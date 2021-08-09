Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFD53E517F
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 05:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbhHJD2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 23:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbhHJD2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 23:28:37 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48CCC0613D3;
        Mon,  9 Aug 2021 20:28:15 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u16so19112137ple.2;
        Mon, 09 Aug 2021 20:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GhyeRU1OXy7cKuXtjm07ggDkCx++YUixjK+wm1BYxtg=;
        b=YTeT2/nRmOJIcqGAZPjivRu5d9O6Abp+R6snyYaRaUn6iQajVd7LBFcDqNZeX+Uot3
         ZwjnCaLmsBjicwIH9GQcAux1hRxrBtnZiOTmDUeoCnF2UaRCsbLkTIok0qv5hocPq696
         JJxqqr32iObH3JZgT/xm403lupemcyR3V3njZbSAb2zcggf/UQK5ET/MmBpbbtaqmO5Y
         ESenvqLzr7rcV1wQX+tdkFIfKaZgHnPOkQ9LBCY/v7aSLoLXkcOHSrRHtnFeLNzz+dBK
         1RF6sfQ1n9jKzps/VyzSCKWssgkj1MYimKQN9WhU5oXu6Mlckkrrgw6sOCuuu0meU5vk
         L/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GhyeRU1OXy7cKuXtjm07ggDkCx++YUixjK+wm1BYxtg=;
        b=tphkx26EqpP26si4NUJXcs/9AgkctglWwo6zXeHjpBznYRI4nuhHmIJIp3cir5kamf
         NfeKkrGkgufNm3crJA+mcU1+pLpEgtHihg8CKA3t9rrsgPKTLC2RZIfnmvsuUwYwNIFW
         f+1C0bJD7O8b8/w17XMi5RiznT/WRJ225lURzCZasRGrKB8OHz5mqJNKCdCDUUmMCmkQ
         11QO0073/v8uf2+jmZE/OHHmAx0AOfYVVNzz9Wi4HN6veKUzwpazL2B1JeEcegVfe/x1
         +achLN//kJ0IlmBFOksXdsbaE33qOAI/ZE1AQaCyNU0UPRtSaqCKiykTY7rWEFJJkYGb
         e7cg==
X-Gm-Message-State: AOAM533Rfm+g9p4F+cebvZE5srp6IWgUNITQj8a77t6zRCyL2B1EQS8Q
        PV9btQ4uVkNZsqVWJXodjV6zku4ZGjA=
X-Google-Smtp-Source: ABdhPJyYuFcZoig3Du/aWKDunvDG7owKBuynuhdo/LwCuE/2olGjouDQtvcjtFSdOlkfmFvuncT3+w==
X-Received: by 2002:a63:5b24:: with SMTP id p36mr375641pgb.91.1628566095155;
        Mon, 09 Aug 2021 20:28:15 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id i1sm971964pjs.31.2021.08.09.20.28.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 20:28:14 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2 2/3] KVM: X86: Set the hardware DR6 only when KVM_DEBUGREG_WONT_EXIT
Date:   Tue, 10 Aug 2021 01:43:06 +0800
Message-Id: <20210809174307.145263-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210809174307.145263-1-jiangshanlai@gmail.com>
References: <YRFdq8sNuXYpgemU@google.com>
 <20210809174307.145263-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Commit c77fb5fe6f03 ("KVM: x86: Allow the guest to run with dirty debug
registers") allows the guest accessing to DRs without exiting when
KVM_DEBUGREG_WONT_EXIT and we need to ensure that they are synchronized
on entry to the guest---including DR6 that was not synced before the commit.

But the commit sets the hardware DR6 not only when KVM_DEBUGREG_WONT_EXIT,
but also when KVM_DEBUGREG_BP_ENABLED.  The second case is unnecessary
and just leads to a more case which leaks stale DR6 to the host which has
to be resolved by unconditionally reseting DR6 in kvm_arch_vcpu_put().

We'd better to set the hardware DR6 only when KVM_DEBUGREG_WONT_EXIT,
so that we can fine-grain control the cases when we need to reset it
which is done in later patch.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ad47a09ce307..d2aa49722064 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9598,7 +9598,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[1], 1);
 		set_debugreg(vcpu->arch.eff_db[2], 2);
 		set_debugreg(vcpu->arch.eff_db[3], 3);
-		set_debugreg(vcpu->arch.dr6, 6);
+		/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
+		if (vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
+			set_debugreg(vcpu->arch.dr6, 6);
 	} else if (unlikely(hw_breakpoint_active())) {
 		set_debugreg(0, 7);
 	}
-- 
2.19.1.6.gb485710b

