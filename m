Return-Path: <kvm+bounces-4407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65DFB812237
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 23:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05891B21245
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 22:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A264581E5A;
	Wed, 13 Dec 2023 22:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KfqFARil"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505DDD0
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 14:59:19 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-dbcc6933a14so1973041276.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 14:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702508358; x=1703113158; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P+J5uhAeT04KXTELzQDOfFmLaVLnZ2vRpEsBsoOgLL4=;
        b=KfqFARilZk67aIMqxNzCzRfq/DqZxGxtsMpp6prFL06MxhzS4rmbbTrr45NGtdGuXx
         KGDWdDc5pUuYn4KLtlljQWjoyefiJ+ddfqQuBYsPI8iJsD84nclDLmF2M7jNwCDXWZx9
         oBgnaPFFWpVJ5b6NyJHDx6StNjYYfzDlP/WjURuo/sjTiO5kc68j/f+3k/UBpiDMhxAi
         r2yE5mkELOpmdYkZGb0OZ0RL7MbMuN0alb7bGZs52REVX6RUQZKuJ+yePas9LILeCKQM
         qV48pvLgllVHnX7o8YniHt4JydRf0XU7yJq97zg22VyJ/0tYr5ajGy0mRBUcvtURKr/B
         h7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702508358; x=1703113158;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P+J5uhAeT04KXTELzQDOfFmLaVLnZ2vRpEsBsoOgLL4=;
        b=m3Sfnisy7Pxa5gUY9F6WjcGaTRlohRMX8CfbtRiX0ZIeE/xeigqBhCuFcFTA+qE8qo
         VvJZP0YMlwpwrpdX7wQOCy57ewPgqAkoX6aNZS+6snrJTUKmfsueswqN1yxcOj6Ga9qB
         wTB8402nEQ6iQQ3FiLnWg+ltgcjeAKbnhX2CP66D/6tSQHiRcFIbspJq0IYUf5raQbUQ
         2qtwCdV8jWzJKbRPbHYNdwbVudIGMNy5swbh5FKyNCC1FLBpeINOnB8iRjPiHJzlD1ay
         XMNCK1/1jxgycHhjTP98V4Ui5oMoXV2GXhHZUA2H7Un/cgLaCb0EOxeQVMXLW/nWPVd0
         SkLg==
X-Gm-Message-State: AOJu0Yy8fmlwGYs4S1+/LzzrVNStYKvYLXG5diD5oM1SQ52T6B7g4Jfv
	1ibfFHKvmlA98cttrLaLdMe5n+Djp24=
X-Google-Smtp-Source: AGHT+IF/2tOKGAnp02CUAmcGGknds7jEyZkdjWAgG3ZJhjWlZQOPu75oZHl38j1efeikxZ9gYUCkkMb1/cI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a28c:0:b0:dbc:d4c4:15d3 with SMTP id
 c12-20020a25a28c000000b00dbcd4c415d3mr27833ybi.5.1702508358541; Wed, 13 Dec
 2023 14:59:18 -0800 (PST)
Date: Wed, 13 Dec 2023 14:59:16 -0800
In-Reply-To: <5ca5592b21131f515e296afae006e5bb28b1fb87.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20220921003201.1441511-11-seanjc@google.com> <20231207010302.2240506-1-jmattson@google.com>
 <ZXHw7tykubfG04Um@google.com> <CALMp9eTT97oDmQT7pxeOMLQbt-371aMtC2Kev+-kWXVRDVrjeg@mail.gmail.com>
 <ZXh8Nq_y_szj1WN0@google.com> <5ca5592b21131f515e296afae006e5bb28b1fb87.camel@redhat.com>
