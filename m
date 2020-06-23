Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F718205AE2
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 20:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733223AbgFWSeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 14:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733149AbgFWSet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 14:34:49 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7A8C061573;
        Tue, 23 Jun 2020 11:34:49 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g1so17127771edv.6;
        Tue, 23 Jun 2020 11:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n1T35J+HW/tfUciSMhCodCWFYqAaiFCQ5lEz9exQc/o=;
        b=Tz4wtzJyPad5gy/IG2huil3XWoC4trTDH3+djIUF3u7v/4p/SjuUx+r/eYHwG9y8jd
         nk5i/IcG6i09Svx0gslTFU6+uZleU99hIi5QCVx+oSEqkoxfnNJbMcK0xZue9Vo3T6a1
         gxxXhLBXgoXWe23MRaAKzJTnsQKT/IAGiH0lmQZ1O9igePrxYt/j6p17WLpPYMiOfcDY
         NOJGpdKZ9TYjFy8tzG3HPottQ3/h1xyLws2qMfEcLEvfXFnWOTLivm7isJ0zKvhUG+G4
         cLVxTeiheNchYJcjJc5JnHmeJ3IGnuP3bB66TNZutt2n2pnGlcsVEucag+efFl5jFEZB
         oHjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n1T35J+HW/tfUciSMhCodCWFYqAaiFCQ5lEz9exQc/o=;
        b=EB6hDhyEfTiOsw4IbzKENf63EQq1tRE3BR7WGB5AhLad4y1eP3CaBuRrAQUX7Bavim
         aGGCM05Ztdo1WkDPeUoDCoj6Ws/fSV+XAxjmxIkf2Brw6Ark0uGnGbg4Hb259lkImUYJ
         WU4zVupQlkDW1XqtAqe4/bGenz2HCS7M6KWDZdOcCrjL1hkOFsU5r4WAhFP8ZN2Di1Sd
         w30nrPIdKL57NFKwgKsR4nM+GO4soZfONlpcovVB6erFS+YZyvznS4K+oJHDw0CuzVu/
         pCPs6M3a3dMsUkK+82YRPUQHJKj0bfwcIClOIaa+H5DcAdSwCbsnL9c6I/1HMYRGpTMj
         d0HA==
X-Gm-Message-State: AOAM533DepYh5o/vja5dvNgWRv2oft2GhTYX4Q3qiQtslYvojTyCn+7w
        xe4PEGYwV/LaETnsehVpCrytpyv8OOs=
X-Google-Smtp-Source: ABdhPJz4BjlhlNpvHxHxx5ypE7pv9WMsb5v1cQUv3j3XfPneaGq69WI+XsdYygOC7WX+OlWM9d/kEw==
X-Received: by 2002:aa7:c41a:: with SMTP id j26mr23493827edq.13.1592937287680;
        Tue, 23 Jun 2020 11:34:47 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id y26sm15341379edv.91.2020.06.23.11.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 11:34:47 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86: Use VMCALL and VMMCALL mnemonics in kvm_para.h
Date:   Tue, 23 Jun 2020 20:34:39 +0200
Message-Id: <20200623183439.5526-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current minimum required version of binutils is 2.23,
which supports VMCALL and VMMCALL instruction mnemonics.

Replace the byte-wise specification of VMCALL and
VMMCALL with these proper mnemonics.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_para.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 49d3a9edb06f..01317493807e 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -18,7 +18,7 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 #endif /* CONFIG_KVM_GUEST */
 
 #define KVM_HYPERCALL \
-        ALTERNATIVE(".byte 0x0f,0x01,0xc1", ".byte 0x0f,0x01,0xd9", X86_FEATURE_VMMCALL)
+        ALTERNATIVE("vmcall", "vmmcall", X86_FEATURE_VMMCALL)
 
 /* For KVM hypercalls, a three-byte sequence of either the vmcall or the vmmcall
  * instruction.  The hypervisor may replace it with something else but only the
-- 
2.26.2

