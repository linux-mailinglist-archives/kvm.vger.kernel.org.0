Return-Path: <kvm+bounces-19821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8BE390BC8F
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 23:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5015E1F228B8
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 21:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2DB19923B;
	Mon, 17 Jun 2024 21:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wAbJF69U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB911990DB
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 21:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658282; cv=none; b=NSVsd8bIi5P47J29NfSvNRgtQv9APSti+1X0p0YP8g7vYtEGVOdTPhLTAdZOhKJsPS904lNQHJRZ2xRg31UptiatISXL3kc5mknf8tEKC3w/DnMu3HSmBx97zDnYtrcdwv6yvDWzwEeMq0fOus+1ohcRiL+InPVd/g7se+uHO5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658282; c=relaxed/simple;
	bh=GgL7C4XsGZdaFxvhCSzn6B1D7vD9GsUfOgTNCMHcqTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t8T3gWiTa5Q2+vc0fiWnW7w12VHr/My4B7izqMFBgSzM1Ojai7wRrmK5+vlAkSkcCqPOWCku/cU2WTfpQRJF9Alb1RmPawARWwBr8OJP4gcN/3c9NpewevGfLDsjwS9g4X5k9hapItYo5XS8afITPxMoxow8f9izeLsD2og9tHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wAbJF69U; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfdfe3d9fc8so9849603276.3
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 14:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718658280; x=1719263080; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NgijcnX9grOHrgyIejX0z10b3CCYWPg+W4dYSETE15U=;
        b=wAbJF69Ug+Prkwb0ppufoBhN2L9ZZkHJP6Zvs6pXiLx1rDKV9aCz9l6Z5vqG916GRg
         QRXsGGDeUn+XgD8bp3OOSzHozOMLYvLacUpeoEgN0SFAQr4Zrmewa4AvEdxjsN9JHlyp
         IMCNjVTpCy8ozgc6JaIK19NTwDsUeSUzglKzNt6G6inn9N0U9I2jrTqgcnu7i5DVXSCE
         leaUxZuwy5+RZIh0az8UaB7JGEsHhp/n9ZQEiLNQrEr52u0wXlzyBG/3mh50+GPCOXcx
         oYiedgYPn2KrsibXGZOfErdY65zv+XY/RQtm3/ekqf1+h8dZzc/DIJLkCBmQx44txqu2
         Qfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718658280; x=1719263080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NgijcnX9grOHrgyIejX0z10b3CCYWPg+W4dYSETE15U=;
        b=jYdtOW+dJEQMLwNJwylpa7LxbrejKxlFi9vtOryEkvN/noLz6q4EtIzo2HcdzUDZd8
         kxuV691LwBLtAtlQvyL3InodoN2y86BfQw9Kv5t3021h+n40rYzQc+BtqsoCnZphEq7e
         XuuzHKERNXcj3h9uHan5NoxJjSDN6nMB3QG/b3at7suMBqRslUzC0ApXtymEzWG0x8c7
         7/5ADWqsRgmKJSrnsm9U6H13DhREX/myqdat/VTgWJzML7txKZnV3yWyitsCFJLkXwv3
         H3OusZhrLxjUTKUcT9BUSW7BApQYEkbgpzGVSQwXh6EopeYmZ5JHJQIfB0PW2q+a4eLq
         tWxQ==
X-Gm-Message-State: AOJu0YxU+o1gM3N68sexLfAfa3DF7j6RXF305j9wZ6sZJ/+vxoZ+yip5
	zOid+EKKmy7f4c7I1wQlbsc/IQCfsFYIgJvkit/cBRJeueUV4XoBzYzAxz90CAwIAA2usjPcq/b
	MzA==
X-Google-Smtp-Source: AGHT+IGh5JSyqQ78f+320CinlxtTglmN1fuD+EdaVZ3qjNH/w5QNMBcaH6q3i7SxIBU+oaFNIg4KR/RtK98=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1027:b0:dfe:1633:89e9 with SMTP id
 3f1490d57ef6-dff1535749dmr3599808276.1.1718658279636; Mon, 17 Jun 2024
 14:04:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 17 Jun 2024 14:04:30 -0700
In-Reply-To: <20240617210432.1642542-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240617210432.1642542-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <20240617210432.1642542-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: SVM: Force sev_es_host_save_area() to be inlined
 (for noinstr usage)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"

Force sev_es_host_save_area() to be always inlined, as it's used in the
low level VM-Enter/VM-Exit path, which is non-instrumentable.

  vmlinux.o: warning: objtool: svm_vcpu_enter_exit+0xb0: call to
    sev_es_host_save_area() leaves .noinstr.text section
  vmlinux.o: warning: objtool: svm_vcpu_enter_exit+0xbf: call to
    sev_es_host_save_area.isra.0() leaves .noinstr.text section

Fixes: c92be2fd8edf ("KVM: SVM: Save/restore non-volatile GPRs in SEV-ES VMRUN via host save area")
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9ac6fca50cf3..0a36c82b316f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1504,7 +1504,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
 }
 
-static struct sev_es_save_area *sev_es_host_save_area(struct svm_cpu_data *sd)
+static __always_inline struct sev_es_save_area *sev_es_host_save_area(struct svm_cpu_data *sd)
 {
 	return page_address(sd->save_area) + 0x400;
 }
-- 
2.45.2.627.g7a2c4fd464-goog


