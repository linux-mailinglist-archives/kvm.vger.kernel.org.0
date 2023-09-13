Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7705479E513
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 12:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239721AbjIMKhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 06:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238013AbjIMKhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 06:37:52 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B670FD3;
        Wed, 13 Sep 2023 03:37:48 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1c3887039d4so37475215ad.1;
        Wed, 13 Sep 2023 03:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694601468; x=1695206268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ojXgjXc0jqNFJeHH1Cm2DAbtucHxBYUYh4RahEa6KBs=;
        b=DaL0s2N+9mV6Rl/u4VhjBUfpAkX4C5tn92B0U/PnJxVmTGi13jW5FbstLXmfbFpN4Q
         RJL7ckt2ruTY5S46Uo/bWxoN4ADakLWBD9u/FSMfOHGV/QPbIsgMJfmgn/cxApaJS1Bg
         VQ6tdzgjuWcg9QApIuRYun57HxTjFptMO/knvUcPbwJlKCxIByMoC6NGlQAcKYRsS1iq
         MnEwoAKYp2Erg3VrtIBLT8BuYwDTJ7RxFRhmYDvTDSW/C6VUuh31hk5T6+wTtsXZH7h9
         i+R5EzudGTdi8FMsoS9Zfd8xkot5ySpnl2CNXCLCMWnIaUDsG1/H720z0aMM2XduhoBP
         TOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694601468; x=1695206268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ojXgjXc0jqNFJeHH1Cm2DAbtucHxBYUYh4RahEa6KBs=;
        b=E8WiXvsszcVZmgwKa81IjvVXFD3tYRE4V1oMA1bfh1kT81CgX611/fzlWX831rWCp8
         3fFfAiqvYd9WqAtjyAUMntSc9xaym/wc6/PRFxjIZfAh4YZQGM7QvZElsjZshdgcuPqY
         yKLTR8IgE6+JIdcfMEB3P5sYRCFz55tkJKZdXxIbWTiaMyx70illKQZOhoWC7YLly95q
         Q+w0NwNFQeVnkeIAmsJU6ep86ZW9HGM2h2iAk0huFWpjk3f6LZNyua6+vJ7M727ox5jZ
         b1m3sFhX8UbyzqHKAyvD3bxugeNPOX5XgCJe/dNuMqDw0X63msCdinAB6KY0iHCqLi0S
         9Zpw==
X-Gm-Message-State: AOJu0Yx5qPQBHofe9J9l+WWcUUPYdjbHjL8b0jwDeT262Mo7EP7wpqOt
        cvEEK6s7rxXwIiSOPaaxuH8=
X-Google-Smtp-Source: AGHT+IHvJ2eBElEtJFWhMKjK3Lz6CRhqGH31S1aPJG0hOing5nNsAWJbgCW7LUwctZ46rF3QIH6DmQ==
X-Received: by 2002:a17:903:2310:b0:1af:aafb:64c8 with SMTP id d16-20020a170903231000b001afaafb64c8mr2623769plh.21.1694601468097;
        Wed, 13 Sep 2023 03:37:48 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b001b8a85489a3sm10090808plg.262.2023.09.13.03.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 03:37:47 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6] KVM: x86/tsc: Don't sync user-written TSC against startup values
Date:   Wed, 13 Sep 2023 18:37:29 +0800
Message-ID: <20230913103729.51194-1-likexu@tencent.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The legacy API for setting the TSC is fundamentally broken, and only
allows userspace to set a TSC "now", without any way to account for
time lost to preemption between the calculation of the value, and the
kernel eventually handling the ioctl.

To work around this we have had a hack which, if a TSC is set with a
value which is within a second's worth of a previous vCPU, assumes that
userspace actually intended them to be in sync and adjusts the newly-
written TSC value accordingly.

Thus, when a VMM restores a guest after suspend or migration using the
legacy API, the TSCs aren't necessarily *right*, but at least they're
in sync.

This trick falls down when restoring a guest which genuinely has been
running for less time than the 1 second of imprecision which we allow
for in the legacy API. On *creation* the first vCPU starts its TSC
counting from zero, and the subsequent vCPUs synchronize to that. But
then when the VMM tries to set the intended TSC value, because that's
within a second of what the last TSC synced to, it just adjusts it to
match that.

The correct answer is for the VMM not to use the legacy API of course.

But we can pile further hacks onto our existing hackish ABI, and
declare that the *first* value written by userspace (on any vCPU)
should not be subject to this 'correction' to make it sync up with
values that only from the kernel's default vCPU creation.

To that end: Add a flag in kvm->arch.user_set_tsc, protected by
kvm->arch.tsc_write_lock, to record that a TSC for at least one vCPU in
this KVM *has* been set by userspace. Make the 1-second slop hack only
trigger if that flag is already set.

Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Original-by: Oliver Upton <oliver.upton@linux.dev>
Original-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Like Xu <likexu@tencent.com>
Tested-by: Yong He <alexyonghe@tencent.com>
---
V5 -> V6 Changelog:
- Refine commit message and comments to make more sense; (David)
- Set kvm->arch.user_set_tsc in the kvm_arch_tsc_set_attr(); (David)
- Continue to allow usersapce to write zero to force a sync; (David)
V5: https://lore.kernel.org/kvm/20230913072113.78885-1-likexu@tencent.com/

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 24 ++++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..427be7ef9702 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1322,6 +1322,7 @@ struct kvm_arch {
 	u64 cur_tsc_offset;
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
+	bool user_set_tsc;
 
 	u32 default_tsc_khz;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..354169fbc9c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2735,20 +2735,35 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 			 * kvm_clock stable after CPU hotplug
 			 */
 			synchronizing = true;
-		} else {
+		} else if (kvm->arch.user_set_tsc) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
 			/*
-			 * Special case: TSC write with a small delta (1 second)
-			 * of virtual cycle time against real time is
-			 * interpreted as an attempt to synchronize the CPU.
+			 * Here lies UAPI baggage: when a user-initiated TSC write has
+			 * a small delta (1 second) of virtual cycle time against the
+			 * previously set vCPU, we assume that they were intended to be
+			 * in sync and the delta was only due to the racy nature of the
+			 * legacy API.
+			 *
+			 * This trick falls down when restoring a guest which genuinely
+			 * has been running for less time than the 1 second of imprecision
+			 * which we allow for in the legacy API. In this case, the first
+			 * value written by userspace (on any vCPU) should not be subject
+			 * to this 'correction' to make it sync up with values that only
+			 * from the kernel's default vCPU creation. Make the 1-second slop
+			 * hack only trigger if the user_set_tsc flag is already set.
+			 *
+			 * The correct answer is for the VMM not to use the legacy API.
 			 */
 			synchronizing = data < tsc_exp + tsc_hz &&
 					data + tsc_hz > tsc_exp;
 		}
 	}
 
+	if (data)
+		kvm->arch.user_set_tsc = true;
+
 	/*
 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
 	 * TSC, we add elapsed time in this computation.  We could let the
@@ -5536,6 +5551,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
 		ns = get_kvmclock_base_ns();
 
+		kvm->arch.user_set_tsc = true;
 		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
 		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 

base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.42.0

