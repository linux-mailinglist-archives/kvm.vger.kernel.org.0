Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBD11555DE
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 11:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgBGKgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 05:36:33 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:36379 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgBGKgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 05:36:32 -0500
Received: by mail-pl1-f202.google.com with SMTP id bg1so1075310plb.3
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 02:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7R/dzs2gX8j/iAzEk3ko1uOJm0nEa/ipr/WpACBTbQQ=;
        b=HH+16w6bSh9kJgwLw/eGP3tT64ip677kQ/rI6KBT1ztBNMY2LuPcn2EtSKmypceuLl
         XHENXp7zLTq1c9REd5bT4rau+b2DJ4Yds7NZUL9N5w4fnzwGEhWweqg8ZPhU+u6/jEXh
         0+qlLVbepZGF4vKYOHbjOkVmB/bYMCCTMcPX7pgn9F1OZWeuoqq7KcAVsI6DkZ0fUW78
         cIWFlEPvnCilWFzZY/idDIrIm/63njmUVxk563HSJ/1KR6b2DTunGb3XPtQDaSdZPObi
         5XWiB5WvTCdP9M0BafRbFWWoDrlYsvvN0/4tiqU76L2mSj//P5tkk5iunbk3glXQnIOA
         m4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7R/dzs2gX8j/iAzEk3ko1uOJm0nEa/ipr/WpACBTbQQ=;
        b=KF1k9W/X/JtBB9slzq+rziYgYi+QdAsI4ZT86la8ie0KEJKfFY2nWyZOALEdZZ6wgY
         dPgKAmkrj5r2TqdImJJ6MQoARlNFrOYI9Qj/plZb3mrqrLpPhJuFtS653PD9RIvB+Lwg
         oacdFgooJ8ULM8QodEKRkPdrjuU9m7rMchOIKXJ5FCVDnE9YoM1MBbTO36UEsEcOEZPf
         7XDNAwpNC/XKiXVWJo0BRyGKU4OQjOs0XM0e6ngmrVSfBxS2UErB6Xrk5H+zdclVbdMu
         iL/UuvwjfxSDHB6Be2JBGUMQLZ+mfJp0gQpOly9cGq3FGosrU+KKjQoL7JZYGqN4gI/f
         iqpw==
X-Gm-Message-State: APjAAAWZFamgacBGTTr2BGleFO1VlRyGYskfLC4SPD+XaJwGATpiHn9x
        RG+T5b57/lt1KdvTQLaRZeTKghcyGmrov3KBmH495SWOur6HTKjKmaMfPQkAQiFhV/8Gc8kIcaS
        9w1ws3OAE6XA0tSyoSjttHF2F/Cj62X5JiLglF/BDbo4/QDwElI+HRhCdxw==
X-Google-Smtp-Source: APXvYqxrN9GobmXw/X8Yt4hU6wKnPvXV97gls1jHqsBkjRGKq2QvqKN6fJ7klMWLTemuQP9hEwwiZNI+oHM=
X-Received: by 2002:a63:7454:: with SMTP id e20mr8820602pgn.192.1581071790694;
 Fri, 07 Feb 2020 02:36:30 -0800 (PST)
Date:   Fri,  7 Feb 2020 02:36:04 -0800
In-Reply-To: <20200207103608.110305-1-oupton@google.com>
Message-Id: <20200207103608.110305-2-oupton@google.com>
Mime-Version: 1.0
References: <20200207103608.110305-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v3 1/5] KVM: x86: Mask off reserved bit from #DB exception payload
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM defines the #DB payload as compatible with the 'pending debug
exceptions' field under VMX, not DR6. Mask off bit 12 when applying the
payload to DR6, as it is reserved on DR6 but not the 'pending debug
exceptions' field.

Fixes: f10c729ff965 ("kvm: vmx: Defer setting of DR6 until #DB delivery")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbabb2f06273..95b753dab207 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -438,6 +438,14 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		 * for #DB exceptions under VMX.
 		 */
 		vcpu->arch.dr6 ^= payload & DR6_RTM;
+
+		/*
+		 * The #DB payload is defined as compatible with the 'pending
+		 * debug exceptions' field under VMX, not DR6. While bit 12 is
+		 * defined in the 'pending debug exceptions' field (enabled
+		 * breakpoint), it is reserved and must be zero in DR6.
+		 */
+		vcpu->arch.dr6 &= ~BIT(12);
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = payload;
-- 
2.25.0.341.g760bfbb309-goog

