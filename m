Return-Path: <kvm+bounces-39436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 433F7A470C2
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3904716CC85
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54D316F8E5;
	Thu, 27 Feb 2025 01:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4TX8+M5Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C69155A4D
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740618817; cv=none; b=mB7YxVOT+Ekt/G00416X/mnb1ZCAPydpMOAkXmJjl3e8rHvWAqbn7/eWX7PBETpcLxXFhq+TdKQrmQM8WJTsj+PUQcUjwzFBo2WYg+PbcUYcuEgfTmER9eaYae6jQ6otlQIgPJrSfYgGalzvIxVU1cj2O+JCufbu33MdbHKFuss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740618817; c=relaxed/simple;
	bh=yu8TyCy5IstIMoYy9ePpidWG2ruXcYEZUf6VlP2oCYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ma6AgKynlr4uLQiX6v/bWPftZOc2I9Rk0o0UBoVsruUjtSUAlYCnqhSkcVYNDicjpsuPEdu3Mwf45oCMLJJ6z+ZiRMHOGTTq0/2XN/etLpH1abAR7jv52oWLDYrSEFrcGAt/UJRCXuB2Xy9GszJrwqVOlidetbQCcMS9kf3KbEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4TX8+M5Q; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe86c01e2bso921374a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740618815; x=1741223615; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qmb3CzVJbBaqSWe8exsC1ZsMXmS+Kv6YmMHciuGnSnM=;
        b=4TX8+M5Q2qdpx05UcqzrpHMy/GCCBxOa2ARRRQlbLLsYcDjA1KPP3r1DLNRtZdzYT0
         gOvcdk9foygKhwP6N0CKc34GUMjts+durzLeVC7R2t/0aECsHBej++xqEUxDKdhKGtEu
         wZySBq4dRCp1OyDcC1i5bHr6tP7WRwgqYO7PJTLjKnNA08/ztuEX7gHEo5tHUyRYj6td
         5a7XrHlpVRbLJVPrW9XviqV7RCN5FUcsME51yQKx0OaAMyPTdwDHyxULmmtMRTHSWCl+
         JdLohSj0QtNejR1rA4fn4f87b5TToUWVWpVL9Xams7Pg2qF0UQFriU9HQ2QvpsGZwVGS
         nurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740618815; x=1741223615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qmb3CzVJbBaqSWe8exsC1ZsMXmS+Kv6YmMHciuGnSnM=;
        b=iOfjUHFeBnZOq4rv8gTaCZPFjZ8nIVbxxCGXv4n1Isnr8auy/LcLbSPrZvHHZBjyeE
         KGiK39TeuEOmC4ne8L2EcboDrtvl/GRSg6ZFERwdA6sQ20LXW8QVCBYSUMvi5ScfDMI1
         R/M7Uzpra2ECbj/1MAF6HF6Oexp7plQxqZTYKWclqMxR3N+rhgjK54v3mZ+SKid/GouL
         Kd65Y6qU8UjZ/hkplGQjVjynnftFRUWBk7Fv94yVDpj9lhRpqXO+xswan3nqL5wEiAET
         vT2pgkbuOz193J1opCdoLSXJ2G9C5AFa22/StE679nei4FgzlZbLsZeV9a+j8X68Xp+c
         m3fA==
X-Gm-Message-State: AOJu0YxJzhBGnLJPFAdEur9LF8NIvcP3h3I9ZfXD674aEldGdRhE7Q0R
	zujdWgKjEZOk35G8SMbfryrRDYfmhjn8ZbDgsyr6VZG/nAll4uOPB29/ZHw63qRZ1CriHDUKEMH
	r+Q==
X-Google-Smtp-Source: AGHT+IHbWmibGgYDxG0pPNvCP7ncWv5pWbcPv0vknPBvkXfOX2PBqWehwjnJxrxNDIGlFBQGAA28ThhFG8Q=
X-Received: from pjuw13.prod.google.com ([2002:a17:90a:d60d:b0:2f9:dc36:b11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5148:b0:2ee:c9b6:4c42
 with SMTP id 98e67ed59e1d1-2fce86cf0ebmr41513310a91.16.1740618815327; Wed, 26
 Feb 2025 17:13:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:13:21 -0800
In-Reply-To: <20250227011321.3229622-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227011321.3229622-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227011321.3229622-6-seanjc@google.com>
Subject: [PATCH v2 5/5] KVM: SVM: Treat DEBUGCTL[5:2] as reserved
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"

Stop ignoring DEBUGCTL[5:2] on AMD CPUs and instead treat them as reserved.
KVM has never properly virtualized AMD's legacy PBi bits, but did allow
the guest (and host userspace) to set the bits.  To avoid breaking guests
when running on CPUs with BusLockTrap, which redefined bit 2 to BLCKDB and
made bits 5:3 reserved, a previous KVM change ignored bits 5:3, e.g. so
that legacy guest software wouldn't inadvertently enable BusLockTrap or
hit a VMRUN failure due to setting reserved.

To allow for virtualizing BusLockTrap and whatever future features may use
bits 5:3, treat bits 5:2 as reserved (and hope that doing so doesn't break
any existing guests).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3924b9b198f4..7fc99c30d2cc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3166,17 +3166,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			break;
 		}
 
-		/*
-		 * AMD changed the architectural behavior of bits 5:2.  On CPUs
-		 * without BusLockTrap, bits 5:2 control "external pins", but
-		 * on CPUs that support BusLockDetect, bit 2 enables BusLockTrap
-		 * and bits 5:3 are reserved-to-zero.  Sadly, old KVM allowed
-		 * the guest to set bits 5:2 despite not actually virtualizing
-		 * Performance-Monitoring/Breakpoint external pins.  Drop bits
-		 * 5:2 for backwards compatibility.
-		 */
-		data &= ~GENMASK(5, 2);
-
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
-- 
2.48.1.711.g2feabab25a-goog


