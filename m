Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3CBA35A39
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 12:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfFEKJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 06:09:35 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45167 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfFEKJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 06:09:34 -0400
Received: by mail-pl1-f196.google.com with SMTP id x7so8527407plr.12;
        Wed, 05 Jun 2019 03:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dIuUcIyMK8nuPrLvAHMlgxxAYTbCV88vnbbR/Oftlkw=;
        b=mTFuorutizHMDSHbn3tP7SVn4HDvwoZqGcuzMbB/n4GQXN0kZmLz4uBbA3hI1+kTVc
         1Ln3yQC/A7lPuAme07EdEV1ZIrrOS+W/f6SNmQv4ttktnP9gc6vXwIjrXRpWBIiKrC2R
         cCRT9BtGKwbdmxcZM+r9+156WM10WG8fxOwKx8XehsgBSQrOjBYw2G6MnuIMzKBBqBBB
         cI83VBG5vYz0IM+MkNtYJTvvoP5+GH/nx7K+YwQGZjJXNefIPzEgPHbG4Cr7Dbl243wb
         F0UfgNcN3D/jo7e6/3sbWzkAsVaVWq0nFbs4UWnwnrKHUUkpOKe04GAzMYTxDX/Hbkbm
         pVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dIuUcIyMK8nuPrLvAHMlgxxAYTbCV88vnbbR/Oftlkw=;
        b=XMw4+KsVWBorQ57a7tFkIndO8bAuft61uxKFmsxNgWZpH/5GLGy+HVQLxY4GVLckoW
         Ab4+hy9dNKFVsc9TMd9L5Bx4Tf3nYqkuFlk+YRQ3X9JBlq12JqP+N5wYSgqv3rjIki8v
         rsazJboftWWkLIdS0vG7vOKyeSI+v9ALv62GHvar6vW5/p6Eig5Ue6DH1DKMg+HrEAEr
         LdswZ2CrAb+1zcYiLh6ewe0GXl2Cmt2St0Y93Qc8dsGbV4Ck07rIBJgLJUFBh8lYVYKl
         O4BlDNGQO4GfPRjnRS2LprfP9Iqeef5em9TFGMAjzByUL9w5Yg1UYfutLFWsbl1LX+H3
         xYtw==
X-Gm-Message-State: APjAAAVJ8chjn3w41AKjdvGbUIUzTVUPbfCK0vKBg3rr2x57aCEzvrU6
        Fcc0az9AUKVNOejg221+e3HsA5LS
X-Google-Smtp-Source: APXvYqyBoWBc80zPeCCeF2ViNlmd8cdOjGvoi9xGqyokMwkW51ZaQFIT+cjnME8u/54BIHukQysgWQ==
X-Received: by 2002:a17:902:28c9:: with SMTP id f67mr42846474plb.19.1559729373861;
        Wed, 05 Jun 2019 03:09:33 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id v9sm19030010pfm.34.2019.06.05.03.09.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 05 Jun 2019 03:09:33 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 3/3] KVM: LAPIC: Ignore timer migration when lapic timer is injected by posted-interrupt
Date:   Wed,  5 Jun 2019 18:09:11 +0800
Message-Id: <1559729351-20244-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
References: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

When lapic timer is injected by posted-interrupt, the emulated timer is 
offload to the housekeeping cpu. The timer interrupt will be delivered 
properly, no need to migrate timer.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e9db086..3bb4376 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2534,7 +2534,8 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 {
 	struct hrtimer *timer;
 
-	if (!lapic_in_kernel(vcpu))
+	if (!lapic_in_kernel(vcpu) ||
+		posted_interrupt_inject_timer(vcpu))
 		return;
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
-- 
2.7.4

