Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF61D4369D8
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhJUR6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbhJUR6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 13:58:21 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0F6C0613B9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:56:05 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id j6so1346914ila.1
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NIb28jF9myhlHii521Fi0CnKe3S439N9mgqsB6OzrQ8=;
        b=Vqv0+pNvyRpRjKj7UdIrKSR2qBY9wFtJnM6i6fUi4B7RfS3eTjyorUo2UfqVZnL2Er
         Gwnmmd1+P/dhgpVRTerixbgXYbj1l+VRRa9TtOVGzIS3MHbHhlQj7xBTzzP4Fc6IPDIM
         5ev/tvmqsfwz7IHLFeWUlRzDg+gKDpJ3wIMTw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NIb28jF9myhlHii521Fi0CnKe3S439N9mgqsB6OzrQ8=;
        b=PjTFg849GDQ1xp/2ICGtzDzm3z4f4xB1nTj/m+LY2J5I5FUPSC98PP2Rg6jwS0b4vD
         6xWcTocc87Qn6oz7lGlZ8xlAgKj/prAcL0+O6fGAktSRUPVXkvjQLwRvxAIcDeFJ99p/
         FJjuRZsXDSJITebl9j9cj4GaFh+tPVLtxL8efxZR8Pnc+clAT6HzFX2XdFBA1vOHxW72
         K1p7R4o98rJZtv8GsURnJ3f1YICr0ia5JdPYyv2OXHzJVdKyb+eimntYClhIiOp5FWNJ
         n3nJFIcBGM4VEcBdFkzWAjclH/RYz6kx9mqYA50x0hqkao+//jJrPf58XkHdvLEQ5xDC
         nEHg==
X-Gm-Message-State: AOAM530jqjHYa9jH/p1vuFFgFoHpKaZvLmg2QC3IcrWWA2o/qVgyCuzY
        XHl3czG2uoI1ou4RgnMT9sbgybV/WOs=
X-Google-Smtp-Source: ABdhPJyzIUMx6SkKLw5EjpXmNVNI136gxC++lNpOVzgsGneg+Co6eDrOuIdS5bAy2jGysdSmYswXnw==
X-Received: by 2002:a05:6e02:14d1:: with SMTP id o17mr4620494ilk.57.1634838965135;
        Thu, 21 Oct 2021 10:56:05 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id n3sm3201743ili.37.2021.10.21.10.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 10:56:04 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     pbonzini@redhat.com, shuah@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftests: kvm: fix mismatched fclose() after popen()
Date:   Thu, 21 Oct 2021 11:56:03 -0600
Message-Id: <20211021175603.22391-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

get_warnings_count() does fclose() using File * returned from popen().
Fix it to call pclose() as it should.

tools/testing/selftests/kvm/x86_64/mmio_warning_test
x86_64/mmio_warning_test.c: In function ‘get_warnings_count’:
x86_64/mmio_warning_test.c:87:9: warning: ‘fclose’ called on pointer returned from a mismatched allocation function [-Wmismatched-dealloc]
   87 |         fclose(f);
      |         ^~~~~~~~~
x86_64/mmio_warning_test.c:84:13: note: returned from ‘popen’
   84 |         f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
index 8039e1eff938..9f55ccd169a1 100644
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -84,7 +84,7 @@ int get_warnings_count(void)
 	f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
 	if (fscanf(f, "%d", &warnings) < 1)
 		warnings = 0;
-	fclose(f);
+	pclose(f);
 
 	return warnings;
 }
-- 
2.32.0

