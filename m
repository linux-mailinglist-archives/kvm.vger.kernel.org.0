Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904C831F899
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 12:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhBSLqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 06:46:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230461AbhBSLqm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 06:46:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613735115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YJlwy/QOkf0QIlTzPZ6przivK3+kqukDr5TR8oal+wM=;
        b=dJVP5+S1tMVic0IRKW2XmEswBeQV8YIS+t1d3w+xxw75aN4BbJft5z8j8elVX8zlG4mtrd
        Hxf3OlSMIAAt/ID4rqLcfJ5RVBSqodb3LTI7giRjJUA7Wx6XtpUk/s4cW6n636kO983pzl
        KnNPLkMRPtJaobU1I3E+gpVgVo19sz8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-kZgZ5Q5CM5CBmJtd3ctDKA-1; Fri, 19 Feb 2021 06:45:13 -0500
X-MC-Unique: kZgZ5Q5CM5CBmJtd3ctDKA-1
Received: by mail-wr1-f70.google.com with SMTP id l10so2325943wry.16
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 03:45:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJlwy/QOkf0QIlTzPZ6przivK3+kqukDr5TR8oal+wM=;
        b=IyntMUs9P42dVBZFeb2W4zmjUBy9Wuj2Q+UUnNcNr2tGl6qj3NhwOPD/YnhuPK9HPl
         s2NuUqYd2hyFvHB03qYywlklKSbDPEa26ifefS8lgRxBHig3nQSJE0RN0rrMApU+P9H8
         M+xylZ/L20ZND8+KSgVrue+i1rmmJik9dAGfwo2OR//mGuyW3hYgPegObZg+vhAmM3Zo
         LnwFGWCw8rPxoBqDA+QZSEQ4Tf85Mr8qo8rHGYfVsQlnVWUGmZF9AB19u3i/18TDmzUU
         Xnya764d2yhTRCFpCDp9HsQ4jDt3hILdoE2WYYU9+4kmkk5kh79vEnd0ViqNOqMAGqv+
         AMxA==
X-Gm-Message-State: AOAM532BSwYLt//7E3h1HLq9jIZh+3sM5yfrhJRxXOCTj3rLltnGrXh1
        D18WLbnrLSoenDg3hBAN72iS2vJ1JsupQacq16g5bTkfCJWEgSMHao21h+UekS219XMvzrIO0mH
        jYeSEI2ZG6qqF
X-Received: by 2002:adf:bbca:: with SMTP id z10mr8877272wrg.168.1613735112115;
        Fri, 19 Feb 2021 03:45:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZHhoZ2Wy0Wkb5v1FsmoSovOJoQjV0ghbc4hAJ/cIFmfZspDESkeyO+OZmJZh6DupK3/KHUQ==
X-Received: by 2002:adf:bbca:: with SMTP id z10mr8877239wrg.168.1613735111985;
        Fri, 19 Feb 2021 03:45:11 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id z17sm15710920wrv.9.2021.02.19.03.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 03:45:11 -0800 (PST)
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
Subject: [PATCH 7/7] accel/kvm: Exit gracefully when KVM is not supported
Date:   Fri, 19 Feb 2021 12:44:28 +0100
Message-Id: <20210219114428.1936109-8-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219114428.1936109-1-philmd@redhat.com>
References: <20210219114428.1936109-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we added the 'kvm_supported' field to MachineClass
and all our machines able to use KVM have this field set,
we can check it in kvm_init() and exit gracefully with
a friendly error message.

Before:

  $ qemu-system-aarch64 -M raspi3b -enable-kvm
  qemu-system-aarch64: /build/qemu-ETIdrs/qemu-4.2/exec.c:865: cpu_address_space_init: Assertion `asidx == 0 || !kvm_enabled()' failed.
  Aborted

  $ qemu-system-aarch64 -M xlnx-zcu102 -enable-kvm -smp 6
  qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument

After:

  $ qemu-system-aarch64 -M raspi3b -enable-kvm
  Machine 'raspi3b' does not support KVM

  $ qemu-system-aarch64 -M xlnx-zcu102 -enable-kvm -smp 6
  Machine 'xlnx-zcu102' does not support KVM

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 accel/kvm/kvm-all.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index b069938d881..8a8d3f64248 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2001,6 +2001,12 @@ static int kvm_init(MachineState *ms)
 
     s = KVM_STATE(ms->accelerator);
 
+    if (!mc->kvm_supported) {
+        ret = -EINVAL;
+        fprintf(stderr, "Machine '%s' does not support KVM\n", mc->name);
+        exit(1);
+    }
+
     /*
      * On systems where the kernel can support different base page
      * sizes, host page size may be different from TARGET_PAGE_SIZE,
-- 
2.26.2

