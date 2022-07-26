Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB6A581875
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 19:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239158AbiGZRiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 13:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239452AbiGZRiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 13:38:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2C1A2E9DB
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658857080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sWzm0DLPHs5F5TGWF/3So4rl+1KlzHURmpCX78JE+vw=;
        b=hU/50N1XnEaQKUkgMo/jNW6PX1lCu4gd/vq4bb2A9e0ZeBTV0K0stWSlU5DPQonPqgMNMv
        CWy8C6rDNB75TCYnqg6O4BmJm/dCbkPINT+US7rtaHjwLkQfjd/ld2/o//lbggamqol5fh
        1wrnS4bWHWV9+mzloCygi4HT78tL1S4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-TcJyorDpPsGQiMn6cCQ7mQ-1; Tue, 26 Jul 2022 13:37:59 -0400
X-MC-Unique: TcJyorDpPsGQiMn6cCQ7mQ-1
Received: by mail-ed1-f72.google.com with SMTP id z1-20020a05640235c100b0043bca7d9b3eso8241464edc.5
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:37:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sWzm0DLPHs5F5TGWF/3So4rl+1KlzHURmpCX78JE+vw=;
        b=sJYxLm5KoSZ3taMa8WZVliitreoNeJ19vldYU0QM90SUTNGiyAks9hqGu8Yf2Bf7Ij
         XDdqnNT/oPj9Ex4PDov8G1QB7rO7M7ng3K6sH0QnCao2bEAKO8kjt3JM1Ds3c2l/UlLa
         0uLcpg1RkyUt1Pshm0Dm+oIhInsJsJW/1vHg90R9xKCnB88zmhWfsEmdYwSghcnFxg+z
         QEmR0cQayBIgpc0G3NW85aYlhMHX2oNURhT11wkkFCrDaL4aHqptt+878a5709SvM9Ni
         VaBu3b1404iUEr39yeSs5vfF8bGsK+BIHnkIJZBIVa1VJTcUJSp4jz+beuI/SNaJMeyP
         qQ8A==
X-Gm-Message-State: AJIora+kqcOIp/zpU1mnlVI83C56tBihmcv2CW/gEdmb8dehQWF5Rfs+
        v2AVBHv8Ve0EIYm8OgVwTw3HTuvQZWUgB7P6/VYkEEF1LjBqeIdPMfST1pNUc+McxQXi2j/NjkD
        NDR8f9xQTFsMyWoPw35boeFCFLi8C1ZJIbZCFttZIged49+cC298hIOf/SWKO+VpY
X-Received: by 2002:a17:907:2cc8:b0:72b:7c72:e6a4 with SMTP id hg8-20020a1709072cc800b0072b7c72e6a4mr14698957ejc.160.1658857078136;
        Tue, 26 Jul 2022 10:37:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1suTrWcv9oArOwoRu3MYbuqnq4SFJi8PvqlwPJWMcAiwgtuMET+B0PGDo1j0ILsT33xJB6jtw==
X-Received: by 2002:a17:907:2cc8:b0:72b:7c72:e6a4 with SMTP id hg8-20020a1709072cc800b0072b7c72e6a4mr14698939ejc.160.1658857077813;
        Tue, 26 Jul 2022 10:37:57 -0700 (PDT)
Received: from goa-sendmail ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.gmail.com with ESMTPSA id a17-20020a50ff11000000b00435a62d35b5sm8750423edu.45.2022.07.26.10.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 10:37:57 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH kvm-unit-tests] x86: smp: fix 32-bit build
Date:   Tue, 26 Jul 2022 19:37:56 +0200
Message-Id: <20220726173756.108816-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On macOS the 32-bit build gives the following warning:

lib/x86/smp.c:89:29: error: format '%d' expects argument of type 'int', but argument 2 has type 'uint32_t' {aka 'long unsigned int'} [-Werror=format=]
   89 |         printf("setup: CPU %d online\n", apic_id());
      |                            ~^            ~~~~~~~~~
      |                             |            |
      |                             int          uint32_t {aka long unsigned int}
      |                            %ld

Fix by using the inttypes.h printf formats.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index feaab7a..b9b91c7 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -86,7 +86,7 @@ void ap_online(void)
 {
 	irq_enable();
 
-	printf("setup: CPU %d online\n", apic_id());
+	printf("setup: CPU %" PRId32 " online\n", apic_id());
 	atomic_inc(&cpu_online_count);
 
 	/* Only the BSP runs the test's main(), APs are given work via IPIs. */
-- 
2.36.1

