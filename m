Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E896459859
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 00:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhKVXZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 18:25:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229619AbhKVXZD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 18:25:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637623315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gFIU64wEJNmUi1Y7D91ACkp2wpuGCouToHN5ND11zdg=;
        b=K7H4cbwFrcYDUxRASOKlj3cuDXE0KrFywEQxMa4AJn/Vh/8VEFXw/pkxW3fCoQVYv9JrGu
        R99agYoKb4q+fzzzoNiiOShHSzWjklQCmBcuaLo6PhzXhnNTb7R+f98UzIsSUl/X93YEpA
        sK/XtEd7OlVoIocRIlfPpSsCVrm7yrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-9uUOuh-zMwKCAtL1-p09Zg-1; Mon, 22 Nov 2021 18:21:52 -0500
X-MC-Unique: 9uUOuh-zMwKCAtL1-p09Zg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FE6D801AE3;
        Mon, 22 Nov 2021 23:21:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E6595DF5F;
        Mon, 22 Nov 2021 23:21:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        syzbot+7b7db8bb4db6fd5e157b@syzkaller.appspotmail.com
Subject: [PATCH] KVM: VMX: do not use uninitialized gfn_to_hva_cache
Date:   Mon, 22 Nov 2021 18:21:49 -0500
Message-Id: <20211122232149.2927356-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An uninitialized gfn_to_hva_cache has ghc->len == 0, which causes
the accessors to croak very loudly.  While a BUG_ON is definitely
_too_ loud and a bug on its own, there is indeed an issue of using
the caches in such a way that they could not have been initialized,
because ghc->gpa == 0 might match and thus kvm_gfn_to_hva_cache_init
would not be called.

For the vmcs12_cache, the solution is simply to invoke
kvm_gfn_to_hva_cache_init unconditionally: we already know
that the cache does not match the current VMCS pointer.
For the shadow_vmcs12_cache, there is no similar condition
that checks the VMCS link pointer, so invalidate the cache
on VMXON.

Fixes: cee66664dcd6 ("KVM: nVMX: Use a gfn_to_hva_cache for vmptrld")
Cc: David Woodhouse <dwmw@amazon.co.uk>
Reported-by: syzbot+7b7db8bb4db6fd5e157b@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1e2f66951566..315fa456d368 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4857,6 +4857,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	if (!vmx->nested.cached_vmcs12)
 		goto out_cached_vmcs12;
 
+	vmx->nested.shadow_vmcs12_cache.gpa = INVALID_GPA;
 	vmx->nested.cached_shadow_vmcs12 = kzalloc(VMCS12_SIZE, GFP_KERNEL_ACCOUNT);
 	if (!vmx->nested.cached_shadow_vmcs12)
 		goto out_cached_shadow_vmcs12;
@@ -5289,8 +5290,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 		struct gfn_to_hva_cache *ghc = &vmx->nested.vmcs12_cache;
 		struct vmcs_hdr hdr;
 
-		if (ghc->gpa != vmptr &&
-		    kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, vmptr, VMCS12_SIZE)) {
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, vmptr, VMCS12_SIZE)) {
 			/*
 			 * Reads from an unbacked page return all 1s,
 			 * which means that the 32 bits located at the
-- 
2.27.0

