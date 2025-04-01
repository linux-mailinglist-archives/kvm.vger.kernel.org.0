Return-Path: <kvm+bounces-42344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF501A77FED
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7EBB7A281D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49D321C9F3;
	Tue,  1 Apr 2025 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A6RlKK3J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D13121B9C1
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523904; cv=none; b=DgeHT77k6zEvF2KntoID4QvFyyj/q57H1qypAdw2QwlZlREUJyyIooFn3yOoDgo2O+w6PPaR7qE041cfVOjvMFKbl8hcMpdgl2NuVLB5eGVYJ9g5+CyT0KxOoaF/I8xgesEowFDuf5VXQo0gKuzjagaqvYjJ5i8jAm0+tYGankA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523904; c=relaxed/simple;
	bh=RE4EXCpfxhno9yiUXTtOFR2cTLxZp7UNPnnGbcmpDXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SurYjOCtbjQ4fngzFO7FlmU6+4aBErxDwmiw/xfEkr8lifMzbpk6P1JTn2MAydydBg9u1eOkkoaJTyeRP83bp6GsB5KEAchJFqhE1BfOKpKE8SlwXFhIXvMKTAorHm6IO9f6bo/qUo2pscLz1LEt6Xjc9hTWAKwzmv8rXjDe76c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A6RlKK3J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yjR3mqM2w8v8J+UuArqg6Kc21meadYNT6Oek6yPNa0w=;
	b=A6RlKK3JQHjOlyJ7GGMZsFvrLquE1UJ/mJ74RaA44neiHd5hyzCIOnIMyryBk0LSaKqmyz
	aHBDI+I5TXDxt8K25jXGCv/XaahqUFNnmyHQ/VLS5KbTgEyGFhGFjDARrSWz5lksgnb9V+
	SMj89+hCoJF1cvITIrwEbr6pghYoDLU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-UEeKNcuDPp249YFu7k9Y3A-1; Tue, 01 Apr 2025 12:11:38 -0400
X-MC-Unique: UEeKNcuDPp249YFu7k9Y3A-1
X-Mimecast-MFC-AGG-ID: UEeKNcuDPp249YFu7k9Y3A_1743523898
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-39c142d4909so1836242f8f.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523897; x=1744128697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yjR3mqM2w8v8J+UuArqg6Kc21meadYNT6Oek6yPNa0w=;
        b=VZKV4wceLiepw/MI4xlGbTEpQfU4FolDiKaw5VPmYvjin4ni9xvhg6k1WSABva3jUW
         Uyp8v20g5hM0Q5t59JgnESE2d7xn+IEWHj9VImzEfVvF9430EwvXBLDvLqpEMa2oorUS
         YvMlPDjLePHvSX757FqkNFfVPFD3ymf1Fk0mPdG+g4FWaij/oDaF5O37c0yuLL8Hmu84
         u145P3s6PZGNC3kNdPFy/fiNTP6gnBd6AMjEPH8HaGOcLXp6IapHeaA246u8OHmtH7NJ
         Y4xogVw4LIgVRtPwEkmxqczrUdH1amTDi6q8h3M0QdmZLGM8r8P19kuNvoRoDyWC/l4k
         DZIg==
X-Forwarded-Encrypted: i=1; AJvYcCWzUGQUf8AF8GelVDuq32FYgBoLGATKJzHmHNtYc8PeJSxdFu+yOQ1EMzkiDvzlQiSbO6E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRV/6Nov7YULHtNh2qJl0xr6XqIYo8y06Z86fspArVQctlwMp/
	D5y6PHO9fEGNXHA+wy5ZbnP/oDJJZGNjRmRE+tgebaiHbUfASB6vNlj2uQ60YC+O8+6YLkJ+dkl
	Z1P6R0tQeWyZlz+mwP9EubwFJ5KbiLK8JCXIp80hHR7BC1mTGWg==
X-Gm-Gg: ASbGncuGAwkEYZOpWUjIy7CSedpu8mqsnPNqG6vj2csXOGng1PWUp+r1W+w+9jdYPDL
	Hh4NboFKSn0RPiJh7dQ7B5CR5Cu+DVlykOGFu4Lx8WcymF4VwsX/LX138fp6g+et9ORj3mXYDbD
	1CMcyQ6lTLv80/HCwBU0uEIPuE45FTvIeivfXUda/WA76+sHCZu4NW1mdoJFRKGlDCsd8JUAzIw
	ApQBlyKc65VfnkWgxzrui9V6DP9c1YZKhVOnKQA/b2APBcycPYF3kOJNQXqNiBu3z7CmQ+UXUe3
	u8CUHi0AMu8eH0VMAgg5Tg==
X-Received: by 2002:a05:6000:1863:b0:399:6dd9:9f40 with SMTP id ffacd0b85a97d-39c120cc8a1mr11575902f8f.9.1743523897702;
        Tue, 01 Apr 2025 09:11:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFf14Rq+IqwJ0RMb19wAyhNB4F46l/fAlyv854rgC7681D5ZIz2UVlu3+YdbiTNo+4kZUtxqg==
X-Received: by 2002:a05:6000:1863:b0:399:6dd9:9f40 with SMTP id ffacd0b85a97d-39c120cc8a1mr11575872f8f.9.1743523897271;
        Tue, 01 Apr 2025 09:11:37 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b79e0afsm14662940f8f.65.2025.04.01.09.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:36 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 11/29] KVM: anticipate allocation of dirty ring
Date: Tue,  1 Apr 2025 18:10:48 +0200
Message-ID: <20250401161106.790710-12-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Put together code that deals with data that is shared by all planes:
vcpu->run and dirty ring.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dce89a2f0a31..4c7e379fbf7d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4173,20 +4173,20 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	}
 	vcpu->run = page_address(page);
 
+	if (kvm->dirty_ring_size) {
+		r = kvm_dirty_ring_alloc(kvm, &vcpu->dirty_ring,
+					 id, kvm->dirty_ring_size);
+		if (r)
+			goto vcpu_free_run_page;
+	}
+
 	vcpu->plane0 = vcpu;
 	vcpu->stat = &vcpu->__stat;
 	kvm_vcpu_init(vcpu, kvm, id);
 
 	r = kvm_arch_vcpu_create(vcpu);
 	if (r)
-		goto vcpu_free_run_page;
-
-	if (kvm->dirty_ring_size) {
-		r = kvm_dirty_ring_alloc(kvm, &vcpu->dirty_ring,
-					 id, kvm->dirty_ring_size);
-		if (r)
-			goto arch_vcpu_destroy;
-	}
+		goto vcpu_free_dirty_ring;
 
 	mutex_lock(&kvm->lock);
 
@@ -4240,9 +4240,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	xa_erase(&kvm->planes[0]->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
-	kvm_dirty_ring_free(&vcpu->dirty_ring);
-arch_vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
+vcpu_free_dirty_ring:
+	kvm_dirty_ring_free(&vcpu->dirty_ring);
 vcpu_free_run_page:
 	free_page((unsigned long)vcpu->run);
 vcpu_free:
-- 
2.49.0


