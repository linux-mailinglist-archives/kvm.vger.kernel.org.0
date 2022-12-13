Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAA364AC2F
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiLMARf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbiLMARN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:17:13 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E680C1C931
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:10 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 84-20020a630257000000b00477f88d334eso8550582pgc.11
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BpGd55nvKBNj0D/PIzME9gJqn/VBcBhffWATlQcE3Ss=;
        b=MGEbvBziCbhDXrzsRWJnhVDajcYBqH32IEoBgzIYBxRLKK4UKIXh6EcKFK5drrmpEA
         8MEpB2G2jJTC+KB8i8pUeFzabhMjuQrp51rHwAi9WxEkwVgMHq+hx6z1qCeb15tkk+/A
         xfO5l3wFXdCOVXkW9mIm6QIGoiMAxwFy5PqTjEG0lrociwfpJRcZuZCVQ4i6Dbk8e5Nz
         RN09Y8fL8D8Z9FfEVzlTciMOkDUqLCiIJjIPFMWWORLTDCS/wKvw2Usdvvi8wmeo9k3u
         WO7xbVQMKylVOulYnz+qg960NwHouXr7kHgcgEzUSk6QbZe3TdXOp/0yG8ARDmW0T2N0
         gIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BpGd55nvKBNj0D/PIzME9gJqn/VBcBhffWATlQcE3Ss=;
        b=inbNL0DFDzPjkKyGYikIUDQWCP6yziIQ5LgyPVdpLWle6Uz+dgbDflGR11V2Go/dfb
         ZhZj3oJe8veBckgUtJw7CdSN4iHHDiMy9aYA5/NdgwOo5Z2IbQMEWVHMldyH8dPWhgQ3
         bpCkIzoAlD1THC4zLDd5RgLjNzUOekd+t5Yeoijk9esVsGEGOqm0s/8S0TTh5V5RrhOX
         KvVD8LeMcagyRWGz8A9D4X2Ul8P7GDE3kBeOMj3CkmwnndJfnVEcXnHk0BlQsK8RNiug
         oM0VJ4Ub93PAa7DTsG2XuqtdIQj8objPbTahQcTsLtJJXfo1hyd8o0HrM3VovAjM707q
         6Mbg==
X-Gm-Message-State: ANoB5plN/rg+KKoDhG/mQXs2kRaJEnnNHZdWcVtquD6L6auhw8XWwpOk
        +LlBhD9iUm+fYHIv6W6vLHeJ62P/2co=
X-Google-Smtp-Source: AA0mqf7+dfd4rJNWoSbVdf58/T9pAFs7MpojsQi0gxbLVrmPbLQZm00Z8l7OQhKT1zAZsx9O/p+kfPEMGQc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1010:b0:219:1d0a:34a6 with SMTP id
 gm16-20020a17090b101000b002191d0a34a6mr4054pjb.1.1670890630136; Mon, 12 Dec
 2022 16:17:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 00:16:47 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-9-seanjc@google.com>
Subject: [PATCH 08/14] KVM: selftests: Probe -no-pie with actual CFLAGS used
 to compile
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Probe -no-pie with the actual set of CFLAGS used to compile the tests,
clang whines about -no-pie being unused if the tests are compiled with
-static.

  clang: warning: argument unused during compilation: '-no-pie'
  [-Wunused-command-line-argument]

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c22c3002492d..a6050dcc381a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -197,7 +197,7 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	$(KHDR_INCLUDES)
 
 no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
-        $(CC) -Werror -no-pie -x c - -o "$$TMP", -no-pie)
+        $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
 
 # On s390, build the testcases KVM-enabled
 pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
-- 
2.39.0.rc1.256.g54fd8350bd-goog

