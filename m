Return-Path: <kvm+bounces-15511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6428ACEB9
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08F8EB21369
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4DE15099A;
	Mon, 22 Apr 2024 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Sk7zeE8u"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E8A746E;
	Mon, 22 Apr 2024 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713793855; cv=none; b=ftHK+MseJs+KjQXsQ8cW97DLBcDlUAdGFgSGzxo6ZbyvrLLb+ttkEqb5Fm1sPo0p4aUFZIVTSARaf6wQKBOv23/+wrWLRA3NncMEhw0HQxyY+y7Ae2NtriWfVPleLEgyO8ZFwbxaLITGATpH2uDDbM0ttNtRzpSYv/MiBr21WCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713793855; c=relaxed/simple;
	bh=l7NZ+omwoqFGQA6ZVUletLL7jzdRrPSXvdUUplAMI9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hG2dKjnWIBFH2hnMTyvIO26Z9GaXi73kB7m0xR6EhsNFK92a96F7pwbWGUMutAOrZQJFgyhTJNvDmv2UignzF3MhKP0NXfFRm2crTD/WB8mKLjNG6Uix+wx2ki6hMaL19GkbOVKdtpXBznEJ5rQOxnRue80T1Er65/zIZNQ/NNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Sk7zeE8u; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B5D6840E0249;
	Mon, 22 Apr 2024 13:50:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YfbN5_RIe3gU; Mon, 22 Apr 2024 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713793844; bh=gpEJcARwvlMysVUkfk6PN54ibTQNSj5iA5HxqAuFSBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sk7zeE8uc9dg1X2YAaDV+rODYwdDZa0GM4/M/T1ehvbzs558Ruy2drJieEgoGd7J4
	 5wxURUeRAjub42Az2+1bk22A+ybRQUByyPDKez2JZhbORYHPmxiNw1Q35B322KFo+s
	 OQDbyWtwa8Lskgym1rNv/dd8InOSyXdH+7nIaJ6FL7fZEh7AMvEQGgfJdQQuz9tWX6
	 Iyry/SNcERHsIRyHsT8YG9Tybd+8q6ou8swAJ99hunSZjfNygC1Fsr20ecnGtpflCY
	 JAYJOSze0EZVkpFKIdPY5hXxKcdTrzq1h2Es5dmCLX95fPH1EeT88KpeTCB/OToI5K
	 DWz5X9kiSMLEJ6aB8Y4n6YsiKyFF02sBkmnDIquICE38yzAckn2Du1wmGhYEMoe9Lf
	 rINPpb2KgI/j02nbMNzwkF/weUZtNZu+4JrojONAlAUlfnhOmqXWAWC2Gc8fJu6p0S
	 ks0RWwYSMEGYANfMhJtDlzkwQBMh9YFv2o1GtE8ltqvmM5zIp9QDIphJMxC1vdCPdz
	 1aRxhKjBD/guCxNbDnqG+8H9tsQG7A0N3TxId+cBawrvb6EIfDsvbHsaEdvUc4MTLG
	 a0I2sQ2kIfp2jMA3e5wVArulBLaDnWkuG4j57qXju6DJxbg6SLEFRPOeClxaKN3X5S
	 nZUN1INBqdPxeVJK5hJ4U3bs=
Received: from nazgul.tnic (unknown [IPv6:2a02:3038:209:d596:9e4e:36ff:fe9e:77ac])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4B0AD40E016C;
	Mon, 22 Apr 2024 13:50:32 +0000 (UTC)
Date: Mon, 22 Apr 2024 15:50:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 10/16] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20240422135019.GDZiZrG0sKpq0fXQ8d@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-11-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-11-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:22PM +0530, Nikunj A Dadhania wrote:
> Add support for Secure TSC in SNP enabled guests. Secure TSC allows
> guest to securely use RDTSC/RDTSCP instructions as the parameters
> being used cannot be changed by hypervisor once the guest is launched.
> 
> During the boot-up of the secondary cpus, SecureTSC enabled guests

