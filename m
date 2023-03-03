Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B47E6A8FDC
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 04:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCCDXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 22:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCCDXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 22:23:15 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2352BFF04
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 19:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677813794; x=1709349794;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gbVdoBjYZB+kPDDeCQ91u4V+gypkPwoAoqtMvne60Uw=;
  b=E8Eh2p3bUrcdzVKl/coj9N0a6aMgksKdaDm7tgMBbeKvQERZn7nNNpho
   XEiZIfdhX+g+quqvfrKOYZMJf0+Zwjz1Itrsp0RyBBmtF9qwwt99PHbKx
   KX+fCFwFGo0T8LdVSIqQQqN8ca3YpYY7bpE/61YQv9NETgegwJ18xq+uA
   I8cmDKMUls4drcGPztTaMtCItjlW6ozq+gUQkAgj0DtECc26qCcwlmd+r
   i64Pzshvk7GY1Qp5tz8FqexSXTjEig7ffud79XWoLhsQ4YTAsp0oI38Lg
   ecldzklNb/imtVocy8na8RvSn6whxuYb4Y+2Bvmqn9+ZWh0y18qo5p+Qh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="337256219"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="337256219"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 19:23:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="707681860"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="707681860"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 02 Mar 2023 19:23:11 -0800
Message-ID: <9db9bd3a2ade8c436a8b9ab6f61ee8dafa2e072a.camel@linux.intel.com>
Subject: Re: [PATCH v5 2/5] [Trivial]KVM: x86: Explicitly cast ulong to bool
 in kvm_set_cr3()
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com,
        kvm@vger.kernel.org
Date:   Fri, 03 Mar 2023 11:23:11 +0800
In-Reply-To: <ZABPFII40v1nQ2EV@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
         <20230227084547.404871-3-robert.hu@linux.intel.com>
         <ZABPFII40v1nQ2EV@gao-cwp>
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

On Thu, 2023-03-02 at 15:24 +0800, Chao Gao wrote:
> > -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > 
> > 	if (pcid_enabled) {
> > 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> 
> pcid_enabled is used only once. You can drop it, i.e.,
> 
> 	if (kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)) {
> 
Emm, that's actually another point.
Though I won't object so, wouldn't this be compiler optimized?

And my point was: honor bool type, though in C implemention it's 0 and
!0, it has its own type value: true, false.
Implicit type casting always isn't good habit.

