Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC8B44802
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393281AbfFMRDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:03:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56098 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbfFMRDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so10963508wmj.5;
        Thu, 13 Jun 2019 10:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7m3hMtDG7gra4X2zWk3roSWCEEO5EloSfs0dzfM9Apo=;
        b=tauNLy6bXrdunw+dGY7UPzi569AXF/L59P1VXZL5xSxv7d3DhA+KdWe49kz5kSjdw+
         Xj85YtiFbt884q5VSpfMECTWrgrZkAjpTzmhXmIYdrpGcgZthDuybh1SvrfQOyWS0RHh
         XrekiJjrLprAQbw1aEIH01BaVXGrv5C4GT3t7CVeajy5ou+68XCPGxVfHou4GbHVt+nm
         pUljNiF5uHfg55WvWtF86bvhGpv7WGaLXsCagILMsFt1Yq51nwyxfpy/xKlMATgHQq3H
         I4UrmC1pAQCvTK1zGniWI0XtigXmXUf10Hd+a+/yAgpygT5CXA71SPlLnDvxtO+JReWW
         Zivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=7m3hMtDG7gra4X2zWk3roSWCEEO5EloSfs0dzfM9Apo=;
        b=adFEVZ7FyNBRr8CLd0NHCrsT+ecG2bgvPzwBnY29iWClJ/KNJkOm/wsjdS+cA7VgpC
         iWhZlFSLDIMte4FlBvvyHm8PYTfxpNiOv1JYumPn81ji3uW2ZyC+l/o+lG0oJ6FwOQ7b
         HpoHbJ1TxnpYiMrURCbD6a6ZPWjQ3z/1At5Ld62FrFNDc0/G6suGsnk5TgVfFW5/ZRay
         EwF1fPLxH3QJjtlbL7hDMpRIIvfEa+jBQ81LUB8LZ86Bac+gPNhhyybBjfcgxaen8666
         R/A+FP+CUxheBRBHdpPihLw0Mkc2PsuHZYOfkbz+fersscrdvE+mjizV3vn90meByQCZ
         oLyQ==
X-Gm-Message-State: APjAAAUM1q+PQjhYXe5Qh7Q3h3ztKjh2wH+j8jvk9GpQ+4lBIVoOfblT
        PbzMozCjcMvD5ixVF4NdmNGIPdX1
X-Google-Smtp-Source: APXvYqxu4kCzKA7T0Wtw/Hp+cpnGxPexT97EFPhWjhA/Q4yqMKDXbO1bwBc5hd5Ea1Yk2JQ4PZyZyA==
X-Received: by 2002:a1c:7310:: with SMTP id d16mr4447800wmb.107.1560445413046;
        Thu, 13 Jun 2019 10:03:33 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:32 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 02/43] kvm: nVMX: small cleanup in handle_exception
Date:   Thu, 13 Jun 2019 19:02:48 +0200
Message-Id: <1560445409-17363-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The reason for skipping handling of NMI and #MC in handle_exception is
the same, namely they are handled earlier by vmx_complete_atomic_exit.
Calling the machine check handler (which just returns 1) is misleading,
don't do it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1b3ca0582a0c..da6c829bad9f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4455,11 +4455,8 @@ static int handle_exception(struct kvm_vcpu *vcpu)
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmx->exit_intr_info;
 
-	if (is_machine_check(intr_info))
-		return handle_machine_check(vcpu);
-
-	if (is_nmi(intr_info))
-		return 1;  /* already handled by vmx_vcpu_run() */
+	if (is_machine_check(intr_info) || is_nmi(intr_info))
+		return 1;  /* already handled by vmx_complete_atomic_exit */
 
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
-- 
1.8.3.1


