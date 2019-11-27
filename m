Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D4410A8FF
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 04:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK0DFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 22:05:41 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40881 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfK0DFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 22:05:41 -0500
Received: by mail-pj1-f67.google.com with SMTP id ep1so9249123pjb.7;
        Tue, 26 Nov 2019 19:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=i34ebQ7c/s5886cOtfqmhdiKMr1NWUArCMVccSTOyxU=;
        b=Pfm4JbgbDK8Hg8YjSkmdCPGylzWp994a1QuRB61z+ZK0BmYqGgYlLY1KUekaYs2Djd
         4gZozuSsPwNNcNh47tXjoMMX0AvaRYVmz510JslIjS2LGIV6UcEDvkueNR6zfTwM5cag
         FrVXMdyOlub4ccCM3B0pjz9I8GBwKYjslxy27Cye6AClqADDkd0aoLMXUFcEtA6H2XiM
         maqHJMuK+xbdkGg1NY+zo0od8Kcb88H0DTLtXeBwPHOnhin64DRbii6/6IygZEUNaEsi
         WH/9+af1phMZGFeU8dhsPDw8DG8EJH5uqDZ9gqehpJ5I/dZE56vKw5QQSHkqZk6vWcbU
         dehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=i34ebQ7c/s5886cOtfqmhdiKMr1NWUArCMVccSTOyxU=;
        b=UDh4XxFVYLZvFvkDECZpfLN75J4RVUO2+9J/51pFFqeXJ2WLaGvGreI0hjoCMW51Ga
         /rdg/EJNRBjITc2sCk/tUZMpWyDIUB5eznYKPcWp9C+Io6lx7UECwLOfYdLD49S/N8nn
         ax7LrA3ZsAa2YJrAzjrvoB+DkCMOGvVWxPCUknTHMvL5XPKp3YiF9S8hpr5mZKM5fE5e
         225kFqj3bU8Cwd65RrCyrBI2mMI6Rjy82v8vNcISmr+cPzWywyukJZyykYet5KYTeAn1
         T0KCD0rs2odZXbksQQ4cryp04VF541Dm6B+W9zg+KdgIMeocJ1pgg9W8dZ0B07+Iavkl
         eoFw==
X-Gm-Message-State: APjAAAWMkFBSEiX/vL1SM5Wait4AUmvyLJshZkhgOvRGw4uZiWHdI5zM
        mwr23zr+a40QQcezAVCnbA==
X-Google-Smtp-Source: APXvYqwkqFrtKPql4uSZmaiVCUopiUt+Vc/mcofIk3c8sjgtYAEWiAqNAIZKx7yR75jVY9qqGm95nA==
X-Received: by 2002:a17:90a:2c1:: with SMTP id d1mr2925498pjd.137.1574823940271;
        Tue, 26 Nov 2019 19:05:40 -0800 (PST)
Received: from [10.72.166.40] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id x4sm3841439pgg.61.2019.11.26.19.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 19:05:39 -0800 (PST)
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH] KVM: SVM: Fix "error" isn't initialized
Message-ID: <f0bac432-ad0f-8d6a-eb92-6135f68d16d6@gmail.com>
Date:   Wed, 27 Nov 2019 11:05:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 From d32ebcf6f426385942fe6c469255e73188cd7d38 Mon Sep 17 00:00:00 2001
From: Haiwei Li <lihaiwei@tencent.com>
Date: Wed, 27 Nov 2019 11:03:21 +0800
Subject: [PATCH] initialize 'error'

There are a bunch of error paths were "error" isn't initialized.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
  arch/x86/kvm/svm.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 362e874..0b3d49c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6294,7 +6294,8 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)

  static int sev_flush_asids(void)
  {
-	int ret, error;
+	int ret;
+	int error = 0;

  	/*
  	 * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
--
1.8.3.1
