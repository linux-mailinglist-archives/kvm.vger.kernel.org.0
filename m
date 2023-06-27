Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3575073FB62
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjF0Lvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjF0Lvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:51:36 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56538120
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:35 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b698371937so44265701fa.3
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687866693; x=1690458693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqGKfDWguJ/wQ1MgcOKBra/Rp1I0sbXrog+W6VzRYIk=;
        b=ewP/4+l1QLLin+KK4AdIpG6bDe13BPYlhXal/v/3ycYZcBW61sbUWbK85IvzFqoKWq
         taSeDcJpBYtghpfLdfEoAXcv+EI3epbC/jcMtzm19+bZ5TGMitS4MrDYVCY4T+SQvvwg
         krtsS2xOqMCc5FagWxKD2GAFDfSG5WSMWZtZkhtkWbNKSSh0qNt1XHRFiskR3ixRupXW
         5D6SGbX/c+qD+5Ied4g3hsI0hqfWWsq4XyMgPeJQQW8nLSwbUS5PpZ799Gvymqq25yQR
         G2/Jeqkuk4ZJ0l3k+RcQCJjYqxjZp7QZZ2jnu3EKwZlfPMjivKmZrvBy2uemvS9Tz+L0
         aM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687866693; x=1690458693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqGKfDWguJ/wQ1MgcOKBra/Rp1I0sbXrog+W6VzRYIk=;
        b=NkQnmyY0U2qL1JIrN/bJOPoNa8B+ebEDcISsbeDxkuGQes5+dkgXLafvAWazHJ42X/
         NKoQ4rrNny/axnlwxXXWbze8pfqCAcBSWrXbla+5X4z4Z3n2fTVQ+ox6QVs+to5e6+RS
         vatLyXi9CAzDRZlApT3tztHjVVAPbcJU1S4g+nqT8GB0zm8Z5a4jKr9eFurPHT5bWoYI
         P2PK9/cqe5zScxoqFcP83vSnofuKPkc/V0d09R4QA64D3j6/ZUV56qG4qmrGGoMV8WTe
         HHGc3R7sCE9nGpY4ItfPdYjwUZ2E7bWyBbrQeTXn9A0uXMvfoyTyG6WJEyryRVpyVZP2
         wYAg==
X-Gm-Message-State: AC+VfDwmu8u4L+OgFdF1g+iFrsGQrMYkRqSX/buVDk/btCOoLGR1hEye
        3dcJh+IxXV2FYMjrL3p9RJdA0Q==
X-Google-Smtp-Source: ACHHUZ4G6BPvWH8r1ThUzkk54gczIHvhE6zDhvt40IrOFYOLgRAQlYtaiLny9tyUaBy38s2P0CdE+g==
X-Received: by 2002:a2e:2408:0:b0:2b5:89db:187 with SMTP id k8-20020a2e2408000000b002b589db0187mr12374664ljk.42.1687866693587;
        Tue, 27 Jun 2023 04:51:33 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id v20-20020aa7dbd4000000b00514a5f7a145sm3701188edt.37.2023.06.27.04.51.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Jun 2023 04:51:33 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v3 1/6] target/ppc: Have 'kvm_ppc.h' include 'sysemu/kvm.h'
Date:   Tue, 27 Jun 2023 13:51:19 +0200
Message-Id: <20230627115124.19632-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230627115124.19632-1-philmd@linaro.org>
References: <20230627115124.19632-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"kvm_ppc.h" declares:

  int kvm_handle_nmi(PowerPCCPU *cpu, struct kvm_run *run);

'struct kvm_run' is declared in "sysemu/kvm.h", include it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm_ppc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 611debc3ce..2e395416f0 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -9,6 +9,7 @@
 #ifndef KVM_PPC_H
 #define KVM_PPC_H
 
+#include "sysemu/kvm.h"
 #include "exec/hwaddr.h"
 #include "cpu.h"
 
-- 
2.38.1

