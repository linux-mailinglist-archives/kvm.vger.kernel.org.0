Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55906C14C1
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjCTOav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCTOar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:30:47 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C5313539;
        Mon, 20 Mar 2023 07:30:43 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679322641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MNnJjc+wTjsbE+tTs4G4f7zF5ub8ez2fAjz50M//XHI=;
        b=P1wYEjvirFWplRoyJ0EDSTwrhMcIlvV5ubepcimBgsiKvL1IMtpSEr+MqRD7Tw2+5KjclI
        YqLW+V3S4FGAl85tJI/55siU6QySIcknND2sJS8+1QCsRIGqu/VRjKw9NueLEevIlTfnR0
        7zSO8nzPrApbinuSCGGX/HGELCxyW6L2wpleLYirF+oFAGZYrzgDz+XYP63c2z1mtcbJsl
        fO6bLRGVtVKlYKTvvAp8bl0BLWcB/O4RZ9snzKjMnzNGFhOoqx3qIqt0oLMFxhSa8vRSGM
        dzvD81DUwcCuJsR+NkUNS2faSRJtx1U34dUewdjQDH4duMIC9V+IurBVsQpDVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679322641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MNnJjc+wTjsbE+tTs4G4f7zF5ub8ez2fAjz50M//XHI=;
        b=k397NgAqoRe94ROeFOGKteN1q3HeCaMfZtxf95A/Y6+wh98xPVvgivEefHHKUih+/JBWzG
        +b6h/1kvJCIVpsCA==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v15 03/12] cpu/hotplug: Add dynamic parallel bringup
 states before CPUHP_BRINGUP_CPU
In-Reply-To: <20230316222109.1940300-4-usama.arif@bytedance.com>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
 <20230316222109.1940300-4-usama.arif@bytedance.com>
Date:   Mon, 20 Mar 2023 15:30:40 +0100
Message-ID: <87r0tja41b.ffs@tglx>
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

On Thu, Mar 16 2023 at 22:21, Usama Arif wrote:
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 6b3dccb4a888..6ccc64defd47 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -1497,8 +1497,30 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
>  
>  void bringup_nonboot_cpus(unsigned int setup_max_cpus)
>  {
> +	unsigned int n = setup_max_cpus - num_online_cpus();
>  	unsigned int cpu;
>  
> +	/*
> +	 * An architecture may have registered parallel pre-bringup states to
> +	 * which each CPU may be brought in parallel. For each such state,
> +	 * bring N CPUs to it in turn before the final round of bringing them
> +	 * online.
> +	 */
> +	if (n > 0) {
> +		enum cpuhp_state st = CPUHP_BP_PARALLEL_DYN;
> +
> +		while (st <= CPUHP_BP_PARALLEL_DYN_END && cpuhp_hp_states[st].name) {
> +			int i = n;
> +
> +			for_each_present_cpu(cpu) {
> +				cpu_up(cpu, st);
> +				if (!--i)
> +					break;
> +			}
> +			st++;
> +		}
> +	}
> +
>  	for_each_present_cpu(cpu) {
>  		if (num_online_cpus() >= setup_max_cpus)
>  			break;

This causes a subtle issue. The bringup loop above moves all CPUs to
cpuhp_state == CPUHP_BP_PARALLEL_DYN_END. So the serial bootup will
start from there and bring them fully up.

Now if a bringup fails, then the rollback will only go back down to
CPUHP_BP_PARALLEL_DYN_END, which means that the control CPU won't do any
cleanups below CPUHP_BP_PARALLEL_DYN_END.

That 'fail' is a common case for SMT soft disable via the 'nosmt'
command line parameter. Due to the marvelous MCE broadcast 'feature' we
need to bringup the SMT siblings at least to the CPUHP_AP_ONLINE_IDLE
state once and then roll them back.

While this is not necessarily a fatal problem, it's changing behaviour
and with quite some of the details hidden in the (then not issued)
teardown callbacks might cause some hard to decode subtle surprises.

So that second for_each_present_cpu() loop needs to check the return
value of cpu_up() and issue a full rollback to CPUHP_OFFLINE in case of
fail.

Thanks,

        tglx


