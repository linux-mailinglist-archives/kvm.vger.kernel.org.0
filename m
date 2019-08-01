Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1147D606
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 09:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfHAHGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 03:06:43 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37510 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHAHGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 03:06:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id d1so775428pgp.4;
        Thu, 01 Aug 2019 00:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sFn82hxl87C8fXjzpueTy3TJLhnUknUHXDSSwlywkZM=;
        b=KA02C6/qRIwz7yk/cKlSKNW3Uh+6uNkHC4I3NyeEDdsrwD6UNzo/7hpOrKkiMs6XJy
         liwhh/Nh1bWSAZ/7DK6JfdNt/BKoNm1up/PxL/FbPZLhcHM+/XggJl3nfBOyIdTTAUUO
         +zeChb37ERCZdxksbacxo8JtVEDROXM9npygMwVbKkCXIABR4Tsk+UljplGXBVF/ltqj
         Hm8N/dFoSBvVJMphXknCnKTuUKdAHX+6IgKpt4BR6YnD08YXbBje2sMzDuwns0p1CHiR
         ZLc8Aba3rn9TvVuoyFRi/Z5EMWOxj1k5lN4zSxIO6H7Q9Qb+x7Va/S+gsdg3g693EdgZ
         BWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sFn82hxl87C8fXjzpueTy3TJLhnUknUHXDSSwlywkZM=;
        b=Gq2GdODuFnbcbx0bLnnBSOmi7AZDZdJGa3FZyfHDo1zcMQhvlIWQa6ul/2FJ8fIY9m
         v31KioxxkAnu13js4GDmHaVv5kS0+IHBvvnbZWpoTXVJ4dk8rsOnbY2hOLybhS6MDyUK
         b+9Ko3qWIXBYuPKtt3/4wNdi9MDLZfxWQCt2hUOY3nE/lBqHraoMmB+sxrc/kdYikaAj
         CHgTYqv9wLmkWPgGCnlef49XAjUdu9uGzGFLOg9+5bLq5Up6YodzlRGCBjooQTQ5a7wI
         Khi4zJ3WiGfVgiwH0RpWw8uqjVGms265+ttYy64FY50AbLWdLaiFnuiZDSkNkUSrrv6u
         H5FA==
X-Gm-Message-State: APjAAAUfO3bqmxNjJRM0hofxLzwMcz3rKvLi6e5asrJXZEiaFNT5nUSD
        mgUZNAb9N3GzG2JJVmUvo+XYnVXG4bQ=
X-Google-Smtp-Source: APXvYqyn219JPDPAJnEN8l24Z8CENaXeYWt1+yJwSOyfhTF9EIK66+hk9n2gnvhVYiytQzdxdpGY7A==
X-Received: by 2002:a63:3ec7:: with SMTP id l190mr120885775pga.334.1564643202178;
        Thu, 01 Aug 2019 00:06:42 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id j6sm9688175pjd.19.2019.08.01.00.06.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 01 Aug 2019 00:06:41 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when dedicated physical CPUs are available
Date:   Thu,  1 Aug 2019 15:06:36 +0800
Message-Id: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The downside of guest side polling is that polling is performed even 
with other runnable tasks in the host. However, even if poll in kvm 
can aware whether or not other runnable tasks in the same pCPU, it 
can still incur extra overhead in over-subscribe scenario. Now we can 
just enable guest polling when dedicated pCPUs are available.

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 drivers/cpuidle/cpuidle-haltpoll.c   | 3 ++-
 drivers/cpuidle/governors/haltpoll.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index 9ac093d..7aee38a 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -53,7 +53,8 @@ static int __init haltpoll_init(void)
 
 	cpuidle_poll_state_init(drv);
 
-	if (!kvm_para_available())
+	if (!kvm_para_available() ||
+		!kvm_para_has_hint(KVM_HINTS_REALTIME))
 		return 0;
 
 	ret = cpuidle_register(&haltpoll_driver, NULL);
diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 797477b..685c7007 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -141,7 +141,7 @@ static struct cpuidle_governor haltpoll_governor = {
 
 static int __init init_haltpoll(void)
 {
-	if (kvm_para_available())
+	if (kvm_para_available() && kvm_para_has_hint(KVM_HINTS_REALTIME))
 		return cpuidle_register_governor(&haltpoll_governor);
 
 	return 0;
-- 
2.7.4

