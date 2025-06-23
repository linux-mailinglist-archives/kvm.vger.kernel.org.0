Return-Path: <kvm+bounces-50419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A03AAE51F9
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 23:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 319464A4D59
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 21:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02372236E5;
	Mon, 23 Jun 2025 21:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tpGaODKZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA44E22256B
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 21:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714752; cv=none; b=QKE6DZxVImtGss7xgQD9oING88TxCgYq1ntB+9zJmepXHIjYj+4Y28n6rIQ5UkeQDiFtP1shDl6C0ffqHXaszsGjVUF07cMiYgiCzjCGi6k7e6Jnp4jBQG31jr0kAqULK3y6TpnPMp3NV9nSEE1oTAJqxU9foMPjMi7DqHL+gEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714752; c=relaxed/simple;
	bh=eXldYpUZaeRaLaz31ERRjXhLWMEa7FVZz4U7H8GVh/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iLk168eKrMSGxS0PJLWO+JbvwSUmsDt2Ueu8agOfUuUIP9bE0KnuxKnqRvBvoQTO7JMV2161QeJ01NT+uX6Sn2vYHSBCOoeb/IGaMCaBecJHYXbofdPdeKpQofR6imWKuhzURXO6kU05GDA7VMsvTRti+OA3uizgJ7e/r5knRFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tpGaODKZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313ff01d2a6so4251702a91.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 14:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750714750; x=1751319550; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hdZ9ggIqKXdhrqZObdqtyNtpTDp5cCQfn7e8zo3QPWM=;
        b=tpGaODKZdjnKnlGLE4MvDOuThJ7/a/RC4MMnDh3hru+sRs21+iXPPYmf8Wc/SVRA6q
         l7NkR9fyUciSNxCiW6wqZENG6LBIB0YjlXdL4hXn4PKolVlaeLKwOoEwDB8rHUw4H462
         HcWhl6MHmmSHV6ECtv8Og7UjkEXH3ho5zd8CyvidY1UBgPdGuhao2wKmC6Kn1dPTOY2U
         aSIjT7DD5dJr/bct2jitMnRK8E8fZgT9dNkMISIbj43eSdrIwEyBFr5fVadh+FTlM/PN
         o7Ua4Ur7CKaX4kGTLYPKxoFy/HTOHftAYogoc3u3jaJlFZB9xchw26nkHNFcFSlSDvXo
         9k4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750714750; x=1751319550;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hdZ9ggIqKXdhrqZObdqtyNtpTDp5cCQfn7e8zo3QPWM=;
        b=l76KK5a14xtO577/Z6m/hE2TjHZLf34i/MrfYaiJbBfe3CbWxUrKiiuW/XJsmdOgih
         ngnCg7BNWdJ11T2bFrRVhVWkAdM6ZeypEb1yEJ9ANykMs+lY6t412VsoDq7fgIBW4t7g
         c8Ci9yhZgoYIAd8i+TPcMXArQrAYV6p9oYFyFBtNhz1Hjwu5dB2a/R5mrqooght8zqU4
         P8Ci+fqbqxInDccyuU9x/xhVm9gFybAQgosvMv56R0NsWvyVVBiv6kB9fFlSJuJtrCUE
         4kwN5BQAX06V0+sYrM037OGetZpJjehKitAgr3K6w6/Prv80PZ/t5jvBbhGm0VhvlSsC
         tMTw==
X-Forwarded-Encrypted: i=1; AJvYcCVRRKdMNOO/WT+khQIU1Dh5NjcnDBoOnNl/5TIbrYqdu0sGJ5HxIGUD+R8mkDT1J2/U4aE=@vger.kernel.org
X-Gm-Message-State: AOJu0YztkpGTNKnqUqLFjFTFmKFpLxWeBps0z6VqVmnmnX6bclir1MQy
	G+47QjCqGeuho0dHzb8DkRgnmM+rL2Bv0/LyMB/3lkfqT9UbM6ignhoqMJK+/VA/0tJoVTAgkA1
	lpnNyBQ==
X-Google-Smtp-Source: AGHT+IEzqG3n0y5161u/luLAcfmwBwwuJeMdqAPyrG33houtRrHG/50JvM0fIgasBypzcMbezmSvflzf63c=
X-Received: from pjbta6.prod.google.com ([2002:a17:90b:4ec6:b0:312:e5dd:9248])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c09:b0:311:e8cc:4256
 with SMTP id 98e67ed59e1d1-3159d8cf694mr16970566a91.22.1750714750031; Mon, 23
 Jun 2025 14:39:10 -0700 (PDT)
Date: Mon, 23 Jun 2025 14:39:02 -0700
In-Reply-To: <CAGtprH_9uq-FHHQ=APwgVCe+=_o=yrfCS9snAJfhcg3fr7Qs-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611095158.19398-2-adrian.hunter@intel.com>
 <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com> <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com> <aFNa7L74tjztduT-@google.com>
 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com> <aFVvDh7tTTXhX13f@google.com>
 <CAGtprH-an308biSmM=c=W2FS2XeOWM9CxB3vWu9D=LD__baWUQ@mail.gmail.com> <CAGtprH_9uq-FHHQ=APwgVCe+=_o=yrfCS9snAJfhcg3fr7Qs-g@mail.gmail.com>
Message-ID: <aFnJdn0nHSrRoOnJ@google.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2025, Vishal Annapurve wrote:
> On Fri, Jun 20, 2025 at 9:14=E2=80=AFAM Vishal Annapurve <vannapurve@goog=
le.com> wrote:
> > Adrian's suggestion makes sense and it should be functional but I am
> > running into some issues which likely need to be resolved on the
> > userspace side. I will keep this thread updated.
> >
> > Currently testing this reboot flow:
> > 1) Issue KVM_TDX_TERMINATE_VM on the old VM.
> > 2) Close the VM fd.
> > 3) Create a new VM fd.
> > 4) Link the old guest_memfd handles to the new VM fd.
> > 5) Close the old guest_memfd handles.
> > 6) Register memslots on the new VM using the linked guest_memfd handles=
.
> >
>=20
> Apparently mmap takes a refcount on backing files.

Heh, yep.

> So basically I had to modify the reboot flow as:
> 1) Issue KVM_TDX_TERMINATE_VM on the old VM.
> 2) Close the VM fd.
> 3) Create a new VM fd.
> 4) Link the old guest_memfd handles to the new VM fd.
> 5) Unmap the VMAs backed by the guest memfd
> 6) Close the old guest_memfd handles. -> Results in VM destruction
> 7) Setup new VMAs backed by linked guest_memfd handles.
> 8) Register memslots on the new VM using the linked guest_memfd handles.
>=20
> I think the issue simply is that we have tied guest_memfd lifecycle
> with VM lifecycle and that discussion is out of scope for this patch.

I wouldn't say it's entirely out of scope.  E.g. if there's a blocking prob=
lem
_in the kernel_ that prevents utilizing KVM_TDX_TERMINATE_VM, then we defin=
itely
want to sort that out before adding support for KVM_TDX_TERMINATE_VM.

But IIUC, the hiccups you've encountered essentially fall into the category=
 of
"working as intended", albeit with a lot of not-so-obvious behaviors and de=
pendencies.

