Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFE8316BD1
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 17:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhBJQzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 11:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbhBJQxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 11:53:11 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB578C061574
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 08:52:31 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id n14so2049459pgi.8
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 08:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=VLJOHZvAQq9lAsR5xQrDCvjmGXyVuxHkPaezCmKjd5U=;
        b=BldTgab5X2aX+vdnSAuR4Nvj7qnjtNrTMrePVym0j2eCrVEnOliCV4Ez8DAhtnz3EM
         nGFTWNmBDWcNc2yRAIoVeQ2jWiTXTDGtbcetRZF0k+5fh++Lr0rkl25mvKkEFXUAmfST
         /PCYK5mC9PLkq8ET7JORItTIrcBh/rGhRAzOoZi7dHOq9EuFaub9nqQK2kMGuMQ8PE7H
         r7YShgO2+d/KcDAnBkHcXTjxxPAvg7okueiYF2OehBATN+bVnoomJ2CCwarYBCSzxYVA
         OcAdPhpaOPgAQFJka0TpWtgqwz++Xz0dOFimMziX2amCYz5/bls3LEpDVyiZY9zwMnwd
         xF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=VLJOHZvAQq9lAsR5xQrDCvjmGXyVuxHkPaezCmKjd5U=;
        b=Ip3ddTgteZiAToMraaGEreO4Rhif0hFjp5C5p4yLZXC2QvILHtmyaiNz2D5YgDp7da
         VSbLo7QoRc8yHLzANIYcZ3Y86uQ00DLLIToVbY2q2CRT2MTvLw+XeAzpol7lzc8qUnlZ
         VeiaFWdXactatI8iCHluLQ88myayP8NA7UtITwkirRbUFKRZhHfFPpn3U9xELWVDL0QR
         JO/5g1SuR81+ElX+LJaUbDydrTrvuhk1rrw4nF1C4x6NiSfH0/++xGEkph1SFiRuIRSz
         uM0wOZ92xNRwKLB6EtCj7NOJLCaalpn65Y1cBM4RFRoMvymDuzlRAtCdj2yOY78BuSZp
         894g==
X-Gm-Message-State: AOAM53380/jnri2MDWcKrlw//Ua9f0eSr3gckMNxXoxjYPUFkBngJuy0
        psxfR4cUIMZyNRgeQPF0QTb7JelTnEIn/rhBataDyxYJldKFqXmGIS2tKEThOTq+FBmXR+SQ9HY
        43yCsrb3vCkay+s06hxaVj6AC/NwELGLjvTNLPjLW6NS1C/HRk5MZPzN890JSOnrUxyzV
X-Google-Smtp-Source: ABdhPJxXC/rKWStAUZXFjh1uU5s0KVIhelnbhsGszTQT5dFMeHWaO6BzGQO7cIQzl3w5djwHX0dkQIuXlTxryzmV
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:e137:6722:53be:42f7])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:70c6:b029:df:d62a:8c69 with
 SMTP id l6-20020a17090270c6b02900dfd62a8c69mr3816730plt.20.1612975950984;
 Wed, 10 Feb 2021 08:52:30 -0800 (PST)
Date:   Wed, 10 Feb 2021 08:50:36 -0800
Message-Id: <20210210165035.3712489-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH] selftests: kvm: Mmap the entire vcpu mmap area
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vcpu mmap area may consist of more than just the kvm_run struct.
Allocate enough space for the entire vcpu mmap area. Without this, on
x86, the PIO page, for example, will be missing.  This is problematic
when dealing with an unhandled exception from the guest as the exception
vector will be incorrectly reported as 0x0.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Steve Rutherford <srutherford@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fa5a90e6c6f0..859a0b57c683 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -21,6 +21,8 @@
 #define KVM_UTIL_PGS_PER_HUGEPG 512
 #define KVM_UTIL_MIN_PFN	2
 
+static int vcpu_mmap_sz(void);
+
 /* Aligns x up to the next multiple of size. Size must be a power of 2. */
 static void *align(void *x, size_t size)
 {
@@ -509,7 +511,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 		vcpu->dirty_gfns = NULL;
 	}
 
-	ret = munmap(vcpu->state, sizeof(*vcpu->state));
+	ret = munmap(vcpu->state, vcpu_mmap_sz());
 	TEST_ASSERT(ret == 0, "munmap of VCPU fd failed, rc: %i "
 		"errno: %i", ret, errno);
 	close(vcpu->fd);
@@ -978,7 +980,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->state), "vcpu mmap size "
 		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
 		vcpu_mmap_sz(), sizeof(*vcpu->state));
-	vcpu->state = (struct kvm_run *) mmap(NULL, sizeof(*vcpu->state),
+	vcpu->state = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
 		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
 	TEST_ASSERT(vcpu->state != MAP_FAILED, "mmap vcpu_state failed, "
 		"vcpu id: %u errno: %i", vcpuid, errno);
-- 
2.30.0.478.g8a0d178c01-goog

