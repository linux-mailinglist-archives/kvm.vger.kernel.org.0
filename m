Return-Path: <kvm+bounces-7619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17060844D0E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:39:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92DF51F2D567
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A513247794;
	Wed, 31 Jan 2024 23:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MZcYIbS3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D6F3BB22
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706743863; cv=none; b=KJnucWyVPIHaC81AWrVp+zP3+iWIWdqv6A8+hdh5qXCZ69wTbTmbIZ9DSuLrBRAzUsNy7rDQK/fmVF0reomwAXdm6SVOjqRJlIHKg8tHBqho1J14VqAJJU6sw0QUUUd0nsxzpZioH3MjzlHPkXDVj/ohpJyp+4kyhiCLbA+6b2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706743863; c=relaxed/simple;
	bh=aYB59q/x6pNj6pzQSRe2KTcn0zHxaBTwdyL0cw+q6zI=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7LDsc45DSCs5CYyLtjH39j63FqHmOP/Z62p3JP8VZJnh4i5bVChbAvpIJ/DrFQ7RhDyaB3fwBij7HcukWPcBz0UdBUDTwxSSJ6+Z6N5ytlV88OsTnb44I7cjDCxxrATZkyZ3SRCd81/I+tnRYvt4RxGqZtvPSdGwmXwtG4LUSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MZcYIbS3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706743859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NeHzUX4C5rx3TtWlhkPppGUwI3SWNpEfMbauN9WWAxA=;
	b=MZcYIbS3dq+IkSRSG/LUQwVhJiTrf6Xh22F+Uu6PX5tU/uF1RrqeYnbuHEb2/TNy3PR+hR
	z9cTNKiCx8zKBnQV9ghLgfIsQL58Bmdp3Gy+39QBD+EExcHhPHlI10y9qPFoDX56QSuYkG
	ZSrg1/p6OT3ps6M/00GBJLgdHkel3uQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-G9_AjWOgMheUylc9uEAr4w-1; Wed, 31 Jan 2024 18:30:57 -0500
X-MC-Unique: G9_AjWOgMheUylc9uEAr4w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED788432A0;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26D59C2590D;
	Wed, 31 Jan 2024 23:30:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 4/8] KVM: s390: move s390-specific structs to uapi/asm/kvm.h
Date: Wed, 31 Jan 2024 18:30:52 -0500
Message-Id: <20240131233056.10845-5-pbonzini@redhat.com>
In-Reply-To: <20240131233056.10845-1-pbonzini@redhat.com>
References: <20240131233056.10845-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

While this in principle breaks the appearance of KVM_S390_* ioctls on architectures
other than s390, this seems unlikely to be a problem considering that there are
already many "struct kvm_s390_*" definitions in arch/s390/include/uapi.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/s390/include/uapi/asm/kvm.h | 314 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h         | 312 ------------------------------
 2 files changed, 314 insertions(+), 312 deletions(-)

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index abe926d43cbe..fee712ff1cf8 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -14,6 +14,320 @@
 #define __KVM_S390
 #define __KVM_HAVE_GUEST_DEBUG
 
