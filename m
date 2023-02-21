Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC39F69DE69
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 12:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbjBULGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 06:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjBULGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 06:06:30 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D71D22DC1;
        Tue, 21 Feb 2023 03:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676977589; x=1708513589;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2CjPQ/miNwaYKFFDt9yQwTps+fh10MwgTpKNxPViTwE=;
  b=ac+1NntqHQ8yjBatGK70H/cuYXYqF9aoqRgt2ZFwW4wYsNm00aTVwvua
   57Vr4s7KWpl4QNnQCnVdiyeYDmRBXfT510AMhXk6lxiN0SY7kmZoMLelb
   Sw2Apu2gWnWsr/u//YFPhAnYOIVGaER7Jp6q/pkxeS+EMpvIZA/DDw2OR
   HneDGVfQSM/2Ab5xPGWKeYctu6OeywgP8B3+RvT/7nZUQszQlI+ULleMV
   ZE90pfTTVI6tn+fiA26lqpkiiKEBSO7rVEp+dS3h5nwChSLDaTebXsLyE
   TJ6gS5MglZr0APrrBUG4iWyJIO/GHyrut1OqNylpE761yNo71MJN1oC8k
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="331270069"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="331270069"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 03:06:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="703993147"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="703993147"
Received: from yichaohu-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.208.83])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 03:06:10 -0800
Date:   Tue, 21 Feb 2023 19:06:07 +0800
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
Message-ID: <20230221110607.6wvrgpqip3njrkwu@linux.intel.com>
References: <20230217225449.811957-1-seanjc@google.com>
 <20230217225449.811957-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217225449.811957-3-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you so much, Sean, for such a detailed guidance!

Some questions below:

On Fri, Feb 17, 2023 at 02:54:49PM -0800, Sean Christopherson wrote:
> Add a KVM x86 doc to the subsystem/maintainer handbook section to explain
> how KVM x86 (currently) operates as a sub-subsystem, and to soapbox on
> the rules and expectations for contributing to KVM x86.

It's a fantastic doc! Also, many good requirements can be common in KVM, not
just KVM x86(e.g. the comment, changelog format, the testing requirement
etc.). Could we be greedier to ask our KVM maintainers for a generic handbook
of KVM, and maybe different sections for specific arches, which describe their
specific requirements(the base trees and branches, the maintaining processes
etc.)? :)
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../process/maintainer-handbooks.rst          |   1 +
>  Documentation/process/maintainer-kvm-x86.rst  | 347 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  3 files changed, 349 insertions(+)
>  create mode 100644 Documentation/process/maintainer-kvm-x86.rst
> 
> diff --git a/Documentation/process/maintainer-handbooks.rst b/Documentation/process/maintainer-handbooks.rst
> index d783060b4cc6..d12cbbe2b7df 100644
> --- a/Documentation/process/maintainer-handbooks.rst
> +++ b/Documentation/process/maintainer-handbooks.rst
> @@ -17,3 +17,4 @@ Contents:
>  
>     maintainer-tip
>     maintainer-netdev
> +   maintainer-kvm-x86
> diff --git a/Documentation/process/maintainer-kvm-x86.rst b/Documentation/process/maintainer-kvm-x86.rst
> new file mode 100644
> index 000000000000..ac81a42a32a3
> --- /dev/null
> +++ b/Documentation/process/maintainer-kvm-x86.rst
> @@ -0,0 +1,347 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +KVM x86
> +=======
> +
> +TL;DR
> +-----
> +Testing is mandatory.  Be consistent with established styles and patterns.
> +
> +Trees
> +-----
> +KVM x86 is currently in a transition period from being part of the main KVM
> +tree, to being "just another KVM arch".  As such, KVM x86 is split across the
> +main KVM tree, ``git.kernel.org/pub/scm/virt/kvm/kvm.git``, and a KVM x86
> +specific tree, ``github.com/kvm-x86/linux.git``.

Does other arch also have a specific tree? If a patch series touches multiple
archs(though the chance could be very low), I guess that patch set should still
be based on the main KVM tree? The master branch or the next branch?

...
> +Co-Posting Tests
> +~~~~~~~~~~~~~~~~
> +KVM selftests that are associated with KVM changes, e.g. regression tests for
> +bug fixes, should be posted along with the KVM changes as a single series.
> +
> +KVM-unit-tests should *always* be posted separately.  Tools, e.g. b4 am, don't
> +know that KVM-unit-tests is a separate repository and get confused when patches
> +in a series apply on different trees.  To tie KVM-unit-tests patches back to
> +KVM patches, first post the KVM changes and then provide a lore Link: to the
> +KVM patch/series in the KVM-unit-tests patch(es).

I wonder, for KVM bugzilla to report a bug, or for our QAs to perform regular
tests using KVM selftests/KVM-unit-tests, which tree/branch is more reasonable
to be based on?

E.g., I saw some bugzilla issues earlier, reporting failures of some unit tests,
did some investigation, yet to find those failures were just because the corresponding
KVM patches had not been merged yet. 

Maybe we also should take care of the timings of the merging of KVM patches and
the test patches? Two examples(I'm sure there're more :)): 
1> https://bugzilla.kernel.org/show_bug.cgi?id=216812
2> https://bugzilla.kernel.org/show_bug.cgi?id=216725


B.R.
Yu
