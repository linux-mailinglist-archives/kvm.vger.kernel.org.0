Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF112612E5D
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 01:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJaAjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 20:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJaAjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 20:39:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2491295BB
        for <kvm@vger.kernel.org>; Sun, 30 Oct 2022 17:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667176703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BHVR2QQLq5gmxvnkMA+rSKhZlYFOe38pzpUbmKo/1hk=;
        b=RmG/lg/y/gzT02wQG+UJTtRbhluXyFw7HeI+JEH59u22Oxkd6mjLGykpkPmRdEPou37fpe
        TcM+n3esXAO7guVp250ZGXhf47LQQCSWAIImZBVSgSfQxwzTYFzJp2y0owZKtuOVFvKkLy
        zOOZXfxw1ns6OQwKJCP82C+tJoxYesI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-CqV6AEGKPfitiYbjqa1SUw-1; Sun, 30 Oct 2022 20:38:18 -0400
X-MC-Unique: CqV6AEGKPfitiYbjqa1SUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09FAA3C0F7E6;
        Mon, 31 Oct 2022 00:38:18 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-151.bne.redhat.com [10.64.54.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A87E40C6F9F;
        Mon, 31 Oct 2022 00:38:11 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, ajones@ventanamicro.com, maz@kernel.org,
        bgardon@google.com, catalin.marinas@arm.com, dmatlack@google.com,
        will@kernel.org, pbonzini@redhat.com, peterx@redhat.com,
        oliver.upton@linux.dev, seanjc@google.com, james.morse@arm.com,
        shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v7 3/9] KVM: Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL} prior to enabling them
Date:   Mon, 31 Oct 2022 08:36:15 +0800
Message-Id: <20221031003621.164306-4-gshan@redhat.com>
In-Reply-To: <20221031003621.164306-1-gshan@redhat.com>
References: <20221031003621.164306-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two capabilities related to ring-based dirty page tracking:
KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL. Both are
supported by x86. However, arm64 supports KVM_CAP_DIRTY_LOG_RING_ACQ_REL
only when the feature is supported on arm64. The userspace doesn't have
to enable the advertised capability, meaning KVM_CAP_DIRTY_LOG_RING can
be enabled on arm64 by userspace and it's wrong.

Fix it by double checking if the capability has been advertised prior to
enabling it. It's rejected to enable the capability if it hasn't been
advertised.

Fixes: 17601bfed909 ("KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option")
Reported-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 30ff73931e1c..91cf51a25394 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4584,6 +4584,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 	}
 	case KVM_CAP_DIRTY_LOG_RING:
 	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
+		if (!kvm_vm_ioctl_check_extension_generic(kvm, cap->cap))
+			return -EINVAL;
+
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
-- 
2.23.0

