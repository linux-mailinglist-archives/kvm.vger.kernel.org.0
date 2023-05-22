Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CCC70B699
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 09:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjEVHfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 03:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjEVHfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 03:35:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25099B7;
        Mon, 22 May 2023 00:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684740906; x=1716276906;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=NNEsmSz9ktPLt1i5LChMsRaaT97gOT/nB8+x/Mn9oGo=;
  b=bLrUp0RJH9Hft3+Au0L6i6F048AqmJYbecYbZseZK2EhH+yJVMIpb0T5
   vWB9hZDQ2OMWts1iA1+arusagsDuSbBMmEDBq2iZwxaWWJzfe5e+JdNnR
   3M7Wd3vtzhy8W3I+gw+BpMDsdtAtn4mxpEj8DJE0dwa+niwdyFnkjxtE0
   E0mrq876yb85S+YAsBOvE5bFntg+9ii0xZaLzLq+d6WepiWE4vQ3xLsWX
   ORhOcgxHOfbIBcPCDVJM0/BbGaqgmGIs/ls+56CQVE4dJz9zsGHiKndnb
   6ALCVIn3f61E8mdonvnxUQQN98WgMePj8GlM7PQxfujFCqbFEcBQKMsIX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="352874164"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="352874164"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 00:35:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="815583491"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="815583491"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.192.139])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2023 00:34:52 -0700
Date:   Mon, 22 May 2023 15:25:08 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Babu Moger <babu.moger@amd.com>, Chao Gao <chao.gao@intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Liu <jing2.liu@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Leonardo Bras <leobras@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Qinglan Xiang <qinglan.xiang@intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Margarita Maroto <margarita.maroto@intel.com>,
        Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE / RFC] Periodic Upstream Call for KVM
Message-ID: <20230522072508.GA326851@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20230512231026.799267-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512231026.799267-1-seanjc@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 04:10:27PM -0700, Sean Christopherson wrote:
> I am "officially" announcing a Periodic Upstream Call for KVM, a.k.a. PUCK.
> The intent of the PUCK is to provide a vehicle for having "in-person" technical
> discussions of features, designs, problems, etc. that are cumbersome to discuss
> asynchronously on-list, e.g. because something is too complex, too large, etc.

Yes, although on-list discussion is still the primary channel, a call is
a nice supplement for all relevant people on a large, complex topic to
achieve quick alignment. For people not able to attend the call, the
meeting recordings/minutes can be posted for them.

> 
> Exact details are TBD, and obviously can be adapted as needed.  Proposal:
> 
>   Frequency: Weekly
>   Time:      Wednesday, 6:00am Pacific Time
>   Duration:  60 minutes
>   Software:  ???
> 
> My thinking for weekly versus fortnightly (every other week) is that we can always
> cancel meetings if there are no agenda items, and bump down to fortnightly if we
> are constantly canceling.  On the flip side, if we go with fortnightly, it'd be
> more difficult to clear the backlog if PUCK gets booked out multiple sessions, and
> PUCK would be less useful for discussing urgent issues.
> 
> As for the time, 6am Pacific Time was the least awful (and still quite awful IMO)
> time I could find that gives the majority of the community a reasonable chance of
> attending.  I know we have developers in at least the below time zones (and probably
> more, though I don't think anyone works from Hawaii, and if someone does work from
> Hawaii then they have nothing to complain about :-) ).
> 
>   PT   (6am)
>   MT   (7am)
>   CT   (8am)
>   ET   (9am)
>   WET  (2pm)
>   CET  (3pm)
>   EET  (4pm)
>   EST  (5pm)
>   CST  (9pm)
>   NZST (1am)

This looks good, 9pm is not too late for PRC people.

> 
> The obvious alternative would be to invert the schedule and have the sync be in
> the evening/night for Pacific Time, but to get 6am for ARM folks, we end up with:
> 
>   PT   (10pm)
>   MT   (11pm)
>   CT   (12pm)
>   ET   (1am)
>   WET  (6am)
>   CET  (7am)
>   EET  (8am)
>   EST  (9am)
>   CST  (1pm)
>   NZST (5pm)
> 
> which is quite unreasonable for pretty much everyone based in the US.  Earlier
> than 6am for WET is likewise unreasonable and will result in people not attending.
> 9pm for China is also unreasonable, but I hope that it's not completely ridiculous
> and is doable enough that people can at least attend on an as-needed basis.  Sorry
> Kai, as the sole representative from New Zealand, you get hosed :-(
> 
> Wednesday because holidays and (short) vacations most often land at the beginning
> and end of the week.
> 
> 60 minutes because I'm not waking up at dawn for anything less, and anything
> more will likely have dimishing returns, especially for folks on the edges of
> the time zone table.
> 
> Lastly, the big unknown is which video communication software to use.  My default
> is obviously Google Meet, but I've been told that Meet is unusable in some
> countries. :-/  My only requirements (beyond basic, obvious functionality) are
> that (a) there's a web interface (no install required) and that (b) the calls can
> be recorded.

Google Meet should work for me, but may not for every (PRC) people.
Besides no installation, if no registration would be even better ;)
Maybe we can run with Google Meet for the first session(s) if you
havn't get one in your mind, it's not too hard to switch to alternative
at a later time right?

> 
> To kick things off, I am leaning toward a "launch" date of May 24th (Pacific),
> with KVM guest private mem (a.k.a. UPM) as the first topic.

Thanks for driving this, yes for UPM I would definitely join.

Chao
> 
> Please chime in with thoughts and ideas!
> 
> 
> P.S. This is an open invite, feel free to forward at will.  The Cc list is by no
> means intended to be definitive.
