Return-Path: <kvm+bounces-54136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B70B1CADD
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 19:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D981C16708F
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 17:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2A029C33A;
	Wed,  6 Aug 2025 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tQY0wjsC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624A3293C67
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 17:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501604; cv=none; b=e8qjgRduvRAJDB2Phs7mIdQ1C6OQpn5xIi2FmUvQyGYGR+6wbHjMaK/TBe83oIpYZpWcaNiU9imd5pYQJQ+hDZtqYt34ioJXhlZa4TcAoa8QnEBOsfHFf2VpYGQEHVKKhx7sjPXaTzBiTVAqogkcNKc4zVIjZwlxR1Cdx4bIQkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501604; c=relaxed/simple;
	bh=HFDlB11tURPLQBHaQNMud7q6jwYGLOK7OT6Zg/6s3aU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OCt/TTEhEPjjBzHyf+ExEAMhwGSwSgSCq6XQDlLKLqqI+ZIUMFr9BeNR3UGgngAC9kiVgfkTAcoCYUDiykbKW2aNhk2if02aif2NWOCXR0Sll+ibQwOzl38VpjYpLEeRwSFsOw43UmqUCp26yaUhQ2VodWBZ3IcREY3R+UDX5Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tQY0wjsC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d6d671ffso173521a91.2
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 10:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754501601; x=1755106401; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LyAOeGFk30dXtQCLyt1rvWsDLNvdp4rxsI4DU4RPNQI=;
        b=tQY0wjsCwBAQV11z5u48o5QmNHUOEn89qBOczS4Tn8HACJfaj+We8xuPC5LCUeYPOQ
         dn5vVMa1OEHFgzGjMD35g8n2yjQz7kv04Nx3qliTsS59/QTrrlmKPTt4STmfDapKvsDb
         jg1Z20oAwo58bCyckiBsuNyDQzLMwehK2DcDxbmDJ8fnduzeUusQcFlNPUMtIRL3v6J/
         BM40TQCkxQpPqN+dscO5qAG2rVQGWDeW+sFmTF/q054JVEbgKCygrJI5wf3P2u1JLMiH
         91QgF0vUVzWys+7mg2OhE5Jx2hEF6AXcCr6K9JTLIWNsyrBMhh2cCx7vPdb5p0VnJc5s
         m3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754501601; x=1755106401;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LyAOeGFk30dXtQCLyt1rvWsDLNvdp4rxsI4DU4RPNQI=;
        b=laQHs2h50u3g+uUWRCOzfanWT4xwUSTlnxdOx1j14sIj9M1FobtmLxfnl8IoJdiKwU
         db3EeL/APEXs0FO68I5cFGrs4z2PbmNBEVEKSsgigPnrzt2sSX5Zvht5RlG4TQSqxFhd
         jd8bZXdFPlxg+thk33J3NMgb7f9PuR+yRCyph1t4AoIeOpXwLSqUPlo48txjSJITJeQw
         iM55eW/qGHmfHd3SCG/+eLXpBHO8ialLQYgQpg7SDUWCKGFu+Ep9kJ5JQHc5scEZQvXp
         sMnda+we7TSVApQuVVQktWyqgUnzObhr8Vmo9ikq47/jPrevEm7otMSqD3qmIMS6rG42
         wZrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9s/S5aQDd2fNeamIeBBRCOW9hRhyfEVacZkjg0EzHp+NSEZu7Ut74nOBe4gqmc0s9Ins=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqPQCiD7RygT8dzaCIhvdiNJ34lZBJIhob2s+E06Dtar9/yVCq
	zAoiro9m4EploMP9I2v6HOtDrJ9VNrFstEQ3scUQ9Vummv4u8XH05/xc1EXXcm7dUaGQhPmZ/f+
	IKYWl5g==
