Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 315F711F2B1
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 16:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfLNP6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 10:58:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56295 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726636AbfLNP6K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Dec 2019 10:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576339088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cebHdve3ZnvlZJWxH5a8KchlZuVrxNjKmx0NHd8T+o=;
        b=FvFHgMb1PeHJnEzhQN0Z1w4AKaQ0Qp0/qW0AiyQL2frI7cF8401J0cfUvYnP4aneO4dV6j
        YFV/9zlfU2CWUUoIlMEGa9FddXLHQWzSdIcX7Y9JttYEfOAgtYQMTwhjUbbQqb3Zy+ozeU
        HUvn6FdSLy5vYCfbedt52HUezxmKqaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-FmV6NzRAPFqS56q6qZWsiQ-1; Sat, 14 Dec 2019 10:58:07 -0500
X-MC-Unique: FmV6NzRAPFqS56q6qZWsiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74DD11005502;
        Sat, 14 Dec 2019 15:58:05 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DCAF5D6A7;
        Sat, 14 Dec 2019 15:57:57 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Andrew Baumann <Andrew.Baumann@microsoft.com>,
        Aurelien Jarno <aurelien@aurel32.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Joel Stanley <joel@jms.id.au>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7/8] target/i386: Use memory_region_add_subregion() when priority is 0
Date:   Sat, 14 Dec 2019 16:56:13 +0100
Message-Id: <20191214155614.19004-8-philmd@redhat.com>
In-Reply-To: <20191214155614.19004-1-philmd@redhat.com>
References: <20191214155614.19004-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is pointless to overlap a memory subregion with priority 0.
Use the simpler memory_region_add_subregion() function.

This patch was produced with the following spatch script:

    @@
    expression region;
    expression offset;
    expression subregion;
    @@
    -memory_region_add_subregion_overlap(region, offset, subregion, 0)
    +memory_region_add_subregion(region, offset, subregion)

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 target/i386/cpu.c | 2 +-
 target/i386/kvm.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 69f518a21a..6131c62f9d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6483,7 +6483,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Err=
or **errp)
          */
         memory_region_init_alias(cpu->cpu_as_mem, OBJECT(cpu), "memory",
                                  get_system_memory(), 0, ~0ull);
-        memory_region_add_subregion_overlap(cpu->cpu_as_root, 0, cpu->cp=
u_as_mem, 0);
+        memory_region_add_subregion(cpu->cpu_as_root, 0, cpu->cpu_as_mem=
);
         memory_region_set_enabled(cpu->cpu_as_mem, true);
=20
         cs->num_ases =3D 2;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 1d10046a6c..4e1ba9d474 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -2081,7 +2081,7 @@ static void register_smram_listener(Notifier *n, vo=
id *unused)
      */
     memory_region_init_alias(&smram_as_mem, OBJECT(kvm_state), "mem-smra=
m",
                              get_system_memory(), 0, ~0ull);
-    memory_region_add_subregion_overlap(&smram_as_root, 0, &smram_as_mem=
, 0);
+    memory_region_add_subregion(&smram_as_root, 0, &smram_as_mem);
     memory_region_set_enabled(&smram_as_mem, true);
=20
     if (smram) {
--=20
2.21.0

