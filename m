Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78147355EFC
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 00:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344191AbhDFWuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 18:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344193AbhDFWuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD90C061756
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 15:50:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x22so21770450ybi.1
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 15:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9unnZdwnJBhmIr85WtW6opdl6PIonHCZIupIJTvjWiM=;
        b=TkbGpsapVhMM/9vNTvKB2L0fGV6FDhcQqCVGeETLXWxcwfezHG91/Q32wDXz4NNQzM
         nc0exNLd9sY6ryGmhhmyHB1RRJGT8Chj3tHZWlz8EP2ltZ2XznhwfwqVrVa8wOWGyxx7
         0q80IQ90Nro8z6l81DX7mZp32wgeHg/9fnbOVCWSN+TnbJo+T+psv21FIznZvp11IQSD
         7OO9fnXsMk0l7y7GljMe9yy4UhNrmsgXxl6Vnzk+LjeuD/C1qm4zOXUElsRpln+otQI5
         b1CaykelVe2JuM1a88H8nPQECvnwDlaUMgwiRCR90/JGzBaByfMcJAkkJv8tWLv1lKzC
         aw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9unnZdwnJBhmIr85WtW6opdl6PIonHCZIupIJTvjWiM=;
        b=A1+QTuyzXxG4SQoM5EL8BYIWBwMLcQApMmOecdZGKGHtZpmfsjsV6kj5wqC5XOcI1C
         7TBXWFAqcUqGRQ9cUhupxtzd/U4nGs28cQg5k2gu4vULT6I7anJXeQflJvZoRK/l47+U
         GO4g/R7wrPWx5E8v+J9RR3QnPkVsxaivBjQziUbamSr9yoEH3HAmOkmRndghfyGDXItc
         gdeh2fFYDKx6NeXZmiB0xFE6IOgVk5Fz4nOC7efpcRL33gmxfVZxXVkKFk9/JFlO1Yyw
         YEm5ufriYDN72sAF0zjdL8m7bB5/KodrrEsNnrf2b0zL+aDGm3WTKMbII1z8nDPrrQJy
         7KqQ==
X-Gm-Message-State: AOAM532vFTtFIC7cUMKUQ2nCLCEcpgF8OaTukFGHiGO8+xM0wa1fROzV
        AOF/7pbCDaL3Ix/B5fpuhMsiMSPrArU=
X-Google-Smtp-Source: ABdhPJzlb0ZbdnN3YVCAvkv4hLaHNRneUSdCrOk9RA1gK+d59njBjzucCXv09ROJce8rsyMB2b1YQgaYp58=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:b3c1:: with SMTP id x1mr517791ybf.506.1617749407346;
 Tue, 06 Apr 2021 15:50:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:45 -0700
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Message-Id: <20210406224952.4177376-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210406224952.4177376-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 1/8] crypto: ccp: Free SEV device if SEV init fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Free the SEV device if later initialization fails.  The memory isn't
technically leaked as it's tracked in the top-level device's devres
list, but unless the top-level device is removed, the memory won't be
freed and is effectively leaked.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cb9b4c4e371e..ba240d33d26e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -987,7 +987,7 @@ int sev_dev_init(struct psp_device *psp)
 	if (!sev->vdata) {
 		ret = -ENODEV;
 		dev_err(dev, "sev: missing driver data\n");
-		goto e_err;
+		goto e_sev;
 	}
 
 	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);
@@ -1002,6 +1002,8 @@ int sev_dev_init(struct psp_device *psp)
 
 e_irq:
 	psp_clear_sev_irq_handler(psp);
+e_sev:
+	devm_kfree(dev, sev);
 e_err:
 	psp->sev_data = NULL;
 
-- 
2.31.0.208.g409f899ff0-goog

