Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7319D694CE6
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 17:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjBMQbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 11:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjBMQbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 11:31:47 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2656D1DBB5
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:39 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a2so12866468wrd.6
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KeERnmdF2+s9ODJ9a6V5Rn9dBXMjzRzsHWfACjpeGRk=;
        b=u8fRa19NrK7Q1oUhx33VIZAKdUntjGIgf5rram8YOJh41RyKxz5/x8Jq+BNmA1fmtB
         ZKxy062/BDKQVUmlBJNyOalC7O3lWhDcHWFo6+DQl6Uy762Nj3Ro1dSbhK0In4+NuIpa
         aT4DbrTDBykiSmkL3W1dodT+Kj2QN1zQADxveHJktEtdjty471zNSxbVJ3nHxy3rwdSE
         Taze7V8MqEpUy18G5EX4v1hMdtWNdW2qq2KeKP85Z/pb4hx7XtIMQRL8fRimj9pLzyEu
         cHrayMkz9EY2931prdAdvOpoWJ3rVse3liexfbQhwlCz5bPV8QeP9lKaRF+qGZMqkjFw
         ho6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KeERnmdF2+s9ODJ9a6V5Rn9dBXMjzRzsHWfACjpeGRk=;
        b=Zcjbea1aMG8a5drc0vX3aYflGwSedUS587yKjPfWBM5VxzgcL4JWaxTh1mkFxDXS1Q
         0cdsTb5KrUXszBOr51QCJE6DEZnuCPmNWbOkPQw0tQKbLs27M8PMtPPGe7kqkncuA/5X
         ZV2c03TQTJYnOwA/3c+TrhK3uhHTNJsvR4K3agfHMn68ZuJXWZWoVieCiGy/UYuNKXiA
         q6n0nISqQiyBDHd2eIZBgtSWGU3qraqyzB4ndLGbzHpWTreUqZ/lmrBqY0JNw2apAnc4
         +AxbpjD5eVjk1kmRlDX37jRJTLHrOBYXs2pw6QR/2jYX5zM7ajwPRp2zYb1NUUtCIQPm
         /Bfg==
X-Gm-Message-State: AO0yUKW/wd8PDTgnpgQ9gS/plJ5QzCTAluQmuIPrhs1+ZedH0TLEOwBQ
        w1eDTnS31LWJEMwta4K69Z4f7g8fUqynoIM1
X-Google-Smtp-Source: AK7set9TmjES6zIKxCUaXDaE/A9p/5EeNQngd5y7g75fyMykh2lCuLzZmf40RpiHHjyIu3fQUAYfhg==
X-Received: by 2002:adf:fec7:0:b0:2c5:4cf1:a57b with SMTP id q7-20020adffec7000000b002c54cf1a57bmr8792783wrs.35.1676305897545;
        Mon, 13 Feb 2023 08:31:37 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af2efd00225e3e97da45b943.dip0.t-ipconnect.de. [2003:f6:af2e:fd00:225e:3e97:da45:b943])
        by smtp.gmail.com with ESMTPSA id s7-20020a5d5107000000b002c556a4f1casm3877993wrt.42.2023.02.13.08.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:31:37 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 0/5] KVM: Put struct kvm_vcpu on a diet
Date:   Mon, 13 Feb 2023 17:33:46 +0100
Message-Id: <20230213163351.30704-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Relayout members of struct kvm_vcpu and embedded structs to reduce its
memory footprint. Not that it makes sense from a memory usage point of
view (given how few of such objects get allocated), but this series
achieves to make it consume two cachelines less, which should provide a
micro-architectural net win. However, I wasn't able to see a noticeable
difference running benchmarks within a guest VM -- the VMEXIT costs are
likely still high enough to mask any gains. Pointers to other benchmark
tools / tests are highly appreciated!

I made sure that the mutex and spinlocks still stick to their own
disjoint cachelines, so this series shouldn't cause any regression in
that regard.

Below is the high level pahole(1) diff. Most significant is the overall
size change from 6688 to 6560 bytes, i.e. -128 bytes.

--- kvm_vcpu.before	2023-02-13 14:13:49.919952154 +0100
+++ kvm_vcpu.after	2023-02-13 14:13:53.559952140 +0100
@@ -6,78 +6,60 @@
 	int                        vcpu_idx;             /*    40     4 */
 	int                        ____srcu_idx;         /*    44     4 */
 	int                        mode;                 /*    48     4 */
