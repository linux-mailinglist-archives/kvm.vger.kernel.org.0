Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C6C30CF1E
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 23:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhBBWfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 17:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbhBBWfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 17:35:08 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC94C061788
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 14:34:20 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id q191so7637978ybg.4
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 14:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=7LGHGvABVV/hOzEr/frM8n8zvokdVXHA8iCPP4kDUv4=;
        b=lf5FREXRqgS0lbB4idjJXbZpvN4HjC2s1M3lu3rgAs/mLwLhIl6y/k2g5pIEbI2n6r
         +XDZop1lxnku3Rlk1aF0K7L/sFMb5wSVjTpsxd8+GqrHqLWWzMxSfYIxm7X9lsT0Z+sB
         UmI/NR8IVaY/ur/OXd0g5UHgGesyFI/FcbFwAEOoSugxvCs8cSEvbNlcLhOG1FxgowCb
         oSIQ8alO9+1nzBUykFWmx6RUY4LqMP10+UFe+Em8YPGlrlfGmBVRT/tmMqZsZdy++I9G
         0WhQFI6c4NbDNRH5BAKlzeF+MB0CHlF/VZAy2x2wc7xP1Sz8v0tYLT7MZmKJvsjGoIvc
         YRFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=7LGHGvABVV/hOzEr/frM8n8zvokdVXHA8iCPP4kDUv4=;
        b=WC9CIwJZfby4pkbsYEzNreY3zGR9yN7grNOM7CFf0XRLoXjs8dJBl+4oi6iHqULptz
         jlnby6ZlcZ9feoHGtwAIhKg1uoNc5Jt1icEvYu00URskgpYcPu2bCXyIWLD1wOp/Zw1m
         +BYxkd7pqIDfzjxxjravuIeNFW7PCQGhTNBcekWClMBC9Vxl904H77HH+wb3tcsRQmlP
         ZujeAmR4U2oeZt48kAdc5cWrZouOGPzW8UvBwXlqnAbcI5+AuobwkyXTM62Lk5I/wt/a
         0c+/tj8K5+O+8lhkwtzi+drgf81Gh+Z/OiCepPVbmZR4X6Wu5sXNRuacCYrB2iKZACIZ
         EAfg==
X-Gm-Message-State: AOAM533acbDBv8aoFNZgM/YlbaZ79dmCw6XHy1qZcyI2Ni1A72g7lzjB
        n59wXEu+lfgrv9EqszFSC+iat5RUvPc=
X-Google-Smtp-Source: ABdhPJxpO6ITfmyuFo8ObTMJgNF5wKHYFWmtXQY8xHo3eagkj9Tx2KSZR6I0YF/WkGlcza5jhZTvpHMiBvI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
 (user=seanjc job=sendgmr) by 2002:a25:bd51:: with SMTP id p17mr195332ybm.274.1612305259277;
 Tue, 02 Feb 2021 14:34:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Feb 2021 14:34:16 -0800
Message-Id: <20210202223416.2702336-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH] KVM: SVM: Use 'unsigned long' for the physical address passed
 to VMSAVE
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take an 'unsigned long' instead of 'hpa_t' in the recently added vmsave()
helper, as loading a 64-bit GPR isn't possible in 32-bit mode.  This is
properly reflected in the SVM ISA, which explicitly states that VMSAVE,
VMLOAD, VMRUN, etc... consume rAX based on the effective address size.

Don't bother with a WARN to detect breakage on 32-bit KVM, the VMCB PA is
stored as an 'unsigned long', i.e. the bad address is long since gone.
Not to mention that a 32-bit kernel is completely hosed if alloc_page()
hands out pages in high memory.

Reported-by: kernel test robot <lkp@intel.com>
Cc: Robert Hu <robert.hu@intel.com>
Cc: Farrah Chen <farrah.chen@intel.com>
Cc: Danmei Wei <danmei.wei@intel.com>
Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm_ops.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm_ops.h b/arch/x86/kvm/svm/svm_ops.h
index 0c8377aee52c..9f007bc8409a 100644
--- a/arch/x86/kvm/svm/svm_ops.h
+++ b/arch/x86/kvm/svm/svm_ops.h
@@ -51,7 +51,12 @@ static inline void invlpga(unsigned long addr, u32 asid)
 	svm_asm2(invlpga, "c"(asid), "a"(addr));
 }
 
-static inline void vmsave(hpa_t pa)
+/*
+ * Despite being a physical address, the portion of rAX that is consumed by
+ * VMSAVE, VMLOAD, etc... is still controlled by the effective address size,
+ * hence 'unsigned long' instead of 'hpa_t'.
+ */
+static inline void vmsave(unsigned long pa)
 {
 	svm_asm1(vmsave, "a" (pa), "memory");
 }
-- 
2.30.0.365.g02bc693789-goog

