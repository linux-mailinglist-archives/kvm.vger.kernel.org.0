Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F6D1C624B
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 22:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbgEEUuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 16:50:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45935 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729206AbgEEUuJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 16:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588711807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lqz8ABTk7mmZmr2SRgNolx/ynB8Uv1cG2IVS55AzIlU=;
        b=JbJkzKECUrTXasp7/5Wv876iJV1/lM2sGOUV2MKmOFb4F4lmLyf4aya3/hupOEgH9qQnzu
        YFPB07ZqBXMqdVl6y7efxNAxiCxrb6oxd+RkE49/fNiuXuEnwgX69olHczrQQ9rvW7wWMk
        fqXNcq6HnP8kAL7iCv+xBXf7cq3b7Rc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-eIZVSSRaOyuA6RSyYbAZGg-1; Tue, 05 May 2020 16:50:06 -0400
X-MC-Unique: eIZVSSRaOyuA6RSyYbAZGg-1
Received: by mail-qv1-f71.google.com with SMTP id ce16so3486641qvb.15
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 13:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lqz8ABTk7mmZmr2SRgNolx/ynB8Uv1cG2IVS55AzIlU=;
        b=ra9aeJ/1QGs/qByuOxBRib6VZMwKICjzisiyQEBkuGLxVWDWIk7Y/XGqw1u0ax5Z9J
         7vNAuyHVV7ihxjduruB82mByo0TffSynSTtUHnwWQXqUw29lgie7E6h4tOnXq8nxh0Lp
         iTIHdm3ZIjuXzf3e6vmY258qOD/qorgJvZfGcOo1zO5mbxEykwg9juuFpLVpmolx7JuR
         d+csz/F1Zih6kGXUnjJx+4t9Ukrpgy3Ifkwo5yDpyINK0EP+AHe5Ycfvd/260lcg98gQ
         SXC1AGv2dVzMCkkxmliOoC8zdlnf1HMJIQMFwehv8t/ymwYBuLnvXTY9hcUWbFR2RYC9
         7xcA==
X-Gm-Message-State: AGi0PubczyLihOUGuZOEAmUiYa8KI8U/vjDmOzci4nYlBpBdkCVXC00h
        ox5dmVDag9049azfYFLbQ4HIhKwoSjy1vk37f9RabohTrT/P0s2Ya9FAReeVegGmxCZhGzGuqnv
        EmG6kCiA2MEG1
X-Received: by 2002:aed:30ad:: with SMTP id 42mr4804533qtf.88.1588711805889;
        Tue, 05 May 2020 13:50:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypJS3vgYB6ujLFNjvYBh4/YtNUpRO0CUlvOlkw6CWWBl6k97CeaB10WRCG6L5GhKHA/wqD12AA==
X-Received: by 2002:aed:30ad:: with SMTP id 42mr4804520qtf.88.1588711805673;
        Tue, 05 May 2020 13:50:05 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 193sm19380qkl.42.2020.05.05.13.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 13:50:04 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/3] KVM: X86: Fix single-step with KVM_SET_GUEST_DEBUG
Date:   Tue,  5 May 2020 16:49:59 -0400
Message-Id: <20200505205000.188252-3-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505205000.188252-1-peterx@redhat.com>
References: <20200505205000.188252-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When single-step triggered with KVM_SET_GUEST_DEBUG, we should fill in the pc
value with current linear RIP rather than the cached singlestep address.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac7b0e6f4000..7190188b2ac8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6672,7 +6672,7 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 		kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM;
-		kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
+		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		return 0;
-- 
2.26.2

