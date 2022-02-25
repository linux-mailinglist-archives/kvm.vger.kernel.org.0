Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C1C4C471B
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241452AbiBYOKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiBYOKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:10:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 332791E017C
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 06:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645798213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vwakpxRLg/AhOfH71656ilXCCJJzZRDG88pVONxw8BY=;
        b=Xv2LHHcocKK5a23SQ/+jhWhb9e+rvr6TOliFvjybfdX4qFeZvXitF40uOecWZgPi5rY2K/
        ivZdJejt1PVyHg5MEWD4lNAsQEqkyDI7QBhFOXBX+YErFE3qjmja8jgM5zogqPolcZ5dDq
        S9sTO0zGbidvgSNskwTL9KGytFyiZ2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-_YbHCZv_PDaKBVATjmSlHw-1; Fri, 25 Feb 2022 09:10:08 -0500
X-MC-Unique: _YbHCZv_PDaKBVATjmSlHw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4608080D6AD;
        Fri, 25 Feb 2022 14:10:05 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B660A7A55D;
        Fri, 25 Feb 2022 14:09:58 +0000 (UTC)
Message-ID: <66b51c39db37c5e5b9d922ecb8275f8cda369d3e.camel@redhat.com>
Subject: Re: [PATCH v6 1/9] x86/cpu: Add new VMX feature, Tertiary
 VM-Execution control
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Date:   Fri, 25 Feb 2022 16:09:57 +0200
In-Reply-To: <20220225082223.18288-2-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
         <20220225082223.18288-2-guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> A new 64-bit control field "tertiary processor-based VM-execution
> controls", is defined [1]. It's controlled by bit 17 of the primary
> processor-based VM-execution controls.
> 
> Different from its brother VM-execution fields, this tertiary VM-
> execution controls field is 64 bit. So it occupies 2 vmx_feature_leafs,
> TERTIARY_CTLS_LOW and TERTIARY_CTLS_HIGH.
> 
> Its companion VMX capability reporting MSR,MSR_IA32_VMX_PROCBASED_CTLS3
> (0x492), is also semantically different from its brothers, whose 64 bits
> consist of all allow-1, rather than 32-bit allow-0 and 32-bit allow-1 [1][2].
> Therefore, its init_vmx_capabilities() is a little different from others.
> 
> [1] ISE 6.2 "VMCS Changes"
> https://www.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
> 
> [2] SDM Vol3. Appendix A.3
> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/msr-index.h   | 1 +
>  arch/x86/include/asm/vmxfeatures.h | 3 ++-
>  arch/x86/kernel/cpu/feat_ctl.c     | 9 ++++++++-
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 3faf0f97edb1..1d180f883c32 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -938,6 +938,7 @@
>  #define MSR_IA32_VMX_TRUE_EXIT_CTLS      0x0000048f
>  #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
>  #define MSR_IA32_VMX_VMFUNC             0x00000491
> +#define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
>  
>  /* VMX_BASIC bits and bitmasks */
>  #define VMX_BASIC_VMCS_SIZE_SHIFT	32
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index d9a74681a77d..ff20776dc83b 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -5,7 +5,7 @@
>  /*
>   * Defines VMX CPU feature bits
>   */
> -#define NVMXINTS			3 /* N 32-bit words worth of info */
> +#define NVMXINTS			5 /* N 32-bit words worth of info */
>  
>  /*
>   * Note: If the comment begins with a quoted string, that string is used
> @@ -43,6 +43,7 @@
>  #define VMX_FEATURE_RDTSC_EXITING	( 1*32+ 12) /* "" VM-Exit on RDTSC */
>  #define VMX_FEATURE_CR3_LOAD_EXITING	( 1*32+ 15) /* "" VM-Exit on writes to CR3 */
>  #define VMX_FEATURE_CR3_STORE_EXITING	( 1*32+ 16) /* "" VM-Exit on reads from CR3 */
> +#define VMX_FEATURE_TERTIARY_CONTROLS	( 1*32+ 17) /* "" Enable Tertiary VM-Execution Controls */
>  #define VMX_FEATURE_CR8_LOAD_EXITING	( 1*32+ 19) /* "" VM-Exit on writes to CR8 */
>  #define VMX_FEATURE_CR8_STORE_EXITING	( 1*32+ 20) /* "" VM-Exit on reads from CR8 */
>  #define VMX_FEATURE_VIRTUAL_TPR		( 1*32+ 21) /* "vtpr" TPR virtualization, a.k.a. TPR shadow */
> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> index da696eb4821a..993697e71854 100644
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -15,6 +15,8 @@ enum vmx_feature_leafs {
>  	MISC_FEATURES = 0,
>  	PRIMARY_CTLS,
>  	SECONDARY_CTLS,
> +	TERTIARY_CTLS_LOW,
> +	TERTIARY_CTLS_HIGH,
>  	NR_VMX_FEATURE_WORDS,
>  };
>  
> @@ -22,7 +24,7 @@ enum vmx_feature_leafs {
>  
>  static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>  {
> -	u32 supported, funcs, ept, vpid, ign;
> +	u32 supported, funcs, ept, vpid, ign, low, high;
>  
>  	BUILD_BUG_ON(NVMXINTS != NR_VMX_FEATURE_WORDS);
>  
> @@ -42,6 +44,11 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>  	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
>  	c->vmx_capability[SECONDARY_CTLS] = supported;
>  
> +	/* All 64 bits of tertiary controls MSR are allowed-1 settings. */
> +	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &low, &high);
> +	c->vmx_capability[TERTIARY_CTLS_LOW] = low;
> +	c->vmx_capability[TERTIARY_CTLS_HIGH] = high;
> +
>  	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
>  	rdmsr_safe(MSR_IA32_VMX_VMFUNC, &ign, &funcs);
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

