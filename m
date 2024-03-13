Return-Path: <kvm+bounces-11743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D447387A9E7
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 16:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 595CB1F23D64
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E5D446D6;
	Wed, 13 Mar 2024 15:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fqt0d0Zc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F50446BD
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710342114; cv=none; b=rTlOkTl4mkHTt3hmjpQEiU6FhLDekyJ0BGs7hrxM8kMznSQwUA2DQFF0iDjPQyLpjbigz5+cSkmiLxsd/zqoBxtONuOSJVHDWVvlHhhNLgOQAzMGE5q1NnIlGwMBhayMMLINco4Rjc+d+PkqMft08nHwIMSXIqLz4i9L+OjUrAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710342114; c=relaxed/simple;
	bh=BhNCnyoTesqFmuls5ivViDYlow0aTT/P/P0basWLPJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oIMT1UNOywd7M2NZ7skeDo+nPUIpqfgpJTE5N2HtHXQC4DKNSXc51dv34teHKIjz/VuTnGB6lvVcVQgCx6X1bAckfJJGsH7Nimw6b1LgOIMsi1y2Q02dEsQQ9lMADQW2BO4jjRYNVFx4k0sJhVOw+MlqXwQG2ckVeVBgbzvoZAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fqt0d0Zc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710342111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7/9033pqa13lPK0uOMJ5/UDPzpYtNbRiAHnnfFJUj+Y=;
	b=Fqt0d0ZcE0REBJtHpjQqjLuWwXFbzfoccqdFEbNwRLCrsDE29kAOQPK6M2WoGe5mfcSo9K
	nqt5UOCx1CF495uuzyU2SqG6mH6GM/b8MTrUQ+4cUg8Q8d9XEdAVl7XbK4nzCVcyFFsmor
	kc/SCWjyE8jAz6oZbS+MI/wHe8MPY3g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-qBwRJBmxO7OjkC7aaP7JXw-1; Wed, 13 Mar 2024 11:01:48 -0400
X-MC-Unique: qBwRJBmxO7OjkC7aaP7JXw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33e8abc8aeaso740966f8f.0
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 08:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710342107; x=1710946907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/9033pqa13lPK0uOMJ5/UDPzpYtNbRiAHnnfFJUj+Y=;
        b=k9pi/xhWLASU6WIrkDRGCSPgmV8YkKQ9TCG7AMloz2mIkREjr5WieB1u7jtjqlY6mk
         Hk1G3eIkmlsl3gVQcn1V7pUE/3z9Jlo5vAas0iuasmnTsjaOxSIzCadwYR5niF/f87bb
         Zenb3Ohhe926sYXN2gixVLFE5ygMjSMedO0dFLGlfYniZpVN/E0m9SG0bKrSONxNB5Pb
         jizx5zAZm1F62FMhQVem/MLYpi0Uk6sK1swovqJyWQh5oSqGrt7Or3RrUucdJx5g44lo
         JbSpLFePO3vZHICgA1pueWHWxAFqJHFoCbToueIFaw043EW2IOqRtWmQI6Xe7GQaaWS/
         SOog==
X-Forwarded-Encrypted: i=1; AJvYcCWsKXT+A2HfSQd0BERNA9ik+bh1z1XTeUAqHSEW+sq33e1VAUtt69Z4tbKTZlMnkRKEN4iq3SpyhM0RizF8EILOInkI
X-Gm-Message-State: AOJu0Yxo4XveobIczj59fdUc9Ta73WBU6EN1k0EUS2/uawzHF39kme9N
	rZpZoM9gF7HM8zeLI683FPrfnGmaZzPwIbgZjQ0wB0ejRJY4k7UkCmXAYvd7+zep6ekBF9ZZx8w
	1KaUJykDIsnE7SYEa4mV1M4sas+X+KBUj9T/y/89BmmcvMVyDy4uEuEXr4gu4EKvy2Nauqjv/PM
	9Ix/AfBx4Ezg0TwVLFLtI4bxEg
