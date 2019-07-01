Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6CBEE00
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 02:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbfD3Alv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 20:41:51 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41079 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfD3Alu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 20:41:50 -0400
Received: by mail-pg1-f196.google.com with SMTP id f6so5981643pgs.8;
        Mon, 29 Apr 2019 17:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=u6RfiIZ4yPam9G9ZVnMLsEDdYbEPmldosOULJBlT5/U=;
        b=JSgORqV2Sl7Xa9ucpLz4zx1nqQBpqQ3if2GU7rrFXDD/wj1uXq25relKulCe1YOoGT
         A+xZXTBmeYXdrGAxjP1nRJaFeagVZGjZhVvUJJ9MFL26kvZJxE2TaS3XOCtxnpVMsEmV
         Kc8OWGfodGuefR/+rmDrQCpBR/2z409A5eVLkoXLoEtu0V4jGOv6K2K3ZjNS7NX3SBC5
         shbkeYjFw+u9Mfz4E7feC8iVEWuG0QvdE3htgzmgSfpNKhPJc/Vs9nrBMiBa4gzKCLKn
         LQmi5a03CxCsORFalCSv9VgxSM7Bdmssrby18GIQLj615kiTAZK6dc33bSWzg4hLwwKN
         sqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u6RfiIZ4yPam9G9ZVnMLsEDdYbEPmldosOULJBlT5/U=;
        b=LCB2nbnSSGbNA49ADw54xjAyAX5zZuKGcXRV97+o2eJ2FVxFVVBA7r+05MYyL8i8Ym
         A+GSXZb/U0HxGBi8f1zzO/2+6gBy1Z/yWnIVWeWDxZzcYAxSdr6L9I84JIZWrzKrZ8ey
         G/Q/NSow2+42Tii039aFILDRkrdH2KKWaXnSdsZDQP4gf6m3bB6P4rZ6LQaX0LxgPIzN
         Wdy4KlBv17Da9/f6eYVrObruuWgpk1VbgYWn5ObP6eJ1kTaYiMdYngRe+wKfd4wgFBT3
         sKYv2E8U1JlW01Pp38JiKCdFNeuHCzsE723iF+WkMuqowj9lsahg2pkkqf0hzaLateQp
         GdBQ==
X-Gm-Message-State: APjAAAV1urpZRAKd9pjiPqe8r8bwpZQBG002FqFKh9WyNgULHcWnq0YS
        QbdHoYSZBhgyzTjEvrlOGVjknGF/
X-Google-Smtp-Source: APXvYqxPwfCayq9GFr8LEnpapkaSfKSKKnCNUvaPN38mQRutkGnpGVqgrSf29+Qpz6r5E8niQRPcaw==
X-Received: by 2002:a65:4342:: with SMTP id k2mr26888886pgq.178.1556584909710;
        Mon, 29 Apr 2019 17:41:49 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id j12sm8901563pff.148.2019.04.29.17.41.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 17:41:48 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Save/restore vrsave register in kvmhv_p9_guest_entry()
Date:   Tue, 30 Apr 2019 10:41:23 +1000
Message-Id: <20190430004123.1189-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On POWER9 and later processors where the host can schedule vcpus on a
per thread basis, there is a streamlined entry path used when the guest
is radix. This entry path saves/restores the fp and vr state in
kvmhv_p9_guest_entry() by calling store_[fp/vr]_state() and
load_[fp/vr]_state(). This is the same as the old entry path however the
old entry path also saved/restored the VRSAVE register, which isn't done
in the new entry path.

This means that the vrsave register is now volatile across guest exit,
which is an incorrect change in behaviour.

Fix this by saving/restoring the vrsave register in kvmhv_p9_guest_entry().
This restores the old, correct, behaviour.

Fixes: 95a6432ce9038 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 06964350b97a..700e125c08ce 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3511,6 +3511,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 #ifdef CONFIG_ALTIVEC
 	load_vr_state(&vcpu->arch.vr);
 #endif
+	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
 
 	mtspr(SPRN_DSCR, vcpu->arch.dscr);
 	mtspr(SPRN_IAMR, vcpu->arch.iamr);
@@ -3602,6 +3603,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 #ifdef CONFIG_ALTIVEC
 	store_vr_state(&vcpu->arch.vr);
 #endif
+	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
 
 	if (cpu_has_feature(CPU_FTR_TM) ||
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-- 
2.13.6

