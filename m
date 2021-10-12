Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDDC42ACDF
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 21:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhJLTDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 15:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbhJLTDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 15:03:49 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5A4C061570;
        Tue, 12 Oct 2021 12:01:47 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634065305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8EAfydLYU8TnGK7IP9Kc1a4tRPN4kDHVt2nFY9Fm4VE=;
        b=kmo7wJIJXVoCs5UgL6aWN93XoLd9SzvY/F9cnocb9hJomLiv+JkzJQNHUGYlaV2cnaG+y1
        dN1O14o6V/e9ltkL+j1qg+k7Ca7BsPJyeEd/EQJgXicyapjknbUGOAgscsUoX9e3/LZ/Q3
        UNJtb+9Yf5dR03xGKDtzkpAtaI4vEmLqQZPY1jm2HFRQ7E9LGO8MtHcwXeCgACW4XAbqkJ
        toUcYSr1fUb6djBi+Zhy/QRmmyyeBagvokKLjIZ33nZIMR8338ezelmsmWWIYxKjs6+ehS
        XPetF4usYvi/iFKvkx8GIvKr5Lu/ofLt35cnzCYWIRBk0LCDVatHgOzMntmRsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634065305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8EAfydLYU8TnGK7IP9Kc1a4tRPN4kDHVt2nFY9Fm4VE=;
        b=Oha5IuykSd6BsVn7tpKl5kTXNZtcVn0vCtzUUw5Ygtep/6NuAUOYcGapfr1kE7GdUTVHrN
        QNgedNHnE9DwfoCg==
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 09/31] x86/fpu: Do not inherit FPU context for CLONE_THREAD
In-Reply-To: <87tuhm9it4.ffs@tglx>
References: <20211011215813.558681373@linutronix.de>
 <20211011223610.828296394@linutronix.de> <YWWzgO9Vn6XlNsLP@zn.tnic>
 <87tuhm9it4.ffs@tglx>
Date:   Tue, 12 Oct 2021 21:01:45 +0200
Message-ID: <87r1cq9iee.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12 2021 at 20:52, Thomas Gleixner wrote:

> On Tue, Oct 12 2021 at 18:10, Borislav Petkov wrote:
>
>> On Tue, Oct 12, 2021 at 02:00:11AM +0200, Thomas Gleixner wrote:
>>> CLONE_THREAD does not have the guarantee of a true fork to inherit all
>>> state. Especially the FPU state is meaningless for CLONE_THREAD.
>>> 
>>> Just wipe out the minimal required state so restore on return to user space
>>> let's the thread start with a clean FPU.
>>
>> This sentence reads weird, needs massaging.
>
> The patch is wrong and needs to be removed. I just double checked
> pthread_create() again and it says:
>
> The new thread inherits the calling thread's floating-point environment
> (fenv(3))
>
> No idea where I was looking at a few days ago. :(

But fenv(3) is not the FPU state. Duh!

Anyway. It's an optimization which we can do later still and not
required for the cleanups here.

Thanks,

        tglx
