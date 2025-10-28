Return-Path: <kvm+bounces-61255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D35C12738
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 02:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 92504561EC7
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C69426B2C8;
	Tue, 28 Oct 2025 00:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y721SBMr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B592E2036E9
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 00:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612804; cv=none; b=ikNL70+gZzSgx/9vb4Je7sJvoLzpfRhiH8M5f7BT3x211cjSYHv968YV1G/i3L1ZCTQ80JQ4cHdTFjtwMFFH6hfnQPs6GXI0k2JIQ8eZ7jcBfMTyj0gU37vLHg7wYWSQlTPgsL4v1z+onUb1DMQBCXPA4g5ESpW3wmYg0pxSNfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612804; c=relaxed/simple;
	bh=4cNoaCHzEIXXX6xk48r/fdOgWstgghbGcJ+Uh2Rack8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WYKxm05VFRIGqzjdw5T5SGsksQ1spKwLTZTGFR9Ry5Myt8a23qLXZAOv9YrVOfwKVdMo3KdHLDuezA7NDN6Sfo3bvcAr7cpWy/mbQRQpVGakmK/yfrc6pOYqAT/WR7V6dpZ0wI9eAHhQziiKGfZW4ru4lY9kEy7s0DKGuUrI27s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y721SBMr; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ecfafb92bcso109231cf.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761612801; x=1762217601; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJCzECofJKvnJPuZipIbzwFt9dZuYtL7L7v6udTFcYQ=;
        b=y721SBMrGPeRfrBtY6u+SOmiX8J/bxDYOc2vN4POw591ibNSAstKdBLU7K9v/oBRa5
         +cDGwJSsd7SXAaNv+3OSvJnWiuiwAnCd0QvYOV0YlEPTYc8u9TOlviM2zppVFXM3azzS
         b0zZpA+hvCC4617HHd0k1QuDMBBxP+FYZfVrUPn7C97RXuamDSxS3gLrzTnDBcttJmBt
         RfSox0mtwiysW9q1Tdx0VyjnSbZniUtCV5qiw7IS+xg1+8gSSnR7H824QXRRbPk5RC0P
         OCjmCwaRPkUzYTiNn/9a/jPj2uIx8E5EhtXIEQcBAckCPbmjyHhxKuGu8jf56VmOm3jF
         MaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761612801; x=1762217601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJCzECofJKvnJPuZipIbzwFt9dZuYtL7L7v6udTFcYQ=;
        b=miRA6vFrbsb9YVm16Fgd+cqE3k2AqyACie6BeNfMFmJYkPv7ggG8tPxEvhFERCplc3
         UuIFtpUx64/J/IsgIfapqWU85laIFcXBUXvX+3209oErnH1Kr4PcVHdcdUpmqEvnA405
         g5joxMm2gNFOZ7L/01qylSsoZRuW34jM2+aN90nADPfiSKvmdPUD5S50pNIAaRa7XCQE
         B6uk6AEMHktRrFsnIuLruSDOVV0sacDlYHqfKQdK3Rxy1Ad54X+SZx0zwmrymTkv1tGE
         M+spjVsRgpwhfx64UnWD3sLl07UV7+lyxVm0Y3/bLWbdaklht7F5DawYxyvRIV2gjCJn
         znBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQBcAANzYfpYl3vJMzS4xNUGXrmK4JHxGIRoijDrqeghgbgK7D+m9FpqwwN6oKtiroesk=@vger.kernel.org
X-Gm-Message-State: AOJu0YweCuF/Qu9rL6GuhF1TDo6e9qLGD0WgR7xjB29BAirlU9yzKQ22
	S8l0s6k2N0/Fv1VBJj17qnHi6kMqLAmIuGdzaKHXRXKDVzOZ5GBG3Sjz2QPHHuTsky+7YevoR/m
	CBHJKvCyhz0IPat4X3hSD8cCFUUevsSYZTfOkgXBp
X-Gm-Gg: ASbGnctpql5L3wo1P6Yu2Zr58QsjRTIaClygUc3ZcU253Cgjt1iQBDo0sLVDC5FGIiZ
	Ji1RrXGlWqSeQrX3ROKP3owAYjFPqNNpN74ZgVswbXkLo2D52j9FaPtAnBKEKnZ633LrMVlcCFl
	6i4jaXSh99O0J/AcwyM0b+zf2+zWI9tQ1bwLQpBkqQcl0xwk/aQIMqoFy/QfRLa6fQcTp0v8DN2
	fZ/36sFEx4sm6+/MxvL6uTsUiEa6nevHCRyOUZ+vW7Ahv8248r/zc9ajBMr4MuF3RROwZIZHON7
	GLLJtLWi6AXF3pnEHZDuXQaAxepl
