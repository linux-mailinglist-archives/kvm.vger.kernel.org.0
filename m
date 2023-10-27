Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619367D9B45
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 16:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345923AbjJ0OYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 10:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345837AbjJ0OYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 10:24:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA23C0;
        Fri, 27 Oct 2023 07:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698416657; x=1729952657;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o9q69zntTngL5HlC4Hh3ir1Xj+G9xs29J6LfyeT2YVE=;
  b=S04xkgS1o0S/3D6Ui/IF7EaSrpjhB9bUFjZCoABnPgKphjTe1xxQcSif
   gjgjMj0wXdEJJCcBrcEzZNluEMuas1O3859OqYN0W7Duzf+ycXkwA0Ulo
   VUIzB6bsmQulM6Prorgsxvm4wP5jVLBmb3pkBIPmlXunwZGdh+7ogD3nF
   uGRbgX832vI60QU6FgPBzUWUgC2rNSkzf0N/euC+uUMwRYupuTxLnALZD
   qSIBD5KnqzONnrAgvnTCrtuZCh2X1dZVfbhwk69kXZC7dOt7ewPviMtoB
   9U+fLLrFFeMN1AO1l3DhpOAcsRr2TEafrooVLWpB60nThp954yuHic/2T
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="6407079"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="6407079"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 07:24:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="788837975"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="788837975"
Received: from dmnassar-mobl.amr.corp.intel.com (HELO desk) ([10.212.203.39])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 07:24:08 -0700
Date:   Fri, 27 Oct 2023 07:24:07 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
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
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH v3 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231027142407.5yb44shspokmis65@desk>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-1-52663677ee35@linux.intel.com>
 <8b6d857f-cbf6-4969-8285-f90254bdafc0@citrix.com>
 <20231025220735.gpopnng76klkbuu3@desk>
 <0ee3e3cd-01b2-4662-ba08-d137663f1699@citrix.com>
 <20231027134829.7ehdjwf5pfcqr6xp@desk>
 <cecd13f6-6d46-4a88-a30b-ce244d8fcd80@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cecd13f6-6d46-4a88-a30b-ce244d8fcd80@citrix.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 27, 2023 at 03:12:45PM +0100, Andrew Cooper wrote:
> Almost as if it's a good idea to follow the advice of the Optimisation
> Guide on mixing code and data, which is "don't".

Thanks a lot Andrew and Peter for shepherding me this way.
