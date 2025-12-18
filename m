Return-Path: <kvm+bounces-66279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00AE4CCD2BC
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 19:28:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1BF26300E3EE
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 18:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 753B52FF15B;
	Thu, 18 Dec 2025 18:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WbHeBpcq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7EA287272
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766082405; cv=none; b=d6d3QX3CeTI9YtUfVs9lUSDWxs4H6qRUJj7tuWXxcbllxNop2Ta2fez5VRCwGyHTtJ9Ms0KtF0bicHwmXUKX4Yrc96//X1LnEuiFTHKTNrVpjcXBlWCPYmpSRvOVS1EHNyI/YGkelJzrhbkskl9FGWUmQlGVgKl/2vRYeiZ6Dhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766082405; c=relaxed/simple;
	bh=V5yN8cHqboweJq8h/RQv2guONPGVgdoM8C39QjQd/t0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PVtOyvhw+v/uQ3eBx4oK+pM9gLzeQKZLdiKW4RUJfDlghef+U6fGzXcicLCjlvoZCCzD1z3DfwYnCtaUcJ83mfCowQHdYv7OfRqff2wA3UhtmO9Xy0AGZvAGezjultMD51MNlLhNGFpmyGqKlVVJC5MiZy1N03CTc8Rt8sgqh6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WbHeBpcq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c66cb671fso1532581a91.3
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 10:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766082399; x=1766687199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/gxkmJ9TQs3AS8Vr3vipzxPLV2YRbYePD93yjaTsRBs=;
        b=WbHeBpcqeY3Z6/aJ3dFidp4wqsMW8MP57gPoYswdSfituL5noPfUxnGFSMtxlcK6yV
         Z1fLYi0BTC1bvVcbflQsIG44N4Jc9qyxW1OtARxbQJ53drRibq2lqDzVQb60kVyvSYbI
         5cVSvOpxoLpIdYmJFy4toVzTBwIy1LTHRBkoN8Vd+gg7YEavf7iMz2uvslWSJHx8jxpN
         hqqKtXRe8INSUVHSJiu4oTHnqf0dIDK8ENXJepKG7foaeKcE9fSJ+9yUlCheHajJqqmC
         RQl1BEB0uNeRaMmokXdxqbIKY2kcGKofulEk1DNe7TgJygJQUvxCb0ecXz4aiEqBQu8E
         e1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766082399; x=1766687199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/gxkmJ9TQs3AS8Vr3vipzxPLV2YRbYePD93yjaTsRBs=;
        b=HRA7eo6knIcxkM4YE0GTcxWqeXC/n9CIez4C1s0bJWu1FOni1w6BnzrroxoXM9C6PX
         7yovy0BPv+hzh57nTKw4dRwCsVF4CLkKWoXy4/6o6F27cjHjQSRLWU0I6nQXm/9C2Nnj
         Hr/QW5lXEn+Plk6rR3U9IjjPk9HyY3LQdYEOgsFU11bMFBErwVqzw8A2+ujo86Pm/H31
         4RFcF2DFz26HN3NjSgeyvDXuQezoR/pzXLBoclu6o//23FG4ArjGtvUP+i38nKcf7Jmo
         lDykqxIkK54+9nglAFiYFgXd2ohyvgli/s6kNTr4JXvZ/2mXzQ4wgQgAo7czCksHnNNo
         wysA==
X-Gm-Message-State: AOJu0YxuEtYnd/F61ShxGK93hMoemjZkZcpm0ijHtrfPpYQgswQ+z8An
	TNHQYQwqK0kwz+SRWSoW01Kznnci3Fj9kORtOsR2e/wW/0iO0cpDaZ5UK5byjDjdJjijRx2UuGC
	gRHP2jg==
