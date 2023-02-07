Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC18668E277
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 21:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjBGU6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 15:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjBGU6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 15:58:49 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5999511647;
        Tue,  7 Feb 2023 12:58:47 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675803524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kNQJNy/R9/K5UBVEa2XTHQBRDjsgUlovum6u1lLQmzM=;
        b=Cycy9LYUbcBKf+iD/qLT6uJTjyeF6t1gUhw8PZNP0qPiMxpA//CSMHrNXeW2Evp0WL29VR
        rIfIXARScT9Xl33sZSpe5TMjzcerq7XY07EcfmIQ1DelptcduoAYVpvONTIHZnlrJXTbBp
        RTfvU/XxJkIi+rGJXBn7D3iw9PH1RbxrFgqf0W0Ha6OtiyllXwVeTUvK14n/uSRyNt3/Hy
        B4gbpuy+BIAVZt0PIvOHZsBXv028GWh+Dao7yJkHYCigBL2ZXwlOJXM9ojRwAOkeuPkQ9n
        iS2hN6skox1qo63F01iqxcNAgVWEJNxLMIwMPtsVQ5kZETKN1a9rw1V4PDqN1A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675803524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kNQJNy/R9/K5UBVEa2XTHQBRDjsgUlovum6u1lLQmzM=;
        b=+lMS0cNSyRWvGBEVLrvGuakIwd5kaM0Kue5WBHCJtypUVHRl0vgyBRwLEHO3EieaA4g51s
        sYKRjvHdp/dkWuBg==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Subject: Re: [PATCH v6 01/11] x86/apic/x2apic: Fix parallel handling of
 cluster_mask
In-Reply-To: <0460d9cd8cdb7be2fcea00579e80ee683920d66d.camel@infradead.org>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-2-usama.arif@bytedance.com> <87a61qxtx0.ffs@tglx>
 <d37f3af69df09ff542024ed93a37865b28dfa86e.camel@infradead.org>
 <921cfe295fcd398168e5454e01193045de312688.camel@infradead.org>
 <87v8kdv9i1.ffs@tglx>
 <0460d9cd8cdb7be2fcea00579e80ee683920d66d.camel@infradead.org>
Date:   Tue, 07 Feb 2023 21:58:44 +0100
Message-ID: <87bkm5ur97.ffs@tglx>
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

On Tue, Feb 07 2023 at 19:53, David Woodhouse wrote:
> On Tue, 2023-02-07 at 15:24 +0100, Thomas Gleixner wrote:
> Thanks. I've reworked and I think I've caught everything. Didn't want
> to elide the credit where Usama had done some of the forward-porting
> work, so I've left those notes and the SoB intact on those patches, on
> the assumption that they will be reposting the series after proper
> testing on hardware again anyway (I'm only spawning it in qemu right
> now).
>
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-6.2-rc7
>
> The only real code change other than what we've discussed here is to
> implement what we talked about for CPUID 0xb vs. 0x1 etc:
>
> 	/*
> 	 * We can do 64-bit AP bringup in parallel if the CPU reports
> 	 * its APIC ID in CPUID (either leaf 0x0B if we need the full
> 	 * APIC ID in X2APIC mode, or leaf 0x01 if 8 bits are
> 	 * sufficient). Otherwise it's too hard. And not for SEV-ES
> 	 * guests because they can't use CPUID that early.
> 	 */
> 	if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 1 ||
> 	    (x2apic_mode && boot_cpu_data.cpuid_level < 0xb) ||
> 	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
> 		do_parallel_bringup = false;
>
> 	if (do_parallel_bringup && x2apic_mode) {
> 		unsigned int eax, ebx, ecx, edx;
>
> 		/*
> 		 * To support parallel bringup in x2apic mode, the AP will need
> 		 * to obtain its APIC ID from CPUID 0x0B, since CPUID 0x01 has
> 		 * only 8 bits. Check that it is present and seems correct.
> 		 */
> 		cpuid_count(0xb, 0, &eax, &ebx, &ecx, &edx);
>
> 		/*
> 		 * AMD says that if executed with an umimplemented level in
> 		 * ECX, then it will return all zeroes in EAX. Intel says it
> 		 * will return zeroes in both EAX and EBX. Checking only EAX
> 		 * should be sufficient.
> 		 */
> 		if (eax) {
> 			smpboot_control = STARTUP_SECONDARY | STARTUP_APICID_CPUID_0B;
> 		} else {
> 			pr_info("Disabling parallel bringup because CPUID 0xb looks untrustworthy\n");
> 			do_parallel_bringup = false;
> 		}
> 	} else if (do_parallel_bringup) {
> 		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
> 		smpboot_control = STARTUP_SECONDARY | STARTUP_APICID_CPUID_01;
> 	}

Looks good to me!

Thanks,

        tglx
