Return-Path: <kvm+bounces-23633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0085F94C177
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 324901C20B2B
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A47819047C;
	Thu,  8 Aug 2024 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ETl95Bee"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B5219046A
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 15:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723131110; cv=none; b=BhmHlOmpdeL8uxscUo6rx7yBzas2Fgt4QmjwXhKpu1r40XuWkP6oAXGc75Vr2e16SYJ6nzUfMZsAWuk583zGmukWQ3GUePfWiNgkUIINigQac/JsibRgvOJlP1QB2Lo+wlov98ZXoKGX35lBW9GOY/lRL000X9nDzh3bbw5pwO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723131110; c=relaxed/simple;
	bh=ptVFr46xmXiBuy5zjVBGgin/uqh4pe4wAYi7ZKMHMBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RBL+vn5FIm/ejn0SVtMIO3I2XzeM9/KhdcavDuwKz+MtSlZ6FODYfFgd4D+48exusYab96jxTimsx9OaPy/1NzFedbPo1HkuDB95nCaDMRTbk4A8X55s14BFWqRUISojLNv4FfiJK3It9CYg+X0WfP1vAY3BDoIlFyFeRaRyMVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ETl95Bee; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc58790766so11407615ad.3
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 08:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723131108; x=1723735908; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jc21vP9HtcAG8Jx0fCnF54KV0nEotJ+OQOgwzr/gmUk=;
        b=ETl95BeeLMkyE81u1igwT+2k9jOUwTWW1Rw/n2LeN/s8Lusdr/19eTO0VZMxnDL84t
         N5MYVcaiYQkhgQvgjsbxOcFeXAvC9wPE7oC/UvDUQjwW7lGTmo9kOe0ThKvhabZ5osg3
         F1kCfqrHLZKN2xb5VIOJJRLtyOaKP79uaz60fWuWyh3HqPcJj15jByKfW5fAgCipFnGf
         /JsUfy4lnPiI19g6C7J8yhBcB8Fb+/0XQOspA/ddJY7C/CWyiD99RLTpEbmYB8EdhLWw
         qa0CSMH77OX7ad+f8HPYjI/cffkaAvDqBS8N8pyGBXuFhcti6RsqwJr36kdVxMyLFwOY
         DLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723131108; x=1723735908;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jc21vP9HtcAG8Jx0fCnF54KV0nEotJ+OQOgwzr/gmUk=;
        b=SAqT6XfP0F4WXge5N1uRqwVAolwzF4g4uaJjzJqCCvbNLUKPyisSZS2fO4Lu0CuMVR
         FqwFVstNNJESrWSOKkgFI5ENRxDv2U8KBtSpZAQ1EihG31mCgJrF0RGlXLHX/tFDgNTp
         5ftIZvMk2Mx6ag0mtmjVd+IUg7EjdE4V7bnvdWIgMR4m0dteknQzmTD0hHRR9/VfADwW
         rUSzR1vkL9roSehArbRhzWlllKGPn/LAuzQgmq+q6QL8uLkFWGsPocmEYHOUb60AsqNZ
         oUbtJZXNnM9pckxVAQ01PbIsOcn8hWh5IZKXCKY5iZlzhkQCZhEf3KXpzEUArrmGMLKD
         LyaA==
X-Forwarded-Encrypted: i=1; AJvYcCXXdeOtIpfJ3GvGBswyPXQBFTJh3yLhn0QczQYfZpw5trAcg6OAGE0UmHll0sv73tCv140TBLoDdlrW7PaSjDXAagha
X-Gm-Message-State: AOJu0YziWcRFbRgznG4sLklJmnWVRoA8mFbZQrdyD7q+HKlczhEd1Y1k
	lTqb5cfynjc3870L0Uu0e16x/Kjkje+7aeTuQB8dbPW2lh1giANxAChltEdsxXTmsGvvGbKJEE4
	yBg==
X-Google-Smtp-Source: AGHT+IGhpuWFvPPS56LNIyARU7ozQJQwYhKu/y/lvyly0zz2F1cJP6/aGqiYnrRnxhwS3wYjMw23Fn2sh0c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2445:b0:1fb:7978:6cc with SMTP id
 d9443c01a7336-20095249cc8mr361865ad.5.1723131108261; Thu, 08 Aug 2024
 08:31:48 -0700 (PDT)
Date: Thu, 8 Aug 2024 08:31:46 -0700
In-Reply-To: <877ccrqc06.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-14-seanjc@google.com>
 <87bk23ql6n.fsf@draig.linaro.org> <ZrTFPhy0e1fFb9vA@google.com> <877ccrqc06.fsf@draig.linaro.org>
Message-ID: <ZrTk4sQS8k1-GBb3@google.com>
Subject: Re: [PATCH v12 13/84] KVM: Annotate that all paths in hva_to_pfn()
 might sleep
From: Sean Christopherson <seanjc@google.com>
To: "Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2024, Alex Benn=C3=A9e wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > On Thu, Aug 08, 2024, Alex Benn=C3=A9e wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >>=20
> >> > Now that hva_to_pfn() no longer supports being called in atomic cont=
ext,
> >> > move the might_sleep() annotation from hva_to_pfn_slow() to
> >> > hva_to_pfn().
> >>=20
> >> The commentary for hva_to_pfn_fast disagrees.
> >>=20
> >>   /*
> >>    * The fast path to get the writable pfn which will be stored in @pf=
n,
> >>    * true indicates success, otherwise false is returned.  It's also t=
he
> >>    * only part that runs if we can in atomic context.
> >>    */
> >>   static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *p=
fn)
> >>=20
> >> At which point did it loose the ability to run in the atomic context? =
I
> >> couldn't work it out from the commits.
> >
> > It didn't lose the ability per se (calling hva_to_pfn_fast() in atomic =
context
> > would still be functionally ok), rather the previous patch
> >
> >   KVM: Drop @atomic param from gfn=3D>pfn and hva=3D>pfn APIs
> >
> > removed support for doing so in order to simplify hva_to_pfn() as a who=
le.
>=20
> It still sticks out given the only caller no longer enforces this.=20

Oh, sorry, I should have been more explicit.  I'll fix the comment, I simpl=
y
missed it.