-
-	/* XXX 4 bytes hole, try to pack */
-
+	unsigned int               guest_debug;          /*    52     4 */
 	u64                        requests;             /*    56     8 */
 	/* --- cacheline 1 boundary (64 bytes) --- */
-	long unsigned int          guest_debug;          /*    64     8 */
-	struct mutex               mutex;                /*    72    32 */
-	struct kvm_run *           run;                  /*   104     8 */
-	struct rcuwait             wait;                 /*   112     8 */
-	struct pid *               pid;                  /*   120     8 */
+	struct mutex               mutex;                /*    64    32 */
+	struct kvm_run *           run;                  /*    96     8 */
+	struct rcuwait             wait;                 /*   104     8 */
+	struct pid *               pid;                  /*   112     8 */
+	sigset_t                   sigset;               /*   120     8 */
 	/* --- cacheline 2 boundary (128 bytes) --- */
 	int                        sigset_active;        /*   128     4 */
-
-	/* XXX 4 bytes hole, try to pack */
-
-	sigset_t                   sigset;               /*   136     8 */
-	unsigned int               halt_poll_ns;         /*   144     4 */
-	bool                       valid_wakeup;         /*   148     1 */
+	unsigned int               halt_poll_ns;         /*   132     4 */
+	bool                       valid_wakeup;         /*   136     1 */
 
 	/* XXX 3 bytes hole, try to pack */
 
-	int                        mmio_needed;          /*   152     4 */
-	int                        mmio_read_completed;  /*   156     4 */
-	int                        mmio_is_write;        /*   160     4 */
-	int                        mmio_cur_fragment;    /*   164     4 */
-	int                        mmio_nr_fragments;    /*   168     4 */
-
-	/* XXX 4 bytes hole, try to pack */
-
-	struct kvm_mmio_fragment   mmio_fragments[2];    /*   176    48 */
-	/* --- cacheline 3 boundary (192 bytes) was 32 bytes ago --- */
+	int                        mmio_needed;          /*   140     4 */
+	int                        mmio_read_completed;  /*   144     4 */
+	int                        mmio_is_write;        /*   148     4 */
+	int                        mmio_cur_fragment;    /*   152     4 */
+	int                        mmio_nr_fragments;    /*   156     4 */
+	struct kvm_mmio_fragment   mmio_fragments[2];    /*   160    48 */
+	/* --- cacheline 3 boundary (192 bytes) was 16 bytes ago --- */
 	struct {
-		u32                queued;               /*   224     4 */
-
-		/* XXX 4 bytes hole, try to pack */
-
-		struct list_head   queue;                /*   232    16 */
-		struct list_head   done;                 /*   248    16 */
-		/* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
-		spinlock_t         lock;                 /*   264     4 */
-	} async_pf;                                      /*   224    48 */
-
-	/* XXX last struct has 4 bytes of padding */
-
+		struct list_head   queue;                /*   208    16 */
+		struct list_head   done;                 /*   224    16 */
+		spinlock_t         lock;                 /*   240     4 */
+		u32                queued;               /*   244     4 */
+	} async_pf;                                      /*   208    40 */
 	struct {
-		bool               in_spin_loop;         /*   272     1 */
-		bool               dy_eligible;          /*   273     1 */
-	} spin_loop;                                     /*   272     2 */
-	bool                       preempted;            /*   274     1 */
-	bool                       ready;                /*   275     1 */
+		bool               in_spin_loop;         /*   248     1 */
+		bool               dy_eligible;          /*   249     1 */
+	} spin_loop;                                     /*   248     2 */
+	bool                       preempted;            /*   250     1 */
+	bool                       ready;                /*   251     1 */
 
 	/* XXX 4 bytes hole, try to pack */
 
-	struct kvm_vcpu_arch       arch __attribute__((__aligned__(8))); /*   280  5208 */
-
-	/* XXX last struct has 6 bytes of padding */
-
-	/* --- cacheline 85 boundary (5440 bytes) was 48 bytes ago --- */
-	struct kvm_vcpu_stat       stat;                 /*  5488  1104 */
-	/* --- cacheline 103 boundary (6592 bytes) --- */
-	char                       stats_id[48];         /*  6592    48 */
-	struct kvm_dirty_ring      dirty_ring;           /*  6640    32 */
+	/* --- cacheline 4 boundary (256 bytes) --- */
+	struct kvm_vcpu_arch       arch __attribute__((__aligned__(8))); /*   256  5104 */
+	/* --- cacheline 83 boundary (5312 bytes) was 48 bytes ago --- */
+	struct kvm_vcpu_stat       stat;                 /*  5360  1104 */
+	/* --- cacheline 101 boundary (6464 bytes) --- */
+	char                       stats_id[48];         /*  6464    48 */
+	struct kvm_dirty_ring      dirty_ring;           /*  6512    32 */
 
 	/* XXX last struct has 4 bytes of padding */
 
