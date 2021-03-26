Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E588634A7C2
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 14:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCZNCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 09:02:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230188AbhCZNBq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 09:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616763705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JRQaAdx++mnEYaHuCYocWMdWO77qGEyQoebROUQWcRY=;
        b=feIxPSrDrC/GnEtBb6gZjUPB7kYBXXJ+eof9fMRZBBUhIFcH3YthJP0tWmOuvvcrfufviX
        WcxPAKXapueCxCmW/zgX/p5PJDzsWjZCbScc97Z3xb19RIjg2nUicd2INIU9k8ETHYqzCW
        GxW7/lmop1rwLCvvs5v5EoY0fHpXoVk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-FxtENkUYO4mC4pL1tcWaig-1; Fri, 26 Mar 2021 09:01:43 -0400
X-MC-Unique: FxtENkUYO4mC4pL1tcWaig-1
Received: by mail-ed1-f72.google.com with SMTP id t27so4372699edi.2
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 06:01:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JRQaAdx++mnEYaHuCYocWMdWO77qGEyQoebROUQWcRY=;
        b=E8DnlvxvXGQ/3w8kusmKHbJVut9hHNpDz3HppvmIJz9ACSuHgUlvvMvJ3ue/V/KzId
         1/SgFGVjOJXSSHBYOnXFApdQbA7oGwo9iAI7D2ssh4pT+xmkHcIh9fD7PsHs7oVoBnZP
         usSvQ3O4WhUHcIN816+6tODPxUFk0kUYlIjdHpkR7RwboWiI0B2BnAAXGawt6bGAShJF
         hm0ZdmVVV94h/tvpnrN1CmyluLhgiPshrns7+60DUvyWvLoMv9ULprlNH5B2ovX7AINJ
         uJVDpA5/OqeYdwzB+oHS3fIXfHXb3AHb9Qk90qAYElB1eRFcFKlVofoYh/n92UjpIe3h
         0wQA==
X-Gm-Message-State: AOAM532WuhsGcKoFh1xWbhNyxpYWeQ7fziRq6Xuwt+EghDtfk1S9ke7A
        QzGzChe2URq/CHGdBcS2TSpKyMWed8shyWlJj7JKm5fWWxoBMPz0NwwPvhlEr4jHgvXU0W6VGYo
        OLTeAiVRt/HGq
X-Received: by 2002:a17:906:b1d4:: with SMTP id bv20mr15320387ejb.46.1616763702281;
        Fri, 26 Mar 2021 06:01:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEuG33i2lwyoA414gaiALmarFRKkgBZbTIDTcF53mrBWq0VE+HhSSWFtli+8L9nxF3XVhj2g==
X-Received: by 2002:a17:906:b1d4:: with SMTP id bv20mr15319976ejb.46.1616763696619;
        Fri, 26 Mar 2021 06:01:36 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r24sm4150534edw.11.2021.03.26.06.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 06:01:36 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Lenny Szubowicz <lszubowi@redhat.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/kvmclock: Stop kvmclocks for hibernate restore
In-Reply-To: <87h7kyccpu.fsf@vitty.brq.redhat.com>
References: <20210311132847.224406-1-lszubowi@redhat.com>
 <87sg4t7vqy.fsf@vitty.brq.redhat.com>
 <5048babd-a40b-5a95-9dee-ab13367de6cb@redhat.com>
 <87mtuqchdu.fsf@vitty.brq.redhat.com>
 <87h7kyccpu.fsf@vitty.brq.redhat.com>
Date:   Fri, 26 Mar 2021 14:01:35 +0100
Message-ID: <87eeg2cbm8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

..

> (this is with your v2 included). There's nothing about CPU0 for
> e.g. async PF + timestamps are really interesting. Seems we have issues
> to fix) I'm playing with it right now.

What if we do the following (instead of your patch):

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 78bb0fae3982..c32392d6329d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -26,6 +26,7 @@
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
 #include <linux/swait.h>
+#include <linux/syscore_ops.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -598,17 +599,21 @@ static void kvm_guest_cpu_offline(void)
 
 static int kvm_cpu_online(unsigned int cpu)
 {
-	local_irq_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	kvm_guest_cpu_init();
-	local_irq_enable();
+	local_irq_restore(flags);
 	return 0;
 }
 
 static int kvm_cpu_down_prepare(unsigned int cpu)
 {
-	local_irq_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	kvm_guest_cpu_offline();
-	local_irq_enable();
+	local_irq_restore(flags);
 	return 0;
 }
 #endif
@@ -639,6 +644,23 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 	native_flush_tlb_others(flushmask, info);
 }
 
+static int kvm_suspend(void)
+{
+	kvm_guest_cpu_offline();
+
+	return 0;
+}
+
+static void kvm_resume(void)
+{
+	kvm_cpu_online(raw_smp_processor_id());
+}
+
+static struct syscore_ops kvm_syscore_ops = {
+	.suspend	= kvm_suspend,
+	.resume		= kvm_resume,
+};
+
 static void __init kvm_guest_init(void)
 {
 	int i;
@@ -681,6 +703,8 @@ static void __init kvm_guest_init(void)
 	kvm_guest_cpu_init();
 #endif
 
+	register_syscore_ops(&kvm_syscore_ops);
+
 	/*
 	 * Hard lockup detection is enabled by default. Disable it, as guests
 	 * can get false positives too easily, for example if the host is
-- 
2.30.2

This seems to work fine (according to the log, I haven't checked yet
that PV features are actually working):

[   20.678081] PM: hibernation: Creating image:
[   20.689925] PM: hibernation: Need to copy 82048 pages
[    2.302411] kvm-clock: cpu 0, msr 2c201001, primary cpu clock, resume
[    2.302487] PM: Restoring platform NVS memory
[    2.302498] kvm-guest: KVM setup async PF for cpu 0
[    2.302502] kvm-guest: stealtime: cpu 0, msr 3ec2c080
[    2.304754] Enabling non-boot CPUs ...
[    2.304823] x86: Booting SMP configuration:
[    2.304824] smpboot: Booting Node 0 Processor 1 APIC 0x1
[    2.304952] kvm-clock: cpu 1, msr 2c201041, secondary cpu clock
[    2.305400] kvm-guest: KVM setup async PF for cpu 1
[    2.305405] kvm-guest: stealtime: cpu 1, msr 3ecac080
[    2.305786] CPU1 is up
[    2.305818] smpboot: Booting Node 0 Processor 2 APIC 0x2
[    2.305920] kvm-clock: cpu 2, msr 2c201081, secondary cpu clock
[    2.306325] kvm-guest: KVM setup async PF for cpu 2
[    2.306330] kvm-guest: stealtime: cpu 2, msr 3ed2c080
[    2.306599] CPU2 is up
[    2.306627] smpboot: Booting Node 0 Processor 3 APIC 0x3
[    2.306729] kvm-clock: cpu 3, msr 2c2010c1, secondary cpu clock
[    2.307092] kvm-guest: KVM setup async PF for cpu 3
[    2.307097] kvm-guest: stealtime: cpu 3, msr 3edac080
[    2.307383] CPU3 is up
[    2.307560] ACPI: Waking up from system sleep state S4
[    2.318778] sd 0:0:0:0: [sda] Starting disk
[    2.342335] OOM killer enabled.
[    2.342817] Restarting tasks ... done.
[    2.346209] PM: hibernation: hibernation exit

-- 
Vitaly

