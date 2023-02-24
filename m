Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3526A18FC
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 10:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjBXJol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 04:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBXJoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 04:44:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20451E1CF;
        Fri, 24 Feb 2023 01:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677231878; x=1708767878;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tthbIv4hexdchQVfCwY+Sh/tjZzJwxcPwHPTMgzq1Hk=;
  b=NFxaLO7PoY5hRUbq80Yscr8/OurPJu8HQEj6xqu73IOeeTT11AAwguNE
   ekU+gNyDb1ECGYjWtOvDgKrDisjeexUcYqBALQi3u+fdCIdwHae5R9Nhb
   FlkF8DKWbkX1NGqUSIcY6rwQwgZI3kneU3NF/2T50FBYPwcunLWgpp8pj
   SKX+OZadPjxXSelfPnSf488qGQb1pdvRIOLtWiSB+WuMeMxykQxUm4RAL
   us0Lz5Sg83oSofp+mCOIlrK8NcATYNSpmB7/TpH/tWxZVkN3r5DHjxMR+
   g80ZFXezon0LW9TVnBRPVHvjyZMuhZ1im15Kvp1leH0hdxSb5aVYnxKWC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="321638727"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="321638727"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 01:44:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="622655252"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="622655252"
Received: from moqiongz-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.215.23])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 01:44:24 -0800
Date:   Fri, 24 Feb 2023 17:44:21 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Shier <pshier@google.com>,
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
        Chao Peng <chao.p.peng@linux.intel.com>,
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
        Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Documentation/process: Add a maintainer handbook for
 KVM x86
Message-ID: <20230224094421.lax6zbccbqk4gg4y@linux.intel.com>
References: <20230217225449.811957-1-seanjc@google.com>
 <20230217225449.811957-3-seanjc@google.com>
 <20230221110607.6wvrgpqip3njrkwu@linux.intel.com>
 <Y/VhBo9ek1PPBEb5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/VhBo9ek1PPBEb5@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 21, 2023 at 04:25:42PM -0800, Sean Christopherson wrote:
> On Tue, Feb 21, 2023, Yu Zhang wrote:
> > Thank you so much, Sean, for such a detailed guidance!
> > 
> > Some questions below:
> > 
> > On Fri, Feb 17, 2023 at 02:54:49PM -0800, Sean Christopherson wrote:
> > > Add a KVM x86 doc to the subsystem/maintainer handbook section to explain
> > > how KVM x86 (currently) operates as a sub-subsystem, and to soapbox on
> > > the rules and expectations for contributing to KVM x86.
> > 
> > It's a fantastic doc! Also, many good requirements can be common in KVM, not
> > just KVM x86(e.g. the comment, changelog format, the testing requirement
> > etc.). Could we be greedier to ask our KVM maintainers for a generic handbook
> > of KVM, and maybe different sections for specific arches, which describe their
> > specific requirements(the base trees and branches, the maintaining processes
> > etc.)? :)
> 
> At some point, yes, but my strong preference is to document the x86 side of things
> and then work from there.  For KVM x86, I can mostly just say "these are the rules".
> Same goes for the other KVM arch maintainers (for their areas).
> 
> Incorporating all of KVM would require a much more collaborative effort, which isn't
> a bad thing, but it will take more time and effort.  And IMO, KVM x86 needs this
> typ eof documentation a lot more than the other KVM architectures, i.e. pushing out
> KVM x86 documentation in order to go for more comprehensive documentation is not a
> good tradeoff.

Sure. No reason to push out this doc. 

> 
> > > +Trees
> > > +-----
> > > +KVM x86 is currently in a transition period from being part of the main KVM
> > > +tree, to being "just another KVM arch".  As such, KVM x86 is split across the
> > > +main KVM tree, ``git.kernel.org/pub/scm/virt/kvm/kvm.git``, and a KVM x86
> > > +specific tree, ``github.com/kvm-x86/linux.git``.
> > 
> > Does other arch also have a specific tree?
> 
> Yes.
> 
> > If a patch series touches multiple archs(though the chance could be very
> > low), I guess that patch set should still be based on the main KVM tree? The
> > master branch or the next branch?
> 
> Hmm, good question.  Using kvm-86/next is likely the best answer in most cases.
> kvm/master is usually a bad choice because it won't have _any_ changes for the next
> release, i.e. using it as a base is more likely to yield conflicts.  Similarly,
> kvm/queue and kvm/next are unlikely to have more relevant changes than kvm-x86/next.

Thanks. Let's try.

> 
> If there are non-trivial conflicts with multiple architectures then coordination
> between maintainers will be required no matter what base is used.  And I would
> expect people sending those types of series to have enough experience to be able
> to make a judgment call and/or engage with maintainers to figure out the best solution.
> 
> I'll rework the "Base Tree/Branch" to explicitly state that any series that primarily
> targets x86 should be based on kvm-x86/next, but with a "use common sense" qualifier.
> 
> > > +Co-Posting Tests
> > > +~~~~~~~~~~~~~~~~
> > > +KVM selftests that are associated with KVM changes, e.g. regression tests for
> > > +bug fixes, should be posted along with the KVM changes as a single series.
> > > +
> > > +KVM-unit-tests should *always* be posted separately.  Tools, e.g. b4 am, don't
> > > +know that KVM-unit-tests is a separate repository and get confused when patches
> > > +in a series apply on different trees.  To tie KVM-unit-tests patches back to
> > > +KVM patches, first post the KVM changes and then provide a lore Link: to the
> > > +KVM patch/series in the KVM-unit-tests patch(es).
> > 
> > I wonder, for KVM bugzilla to report a bug, or for our QAs to perform regular
> > tests using KVM selftests/KVM-unit-tests, which tree/branch is more reasonable
> > to be based on?
> > 
> > E.g., I saw some bugzilla issues earlier, reporting failures of some unit tests,
> > did some investigation, yet to find those failures were just because the corresponding
> > KVM patches had not been merged yet. 
> > 
> > Maybe we also should take care of the timings of the merging of KVM patches and
> > the test patches?
> 
> I really don't want to hold up KVM-unit-test patches waiting for KVM fixes to be
> merged.  KUT is already woefully under-maintained, artificially holding up patches
> will only make things worse.  And simply waiting for patches to land in KVM doesn't
> necessarily solve things either, e.g. if the fixes land in kvm/master mid-cycle
> then running against kvm/next will continue to fail.  Waiting also doesn't help
> people running KUT against older kernels, e.g. for qualifying stable kernels.
> 
> I completely understand the pain, but unfortunately no one has come up with an
> elegant, low-maintenance solution (this problem has been discussed multiple times
> in the past).

Got it. The pain is still tolerable. 

B.R.
Yu



