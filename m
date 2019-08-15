Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6DF8E912
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 12:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbfHOKfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 06:35:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33516 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729838AbfHOKfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 06:35:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so1172828pfq.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 03:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MmetD9yuNOrneVgW+Ws3yNNgT+hSrMad8QH4+681/0w=;
        b=C84PiUf6eL2l7BUNLvibKFhvbnoldzZ5aNfJqXwMRkmNxGFObdgoeTJ0DfWd/oBxx0
         xI/GNTgMgDywf/vlSVG9gWX9Vw8HSD3wkvNRYf32NBJaAvd2nKB8UlzxT3l+TMYHTnyC
         jucynL1cOnTIOwos9ZQ3V2Ct50Ef01kqvlsV0AMlV1/Wo8UYqLgPML4GDhIVcWAlmfol
         XAogCgc/cmdcJSikXUrKnWad5lhSFqs7MLBMSAg5O/B+ATXjd/8h8W17PFz5exO/N8iA
         PxhqYvYYPAXka7TTrt+6Y76n7oy1wThy9GMUOu1fxwu4mxSLj6BLBc4YO44zd6RbTGPo
         zldQ==
X-Gm-Message-State: APjAAAXkD2jgRQhygxb6SkA1ZS4AlE339Ly11uTgkqwGJA5qtkZSzcBe
        qi4zmeYMXoSW9qJblksU+Eojh/p5YcSrcQ==
X-Google-Smtp-Source: APXvYqxKKF0KfKHwNQj3s+wlVd2MyW5RDnuq7+O3uAwel68MJtSEcu2G+KFYOLwfS91JP2EQjeV2Dg==
X-Received: by 2002:aa7:9903:: with SMTP id z3mr4536091pff.200.1565865313856;
        Thu, 15 Aug 2019 03:35:13 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o128sm2481066pfb.42.2019.08.15.03.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 03:35:13 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v2 1/3] KVM: X86: Trace vcpu_id for vmexit
Date:   Thu, 15 Aug 2019 18:34:56 +0800
Message-Id: <20190815103458.23207-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190815103458.23207-1-peterx@redhat.com>
References: <20190815103458.23207-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tracing the ID helps to pair vmenters and vmexits for guests with
multiple vCPUs.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/trace.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b5c831e79094..c682f3f7f998 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -232,17 +232,20 @@ TRACE_EVENT(kvm_exit,
 		__field(	u32,	        isa             )
 		__field(	u64,	        info1           )
 		__field(	u64,	        info2           )
+		__field(	int,	        vcpu_id         )
 	),
 
 	TP_fast_assign(
 		__entry->exit_reason	= exit_reason;
 		__entry->guest_rip	= kvm_rip_read(vcpu);
 		__entry->isa            = isa;
+		__entry->vcpu_id        = vcpu->vcpu_id;
 		kvm_x86_ops->get_exit_info(vcpu, &__entry->info1,
 					   &__entry->info2);
 	),
 
-	TP_printk("reason %s rip 0x%lx info %llx %llx",
+	TP_printk("vcpu %d reason %s rip 0x%lx info %llx %llx",
+		  __entry->vcpu_id,
 		 (__entry->isa == KVM_ISA_VMX) ?
 		 __print_symbolic(__entry->exit_reason, VMX_EXIT_REASONS) :
 		 __print_symbolic(__entry->exit_reason, SVM_EXIT_REASONS),
-- 
2.21.0

