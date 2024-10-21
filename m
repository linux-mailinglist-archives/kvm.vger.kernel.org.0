Return-Path: <kvm+bounces-29305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 483669A72C3
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 20:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 087282832E3
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 18:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49981FBC87;
	Mon, 21 Oct 2024 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kdASUYjA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464E41946CF
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 18:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729537072; cv=none; b=gC5u8yys/e4VpcGN1PRs/Qj+YOSHkyv9r8CHYKY7OWdGgkOusx/Ha4C2gBKWni62D5s50+E9D8RuRnrkBiA/0IIGerP+hhKk9uRiitMo/Xz49d+3NgIACsQWYePoYMglkI6gQKPxhoB4sTUl5bwlvy6qdwZXiqp4bI0UVSU5syI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729537072; c=relaxed/simple;
	bh=eiuskN0Rqd2YRzqsihlK78NQBES1kITJct33unB+ED8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lp40YpWjW8FlU/fnsXjrRKkjuf+/+hCzzjpZFqyXfzHX7t5jqxSeCm+/aWAxj5Qezh3F3Nl0BiMySq6+cAmQ+Q1CEDo0uTLTZA4irvKVq0HlDDdB0PUY5kMlB6YW/mLe78pSN/jdFrQ7fqXDTFndUpVreGkp7FY9gRLAQ/zMCt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kdASUYjA; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ea6efcd658so4087251a12.3
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 11:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729537065; x=1730141865; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRc3VGGNkUkUR9ifA4nNeX0hRZiSdlXeerhUJQ+tYBo=;
        b=kdASUYjA4uGl+/Lzlu6BXwHfIsB7i/tBFO9IhxUbGjGXjQF59ek6/CHFTCctjDPUuZ
         1MsqOVNsd6s+GVMiWC66957Em1xb2DBYSrU8isQeABQyn83ei/fsD2aLt0a479A84cPB
         V6LQXUawucewAehTnjFLXliSYnhKBk8UAXPQ+AitbwdoQtePAUTyUeq4WLFcVDe63oDV
         NJ1lP/wPdprXRQIJOX+XcdgC/XnymfjsG04Nsel3StCJTWt/TqYrXpcJScgrgmUXp0Nw
         t/bsnz9EcP/v4StUu/at1ueGJTkWoxc7LMRy61IvJpEUERO1Ijr8RyeSn6hTAIbErve4
         namA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729537065; x=1730141865;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TRc3VGGNkUkUR9ifA4nNeX0hRZiSdlXeerhUJQ+tYBo=;
        b=FoWRvY80OOVUbJTaYuBCRuunZrBpj8WEH88Rywm9k/omE5I7PtYzmW/tytEYtmi7H0
         Z63GhjiwSL7vctciwYhvdKouhzQjz7swS90AYpzT0Yp2izlrHiR1Ey+AUNpPU6dqacPL
         go07o3z66KG4QGI7Cod4bquu0hpZPXcYby2aQcyo0MYQWtf564O02YUSYfVUwqBmh2vv
         1PW0bG3U3MCiO2lO7p2hh4BJooV+IbAwLqEqtQc+tzhXBbMiSqcIoViZE/wzDpYcb9W8
         SoZz1dmR18IEwkEK7MOA6HYGSw1RpTD2Z2eaUXdlxHwUgg/z2V663OaEAKf4pyO+Vd3X
         H+jA==
X-Forwarded-Encrypted: i=1; AJvYcCVZSafc/HTWUPytTqA5ftrz1N8/pPPCE6jwkWe0nIo/cfBd6LssIGVQhL6RR6pJfpLC8Us=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyp1Db2e+eDaUtwfqNTV5RQCr1Nls0NvqWuvte0ZOBkz4HTqeZ
	gb4ij5XqgUkAKAGRhHWm/+YSUwg6oe45tToYkhTDtp7LbBzSPgLyD410AJ8QOuR0Kg8GeMaFH0K
	zRQ==
X-Google-Smtp-Source: AGHT+IHRYlBrX6M+NH4TUGVEqm9BFtB7q+VVhXD5EoRBvSsXa42IiMZxJc+hXyxs+ZPnB8HLQQfXC/cdu0E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:3858:0:b0:7e9:f93c:22b9 with SMTP id
 41be03b00d2f7-7eacc895cf2mr12508a12.10.1729537064143; Mon, 21 Oct 2024
 11:57:44 -0700 (PDT)
Date: Mon, 21 Oct 2024 11:57:42 -0700
In-Reply-To: <ZxYrYe/WN8XoB+fI@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com> <20241010182427.1434605-52-seanjc@google.com>
 <ZxYrYe/WN8XoB+fI@yzhao56-desk.sh.intel.com>
Message-ID: <ZxakJr_jWkU-Y54e@google.com>
Subject: Re: [PATCH v13 51/85] KVM: VMX: Use __kvm_faultin_page() to get APIC
 access page/pfn
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
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
	"Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024, Yan Zhao wrote:
> On Thu, Oct 10, 2024 at 11:23:53AM -0700, Sean Christopherson wrote:
> > Use __kvm_faultin_page() get the APIC access page so that KVM can
> > precisely release the refcounted page, i.e. to remove yet another user
> > of kvm_pfn_to_refcounted_page().  While the path isn't handling a guest
> > page fault, the semantics are effectively the same; KVM just happens to
> > be mapping the pfn into a VMCS field instead of a secondary MMU.
> >=20
> > Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---

...

> > @@ -6838,10 +6840,13 @@ void vmx_set_apic_access_page_addr(struct kvm_v=
cpu *vcpu)
> >  		vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
> > =20
> >  	/*
> > -	 * Do not pin apic access page in memory, the MMU notifier
> > -	 * will call us again if it is migrated or swapped out.
> > +	 * Do not pin the APIC access page in memory so that it can be freely
> > +	 * migrated, the MMU notifier will call us again if it is migrated or
> > +	 * swapped out.  KVM backs the memslot with anonymous memory, the pfn
> > +	 * should always point at a refcounted page (if the pfn is valid).
> >  	 */
> > -	kvm_release_pfn_clean(pfn);
> > +	if (!WARN_ON_ONCE(!refcounted_page))
> > +		kvm_release_page_clean(refcounted_page);
> Why it's not
> if (!WARN_ON_ONCE(!refcounted_page)) {
> 	if (writable)
> 		kvm_release_page_dirty(refcounted_page)
> 	else
> 		kvm_release_page_clean(refcounted_page)
> }
>=20
> or simply not pass "writable" to __kvm_faultin_pfn() as we know the slot =
is
> not read-only and then set dirty ?

__kvm_faultin_pfn() requires a non-NULL @writable.  The intent is to help e=
nsure
the caller is actually checking whether a readable vs. writable mapping was
acquired.  For cases that explicitly pass FOLL_WRITE, it's awkward, but tho=
se
should be few and far between.

> if (!WARN_ON_ONCE(!refcounted_page))
> 	kvm_release_page_dirty(refcounted_page)

Ya, this is probably more correct?  Though I would strongly prefer to make =
any
change in behavior on top of this series.  The use of kvm_release_page_clea=
n()
was added by commit 878940b33d76 ("KVM: VMX: Retry APIC-access page reload =
if
invalidation is in-progress"), and I suspect the only reason it added the
kvm_set_page_accessed() call is because there was no "unused" variant.  I.e=
. there
was no concious decision to set Accessed but not Dirty.

