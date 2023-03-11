Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547F16B5CA4
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 15:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCKOPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Mar 2023 09:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCKOO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Mar 2023 09:14:58 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3416D23122;
        Sat, 11 Mar 2023 06:14:56 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678544093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kUz9bSwjiGMhx/0cwTj81VlLH7EOsgQepcpD99BcUWM=;
        b=FRJuUXYO+k/z9uPNAXb8nvIWxeIbZGEOZsHUPBI7FQvM5G5v8zcjRDs4s9BtIf0rXLAedD
        VHwKO0IJkCxcdfFoNo+vDz2x9KVpa/fMap2VhB4eAC1j95goI0ZL2wcImGX2yK/ECcdPxF
        wL/b6vmKZdkFvDL4jLlH33UIwIcQndGo1PE8wLZjCgFuP4UiokfO9tDrQ1e1q5gedtsjCF
        EIMSk5slDmhvZ8eUn1zw2cJcywx9fIbHatyyd1eEFEdttC0JkW/R114WP1e+cyhNig/Mh2
        0KPcs7mPzuy/rQ87dnfiQj+9UTPRJEirzHIGDsDrPDiwYUnU5cVTrGad51umZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678544093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kUz9bSwjiGMhx/0cwTj81VlLH7EOsgQepcpD99BcUWM=;
        b=H0YPQ2NjD2HuhW9NGmBA5XlXUf7iaOxNc1vWUZNIhHlHj9pKC3I1n3dte8TY3yu2CWG1QW
        L/tAJ1fLVVxSnvDA==
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
        simon.evans@bytedance.com, liangma@liangbit.com,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
Subject: Re: [PATCH v14 10/12] x86/smpboot: Send INIT/SIPI/SIPI to secondary
 CPUs in parallel
In-Reply-To: <5a9d6d4aef78de6fc8a2cfc62922d06617cbe109.camel@infradead.org>
References: <20230308171328.1562857-1-usama.arif@bytedance.com>
 <20230308171328.1562857-11-usama.arif@bytedance.com> <87y1o3acrh.ffs@tglx>
 <5a9d6d4aef78de6fc8a2cfc62922d06617cbe109.camel@infradead.org>
Date:   Sat, 11 Mar 2023 16:14:53 +0200
Message-ID: <87r0tv9xya.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 11 2023 at 09:55, David Woodhouse wrote:
> On Sat, 2023-03-11 at 10:54 +0200, Thomas Gleixner wrote:
> I think I'll do it with a 'bool unpoison' argument to
> idle_thread_get(). Or just make it unconditional; they're idempotent
> anyway and cheap enough? Kind of weird to be doing it from finish_cpu()
> though, so I'll probably stick with the argument.

Eew.

> ....*types*....
>
> Erm, there are circumstances (!CONFIG_GENERIC_SMP_IDLE_THREAD) when
> idle_thread_get() just unconditionally returns NULL.
>
> At first glance, it doesn't look like scs_task_reset() copes with being
> passed a NULL. Am I missing something?

Shadow call stacks are only enabled by arm64 today, and that uses
the generic idle threads.

Thanks,

        tglx


