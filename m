Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421C12695D5
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 21:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgINTqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 15:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgINTqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 15:46:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45592C06174A;
        Mon, 14 Sep 2020 12:46:07 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t10so923885wrv.1;
        Mon, 14 Sep 2020 12:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3jJ1hxTPLBGWpQI1GCiVmGcN1WbZ3VAIPQQi3dOMAA=;
        b=UbivJ5BEE6YXLEJlzMjHXxuufyt9ap5eEUGMjmAtBaYSe4OozvHIX7V+41ySEW8WtF
         5n3svksvJxMrRJgVt4I3O2rmrSA0M55E32LlVjG9XHGLwK78QjMUyVVZBjeDZxRiuaZL
         RQAFFPsX5SI7CNXW9O2/89D6cXDO1TXWkwOjGBG0VpKvkprRaq/p6PFNYIhZYE6LkmJX
         8RgZDtHY62SpL6rtm4KYNceIqPq/cHLWT23tfhle6j7mD26ayGMxksWEkQm1no/qVTh/
         kPzDBN2xmzu1vnxWC161nUcdgtfX+4yPqD56pawZuJhjAsNN/FULEX0u668G5W801wq9
         A/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3jJ1hxTPLBGWpQI1GCiVmGcN1WbZ3VAIPQQi3dOMAA=;
        b=bOfKzJwIBXQU5D1GAvdj4qAfZfxbcRJ9SQFrPZ/FT9WWJuuJbzubDaR6OraZnn6FA5
         vXbCBC3rXeDCelbdlSC/cUsgrZvOREirWSwFwhGPg7n7KeDcrO2ASSz2eEyoFCxNFTo/
         RDGi447zBFJ8qhVJMIA8ByaySX4bvzfMG4Iwwen3Qu9oVlz8Acqo4TfPvShedq9kaFUa
         Qn8H70tghH2HF9bJ6dQBZEml+utADI3ZPh0mjJFx42JnI7QlypiPGIgjEQxb3GRKISxK
         d4r1Gv+cawrqotQ7matrazMNRdGePzq4CUb3a8dherTn6pq60v8i45YoZcAvaMSpQIpa
         sAHw==
X-Gm-Message-State: AOAM533K71Uq+oa7DsSL2gNogUdgCfFZQJp33MnD/uag1RBAL4qPN5Yj
        sxprDWouvA7gIkjqZgb4pFI=
X-Google-Smtp-Source: ABdhPJyYl1lq1gTyGCizYSQVmMI/1XVEeI9SM1r+ugHKSigZ6mr39a4UpKO38JxJFtBe15jYkAg99g==
X-Received: by 2002:adf:e6c7:: with SMTP id y7mr16500066wrm.147.1600112766022;
        Mon, 14 Sep 2020 12:46:06 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id n11sm22410550wrx.91.2020.09.14.12.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 12:46:05 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] SVM: nSVM: fix resource leak on error path
Date:   Mon, 14 Sep 2020 20:45:57 +0100
Message-Id: <20200914194557.10158-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In svm_set_nested_state(), if nested_svm_vmrun_msrpm() returns false,
then variables save and ctl will leak. Fix this.

Fixes: 772b81bb2f9b ("SVM: nSVM: setup nested msr permission bitmap on nested state load")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 598a769f1961..85f572cbabe4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1148,7 +1148,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_prepare_vmcb_control(svm);
 
 	if (!nested_svm_vmrun_msrpm(svm))
-		return -EINVAL;
+		goto out_free;	/* ret == -EINVAL */
 
 out_set_gif:
 	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
-- 
2.28.0

