Return-Path: <kvm+bounces-55211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF780B2E75E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 23:18:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCBA95E6636
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 21:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617BB2797A5;
	Wed, 20 Aug 2025 21:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w5uFRzjV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FCF274651
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755724728; cv=none; b=fvbD/9X6H0CNEopQ5om7vgcQuPyEWmDnr//wkM895a0FCzJ+ae0Ok8JUcYlMdZIAx1H8/W9mRHM4D1/LCtS3whnmzyCjVSzAjhsHP66JTgaqQ+nH54aXVaX0z6CoH5uhBTpPgBfCKDu0BPooboiHJdRq5FOGeAsBqldIlg/DTX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755724728; c=relaxed/simple;
	bh=LjWgtUe2ffDBIWe5AFEdQGtloc8BFsTdPCWfRERMshk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PqSZqo/LpgVl0FDsd7vH476PG2b8wR6U692e3cHBAJ9F+qTsMeF6eGV1kdTnbtIi8CyxAyTgJJrOJKMGqJgJj2mPIA5i8pNqvr4qHO/r8c7FTRk4BZoAC84nGXLHEO9RztcwqBgEwvdRUwuO86HHHmLljTFRzZWEggeKqFJI0TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w5uFRzjV; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b29b715106so49081cf.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 14:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755724726; x=1756329526; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YanTK0e4sjbxPtv/E87AJagkyaCOqYnz6w0QIlh+WUM=;
        b=w5uFRzjVLHGoWA28qun18g8F+qm8/UmNNMO0jRdnF3Rpf3dfqsha8zxn1xxBsI3NBI
         HWzFT8vVEFFmqPy184XOZeqDWaDCBTCq9/sDgXgi4i6low7lnxw5E62gPiRiD2lxt0Hf
         iIfMd8sWPn+dfe1PFP/EPZQoQEeSWQ4t4HMwb49atVeuZFU9zoJIAL8h4rS9izg+Q6tj
         ik7BK0oT1fz6ZkxZGZfOxrouXlj+Z70dSuzY7t+cXyUxqJ1DzQqvkKQ9ZfmRNXV6+2iN
         rGGwP4C4MhKCVilbOmfCUtuyb1N+uugtpo5NTV3knsJrh+OpP6H2XI49vU+ouio3nJjN
         UBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755724726; x=1756329526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YanTK0e4sjbxPtv/E87AJagkyaCOqYnz6w0QIlh+WUM=;
        b=LBxnH43ddMuERox+rmzHoDJML45kSazWn1jG0M9twuRyUJbtNI1FT/gMFyCFj/bUyn
         icVYF5wonZs9foMz7Rx8CXZCzZmg6h0HLL23pymxhDVOpQ4qNb+hUwduuS+Vqc3JHShr
         X1YNJzNdq2JSLStc+FnWh6Ui78nn+CzuN8eGgHiMSrfUdGA2OC+85E82DXHNxVvEDars
         1jh+FgbrJ7YAbv0qW9GFJ9B2Ou6edIhUH/TUVXcuzxSuNMiaRMT6bbwN+a3sgIpghEHn
         ynn6JBsz4jYnmK3vw05ixhhVU1nIWFyhPISZyA5C3+fuCot9YQvicr6fv2unllJn694v
         VlYw==
X-Forwarded-Encrypted: i=1; AJvYcCVjhBVfTbZn186bx22OPz1neHC8zxSuw6Lq+IlHA08wda5vLzBCSNgXuMGfk1haJr7zkOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ9lcFZ7GzxFMlKXZDjlc+YVhAXVnE94mnoN8r7r32uWl2ngZ7
	OVloN/p3I1jFe04posk+lvmo/bN2wJQbHdkFQmiLD33eUBEo5C99llQrJOQ19UFrpvixv46ps8N
	Mdhf77A8adwGX19H1UB2KJvoQasHTz9k7wzcCaUoL
