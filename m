Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAF846842E
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 11:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384652AbhLDKth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Dec 2021 05:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346511AbhLDKth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Dec 2021 05:49:37 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B14C061751;
        Sat,  4 Dec 2021 02:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+iPI6L3nEz1funxb+fD0ArJNK78fEZ3dT8SI5UoTVRU=; b=ZpR5zrvXST0FELokWlLqB75j/6
        83lFEUKZrsQ0CCDC0xfq8Vl8qF8MGm94fqnwCpBqf1c3B9dwv/9wHu3FJqxf047yuVeLphisSNYB3
        3aEBdPEEfki1dqh0iQgGYaXNexTx0u1yEedF/wNvw0OBJ/Xnxu+pFSMKGwe1KeoOQJJOfysNss6jr
        Ud/xFN9CT/pbVbz7B1pRfGWKWVrgmIHgQ4MvBXiDT6sC+SWR3JjPukO4durOVbF3yC2WxaNLkgm8e
        Sdkp9v5bPYg16arc2v+sNPX5sbOFAP6U7hTbm8Dg+sN+TOWxI3Yesux3z9fY3EAQlVsMQuA3/W3pr
        r5bDcPWg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mtSYL-002BJS-In; Sat, 04 Dec 2021 10:46:01 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id B6D5598106D; Sat,  4 Dec 2021 11:46:00 +0100 (CET)
Date:   Sat, 4 Dec 2021 11:46:00 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     tglx@linutronix.de, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: Re: [PATCH v2 1/2] x86/cpu: Introduce x86_get_cpufreq_khz()
Message-ID: <20211204104600.GT16608@worktop.programming.kicks-ass.net>
References: <20211201024650.88254-1-pizhenwei@bytedance.com>
 <20211201024650.88254-2-pizhenwei@bytedance.com>
 <20211202222514.GD16608@worktop.programming.kicks-ass.net>
 <947de021-df91-9219-7378-8addc6f66612@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <947de021-df91-9219-7378-8addc6f66612@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 03, 2021 at 03:34:04PM +0800, zhenwei pi wrote:
> A KVM guest overwrites the '.calibrate_tsc' and '.calibrate_cpu' if kvmclock
> is supported:
> 
> in function kvmclock_init(void) (linux/arch/x86/kernel/kvmclock.c)
> 	...
>         x86_platform.calibrate_tsc = kvm_get_tsc_khz;
>         x86_platform.calibrate_cpu = kvm_get_tsc_khz;
> 	...
> 
> And kvm_get_tsc_khz reads PV data from host side. Before guest reads this,
> KVM should writes the frequency into the PV data structure.
> 
> And the problem is that KVM gets tsc_khz directly without aperf/mperf
> detection. So user may gets different frequency(cat /proc/cpuinfo) from
> guest & host.
> 
> Or is that possible to export function 'aperfmperf_get_khz'?

TSC frequency and aperf/mperf are unrelated. You're trying to make apple
juice with carrots.
