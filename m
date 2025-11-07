Return-Path: <kvm+bounces-62265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE673C3E63C
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 04:48:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 297CA188A5AD
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 03:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8C272046BA;
	Fri,  7 Nov 2025 03:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUiJEjyg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8471314F70
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 03:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762487297; cv=none; b=LO3W4XZ3yfBH9iPNemlL/hflgj9jKF1Ea4M//lzcB/58pm6lkwps0HHo2B2DjzDhyviO/YbCVFp48NuOr7blmHVY2ZEOnSR/T/EngYD7Hq9ZXET2JddgmCrUa/xh5fW44sPOjCadFK1lPWXJvNUyzZ7f2QQgs3DaQI0Isplkfp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762487297; c=relaxed/simple;
	bh=442eqadcHzio0qf/stWiPJed66HJJL13Xmo3zWX5t9w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qJkKzKy+T9pXDoHKRSR+nw7Sht6miNIDlVKMSeW8+Xg84USyEjQ3pvaNb9T7iflyXcQj7xx8Zugl8qTTj7ecDvSb39wwGB9thlNyesjdLtgWSewgOB0dSUadFDncI+3DpMIdfGjYXXQrt3QgW1oWjFSw4Gm0XFWLIBBHKAuYZFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUiJEjyg; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-340cccf6956so232813a91.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 19:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762487295; x=1763092095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MxGmPbv+36kk7i4AWF1GAropKIoZf8pJ2g2kJsx2bXg=;
        b=aUiJEjygcQmIL34LHkQ5bwi3jduGxN+kzqtHBKRcJUTIwuJEhNhBZYrCxIRqBy/LAO
         6pMMHHJlDgouznCsoyesHvD6uPglk2+2mx5oh0QDurDuTJe/4hn/9HLVhEyK3px4PqIH
         wVfbs4oztbFzvZI8l0wGqxMUCJ6REajeREOiZ8Ru4pE0UuID5NkcmKz9Q8b9KCMvay96
         J7chA6wVeS08B/OpNFQQvAu76RVn+uwBf5dIp6+yJqgIP+9ABtgV++1dtJItj+TH+WB/
         C7rcymD0r6xG91j9Vx3dYUGP590KgzjzY0iNVYNAm9Yq6PyGRRhGr3Bd2mYP2iGLLXKj
         NUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762487295; x=1763092095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MxGmPbv+36kk7i4AWF1GAropKIoZf8pJ2g2kJsx2bXg=;
        b=WfnjVeT7JlbUV+cnl5ax+2eIR5ASX0gsb1uucHykTmGOcwvHsOCuWwa8qluJ0tlYps
         q/QmDurOcUrfPrDT3bca43azlNM8XNyixHrySSoR8bS2EDgLrWqChIbltdKhbC9cm3pt
         cCB5wQb8VzJYfFrNQHll4JCPX8EtAMAtARXJccMVIbUn/IaSLr9+9R/e42GTOP0eKa8R
         XSa9ezKXzFFt17Oxv1ixuTgspdAe3qenL9mv3U6iXOBown64PciFZLAVqtYHb31nx+Ny
         kxaF7zm0AWkwYPKOzjW2tRdDWejOy0KkXUNZ2oDVb9LZhkIP6MQI2hnNINLL5LsYgYYP
         1wyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlkG9kzVuYU9fw1evbTbMn01q9HEebER4UmziZ6bCJxJQo7Z55msp1DAOBnZG9HYoSToc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/omHKFbYNdESZIeigpwykIcn1ZE7pcjic3rO8lL1qrrcQwXSG
	wKUE97jHlQ1imwL3C4k3crIHpSMmuNbviGkeuWWABPh8nB56u4Lk0QZX
