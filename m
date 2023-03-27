Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF4D6CA45D
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjC0Mpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC0Mph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:45:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D437A3583
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:36 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso11723140pjb.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PpTzbMH90nuCbMjFAXk2bMe3gXvv0QmXPsT0AcaRz3s=;
        b=IkbW1MPv6KEm1msEzQrCWRtsPTtcnIqtTNS/thWCQE6gia8r2dLwjR5rD/AduQGs5M
         sI48rtq8QvmU9ZDUpU/mxsIN4ypu/WtyjWI+d+uxhE2pZkFpAy5yaoDXTf/lAmq3LOFD
         MNW85UQq0meg7a2JbyluKGSGO+682E928NcSBfRxJw23lglCL8DiP4aaCxw3gHjZGbBz
         sLlIubqjzTzWzLCPN5RlG3Vp8IrKY9lzhznQn8AZ3hRWV5eZtAALNwtl/aSN3SEaouCj
         YZuYGrnlD5wonITvJQommGEcNECDBDCzPwvx7XdSmlwzuCPbt8HXlsV1N5FyminnSMnX
         9pow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PpTzbMH90nuCbMjFAXk2bMe3gXvv0QmXPsT0AcaRz3s=;
        b=tNTA2MGrZnELzRZdcsRTJQaAZB8mw3NVQ/6C+mOm5rUwn/v8fd/CqKxiVyS8qkx5M/
         bJvvAZqVfO7TayOnflCmeq+ibAn7RnN/AMHvH+6UrfSXGrEwNCbT1CNyn64L8omusTeB
         d/KSNU2rwF/2ThqEaHF+7AwEdeTJMhD4mL4x6rdCB07aKgw6ptYVNV9g1EK59+vB5rCW
         R/lJmBTAczP/ypgDZ9xxEwlSKn6H01WLjKteIUIrrZno6GiBJKOmI6Rgdpk85EihoBP5
         HbMnKW0nFRYXeaoLMbX+nFwNmEGnNRns4S8EGRgyjx3TN1PoDJH9mMGwVs2TdBbeZaC1
         5Cpg==
X-Gm-Message-State: AAQBX9cmZSYYt32AxJiHJp+v4Toh36kp/cgiQ9vRbaRRozsteKfL4fQ1
        zIqP+0H3A1S6hPTy9G9SqYCGxHYiBDk=
X-Google-Smtp-Source: AKy350Ys9+sy3qay/A4osnxqbLBpaOg7QfgIQGCXXJVLpDbyCI8IS4fJ1/iP285iIlTJ8KQSQGdOdg==
X-Received: by 2002:a17:902:c9d2:b0:1a1:a9a4:ba26 with SMTP id q18-20020a170902c9d200b001a1a9a4ba26mr9222927pld.8.1679921136153;
        Mon, 27 Mar 2023 05:45:36 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:35 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 01/13] MAINTAINERS: Update powerpc list
Date:   Mon, 27 Mar 2023 22:45:08 +1000
Message-Id: <20230327124520.2707537-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM development on powerpc has moved to the Linux on Power mailing list,
as per linux.git commit 19b27f37ca97d ("MAINTAINERS: Update powerpc KVM
entry").

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 649de50..b545a45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -79,7 +79,7 @@ M: Laurent Vivier <lvivier@redhat.com>
 M: Thomas Huth <thuth@redhat.com>
 S: Maintained
 L: kvm@vger.kernel.org
-L: kvm-ppc@vger.kernel.org
+L: linuxppc-dev@lists.ozlabs.org
 F: powerpc/
 F: lib/powerpc/
 F: lib/ppc64/
-- 
2.37.2

