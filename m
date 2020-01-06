Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E67130FF0
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgAFKEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726640AbgAFKET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wj6IAqlh+XnGpahfgQdkQqwj32LrGOPkbZAukG9b+ak=;
        b=JgtQhKl5DdIE0ADabiYP//PfcKw0K/eE9zR12+Z20Wo6OU7PQdT1LcqkaAgl8uB9WNJFwm
        0T2gIn/K3immTfBPjL0sAH+ChW6G3zs/I/ST3qk3lkX9OtHKun3YIt/10iVxMirjuxguFA
        gYGEQ0MBKpeDUiB/BQuNcHzBTGcP9BQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-unEXVf9sORC-QLgzPltAcw-1; Mon, 06 Jan 2020 05:04:17 -0500
X-MC-Unique: unEXVf9sORC-QLgzPltAcw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CA30801E7E;
        Mon,  6 Jan 2020 10:04:16 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 701F163BCA;
        Mon,  6 Jan 2020 10:04:15 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 17/17] arm: cstart64.S: Remove icache invalidation from asm_mmu_enable
Date:   Mon,  6 Jan 2020 11:03:47 +0100
Message-Id: <20200106100347.1559-18-drjones@redhat.com>
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

According to the ARM ARM [1]:

"In Armv8, any permitted instruction cache implementation can be
described as implementing the IVIPT Extension to the Arm architecture.

The formal definition of the Arm IVIPT Extension is that it reduces the
instruction cache maintenance requirement to the following condition:
Instruction cache maintenance is required only after writing new data to
a PA that holds an instruction".

We never patch instructions in the boot path, so remove the icache
invalidation from asm_mmu_enable. Tests that modify instructions (like
the cache test) should have their own icache maintenance operations.

[1] ARM DDI 0487E.a, section D5.11.2 "Instruction caches"

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart64.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 6f49506ca19b..e5a561ea2e39 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -159,7 +159,6 @@ halt:
=20
 .globl asm_mmu_enable
 asm_mmu_enable:
-	ic	iallu			// I+BTB cache invalidate
 	tlbi	vmalle1			// invalidate I + D TLBs
 	dsb	nsh
=20
--=20
2.21.0

