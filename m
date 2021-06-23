Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DBA3B23BF
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFWXIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhFWXIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:08:19 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF76C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:01 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id t144-20020a3746960000b02903ad9c5e94baso4288813qka.16
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oH77o4lz1NSzb78aMq4uAG+U/iFLzDNAUznM/bo62rM=;
        b=SHTgYbmg959e42qNZl0AWZ4dEw+/QJ0kmNAUoS+JotxoPZ67fTbBx9aztLXg0XppJR
         qX8eRksw5kNejjfxTs3qoTSm3JFG5mjA0vgts9XvdCPOqyXjQVpbBC4D1OxUb7QFFEcN
         lFV0n00kQCgZ0OMY+AOIPmdj23OHoYiMnaMfZ2YrJbgf0u8Pm/59bz6BwP5zydK8K6fF
         TEm1wHkuMa8K4j4Refjr5aoFTuf5x4DF9jHJBX8E0By3TnSSUH/d36n9fe5d1d9N/SOS
         Y1QJb0bpQ4dCh63xN9fh8NODwOxo0XhySnOa+WuOIVBzNrquX7sV1zA8+6LXPRRHjRdI
         FsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oH77o4lz1NSzb78aMq4uAG+U/iFLzDNAUznM/bo62rM=;
        b=OJmi5ZQT9cItBMHm93OSMloLJ/7KI7I949Qvwouvyr83JZQmU6XuKleDkuiGeUpjA8
         Q7nIYrxMJZIZl8LBXCGLdVaKsJ/WZn5RMg1II1QSFGm+AJAbOXQn7LYwPQoqyFsX1dDH
         iaHLBMTxVuRvuq53Ql5Z4X6smoZ8TgtEHs9bBXVZsQandvBOtjaKv8ANHUF67jqOEPuL
         6nl9WiYRmD0MweRZWBqOFtf14LOudtQ1CQdcUaYvD3wiRWgEqMIk5RXzYRr3gf/Pra4y
         xJ5ggmupH1X33J/oHodL6dhNOKBrefAoEqC1fcGOAqsIfj3ZRgjo9GObxP7IklxiCGvm
         cUhg==
X-Gm-Message-State: AOAM532Arvtix00SmnSSrWE+VvVNmR2/iIXTWZvS28gnU6od2ES/X8Of
        E99cbFHaS4a8lVaqHHzwQksqtvoY0KA=
X-Google-Smtp-Source: ABdhPJws+FaF+iL4+9O3U4PePeppdh6J+coIlouK26lbEh4WpKyXv5fC2xidL+TZqY/x+5e/gV0FkB8gM/Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e9e:5b86:b4f2:e3c9])
 (user=seanjc job=sendgmr) by 2002:a25:cf03:: with SMTP id f3mr635411ybg.522.1624489560555;
 Wed, 23 Jun 2021 16:06:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 23 Jun 2021 16:05:46 -0700
In-Reply-To: <20210623230552.4027702-1-seanjc@google.com>
Message-Id: <20210623230552.4027702-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210623230552.4027702-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 1/7] KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff
 TDP is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ignore the guest MAXPHYADDR reported by CPUID.0x8000_0008 if TDP, i.e.
NPT, is disabled, and instead use the host's MAXPHYADDR.  Per AMD'S APM:

  Maximum guest physical address size in bits. This number applies only
  to guests using nested paging. When this field is zero, refer to the
  PhysAddrSize field for the maximum guest physical address size.

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b4da665bb892..4b2f8c6b41e8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -940,8 +940,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
 		unsigned phys_as = entry->eax & 0xff;
 
-		if (!g_phys_as)
+		/*
+		 * Use bare metal's MAXPHADDR if the CPU doesn't report guest
+		 * MAXPHYADDR separately, or if TDP (NPT) is disabled, as the
+		 * guest version "applies only to guests using nested paging".
+		 */
+		if (!g_phys_as || !tdp_enabled)
 			g_phys_as = phys_as;
+
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
-- 
2.32.0.288.g62a8d224e6-goog

