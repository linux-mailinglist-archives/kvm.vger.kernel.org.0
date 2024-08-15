Return-Path: <kvm+bounces-24314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 492EA953891
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:49:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AD961C23819
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95751BA88F;
	Thu, 15 Aug 2024 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yu3kT0RG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA4A1A4F0F
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723740535; cv=none; b=U2HLWeP6kMzapJvNkhbifMHHkwPcbvnbdXf3vUCSpwmVGaKm4404fTck9+S9jxPscNnWs5kBFekGYR8bBgo1men2nFLIAZVcLNJkYnBCM2wgEY+UeJP+BtTJRor1mSfjXcJzOez0/+npQNBfPId96JkG8lSbTFb3RYkeXTAbLC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723740535; c=relaxed/simple;
	bh=LX0H7T59howhQUCK+ljDoyYrSqydSu2jLYt4IKsLzFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCn4DYPji1Lng0MehMQ9CXu8BWkiWYHn6x+yDxNkGvW4gf+NHaxSC0hxVH9LovQsoFq8S8iB6aRY7B/MBeCyiZvtcmdBTpEuOMdfh1gwyV5UAO8ob1uPqpjw7U7UiiRjqihpAQarkbMqo4zhI9tJ2fAXmBc9gvtIqfnKIkReVc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yu3kT0RG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723740532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pncdtjKt0JujPY/3N69/LmC6bpA92ExCyNXIcB41Qks=;
	b=Yu3kT0RGFcZtul37OZVwY3QKA77zomxyXseJL7SAeMo0PektaY44/5iIVfZJYqWV3frTOV
	GYEh24a5OwGMwAlT/excNZlDmo1U6gFL5P4BptoNY2m40CLLcmC6/647MTE1z4qY/umiX9
	gOpv66yPD8sotJRURXAGaKBefty5HRg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-OzEMCdO0MZyFqiZoaD-fkA-1; Thu, 15 Aug 2024 12:48:51 -0400
X-MC-Unique: OzEMCdO0MZyFqiZoaD-fkA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4281310bf7aso7127465e9.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 09:48:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723740530; x=1724345330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pncdtjKt0JujPY/3N69/LmC6bpA92ExCyNXIcB41Qks=;
        b=jL8/ZNkB5Dqh5aWOCMWkpx+EbkdODj9OEhEIkc8h2/YDtbGC3BA9vmUqs9N/YeSvBs
         Fe+a18U4pcZ5M/+g/bdEczlL4Fr27mXYQRK/4IzA8/NMj7HypvGXkZ4dIP7fJ7LoFPSp
         x7fv0TUYZNJo7JEUYdkupiCQtikD7dNukKt9Woo3RI2kv5tjMdVqVuXQdk8898D8iR0Y
         rC4627cMrm06+Xns7ANUkNCUlV94o5fcP0C71r2ZB5hnMvrkWQQjgnKkLZJCD5VH5+OG
         e2qT7i8FQjq8H09IO/NKou8ZdXE2VIkyco8Szta/d0DvpwZ93Zl61GBarXqqTUCVDJwf
         ucuQ==
X-Gm-Message-State: AOJu0YwwZ8iOLnwW/ayXYrUe04Fxdmw6TBhf7D1jfUslauXbqurvOrfB
	+ZSQsfYD2mIxa+aeM2hWP1lUEZsACCYeepq2R484XWCfLQr+FWC/ri8rpUDJB4FK3BbTJaxfjXl
	+dm0eNjT+yowx6rkK0UD98fLM7729AOeLvUzU+WGAP9tdwy3iA0oHZYW0hmXNs9MVMSJV5h7l87
	YLiSySNtdboo74u1+KwYPe52Zl
X-Received: by 2002:a05:600c:468f:b0:426:593c:935d with SMTP id 5b1f17b1804b1-429dd22ff11mr44548215e9.5.1723740529888;
        Thu, 15 Aug 2024 09:48:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoTrQ879n/ysyQctBFZ/2SXwCQCk8sn+EomvA7CTTpaL9SOacnhe2rO5VnSYbhln8UK0Q77xLW0MZG6BizNWU=
X-Received: by 2002:a05:600c:468f:b0:426:593c:935d with SMTP id
 5b1f17b1804b1-429dd22ff11mr44548065e9.5.1723740529383; Thu, 15 Aug 2024
 09:48:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-10-seanjc@google.com>
 <e50240f9-a476-4ace-86aa-f2fd33fbe320@redhat.com> <Zr4L_4dzZl-qa3xu@google.com>
In-Reply-To: <Zr4L_4dzZl-qa3xu@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 15 Aug 2024 18:48:36 +0200
Message-ID: <CABgObfbyJo2uYYkTTYdrrYQcB6XgB2+PhmfqwKrQ-g7D5UPr5A@mail.gmail.com>
Subject: Re: [PATCH 09/22] KVM: x86/mmu: Try "unprotect for retry" iff there
 are indirect SPs
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024 at 4:09=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > (This is preexisting in reexecute_instruction() and goes away in patch =
18, if
> > I'm pre-reading that part of the series correctly).
> >
> > Bonus points for opportunistically adding a READ_ONCE() here and in
> > kvm_mmu_track_write().
>
> Hmm, right, this one should have a READ_ONCE(), but I don't see any reaso=
n to
> add one in kvm_mmu_track_write().  If the compiler was crazy and generate=
 multiple
> loads between the smp_mb() and write_lock(), _and_ the value transitioned=
 from
> 1->0, reading '0' on the second go is totally fine because it means the l=
ast
> shadow page was zapped.  Amusingly, it'd actually be "better" in that it =
would
> avoid unnecessary taking mmu_lock.

Your call, but I have started leaning towards always using
READ_ONCE(), similar to all atomic_t accesses are done with
atomic_read(); that is, just as much as a marker for cross-thread
lock-free accesses, in addition to limiting the compiler's
optimizations.

tools/memory-model/Documentation/access-marking.txt also suggests
using READ_ONCE() and WRITE_ONCE() always except in special cases.
They are also more friendly to KCSAN (though I have never used it).

This of course has the issue of being yet another unfinished transition.

> Obviously the READ_ONCE() would be harmless, but IMO it would be more con=
fusing
> than helpful, e.g. would beg the question of why kvm_vcpu_exit_request() =
doesn't
> wrap vcpu->mode with READ_ONCE().  Heh, though arguably vcpu->mode should=
 be
> wrapped with READ_ONCE() since it's a helper and could be called multiple=
 times
> without any code in between that would guarantee a reload.

Indeed, who said I wouldn't change that one as well? :)

Paolo


