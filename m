Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528B123AC37
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 20:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgHCSRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 14:17:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:64254 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgHCSRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 14:17:32 -0400
IronPort-SDR: loAs93nzpjOkEnHDRT2GmaePKOyORBLTbtHOopOwbcRwogaw3wFNo1uxlSx1+Fq8iG0e8ux7fd
 GsC3Z9InH7rQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="131747474"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="131747474"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 11:17:31 -0700
IronPort-SDR: qYwWbSdY2czxF1LXhZWr+jtXPPNYNiq2mfY0YwJjC7Ot1FOGTWET09qrJQ/cqYNEbRl5rrR0bK
 qMcClRYrJTgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="492008119"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006.fm.intel.com with ESMTP; 03 Aug 2020 11:17:31 -0700
Date:   Mon, 3 Aug 2020 11:17:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v3 2/4] KVM: SVM: Add GHCB definitions
Message-ID: <20200803181731.GF3151@linux.intel.com>
References: <20200803122708.5942-1-joro@8bytes.org>
 <20200803122708.5942-3-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803122708.5942-3-joro@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 03, 2020 at 02:27:06PM +0200, Joerg Roedel wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Extend the vmcb_safe_area with SEV-ES fields and add a new
> 'struct ghcb' which will be used for guest-hypervisor communication.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/svm.h | 45 +++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c     |  2 ++
>  2 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 8a1f5382a4ea..9a3e0b802716 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -200,13 +200,56 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
>  	u64 br_to;
>  	u64 last_excp_from;
>  	u64 last_excp_to;
> +
> +	/*
> +	 * The following part of the save area is valid only for
> +	 * SEV-ES guests when referenced through the GHCB.
> +	 */
> +	u8 reserved_7[104];
> +	u64 reserved_8;		/* rax already available at 0x01f8 */
> +	u64 rcx;
> +	u64 rdx;
> +	u64 rbx;
> +	u64 reserved_9;		/* rsp already available at 0x01d8 */
> +	u64 rbp;
> +	u64 rsi;
> +	u64 rdi;
> +	u64 r8;
> +	u64 r9;
> +	u64 r10;
> +	u64 r11;
> +	u64 r12;
> +	u64 r13;
> +	u64 r14;
> +	u64 r15;
> +	u8 reserved_10[16];
> +	u64 sw_exit_code;
> +	u64 sw_exit_info_1;
> +	u64 sw_exit_info_2;
> +	u64 sw_scratch;
> +	u8 reserved_11[56];
> +	u64 xcr0;
> +	u8 valid_bitmap[16];
> +	u64 x87_state_gpa;
> +};
> +
> +struct __attribute__ ((__packed__)) ghcb {

IMO this should use __packed straightaway, but I can also appreciate the
desire for consistency within a given snapshot in time so I'm a-ok if you
want to keep it as is.

> +	struct vmcb_save_area save;
> +	u8 reserved_save[2048 - sizeof(struct vmcb_save_area)];
> +
> +	u8 shared_buffer[2032];
> +
> +	u8 reserved_1[10];
> +	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
> +	u32 ghcb_usage;
>  };
>  
>  
>  static inline void __unused_size_checks(void)
>  {
> -	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != 0x298);
> +	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != 1032);
>  	BUILD_BUG_ON(sizeof(struct vmcb_control_area) != 256);
> +	BUILD_BUG_ON(sizeof(struct ghcb) != 4096);
>  }
>  
>  struct __attribute__ ((__packed__)) vmcb {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 783330d0e7b8..953cf947f022 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4161,6 +4161,8 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
>  
>  static int __init svm_init(void)
>  {
> +	__unused_size_checks();
> +
>  	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
>  			__alignof__(struct vcpu_svm), THIS_MODULE);
>  }
> -- 
> 2.17.1
> 