X-Received: by 2002:adf:f549:0:b0:33e:8b95:b351 with SMTP id j9-20020adff549000000b0033e8b95b351mr1835671wrp.9.1710342107690;
        Wed, 13 Mar 2024 08:01:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXNDFO30abwoBORNfBCrv9tG6NnsBZaqMWC9sIknwfHHO03Tt2/WreaRj4i/D+RMnScfjJFx/ABZsxCaZHcLs=
X-Received: by 2002:adf:f549:0:b0:33e:8b95:b351 with SMTP id
 j9-20020adff549000000b0033e8b95b351mr1835644wrp.9.1710342107333; Wed, 13 Mar
 2024 08:01:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313003739.3365845-1-mizhang@google.com> <DS0PR11MB63731F54EA26D14CF7D6A3FDDC2A2@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZfG7SgyqTTtqF3cw@google.com>
In-Reply-To: <ZfG7SgyqTTtqF3cw@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 13 Mar 2024 16:01:34 +0100
Message-ID: <CABgObfYfAS2DBaW71iUcQgua7K3VY4nz8krGYGxyBt1+7i193A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: Return correct value of IA32_PERF_CAPABILITIES
 for userspace after vCPU has run
To: Sean Christopherson <seanjc@google.com>
Cc: Wei W Wang <wei.w.wang@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Aaron Lewis <aaronlewis@google.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024 at 3:42=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> We discussed this whole MSRs mess at PUCK this morning.  I forgot to hit =
RECORD,
> but Paolo took notes and will post them soon.
>
> Going from memory, the plan is to:
>
>   1. Commit to, and document, that userspace must do KVM_SET_CPUID{,2} pr=
ior to
>      KVM_SET_MSRS.

Correct.

>   2. Go with roughly what I proposed in the CET thread (for unsupported M=
SRS,
>      read 0 and drop writes of '0')[*].

More precisely, read a sensible default value corresponding to
"everything disabled", which generally speaking should be 0. And
generally speaking, commit to:
- allowing host_initiated reads independent of CPUID
- allowing host_initiated writes of the same value that was read
- blocking host_initiated writes of nonzero (or nondefault) values if
the corresponding guest CPUID bit is clear

Right now some MSRs do not allow host initiated writes, for example
MSR_KVM_* (check for calls to guest_pv_has), and the VMX MSRs.

Generally speaking we want to fix them, unless it's an unholy pain
(for example the VMX capabilities MSRs are good candidates for pain,
because they have some "must be 1" bits in bits 63:32).

All this should be covered by selftests.

>   3. Add a quire for PERF_CAPABILITIES, ARCH_CAPABILITIES, and PLATFORM_I=
NFO
>      (if quirk=3D=3Denabled, keep KVM's current behavior; if quirk=3D=3Dd=
isabled, zero-
>       initialize the MSRs).

More precisely, even if quirk=3D=3Denabled we will move the setting of a
non-zero default value for the MSR from vCPU creation to
KVM_SET_CPUID2, and only set a non-zero default value if the CPUID bit
is set.

Another small thing in my notes was to look at the duplication between
emulated_msrs and msr_based_features_all_except_vmx. Right now
MSR_AMD64_DE_CFG is the only one that is not in both and, probably not
a coincidence, it's also the only one implemented only for one vendor.
There's probably some opportunity for both cleanups and fixes. It
looks like svm_has_emulated_msr(MSR_AMD64_DE_CFG) should return true
for example.

Paolo

> With those pieces in place, KVM can simply check X86_FEATURE_PDCM for bot=
h reads
> and writes to PERF_CAPABILITIES, and the common userspace MSR handling wi=
ll
> convert "unsupported" to "success" as appropriate.
>
> [*] https://lore.kernel.org/all/ZfDdS8rtVtyEr0UR@google.com


