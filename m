Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787AB652D91
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 09:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbiLUIC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 03:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiLUIC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 03:02:27 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEEB15F3B
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 00:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671609747; x=1703145747;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4aY/8dBQDtJ9YtIUkt9xKGtXzGkGmI09FQe1hs6E6EU=;
  b=EQ7G39rIkZ2+unxSeeZhs+9uJpLDJxovjI5wnKedT2Ai3gpZwEJfLhDq
   wwZDkq4zia254Hsyj7mMsVT/FBM/9SQz3Pf4mAP6Eg8S++37p+CVA8VgT
   DQQVrvSw4t7j9fhNpwPESMfT7ocNDpBGGlm+0zFyIQ5Q8oHpF3lrB4fUf
   luvGWr2lCBGy0znOs0FKEPsPWB/qGV8yRbhjt2NGBZRQCsdEFs6tD/vuc
   KyMV/spISubytNbiZ+yzam5mkI9KbJEOBblRSXca5IFQJlsrfDJronxQO
   /RlJK0l3ks8/zV62glRYId8U/Qwky2ECimQxPQ5oscmGdMVHsJBIZ5ewl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="382040374"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="382040374"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:02:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="629030700"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="629030700"
Received: from xruan5-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.29.248])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:02:21 -0800
Date:   Wed, 21 Dec 2022 16:02:22 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221221080222.ohsk6mcqvq5z4t3t@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221219094511.boo7iththyps565z@yy-desk-7060>
 <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Emm, I take a look at the callers, looks like they're segment registers
> and MSRs. Per spec (ISE 10.4): processors that support LAM continue to
> require the addresses written to control registers or MSRs be legacy
> canonical. So, like the handling on your last commented point on this
> patch, such situation needs no changes, i.e. legacy canonical still
> applied.
> 
Well, it's not about the control register or MSR emulation. It is about
the instruction decoder, which may encounter an instruction with a memory
operand with LAM bits occupied. 

B.R.
Yu
