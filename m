Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F89EA51E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 22:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfJ3VEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 17:04:43 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:53174 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfJ3VEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 17:04:43 -0400
Received: by mail-pl1-f202.google.com with SMTP id g4so1180108plj.19
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 14:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lhVsM4FQB61bpLTEu+wM1raoKVMWWZdSz94pZzLGKoc=;
        b=YKOji3VtEg9GP4M9W1hLFkEHzud1IjevHtTgkkJb/AF8GltzeAdn8mWyLPrGRQUDnJ
         U1kVxLt9mOaAOSF56zDNfB47cj1PdtiXstQ/hcWILuYcG5qbAZao7O3KHOR+a2okvSnM
         JOaj1hdMepa+pzkpLtRgIji7IjdrsHxxVE7Dw2RoLzRiI5uB5t0Oh820oMiTNWj5hMcf
         8LKQVDd00M0g9y+1xAzlvmuhnP14tWAvbKxC19x2NDjdG4D68snzJNQCAOYI9ACdZxN6
         zD6fOcxV4u/fVvjmcGM9MwJggaVFNY6ye8AnzMj1kHt0bNmkTjq5Y7djC6WDs86IhjOs
         jUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lhVsM4FQB61bpLTEu+wM1raoKVMWWZdSz94pZzLGKoc=;
        b=rqLthGREVDWaG+Y8RInKrTAA8Mxfxw8lj8eHoXqjIEYxHep98weZtpsEbdoNs+068C
         dKCrI0ghPAbCNeJofY1awc6XlpXFqUZmuyJAh8w/Tug4oOh8/rexBRPKkxRS7oVeveQx
         3cyEbWTOP5DJ31t0mTZ4x68q/H2Rl5i7f3JeU7KXXsJmPmGnXAg6MuIHRUhNlewRqo14
         Oz7NHMDKHS7oJxKojDatTZQzhVaYQadAYq+yYPDg9lPCt96N3QkxF9bbJbO63OnKRdPn
         2c/7atbbtl/0l8FbG7T51S952xaAfTgmyHlkrlXCjtrC1CDcuEpXOkxDPK8s8ccrWSRz
         vTCA==
X-Gm-Message-State: APjAAAUsVdW2Hz5pICc4505y5QHzSGK7XxzpPySfEf7jEcn8JgA7DhHn
        jKSxweEJY4BOwAPDhuzSPLbPix2uk/gLdVYcKIj/ioHkVoGl3m7yQkFFQbRuDxHrRij6Casw9SI
        7G9zVgHrh6UFudHwV/+t/eJjXlPekxfFjIxRHACPzSWWX2N+mHaCyRg==
X-Google-Smtp-Source: APXvYqwJ4A+cwb37fiyKOWBi6v/anubjM6fhdkdMJyrSm+NE1glPYlPeupMFqsLwX1YPK0B8/iJdtKJf2A==
X-Received: by 2002:a63:6744:: with SMTP id b65mr1593294pgc.13.1572469482038;
 Wed, 30 Oct 2019 14:04:42 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:04:19 -0700
In-Reply-To: <20191030210419.213407-1-morbo@google.com>
Message-Id: <20191030210419.213407-7-morbo@google.com>
Mime-Version: 1.0
References: <20191015000411.59740-1-morbo@google.com> <20191030210419.213407-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v3 6/6] x86: use inline asm to retrieve stack pointer
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to GCC's documentation, the only supported use for specifying
registers for local variables is "to specify registers for input and
output operands when calling Extended asm." Using it as a shortcut to
get the value in a register isn't guaranteed to work, and clang
complains that the variable is uninitialized.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/vmx_tests.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4aebc3f..565b69b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2138,7 +2138,9 @@ static void into_guest_main(void)
 		.offset = (uintptr_t)&&into,
 		.selector = KERNEL_CS32,
 	};
-	register uintptr_t rsp asm("rsp");
+	uintptr_t rsp;
+
+	asm volatile ("mov %%rsp, %0" : "=r"(rsp));
 
 	if (fp.offset != (uintptr_t)&&into) {
 		printf("Code address too high.\n");
@@ -3221,7 +3223,9 @@ static void try_compat_invvpid(void *unused)
 		.offset = (uintptr_t)&&invvpid,
 		.selector = KERNEL_CS32,
 	};
-	register uintptr_t rsp asm("rsp");
+	uintptr_t rsp;
+
+	asm volatile ("mov %%rsp, %0" : "=r"(rsp));
 
 	TEST_ASSERT_MSG(fp.offset == (uintptr_t)&&invvpid,
 			"Code address too high.");
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

