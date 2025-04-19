Return-Path: <kvm+bounces-43689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F3D7A940BA
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 03:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E391C1B61989
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 01:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8459B78F3A;
	Sat, 19 Apr 2025 01:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AeolmxXk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5648214012
	for <kvm@vger.kernel.org>; Sat, 19 Apr 2025 01:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745024912; cv=none; b=CAfQfz1UNvAX0Lx0JQ67X1RlSLCP5ZTKlIy6cTEgzMn8Uyn4UiwDhuf+wl9ev1uekYKYgVn3ahdPq2Kzk+TW00foYqCZmRMY9U0mZUDhqqdYRzLqXuDaakaKnt14OvloBpzKxYQ3unyvjY+hunx6OZ4qf1O9JwfOgYrZeRCRD54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745024912; c=relaxed/simple;
	bh=cU2tHaXn2pOKzWFOKUzDs+vE1QW3JSZ+sVLoQvJ40U0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QiFlAdqJRpn4ve7guuiwWzcDUry1lItu/rkr4H06/3jYZ6e2nlGJdnkbjh4FQxEfmr6gI1H1qDXmNRGfW61NyJpeef0o0z/kZfVaY/IGK8I2rW381AaXjXgv8gGJ2dKwqSoh/jQyYqCQl/AFsU+rNuYrg5qrqxoA7fdk3P6BCUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AeolmxXk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso2146147a91.0
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 18:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745024910; x=1745629710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mIH8+9dmxep9+Z84JNZHTxNcz8JapbeaUZwNMPKkJbk=;
        b=AeolmxXkTz/xBvLtEZGsgN1mnu4UN5zLKyq1p5kJUzU5LhS5vgy9Scw7fKUWLF2mKe
         6N3ixiv3+13mbD/YCEuXGl7vg1BSi8INw7MoEYPMhT0U0dSzMBset4VxGmU9h1NKWQ5D
         CX5UTlNReSRT0mJkL64uNmsMSKnDn87IlY2ojLZPk64s8WvRQMKFhDsncfkr/uVqD+R8
         nkytNFRmYoiMPvmFzd2YxviWfFsL7GHwspSGWSKcyAmH0S5SLEjxvPz+SWU5ib6lOPDI
         eX0ok0KSX5Zx65BjCnl4Xz1NIyn1DhHlMui/2Xk7lHK8k2r4vDVJKZhahxnbamMypTkw
         Fg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745024910; x=1745629710;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mIH8+9dmxep9+Z84JNZHTxNcz8JapbeaUZwNMPKkJbk=;
        b=EDHzbhu6ovb+YTVQ7W8c0uAjkeVAtYwxnBcn/X7/W3z2WBm233xME3vmk2Sc9dIb5q
         Q81/Dz9++ZJpJBJXlzAJsHzcYiCRIX1IKohgO3H9XPId9K9290x6GbiPUjXwOwwRd3yF
         z4baLAO0hRWiRpGF3Bg2lgBg3c1h+nYcGVmlDuwQJ8auMw2CsQVFW8ggTSSIfL89E+Qh
         9Rx2MrMKplvRdSN6XASltX14iBeDOC/uEYAfT/HhLhYlkP5KRlxjLTxdPVmQNhiCxG/A
         rm3nq+Pbmm2yHA0WCt0+OY3GGjVmaB3/twe6kv2LRGMDTQPej2QTuRvwYocFMDT+udgh
         q/Zg==
X-Forwarded-Encrypted: i=1; AJvYcCUhSwa/i45ACD/NhYRxCtduWLkjtKoLutsRcAr5Z3R/hJgLO33jmXsErkFulvZfqgwlLAM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4EuH9u+k/3js68mJudwcf2N/5PaiWFncux6YOOr+nE4uyRC4y
	TdZbLfKe6UcpLnL6eZ6MwSmsTX0J1Q5pFw4o5Lky6yLz1KoPFyab4uyS+NgExhDOL/S3sTEFxDj
	j0g==
X-Google-Smtp-Source: AGHT+IHZhSXXubTpCFlOOnEIvHU467QNmKjXZoPNQezYYBYMwUyEsWt9k+iXgKJhh/FN2m03pEsubHOIrwo=
X-Received: from pjyp13.prod.google.com ([2002:a17:90a:e70d:b0:2fc:2ee0:d38a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53c5:b0:2ee:8430:b831
 with SMTP id 98e67ed59e1d1-3087bb3e7a6mr7256764a91.2.1745024910614; Fri, 18
 Apr 2025 18:08:30 -0700 (PDT)
Date: Fri, 18 Apr 2025 18:08:29 -0700
In-Reply-To: <CAGtprH8EhU_XNuQUhCPonwfbhpg+faHx+CdtbSRouMA38eSGCw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250417131945.109053-1-adrian.hunter@intel.com>
 <20250417131945.109053-2-adrian.hunter@intel.com> <CAGtprH8EhU_XNuQUhCPonwfbhpg+faHx+CdtbSRouMA38eSGCw@mail.gmail.com>
Message-ID: <aAL3jRz3DTL8Ivhv@google.com>
Subject: Re: [PATCH V2 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com, mlevitsk@redhat.com, 
	kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025, Vishal Annapurve wrote:
> On Thu, Apr 17, 2025 at 6:20=E2=80=AFAM Adrian Hunter <adrian.hunter@inte=
l.com> wrote:
> >
> > ...
> > +static int tdx_terminate_vm(struct kvm *kvm)
> > +{
> > +       int r =3D 0;
> > +
> > +       guard(mutex)(&kvm->lock);
> > +       cpus_read_lock();
> > +
> > +       if (!kvm_trylock_all_vcpus(kvm)) {
>=20
> Does this need to be a trylock variant? Is userspace expected to keep
> retrying this operation indefinitely?

Userspace is expected to not be stupid, i.e. not be doing things with vCPUs=
 when
terminating the VM.  This is already rather unpleasant, I'd rather not have=
 to
think hard about what could go wrong if KVM has to wait on all vCPU mutexes=
.

