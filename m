Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A31AB096
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 04:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404340AbfIFCRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 22:17:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbfIFCRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 22:17:36 -0400
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C63F0806A2
        for <kvm@vger.kernel.org>; Fri,  6 Sep 2019 02:17:36 +0000 (UTC)
Received: by mail-pf1-f199.google.com with SMTP id w126so2080960pfd.22
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 19:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PI0dvyELfgDR6EZuTiL1mpi7X9aW26KSG8PfN04SbrI=;
        b=oN0NHEgxCElw0qORey0AzjgBHphZBkwdVms0p0rKcOHc8FcUwHToFdNK9joGSEY3cd
         bhG3Q764w1fjpyaz/XSGKOqlB8aQhCBlJNP1Nyh/7aRZ3cXtuncU9Z5d9b2WBtRnnMRL
         A9VWRhaZrtf2UOXXd2xpXDcrg0A+GAyqN/ljSObzI7wkyxvD90h3PLoFaUCftwPWZyXH
         CDKSiEvtUirpnGjLg/J7aExwUngjJv5eejYfaOAmrA1ccelu5UXgsujgYamfPAMXBoJP
         ZPTM54X4VbGEiOpOxrgylm9GGQJUM+se4fSvWstow1oosDIuSCpeQAgCxOOEcueqRCnt
         xIIA==
X-Gm-Message-State: APjAAAVwm2fWgjD72/no5vpLnLSpaFbSg5YACJo3HdEySWGucrHPdPYB
        3Pj5yLhB34PQkxWTSwh6T3U35q5VLCjf1zNr2WK4Z2ExxoJpeI5cOXgZA1A/R72tltW9LL4VZjK
        O6pm3mmDc8pEX
X-Received: by 2002:a17:902:a507:: with SMTP id s7mr6835202plq.66.1567736256237;
        Thu, 05 Sep 2019 19:17:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyHNmYW/Tb/4gB158GISbxVxqvjGZfcetpu67IukX/XY4cAL70pd1u6vIEnBjmgKmkvmFrjng==
X-Received: by 2002:a17:902:a507:: with SMTP id s7mr6835191plq.66.1567736256066;
        Thu, 05 Sep 2019 19:17:36 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a11sm8212359pfg.94.2019.09.05.19.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 19:17:35 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v4 1/4] KVM: X86: Trace vcpu_id for vmexit
Date:   Fri,  6 Sep 2019 10:17:19 +0800
Message-Id: <20190906021722.2095-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190906021722.2095-1-peterx@redhat.com>
References: <20190906021722.2095-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tracing the ID helps to pair vmenters and vmexits for guests with
multiple vCPUs.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/trace.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b5c831e79094..20d6cac9f157 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -232,17 +232,20 @@ TRACE_EVENT(kvm_exit,
 		__field(	u32,	        isa             )
 		__field(	u64,	        info1           )
 		__field(	u64,	        info2           )
+		__field(	unsigned int,	vcpu_id         )
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
+	TP_printk("vcpu %u reason %s rip 0x%lx info %llx %llx",
+		  __entry->vcpu_id,
 		 (__entry->isa == KVM_ISA_VMX) ?
 		 __print_symbolic(__entry->exit_reason, VMX_EXIT_REASONS) :
 		 __print_symbolic(__entry->exit_reason, SVM_EXIT_REASONS),
-- 
2.21.0

