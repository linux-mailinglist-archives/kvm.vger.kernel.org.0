Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE74BF212
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 07:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiBVGZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 01:25:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiBVGZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 01:25:46 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF7EF41;
        Mon, 21 Feb 2022 22:25:21 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gf13-20020a17090ac7cd00b001bbfb9d760eso1404778pjb.2;
        Mon, 21 Feb 2022 22:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EXIviZBFa0roKyh42LUJ3zl7p19OISm2ntSverQdUJI=;
        b=GWMk/2qo7wq8+StKOI9p6fdIRRP8rfFC/BKhB9jWPqXp8bR71jZlkdE2UzznR6rdQr
         rRTxKrYaJ7MLoxCGZ3rcSYyG7uX0uhOY8e3PENuO8BogHYsPqX0/8f6JnbWB1T52RJwx
         dg3AVowgFmD0dw4hZoRmuLrRBbgJFPQmkANatWBC8vgN2uDkIKutXWjxRKBMqrGDZa74
         kIC4SiZxpWmvWEIHk0CG9IZvMDIycXwbgSWX27JGm1e9AJU7EBWZ6DQ7jkFz1ziQnlOo
         QpiK16tvPte2Sd0svpxy6g4DoAF/TFLRqLUqm4zTjt/JyATaMFyRnQlV28imTNsoPyXl
         2S/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EXIviZBFa0roKyh42LUJ3zl7p19OISm2ntSverQdUJI=;
        b=wORK75ARWOj956PK+y7UNFLEE7jrV4wHSAego1GBOsFXD/sgciL4lu0ED+qeK68p6X
         //pfsahg0+wbmcNTATFNqIdqS9WcTVi/NAcjs7TQZ2nkHB7SAPiPlDzeAYgndcAVaXSY
         9FFPv7KARoeMHz4TDzED4C+n3dINXiFLvHJRKIfcNi85v77fWhk0gCor3Wy9xUfrlf76
         Nc+WPcC72khcB2pHcOOxhqnNgQD0xWequo7rNRLdtQpWUdmnRW51lvKhhToWwSosslKm
         OupiHM4q1AEBhjc4f9LbQYS200GhQ2hcoNDd7fBTPCT48N5SmxSffltp6THsvSOiReg3
         YvLA==
X-Gm-Message-State: AOAM5303x2uId2hx6RPID9129kn394mAQi0lZjQwAxiouoKCbYzXiOjt
        D0huV625Z3dyxSLQLDBR/mM=
X-Google-Smtp-Source: ABdhPJwgJmJ7+1iUAqCpgtNcr5GpMo9SmxEMZp37UaoNOLP/zctOG14kOsrjhI5bk2SKGg293403uw==
X-Received: by 2002:a17:902:b204:b0:14f:26a7:9f61 with SMTP id t4-20020a170902b20400b0014f26a79f61mr21997285plr.97.1645511120964;
        Mon, 21 Feb 2022 22:25:20 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l17sm15389954pfu.61.2022.02.21.22.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 22:25:20 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH] KVM: x86: Fix function address when kvm_x86_ops.func is NULL
Date:   Tue, 22 Feb 2022 14:25:10 +0800
Message-Id: <20220222062510.48592-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Fix the function address for __static_call_return0() which is used by
static_call_update() when a func in struct kvm_x86_ops is NULL.

Fixes: 5be2226f417d ("KVM: x86: allow defining return-0 static calls")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 713e08f62385..312f5ee19514 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1548,7 +1548,7 @@ static inline void kvm_ops_static_call_update(void)
 #define KVM_X86_OP_OPTIONAL __KVM_X86_OP
 #define KVM_X86_OP_OPTIONAL_RET0(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
-			   (void *) __static_call_return0);
+			   (void *)&__static_call_return0);
 #include <asm/kvm-x86-ops.h>
 #undef __KVM_X86_OP
 }
-- 
2.35.0

