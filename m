Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE01B11BE74
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 21:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfLKUtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 15:49:21 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:36780 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbfLKUtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 15:49:11 -0500
Received: by mail-pf1-f202.google.com with SMTP id 6so1270662pfv.3
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 12:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WZ/pozjf2CR0qApOsQ3LoX3Js66TDlIX/9nxk8jnQ0A=;
        b=iQ7kT7Y9mfyXWGO8Q29hx1zTEE9Bdhpvd73jndRbpQMA/nkDSJJad1cfgRiSXcp0GG
         Aoll/H628y/FGWtzQgLzGiYTPKxZHoBdgVo/BXOGGxyK82U8Ult9z22hrdQEAedMOX7p
         HkB0IiXMVFJtsNvcvj1Hh36SQIgESTDivY0LJOzA8ia/NHpeCKbqEw4JeK9T9+3BWXHb
         ouPhMP0W13hDD4Zqxc0Houg9bB8OgUh3IslZQvH0jeJn9rzj0AGauJ+zGNSN9kcRKyzv
         DyfcNbMomWZWNMIcvWzSWqUrHQ8L9PPd6WdGWc8TVeQK5oBINUP6Fsi+0bBJNI5+ggI1
         PpJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WZ/pozjf2CR0qApOsQ3LoX3Js66TDlIX/9nxk8jnQ0A=;
        b=NrJAZnL8JXtELhUpyPDiXFfTFBWO/ICRTHsljjMiiMd/lOshPod7lKH4wUvkTV7xEB
         NDXbqCH88URClyqoKaO2eRch40Ri5e4G3RatTDolK5/ba9sdQbsAAYsY22WoLoXDjKgA
         FmSigoFCbgBVejT6Kdo4bgpGYbEcDWIQh9gfm5zATh08an5c8On93OhixcCFNsykS0xt
         9GJdFGaZvTD6LxvuTvgaK7jYwSC6f5U9QDGuLjNsIEh+N75+XDWtpV5jE/ll7LpQlw49
         8LMwwVHh3bvNIvru+uvzYmN49TtLdQ3fVFltf+/jSuMtw3d2ItaBzDFSke8yXpXHremR
         kM9g==
X-Gm-Message-State: APjAAAXH/ZLh1XeEwAAnM1gu6TQDkJxI+XcZsWau6Fmb1ljALIw6h05P
        YFu+GI3Rxq2ImOlzxr3CpAF7xpAhVcYv
X-Google-Smtp-Source: APXvYqxQMz+7rmle/AEYWdoD3NDtjcWQN/4YuaU56QUbmfqi9ASnXB/oWkpGs3X5CREMFPVXnKInlo10uoJH
X-Received: by 2002:a63:d017:: with SMTP id z23mr6411966pgf.110.1576097350640;
 Wed, 11 Dec 2019 12:49:10 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:52 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-13-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 12/13] KVM: x86: Protect DR-based index computations from
 Spectre-v1/L1TF attacks
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes a Spectre-v1/L1TF vulnerability in __kvm_set_dr() and
kvm_get_dr().
Both kvm_get_dr() and kvm_set_dr() (a wrapper of __kvm_set_dr()) are
exported symbols so KVM should tream them conservatively from a security
perspective.

Fixes: commit 020df0794f57 ("KVM: move DR register access handling into generic code")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/x86.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9e66f09422e..9a2789652231 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1057,9 +1057,11 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 
 static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 {
+	size_t size = ARRAY_SIZE(vcpu->arch.db);
+
 	switch (dr) {
 	case 0 ... 3:
-		vcpu->arch.db[dr] = val;
+		vcpu->arch.db[array_index_nospec(dr, size)] = val;
 		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
 			vcpu->arch.eff_db[dr] = val;
 		break;
@@ -1096,9 +1098,11 @@ EXPORT_SYMBOL_GPL(kvm_set_dr);
 
 int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 {
+	size_t size = ARRAY_SIZE(vcpu->arch.db);
+
 	switch (dr) {
 	case 0 ... 3:
-		*val = vcpu->arch.db[dr];
+		*val = vcpu->arch.db[array_index_nospec(dr, size)];
 		break;
 	case 4:
 		/* fall through */
-- 
2.24.0.525.g8f36a354ae-goog

