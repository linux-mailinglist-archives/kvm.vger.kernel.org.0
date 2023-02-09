Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EFD69104F
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 19:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBISbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 13:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBISbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 13:31:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7176569E;
        Thu,  9 Feb 2023 10:31:18 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675967477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7pUh6iI4OnfGqJZq7VtDTnwn9iFkcNOiD9vzdvat8Y=;
        b=prVdJx8mPcRJM5e4dt9vLLMnJbMJOrL1ES7/lty2iW61De45cS7zCOcIpGfmL4ByMXPQFQ
        gqz0ASwvpfu5g0Zg1F64tbIlvJqsca1jvzkA1Xwu2ATNeiVrYKYOQFzZP9bWl1SExSVVk4
        fP3BoeDa9is6K1ZlstkeFmDSac9ySpWYl/HkbqDcSiQhubeR5+syS6qNudRSNVPG8oEpC7
        J4El19PaZ0nVdOVfPFZYrB0UlymwTDB5AK2M16Xttorfyv4aAKOu94JZrzPYRTjBnfEcWB
        cs0L0Ufyg11aU/5tw2ny1Gv/mLHTk85YApDtj+mzlq33NYxuGaw8ypPKLBzvHg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675967477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7pUh6iI4OnfGqJZq7VtDTnwn9iFkcNOiD9vzdvat8Y=;
        b=7zA2igiHdJUrzkuc7pxNysaK5j1RhZ0AlsBOPOXgS6OQztCULl457Oexe/NtoFhlMXvdeZ
        XXDX1Zs5yvwSGzDQ==
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
Subject: Re: [PATCH v8 8/9] x86/mtrr: Avoid repeated save of MTRRs on
 boot-time CPU bringup
In-Reply-To: <20230209154156.266385-9-usama.arif@bytedance.com>
References: <20230209154156.266385-1-usama.arif@bytedance.com>
 <20230209154156.266385-9-usama.arif@bytedance.com>
Date:   Thu, 09 Feb 2023 19:31:16 +0100
Message-ID: <87mt5m1yiz.ffs@tglx>
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
>  void mtrr_save_state(void)
>  {
> +	static bool mtrr_saved;
>  	int first_cpu;
>  
>  	if (!mtrr_enabled())
>  		return;
>  
> +	if (system_state < SYSTEM_RUNNING) {
> +		if (!mtrr_saved) {
> +			mtrr_save_fixed_ranges(NULL);
> +			mtrr_saved = true;
> +		}
> +		return;
> +	}
> +
>  	first_cpu = cpumask_first(cpu_online_mask);
>  	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);

So why is this relevant after the initial bringup? The BP MTRRs have
been saved already above, no?

Thanks,

        tglx
