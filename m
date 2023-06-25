Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A1773D52C
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 01:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjFYXH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 19:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjFYXH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 19:07:56 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF37E46
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:55 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-666e916b880so1203656b3a.2
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 16:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687734475; x=1690326475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zfLc8s8ukm6B8uTEBNuw3gp/VvXLK+Q2HtLxCf87RA=;
        b=AynI/fZMfTDQaf+uit3KBv2q/DJ9daWnRBz76NzDxTFBam4mj9rsWeOM1TwnMy+mdN
         ziXPVeb9KYV5pHMUL8bdcpq4qsWMJr95dKpz+LOP5Jbex2hnflc+lSHY+PdGj7sK4i5D
         nsFBHOASa9caRVyrAtp1ZZmHDj7x+bkkg1j64ePu+xNpfX7//dja9qtd9yLknR9rSG/K
         NKUtJ/4ZDik9XNgCp9/ClIyBiPO+nSxKki06oJKV54kGbMdwTqV+Lme7P1PucGT00oK/
         hVOIQuVOuQgGl3CmUnuEXLxyPXn+eIkNPlTXpCLd4wPWx9a9+A2/Y6kJYucUiBdAdWVu
         rMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687734475; x=1690326475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zfLc8s8ukm6B8uTEBNuw3gp/VvXLK+Q2HtLxCf87RA=;
        b=E8qn/8U7Z0yZkoFLPjlGSI4+INLgLROPaN1awFpvBbWgv9BHa0Tzx+fpbXR08wgO+G
         3P2fNOefV4CB4gWodVYNl0M3HgDfeP0oVHV3HL/XIZWq/nieA+Vu5Hi5ynI1ihX4ZP3Y
         v4K4bYrOdowWyPAauv1+P/bAIlCAkhoPSm6hdE57aV7RF1FqqQVGThHkt/bsUa9wfI4S
         05Fto2ApIrRDEJwzB0HTUY+bYdFn0qEqCi1DDtzQli34kr/rvfYADNF49j2J0cvhI/yG
         7VzUE22eJFXToMTBdqWCahNMq3DscYSWXB3L4crcI8SK6CQuz4CuPqwc26eMXr3n9LL+
         yKRA==
X-Gm-Message-State: AC+VfDwGMh8Z/0lzwRVchtIa+Ntph9WPoWH/Qe1DhDwAXotQjnRxs7vw
        +nTygn67f/cxYIctas6lbmE=
X-Google-Smtp-Source: ACHHUZ51li6kaeUchqHwWbbjtLqSUUE2pFgSQxSkwB36acZS+Cdmp79EVQgN2I58zJnvMK3amYaQaA==
X-Received: by 2002:a05:6a00:194d:b0:666:2889:32bd with SMTP id s13-20020a056a00194d00b00666288932bdmr16655032pfk.9.1687734474490;
        Sun, 25 Jun 2023 16:07:54 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79194000000b006668f004420sm2716397pfa.148.2023.06.25.16.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 16:07:53 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v2 5/6] efi: print address of image
Date:   Sun, 25 Jun 2023 23:07:15 +0000
Message-Id: <20230625230716.2922-6-namit@vmware.com>
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

Using gdb to debug tests that are run from efi is very hard without
knowing the base address in which the image was loaded. Print the
address so it can be used while debugging.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/efi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index 2e127a4..2091771 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -19,6 +19,8 @@ extern int __argc, __envc;
 extern char *__argv[100];
 extern char *__environ[200];
 
+extern char _text;
+
 extern int main(int argc, char **argv, char **envp);
 
 efi_system_table_t *efi_system_table = NULL;
@@ -363,6 +365,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 		goto efi_main_error;
 	}
 
+	printf("Address of image is: 0x%lx\n", (unsigned long)&_text);
+
 	/* Run the test case */
 	ret = main(__argc, __argv, __environ);
 
-- 
2.34.1

