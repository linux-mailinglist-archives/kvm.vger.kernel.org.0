Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E5F4C0C5F
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbiBWGAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 01:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiBWGAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 01:00:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA92D3B00C;
        Tue, 22 Feb 2022 21:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645595988; x=1677131988;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NIratgGYOhkpACukr35jSYKDkM0v76qmlkK/PhGjAS8=;
  b=XVBj3nLxznNDiHi4XIYkTH+HXpjHe5z+3Xah9hLcrbQA84PEqeE6wCqm
   bNyCLWvpBeB/iGhMqvcLUwcnSYIflSVOZV7D9WiYKZufoUbKusRQ9PV5l
   WIIMXU6pu2jlMnLt8LtSS4dWt5EpdmCWpzCfla/LPrz9f26ZeQrMMVt+S
   wd9zhSaU9c1yUlmttEtsTa3iRfNodAIwxr6domBz/2rMzhDtsRonYORpj
   uXyNLXSIWRFOIO/jQui7/xjp68DNvdbncz19FMQIEg1Ouk2jO6Qiwo5pG
   iw3idhSdJvzmYSx1f86vAbULVgv752vMJNKXWbsV7+dpAtVSQ4pgRUNI+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="235401098"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="235401098"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 21:59:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="491071664"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 21:59:42 -0800
Date:   Wed, 23 Feb 2022 14:10:38 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Zeng Guang <guang.zeng@intel.com>,
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
Message-ID: <20220223061037.GA21263@gao-cwp>
References: <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
 <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
 <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
 <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
 <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
 <20220110074523.GA18434@gao-cwp>
 <1ff69ed503faa4c5df3ad1b5abe8979d570ef2b8.camel@redhat.com>
 <YeClaZWM1cM+WLjH@google.com>
 <YfsSjvnoQcfzdo68@google.com>
 <Yfw5ddGNOnDqxMLs@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfw5ddGNOnDqxMLs@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 03, 2022 at 08:22:13PM +0000, Sean Christopherson wrote:
>i.e. ACPI_NUMA gets priority and thus amd_numa_init() will never be reached if
>the NUMA topology is enumerated in the ACPI tables.  Furthermore, the VMM would
>have to actually emulate an old AMD northbridge, which is also extremely unlikely.
>
>The odds of breaking a guest are further diminised given that KVM doesn't emulate
>the xAPIC ID => x2APIC ID hilarity on AMD CPUs and no one has complained.
>
>So, rather than tie this to IPI virtualization, I think we should either make
>the xAPIC ID read-only across the board,

We will go this way and defer the introduction of "xapic_id_writable" to the
emergence of the "crazy" use case.

Levitsky, we plan to revise your patch 13 "[PATCH RESEND 13/30] KVM: x86: lapic:
don't allow to change APIC ID when apic acceleration is enabled" to make xAPIC
ID read-only regardless of APICv/AVIC and include it into IPI virtualization
series (to eliminate the dependency on your AVIC series). Is it fine with you?
And does this patch 13 depend on other patches in your fixes?

>or if we want to hedge in case someone
>has a crazy use case, make the xAPIC ID read-only by default, add a module param
>to let userspace opt-in to a writable xAPIC ID, and report x2APIC and APICv as
>unsupported if the xAPIC ID is writable.  E.g. rougly this, plus your AVIC patches
>if we want to hedge.
