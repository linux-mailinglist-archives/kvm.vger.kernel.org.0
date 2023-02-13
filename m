Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8974694CE7
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 17:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjBMQbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 11:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjBMQbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 11:31:48 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315141C5AC
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:41 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so9492354wmb.2
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gL3WY5uINlzkgyRq7H7dB8gj8YytqwpDUD1ql7z7pK4=;
        b=hPTxoCu4/JNwETqutr1XeI0h2A+vQZHDu54xpEqdCBR+IiDlUtuV/j4MxbmdYjgfT0
         BqUUIcAHdOCLwtamrYQuCY66ss1l5mfGSbv9idlxRI8p/BgqUCO2HCXDbduL0kwnpcxu
         Ko6jubB915WKqxj/jqW1yi5Vw1LyFiUqh/dM7fIlGEC4O1dUZoPSOag6xbrHj4AoiimM
         ELFRh1jdJsQq5xnsYHnF955YXk9HZ+zs/bZqnwbsYEyjVVWBQXnuNxHYQZvPLmEtO7hr
         ozn5jcy0D74BwZc5gNHRMgBvW7880niRu+QHMQjDSoqg5HcH/ehq6VWrObnqQLkt8KXD
         OiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gL3WY5uINlzkgyRq7H7dB8gj8YytqwpDUD1ql7z7pK4=;
        b=Okg8v+HQtpCsxhrHYY3olepOX+6hV4E8C4ENsEwG1+QPQekvD8RBdxjqL6kxtUWIxI
         kb1xN+xLsvnEOrciWXxeoTdlUcGMlhpe7iRZhTo0LJWR6ZjRe5JOCvqntv3j5mCcRqHF
         IESM3LqlIUHHaalDv0438MXTSPhrCHYusPMSd9moEAuPK0IfW/VgFoFP26i6SipMutoI
         j9VtIlcTB9qKMMA6PCE6ajjXrTV1sR5Kafe25sy/oE2RhbTU9t2LHcnAoDlpnTV3D8pu
         CDjYmY20YEyxez0cy7Hp0blRRxc+ooCtwpsK12aF0L6KJKNCHpBCCUvxjP5qDer31Eu7
         nVGw==
X-Gm-Message-State: AO0yUKV5N2cX3nW0i18lBDoxgUsZW46JpWU4z6gaX34XOnz0xdZL1U8W
        WzGUmfMwiH3WpzBk13JGAO286lCcz6AKjGMo
X-Google-Smtp-Source: AK7set8S/1VeRbbWTaHFhH8+N2psjylMhzSWMWCIAMpS9QURMcnaJA+HnYVwNcQ4MeV4TlKDJm8cYw==
X-Received: by 2002:a05:600c:16d4:b0:3e0:fad:675a with SMTP id l20-20020a05600c16d400b003e00fad675amr18623402wmn.38.1676305899157;
        Mon, 13 Feb 2023 08:31:39 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af2efd00225e3e97da45b943.dip0.t-ipconnect.de. [2003:f6:af2e:fd00:225e:3e97:da45:b943])
        by smtp.gmail.com with ESMTPSA id s7-20020a5d5107000000b002c556a4f1casm3877993wrt.42.2023.02.13.08.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:31:38 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 2/5] KVM: x86: Shrink struct kvm_queued_exception
Date:   Mon, 13 Feb 2023 17:33:48 +0100
Message-Id: <20230213163351.30704-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213163351.30704-1-minipli@grsecurity.net>
References: <20230213163351.30704-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reshuffle the boolean members of struct kvm_queued_exception and make
them individual bits, allowing denser packing.

This allows us to shrink the object size from 24 to 16 bytes for 64 bit
builds.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 43329c60a6b5..040eee3e9583 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -701,13 +701,13 @@ struct kvm_vcpu_xen {
 };
 
 struct kvm_queued_exception {
-	bool pending;
-	bool injected;
-	bool has_error_code;
+	u8 pending : 1;
+	u8 injected : 1;
+	u8 has_error_code : 1;
+	u8 has_payload : 1;
 	u8 vector;
 	u32 error_code;
 	unsigned long payload;
-	bool has_payload;
 };
 
 struct kvm_vcpu_arch {
-- 
2.39.1

