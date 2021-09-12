Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58082407F39
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 20:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhILSTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 14:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhILSTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Sep 2021 14:19:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9DBC061574
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 11:18:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o202-20020a25d7d3000000b005a704560db0so8321355ybg.17
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 11:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=A5jzcEo3N8osg10m96UXC0mRrSn6XuuhJObZXmt9E+Q=;
        b=Amted87+W6/WP0Kg6XI/m7V6R5ychIhbfTusMpYEViZUdigBJUgvOWbExI3j08g3R8
         GDscaVh51TSLhnPo8DQcsH1oL4T1iqru9P2HtlcAzWsaumpHtNnySz1lToJp23D+Myuf
         4BJEiKVCREKgTxQdNt+TPqshjUEXhb7wyT9tY8kRfP18l8XoxMRdgsWe5kqQCfxTHHQT
         5+zCjsgphNpA4KN1LEYG/Scf1Ud9tWnxE+6Juk1+usX8Lap5U2ePMB8HXMHPG490RHTT
         8Z7JMGzuKKsW1KYtuMCmepRy1y7087X4RgwV6GVL0ndSzDdZEBgO8KtK6GGpMTy8uGBs
         8SWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=A5jzcEo3N8osg10m96UXC0mRrSn6XuuhJObZXmt9E+Q=;
        b=1cAnrl7DhTF5PtZX0krRR/qS8pql5a9zeIf8WdQ859U01r5EOkiKZQcYHc0lP2hBEk
         3qmA+/xr3FwfGki0Rnhqyal3/idyB/9WAZASVQ6SqsAdzyspRZ+LkLGR/YZOrpwIvYtu
         GUkPnHlZz/npb8mcLzOQ6s3V9gCvOGzvGoA5OuaBerGLfRbe+rvMNFEIj+SwoCoTm+sG
         PAVwOQtpdYwcBAuSV6zmB+luoRsQekMJm+h9GnKy6rgz80xLC4+RHvEgAG0Q7X2TW0+y
         F2492q1tIUsrk1RH1JR6EkuQd0SRio7U9WvWCnOUpePBMTg3EXfzi5+Gk++261tMWVek
         4f1Q==
X-Gm-Message-State: AOAM533qFq4R9JORj7cN+UnhOl0KBSK1s8I6O2bcMhBwc8VB8KdChXqI
        wXG5s5+L9hdkNw6QrcxGbs2xCFcZsCfq
X-Google-Smtp-Source: ABdhPJw+pcn8ymn8D7AhPPxq0UqlxK1KLvhUzH+nhooa4tfQoogcmF8mTgUYD4EhR9wOjrEkXzRPHqc/thu5
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a25:c441:: with SMTP id
 u62mr10565061ybf.12.1631470702545; Sun, 12 Sep 2021 11:18:22 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 12 Sep 2021 18:18:15 +0000
Message-Id: <20210912181815.3899316-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH] KVM: SVM: fix missing sev_decommission in sev_receive_start
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, John Allen <john.allen@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sev_decommission is needed in the error path of sev_bind_asid. The purpose
of this function is to clear the firmware context. Missing this step may
cause subsequent SEV launch failures.

Although missing sev_decommission issue has previously been found and was
fixed in sev_launch_start function. It is supposed to be fixed on all
scenarios where a firmware context needs to be freed. According to the AMD
SEV API v0.24 Section 1.3.3:

"The RECEIVE_START command is the only command other than the LAUNCH_START
command that generates a new guest context and guest handle."

The above indicates that RECEIVE_START command also requires calling
sev_decommission if ASID binding fails after RECEIVE_START succeeds.

So add the sev_decommission function in sev_receive_start.

Cc: Alper Gun <alpergun@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: David Rienjes <rientjes@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vipin Sharma <vipinsh@google.com>

Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..55d8b9c933c3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1397,8 +1397,10 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start.handle, error);
-	if (ret)
+	if (ret) {
+		sev_decommission(start.handle);
 		goto e_free_session;
+	}
 
 	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
-- 
2.33.0.309.g3052b89438-goog

