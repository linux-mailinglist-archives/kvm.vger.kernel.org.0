Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72C2121E3
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 20:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfEBSbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 14:31:37 -0400
Received: from mail-oi1-f202.google.com ([209.85.167.202]:34985 "EHLO
        mail-oi1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBSbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 14:31:36 -0400
Received: by mail-oi1-f202.google.com with SMTP id u135so1589806oia.2
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 11:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1wdEmKD5eKqokJpkPtk7KxNlmpgJyCP7ZVZyjPalqFQ=;
        b=IeehO9RnlCiTUA2VOiiZqB+jKOwia0KHRn7+6c+ldMsfGqEriioKb+vI1ESbWulumz
         tJbpzgInJe9bKcGaEodscJilcyKUHtabgwtXvRpI2HVYePITko0migtOstdLP8Is/REo
         G+yQC0Gmz/iEQRZNTtMp+cyPpYg5SLXb4nL5d/0b/li96MzkjAhqYqe20D9NQi4Wzn2k
         h48R2o2icuPTKBvoU1Gl8jzkQUH4iNmABH/KVDij3xqxTkT3cGoEwUIWVML9M9jCOSLP
         sv3ePCsskh/z2zmmL+6j79Thup1I/2GkYdh9nqOYuLHdkKhxMRKTHsCa+6KTG6w68OlF
         MOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1wdEmKD5eKqokJpkPtk7KxNlmpgJyCP7ZVZyjPalqFQ=;
        b=bZhRnSPIJ10fCnS2/cgZqeHAE0dnFiP1MdQkHgy8HCZxS0gpvYH3t2fVE1Uf/vwk6h
         4bpbek9LzKqNiyLnh5oHc8viwsqTv+KBe1cA8LeZx8iXynCMLLjnAlLuO15m1zo8Plwe
         BFQr8XRrV3KGqN0drUSHVflBBEIZfCpd1Z7HXNSXHTlxPZSa8Fval6evEtLPBJMfcbHv
         C3bE+3XV5DMkWNfx2jPosjutTg8mSHluzwb389fSUtXuova9BDDe9o7OJGdpnzdSwKei
         1uxVvhRrVaBVxCSn79VqMSpazepETx7jOZlFQoiawj5dlGCF30dVeqHBDkF9qYlWrOC4
         9K7A==
X-Gm-Message-State: APjAAAUOJp4HLEet+PDGi2JD0+Va3hH0+uULOdIwsgJTvVgGBDZztwKW
        UwD9sMiq7xmTcEHlBSJbv6m26Y2zUvLvNO8E
X-Google-Smtp-Source: APXvYqwFLDglIgcl+4nmlpRLh0xry9cy3Le36WYlcplIkwb+bTOLWa5+rzeee0VTT4k/PnWrGbpv7PS0r0P0a41g
X-Received: by 2002:aca:ac08:: with SMTP id v8mr3457668oie.44.1556821896206;
 Thu, 02 May 2019 11:31:36 -0700 (PDT)
Date:   Thu,  2 May 2019 11:31:33 -0700
Message-Id: <20190502183133.258026-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH 2/3] KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS
 state before setting new state
From:   Aaron Lewis <aaronlewis@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        marcorr@google.com, vkuznets@redhat.com, kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move call to nested_enable_evmcs until after free_nested() is complete.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 081dea6e211a..3b39c60951ac 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5373,9 +5373,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (kvm_state->format != 0)
 		return -EINVAL;
 
-	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
-		nested_enable_evmcs(vcpu, NULL);
-
 	if (!nested_vmx_allowed(vcpu))
 		return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
 
@@ -5417,6 +5414,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (kvm_state->vmx.vmxon_pa == -1ull)
 		return 0;
 
+	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
+		nested_enable_evmcs(vcpu, NULL);
+
 	vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
 	ret = enter_vmx_operation(vcpu);
 	if (ret)
-- 
2.21.0.593.g511ec345e18-goog

