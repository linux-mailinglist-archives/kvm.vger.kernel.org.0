Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF5F6C032D
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 17:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjCSQf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 12:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCSQe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 12:34:56 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8153D53F;
        Sun, 19 Mar 2023 09:34:18 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AD3F91EC067D;
        Sun, 19 Mar 2023 17:34:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1679243654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oQqxL3BHw5WjuWqun2syN57FSJzoyI2jQrk/HbbPWhs=;
        b=pqEwETfaj31dpAz2SEYSWfvU3WeBzG4lX8oZzUyb/EtHCHrnN4e+cfPaekUjGZ8SBiLJJd
        d1DJ2QpKdRIeoydJx+SuRzEIaZ2w3eBxtrIhSGGgWTcRelmavWlZ7879Seb5jaxbE6Z+Qm
        +GMiBj8HPxvSZjAvuffKs7s8PsJaneU=
Date:   Sun, 19 Mar 2023 17:34:09 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v15 02/12] cpu/hotplug: Move idle_thread_get() to
 <linux/smpboot.h>
Message-ID: <20230319163409.GBZBc5gTU94IdrucNL@fat_crate.local>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
 <20230316222109.1940300-3-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316222109.1940300-3-usama.arif@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 10:20:59PM +0000, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Instead of relying purely on the special-case wrapper in bringup_cpu()
> to pass the idle thread to __cpu_up(), expose idle_thread_get() so that
> the architecture code can obtain it directly when necessary.
> 
> This will be useful when the existing __cpu_up() is split into multiple
> phases, only *one* of which will actually need the idle thread.
> 
> If the architecture code is to register its new pre-bringup states with
> the cpuhp core, having a special-case wrapper to pass extra arguments is
> non-trivial and it's easier just to let the arch register its function
> pointer to be invoked with the standard API.
> 
> To reduce duplication, move the shadow stack reset and kasan unpoisoning

I was wondering what "shadow stack" as that set is not upstream yet. You mean
"shadow call stack" which is apparently something else,
compiler-generated, purely software thing.

> into idle_thread_get() too.

Frankly, I don't think resetting shadow call stack and kasan state
belongs in a function which returns the idle thread. Even more so if you
have to add an @unpoison param which is false sometimes and sometimes
true, depending on where you call the function.

I think you should have a helper

	tsk_reset_stacks(struct task_struct *tsk);

or so which is called where @unpoison == true instead of having a getter
function do something unrelated too.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
