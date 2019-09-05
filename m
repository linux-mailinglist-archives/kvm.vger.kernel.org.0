Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4249FA985F
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 04:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfIECgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 22:36:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730273AbfIECgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 22:36:33 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0792C04BD48
        for <kvm@vger.kernel.org>; Thu,  5 Sep 2019 02:36:32 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id b8so710894pfd.5
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 19:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D5GbwgUbqjtNcqY0SPgp2YB/jV4XMs+EgfcVdllqHe8=;
        b=GbUkndWVUU6GR0ZCgJwqpVKpzuU6LCleyvre1RRMkw3upaal4PPEEeezl4wDSh+nVL
         aA8iD+r+p3/5LpGz0XqBRX2Qa/PrU9Ce9b1ZXza6wgidUYSZ9zACKoUr46ws2gZ9Pctt
         1PZnhg8htzzFr4YxLqKq9kCalXs05szB1ad0w1yAU+mNc9P2gK6iiYTz/SO0eZL65qSh
         4s4DjYv8Y7hCd9Jhzicpz3osJdhT/db0WvhP4ReQNkyoGCGTfPOKIp+MiRXyyh3UlOhl
         jGvBxp2OF4r+aAC6k3mxUAVfFokAE74qxEApAQFO7s3t0X+WMbgcRmpd7/C7qmwFadXN
         zBKw==
X-Gm-Message-State: APjAAAUlacAnU+ebp7y3dp5n+NP1LE9q14ZTTVVLbLHmz+XKA51GsmSW
        nq3NZo2kKRHbdVLaYRUw9CLTi+zpEg/2UdUAN4336ojX0Ibyd88PivEvuoewizrKK325gm/9Tbz
        2Ouq5yNHaGvRM
X-Received: by 2002:a17:902:67:: with SMTP id 94mr941159pla.121.1567650992224;
        Wed, 04 Sep 2019 19:36:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwiGVQPTwGuGQy7rBcAzOtUEK+ZrVZNNsNgPYaIYLZwLdkLNgka3U9b7pbZcwFOLz6B/6HG2A==
X-Received: by 2002:a17:902:67:: with SMTP id 94mr941144pla.121.1567650992091;
        Wed, 04 Sep 2019 19:36:32 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v10sm326504pjk.23.2019.09.04.19.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 19:36:31 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v3 1/4] KVM: X86: Trace vcpu_id for vmexit
Date:   Thu,  5 Sep 2019 10:36:13 +0800
Message-Id: <20190905023616.29082-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905023616.29082-1-peterx@redhat.com>
References: <20190905023616.29082-1-peterx@redhat.com>
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

