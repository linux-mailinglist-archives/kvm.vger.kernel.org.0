Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EEF699D93
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 21:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBPUW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 15:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBPUW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 15:22:57 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43CA241E8
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:22:56 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id q6-20020a656246000000b004fc1c14c9daso827321pgv.23
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCcncjl9vBVTEjELfag9S1oLRHyPwIXh9OBkmmp9fyQ=;
        b=NTpw1IWK3yxfTwGuflws4m5YpI8z8UgmraB7YS1w/S3ByOhCFacaKx7rycLIedDkCn
         jJUHfxI3ogukVrFzv/nYaeBLtbKVDtyHlsfZmhX1EjbJZut+AbB4u1qMweHYauWd3FiB
         jptZBQsHE5XmbvRFBawO9ymKexULzaGA4+zGWMmM5XiMuqMu08n3kCGlociec9zueD5e
         n0YMjDPMCINMWK/CU3c9sxnop9ActkMTr8nIypll3yp9JGWRwdYNCq/CnmGL41wLnkwn
         uCQivV48xRDy0XYjNZwOOrzU3QYfg+iHNfMGK8xR6iu/h2bmUy0twRglIkpI3AgKfu8O
         06mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCcncjl9vBVTEjELfag9S1oLRHyPwIXh9OBkmmp9fyQ=;
        b=yB/1zwqFHLhLLxvtD1djxqVCS0xXiVFD+MFmx2AXVeGub0MNDZSx9ZQ+ihSsERzPsr
         pqYzDHSuyBCBEC+xZ6ethC+UVZnICbGgx61kdfmW/2HkiJOGS0MdQ0xZemlWqy08PdHU
         kYOaTbFnm8hERGGDivCZasshP8rSO8BW908sHfWzoj5a/Epge3SLl93kz4yhnnC8uP/J
         IFnzyYNNd83EYlcPqDNy06KWnufZVsl+QsVeKeW0X1e+RInXjpuwWhMa7yFgYRG5y1gq
         moaQQNYu072ik0cNdm2X8aVG/ZhgY1LsDfBAatEUZH69yVJH8NNT9eCpWObFvMBR7ARy
         O25g==
X-Gm-Message-State: AO0yUKUI40T7IoHybMN8vwwi7M8BVcnXm/LcIIa6+S77FdooyfZocRos
        l82PgaP7qH2flGPMW/ERtHHSSCDr+VQ=
X-Google-Smtp-Source: AK7set/C3eyoe44sPAK5448q8AkTUZPYBdSEOdPc/EdG3pQncPT5DGKzeV84EYJMZ2sfGXKPDmrwVbH11QQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:755d:0:b0:4fc:8b10:870 with SMTP id
 f29-20020a63755d000000b004fc8b100870mr35550pgn.5.1676578976283; Thu, 16 Feb
 2023 12:22:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 16 Feb 2023 12:22:54 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216202254.671772-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Assert that the emulator doesn't load CS with
 garbage in !RM
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yell loudly if KVM attempts to load CS outside of Real Mode without an
accompanying control transfer type, i.e. on X86_TRANSFER_NONE.  KVM uses
X86_TRANSFER_NONE when emulating IRET and exceptions/interrupts for Real
Mode, but IRET emulation for Protected Mode is non-existent.  WARN instead
of trying to pass in a less-wrong type, e.g. X86_TRANSFER_RET, as
emulating IRET goes even beyond emulating FAR RET (which KVM also doesn't
fully support).

Reported-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index baf97c56aefa..07e5f473f6fe 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1640,6 +1640,14 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 			goto exception;
 		break;
 	case VCPU_SREG_CS:
+		/*
+		 * KVM uses "none" when loading CS as part of emulating Real
+		 * Mode exceptions and IRET (handled above).  In all other
+		 * cases, loading CS without a control transfer is a KVM bug.
+		 */
+		if (WARN_ON_ONCE(transfer == X86_TRANSFER_NONE))
+			goto exception;
+
 		if (!(seg_desc.type & 8))
 			goto exception;
 

base-commit: 62ef199250cd46fb66fe98267137b7f64e0b41b4
-- 
2.39.2.637.g21b0678d19-goog