X-Google-Smtp-Source: AGHT+IGOJzRw3+tnCjYs2ZQwqi4LKMDc4l1C1xVPazx7uAjNqwk2hnkWloo6cOhDiQsW1rx8Q3BctsVZqNg=
X-Received: from pjso12.prod.google.com ([2002:a17:90a:c08c:b0:34c:6892:136f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d49:b0:340:c060:4d44
 with SMTP id 98e67ed59e1d1-34e921353ffmr280520a91.14.1766082399177; Thu, 18
 Dec 2025 10:26:39 -0800 (PST)
Date: Thu, 18 Dec 2025 10:26:37 -0800
In-Reply-To: <769da4d7-0e8c-447a-be6b-1e3ad9a0ae36@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net> <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net> <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net> <aUNci6Oy1EXXoQuY@google.com>
 <769da4d7-0e8c-447a-be6b-1e3ad9a0ae36@grsecurity.net>
Message-ID: <aURHXUX3tC8ElwFa@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Eric Auger <eric.auger@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

VICTORY IS MINE!!!!!!!

On Thu, Dec 18, 2025, Mathias Krause wrote:
> On 18.12.25 02:44, Sean Christopherson wrote:
> > On Fri, Nov 21, 2025, Mathias Krause wrote:
> >> On 18.11.25 02:47, Mathias Krause wrote:
> >>
> >> Finally found it. It's register corruption within both host and guest.
> >> [...]
> > 
> > *sigh*
> > 
> > I'm not going to type out the first dozen words that escaped my mouth when
> > reading this.  I happen to like my job :-)
> 
> Me too, that's why I had to switch tasks to gain back some sanity ;)
> 
> > [...]
> >> I hacked up something to verify my theory and made 'regs' "per-cpu". It
> >> needs quite some code churn and I'm not all that happy with it. IMHO,
> >> 'regs' and lots of the other VMX management state should be part of some
> >> vcpu struct or something. In fact, struct vmx_test already has a
> >> 'guest_regs' but using it won't work, as we need offsetable absolute
> >> memory references for the inline ASM in vmx_enter_guest() to work as it
> >> cannot make use of register-based memory references at all. (My hack
> >> uses a global 'scratch_regs' with mutual exclusion on its usage.)
> > 
> > So, much to my chagrin, I started coding away before reading your entire mail
> > (I got through the paragraph about 'regs' getting clobbered, and then came back
> > to the rest later; that was a mistake).
> 
> A common mistake of mine: writing lengthy explanations that don't get
> read. Maybe I should start included some tl;dr section for such cases ;)

FWIW, I like the lengthy, detailed explanations.  I just got excited about having
a clever idea for addressing the regs.

> > The test itself is also flawed.  On top of this race that you spotted:
> > 
> >  @@ -9985,11 +9985,11 @@ static void vmx_sipi_signal_test(void)                
> >        /* update CR3 on AP */                                                  
> >        on_cpu(1, update_cr3, (void *)read_cr3());                              
> >                                                                                
> >  +     vmx_set_test_stage(0);                                                  
> >  +                                                                             
> >        /* start AP */                                                          
> >        on_cpu_async(1, sipi_test_ap_thread, NULL);                             
> >                                                                                
> >  -     vmx_set_test_stage(0);                                                  
> >  -                                                                             
> >        /* BSP enter guest */                                                   
> >        enter_guest();                                                          
> >   }                                
> > 
> > This snippet is also broken:
> > 
> > 	vmx_set_test_stage(1);
> > 
> > 	/* AP enter guest */
> > 	enter_guest();
> > 
> > because the BSP can think the AP has entered WFS before it has even attempted
> > VMLAUNCH.  It's "fine" so long as there are host CPUs available, but the test
> > fails 100% for me if I run KUT in a VM with e.g. j<number of CPUs>, and on an
> > Ivybridge server CPU, it fails pretty consistently.  No idea why, maybe a slower
> > nested VM-Enter path?  E.g. the test passes on EMR even if I run with j<2x CPUs>.
> 
> Yeah, I noticed the failing synchronization between the vCPUs too. I
> even tried to fix them by introducing a few more states (simply more
> steps). However, then I ended up in deadlocks, as the AP re-enters
> vmx_sipi_test_guest() multiple times (well, twice). It was likely
> related to the register corruption, I only noticed later. So I believed
> those magic sleeps (delay(SIPI_SIGNAL_TEST_DELAY)) are for the lack of
> synchronization and should account for the time span of the AP setting a
> new step value but not yet having switched to the guest.
> It might be worth revisiting my attempts of explicitly adding new step
> states, now with the register corrupting being handled...
> 
> > 
> > Unfortunately, I can't think of any way to fix that problem.  To recognize the
> > SIPI, the AP needs to do VM-Enter with a WFS activity state, and I'm struggling
> > to think of a way to atomically write software-visible state at the time of VM-Enter.
> > E.g. in theory, the test could peek at the LAUNCHED field in the VMCS, but that
> > would require reverse engineering the VMCS layout for every CPU.  If KVM emulated
> > any VM-wide MSRs, maybe we could throw one in the MSR load list?  But all the ones
> > I can think of, e.g. Hyper-V's partition-wide MSRs, aren't guaranteed to be available.
> 
> Ahh, that explains the deadlock I observed. So adding more states won't
> help. Yeah, it needs some trickery... or those magic sleeps :D