X-Google-Smtp-Source: AGHT+IFUa6cbmVeGtvDptFMbgioO6afUPchhlusFkMBjA1ySA48BX0gjJrkRqKv7ZzUc5bXX4Ce1xRj5gu1FMlPg1oI=
X-Received: by 2002:a05:622a:54d:b0:4b7:9617:4b51 with SMTP id
 d75a77b69052e-4ed09f6d3bdmr1722601cf.15.1761612801462; Mon, 27 Oct 2025
 17:53:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com> <20250925172851.606193-22-sagis@google.com>
 <aPum5qJjFH49YVyy@google.com> <68fff9328b74_1ffdeb100d8@iweiny-mobl.notmuch> <aQADUmrDSRAydBhI@google.com>
In-Reply-To: <aQADUmrDSRAydBhI@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Mon, 27 Oct 2025 19:53:09 -0500
X-Gm-Features: AWmQ_blpq8uWAYgHCheNYVNyGFnS8Ty-_u58qPRtAcnmw4uJ0sM5wXqbEirKh4w
Message-ID: <CAAhR5DGAOsv-SiLkCziazy4Q9qG_iNqn5Zb9ik+KQ63KDzJsAA@mail.gmail.com>
Subject: Re: [PATCH v11 21/21] KVM: selftests: Add TDX lifecycle test
To: Sean Christopherson <seanjc@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>, linux-kselftest@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 6:42=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Oct 27, 2025, Ira Weiny wrote:
> > Sean Christopherson wrote:
> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/t=
esting/selftests/kvm/include/kvm_util.h
> > > index af52cd938b50..af0b53987c06 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > > @@ -210,6 +210,20 @@ kvm_static_assert(sizeof(struct vm_shape) =3D=3D=
 sizeof(uint64_t));
> > >     shape;                                  \
> > >  })
> > >
> > > +#define __VM_TYPE(__mode, __type)          \
> > > +({                                         \
> > > +   struct vm_shape shape =3D {               \
> > > +           .mode =3D (__mode),               \
> > > +           .type =3D (__type)                \
> > > +   };                                      \
> > > +                                           \
> > > +   shape;                                  \
> > > +})
> > > +
> > > +#define VM_TYPE(__type)                            \
> > > +   __VM_TYPE(VM_MODE_DEFAULT, __type)
> >
> > We already have VM_SHAPE()?  Why do we need this as well?
>
> VM_SHAPE() takes the "mode", and assumes a default type.  The alternative=
 would
> be something like __VM_SHAPE(__type, __mode), but that's annoying, especi=
ally on
> x86 which only has one mode.
>
> And __VM_SHAPE(__type) + ____VM_SHAPE(__type, __mode) feels even more wei=
rd.
>
> I'm definitely open to more ideas, VM_TYPE() isn't great either, just the=
 least
> awful option I came up with.
>
> > >  #if defined(__aarch64__)
> > >
> > >  extern enum vm_guest_mode vm_mode_default;
> > > diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/to=
ols/testing/selftests/kvm/include/x86/processor.h
> > > index 51cd84b9ca66..dd21e11e1908 100644
> > > --- a/tools/testing/selftests/kvm/include/x86/processor.h
> > > +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> > > @@ -362,6 +362,10 @@ static inline unsigned int x86_model(unsigned in=
t eax)
> > >     return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
> > >  }
> > >
> > > +#define VM_SHAPE_SEV               VM_TYPE(KVM_X86_SEV_VM)
> > > +#define VM_SHAPE_SEV_ES            VM_TYPE(KVM_X86_SEV_ES_VM)
> > > +#define VM_SHAPE_SNP               VM_TYPE(KVM_X86_SNP_VM)
> >
> > FWIW I think the SEV bits should be pulled apart from the TDX bits and =
the
> > TDX bits squashed back into this series with the SEV as a per-cursor pa=
tch.
>
> Ya, that's my intent, "officially" post and land this SEV+ change, then h=
ave the
> TDX series build on top.  Or did you mean something else?

I've got v12 mostly ready to be sent for review. I was thinking of
incorporating this change as part of that series. Do you prefer that I
wait until this patch lands before I post v12?

