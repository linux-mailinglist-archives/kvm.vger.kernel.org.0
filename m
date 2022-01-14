Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84A348E2A5
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 03:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbiANCrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 21:47:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:7289 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232137AbiANCrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 21:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642128459; x=1673664459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cQRgRnqmvCaCbUjaJpysSA9MPAFh7BrW8Ba21rcYXVw=;
  b=hv/xqxwxBIa1XIJetlVueX40oWzvQ7eLKenEddfuJrJKDQ3Au31gyrxZ
   fszjpyNZf8e9j5xmqZRj5/3mDWtt9GpNT6YTxGmgvBaRQbjXloi892Z9R
   vqPZB9ug7Ev069146AfOgEid8Hh27aDwnJpJ7rDAmSJfrDID2L8yNB2AS
   ATgAmQLAOd8ZG8lAFWd7kqXUYiwnEVaVojaNetUJdFSf4VbuTDWkssGDk
   e0iox5oDjhkfFP4ae9xtFzIfose7q4weRryl5kmNH37Ig1pbLeRvts6aK
   407OWYGigEuLYvi9KZOnFpPtku4ZkREfLMtNy47unS07JgJzpSYkG7Qz8
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="244125795"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="244125795"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 18:47:38 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="529964874"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 18:47:33 -0800
Date:   Fri, 14 Jan 2022 10:58:27 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
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
Message-ID: <20220114025825.GA3010@gao-cwp>
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
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 10:19:21PM +0000, Sean Christopherson wrote:
>On Tue, Jan 11, 2022, Maxim Levitsky wrote:
>> Both Intel and AMD's PRM also state that changing APIC ID is implementation
>> dependent.
>>  
>> I vote to forbid changing apic id, at least in the case any APIC acceleration
>> is used, be that APICv or AVIC.
>
>That has my vote as well.  For IPIv in particular there's not much concern with
>backwards compability, i.e. we can tie the behavior to enable_ipiv.

Hi Sean and Levitsky,

Let's align on the implementation.

To disable changes for xAPIC ID when IPIv/AVIC is enabled:

1. introduce a variable (forbid_apicid_change) for this behavior in kvm.ko
and export it so that kvm-intel, kvm-amd can set it when IPIv/AVIC is
enabled. To reduce complexity, this variable is a module level setting.

2. when guest attempts to change xAPIC ID but it is forbidden, KVM prints
a warning on host and injects a #GP to guest.

3. remove AVIC code that deals with changes to xAPIC ID.
