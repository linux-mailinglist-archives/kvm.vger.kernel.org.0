Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E948C5815E5
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 17:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbiGZPDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 11:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiGZPDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 11:03:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E6A72E6B6
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658847817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8LOSOvmdlo8cOSBNyocAOSC7b+QHmt65vY4asog1hJ0=;
        b=WNzIRPT1bBoamY4qS7XRAZcO17d8wXudNBDGOTqEkSr4ZqD0XbvPQj8smnTPXDH5LIocjM
        v8QOEuRD3jtmeF5DS06bZaf1sMvWeoEBUNtJBeuoe2mP+vBoyxdiAb0IfWvnWS6WqCq2mB
        lGTfiuvylVS795l1TlLxjPoPuIce60A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-1t5rI_iTOkS1i4j6eRaQOw-1; Tue, 26 Jul 2022 11:03:35 -0400
X-MC-Unique: 1t5rI_iTOkS1i4j6eRaQOw-1
Received: by mail-ed1-f71.google.com with SMTP id w15-20020a056402268f00b0043be4012ea9so4765316edd.4
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8LOSOvmdlo8cOSBNyocAOSC7b+QHmt65vY4asog1hJ0=;
        b=4C9Ox7ZOe4QALEl+HF4MbqAit7z37KE9HAuxDe+Yox3IXuA90QuWEtaW2UTVC6dbPu
         SKlQE7i+fVdQVr2B6iUcOKPLUjmvh7eEmRXTg4kz7Xes3W3FWn+P0aHnjZn2XuxH8ZIV
         aKzj/5ISmmdr2BSeLnD1lmk3YBkh9jvbiDWQB3IcU24+I8pN3VU2L+EIRR/78IJKh5wV
         14xmL3QrDRW6WU6gtD8EEeL+trcxpTdun+IXUpFNRbxSU9diwYkmYLQgA4h4VUlK7eO5
         GjeBS0WugoaQODqYn+OC1Juj+MYP9r/Rxyzolh2K25InuDG6kHVToorXdyZbCQ/2ue3o
         uKPA==
X-Gm-Message-State: AJIora9PyBFZ/EzOmF9AUbHAFYXAxX9hB62yPQ8gS0Tt74/ex8U7h2kS
        H8Sb2Qsy7fzyo5F9Rt/F801bEjSFM88SHZUAMe+Pcm91beKb212qBrCBqvNdB2elyWGAJOh7e4W
        QiP6Uoyd/ze863AljI4MKRKZAMPDmeMB5BUl/4qmCiUepPYFbynYBPEOrW4a6gCK3
X-Received: by 2002:aa7:c784:0:b0:43a:caa8:75b9 with SMTP id n4-20020aa7c784000000b0043acaa875b9mr17971167eds.311.1658847814036;
        Tue, 26 Jul 2022 08:03:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vo3PoEV+zsnEFUOBw6Q92PD3vhPl1Gtxr57Pi82VqPmN3jeMFkEUhgZaoXCEtTMNZw7EnaaQ==
X-Received: by 2002:aa7:c784:0:b0:43a:caa8:75b9 with SMTP id n4-20020aa7c784000000b0043acaa875b9mr17971131eds.311.1658847813722;
        Tue, 26 Jul 2022 08:03:33 -0700 (PDT)
Received: from goa-sendmail ([93.56.169.184])
        by smtp.gmail.com with ESMTPSA id 13-20020a170906308d00b0072fb3704e49sm4625442ejv.46.2022.07.26.08.03.32
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 08:03:32 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: fix clang warning
Date:   Tue, 26 Jul 2022 17:03:31 +0200
Message-Id: <20220726150331.91457-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86/vmx.c:1502:69: error: use of logical
---
 x86/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index fd845d7..a13f2c9 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1499,7 +1499,8 @@ static int test_vmxon_bad_cr(int cr_number, unsigned long orig_cr,
 		 * bit set at all levels.
 		 */
 		if ((cr_number == 0 && (bit == X86_CR0_PE || bit == X86_CR0_PG)) ||
-		    (cr_number == 4 && (bit == X86_CR4_PAE || bit == X86_CR4_SMAP || X86_CR4_SMEP)))
+		    (cr_number == 4 && (bit == X86_CR4_PAE || bit == X86_CR4_SMAP ||
+					bit == X86_CR4_SMEP)))
 			continue;
 
 		if (!(bit & required1) && !(bit & disallowed1)) {
-- 
2.36.1

