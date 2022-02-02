Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081F64A7BA9
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 00:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348078AbiBBXYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 18:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiBBXYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 18:24:03 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6510C06173B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 15:24:03 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id i30so635238pfk.8
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 15:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TMRuvj0YHSNq7J8xOEwAXO2ubsHdoBysuDc2sKEVP3s=;
        b=ULms3/ZRHlzY8oLjMfRqpQyd8v2wX/UI9/n0bqukSNG9LV/tluvg6vlFRvnHwxb/jM
         VX6uDlvynqTGzvXEuEnSI5GQ3BykMjyFrVKEU4oE9COK/+enYL+Day453MVa6rWZCVFM
         7bqx8ZuDLYDU4AyDI7PcH4K5V7bY6dBp86ccmUp9vJERazJv+epOk2n8B5Siil7Oymd0
         TOFtvlTXTsG9B6zeSRf+YJBdaguvjoqadDwP6K36H2+2tF3UqIFec0qy9giwGeqBPJT+
         iiSAPOQFPGCakiSuNPpGfE1BrvmEnWgStWOtOlucxsxG/iKCvqx4gYoas04WUr0IWPdM
         mIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TMRuvj0YHSNq7J8xOEwAXO2ubsHdoBysuDc2sKEVP3s=;
        b=m6tGlyZc/ozvI+w2mfkdFMandDhO2DHGkNr7WRIjbU4vJYgh1yf/4rDeXX/RrO7lPO
         Zb8+MXHjb1DCnPQExeki5FsjLGDntwC9/0UVsDlkb30HNZPFMN4uZAkUdsDXl9DS4WXT
         xjmsdZRfS81sgLbn1qeCJqKtAItxgNAmGJkEnsBvyj8KG+MJ6zbM2D3tgLiT41ki6VKo
         DE5ozd7htpDkukU7hIm50H/l+I4ezuHBWo0pNav7pspVBUC+PXkH1qTe7LWEsly5Q1a3
         ylsp1ZkPDX6rK3ZkaKmqmt0P32M8hBDbpcG02TnpdNeey3c5QjPFTxQQK7Evr+s5oXtp
         rU5g==
X-Gm-Message-State: AOAM533vN1PVeXOeFm5McaTRCOYM2QFnDSotOwdzcH238dQ/oDz7Xbii
        ltZ9L/6yQMNThLJYh/3yUpfwTUB8oJ8LHQ==
X-Google-Smtp-Source: ABdhPJw/VhzDp5WVmvlbQGPQXxyweppph1Vh5AQrAkvzGhAzooZZ0zxO4saiM9oL8DJQGQ56OGUU9Q==
X-Received: by 2002:a63:485f:: with SMTP id x31mr8133318pgk.358.1643844242921;
        Wed, 02 Feb 2022 15:24:02 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ne23sm4147784pjb.57.2022.02.02.15.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 15:24:02 -0800 (PST)
Date:   Wed, 2 Feb 2022 23:23:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when
 APIC ID is changed
Message-ID: <YfsSjvnoQcfzdo68@google.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-8-guang.zeng@intel.com>
 <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
 <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
 <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
 <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
 <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
 <20220110074523.GA18434@gao-cwp>
 <1ff69ed503faa4c5df3ad1b5abe8979d570ef2b8.camel@redhat.com>
 <YeClaZWM1cM+WLjH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeClaZWM1cM+WLjH@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022, Sean Christopherson wrote:
> On Tue, Jan 11, 2022, Maxim Levitsky wrote:
> > Both Intel and AMD's PRM also state that changing APIC ID is implementation
> > dependent.
> >  
> > I vote to forbid changing apic id, at least in the case any APIC acceleration
> > is used, be that APICv or AVIC.
> 
> That has my vote as well.  For IPIv in particular there's not much concern with
> backwards compability, i.e. we can tie the behavior to enable_ipiv.

Hrm, it may not be that simple.  There's some crusty (really, really crusty) code
in Linux's boot code that writes APIC_ID.  IIUC, the intent is to play nice with
running a UP crash dump kernel on "BSP" that isn't "the BSP", e.g. has a non-zero
APIC ID.

static void __init apic_bsp_up_setup(void)
{
#ifdef CONFIG_X86_64
	apic_write(APIC_ID, apic->set_apic_id(boot_cpu_physical_apicid));
#else
	/*
	 * Hack: In case of kdump, after a crash, kernel might be booting
	 * on a cpu with non-zero lapic id. But boot_cpu_physical_apicid
	 * might be zero if read from MP tables. Get it from LAPIC.
	 */
# ifdef CONFIG_CRASH_DUMP
	boot_cpu_physical_apicid = read_apic_id();
# endif
#endif
}

The most helpful comment is in generic_processor_info():

	/*
	 * boot_cpu_physical_apicid is designed to have the apicid
	 * returned by read_apic_id(), i.e, the apicid of the
	 * currently booting-up processor. However, on some platforms,
	 * it is temporarily modified by the apicid reported as BSP
	 * through MP table. Concretely:
	 *
	 * - arch/x86/kernel/mpparse.c: MP_processor_info()
	 * - arch/x86/mm/amdtopology.c: amd_numa_init()
	 *
	 * This function is executed with the modified
	 * boot_cpu_physical_apicid. So, disabled_cpu_apicid kernel
	 * parameter doesn't work to disable APs on kdump 2nd kernel.
	 *
	 * Since fixing handling of boot_cpu_physical_apicid requires
	 * another discussion and tests on each platform, we leave it
	 * for now and here we use read_apic_id() directly in this
	 * function, generic_processor_info().
	 */

It's entirely possible that this path is unused in a KVM guest, but I don't think
we can know that with 100% certainty.

But I also completely agree that attempting to keep the tables up-to-date is ugly
and a waste of time and effort, e.g. as Maxim pointed out, the current AVIC code
is comically broken.

Rather than disallowing the write, what if we add yet another inhibit that disables
APICv if IPI virtualization is enabled and a vCPU has an APIC ID != vcpu_id?  KVM
is equipped to handle the emulation, so it just means that a guest that's doing 
weird things loses a big of performance.
