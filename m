Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E459162407
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 10:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgBRJ4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 04:56:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29270 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726360AbgBRJ4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 04:56:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582019807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=j5SqOpoqU7PlhGnltoiJZDVg+ZjUcSgX3R7TC0XOqwQ=;
        b=EH5cxhlbIco1Q6NN4VupB1H5B47rQu9DWshHUpJF/8wXPz6fWMebEveGuu8jbF6lbkYuyV
        gmnWCrfkm/E3fhEaI+Soqxmd5lDW4alYND76NGXul3hSoI4nDKdAEEMkXkSgROXKKNb/1t
        TjLmOT7ZcgAxhCFKSqxg4wIenpDNZk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-PyiRDi0JPbyVdE1oq_5DTQ-1; Tue, 18 Feb 2020 04:56:42 -0500
X-MC-Unique: PyiRDi0JPbyVdE1oq_5DTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BD458017CC;
        Tue, 18 Feb 2020 09:56:41 +0000 (UTC)
Received: from [10.36.116.190] (ovpn-116-190.ams2.redhat.com [10.36.116.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5C0319481;
        Tue, 18 Feb 2020 09:56:38 +0000 (UTC)
Subject: Re: [PATCH v2.1] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ulrich.Weigand@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, frankja@linux.vnet.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
References: <20200214222658.12946-10-borntraeger@de.ibm.com>
 <20200218083946.44720-1-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <2585441c-5d80-3264-d248-08f04261cb2e@redhat.com>
Date:   Tue, 18 Feb 2020 10:56:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218083946.44720-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.02.20 09:39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> This contains 3 main changes:
> 1. changes in SIE control block handling for secure guests
> 2. helper functions for create/destroy/unpack secure guests
> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
> machines
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
> 2->2.1  - combine CREATE/DESTROY CPU/VM into ENABLE DISABLE
> 	- rework locking and check locks with lockdep
> 	- I still have the PV_COMMAND_CPU in here for later use in
> 	  the SET_IPL_PSW ioctl. If wanted I can move
> 	- change CAP number
> 
>  arch/s390/include/asm/kvm_host.h |  24 ++-
>  arch/s390/include/asm/uv.h       |  69 ++++++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/kvm-s390.c         | 231 ++++++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  35 +++++
>  arch/s390/kvm/pv.c               | 262 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  35 +++++
>  7 files changed, 654 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/kvm/pv.c
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index d058289385a5..1aa2382fe363 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -160,7 +160,13 @@ struct kvm_s390_sie_block {
>  	__u8	reserved08[4];		/* 0x0008 */
>  #define PROG_IN_SIE (1<<0)
>  	__u32	prog0c;			/* 0x000c */
> -	__u8	reserved10[16];		/* 0x0010 */
> +	union {
> +		__u8	reserved10[16];		/* 0x0010 */
> +		struct {
> +			__u64	pv_handle_cpu;
> +			__u64	pv_handle_config;
> +		};
> +	};
>  #define PROG_BLOCK_SIE	(1<<0)
>  #define PROG_REQUEST	(1<<1)
>  	atomic_t prog20;		/* 0x0020 */
> @@ -233,7 +239,7 @@ struct kvm_s390_sie_block {
>  #define ECB3_RI  0x01
>  	__u8    ecb3;			/* 0x0063 */
>  	__u32	scaol;			/* 0x0064 */
> -	__u8	reserved68;		/* 0x0068 */
> +	__u8	sdf;			/* 0x0068 */
>  	__u8    epdx;			/* 0x0069 */
>  	__u8    reserved6a[2];		/* 0x006a */
>  	__u32	todpr;			/* 0x006c */
> @@ -645,6 +651,11 @@ struct kvm_guestdbg_info_arch {
>  	unsigned long last_bp;
>  };
>  
> +struct kvm_s390_pv_vcpu {
> +	u64 handle;
> +	unsigned long stor_base;
> +};
> +
>  struct kvm_vcpu_arch {
>  	struct kvm_s390_sie_block *sie_block;
>  	/* if vsie is active, currently executed shadow sie control block */
> @@ -673,6 +684,7 @@ struct kvm_vcpu_arch {
>  	__u64 cputm_start;
>  	bool gs_enabled;
>  	bool skey_enabled;
> +	struct kvm_s390_pv_vcpu pv;
>  };
>  
>  struct kvm_vm_stat {
> @@ -843,6 +855,13 @@ struct kvm_s390_gisa_interrupt {
>  	DECLARE_BITMAP(kicked_mask, KVM_MAX_VCPUS);
>  };
>  
> +struct kvm_s390_pv {
> +	u64 handle;
> +	u64 guest_len;
> +	unsigned long stor_base;
> +	void *stor_var;
> +};
> +
>  struct kvm_arch{
>  	void *sca;
>  	int use_esca;
> @@ -878,6 +897,7 @@ struct kvm_arch{
>  	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
>  	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
>  	struct kvm_s390_gisa_interrupt gisa_int;
> +	struct kvm_s390_pv pv;
>  };
>  
>  #define KVM_HVA_ERR_BAD		(-1UL)
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index bc452a15ac3f..839cb3a89986 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -23,11 +23,19 @@
>  #define UVC_RC_INV_STATE	0x0003
>  #define UVC_RC_INV_LEN		0x0005
>  #define UVC_RC_NO_RESUME	0x0007
> +#define UVC_RC_NEED_DESTROY	0x8000
>  
>  #define UVC_CMD_QUI			0x0001
>  #define UVC_CMD_INIT_UV			0x000f
> +#define UVC_CMD_CREATE_SEC_CONF		0x0100
> +#define UVC_CMD_DESTROY_SEC_CONF	0x0101
> +#define UVC_CMD_CREATE_SEC_CPU		0x0120
> +#define UVC_CMD_DESTROY_SEC_CPU		0x0121
>  #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
>  #define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
> +#define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
> +#define UVC_CMD_UNPACK_IMG		0x0301
> +#define UVC_CMD_VERIFY_IMG		0x0302
>  #define UVC_CMD_PIN_PAGE_SHARED		0x0341
>  #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
>  #define UVC_CMD_SET_SHARED_ACCESS	0x1000
> @@ -37,10 +45,17 @@
>  enum uv_cmds_inst {
>  	BIT_UVC_CMD_QUI = 0,
>  	BIT_UVC_CMD_INIT_UV = 1,
> +	BIT_UVC_CMD_CREATE_SEC_CONF = 2,
> +	BIT_UVC_CMD_DESTROY_SEC_CONF = 3,
> +	BIT_UVC_CMD_CREATE_SEC_CPU = 4,
> +	BIT_UVC_CMD_DESTROY_SEC_CPU = 5,
>  	BIT_UVC_CMD_CONV_TO_SEC_STOR = 6,
>  	BIT_UVC_CMD_CONV_FROM_SEC_STOR = 7,
>  	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
>  	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
> +	BIT_UVC_CMD_SET_SEC_PARMS = 11,
> +	BIT_UVC_CMD_UNPACK_IMG = 13,
> +	BIT_UVC_CMD_VERIFY_IMG = 14,
>  	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>  	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
>  };
> @@ -52,6 +67,7 @@ struct uv_cb_header {
>  	u16 rrc;	/* Return Reason Code */
>  } __packed __aligned(8);
>  
> +/* Query Ultravisor Information */
>  struct uv_cb_qui {
>  	struct uv_cb_header header;
>  	u64 reserved08;
> @@ -71,6 +87,7 @@ struct uv_cb_qui {
>  	u64 reserveda0;
>  } __packed __aligned(8);
>  
> +/* Initialize Ultravisor */
>  struct uv_cb_init {
>  	struct uv_cb_header header;
>  	u64 reserved08[2];
> @@ -79,6 +96,35 @@ struct uv_cb_init {
>  	u64 reserved28[4];
>  } __packed __aligned(8);
>  
> +/* Create Guest Configuration */
> +struct uv_cb_cgc {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 guest_handle;
> +	u64 conf_base_stor_origin;
> +	u64 conf_virt_stor_origin;
> +	u64 reserved30;
> +	u64 guest_stor_origin;
> +	u64 guest_stor_len;
> +	u64 guest_sca;
> +	u64 guest_asce;
> +	u64 reserved58[5];
> +} __packed __aligned(8);
> +
> +/* Create Secure CPU */
> +struct uv_cb_csc {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 cpu_handle;
> +	u64 guest_handle;
> +	u64 stor_origin;
> +	u8  reserved30[6];
> +	u16 num;
> +	u64 state_origin;
> +	u64 reserved40[4];
> +} __packed __aligned(8);
> +
> +/* Convert to Secure */
>  struct uv_cb_cts {
>  	struct uv_cb_header header;
>  	u64 reserved08[2];
> @@ -86,12 +132,34 @@ struct uv_cb_cts {
>  	u64 gaddr;
>  } __packed __aligned(8);
>  
> +/* Convert from Secure / Pin Page Shared */
>  struct uv_cb_cfs {
>  	struct uv_cb_header header;
>  	u64 reserved08[2];
>  	u64 paddr;
>  } __packed __aligned(8);
>  
> +/* Set Secure Config Parameter */
> +struct uv_cb_ssc {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 guest_handle;
> +	u64 sec_header_origin;
> +	u32 sec_header_len;
> +	u32 reserved2c;
> +	u64 reserved30[4];
> +} __packed __aligned(8);
> +
> +/* Unpack */
> +struct uv_cb_unp {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 guest_handle;
> +	u64 gaddr;
> +	u64 tweak[2];
> +	u64 reserved38[3];
> +} __packed __aligned(8);
> +
>  /*
>   * A common UV call struct for calls that take no payload
>   * Examples:
> @@ -105,6 +173,7 @@ struct uv_cb_nodata {
>  	u64 reserved20[4];
>  } __packed __aligned(8);
>  
> +/* Set Shared Access */
>  struct uv_cb_share {
>  	struct uv_cb_header header;
>  	u64 reserved08[3];
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index 05ee90a5ea08..12decca22e7c 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -9,6 +9,6 @@ common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  $(KVM)/async_pf.o $(KVM)/irqch
>  ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>  
>  kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
> -kvm-objs += diag.o gaccess.o guestdbg.o vsie.o
> +kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
>  
>  obj-$(CONFIG_KVM) += kvm.o
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index cc7793525a69..1a7bb08f5c26 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -44,6 +44,7 @@
>  #include <asm/cpacf.h>
>  #include <asm/timex.h>
>  #include <asm/ap.h>
> +#include <asm/uv.h>
>  #include "kvm-s390.h"
>  #include "gaccess.h"
>  
> @@ -234,8 +235,10 @@ int kvm_arch_check_processor_compat(void)
>  	return 0;
>  }
>  
> +/* forward declarations */
>  static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
>  			      unsigned long end);
> +static int sca_switch_to_extended(struct kvm *kvm);
>  
>  static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
>  {
> @@ -571,6 +574,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_BPB:
>  		r = test_facility(82);
>  		break;
> +	case KVM_CAP_S390_PROTECTED:
> +		r = is_prot_virt_host();
> +		break;

FWIW, the clean thing to do is to enable the capability only after all
features have been implemented, so as the very last patch.

-- 
Thanks,

David / dhildenb

