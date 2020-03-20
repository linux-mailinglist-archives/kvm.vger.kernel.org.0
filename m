Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353E818D3D7
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCTQLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:11:49 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:35291 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727631AbgCTQLf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IbLZORyF+FBzkvN/rkMPuIvUtFOE3LBT6liq8J+EO80=;
        b=Z/okJYl+r/nxxyaZPAH/PTKEGAK9CDdAdhEw64vgnMNs6ArQsNEGdq0oZIFpqSglE/qpjm
        1vHTiNrILm2kRELT+98lodYLmud/UhSuLXlleFOafZqmLQ4B5/TpoPGDtvrAOlsCjzKk3C
        id25Tpb+5E1F+7yxYxDmQq6yEliLMwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-Y8tekUm9MrK0M_UsvaplWw-1; Fri, 20 Mar 2020 12:11:31 -0400
X-MC-Unique: Y8tekUm9MrK0M_UsvaplWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4381C100550D;
        Fri, 20 Mar 2020 16:11:25 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 530F85C1D8;
        Fri, 20 Mar 2020 16:11:20 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 13/13] iommu/smmuv3: Report non recoverable faults
Date:   Fri, 20 Mar 2020 17:09:32 +0100
Message-Id: <20200320160932.27222-14-eric.auger@redhat.com>
In-Reply-To: <20200320160932.27222-1-eric.auger@redhat.com>
References: <20200320160932.27222-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a stage 1 related fault event is read from the event queue,
let's propagate it to potential external fault listeners, ie. users
who registered a fault handler.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v8 -> v9:
- adapt to the removal of IOMMU_FAULT_UNRECOV_PERM_VALID:
  only look at IOMMU_FAULT_UNRECOV_ADDR_VALID which comes with
  perm
- do not advertise IOMMU_FAULT_UNRECOV_PASID_VALID faults for
  translation faults
- trace errors if !master
- test nested before calling iommu_report_device_fault
- call the fault handler unconditionnally in non nested mode

v4 -> v5:
- s/IOMMU_FAULT_PERM_INST/IOMMU_FAULT_PERM_EXEC
---
 drivers/iommu/arm-smmu-v3.c | 182 +++++++++++++++++++++++++++++++++---
 1 file changed, 171 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index c98ee8edf5cf..c906a07396e7 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -171,6 +171,26 @@
 #define ARM_SMMU_PRIQ_IRQ_CFG1		0xd8
 #define ARM_SMMU_PRIQ_IRQ_CFG2		0xdc
=20
+/* Events */
+#define ARM_SMMU_EVT_F_UUT		0x01
+#define ARM_SMMU_EVT_C_BAD_STREAMID	0x02
+#define ARM_SMMU_EVT_F_STE_FETCH	0x03
+#define ARM_SMMU_EVT_C_BAD_STE		0x04
+#define ARM_SMMU_EVT_F_BAD_ATS_TREQ	0x05
+#define ARM_SMMU_EVT_F_STREAM_DISABLED	0x06
+#define ARM_SMMU_EVT_F_TRANSL_FORBIDDEN	0x07
+#define ARM_SMMU_EVT_C_BAD_SUBSTREAMID	0x08
+#define ARM_SMMU_EVT_F_CD_FETCH		0x09
+#define ARM_SMMU_EVT_C_BAD_CD		0x0a
+#define ARM_SMMU_EVT_F_WALK_EABT	0x0b
+#define ARM_SMMU_EVT_F_TRANSLATION	0x10
+#define ARM_SMMU_EVT_F_ADDR_SIZE	0x11
+#define ARM_SMMU_EVT_F_ACCESS		0x12
+#define ARM_SMMU_EVT_F_PERMISSION	0x13
+#define ARM_SMMU_EVT_F_TLB_CONFLICT	0x20
+#define ARM_SMMU_EVT_F_CFG_CONFLICT	0x21
+#define ARM_SMMU_EVT_E_PAGE_REQUEST	0x24
+
 /* Common MSI config fields */
 #define MSI_CFG0_ADDR_MASK		GENMASK_ULL(51, 2)
 #define MSI_CFG2_SH			GENMASK(5, 4)
@@ -387,6 +407,15 @@
 #define EVTQ_MAX_SZ_SHIFT		(Q_MAX_SZ_SHIFT - EVTQ_ENT_SZ_SHIFT)
=20
 #define EVTQ_0_ID			GENMASK_ULL(7, 0)
