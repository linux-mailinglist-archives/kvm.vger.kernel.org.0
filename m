Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CEC6C73DA
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 00:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCWXFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 19:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCWXFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 19:05:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DEE15575;
        Thu, 23 Mar 2023 16:05:34 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679612733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f5sjryDy5LEhlWt18Hl0IcqzfSwt8nmXit8rKsnVSBI=;
        b=MxkKiT5HXCdVQqFTNy0TTutikBpxy8YTJV2dqP2Gx6KzRyW1+DhRmkXucvuYBAog3qYiOU
        VGNZOL5HzEMOGuE/49d+fMCMQ8Yf2MqXqpDEk2hkDffq60uUn4IhszvX4lA0tOVJPu8+qa
        AnHcV9fCZzMk761KKwFxZbq6saZpslFObLwXLidh7OWLtWPZAQVE/4JlO7C7KpCTUBZh0f
        ib/F0Rk/UY0F/fDtxbPz/PGCLtJH7rwe6pTWmw3jtM/Hf5EI4cN1byJnVX5QzsolsFPxz2
        QB09ZPk5Z1J4f4LYhDGKPuGrItwNIubix/4AupPTq8M/DcS270iZ9vzbXOXaeA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679612733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f5sjryDy5LEhlWt18Hl0IcqzfSwt8nmXit8rKsnVSBI=;
        b=ilEd8OWAQp53lLRAFyKoM4qc5uVzjbwhMMCiIYPM88uhrxgbCscRwfA3q8kJYwdfYS9JoM
        vYBdQgM3o5YNz+Aw==
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
Subject: Re: [PATCH v16 3/8] cpu/hotplug: Add dynamic parallel bringup
 states before CPUHP_BRINGUP_CPU
In-Reply-To: <874jqb8588.ffs@tglx>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-4-usama.arif@bytedance.com> <874jqb8588.ffs@tglx>
Date:   Fri, 24 Mar 2023 00:05:32 +0100
Message-ID: <871qlf83wj.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23 2023 at 23:36, Thomas Gleixner wrote:
> On Tue, Mar 21 2023 at 19:40, Usama Arif wrote:
>>  void bringup_nonboot_cpus(unsigned int setup_max_cpus)
>>  {
>> +	unsigned int n = setup_max_cpus - num_online_cpus();
>>  	unsigned int cpu;
>>  
>> +	/*
>> +	 * An architecture may have registered parallel pre-bringup states to
>> +	 * which each CPU may be brought in parallel. For each such state,
>> +	 * bring N CPUs to it in turn before the final round of bringing them
>> +	 * online.
>> +	 */
>> +	if (n > 0) {
>> +		enum cpuhp_state st = CPUHP_BP_PARALLEL_DYN;
>> +
>> +		while (st <= CPUHP_BP_PARALLEL_DYN_END && cpuhp_hp_states[st].name) {
>
>
> There is no point in special casing this. All architectures can invoke
> the CPUHP_BP_* states before CPUHP_BRINGUP_CPU for each to be brought up
> CPU first. So this can be made unconditional and common exercised
> code.

Bah. There is. We discussed that before. Architectures need to opt in to
make sure that there are no implicit dependencies on the full
serialization.

Still the rest can be simplified as below.

Thanks,

        tglx
---
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -133,6 +133,20 @@ enum cpuhp_state {
 	CPUHP_MIPS_SOC_PREPARE,
 	CPUHP_BP_PREPARE_DYN,
 	CPUHP_BP_PREPARE_DYN_END		= CPUHP_BP_PREPARE_DYN + 20,
+	/*
+	 * This is an optional state if the architecture supports parallel
+	 * startup. It's used to send the startup IPI so that the APs can
+	 * run in parallel through the low level startup code instead of
+	 * sending the IPIs one by one in CPUHP_BRINGUP_CPU. This avoids
+	 * waiting for the AP to react and shortens the serialized bringup.
+	 */
+	CPUHP_BP_PARALLEL_STARTUP,
+
+	/*
+	 * Fully per AP serialized bringup from here on. If the
+	 * architecture does no register the CPUHP_BP_PARALLEL_STARTUP
+	 * state, this step sends the startup IPI first.
+	 */
 	CPUHP_BRINGUP_CPU,
 
 	/*
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1504,13 +1504,45 @@ int bringup_hibernate_cpu(unsigned int s
 
 void bringup_nonboot_cpus(unsigned int setup_max_cpus)
 {
-	unsigned int cpu;
+	unsigned int cpu, n = 1;
 
+	/*
+	 * On architectures which have setup the CPUHP_BP_PARALLEL_STARTUP
+	 * state, this invokes all BP prepare states and the parallel
+	 * startup state sends the startup IPI to each of the to be onlined
+	 * APs. This avoids waiting for each AP to respond to the startup
+	 * IPI in CPUHP_BRINGUP_CPU. The APs proceed through the low level
+	 * bringup code and then wait for the control CPU to release them
+	 * one by one for the final onlining procedure in the loop below.
+	 *
+	 * For architectures which do not support parallel bringup all
+	 * states are fully serialized in the loop below.
+	 */
+	if (!cpuhp_step_empty(true, CPUHP_BP_PARALLEL_STARTUP) {
+			for_each_present_cpu(cpu) {
+				if (n++ >= setup_max_cpus)
+					break;
+				cpu_up(cpu, CPUHP_BP_PARALLEL_STARTUP);
+			}
+	}
+
+	/* Do the per CPU serialized bringup to ONLINE state */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
 			break;
-		if (!cpu_online(cpu))
-			cpu_up(cpu, CPUHP_ONLINE);
+
+		if (!cpu_online(cpu)) {
+			struct cpuhp_cpu_state *st = per_cpu_ptr(&cpuhp_state, cpu);
+			int ret = cpu_up(cpu, CPUHP_ONLINE);
+
+			/*
+			 * Due to the above preparation loop a failed online attempt
+			 * might have only rolled back to CPUHP_BP_PARALLEL_STARTUP. Do the
+			 * remaining cleanups. NOOP for the non parallel case.
+			 */
+			if (ret && can_rollback_cpu(st))
+				WARN_ON(cpuhp_invoke_callback_range(false, cpu, st, CPUHP_OFFLINE));
+		}
 	}
 }
 
