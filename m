Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D9C17E6D4
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 19:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgCISUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 14:20:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38661 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727752AbgCISUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 14:20:33 -0400
Received: by mail-wm1-f68.google.com with SMTP id n2so524034wmc.3;
        Mon, 09 Mar 2020 11:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uHjQnX3gyUEuVprG/+YZpKO/PfRLqvF0oJQ7HCGTFS0=;
        b=TbiGWwAhKVkXZDdUIAruKPooWBEa7jPJ0vXBZAvYvskkH4V6YNt34tLngLeXiGCuFK
         5fvWMDUZF9dE7dg+tmaS03lY7BJWTC0E2qPILTG95KsuBP3Y+7p4xONMGIOPDQOBFgeq
         a9q8xoBVua2Zs8C1YIXcIbmJXtcLWSn4Mx3t1E4tY9k8fVhk6BnHmU+UxWLyg7Rk4VWD
         ZZB8NftRsfxkZPoZRW1vcXlbmhzncXTg3AUkhbYzOEb2ZSCqvq5yPelKlHJkJgDLBs/B
         g2x9+K2QSSM6rrAofRKLukyEiVLoZJWaCdIR2CsF4E5jqxBGGe1kC+cSDslNgjK8KkPw
         Ts8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uHjQnX3gyUEuVprG/+YZpKO/PfRLqvF0oJQ7HCGTFS0=;
        b=G4WviDSynFpsEQXCF9Y5TOZseaa8gEXx1/bwb+Su9703ehw6NCot88hVqRew1ioLwM
         nNCWJ9xnT1uINtdK6A4E0lbcog7KObeIuJb4bOBwuTTrZ/KslIjeNHrKw7AF3Gw7x6Ay
         z8i06XFhje2OtQbnzPsRSyZZnm8d4UXd2VMPTw1G327QSDY42uBnUhfTfc3VJZ8mjHXU
         i1VitLAovPvP4vStVMJqUNgcpRKuBTtz5/O/0tR1Ofi2Row9Hh3wH3g0DYLJKVI/Hrnw
         7LLNNQy6RETFWBazYr5qYwWYBqK3Rh1K+UnyFdqMjAfuqEchycM9n/n5FrvM9s3/Q7gn
         xszQ==
X-Gm-Message-State: ANhLgQ3KD9ygalF7YWCRMXwKc7fQbI2PhiEOHdVm5XzlXZDFfdECm5DN
        H2xnnKJ+z70Eg4eD98hxwxyoHztJew8=
X-Google-Smtp-Source: ADFU+vv3/Rc5ZrG5moXweUn8xofLMZw614O4eZMqaKc6z/1MnyT6qObBiGZityNbI/Rm2B4TBUYbXQ==
X-Received: by 2002:a1c:4642:: with SMTP id t63mr494064wma.164.1583778031408;
        Mon, 09 Mar 2020 11:20:31 -0700 (PDT)
Received: from linux.local ([31.154.166.148])
        by smtp.gmail.com with ESMTPSA id t6sm8371828wrr.49.2020.03.09.11.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 11:20:30 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v4 4/5] x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
Date:   Mon,  9 Mar 2020 20:20:16 +0200
Message-Id: <20200309182017.3559534-5-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309182017.3559534-1-arilou@gmail.com>
References: <20200309182017.3559534-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Microsoft's kdvm.dll dbgtransport module does not respect the hypercall
page and simply identifies the CPU being used (AMD/Intel) and according
to it simply makes hypercalls with the relevant instruction
(vmmcall/vmcall respectively).

The relevant function in kdvm is KdHvConnectHypervisor which first checks
if the hypercall page has been enabled via HV_X64_MSR_HYPERCALL_ENABLE,
and in case it was not it simply sets the HV_X64_MSR_GUEST_OS_ID to
0x1000101010001 which means:
build_number = 0x0001
service_version = 0x01
minor_version = 0x01
major_version = 0x01
os_id = 0x00 (Undefined)
vendor_id = 1 (Microsoft)
os_type = 0 (A value of 0 indicates a proprietary, closed source OS)

and starts issuing the hypercall without setting the hypercall page.

To resolve this issue simply enable hypercalls also if the guest_os_id
is not 0.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b6a97abe2bc9..917b10a637fc 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1639,7 +1639,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
 bool kvm_hv_hypercall_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
+	struct kvm_hv *hv = &kvm->arch.hyperv;
+
+	return READ_ONCE(hv->hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE ||
+	       READ_ONCE(hv->hv_guest_os_id) != 0;
 }
 
 static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
-- 
2.24.1