"CPUs"

> need to query TSC info from AMD Security Processor. This communication
> channel is encrypted between the AMD Security Processor and the guest,
> the hypervisor is just the conduit to deliver the guest messages to
> the AMD Security Processor. Each message is protected with an
> AEAD (AES-256 GCM). Use minimal AES GCM library to encrypt/decrypt SNP
> Guest messages to communicate with the PSP.
> 
> Use the guest enc_init hook to fetch SNP TSC info from the AMD Security
> Processor and initialize the snp_tsc_scale and snp_tsc_offset. During
> secondary CPU initialization set VMSA fields GUEST_TSC_SCALE (offset 2F0h)
> and GUEST_TSC_OFFSET(offset 2F8h) with snp_tsc_scale and snp_tsc_offset
> respectively.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> ---
>  arch/x86/include/asm/sev-common.h |   1 +
>  arch/x86/include/asm/sev.h        |  23 +++++++
>  arch/x86/include/asm/svm.h        |   6 +-
>  arch/x86/kernel/sev.c             | 107 ++++++++++++++++++++++++++++--
>  arch/x86/mm/mem_encrypt_amd.c     |   6 ++
>  5 files changed, 134 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index b463fcbd4b90..6adc8e27feeb 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -159,6 +159,7 @@ struct snp_psc_desc {
>  #define GHCB_TERM_NOT_VMPL0		3	/* SNP guest is not running at VMPL-0 */
>  #define GHCB_TERM_CPUID			4	/* CPUID-validation failure */
>  #define GHCB_TERM_CPUID_HV		5	/* CPUID failure during hypervisor fallback */
> +#define GHCB_TERM_SECURE_TSC		6	/* Secure TSC initialization failed */
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index d950a3ac5694..16bf5afa7731 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -170,6 +170,8 @@ enum msg_type {
>  	SNP_MSG_ABSORB_RSP,
>  	SNP_MSG_VMRK_REQ,
>  	SNP_MSG_VMRK_RSP,

<-- Pls leave an empty newline here to denote that there's a hole in the
define numbers. Alternatively, you can add the missing ones too.

> +	SNP_MSG_TSC_INFO_REQ = 17,
> +	SNP_MSG_TSC_INFO_RSP,
>  
>  	SNP_MSG_TYPE_MAX
>  };
> @@ -214,6 +216,23 @@ struct sev_guest_platform_data {
>  	struct snp_req_data input;
>  };
>  
> +#define SNP_TSC_INFO_REQ_SZ 128
> +
> +struct snp_tsc_info_req {
> +	/* Must be zero filled */

Instead of adding a comment which people might very likely miss, add
a check for that array to warn when it is not zeroed.

> +	u8 rsvd[SNP_TSC_INFO_REQ_SZ];
> +} __packed;
> +
> +struct snp_tsc_info_resp {
> +	/* Status of TSC_INFO message */

The other struct members don't need a comment?

> +	u32 status;
> +	u32 rsvd1;
> +	u64 tsc_scale;
> +	u64 tsc_offset;
> +	u32 tsc_factor;
> +	u8 rsvd2[100];
> +} __packed;
> +
>  struct snp_guest_dev {
>  	struct device *dev;
>  	struct miscdevice misc;
> @@ -233,6 +252,7 @@ struct snp_guest_dev {
>  		struct snp_report_req report;
>  		struct snp_derived_key_req derived_key;
>  		struct snp_ext_report_req ext_report;
> +		struct snp_tsc_info_req tsc_info;
>  	} req;
>  	unsigned int vmpck_id;
>  };
> @@ -370,6 +390,8 @@ static inline void *alloc_shared_pages(size_t sz)
>  
>  	return page_address(page);
>  }
> +
> +void __init snp_secure_tsc_prepare(void);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
> @@ -404,6 +426,7 @@ static inline int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_g
>  					 struct snp_guest_request_ioctl *rio) { return 0; }
>  static inline void free_shared_pages(void *buf, size_t sz) { }
>  static inline void *alloc_shared_pages(size_t sz) { return NULL; }
> +static inline void __init snp_secure_tsc_prepare(void) { }
>  #endif
>  
>  #ifdef CONFIG_KVM_AMD_SEV
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 87a7b917d30e..3a8294bbd109 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -410,7 +410,9 @@ struct sev_es_save_area {
>  	u8 reserved_0x298[80];
>  	u32 pkru;
>  	u32 tsc_aux;
> -	u8 reserved_0x2f0[24];
> +	u64 tsc_scale;
> +	u64 tsc_offset;
> +	u8 reserved_0x300[8];
>  	u64 rcx;
>  	u64 rdx;
>  	u64 rbx;
> @@ -542,7 +544,7 @@ static inline void __unused_size_checks(void)
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
> -	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
> +	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index a9c1efd6d4e3..20a1e50b7638 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -75,6 +75,10 @@ static u64 sev_hv_features __ro_after_init;
>  /* Secrets page physical address from the CC blob */
>  static u64 secrets_pa __ro_after_init;
>  
> +/* Secure TSC values read using TSC_INFO SNP Guest request */
> +static u64 snp_tsc_scale __ro_after_init;
> +static u64 snp_tsc_offset __ro_after_init;
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>  	struct ghcb ghcb_page;
> @@ -956,6 +960,83 @@ void snp_guest_cmd_unlock(void)
>  }
>  EXPORT_SYMBOL_GPL(snp_guest_cmd_unlock);
>  
> +static struct snp_guest_dev tsc_snp_dev __initdata;
> +
> +static int __snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
> +				    struct snp_guest_request_ioctl *rio);
> +

