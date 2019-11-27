Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B5310AB1C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 08:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfK0HXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 02:23:25 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36414 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfK0HXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 02:23:25 -0500
Received: by mail-pf1-f196.google.com with SMTP id b19so10535354pfd.3;
        Tue, 26 Nov 2019 23:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+dIEa+jclTmXr02IdnKWGZL7TW+4WBFOQZr27PMe7Hc=;
        b=LUVyaSWC8ur/hYdxkd01ssliYl8hgfyWz8MGHZr/pgpnMxFKjZpDYmTiv5Xbg35YPw
         T7bstW0FN20orFDv24ZfFaJmwxuZnbyCm54i/lY2fVlxZbGc+I9mpTj4zMKF9Ao6ITw2
         Pqnh/fqvQvU3kNZJNw/psAiDHpbFzjG3kozmrkJ8QM9ZMm6dGbruFw1jJA7yYEEGQdc1
         tRj7XHGlxPWtJGHXutDg9aXe2QGMH7qZl3vERWQ2qifuLNk6n3KUgSvN+sVc3O5zlV55
         Ku58NI1qssmv0EJdTyunl9MYkZI8Yro68/kLXxZNDAz/+hbcbrJn1ibZystLXwOv6OOY
         Djrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+dIEa+jclTmXr02IdnKWGZL7TW+4WBFOQZr27PMe7Hc=;
        b=EfnypMnCH7Jbfw/qBdSWtUoPPEypwm4ywGbAzIEZ3QdK+oS1KNkji2PZgDPMDWKIZo
         +D+P1L8ra94nIVxbqHRYtngHeZPYnIzRqd0nSnIB9tK0eamAAhXm2k8ZLMVjNFZiz5VC
         2EsNftTsn0Xg2w6w/Q4RXXSeCZPQ8YyN0a0gkMu4CAokD9s4Y7Olzj3g/xGn23anJqGr
         l/+//tdjIuOnHdZPNjEhwl0EqGQ//weaUI/6zUeamY+PfCUyb4mNSEMYSPZ2XTinDDcv
         suaPa73lHJa4bDmLdURaLceRF9ELSN2hzBywUFAhNqTLrdeuMehJE8EG20M75uzElX8c
         8xYw==
X-Gm-Message-State: APjAAAUtvVeXW33jJtnmZBisMSpHjQ8kwjlzT8B+Wi9l5+JvBVr5fYIs
        ImGxWVZAhdS5A0XtghuIoQ==
X-Google-Smtp-Source: APXvYqzS17o0cTwSBMikvDtpI2vJkGXunqmsk69ZCLz76soXE2RAFfo2u+HPnSMvKaOmoDyyDIMEnw==
X-Received: by 2002:a63:ea09:: with SMTP id c9mr3283058pgi.232.1574839404727;
        Tue, 26 Nov 2019 23:23:24 -0800 (PST)
Received: from [127.0.0.1] ([203.205.141.52])
        by smtp.gmail.com with ESMTPSA id g7sm14609829pgr.52.2019.11.26.23.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 23:23:24 -0800 (PST)
To:     "x86@kernel.org" <x86@kernel.org>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH v2] KVM: SVM: Fix "error" isn't initialized
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        thomas.lendacky@amd.com, gary.hook@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Message-ID: <2967bd12-21bf-3223-e90b-96b4eaa8c4c2@gmail.com>
Date:   Wed, 27 Nov 2019 15:23:09 +0800
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

 From e7f9c786e43ef4f890b8a01f15f8f00786f4b14a Mon Sep 17 00:00:00 2001
From: Haiwei Li <lihaiwei@tencent.com>
Date: Wed, 27 Nov 2019 15:00:49 +0800
Subject: [PATCH v2] fix: 'error' is not initialized

There are a bunch of error paths were "error" isn't initialized.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
  arch/x86/kvm/svm.c           | 3 ++-
  drivers/crypto/ccp/psp-dev.c | 2 ++
  2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 362e874..9eef6fc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6308,7 +6308,8 @@ static int sev_flush_asids(void)
  	up_write(&sev_deactivate_lock);

  	if (ret)
-		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
+		pr_err("SEV: DF_FLUSH failed, ret=%d. PSP returned error=%#x\n",
+		       ret, error);

  	return ret;
  }
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 39fdd06..c486c24 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -155,6 +155,8 @@ static int __sev_do_cmd_locked(int cmd, void *data, 
int *psp_ret)
  	unsigned int phys_lsb, phys_msb;
  	unsigned int reg, ret = 0;

+	*psp_ret = -1;
+
  	if (!psp)
  		return -ENODEV;

--
1.8.3.1
