Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEFE31ACA0
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 16:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhBMPda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 10:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBMPd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 10:33:27 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F79C061574;
        Sat, 13 Feb 2021 07:32:46 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id e15so1905974qte.9;
        Sat, 13 Feb 2021 07:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aPNiAFSqGubBl+g6zZSnfdiPci9YUIDPO5OPK2PIv7A=;
        b=kYskrqxNavsZf/AJgDpl4C8BOguF2R5HEewIyHxRfSl1t2YrXv4tdgRK8fkTkNZ/dj
         lbF2VoW4IewHowoTvx1GjViA+W0oYN5dtcjf1TykTmYUAnUXY/5JrmkPcJNiFT3GdthM
         AlU7ENS0+6hUNyJNsgRDYBE1SkYocsm9ytf4c3FhjG7/tUqKYuxDb+wKMojdMyMfg+pn
         uwHCQEB8RNJ4EX+TggV81UgBbVYBvJ6h3OMQgQNBzj2i53K1TeRD0EK8ysloacCTAutW
         Xd/lBGIcbh5QC7KPIUH83dL3WgXV5r8ow3fO6tyhSwYZ6unFr38T5BsdeqkRJ9zuzZ5D
         FI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aPNiAFSqGubBl+g6zZSnfdiPci9YUIDPO5OPK2PIv7A=;
        b=o32CjniqusbmOXXZrA2jsg1yAT4wkGyf9yzbu8e+PuT0A9d8oa9jigmHOjvhPM7Ecw
         IPLKHsOOfEMlQF4hgXGtZwwubVZOww0OTIMOgGsutBhSBD5E94W3eALTRmqJCA0srEPn
         4uTVkVgbnNDtt1IGVU4a4KZFnluYnDZLLElPIdd9HhfOrZa4hHjlUSWpGuRE/BfLWWKd
         iXj8sonsJtXw/EPksmUZWgHwQYHDOtTlrXvsuTe5l2CA10njdoE9jnEm2ryDDMfmcOXZ
         Mp2MoOjc/MndEX6GaQJe9Et9UxJBK1EsvAwlv1ZTohm1Pfc5wP4uy5SrGbRJoS5L2IYc
         xv5w==
X-Gm-Message-State: AOAM531TBAjAt78pe2dHo/bMGV7ye/1vqKjGSLPmEYoKsBY0ZowcTi4n
        s7LRDU4kcBcfW+A9+lf+bkw=
X-Google-Smtp-Source: ABdhPJwMr1Wei88g5Xh7RlX+z1UVfs29ZUxTQEwjEWIm8B3AQ7CK122kZD8OQppjy+tjarjI6HfDNw==
X-Received: by 2002:ac8:35d5:: with SMTP id l21mr7307551qtb.59.1613230365219;
        Sat, 13 Feb 2021 07:32:45 -0800 (PST)
Received: from localhost.localdomain ([156.146.55.129])
        by smtp.gmail.com with ESMTPSA id d1sm7514332qtq.94.2021.02.13.07.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 07:32:44 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] arch: s390: kvm: Fix oustanding to outstanding in the file kvm-s390.c
Date:   Sat, 13 Feb 2021 21:02:27 +0530
Message-Id: <20210213153227.1640682-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


s/oustanding/outstanding/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index dbafd057ca6a..1d01afaca9fe 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4545,7 +4545,7 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 		/*
 		 * As we are starting a second VCPU, we have to disable
 		 * the IBS facility on all VCPUs to remove potentially
-		 * oustanding ENABLE requests.
+		 * outstanding ENABLE requests.
 		 */
 		__disable_ibs_on_all_vcpus(vcpu->kvm);
 	}
--
2.30.1