+struct kvm_s390_skeys {
+	__u64 start_gfn;
+	__u64 count;
+	__u64 skeydata_addr;
+	__u32 flags;
+	__u32 reserved[9];
+};
+
+#define KVM_S390_CMMA_PEEK (1 << 0)
+
+/**
+ * kvm_s390_cmma_log - Used for CMMA migration.
+ *
+ * Used both for input and output.
+ *
+ * @start_gfn: Guest page number to start from.
+ * @count: Size of the result buffer.
+ * @flags: Control operation mode via KVM_S390_CMMA_* flags
+ * @remaining: Used with KVM_S390_GET_CMMA_BITS. Indicates how many dirty
+ *             pages are still remaining.
+ * @mask: Used with KVM_S390_SET_CMMA_BITS. Bitmap of bits to actually set
+ *        in the PGSTE.
+ * @values: Pointer to the values buffer.
+ *
+ * Used in KVM_S390_{G,S}ET_CMMA_BITS ioctls.
+ */
+struct kvm_s390_cmma_log {
+	__u64 start_gfn;
+	__u32 count;
+	__u32 flags;
+	union {
+		__u64 remaining;
+		__u64 mask;
+	};
+	__u64 values;
+};
+
+#define KVM_S390_RESET_POR       1
+#define KVM_S390_RESET_CLEAR     2
+#define KVM_S390_RESET_SUBSYSTEM 4
+#define KVM_S390_RESET_CPU_INIT  8
+#define KVM_S390_RESET_IPL       16
+
+/* for KVM_S390_MEM_OP */
+struct kvm_s390_mem_op {
+	/* in */
+	__u64 gaddr;		/* the guest address */
+	__u64 flags;		/* flags */
+	__u32 size;		/* amount of bytes */
+	__u32 op;		/* type of operation */
+	__u64 buf;		/* buffer in userspace */
+	union {
+		struct {
+			__u8 ar;	/* the access register number */
+			__u8 key;	/* access key, ignored if flag unset */
+			__u8 pad1[6];	/* ignored */
+			__u64 old_addr;	/* ignored if cmpxchg flag unset */
+		};
+		__u32 sida_offset; /* offset into the sida */
+		__u8 reserved[32]; /* ignored */
+	};
+};
+/* types for kvm_s390_mem_op->op */
+#define KVM_S390_MEMOP_LOGICAL_READ	0
+#define KVM_S390_MEMOP_LOGICAL_WRITE	1
+#define KVM_S390_MEMOP_SIDA_READ	2
+#define KVM_S390_MEMOP_SIDA_WRITE	3
+#define KVM_S390_MEMOP_ABSOLUTE_READ	4
+#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
+#define KVM_S390_MEMOP_ABSOLUTE_CMPXCHG	6
+
+/* flags for kvm_s390_mem_op->flags */
+#define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
+#define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
+#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
+
+/* flags specifying extension support via KVM_CAP_S390_MEM_OP_EXTENSION */
+#define KVM_S390_MEMOP_EXTENSION_CAP_BASE	(1 << 0)
+#define KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG	(1 << 1)
+
+struct kvm_s390_psw {
+	__u64 mask;
+	__u64 addr;
+};
+
+/* valid values for type in kvm_s390_interrupt */
+#define KVM_S390_SIGP_STOP		0xfffe0000u
+#define KVM_S390_PROGRAM_INT		0xfffe0001u
+#define KVM_S390_SIGP_SET_PREFIX	0xfffe0002u
+#define KVM_S390_RESTART		0xfffe0003u
+#define KVM_S390_INT_PFAULT_INIT	0xfffe0004u
+#define KVM_S390_INT_PFAULT_DONE	0xfffe0005u
+#define KVM_S390_MCHK			0xfffe1000u
+#define KVM_S390_INT_CLOCK_COMP		0xffff1004u
+#define KVM_S390_INT_CPU_TIMER		0xffff1005u
+#define KVM_S390_INT_VIRTIO		0xffff2603u
+#define KVM_S390_INT_SERVICE		0xffff2401u
+#define KVM_S390_INT_EMERGENCY		0xffff1201u
+#define KVM_S390_INT_EXTERNAL_CALL	0xffff1202u
+/* Anything below 0xfffe0000u is taken by INT_IO */
+#define KVM_S390_INT_IO(ai,cssid,ssid,schid)   \
+	(((schid)) |			       \
+	 ((ssid) << 16) |		       \
+	 ((cssid) << 18) |		       \
+	 ((ai) << 26))
+#define KVM_S390_INT_IO_MIN		0x00000000u
+#define KVM_S390_INT_IO_MAX		0xfffdffffu
+#define KVM_S390_INT_IO_AI_MASK		0x04000000u
+
+
+struct kvm_s390_interrupt {
+	__u32 type;
+	__u32 parm;
+	__u64 parm64;
+};
+
+struct kvm_s390_io_info {
+	__u16 subchannel_id;
+	__u16 subchannel_nr;
+	__u32 io_int_parm;
+	__u32 io_int_word;
+};
+
+struct kvm_s390_ext_info {
+	__u32 ext_params;
+	__u32 pad;
+	__u64 ext_params2;
+};
+
+struct kvm_s390_pgm_info {
+	__u64 trans_exc_code;
+	__u64 mon_code;
+	__u64 per_address;
+	__u32 data_exc_code;
+	__u16 code;
+	__u16 mon_class_nr;
+	__u8 per_code;
+	__u8 per_atmid;
+	__u8 exc_access_id;
+	__u8 per_access_id;
+	__u8 op_access_id;
+#define KVM_S390_PGM_FLAGS_ILC_VALID	0x01
+#define KVM_S390_PGM_FLAGS_ILC_0	0x02
+#define KVM_S390_PGM_FLAGS_ILC_1	0x04
+#define KVM_S390_PGM_FLAGS_ILC_MASK	0x06
+#define KVM_S390_PGM_FLAGS_NO_REWIND	0x08
+	__u8 flags;
+	__u8 pad[2];
+};
+
+struct kvm_s390_prefix_info {
+	__u32 address;
+};
+
+struct kvm_s390_extcall_info {
+	__u16 code;
+};
+
+struct kvm_s390_emerg_info {
+	__u16 code;
+};
+
+#define KVM_S390_STOP_FLAG_STORE_STATUS	0x01
+struct kvm_s390_stop_info {
+	__u32 flags;
+};
+
+struct kvm_s390_mchk_info {
+	__u64 cr14;
+	__u64 mcic;
+	__u64 failing_storage_address;
+	__u32 ext_damage_code;
+	__u32 pad;
+	__u8 fixed_logout[16];
+};
+
+struct kvm_s390_irq {
+	__u64 type;
+	union {
+		struct kvm_s390_io_info io;
+		struct kvm_s390_ext_info ext;
+		struct kvm_s390_pgm_info pgm;
+		struct kvm_s390_emerg_info emerg;
+		struct kvm_s390_extcall_info extcall;
+		struct kvm_s390_prefix_info prefix;
+		struct kvm_s390_stop_info stop;
+		struct kvm_s390_mchk_info mchk;
+		char reserved[64];
+	} u;
+};
+
+struct kvm_s390_irq_state {
+	__u64 buf;
+	__u32 flags;        /* will stay unused for compatibility reasons */
+	__u32 len;
+	__u32 reserved[4];  /* will stay unused for compatibility reasons */
+};
+
+struct kvm_s390_ucas_mapping {
+	__u64 user_addr;
+	__u64 vcpu_addr;
+	__u64 length;
+};
+
+struct kvm_s390_pv_sec_parm {
+	__u64 origin;
+	__u64 length;
+};
+
+struct kvm_s390_pv_unp {
+	__u64 addr;
+	__u64 size;
+	__u64 tweak;
+};
+
+enum pv_cmd_dmp_id {
+	KVM_PV_DUMP_INIT,
+	KVM_PV_DUMP_CONFIG_STOR_STATE,
+	KVM_PV_DUMP_COMPLETE,
+	KVM_PV_DUMP_CPU,
+};
+
+struct kvm_s390_pv_dmp {
+	__u64 subcmd;
+	__u64 buff_addr;
+	__u64 buff_len;
+	__u64 gaddr;		/* For dump storage state */
+	__u64 reserved[4];
+};
+
+enum pv_cmd_info_id {
+	KVM_PV_INFO_VM,
+	KVM_PV_INFO_DUMP,
+};
+
+struct kvm_s390_pv_info_dump {
+	__u64 dump_cpu_buffer_len;
+	__u64 dump_config_mem_buffer_per_1m;
+	__u64 dump_config_finalize_len;
+};
+
+struct kvm_s390_pv_info_vm {
+	__u64 inst_calls_list[4];
+	__u64 max_cpus;
+	__u64 max_guests;
+	__u64 max_guest_addr;
+	__u64 feature_indication;
+};
+
+struct kvm_s390_pv_info_header {
+	__u32 id;
+	__u32 len_max;
+	__u32 len_written;
+	__u32 reserved;
+};
+
+struct kvm_s390_pv_info {
+	struct kvm_s390_pv_info_header header;
+	union {
+		struct kvm_s390_pv_info_dump dump;
+		struct kvm_s390_pv_info_vm vm;
+	};
+};
+
+enum pv_cmd_id {
+	KVM_PV_ENABLE,
+	KVM_PV_DISABLE,
+	KVM_PV_SET_SEC_PARMS,
+	KVM_PV_UNPACK,
+	KVM_PV_VERIFY,
+	KVM_PV_PREP_RESET,
+	KVM_PV_UNSHARE_ALL,
+	KVM_PV_INFO,
+	KVM_PV_DUMP,
+	KVM_PV_ASYNC_CLEANUP_PREPARE,
+	KVM_PV_ASYNC_CLEANUP_PERFORM,
+};
+
+struct kvm_pv_cmd {
+	__u32 cmd;	/* Command to be executed */
+	__u16 rc;	/* Ultravisor return code */
+	__u16 rrc;	/* Ultravisor return reason code */
+	__u64 data;	/* Data or address */
+	__u32 flags;    /* flags for future extensions. Must be 0 for now */
+	__u32 reserved[3];
+};
+
+struct kvm_s390_zpci_op {
+	/* in */
+	__u32 fh;               /* target device */
+	__u8  op;               /* operation to perform */
+	__u8  pad[3];
+	union {
+		/* for KVM_S390_ZPCIOP_REG_AEN */
+		struct {
+			__u64 ibv;      /* Guest addr of interrupt bit vector */
+			__u64 sb;       /* Guest addr of summary bit */
+			__u32 flags;
+			__u32 noi;      /* Number of interrupts */
+			__u8 isc;       /* Guest interrupt subclass */
+			__u8 sbo;       /* Offset of guest summary bit vector */
+			__u16 pad;
+		} reg_aen;
+		__u64 reserved[8];
+	} u;
+};
+
+/* types for kvm_s390_zpci_op->op */
+#define KVM_S390_ZPCIOP_REG_AEN                0
+#define KVM_S390_ZPCIOP_DEREG_AEN      1
+
+/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
+#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
+
 /* Device control API: s390-specific devices */
 #define KVM_DEV_FLIC_GET_ALL_IRQS	1
 #define KVM_DEV_FLIC_ENQUEUE		2
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a5458aeee018..b7c8054e9d14 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -85,43 +85,6 @@ struct kvm_pit_config {
 
 #define KVM_PIT_SPEAKER_DUMMY     1
 
-struct kvm_s390_skeys {
-	__u64 start_gfn;
-	__u64 count;
-	__u64 skeydata_addr;
-	__u32 flags;
-	__u32 reserved[9];
-};
-
-#define KVM_S390_CMMA_PEEK (1 << 0)
-
-/**
- * kvm_s390_cmma_log - Used for CMMA migration.
- *
- * Used both for input and output.
- *
- * @start_gfn: Guest page number to start from.
- * @count: Size of the result buffer.
- * @flags: Control operation mode via KVM_S390_CMMA_* flags
- * @remaining: Used with KVM_S390_GET_CMMA_BITS. Indicates how many dirty
- *             pages are still remaining.
- * @mask: Used with KVM_S390_SET_CMMA_BITS. Bitmap of bits to actually set
- *        in the PGSTE.
- * @values: Pointer to the values buffer.
- *
- * Used in KVM_S390_{G,S}ET_CMMA_BITS ioctls.
- */
-struct kvm_s390_cmma_log {
-	__u64 start_gfn;
-	__u32 count;
-	__u32 flags;
-	union {
-		__u64 remaining;
-		__u64 mask;
-	};
-	__u64 values;
-};
-
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
@@ -315,11 +278,6 @@ struct kvm_run {
 			__u32 ipb;
 		} s390_sieic;
 		/* KVM_EXIT_S390_RESET */
-#define KVM_S390_RESET_POR       1
-#define KVM_S390_RESET_CLEAR     2
-#define KVM_S390_RESET_SUBSYSTEM 4
-#define KVM_S390_RESET_CPU_INIT  8
-#define KVM_S390_RESET_IPL       16
 		__u64 s390_reset_flags;
 		/* KVM_EXIT_S390_UCONTROL */
 		struct {
@@ -536,43 +494,6 @@ struct kvm_translation {
 	__u8  pad[5];
 };
 
-/* for KVM_S390_MEM_OP */
-struct kvm_s390_mem_op {
-	/* in */
-	__u64 gaddr;		/* the guest address */
-	__u64 flags;		/* flags */
-	__u32 size;		/* amount of bytes */
-	__u32 op;		/* type of operation */
-	__u64 buf;		/* buffer in userspace */
-	union {
-		struct {
-			__u8 ar;	/* the access register number */
-			__u8 key;	/* access key, ignored if flag unset */
-			__u8 pad1[6];	/* ignored */
-			__u64 old_addr;	/* ignored if cmpxchg flag unset */
-		};
-		__u32 sida_offset; /* offset into the sida */
-		__u8 reserved[32]; /* ignored */
-	};
-};
-/* types for kvm_s390_mem_op->op */
-#define KVM_S390_MEMOP_LOGICAL_READ	0
-#define KVM_S390_MEMOP_LOGICAL_WRITE	1
-#define KVM_S390_MEMOP_SIDA_READ	2
-#define KVM_S390_MEMOP_SIDA_WRITE	3
-#define KVM_S390_MEMOP_ABSOLUTE_READ	4
-#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
-#define KVM_S390_MEMOP_ABSOLUTE_CMPXCHG	6
-
-/* flags for kvm_s390_mem_op->flags */
-#define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
-#define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
-#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
-
-/* flags specifying extension support via KVM_CAP_S390_MEM_OP_EXTENSION */
-#define KVM_S390_MEMOP_EXTENSION_CAP_BASE	(1 << 0)
-#define KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG	(1 << 1)
-
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
 	/* in */
@@ -637,124 +558,6 @@ struct kvm_mp_state {
 	__u32 mp_state;
 };
 
-struct kvm_s390_psw {
-	__u64 mask;
-	__u64 addr;
-};
-
-/* valid values for type in kvm_s390_interrupt */
-#define KVM_S390_SIGP_STOP		0xfffe0000u
-#define KVM_S390_PROGRAM_INT		0xfffe0001u
-#define KVM_S390_SIGP_SET_PREFIX	0xfffe0002u
-#define KVM_S390_RESTART		0xfffe0003u
-#define KVM_S390_INT_PFAULT_INIT	0xfffe0004u
-#define KVM_S390_INT_PFAULT_DONE	0xfffe0005u
-#define KVM_S390_MCHK			0xfffe1000u
-#define KVM_S390_INT_CLOCK_COMP		0xffff1004u
-#define KVM_S390_INT_CPU_TIMER		0xffff1005u
-#define KVM_S390_INT_VIRTIO		0xffff2603u
-#define KVM_S390_INT_SERVICE		0xffff2401u
-#define KVM_S390_INT_EMERGENCY		0xffff1201u
-#define KVM_S390_INT_EXTERNAL_CALL	0xffff1202u
-/* Anything below 0xfffe0000u is taken by INT_IO */
-#define KVM_S390_INT_IO(ai,cssid,ssid,schid)   \
-	(((schid)) |			       \
-	 ((ssid) << 16) |		       \
-	 ((cssid) << 18) |		       \
-	 ((ai) << 26))
-#define KVM_S390_INT_IO_MIN		0x00000000u
-#define KVM_S390_INT_IO_MAX		0xfffdffffu
-#define KVM_S390_INT_IO_AI_MASK		0x04000000u
-
-
-struct kvm_s390_interrupt {
-	__u32 type;
-	__u32 parm;
-	__u64 parm64;
-};
-
-struct kvm_s390_io_info {
-	__u16 subchannel_id;
-	__u16 subchannel_nr;
-	__u32 io_int_parm;
-	__u32 io_int_word;
-};
-
-struct kvm_s390_ext_info {
-	__u32 ext_params;
-	__u32 pad;
-	__u64 ext_params2;
-};
-
-struct kvm_s390_pgm_info {
-	__u64 trans_exc_code;
-	__u64 mon_code;
-	__u64 per_address;
-	__u32 data_exc_code;
-	__u16 code;
-	__u16 mon_class_nr;
-	__u8 per_code;
-	__u8 per_atmid;
-	__u8 exc_access_id;
-	__u8 per_access_id;
-	__u8 op_access_id;
-#define KVM_S390_PGM_FLAGS_ILC_VALID	0x01
-#define KVM_S390_PGM_FLAGS_ILC_0	0x02
-#define KVM_S390_PGM_FLAGS_ILC_1	0x04
-#define KVM_S390_PGM_FLAGS_ILC_MASK	0x06
-#define KVM_S390_PGM_FLAGS_NO_REWIND	0x08
-	__u8 flags;
-	__u8 pad[2];
-};
-
-struct kvm_s390_prefix_info {
-	__u32 address;
-};
-
-struct kvm_s390_extcall_info {
-	__u16 code;
-};
-
-struct kvm_s390_emerg_info {
-	__u16 code;
-};
-
-#define KVM_S390_STOP_FLAG_STORE_STATUS	0x01
-struct kvm_s390_stop_info {
-	__u32 flags;
-};
-
-struct kvm_s390_mchk_info {
-	__u64 cr14;
-	__u64 mcic;
-	__u64 failing_storage_address;
-	__u32 ext_damage_code;
-	__u32 pad;
-	__u8 fixed_logout[16];
-};
-
-struct kvm_s390_irq {
-	__u64 type;
-	union {
-		struct kvm_s390_io_info io;
-		struct kvm_s390_ext_info ext;
-		struct kvm_s390_pgm_info pgm;
-		struct kvm_s390_emerg_info emerg;
-		struct kvm_s390_extcall_info extcall;
-		struct kvm_s390_prefix_info prefix;
-		struct kvm_s390_stop_info stop;
-		struct kvm_s390_mchk_info mchk;
-		char reserved[64];
-	} u;
-};
-
-struct kvm_s390_irq_state {
-	__u64 buf;
-	__u32 flags;        /* will stay unused for compatibility reasons */
-	__u32 len;
-	__u32 reserved[4];  /* will stay unused for compatibility reasons */
-};
-
 /* for KVM_SET_GUEST_DEBUG */
 
 #define KVM_GUESTDBG_ENABLE		0x00000001
@@ -1364,11 +1167,6 @@ struct kvm_vfio_spapr_tce {
 					 struct kvm_userspace_memory_region2)
 
 /* enable ucontrol for s390 */
-struct kvm_s390_ucas_mapping {
-	__u64 user_addr;
-	__u64 vcpu_addr;
-	__u64 length;
-};
 #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
 #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
 #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
@@ -1563,89 +1361,6 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
-struct kvm_s390_pv_sec_parm {
-	__u64 origin;
-	__u64 length;
-};
-
-struct kvm_s390_pv_unp {
-	__u64 addr;
-	__u64 size;
-	__u64 tweak;
-};
-
-enum pv_cmd_dmp_id {
-	KVM_PV_DUMP_INIT,
-	KVM_PV_DUMP_CONFIG_STOR_STATE,
-	KVM_PV_DUMP_COMPLETE,
-	KVM_PV_DUMP_CPU,
-};
-
-struct kvm_s390_pv_dmp {
-	__u64 subcmd;
-	__u64 buff_addr;
-	__u64 buff_len;
-	__u64 gaddr;		/* For dump storage state */
-	__u64 reserved[4];
-};
-
-enum pv_cmd_info_id {
-	KVM_PV_INFO_VM,
-	KVM_PV_INFO_DUMP,
-};
-
-struct kvm_s390_pv_info_dump {
-	__u64 dump_cpu_buffer_len;
-	__u64 dump_config_mem_buffer_per_1m;
-	__u64 dump_config_finalize_len;
-};
-
-struct kvm_s390_pv_info_vm {
-	__u64 inst_calls_list[4];
-	__u64 max_cpus;
-	__u64 max_guests;
-	__u64 max_guest_addr;
-	__u64 feature_indication;
-};
-
-struct kvm_s390_pv_info_header {
-	__u32 id;
-	__u32 len_max;
-	__u32 len_written;
-	__u32 reserved;
-};
-
-struct kvm_s390_pv_info {
-	struct kvm_s390_pv_info_header header;
-	union {
-		struct kvm_s390_pv_info_dump dump;
-		struct kvm_s390_pv_info_vm vm;
-	};
-};
-
-enum pv_cmd_id {
-	KVM_PV_ENABLE,
-	KVM_PV_DISABLE,
-	KVM_PV_SET_SEC_PARMS,
-	KVM_PV_UNPACK,
-	KVM_PV_VERIFY,
-	KVM_PV_PREP_RESET,
-	KVM_PV_UNSHARE_ALL,
-	KVM_PV_INFO,
-	KVM_PV_DUMP,
-	KVM_PV_ASYNC_CLEANUP_PREPARE,
-	KVM_PV_ASYNC_CLEANUP_PERFORM,
-};
-
-struct kvm_pv_cmd {
-	__u32 cmd;	/* Command to be executed */
-	__u16 rc;	/* Ultravisor return code */
-	__u16 rrc;	/* Ultravisor return reason code */
-	__u64 data;	/* Data or address */
-	__u32 flags;    /* flags for future extensions. Must be 0 for now */
-	__u32 reserved[3];
-};
-
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
@@ -1821,33 +1536,6 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_S390_ZPCI_OP */
 #define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd1, struct kvm_s390_zpci_op)
 
-struct kvm_s390_zpci_op {
-	/* in */
-	__u32 fh;               /* target device */
-	__u8  op;               /* operation to perform */
-	__u8  pad[3];
-	union {
-		/* for KVM_S390_ZPCIOP_REG_AEN */
-		struct {
-			__u64 ibv;      /* Guest addr of interrupt bit vector */
-			__u64 sb;       /* Guest addr of summary bit */
-			__u32 flags;
-			__u32 noi;      /* Number of interrupts */
-			__u8 isc;       /* Guest interrupt subclass */
-			__u8 sbo;       /* Offset of guest summary bit vector */
-			__u16 pad;
-		} reg_aen;
-		__u64 reserved[8];
-	} u;
-};
-
-/* types for kvm_s390_zpci_op->op */
-#define KVM_S390_ZPCIOP_REG_AEN                0
-#define KVM_S390_ZPCIOP_DEREG_AEN      1
-
-/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
-#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
-
 /* Available with KVM_CAP_MEMORY_ATTRIBUTES */
 #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
 
-- 
2.39.0



