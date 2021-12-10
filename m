Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B51470E6C
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 00:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344979AbhLJXPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 18:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhLJXPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 18:15:33 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B5EC061746;
        Fri, 10 Dec 2021 15:11:57 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639177916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=faXgH7LlO5gnL3IcA9DrbYhVz4hrXT1lbXvsksl+Fnc=;
        b=1dhMCTk0rItIEnWXLvi5VTk8lk1g2/30yULcAI9dazKKXN6n5hUI9q1KhsbPo9LeanOGg/
        UVm697vEOObgg1YQZ1Jypdpzb4z5WWHsDBiQd2FmhSXhEH9tPRGYJGjkZj+I+nRMMmf2Nt
        OYfqoCpDeUuUziIoaMpz6rT9gO0FGpNY7+o1foQzI4PRdMau2eug7ijIS4SJgGV20ByREb
        AsdDkuH5R80zqSyXEwU6QBprgbowJQXOnQkg1OD/eflUij+Z7y/DUTtI/5z0VZOy4nD5Kk
        aNEvr2zHKMhJgU1FpRpLTYoSWkmhCcP2PX3bnl8taPJG/HZ0sgyWJV4JjpK4OQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639177916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=faXgH7LlO5gnL3IcA9DrbYhVz4hrXT1lbXvsksl+Fnc=;
        b=c25bG0deDwhN8mqy4tTDHezk8r5jzuLOd5wuf0HKui+yuGIOcG8TvEOWURXqb3EkRbSR+B
        mRpOUWVuKvBfaYAw==
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 12/19] x86/fpu: Prepare KVM for bringing XFD state back
 in-sync
In-Reply-To: <20211208000359.2853257-13-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-13-yang.zhong@intel.com>
Date:   Sat, 11 Dec 2021 00:11:55 +0100
Message-ID: <87wnkcvyv8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07 2021 at 19:03, Yang Zhong wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> Guest may toggle IA32_XFD in high frequency as it is part of the fpstate
> information (features, sizes, xfd) and swapped in task context switch.
>
> To minimize the trap overhead of writes to this MSR, one optimization
> is to allow guest direct write thus eliminate traps. However MSR
> passthrough implies that guest_fpstate::xfd and per-cpu xfd cache might
> be out of sync with the current IA32_XFD value by the guest.
>
> This suggests KVM needs to re-sync guest_fpstate::xfd and per-cpu cache
> with IA32_XFD before the vCPU thread might be preempted or interrupted.
>
> This patch provides a helper function for the re-sync purpose.

Provide a ....

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> ---
> (To Thomas): the original name kvm_update_guest_xfd_state() in
> your sample code is renamed to xfd_sync_state() in this patch. In
> concept it is a general helper to bring software values in-sync with
> the MSR value after they become out-of-sync. KVM is just the
> first out-of-sync usage on this helper, so a neutral name may make
> more sense. But if you prefer to the original name we can also
> change back.

There is no need for a general helper, really.

It's KVM specific and should go into KVM section in core.c next to the
other thing vs. the XFD update.

Thanks,

        tglx