+#define EVTQ_0_SSV			GENMASK_ULL(11, 11)
+#define EVTQ_0_SUBSTREAMID		GENMASK_ULL(31, 12)
+#define EVTQ_0_STREAMID			GENMASK_ULL(63, 32)
+#define EVTQ_1_PNU			GENMASK_ULL(33, 33)
+#define EVTQ_1_IND			GENMASK_ULL(34, 34)
+#define EVTQ_1_RNW			GENMASK_ULL(35, 35)
+#define EVTQ_1_S2			GENMASK_ULL(39, 39)
+#define EVTQ_1_CLASS			GENMASK_ULL(40, 41)
+#define EVTQ_3_FETCH_ADDR		GENMASK_ULL(51, 3)
=20
 /* PRI queue */
 #define PRIQ_ENT_SZ_SHIFT		4
@@ -730,6 +759,57 @@ struct arm_smmu_domain {
 	spinlock_t			devices_lock;
 };
=20
+/* fault propagation */
+struct arm_smmu_fault_propagation_data {
+	enum iommu_fault_reason reason;
+	bool s1_check;
+	u32 fields; /* IOMMU_FAULT_UNRECOV_*_VALID bits */
+};
+
+/*
+ * Describes how SMMU faults translate into generic IOMMU faults
+ * and if they need to be reported externally
+ */
+static const struct arm_smmu_fault_propagation_data fault_propagation[] =
=3D {
+[ARM_SMMU_EVT_F_UUT]			=3D { },
+[ARM_SMMU_EVT_C_BAD_STREAMID]		=3D { },
+[ARM_SMMU_EVT_F_STE_FETCH]		=3D { },
+[ARM_SMMU_EVT_C_BAD_STE]		=3D { },
+[ARM_SMMU_EVT_F_BAD_ATS_TREQ]		=3D { },
+[ARM_SMMU_EVT_F_STREAM_DISABLED]	=3D { },
+[ARM_SMMU_EVT_F_TRANSL_FORBIDDEN]	=3D { },
+[ARM_SMMU_EVT_C_BAD_SUBSTREAMID]	=3D {IOMMU_FAULT_REASON_PASID_INVALID,
+					   false,
+					   IOMMU_FAULT_UNRECOV_PASID_VALID
+					  },
+[ARM_SMMU_EVT_F_CD_FETCH]		=3D {IOMMU_FAULT_REASON_PASID_FETCH,
+					   false,
+					   IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID
+					  },
+[ARM_SMMU_EVT_C_BAD_CD]			=3D {IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
+					   false,
+					  },
+[ARM_SMMU_EVT_F_WALK_EABT]		=3D {IOMMU_FAULT_REASON_WALK_EABT, true,
+					   IOMMU_FAULT_UNRECOV_ADDR_VALID |
+					   IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID
+					  },
+[ARM_SMMU_EVT_F_TRANSLATION]		=3D {IOMMU_FAULT_REASON_PTE_FETCH, true,
+					   IOMMU_FAULT_UNRECOV_ADDR_VALID
+					  },
+[ARM_SMMU_EVT_F_ADDR_SIZE]		=3D {IOMMU_FAULT_REASON_OOR_ADDRESS, true,
+					   IOMMU_FAULT_UNRECOV_ADDR_VALID
+					  },
+[ARM_SMMU_EVT_F_ACCESS]			=3D {IOMMU_FAULT_REASON_ACCESS, true,
+					   IOMMU_FAULT_UNRECOV_ADDR_VALID
+					  },
+[ARM_SMMU_EVT_F_PERMISSION]		=3D {IOMMU_FAULT_REASON_PERMISSION, true,
+					   IOMMU_FAULT_UNRECOV_ADDR_VALID
+					  },
+[ARM_SMMU_EVT_F_TLB_CONFLICT]		=3D { },
+[ARM_SMMU_EVT_F_CFG_CONFLICT]		=3D { },
+[ARM_SMMU_EVT_E_PAGE_REQUEST]		=3D { },
+};
+
 struct arm_smmu_option_prop {
 	u32 opt;
 	const char *prop;
@@ -2001,7 +2081,6 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_=
device *smmu, u32 sid)
 	return 0;
 }
=20
-__maybe_unused
 static struct arm_smmu_master *
 arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
 {
@@ -2027,25 +2106,106 @@ arm_smmu_find_master(struct arm_smmu_device *smm=
u, u32 sid)
 	return master;
 }
