Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672AA7846D
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 07:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfG2Fc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 01:32:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41944 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfG2Fc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 01:32:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so27400579pff.8
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2019 22:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VwrOmLwm9SuJeXt60JPzTNp8w0LAjI+Cz+erHXrmem0=;
        b=lnQ+8ibkZM1PfrbfBJ86mjGA+K9bLCyMkZFQ7JUfjeNFToHyM0PldKVj6NZEZ4JNS2
         55M6O9PSLBrZSOGYMeqH/sy4VVmaG6GNfLBWiSUHFashufYUXkn/LK/tVD9OHkVvsHWp
         Y8nvIhR09FCKIEAxS3VzsGtpe3dwQ3idR3vRmNGs5qNYZuYX1sNGmszSLb9QrFqTD0IP
         5z0Ucy83bkCsx1gKqlrxSGPwXSS+Eyd9AL+4tlqVpM+9i3Z/fadrju63qpFbSpO/hdfx
         n06IWCylKaAhOb3GFUxdC9yh5rqtm2FLUs1QBUbtdd66eaTHVbgWCrWEXnszFXB/4hDv
         lZFQ==
X-Gm-Message-State: APjAAAUqDjaw6KOPWYMM6kaTkZxWmModQEmv7N44KcHKu8nJYHElIgPh
        5bem7s/KxK1YYCE7tP10EvBe9J3pWUM=
X-Google-Smtp-Source: APXvYqwcI+XYlYt2aA5fBoyf96ppdnlGHaWXjMmdyNnUtrO3wIxL6tNMl12ewyVs2uuMJfftW6BOGA==
X-Received: by 2002:aa7:9254:: with SMTP id 20mr35878432pfp.212.1564378375157;
        Sun, 28 Jul 2019 22:32:55 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o129sm30498550pfg.1.2019.07.28.22.32.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 22:32:54 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com
Subject: [PATCH 1/3] KVM: X86: Trace vcpu_id for vmexit
Date:   Mon, 29 Jul 2019 13:32:41 +0800
Message-Id: <20190729053243.9224-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190729053243.9224-1-peterx@redhat.com>
References: <20190729053243.9224-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It helps to pair vmenters and vmexis with multi-core systems.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/trace.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4d47a2631d1f..26423d2e45df 100644
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

