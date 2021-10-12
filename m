Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE34429A18
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbhJLAIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E374DC061570;
        Mon, 11 Oct 2021 17:06:28 -0700 (PDT)
Message-ID: <20211011223610.463067287@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=30YG7qzJGGvYFzVQYDpeQaqJ24jssBdyvBLYMB+8pqE=;
        b=tuFoHc3CvB604KyPYb91G6msQbCntsX7/nKZGfcSk3TbmtEcYMHNvkLl33cxBTca+SkZhU
        YCce9McsVBVGsVVaWxzUElKrLb60jdjigFG/L3bjszALXVF60Rv3Q2mvips6/+/Hk1zqb9
        YJG+uv727y/wnlPrPjirS4itCZ22oDXHUIVPz4D/NLTklsARdOWRlekoyXQ573Nr+QUWmS
        qy7Lz8pYp/6wxYfRgEHAwMIvIto5GiDxJ1bLgDbQiu9eNoUBr7ZUSpzbr+S5DisQafZiRj
        8kN5LnoarjkHaJxNqYvwm7IAfy91zYrVVGmi79LGGGIGa8KLQSvrMUhNR8dZRw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=30YG7qzJGGvYFzVQYDpeQaqJ24jssBdyvBLYMB+8pqE=;
        b=PGDHmx21mQhHnTYI4anE8NXeZGRymNWzg33VgmGjKiYZAanhOWnoEHJBnNgkoCYzmXq6Rx
        O3Eys41Wscfg07AQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 03/31] x86/pkru: Remove useless include
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:02 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKRU code does not need anything from fpu headers. Include cpufeature.h
instead and fixup the resulting fallout in perf.

This is a preparation for FPU changes in order to prevent recursive include
hell.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/events/perf_event.h |    1 +
 arch/x86/include/asm/pkru.h  |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -14,6 +14,7 @@
 
 #include <linux/perf_event.h>
 
+#include <asm/fpu/xstate.h>
 #include <asm/intel_ds.h>
 #include <asm/cpu.h>
 
--- a/arch/x86/include/asm/pkru.h
+++ b/arch/x86/include/asm/pkru.h
@@ -2,7 +2,7 @@
 #ifndef _ASM_X86_PKRU_H
 #define _ASM_X86_PKRU_H
 
-#include <asm/fpu/xstate.h>
+#include <asm/cpufeature.h>
 
 #define PKRU_AD_BIT 0x1
 #define PKRU_WD_BIT 0x2

