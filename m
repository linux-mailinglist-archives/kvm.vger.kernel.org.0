Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E7C204F8F
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732360AbgFWKv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:51:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732353AbgFWKv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592909486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qmjIgwRF8m2X82NXC/aF4wUlj0t/xV0oEGPCL2nLyv8=;
        b=fdTkAmMACf4ZyrwWSWZ1IaghGuqq7okLBx+IUSo84szYnuNy6+aG7+s/x5+OFRLa5G+d5t
        +6ZBazRq8kaDrPq3RiieWJ7kW5hpd+0Uq7UNmTboGCM9zLSRynV7XKcOreYqMGsPXROoFQ
        vHb6ToQJ/WO5pLV19SezTfsXQXvo/Dk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-JT6087c9M_yT3a7RkrZ5ug-1; Tue, 23 Jun 2020 06:51:25 -0400
X-MC-Unique: JT6087c9M_yT3a7RkrZ5ug-1
Received: by mail-wr1-f71.google.com with SMTP id d6so14837627wrn.1
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qmjIgwRF8m2X82NXC/aF4wUlj0t/xV0oEGPCL2nLyv8=;
        b=r7Dg157KdWKiWAgSVOTjZ6Xm3vUj0WfV9sI1aBNNoGs13+1rvFYxXHUvF6KEe01UVR
         BGDG6S/FUyK2A2atbzaKahTs7XdEFcK1aN8PxoUe6b9IG5jgnnP2oLN1uHFaEJItZvsV
         dHNMc9LdonkKOmSSf3zCnt5De2cHTneHEsdNpzG72ubc9sbTiN/+8l27l2nP6WMJZNym
         W/L13GAVylg82CMy7elBlC88mEB9f73q9aczwdW14iAE4Xm69xM/C+QhPZa/dGGFCveQ
         tXkGRqo5LJMMq/tftlfEQub14OLJqjkGKka/4Okxbawr8f0AASqnOZK3R4tKabSyyrhi
         R2cg==
X-Gm-Message-State: AOAM533C3XUDh3td+xIsFMYL3z7/dPn8c4AeZfUSl7+gOWlM/ma73R5h
        42Eonj8MgZsDmjYcHZgsbUPNe2Y3jVsG8OUuRg+dYcieiMV5AVITUstSJ8iT4yc0T9nZI38UMn/
        2iAC6ghOVuN9h
X-Received: by 2002:adf:f9c9:: with SMTP id w9mr7100468wrr.176.1592909484048;
        Tue, 23 Jun 2020 03:51:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlpmoxTmn90g70HUfnMorwjhE16MuS3RvWoGCm7N031I11kiIVc6XhUo8zzfA2/fxL4+l7Mg==
X-Received: by 2002:adf:f9c9:: with SMTP id w9mr7100432wrr.176.1592909483842;
        Tue, 23 Jun 2020 03:51:23 -0700 (PDT)
Received: from localhost.localdomain (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id a16sm21190508wrx.8.2020.06.23.03.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:51:23 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 5/7] target/i386/kvm: Simplify get_para_features()
Date:   Tue, 23 Jun 2020 12:50:50 +0200
Message-Id: <20200623105052.1700-6-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200623105052.1700-1-philmd@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVMState* argument is now unused, drop it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 03df6ac3b4..19d3db657a 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -289,7 +289,7 @@ static const struct kvm_para_features {
     { KVM_CAP_ASYNC_PF, KVM_FEATURE_ASYNC_PF },
 };
 
-static int get_para_features(KVMState *s)
+static int get_para_features(void)
 {
     int i, features = 0;
 
@@ -452,7 +452,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
 
     /* fallback for older kernels */
     if ((function == KVM_CPUID_FEATURES) && !found) {
-        ret = get_para_features(s);
+        ret = get_para_features();
     }
 
     return ret;
-- 
2.21.3