-	/* --- cacheline 104 boundary (6656 bytes) was 16 bytes ago --- */
-	struct kvm_memory_slot *   last_used_slot;       /*  6672     8 */
-	u64                        last_used_slot_gen;   /*  6680     8 */
-
-	/* size: 6688, cachelines: 105, members: 33 */
-	/* sum members: 6669, holes: 5, sum holes: 19 */
-	/* paddings: 3, sum paddings: 14 */
+	/* --- cacheline 102 boundary (6528 bytes) was 16 bytes ago --- */
+	struct kvm_memory_slot *   last_used_slot;       /*  6544     8 */
+	u64                        last_used_slot_gen;   /*  6552     8 */
+
+	/* size: 6560, cachelines: 103, members: 33 */
+	/* sum members: 6553, holes: 2, sum holes: 7 */
+	/* paddings: 1, sum paddings: 4 */
 	/* forced alignments: 1, forced holes: 1, sum forced holes: 4 */
 	/* last cacheline: 32 bytes */
 } __attribute__((__aligned__(8)));


There are still holes left, i.e. still room for squeezing out a few more
bytes. But I didn't want to destroy the grouping of members nor sprinkle
random structs with __packed just for that. That said, we might still
want to do it to save yet another cacheline (only 32 more bytes to go).

Code wise it seems to save a few instructions as well, likely because of
patch 2, simplifying some of the struct kvm_queued_exception users:

$ size kvm-6.2-rc5{,+patch}/arch/x86/kvm/kvm.ko
   text    data     bss     dec     hex filename
 806277  129095    1168  936540   e4a5c kvm-6.2-rc5/arch/x86/kvm/kvm.ko
 806026  129063    1168  936257   e4941 kvm-6.2-rc5+patch/arch/x86/kvm/kvm.ko

$ bloat-o-meter kvm-6.2-rc5{,+patch}/arch/x86/kvm/kvm.ko
add/remove: 0/2 grow/shrink: 7/11 up/down: 102/-340 (-238)
Function                                     old     new   delta
kvm_vcpu_ioctl_x86_set_vcpu_events           664     707     +43
kvm_multiple_exception                       581     613     +32
kvm_inject_exception                         153     161      +8
kvm_vcpu_ioctl_x86_get_vcpu_events           510     517      +7
__UNIQUE_ID_vermagic166                       67      73      +6
kvm_inject_page_fault                        108     113      +5
kvm_mmu_x86_module_init                      174     175      +1
kvm_vcpu_ready_for_interrupt_injection       134     131      -3
kvm_vcpu_ioctl                              1717    1714      -3
kvm_vcpu_compat_ioctl                        274     271      -3
kvm_sigset_activate                           53      50      -3
kvm_can_do_async_pf                          150     147      -3
kvm_mtrr_get_msr                             290     286      -4
kvm_deliver_exception_payload                139     135      -4
kvm_arch_vcpu_ioctl_set_guest_debug          662     657      -5
x86_emulate_instruction                     1952    1945      -7
kvm_vcpu_reset                              1382    1375      -7
__pfx_kvm_deliver_exception_payload.part      16       -     -16
kvm_deliver_exception_payload.part           122       -    -122
kvm_arch_vcpu_ioctl_run                     7782    7622    -160
Total: Before=635427, After=635189, chg -0.04%


Please apply!

Thanks,

Mathias Krause (5):
  KVM: x86: Shrink struct kvm_pmu
  KVM: x86: Shrink struct kvm_queued_exception
  KVM: Shrink struct kvm_mmu_memory_cache
  KVM: x86: Shrink struct kvm_vcpu_arch
  KVM: Shrink struct kvm_vcpu

 arch/x86/include/asm/kvm_host.h | 30 +++++++++++++++---------------
 include/linux/kvm_host.h        |  6 +++---
 include/linux/kvm_types.h       |  2 +-
 3 files changed, 19 insertions(+), 19 deletions(-)

-- 
2.39.1

