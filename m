Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F3B10A1E8
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 17:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfKZQVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 11:21:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36157 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfKZQVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 11:21:51 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iZdSS-0002hL-31; Tue, 26 Nov 2019 16:12:56 +0000
From:   Colin King <colin.king@canonical.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: fix comparison of u8 with -1
Date:   Tue, 26 Nov 2019 16:12:55 +0000
Message-Id: <20191126161255.323992-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparison of the u8 value __entry->u with -1 is always
going to be false because a __entry-u can never be negative.
Fix this by casting it to a s8 integer.

Addresses clang warning:
arch/x86/kvm/./mmutrace.h:360:16: warning: result of comparison
of constant -1 with expression of type 'u8' (aka 'unsigned char')
is always false [-Wtautological-constant-out-of-range-compare]

Fixes: 335e192a3fa4 ("KVM: x86: add tracepoints around __direct_map and FNAME(fetch)")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/kvm/mmutrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 7ca8831c7d1a..3466cd528a67 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -357,7 +357,7 @@ TRACE_EVENT(
 		  __entry->r ? "r" : "-",
 		  __entry->spte & PT_WRITABLE_MASK ? "w" : "-",
 		  __entry->x ? "x" : "-",
-		  __entry->u == -1 ? "" : (__entry->u ? "u" : "-"),
+		  (s8)__entry->u == -1 ? "" : (__entry->u ? "u" : "-"),
 		  __entry->level, __entry->sptep
 	)
 );
-- 
2.24.0

