Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB296EDD9B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 12:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfKDLTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 06:19:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfKDLTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 06:19:40 -0500
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 93F4685537
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 11:19:39 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id 2so3734848wmd.3
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 03:19:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IyB/9FjVy0L8r3UgW28zHK/5BLov7tJmvoQB43XUc5U=;
        b=YymVBmdQzTXuqLdHSuW7A4kdD23rcIWukHecCGjzHp0LRcXgjoYyLv7JsBJAyMHvJG
         mLV7YLO8yjYG1xN37WX3v96ga+k9+najoU0IQZGvqMWiRSdv0qnj9ULmD3wyJawmMUw7
         Y+NiXEN0W0Ox8Dh4sPL7u3waz2mQZ9C1TTclSKCujvPUm+xO0ca3d36F9mmnYeBdOqkw
         arSVJxShGLVoer9TtD8tvTmGg36WOfp5/+I6oY9nD6G+oxDwKKUIYBWXPk+vZkRCbHNU
         N216aEoQwujcUjW1qd2FhF55zjjMFTxNmJ1Z2H0MvqG9Onmx5kVfrM/H/IHfRg94ZOpr
         OlNg==
X-Gm-Message-State: APjAAAX72kLhr1ZKxx3XMQIYaQletmnZ2nlyjOMUvTPIz44yTGcJ3Rsn
        BVDsU3dXpeRRVHB2y7cnS8mN8IobGEJ28eYK/V7l1ov3Fw4/WuwmKq2//wDjCVSHhFVykTyjHnA
        YA54xWNaf/78U
X-Received: by 2002:adf:cf11:: with SMTP id o17mr22563007wrj.284.1572866378274;
        Mon, 04 Nov 2019 03:19:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwVKUPV8W60run1lYhxWK79IIU0DtaJkMmOqyowGnPFh+KCscVP6nwt1b1fryS4H5d9uC+blA==
X-Received: by 2002:adf:cf11:: with SMTP id o17mr22562979wrj.284.1572866377969;
        Mon, 04 Nov 2019 03:19:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id a206sm23814056wmf.15.2019.11.04.03.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 03:19:37 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: Fix NULL-ptr defer after kvm_create_vm fails
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1572848879-21011-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6a3217bc-cc01-38db-f994-b501110b14bf@redhat.com>
Date:   Mon, 4 Nov 2019 12:19:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1572848879-21011-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 07:27, Wanpeng Li wrote:
> Commit 9121923c457d ("kvm: Allocate memslots and buses before calling kvm_arch_init_vm") 
> moves memslots and buses allocations around, however, if kvm->srcu/irq_srcu fails 
> initialization, NULL will be returned instead of error code, NULL will not be intercepted 
> in kvm_dev_ioctl_create_vm() and be deferenced by kvm_coalesced_mmio_init(), this patch 
> fixes it.

This is not enough, as syzkaller also reported an incorrect synchronize_srcu
that was also reported by syzkaller:

     wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
     __synchronize_srcu+0x197/0x250 kernel/rcu/srcutree.c:921
     synchronize_srcu_expedited kernel/rcu/srcutree.c:946 [inline]
     synchronize_srcu+0x239/0x3e8 kernel/rcu/srcutree.c:997
     kvm_page_track_unregister_notifier+0xe7/0x130 arch/x86/kvm/page_track.c:212
     kvm_mmu_uninit_vm+0x1e/0x30 arch/x86/kvm/mmu.c:5828
     kvm_arch_destroy_vm+0x4a2/0x5f0 arch/x86/kvm/x86.c:9579
     kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:702 [inline]

I'm thinking of something like this (not tested yet):

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6f0696d98ef..e22ff63e5b1a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -645,6 +645,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
+	if (init_srcu_struct(&kvm->srcu))
+		goto out_err_no_srcu;
+	if (init_srcu_struct(&kvm->irq_srcu))
+		goto out_err_no_irq_srcu;
+
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		struct kvm_memslots *slots = kvm_alloc_memslots();
 
@@ -675,11 +680,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
 
-	if (init_srcu_struct(&kvm->srcu))
-		goto out_err_no_srcu;
-	if (init_srcu_struct(&kvm->irq_srcu))
-		goto out_err_no_irq_srcu;
-
 	r = kvm_init_mmu_notifier(kvm);
 	if (r)
 		goto out_err;
@@ -693,10 +693,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	return kvm;
 
 out_err:
-	cleanup_srcu_struct(&kvm->irq_srcu);
-out_err_no_irq_srcu:
-	cleanup_srcu_struct(&kvm->srcu);
-out_err_no_srcu:
 	hardware_disable_all();
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
@@ -706,6 +702,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
 		kfree(kvm_get_bus(kvm, i));
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
+	cleanup_srcu_struct(&kvm->irq_srcu);
+out_err_no_irq_srcu:
+	cleanup_srcu_struct(&kvm->srcu);
+out_err_no_srcu:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
 	return ERR_PTR(r);

Paolo
