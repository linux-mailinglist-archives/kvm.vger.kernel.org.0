Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486B52EA8F
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 04:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfE3CRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 22:17:38 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38099 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfE3CRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 22:17:37 -0400
Received: by mail-pl1-f194.google.com with SMTP id f97so1875092plb.5;
        Wed, 29 May 2019 19:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mG0K6Xuhbuw0UAFGEVQxLHL2UiAfokWdja5pAOSTcpg=;
        b=VqyPuC7zMupYS4v6p61jz9KDynbRRTkVHwNJiFGnK/Hc22x1CqCZFSBb4M8e4XEiBt
         KoKy2RQjLyOHhPnY3OXbAVGPfxFbwkqtCh4JBY7mtAlNBqojoAlX6RXSyk6iY15BLOaD
         JPObD4AEb/7tGgGSGhvu3XQvOWVcaP8HMuuq4bRdnW2jpYkY+sQrjSux25khGi65v9Sl
         a1K2GuBVQ9unJLDNF/Y3dGrG1982wtYqXqWxS10gUJSf6dbho2UK7+xofFDXvrsrUo2k
         tFuob60BGNXXGDKJaTTWA4aZUI+CkyqNBlFbK7TXQKlwvn7OzuR/A76hPioKWoIb8Wf2
         wx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mG0K6Xuhbuw0UAFGEVQxLHL2UiAfokWdja5pAOSTcpg=;
        b=T3QHkmNhwrkGJ8Eqc8lnMFGiIXxIQSvrqhyTCvJUEFAE7vmYiQdbpdK4vjjLIH5V1v
         7N6p19Wde8r8RVyjfIJt25jvvmZFn9yAq9tNUpUYLl6+EC+B9bCs5rlvm0cnk9/x2byD
         qboHITxaeAEvIHPUnA0afNdr08yETDNhImxtoCVklLSU3TdoXPfZrEt5zoOwlMwbAPya
         Fy15ZCboWm6/rlFxPbHj+w3c7Zy0E3U/Q9OOxSMHMh1HiTWqX8QCUQT38xHY7CClChr1
         FTPPb4le64q3uYidoRx+7oXwTMfZ9gSeYR7I7IJuRjLhFzRenXyf8U+FVhHXfedeqZ4P
         adXw==
X-Gm-Message-State: APjAAAVkJIUZFGj6ocrPnszdBgXWXicQxEtq4PBcsVG1oWDImts0MKN6
        QfKD/jT6N2B4zbzyCDjdmtSMOZHD
X-Google-Smtp-Source: APXvYqzmsXAqAKLi9iA7Pw+2glcjWOhnjwCr303RsKvFP3aZAWFx95j+iUfQWeD6hFlFPajWOTLlDw==
X-Received: by 2002:a17:902:a81:: with SMTP id 1mr1257428plp.287.1559182657101;
        Wed, 29 May 2019 19:17:37 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id x17sm584766pgh.47.2019.05.29.19.17.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 19:17:36 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Restore SPRG3 in kvmhv_p9_guest_entry()
Date:   Thu, 30 May 2019 12:17:18 +1000
Message-Id: <20190530021718.22584-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sprgs are a set of 4 general purpose sprs provided for software use.
SPRG3 is special in that it can also be read from userspace. Thus it is
used on linux to store the cpu and numa id of the process to speed up
syscall access to this information.

This register is overwritten with the guest value on kvm guest entry,
and so needs to be restored on exit again. Thus restore the value on
the guest exit path in kvmhv_p9_guest_entry().

Fixes: 95a6432ce9038 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ecbf66b3d2a4..4fdd7a7fe6a7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3677,6 +3677,7 @@ out:		kfree(hvregs);
 	vc->in_guest = 0;
 
 	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
 
-- 
2.13.6

