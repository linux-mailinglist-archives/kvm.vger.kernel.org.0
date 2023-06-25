Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D176173D52D
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 01:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjFYXH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 19:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjFYXH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 19:07:57 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF211A
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:56 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-38c35975545so2540591b6e.1
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687734476; x=1690326476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bl2xS0hpaMhLNXGaRDLAye8tC/jIz9OZNyY0aYdzy3U=;
        b=KbMaFmSofqmick+plETX0T+mF+UV+45vO49VyJ7JA6kAtF+qJwHiCKXRLip4J88uGr
         Igti9yUpic3Ls6GY/9Wha/3gaYHrnG0Vxf5eLjXHL2OBTYPXyySoTPm2MXH7nuyXL0zU
         nbMWVHtWgtx2khr7nFXLRQQ0Si1b2nK8iKK5ux5dix7U+Av1DAG0gxqpg3bvLu2vjNRH
         cY5Rfh6Ydbm7PeimaHCmBjEwAROiXJBBi8gYYHMhnc+vDRaXgpPoGCvSxKCqxtHElfxu
         +iL7UjdJ6KTTDR9xGg5mXl5jSq58WqIZyVbupMgxcQcFva87aSVNt4dDoCsITFwlVVGE
         cFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687734476; x=1690326476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bl2xS0hpaMhLNXGaRDLAye8tC/jIz9OZNyY0aYdzy3U=;
        b=UF/Twng9aCYc2dGCtfbGY0juuk5dRk7slCWtMIom11f28NdcFGE5oPuksg6Qxv7+Pr
         e6FTNMB4/1XoZNVR5VHqPPUHWIpIhzfuySpSbl2BvYmbTpQxE0GpH4Sl9j3PRkR59f5j
         B2qcLtKGkAia0RIEgPK1YDf23L8HmHgPB5VLV9AFHtu9HIdtaRFVT92+rg2qoL17zrId
         DrWxBE0jI/oR207iAb8QIjTdTFWPhpw+7B9/sl3pPCqZvahu8eOTUGr7hOKIG5LX2NSS
         ZBMr71oNOHrvI43DMHHkJjClW+7WdRDSRAuL37F4i7wt027n0VP6iiCsOylOY2yorEZ8
         ECvA==
X-Gm-Message-State: AC+VfDxmMUIgnoIk+k3Wm+J9JEcghkut7beFT+dXLySUvGrrHgRsDqTB
        iBHxMpIV7j7h7ZQMhx6CVZY=
X-Google-Smtp-Source: ACHHUZ5+5W+RcZMMKDb8pS61tgrv8Ela1lzVu99tUh2smk0denIO+W1dQYrHPE6NAvbWasv4+kzOUg==
X-Received: by 2002:a05:6808:14c5:b0:39f:393f:688c with SMTP id f5-20020a05680814c500b0039f393f688cmr27624441oiw.22.1687734475810;
        Sun, 25 Jun 2023 16:07:55 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b006668f004420sm2716397pfa.148.2023.06.25.16.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 16:07:55 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v2 6/6] arm64: dump stack on bad exception
Date:   Sun, 25 Jun 2023 23:07:16 +0000
Message-Id: <20230625230716.2922-7-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230625230716.2922-1-namit@vmware.com>
References: <20230625230716.2922-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Upon a bad exception, the stack is rather useful for debugging, splat it
out.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/arm64/processor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 831207c..5bcad67 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -130,6 +130,7 @@ static void bad_exception(enum vector v, struct pt_regs *regs,
 	printf("Vector: %d (%s)\n", v, vector_names[v]);
 	printf("ESR_EL1: %8s%08x, ec=%#x (%s)\n", "", esr, ec, ec_names[ec]);
 	printf("FAR_EL1: %016lx (%svalid)\n", far, far_valid ? "" : "not ");
+	dump_stack();
 	printf("Exception frame registers:\n");
 	show_regs(regs);
 	abort();
-- 
2.34.1

