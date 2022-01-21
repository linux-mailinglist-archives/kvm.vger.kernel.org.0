Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CA2496227
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381580AbiAUPeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:34:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351194AbiAUPeM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 10:34:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642779251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y1ioxiY0W+l8y9N8AdRsRcG1WEE9kw4DY0kAF9kd914=;
        b=X9KUHy+ODygmrt24LWeBcN9S9u0eV2qWZNyRK2nIJkvuzb38E9tDxkbxbySoZ9jjDE3wPm
        s4mJS7eKBvCEtPbfrl8lBPwH/VBp89G/RLVSdN3cZXpW/daZZkoyHI1/W6Sb/7Y+eIIk+e
        ALUl0C0JBlL2Wmjx4p4/dYfvT1MCy/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-vrAVhqKEPfWLkDL3Sr36pg-1; Fri, 21 Jan 2022 10:34:10 -0500
X-MC-Unique: vrAVhqKEPfWLkDL3Sr36pg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7464084BA64
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:34:09 +0000 (UTC)
Received: from virtlab612.virt.lab.eng.bos.redhat.com (virtlab612.virt.lab.eng.bos.redhat.com [10.19.152.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10F9410A3BC2;
        Fri, 21 Jan 2022 15:34:09 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] vmx: Fix EPT accessed and dirty flag test
Date:   Fri, 21 Jan 2022 10:34:08 -0500
Message-Id: <20220121153408.2332-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If ept_ad is not supported by the processor or has been
turned off via kvm module param, test_ept_eptp() will
incorrectly leave EPTP_AD_FLAG set in variable eptp
causing the following failures of subsequent
test_vmx_valid_controls calls:

FAIL: Enable-EPT enabled; reserved bits [11:7] 0: vmlaunch succeeds
FAIL: Enable-EPT enabled; reserved bits [63:N] 0: vmlaunch succeeds

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/vmx_tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3d57ed6..54f2aaa 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4783,6 +4783,7 @@ static void test_ept_eptp(void)
 
 		eptp |= EPTP_AD_FLAG;
 		test_eptp_ad_bit(eptp, false);
+		eptp &= ~EPTP_AD_FLAG;
 	}
 
 	/*
-- 
2.31.1

