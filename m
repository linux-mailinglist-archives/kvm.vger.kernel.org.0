Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A0F6C3FD3
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCVBel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjCVBee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:34:34 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBBE521CC
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:34:33 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id eg48so66843047edb.13
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679448871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9S6DLSaz+uk2ZH/3jWZtx5Az5bSp7as8qYLxRe1iiAg=;
        b=wJWLjVUhjUTxSKGzugStwodUsPdXdHnfCS4e4erp/ANgNbFHTkXoCdvfKJjUzgUosB
         uAkN/6nuradReBSnnjR2LZX0wuZPJuAqzK9UqJEWrwgIiiC3DSmL7kfZw8V7cXg9wxzu
         LqB8kWeBotwel/McwqJs6yCo7ALREpf/bLi/JhQ4wdOGZ2dYt92KOeNR6XiSBsEywqUd
         t4mPjoPpG1LfJR7GEbQvA/iHLx5wKIPzfxg2JOph/jglkZq7k6Ye3i00OjHrCcOkoGVX
         fQgdwleihe5KNGnxPVbvkx2/phajSzfLRJypAH6wtkOa32STmPdy7B6UGKyjwoL5AMzo
         z1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679448871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9S6DLSaz+uk2ZH/3jWZtx5Az5bSp7as8qYLxRe1iiAg=;
        b=DHxmE+/JR4otOM9Wmr9Tz0QGvZysPW+ktSOJYgBa5JUhBjNI98NwXYqNshPnWrig5m
         e7SPcHE21YVWZpnxQLsM8V5MopAyHznsdltygDRk+05K3Gk8knc/WoIER1EtY07o8mdR
         8JVxbjNNREqEjxpgfxknxcx5JD8ywD4z8Qho/QxBo+NzxRbzrdK7RZSobXUzozCaAIC/
         EqsPStoBArRTxw1O2tNv1ejU8E5Pv0qaSo9XQDBtJlB0eN068ZN9rG+Naq/6qqjFp/cQ
         Ucr8QQVhUHfFcRyFrGzG5iHU23ip8Yxw1zUucKdGjStfvPfH4/19/Ql2B727mrYhEydk
         wdFg==
X-Gm-Message-State: AO0yUKVdiKrJRvt7oxwqQqugwTWoFMV4OxYIfqK7Ro/yU+SdVbyji2wf
        xVuHOu7mCKlEnAuPMDuBnts0zNpwMW5Y/L8SONw=
X-Google-Smtp-Source: AK7set8K6fX9IVsxbATaDWD8G8s3XSQPFJHhQGwToQdLSsGXRRK/FSrR6e9Kxv9zZqIBMgksdY6NqA==
X-Received: by 2002:a17:906:5a8f:b0:931:41af:8ecb with SMTP id l15-20020a1709065a8f00b0093141af8ecbmr4848403ejq.49.1679448871605;
        Tue, 21 Mar 2023 18:34:31 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af344e007f5e5982a136b54e.dip0.t-ipconnect.de. [2003:f6:af34:4e00:7f5e:5982:a136:b54e])
        by smtp.gmail.com with ESMTPSA id w11-20020a1709067c8b00b009231714b3d4sm6356260ejo.151.2023.03.21.18.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 18:34:31 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v4 5/6] KVM: x86/mmu: Fix comment typo
Date:   Wed, 22 Mar 2023 02:37:30 +0100
Message-Id: <20230322013731.102955-6-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322013731.102955-1-minipli@grsecurity.net>
References: <20230322013731.102955-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a small comment typo in make_spte().

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/mmu/spte.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c15bfca3ed15..cf2c6426a6fc 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -164,7 +164,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	/*
 	 * For simplicity, enforce the NX huge page mitigation even if not
 	 * strictly necessary.  KVM could ignore the mitigation if paging is
-	 * disabled in the guest, as the guest doesn't have an page tables to
+	 * disabled in the guest, as the guest doesn't have any page tables to
 	 * abuse.  But to safely ignore the mitigation, KVM would have to
 	 * ensure a new MMU is loaded (or all shadow pages zapped) when CR0.PG
 	 * is toggled on, and that's a net negative for performance when TDP is
-- 
2.39.2