Message-ID: <ZXo3REB8g-ZecT2U@google.com>
Subject: Re: [PATCH v4 10/12] KVM: x86: never write to memory from kvm_vcpu_check_block()
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Jim Mattson <jmattson@google.com>, alexandru.elisei@arm.com, anup@brainfault.org, 
	aou@eecs.berkeley.edu, atishp@atishpatra.org, borntraeger@linux.ibm.com, 
	chenhuacai@kernel.org, david@redhat.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, james.morse@arm.com, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	maz@kernel.org, oliver.upton@linux.dev, palmer@dabbelt.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, suzuki.poulose@arm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023, Maxim Levitsky wrote:
> On Tue, 2023-12-12 at 07:28 -0800, Sean Christopherson wrote:
> > On Sun, Dec 10, 2023, Jim Mattson wrote:
> > > On Thu, Dec 7, 2023 at 8:21=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > > Doh.  We got the less obvious cases and missed the obvious one.
> > > >=20
> > > > Ugh, and we also missed a related mess in kvm_guest_apic_has_interr=
upt().  That
> > > > thing should really be folded into vmx_has_nested_events().
> > > >=20
> > > > Good gravy.  And vmx_interrupt_blocked() does the wrong thing becau=
se that
> > > > specifically checks if L1 interrupts are blocked.
> > > >=20
> > > > Compile tested only, and definitely needs to be chunked into multip=
le patches,
> > > > but I think something like this mess?
> > >=20
> > > The proposed patch does not fix the problem. In fact, it messes thing=
s
> > > up so much that I don't get any test results back.
> >=20
> > Drat.
> >=20
> > > Google has an internal K-U-T test that demonstrates the problem. I
> > > will post it soon.
> >=20
> > Received, I'll dig in soonish, though "soonish" might unfortunately mig=
ht mean
> > 2024.
> >=20
>=20
> Hi,
>=20
> So this is what I think:
>=20
> KVM does have kvm_guest_apic_has_interrupt() for this exact purpose,
> to check if nested APICv has a pending interrupt before halting.

For all intents and purposes, so was nested_ops->has_events().  I don't see
any reason to have two APIs that do the same thing, and the call to
kvm_guest_apic_has_interrupt() is wrong in that it doesn't verify that IRQs=
 are
enabled for _L2_.  That's why my preference is to fold the two together.

> However the problem is bigger - with APICv we have in essence 2 pending
> interrupt bitmaps - the PIR and the IRR, and to know if the guest has a
> pending interrupt one has in theory to copy PIR to IRR, then see if the m=
ax
> is larger then the current PPR.

Yeah, this is what my untested hack-a-patch tried to do.

> Since we don't want to write to guest memory,

The changelog is misleading/wrong.  Writing guest memory is ok, what isn't =
safe
is blocking or sleeping, i.e. KVM must not trigger a host page fault due to
accessing a page that's been swapped out.  Read vs. write doesn't matter.

So KVM can safely read and write guest memory so long as it already mapped =
by=20
kvm_vcpu_map() (or I suppose if we wrapped an access with pagefault_disable=
(),
but I can't think of a sane reason to do that).  E.g. nVMX can access a vCP=
U's
PID mapping, but synthesizing a nested VM-Exit will cause explosions on nSV=
M.

> and the IRR here resides in the guest memory, I guess we have to do a
> 'dry-run' version of 'vmx_complete_nested_posted_interrupt' and call it f=
rom
> kvm_guest_apic_has_interrupt().

nested_ops->has_events() is the much better fit, e.g. the naming won't get =
weird
and we can gate the whole thing on is_guest_mode().  Though we probably nee=
d a
wrapper to handle any commonalities between nVMX and nSVM.

> What do you think? I can prepare a patch for this.

As above, this is what I tried to do, sort of.  Though it's obviously broke=
n.  We
don't need a full dry-run because KVM only needs to detect events that are =
unique
to L2, e.g. nVMX's preemption timer, MTF, and pending virtual interrupts (h=
mm,
I suspect nSVM's vNMI is broken too).  Things like INIT and SMI don't requi=
re
nested virtualization awareness because the event itself is tracked for the=
 vCPU
as a whole.

