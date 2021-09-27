Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A10C41A327
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 00:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbhI0WiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 18:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbhI0WiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 18:38:08 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8501AC061575
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 15:36:30 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id h18-20020ad446f2000000b0037a7b48ba05so79069565qvw.19
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 15:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=awXGcyw9qU3X89D85AKJWKhXIsqx2bBCtPEaNJBsoo8=;
        b=N0TNmAlgGB+1ntXKuel/4ogZtyl3PP3lweKgPBkPCcUP/FFKRibHkGInbke8bTP3Ny
         MCFnLnUL7OS/pVC7d2QdL2wk6QjUIkXwzr1QC4OkKZqWs8+6yAI9dag/q4s4/emEQo7a
         LCrO1gdfV7N/WXOple7JlzAqhlpvNR2wrBv4jtDSFU4SZVknILSc5fSHQGRARehnm4Ac
         /OdSFo3vLSwyAQYSKiDs/kb4udZRqcAj27ob5Iq0YqF6lJNzdTHEExdh+pw54LXXxLYo
         CsfPPbANWqrq86mlFmZLiuFHbQAfL1o70KI+WRI9befNDXOl0dlwCAEtS+LR5i3sHygP
         qVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=awXGcyw9qU3X89D85AKJWKhXIsqx2bBCtPEaNJBsoo8=;
        b=78c/w83VqQpt4RenOvHfP239diqFbFzAgfHG+vOM7Tl/svX3g1Sy7g5WbJvJ2615VT
         32XW2wKpIzKEr4MXeI1Gp5pqxbkf6wbR5vclqCAzxCtiw6/fzyKw2JuJsl13y+VmFL0R
         euqThFi3oUrBOeVaUFwD6zd7wZXsEZ8DnY6138ddglsRUkLVO7dDPrUXcGm2HTZUAafa
         i4G0eaGiyjou+u1/0Vj4y2SEUjruApy1/w5/D9DkS6NkcVY5SNNoNCn3KWZpjYEQ1yPa
         Put4VxWwrKrrAYPkf7fOuv253RPuzRvYXxLgviy+AXOQoscJ7yJ2x6soWLDYQXWUlL2z
         gAYw==
X-Gm-Message-State: AOAM533IZO9DlvZ2gBfNDap6Ba9j4165qBH/kBocXtQPz4/9DL/l03rA
        dQ+Y04Oc1s805SAQ4y1YfyYY/ePn+KnKls9fHFQv+Bn/qjwfY6Iw/Ms6Vj1iJnHT7HkgqcLVK+k
        BCa94nWEb9tigMlHTR6bYpi4tBxAEgMxwj6ET0QPv+jW0q3umZAS/kTUW5w==
X-Google-Smtp-Source: ABdhPJyp164eXQKhIcjjJku39MF2zkW4XXqcpW4YQ0sDZmrb1I0Yx6d3oThgVrHOsnUkRymmkoi5MVeuRLI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:122e:: with SMTP id
 p14mr2407194qvv.37.1632782189677; Mon, 27 Sep 2021 15:36:29 -0700 (PDT)
Date:   Mon, 27 Sep 2021 22:36:21 +0000
Message-Id: <20210927223621.50178-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH] selftests: KVM: Don't clobber XMM register when read
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to clobber a register that is only being read from.
Oops. Drop the XMM register from the clobbers list.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index eba8bd08293e..05e65ca1c30c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -315,7 +315,7 @@ static inline void set_xmm(int n, unsigned long val)
 #define GET_XMM(__xmm)							\
 ({									\
 	unsigned long __val;						\
-	asm volatile("movq %%"#__xmm", %0" : "=r"(__val) : : #__xmm);	\
+	asm volatile("movq %%"#__xmm", %0" : "=r"(__val));		\
 	__val;								\
 })
 
-- 
2.33.0.685.g46640cef36-goog

