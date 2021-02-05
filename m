Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AA63116E7
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 00:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhBEXT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 18:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhBEKEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 05:04:13 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9E8C061794
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 02:03:27 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id m6so4015115pfk.1
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbYQyh/wUPH5WcnSCH7zbiSdkAdjW/rNp5kroeeG+hQ=;
        b=oXwCFwAIzW1+p8qYzYussJeJMDKDssCHnCVHnxhympWx+CHOZ6zhK3D+PrN+EHfBtg
         1IV1X23575kPhbgfbZcJghneTAR4ayzRV1uAe870b0w9HF8b90msSuz1/Ak1imfvwzWE
         qGmMvdpV/0A/Hr3mczZqhz1sgwWcgIhwfCXMuqiaLRieY7KxWn9s76rypPG5KMHkYc69
         BO+Lo8JdpDtN9Vo+8Llv1Sb0lSwvFSWKmsvlgQnLYOEav/X7l90ryqxGiW0q9iOGCxgA
         n8+oHdvppb01HQT2IJ5lkekz9mhZBVQMG7P06MuythPAJaJSFswA7nZ25b3LZoh1TR3Q
         6zRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbYQyh/wUPH5WcnSCH7zbiSdkAdjW/rNp5kroeeG+hQ=;
        b=Zo1cZxLn1AynPiFoAyxHwlWUnAWk44CCkJFdNDZ+2gJj63yoc37p1/me/3XO0rAcvh
         P9FDkvHzyhYbudBiddfvOeWKb96iDKOhmRXRDAFnYGP/lko20eQBemG3HF2+tsJCFeV6
         htCwTyxFX/xTZicsul/bLTzwmfR32oAujNzkPkklM2BuqR23Ord3tEsoGnUo/I/suRnS
         6DNmgXLoGZweUEnkLPIcwlEBH2XukVawLp7eV6ltqagUe5yn1FghIRQYZj1JeX+Vt94C
         2kfsRo4guCAZBS2IRSf/f/MLS+NrwdD6Lz6F3qaXuI39701hVKJCRttOHA+XOuSOVoPH
         B54A==
X-Gm-Message-State: AOAM530eQVn+s7wdXItTIDW1eFFQaOzQazZ9ContFTRV+3KjH/Er9rVG
        vBvnitibQ6j1NjZ5mRBVdpJGTw==
X-Google-Smtp-Source: ABdhPJxsOqdEPug9LcOofBdQrmkfXtTjd5kRElPCsAo3oxuUzCRmjprv29fFJ3DkqZrzLOYovaPP9g==
X-Received: by 2002:a62:7dc4:0:b029:1ba:765:3af with SMTP id y187-20020a627dc40000b02901ba076503afmr3722368pfc.78.1612519407070;
        Fri, 05 Feb 2021 02:03:27 -0800 (PST)
Received: from C02CC49MMD6R.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id l12sm8142562pjg.54.2021.02.05.02.03.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:03:26 -0800 (PST)
From:   Zhimin Feng <fengzhimin@bytedance.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com, Zhimin Feng <fengzhimin@bytedance.com>
Subject: [RESEND RFC: timer passthrough 0/9] Support timer passthrough for VM
Date:   Fri,  5 Feb 2021 18:03:08 +0800
Message-Id: <20210205100317.24174-1-fengzhimin@bytedance.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main motivation for this patch is to improve the performance of VM.
This patch series introduces how to enable the timer passthrough in
non-root mode.

The main idea is to offload the host timer to the preemtion timer in
non-root mode. Through doing this, guest can write tscdeadline msr directly
in non-root mode and host timer isn't lost. If CPU is in root mode,
guest timer is switched to software timer.

Testing on Intel(R) Xeon(R) Platinum 8260 server.

The guest OS is Debian(kernel: 4.19.28). The specific configuration is
 is as follows: 8 cpu, 16GB memory, guest idle=poll
memcached in guest(memcached -d -t 8 -u root)

I use the memtier_benchmark tool to test performance
(memtier_benchmark -P memcache_text -s guest_ip -c 16 -t 32
 --key-maximum=10000000000 --random-data --data-size-range=64-128 -p 11211
 --generate-keys --ratio 5:1 --test-time=500)

Total Ops can be improved 25% and Avg.Latency can be improved 20% when
the timer-passthrough is enabled.

=============================================================
               | Enable timer-passth | Disable timer-passth |
=============================================================
Totals Ops/sec |    514869.67        |     411766.67        |
-------------------------------------------------------------
Avg.Latency    |    0.99483          |     1.24294          |
=============================================================


Zhimin Feng (9):
  KVM: vmx: hook set_next_event for getting the host tscd
  KVM: vmx: enable host lapic timer offload preemtion timer
  KVM: vmx: enable passthrough timer to guest
  KVM: vmx: enable passth timer switch to sw timer
  KVM: vmx: use tsc_adjust to enable tsc_offset timer passthrough
  KVM: vmx: check enable_timer_passth strictly
  KVM: vmx: save the initial value of host tscd
  KVM: vmx: Dynamically open or close the timer-passthrough for pre-vm
  KVM: vmx: query the state of timer-passth for vm

 arch/x86/include/asm/kvm_host.h |  27 ++++
 arch/x86/kvm/lapic.c            |   1 +
 arch/x86/kvm/vmx/vmx.c          | 331 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  26 +++-
 include/linux/kvm_host.h        |   1 +
 include/uapi/linux/kvm.h        |   3 +
 kernel/time/tick-common.c       |   1 +
 tools/include/uapi/linux/kvm.h  |   3 +
 virt/kvm/kvm_main.c             |   1 +
 9 files changed, 389 insertions(+), 5 deletions(-)

-- 
2.11.0

