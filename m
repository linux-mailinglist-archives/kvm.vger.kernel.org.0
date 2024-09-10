Return-Path: <kvm+bounces-26278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB71973B41
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:16:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18843B21CCD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D02198840;
	Tue, 10 Sep 2024 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FSkSmBKb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEDA81205
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725981391; cv=none; b=e1EG8reUjTWjc3JtCb/Ulit7TZ3+Wce+SlQeauajaDR42Lj5j/BvvxK3TWpWjJQPsxaE665HN2H+FOX65cDHC5FHh7Glj04KBPb09AWCBZimENI8MUroQ82RUW6Obai7EOhfspftC3Y8GOl2DB9wt9vEv2yRptRVuKg9E+ddlwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725981391; c=relaxed/simple;
	bh=wF4vyctgMM9SgS/++eIxgGDt7759BR/w2WtM6AANn9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jrwmYE9PXIyRql2Hcrweas9lkrHBEZoo8EoIdWYEK02d12m1URCMyyOE3vptDzRZPv2MIIvGMKeWf/1l+Sdas0nWb0MJNzqi3KVSg4KFvlzQ3iqG4hNK3oyHf+qZjr9vYG0pc/AhppN9FIdlaP50IxbmzxyCdqHPioqc9SKExfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FSkSmBKb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725981389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mklp9pGql4hBvPJCZKxHS9qvQI+U2JzUn2xs9sIn9F8=;
	b=FSkSmBKbczjV3Cxm2Wh9Tq4Ta8r9P2Ilcgw3Ye6pfWX9Opw7uk62hHh6vQKaJe9nW2NLNo
	4E8C8kNQn+P15fYnYLMwKzFmtnU7isB4uoAAWLWGz/14WUU8Ewt6nSeBh70tvW2+su7/tD
	4jAIzJMy76QHlVOKwZ7chwVFfRS3HTg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-qoD8bSZXMDuQTVrVpy-nfQ-1; Tue, 10 Sep 2024 11:16:27 -0400
X-MC-Unique: qoD8bSZXMDuQTVrVpy-nfQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-378ab5b74e1so393816f8f.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 08:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725981387; x=1726586187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mklp9pGql4hBvPJCZKxHS9qvQI+U2JzUn2xs9sIn9F8=;
        b=KBU9NYHs74+5zIlmZBhHwLvI0YjlL/dvPE5hNLt7goQPKKAja+eAA3/x+7gB6ZJ8l0
         q+47fQI91cTPX0DYWdiUnRFsibRFHigija8oUCzuLGDOyHJpnH0N4BHqF9ecjm2sg6Qd
         UR+40o6aHSqHZIRM0pjgcUqkuskW+cjHq0pRyledaXW49WSABSVVuZOMxACA165gnUwK
         KHx6XLsRGLomxhSQ49waDDqLrMmblcEWGT5KvX3dSJi9W/A+vjv5/QA/zlzkymcDK9ZG
         fBFeVqHUOTGEw6PrLKIo2WBbzK5o1NnPFA3Wd7yMweCbiUEngwAdNOZFmS1EclCcSZ9k
         //kA==
X-Forwarded-Encrypted: i=1; AJvYcCXAsmqgLMg7Lu42d7wHlb2oCtqldMxyE/pKrT1OXqVF9Ag5Ew0yYr1K6kuBqA4LSduwRUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBE5CqJAPsmIRR//EpYJsaskTdl679VFQCwVpesq5rGTLz6CYs
	RRSYsGaRGWRZ1wCCx8WKLNB7c91Lura8g+bH52bwxcZQAd04U89n8FWzDC6xvpcsAYIDC66nycL
	YPY0b+2jOy0suCZCzLscEs2PJyVlngXIvKziUJvfCIu/AkHtFFy6Ie7iJZzSVdFV9M7hxHpWVdu
	CZ7qRvhH6O3cNgTKTpeaLp+O2c
X-Received: by 2002:a05:6000:25a:b0:371:9360:c4a8 with SMTP id ffacd0b85a97d-378895b7966mr7280897f8f.6.1725981386630;
        Tue, 10 Sep 2024 08:16:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsSzLiEhAelNJyVR1wTIGazM0zcD0n/USsPoj/yAvsiXdOzgl8RO4389o43ivD4GAxxvJLiTxbyTWw8eZg/sc=
