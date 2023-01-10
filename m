Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832556647B6
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbjAJRv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbjAJRvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:51:17 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E338754DBC
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:15 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id f8-20020a170902ce8800b00190c6518e21so8816801plg.1
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wd8IRDcm/I+X4nIj9mIHk75KksnNCPDW6vKldjVyscc=;
        b=b6KSQFqc5bLezor0zmWctfaPJ+f7KyxQdr3D/WxZuD9X/46Ab/0ny+3J5uSKG+8BMd
         uOQtNt3qd0SKGSJDc48X0DejhNnMOMN1KqX1H6Y2pq4012FFY+jsK2wdmkihUd8VYDJi
         lcm7hjV5n3lyYiVTAfWEbyj6PuU3nPZAPMuLFBK1dNwVn8VthonXMN8aFsG2D7/FUimc
         nqJ2g6PZpyu46JOs2r3mstW5uLQxFnf0GAqB1S1db+9ovE4akeJlXlcXxOEh+z4XxCNp
         YjtPFDZ7tPeI1jg+M4oKf7aIqOJxeUYsspIuXjhlF97sGbW0rAl1a7vOZq86idj7GWYl
         GBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wd8IRDcm/I+X4nIj9mIHk75KksnNCPDW6vKldjVyscc=;
        b=ScT44BNRzXvso0PBtjNw2VGeGxxJf5GLpO1ZEyr/mI+285oM1I92w7bhXwiTL2nTsI
         tooF22mK7x5lKurayeKRkUG7PAmn19oEATet637pnX5A+5gpQvtvO5JHCXKudxpc5kNi
         p/At+ACqWnz026lvg1WRoSf6Kzc37P6FnjtePsy1x4HeR09DDzOUBPRNCMmEqt8bDU2Z
         hDV8sM+buNtGniVX6NdN1CrXY+CTBtlauQLA1lDfxhweWhO0ohUed4R6/ksd4PiJOzTx
         +YrLuEGU8mPQ0ltnwLJEgWUrb+s5GaPjhOP6gGSEdWlqOVEf+SkQpBNChj5237glq+O0
         AQHQ==
X-Gm-Message-State: AFqh2kpfJzRFSDKLyRB9TsK5fq3NtMdENgkqSLHBPqsRb8TT2AvP74ED
        rA3THu0YrAxyo+u86o1fYMfN/2UvtuW6/5ycepIs/c6JTvTyVo5oCwcZ1RJALC4Jer7fKgRt9Nx
        KhMXK/XbBFvG8qWh2Vj6oikjvQ04yS48XebZkyrWCB4itgQxU/B6GSZEF/Q==
X-Google-Smtp-Source: AMrXdXtgUqdh/8WMm6DEuvZ030LJA1xX0uMeQAB19fs4xWBZgfTRe3FK8MNQ9gfkgaQtgyE4OlBoTZ6JP8U=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a63:1a0a:0:b0:478:ba6c:3879 with SMTP id
 a10-20020a631a0a000000b00478ba6c3879mr5162985pga.440.1673373075316; Tue, 10
 Jan 2023 09:51:15 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:50:56 -0800
In-Reply-To: <20230110175057.715453-1-pgonda@google.com>
Message-Id: <20230110175057.715453-7-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 6/7] KVM: selftests: Update ucall pool to allocate from
 shared memory
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerly Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the per VM ucall_header allocation from vm_vaddr_alloc() to
vm_vaddr_alloc_shared(). This allows encrypted guests to use ucall pools
by placing their shared ucall structures in unencrypted (shared) memory.
No behavior change for non encrypted guests.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 2f0e2ea941cc..99ef4866a001 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -24,7 +24,7 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = __vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR, MEM_REGION_DATA);
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.39.0.314.g84b9a713c41-goog

