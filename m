Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5B1A815F
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436558AbgDNPHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:07:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47478 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436528AbgDNPHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 11:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586876823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wi4Jh9LpqkWQ8FgIrc+LUaKxo2ewQeuAx/AgKj7vtRQ=;
        b=V0ANxuzS36YARlN3/ViGwNFBjgVkU9M/T40RJ5hZcWfxVzEDuIRe1snm/sPpVgWMajfH1i
        YP3RhPuPVwxoN7Gg9VjjdNjIo7BAStE2Z/sRKiKONcBfrG1Y6NCUMkv9dvZN91Q9fW/DgR
        jhHqh4qTdnCegRIY7sH+o3M4I0nyHFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-preTWx42MDegmYGFUlvpOw-1; Tue, 14 Apr 2020 11:06:58 -0400
X-MC-Unique: preTWx42MDegmYGFUlvpOw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17C10800D5C;
        Tue, 14 Apr 2020 15:06:56 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 837F519C69;
        Tue, 14 Apr 2020 15:06:44 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        shameerali.kolothum.thodi@huawei.com, alex.williamson@redhat.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        peter.maydell@linaro.org, zhangfei.gao@gmail.com, tn@semihalf.com,
        zhangfei.gao@foxmail.com, bbhushan2@marvell.com
Subject: [PATCH v11 03/13] iommu/arm-smmu-v3: Maintain a SID->device structure
Date:   Tue, 14 Apr 2020 17:05:57 +0200
Message-Id: <20200414150607.28488-4-eric.auger@redhat.com>
In-Reply-To: <20200414150607.28488-1-eric.auger@redhat.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

When handling faults from the event or PRI queue, we need to find the
struct device associated to a SID. Add a rb_tree to keep track of SIDs.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 drivers/iommu/arm-smmu-v3.c | 112 +++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 82508730feb7..ac7009348749 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -677,6 +677,16 @@ struct arm_smmu_device {
=20
 	/* IOMMU core code handle */
 	struct iommu_device		iommu;
+
+	struct rb_root			streams;
+	struct mutex			streams_mutex;
+
+};
+
+struct arm_smmu_stream {
+	u32				id;
+	struct arm_smmu_master		*master;
+	struct rb_node			node;
 };
=20
 /* SMMU private data for each master */
@@ -687,6 +697,7 @@ struct arm_smmu_master {
 	struct list_head		domain_head;
 	u32				*sids;
 	unsigned int			num_sids;
+	struct arm_smmu_stream		*streams;
 	bool				ats_enabled;
 	unsigned int			ssid_bits;
 };
@@ -1967,6 +1978,32 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu=
_device *smmu, u32 sid)
 	return 0;
 }
=20
+__maybe_unused
+static struct arm_smmu_master *
+arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
+{
+	struct rb_node *node;
+	struct arm_smmu_stream *stream;
+	struct arm_smmu_master *master =3D NULL;
+
+	mutex_lock(&smmu->streams_mutex);
+	node =3D smmu->streams.rb_node;
+	while (node) {
+		stream =3D rb_entry(node, struct arm_smmu_stream, node);
+		if (stream->id < sid) {
+			node =3D node->rb_right;
+		} else if (stream->id > sid) {
+			node =3D node->rb_left;
+		} else {
+			master =3D stream->master;
+			break;
+		}
+	}
+	mutex_unlock(&smmu->streams_mutex);
+
+	return master;
+}
+
 /* IRQ and event handlers */
 static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 {
@@ -2912,6 +2949,69 @@ static bool arm_smmu_sid_in_range(struct arm_smmu_=
device *smmu, u32 sid)
 	return sid < limit;
 }
=20
+static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
+				  struct arm_smmu_master *master)
+{
+	int i;
+	int ret =3D 0;
+	struct arm_smmu_stream *new_stream, *cur_stream;
+	struct rb_node **new_node, *parent_node =3D NULL;
+
+	master->streams =3D kcalloc(master->num_sids,
+				  sizeof(struct arm_smmu_stream), GFP_KERNEL);
+	if (!master->streams)
+		return -ENOMEM;
+
+	mutex_lock(&smmu->streams_mutex);
+	for (i =3D 0; i < master->num_sids && !ret; i++) {
+		new_stream =3D &master->streams[i];
+		new_stream->id =3D master->sids[i];
+		new_stream->master =3D master;
+
+		new_node =3D &(smmu->streams.rb_node);
+		while (*new_node) {
+			cur_stream =3D rb_entry(*new_node, struct arm_smmu_stream,
+					      node);
+			parent_node =3D *new_node;
+			if (cur_stream->id > new_stream->id) {
+				new_node =3D &((*new_node)->rb_left);
+			} else if (cur_stream->id < new_stream->id) {
+				new_node =3D &((*new_node)->rb_right);
+			} else {
+				dev_warn(master->dev,
+					 "stream %u already in tree\n",
+					 cur_stream->id);
+				ret =3D -EINVAL;
+				break;
+			}
+		}
+
+		if (!ret) {
+			rb_link_node(&new_stream->node, parent_node, new_node);
+			rb_insert_color(&new_stream->node, &smmu->streams);
+		}
+	}
+	mutex_unlock(&smmu->streams_mutex);
+
+	return ret;
+}
+
+static void arm_smmu_remove_master(struct arm_smmu_device *smmu,
+				   struct arm_smmu_master *master)
+{
+	int i;
+
+	if (!master->streams)
+		return;
+
+	mutex_lock(&smmu->streams_mutex);
+	for (i =3D 0; i < master->num_sids; i++)
+		rb_erase(&master->streams[i].node, &smmu->streams);
+	mutex_unlock(&smmu->streams_mutex);
+
+	kfree(master->streams);
+}
+
 static struct iommu_ops arm_smmu_ops;
=20
 static int arm_smmu_add_device(struct device *dev)
@@ -2979,15 +3079,21 @@ static int arm_smmu_add_device(struct device *dev=
)
 	if (ret)
 		goto err_disable_pasid;
=20
+	ret =3D arm_smmu_insert_master(smmu, master);
+	if (ret)
+		goto err_unlink;
+
 	group =3D iommu_group_get_for_dev(dev);
 	if (IS_ERR(group)) {
 		ret =3D PTR_ERR(group);
-		goto err_unlink;
+		goto err_remove_master;
 	}
=20
 	iommu_group_put(group);
 	return 0;
=20
+err_remove_master:
+	arm_smmu_remove_master(smmu, master);
 err_unlink:
 	iommu_device_unlink(&smmu->iommu, dev);
 err_disable_pasid:
@@ -3011,6 +3117,7 @@ static void arm_smmu_remove_device(struct device *d=
ev)
 	smmu =3D master->smmu;
 	arm_smmu_detach_dev(master);
 	iommu_group_remove_device(dev);
+	arm_smmu_remove_master(smmu, master);
 	iommu_device_unlink(&smmu->iommu, dev);
 	arm_smmu_disable_pasid(master);
 	kfree(master);
@@ -3365,6 +3472,9 @@ static int arm_smmu_init_structures(struct arm_smmu=
_device *smmu)
 {
 	int ret;
=20
+	mutex_init(&smmu->streams_mutex);
+	smmu->streams =3D RB_ROOT;
+
 	ret =3D arm_smmu_init_queues(smmu);
 	if (ret)
 		return ret;
--=20
2.20.1

