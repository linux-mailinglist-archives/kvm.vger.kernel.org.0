Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C459031FE0D
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhBSRka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:40:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229658AbhBSRk2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:40:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98X4DsBNdk1BN09KWcHx0mE3/gzzTZdKxOLSGajyIeI=;
        b=f+zaNRcDyHOGFgQzgmzI1vGQTqanXW+HRFwydtdmYIhDR12kw6EKpXwgZZaeWwq4mSSmMr
        QqjjZCx6PUXvPzANDqTKL7piZRIfBn5rFhCQcEm3zsxEK0eTgXt4Nw317mbdED25dOmSMK
        iHDM9R7tJdN7IxfnkKj20TsYZTc8I0U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-LrRgB1XcMSit_nQi_B59-Q-1; Fri, 19 Feb 2021 12:38:58 -0500
X-MC-Unique: LrRgB1XcMSit_nQi_B59-Q-1
Received: by mail-wm1-f72.google.com with SMTP id j204so2793868wmj.4
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:38:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=98X4DsBNdk1BN09KWcHx0mE3/gzzTZdKxOLSGajyIeI=;
        b=PjHVjDJ9iBnbLTf2yoqML5R70DRfSc+fgfeg8xtBkU2/HtpwnL9EWBqKgZFTnSDRdW
         vpJaLo2rAenGCabd8hYSkCLths1wu2Dw9VsJ1xvmSvKU0AODuJny4S7ZXrZRVsOvNCud
         8+O3Emjaw8WEwLxb8pbDhOtVm5Xdl03koeQpFMoIgs6mcqTEQqnfiEatTshmwYNMpoMo
         1OoZtN3whqK+0vJJnD++AD3PFPaSdzOsg34ZP9lr8if9X3Wz3yMvhBP7CnQ75EHfyQsV
         sOz6m/yzDDRkBF/j8NzkbRILyGqPgaDmSHZzL4ULkBvb+2na17X7YOTO3cLF4DBdN8L5
         cTjw==
X-Gm-Message-State: AOAM532DvAsnpT7XXU9cJJJ4Ih0JZ1shr7SQTFqISpRxK0gj7z1UeJ1J
        7XbGcL/kaWyY7ZOg2Z0N+kt25PLMWG8Y+4jsLvegcDq1VKumnS+4O/wlNMj4sRfIo83lx0WCqY8
        H6VMKY6Nrtrff
X-Received: by 2002:adf:b60f:: with SMTP id f15mr10395981wre.83.1613756336824;
        Fri, 19 Feb 2021 09:38:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzk+AP79F8l3TWLxyR5RU8SmferiSbz3yhDIC5dQKM04uA2QaqDVPRO6H3UVoBxcUQFmDZVKw==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr10395942wre.83.1613756336683;
        Fri, 19 Feb 2021 09:38:56 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id i7sm23525949wmq.2.2021.02.19.09.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:38:56 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 01/11] accel/kvm: Check MachineClass kvm_type() return value
Date:   Fri, 19 Feb 2021 18:38:37 +0100
Message-Id: <20210219173847.2054123-2-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MachineClass::kvm_type() can return -1 on failure.
Document it, and add a check in kvm_init().

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/boards.h | 3 ++-
 accel/kvm/kvm-all.c | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index a46dfe5d1a6..68d3d10f6b0 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -127,7 +127,8 @@ typedef struct {
  *    implement and a stub device is required.
  * @kvm_type:
  *    Return the type of KVM corresponding to the kvm-type string option or
- *    computed based on other criteria such as the host kernel capabilities.
+ *    computed based on other criteria such as the host kernel capabilities
+ *    (which can't be negative), or -1 on error.
  * @numa_mem_supported:
  *    true if '--numa node.mem' option is supported and false otherwise
  * @smp_parse:
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 84c943fcdb2..b069938d881 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2057,6 +2057,12 @@ static int kvm_init(MachineState *ms)
                                                             "kvm-type",
                                                             &error_abort);
         type = mc->kvm_type(ms, kvm_type);
+        if (type < 0) {
+            ret = -EINVAL;
+            fprintf(stderr, "Failed to detect kvm-type for machine '%s'\n",
+                    mc->name);
+            goto err;
+        }
     }
 
     do {
-- 
2.26.2

