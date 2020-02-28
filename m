Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28096172F40
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 04:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgB1DVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 22:21:06 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42976 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730569AbgB1DVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 22:21:06 -0500
Received: by mail-pl1-f196.google.com with SMTP id u3so650584plr.9;
        Thu, 27 Feb 2020 19:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rIXCm5M81d91xnd3Gd+yipbJxz4KGDW+jKNm3v5D9gk=;
        b=XPn2INuxdUtQeXgF2JFagwKBhjD8Xu8RwD86VmOBcImn8OPYR+JMgLyfejr2lHKd+/
         RTCuZ/a57sQcuv5TgR9DV9lQ4aYdZgWEPVyuPstCbC726RYaGUjhA5t/KlSYYOAIPPUb
         E8MKSpqmDjdpIhqi2iEU2OYzirWW1385QP2mFEIjkii/a5EKOniWHB+wkyHzNFaELsGL
         7eYRTXzVFf1612T8a75KvCicWXEn+ukYqvKUo7heiFg3YtpoAE/lNg3IvgKfCYNfglLz
         m8b678AX3VhxQlhH3IXXVkyG/sZUhV5IolwQRNX6r/BrrUNG5aoLm9U2JI8AsnhjKbe1
         v/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rIXCm5M81d91xnd3Gd+yipbJxz4KGDW+jKNm3v5D9gk=;
        b=lQ6mj8+2rzj7akAVwBd/F0gIymOrIXE2vCily71DFC3pQSEyJMuN7wH3WkK8ogBQNC
         nHAHVqvewlyMUnmO5KbwLVNvn6AKdkqsnNQg8t0lLS6pFaf5/+BBnVqZOjGSV50i9dJG
         Mtsv95WxakDqsXFFnwceoyF/IkNttPSjywX1AUrf/YtbM0tGUW+jW/WsRMIZJ9CcMau3
         o4BmdEODSNjnyVwWdZAK0VPbmBDTJZthsFssIQAZ9D2ESqAmvfEriKWHHB3F3Uua02Iv
         /n1sKavh1iqSPdAxglgyMrM166yY4+fjgXVMHzxix+P8TyU8IHY78PsLnP0XORKU3u6+
         CV0g==
X-Gm-Message-State: APjAAAWzd/+uEFB3jSiNo6Xu+xFQhtiy43e4Bf0nNkETclOlN4MgMCgo
        2184pK8crL9xXgEgeXl8I4m5bP/szQvl8A==
X-Google-Smtp-Source: APXvYqyRTgQvWLHeivT3wAVpwiccEkXlX8bq7fFjVmzw+54PY2Cu3W1F3m7+XFt7JuJPSrLQZCi7AA==
X-Received: by 2002:a17:902:8a8e:: with SMTP id p14mr2022551plo.28.1582860064936;
        Thu, 27 Feb 2020 19:21:04 -0800 (PST)
Received: from kernel.DHCP ([120.244.140.54])
        by smtp.googlemail.com with ESMTPSA id b6sm8854260pfg.17.2020.02.27.19.20.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 27 Feb 2020 19:21:04 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3] KVM: X86: Just one leader to trigger kvmclock sync request
Date:   Fri, 28 Feb 2020 11:18:41 +0800
Message-Id: <1582859921-11932-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

In the progress of vCPUs creation, it queues a kvmclock sync worker to the global
workqueue before each vCPU creation completes. The workqueue subsystem guarantees 
not to queue the already queued work, however, we can make the logic more clear by 
make just one leader to trigger this kvmclock sync request and save on cacheline 
boucing due to test_and_set_bit.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * update patch description
v1 -> v2:
 * check vcpu->vcpu_idx

 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5d64e..79bc995 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9390,8 +9390,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (!kvmclock_periodic_sync)
 		return;
 
-	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
-					KVMCLOCK_SYNC_PERIOD);
+	if (vcpu->vcpu_idx == 0)
+		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
+						KVMCLOCK_SYNC_PERIOD);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
2.7.4

