Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD23652207
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbiLTOIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiLTOIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:08:12 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417771B1EF
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671545290; x=1703081290;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=46IEfA9CHfupYJmZ16swUYpob8Lm2zcchM1Yq9bHK/8=;
  b=juj/f66ZCV3jGf0kRf+qLokkNZYw1P4A2O94k04eb6H601MuEo8U9gLx
   HPoC07jjaX3dwTxpNK8muzK6zm+rNR3A+ULKpgLPYemvCAbUzJBjb7tCB
   w7jYzrCbiVhkla6QbR/lHXgWkNbeLIoNIqgm9fMMJfp3xJQxYW9dhsASb
   5aBSFW4nW0IwHUmXdO4oqXrrKrDo25NGg7dqprtK4i8LAoBOG6onTYJfj
   NprkHpR0v0mEWCT8enhB/yVkRzBGSckQhKAAwtWZpVT14RY/ifMDJeSN7
   Dhak4ioNHfM/+9uaZgvwLKItI6my52Usk78efBS/Uv0tgXHdNQIqhaLaR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299961815"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="299961815"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 06:08:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="714447360"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="714447360"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2022 06:07:57 -0800
Message-ID: <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Date:   Tue, 20 Dec 2022 22:07:57 +0800
In-Reply-To: <20221219094511.boo7iththyps565z@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-7-robert.hu@linux.intel.com>
         <20221219094511.boo7iththyps565z@yy-desk-7060>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-12-19 at 17:45 +0800, Yuan Yao wrote:
> On Fri, Dec 09, 2022 at 12:45:54PM +0800, Robert Hoo wrote:
> > Define kvm_untagged_addr() per LAM feature spec: Address high bits
> > are sign
> > extended, from highest effective address bit.
> > Note that LAM_U48 and LA57 has some effective bits overlap. This
> > patch
> > gives a WARN() on that case.
> > 
> > Now the only applicable possible case that addresses passed down
> > from VM
> > with LAM bits is those for MPX MSRs.
> 
> How about the instruction emulation case ? e.g. KVM on behalf of CPU
> to do linear address accessing ? In this case the kvm_untagged_addr()
> should also be used to mask out the linear address, otherwise
> unexpected
> #GP(or other exception) will be injected into guest.
> 
> Please see all callers of __is_canonical_address()
> 
Emm, I take a look at the callers, looks like they're segment registers
and MSRs. Per spec (ISE 10.4): processors that support LAM continue to
require the addresses written to control registers or MSRs be legacy
canonical. So, like the handling on your last commented point on this
patch, such situation needs no changes, i.e. legacy canonical still
applied.

