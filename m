Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C30E46B80C
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhLGJzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbhLGJzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:55:50 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1DBC061574;
        Tue,  7 Dec 2021 01:52:20 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso2203019pjb.2;
        Tue, 07 Dec 2021 01:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AggZV2m9pqXxnzeFQjDaBo+amTkLh6dgZ3TEXgFqWsI=;
        b=jPzFBXftZgwL/u/b+dpxrnveAEUhqe17Ub1F3EsLObND8KZPmoZXS+h1g9Ruq/Bu7L
         tLNRtcbwos5SL3ILogmtiGVDLuWmbYDovOQIj8h0KrecZB6XywdfJGzxuXp3cm49CntF
         Jk6rmlAslHbwZL0qGkEG8PzNtA4npiECpTZnseuLzas7/McE1/9518jyPxcUXpd0UBMn
         clWCY+dWgTHJqSHPRMvl+bpNLBoQcAgp1Rjic45gFMC2qrRgZUcTHyQzSXUZy+ylgAKR
         8F/MufYIv8yDSndeqMx0hkkPivpVpNZNjnlg1zYd5gafOrb+DNYqW2tjdoCwZuguphN1
         QCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AggZV2m9pqXxnzeFQjDaBo+amTkLh6dgZ3TEXgFqWsI=;
        b=T0c5F5uw16KIHkwsHWeGxX32yfrRi4zqUi8ILGGMskDKERVbdd8+9buv6p5vMx80v7
         HB393WCCnIbHH1Nk4KrO4FMvhdRS1Xdv+eMECzqI3keb9KCkZiStGcYQrH1vEwXulHDS
         EpHP2y5zQR99O6opGiEeccP3qkRVfHqqKDLbcssW8gq3MtszGMR3wW3WkmZO8IK9XQsE
         sm+8rtFhULXoizVYI8CzWiVUbfRKBj47+LNpOjsHVgkr6dty5Gp/ILUo7D/S+MqhG4HR
         xh8/dd9sK6sNFsegMAmtJDhaZ/M/ja5mZMCc6RxG5alFiLBwUbtVD3kNFla6zToWAJMi
         gX9g==
X-Gm-Message-State: AOAM53087a1+L8A4+w/hR7G3kCl+oTXsDmdTVur/Xi7HQEl4pBxs8Qbn
        VWCOBtBfeYvH08kRA7AjHdBnhHXOT34=
X-Google-Smtp-Source: ABdhPJwXzoP30B10NeSDpYRv0Zs/d3AIA+fHzA1z8/M0HJteC7Rk9UQ+4mEz3IzgEzEUPjf9d+EvWA==
X-Received: by 2002:a17:903:2341:b0:142:1b63:98f3 with SMTP id c1-20020a170903234100b001421b6398f3mr49926698plh.49.1638870739547;
        Tue, 07 Dec 2021 01:52:19 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id n3sm12377373pgc.76.2021.12.07.01.52.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Dec 2021 01:52:19 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] KVM: X86: Raise #GP when clearing CR0_PG in 64 bit mode
Date:   Tue,  7 Dec 2021 17:52:30 +0800
Message-Id: <20211207095230.53437-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In the SDM:
If the logical processor is in 64-bit mode or if CR4.PCIDE = 1, an
attempt to clear CR0.PG causes a general-protection exception (#GP).
Software should transition to compatibility mode and clear CR4.PCIDE
before attempting to disable paging.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00f5b2b82909..78c40ac3b197 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -906,7 +906,8 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    !load_pdptrs(vcpu, kvm_read_cr3(vcpu)))
 		return 1;
 
-	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
+	if (!(cr0 & X86_CR0_PG) &&
+	    (is_64_bit_mode(vcpu) || kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
-- 
2.19.1.6.gb485710b

