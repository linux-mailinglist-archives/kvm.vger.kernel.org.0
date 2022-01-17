Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CB44902E8
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 08:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbiAQHZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 02:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237523AbiAQHZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 02:25:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A447C06161C;
        Sun, 16 Jan 2022 23:25:07 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i17so9455621pfk.11;
        Sun, 16 Jan 2022 23:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hg9JEbF93yOirT0i1PqEL2GAy0mjKH1xF5tCZqOwYkA=;
        b=le4cDKdnkLHCXSal+0sNyEjoiGK0X3PQkjGYxVjok1uBNsoY03UcKH6EQSX/Sl+Byg
         W63VbHCFyeUcxK2oQfytXOYQar6qDS+COW+COQpPpE4ROP0hUiIg/b6whdi/dzFDSkqo
         /GK8PBHDkbydCniZvZK5FFLa3yz8rdrA/lNJ1hYo9OiDklCLpTpaqz8kXe/o+BYYs+Hm
         x/WqASoFxgSgo/GyIZFopL+rd7VF+dZ7h5fhEHXPcE3ewjyaWfQtY6bCihyAhY1MmfBK
         CQEtbBbRRVNYsvZHiCJSf3rLhveEwkBi66RahAlV7l8yzxf4v0s4/kfUqyKVNQD9mIZX
         zvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hg9JEbF93yOirT0i1PqEL2GAy0mjKH1xF5tCZqOwYkA=;
        b=Wbi7GL1yMDDZrz4N/ExXLNC62MW0cFupHGPG0ZEL0ZUqI7RSKRERrMOqHLBexd51iR
         KTiajQFUQi54nzehNnRU45TxUc3WQvfuTv2QzFIm0Ew8uZEMkmjyxpNUBbEDF1hU42om
         2uhWGi2NC/wAWmlw0gfbZiWlEvmO3xxbMm2WaxaBVpUKEQANPRRfIWi3iAGWEQklivTQ
         UVGoHoFDnnRNT9itN0PTX9pHVEV+x4UTpmGLPy5eBTSSnVdwsWdmg1qyzLeK/BoOM6wc
         Jd+N3XdOLPya9Q9jgY4YmAk4AnnaZWljjGq/u2QItMu9EfoIpFLqm9qycvMCUqMiiJCc
         AFQg==
X-Gm-Message-State: AOAM532GOBTFR1bjzHZfnHeA0lgBfZyKbweenQxJX+JwwzWsOR7uqrny
        Nn8WKXzEvDbZ3rOciRRXREE=
X-Google-Smtp-Source: ABdhPJzecYpPu7ynpUVr8Sc01lyFp20Oc04LQanRefauwZ0etJm3v0mAxOui/JF875/R4daV0K8psg==
X-Received: by 2002:a05:6a00:2444:b0:4a3:239f:d58a with SMTP id d4-20020a056a00244400b004a3239fd58amr19581924pfj.85.1642404306644;
        Sun, 16 Jan 2022 23:25:06 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s5sm12437631pfe.117.2022.01.16.23.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 23:25:06 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix the #GP(0) and #UD conditions for XSETBV emulation
Date:   Mon, 17 Jan 2022 15:24:56 +0800
Message-Id: <20220117072456.71155-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

According to Intel SDM "XSETBV—Set Extended Control Register",
the #UD exception is raised if CPUID.01H:ECX.XSAVE[bit 26] = 0
or if CR4.OSXSAVE[bit 18] = 0, and the #GP(0) exception for the
reason "if the current privilege level is not 0" is only valid
in the protected mode. Translate them into KVM terms.

Fixes: 92f9895c146d ("Move XSETBV emulation to common code")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76b4803dd3bd..7d8622e592bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1024,7 +1024,11 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 {
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) ||
+	    !kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE))
+		return kvm_handle_invalid_op(vcpu);
+
+	if ((is_protmode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) != 0) ||
 	    __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
-- 
2.33.1

