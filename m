Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A724518D5C4
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCTR2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:28:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42499 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgCTR2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 13:28:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id v11so8473082wrm.9;
        Fri, 20 Mar 2020 10:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qORovMW4qFXFXcdoIljFzjQs+83nq3xI2+7AeVXu0Jo=;
        b=k8BJZ4XIzMUsdagDL0oFf2+WVUil6hLei1zA5A8UsReL31QvYybLJA3oP2gIlhD9b4
         A1WHbLZbmJ02lpfpLj2rRRx19teXV/8qMfVkG5XDWYCOYbiYGY/WcxPrXhi3Mj6Egak2
         EJpB8Vl7TEdh75LIgRVMdbPF/UdhGzcUzVmIAerMNuwegLdN+uvz+J0T4VyzRorPOnyu
         ICUMnVmc1XcOeLiCG4FTYcGifqv09UtveNFKA0HLjxoNs2WyBmyU1lK4kGr5vjteKtTe
         TjFJtY7ESlqxoJCirbrOGlAGsirbt/Ms9HuBHunZg2oSv4wFsyitmgkf5C1ilCTduHiv
         7kAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qORovMW4qFXFXcdoIljFzjQs+83nq3xI2+7AeVXu0Jo=;
        b=SdJe7WJF9LR13w5j2cGxD8pvqTygmX1DQOwnn47F1W9+0qAeRE9YfNkevUbXbLC6QP
         EcL8w6pWxVRlzczeHDauq/aK8mXSplRIeHOJHiMNMYOl1RjAa9G6eSi8MuiZbTq9/c0V
         ZRTepfSIQDpAsCEbg5hpf0ZHGwNL6vDIZmC51sNjVKq8PCHoqXGfCz3H3GLoqyqJOWl8
         KcJOpwYy3zq9EUq2gVHqprWZhPYPiTFX7iF5vw/1/VbQUa3wvETav2UxzHCLgexzvPoP
         0YjliNzTrGOlT8jTiKi9FO69E+OBJ++rA68TZ09YBdWI2VJo/cBVNpvtNb6BC2AU0qdH
         wH3Q==
X-Gm-Message-State: ANhLgQ183uxXiRylsQZ6TL1EY8Me0CoLdBSLGEjakGp32tKOAJpu+Czu
        bKKsojL4l/tkVYrqBcbkgv9mZl5JATE=
X-Google-Smtp-Source: ADFU+vtaj++CrMMhqZXo7hw9Nyt36fJSsYzaZNL6R8wlkUfeeJDDTJl7vl16D+1AoJDsCn6dr/sjzg==
X-Received: by 2002:adf:cd04:: with SMTP id w4mr12707952wrm.280.1584725329242;
        Fri, 20 Mar 2020 10:28:49 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id q4sm11028333wmj.1.2020.03.20.10.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 10:28:48 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v9 1/6] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Fri, 20 Mar 2020 19:28:34 +0200
Message-Id: <20200320172839.1144395-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320172839.1144395-1-arilou@gmail.com>
References: <20200320172839.1144395-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The problem the patch is trying to address is the fact that 'struct
kvm_hyperv_exit' has different layout on when compiling in 32 and 64 bit
modes.

In 64-bit mode the default alignment boundary is 64 bits thus
forcing extra gaps after 'type' and 'msr' but in 32-bit mode the
boundary is at 32 bits thus no extra gaps.

This is an issue as even when the kernel is 64 bit, the userspace using
the interface can be both 32 and 64 bit but the same 32 bit userspace has
to work with 32 bit kernel.

The issue is fixed by forcing the 64 bit layout, this leads to ABI
change for 32 bit builds and while we are obviously breaking '32 bit
userspace with 32 bit kernel' case, we're fixing the '32 bit userspace
with 64 bit kernel' one.

As the interface has no (known) users and 32 bit KVM is rather baroque
nowadays, this seems like a reasonable decision.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 ++
 include/uapi/linux/kvm.h       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ebd383fba939..4872c47bbcff 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5025,9 +5025,11 @@ EOI was received.
   #define KVM_EXIT_HYPERV_SYNIC          1
   #define KVM_EXIT_HYPERV_HCALL          2
 			__u32 type;
+			__u32 pad1;
 			union {
 				struct {
 					__u32 msr;
+					__u32 pad2;
 					__u64 control;
 					__u64 evt_page;
 					__u64 msg_page;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..7ee0ddc4c457 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -189,9 +189,11 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
 	__u32 type;
+	__u32 pad1;
 	union {
 		struct {
 			__u32 msr;
+			__u32 pad2;
 			__u64 control;
 			__u64 evt_page;
 			__u64 msg_page;
-- 
2.24.1