X-Gm-Gg: ASbGncsLV4z8zSUpGtW5TdavLo2bx/+aNs2QhhPSYzeaLnmCfec6Vf2m8zkJtomzghs
	6Lcjck44Pl+cI1PvBx0E2EyOf6gR78H/8cEOPL9+XHnu9rOou3ZTClUTncOwSx/gWzWWy96Th3P
	N9evyF2TVgsrB8NoWbDQj8dYltKIhlAoC45V2d7l9u8o6B4uLUWnZDJ6o92liNusZxD+vfucQ3m
	33jruRX0e8stAk3D4Zz/dChmz7G+eS2PYLry+LmnlrXA8MHL5LeI54zpNvPo3C/AmOPI2EmYj6W
	JNlbG2L2UsPTXAIVURE/12PdHdLzFbWTTsRcq61UMfhCxyOdtmGmPKK6QK/ntSE8feRPrHUSVN9
	T2pSFoyUwMe5ajE3hOIYCbo35lftEEtQ8i4Qi2S0qY8PAXDf3tH7CXGCQLAIYR6Lt4ETczu92Tr
	ZhoJSvtj/b7Ze/b8dzyA==
X-Google-Smtp-Source: AGHT+IEsn7E1xrWwBVAA3UJlPFxnkFIozsp7ECdOPBKH4YIoxMww2ThRv51KM04jqJiCgXo74xxoJg==
X-Received: by 2002:a17:90b:5250:b0:33e:2d0f:479c with SMTP id 98e67ed59e1d1-3434c5633cbmr1561991a91.22.1762487294718;
        Thu, 06 Nov 2025 19:48:14 -0800 (PST)
