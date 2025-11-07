Return-Path: <kvm+bounces-62361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD1AC418C9
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 21:13:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04C0E188BF78
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 20:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2C533970F;
	Fri,  7 Nov 2025 20:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HpZd5jDD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFFE30DD25
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 20:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762546328; cv=none; b=PDD5N/xOlUnGmhMJXUV3rZqrLB57l9LsV0KVst47Cdt2Y4n0AvhIejjRcy0YEm/535SksSy6hmJ4RijQ27dyDIZTFf5aH2ikHILffl3Jzygu1ada8i/lJR9b+QUJO7lAPL7REAxL8dpVkz9RL/+R6/xtdEobwlT0QLEF+PdrZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762546328; c=relaxed/simple;
	bh=0PSUXZdtAcAVckwW4lK0mGvQ71b1MKoWNaHJVsrSzZk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KAlJ9rbBYrUQaSsiUGSnLywu5gYK7u0MoqczIvG1Y/8HXdf5yXGUHbX64tuQsCG8tp1Gs7O1ZV2Z3iGmQ7U8QbO1YhdHeQjN0/tzqbXuu2jaUOgSWhauPIOfA00X30oiL8CIdLRNHxn+OeFdhvJjUHHOvqvy5Hfxpm6cYGU8Nn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HpZd5jDD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3418c17d21dso1380254a91.2
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 12:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762546325; x=1763151125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V1c44yEBK31lRCe8Lbf69dQHnIbjaXo/fMdKgYC3v+E=;
        b=HpZd5jDDA7maAjugMbhW4c3/UfWEnnPik7iYt6wIqmVT5WZ+pirj7rWx/REWW3hlOv
         xisYn+tXSvmcUi2wM/ZQlfUDmphV08vt9aE/8ICLNK9AeQSwvfdcjPaeOPoyDfaF0+y/
         bzsg+N2uid758X9xh9CgZrSSuGd82WjLf4ldpiaxXgiYGakla+OvW5SHqGGBDGqmGtP9
         aQJ5eBaPXo/VtzfA88SMuV6h0oCRW1+6+RYsk7AHkfPp41ZlY6ffrJ99drrXzfIJxKua
         dKdT8cR8dwEahtBUvwAXj/DNr7a7pO33Pr1dtD8v1ry8t2W1SyzINkwQMjHUJ5RukYIH
         ZKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762546325; x=1763151125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V1c44yEBK31lRCe8Lbf69dQHnIbjaXo/fMdKgYC3v+E=;
        b=KgsbSeUya7gfSN8FRHXL8hrNFkh1+L6dujYcwxW6euZNmP3E49z2YoTDWq+UHUNWDf
         LYGnFc14XY7OpB2G/eD550frAPg/Y0V3sSVwX0wIfnyQeFEWXkwBXCIRil5Mil+AKX56
         W7xnzwe5d6lpALevlJZAkraeR6JJuqVuWdmjopW0GfaRPKJOlIYx/RdqIo1+jgmn/cwx
         y3EwbaqGJPDKpW2t5pIVivu/yFLOX6FCqx7ofou2YXR8Ys0QugePCXnHbfXlJoImOzJ0
         w1h3Rt+wZk5DQZiO4gQopD39lYWce+ST8PZOhOAJKMWjoZn10nSAHY29lXX7yw2lD6me
         9IQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZtQC+nGqkIxvn0FVq3f5bf8MfIst05HZkyq5fXkTW7ENV0ZAh2P7nbM4vPXmb1UV4Q58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0b4DTBn6xlxKX7KmDUzl8Dr7KQNdPgtMiMTY7AFSz+4Ie8VW1
	JXZPfkGg77VmSVPx6CFNYT4jM3AFQ8QkGF+MlgWwSESMt2brQY4KOATY7vI1Hs2goQHmMfuXHjd
	DhpDwnHyC149zWQ==
X-Google-Smtp-Source: AGHT+IFmjsIKMoEWnsUYi/J8vax4CWimpYEJ50LiM8ewxXqIhiQY8LKKFNOWWpBuxiDjIkkZLdAnyBQIvKPkIA==
X-Received: from pjbnc11.prod.google.com ([2002:a17:90b:37cb:b0:33b:ca21:e3e7])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3145:b0:343:688e:3252 with SMTP id 98e67ed59e1d1-3436cb89d6cmr561450a91.12.1762546325387;
 Fri, 07 Nov 2025 12:12:05 -0800 (PST)
Date: Fri,  7 Nov 2025 12:11:28 -0800
In-Reply-To: <20251107201151.3303170-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107201151.3303170-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107201151.3303170-6-jmattson@google.com>
Subject: [RFC PATCH 5/6] KVM: x86: nSVM: Add validity check for the VMCB12 g_pat
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Alexander Graf <agraf@suse.de>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When nested paging is enabled for VMCB12, an invalid g_pat causes an
immediate #VMEXIT with exit code VMEXIT_INVALID, as specified in the
APM.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6e48572e2bd7..43429399993c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -336,6 +336,10 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && !npt_enabled))
 		return false;
 
+	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
+	       npt_enabled && !kvm_pat_valid(control->g_pat)))
+		return false;
+
 	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
 					   MSRPM_SIZE)))
 		return false;
-- 
2.51.2.1041.gc1ab5b90ca-goog


