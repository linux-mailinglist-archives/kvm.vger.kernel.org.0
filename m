Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07EC2161E74
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 02:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgBRBTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 20:19:32 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44771 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgBRBTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 20:19:32 -0500
Received: by mail-pg1-f195.google.com with SMTP id g3so9970574pgs.11;
        Mon, 17 Feb 2020 17:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wdl63vLkZeTCO6cEhD7wb/Lt5+ras5GaQCOoaNINnOw=;
        b=ayxtwJaJbgP+QbO48qMs3x/NxRg1vDVDmL+gjWbxxaU3tI1Qh0trNJeYSdUeIkwXV4
         o4kD+UFWcT1uRG+LyO5jEAYfnr7gicrHdPZKy5hAORerM3yZ3dDeEGG4tkPmKL9YNKCk
         SjzmUR+5goMb7yJGKwPp3qarq9+Po7GmxbG000fR3pdqpp77U3BiGO422VbQB2zaCRPE
         vK7YImQV8c47x9QWXmB6GiS8+mQbMwv0qn+9RBfh3i0LZhGUedl/CgzinjFL6jeimtwj
         OhqHvDPE/+ofCJO6OceQIJeYQj8MgTOgY9vwIJy00Yg7FmzRnIBB6dGAmW9+4IsH3Ml7
         4SLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wdl63vLkZeTCO6cEhD7wb/Lt5+ras5GaQCOoaNINnOw=;
        b=OoGDXkMYUuF7S+0h8u5MYYB7Ce2vN4hUK1cDkbrpK1eQklWkQ6FQGZLB2dqq1GU6ep
         0WpxU7L1gLLQbty50Bnvq5hojJ9KT5p+i1vxlrRyAZq818vVOcu++bquy6AoCpWF90Sl
         s0wJd1FdLdyJfRiR16qLLDWurmT4QFwOrlBbZy0DjI8Dw/nACpd9VCmMM24TuoZKj/Eh
         G+FIuyZPiA7M5lQWAu4MzLiuITURs5U19MveksBL4yS0IWn0zr5jYb91wkq8CV4l+JVG
         H+tYpXcILhibxErLGG0U0hq0rJAzKGQzfqvUql7/gFPa7G/QAOpqmDyPM/YHrSgVwmiS
         H4HQ==
X-Gm-Message-State: APjAAAVoYC+nTW6hOB0kwM/SB5P/T9Z4QWzh29HrygmB3YbexBdDiS6G
        95SaI+7JaYtRaXUxHtuOk6Ldhx9YlnUEZQ==
X-Google-Smtp-Source: APXvYqx5VtdeS9U5CVkgXTZIeohJKxNEj2BmCVl/+Xi8BV5uynYvo/WGPRsqNJSsSroxYkw0Q5MYrQ==
X-Received: by 2002:a63:38b:: with SMTP id 133mr20234538pgd.153.1581988771240;
        Mon, 17 Feb 2020 17:19:31 -0800 (PST)
Received: from kernel.DHCP ([120.244.140.205])
        by smtp.googlemail.com with ESMTPSA id g13sm1519511pfo.169.2020.02.17.17.19.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Feb 2020 17:19:30 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v4 1/2] KVM: X86: Less kvmclock sync induced vmexits after VM boots
Date:   Tue, 18 Feb 2020 09:17:09 +0800
Message-Id: <1581988630-19182-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

In the progress of vCPUs creation, it queues a kvmclock sync worker to the global 
workqueue before each vCPU creation completes. Each worker will be scheduled 
after 300 * HZ delay and request a kvmclock update for all vCPUs and kick them 
out. This is especially worse when scaling to large VMs due to a lot of vmexits. 
Just one worker as a leader to trigger the kvmclock sync request for all vCPUs is 
enough.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v3 -> v4:
 * check vcpu->vcpu_idx

 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5d64e..d0ba2d4 100644
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

