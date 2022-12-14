Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B55B64D1C0
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 22:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiLNVZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 16:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiLNVZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 16:25:26 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2F63722B;
        Wed, 14 Dec 2022 13:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671053122; x=1702589122;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gXLE+mSz9Ky8I8FcVZY8tiBfQ6uUmNqDpsoYD6oEPHo=;
  b=Mf/y0Rjsv0kY3z1R/3EH72tvzIbNmgPVUaMuczsJgrAV3QNKG3e+XA8L
   iXpmyf39KrI2EcEfwXyy9JsDbnmlF3+Lw5mHNl6LNnPAKELMHviehkWvc
   cOUfqzQwA5JiD3OccvDSTGcRH1YP/MIUcI0PmNwW5kMgqTu6AZXsz9gTk
   OWqUtfIRn9AVR6/OQVyHsoFlHyX3txtWhQtaVokL4G2n2ZqH534UvTzIo
   cZV6cyTfRFdX2NZmWBVbUeJPYvvznYsqB9jt108ss0Ofi9uSTs2H6RVIO
   CvWooKxCXnGDsY/H0HQ3Fme+80aIS9Qy1xGAdKoqkKP8k60PpNC/pAU69
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="316153726"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="316153726"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 13:25:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="737832125"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="737832125"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Dec 2022 13:25:21 -0800
Date:   Wed, 14 Dec 2022 13:33:35 -0800
From:   Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To:     Zhang Chen <chen.zhang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 2/9] KVM: x86: Add a kvm-only leaf for RRSBA_CTRL
Message-ID: <20221214213335.GB16072@ranerica-svr.sc.intel.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-3-chen.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210160046.2608762-3-chen.zhang@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 11, 2022 at 12:00:39AM +0800, Zhang Chen wrote:
> KVM needs to check if guests can see RRSBA_CTRL. If a guest is using
> retpoline and cannot see RRSBA_CTRL and the host enumerates RRSBA,
> KVM is responsible for setting RRSBA_DIS_S for the guest.
> 
> This allows VM migration from parts doesn't enumerates RRSBA to those

perhaps s/parts doesn't enumerates/parts that do not enumerate/ reads
better?

> that enumerate RRSBA.

and here maybe s/that enumerate RRSBA/do/ ?

Thanks and BR,
Ricardo
