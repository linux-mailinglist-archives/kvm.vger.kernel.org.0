Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652611FD0CA
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 17:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgFQPWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 11:22:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34213 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726815AbgFQPWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 11:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592407320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zVWEhzXPRli8YcvMsJuZOhmzlxl40/jDyj4c8Sv7fu4=;
        b=bjX6oLqDsLTtHZEK3XDRZd4NkoyqkFGxLB9fSjb1/XY7f0HDKo5UG3FhHh/kirpQ62aNjB
        +1/hs8wpn0mH13e1KTKKvd1+2+nC9mzKBghWqOqZp2QEVFL3hVkVULIDLrFgvnFw92tZZ2
        0gt+U8ghcaI1jMnXDyMp4Vm72pFVNqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-IljxjI3PNjKj_CeWVvaEDw-1; Wed, 17 Jun 2020 11:21:57 -0400
X-MC-Unique: IljxjI3PNjKj_CeWVvaEDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E6C010AEA27
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 15:21:41 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.196.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5465B75E11;
        Wed, 17 Jun 2020 15:21:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] x86: skip hyperv_clock test when host clocksource is not TSC
Date:   Wed, 17 Jun 2020 17:21:39 +0200
Message-Id: <20200617152139.402827-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V TSC page clocksource is TSC based so it requires host to use TSC
for clocksource. While TSC is more or less standard for x86 hardware
nowadays, when kvm-unit-tests are run in a VM the clocksource tends to be
different (e.g. kvm-clock).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/unittests.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 504e04e5f2b5..3a7915143479 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -334,6 +334,7 @@ smp = 2
 extra_params = -cpu kvm64,hv_time
 arch = x86_64
 groups = hyperv
+check = /sys/devices/system/clocksource/clocksource0/current_clocksource=tsc
 
 [intel_iommu]
 file = intel-iommu.flat
-- 
2.25.4

