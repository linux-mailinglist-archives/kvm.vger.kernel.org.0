Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA13E27CAF3
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 14:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732533AbgI2MXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 08:23:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732524AbgI2MXW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 08:23:22 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601382201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+59t8nhMuIvZqQRatGY9+VNUbMSmHZDTpsf5ZrAqbOE=;
        b=V7si+Mopbr7urZM3cNNK2VQUspQdHra8xSIu8g84y29Ne8Iz8mJBewqkJCFHUI1a8vsN8m
        qYyqN/cPEHZtlOqdUhhLADCA7EJYZETydOtbQk249OT40YF8tVOFNHsc5BGiEUK3SPQCov
        26ZziXuG+2UoBWBN10xbX1Na5VgiUiY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-01Y-MrgTN7eWG29kUhKGzA-1; Tue, 29 Sep 2020 08:23:19 -0400
X-MC-Unique: 01Y-MrgTN7eWG29kUhKGzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0143510A7AE1
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 12:23:18 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8BB760F96
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 12:23:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] runtime: SKIP if required sysfs file is missing
Date:   Tue, 29 Sep 2020 08:23:17 -0400
Message-Id: <20200929122317.889256-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes the test once more, so that we correctly skip for
example access-reduced-maxphyaddr on AMD processors.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 scripts/runtime.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 3121c1f..f070e14 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -118,7 +118,7 @@ function run()
     for check_param in "${check[@]}"; do
         path=${check_param%%=*}
         value=${check_param#*=}
-        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
+        if ! [ -f "$path" ] || [ "$(cat $path)" != "$value" ]; then
             print_result "SKIP" $testname "" "$path not equal to $value"
             return 2
         fi
-- 
2.26.2

