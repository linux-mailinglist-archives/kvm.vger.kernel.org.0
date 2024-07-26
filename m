Return-Path: <kvm+bounces-22405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6303293DBD2
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1863E285A8E
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E151181D0D;
	Fri, 26 Jul 2024 23:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V5b+Tfpe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095BA181CF2
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038046; cv=none; b=XmKzEOOsEVIHyOVKaqyIB1hJvdpPCjGeF34eQRFnymV+S0UFU1d89e51DQ3D91ylUYWbSj09qKCKOtNOfJ7h6srt6QzTflJ7StSGt7eap5KTbVH/aRqxQpXWRQPYJdVufgTYNCMeIeDSbXzzSbWLqs4Nn7rzT2N/MgLq3/RlMZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038046; c=relaxed/simple;
	bh=UWINRAqNW2M8Y4oOWNTo24b9GyZbmPXxBUrdFtS1EX8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zt/fmNbjxpSBBrOn9UeM+iJLU3XCP98rSOfSv8mtz8yLOuTcMvGBzqOU7oKADl2oIvdJm3r7ft7iuTzujojoLWdGjQoOqAaw7gj3fyMuS3YSBKxTNnkIXRAu0BRpcWOyoqdx3bQ3HjbNg1FAeRYsnEB+vVb/S3XqQIvHP+f+D7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V5b+Tfpe; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-664c185a606so7417007b3.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038044; x=1722642844; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=66tkjZePX8REZ4BHWwuGWSSOzSubgrfSmhtIFHX3PRM=;
        b=V5b+TfpehAdO9KMd/KsKTEbBdxg1QIt4az43gsucsek9hLuDgqK8rpjTLcdF/gRre1
         QqKH9xgD1A2rjCmwHMZPJpWl85Mg6YDFgRmWibsvClV92myvowJhtapwWlOATKM7a6aY
         d+JMU6Zlwe/OBS2XXLr8m9bms9CnKYWr3WzCNtIicUvbHG9ACUgHhXKNUMU0S3hYqIwx
         /AYxweT8DAriiYdTK3gpI/Ua3Lc7PtlJ5ow7UaGJtNXIEqEW4CK2TH1B9LwgKwmF+Btr
         L+IOKHNyL6CB9JATPWl8eBDlHpfsv1HpbdV27bR7RgfW5Oms/lzOeuXbmWF9nTtW0vIe
         5HLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038044; x=1722642844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=66tkjZePX8REZ4BHWwuGWSSOzSubgrfSmhtIFHX3PRM=;
        b=vYQTGoHFhDV+YUdIcdSj5LaFpMZoC6iuO8CNtEW93Zr26n1xrPKIQJ4duyqOQ0k4Fb
         GJ7YoW91ZMPjRxtxqjKEOC/Y2K2wnaRkjvZLXBEczCGyQtheoy87IUJFikcJ9EvtHcmV
         27/2iOqTLFLc6vV/vvnjJM+5Ep0B/X+1J9vkPt9hVzIAhJu8nYcVFgZ+RtYFR23N/Qwh
         PtVcYxdikv0dRMzzlL16bTtq1alJHaDV3e1Wf6O0F/Ca6JTP0e6nxoK55d0lrHKKTmck
         Ow/Amuvbmy2yqdmq2FNHevJz7D9adGiS/q3TYvzTPLz+hN8qAmW/gWUhrFHLWF/wvfzZ
         dbTw==
X-Gm-Message-State: AOJu0YwoVrLYxOJuWlV7uK1SW2uAY55mlls8Mt+Hnxigo3UkrDwhKYh0
	6oSZefjeHwF/pJwZ5NaHXVDisIAZ3KoCH0pHSrLcVaqwoSrryiv1FbeGG7RBwUDK9pJJJGIRRpf
	FQQ==
X-Google-Smtp-Source: AGHT+IEXCHhy0parcxZWaUKhAkA9z5ds6aScUvbMwsWWyatCr0tT87bBO0XasR4cX5mU+wgB/x+9BeJQnC8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f92:b0:673:b39a:92f2 with SMTP id
 00721157ae682-67a0a7fd778mr244297b3.7.1722038044118; Fri, 26 Jul 2024
 16:54:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:51 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-43-seanjc@google.com>
Subject: [PATCH v12 42/84] KVM: Move declarations of memslot accessors up in kvm_host.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Move the memslot lookup helpers further up in kvm_host.h so that they can
be used by inlined "to pfn" wrappers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5a572cef4adc..ef0277b77375 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1153,6 +1153,10 @@ static inline bool kvm_memslot_iter_is_valid(struct kvm_memslot_iter *iter, gfn_
 	     kvm_memslot_iter_is_valid(iter, end);			\
 	     kvm_memslot_iter_next(iter))
 
+struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
+struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
+struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
+
 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
  * - create a new memory slot
@@ -1290,15 +1294,13 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 })
 
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
-struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
-struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
-struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
+
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map,
-- 
2.46.0.rc1.232.g9752f9e123-goog


