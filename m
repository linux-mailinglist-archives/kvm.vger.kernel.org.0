Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6F54F8AC3
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiDGWzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 18:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiDGWzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 18:55:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A0B16BF51;
        Thu,  7 Apr 2022 15:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649371996; x=1680907996;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5d1RarmXrWSkAaZMLy3cBZ62eTcBy7+tNhk8kPDmHfc=;
  b=f8YVBDmbGnsVN2Xi+OZAtfa/aokXkwvdqvrn7VaiG5gS3EitLBzmzJIR
   zXRfvZL38qHa16wnWxU0YfPZDDzUPDq8YGG2NXNDDvbfEOgkzcmH46nqI
   mgdppNGO8wv4bR5I6lEOYP3yGxXYaQk5C23eW9U8GeOOxG8WbfKYKQkQZ
   pICCufGJC+1547mVMMdKY1raCrlaNr/i7BTU+Nu4fmNWNEPIG++bI5KCX
   JmOTNtgQizUlRUPPZY6QstZuI26Idm2qu7XNXnf1/FVAlrxs2Y1qln81V
   02HpP9536kffLhnu3zqEuScpx9iY0XXYjUEFysN/HCT2egJB9TZHD54X9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="324621145"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="324621145"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 15:53:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="642672400"
Received: from asaini1-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.28.162])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 15:53:13 -0700
Message-ID: <05b1d51b69f14bb794024f13ef4703ad1c888717.camel@intel.com>
Subject: Re: [RFC PATCH v5 047/104] KVM: x86/mmu: add a private pointer to
 struct kvm_mmu_page
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 08 Apr 2022 10:53:11 +1200
In-Reply-To: <ec5ffd8b-acc6-a529-6241-ad96a6cf2f88@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <499d1fd01b0d1d9a8b46a55bb863afd0c76f1111.1646422845.git.isaku.yamahata@intel.com>
         <a439dc1542539340e845d177be911c065a4e8d97.camel@intel.com>
         <ec5ffd8b-acc6-a529-6241-ad96a6cf2f88@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-07 at 15:52 +0200, Paolo Bonzini wrote:
> On 4/7/22 01:43, Kai Huang wrote:
> > > +	if (kvm_gfn_stolen_mask(vcpu->kvm)) {
> > Please get rid of kvm_gfn_stolen_mask().
> > 
> 
> Kai, please follow the other reviews that I have posted in the last few 
> days.
> 
> Paolo
> 

Do you mean below reply?

"I think use of kvm_gfn_stolen_mask() should be minimized anyway.  I 
would rename it to to kvm_{gfn,gpa}_private_mask and not return bool."

I also mean we should not use kvm_gfn_stolen_mask().  I don't have opinion on
the new name.  Perhaps kvm_is_protected_vm() is my preference though.


