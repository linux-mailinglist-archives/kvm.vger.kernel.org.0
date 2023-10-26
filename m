Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D372C7D88EA
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 21:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjJZT34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 15:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJZT3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 15:29:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFAE12A;
        Thu, 26 Oct 2023 12:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698348593; x=1729884593;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=UCuF++K/DRoYTSz+IUQsOAUxD4trrlqrqUJab+FeXUc=;
  b=lvB9t1jTzntGOLg5FsK4AcCwwoZKKAlW39xA6KwLArqpWxF0PAb8g9ky
   BMrU467sV+5dLK/5O2qhWDTaZZJevIXswOyvn5dpVQB9hs4RROPF+yWid
   Ug5cFjTOFhw9fLcdKvHZvHxcjPHRjvMTn3wJBIG2YPjEPxgEx2UKP5spq
   OQEA2V243vxWfV2tiBtMBnGG7oizYWFGuiqNtphH/pEICe/mkktRakZzV
   xVA20KsyE4dbJC5Yd3K1eW+Kg/ojxoOU4/Wo9NSJ7ooxgPn3wwldUmFvP
   HIfEYR2OcZ9p+YeDFICXsWQ2C2QCH1FNtZGNZfvCFTxuW6/Pxfm7S1xpw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="425274"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="425274"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 12:29:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="752860578"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="752860578"
Received: from paseron-mobl4.amr.corp.intel.com (HELO desk) ([10.209.17.113])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 12:29:51 -0700
Date:   Thu, 26 Oct 2023 12:29:50 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Nikolay Borisov <nik.borisov@suse.com>
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
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3 2/6] x86/entry_64: Add VERW just before userspace
 transition
Message-ID: <20231026192950.ylzc66f3f5naqvjv@desk>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-2-52663677ee35@linux.intel.com>
 <2cda7e85-aa75-4257-864d-0092b3339e0e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2cda7e85-aa75-4257-864d-0092b3339e0e@suse.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 07:25:27PM +0300, Nikolay Borisov wrote:
> 
> 
> On 25.10.23 г. 23:52 ч., Pawan Gupta wrote:
> 
> <snip>
> 
> > @@ -1520,6 +1530,7 @@ SYM_CODE_START(ignore_sysret)
> >   	UNWIND_HINT_END_OF_STACK
> >   	ENDBR
> >   	mov	$-ENOSYS, %eax
> > +	CLEAR_CPU_BUFFERS
> 
> nit: Just out of curiosity is it really needed in this case or it's doesn
> for the sake of uniformity so that all ring3 transitions are indeed
> covered??

Interrupts returning to kernel don't clear the CPU buffers. I believe
interrupts will be enabled here, and getting an interrupt here could
leak the data that interrupt touched.
