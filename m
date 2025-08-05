Return-Path: <kvm+bounces-54052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC498B1BB3A
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FD781883B75
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03E9275B02;
	Tue,  5 Aug 2025 19:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SPVwXk9r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956FF224B1B
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754423966; cv=none; b=BB2f62ZRM3oc2sFzEFUPplAPtN0wYXWMSr/ZPM1nEszQCWDt08jzX9xn9kyLfGxjvActvxfClEfluNiD6Artu7tA1nLNkz/8VtU9arHiRJM9dBy+ElS8tCDDstu+6xZTcwhyPcC2RnBx1OvIG5YBeltcmN1XfiEv3iIiB1hyHc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754423966; c=relaxed/simple;
	bh=pXhxchSRRgtxWJx8jVY2QY92qQA379bq+J7HbDgvShU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MGki4hJIJl9NY8AUkuufPvv9HDR2XBAkqUiDAnM4jCjAv/knrfzPpGZA8nduMO6o+6ctLVfviMPxTL4dFZNZGTleuxMXlDlanO5yFsHk737f7u/il3cCPkXpIknSYJD9Fn2gmLRnjRRM9oQhpSDsTjTarkFpwbiQucqqfQfJ66Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SPVwXk9r; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3214765a5b9so3551009a91.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754423964; x=1755028764; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w3Yvf2JfDXGKcx67v9ooLLvg0JCE6s5eg0KrtzPSvSI=;
        b=SPVwXk9rlSJWnmlbW2bmHhgn1zxdmjolLq9toYnkL9Odbdz6PFCyss55pgh+ACNQ4H
         I777PmMXBUXYAWa/nQdSh0o34s7qZpy4+v5oKhHw+01mf0ecNLEcbowx9QW2DuwqwKQW
         TEI0U7nzF5nfKSHPH2SN5G6ICc79DUxWGRmAikcrrdcRG45gGv5EjabaMt7DJEEdU8iT
         2VRSE/rL0gb6v7O/oHCDC6BAmWQZs2jPCxZXNlp7NVTII1usZPtiHletraIbxFUZBGDs
         9035KSjs6KHpkuPHWZ8i1g2n/YY0gjLEiapWzwVa5l/xxAHyti25J730jxaEvL07CcDo
         s9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754423964; x=1755028764;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w3Yvf2JfDXGKcx67v9ooLLvg0JCE6s5eg0KrtzPSvSI=;
        b=vtYqyD4STr/0xP+hozQRPnElwr5FWpFNKZcVUT4JQw6OprKFulofmaQIUWTV07R5Fm
         GDYeIJCnsIPNCu0dnpJ4nUDgXIHUkgaNfXr9kJN1MXTMjWnIrwKg/FzjHJTD8CthIbIV
         mXwS092KlfbTQfcXIBBQ0He1vBrQPVMNw6JajJEAgXhjpJYAGHFZELqQgOhnQpOKg6KI
         GEcoSKaXkToa6f2+XMVrVCrUI2zcevDCQFaEWXDl/IgAakBrijzTuxd2qdagJoWj2hQ7
         aMPyqlVWh64Ryk20vfemjaQOED2AoebtVIcDuW6XJfonz9vUKdmMbZgbSme5UBKg+W3o
         gYTg==
X-Forwarded-Encrypted: i=1; AJvYcCVOE4eF9Ae+rcQy6QAPUzxNucTuN//5sLdp/O9Tk4LpsFIQq/BwxoiDUXtlNTiL6t2geRU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5n1y5CXZLULMat0ZeV7veZ1swTSbVESQdEqHKGJ63P0WlkPyz
	k+sJ07fWXsJNiH7z3zzG9kdWgxFQTnIWNaE4xIfWvuhX1+QnueLdybmGPv5VZYAu4gejOYc/QCM
	aPlopAA==
X-Google-Smtp-Source: AGHT+IEuI8KiE77OJVjXZOrcYjc8/vveaA71MtGaUeonbU64/fh8UEXUNZAQbuVlyWgScx/PDrxoAQPbFoQ=
X-Received: from pjbpx16.prod.google.com ([2002:a17:90b:2710:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5584:b0:312:51a9:5d44
 with SMTP id 98e67ed59e1d1-32166c15c64mr147232a91.5.1754423963903; Tue, 05
 Aug 2025 12:59:23 -0700 (PDT)
Date: Tue, 5 Aug 2025 12:59:22 -0700
In-Reply-To: <CAGtprH9ELoYmwA+brSx-kWH5qSK==u8huW=4otEZ5evu_GTvtQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aHUmcxuh0a6WfiVr@google.com> <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com> <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com> <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
 <aIgl7pl5ZiEJKpwk@yzhao56-desk.sh.intel.com> <6888f7e4129b9_ec573294fa@iweiny-mobl.notmuch>
 <aJFOt64k2EFjaufd@google.com> <CAGtprH9ELoYmwA+brSx-kWH5qSK==u8huW=4otEZ5evu_GTvtQ@mail.gmail.com>
Message-ID: <aJJimk8FnfnYaZ2j@google.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Michael Roth <michael.roth@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, david@redhat.com, ackerleytng@google.com, 
	tabba@google.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2025, Vishal Annapurve wrote:
> On Mon, Aug 4, 2025 at 5:22=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > : 4) For SNP, if src !=3D null, make the target pfn to be shared, copy
> > : contents and then make the target pfn back to private.
> >
> > Copying from userspace under spinlock (rwlock) is illegal, as accessing=
 userspace
> > memory might_fault() and thus might_sleep().
>=20
> I would think that a combination of get_user_pages() and
> kmap_local_pfn() will prevent this situation of might_fault().

Yes, but if SNP is using get_user_pages(), then it looks an awful lot like =
the
TDX flow, at which point isn't that an argument for keeping populate()?

> Memory population in my opinion is best solved either by users asserting
> ownership of the memory and writing to it directly or by using guest_memf=
d
> (to be) exposed APIs to populate memory ranges given a source buffer. IMO
> kvm_gmem_populate() is doing something different than both of these optio=
ns.

In a perfect world, yes, guest_memfd would provide a clean, well-defined AP=
I
without needing a complicated dance between vendor code and guest_memfd.  B=
ut,
sadly, the world of CoCo is anything but perfect.  It's not KVM's fault tha=
t
every vendor came up with a different CoCo architecture.  I.e. we can't "fi=
x"
the underlying issue of SNP and TDX having significantly different ways for
initializing private memory.

What we can do is shift as much code to common KVM as possible, e.g. to min=
imize
maintenance costs, reduce boilerplate and/or copy+paste code, provide a con=
sistent
ABI, etc.  Those things always need to be balanced against overall complexi=
ty, but
IMO providing a vendor callback doesn't add anywhere near enough complexity=
 to
justify open coding the same concept in every vendor implementation.

