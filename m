Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DD16A6AC6
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 11:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCAK1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 05:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCAK13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 05:27:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093182CFFC;
        Wed,  1 Mar 2023 02:27:29 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677666447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qQq8biZFG1TDLuIi5aH3qOfGPTw6u6lFEoiVnltZdKA=;
        b=FiTpyes8Kf88MbUyLK94OyEh6GFvtLuCUMqslQUkMify/af6EzC9E+kZWfhdaBYwvraEV6
        tCTXC/0LIV+l+wVDjsfmMYU7gnwihvisjp0f3hCtTJVGwuHpLrlOJ2srFmvfQs4+BpcXFU
        OIaUQzP6EQsj5PV5h3ybJ7oXojsQQV1rlds5eznGySzvCk58cFHK4dx9NBjwoO0dWGKz72
        pVzQrc7TAcdq7Xqxa/aHyyZkRKJABH/qfLNgC4snCkI8t+iPGtZjk4i5oISttVvwkXx4zo
        fig6iuL0OLoZpLkC0EFg99hSlum4PQYeY2W2IRGW0VOv0t/gqcadLIxtRA5rWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677666447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qQq8biZFG1TDLuIi5aH3qOfGPTw6u6lFEoiVnltZdKA=;
        b=X2WMxLrVW9MdYfnUcgrrGy20QoJi/mVSz5BcnM4oH47ugXxVO4O3T+0GTVBmgfoI8qMUkp
        lfnScbdRYsHez0Bw==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
In-Reply-To: <35264451eabdf967eb31069cb814e8a05ee3179b.camel@infradead.org>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com> <878rghmrn2.ffs@tglx>
 <35264451eabdf967eb31069cb814e8a05ee3179b.camel@infradead.org>
Date:   Wed, 01 Mar 2023 11:27:26 +0100
Message-ID: <87v8jklqb5.ffs@tglx>
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

On Tue, Feb 28 2023 at 21:57, David Woodhouse wrote:
> On Tue, 2023-02-28 at 22:01 +0100, Thomas Gleixner wrote:
> Empirically, yours doesn't boot and Brian's does.

Correct. It was just my sleep deprived brain which got lost in assembly
and #ifdef maze.

On UP per_cpu variables just become regular variables and gdt_page(%rdx)
with %rdx = 0 will just resolve that address.

Sorry for the noise.

Thanks,

        tglx