X-Received: by 2002:a05:6000:25a:b0:371:9360:c4a8 with SMTP id
 ffacd0b85a97d-378895b7966mr7280877f8f.6.1725981386122; Tue, 10 Sep 2024
 08:16:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com> <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com> <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com>
In-Reply-To: <ZuBQYvY6Ib4ZYBgx@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 10 Sep 2024 17:16:13 +0200
Message-ID: <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Yuan Yao <yuan.yao@intel.com>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	Kai Huang <kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2024 at 3:58=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> On Tue, Sep 10, 2024, Paolo Bonzini wrote:
> No, because that defeates the purpose of having mmu_lock be a rwlock.

But if this part of the TDX module is wrapped in a single big
try_lock, there's no difference in spinning around busy seamcalls, or
doing spin_lock(&kvm->arch.seamcall_lock). All of them hit contention
in the same way.  With respect to FROZEN_SPTE...

> > This way we know that "busy" errors must come from the guest and have s=
et
> > HOST_PRIORITY.
>
> We should be able to achieve that without a VM-wide spinlock.  My thought=
 (from
> v11?) was to effectively use the FROZEN_SPTE bit as a per-SPTE spinlock, =
i.e. keep
> it set until the SEAMCALL completes.

Only if the TDX module returns BUSY per-SPTE (as suggested by 18.1.3,
which documents that the TDX module returns TDX_OPERAND_BUSY on a
CMPXCHG failure). If it returns BUSY per-VM, FROZEN_SPTE is not enough
to prevent contention in the TDX module.

If we want to be a bit more optimistic, let's do something more
sophisticated, like only take the lock after the first busy reply. But
the spinlock is the easiest way to completely remove host-induced
TDX_OPERAND_BUSY, and only have to deal with guest-induced ones.

> > It is still kinda bad that guests can force the VMM to loop, but the VM=
M can
> > always say enough is enough.  In other words, let's assume that a limit=
 of
> > 16 is probably appropriate but we can also increase the limit and crash=
 the
> > VM if things become ridiculous.
>
> 2 :-)
>
> One try that guarantees no other host task is accessing the S-EPT entry, =
and a
> second try after blasting IPI to kick vCPUs to ensure no guest-side task =
has
> locked the S-EPT entry.

Fair enough. Though in principle it is possible to race and have the
vCPU re-run and re-issue a TDG call before KVM re-issues the TDH call.
So I would make it 5 or so just to be safe.

> My concern with an arbitrary retry loop is that we'll essentially propaga=
te the
> TDX module issues to the broader kernel.  Each of those SEAMCALLs is sloo=
ow, so
> retrying even ~20 times could exceed the system's tolerances for scheduli=
ng, RCU,
> etc...

How slow are the failed ones? The number of retries is essentially the
cost of successful seamcall / cost of busy seamcall.

If HOST_PRIORITY works, even a not-small-but-not-huge number of
retries would be better than the IPIs. IPIs are not cheap either.

> > For zero step detection, my reading is that it's TDH.VP.ENTER that fail=
s;
> > not any of the MEM seamcalls.  For that one to be resolved, it should b=
e
> > enough to do take and release the mmu_lock back to back, which ensures =
that
> > all pending critical sections have completed (that is,
> > "write_lock(&kvm->mmu_lock); write_unlock(&kvm->mmu_lock);").  And then
> > loop.  Adding a vCPU stat for that one is a good idea, too.
>
> As above and in my discussion with Rick, I would prefer to kick vCPUs to =
force
> forward progress, especially for the zero-step case.  If KVM gets to the =
point
> where it has retried TDH.VP.ENTER on the same fault so many times that ze=
ro-step
> kicks in, then it's time to kick and wait, not keep retrying blindly.

Wait, zero-step detection should _not_ affect TDH.MEM latency. Only
TDH.VP.ENTER is delayed. If it is delayed to the point of failing, we
can do write_lock/write_unlock() in the vCPU entry path.

My issue is that, even if we could make it a bit better by looking at
the TDX module source code, we don't have enough information to make a
good choice.  For now we should start with something _easy_, even if
it may not be the greatest.

Paolo


