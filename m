Return-Path: <kvm+bounces-39320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A92A46957
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97CDE7ABD5B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D17236A88;
	Wed, 26 Feb 2025 18:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQiJQRI/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3FE22A7EE
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593707; cv=none; b=Cpz/QflJInmrmwonC9NjU4jvg0uYgd93dCEv8uvJb7wwEwxC7aZdUKIzUza3+lE/PMHPsccnjVYAFijUwOoU9d6t7fjoK9MGxqNaJJNph3iG4DafMzvr1I5ySWIvY1bQLx6KSandUsoeaR47wKbRf2KuvH5BDYRIUv6Ctq3q4Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593707; c=relaxed/simple;
	bh=79oyuSNd07nu5wvlsuH58YEU1TVuD6rRirPk1ev+who=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pumdtvj4mcJuqht1S88UfSPs1xc6Ca5ltc6WKwSNpYqTgecre0i3dL605+SPMYl8sQH2B7KQ2VIFhtsYGVg2/ZXHEQcIaTsqCAMgtbX1pRrx/gRJjW5oHgiNZgErO/Is3Ihc+7GRLE3IbHsalbF9wsaIPdwCDKdu4JKmO9RWqrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RQiJQRI/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7TrLxIsAUhAfpT2w7dUYLCOnowUGEWdS1GQFvFDTTs=;
	b=RQiJQRI/pkaY1xpFV6uPPRS74OZhXEAG0RrcO4wH2dcrydVhMx/2b37fI9S9hbnk2QVSVf
	dY3xbDYrh2PufPVxPR/O640h6BQtZUcfTqpw8uba4jRw7jVsG6rq+pHs+txxU0qEpQCETX
	yb7zbYRtfVoVl8qJfHzBscDLTj9VskE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-138-xDHihzx2NKats8bf2Q9FAw-1; Wed,
 26 Feb 2025 13:14:59 -0500
X-MC-Unique: xDHihzx2NKats8bf2Q9FAw-1
X-Mimecast-MFC-AGG-ID: xDHihzx2NKats8bf2Q9FAw_1740593698
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C56DC1800878;
	Wed, 26 Feb 2025 18:14:58 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E0B861944D02;
	Wed, 26 Feb 2025 18:14:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 03/33] KVM: x86: Don't load/put vCPU when unloading its MMU during teardown
Date: Wed, 26 Feb 2025 13:14:22 -0500
Message-ID: <20250226181453.2311849-4-pbonzini@redhat.com>
In-Reply-To: <20250226181453.2311849-1-pbonzini@redhat.com>
References: <20250226181453.2311849-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Sean Christopherson <seanjc@google.com>

Don't load (and then put) a vCPU when unloading its MMU during VM
destruction, as nothing in kvm_mmu_unload() accesses vCPU state beyond the
root page/address of each MMU, i.e. can't possible need to run with the
vCPU loaded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250224235542.2562848-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 514fc84efc92..e5cdcccac4c9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12754,13 +12754,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
-{
-	vcpu_load(vcpu);
-	kvm_mmu_unload(vcpu);
-	vcpu_put(vcpu);
-}
-
 static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 {
 	unsigned long i;
@@ -12768,7 +12761,7 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_unload_vcpu_mmu(vcpu);
+		kvm_mmu_unload(vcpu);
 	}
 }
 
-- 
2.43.5



