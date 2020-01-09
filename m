Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08110135C8F
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732326AbgAIPWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 10:22:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732321AbgAIPWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 10:22:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578583344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rw8jmxMoDMD+mDmAS1YaT70WlRmZEqpVqIIhKc3uSz0=;
        b=NsuRFMXw10c27DpYwdMjuaE75U4GUzN8t4rl2J/5J/TVusKNblW9i1/iH2uRF3jOpSM56d
        3cJysVQFCK2CtWzhdnhN1KAOfTazUYxyAF6U0YSSZMhoddf5NmfIyuQMb3I2eA1QEby7DX
        hY2C+30sT8hLEH5Kb8dSXMb4kogupaI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-7u9vL7X1MXy5Q1TcHaePyA-1; Thu, 09 Jan 2020 10:22:21 -0500
X-MC-Unique: 7u9vL7X1MXy5Q1TcHaePyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE915477;
        Thu,  9 Jan 2020 15:22:19 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5EAA1CB;
        Thu,  9 Jan 2020 15:22:13 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-ppc@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 04/15] hw/ppc/spapr_rtas: Restrict variables scope to single switch case
Date:   Thu,  9 Jan 2020 16:21:22 +0100
Message-Id: <20200109152133.23649-5-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-1-philmd@redhat.com>
References: <20200109152133.23649-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We only access these variables in RTAS_SYSPARM_SPLPAR_CHARACTERISTICS
case, restrict their scope to avoid unnecessary initialization.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 hw/ppc/spapr_rtas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/ppc/spapr_rtas.c b/hw/ppc/spapr_rtas.c
index 6f06e9d7fe..7237e5ebf2 100644
--- a/hw/ppc/spapr_rtas.c
+++ b/hw/ppc/spapr_rtas.c
@@ -267,8 +267,6 @@ static void rtas_ibm_get_system_parameter(PowerPCCPU =
*cpu,
                                           uint32_t nret, target_ulong re=
ts)
 {
     PowerPCCPUClass *pcc =3D POWERPC_CPU_GET_CLASS(cpu);
-    MachineState *ms =3D MACHINE(spapr);
-    unsigned int max_cpus =3D ms->smp.max_cpus;
     target_ulong parameter =3D rtas_ld(args, 0);
     target_ulong buffer =3D rtas_ld(args, 1);
     target_ulong length =3D rtas_ld(args, 2);
@@ -276,6 +274,8 @@ static void rtas_ibm_get_system_parameter(PowerPCCPU =
*cpu,
=20
     switch (parameter) {
     case RTAS_SYSPARM_SPLPAR_CHARACTERISTICS: {
+        MachineState *ms =3D MACHINE(spapr);
+        unsigned int max_cpus =3D ms->smp.max_cpus;
         char *param_val =3D g_strdup_printf("MaxEntCap=3D%d,"
                                           "DesMem=3D%" PRIu64 ","
                                           "DesProcs=3D%d,"
--=20
2.21.1

