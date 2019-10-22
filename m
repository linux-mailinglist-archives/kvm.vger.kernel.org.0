Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D3AE0DD0
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 23:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733123AbfJVVd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 17:33:59 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:33905 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731588AbfJVVd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 17:33:58 -0400
Received: by mail-pf1-f202.google.com with SMTP id a1so14392480pfn.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 14:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=maN1OI3C8rGLXYdMk46F5meV/56/Uajs3NmMIo+9ziM=;
        b=oyIA2iT4jfp/E8ooWHHMvhhM6WbvbYalsKEiLc0XOXOoDEd+zOX7I+H0K2MEqy+YEx
         X4lJemc+Ng0cG5WVp9oFRweqD3HLX3vLAPu/1jtZ/OS+o5L1qkz5yyomvwi4HNBl7/Od
         XjGAb6c2B7eu0q1xLgY95xb0XpiG0+IkaLMxvziLyxByvjEfbah28+hUlru933B2G/oe
         m0nOCvqrkx1pIY+cl6UAyh5mqlAMcI+YEyEJj8klk2t+GqJSGobZ+1CMnU0+Nme0+v5U
         LWv7qygmH59Bfbu4I9/8m/Znlh4nY82S1wG1dhH2NP2jzCyyPIw7+sqKypcniETYzfLg
         OsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=maN1OI3C8rGLXYdMk46F5meV/56/Uajs3NmMIo+9ziM=;
        b=FibtRO8DTRDTPMoB3TGgqf3NaT+ARlc6n5bB8lmGnxgAA8NrX74u7ytgWEAt5to8Hq
         OjllCUh/9X6UEGPBx05xDcs41zqV5AKFtc/AFSVEvUvW7vbIxc2imb9CYqaGm2/b3qtc
         mxrRX0Qe4+2S5qMq/TEmKGQt+NoANetOOZ6kGAJ2GfpFKOR7RSrWY5CHXZLmQJonamWn
         u7nA07wySbBxKp4Pi8K6MzQGrvU2doa/WmLFE0NGFAZnK2iozTDHhbwOZozQjHcuGwB1
         azR53yIFFkSU2CkA0tvfZhMJeuOtakcqDUEoB9taMNnSUGtmd/N2RUqemEfpHoyQWyAI
         ROHg==
X-Gm-Message-State: APjAAAVFUW3AhPfGHxNckFS51Mczfmn/sxnGK3jBoqI/+Ub0GIL+2Ixz
        xEovko3HIn5eR+LG8g6sUffZmSmotZgIFLKhJLCMqzUeEKiNNpsCtMOH8C4uw7VINfFW87/8l4A
        q8bQDecEcAqjNVchf5Kf0leKYqRuthIqVIEsrQlQ2c8p/pNRsplVSAuBhX97Hyqo=
X-Google-Smtp-Source: APXvYqwpjchncx6hw+AHJpzPqGA9YF6OKMed2JbxzqV1MY//zXCXLpayE53iKxm98PU2+i8Y+R/+qCF1RTALjA==
X-Received: by 2002:a63:ae02:: with SMTP id q2mr6196324pgf.210.1571780037817;
 Tue, 22 Oct 2019 14:33:57 -0700 (PDT)
Date:   Tue, 22 Oct 2019 14:33:49 -0700
Message-Id: <20191022213349.54734-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH] kvm: cpuid: Expose leaves 0x80000005 and 0x80000006 to the guest
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Leaf 0x80000005 is "L1 Cache and TLB Information." Leaf 0x80000006 is
"L2 Cache and TLB and L3 Cache Information." Include these leaves in
the array returned by KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9c5029cf6f3f..1b40d8277b84 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -730,6 +730,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
 		cpuid_mask(&entry->ecx, CPUID_8000_0001_ECX);
 		break;
+	case 0x80000005:
+	case 0x80000006:
+		break;
 	case 0x80000007: /* Advanced power management */
 		/* invariant TSC is CPUID.80000007H:EDX[8] */
 		entry->edx &= (1 << 8);
-- 
2.23.0.866.gb869b98d4c-goog

