Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552B2BD3CE
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 22:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388292AbfIXUvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 16:51:14 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:39335 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731288AbfIXUvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 16:51:13 -0400
Received: by mail-pg1-f201.google.com with SMTP id t19so2069292pgh.6
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cK0rz6GPB8sFkc3B+fwwxTP1+0Eh134HuJh0fwsbwJg=;
        b=UJEfQGqxAA6lLw1NEwRj33/BhnUqc6DRlpLj4yz+I+mQaomwE6CDA6TqoPJ9XGQuOF
         yy/B9uXMuXxEP0X+IL+rciL8EHjdTBX44eFYmun9ZqIYl8466kRzd2da9gC4IbRSwElz
         CRcg16dVaGWccDBdmeWnQ8CDGUXTA8DmmrzyZ3DZgv1JqAxB718KxjTR9XBJsvyl7VS1
         nRfFFa2UqLqk1hYSQD1EPywlLRmWXk4rUe1FTGL28OKMnBM0mSNP8Z4+AVqYfST2oeFm
         sxPAzRZoXY9fHs0y0kPEAjQl8BFB5YWaZEgXLeBCxuGmM54RHo+hmptlSXPVqfRxhlFd
         kEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cK0rz6GPB8sFkc3B+fwwxTP1+0Eh134HuJh0fwsbwJg=;
        b=M2GQVtEIP6iqy9CrmMCL79Ar8K0Y/fR0lr0SckVvVBzPMbtz5q7XdHOpPDUoj3RoJJ
         Oqx8CYbDEFX6ELG2bRhJdN651TVRBeTZ+2J42G+R5MBF+XYiLYz0Uv5PgTzDqOfwEGVA
         qBcG5i69CS1Wk/fg7nQMygZxaEIs5cqM5VaanuSJXKbnPSicEta+s6Up8kwhwz190AbV
         ZJIk4VNXd9kchhaJv8PiEyC0U6rMWBsMyFmtiv2ECFuMGkMJFKbH/fSkHSH2q8lwOBqC
         dcx9qRPpHtwiTo+/FJPDfx8EZtt2Xzrrm1TlNK9k6RM8s2faYvi4lYBmPrxmzo7hLXqo
         KuIQ==
X-Gm-Message-State: APjAAAWQD3iMy5btbH1OOdvKdQmgWyJgQiHsZHYwLP99vrVuMbPYVJ6u
        fT/Wco/srHfd1IA7eAy55+oVpJKzJifct7tzvcSzJ3QVfxaOOwljFfnhD/mvhCUtGyn/stzz7ew
        Fu8TGGAYIzRJ02BpBBtHEmjWIqa5H2969vaDOmxa8Zsr+jTTt2hbpbvxlqv+9hAs=
X-Google-Smtp-Source: APXvYqxXsQDeUlr1+fAdznIO2UuQLxYD1je6XT/Xaj6VskWVdZaj6xldEmjZ58rZGoFPMTNOAtb3f7/RvMSbTg==
X-Received: by 2002:a63:d60:: with SMTP id 32mr4984367pgn.316.1569358272664;
 Tue, 24 Sep 2019 13:51:12 -0700 (PDT)
Date:   Tue, 24 Sep 2019 13:51:08 -0700
Message-Id: <20190924205108.241657-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH] kvm: x86: Enumerate support for CLZERO instruction
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CLZERO is available to the guest if it is supported on the
host. Therefore, enumerate support for the instruction in
KVM_GET_SUPPORTED_CPUID whenever it is supported on the host.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dd5985eb61b4..787f1475bf77 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -479,8 +479,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	/* cpuid 0x80000008.ebx */
 	const u32 kvm_cpuid_8000_0008_ebx_x86_features =
-		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
+		F(CLZERO) | F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) |
+		F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) | F(AMD_SSBD) |
+		F(VIRT_SSBD) | F(AMD_SSB_NO);
 
 	/* cpuid 0xC0000001.edx */
 	const u32 kvm_cpuid_C000_0001_edx_x86_features =
-- 
2.23.0.351.gc4317032e6-goog

