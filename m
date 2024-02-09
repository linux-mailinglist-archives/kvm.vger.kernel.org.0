Return-Path: <kvm+bounces-8436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9C384F7B0
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 15:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33AD0281969
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 14:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EDD6BFBF;
	Fri,  9 Feb 2024 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q0np9RMG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362D569DFD
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707489267; cv=none; b=GzEJeoaIX5AKOljf0yuIxILRXhBKJzzFsJYwjpfL0MhsGyIOPA2szIoMVrRjMkodCDAClmL4FAyN+NVkABIf5y56z/0pH/iwdLIRdGLhoY0Ta1vFTW4iqwECqrdcqAuUcmukgtNIfteP0mPy6zbJWyeN12D7Zqd+EVrwSW/M8kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707489267; c=relaxed/simple;
	bh=uDVju7ixAiwjpj/e3kzUH3e/2RTTarHMD2S0WTFI0dk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=upRGJpJFrRIOhhE89RtloOLz+jz4w1azB0KZn1+ozwkOPFmnf62+7UEOan+SB8KUzXZJA37bVX1A8gcnS252R/ETv+LYWzjog24v4FjqSLLeB+n3pwUD3QNVS++oAG0rvPeDEK89AhZAfPHwAF74Ko6nMrzfdDrHaiPdwgGHt+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q0np9RMG; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc7489c346bso2179186276.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 06:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707489265; x=1708094065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ogb4ATBnN2iysVy3kYWYrQJMQNa+6CsJIghREb4Ixj8=;
        b=Q0np9RMGkeKUjHcN5rGnEpwKssz80xtQ0E1KR+92F8G6I6IT6UJOgzIRHL2gMNnSOq
         0S0L8wSuQZ9XeOkGRwzv9lh+x3Owlwtx31OdaEETC0f7NQ5WuKxhbByx8a6ingjmedd2
         XlU9o+HnlhIWrbCyMVxiRL4wsHi/9neAW47hBqLPAjb30Pt/eUdbEecroOp+a3wRljgm
         bFCLb/HaUrPqFX4z2R3ppEysFFy5zawjRNagSbnnOgchYpK9aK5FlvcGNAh/B1eM6qq7
         oc7UeFU/NLI2CpWFB4mdqLT7gyUCG/KN+xjC1RJLvUgOyILfk8OVAl/Pjv/qMnCo28JF
         Czrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707489265; x=1708094065;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ogb4ATBnN2iysVy3kYWYrQJMQNa+6CsJIghREb4Ixj8=;
        b=LUuF/4f8WTdqdLR35HFaeD4ftl8hzFpooKgRTVkgsah3iuc/SF0bFx8DEvpOk//XJM
         fiwlBmvALVAUvID8LexoXKPQ8kDD2NGA+bDvZ3iZDfQEwayTorn91gKpSiUD2yhFifIP
         Feodofbk7FZVOsQUiFbKyDdmhaCPn58QsIAxKGOWmQxrGo9PlBFCED9JvyaClMvTX/Pr
         dq6fvUTNhCG+dGCDrZWeIpmYI9pc6rqyaWVthh177ulc/FSU/9gfe4Zik+e6Za3gdwGv
         LJ1d3jlGVEyfP7sKsmZg2DD+NGhUcnl6SmzvR80r7ZzuMszcn7VktTVYB2CKJwG0LFXv
         06zw==
X-Gm-Message-State: AOJu0Yzspm/YXRWt739KuSq2rTgOYPmRMXIS3ys0SJCcdO58DnYVcTS9
	fxs1TeHqz9RNkatuihn7UDKxyxauwMGGUfuy5c0oRuKbAU2wqniCq7l+ufVSmwQ4iz6mZIB3AZk
	mAg==
X-Google-Smtp-Source: AGHT+IH+PMy8iQLYvFKMIvPM5koUGV9QPuYOtUDT8Wfa8+0a+Da1NQZskJ0yqIIdQ/Pd2OKS2Vpp+q0w+PI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a1e5:0:b0:dc6:e823:9edc with SMTP id
 a92-20020a25a1e5000000b00dc6e8239edcmr354524ybi.8.1707489265182; Fri, 09 Feb
 2024 06:34:25 -0800 (PST)
Date: Fri, 9 Feb 2024 06:34:23 -0800
In-Reply-To: <20240209015205.xv66udh6hqz7a6t7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-19-michael.roth@amd.com>
 <ZZ67oJwzAsSvui5U@google.com> <20240116041457.wver7acnwthjaflr@amd.com>
 <Zb1yv67h6gkYqqv9@google.com> <CABgObfa_PbxXdj9v7=2ZXfqQ_tJgdQTrO9NHKOQ691TSKQDY2A@mail.gmail.com>
 <20240209015205.xv66udh6hqz7a6t7@amd.com>
Message-ID: <ZcY37-KKIy1O27ad@google.com>
Subject: Re: [PATCH v11 18/35] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 08, 2024, Michael Roth wrote:
> On Wed, Feb 07, 2024 at 12:43:02AM +0100, Paolo Bonzini wrote:
> > On Fri, Feb 2, 2024 at 11:55=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > What sanity is being checked for, in other words why are they useful?
> > If all you get for breaking the promise is a KVM_BUG_ON, for example,
> > that's par for the course. If instead you get an oops, then we have a
> > problem.
> >=20
> > I may be a bit less draconian than Sean, but the assumptions need to
> > be documented and explained because they _are_ going to go away.
>=20
> Maybe in this case sanity-check isn't the right word, but for instance
> the occurance Sean objected to:
>=20
>   kvaddr =3D pfn_to_kaddr(pfns[i]);
>   if (!virt_addr_valid(kvaddr)) {
>     ...
>     ret =3D -EINVAL;
>=20
> where there are pfn_valid() checks underneath the covers that provide
> some assurance this is normal struct-page-backed/kernel-tracked memory
> that has a mapping in the directmap we can use here. Dropping that
> assumption means we need to create temporary mappings to access the PFN,

No, you don't.  kvm_vcpu_map() does all of the lifting for you, with the sm=
all
caveat that it obviously needs a vCPU.  But that's trivial to solve with a =
minor
refactoring, *if* we need to solve that problem (it's not clear to me wheth=
er or
not the APIs for copying data into guest_memfd will be VM-scoped or vCPU-sc=
oped).

