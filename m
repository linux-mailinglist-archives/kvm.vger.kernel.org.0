Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E640F4AA795
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 09:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243297AbiBEIRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 03:17:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243136AbiBEIRl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 5 Feb 2022 03:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644049061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+z3ZjKtRxG6T6Z5VKFKBhdA6gfV81DVizdvw4/6PUk=;
        b=PTI5329XRIFYkLV1CGeECdlRdpEsiECsN+SICqAWM40DZIJI300dTRsTnFExxmDLEBBR8X
        wracAvVSISuVQ6bWtP4IkxCHd0TMYBANyfXamnFwa2u2cYI4go6eYYGx6570XT8AuC+duT
        e3ABaulwnIiGn0rZH5I42N2skUtlJSs=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-9etv8YEnMA6vlhloORZlsg-1; Sat, 05 Feb 2022 03:17:38 -0500
X-MC-Unique: 9etv8YEnMA6vlhloORZlsg-1
Received: by mail-oo1-f69.google.com with SMTP id bb33-20020a056820162100b0031619149c44so4741948oob.5
        for <kvm@vger.kernel.org>; Sat, 05 Feb 2022 00:17:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+z3ZjKtRxG6T6Z5VKFKBhdA6gfV81DVizdvw4/6PUk=;
        b=nS7jRNwMFTu9eMVRZZPtjQD6gl9Xe/PbGPZEwXqKWIJgOAmjWyeNyUT+AuKIho7eQu
         ZvQaK2iD8gfXllQ0mQN9ASsf8qf9smd6RxaaLv99PkJ5RBSWtOZRp6Ynriaf/sAYCybm
         ATqngq3ETelkLYmVMLvjW4dd5P0XdQ6CPekmEY81/5VyxDqfpwsOkqFtOoPlKhLMbpra
         NuBNcnRr3c6Gsuf8QvMr+SKeBJfambOBYEvLaHZsNPhDAguYLnpioB1CfINeziJdczBB
         6DEj8ER69XcWbpKnG3568bj2VX4Ct7psVnxFXaSybcpsXeMSNlAsSviYJbzCKLHd8Q8A
         zN7A==
X-Gm-Message-State: AOAM533XYeHsJPjfL7imnPQvKF5W0mfyzK/GpPyIhGjjaIn97SSEIfrc
        HZF2Aj8z84pwoAC44sa8PDZT7snsQHBLQHekuUvi3vQZq9IPcSSKTB+kaeXZh7gyYVOHfv0w3rQ
        lekTeVYb2uu+s
X-Received: by 2002:a05:6808:17a9:: with SMTP id bg41mr1270102oib.41.1644049057517;
        Sat, 05 Feb 2022 00:17:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6PMVICTXXaDLc3Yid7XTSlSXktoo6ZqEOP3oQm+lihYzAmAhSDV2aZ6Tt5Yid/SGbl4RWdQ==
X-Received: by 2002:a05:6808:17a9:: with SMTP id bg41mr1270088oib.41.1644049057343;
        Sat, 05 Feb 2022 00:17:37 -0800 (PST)
Received: from localhost.localdomain ([2804:431:c7f0:b1af:f10e:1643:81f3:16df])
        by smtp.gmail.com with ESMTPSA id bg34sm1708795oob.14.2022.02.05.00.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 00:17:36 -0800 (PST)
From:   Leonardo Bras <leobras@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Leonardo Bras <leobras@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] x86/kvm/fpu: Limit setting guest fpu features based on guest_supported_xcr0
Date:   Sat,  5 Feb 2022 05:16:59 -0300
Message-Id: <20220205081658.562208-3-leobras@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205081658.562208-1-leobras@redhat.com>
References: <20220205081658.562208-1-leobras@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As of today, if userspace tries to set guest's fpu features to any value
(vcpu ioctl: KVM_SET_XSAVE), it is checked against the supported features
of the host cpu, and the supported features of KVM.

This makes possible to set the guest fpstate with features that were not
enabled during guest creation, but are available in the host cpu.

This becomes an issue during guest migration, if the target host does not
support the given feature:
1 - Create guest vcpu without support to featureA, on a source host that
    supports it,
2 - Set featureA to guest vcpu, even if it does not support it.
    It will run just fine, as the current host cpu supports featureA,
3 - Migrate guest to another host, which does not support featureA,
4 - After migration is completed, restoring guest fpustate to fpu regs will
    cause a general-protection exception, and crash the guest.

A way to avoid the issue is by returning error if the user tries to set
any feature not enabled during guest creation (guest_supported_xcr0).

Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 74b53a16f38a..f4e42de3560a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5010,7 +5010,8 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 
 	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
 					      guest_xsave->region,
-					      supported_xcr0, &vcpu->arch.pkru);
+					      vcpu->arch.guest_supported_xcr0,
+					     &vcpu->arch.pkru);
 }
 
 static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
-- 
2.35.1

