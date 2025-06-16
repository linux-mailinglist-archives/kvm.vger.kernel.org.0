Return-Path: <kvm+bounces-49633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C7FADB854
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 20:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF37D3A7FF0
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 18:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07186288C97;
	Mon, 16 Jun 2025 18:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2ejNruvq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2451925AF
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 18:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750097067; cv=none; b=ImjjHod+XM6h7KEzAJgHTn/IeFbDFbD7aXfIJpBoyOdA/oVchBlHcB9F4/uTyaM062oGv020+FX5/gqHzthxEkX9piZfa5bP+H3j2BmXKUQO8uvwgaefz76zC+ln+b2azAhjtrSElVwEahH6Tf1sPyTfykaFFxUYmDerWRW0zm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750097067; c=relaxed/simple;
	bh=ieUrBpxnhAcHZVPIDjWg8YrjgXlXZRU0bnijma7YrcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PN1CYowcc3LpD1ABlCOhYUO/0RnZJ6gpt41LEjbj4sO0jgCSHJYJdvi9C79IF6wkS4YPAWMIUSJOyqep7UB/f1gKmxcRaA5taIM2ynG88e6FyyHOG2AH7n+sGD/zt4aduPvZwGmMhJNZTPwreDs9UCWjrQ2jzuFALycGwa4vbCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2ejNruvq; arc=none smtp.client-ip=209.85.222.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-7c790dc38b4so819252385a.0
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 11:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750097064; x=1750701864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6s05CdLcRzyi2nsOTKC32FfCxvZXUgETWtMCfMXqdTs=;
        b=2ejNruvqmpZ8PKAflJwcgI8vtHD5yQX+487nSmSbi5XsI03pk6byB9hiYZE7XgORo5
         9WvK+lJdhW0n9Dvhn6zkiR+7yqyWtBIyA6BDmjp5ugn38tjEv7mCM36Ha5MhQtrJCNzq
         t9hYS2j4GuNjb4PDHZOmFDIU2sa4VC4PdZ01vRbMDk6BNtIE2nW4Z0PAsjMppyvXwx1l
         cRIoRk3+aFjqaneR0F6rAIMIbdZmP+1Y8DLcklKuPrmHiM/5yUFz/FWoattw6j5C+ekt
         PGkabO8SZGr5As0fhKenhYNNMvdzGXE+t5Z/DfcCdmNL2nXnyoyMmRnzkAgzoWM+FBHk
         w/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750097064; x=1750701864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6s05CdLcRzyi2nsOTKC32FfCxvZXUgETWtMCfMXqdTs=;
        b=poV5DG+8bQk3jqlh5q7W8YpDa4tLWWNJgO3fEY97YlATiTS/JktZA4juFjfnYrHj3Q
         RW0ZsXydhpMTrDQoXD8nldojNLv/+dIP5Ky4JT02Sas6RMxZcKVOhf01Ee+kOebaSrSZ
         6LOSZMB5xIqJf8v2BurrkyUg4yjbGu0r2fRI9m9bZSSLQKEaozVbwKk0h9fdnDDsyBod
         HEwFiznUD4v4iVhhfJ6RR1Wb71CzrsIRBnE0ujiIKYIKQfBkXjc5RL+0Cv2PLWuCrfqq
         0WBFWhWKeyrik6DaI2tRWp/Hvcn1cCKO6EKbMFWDnJnq4gNShMUZccRIRSJTZuqo79YB
         82zQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNleUVSyJKVbgiZO9VQ8ftfqgfFQmR0OPzHgd/35xDeAgKw2BzbJErAvxNWqJ9ro8RaWw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5b7jmpHRNrknIB53imIQBg3GCH+sMGd+Fxjjq2MFjjL+FeeEq
	vQHdla802BUKDX+56UUtSlxx89OYuDctEpNM1LaMOs5nsyThy2ZaHPfdrYd51u/7k5i2a1vj1gX
	TB55I5wwzL+hdnlvV/Q4L+w==
X-Google-Smtp-Source: AGHT+IE18+eJ2mJb0IiEY7AbbpEu86bBMFRR0dra4DbsFH8VnDPOgkInNK1ZU3CtXj87hevrPmaWTiBTb6wKlYzP
X-Received: from uabch3.prod.google.com ([2002:a05:6130:c83:b0:87e:c20a:bcb1])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:2714:b0:7ce:fc0b:d39d with SMTP id af79cd13be357-7d3c5125037mr1849533285a.6.1750097064527;
 Mon, 16 Jun 2025 11:04:24 -0700 (PDT)
Date: Mon, 16 Jun 2025 18:04:23 +0000
In-Reply-To: <202506142050.kfDUdARX-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202506142050.kfDUdARX-lkp@intel.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250616180423.2859920-1-jthoughton@google.com>
Subject: Re: [PATCH v4 1/7] KVM: x86/mmu: Track TDP MMU NX huge pages separately
From: James Houghton <jthoughton@google.com>
To: lkp@intel.com
Cc: dmatlack@google.com, jthoughton@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev, 
	pbonzini@redhat.com, seanjc@google.com, vipinsh@google.com
Content-Type: text/plain; charset="UTF-8"

> All errors (new ones prefixed by >>):
> 
>    arch/x86/kvm/mmu/mmu.c: In function 'kvm_recover_nx_huge_pages':
> >> arch/x86/kvm/mmu/mmu.c:7609:38: error: 'KVM_TDP_MMU' undeclared (first use in this function)
>     7609 |                 else if (mmu_type == KVM_TDP_MMU)
>          |                                      ^~~~~~~~~~~
>    arch/x86/kvm/mmu/mmu.c:7609:38: note: each undeclared identifier is reported only once for each function it appears in

Sorry for not trying to build on i386. :(

Fixup for this, as Sean originally had[1]:

[1]: https://lore.kernel.org/kvm/ZyJCjJx2lxnEnDwa@google.com/

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9df15c9717771..d544a269c1920 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1358,6 +1358,10 @@ enum kvm_mmu_type {
 	KVM_NR_MMU_TYPES,
 };
 
+#ifndef CONFIG_X86_64
+#define KVM_TDP_MMU -1
+#endif
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;

