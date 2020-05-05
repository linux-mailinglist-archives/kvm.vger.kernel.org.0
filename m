Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CA41C624A
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 22:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgEEUuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 16:50:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41102 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729194AbgEEUuI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 16:50:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588711807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y5fyKyck3cIU7DcvHTGzyMWNl4dUwB0H2Ul/b+bN2co=;
        b=bgsy7smivUCohNb0VZ9RyAAn09/wbXmp09VCksd36uz9Q4Vp3oqUw//bTfzTjEZVSILFXQ
        6sECyTHw8ES4T2niXhR3YIeBWiRIsUneRVIpev86AgzJ1QkFhG8nvRwRoxr2ylNrquQdjd
        WxFgRQxlo99aOu4WKRuveZ/yxZrZ+8Q=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-JyQxmu5xOdyd8lcPcWZ5mg-1; Tue, 05 May 2020 16:50:05 -0400
X-MC-Unique: JyQxmu5xOdyd8lcPcWZ5mg-1
Received: by mail-qv1-f70.google.com with SMTP id ev8so3501117qvb.7
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 13:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5fyKyck3cIU7DcvHTGzyMWNl4dUwB0H2Ul/b+bN2co=;
        b=AtBIm26NB5dX8FA65z2Lb3orTXq9uM9Ya94nZ3qMMxbfTpjUNXnhaPt5zG80/0F8Q2
         OtJ6bBJoSFS3IkczXfXeZH8R1jrnpBiZ1Fxn9pZcxBfao01mcyEh6qjgf+0C8UUCX4lQ
         H9RW73gtXgPxeqQSn8823bq+oN0cfpIghMtTmOjRVg1caVaNisUaiwSHT69SEobWctM0
         lUKaOdYmAORAXhusLvTr5/CkTihFc+dv2BwiJe4ArkzLTT3lePiuRAkYO/TCFJurRqRW
         4To9IgrwUpy1RyWsmYIjsdarH4UKOFtdqIObsVkC7Zp+AyAqm7BXIO3iHfWMiLQaaJyu
         vwqA==
X-Gm-Message-State: AGi0PuZJdBCjJLVssSGW9Egrc5OCdApfYDCCBtZTsNs/AGphkxiqWaJN
        NMalOIipGAsUudTurcjQyi2x+TLDySI3C5xANraUB2WiguCyzhpG+lqf0lblvk0hsTH+QC/bC/a
        J7iHpUSUynX68
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr4732571qtk.171.1588711804403;
        Tue, 05 May 2020 13:50:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypLOTQWzwWYM8fE/nDb/teAnnAv0eA3zDhbPGnwIcj7jk9BsG2W3T+3JWJxBw9ko1tMQ6r44Lw==
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr4732555qtk.171.1588711804173;
        Tue, 05 May 2020 13:50:04 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 193sm19380qkl.42.2020.05.05.13.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 13:50:03 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/3] KVM: X86: Set RTM for DB_VECTOR too for KVM_EXIT_DEBUG
Date:   Tue,  5 May 2020 16:49:58 -0400
Message-Id: <20200505205000.188252-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505205000.188252-1-peterx@redhat.com>
References: <20200505205000.188252-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RTM should always been set even with KVM_EXIT_DEBUG on #DB.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2c6335a998c..05ed3e707ec6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4685,7 +4685,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception(vcpu, DB_VECTOR);
 			return 1;
 		}
-		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
+		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
 		kvm_run->debug.arch.dr7 = vmcs_readl(GUEST_DR7);
 		/* fall through */
 	case BP_VECTOR:
-- 
2.26.2

