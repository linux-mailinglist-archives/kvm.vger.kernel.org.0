Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B86E1ACC63
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410680AbgDPP73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:59:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49111 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2897252AbgDPP7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 11:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587052755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fzOnR5A7GlmS9rHeBs6Acef4J3y9D9TufivnERunTyU=;
        b=J6YNm5CZZE4QvAiJhztq1EOGG85t2BoWfbKKRTJLoKXGdeIXfim4TEnHoUGwGTcAdm16X4
        AHIxf1jlAWES304Z3eETC/b+h8k32A1zE5JByssWXk151NsAX+4pTQNSsFsit0Y17n/G6P
        AnMDq4MvetXYau0rUOQ29rF5ZeaUZwc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-gMI0G1RdOGeuv90seyGMGA-1; Thu, 16 Apr 2020 11:59:12 -0400
X-MC-Unique: gMI0G1RdOGeuv90seyGMGA-1
Received: by mail-qk1-f198.google.com with SMTP id k13so2563124qkg.2
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 08:59:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fzOnR5A7GlmS9rHeBs6Acef4J3y9D9TufivnERunTyU=;
        b=mTfdvmNN3PLhrlqfrYI5Nxl0zdhvHswIRBCp3yYDqev3ty/yY6YZ9xAWFDBdbU0ihm
         L6jexn7Bo1TMJ3oqtaeXzq7eWEyF0nD2wLBlh9AK6XXJgbP9eMOd9unT0Ct4aTIOHHvw
         kzt/ygyjQZ1NH1GVS4rpMAmNvDIoZtdesjSamX5KPYHEQp1HdttnTO2of0Dc6yQXROe/
         NRY2p5lhRPOoFoIRfR6W+N5ipyCmPmYcWudJ5Q2SI520TiIne2g9H+w597nTBzk2W+M1
         3YhTI6jLyNwIUSN7RDp1WTI/KD79/alWF/4Sc02MtABaK1BVlQ449+DEKXhXbxupxZ7y
         EG7A==
X-Gm-Message-State: AGi0PubDKhD3BGr3FuTE+ZKQPQU5kqmsgi1ZO+7ucoLqfZi+DLix0IJy
        m3uAIysf50crtMEKjDHYqjjiKwe/nEC05z3rl9rS2Z1+dDlI4LrkziKkPka/LVGSSwd3FIDjVCD
        wAe4Y7vMv9vnH
X-Received: by 2002:a37:809:: with SMTP id 9mr17014804qki.93.1587052752008;
        Thu, 16 Apr 2020 08:59:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypJCVUrdFy7/i8pvfn8GY7IMxV4JE5dnih9EcFzFPzSJsgH6IoFoXLnlQV0a2ClVWLh0S21nfw==
X-Received: by 2002:a37:809:: with SMTP id 9mr17014792qki.93.1587052751792;
        Thu, 16 Apr 2020 08:59:11 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id d1sm15426699qto.66.2020.04.16.08.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 08:59:11 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com
Subject: [PATCH] KVM: X86: Sanity check on gfn before removal
Date:   Thu, 16 Apr 2020 11:59:10 -0400
Message-Id: <20200416155910.267514-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The index returned by kvm_async_pf_gfn_slot() will be removed when an
async pf gfn is going to be removed.  However kvm_async_pf_gfn_slot()
is not reliable in that it can return the last key it loops over even
if the gfn is not found in the async gfn array.  It should never
happen, but it's still better to sanity check against that to make
sure no unexpected gfn will be removed.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc74dafa72ff..f1c6e604dd12 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10308,6 +10308,10 @@ static void kvm_del_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 	u32 i, j, k;
 
 	i = j = kvm_async_pf_gfn_slot(vcpu, gfn);
+
+	if (WARN_ON_ONCE(vcpu->arch.apf.gfns[i] != gfn))
+		return;
+
 	while (true) {
 		vcpu->arch.apf.gfns[i] = ~0;
 		do {
-- 
2.24.1

