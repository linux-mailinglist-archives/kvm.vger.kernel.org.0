Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965FA31FE09
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 18:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhBSRkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 12:40:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhBSRkh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 12:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQ6bR9q2nTx8UZfcCwDp8YyWJ5IdPylW4EMLv5ePnSc=;
        b=aiIBXvVyVz8UZbKJ1VRMWUICNBGe/Ged0aq2gyJIxKbrGg/y/4qW6C+GOeGtIqz8jtKocz
        5JzrOWvPQ7Ac/lyOQZIzNKA0PophRMhi2pvyfybwaAlU4CSSoR35XxHQdA1Qhusxog216A
        8gIlUEBGhNHKT/IFLkIGd8rknRMOg3c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-tagFiIxWOY-s7oEXMF7aig-1; Fri, 19 Feb 2021 12:39:09 -0500
X-MC-Unique: tagFiIxWOY-s7oEXMF7aig-1
Received: by mail-wr1-f72.google.com with SMTP id x14so2174130wrr.13
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 09:39:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HQ6bR9q2nTx8UZfcCwDp8YyWJ5IdPylW4EMLv5ePnSc=;
        b=ZZqHEj4fjDwkvkUUMR9mRmOZrBMoboxY7iwMdi3CBrKnEdpqjeu+3lE/fZ0S4s4l0z
         EUYdI2ByvrP8XzgXBGUprgttxW6xNmJaT7C9ZlSzhd07opaia2i2U0rCXfSWux29j4/z
         wXhkZQt8qWImYSsb4FRmF3Sze3ay25xVlu0GL+nh4p8evDcC4kq0duz41AkDlzHxVbBS
         c5tJZCV6JJAnqZf20bwLEGZghuf3ZUnN//YIx7nvkrjaPIp+YXcZkLz9iGCYbGEuHH37
         TBvEiqmAsJ2fZgb04hW9mJEkmup14IPqOWfXlSMh2zBr/LjWCVH2IeTUg3JsnF5rpr9F
         aXNw==
X-Gm-Message-State: AOAM531p8ZLC6jhuBN22Ti9aU8vjpLHZ8LAHmgYmZGe/sWqsrs+8ia4V
        P0MWx+tY7GEKiAse+CHwNx8km+NjAptBshkw9moAD1+OSEOsCw/aIoKsb++Lr6n+CjKAo+l0/FJ
        NULsMTT+O1eNZ
X-Received: by 2002:adf:b342:: with SMTP id k2mr10246413wrd.264.1613756347939;
        Fri, 19 Feb 2021 09:39:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRIsqLMFpNjZYF3WUU2UHyYdzuctCSQdLydicZwE25C3zYE3MQJaOoIUNZctaN8YvHWyznKA==
X-Received: by 2002:adf:b342:: with SMTP id k2mr10246368wrd.264.1613756347790;
        Fri, 19 Feb 2021 09:39:07 -0800 (PST)
Received: from localhost.localdomain (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id y62sm15299048wmy.9.2021.02.19.09.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:39:07 -0800 (PST)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Daniel=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2 03/11] hw/core: Restrict 'query-machines' to those supported by current accel
Date:   Fri, 19 Feb 2021 18:38:39 +0100
Message-Id: <20210219173847.2054123-4-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219173847.2054123-1-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not let 'query-machines' return machines not valid with
the current accelerator.

Suggested-by: Daniel Berrangé <berrange@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/core/machine-qmp-cmds.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/hw/core/machine-qmp-cmds.c b/hw/core/machine-qmp-cmds.c
index 44e979e503b..c8630bc2ddc 100644
--- a/hw/core/machine-qmp-cmds.c
+++ b/hw/core/machine-qmp-cmds.c
@@ -204,6 +204,10 @@ MachineInfoList *qmp_query_machines(Error **errp)
         MachineClass *mc = el->data;
         MachineInfo *info;
 
+        if (!machine_class_valid_for_current_accelerator(mc)) {
+            continue;
+        }
+
         info = g_malloc0(sizeof(*info));
         if (mc->is_default) {
             info->has_is_default = true;
-- 
2.26.2

