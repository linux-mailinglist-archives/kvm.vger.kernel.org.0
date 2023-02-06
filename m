Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D35E68CABC
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBFXnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjBFXnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:43:49 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF83222FB;
        Mon,  6 Feb 2023 15:43:48 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675727026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xvt78yL1c4ccij3JuqZYM3GlDRuaTucptdUJHCTUbCk=;
        b=A2ZwGtqnmuC3PNF/+3N1b+STkdnoyqWTspIxe3/iQQ2oRKmMx1m7PRNmRSx9nRevk7Hn3p
        xFLJ0XAXAIU4gHZSQMa0Vht0dqQ/ftfCA+nRiVeRLnxpKRtsEMM4u/DTMhBm1A+tMAGVmT
        ZM+nRX80kJRid3nN6d/6aBYL4OJjStJd/zDX/v/BTuMOKuWG3sk+oWMI8wpygcJIdCjooK
        GBStwEwdJQWpowrkTKrascCX54ORm0pXkj+7vXj+rtJwkQKUI7lIj1b4KMDVkOkG7iTcV1
        ucEIXhDhMn1BzWVv65bfAaEUwI/rxmGIJEgq55RhrL4dbmcz9BQLHlhr2I6gMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675727026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xvt78yL1c4ccij3JuqZYM3GlDRuaTucptdUJHCTUbCk=;
        b=KGcQjkalaVSTz2YrXyjIQFzqTvbnpCSD2zjVO5peZ2YMxwuvVf4iGjw8Dl3ZnpwN3YIBqb
        6PD1hoI0r0FLclAQ==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v6 03/11] cpu/hotplug: Add dynamic parallel bringup
 states before CPUHP_BRINGUP_CPU
In-Reply-To: <20230202215625.3248306-4-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-4-usama.arif@bytedance.com>
Date:   Tue, 07 Feb 2023 00:43:45 +0100
Message-ID: <874jryxsum.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
> So any combination of prepare/start calls which depend on A-B ordering
> for each CPU in turn, such as the X2APIC code which used to allocate a
> cluster mask 'just in case' and store it in a global variable in the
> prep stage, then potentially consume that preallocated structure from
> the AP and set the global pointer to NULL to be reallocated in
> CPUHP_X2APIC_PREPARE for the next CPU... would explode horribly.
>
> We believe that X2APIC was the only such case, for x86. But this is why
> it remains an architecture opt-in. For now.

We believe is not really a convincing technical argument.

  On x86 the X2APIC case was established to be the only one which relied
  on the full CPU hotplug serialization. It's unclear whether this
  affects any other architecture, so this optimization is opt-in.

Hmm?

> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 6c0a92ca6bb5..5a8f1a93b57c 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -1505,6 +1505,24 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
>  void bringup_nonboot_cpus(unsigned int setup_max_cpus)
>  {
>  	unsigned int cpu;
> +	int n =3D setup_max_cpus - num_online_cpus();

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#variable=
-declarations

Aside of that I detest the mixture between unsigned and signed here.

> +
> +	/* =E2=88=80 parallel pre-bringup state, bring N CPUs to it */
> +	if (n > 0) {
> +		enum cpuhp_state st =3D CPUHP_BP_PARALLEL_DYN;
> +
> +		while (st <=3D CPUHP_BP_PARALLEL_DYN_END &&
> +		       cpuhp_hp_states[st].name) {

		while (st <=3D CPUHP_BP_PARALLEL_DYN_END && cpuhp_hp_states[st].name) {

80 character limit has been updated quite some time ago

Thanks,

        tglx
