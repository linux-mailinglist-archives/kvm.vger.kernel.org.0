Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E3A130FEC
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgAFKEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55564 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726498AbgAFKEK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jan 2020 05:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1WJyYUM6ymx8yc6lcwPhCIh5ZZCd5xmlYFGgwWqcFv0=;
        b=KM9GfHAZI0d2yNWWbchZtEiWbSDKCfz/QexbWqpjjcspWhw4qVCagJHDIVv3+BP+wXrBV2
        s1TQo/w1qVcWn/LP20ykHOASRVpzkMhTl4pVsTNO4OLva9QP6GjQCtaLF2/muZw7MJWVba
        2uJBdNd16bzC57rMMBOdTGul1v/vD7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-_Ny9n4pTN0yg_heUKWNDyQ-1; Mon, 06 Jan 2020 05:04:06 -0500
X-MC-Unique: _Ny9n4pTN0yg_heUKWNDyQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A03EB1005502;
        Mon,  6 Jan 2020 10:04:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76B0563BCA;
        Mon,  6 Jan 2020 10:04:04 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PULL kvm-unit-tests 09/17] lib: arm/arm64: Remove unused CPU_OFF parameter
Date:   Mon,  6 Jan 2020 11:03:39 +0100
Message-Id: <20200106100347.1559-10-drjones@redhat.com>
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
References: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

The first version of PSCI required an argument for CPU_OFF, the power_sta=
te
argument, which was removed in version 0.2 of the specification [1].
kvm-unit-tests supports PSCI 0.2, and KVM ignores any CPU_OFF parameters,
so let's remove the PSCI_POWER_STATE_TYPE_POWER_DOWN parameter.

[1] ARM DEN 0022D, section 7.3.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/psci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index c3d399064ae3..936c83948b6a 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -40,11 +40,9 @@ int cpu_psci_cpu_boot(unsigned int cpu)
 	return err;
 }
=20
-#define PSCI_POWER_STATE_TYPE_POWER_DOWN (1U << 16)
 void cpu_psci_cpu_die(void)
 {
-	int err =3D psci_invoke(PSCI_0_2_FN_CPU_OFF,
-			PSCI_POWER_STATE_TYPE_POWER_DOWN, 0, 0);
+	int err =3D psci_invoke(PSCI_0_2_FN_CPU_OFF, 0, 0, 0);
 	printf("CPU%d unable to power off (error =3D %d)\n", smp_processor_id()=
, err);
 }
=20
--=20
2.21.0

