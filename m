Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C9C1725D9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 19:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgB0SBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 13:01:24 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36505 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbgB0SBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 13:01:23 -0500
Received: by mail-wr1-f65.google.com with SMTP id j16so3028709wrt.3;
        Thu, 27 Feb 2020 10:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E8ZWbS7tq2JVdfpTRDo8i0zrwTusfBz0dP/4sGTaYhE=;
        b=CacxHc1sX0lFECQt6xnPa7ab2DoBIXez7pUXgytY0T13W9k/YHrXteFuXYxvWcEtUL
         baWCq6Qjq1ofXIkAixN4zKjzxO6kA2z+bqxFXH8Qw+yoLwofFIeaEp+/Jhj0lWX//7nP
         sh8h/bX6nea9yMt/EZENdgjMMRbGV5qEuFHjj+kvap62I/5xBlT6LYb1aTH80jUYy1HR
         VDdb5vmtm8ksc5UEndBJRQAMSg24SVWx7f/g8HHE8is4YiwD/z7UU0sR1DXLe+pYvVqt
         Mvzcodidc1E5Fy+gWW11vodldtQoIjasP1oQkbE5JcCrt6u5hH+rlyviWCD2rJ0XH7tQ
         BzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E8ZWbS7tq2JVdfpTRDo8i0zrwTusfBz0dP/4sGTaYhE=;
        b=WheFHmimv/nuAhsWh7A2xLg4Lm8U/Nwwj1CoHiR2v1oUXJlaT+eH50OstMp1jtx82D
         XCzI2+IUkerkqYYl6/IAVLLIRZIQNZC+Pf6P0+8NXnyX6UZgL0TO+ZrYJyakKld9x1y7
         +br0PT+vWEaLTmbhSdRy8jq2OuJKe2/qPOH2/RfedOCOjAvbNkAmvsfjVKQs0v9Q6zL/
         ResmSbEdjYhWZpPw5iVMFGlRI/LdcCy2bikjfeS88REyUKvjbxx9eNgGwB3XUABU64uY
         rgzaAVn39D4zsQPlgL5ZGJ4nW4KgvY6LMvlG+Bn8S36mQSHDjHz7bL3PVWbUSZ+2dvGV
         OzLQ==
X-Gm-Message-State: APjAAAXpCmbvqok6pnV6T3UjzIelgMsxf9uAX1zdr/z6/Ihpz9LBDuAf
        qm76eupUyhXxVK8BvgjRdss=
X-Google-Smtp-Source: APXvYqzd3Adej9lxNHdKHQ4vxXxVbjCB5TS6CY9IBBvPvHdwJ/a5fmSIuHpqkTy37ODZrIE+SJGI8g==
X-Received: by 2002:adf:ef4e:: with SMTP id c14mr35395wrp.335.1582826480343;
        Thu, 27 Feb 2020 10:01:20 -0800 (PST)
Received: from laptop.criteo.prod ([2a01:e34:eecb:7400:6cb4:8756:33ca:8626])
        by smtp.gmail.com with ESMTPSA id b186sm8582287wmb.40.2020.02.27.10.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 10:01:19 -0800 (PST)
From:   Erwan Velu <erwanaliasr1@gmail.com>
X-Google-Original-From: Erwan Velu <e.velu@criteo.com>
Cc:     Erwan Velu <e.velu@criteo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH v2] kvm: x86: Limit the number of "kvm: disabled by bios" messages
Date:   Thu, 27 Feb 2020 19:00:46 +0100
Message-Id: <20200227180047.53888-1-e.velu@criteo.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200214143035.607115-1-e.velu@criteo.com>
References: <20200214143035.607115-1-e.velu@criteo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In older version of systemd(219), at boot time, udevadm is called with :
	/usr/bin/udevadm trigger --type=devices --action=add"

This program generates an echo "add" in /sys/devices/system/cpu/cpu<x>/uevent,
leading to the "kvm: disabled by bios" message in case of your Bios disabled
the virtualization extensions.

On a modern system running up to 256 CPU threads, this pollutes the Kernel logs.

This patch offers to ratelimit this message to avoid any userspace program triggering
this uevent printing this message too often.

This patch is only a workaround but greatly reduce the pollution without
breaking the current behavior of printing a message if some try to instantiate
KVM on a system that doesn't support it.

Note that recent versions of systemd (>239) do not have trigger this behavior.

This patch will be useful at least for some using older systemd with recent Kernels.

Signed-off-by: Erwan Velu <e.velu@criteo.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 359fcd395132..c8a90231befe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7308,12 +7308,12 @@ int kvm_arch_init(void *opaque)
 	}
 
 	if (!ops->cpu_has_kvm_support()) {
-		printk(KERN_ERR "kvm: no hardware support\n");
+		pr_err_ratelimited("kvm: no hardware support\n");
 		r = -EOPNOTSUPP;
 		goto out;
 	}
 	if (ops->disabled_by_bios()) {
-		printk(KERN_ERR "kvm: disabled by bios\n");
+		pr_err_ratelimited("kvm: disabled by bios\n");
 		r = -EOPNOTSUPP;
 		goto out;
 	}
-- 
2.24.1

