Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6436315F865
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 22:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbgBNVCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 16:02:48 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41869 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgBNVCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 16:02:48 -0500
Received: by mail-pg1-f193.google.com with SMTP id 70so5527750pgf.8;
        Fri, 14 Feb 2020 13:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=a5vpABAOF4tMnz1rUUiLuId4s5LEubXLb2rqt5r8eCs=;
        b=oGhvLCAqTKogQhSrxAAZT/zL/XDtpVJlRejNsl7YHbdxcpkycNRIy3kJfXrLxJ0sh8
         wzYrmh3qZdrja7JJkuSVS9CWcG7phlIYdCr5Ofrx2sEZpFu693pZWbUqLWrUlrBsjV3d
         +t47E0/WXHBFQPPlalulQdq7ctlEOpZpS8qWfV9K5R2YJP1TkwwcvXz2BOwx0O+NqEqN
         8IJC1xq27p6Gb2BuJtaLPydhiYy4OKXVYd40bozSmWWTZhPkAPHIwTHgUoiq2q2yDdEb
         NVA4ieQqPmGa25XdKwTkyTxxw46UytcD6DDMae9DxA83pxYxiyFm3fmauU7mXzm8CFJw
         15Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=a5vpABAOF4tMnz1rUUiLuId4s5LEubXLb2rqt5r8eCs=;
        b=Zgx8URsG2wN1FzG7Xg7Gfh3D5boO240QaBj6LmJS/UpiZZBZGsnsST0nj2lo5/xHm9
         thum0zPJaTlNlVY/CJyI3Dev4lHcaJHL5Tm0FCnd8H9eg5lgSvsmIDfkIOpRSF6PII5l
         UYKmMF7sS9slNU6HbBxwDAcqpRQfnqrJvINFcZyZgyeb+25UKMQeOyuJXmG5ICbFJtKK
         AECJPvMc2UIgOmGrKzjZA0+uftiI2I6BhI7Iw+r1WrLt46Pn/l1olcPg/Y7cI6+JUkv0
         Bk5/Q+OA4M8wS9SAj1YfwqRFr7Hhk3ss4Y40Wi0RHMsxWrrOic+ZW1P0ga/TL7N5tLtL
         JIjA==
X-Gm-Message-State: APjAAAUn9jWP2eqx7ZqSjs9dFJZiEgq+AP12eO6OGgfWkPiDtpsC4JWE
        GMck3dqaH19bCPmYZOvDLg==
X-Google-Smtp-Source: APXvYqyj7hwkSoVtaBZ7FLTUEWmuCah+0sp4N5QxvC0rPRZrPVxxGsQBwJDGGMxPr3DUmDASbW3mqA==
X-Received: by 2002:a63:1c4:: with SMTP id 187mr5508035pgb.121.1581714166014;
        Fri, 14 Feb 2020 13:02:46 -0800 (PST)
Received: from [192.168.199.209] ([111.199.188.104])
        by smtp.gmail.com with ESMTPSA id q11sm7811030pff.111.2020.02.14.13.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 13:02:45 -0800 (PST)
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH] KVM: Add the check and free to avoid unknown errors.
Message-ID: <aaac4289-f6b9-4ee5-eba3-5fe6a4b72645@gmail.com>
Date:   Sat, 15 Feb 2020 05:02:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

If 'kvm_create_vm_debugfs()' fails in 'kzalloc(sizeof(*stat_data), ...)',
'kvm_destroy_vm_debugfs()' will be called by the final fput(file) in
'kvm_dev_ioctl_create_vm()'.

Add the check and free to avoid unknown errors.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
  virt/kvm/kvm_main.c | 5 ++++-
  1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67ae2d5..18a32e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -617,8 +617,11 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
  	debugfs_remove_recursive(kvm->debugfs_dentry);

  	if (kvm->debugfs_stat_data) {
-		for (i = 0; i < kvm_debugfs_num_entries; i++)
+		for (i = 0; i < kvm_debugfs_num_entries; i++) {
+			if (!kvm->debugfs_stat_data[i])
+				break;
  			kfree(kvm->debugfs_stat_data[i]);
+		}
  		kfree(kvm->debugfs_stat_data);
  	}
  }
--
1.8.3.1
