Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC373B0C3C
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhFVSER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbhFVSDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:03:39 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C23C061094
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:16 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id r15-20020a0562140c4fb0290262f40bf4bcso18350008qvj.11
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/fOnrQt0b+P3Ity+GO+jt22k738kvVjgqmFqrCLqebY=;
        b=L4RgXrf9+KUDS4xiUlAqkS4rxjbz53wPTpgtwoP6J2RbPVhFt3wPIvtLheHnG2WCaI
         dyFYt7+27Uq6gyTerEpPSOjrGsZIH5FO68fDv5aXPp2EkixEinfpuzf+YoPQx8lvlUQO
         TKOfTXBjXkwNWAvLWnLjhVpNipFboI4b3PP9gfiyAuvO+FgbQbGbQChPmRiHAZmis45x
         sr/1YxJOtzRQ5uW1vpNdBcQPLjPwsPsCeDMluHNPQmHZQr+cgUrYwTdUcB/pCIBxNT+n
         xRAAkriPZ8Fx47e+D/zvt3CdngWL4HscSAjhveSl2YjxIQ9AWEdtZ4abdG3ci42ROwgY
         YCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/fOnrQt0b+P3Ity+GO+jt22k738kvVjgqmFqrCLqebY=;
        b=YtViFydIrqaUIRuadJR1eHEKq6w9yV0MpkB1E+/bPHN5pPdLdkxE0LPwPxwMDuoR8i
         C/N3rBuUofYyG+etamTtWEExmSq8on3XcYPyZFhBbufDH+vzPEKXokfbIeIICtz2YoA7
         OE1VW3krh+nvwYxRcTARIdo17Wyi2vITIm2daV8HNwNMF12V6Qmrhzja+TmisLM0UEyI
         95Ear/7MLl+QNxbwFRnepHYZlKsSXBN1hvo0zy/rXz+9QUUM/xOQgq8aVg1h6uzbSAm/
         v93cpz2xXFzPCPIAawrcKAh33OxxbezybJIB5KZPAJZjdCuO8ErsZvi8W14uNbRNNQ9w
         fdWg==
X-Gm-Message-State: AOAM530ECYlexa3KnnUhEf+7tuIftihUraSaI3OyP2nXIeTqOmdUidbg
        2/T7PhA6zqUcaEn64IinvkjusSeUPMw=
X-Google-Smtp-Source: ABdhPJwyKNqTgWBLpleYfWkDsfKxvljdyXHQcnLrZnIzrjrXorasmn/thSn2YFBKL92PkohQu22bCtSyG7Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a0c:d7c4:: with SMTP id g4mr26103996qvj.23.1624384756086;
 Tue, 22 Jun 2021 10:59:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:20 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-36-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 35/54] KVM: x86/mmu: Use MMU's role to detect EFER.NX in guest
 page walk
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the NX bit from the MMU's role instead of the MMU itself so that the
redundant, dedicated "nx" flag can be dropped.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5cf36eb96ee2..c92e712607b6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -471,7 +471,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 error:
 	errcode |= write_fault | user_fault;
-	if (fetch_fault && (mmu->nx || is_cr4_smep(mmu)))
+	if (fetch_fault && (is_efer_nx(mmu) || is_cr4_smep(mmu)))
 		errcode |= PFERR_FETCH_MASK;
 
 	walker->fault.vector = PF_VECTOR;
-- 
2.32.0.288.g62a8d224e6-goog

