Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886574D79CE
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 04:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiCND51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 23:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiCND50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 23:57:26 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A31731DD5;
        Sun, 13 Mar 2022 20:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647230177; x=1678766177;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6bkM5qkPnQ8XQAJyJzGj5m4VADZeV4mTAnh7ytVk5t8=;
  b=nJjDVNXIJzKHe7lucGwQ3LnMoki4zcUbV1Qk8aFoUN/vei5TYAfC1rn2
   OZ5WEJzlQMWyBanpMy4A9BJj1ZUUeaJowqbBELhPjiGBpaguKw98vrX8g
   CMKMY6k5a3WbgbRwnkYjbU4uxeRVA87gwZAtDVqStXfZ5eGD5fFewPej6
   Z1HH7SnCGDEfqYvM1CAvzxgfh8BHsbWm+U56b232Mh70+Xe5KZF0b9yWG
   u1t1V805q7CyiUoPWVmWB8aZIjvA+QIrdhoWcvsV3jw0pKfOiimhx+DlE
   SDLOLwiAXzclhtDrJOkLzWB2HhtLfODJhjXmLQQhcA+LabmWX82sVj9BZ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="236532311"
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="236532311"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 20:56:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,179,1643702400"; 
   d="scan'208";a="713561551"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 20:56:11 -0700
Date:   Mon, 14 Mar 2022 12:09:42 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
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
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <20220314040941.GA18296@gao-cwp>
References: <Yifg4bea6zYEz1BK@google.com>
 <20220309052013.GA2915@gao-cwp>
 <YihCtvDps/qJ2TOW@google.com>
 <6dc7cff15812864ed14b5c014769488d80ce7f49.camel@redhat.com>
 <YirPkr5efyylrD0x@google.com>
 <29c76393-4884-94a8-f224-08d313b73f71@intel.com>
 <01586c518de0c72ff3997d32654b8fa6e7df257d.camel@redhat.com>
 <2900660d947a878e583ebedf60e7332e74a1af5f.camel@redhat.com>
 <20220313135335.GA18405@gao-cwp>
 <fbf929e0793a6b4df59ec9d95a018d1f6737db35.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbf929e0793a6b4df59ec9d95a018d1f6737db35.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> > > This won't work with nested AVIC - we can't just inhibit a nested guest using its own AVIC,
>> > > because migration happens.
>> > 
>> > I mean because host decided to change its apic id, which it can in theory do any time,
>> > even after the nested guest has started. Seriously, the only reason guest has to change apic id,
>> > is to try to exploit some security hole.
>> 
>> Hi
>> 
>> Thanks for the information.  
>> 
>> IIUC, you mean KVM applies APICv inhibition only to L1 VM, leaving APICv
>> enabled for L2 VM. Shouldn't KVM disable APICv for L2 VM in this case?
>> It looks like a generic issue in dynamically toggling APICv scheme,
>> e.g., qemu can set KVM_GUESTDBG_BLOCKIRQ after nested guest has started.
>> 
>
>That is the problem - you can't disable it for L2, unless you are willing to emulate it in software.
>Or in other words, when nested guest uses a hardware feature, you can't at some point say to it:
>sorry buddy - hardware feature disappeared.

Agreed. I missed this.

>
>It is *currently* not a problem for APICv because it doesn't do IPI virtualization,
>and even with these patches, it doesn't do this for nesting.
>It does become when you allow nested guest to use this which I did in the nested AVIC code.
>
>
>and writable apic ids do pose a large problem, since nested AVIC, will target L1's apic ids,
>and when they can change under you without any notice, and even worse be duplicate,
>it is just nightmare.

OK. So the problem of disabling APICv is if we choose to disable APICv instead
of making APIC ID read-only, although it can work perfectly for VMX IPIv, it
effectively makes future cleanup to AVIC difficult/impossible because nested
AVIC is practically to implement without assuming APIC IDs of L1 is immutable.

Sean & Maxim

How about go back to use a module parameter to opt in to read-only APIC ID.
Although migration in some cases may fail but it shouldn't be a big issue as
migration VMs from a KVM with nested=on to a KVM with nested=off may also fail.