Pls design your code without the need for a forward declaration.

> +static int __init snp_get_tsc_info(void)
> +{
> +	struct snp_tsc_info_req *tsc_req = &tsc_snp_dev.req.tsc_info;
> +	static u8 buf[SNP_TSC_INFO_REQ_SZ + AUTHTAG_LEN];
> +	struct snp_guest_request_ioctl rio;
> +	struct snp_tsc_info_resp tsc_resp;
> +	struct snp_guest_req req;
> +	int rc, resp_len;
> +
> +	/*
> +	 * The intermediate response buffer is used while decrypting the
> +	 * response payload. Make sure that it has enough space to cover the
> +	 * authtag.
> +	 */
> +	resp_len = sizeof(tsc_resp) + AUTHTAG_LEN;
> +	if (sizeof(buf) < resp_len)
> +		return -EINVAL;

Huh, those both are static buffers. Such checks are done with
BUILD_BUG_ON.

> +	memset(tsc_req, 0, sizeof(*tsc_req));
> +	memset(&req, 0, sizeof(req));
> +	memset(&rio, 0, sizeof(rio));
> +	memset(buf, 0, sizeof(buf));
> +
> +	if (!snp_assign_vmpck(&tsc_snp_dev, 0))
> +		return -EINVAL;

Do that before the memsetting.

> +
> +	/* Initialize the PSP channel to send snp messages */
> +	rc = snp_setup_psp_messaging(&tsc_snp_dev);
> +	if (rc)
> +		return rc;
> +
> +	req.msg_version = MSG_HDR_VER;
> +	req.msg_type = SNP_MSG_TSC_INFO_REQ;
> +	req.vmpck_id = tsc_snp_dev.vmpck_id;
> +	req.req_buf = tsc_req;
> +	req.req_sz = sizeof(*tsc_req);
> +	req.resp_buf = buf;
> +	req.resp_sz = resp_len;
> +	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +
> +	rc = __snp_send_guest_request(&tsc_snp_dev, &req, &rio);

The changes to *snp_send_guest_request are unrelated to the secure TSC
enablement. Pls do them in a pre-patch.

Ok, I'm going to stop here and give you a chance to work in all the
review feedback and send a new revision.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