X-Google-Smtp-Source: AGHT+IGr5NQ4unyFFD1LCKq5VEbjUEGgPs67kjJYV97puf807pg/ZHj7pgAJv73ef0jkdIubgiWbliotX1Y=
X-Received: from pjje11.prod.google.com ([2002:a17:90a:630b:b0:31e:998f:7b79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a4f:b0:31f:12d:ee4f
 with SMTP id 98e67ed59e1d1-32166cd2f77mr4291258a91.23.1754501601572; Wed, 06
 Aug 2025 10:33:21 -0700 (PDT)
Date: Wed, 6 Aug 2025 10:33:20 -0700
In-Reply-To: <e64951b0-4707-42ed-abf4-947def74ea34@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com> <20250805190526.1453366-18-seanjc@google.com>
 <e64951b0-4707-42ed-abf4-947def74ea34@linux.intel.com>
Message-ID: <aJOR4Bk3DwKSVdQV@google.com>
Subject: Re: [PATCH 17/18] KVM: x86: Push acquisition of SRCU in fastpath into kvm_pmu_trigger_event()
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xin Li <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2025, Dapeng Mi wrote:
>=20
> On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> > Acquire SRCU in the VM-Exit fastpath if and only if KVM needs to check =
the
> > PMU event filter, to further trim the amount of code that is executed w=
ith
> > SRCU protection in the fastpath.  Counter-intuitively, holding SRCU can=
 do
> > more harm than good due to masking potential bugs, and introducing a ne=
w
> > SRCU-protected asset to code reachable via kvm_skip_emulated_instructio=
n()
> > would be quite notable, i.e. definitely worth auditing.
> >
> > E.g. the primary user of kvm->srcu is KVM's memslots, accessing memslot=
s
> > all but guarantees guest memory may be accessed, accessing guest memory
> > can fault, and page faults might sleep, which isn't allowed while IRQs =
are
> > disabled.  Not acquiring SRCU means the (hypothetical) illegal sleep wo=
uld
> > be flagged when running with PROVE_RCU=3Dy, even if DEBUG_ATOMIC_SLEEP=
=3Dn.
> >
> > Note, performance is NOT a motivating factor, as SRCU lock/unlock only
> > adds ~15 cycles of latency to fastpath VM-Exits.  I.e. overhead isn't a
> > concern _if_ SRCU protection needs to be extended beyond PMU events, e.=
g.
> > to honor userspace MSR filters.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---

...

> > @@ -968,12 +968,14 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu=
 *vcpu,
> >  			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
> >  		return;
> > =20
> > +	idx =3D srcu_read_lock(&vcpu->kvm->srcu);
>=20
> It looks the asset what "kvm->srcu" protects here is
> kvm->arch.pmu_event_filter which is only read by pmc_is_event_allowed().
> Besides here, pmc_is_event_allowed() is called by reprogram_counter() but
> without srcu_read_lock()/srcu_read_unlock() protection.

No, reprogram_counter() is only called called in the context of KVM_RUN, i.=
e. with
the vCPU loaded and thus with kvm->srcu already head for read (acquired by
kvm_arch_vcpu_ioctl_run()).
=20
> So should we shrink the protection range further and move the
> srcu_read_lock()/srcu_read_unlock() pair into pmc_is_event_allowed()
> helper? The side effect is it would bring some extra overhead since
> srcu_read_lock()/srcu_read_unlock() could be called multiple times.

No, I don't think it's worth getting that precise.  As you note, there will=
 be
extra overhead, and it could actually become non-trivial amount of overhead=
,
albeit in a somewhat pathological scenario.  And cpl_is_matched() is easy t=
o
audit, i.e. is very low risk with respect to having "bad" behavior that's h=
idden
by virtue of holding SRCU.

E.g. if the guest is using all general purpose PMCs to count instructions
retired, then KVM would acquire/release SRCU 8+ times.  On Intel, the fastp=
ath
can run in <800 cycles.  Adding 8 * 2 full memory barriers (difficult to me=
asure,
but somewhere in the neighborhood of ~10 cycles per barrier) would increase=
 the
latency by 10-20%.

Again, that's an extreme scenario, but since there's almost nothing to gain=
 from
pushing SRCU acquisition into the filter checks, I don't see any reason to =
go
with an approach that we *know* is sub-optimal.

> An alternative could be to add srcu_read_lock()/srcu_read_unlock() around
> pmc_is_event_allowed() in=C2=A0reprogram_counter() helper as well.

As above, there's no need to modify reprogram_counter().  I don't see any f=
uture
where reprogram_counter() would be safe to call in the fastpath, there's si=
mply
too much going on, i.e. I think reprogram_counter() will always be a non-is=
sue.

