Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05590633FD4
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbiKVPGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 10:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiKVPG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 10:06:28 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA462E5;
        Tue, 22 Nov 2022 07:06:27 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669129585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jgAMdI+izwDeEvpgX4m0VI03W8NKclkKP90RLZ9WIgA=;
        b=1+tAieLZ/HZeaJFKtaHw4vi1gZimlzue2u9cqJzeYDjmsND6FbuFRnsrDHMvqStd36WDQ5
        zdowaOcylQk455fJ8gN2mYKy7pFOIAxFF95RqMT8yTAwNFC6fSK4IwhbQZveqN6smCI1AF
        hErxnuE2xff4VQHXbS3FOhYgbu4ynarw8Tk5xxHgMQ7x/+i8dFEGuASdL5vwujgHwe+ifr
        lt6gA1frFaTT7rmGpRAq/CRtNld78MLdVjyWihZJYmfuwkF04TMWB4QcgpzaOA9WO0v1++
        hNeq4/cElSkc6ZLN2S2IHkEcXyLaoba4w/8ynTHUHZWq10sDQ2f0zv+e0ytxLA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669129585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jgAMdI+izwDeEvpgX4m0VI03W8NKclkKP90RLZ9WIgA=;
        b=BOGG+iOwzQCE8G/W4MRT93mk1FQyIcC0bvXLAIXGPpJZzsusE/JeB0Bpc5TtS53cfoLwQZ
        66AGLC1EvkM65rAw==
To:     Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
In-Reply-To: <Y3yUdcJjrY2LhUWJ@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3yUdcJjrY2LhUWJ@hirez.programming.kicks-ass.net>
Date:   Tue, 22 Nov 2022 16:06:25 +0100
Message-ID: <87bkozgham.ffs@tglx>
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

On Tue, Nov 22 2022 at 10:20, Peter Zijlstra wrote:

> On Mon, Nov 21, 2022 at 01:26:28PM +1300, Kai Huang wrote:
>
>> Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
>> BIOS-enabled CPUs, and the SEMACALL can run concurrently on different
>> CPUs.  Implement a mechanism to run SEAMCALL concurrently on all online
>> CPUs and use it to shut down the module.  Later logical-cpu scope module
>> initialization will use it too.
>
> Uhh, those requirements ^ are not met by this:

  Can run concurrently != Must run concurrently
 
The documentation clearly says "can run concurrently" as quoted above.

Thanks,

        tglx
