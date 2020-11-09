Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8122AB3E6
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 10:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgKIJqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 04:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgKIJqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 04:46:00 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C27C0613D3
        for <kvm@vger.kernel.org>; Mon,  9 Nov 2020 01:46:00 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id k2so4555397wrx.2
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 01:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OUYrJMZKmRU5gfzMdZni/PewvUwFGv/yOXLZtLqq/rA=;
        b=Rym4zP1Gy212Y6DC8Ti9e67ZFiG8o9H/mun5p3eVP/l4unpQXp/SCMc0Y8PVbSUN98
         kAb8p6pKNT39Bdaw9Lok8Pk8clFS3Z5J6eHks8SHPVayOLB19Ew8ryEUY0GfP6Q6Pzov
         Ef8y87K0rjeWrtgyqSe1EcCDTpZ3F9fNmcXZBk4xV6+Naf7HzsJfdTa4kp+/0Tpqso2z
         Xjo3yVR8AA9FhhZaUtmfJhvq2yJ3rYPEHtjoAbOkDgK+j0IuzzbszzVOJ1TgcCQidyX0
         GXnXmusnOxIw/+DdU5w5yeYNDNsoz66Vr35hL6TJ74Rfztu3EgQpoX1/wPqWe9foe3BJ
         ocqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=OUYrJMZKmRU5gfzMdZni/PewvUwFGv/yOXLZtLqq/rA=;
        b=BoYIGlKHi0cYgw9Ozi9uiUow+7vcSt2iCBq2j9b73mthuRSnuzMw4DP2gsYmqJKEox
         G+GqtdGY0sxzivJys2Un7cmfRO/0unvtOIlmzjCyXrBlH60uR5F4oelbO/jKqKo7cOXQ
         kW4bKw5bGCzwjOdW2fyeMmhX7VjytFnMI1+yYvP/gR4ZNUSSLY4DcImMrhUkGgsSDpxk
         VCXzubj1aT4IHLfKCL1mObqhyu4AA5ykjRGYt9D8dfGYyFK8R4D2Z8gB4e/ynlkPUuKO
         Cro/AyG0gRSTiCFGTj315iwT/MVzf+gzvaNl/akEntWNROMaoFIAf7V2VDA/yk2YjWcW
         cPhg==
X-Gm-Message-State: AOAM532WQqupGv4dPMuV8Q4x8qnwiz1YypXkNs4r200butXPw1NJnZZA
        CHohHJ2RQbYvnd7bgb/mpoQgnqqmOBU=
X-Google-Smtp-Source: ABdhPJxt5z9bdv9Mv9Zt4CoeM7KloJcC+UEmkeSWlobZoei3yRhyzsB5igE5vQS+QtJ4sEWc1Ys7xg==
X-Received: by 2002:adf:8465:: with SMTP id 92mr16122883wrf.50.1604915159327;
        Mon, 09 Nov 2020 01:45:59 -0800 (PST)
Received: from localhost.localdomain (234.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.234])
        by smtp.gmail.com with ESMTPSA id a17sm12837504wra.61.2020.11.09.01.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 01:45:58 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 2/3] accel/stubs: Restrict system-mode emulation stubs
Date:   Mon,  9 Nov 2020 10:45:46 +0100
Message-Id: <20201109094547.2456385-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201109094547.2456385-1-f4bug@amsat.org>
References: <20201109094547.2456385-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This system-mode emulation stubs are not require
in user-mode binaries. Restrict them to system-mode
binaries.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 accel/stubs/meson.build | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/accel/stubs/meson.build b/accel/stubs/meson.build
index 12dd1539afa..a83408bc0a7 100644
--- a/accel/stubs/meson.build
+++ b/accel/stubs/meson.build
@@ -1,4 +1,8 @@
-specific_ss.add(when: 'CONFIG_HAX', if_false: files('hax-stub.c'))
-specific_ss.add(when: 'CONFIG_XEN', if_false: files('xen-stub.c'))
-specific_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
-specific_ss.add(when: 'CONFIG_TCG', if_false: files('tcg-stub.c'))
+accel_stubs_ss = ss.source_set()
+
+accel_stubs_ss.add(when: 'CONFIG_HAX', if_false: files('hax-stub.c'))
+accel_stubs_ss.add(when: 'CONFIG_XEN', if_false: files('xen-stub.c'))
+accel_stubs_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
+accel_stubs_ss.add(when: 'CONFIG_TCG', if_false: files('tcg-stub.c'))
+
+specific_ss.add_all(when: ['CONFIG_SOFTMMU'], if_true: accel_stubs_ss)
-- 
2.26.2

