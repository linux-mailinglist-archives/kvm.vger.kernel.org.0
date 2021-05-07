Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8D33765C8
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbhEGNLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 09:11:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232140AbhEGNLT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 09:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620393019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=3szDupmhb5P3gzH2roiv5CqgjhCLQjU+Y1Q5biEIpRs=;
        b=SSLvvI0fK5jIbF5ALwRwj8SUF4ZPhKeuXRQ18RvkcVRy86IY30h45e/wfT1uFuektmTdNZ
        ebcqx+4qkjb6Nrh9f4UEW/hRo1D6NmAcYuuFwwAZhjCYtIpxZnGC4nTc/n0mSgPHpVyYHa
        0kFy0JFHPdLSuIVOldkEwnDrXSvaeUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-Xa6uYFsgMjuSOm6-ga3jVQ-1; Fri, 07 May 2021 09:10:17 -0400
X-MC-Unique: Xa6uYFsgMjuSOm6-ga3jVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DED0A64149;
        Fri,  7 May 2021 13:10:16 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F128B13487;
        Fri,  7 May 2021 13:10:12 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id A29D640E6DFB; Fri,  7 May 2021 10:10:07 -0300 (-03)
Message-ID: <20210507130923.468254904@redhat.com>
User-Agent: quilt/0.66
Date:   Fri, 07 May 2021 10:06:11 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 2/4] KVM: add arch specific vcpu_check_block callback
References: <20210507130609.269153197@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add callback in kvm_vcpu_check_block, so that architectures
can direct a vcpu to exit the vcpu block loop without requiring
events that would unhalt it.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Index: kvm/include/linux/kvm_host.h
===================================================================
--- kvm.orig/include/linux/kvm_host.h
+++ kvm/include/linux/kvm_host.h
@@ -971,6 +971,13 @@ static inline int kvm_arch_flush_remote_
 }
 #endif
 
+#ifndef __KVM_HAVE_ARCH_VCPU_CHECK_BLOCK
+static inline int kvm_arch_vcpu_check_block(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+#endif
+
 #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
Index: kvm/virt/kvm/kvm_main.c
===================================================================
--- kvm.orig/virt/kvm/kvm_main.c
+++ kvm/virt/kvm/kvm_main.c
@@ -2794,6 +2794,8 @@ static int kvm_vcpu_check_block(struct k
 		goto out;
 	if (signal_pending(current))
 		goto out;
+	if (kvm_arch_vcpu_check_block(vcpu))
+		goto out;
 
 	ret = 0;
 out:


