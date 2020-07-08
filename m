Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2D52190BA
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgGHTea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgGHTe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:34:29 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E1AC061A0B;
        Wed,  8 Jul 2020 12:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ykqc4FtVhosQ5cT56AO4CSaf12VShBEd2EeO9VFWJck=; b=d1QHdFcmXFBD/KiHmya6++Y2LQ
        O1J2Ji+Cn6nmDYDKi8i6rjaNa3en/nvJyCpHdpO0fsmFMAxsYVX8j9ntnSCLsY1OdZFsreisiHAbH
        fo3C/+N01j+ETDL0DAjEJaefVvteJjo0CG8tKDCELKC5EOm0DqWPh7zkTGBAwI0lDvkl9YEMCcBb8
        dj/UMpEOXvVRI60INXSsRmmvlrK3WX57oa8zehiCIdQhdN5e6K9xvjJNDHCGokxQ/ykxIKCytOfqo
        ozQfZ4wQuWLuZew6ufsfD+bkoZuiytb7UEgXTeoAyjzE8hQxHtSTCTKdBAGP/eA1+H0LX0Hugu9O2
        o6o78CvA==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtFpb-0001LA-05; Wed, 08 Jul 2020 19:34:11 +0000
Subject: Re: [PATCH v4] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Abhishek Bhardwaj <abhishekbh@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
References: <20200708192546.4068026-1-abhishekbh@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <06f15327-f346-fb8d-cc8e-8e12c398324d@infradead.org>
Date:   Wed, 8 Jul 2020 12:34:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708192546.4068026-1-abhishekbh@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi again,

On 7/8/20 12:25 PM, Abhishek Bhardwaj wrote:
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index b277a2db62676..1f85374a0b812 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -107,4 +107,17 @@ config KVM_MMU_AUDIT
>  	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
>  	 auditing of KVM MMU events at runtime.
>  
> +config KVM_VMENTRY_L1D_FLUSH
> +	int "L1D cache flush settings (1-3)"
> +	range 1 3
> +	default "2"
> +	depends on KVM && X86_64
> +	help
> +	 This setting determines the L1D cache flush behavior before a VMENTER.
> +	 This is similar to setting the option / parameter to
> +	 kvm-intel.vmentry_l1d_flush.
> +	 1 - Never flush.
> +	 2 - Conditionally flush.
> +	 3 - Always flush.
> +
>  endif # VIRTUALIZATION

If you do a v5, the help text lines (under "help") should be indented
with one tab + 2 spaces according to Documentation/process/coding-style.rst.

-- 
~Randy

