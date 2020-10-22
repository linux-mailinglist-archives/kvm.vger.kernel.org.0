Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFBD295617
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 03:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894744AbgJVBes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 21:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894703AbgJVBes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 21:34:48 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADBAC0613CE;
        Wed, 21 Oct 2020 18:34:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s22so2590333pga.9;
        Wed, 21 Oct 2020 18:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zNKVQRtl8vfQItkTAR2QKWDzX8AbVsj4JXt+RK8do8I=;
        b=DaIryzOAJGOyqZoPSszwqFZw9oUE0zc7MM3We7s/DAGw3+ioDMCj6M+fREQyVZjz+n
         +z/LEH2o48uBxXmKstLKdm5vsN2howD3wceHBxYwlGasykhTmgpi23T4upBG28pbUyE+
         GCJJ6FfztGioPLkhyq2IGpZqPOdY4eUe6rnU1fWoouUjnEqgkPsmCh64qTeOKqQuvqOF
         wYXVJ8q7+IYvM9IJ9+x2C8wzn/pBX+HfE2Z0dXuZCC5dDwT2IDTkpY0hxcoah+roQgrk
         NXJoK+y9Ty0Trguq6yJBTiwvewzKt+GL2LEY+dl/4+0fS6kjrzj09iCgzFP0rvga3eAr
         kvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zNKVQRtl8vfQItkTAR2QKWDzX8AbVsj4JXt+RK8do8I=;
        b=fOU6dclQDrx25lBvZV1vFckW1U+m8vmpcMCTxYpMRECBF8l2JR8qBR7kZ3XHn1Ih56
         Ftl9DJdh8F2Hq2OX5kfa3jEBFK8rKbPpHdU4VfuTfFbQk2ZoVnnJIZ5AawEzPE+zashw
         6oKFihmPahqMvaMbjRhu1GV/ldLpkIRC5gi0aMvZpmQg+c/VHkewRAl1yLA0Htq5b398
         pI8MLF4PUoBuWpY8BD+e7vqyUBmmbmdskHOwJZTuFNkEO/4l+UIglusBPHEpbYyKzxuO
         jM9ZEyQ2TjmE87pQBLvT1hXUzVuKU4ZJT34usy4Cq2xtd0oo+cp6nFkL3UNIiCO7/vr7
         Txkw==
X-Gm-Message-State: AOAM533P4Qu6PdoDD87f1INwwmHt9AjKNNajV9iea8y275UDmP4TdZLK
        RP0Nkufc0QwYN9shkra8Gt9WlXZ0Bp0=
X-Google-Smtp-Source: ABdhPJxBMPAYu5DIsToLDmpp11MFkGT4FM098nbniWPHUQa5FCz7+iPgcrVfY+L+rwbJ7eJbQ0nHNQ==
X-Received: by 2002:a63:4702:: with SMTP id u2mr302963pga.111.1603330485678;
        Wed, 21 Oct 2020 18:34:45 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id kc21sm55289pjb.36.2020.10.21.18.34.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2020 18:34:44 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in KVM_GET_SUPPORTED_CPUID
Date:   Thu, 22 Oct 2020 09:34:35 +0800
Message-Id: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Per KVM_GET_SUPPORTED_CPUID ioctl documentation:

This ioctl returns x86 cpuid features which are supported by both the 
hardware and kvm in its default configuration.

A well-behaved userspace should not set the bit if it is not supported.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 06a278b..225d251 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -789,7 +789,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		entry->ebx = 0;
 		entry->ecx = 0;
-		entry->edx = 0;
+		entry->edx = (1 << KVM_HINTS_REALTIME);
 		break;
 	case 0x80000000:
 		entry->eax = min(entry->eax, 0x8000001f);
-- 
2.7.4