X-Gm-Gg: ASbGnctoeOjkfnS3ychOTWG49djr6U9jpJWcSNNlxxB6nFh17ABo08l47jfx00L2yep
	PgLrzbPS6EHpJp4hmoZM6SbKu9eQXuIJimMOlaYnYZlALPBDFYtiifhP8mb8vt/Gh7AZUif8PUz
	X1/e79O5YYBB/hqMHvvCETHn9OMzO6yXvonvBEOZOMRrvO9ODtJ+57E/J8gS3ebqks2gedFp77d
	WciCZ8zTvCF1c02AkZE5tIFAgZes3ZBIfO57KU++eoiTNn+RwkWcRe5
X-Google-Smtp-Source: AGHT+IHQRQFKbAOxo3PCN2gG1G+ONSaIYJEXSt8UDmWnpQyb4QJhOGxYZUIFKUu3mwSBMEBJBwB01GXcO6yRlid9inA=
X-Received: by 2002:ac8:7d0f:0:b0:4ae:d28f:b259 with SMTP id
 d75a77b69052e-4b29f9a3674mr171551cf.1.1755724725381; Wed, 20 Aug 2025
 14:18:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com> <20250807201628.1185915-8-sagis@google.com>
 <55e8d6da-50e3-4916-a778-71da628cbc08@intel.com>
In-Reply-To: <55e8d6da-50e3-4916-a778-71da628cbc08@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Wed, 20 Aug 2025 16:18:34 -0500
X-Gm-Features: Ac12FXy_O78l2qvX7QDGviCsQ0A4AbxaWcPp4bMvbe2OHW1_jf70ZZip1EYTtc4
Message-ID: <CAAhR5DHc_1VtVTD=g=q7qvnrK0z57jwD38AoDSDK1buEb5WUDg@mail.gmail.com>
Subject: Re: [PATCH v8 07/30] KVM: selftests: TDX: Use KVM_TDX_CAPABILITIES to
 validate TDs' attribute configuration
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2025 at 8:34=E2=80=AFAM Chenyi Qiang <chenyi.qiang@intel.co=
m> wrote:
>
>
>
> On 8/8/2025 4:16 AM, Sagi Shahar wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > This also exercises the KVM_TDX_CAPABILITIES ioctl.
> >
> > Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  .../selftests/kvm/lib/x86/tdx/tdx_util.c        | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools=
/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > index 392d6272d17e..bb074af4a476 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > @@ -140,6 +140,21 @@ static void tdx_apply_cpuid_restrictions(struct kv=
m_cpuid2 *cpuid_data)
> >       }
> >  }
> >
> > +static void tdx_check_attributes(struct kvm_vm *vm, uint64_t attribute=
s)
> > +{
> > +     struct kvm_tdx_capabilities *tdx_cap;
> > +
> > +     tdx_cap =3D tdx_read_capabilities(vm);
> > +
> > +     /* TDX spec: any bits 0 in supported_attrs must be 0 in attribute=
s */
> > +     TEST_ASSERT_EQ(attributes & ~tdx_cap->supported_attrs, 0);
> > +
> > +     /* TDX spec: any bits 1 in attributes must be 1 in supported_attr=
s */
> > +     TEST_ASSERT_EQ(attributes & tdx_cap->supported_attrs, attributes)=
;
> > +
> > +     free(tdx_cap);
> > +}
> > +
> >  #define KVM_MAX_CPUID_ENTRIES 256
> >
> >  #define CPUID_EXT_VMX                        BIT(5)
> > @@ -256,6 +271,8 @@ static void tdx_td_init(struct kvm_vm *vm, uint64_t=
 attributes)
> >       memcpy(&init_vm->cpuid, cpuid, kvm_cpuid2_size(cpuid->nent));
> >       free(cpuid);
> >
> > +     tdx_check_attributes(vm, attributes);
> > +
> >       init_vm->attributes =3D attributes;
> >
> >       tdx_apply_cpuid_restrictions(&init_vm->cpuid);
>
> Do we need to set the init_vm->xfam based on cpuid.0xd and validate it wi=
th tdx_cap->supported_xfam?
>
I don't think it's necessary. And according to the TDX spec (TDX
Module Base Spec - 11.8.3. Extended Features Execution Control) the
mapping from CPUID to XFAM is not trivial. Checking attributes makes
sense since some tests use non-default attributes but right now we
don't have any test which uses XFAM features. We can add XFAM support
in the future if it's needed and do the check then.

