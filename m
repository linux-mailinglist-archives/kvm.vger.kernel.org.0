Return-Path: <kvm+bounces-18707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AADCB8FA72B
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 02:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 490C81F2063E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 00:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29108494;
	Tue,  4 Jun 2024 00:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="34O6ibuk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88FA7462
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 00:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717462074; cv=none; b=eqrG9UYEwJWa7UH44rzcv8YQvfvxcKKnNn0nksNAv4QPMfsoQiYfE2pnt9EypotDeqMLQss3hoVUIFtJ1p0yQ+C20qLaD+ETsyLaqwvskYc1uDF5ezeGnV2FcFGVuw51ZqojJVcLceSm5v16XecjXDIXuIkF1XAAV0sO73Wki4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717462074; c=relaxed/simple;
	bh=5bxoVBLLjPBD7SoG7jPQ2z8Gy8DmUiseDIdQ47ZP27Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J/7lCJ3t4zCNstz0Mi3Q2Sf7K+y+da3KlAV4KowXp5RqI93MiNIZqkcn+NxrACYtL7KuZl2P/HFwPog8XGkSpYMibKCGY78v4p6PQhLdOKGTLQAKzU+i+DcleUWgbADxGjOqhaN8q03hvnrlER0lGO4IFa8yBZlXo/2rs4tEi8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=34O6ibuk; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfa74b3e6cbso6371092276.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 17:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717462072; x=1718066872; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5bxoVBLLjPBD7SoG7jPQ2z8Gy8DmUiseDIdQ47ZP27Q=;
        b=34O6ibuktDpjSk1rfFS6BkYWDmfAqr8RCk5lvNv9dTB9fgcDvxy5xoAU/tH0D/rwsl
         mHYwBFjTZyQFbuDpXF+GzYSjSSzDtamvQeO7G/wIh0zOtSIckIY1gYb6B4LLJVeTDs1l
         dfpL9bGixODKjqwr+KmUNpOaFptQcciyp5nsWYw5M0JJPqjDFY39jvcRkjoKHjXsxCi5
         RM/rkXdEvtPlBi3OaKM/bO3iARsotl4IZ/kk2kCAoSJm6HY0WAD44m0tV9LDBTPT5Y6W
         nke1KINVpldGCfommXCa1GzPn/eKFIhCWgH4jCXGFeZJ//yesER5jyFyJ8yKPCQY+Ibs
         2VWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717462072; x=1718066872;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5bxoVBLLjPBD7SoG7jPQ2z8Gy8DmUiseDIdQ47ZP27Q=;
        b=doCJUJ9xXiQ0RkxEmGqANCNySjIZar4Y6GQhi0JHljp1M5d0uyMLgvKUdo3SEDpLQI
         oSSY+d28gtOAg4s9DPbnDUj7OMd2O/+TciiEnlwXUOar1w12Ec33HiMsprutvbeIu9t5
         ubBPlFdOzX9WD2l3wt0JfHL4QL61+cnu+uMM++1YavBYc69YrfelSgTBCGnMv1AU9//3
         nz5M+F+3aPbv3qOS+bzgSLsvk/jF52juBzI1Lf2F+WopojnvGaLylYWJWl17hAMdN0b5
         ktIyny9/laxsa2e+l/Hb/hUMkmt/U/GUuk0ndcPFfs9iIyeuqu5JbyuUtsr8Lq1WDIiF
         PdnA==
X-Forwarded-Encrypted: i=1; AJvYcCWiTj3wNSWLN1J0sY3Uyp3GhpELX+e9FokVJXWdar3r9EasVMhav3Ox7tGFLfn/JY8pIsWl5yubGI4yLS7anUivs6Iz
X-Gm-Message-State: AOJu0YxiK55ujEIHve5A+NqdoO+1ChEPOBTJky1Mfe5LY1ga13V4A1VX
	WKplpaK2VtmJLEIUFSsUGy7bXB1AuIkrIDUvafvxeC0ZW0Ubrf/ThH8Yy2UqIJqXvrYX0CgT5B0
	B2Q==
X-Google-Smtp-Source: AGHT+IEZ+F10ts8rccgAdQGGDmSLAqgaKz+peOBMZ9RGjYbuAWzb6oeWRNwl3+lBO73cv7KAkKC8yy8gBso=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154d:b0:df7:b717:10c2 with SMTP id
 3f1490d57ef6-dfa73bda088mr1660141276.2.1717462071759; Mon, 03 Jun 2024
 17:47:51 -0700 (PDT)
Date: Mon, 3 Jun 2024 17:47:50 -0700
In-Reply-To: <CABgObfbz5kZZObu9dO=KPu8_mZvGmV1752SQzQckkrj5jPaTQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240528041926.3989-1-manali.shukla@amd.com> <CABgObfbz5kZZObu9dO=KPu8_mZvGmV1752SQzQckkrj5jPaTQg@mail.gmail.com>
Message-ID: <Zl5kNh8znAYHHYuC@google.com>
Subject: Re: [PATCH v3 0/5] Add support for the Idle HLT intercept feature
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, nikunj@amd.com, 
	thomas.lendacky@amd.com, vkuznets@redhat.com, bp@alien8.de, 
	ajones@ventanamicro.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024, Paolo Bonzini wrote:
> On Tue, May 28, 2024 at 6:19=E2=80=AFAM Manali Shukla <manali.shukla@amd.=
com> wrote:
> >
> > The upcoming new Idle HLT Intercept feature allows for the HLT
> > instruction execution by a vCPU to be intercepted by the hypervisor
> > only if there are no pending V_INTR and V_NMI events for the vCPU.
> > When the vCPU is expected to service the pending V_INTR and V_NMI
> > events, the Idle HLT intercept won=E2=80=99t trigger. The feature allow=
s the
> > hypervisor to determine if the vCPU is actually idle and reduces
> > wasteful VMEXITs.
>=20
> Does this have an effect on the number of vmexits for KVM, unless AVIC
> is enabled? Can you write a testcase for kvm-unit-tests' vmexit.flat
> that shows an improvement?
>=20
> The reason I am wondering is because KVM does not really use V_INTR
> injection. The "idle HLT" intercept basically differs from the basic
> HLT trigger only in how it handles an STI;HLT sequence, as in that
> case the interrupt can be injected directly and the HLT vmexit is
> suppressed. But in that circumstance KVM would anyway use a V_INTR
> intercept to detect the opening of the interrupt injection window (and
> then the interrupt uses event injection rather than V_INTR). Again,
> this is only true if AVIC is disabled, but that is the default.
>=20
> So unless I'm wrong in my analysis above, I'm not sure this series,
> albeit small, is really worth it.

But aren't we hoping to enable x2AVIC by default sooner than later?

> As things stand, it would be more interesting to enable this for nested V=
Ms,
> especially Hyper-V which does use V_INTR and V_TPL; even better, _emulati=
ng_
> it on older processors would reduce the L2->L0->L1->L0->L2 path to a
> less-expensive L2->L0->L2 vmexit.

