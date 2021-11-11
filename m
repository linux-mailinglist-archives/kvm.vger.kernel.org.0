Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E9C44CE0D
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhKKAGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhKKAGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:06 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923BCC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:18 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id jx2-20020a17090b46c200b001a62e9db321so1909455pjb.7
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UZSxYvi0qVP1F++cVUOnkEBRLDYe6xqDOy+3nDoOuSU=;
        b=Nu4Xe1RNrAHjwd8Y9T19r7uxMhVbmeFSDxMLfs+feMXLVSp991YAqWJrGC2Osm4M4q
         ANRopmYWxfUAR6GPOELfEQCgaTy1pZjGTQtfO3OaH1DoOxjxiJZ6elEaediRI3/r70R8
         gIBBhnd+h8uUjkTNVJNdLlisXByH5CNDp7xtOETQrFKtYjImReiNMIJHGYAcfof6UA1G
         Z0QAmF1j0LXrbC6zTd9wmD6HLeGp+8Vrp1HV1nWt+xMjBvJJHMjDU29ErmLnBJd58xZb
         g15/gpSSOnsXrTlj01Mqi12DhCIhtlDCygRHtSZMkh2GETe7q+9WeKE8NaELFK1ymuIu
         NfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UZSxYvi0qVP1F++cVUOnkEBRLDYe6xqDOy+3nDoOuSU=;
        b=Q/sdKNf9yH82CIeUYRwVJCGSU7YMRibCO6EMXbc5ai6w3rENU6+6i+BxUZrH+pX+b5
         8fDT4JjptwCBBKmOAhCNwxEVXoIy1LF+IhcuYBBRYgJbQQABN5DEy1S3lhBlK2mXKdpX
         ScsaqeC2LZelWTcqHeIsqnSdy1kK3a3/SL+IxkzUe0/ukEH/sTIlfyDTb6x6d1FIOboK
         ulGGbigif8+LGb8PUdcVpwfKhBBWezF8LwP3BT/Y0vxKSEwPS5cvBCbbLI5EGnV8C1Yf
         lx0CeENm5pW0WbLXtsFWRFN4mdsONZwPPi0UP/TdxiTUa4Z6CQfoQ1QIj/e/iCtfF/0n
         j7Iw==
X-Gm-Message-State: AOAM532hWbPgbLlyXe6I4LvqavXiCi0K5UoKbcXEk3RzHL/T+eZBYFmq
        k+bmgEC4jMi/ylKzFqY6aHJt1z5gnx8Iuw==
X-Google-Smtp-Source: ABdhPJyzQxB4rxgT/wTBpDIrco6bFSolY9rdi0OTTQ91XYSKRxdfvQS3XXpAi1KKLSjsMnPDwuMMRGb1p+tAwA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1a8e:b0:49f:a4a9:8f1e with SMTP
 id e14-20020a056a001a8e00b0049fa4a98f1emr2860990pfv.67.1636588998080; Wed, 10
 Nov 2021 16:03:18 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:02:59 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 01/12] KVM: selftests: Explicitly state indicies for
 vm_guest_mode_params array
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Explicitly state the indices when populating vm_guest_mode_params to
make it marginally easier to visualize what's going on.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
[Added indices for new guest modes.]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 041004c0fda7..b624c24290dd 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -187,15 +187,15 @@ const char *vm_guest_mode_string(uint32_t i)
 }
 
 const struct vm_guest_mode_params vm_guest_mode_params[] = {
-	{ 52, 48,  0x1000, 12 },
-	{ 52, 48, 0x10000, 16 },
-	{ 48, 48,  0x1000, 12 },
-	{ 48, 48, 0x10000, 16 },
-	{ 40, 48,  0x1000, 12 },
-	{ 40, 48, 0x10000, 16 },
-	{  0,  0,  0x1000, 12 },
-	{ 47, 64,  0x1000, 12 },
-	{ 44, 64,  0x1000, 12 },
+	[VM_MODE_P52V48_4K]	= { 52, 48,  0x1000, 12 },
+	[VM_MODE_P52V48_64K]	= { 52, 48, 0x10000, 16 },
+	[VM_MODE_P48V48_4K]	= { 48, 48,  0x1000, 12 },
+	[VM_MODE_P48V48_64K]	= { 48, 48, 0x10000, 16 },
+	[VM_MODE_P40V48_4K]	= { 40, 48,  0x1000, 12 },
+	[VM_MODE_P40V48_64K]	= { 40, 48, 0x10000, 16 },
+	[VM_MODE_PXXV48_4K]	= {  0,  0,  0x1000, 12 },
+	[VM_MODE_P47V64_4K]	= { 47, 64,  0x1000, 12 },
+	[VM_MODE_P44V64_4K]	= { 44, 64,  0x1000, 12 },
 };
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
-- 
2.34.0.rc1.387.gb447b232ab-goog

