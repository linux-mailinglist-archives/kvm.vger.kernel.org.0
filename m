Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4133019A6EA
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 10:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgDAINz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 04:13:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48864 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731982AbgDAINz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 04:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585728834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cU+okLsMKSqHOKUW7pNlWD/YMAsYMmyQn6ZUscB8aaA=;
        b=JIfjUAgavdfZxV8lDnIxQGpcL30vF1IJ9UKRcvaoOKiemSt/2c/i8oyO3uknY9G9oagel5
        Kg9CMq5QYzHpP10hUHGuYfHA6x4chazxKSaY59OPZRse7EsNDQpCK1MHKI/wF35Y+vzEYD
        sq+r5Nh6E1SsV0+jMBXDV5FG1zT2WME=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-r-G_YilxMWm2oxqK3OZFzQ-1; Wed, 01 Apr 2020 04:13:52 -0400
X-MC-Unique: r-G_YilxMWm2oxqK3OZFzQ-1
Received: by mail-wr1-f70.google.com with SMTP id y1so14207913wrn.10
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 01:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cU+okLsMKSqHOKUW7pNlWD/YMAsYMmyQn6ZUscB8aaA=;
        b=AA2yzg6V2d5tcz26u6gd2HNJpk7GL7Imj5UOsKoquZRRJH3O7BVGYR0UeLZq90A+Fz
         BrvRIwxu7YBgj1mNKuqZMbQkVmPGSLAbNYN9l6qXNBQ0LQTgNhqOgo2ACyVzfivm2mFN
         6ZVHPDDl1CqAypYbxaH6KtPzPHeXDiND4LVGqc5/qR1s4nbVTDs99Vi+ExVQhYb4uZKI
         ASUdDwPf0pkzh17srHeoifuKbpYJU4SrlrrAnqszaiBMSOZQ/sXiYSsl+pqMRwjP3tqJ
         pFAAsxqyc9OUbnaBx1cRQBpcJgdwWKk5c9tTl0BQdihRjP+94ifLlhT+5PANUVJKmrf2
         /+ZA==
X-Gm-Message-State: ANhLgQ0yBIoVQvwhtnf5BRYuFB5ckQWVZ4aRl0SUu8ON1pt7D+6qlQAh
        3PGcVcG8D9YEixzHCsiE5rSD4GztjrnrNq7E+4+jy8nNpP/iBQgXliTfRjxVuE9+YoIxM4qx432
        aSOFg+wXzsATA
X-Received: by 2002:adf:82c5:: with SMTP id 63mr24282615wrc.312.1585728831193;
        Wed, 01 Apr 2020 01:13:51 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vulGMjI4Nsim53ni39KXrS3G3GMQJsPvuNJhEQA50Sov48kj3Pwv0cKCOqLAqS/Et+Hnnw+HQ==
X-Received: by 2002:adf:82c5:: with SMTP id 63mr24282595wrc.312.1585728830954;
        Wed, 01 Apr 2020 01:13:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x206sm1662492wmg.17.2020.04.01.01.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 01:13:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: fix crash cleanup when KVM wasn't used
Date:   Wed,  1 Apr 2020 10:13:48 +0200
Message-Id: <20200401081348.1345307-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If KVM wasn't used at all before we crash the cleanup procedure fails with
 BUG: unable to handle page fault for address: ffffffffffffffc8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 23215067 P4D 23215067 PUD 23217067 PMD 0
 Oops: 0000 [#8] SMP PTI
 CPU: 0 PID: 3542 Comm: bash Kdump: loaded Tainted: G      D           5.6.0-rc2+ #823
 RIP: 0010:crash_vmclear_local_loaded_vmcss.cold+0x19/0x51 [kvm_intel]

The root cause is that loaded_vmcss_on_cpu list is not yet initialized,
we initialize it in hardware_enable() but this only happens when we start
a VM.

Previously, we used to have a bitmap with enabled CPUs and that was
preventing [masking] the issue.

Initialized loaded_vmcss_on_cpu list earlier, right before we assign
crash_vmclear_loaded_vmcss pointer. blocked_vcpu_on_cpu list and
blocked_vcpu_on_cpu_lock are moved altogether for consistency.

Fixes: 31603d4fc2bb ("KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3aba51d782e2..39a5dde12b79 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2257,10 +2257,6 @@ static int hardware_enable(void)
 	    !hv_get_vp_assist_page(cpu))
 		return -EFAULT;
 
-	INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
-	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
-
 	r = kvm_cpu_vmxon(phys_addr);
 	if (r)
 		return r;
@@ -8006,7 +8002,7 @@ module_exit(vmx_exit);
 
 static int __init vmx_init(void)
 {
-	int r;
+	int r, cpu;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	/*
@@ -8060,6 +8056,12 @@ static int __init vmx_init(void)
 		return r;
 	}
 
+	for_each_possible_cpu(cpu) {
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+		INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
+		spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+	}
+
 #ifdef CONFIG_KEXEC_CORE
 	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
 			   crash_vmclear_local_loaded_vmcss);
-- 
2.25.1

