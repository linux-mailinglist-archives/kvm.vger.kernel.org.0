Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44201468D10
	for <lists+kvm@lfdr.de>; Sun,  5 Dec 2021 20:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238179AbhLETu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Dec 2021 14:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbhLETu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Dec 2021 14:50:56 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FC4C061714;
        Sun,  5 Dec 2021 11:47:28 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o29so6587284wms.2;
        Sun, 05 Dec 2021 11:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p6VZNSUViKWsvBC4D3bAKgcLTUpKM8IQ1NkUj0lnKj4=;
        b=W50julzPbKEIBzCs7GVoL+u92IdUaKcc0pWeEnNB8D3VW0wbOp4jL0rWVMNDGBot3U
         f70gL8hSU1ddD/n2o4GiRYTgLzW6jnrBniEajSNdd6WKLqG2ktVqxT9mnUxPW9Yh0Eol
         /MCv2VUNAKARr0BvmW35+LOGKnlPCPtnJqRc4U6M/CabYydlnYbFGVj2M1YsxbqBwkl3
         b5p4QDhqgO9ZehJQCHTZigxHyuDqMX76kfM4G+liEGJ9r7wwWBziSvijuulyI1aEsw3J
         2TslKoVtwJBcDilwws1CtaSw1FRaYd3bqFKQBaqPrJaXRv83NvW9Ag8CmkOLVZOM1u97
         XfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p6VZNSUViKWsvBC4D3bAKgcLTUpKM8IQ1NkUj0lnKj4=;
        b=O6ptHQ8JESuGTJhc2rPHf0vpOXDiKdK/2RKQSU+kY/haUY0Im4IwnCrVZNoNHAmxZn
         8TtrrhGrLZhXdhmf9E9qVncNBZTjYJmensnZ1B540xyrUP6dl7t+8dr79JqolS+H2TmF
         lVfPPwx/ztCWwRaWGj5xULgGf5JxSoEEiGQPx6yimmkbXTAsGJsfG/fGx0R0fdGT8/ZH
         EP4HOtijAynOFFMI4ynO5Vmbyk60LV8rtmtW/WKIIJWqNQ+VFeh1MUKDC/Q8KfHEiArc
         eaC/L00vzYqxF6Vyjpn1q9aIm/hPcNyO0Ed9tIRfi0pqj8htyJfj+sP2UVtm4DeIcBl9
         qZaA==
X-Gm-Message-State: AOAM532zofnhUn3h+JsWeiwQ90rfBW1cioE0muEx8v8PW3zqfYMhb+tQ
        bgEPoUppojqBI9WoQckIs3M=
X-Google-Smtp-Source: ABdhPJzzMcj1rJTNC1APFmjwJlezJA4W7THygiS9yh+7Eh+WcgqorVpHqbiWwOxQ1RZdWMaOj++TEw==
X-Received: by 2002:a05:600c:3c91:: with SMTP id bg17mr33713320wmb.80.1638733647439;
        Sun, 05 Dec 2021 11:47:27 -0800 (PST)
Received: from localhost.localdomain ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id w7sm9231516wru.51.2021.12.05.11.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 11:47:26 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        amhamza.mgc@gmail.com
Subject: [PATCH] KVM: x86: fix for missing initialization of return status variable
Date:   Mon,  6 Dec 2021 00:47:19 +0500
Message-Id: <20211205194719.16987-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If undefined ioctl number is passed to the kvm_vcpu_ioctl_device_attr
function, it should return with error status.

Addresses-Coverity: 1494124 ("Uninitialized scalar variable")

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0aa4dd53c7f..55b90c185717 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5001,7 +5001,7 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
 				      void __user *argp)
 {
 	struct kvm_device_attr attr;
-	int r;
+	int r = -EINVAL;
 
 	if (copy_from_user(&attr, argp, sizeof(attr)))
 		return -EFAULT;
-- 
2.25.1

