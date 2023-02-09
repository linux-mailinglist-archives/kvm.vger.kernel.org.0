Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20648691044
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 19:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjBISZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 13:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBISZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 13:25:32 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF476031C;
        Thu,  9 Feb 2023 10:25:31 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675967130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0NaX4sqxw6MUujMtWMhi4Kyfzd9HAZvF25tWNFvR+NQ=;
        b=a4uFotAh4zBkNeR4bTyBuQc9kV5tVaWaMBAc/9il112kLU0MYI7QbLsTUlR38AfEFeKLcE
        8nizRUUZu6/dgDL7F1kmlQHFfgGeu06VCJLavdapJgx1aDAoAucuj78bEYQ5q/NIE46ZAX
        NV1PHWGM3DbHFAoZnV4Amrjnb1GxH4K4PnjFzqChh5/YSHLgI++byg79BnA3ntFJ/XRnN5
        tX9325ZAlOKhggkcMQgjGTDI7FU75ZLQ2kPLJy12HCz6WcOXqpvzVGXF+he0K8JFycrLRn
        +HPXv7DguxauoLxol0w2dE71DIi+1zvcxpu/LEe5bJRk807sOE/sBxNDplukzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675967130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0NaX4sqxw6MUujMtWMhi4Kyfzd9HAZvF25tWNFvR+NQ=;
        b=pernKmnmJ4vi3c/QkDNqcxvo6wqgdKcDJbALgJnLBljAsmeNZOF8vDMtAxGsN1zuclVquW
        whO9e3NeXhm2ITAw==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v8 6/9] x86/smpboot: Support parallel startup of
 secondary CPUs
In-Reply-To: <20230209154156.266385-7-usama.arif@bytedance.com>
References: <20230209154156.266385-1-usama.arif@bytedance.com>
 <20230209154156.266385-7-usama.arif@bytedance.com>
Date:   Thu, 09 Feb 2023 19:25:29 +0100
Message-ID: <87r0uy1ysm.ffs@tglx>
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

On Thu, Feb 09 2023 at 15:41, Usama Arif wrote:
>  
> +static bool do_parallel_bringup = true;

Wants to be __ro_after_init

> +static int __init no_parallel_bringup(char *str)
> +{
> +	do_parallel_bringup = false;
> +
> +	return 0;
> +}
> +early_param("no_parallel_bringup", no_parallel_bringup);

Lacks an entry in Documentation/admin/kernel-parameters.txt

Thanks,

        tglx
