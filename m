Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4562355F0E
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 00:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhDFWuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 18:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344320AbhDFWu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D3AC0613D7
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 15:50:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i6so21911661ybk.2
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 15:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=csTFUpsRawa07wcmPlEmUE8R3c/8ED1fSyaPMVbY1/I=;
        b=ff3Qi8XlXaAP8Ho2RSWqRgeiGlfya7kplhOvaksEp9BmY37Y78knjcMBQPMdr0bkdj
         i6mofTDVD21bxrCn2qrsF6/ZM5F6AG/PtOnjbNgjZjDFFTzA+pp5DQUFL91v9mwNdKrg
         9KlR5eJb1m25NsJhf18rWWy1y5RCmIEiN0Q3nokwOo0bcVMPIQFOdbEgypQ3VGVC4A88
         Y20jYwiqSnMhAoyDCjMaSoxIHssFJ/hRvxuS93qqIMdYAUmgnLvhW5iGZWzGlmi1zT5q
         iYu8Q/4JfbkQ414gV4CUnQpHfmJERzjFRjHGL+lAH0/nBivSMrJvmW6JoTItq6Du7w4E
         IYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=csTFUpsRawa07wcmPlEmUE8R3c/8ED1fSyaPMVbY1/I=;
        b=QadAnsBFy+EYJXV09n+b6WodeXMixolmljIU+lGnCWK/y88ETrwnzgumCEdrtUAcpx
         FYRZE/BJXKm/JXhGkeogMbMqGt02txoiycUx4Mp2MhDr2ZKpCMtwiVnjMBu0m1tqhEey
         ahxxlrvs3jwzL8MYQxi1Megob0Xi+sJpPPg5ZpA/L2zkkDe1h+CTNvWy4Ik5GU9fbQWb
         FTe/BqdpQ+7ZEFvLnZc7HXUCp+/nViW4dSf0ehyT67tqmLCazg/xy9AdvVjCgWqvubPg
         ilVkjYvmQglRAtKfbJJicZpXv+D69q7VUDZTVAGS7P9MpLHH8XsVa7fpE7cly8gW2FVw
         jWuw==
X-Gm-Message-State: AOAM5324HjxyJQUCiC6a7c5CPPlghx4fcT1Q+zv/5peC0Qad/5w1iPjV
        B7+k9wNX193I2VrYRbWB6veVvxsqcng=
X-Google-Smtp-Source: ABdhPJzA/KxCkl9GQmyOLhOkCUX3BBpDSU1ecrOweyAwp+jRB/OA9VvOLBWyuq9yZ7lYhKOxmUTIcFoJpfQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:4cc6:: with SMTP id z189mr475227yba.453.1617749420597;
 Tue, 06 Apr 2021 15:50:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:51 -0700
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Message-Id: <20210406224952.4177376-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210406224952.4177376-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 7/8] crypto: ccp: Use the stack and common buffer for INIT command
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

Drop the dedicated init_cmd_buf and instead use a local variable.  Now
that the low level helper uses an internal buffer for all commands,
using the stack for the upper layers is safe even when running with
CONFIG_VMAP_STACK=y.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++++----
 drivers/crypto/ccp/sev-dev.h |  1 -
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e54774b0d637..9ff28df03030 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -233,6 +233,7 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 static int __sev_platform_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
+	struct sev_data_init data;
 	struct sev_device *sev;
 	int rc = 0;
 
@@ -244,6 +245,7 @@ static int __sev_platform_init_locked(int *error)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
+	memset(&data, 0, sizeof(data));
 	if (sev_es_tmr) {
 		u64 tmr_pa;
 
@@ -253,12 +255,12 @@ static int __sev_platform_init_locked(int *error)
 		 */
 		tmr_pa = __pa(sev_es_tmr);
 
-		sev->init_cmd_buf.flags |= SEV_INIT_FLAGS_SEV_ES;
-		sev->init_cmd_buf.tmr_address = tmr_pa;
-		sev->init_cmd_buf.tmr_len = SEV_ES_TMR_SIZE;
+		data.flags |= SEV_INIT_FLAGS_SEV_ES;
+		data.tmr_address = tmr_pa;
+		data.tmr_len = SEV_ES_TMR_SIZE;
 	}
 
-	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &sev->init_cmd_buf, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
 	if (rc)
 		return rc;
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 0fd21433f627..666c21eb81ab 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -46,7 +46,6 @@ struct sev_device {
 	unsigned int int_rcvd;
 	wait_queue_head_t int_queue;
 	struct sev_misc_dev *misc;
-	struct sev_data_init init_cmd_buf;
 
 	u8 api_major;
 	u8 api_minor;
-- 
2.31.0.208.g409f899ff0-goog

