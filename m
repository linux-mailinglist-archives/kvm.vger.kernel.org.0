Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E6F3EBDC1
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 23:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhHMVND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 17:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbhHMVNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 17:13:02 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F8CC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:35 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id b4-20020a3799040000b02903b899a4309cso8260902qke.14
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i0gC3YpOlYGFveSBqO/xZNra4rgAWDR79DWIZ6oDj6o=;
        b=s5Ktat8XOcezUVnJb1WS/qHIUWUy9yBdjTN5bhE6i0fMGjZYCkwSbxqDUwud+MdaqI
         dk+Zn+RkrsOIY2CeFggqpVheqoDLAYFUIkYmtjScPsc+VSl0awgPlkE9cbjjaN2c74Hb
         0N7En1twzTQQ1D2vqEPO2tnAa2zH8LuA94yv19XCVKzmow5wCaAPjo8h1A8Jm415QD0B
         wy/JG7ZSJxXDmVOsUfPqOMNZeL9lV5d/drVQKTfkSNvDOPB9GDBwbboSwEvZPwbV6/12
         4hsuaOo8hX7Kr3txQkKfPNAO7cudiUrRu5z8/2U73CwmgqnsNFfYUc0u9ZBUwZGVIWeu
         oCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i0gC3YpOlYGFveSBqO/xZNra4rgAWDR79DWIZ6oDj6o=;
        b=WC2KDA6mkIhmqgOhoDC5BcCXNMNJeTXXi0QS7KZmo9TXAJoMNqK1c0HeeuqejTftZi
         ZzKFUfbkQzur0X9vKDPu3dN8TD++J1fx8iEdkluEOfewC3P842lL03Dxhugz5pytfDVO
         710H9X84Oz9qyhf/ndIILcbRUg9itKp2QfldzP2I7fw4lL7nhp7NSw5fs4q5TZFDOE0g
         S8ZUtlgwF1OsavxQtgr0Vr0Pb24nqbut3TYANj48g2uHzpEEulTT4/zJa3QDnpbGO/rM
         luiu2FeLRia4unQtWTmJstVDpOhTVVME+JDc4mLVEfxRFvp0N8q8gQEXXFQ1QH3mmUnL
         i0UQ==
X-Gm-Message-State: AOAM530sEjjfyFVAZ5IU/zPZoKRKT8jK+iFrCLVHcGBUPbAx4R/Qe7lm
        m9Rk6jFOr9IL+bHJcXNUJsEqoN7W7N4m
X-Google-Smtp-Source: ABdhPJypOuxC0xiAvWzRKcX6FUG1sO4EVFhTLrKIh/dzhKC+66Hb60+6xtglfO5h44/z9YkcWOomkfrGI10A
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:62c:: with SMTP id
 a12mr4731968qvx.49.1628889154400; Fri, 13 Aug 2021 14:12:34 -0700 (PDT)
Date:   Fri, 13 Aug 2021 21:12:04 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-4-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 03/10] KVM: arm64: selftests: Add support for cpu_relax
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the guest helper routine, cpu_relax(), to yield
the processor to other tasks.

The function was derived from
arch/arm64/include/asm/vdso/processor.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b4bbce837288..c83ff99282ed 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -188,6 +188,11 @@ asm(
 	val;								  \
 })
 
+static inline void cpu_relax(void)
+{
+	asm volatile("yield" ::: "memory");
+}
+
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.rc1.237.g0d66db33f3-goog

