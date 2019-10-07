Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF95CE0FB
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 13:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfJGL5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 07:57:40 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41316 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfJGL5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 07:57:40 -0400
Received: by mail-ed1-f66.google.com with SMTP id f20so12106119edv.8
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 04:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rDQ20V9uLNcqWB97jPsuLuN7Jzo7LgwLu2gpmwH3EQs=;
        b=cuFw0ZfReMx1L8G+e346BwYa/kgKz8QgVeIglP1hXoNGGZ8GqO6vPY6mW3O/TW1OXr
         Opl1B/noBKQLtIkcZHCyzd3kuCAUUulxYDsNLj91S7qpsBh271CTNIOyLvzuImcWBVRi
         FJ9r0WXgmRU0U2i/i0w1JGSuR2QaFgQkDuM6sSuxVB6apZTrafVQHoVjHUX2TJM2wgoo
         wOSYwL2gp41s7XkRWwcQ9pXNbUzUjbiQRmo0+bylRi9+qbg/i93eVUmRYtIHPx7gSDEW
         KKJCoMBJbtozJ2/3nUD0CgLEt4XgHjIwPNvFaytgGg4/MiMGzEgpiAzgn5XhptC7pqLX
         gQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rDQ20V9uLNcqWB97jPsuLuN7Jzo7LgwLu2gpmwH3EQs=;
        b=bx6FQbhd0drZQJow7KJ3o8wL+h9FB791+9xOASSSmJGigTfdkLERURbjs1qjFZVENj
         EH5zYfBuLA22/tFEGfLK8zpv1uggIungPEWWj4QDHb860vzDnIsjPTTY8LIspiocYgR3
         gSc5cHTAYHL12mn9vXo/JNxUXsWiQZMYs6LJAhUJoYN8htlBL+Xe+BXGtnk2tJZEwlEa
         eXZVdyK1phbtVG+ShORJ1kFplhHhQw8rwufY1mmNcoHEHHTTOYQNuTDnnjmcLoPOrVDo
         su115vOfiGymIBO4JooCeVP+olbgQSrdpyCx/mCnjSmG1Ke54Cp0u/LSom0EzUXWY18q
         H2hA==
X-Gm-Message-State: APjAAAWN80UflW/Ti4Xqo6iv293s5dRpKD6U6Kl31n6b8hBoAakIOnQQ
        O9cZt2PdOBOukyMfOH6BxzA=
X-Google-Smtp-Source: APXvYqxiQi7T1g2y9gARkUZyVVwryGrZs1cOyEin4et4UcEm8vqXVbEmwX+zoqnkCLt8ZK+quKxgAw==
X-Received: by 2002:a17:906:8041:: with SMTP id x1mr23663753ejw.132.1570449458022;
        Mon, 07 Oct 2019 04:57:38 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([2001:1438:4010:2558:f50b:fd6b:fe5b:ba84])
        by smtp.gmail.com with ESMTPSA id m19sm1793068eja.35.2019.10.07.04.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 04:57:37 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, x86@kernel.org, kvm@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH] kvm: avoid NULL pointer deref in kvm_write_guest_virt_system
Date:   Mon,  7 Oct 2019 13:57:36 +0200
Message-Id: <20191007115736.15354-1-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

kvm-unit-test triggered a NULL pointer deref below:
[  948.518437] kvm [24114]: vcpu0, guest rIP: 0x407ef9 kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
[  949.106464] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[  949.106707] PGD 0 P4D 0
[  949.106872] Oops: 0002 [#1] SMP
[  949.107038] CPU: 2 PID: 24126 Comm: qemu-2.7 Not tainted 4.19.77-pserver #4.19.77-1+feature+daily+update+20191005.1625+a4168bb~deb9
[  949.107283] Hardware name: Dell Inc. Precision Tower 3620/09WH54, BIOS 2.7.3 01/31/2018
[  949.107549] RIP: 0010:kvm_write_guest_virt_system+0x12/0x40 [kvm]
[  949.107719] Code: c0 5d 41 5c 41 5d 41 5e 83 f8 03 41 0f 94 c0 41 c1 e0 02 e9 b0 ed ff ff 0f 1f 44 00 00 48 89 f0 c6 87 59 56 00 00 01 48 89 d6 <49> c7 00 00 00 00 00 89 ca 49 c7 40 08 00 00 00 00 49 c7 40 10 00
[  949.108044] RSP: 0018:ffffb31b0a953cb0 EFLAGS: 00010202
[  949.108216] RAX: 000000000046b4d8 RBX: ffff9e9f415b0000 RCX: 0000000000000008
[  949.108389] RDX: ffffb31b0a953cc0 RSI: ffffb31b0a953cc0 RDI: ffff9e9f415b0000
[  949.108562] RBP: 00000000d2e14928 R08: 0000000000000000 R09: 0000000000000000
[  949.108733] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffffc8
[  949.108907] R13: 0000000000000002 R14: ffff9e9f4f26f2e8 R15: 0000000000000000
[  949.109079] FS:  00007eff8694c700(0000) GS:ffff9e9f51a80000(0000) knlGS:0000000031415928
[  949.109318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  949.109495] CR2: 0000000000000000 CR3: 00000003be53b002 CR4: 00000000003626e0
[  949.109671] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  949.109845] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  949.110017] Call Trace:
[  949.110186]  handle_vmread+0x22b/0x2f0 [kvm_intel]
[  949.110356]  ? vmexit_fill_RSB+0xc/0x30 [kvm_intel]
[  949.110549]  kvm_arch_vcpu_ioctl_run+0xa98/0x1b30 [kvm]
[  949.110725]  ? kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
[  949.110901]  kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
[  949.111072]  do_vfs_ioctl+0xa2/0x620

The commit introduced the bug is 541ab2aeb282, it has been backported to
at least stable 4.14.145+ and 4.19.74+, to fix it, just check the
exception not NULL before do the memset. The fix should go to stable.

Fixes: 541ab2aeb282 ("KVM: x86: work around leak of uninitialized stack contents")
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>

---
I did the kvm-unit-tests on top of 4.19.77, it no longer crash with the fix,
and it applies cleanly to v5.4-rc2.
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf38526..9fd734fcacb5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5438,7 +5438,8 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
 	 * uninitialized kernel stack memory into cr2 and error code.
 	 */
-	memset(exception, 0, sizeof(*exception));
+	if (exception)
+		memset(exception, 0, sizeof(*exception));
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
 }
-- 
2.17.1

