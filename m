Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E5E2581D0
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 21:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgHaTec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 15:34:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22754 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725872AbgHaTeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 15:34:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598902470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtLyg6lCGileigLzG/AbjWIpEiRqxpxwtXfCaWYW4BQ=;
        b=ZEVX7Vb8OGsWmdTqUo2StbwPKBbC1YQdExZJ4AqWa1I3n5GysXiZ2NfLxCy7FWEk9A03wh
        6zCj5uC9wPUaDBXd6oriTXjrqHyn7vaCic9xemHIW2CjqK2WWEEzRGS1SP4hYM3KP7pQyt
        IqQQKvcjQ+3eSn9nYOxbbb9sJh9vkW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-IZETdFkBPgyuFjCOujLmHQ-1; Mon, 31 Aug 2020 15:34:27 -0400
X-MC-Unique: IZETdFkBPgyuFjCOujLmHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FF6A802B49;
        Mon, 31 Aug 2020 19:34:25 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-112.ams2.redhat.com [10.36.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB7637EB7D;
        Mon, 31 Aug 2020 19:34:22 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        qemu-devel@nongnu.org, drjones@redhat.com, andrew.murray@arm.com,
        sudeep.holla@arm.com, maz@kernel.org, will@kernel.org,
        haibo.xu@linaro.org
Subject: [kvm-unit-tests RFC 1/4] arm64: Move get_id_aa64dfr0() in processor.h
Date:   Mon, 31 Aug 2020 21:34:11 +0200
Message-Id: <20200831193414.6951-2-eric.auger@redhat.com>
In-Reply-To: <20200831193414.6951-1-eric.auger@redhat.com>
References: <20200831193414.6951-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We plan to use get_id_aa64dfr0() for SPE tests.
So let's move this latter in processor.h header.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c                 | 1 -
 lib/arm64/asm/processor.h | 5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cece53e..e2cb51e 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -167,7 +167,6 @@ static void test_overflow_interrupt(void) {}
 #define ID_DFR0_PMU_V3_8_5	0b0110
 #define ID_DFR0_PMU_IMPDEF	0b1111
 
-static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
 static inline uint64_t get_pmccntr(void) { return read_sysreg(pmccntr_el0); }
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 02665b8..11b7564 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -88,6 +88,11 @@ static inline uint64_t get_mpidr(void)
 	return read_sysreg(mpidr_el1);
 }
 
+static inline uint64_t get_id_aa64dfr0(void)
+{
+	return read_sysreg(id_aa64dfr0_el1);
+}
+
 #define MPIDR_HWID_BITMASK 0xff00ffffff
 extern int mpidr_to_cpu(uint64_t mpidr);
 
-- 
2.21.3

