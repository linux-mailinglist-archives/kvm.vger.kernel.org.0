Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B27A6341E6
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiKVQwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiKVQwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:52:15 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A257B70A28;
        Tue, 22 Nov 2022 08:52:12 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669135931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gjmtC/V1IhUMDwLItEi+YzLakaX5z0D3glhq5KpL7n0=;
        b=zL+JREAI54DPIOaCj7r+99hl6Omzz5yTQz4rB9mo3oM7+z4ImloQlObcg3mAH/wze1pnFQ
        Mmt4JKu+KPW9dipD0w5t1oF6L1V/T0tEhOdglZGMY9coDNGWiHcPXgfuFobe8FZIGuaoJ4
        hP9ekFK+RjoBZUImHvClct4h2x4yIekFNv6WEtyeVch04auNBVV1Lu6cSSYz1w+AODwCpf
        7jH9pS9ooKPmdsLU3y8wQ0tD6KDkCt3+ATiUGnL+IG8oiLHhuItTFpKa616Xh56OhYJRWF
        n0XjIs4x55yh0cTX3s/QLbCgqKNsGiCUtVRbTN6YC5GFzxAcJpkMuZtHGYaWMA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669135931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gjmtC/V1IhUMDwLItEi+YzLakaX5z0D3glhq5KpL7n0=;
        b=GbdranQm66ucsOgjrVBBcyt+6Dk3M9qsLoUxUwsiqJSGRQ2y9sZuwXT1O7MXzbIvtgudCs
        WemgrRenS68AWwDw==
To:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
In-Reply-To: <058a6033-a5e0-771b-3c16-950fdbb8c1e5@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3yUdcJjrY2LhUWJ@hirez.programming.kicks-ass.net>
 <058a6033-a5e0-771b-3c16-950fdbb8c1e5@intel.com>
Date:   Tue, 22 Nov 2022 17:52:10 +0100
Message-ID: <87tu2rextx.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22 2022 at 07:20, Dave Hansen wrote:
> On 11/22/22 01:20, Peter Zijlstra wrote:
>> Either the Changelog is broken or this TDX crud is worse crap than I
>> thought possible, because the only way to actually meet that requirement
>> as stated is stop_machine().
>
> I think the changelog is broken.  I don't see anything in the TDX module
> spec about "the SEMACALL can run concurrently on different CPUs".
> Shutdown, as far as I can tell, just requires that the shutdown seamcall
> be run once on each CPU.  Concurrency and ordering don't seem to matter
> at all.

You're right. The 'can concurrently run' thing is for LP.INIT:

4.2.2.
 LP-Scope Initialization: TDH.SYS.LP.INIT

  TDH.SYS.LP.INIT is intended to perform LP-scope, core-scope and
  package-scope initialization of the Intel TDX module. It can be called
  only after TDH.SYS.INIT completes successfully, and it can run
  concurrently on multiple LPs.

