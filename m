Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39E5C12A1
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2019 03:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbfI2BHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 21:07:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37160 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbfI2BHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 21:07:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id u20so2488283plq.4;
        Sat, 28 Sep 2019 18:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lEm23RZXulSmlP370lFYOGBjjNx5eqJhq1MeUNEd3jQ=;
        b=Rs7Te/s2njqQvR8Z/hq50Gss4qS2rGACcqiS/FdSM0ssXWVXRiVprx2rdNU93oHHwb
         37FD6/AvGJLRqZVDXgrDBX/uMwM9ZHTO3qRKtEJlDAAhMEkDZ1kbb7m8Gu20aff9smXZ
         MnLE4zJZjUosvJ7k5xfBBREGr6+gN+oLkGJULlMOpJvXfRLVARb7ez4a2rM6EbFxC2ZO
         t6vpY4zWEO20utF9QJmv3nv7VAkAg6xnnuwyfs7R4M4GK4j11dHLlYMTzRbysL1x2sib
         7KQkdjbEKHfGbGHOTLqLF5bUUsXytLlx2Mhu4/P/bO8JHoBFTCljDF/Sz0dtx1xBLLO2
         oFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lEm23RZXulSmlP370lFYOGBjjNx5eqJhq1MeUNEd3jQ=;
        b=cuKVvJB2ENZXf+UnT9R2ahTUBMjQYlh8+DfPltjOjjZB/tPaUdomEyrpka9zNMlmww
         aRhHLq3UUSAGXOqTsp5TzUQM1IImNerIHoPHQ8+iMhMLqCRWruLYE7OKXAyyUFjnjf+n
         U0RBsneSmgwaP1P6nMGj8iKfqw2wFMnnW8REcrLYvi+zMY0Vf5CYxO7l87wQFtwZ4+K8
         E+ddYBxPq+3GU5XphVo1O+aHbaPYduRC2jhZMaT8rNUvtb1HjnDK/4bSsmS5pMrPNND7
         o/5Op56sDSGfEpKxK/qMsXA2A72FbAjEnq6Nefu3UY+CXLtBtSpGCu2CZ15po1K//So8
         ic4A==
X-Gm-Message-State: APjAAAWMKKotVPetRfmLyZ4JZDpCn5zh8LtWaU7slorB21yDQZpCvzVl
        YyUbvvouh5nyvQnGS4hFgbAgolAw
X-Google-Smtp-Source: APXvYqwbadV9s3qfd7nhJQvCRIhGv/fSpBO72pITQ3mh60EycuNRVNiH688w3agRcg+hRlJBm4Yddw==
X-Received: by 2002:a17:902:d685:: with SMTP id v5mr12683022ply.15.1569719222264;
        Sat, 28 Sep 2019 18:07:02 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id b69sm7336170pfb.132.2019.09.28.18.06.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 28 Sep 2019 18:07:01 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2] KVM: Don't shrink/grow vCPU halt_poll_ns if host side polling is disabled
Date:   Sun, 29 Sep 2019 09:06:56 +0800
Message-Id: <1569719216-32080-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Don't waste cycles to shrink/grow vCPU halt_poll_ns if host 
side polling is disabled.

Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2: 
 * fix coding style

 virt/kvm/kvm_main.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e6de315..9d5eed9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2359,20 +2359,23 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
-	if (!vcpu_valid_wakeup(vcpu))
-		shrink_halt_poll_ns(vcpu);
-	else if (halt_poll_ns) {
-		if (block_ns <= vcpu->halt_poll_ns)
-			;
-		/* we had a long block, shrink polling */
-		else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
+	if (!kvm_arch_no_poll(vcpu)) {
+		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
-		/* we had a short halt and our poll time is too small */
-		else if (vcpu->halt_poll_ns < halt_poll_ns &&
-			block_ns < halt_poll_ns)
-			grow_halt_poll_ns(vcpu);
-	} else
-		vcpu->halt_poll_ns = 0;
+		} else if (halt_poll_ns) {
+			if (block_ns <= vcpu->halt_poll_ns)
+				;
+			/* we had a long block, shrink polling */
+			else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
+				shrink_halt_poll_ns(vcpu);
+			/* we had a short halt and our poll time is too small */
+			else if (vcpu->halt_poll_ns < halt_poll_ns &&
+				block_ns < halt_poll_ns)
+				grow_halt_poll_ns(vcpu);
+		} else {
+			vcpu->halt_poll_ns = 0;
+		}
+	}
 
 	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
 	kvm_arch_vcpu_block_finish(vcpu);
-- 
2.7.4