=20
+/* Populates the record fields according to the input SMMU event */
+static bool arm_smmu_transcode_fault(u64 *evt, u8 type,
+				     struct iommu_fault_unrecoverable *record)
+{
+	const struct arm_smmu_fault_propagation_data *data;
+	u32 fields;
+
+	if (type >=3D ARRAY_SIZE(fault_propagation))
+		return false;
+
+	data =3D &fault_propagation[type];
+	if (!data->reason)
+		return false;
+
+	fields =3D data->fields;
+
+	if (data->s1_check & FIELD_GET(EVTQ_1_S2, evt[1]))
+		return false; /* S2 related fault, don't propagate */
+
+	if (fields & IOMMU_FAULT_UNRECOV_PASID_VALID)
+		record->pasid =3D FIELD_GET(EVTQ_0_SUBSTREAMID, evt[0]);
+	else {
+		/* all other transcoded errors have SSV */
+		if (FIELD_GET(EVTQ_0_SSV, evt[0])) {
+			record->pasid =3D FIELD_GET(EVTQ_0_SUBSTREAMID, evt[0]);
+			fields |=3D IOMMU_FAULT_UNRECOV_PASID_VALID;
+		}
+	}
+
+	if (fields & IOMMU_FAULT_UNRECOV_ADDR_VALID) {
+		if (FIELD_GET(EVTQ_1_RNW, evt[1]))
+			record->perm =3D IOMMU_FAULT_PERM_READ;
+		else
+			record->perm =3D IOMMU_FAULT_PERM_WRITE;
+		if (FIELD_GET(EVTQ_1_PNU, evt[1]))
+			record->perm |=3D IOMMU_FAULT_PERM_PRIV;
+		if (FIELD_GET(EVTQ_1_IND, evt[1]))
+			record->perm |=3D IOMMU_FAULT_PERM_EXEC;
+		record->addr =3D evt[2];
+	}
+
+	if (fields & IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID)
+		record->fetch_addr =3D FIELD_GET(EVTQ_3_FETCH_ADDR, evt[3]);
+
+	record->flags =3D fields;
+	record->reason =3D data->reason;
+	return true;
+}
+
+static void arm_smmu_report_event(struct arm_smmu_device *smmu, u64 *evt=
)
+{
+	u32 sid =3D FIELD_GET(EVTQ_0_STREAMID, evt[0]);
+	u8 type =3D FIELD_GET(EVTQ_0_ID, evt[0]);
+	struct arm_smmu_master *master;
+	struct iommu_fault_event event =3D {};
+	bool nested;
+	int i;
+
+	master =3D arm_smmu_find_master(smmu, sid);
+	if (!master || !master->domain)
+		goto out;
+
+	event.fault.type =3D IOMMU_FAULT_DMA_UNRECOV;
+
+	nested =3D (master->domain->stage =3D=3D ARM_SMMU_DOMAIN_NESTED);
+
+	if (nested) {
+		if (arm_smmu_transcode_fault(evt, type, &event.fault.event)) {
+			/*
+			 * Only S1 related faults should be reported to the
+			 * guest and must not flood the host log.
+			 * Also a fault handler should have been registered
+			 * to guarantee the full nested functionality
+			 */
+			WARN_ON_ONCE(iommu_report_device_fault(master->dev,
+							       &event));
+			return;
+		}
+	} else {
+		iommu_report_device_fault(master->dev, &event);
+	}
+out:
+	dev_info(smmu->dev, "event 0x%02x received:\n", type);
+	for (i =3D 0; i < EVTQ_ENT_DWORDS; ++i) {
+		dev_info(smmu->dev, "\t0x%016llx\n",
+			 (unsigned long long)evt[i]);
+	}
+}
+
 /* IRQ and event handlers */
 static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 {
-	int i;
 	struct arm_smmu_device *smmu =3D dev;
 	struct arm_smmu_queue *q =3D &smmu->evtq.q;
 	struct arm_smmu_ll_queue *llq =3D &q->llq;
 	u64 evt[EVTQ_ENT_DWORDS];
=20
 	do {
-		while (!queue_remove_raw(q, evt)) {
-			u8 id =3D FIELD_GET(EVTQ_0_ID, evt[0]);
-
-			dev_info(smmu->dev, "event 0x%02x received:\n", id);
-			for (i =3D 0; i < ARRAY_SIZE(evt); ++i)
-				dev_info(smmu->dev, "\t0x%016llx\n",
-					 (unsigned long long)evt[i]);
-
-		}
+		while (!queue_remove_raw(q, evt))
+			arm_smmu_report_event(smmu, evt);
=20
 		/*
 		 * Not much we can do on overflow, so scream and pretend we're
--=20
2.20.1

