Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A3D49B14B
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239788AbiAYKEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238553AbiAYJ7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:54 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C12C061759;
        Tue, 25 Jan 2022 01:59:54 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id h23so17807615pgk.11;
        Tue, 25 Jan 2022 01:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CubPfo8X6E6cLCRQ+9YQFpgd03CzrlDLAlSclXyiqwM=;
        b=TYu2hzxhyUdjSdW4KzB0PgKW9Qz71gcHjEYoVWvjdSBfpPlHxw+0PXC3VLvLMHIFK2
         a/j+0xzi533KhtP5gZ2w+vyWVf6354B3agubc74M5PlKNK4Tobp0/tSCK303cMHbLMfn
         shESi3Aq3g/9NY8RhCzvqHCcQTB7DK6JdosachSbNEr/s/XSoYUSuwOW4h7tO9sFwijT
         nvO8sYjQa1brA8xJLIc8dHlMo/mTdGLOASpxM0LUA0r4ctZPplYRzQXhUC+gkClZrlRD
         XgRtg2S94K6Oww8Ks5nj434KY4EsDg7N+BpWEutSU/Q8ICBZePIVh97sPlevCORJhh5J
         Z0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CubPfo8X6E6cLCRQ+9YQFpgd03CzrlDLAlSclXyiqwM=;
        b=BVfCIhqgRncsrU11mybbMqQdHKF5Gk1GZPCZziRT1bJbShnddOZE67V6LOKbMelCbV
         SZsyaTi/TT/wnJa/l6mjW27QUFWPHzRb386pg69JbFsURbrDGPgTbbJrVl0l9JMRQ4vD
         klOkDBB0qautA5CTRTDqiMr1OXjL/UHK57vEpVaqqd0whwH1etAz9xMb5+DKxq9mQozH
         odl5bGYTMvYyEdcjVQrhbbJN2YIQrooNh1qqQ4w3DdHyBM+y6zK7j30cAXb8FfOJxuzU
         tjsQUlE+5OlT/kFyEfryhvHz1sX4zjj5ABpNZKJDcKNcLuLCmO/JRGaP0goFzXph7b1F
         h3nQ==
X-Gm-Message-State: AOAM531c9/hzQFl1+08UYqEv/SA2QwtNGgn1ZZ7QQ2JMmDkN5Nvy2Bw4
        QO21d1ZNPsfAzKZL8FuCjUs=
X-Google-Smtp-Source: ABdhPJz9mzW3DR7bpfB4++1k/wQOade45pfCyNWq75tTufotEG/+KFC05x9/DGi+H0VIlfK+eR8Eaw==
X-Received: by 2002:a05:6a00:15ce:b0:4ca:5090:dbe6 with SMTP id o14-20020a056a0015ce00b004ca5090dbe6mr4828275pfu.84.1643104793842;
        Tue, 25 Jan 2022 01:59:53 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:53 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] KVM: x86/emulate: Remove unused "ctxt" of task_switch_{16, 32}()
Date:   Tue, 25 Jan 2022 17:59:05 +0800
Message-Id: <20220125095909.38122-16-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct x86_emulate_ctxt *ctxt" parameter of task_switch_{16, 32}()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/emulate.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c2d9fe6449c2..9e4a00d04532 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3020,8 +3020,7 @@ static int load_state_from_tss16(struct x86_emulate_ctxt *ctxt,
 	return X86EMUL_CONTINUE;
 }
 
-static int task_switch_16(struct x86_emulate_ctxt *ctxt,
-			  u16 tss_selector, u16 old_tss_sel,
+static int task_switch_16(struct x86_emulate_ctxt *ctxt, u16 old_tss_sel,
 			  ulong old_tss_base, struct desc_struct *new_desc)
 {
 	struct tss_segment_16 tss_seg;
@@ -3159,8 +3158,7 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
 	return ret;
 }
 
-static int task_switch_32(struct x86_emulate_ctxt *ctxt,
-			  u16 tss_selector, u16 old_tss_sel,
+static int task_switch_32(struct x86_emulate_ctxt *ctxt, u16 old_tss_sel,
 			  ulong old_tss_base, struct desc_struct *new_desc)
 {
 	struct tss_segment_32 tss_seg;
@@ -3268,10 +3266,9 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
 		old_tss_sel = 0xffff;
 
 	if (next_tss_desc.type & 8)
-		ret = task_switch_32(ctxt, tss_selector, old_tss_sel,
-				     old_tss_base, &next_tss_desc);
+		ret = task_switch_32(ctxt, old_tss_sel, old_tss_base, &next_tss_desc);
 	else
-		ret = task_switch_16(ctxt, tss_selector, old_tss_sel,
+		ret = task_switch_16(ctxt, old_tss_sel,
 				     old_tss_base, &next_tss_desc);
 	if (ret != X86EMUL_CONTINUE)
 		return ret;
-- 
2.33.1

