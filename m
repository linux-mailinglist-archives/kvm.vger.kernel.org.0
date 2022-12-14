Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB27A64C89C
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 13:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiLNMBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 07:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbiLNMBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 07:01:12 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142F320F74;
        Wed, 14 Dec 2022 04:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671019268; x=1702555268;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fuR/7HxR7Oiga7wEFtKODLYaZ2RDSEctAuCeIpD5vCU=;
  b=b6K29/nlwWJ+8aMkzClXeaWPJH9XfeRQssvjkJ+I+0uYVKl9MiVR8cMy
   V00EyhNUuUNmFppUkkevxicllCjXJRCEEDsMNltn9WD8G1i4didqozZ0O
   d6AITGVq6Ws1zoOBTqst5JVAgO8FAbJkpkheJuIp/fRr6tkC8u/ZszPlX
   /vGt+/7YRLrUDtc27Eb6nWOaNDJKW7i8wSZCONO57PwcAKg6mSzS5Zb/i
   OaKFJ5+B2ktymPIautYqIbGcBFFMXCcVBN9IIi2F7o4O07MjPMfA4veyt
   20PDv5wq2Lyj5QAHvcjfhWyErgNisYO9CQVTa6ZW86AocIohryUcUKFTl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="380587779"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="380587779"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 04:01:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="717590085"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="717590085"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2022 04:01:05 -0800
Message-ID: <acb8adfc5a2ace34010dc70d5ccd2821ff0a1ecb.camel@linux.intel.com>
Subject: Re: [PATCH 0/5] KVM: x86/mmu: TDP MMU fixes for 6.2
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Date:   Wed, 14 Dec 2022 20:01:04 +0800
In-Reply-To: <20221213033030.83345-1-seanjc@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
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

On Tue, 2022-12-13 at 03:30 +0000, Sean Christopherson wrote:
> Fix three fatal TDP MMU bugs introduced in 6.2,

introduced in 6.1? or earlier?

>  harden related code,
> and clean up kvm_tdp_mmu_map() to eliminate the need for gotos.
> 
> Sean Christopherson (5):
>   KVM: x86/mmu: Don't attempt to map leaf if target TDP MMU SPTE is
>     frozen
>   KVM: x86/mmu: Map TDP MMU leaf SPTE iff target level is reached
>   KVM: x86/mmu: Re-check under lock that TDP MMU SP hugepage is
>     disallowed
>   KVM: x86/mmu: Don't install TDP MMU SPTE if SP has unexpected level
>   KVM: x86/mmu: Move kvm_tdp_mmu_map()'s prolog and epilog to its
> caller
> 
>  arch/x86/kvm/mmu/mmu.c          |  9 +++++++-
>  arch/x86/kvm/mmu/mmu_internal.h |  1 -
>  arch/x86/kvm/mmu/tdp_mmu.c      | 39 +++++++++++++++--------------
> ----
>  3 files changed, 26 insertions(+), 23 deletions(-)
> 
> 
> base-commit: 51229fd7872f82af07498aef5c79ad51baf81ea0

I cannot find this base commit in my tree, where I just pulled to
latest queue yesterday. But find this series can be applied to this
latest queue as well.

commit 9d75a3251adfbcf444681474511b58042a364863 (origin/queue, queue)
Author: Sean Christopherson <seanjc@google.com>
Date:   Wed Dec 7 00:09:59 2022 +0000

    KVM: x86: Add proper ReST tables for userspace MSR exits/flags

