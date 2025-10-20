Return-Path: <kvm+bounces-60557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DA56BF2764
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 18:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DC0F3A42C5
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 16:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D211294A10;
	Mon, 20 Oct 2025 16:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yet/KfXT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07272957CD
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978076; cv=none; b=oJ+Qc8v6FKUczdW8x6a8jwESSFCFVT8AG8FSCw3jSnGunEKbb3an/S1I718fM3kgPdP8yeOv5JXmOyDYp7a/velStBpKa7Dn82oHWwXg1BiGK7t5MvzhQNPxsoVvwrEvtqMSJ1kK5GyNGTne0+U/ayN4aSm18o12Vxs1VaaP6l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978076; c=relaxed/simple;
	bh=EiQcu69ThNMV5eVSMYsDQ4bCDv3shLxSwQL7H3mKAKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uCD46Wu1C4Sg8bofqQ097nFOKH24a3C3nU/d6o47AVievHK4DAmAWxn1YDo1I2TI1JI0jw4d9Q0t0obVyTpCcTr/g5ItXCnihQdyKYOsmKjoT0JMpWeEn/02bGCOvgDv3KphHm6D2DagmKnLAECmGikEJmDkDvI8Tvq5+W+8ltw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yet/KfXT; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so3366109a12.3
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 09:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760978074; x=1761582874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NgpNr0aTDcHON6YJRRGl/Ho3bIHC4QKB1w6+dL8sIvA=;
        b=Yet/KfXTAZlNPK9AuR/EzQt1VB2Yr5d09V1xhF9We21YXjupqiaFLKBWyXN4MNyhRf
         p2V+VG7YYrVsCtoe1Vi3nWazGWYehoX5c8bZijF+zYDlqaumT6QTMbWySLf6Qv5QK4DK
         R/vVWZPxzDS+ER2Uw9apxw+jGNwIhgOiduguzeNMSdkcCrMtMJcCsASdDupKOpAvRGwj
         3TWWY5jR8lz0hgTVRkgbQZTjzkYVoY/62Xnr5HPReNzHmBlYT9vUH4kphC655l30RzPL
         sjrAdH1ms8JE1x4Qw9hzFEgOSj3bf4dIKnXCQVPkPsWCkbkd6WR1joRaz6RgNL0/lig9
         FMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760978074; x=1761582874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NgpNr0aTDcHON6YJRRGl/Ho3bIHC4QKB1w6+dL8sIvA=;
        b=mQqRFMrL/eAIH9O6QI2hb3AAQ/0h58LOlGn5Wt7qT7pWtMcPxHWT7D1/UEGgScPyZX
         HJq2E14N+tZ/mw1dQsA2VV5VpFZVbjHBKzaHGzDoWJr7t4GE6uu7P/KU+wNLD6g0npwt
         ix5z5pyuQJx2BkmhfONf9wugiPzzN0Ym5XKSF86iXrAf4pL1tgZfbeiK8ILcrTzaQ3uf
         mhYgyM4CyWI7frZgjEF8IzhD/1Tq/NM3yWRbnTb3eMPd/6hbGWCofcAx+ocKoAGfMpwP
         uj9Bi6vBcT0lQDK80NQQcGheONg/Rsf4wdKAoYDxGqME6MzkE4drXTdRr4ru7N8hIZ5g
         tqQw==
X-Forwarded-Encrypted: i=1; AJvYcCWf1VqBMTEwestZUkTJOWeAyj2sTKLfld1dM62PesEnVAcRHUyMNQdZORKGUHCKmAAsWjY=@vger.kernel.org
X-Gm-Message-State: AOJu0YykN9wHoQJx//UixZumdinYvwN1yZ1ik15wa2VDT36wo+Mvccfa
	SFeuIpFsTxE9dQ2wgPffdmNdX3CC4Xh2joEX6PyGHy+1dhT4wsbToaRouurI9JxyZvJ/1dE2AhW
	h7Ba5zQ==
X-Google-Smtp-Source: AGHT+IFqEfOmAYtapsa+GPV8RKNNVZk1GUoa5rfaKPAJZdtFoNenwW3NDOU3pFR/bunCzSaiK4MoJdmxl4k=
X-Received: from pjoa3.prod.google.com ([2002:a17:90a:8c03:b0:32e:a549:83e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1585:b0:334:a483:1c2c
 with SMTP id adf61e73a8af0-334a852439emr18638872637.22.1760978073961; Mon, 20
 Oct 2025 09:34:33 -0700 (PDT)
Date: Mon, 20 Oct 2025 09:33:09 -0700
In-Reply-To: <cover.1757009416.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1757009416.git.naveen@kernel.org>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
Message-ID: <176097555536.435958.1932451484992225591.b4-ty@google.com>
Subject: Re: [RESEND v4 0/7] KVM: SVM: Add support for 4k vCPUs with x2AVIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: x86@kernel.org, kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 05 Sep 2025 00:03:00 +0530, Naveen N Rao (AMD) wrote:
> Nikunj pointed out that I have missed copying the x86 maintainers though
> I am adding a new CPUID feature bit. Re-sending this series for that
> reason.
> 
> --
> This is v4 of the series posted here:
> http://lkml.kernel.org/r/cover.1740036492.git.naveen@kernel.org
> 
> [...]

Applied to kvm-x86 svm, with a few minor tweak to drop the enable_apicv check
from svm_vcpu_precreate() (it's redundant, and to have the SVM and VMX code be
more consistent).  Thanks!

P.S. I haven't forgotten about the IRQ window fixes, they just require more
brain power, so I'm waiting until I'm fully charged :-)

[1/7] KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
      https://github.com/kvm-x86/linux/commit/574ef752d4ae
[2/7] KVM: SVM: Add a helper to look up the max physical ID for AVIC
      https://github.com/kvm-x86/linux/commit/f2f6e67a56dc
[3/7] KVM: SVM: Replace hard-coded value 0x1FF with the corresponding macro
      https://github.com/kvm-x86/linux/commit/83f3cbcd3a9f
[4/7] KVM: SVM: Expand AVIC_PHYSICAL_MAX_INDEX_MASK to be a 12-bit field
      https://github.com/kvm-x86/linux/commit/ca11d9d35e95
[5/7] KVM: SVM: Move AVIC Physical ID table allocation to vcpu_precreate()
      https://github.com/kvm-x86/linux/commit/54ffe74cc4ab
[6/7] x86/cpufeatures: Add X86_FEATURE_X2AVIC_EXT
      https://github.com/kvm-x86/linux/commit/5d0316e25def
[7/7] KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode
      https://github.com/kvm-x86/linux/commit/940fc47cfb0d

--
https://github.com/kvm-x86/linux/tree/next

