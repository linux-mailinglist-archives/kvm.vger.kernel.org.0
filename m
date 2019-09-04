Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344E8A77C7
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 02:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfIDAOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 20:14:54 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:46023 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfIDAOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 20:14:54 -0400
Received: by mail-ua1-f73.google.com with SMTP id 34so2185152uak.12
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 17:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=gddY9rXfy1o/BJAVc6NV/dzZ1eIgz23K6mAhrOnns6o=;
        b=mQmP8yLidRKsOA6YGterIhvm71km1533ZKZH5XuU0t2XnmLxal0PYJXgij40loF5xa
         lURGeeKQe0Sc2V3aYWXwYWjnbrtnLOSFm79r8ZzIqdUgLYU7vvpIrj8FokAz4LInIgjX
         vn0x77A+Z0+czO6/ScPkTAZYs2sE+/bjOryLAGurBQrWgBxYhUf772Unla2XNINnNosQ
         KrXRQLpEhmZa6zFV27mSQH0QPJdKT756iEfBb7TAlg0XOdvaFciWDGclwqWrNENB5Lrj
         S4N8w+Krs9+WorvRzstVvq+jIBsOVWFpmzwvRnbNWqMa7c+78m+h+T7G5mPdMfUHodQP
         ++Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=gddY9rXfy1o/BJAVc6NV/dzZ1eIgz23K6mAhrOnns6o=;
        b=DwcV1urIAAGGnipoQE5QGVK+ooV/KkbbLYLE+tQAq3nvKlXSja7EIry607Yi7qb+g+
         n6hbtmpVbgJHdcNnKPmwzxd52fRRWVFR0+lHgP7MZwzSmqr2Pb+NKz8nl1fDTP07xP3M
         gdCRhqykyjsxvUFMrGQIUoers3mSixI1eJFOBPsH03gvuDZZEQm9XA8XJAXCXolc75bC
         Z0LxBT6FLzgoK/9KLRQiGFOYezo1FA59oGDXxF6a7RBQOWW269ohBTlngF+OupTkRe9s
         mF/kapbcdEJyrseeHpjE5kcgudZG6a3w8ssbjdcBZAi93cCPIpVMbzUIrkbRA1xLFiGv
         Cu4w==
X-Gm-Message-State: APjAAAWWHFts11X/t61DtgolvwGLZqseOTd3VQthWQhQQT6OTLDxOScY
        3vvh8HizkH642B/s1DmY5wpMCmJrloFjSNityUh0zLyq5CvbgBptX3I9otAqyR7a/dAUxcYwLoC
        VaXooXXFbC3JBp+EdH/kqhuyu8aqiqN7ZmNTZwDco38cpcif/LyEdHJOKQ/5P0JcfOfMJ
X-Google-Smtp-Source: APXvYqxzziA5JgqUEnZXByq+rnJeFb6VsrtjTq1mmKSs5vX1/rGddkQjZJz+Gw9WO48+GE7WS/t9Udary57+I1V9
X-Received: by 2002:ab0:1c0b:: with SMTP id a11mr7245696uaj.65.1567556093218;
 Tue, 03 Sep 2019 17:14:53 -0700 (PDT)
Date:   Tue,  3 Sep 2019 17:14:22 -0700
Message-Id: <20190904001422.11809-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [Patch] KVM: SVM: Fix svm_xsaves_supported
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Janakarajan.Natarajan@amd.com, jmattson@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD allows guests to execute XSAVES/XRSTORS if supported by the host.  This=
 is different than Intel as they have an additional control bit that determ=
ines if XSAVES/XRSTORS can be used by the guest. Intel also has intercept b=
its that might prevent the guest from intercepting the instruction as well.=
 AMD has none of that, not even an Intercept mechanism.  AMD simply allows =
XSAVES/XRSTORS to be executed by the guest if also supported by the host.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f220a85514f..b681a89f4f7e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5985,7 +5985,7 @@ static bool svm_mpx_supported(void)
=20
 static bool svm_xsaves_supported(void)
 {
-	return false;
+	return boot_cpu_has(X86_FEATURE_XSAVES);
 }
=20
 static bool svm_umip_emulated(void)
--=20
2.23.0.187.g17f5b7556c-goog

