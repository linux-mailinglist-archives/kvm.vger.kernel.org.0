Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C34695894
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjBNFiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBNFiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:38:22 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D68CC36
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 21:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676353101; x=1707889101;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kd61GRuiaqTcbcDmasZ8IPrbV05dRwfeIxltOtplEhQ=;
  b=G+PKZ9OprPdDFiMwACGAbrifVMs6RTW21xafsxroovJKtuar52mYNs1+
   eB08ROtp11nbgkfBxactLEXlmig6v8lLNLh7+vnJDWHFqItseG5kyDb0Y
   tpMbE8wCnUgff3gpuZc7PXrsS5ootkpZYe5yt5+mU5MrQzLS+9jj3dLT/
   oNN7SKzjxzja+JkW099WvJeMr2QVlzpyftFKI3GZfDVr+Co2TyjetTKSr
   HYo3wLL2mB73+fGW4kWUDQJ2p8cBIt7qRJtCAzSPHsWbhpIryVhx+rd6E
   uNLWsVRBqHf6055JT3YdyKHhK9bkrT5ybzT2p21Z5kC7eEIzinj45tq5w
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="328789090"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="328789090"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 21:38:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="914612271"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="914612271"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Feb 2023 21:38:19 -0800
Message-ID: <9f0cd04173a2c5939a23722841091c1f89c0f95b.camel@linux.intel.com>
Subject: Re: [PATCH v4 8/9] KVM: x86: emulation: Apply LAM when emulating
 data access
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Tue, 14 Feb 2023 13:38:18 +0800
In-Reply-To: <Y+m0QToEqlqQz/ba@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-9-robert.hu@linux.intel.com>
         <Y+m0QToEqlqQz/ba@gao-cwp>
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

On Mon, 2023-02-13 at 11:53 +0800, Chao Gao wrote:
> On Thu, Feb 09, 2023 at 10:40:21AM +0800, Robert Hoo wrote:
> > When in KVM emulation, calculated a LA for data access, apply LAM
> > if
> > guest is at that moment LAM active, so that the following canonical
> > check
> > can pass.
> 
> This sounds weird. Passing the canonical checking isn't the goal.
> Emulating
> the behavior of a LAM-capable processor on memory accesses is.
> 
Emm, how about describe like this:
In KVM emulation, apply LAM rule for linear address calculated, (data
access only), i.e. clear possible meta data in LA, before doing
canonical check.

> > +#ifdef CONFIG_X86_64
> > +static inline bool is_lam_active(struct kvm_vcpu *vcpu)
> 
> Drop this function because kvm_untagged_addr() already does these
> checks
> (and taking user/supervisor pointers into consideration).
> 
OK

