Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E268C2180C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 14:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfEQMNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 08:13:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53087 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbfEQMNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 08:13:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id y3so6743564wmm.2;
        Fri, 17 May 2019 05:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=aDe4WefbxGIBtvtccZHYzwFMvx7Jk1IWn8lyxDHSymk=;
        b=eVAkEEE1W6z3X/C/A6bR7CDafk66r+lGump+hYlNLoeaLcN87GuhIUd4c27E2pBAGL
         6NgrhYEQnb7bigIho7JPTQ6AexmiNcSYSqQmo5gkAfHmHZwrVukYe/I4TLMf4YUFTg96
         5N3gjmwnQMtJ+5OZ8hNi1P8eQ3bt8zb21gJD6/H85IiK2ZtWBWi4qfI9gXr7y3tf6x04
         bAS6LnZFxhoqA45hbamRdBHYucIWsVJ42N9e8Sey+txlhU5pOlpDkCxud7qWN7UykiUh
         3DWNnF/yVEnXOUq9vkkOx+oNlcb2Zb/h31FkNnXPRWDSYv3A7MIgGZqiBZfXoHvmSVLG
         OFwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=aDe4WefbxGIBtvtccZHYzwFMvx7Jk1IWn8lyxDHSymk=;
        b=WHO2POYW14z2ZbC9V7up2nwpymKDaRuk6Pje+7JPX/ewahPgxYUSChtjS3Ti7vhztO
         jHeNZAd4/yEsSjjgsvfkqlTW8LyK3Tu0zoU+dqLuiWych9TIYWZ/5geB0afnQxblzq4n
         /GzyXUPISPRCrQO+sTInvXWayDy6WId7/aI6NvUkOpSKRkf+9DPRIx0ZszHi9LBrRDF/
         qN3BRMs/gZnxQW0R2wsSV7sZ9I0aajhaC8I8FmZF2siDVllFNE9GDX6uyALGkLqjWPWF
         7mDjGU51FyVGr6jv7/DO3zT96XM3dY6RaE3Uz9AdlnAv1melkM/6uICG0p7KHN6lA0S2
         YGKA==
X-Gm-Message-State: APjAAAUAaslH0Q5QN/YNsmmjFKq3DPui9SWLog4fYXtZeLY0Uj2hZhJn
        ZdCDcks433fU/TwpWIk3YKojCxzRYYc=
X-Google-Smtp-Source: APXvYqw+/wqZ6HgBsx9b8ttbYySUxHL/ilEeNwtBZHrXSmj+ikC8TON/0VI0LKNP4MliT6dQWEi4HA==
X-Received: by 2002:a7b:c5d6:: with SMTP id n22mr1949875wmk.112.1558095219277;
        Fri, 17 May 2019 05:13:39 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id e12sm8327265wrs.8.2019.05.17.05.13.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 05:13:38 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] kvm: fix compilation on aarch64
Date:   Fri, 17 May 2019 14:13:35 +0200
Message-Id: <1558095215-43363-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit e45adf665a53 ("KVM: Introduce a new guest mapping API", 2019-01-31)
introduced a build failure on aarch64 defconfig:

$ make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- O=out defconfig \
                Image.gz
...
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:
    In function '__kvm_map_gfn':
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1763:9: error:
    implicit declaration of function 'memremap'; did you mean 'memset_p'?
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1763:46: error:
    'MEMREMAP_WB' undeclared (first use in this function)
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:
    In function 'kvm_vcpu_unmap':
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1795:3: error:
    implicit declaration of function 'memunmap'; did you mean 'vm_munmap'?

because these functions are declared in <linux/io.h> rather than <asm/io.h>,
and the former was being pulled in already on x86 but not on aarch64.

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d22b1f4bfa56..34afa94f0183 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,9 +51,9 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
+#include <linux/io.h>
 
 #include <asm/processor.h>
-#include <asm/io.h>
 #include <asm/ioctl.h>
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
-- 
1.8.3.1

