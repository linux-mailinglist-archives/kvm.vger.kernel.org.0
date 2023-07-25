Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245C97606C3
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 05:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjGYDjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 23:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjGYDjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 23:39:51 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26010171E
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 20:39:51 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bb9e6c2a90so14291645ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 20:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690256390; x=1690861190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYm5KBKtRgmHqsJ7qG78pZ/7OSA76dtqycHyYKXgSwc=;
        b=HLq21PCypW5pBm+OmMRaVavDQKsrHOsrS24TADqmsS0BDKgV2NdS1+cAK39OXZyksZ
         NSSyqOUNGaH/Inc7/qkeUQshGNm9MdYqmHnXitzzruqKrCv7cDgwrTtXtKujrNca926t
         FzmUGo9TSBzxbctnjlv1sPI+2v7NhkekUNiNHS4C8bxjHbG2LDupzrY61H8ifyRRFhPz
         fDm2lwB4wdJ4WeroJTXU9C2m9l/fSYqufE8ULqGXbEy9TxcAPZuInQzLkfP6zCYymH5u
         CgtpF8ZEYsHDT4cCmU+etMKOOZWyXQcNM4Gbc7Jd2o2250JocsPEHl6owowqcSCVWxu1
         kMAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690256390; x=1690861190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZYm5KBKtRgmHqsJ7qG78pZ/7OSA76dtqycHyYKXgSwc=;
        b=BtmvsNJo1TRG7kzYXRxFmgZxigUNdVnNj3tBCNW2RJ37eTyPb7f5QIkYqLhXZB9jOq
         q0pBbhqbTF74TuU5MK+lSphFAyg4DA70A8BE2YYYbRK7TtbnL8GrXewI5xADbzPX2ppx
         MIrdLia7ZgE2afqg7HAqbubCfq63s/484k91neNbKq4Xvy4y/2pTnCYZn7flEjuZaZHW
         Wwnd55u6giLiiSxY8A3ZRWnZHICI6biZAGNeuosYAeXSyY+NZ+T7PuX8cQC5paB0NcCP
         oRkq2c+2/qce6kVPzM/pP07ABQ8oScmFK44iyHpVkchBA4/WGjPqq9IdwM15S9bhzYNN
         Bh6w==
X-Gm-Message-State: ABy/qLbs7eyGZBT0V6ocQofSJevzCQdApJnPIFiMpjyma2t1hJaYFL//
        ryfZQ1mwnlEVmZHsdY8NNfpGW9b+cxc=
X-Google-Smtp-Source: APBJJlHmlwkxy/1k+VB2FrYgeT+RuUU9bbvZ47VOVWeB+Xgfql8wE5x5ci7ODC6WUhILTb17fN81Wg==
X-Received: by 2002:a17:903:230b:b0:1b8:9b5e:65c8 with SMTP id d11-20020a170903230b00b001b89b5e65c8mr16049113plh.4.1690256390381;
        Mon, 24 Jul 2023 20:39:50 -0700 (PDT)
Received: from wheely.local0.net ([118.102.104.45])
        by smtp.gmail.com with ESMTPSA id i5-20020a170902c94500b001b809082a69sm9793112pla.235.2023.07.24.20.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 20:39:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH 1/3] migration: Fix test harness hang on fifo
Date:   Tue, 25 Jul 2023 13:39:35 +1000
Message-Id: <20230725033937.277156-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230725033937.277156-1-npiggin@gmail.com>
References: <20230725033937.277156-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the test fails before migration is complete, the input fifo for the
destination machine is not written to and that can leave cat waiting
for input.

Clear that condition in the error handler so the harness doesn't hang
in this case.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 5e7e4201..518607f4 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -165,6 +165,7 @@ run_migration ()
 		migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
 		if grep -q '"failed"' <<<"$migstatus" ; then
 			echo "ERROR: Migration failed." >&2
+			echo > ${fifo}
 			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
 			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
 			return 2
-- 
2.40.1

