Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25A770D13B
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 04:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjEWCaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 22:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbjEWC34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 22:29:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC36CA;
        Mon, 22 May 2023 19:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684808994; x=1716344994;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=+gDiLZPsuz1kelUJx+GgjjhllFg4WBajJIGyW+kQs+c=;
  b=OAhS4r/RqIGAAge4fBXGjYNHrJ8yFUgYvVxaqm0cmYhpZG5SfKoYu1Vu
   4npKjVZku2wXL3OFKHaga0A2EurhHCAOUBgEyu+NrQh+dHsMBwfOlqXD8
   4UfZsy0R2++ysVBrPLFCmVqYIHwcKEGSPxgivRFYBuKRqreHF7f3z1xlB
   lOKNgiwa6bfnFrPXwb/ykw+vBRG3UVBzF52kbj09Sq7XKUSodVbiAhT54
   9Fa3Lwc5XsHaP5y8cSTmocDTOOtF6I/rQxpgxZEvygzrOj8vSq1blClWW
   Wn6Ey9IxT4X1EKFBNVVYgo9FKY3itDLdJXAB2xWq2xHyrsetO84vkXSW0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="353131976"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="353131976"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 19:29:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="1033863646"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="1033863646"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.192.139])
  by fmsmga005.fm.intel.com with ESMTP; 22 May 2023 19:29:42 -0700
Date:   Tue, 23 May 2023 10:19:58 +0800
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
Message-ID: <20230523021958.GA346459@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20230512231026.799267-1-seanjc@google.com>
 <20230522072508.GA326851@chaop.bj.intel.com>
 <ZGwDs1qHcl8PX+m2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGwDs1qHcl8PX+m2@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... 
> > > To kick things off, I am leaning toward a "launch" date of May 24th (Pacific),
> > > with KVM guest private mem (a.k.a. UPM) as the first topic.
> > 
> > Thanks for driving this, yes for UPM I would definitely join.
> 
> I'm going to push out the inagaural date one week until May 31st, partly to give
> more time for this to get widely disseminated, but mostly because I need to write
> down my various thoughts on where to go with UPM, and I don't think I'll get that
> done before Wednesday.  That'll also give me time to setup a public calendar so
> that people can get reminders and whatnot.

That looks good to me.

Chao
