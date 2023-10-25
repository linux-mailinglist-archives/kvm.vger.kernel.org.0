Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37327D7096
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbjJYPQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbjJYPQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:16:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6440A128;
        Wed, 25 Oct 2023 08:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698246978; x=1729782978;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m+Ej6NHPrhm+wYMnczhpaBZL2+SGa4xutIPZCENtxjw=;
  b=WItkXpwDxMTZCDHl9I12MvKKmI9dCDAIOZh/PDZO0oFwSpFFl32mKfVE
   LkR+UuLOxT3PIPK4JVo711o9hA/MU5idD4sR2W1FUmTR5/hajSr9w4Btz
   5IJN2X1RDDJ59eAOcJD9chCXVWBjTQS+670mkwrjawLGU9DYBL2f6gmU7
   Pr8MdgrlfXSU06McI5EXYcOwHqP8bgELoh8oWrvxzm1jWUnsoP/azXvy7
   yhvbvJUWA4xe195shtEivXLMvjrCRh2lP15kdybWxr31GqQ7IwURrB+ZN
   h8O7cSRWWxVOMeVY6c8L0uG+aGzQDXbfrrg02z5lhFTZUk5vtpNsHdtxz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="377695015"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="377695015"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 08:15:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="875541085"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="875541085"
Received: from mhans-mobl3.amr.corp.intel.com (HELO desk) ([10.252.132.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 08:15:54 -0700
Date:   Wed, 25 Oct 2023 08:15:46 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  v2 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20231025151546.dwnlovtbjurqvjsw@desk>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-6-f1881340c807@linux.intel.com>
 <ZTjIGVE3o4K7O9kW@chao-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTjIGVE3o4K7O9kW@chao-email>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 03:47:37PM +0800, Chao Gao wrote:
> >diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> >index b3b13ec04bac..c566035938cc 100644
> >--- a/arch/x86/kvm/vmx/vmenter.S
> >+++ b/arch/x86/kvm/vmx/vmenter.S
> >@@ -1,6 +1,7 @@
> > /* SPDX-License-Identifier: GPL-2.0 */
> > #include <linux/linkage.h>
> > #include <asm/asm.h>
> >+#include <asm/segment.h>
> 
> This header is already included a few lines below:

Thanks, will remove it.