Received: from localhost.localdomain ([129.227.63.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3434c356300sm989552a91.18.2025.11.06.19.48.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Nov 2025 19:48:14 -0800 (PST)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: fuqiang wang <fuqiang.wng@gmail.com>,
	yu chen <33988979@163.com>,
	dongxu zhang <xu910121@sina.com>
Subject: [PATCH v5 0/1] KVM: x86: fix some kvm period timer BUG
Date: Fri,  7 Nov 2025 11:47:59 +0800
Message-ID: <20251107034802.39763-1-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

This patch fixes two issues with the period timer:

====================================================================
issue 1: avoid hv timer fallback to sw timer if delay exceeds period 
====================================================================

When the guest uses the APIC periodic timer, if the next period has already
expired, e.g. due to the period being smaller than the delay in processing
the timer, the delta will be negative. nsec_to_cycles() may then convert
this delta into an absolute value larger than guest_l1_tsc, resulting in a
negative tscdeadline. Since the hv timer supports a maximum bit width of
cpu_preemption_timer_multi + 32, this causes the hv timer setup to fail and
switch to the sw timer.

Moreover, due to the commit 98c25ead5eda ("KVM: VMX: Move preemption timer
<=> hrtimer dance to common x86"), if the guest is using the sw timer
before blocking, it will continue to use the sw timer after being woken up,
and will not switch back to the hv timer until the relevant APIC timer
register is reprogrammed.  Since the periodic timer does not require
frequent APIC timer register programming, the guest may continue to use the
software timer for an extended period.

Link [1] reproduces this issue by injecting a kernel module. This module
creates a periodic hrtimer and adds a certain delay in its callback, making
the delay longer than the KVM periodic timer period.

======================================================================
issue 2: VM hard lockup after prolonged suspend with periodic HV timer
======================================================================

Resuming a virtual machine after it has been suspended for a long time may
trigger a hard lockup. 

The main reason is that the KVM periodic HV timer only advances during the
VM-exit “VMX-preemption timer expired” event and  when the vCPU is
suspended or returns to user space for other reasons, the KVM timer stops
advancing. Since the periodic timer expiration callback advances the timer
by one period per invocation, this results in the callback being executed
many times to catch up the expiration to the current timer value.

Due to issue 1, the KVM periodic HV timer will switch to the software
timer, and these catch-up will be executed within a single clock interrupt.
If this process lasts long enough, it can easily lead to a hard lockup.

One of our Windows virtual machines in the production environment triggered
this case:
  NMI watchdog: Watchdog detected hard LOCKUP on cpu 45
  ...
  RIP: 0010:advance_periodic_target_expiration+0x4d/0x80 [kvm]
  ...
  RSP: 0018:ff4f88f5d98d8ef0 EFLAGS: 00000046
  RAX: fff0103f91be678e RBX: fff0103f91be678e RCX: 00843a7d9e127bcc
  RDX: 0000000000000002 RSI: 0052ca4003697505 RDI: ff440d5bfbdbd500
  RBP: ff440d5956f99200 R08: ff2ff2a42deb6a84 R09: 000000000002a6c0
  R10: 0122d794016332b3 R11: 0000000000000000 R12: ff440db1af39cfc0
  R13: ff440db1af39cfc0 R14: ffffffffc0d4a560 R15: ff440db1af39d0f8
  FS:  00007f04a6ffd700(0000) GS:ff440db1af380000(0000) knlGS:000000e38a3b8000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000000d5651feff8 CR3: 000000684e038002 CR4: 0000000000773ee0
  PKRU: 55555554
  Call Trace:
   <IRQ>
   apic_timer_fn+0x31/0x50 [kvm]
   __hrtimer_run_queues+0x100/0x280
   hrtimer_interrupt+0x100/0x210
   ? ttwu_do_wakeup+0x19/0x160
   smp_apic_timer_interrupt+0x6a/0x130
   apic_timer_interrupt+0xf/0x20
   </IRQ>

And in link [2], Marcelo also reported this issue. But I don't think it can
reproduce the issue. Because of commit [3], as long as the KVM timer is
running, target_expiration will keep catching up to now (unless every
single delay from timer virtualization is longer than the period, which is
a pretty extreme case). Also, this patch is based on the patch of link [2],
but with some differences: In link [2], target_expiration is updated to
"now - period"(I'm not sure why it doesn't just catch up to now -- maybe
I'm missing something?). In this patch, I set target_expiration to catch up
to now just like how update_target_expiration handles the remaining.

Link [4] provides details of the hard lockup details and as well as how to
reproduce the KVM timer stop by pausing the virtual machine.

=================================
Fix both issues in a single patch
=================================

In versions v2 and v3, I split these two issues into two separate patches
for fixing. However, this caused patch 2 to revert some of the changes made
by patch 1.

In patch 4, I attempted to merge the two patches into one and tried to
describe both issues in the commit message, but I did not do it well. In
this version, I have included more details in the commit message and the
cover letter.

Changes in v5:
- Add more details in commit messages and letters.
- link to v4: https://lore.kernel.org/all/20251105135340.33335-1-fuqiang.wng@gmail.com/

Changes in v4:
- merge two patch into one
- link to v3: https://lore.kernel.org/all/20251022150055.2531-1-fuqiang.wng@gmail.com/

Changes in v3:
- Fix: advanced SW timer (hrtimer) expiration does not catch up to current
  time.
- optimize the commit message of patch 2
- link to v2: https://lore.kernel.org/all/20251021154052.17132-1-fuqiang.wng@gmail.com/

Changes in v2:
- Added a bugfix for hardlockup in v2
- link to v1: https://lore.kernel.org/all/20251013125117.87739-1-fuqiang.wng@gmail.com/

[1]: https://github.com/cai-fuqiang/kernel_test/tree/master/period_timer_test
[2]: https://lore.kernel.org/kvm/YgahsSubOgFtyorl@fuller.cnet/
[3]: commit d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
[4]: https://github.com/cai-fuqiang/md/tree/master/case/intel_kvm_period_timer

fuqiang wang (1):
  KVM: x86: Fix VM hard lockup after prolonged suspend with periodic HV
    timer

 arch/x86/kvm/lapic.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

-- 
2.47.0


