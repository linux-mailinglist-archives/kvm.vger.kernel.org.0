Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643B76B59FE
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 10:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCKJUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Mar 2023 04:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCKJUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Mar 2023 04:20:08 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A541BFE;
        Sat, 11 Mar 2023 01:19:12 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678526350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TWqLM4GN3BK/H62VxUNFd2Gi4UA41TC1BZfBfm1ijYQ=;
        b=v9/aWHPS+a0oQNdKOkohbsxF3OQGjJK4oF4UZJmG1JpPdScpCgeSbD3aUQtheAadWw3noD
        Pk1AamUJqrX3z+6JNVV8BFUtmrA69l3fhK7+BAxMAU3sGFd/xl/POi16hJy6tyoyvFNy10
        uNVP5RmMTOtln4kfSIIVRo25IBBpxclFTkp7pUrN4J5gTr2p9rQkVfZvSkRlz/Th7QovQa
        9RTh3LP/li7Eq+CahpY5bzjqkCbSfUxrenFrjnQNVdAv9mv4nZTLyEpEf0OTNs6Ax3t50l
        ueQAvHh1kSvD2/kQGcMdR2zwPMAfmcjdkjLoXsvBgfBngqq/9VmcA/8VOy+wtg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678526350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TWqLM4GN3BK/H62VxUNFd2Gi4UA41TC1BZfBfm1ijYQ=;
        b=Gg6gdghsHftcHwbgLoTMXcSSlhY9KIZhXxkcwQYxHzLhJqOqLch6EOAu0G16/8FUqAb64q
        YnZJmLEUztqqHnBQ==
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
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
Subject: Re: [PATCH v14 05/12] x86/smpboot: Split up native_cpu_up into
 separate phases and document them
In-Reply-To: <20230308171328.1562857-6-usama.arif@bytedance.com>
References: <20230308171328.1562857-1-usama.arif@bytedance.com>
 <20230308171328.1562857-6-usama.arif@bytedance.com>
Date:   Sat, 11 Mar 2023 11:19:10 +0200
Message-ID: <87ttyrabn5.ffs@tglx>
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

On Wed, Mar 08 2023 at 17:13, Usama Arif wrote:
>  
> +int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
> +{
> +	int ret;
> +
> +	ret = do_cpu_up(cpu, tidle);
> +	if (ret)
> +		return ret;

In case of error this leaves the warm reset vector dangling.

> +	ret = do_wait_cpu_initialized(cpu);
> +	if (ret)
> +		return ret;
> +
> +	ret = do_wait_cpu_callin(cpu);
> +	if (ret)
> +		return ret;

Same for these two error returns.

Thanks,

        tglx