Trickery obtained!  MSR_KVM_WALL_CLOCK_NEW to the rescue.  Even if with a delay
on the AP but not the BSP:

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 6bfd6280..047eb1f5 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9869,7 +9869,7 @@ static void vmx_sipi_test_guest(void)
                /* wait AP enter guest with activity=WAIT_SIPI */
                while (vmx_get_test_stage() != 1)
                        ;
-               delay(SIPI_SIGNAL_TEST_DELAY);
+               // delay(SIPI_SIGNAL_TEST_DELAY);
 
                /* First SIPI signal */
                apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
@@ -9938,6 +9938,7 @@ static void sipi_test_ap_thread(void *data)
        vmcs_write(GUEST_ACTV_STATE, ACTV_WAIT_SIPI);
 
        vmx_set_test_stage(1);
+       delay(SIPI_SIGNAL_TEST_DELAY);
 
        /* AP enter guest */
        enter_guest();

Writing MSR_KVM_WALL_CLOCK_NEW via the AP's VM-Entry load list passes with.

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 510454a6..2d140ee5 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6,6 +6,7 @@
 
 #include <asm/debugreg.h>
 
+#include "kvmclock.h"
 #include "vmx.h"
 #include "msr.h"
 #include "processor.h"
@@ -1967,7 +1968,7 @@ struct vmx_msr_entry {
        u32 index;
        u32 reserved;
        u64 value;
-} __attribute__((packed));
+} __attribute__((packed)) __attribute__((aligned(16)));
 
 #define MSR_MAGIC 0x31415926
 struct vmx_msr_entry *exit_msr_store, *entry_msr_load, *exit_msr_load;
@@ -9861,6 +9862,8 @@ static void vmx_init_signal_test(void)
         */
 }
 
+static bool use_kvm_wall_clock;
+
 #define SIPI_SIGNAL_TEST_DELAY 100000000ULL
 
 static void vmx_sipi_test_guest(void)
@@ -9869,7 +9872,7 @@ static void vmx_sipi_test_guest(void)
                /* wait AP enter guest with activity=WAIT_SIPI */
                while (vmx_get_test_stage() != 1)
                        ;
-               delay(SIPI_SIGNAL_TEST_DELAY);
+               // delay(SIPI_SIGNAL_TEST_DELAY);
 
                /* First SIPI signal */
                apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
@@ -9903,6 +9906,12 @@ static void vmx_sipi_test_guest(void)
        }
 }
 
+static const struct vmx_msr_entry msr_load_wall_clock = {
+       .index = MSR_KVM_WALL_CLOCK_NEW,
+       .reserved = 0,
+       .value = 1,
+};
+
 static void sipi_test_ap_thread(void *data)
 {
        struct guest_regs *regs = this_cpu_guest_regs();
@@ -9937,7 +9946,15 @@ static void sipi_test_ap_thread(void *data)
        /* Set guest activity state to wait-for-SIPI state */
        vmcs_write(GUEST_ACTV_STATE, ACTV_WAIT_SIPI);
 
-       vmx_set_test_stage(1);
+       if (use_kvm_wall_clock) {
+               wrmsr(MSR_KVM_WALL_CLOCK_NEW, 0);
+               vmcs_write(ENT_MSR_LD_CNT, 1);
+               vmcs_write(ENTER_MSR_LD_ADDR, virt_to_phys(&msr_load_wall_clock));
+       } else {
+               vmx_set_test_stage(1);
+       }
+
+       delay(SIPI_SIGNAL_TEST_DELAY);
 
        /* AP enter guest */
        enter_guest();
@@ -9980,6 +9997,8 @@ static void vmx_sipi_signal_test(void)
        u64 cpu_ctrl_0 = CPU_SECONDARY;
        u64 cpu_ctrl_1 = 0;
 
+       use_kvm_wall_clock = this_cpu_has_kvm() && this_cpu_has(KVM_FEATURE_CLOCKSOURCE2);
+
        /* passthrough lapic to L2 */
        disable_intercept_for_x2apic_msrs();
        vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
@@ -9996,6 +10015,13 @@ static void vmx_sipi_signal_test(void)
        /* start AP */
        on_cpu_async(1, sipi_test_ap_thread, NULL);
 
+       if (use_kvm_wall_clock) {
+               while (rdmsr(MSR_KVM_WALL_CLOCK_NEW) != 1)
+                       cpu_relax();
+
+               vmx_set_test_stage(1);
+       }
+
        /* BSP enter guest */
        enter_guest();
 }
 

