Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCBC458A15
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 20:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfF0Sg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 14:36:57 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:53969 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0Sg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 14:36:57 -0400
Received: by mail-vs1-f73.google.com with SMTP id b23so1040154vsl.20
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 11:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uSmJJmNgOKMeUBo8e/RmP5gdCOAkqrM+tp6lYtgcfRA=;
        b=BMJ/RW0y5XM8Z1KyNi9ofcOGbxX7E1myXdVhf1cnnvCqqodqZ/4Ve59eEeFldg1ESK
         wbjmw+DYCwv2gdl5ESrU0M3jfwfih6HIBe7fxm9MpF8NsJFQ8rboU39ZiUyfVbdtFAfp
         v6L14/uJvduXiBELpV65W7bJTvKCOl7yOfxrIrn53BCycHmyKXLCX0odJOKxwS/WOPcW
         88T9pTDSCq0msehb/QiiOMjaPYP5nV43KrgDPETWtuqc48v7idoLlMtCDAblXkvsC/Vb
         acEHKz64405Wx3sPRyrmYDDqKQODaCJn8t1PRmFb8OztYBfRvl5dMpRgWZHf3uFArDEl
         BKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uSmJJmNgOKMeUBo8e/RmP5gdCOAkqrM+tp6lYtgcfRA=;
        b=r5v+a7LAs3xPsGKgitwjS0BoP1G+D5cAKlhXmllBCb5BegzEr+LoAonw6aoPAOyuxq
         UI0Dp9QVCFdirJWZvEVNFOdXYy+vs9ld5zA64smpGMzrPem69q2Hvx/5noZqKCBQgM1z
         akDgNcncML/O71YXvJ4gzXaItTd4BHbWKhNG94AJEfhObIT8nLM67qH4Rby6vd0CTl+u
         vboZdBPnNHOumOUpm8rYBkNCinfwV+NtlShlfgLOQk+LWI7m0xGTJqyF0JcVJeROsMeb
         rZmff/c5uM2awAuCbrLIYd6zgpVBBL2N8tq3ieB15yF6rOserP0RRNGT2MdKSwjkb16c
         qmeg==
X-Gm-Message-State: APjAAAVf2BOqRzR/ghEElGSg7jT22cbVwnjSlXtai7aQ/5FFqTfDbckk
        9vnmZ07qYbToOYfO139T2t2xirlc2RvqjHXT5vk+i0aYXhx6mBeJxfDbkimGwFjWPU1fsVrjLNO
        ecPSn3Ep3rGe/fWZ8+AA4lGBaux6TlS84mFFKuW5nl7+JlbyqYCuP+GhOP8DoZFo=
X-Google-Smtp-Source: APXvYqyVcdJ27CjdqEZzUSD43I0HtxjtTbGBCTJuI2jcF74KVTtdCQgRJwoBHjk3dilVaQQzD+0rRNKvTnWaxg==
X-Received: by 2002:a1f:8ad0:: with SMTP id m199mr2097373vkd.80.1561660615992;
 Thu, 27 Jun 2019 11:36:55 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:36:51 -0700
Message-Id: <20190627183651.130922-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH] kvm: x86: Pass through AMD_STIBP_ALWAYS_ON in GET_SUPPORTED_CPUID
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This bit is purely advisory. Passing it through to the guest indicates
that the virtual processor, like the physical processor, prefers that
STIBP is only set once during boot and not changed.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4992e7c99588..e52f0b20d2f0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -377,7 +377,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	/* cpuid 0x80000008.ebx */
 	const u32 kvm_cpuid_8000_0008_ebx_x86_features =
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO) | F(AMD_STIBP);
+		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
 
 	/* cpuid 0xC0000001.edx */
 	const u32 kvm_cpuid_C000_0001_edx_x86_features =
-- 
2.22.0.410.gd8fdbe21b5-goog

