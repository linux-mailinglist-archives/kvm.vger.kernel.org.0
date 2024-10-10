Return-Path: <kvm+bounces-28480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2548998FEE
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2978F1C20A59
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BA61CEAD8;
	Thu, 10 Oct 2024 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YefjeM7N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD861CF5D6
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584697; cv=none; b=YdV+2M4lOgqNbca6CD5N8f4unNLecfAoiEzxF6NrGCW8zzEB0erQfkaNxqVN0l614AuiK/udfoJAwrgzMFml3TjhvCPqd4mkgRhYNlY4eH3ZVywP54rtkqViurqj3+BQNHC9EtTBtJG8ugz/MzWH1cXe8+BBDQOhCKvuaQNKe3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584697; c=relaxed/simple;
	bh=iBKdL35kBHi2YuWkjigWDtnk5mPkldKXaU7GHff52mQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uonubBpkXoXIME0P0qlY+O8o75NWNYdLPCAS7MFLAhrXPympCleMrgjulSKWBNlNw9IFUJRp/Ye54OY6CPGua5hn92ozFW4IMJOv5G3jbdwrHjIII08qq9FmzhE5Mxucmq2F2CeribrWgWwigvPc3tXV3EBiB+FfqxapEHE5GYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YefjeM7N; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e284982a31so22414827b3.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584695; x=1729189495; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PiI9IzFtQVAZLsCzTZ7ta7WGdR9XnSo4A5BSh1uxRg=;
        b=YefjeM7NlL5WJTyheSu3K4yw2vp2CkS7uAx7Z40RaC/a/T9mf5Ut339LIWtkQ2XuXQ
         17CbefMXqiqBMTUljRvZMHgszGwbaPFU/tkQky5Clu/5W9+/PGYR9hUCa+QIZ1madUv6
         GhU3c/TE8J0FNncSSvv8YuqrNrxaNbhW9YiVKnl29law8WUX4fWW35jK/IILY2eu6SQ7
         snOZPsHIyng5WefoSyBjOo1ogSwiFFA5eg3ef7Npa6sKnfD/cEcNQbDShB+D61sKl22R
         AeIaMhHY8Bfyfnv2ZxOyGX3QoGGAPDZXoT3sLgxyIdmnWJQG6fwCEFa2beItHdM20glS
         GA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584695; x=1729189495;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8PiI9IzFtQVAZLsCzTZ7ta7WGdR9XnSo4A5BSh1uxRg=;
        b=TiYlOmVkRLWq7jh3kH1eHuu6fx+7JLm81d5A1i2eYkyZxBic4QR8Ofuj0FRkxVyfqa
         WcPItw4Rrhk754oU8rP8/BcpLOZp8LW+ZFMCmuEolxukl2R7Lrl1N9OMUFbuuxOfXgBz
         cWj6GK7Jc2NiKosR5wr/pW3FUrSjsCbhGP9BAvtsisR7Xeu8eusOrivTGVVRxycBscUR
         v7KaHG1S2KB1iEwKUzFOFDqv/EiB5wXkHpuSglcMNhXKlP/1XnYukamHJy0SjdZm/0b9
         nUh3/PSTP/w9miN5Fbnb2E9GsflcKlWiCGIP9RlJzzS0mygPwKM4T/3SxQuqU8W5SCC+
         ZOgQ==
X-Gm-Message-State: AOJu0Yz8K6eUMfFhXS+5SI3jGbzfn9zAliDyj+bdioupDYNhThkOHFQj
	vUe1zGUQmkIP2D+DBUgJwRMn+b6ZHvOfk1Z9gfYQVr3Yzanb3UHxXbFO6puTSMo4D5Sd8g6+ifb
	j/A==
X-Google-Smtp-Source: AGHT+IGz6mODxZTH5agCMYiGZey+8PwFJu50se4JqpXBNG0SwyKrN9TWGGQJqqmZYCdc2Fnc7eka1IGyLLE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a81:ad16:0:b0:6c1:298e:5a7 with SMTP id
 00721157ae682-6e3224662ffmr1632867b3.5.1728584694780; Thu, 10 Oct 2024
 11:24:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:05 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-4-seanjc@google.com>
Subject: [PATCH v13 03/85] KVM: Add kvm_release_page_unused() API to put pages
 that KVM never consumes
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
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add an API to release an unused page, i.e. to put a page without marking
it accessed or dirty.  The API will be used when KVM faults-in a page but
bails before installing the guest mapping (and other similar flows).

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ee186a1fbaad..ab4485b2bddc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1216,6 +1216,15 @@ unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t=
 gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t =
gfn,
 				      bool *writable);
+
+static inline void kvm_release_page_unused(struct page *page)
+{
+	if (!page)
+		return;
+
+	put_page(page);
+}
+
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
=20
--=20
2.47.0.rc1.288.g06298d1525-goog


