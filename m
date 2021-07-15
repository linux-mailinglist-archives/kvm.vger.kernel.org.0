Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8628E3C9D09
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 12:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241594AbhGOKsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 06:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhGOKsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 06:48:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AA8C06175F;
        Thu, 15 Jul 2021 03:45:16 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id me13-20020a17090b17cdb0290173bac8b9c9so5913955pjb.3;
        Thu, 15 Jul 2021 03:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IHBjkWgqS/NOdM7d9Jyx0y5kUtcIn0jIJPI+JSBGKAE=;
        b=rJNcvfxjnwtlwcC9UEJcg6LDpoLcuMLdztJerSbCVAeqHTiE+kG5tlKWkMInUTH2O9
         jumVZu0ljDnnKh1Vn3dIW8q4TgD0ClmOcGOVmQBILDmulaSnK+M5vRGhOBY0D6rRRihI
         O4Es3+Q1VPYnEEpS5hkkyPmypJ1KnFkZjxU3DOYPJoS0zlOeiChN0iq+crFmD3ZzvSy0
         nHe4JyEfrYYydh0s3DIGB/+Nmap3aK8zGfWgv1vdPRbDnTdMT5UW3qEnXihuFeWCbOES
         w8TdqsJ9x5QmJzDe7LmhS3HaE5rGUnkvqVpgS8RcIS5gOYs5Jwe6XyN5kRgA1zt7QOJ6
         e9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IHBjkWgqS/NOdM7d9Jyx0y5kUtcIn0jIJPI+JSBGKAE=;
        b=KAUN/J8/qszK5g5cVpQ3L3Ug5zDmYm/JDNLN8LX7bR7xuPVCYGrMpVyjC53AEx5Vap
         1rAYboQfZhYXR+Xi1ElrJWpIdn+9ck/6++YDQQQIOsJA3lBAkZGNmr3lrD8oYms/Q7Bg
         JlQnREEWC0mSHWHQvKiwPL/z1pUOU4jz7z0RLrpHcwCqnhTkkS8Iuub25OdWsXcrn/rA
         puMFIT3gW13QpE6rrsfLmZPk7Y6jsFnMUunovF7/cmV8mzzj70xUO9rBEZhYnACRKurB
         ngniWpNNWHeTpDgJyUK+aQU02lA5SOdLMdbM3skDB5DsDXjJ1B248RpV/7cBVzsf+2Gw
         Aotg==
X-Gm-Message-State: AOAM531a3Z7KWv5RuXHsphG2qRJTVtEzIORahJBpdQa8v9KkYaEn87nf
        A5Vu+7cqiifBT3tXiIHQ3hE=
X-Google-Smtp-Source: ABdhPJztWtQgx3wKN8L+Bpy2CdMFj40VEP2AkLDCRuLvPAR9WGstnpFlEcctcGW8gIPXwoSOoMg4dQ==
X-Received: by 2002:a17:90a:b795:: with SMTP id m21mr3624401pjr.143.1626345915877;
        Thu, 15 Jul 2021 03:45:15 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f4sm6704452pgs.3.2021.07.15.03.45.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jul 2021 03:45:15 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86/cpuid: Expose the true number of available ASIDs
Date:   Thu, 15 Jul 2021 18:45:05 +0800
Message-Id: <20210715104505.96220-1-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The original fixed number "8" was first introduced 11 years ago. Time has
passed and now let KVM report the true number of address space identifiers
(ASIDs) that are supported by the processor returned in Fn8000_000A_EBX.

It helps user-space to make better decisions about guest values.

Fixes: c2c63a493924 ("KVM: SVM: Report emulated SVM features to userspace")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 739be5da3bca..133827704fd3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -967,8 +967,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			break;
 		}
 		entry->eax = 1; /* SVM revision 1 */
-		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
-				   ASID emulation to nested SVM */
+		/*
+		 * Let's support at least 8 ASIDs in case we
+		 * add proper ASID emulation to nested SVM.
+		 */
+		entry->ebx = max_t(unsigned int, 8, entry->ebx);
 		entry->ecx = 0; /* Reserved */
 		cpuid_entry_override(entry, CPUID_8000_000A_EDX);
 		break;
-- 
2.32.0

