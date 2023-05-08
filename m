Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6166FB92C
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 23:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjEHVLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 17:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjEHVLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 17:11:52 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618E04220;
        Mon,  8 May 2023 14:11:51 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso4569141a12.1;
        Mon, 08 May 2023 14:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683580311; x=1686172311;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NFnNeAlUj9C+huN2rBEcxkVDG8OipZYXhgLegmZBDMk=;
        b=S9UF4HLG98keATLrTaHybz4WUFa5bF0m5spBkllhG7MJveWKjBgz+fjTKfueRjX8LO
         YUz/PdBKVrT0jvYlv+Yc53iOIPt/ZRXnvYdaOpT9ZR7mjU2GE4hMOHBL3a/3jxD1SaPn
         2utFB62PsvOZtp3Wwq1dBsM0pArQV68Grvxxh13mqaax040tfLT94cBy534+4u5IjyOR
         I9xh7S7YBSJOEjJpDW9QIEnrEotSvaAeoaJC8D+LfiZ82M5TCrNCt4NPG84P/VRLo/Au
         cOj/icR180Vw6mDBLiwUTtF0FusiKdmQJUpkhZqq7G7W6BZOTD1cSmqin+wOdFJe6jfd
         r2Kg==
X-Gm-Message-State: AC+VfDzGCIt1Qy19WlXYsaaDcE5/qwuTQNnYTJrceGpTKsespQHqhGAr
        7ucAH7lDqHSxSTVHpATGtcU=
X-Google-Smtp-Source: ACHHUZ6BtFvSoF+wcEO4loE9NZdFfCT+I/PFTdAZhqBSeRBB8gma6+CJUbrsA8zRjfVrnuCD3KU/Lw==
X-Received: by 2002:a17:90a:65cb:b0:248:8399:1f7c with SMTP id i11-20020a17090a65cb00b0024883991f7cmr11239406pjs.38.1683580310757;
        Mon, 08 May 2023 14:11:50 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id k14-20020a170902760e00b0019aeddce6casm7648553pll.205.2023.05.08.14.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 14:11:50 -0700 (PDT)
Date:   Mon, 8 May 2023 21:11:48 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        =?utf-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?utf-8?Q?=C8=98tefan_=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 5/9] KVM: x86: Add new hypercall to lock control
 registers
Message-ID: <ZFlllHjntehpthma@liuwe-devbox-debian-v2>
References: <20230505152046.6575-1-mic@digikod.net>
 <20230505152046.6575-6-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230505152046.6575-6-mic@digikod.net>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023 at 05:20:42PM +0200, Mickaël Salaün wrote:
> This enables guests to lock their CR0 and CR4 registers with a subset of
> X86_CR0_WP, X86_CR4_SMEP, X86_CR4_SMAP, X86_CR4_UMIP, X86_CR4_FSGSBASE
> and X86_CR4_CET flags.
> 
> The new KVM_HC_LOCK_CR_UPDATE hypercall takes two arguments.  The first
> is to identify the control register, and the second is a bit mask to
> pin (i.e. mark as read-only).
> 
> These register flags should already be pinned by Linux guests, but once
> compromised, this self-protection mechanism could be disabled, which is
> not the case with this dedicated hypercall.
> 
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Link: https://lore.kernel.org/r/20230505152046.6575-6-mic@digikod.net
[...]
>  	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
>  	if (is_unrestricted_guest(vcpu))
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ffab64d08de3..a529455359ac 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7927,11 +7927,77 @@ static unsigned long emulator_get_cr(struct x86_emulate_ctxt *ctxt, int cr)
>  	return value;
>  }
>  
> +#ifdef CONFIG_HEKI
> +
> +extern unsigned long cr4_pinned_mask;
> +

Can this be moved to a header file?

> +static int heki_lock_cr(struct kvm *const kvm, const unsigned long cr,
> +			unsigned long pin)
> +{
> +	if (!pin)
> +		return -KVM_EINVAL;
> +
> +	switch (cr) {
> +	case 0:
> +		/* Cf. arch/x86/kernel/cpu/common.c */
> +		if (!(pin & X86_CR0_WP))
> +			return -KVM_EINVAL;
> +
> +		if ((read_cr0() & pin) != pin)
> +			return -KVM_EINVAL;
> +
> +		atomic_long_or(pin, &kvm->heki_pinned_cr0);
> +		return 0;
> +	case 4:
> +		/* Checks for irrelevant bits. */
> +		if ((pin & cr4_pinned_mask) != pin)
> +			return -KVM_EINVAL;
> +

It is enforcing the host mask on the guest, right? If the guest's set is a
super set of the host's then it will get rejected.


> +		/* Ignores bits not present in host. */
> +		pin &= __read_cr4();
> +		atomic_long_or(pin, &kvm->heki_pinned_cr4);
> +		return 0;
> +	}
> +	return -KVM_EINVAL;
> +}
> +
> +int heki_check_cr(const struct kvm *const kvm, const unsigned long cr,
> +		  const unsigned long val)
> +{
> +	unsigned long pinned;
> +
> +	switch (cr) {
> +	case 0:
> +		pinned = atomic_long_read(&kvm->heki_pinned_cr0);
> +		if ((val & pinned) != pinned) {
> +			pr_warn_ratelimited(
> +				"heki-kvm: Blocked CR0 update: 0x%lx\n", val);

I think if the message contains the VM and VCPU identifier it will
become more useful.

Thanks,
Wei.
