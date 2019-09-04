Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE1AA921D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387830AbfIDS4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 14:56:44 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:34860 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387735AbfIDS4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 14:56:44 -0400
Received: by mail-ua1-f74.google.com with SMTP id s1so2603019uao.2
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 11:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VZbtzYth1iyB1JmiHi6rjfOXl9Od7ZdhUTqesBSHm68=;
        b=oHn5sY9tt+TG6qHT1zfqLjF7lsDATz0QQGQDwLznqt/m2xKMfYR2VxMQa2cajt11b4
         teRRcDjzrmJ/P5YQsKyPF8sOlOj3oOOOMVsYSADFY6pNVD5Ly03XimzFBBcTw6sgO70t
         QDoWybnVJTTpe+JDz6TpNpnPEIC7lgznERrZiE2b6cS48OdWhgGFgW9AhutIKgy6ruy2
         O0pl6pAi5KfFf1bs4ggIju0TzyopLD4zwMaxBiUdeZjX5OhYDfYSowVU/zOjUd8k4vkG
         tbExKWhGYRRACXRYN5NmZWi+ts3blnJRuR/bQN4tBizRTQ7jqbUtlqvATAMIbwfFe5DS
         9cLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VZbtzYth1iyB1JmiHi6rjfOXl9Od7ZdhUTqesBSHm68=;
        b=YZEWhYe5ncmKYLhyu/bSCXYEYj54LQ3RhwQ9HGBOpihNYSOgDy+H/AtnFcXqtdBY6G
         btTLWsRY13awGIbOAsX+PRbOS2K6/TELZv3j4pX9/N2FIQvVvUzXwa2Kahjw++rQLhWH
         lzWYyh/+ryYbx1trtbHbGpCCaNetSE5yS4N/7Sp4G0xkZKSeZgweFFeHIszGCZfAQ02n
         g2nSwiwXXgkvPs+nTPzyE26zeayIPANiFaGBTKd0c7ZglsXWFfS8/tgRewzx+DZMsSuo
         /3XrnHNTwTU4/2QdmotM93wOpaTjgSEHxCIM+QjOHjaGPGaw3+eYwAnw5k+pg28C6R3R
         Qlhg==
X-Gm-Message-State: APjAAAV191rM/UutlFrZ/w9/jsxGbBasPjvYrdPO4pnK+bAdsey6YsIu
        0jHIBugtKPfOz9EVEJKV5QkvuJBijtZbxgbFuX8btDTvo47kr2NL7gpwJj4nBA/H5gowSWkGzcR
        0hXMWkoQW7MbekgieTO9jMlY+80f9NHVpBsttPbdEFKQ+hy4nwUNWJ5wBikulLqdE/z1v
X-Google-Smtp-Source: APXvYqwwdMHm3qfkNqirkk6pn96/66jnW7vhapirIV21dNcbQBoCHI1lWCHs3f91CWDhG2yMUy3Zc6vC4nfIjPE7
X-Received: by 2002:ab0:20a6:: with SMTP id y6mr10596750ual.119.1567623402573;
 Wed, 04 Sep 2019 11:56:42 -0700 (PDT)
Date:   Wed,  4 Sep 2019 11:56:39 -0700
Message-Id: <20190904185639.81615-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v2] KVM: SVM: Fix svm_xsaves_supported
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Janakarajan.Natarajan@amd.com, jmattson@google.com,
        vkuznets@redhat.com, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD allows guests to execute XSAVES/XRSTORS if supported by the host.
This is different than Intel as they have an additional control bit that
determines if XSAVES/XRSTORS can be used by the guest. Intel also has
intercept bits that might prevent the guest from intercepting the
instruction as well. AMD has none of that, not even an Intercept
mechanism.  AMD simply allows XSAVES/XRSTORS to be executed by the guest
if also supported by the host.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f220a85514f..b681a89f4f7e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5985,7 +5985,7 @@ static bool svm_mpx_supported(void)
 
 static bool svm_xsaves_supported(void)
 {
-	return false;
+	return boot_cpu_has(X86_FEATURE_XSAVES);
 }
 
 static bool svm_umip_emulated(void)
-- 
2.23.0.187.g17f5b7556c-goog

