Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD22D3D734A
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 12:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbhG0Kc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 06:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhG0Kc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 06:32:56 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B566C061757;
        Tue, 27 Jul 2021 03:32:57 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id da26so14702584edb.1;
        Tue, 27 Jul 2021 03:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jnFmiiCARwRXURV87SUoI4OAHXmTW3lr0hJaEC8D8Qo=;
        b=t5/8OCiV65LjtymFAaIrJfaSLZnhAwBIp4orIX/0Z1v2iy1a6amOxkKFI69uy0S14q
         VzeM8IvLh4y36jG3aVxfAZs0TMweAVVWwlFoLTPJPmIkwmD3FBxA03ABTrmZUU1gM1fR
         fZ1Viz0+VHQT6fnAzY6kr2TTNtJ3FoWLklbrOd3X5kSn49K/+E3EgRLkwos/ewcrJhA+
         KQkiS+2K+2ALVEnQe+9ARSCiIAbjCKtg41e6Wjz1AKmDvAy/ZhssNgyfC2HSpxX5OdeY
         gNoOyPnc8tm9+4qU59BAE2P8vp0JjeVpjLEMIYbhJZ6XYS5Cn8jghBtzA5TArnoUCGRQ
         DlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=jnFmiiCARwRXURV87SUoI4OAHXmTW3lr0hJaEC8D8Qo=;
        b=lOBfW6S/QVd/2Eecv2zKZ6xDMYBXzmgGpivMzg5of/TWGYbCkP0BMaBUup4wN+5HJ2
         TciZBr35PFQor1S3FAPkIE4QzoQ4aEzQgw2pSNgcB2TIBSaDWNgbM5FH5WpUth/T9XGr
         dQVpgD1BVVEk2IzeZebnMBgTF+GupzI9HCpbEO6JreMoUacx2blA65Int0uC6lZU6iHf
         nT9rIBBvwpH/YcowYGKyMKjEFb3JMmRLoNbHQUXh4eYRNHdjHSMIXXptdxatMfqkPXYl
         A1pkQO9iw/29yS9CD/5rWylqlUiWCDBNTQyXbdpS7AsYfYo8YUkZ9zjdvXo/wFeB3rua
         Ucwg==
X-Gm-Message-State: AOAM532VqHz45NiFAaGaUdC7yhyCtrMHhcDGYzxmN2YhmLE8AfAQYVrG
        5+4yigTGhXJDiSz2LLL8sRv114VbC6s=
X-Google-Smtp-Source: ABdhPJwVzbWCsmg6tp3vU13MkpOZeZpi6hJPrU/wtF3E5a4blQzAdpGohkBz9ys4/iB3AFYxRb59+A==
X-Received: by 2002:a05:6402:3489:: with SMTP id v9mr27339068edc.124.1627381975605;
        Tue, 27 Jul 2021 03:32:55 -0700 (PDT)
Received: from avogadro.. (93-33-132-114.ip44.fastwebnet.it. [93.33.132.114])
        by smtp.gmail.com with ESMTPSA id la23sm742030ejc.63.2021.07.27.03.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 03:32:54 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     maz@kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: ARM: count remote TLB flushes
Date:   Tue, 27 Jul 2021 12:32:51 +0200
Message-Id: <20210727103251.16561-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/ARM has an architecture-specific implementation of
kvm_flush_remote_tlbs; however, unlike the generic one,
it does not count the flushes in kvm->stat.remote_tlb_flush,
so that it inexorably remained stuck to zero.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c10207fed2f3..6cf16b43bfcc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -81,6 +81,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
+	++kvm->stat.generic.remote_tlb_flush;
 }
 
 static bool kvm_is_device_pfn(unsigned long pfn)
-- 
2.31.1

