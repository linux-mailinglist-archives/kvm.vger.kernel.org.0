Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F6331F898
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 12:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhBSLqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 06:46:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230438AbhBSLqf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 06:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613735109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSOzp7uQzDcR4IYxMZ7wQ2qt5GIWM3B9STvSPsjq1vc=;
        b=P7V5WTzyCkj+OSNAXTB0ChpNKNApf9nO8ezuauv8NqC47BHrkjpePPsCUGaKvlWTbfSlY5
        JrsmPxVtAEsxRZ61Me/WdcNuOcBoxZyt2GS5WaNr0aboJ64zqm4Z9UepvV4IzuB9FD6uDr
        2jXk82hOFYCPolOQstImeATu3zDs8d4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-_UMdGcv9Nh6m-Q4T8UkPIw-1; Fri, 19 Feb 2021 06:45:07 -0500
X-MC-Unique: _UMdGcv9Nh6m-Q4T8UkPIw-1
Received: by mail-wr1-f70.google.com with SMTP id l3so699224wrx.15
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 03:45:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FSOzp7uQzDcR4IYxMZ7wQ2qt5GIWM3B9STvSPsjq1vc=;
        b=Hr2NMJGcO9FImw1uJfprac4AgSuWq4s0WOByG8YKFCywLCh4HCvGsuXKEXF1BD7l9V
         iIpb3bNQgbyHshR/aLdKqouzVq8afl8t7lowsqKJsMoDE7senLBTWyJBFvKFLdc3x9HM
         HLPVKGZhkx8asrkSB6isA4BZnHV8iFIBJ9jZcnC2qAdIP7ftusMN1Ch/LU9heQP7eEJ5
         jRJsbevSUh7eQPqr8rFztoTI54R00YOEFC/JbolDmqIWiu8e8LHM/TkiwZX7yUWUC4jk
         1oJoT2gJlsKCWLTBRSRGGu78cubSEGYkvadGep5eBbRz7RT+hEunW9fQju4xeQmuZi76
         IWOw==
X-Gm-Message-State: AOAM532YrXWu76bYbS8tZHz12X1a7tXniY1l2zPCYNrNDhQXRQflbMPK
        eukkNvBIVRkXgsysRU9yyKnfxKzIcLbYYWNspDmlEf02tJNJBEmTzl6wAoR+RkKiicNWLcCDc0/
        pH+5TTjh/mBkO
X-Received: by 2002:a1c:9d52:: with SMTP id g79mr1792871wme.144.1613735106319;
        Fri, 19 Feb 2021 03:45:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5NDROWWBmKNQhqQPWK1fZiiO56f2O6/VVl8Y9duIpMUqxZOlYU2Hbr0aPfnX0v4HquetdhQ==
X-Received: by 2002:a1c:9d52:: with SMTP id g79mr1792832wme.144.1613735106189;
        Fri, 19 Feb 2021 03:45:06 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id a11sm3917199wmh.25.2021.02.19.03.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 03:45:05 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Radoslaw Biernacki <rad@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Greg Kurz <groug@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-arm@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Leif Lindholm <leif@nuviainc.com>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 6/7] hw/s390x: Set kvm_supported to s390-ccw-virtio machines
Date:   Fri, 19 Feb 2021 12:44:27 +0100
Message-Id: <20210219114428.1936109-7-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219114428.1936109-1-philmd@redhat.com>
References: <20210219114428.1936109-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All s390-ccw-virtio machines support KVM.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/s390x/s390-virtio-ccw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 2972b607f36..259b4b4397e 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -612,6 +612,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
     mc->possible_cpu_arch_ids = s390_possible_cpu_arch_ids;
     /* it is overridden with 'host' cpu *in kvm_arch_init* */
     mc->default_cpu_type = S390_CPU_TYPE_NAME("qemu");
+    mc->kvm_supported = true;
     hc->plug = s390_machine_device_plug;
     hc->unplug_request = s390_machine_device_unplug_request;
     nc->nmi_monitor_handler = s390_nmi;
-- 
2.26.2

