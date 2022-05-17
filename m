Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BD252A421
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348322AbiEQOCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348265AbiEQOCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:02:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4948E3DDCE;
        Tue, 17 May 2022 07:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652796159; x=1684332159;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=faeEMQ7OyUUptQglXkgamVq5rsrzWsmKaeH4VwE3gNU=;
  b=Wltjw9gTX/Mey9tS9nQS5iv15tymLLm12keeV+qLVPf3famUPFAbOtXO
   HKudZlpGqrr0c1havLPzpxiPKUBFVKMV2crXFpFGET68vqvBRnWDnTZGa
   GuN7bXeDtY1T4fOcGZzIAn4Esoq47NnsFeKSJI8zTd0joEpoqmvSdpLQk
   2ZGAuTLgB3hevW5gjoX/PnWnN4yC14KgBb88IvoMDeJXCJHDhJcEHVrnV
   YValSHRh74aDQPTF+MQKT6WnpNsCTnbMoLHxO+TybzdeWIlHPezPzg2q7
   aF0CAEa5oK1gPSq5fsAO6oaDpX6tncGVjUi3Tt179AX8p/3y0ny1WNkl8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="357602592"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357602592"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 07:02:38 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="568907519"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 07:02:32 -0700
Date:   Tue, 17 May 2022 22:02:23 +0800
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
Message-ID: <20220517140218.GA569@gao-cwp>
References: <20220419153155.11504-1-guang.zeng@intel.com>
 <2d33b71a-13e5-d377-abc2-c20958526497@redhat.com>
 <cf178428-8c98-e7b3-4317-8282938976fd@intel.com>
 <f0e633b3-38ea-f288-c74d-487387cefddc@redhat.com>
 <YoK48P2UrrjxaRrJ@google.com>
 <20220517135321.GA31556@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517135321.GA31556@gao-cwp>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ Maxim

On Tue, May 17, 2022 at 09:53:26PM +0800, Chao Gao wrote:
>On Mon, May 16, 2022 at 08:49:52PM +0000, Sean Christopherson wrote:
>>On Tue, May 03, 2022, Paolo Bonzini wrote:
>>> On 5/3/22 09:32, Zeng Guang wrote:
>>> > 
>>> > I don't see "[PATCH v9 4/9] KVM: VMX: Report tertiary_exec_control field in
>>> > dump_vmcs()" in kvm/queue. Does it not need ?
>>> 
>>> Added now (somehow the patches were not threaded, so I had to catch them one
>>> by one from lore).
>>> 
>>> > Selftests for KVM_CAP_MAX_VCPU_ID is posted in V2 which is revised on top of
>>> > kvm/queue.
>>> > ([PATCH v2] kvm: selftests: Add KVM_CAP_MAX_VCPU_ID cap test - Zeng
>>> > Guang (kernel.org) <https://lore.kernel.org/lkml/20220503064037.10822-1-guang.zeng@intel.com/>)
>>> 
>>> Queued, thanks.
>>
>>Shouldn't we have a solution for the read-only APIC_ID mess before this is merged?
>
>We can add a new inhibit to disable APICv if guest attempts to change APIC
>ID when IPIv (or AVIC) is enabled. Maxim also thinks using a new inhibit is
>the right direction [1].
>
>If no objection to this approach and Maxim doesn't have the patch, we can post
>one. But we will rely on Maxim to fix APIC ID mess for nested AVIC.
>
>[1] https://lore.kernel.org/all/6475522c58aec5db3ee0a5ccd3230c63a2f013a9.camel@redhat.com/
