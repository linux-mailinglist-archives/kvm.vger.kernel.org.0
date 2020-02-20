Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA385165E34
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgBTNGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:39 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28991 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728169AbgBTNGj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:06:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HqjVrldq/ACwB3h0fVhMHW95VpOuJ6iegNutM3g++eM=;
        b=QbhpLft6uYLQBRDhp3D2fKwIyxc9gBViMZ3khwuECeTlOJCg3wDO/fuK4ubX7tex9IfIlM
        e5AjyZCP43Il1Clh3OQR+V0x84LLd9PlXxYeKbEcylB/h7/eRD/LT7tFoicXadvMloLBzD
        OATee4MftInWM/ycgVc4zL30X0j49JU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-uRDMcB4bMV-E41R8wdaeig-1; Thu, 20 Feb 2020 08:06:36 -0500
X-MC-Unique: uRDMcB4bMV-E41R8wdaeig-1
Received: by mail-wr1-f71.google.com with SMTP id r1so1700255wrc.15
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqjVrldq/ACwB3h0fVhMHW95VpOuJ6iegNutM3g++eM=;
        b=Irp3OXzJbcMdG1ewqGzIb+UApQiHtTYw+oiz/2j/FiRhWKVhlJ1KjdmKOHXkOcDzw7
         d1ub0Xb6xaYadSqxkoUuZeHVgNcZqFgEK0jR6hupDpA0tMfu1I9P2fCca6vRk174h6O1
         3aTpWZJoLvr7zp9e1C3GbbBI3wGMwrqFaNAxTD8u74l9hlqv9CKit4g4sYuykzD1AVix
         VJfLHvgilAqZM5CuJuRl3lxemZXKyb/xXpiISHsCWSg9tG9quNPIB3Vx5/dUR2Jaugy9
         lvrih3WPjG/rM+N8JFb8tUT61gIfURpaqc9/vq4IXgXKl4K69IuzjCoqFeX6npoTth9p
         O94Q==
X-Gm-Message-State: APjAAAWTAbxYsWx5gsuu39Gktl2wAhzbWVmiNCSBeqPalQJa1e99dBUe
        DuSC7quMuo6YLCpdHcSWUx7km8tCAtpQP4EBw3IRZkzXK64Qdgu5I2eYHT7HRB9kqVs7cz+NcxO
        f+tQwS9taum7U
X-Received: by 2002:a5d:4e91:: with SMTP id e17mr40461397wru.233.1582203995252;
        Thu, 20 Feb 2020 05:06:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqxMGFl+IFZrtHZDte4P/R96xDKYdgOkawy+8epg2tZDd8Fi56EKpiHK5Ha76g6PPzAayNlwiw==
X-Received: by 2002:a5d:4e91:: with SMTP id e17mr40461365wru.233.1582203995044;
        Thu, 20 Feb 2020 05:06:35 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:34 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v3 11/20] hw/ide/internal: Remove unused DMARestartFunc typedef
Date:   Thu, 20 Feb 2020 14:05:39 +0100
Message-Id: <20200220130548.29974-12-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200220130548.29974-1-philmd@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The IDE DMA restart callback has been removed in commit fe09c7c9f0.

Fixes: fe09c7c9f0
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/ide/internal.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/hw/ide/internal.h b/include/hw/ide/internal.h
index 52ec197da0..ce766ac485 100644
--- a/include/hw/ide/internal.h
+++ b/include/hw/ide/internal.h
@@ -326,7 +326,6 @@ typedef int DMAIntFunc(IDEDMA *, int);
 typedef int32_t DMAInt32Func(IDEDMA *, int32_t len);
 typedef void DMAu32Func(IDEDMA *, uint32_t);
 typedef void DMAStopFunc(IDEDMA *, bool);
-typedef void DMARestartFunc(void *, int, RunState);
 
 struct unreported_events {
     bool eject_request;
-- 
2.21.1

