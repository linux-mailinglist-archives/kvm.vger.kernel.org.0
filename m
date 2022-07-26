Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DAA580F2E
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 10:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238582AbiGZIhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 04:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiGZIhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 04:37:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 752A42F385
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658824654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FurqgRX31jVoiI2p8b4EmkiKFjf4ER8n82Uh1xsPhDo=;
        b=FO/HsPnOD49r3BGkh7C6cO1+YnKvoRVsebIA2PHu+YjAp5YiqIRIxc1ykUJw5gkYJiWpYF
        z/VHY/sb6vZWhKhY6EyMesLl4Q7H0CabPIg81y3r/e8t/8Z51Mdm65p6LQIED82foViyV+
        6UYJAb9Mxj1VQWfaqmdKEPnt3ZVgUng=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-Hb-0WJ5KObuWfRQFLZWawQ-1; Tue, 26 Jul 2022 04:37:28 -0400
X-MC-Unique: Hb-0WJ5KObuWfRQFLZWawQ-1
Received: by mail-ed1-f69.google.com with SMTP id w15-20020a056402268f00b0043be4012ea9so4222247edd.4
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FurqgRX31jVoiI2p8b4EmkiKFjf4ER8n82Uh1xsPhDo=;
        b=n1in8w5ktN8mK8RM5uiYuCoG9Ma78k6ywhgY2opzFlq92ualU+cQnuFzNEydz2Jape
         FCjYVLnCZwlQUOW6ioH6FWyktB3BMBWVeVwgMpXrXPQBvetiIG+nX1VlLHEOBC+c9Siy
         1NwOEihhkVuqkiY0Gs2xM65nAlxLOIYr07Soa1EBi9jCqs+eVxbg+X/ghRX/R2sJBJ0v
         5E52XQiSt7DwTLMQ4Bvnz/vuulzOj7y+xrTKJPZym3a2J0t2Wu3XE/OOPGTeLBY3Pquo
         AVorpyy/JSGm/vstpBYQM+OG5iDijfPwY56DbdVcDLjocAkLg97y8zvtQjSZIZn2prMA
         4V4w==
X-Gm-Message-State: AJIora+Tv5JqIX+sq3pNBwqEPhlYt1Jpy7EM9lz1CDHj8Q41qyv0sw4d
        9IgTatRhtj8kc85GkKDgqQI16aMxgXyhAHxB4rBqgLUZ2QMc+WWk53OowEFIlk4X809sHeP1xqp
        mX8yhfLfgct+7oNKo5kf1sRjrxuwPWD+Zf9/xVEYMqyMEEIMfQTDAdeTzvEHNPlF4
X-Received: by 2002:a17:907:a0c6:b0:72e:ee9a:cf89 with SMTP id hw6-20020a170907a0c600b0072eee9acf89mr12746852ejc.43.1658824647103;
        Tue, 26 Jul 2022 01:37:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1voOl14uHYpAP9YZBy7kzR5G5Pwt847cwy0JMatd4ESzo/kvdtPiu6BB7oU7d3lUAQCtWy9mA==
X-Received: by 2002:a17:907:a0c6:b0:72e:ee9a:cf89 with SMTP id hw6-20020a170907a0c600b0072eee9acf89mr12746819ejc.43.1658824646540;
        Tue, 26 Jul 2022 01:37:26 -0700 (PDT)
Received: from goa-sendmail ([93.56.169.184])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090623e900b006fed93bf71fsm6241504ejg.18.2022.07.26.01.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 01:37:26 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
Subject: [PATCH kvm-unit-tests] s390x: fix build with clang
Date:   Tue, 26 Jul 2022 10:37:25 +0200
Message-Id: <20220726083725.32454-1-pbonzini@redhat.com>
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

Reported by Travis CI:

/home/travis/build/kvm-unit-tests/kvm-unit-tests/lib/s390x/fault.c:43:56: error: static_assert with no message is a C++17 extension [-Werror,-Wc++17-extensions]
                _Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES);
                                                                     ^
                                                                     , ""
1 error generated.
make: *** [<builtin>: lib/s390x/fault.o] Error 1

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/s390x/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/fault.c b/lib/s390x/fault.c
index 1cd6e26..a882d5d 100644
--- a/lib/s390x/fault.c
+++ b/lib/s390x/fault.c
@@ -40,7 +40,7 @@ static void print_decode_pgm_prot(union teid teid)
 			"LAP",
 			"IEP",
 		};
-		_Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES);
+		_Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES, "ESOP2 prot codes");
 		int prot_code = teid_esop2_prot_code(teid);
 
 		printf("Type: %s\n", prot_str[prot_code]);
-- 
2.36.1

