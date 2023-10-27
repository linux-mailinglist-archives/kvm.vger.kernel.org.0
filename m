Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601137D9A5F
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 15:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345997AbjJ0Nsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 09:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345458AbjJ0Nse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 09:48:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31E818A;
        Fri, 27 Oct 2023 06:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698414512; x=1729950512;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FT3SYkcDyStolkfc5gH/ZZusESEYmy+fhjCdCEwgFao=;
  b=m+NrMq5x8XTO8B+y5VFoGpoFawbGMxON/uXoytD3lQz+q37nH29B8WNw
   gT8vZRZYo3r0Ya4bOdfkv003Z5uMLE2+WWz+DztOzqPln7dg+WEsBUM6i
   8IUzagthItg5fclMLZUb0Bnb6UHTodX6LvjY6dNawgeB4atNH+4oftbl3
   pger6YfOtxbJKMfmj9UHGNF9mY4cAGlVeoaocfqgP1tcTVNby0L+Lvenl
   1+/d4GM5sQ5gZaL5ddgbnAPwzdcniYuaIu6IUmqlaY7bMJv5AMCIVAE0V
   aDavWdX8lQRT+eJy5qGW+0t1VvWregmm/4l3UAFxOcdCKMYK/UZAq3TAS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="384983499"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="384983499"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 06:48:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="838066"
Received: from dmnassar-mobl.amr.corp.intel.com (HELO desk) ([10.212.203.39])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 06:48:19 -0700
Date:   Fri, 27 Oct 2023 06:48:29 -0700
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
Message-ID: <20231027134829.7ehdjwf5pfcqr6xp@desk>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-1-52663677ee35@linux.intel.com>
 <8b6d857f-cbf6-4969-8285-f90254bdafc0@citrix.com>
 <20231025220735.gpopnng76klkbuu3@desk>
 <0ee3e3cd-01b2-4662-ba08-d137663f1699@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ee3e3cd-01b2-4662-ba08-d137663f1699@citrix.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 11:13:46PM +0100, Andrew Cooper wrote:
> On 25/10/2023 11:07 pm, Pawan Gupta wrote:
> > On Wed, Oct 25, 2023 at 10:10:41PM +0100, Andrew Cooper wrote:
> >>> +.align L1_CACHE_BYTES, 0xcc
> >>> +SYM_CODE_START_NOALIGN(mds_verw_sel)
> >>> +	UNWIND_HINT_UNDEFINED
> >>> +	ANNOTATE_NOENDBR
> >>> +	.word __KERNEL_DS
> >> You need another .align here.  Otherwise subsequent code will still
> >> start in this cacheline and defeat the purpose of trying to keep it
> >> separate.
> > Right.
> >
> >>> +SYM_CODE_END(mds_verw_sel);
> >> Thinking about it, should this really be CODE and not a data entry?
> > Would that require adding a data equivalent of .entry.text and update
> > KPTI to keep it mapped? Or is there an easier option?
> 
> Leave it right here in .entry.text , but try using SYM_DATA() and
> friends.  See whether objtool vomits over the result or not.

objtool still complaints when using SYM_DATA*() without the annotations:

 vmlinux.o: warning: objtool: mds_verw_sel+0x0: unreachable instruction
 vmlinux.o: warning: objtool: .altinstr_replacement+0x2c: relocation to !ENDBR: mds_verw_sel+0x0

> And if objtool does vomit over the result, then leaving it as it is in
> this patch with SYM_CODE() is good enough.

Settling with SYM_CODE().

On the bright-side, I am seeing even better perf with VERW operand
out-of-line:

Baseline: v6.6-rc5

| Test               | Configuration          | v1   | v3   |
| ------------------ | ---------------------- | ---- | ---- |
| build-linux-kernel | defconfig              | 1.00 | 1.00 |
| hackbench          | 32 - Process           | 1.02 | 1.06 |
| nginx              | Short Connection - 500 | 1.01 | 1.04 |

Disclaimer: These are collected by a stupid dev who knows nothing about
perf, please take this with a grain of salt.

I will be sending v4 soon.
