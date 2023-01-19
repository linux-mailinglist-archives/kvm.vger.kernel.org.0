Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1FEF674428
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjASVSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjASVR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:17:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4354DBE8;
        Thu, 19 Jan 2023 13:12:34 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674162752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rRUXLP0p0WQ+Qd4xVEuRKMl25ggID9YoYcEY3DCIiik=;
        b=mdQ7CD0wRJvfaZDOr0f82Dc4967iwC75I1+s5lDCu1fHHwtrp+IBba8UPSoQ/va3j4Qar2
        ATGu2nZLLKa0vJ8CheBHLvt0I89xHSG06ZUusQKDPY104va7qqUjwYfiuIUukk+LaqO7Gu
        N+aHnCbtSnW+e8Smx0L+A2DiKy1AOSyLQ5QGRIN4vgJHVE1sRkt9jT/0k9LahiDV7T+AiK
        jKmIL8dmtVDNgeoMh+UAXcZ37mv49o4hNCz9KdPCGAyDUP9ZfpqnymsWZ0f3dG4LxhFiyw
        RTndkgdz2BKS/FhRmtxFB9hP9YbenuT2IOAVALIMh4inh4bZRqxisS45FivGfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674162752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rRUXLP0p0WQ+Qd4xVEuRKMl25ggID9YoYcEY3DCIiik=;
        b=0BJ5w/p0x778LsQ1MznxzGrIdB3OE1QGABAUfN3vpOmJUgdDINUgQsr9tLqZGxSzWuC+ct
        ivl26is4VR39BBBw==
To:     Igor Mammedov <imammedo@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     linux-kernel@vger.kernel.org, amakhalov@vmware.com,
        ganb@vmware.com, ankitja@vmware.com, bordoloih@vmware.com,
        keerthanak@vmware.com, blamoreaux@vmware.com, namit@vmware.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Lewis Caroll <lewis.carroll@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>, x86@kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2] x86/hotplug: Do not put offline vCPUs in mwait idle
 state
In-Reply-To: <20230116155526.05d37ff9@imammedo.users.ipa.redhat.com>
References: <20230116060134.80259-1-srivatsa@csail.mit.edu>
 <20230116155526.05d37ff9@imammedo.users.ipa.redhat.com>
Date:   Thu, 19 Jan 2023 22:12:31 +0100
Message-ID: <87bkmui5z4.ffs@tglx>
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

On Mon, Jan 16 2023 at 15:55, Igor Mammedov wrote:
> "Srivatsa S. Bhat" <srivatsa@csail.mit.edu> wrote:
>> Fix this by preventing the use of mwait idle state in the vCPU offline
>> play_dead() path for any hypervisor, even if mwait support is
>> available.
>
> if mwait is enabled, it's very likely guest to have cpuidle
> enabled and using the same mwait as well. So exiting early from
>  mwait_play_dead(), might just punt workflow down:
>   native_play_dead()
>         ...
>         mwait_play_dead();
>         if (cpuidle_play_dead())   <- possible mwait here                                              
>                 hlt_play_dead(); 
>
> and it will end up in mwait again and only if that fails
> it will go HLT route and maybe transition to VMM.

Good point.

> Instead of workaround on guest side,
> shouldn't hypervisor force VMEXIT on being uplugged vCPU when it's
> actually hot-unplugging vCPU? (ex: QEMU kicks vCPU out from guest
> context when it is removing vCPU, among other things)

For a pure guest side CPU unplug operation:

    guest$ echo 0 >/sys/devices/system/cpu/cpu$N/online

the hypervisor is not involved at all. The vCPU is not removed in that
case.

So to ensure that this ends up in HLT something like the below is
required.

Note, the removal of the comment after mwait_play_dead() is intentional
because the comment is completely bogus. Not having MWAIT is not a
failure. But that wants to be a seperate patch.

Thanks,

        tglx
---        
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 55cad72715d9..3f1f20f71ec5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1833,7 +1833,10 @@ void native_play_dead(void)
 	play_dead_common();
 	tboot_shutdown(TB_SHUTDOWN_WFS);
 
-	mwait_play_dead();	/* Only returns on failure */
+	if (this_cpu_has(X86_FEATURE_HYPERVISOR))
+		hlt_play_dead();
+
+	mwait_play_dead();
 	if (cpuidle_play_dead())
 		hlt_play_dead();
 }


  
