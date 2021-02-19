Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4C331FE18
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhBSRlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:41:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229991AbhBSRlL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m89dmrSplgkgoyBA9XFoMMYsKZX69TbxEanq9oDkcW0=;
        b=JEKKxhMc4fPJKMm8IN1nbv2+K5pOJGMwCJpYZ3by1SgsbEYLRuEpDK//Q2ZmcQHmTlZe5h
        0pVMeyHrg6cpiUfX90g3lutN3L4jh+VYpMbz12nyaUoBkiAs7aw68Qdhu8VkoWFUJYhe0+
        Cc7PtECKSByiWWyKTW/d6gqn9e9Nxqo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-NEXKjxB9MsiFboNGiHssAw-1; Fri, 19 Feb 2021 12:39:43 -0500
X-MC-Unique: NEXKjxB9MsiFboNGiHssAw-1
Received: by mail-wm1-f71.google.com with SMTP id b201so2769705wmb.9
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:39:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m89dmrSplgkgoyBA9XFoMMYsKZX69TbxEanq9oDkcW0=;
        b=A0mploV6hRQfkhxdgWqAZ3rfyzYD67fanwfOvqLxvpe3q9S5lgIp8HEsYeg+MTgfMU
         oNwdM5tDySL8CwGoehcAEl6hLnFwIwoI/5HVHtAr9g+RlbDfxRkv9KBJDzxVJ/xCZYjI
         SKlDbOjNiTxIf3VnthNqNpnNjDT5Ik2xAGfQ9zDMUKWSHJ3HPq3v+NZuJxbCF7CRXtCh
         puyy8DFHnYBh+aoP94Cm97sIfldISiYcenFRSmgp+16DAiubLqSYZZkUauVkthH1DgRI
         N2IKFBuizm+xeh1xSOqXahSNrMrCfQ3hAKyuNZoTNpLKNFzhXauzm37tAR62zCvnnaTx
         Xwew==
X-Gm-Message-State: AOAM533GhMrzcOrAfMYz0OvQPF+IyZKzCzJfq/gWrKXvr3J7sonc7vGl
        5fFooqGEkXp2QaOa3H/Ko1ZWcoP8ecUhLoIhZOOBnH11K50EVWh2O2L5qK7JvExG/RMuWcTLTno
        AgVNhZJab7RLB
X-Received: by 2002:a1c:c6:: with SMTP id 189mr9272312wma.128.1613756382370;
        Fri, 19 Feb 2021 09:39:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfL/zeX1Twd/41yRwfBzbYwswnUhtDRMBecaJ3a8NHeinaw0+wzScyZWOOrq01liX3KOGGMQ==
X-Received: by 2002:a1c:c6:: with SMTP id 189mr9272291wma.128.1613756382214;
        Fri, 19 Feb 2021 09:39:42 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id b72sm13082236wmd.4.2021.02.19.09.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:39:41 -0800 (PST)
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
Subject: [PATCH v2 09/11] hw/xenpv: Restrict Xen Para-virtualized machine to Xen accelerator
Date:   Fri, 19 Feb 2021 18:38:45 +0100
Message-Id: <20210219173847.2054123-10-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When started with other accelerator than Xen, the XenPV machine
fails with a criptic message:

  $ qemu-system-x86_64 -M xenpv,accel=kvm
  xen be core: can't connect to xenstored
  qemu-system-x86_64: xen_init_pv: xen backend core setup failed

By restricting it to Xen, we display a clearer error message:

  $ qemu-system-x86_64 -M xenpv,accel=kvm
  qemu-system-x86_64: invalid accelerator 'kvm' for machine xenpv

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/xenpv/xen_machine_pv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/xenpv/xen_machine_pv.c b/hw/xenpv/xen_machine_pv.c
index 8df575a457c..d7747bcec98 100644
--- a/hw/xenpv/xen_machine_pv.c
+++ b/hw/xenpv/xen_machine_pv.c
@@ -86,12 +86,17 @@ static void xen_init_pv(MachineState *machine)
     atexit(xen_config_cleanup);
 }
 
+static const char *valid_accels[] = {
+    "xen", NULL
+};
+
 static void xenpv_machine_init(MachineClass *mc)
 {
     mc->desc = "Xen Para-virtualized PC";
     mc->init = xen_init_pv;
     mc->max_cpus = 1;
     mc->default_machine_opts = "accel=xen";
+    mc->valid_accelerators = valid_accels;
 }
 
 DEFINE_MACHINE("xenpv", xenpv_machine_init)
-- 
2.26.2

