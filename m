Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5000E42AC99
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 20:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhJLSzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 14:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbhJLSzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 14:55:00 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324EEC061570;
        Tue, 12 Oct 2021 11:52:58 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634064776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QlKCFEGnLo/IAL16FG94d9Hqx69oGFiZJmrGdarrPw8=;
        b=IRPYEUMVvJBA57RbMqlKjooWujc2r5iXaDlfnCQbGKhEKb6ruiO5oAM1lC5TINGNw+aZz/
        Ws2OVVJS4H2KwegMKycpmBEoxjBF9g+BZDeQoCEv8MZ1ri5gIFZip8IXGZ8Sx0X+wqz4Z+
        4sSfTavqwOURyhDCWY6P2oZtGEAv551AyR08uC9yKZM1oVDlgdnDvfDGJCViafMxZqBWbQ
        C+Rm//KrtW+/TyYEIU77oHrhyQNMv2z1KVjXDMLWqkE9EIT/fG/1Fo+d4fiYaMN/gs1cbG
        XbAMIa69qkgiBC450O7RvtaPCpFFsS+IyjtuOyX5/7ud5Vp5rpKAkZcMXWJl4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634064776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QlKCFEGnLo/IAL16FG94d9Hqx69oGFiZJmrGdarrPw8=;
        b=hSMpjILvWoDtkWr7hKkQBcjSfPHJG5wx0oEuIsxFcY5M6l15NzWtLpl4aLcZzt/DebLVnO
        6TNj4bbwTTpSPHAg==
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 09/31] x86/fpu: Do not inherit FPU context for CLONE_THREAD
In-Reply-To: <YWWzgO9Vn6XlNsLP@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223610.828296394@linutronix.de> <YWWzgO9Vn6XlNsLP@zn.tnic>
Date:   Tue, 12 Oct 2021 20:52:55 +0200
Message-ID: <87tuhm9it4.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12 2021 at 18:10, Borislav Petkov wrote:

> On Tue, Oct 12, 2021 at 02:00:11AM +0200, Thomas Gleixner wrote:
>> CLONE_THREAD does not have the guarantee of a true fork to inherit all
>> state. Especially the FPU state is meaningless for CLONE_THREAD.
>> 
>> Just wipe out the minimal required state so restore on return to user space
>> let's the thread start with a clean FPU.
>
> This sentence reads weird, needs massaging.

The patch is wrong and needs to be removed. I just double checked
pthread_create() again and it says:

The new thread inherits the calling thread's floating-point environment
(fenv(3))

No idea where I was looking at a few days ago. :(

Thanks,

        tglx
