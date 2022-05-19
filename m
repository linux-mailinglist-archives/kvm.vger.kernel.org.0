Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B8F52CF64
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 11:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiESJ3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 05:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbiESJ3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 05:29:35 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6839CA776E;
        Thu, 19 May 2022 02:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652952573; x=1684488573;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GG+D/zbzcTBxqP2PNnwLTtmoBW5Cf4iVBDI1LewPyVE=;
  b=TqX1Y9O9Hs49AZiWkUl1+B8xITThfcTUdUzpngbIFMJC28Az6DVBixAN
   gefLfygW6iBMEWmNPQYrdYV394OYd4O6QvXOtynzEpTSM2u+wVmmy4hBy
   sHiaR3Ojw+bc6Nm4sPn8MB1BcHnrQEqExASQpUO/WsP/HDYcNf0kNibV9
   6XTS2eEHZGoLXZ8YoLUIEkhom51iAG/B/LPGvWmpdtCxNOcQbwfPhG6KF
   Xh+ShMxGnZN7zRaFkX4R9aQyqwqhdI5S5A+3XU75Erpn2E93E5Z9VV16D
   ZcLScckKMBG+/EcP9uqYu5A8OWyCCIvP46pEXJezKRKsYeeRtm3+cFOro
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="269701311"
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="269701311"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 02:29:26 -0700
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="570113195"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 02:29:20 -0700
Date:   Thu, 19 May 2022 17:29:12 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zeng Guang <guang.zeng@intel.com>,
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
Subject: Re: [PATCH v9 0/9] IPI virtualization support for VM
Message-ID: <20220519092906.GA3234@gao-cwp>
References: <20220419153155.11504-1-guang.zeng@intel.com>
 <2d33b71a-13e5-d377-abc2-c20958526497@redhat.com>
 <cf178428-8c98-e7b3-4317-8282938976fd@intel.com>
 <f0e633b3-38ea-f288-c74d-487387cefddc@redhat.com>
 <YoK48P2UrrjxaRrJ@google.com>
 <20220517135321.GA31556@gao-cwp>
 <20220517140218.GA569@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517140218.GA569@gao-cwp>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 10:02:23PM +0800, Chao Gao wrote:
>+ Maxim
>
>On Tue, May 17, 2022 at 09:53:26PM +0800, Chao Gao wrote:
>>On Mon, May 16, 2022 at 08:49:52PM +0000, Sean Christopherson wrote:
>>>On Tue, May 03, 2022, Paolo Bonzini wrote:
>>>> On 5/3/22 09:32, Zeng Guang wrote:
>>>> > 
>>>> > I don't see "[PATCH v9 4/9] KVM: VMX: Report tertiary_exec_control field in
>>>> > dump_vmcs()" in kvm/queue. Does it not need ?
>>>> 
>>>> Added now (somehow the patches were not threaded, so I had to catch them one
>>>> by one from lore).
>>>> 
>>>> > Selftests for KVM_CAP_MAX_VCPU_ID is posted in V2 which is revised on top of
>>>> > kvm/queue.
>>>> > ([PATCH v2] kvm: selftests: Add KVM_CAP_MAX_VCPU_ID cap test - Zeng
>>>> > Guang (kernel.org) <https://lore.kernel.org/lkml/20220503064037.10822-1-guang.zeng@intel.com/>)
>>>> 
>>>> Queued, thanks.
>>>
>>>Shouldn't we have a solution for the read-only APIC_ID mess before this is merged?

Paolo & Sean,

If a solution for read-only APIC ID mess is needed before merging IPIv
series, do you think the Maxim's patch [1] after some improvement will
suffice? Let us know if there is any gap.

[1]: https://lore.kernel.org/all/20220427200314.276673-3-mlevitsk@redhat.com/
