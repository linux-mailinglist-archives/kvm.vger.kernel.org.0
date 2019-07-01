Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993D823865
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389210AbfETNjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 09:39:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44451 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfETNjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 09:39:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id w13so3908475wru.11;
        Mon, 20 May 2019 06:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=bLeZplg8ot5OhBeGr3FMD+700rd1zlYGYOO98ayuuNo=;
        b=PX548Kp9GsiNqYIeFor5Wcu6Pgv+PD4Gs81KYmfCoXffToGmp4sAQQWTIaSNFDj7Nl
         wvLZhu1VvaODdyWfglGsJ4uuy6TOQ9SsaVhqX6Cctt3ZwZFgZa4Amujq1+M5FFAPQMCN
         H8zTBKCyRmTS3K5LsdsZnVUH5QBTBVlY6U37XIFs9z50xPVGyHJgZNr8/y8+NZqFhn+T
         1dV3jM5NICApffmF/er+5fynKFLEfyAORcqM39/ihsJl8nwWFfoY3mKDlZQwxQOQosO1
         /uuG9JRpoPguNh9Pt9wL3hDIhCM4bWG6X0q7ukx5h+jJR2VxY+JU0i7fgjDftpwQfIh0
         Tngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=bLeZplg8ot5OhBeGr3FMD+700rd1zlYGYOO98ayuuNo=;
        b=tbfLHMr6nVjVtajxkE/jWBbHhkv4Rs7+i5cpJxeTMLbdmLctqn/pnqK8NfjDVJmsGd
         1Yeu2mHvO7hC6HMYq6lV46+Uza3dB7v9znU//Imowzcp5wfGf9UOhjE0qYIh8E5/Ffpy
         hpdmrCjHso/I6H7b69Z0VQ4QrkqdJBtxiINzmqaS5smM+82r9lY62lMiAExlYfaFiShT
         slQb3oZMq505AkzhU+nIu3/Ahicm2VN5KWQ88/a4fcpziLzmdN4XRgXPi2saUV4QL3f0
         EeKT6ruFMOvLee8LO73u/8HhQqs4POVBJ6dDOk1qH5vUYCVpW7KA7qUKDYqJ2bqTSFej
         bKCQ==
X-Gm-Message-State: APjAAAW8YhQ9Tm4oMouWbCuB6w4DH3ZbthRnyV4KBPbdTq3AV6AafcF0
        UGfAo6XCox0aD3eu3WtNxzY4d77d
X-Google-Smtp-Source: APXvYqyPQru8WZN1t8IdBQ5n6pFQOvI+1sT5Bmz9bJYnhIJ7RuVzyHMYa7ozc42hEbDObV1oy4F2UQ==
X-Received: by 2002:a5d:688f:: with SMTP id h15mr7843019wru.44.1558359540711;
        Mon, 20 May 2019 06:39:00 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z20sm20659472wmf.14.2019.05.20.06.38.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:39:00 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thuth@redhat.com
Subject: [PATCH] kvm: selftests: avoid type punning
Date:   Mon, 20 May 2019 15:38:58 +0200
Message-Id: <1558359538-14910-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid warnings from -Wstrict-aliasing by using memcpy.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/lib/ucall.c                        | 2 +-
 tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall.c b/tools/testing/selftests/kvm/lib/ucall.c
index a2ab38be2f47..b701a01cfcb6 100644
--- a/tools/testing/selftests/kvm/lib/ucall.c
+++ b/tools/testing/selftests/kvm/lib/ucall.c
@@ -142,7 +142,7 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
 		vm_vaddr_t gva;
 		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
 			    "Unexpected ucall exit mmio address access");
-		gva = *(vm_vaddr_t *)run->mmio.data;
+		memcpy(&gva, run->mmio.data, sizeof(gva));
 		memcpy(uc, addr_gva2hva(vm, gva), sizeof(*uc));
 	}
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 61a2163cf9f1..9d62e2c7e024 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -75,7 +75,7 @@ void set_revision_id_for_vmcs12(struct kvm_nested_state *state,
 				u32 vmcs12_revision)
 {
 	/* Set revision_id in vmcs12 to vmcs12_revision. */
-	*(u32 *)(state->data) = vmcs12_revision;
+	memcpy(state->data, &vmcs12_revision, sizeof(u32));
 }
 
 void set_default_state(struct kvm_nested_state *state)
-- 
1.8.3.1

