Return-Path: <kvm+bounces-22401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2777A93DBC4
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5E23288C49
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B534B18131D;
	Fri, 26 Jul 2024 23:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhLCYwRM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB76155C8F
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038038; cv=none; b=JI/ChL4iy7cJdZHCwxnBy3S5rair57LoqAZfwe4QRRAfcTpDLKj7HHLw4VhKxVg4bs9CIm8tlI1QKymU2hzVcOcqBeHQyhAEcQN/BxSDssuAByySfYOrQWE1Tsa10TL6VpJC0lIlU8GPEQa+eNjDanDjoDIpP3Gvln7QeBVbtjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038038; c=relaxed/simple;
	bh=LBKPMXijjb0wTzjBJsxSrtcd3ZT6pYGX5pSqb6D2ibs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MeYGiMP/Bfx08ZLRC6oIaV4ttnlTBoTLkDFvNkvQ1iczMkvQH2+0qOUE8QwVT+wgJiAfZhBYdSdl27pi+gvnUMorWA5eQ14353XFXvjK6tdgyfEwaWwl9ISjL44Zk/GntCP4/c9buDekkBqhoZ0/9ZfQYhhAlKWo4P8G9qIthvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhLCYwRM; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-70ac9630e3aso1335967a12.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038036; x=1722642836; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G6XdYYnK6SmaIVsSbjLWLiXTD6vQEkdodh0PTaLJXbU=;
        b=dhLCYwRMU1sTsqFo+mvvQrjEFN7WADvFZULmykZMrrQujxZAfg/Q5i4It5m0pRRYKF
         3X9t644Jl2cWQqUJ+2+VgchB0dxak+38Qj63Wgy4bx7+YOCF9Yb8BW7b/ZvoCLpgnhK2
         vo7rBKNTdvoSo50vu/BH+IsmswxYhK+2b/i1Ck3Iq6acdV0bbI29pMTXd0E1JgmL4VK0
         iXDlQI8IzpIKH8SE/rIJTAzU8qWI2bmqpYHNcU27RkJlIxNKIhUtsC9b8UQ1IFDGlZ6V
         uktRZpjXrVACNJzd7c0JCAjJU8fhhLKgmZvK+ofMczsVJjp6lxX7YH68f0G1vouIjKTf
         WTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038036; x=1722642836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G6XdYYnK6SmaIVsSbjLWLiXTD6vQEkdodh0PTaLJXbU=;
        b=Ugre2Y87/IqmHEYa/Ae1SQOEYNsMaNDbpSsbixhEEU1Qy401WxyZAzDpojod/l9FPx
         qKsCUa1Km06ehNaVkCd2kYJ5s2Ef+9+7SiiNjw2uJ1qIoT/d7t5IccXVxYywewJrGkIw
         7mSZ8AnxFuJIgxRXmviwa0HGzUlLzcS3ZE3VbpwOs6BLIXLCjQxMs07hJrAgfJTum6uC
         v9FTZALpL/2BIYHcgB6K3OmanwB9oWH1ld7eIUDIyXTNeRZbZfYjab/LMxHUnptpSHKz
         koMp5Xc7egphlI8kZ6dhnpgczHzFj7GcGMHwxA3s9KwBhC4RujgwCB5R93Hjf+5osEN1
         YeVg==
X-Gm-Message-State: AOJu0YxJSVKnUjCNJhFFeRz05tDLZG7lYsbWo0mAnwOJtwAbQLNMN/e9
	CmmdmgkN8acA7XBvi25oKLMGCKjfzR8uoSEAmh/wO6HzN/JxoXxlSsWbI4fxg+iGmarjlqDFPji
	I4w==
X-Google-Smtp-Source: AGHT+IFqcJX/9FY6hmZYd8EnC/sSURY7mS/rFneQMUHDSr3ovaE0Tb6dbx+RwJc5DGDg7FZUxHqlUK5Q8cY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c945:b0:1fc:733d:8465 with SMTP id
 d9443c01a7336-1ff0488cadamr598725ad.8.1722038035986; Fri, 26 Jul 2024
 16:53:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:47 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-39-seanjc@google.com>
Subject: [PATCH v12 38/84] KVM: x86/mmu: Put direct prefetched pages via kvm_release_page_clean()
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

Use kvm_release_page_clean() to put prefeteched pages instead of calling
put_page() directly.  This will allow de-duplicating the prefetch code
between indirect and direct MMUs.

Note, there's a small functional change as kvm_release_page_clean() marks
the page/folio as accessed.  While it's not strictly guaranteed that the
guest will access the page, KVM won't intercept guest accesses, i.e. won't
mark the page accessed if it _is_ accessed by the guest (unless A/D bits
are disabled, but running without A/D bits is effectively limited to
pre-HSW Intel CPUs).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4d30920f653d..0def1444c01c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2919,7 +2919,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	for (i = 0; i < ret; i++, gfn++, start++) {
 		mmu_set_spte(vcpu, slot, start, access, gfn,
 			     page_to_pfn(pages[i]), NULL);
-		put_page(pages[i]);
+		kvm_release_page_clean(pages[i]);
 	}
 
 	return 0;
-- 
2.46.0.rc1.232.g9752f9e123-goog


