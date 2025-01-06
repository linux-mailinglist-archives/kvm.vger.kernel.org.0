Return-Path: <kvm+bounces-34648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E72B9A03389
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 00:49:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C1983A06D4
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 23:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED98E1E2317;
	Mon,  6 Jan 2025 23:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TirlTpII"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFA91E1A28
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 23:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736207383; cv=none; b=VxrF81Z42HuKgONfrTNnM6f5VHBvNimzAFOvIrnV40mkZBeNUdRxpByZXnvTQ/PQnW3auy1reV/qhQbMJz/IyV+j6j422i7TwQ0C2OeO/VpO5Wpt3iPqh9kxGNridBvYtLCHNUWGEHfwKt2sr0t7ohEVqNDtf5h/O3Ys0W4eVg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736207383; c=relaxed/simple;
	bh=LeksPA2aHWOWxkjOZmohp5++dprnR2b8TpT1nllhgtA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rbyHNZIZHvmbqoRRa4BclqcGpTw8vqh0DdmuRfSu/dAsVXv98LfXJqIpsbMQvgggsfcBGEM0pNb/nKCC6MSWQHVjCfcSjhJqMMJ1D11a5AzCc2vwQ6s4PIOBTxQX/+80QjsQWqH0G972WIEgKqx0AaPnmlZUURhZ2079cdxXZYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TirlTpII; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef7fbd99a6so20788843a91.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 15:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736207381; x=1736812181; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P8KvKEJrNmwb2uW1NJHV/ldlGxsuuLV7shvQVTGfzPc=;
        b=TirlTpIImxSKb7Wldh6ZCcPrt9VqWvicuL6CHxla21nKluilpBTPF/F1UV7LLn0p0J
         61FwlZwAk/9ssW9P+AaZxS6Wlpkf33Voq7smtVkRE7fiECGbaREjR/MPoOSOeqfnfCRf
         oG3GnBOzXUzqvzbSe99/0Nceaba+K2Ni2kOBXkkTtWhG2FEre0chKDBoFDhJTZeNKLHi
         3sSL2FwLBBXVPqfKZIZUoVVhegTTKlnPlavdMkl1CUK8y/Ao38HOAQyvZgqnh/WATu16
         gyPUX7rUBIkPu28ce9kDvy2GK0z5qXVR/fkOW09VsugO++Xq9PX9U5F8nrZSE6wBAX/V
         ym/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736207381; x=1736812181;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P8KvKEJrNmwb2uW1NJHV/ldlGxsuuLV7shvQVTGfzPc=;
        b=oLPaM+dD/ZjXklTRTCu96VgOzbdb1TIxEgwB91XZzpy9YQDSj8mPBDBVkM4M/Bijq4
         JhnR7lBbJqVDoOjStgBURUWeQwoy9B/4mYOJsjvaj1p12sUdvBMV1Swfsxd+f7D0VSSz
         sQXgOh38H64Zz/EtRAgO0V+iyE+NGbt0oeCYXSYZVP2tXpBJEZPQyoZY7A9S09iMqPnP
         jX6q5b/1YuiNQ2wCiy/TwloQFm6hDjIo7Guqh3faLb531hLEBoSZIeg92SwlvNLrTZ4u
         3yNY6hZX0I//W/q63zngmaIfDwHMGvFBfF3mKVDTOYt96tq+jOTdOtN1KvAtqLjordZo
         VHJQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4e0u43CZRzBtgkSl7SqAKC1wEiTzsvDXKjNKxnGInaJQKP15uqht5jhBkqc6erChj7WQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqKESTogcPr1cYLSEqAQRI/g/1Eb8lpzhaqb5I6jwXwRpo1r+9
	3tLbooo6GrLlP5UkiH79qaKqZ99Mb6jM1w3ZrbScvhdvvnqsD7bb1TxsN/Be58OQYGPrF39Lm1O
	WNQ==
X-Google-Smtp-Source: AGHT+IET+V1UyyJB/gcqviFhIXxdjhULmPls+67Q2bSntTN1ooNqI9R4PqjKGEgEJoLJGTnVCIoD7oDU85w=
X-Received: from pfbay10.prod.google.com ([2002:a05:6a00:300a:b0:728:f1bf:72ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7187:b0:1e5:f930:c6e8
 with SMTP id adf61e73a8af0-1e5f930c7efmr71092337637.4.1736207380808; Mon, 06
 Jan 2025 15:49:40 -0800 (PST)
Date: Mon, 6 Jan 2025 15:49:39 -0800
In-Reply-To: <Z2kp11RuI1zJe2t0@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241115084600.12174-1-yan.y.zhao@intel.com> <CABgObfbukWu5srwDGA-orsd35VRk-ZGmqbMzoCfwQvN-HMHDnw@mail.gmail.com>
 <Z2kp11RuI1zJe2t0@yzhao56-desk.sh.intel.com>
Message-ID: <Z3xsE_ixvNiSC4ij@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Only zap valid non-mirror roots in kvm_zap_gfn_range()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, rick.p.edgecombe@intel.com, 
	binbin.wu@linux.intel.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2024, Yan Zhao wrote:
> On Sun, Dec 22, 2024 at 08:28:56PM +0100, Paolo Bonzini wrote:
> > On Fri, Nov 15, 2024 at 9:50=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > > Sean also suggested making the self-snoop feature a hard dependency f=
or
> > > enabling TDX [2].
> > >
> > > That is because
> > > - TDX shared EPT is able to reuse the memory type specified in VMX's =
code
> > >   as long as guest MTRRs are not referenced.
> > > - KVM does not call kvm_zap_gfn_range() when attaching/detaching
> > >   non-coherent DMA devices when the CPU have feature self-snoop. [3]
> > >
> > > However, [3] cannot be guaranteed after commit 9d70f3fec144 ("Revert =
"KVM:
> > > VMX: Always honor guest PAT on CPUs that support self-snoop"), which =
was
> > > due to a regression with the bochsdrm driver.
> >=20
> > I think we should treat honoring of guest PAT like zap-memslot-only,
> > and make it a quirk that TDX disables.  Making it a quirk adds a bit of
> > complexity, but it documents why the code exists and it makes it easy f=
or
> > TDX to disable it.

Belated +1.  Adding a quirk for honoring guest PAT was on my todo list.  A =
quirk
also allows setups that don't provide a Bochs device to honor guest PAT, wh=
ich
IIRC is needed for virtio-gpu with a non-snooping graphics device.

> Thanks! Will do in this way after the new year.

Nice!  One oddity to keep in mind when documenting the quirk is that KVM al=
ways
honors guest PAT when running on AMD.  :-/

