Return-Path: <kvm+bounces-63128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C38C5AB8F
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8481C3B8721
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A48621A444;
	Fri, 14 Nov 2025 00:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1GJ5lb2a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6582B215F42
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079186; cv=none; b=bXmD76OHCUkm1iEAhedzmPdzFH5K1D7hF/miCcDRvJHS1DKa5/JT3tacNLEKe8dnNXA67Nb8UkoknrItW09ap/jEpbtsDu4buJviIRAJkOjB9hmI1YrA+16P0+HRO4VJ/D14X8b96rC7qEkuLv2OAb1wuDWXhit8CwjWuAD48HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079186; c=relaxed/simple;
	bh=w53kG4R7YwcZnR+lpXcyUFUHjSYejRgZ/c87yeGZZDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YPf2gyxDuiE36U/YyZzkBRLhW/l1Cy6s+LV2C7rFwc8PsBsLGqhCfSfqn/cVVQAzO1rhWau/Rl4zGsil7C5IaScB22lcfNsyC8ne+Jlb8UCefz8JxYxP1DPgC5BFcB+V0j3SWxKEIZP7gHt67dySeR15/LDAf80cz2TVT5cwVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1GJ5lb2a; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-341aec498fdso2271349a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079184; x=1763683984; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FzRCL2bVhv1bnUeLRVlUhiFFBj17om1TzQexeXV1Pmw=;
        b=1GJ5lb2aFPkJuFgQL3KPB/Pf7JCR/N8UPoIU532/NtaHjTf3hR81HTWuhjhrwHTGAA
         KcbJSqJfxEKoHm5EdNkOmRKtui9hM+oTBBGHI/R7iIy+3Cf2GEJWzevFaXVNd7HqmbNl
         6j7mraBHNfVyVx5MreZaKxVC204Y2u+jRcGQKzd+ezguZuPgHu2rbSyM53YjQ68IpUJi
         f+0aQBkikUUypHj/AtFn6uRcdl0jiv5uEZSOkIKOVDWcxiNDnkdaa+Sq4hPg6HgO04SB
         DCUSW4e48qzMJbR5fuHGCdPILMiCLsFf4TVYjrpiyYPuSUFMI/wu1VVOHgz81ZgJ0rpG
         83JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079184; x=1763683984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FzRCL2bVhv1bnUeLRVlUhiFFBj17om1TzQexeXV1Pmw=;
        b=IMTbWJJvEL5wpneyHQr+VzuGUcLmHDErKyUMJtnqD422iH0NlgJ1foOrZN1drLNI6x
         tVy2HGAxFm0sOiWrVV9ughGqZqwka1/T2Kr9oXCGoNqKsIJF/L4Php/WsKyEEy9shB/g
         vL1TVJ5jPauAonONCHIGNWdjLbuUFmkKZzK0/VaipqKvGIqoVAo+vwJ4mrAIwzi/sNcn
         QErBXBklmZom/C8RvjcEPutxUFvlBnKcPnIKjRTv47T9pwlSh2JVWC4ireJ0Bxg2wTvb
         dLtfgtjPCzcffq7utsNQAZXzB/u3PdKi2cy17VRhTkjXhYJSSFhcK7tblDJR2Q76jaSu
         67gA==
X-Gm-Message-State: AOJu0YwjGIJb3Gk6e7uWlyU0jzy0m7f2orAnfj/Khap3zT2iKPV69Mjx
	j+z8rvlbAQuUjst+ECKc+pOeywGH5UmEyntWDov484kUdoFS/ccX2oxg6cGZnHrLjmRysVsU+2x
	AocAOHg==
X-Google-Smtp-Source: AGHT+IFaIcMAFFebxMkK2542OdFvQGkKzZkis8gIVZj5PE/MmqzV7ae3b6AQ/uc2lJh1TK0Wc1YTDg7bALo=
X-Received: from pjbnm16.prod.google.com ([2002:a17:90b:19d0:b0:33b:8aa1:75ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3509:b0:341:8adc:76d2
 with SMTP id 98e67ed59e1d1-343f9ee49a5mr1323146a91.16.1763079184580; Thu, 13
 Nov 2025 16:13:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:43 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 02/17] x86: cet: Pass virtual addresses to invlpg
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Correct the parameter passed to invlpg.

The invlpg instruction should take a virtual address instead of a physical
address when flushing TLBs. Using shstk_phys results in TLBs associated
with the virtual address (shstk_virt) not being flushed, and the virtual
address may not be treated as a shadow stack address if there is a stale
TLB. So, subsequent shadow stack accesses to shstk_virt may cause a #PF,
which terminates the test unexpectedly.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cet.c b/x86/cet.c
index 42d2b1fc..51a54a50 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -100,7 +100,7 @@ int main(int ac, char **av)
 	*ptep |= PT_DIRTY_MASK;
 
 	/* Flush the paging cache. */
-	invlpg((void *)shstk_phys);
+	invlpg((void *)shstk_virt);
 
 	/* Enable shadow-stack protection */
 	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
-- 
2.52.0.rc1.455.g30608eb744-goog


