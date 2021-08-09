Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104633E42D0
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 11:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhHIJex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 05:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbhHIJev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 05:34:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9E6C0613CF;
        Mon,  9 Aug 2021 02:34:28 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a8so26909748pjk.4;
        Mon, 09 Aug 2021 02:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SClIEUrgBmGnLAFcX7ZZcCu89jAx05xmV/2QXqeca2c=;
        b=LsyWMjctV2SbgGvZf7etUKKoyebOtcEhXQ/cU3VtoMBK0lMmH011y/DVcKSBEp2ypO
         87na3pOnAJlIK05je08mBAZFZGpWwlgD1ashhiwTk+qOdbiGK5nYeecgiaJYyWbIhDNK
         ULwwYUFWQgiqNJL6YgFyslc0kUpuLdyg+goJh22a98iT28qCmu3YzrojTrx7zw85gY2S
         OPEL0lznH3/qh/r05RpKDc6sn3mP4D/LG05kmPqVaTwDoPy+zzD0cl0Cl4xq5AsKlx8Z
         PT3lq1ENa/C/6iIA4XJx3JEOoBwPxIRCb+m9wPxJDii1yMl+nvwYoSnQVkdgdj1z79ds
         g1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SClIEUrgBmGnLAFcX7ZZcCu89jAx05xmV/2QXqeca2c=;
        b=OqUxnRm5iUyFjTYPxI/FfeG/SdgsxVsA6yK+e5d7ho9262g1xZo2SKseoaKSHUx4zA
         Hmp+4D5hH2LpwGsWBKdG3UVslQAMYERGSvJuvhdkYa3CfIUMGahwMsexNJoXvEbCXjfp
         7xGkRS7MEADNE1O1wdtmCeoiwlQQofakgVu3/33/sulG+G7Y7hYP7riTUS4L0BGZFHRA
         EluzEzmRPCwJkx0FNzotyjMkktH+vRITKGyn7NSVh5W1a7Nbvg1EdCEX/481KQjFtmrF
         whUiDGxkZ+TO+0w0kGnXF2voefev5+xzfig0HvzAN55twOg9iYPN9erMFppLz6ElWV0f
         yRgg==
X-Gm-Message-State: AOAM5302R9Bz4k7u/XjgxGxGGYl/5G4TjDvA30+qgFeLFyrZq5zabtt7
        JoJYnceSLWgBZuW6Od39sHR246ursFgNPw==
X-Google-Smtp-Source: ABdhPJx3owKMpELajEbku0QfVtOuK2luyB/1Wxh2S9w281C87D1YUJVUF+tLaK7wWI0mPEIoNXofgw==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr34827680pjj.165.1628501667764;
        Mon, 09 Aug 2021 02:34:27 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h188sm10839982pfg.45.2021.08.09.02.34.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:34:27 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] KVM: x86: Clean up redundant ROL16(val, n) macro definition
Date:   Mon,  9 Aug 2021 17:34:08 +0800
Message-Id: <20210809093410.59304-4-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809093410.59304-1-likexu@tencent.com>
References: <20210809093410.59304-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The ROL16(val, n) macro is repeatedly defined in several vmcs-related
files, and it has never been used outside the KVM context.

Let's move it to vmcs.h without any intended functional changes.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/evmcs.c  | 1 -
 arch/x86/kvm/vmx/evmcs.h  | 4 ----
 arch/x86/kvm/vmx/vmcs.h   | 2 ++
 arch/x86/kvm/vmx/vmcs12.c | 1 -
 arch/x86/kvm/vmx/vmcs12.h | 4 ----
 5 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 896b2a50b4aa..0dab1b7b529f 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -14,7 +14,6 @@ DEFINE_STATIC_KEY_FALSE(enable_evmcs);
 
 #if IS_ENABLED(CONFIG_HYPERV)
 
-#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
 #define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
 		{EVMCS1_OFFSET(name), clean_field}
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 2ec9b46f0d0c..152ab0aa82cf 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -73,8 +73,6 @@ struct evmcs_field {
 extern const struct evmcs_field vmcs_field_to_evmcs_1[];
 extern const unsigned int nr_evmcs_1_fields;
 
-#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
-
 static __always_inline int get_evmcs_offset(unsigned long field,
 					    u16 *clean_field)
 {
@@ -95,8 +93,6 @@ static __always_inline int get_evmcs_offset(unsigned long field,
 	return evmcs_field->offset;
 }
 
-#undef ROL16
-
 static inline void evmcs_write64(unsigned long field, u64 value)
 {
 	u16 clean_field;
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 4b9957e2bf5b..6e5de2e2b0da 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -11,6 +11,8 @@
 
 #include "capabilities.h"
 
+#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
+
 struct vmcs_hdr {
 	u32 revision_id:31;
 	u32 shadow_vmcs:1;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index d9f5d7c56ae3..cab6ba7a5005 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -2,7 +2,6 @@
 
 #include "vmcs12.h"
 
-#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
 #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
 #define FIELD(number, name)	[ROL16(number, 6)] = VMCS12_OFFSET(name)
 #define FIELD64(number, name)						\
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 5e0e1b39f495..2a45f026ee11 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -364,8 +364,6 @@ static inline void vmx_check_vmcs12_offsets(void)
 extern const unsigned short vmcs_field_to_offset_table[];
 extern const unsigned int nr_vmcs12_fields;
 
-#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
-
 static inline short vmcs_field_to_offset(unsigned long field)
 {
 	unsigned short offset;
@@ -385,8 +383,6 @@ static inline short vmcs_field_to_offset(unsigned long field)
 	return offset;
 }
 
-#undef ROL16
-
 static inline u64 vmcs12_read_any(struct vmcs12 *vmcs12, unsigned long field,
 				  u16 offset)
 {
-- 
2.32.0

