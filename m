Return-Path: <kvm+bounces-19116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9D190110B
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 11:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3D2EB20449
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 09:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366F5176AB7;
	Sat,  8 Jun 2024 09:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HkPhKjEn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3531C6B7
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 09:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717838056; cv=none; b=cXcodvwQjn4oP8xvr7xIgFu6wGTkS6F2Dx4xiHc1hDbgafyl3nbPX+PtT45A5L4zuZQZwJZQuonfQ5axQa4ORUwBSM97nAofRl3OZ2s+yfHVw87V0xk2iApt3Z6XIf8r+cNDPofl/Ls3P475ztEe4uWCibeRi9qkWsDzdelVA2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717838056; c=relaxed/simple;
	bh=Q/TGAr0CiNDoDYrcj03jYZOrzqb1pAXuFRC9IC55pSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KONhneHBz5h5ll3hUtYAMOmxb0l35DOSRUGKnzJq3kA38pFXcCBiapmU0B0qhbHvckNaJEjKwLtFcr5KZ1Giz37Q02yCaK055CgQFsxpQU7/Z0/wN6M3xJ+IDl08eeLF0n6NWzXsmwv2UYrn7eA/amdefwTzuLILSQPoezgB+CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HkPhKjEn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717838054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ku7v+UVkWkWp0wqpNRlbUjz2nl0FWZCw5kgGu5XvDzY=;
	b=HkPhKjEnNwjohErGxdU1HR/UFPZSMmFwVaeWsZC/ueIL++o5pIBzzeHkymXL4RBS1otqLg
	yGySgPtm5oF/D4w1Z/kaBqXoUcaCf0Wdkyu8NLJaeJkce04/UcmjVvnv77veI5kPDJOi7I
	wZD7XPb49u1ab7n2E4tPClduWXmxIXw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-D_qrZTULP_ysbK8sIxA9AA-1; Sat, 08 Jun 2024 05:14:12 -0400
X-MC-Unique: D_qrZTULP_ysbK8sIxA9AA-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2c2dd7fb263so441058a91.0
        for <kvm@vger.kernel.org>; Sat, 08 Jun 2024 02:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717838049; x=1718442849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ku7v+UVkWkWp0wqpNRlbUjz2nl0FWZCw5kgGu5XvDzY=;
        b=AvTnXyRY9Z5heeuqQ+9QymbR7jerR7O6cZj8QV2s5JEDRhfrg/NCgFUOKEgEs+2tpU
         mb11oF2QCIVWblWb3V16z2C3IrRXYayjJ+rxcatfoFq6DdJp1IJnHJVvvvWpWcPVUBWA
         IwOH2Rgdp7f4y8kbBiQdrc6Y9wCiFsUv/mTF0FScRQMCmbIdsVBU30htbS3891PTu0CE
         ho4gpvmJ5Pz1UoWCzIs/hdMtVfdVUan+oHTm3rl4jI4xuy6YAGSOtqxoQ8pGpGhat8/5
         9oeDw2IUyjY++izj+rK0zXX/oZLE+Qh+Mf6gAiQJDtccpWZ7gRf0ZjzuMcm8V3tol5rz
         k/kQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyfGkBmqVznKepagquMkfDqnq+IZvjI77LUZNb1CAgQvfA6OYVHefJXdrlWcszijYasOFB6x/CoWb+9eOGOmrcqS1y
X-Gm-Message-State: AOJu0YwxT9Zr1JxcRBpiwh6KQEkRDD1nJdtyrc+AE4j1I9fHzGaCklaL
	Pn51Lw10kmYrMxqOhJWZqDBq03PKXU25V+A72ML6l+lTnkhtdBQF/P6UpwlmHGfbUYmYvPi5eek
	t9Bl2RQC3kmxQD/MzaYlwSBdngdWuUUYhCxZoyAkodp2c48gRoizg8eKsk1c9zZfFSienQT0GaR
	Uy9LSE88daHM64tsJCSyhUd5NcAAp2+hEeQGo=
X-Received: by 2002:a17:90b:2352:b0:2c2:cfca:6783 with SMTP id 98e67ed59e1d1-2c2cfca6890mr2473196a91.45.1717838049449;
        Sat, 08 Jun 2024 02:14:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBnTLiWOqQ8M39DA41jBBu3T4ZcnpjvGkKGIcmuIotBe6az6pnyy609CbOYHeRjWy3x6zvVVnDyy1QEi2ONuw=
X-Received: by 2002:a17:90b:2352:b0:2c2:cfca:6783 with SMTP id
 98e67ed59e1d1-2c2cfca6890mr2473190a91.45.1717838049109; Sat, 08 Jun 2024
 02:14:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
 <20240530210714.364118-10-rick.p.edgecombe@intel.com> <CABgObfbzjLtzFX9wC_FU2GKGF_Wq8og+O=pSnG_yD8j1Dn3jAg@mail.gmail.com>
 <b1306914ee4ca844f9963fcd77b8bf9a30d05249.camel@intel.com>
In-Reply-To: <b1306914ee4ca844f9963fcd77b8bf9a30d05249.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 8 Jun 2024 11:13:53 +0200
Message-ID: <CABgObfb1L4SLGLOPwUKTBusN9bVKACJp7cyvgL8LPhGz0QTNAA@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP MMU
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 10:27=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> > static inline struct kvm_mmu_page *
> > tdp_mmu_get_root_for_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault
> > *fault)
> > {
> >   hpa_t root_hpa;
> >   if (unlikely(fault->is_private && kvm_has_mirror_tdp(kvm)))
> >     root_hpa =3D vcpu->arch.mmu->mirror_root_hpa;
> >   else
> >     root_hpa =3D vcpu->arch.mmu->root.hpa;
> >   return root_to_sp(root_hpa);
> > }
>
> I was not loving the amount of indirection here in the patch, but thought=
 it
> centralized the logic a bit better. This way seems good, given that the a=
ctual
> logic is not that complex.

My proposed implementation is a bit TDX-specific though... Something
like this is more agnostic, and it exploits nicely the difference
between fault->addr and fault->gfn:

if (!kvm_gfn_direct_mask(kvm) ||
    (gpa_to_gfn(fault->addr) & kvm_gfn_direct_mask(kvm))
  root_hpa =3D vcpu->arch.mmu->root.hpa;
else
  root_hpa =3D vcpu->arch.mmu->mirror_root_hpa;
return root_to_sp(root_hpa);

Paolo


