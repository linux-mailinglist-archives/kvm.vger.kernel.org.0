Return-Path: <kvm+bounces-67269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 035BAD0001D
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DC0DB3014DF8
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F47F33858A;
	Wed,  7 Jan 2026 20:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m/0lqQoN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467AC2D8DDB
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817641; cv=none; b=Ny1t6yrLbWtjJf3PRyqnsGQZ3Vf8v0jWWchDhXE+s1FK6qOGG3Vyk1GekZzWiOLrG8HurKbU8LOGgql9uzKt/WpFdhdil383VN1kYrdP+SbyZ5pjUPaQ24R7iy1HN3wex8rHsmSilQC6bLp5ihBW90xyfN3rZ/pVZRmJqbh5dV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817641; c=relaxed/simple;
	bh=p/oK5Bmsh2siMeoB4Sq+v4wsq+VZG/J9p3QZJrR72Gg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AKKOaOBmF2B7W1uvNQC+qqObkviFV9rMFgoF2ftS2ZMJRasUd1u775jCuheaY3VzjzdgkVbc0p5PIAX0Cx/+tEl/Vt9JAGxH1rA/oai1Kb8ScV7U1d016I8syOmDLQGpfIqMarDebvODO1atYC+356BR4zvuK8y/wv0TF2D0BNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m/0lqQoN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f177f4d02so36549995ad.2
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767817639; x=1768422439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r8JCfDkw+QkeOmECffrrLkDd+5KJ3bAvQIYDVGkdr+c=;
        b=m/0lqQoN8NP4EUBIqh2yG3+OjxBC+TuIXrBOdiOJCtlWB4jdvTibb0xZuTkjXG4QVq
         pXwSglH6GTf3htAVoWdX/vgHU3fYjABwpxHzuwt50BNVRhbIEzHJDnIuEzWOI3FMe8Cq
         HNEqAtgYbow0XdYXdlmhXFGdsWbfHZi9pH89w1J8VisdQxtz8DEaR0+88Apdj9ZvE8Bj
         k77JbwKrppy/Q9ArJ/SAUZjPlxWqxuyrdLUJ4ZjJzK4RwFI3UK4GZU6PoksTZYcKQp0Q
         AhEtpLlGeSL5vtDpRhwcMTDzZ1I2zrij4+B+HoSJDLeq8o4aUVSjKp1fuWuQHOb4k5HV
         4gjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817639; x=1768422439;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r8JCfDkw+QkeOmECffrrLkDd+5KJ3bAvQIYDVGkdr+c=;
        b=ZeU8eMD5dLyQTqXIUbrP29WshjByl2CPFgF4UGbyXhHY4hpm3TCJeQLcy4xxDe9WBT
         Xt4OZio69OORVfVWckokrwOA9MVpumE9PJ+NVKpT2FTZK+64iUhK2vzrtqrji7j/Mmf8
         Zrjclegvyn74S7t1Bn0CapsZc5LE8Y+xHyOEGCCm8kKRTEBCXxyfXuNIT1qSBjBSYzxP
         Y3MZzKYxqr5uireLXyFlZU9JHPsJAqlvumzwdTN709RkFlqWc0q1/aMU7Iz1dV+7rHDN
         jDqeNzUKtg09YINcAmjyoqZtkVRx4UPQFGJeRjnSKpFmHwDhLydnxGGETOtJl+/YAWih
         UvyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW/IWX6RkaDvGi6YAbO6XkGhy4yOegyF2li65FMoekX5P/5fdoN39rgiqV7J6VYpG0Qdc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDYuB7GWGC+WZ/RI/7nG1hPB0PMz6t2d5T9PKcAS7ZhAqJY2xP
	mh5Zm2MvlwIBw0gE/QLw/XZj9rw7OH+OhCwM95SrrVrZ+u52K8GixSs5tYRBC2/xZHU5+d9tzyM
	A+z1KyQ==
X-Google-Smtp-Source: AGHT+IH6m3f76l6yku6MzokNsOCaSmhZodZjwP6CfTO6JSklzF6cEWk3kWQxsyjylQvGnXRVGHq+qWLVkNs=
X-Received: from plbku7.prod.google.com ([2002:a17:903:2887:b0:29f:13e0:4d8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce08:b0:295:54cb:16ac
 with SMTP id d9443c01a7336-2a3ee44252dmr36132945ad.18.1767817639553; Wed, 07
 Jan 2026 12:27:19 -0800 (PST)
Date: Wed, 7 Jan 2026 12:27:18 -0800
In-Reply-To: <741984276082955190f9bf9cedc244cb3cab1556.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <741984276082955190f9bf9cedc244cb3cab1556.camel@intel.com>
Message-ID: <aV7Bpnbbf5qfXv1J@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Fan Du <fan.du@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>, 
	Ira Weiny <ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	Chao P Peng <chao.p.peng@intel.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, Vishal Annapurve <vannapurve@google.com>, 
	"sagis@google.com" <sagis@google.com>, Chao Gao <chao.gao@intel.com>, Jun Miao <jun.miao@intel.com>, 
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2026, Rick P Edgecombe wrote:
> On Tue, 2026-01-06 at 15:43 -0800, Sean Christopherson wrote:
> > Mapping a hugepage for memory that KVM _knows_ is contiguous and homoge=
nous is
> > conceptually totally fine, i.e. I'm not totally opposed to adding suppo=
rt for
> > mapping multiple guest_memfd folios with a single hugepage.=C2=A0=C2=A0=
 As to whether we
> > do (a) nothing, (b) change the refcounting, or (c) add support for mapp=
ing
> > multiple folios in one page, probably comes down to which option provid=
es "good
> > enough" performance without incurring too much complexity.
>=20
> Can we add "whether we can push it off to the future" to the consideratio=
ns
> list? The in-flight gmem stuff is pretty complex and this doesn't seem to=
 have
> an ABI intersection.

Ya, for sure.  The only wrinkle I can think of is if the refcounting someho=
w
bleeds into userspace, but that seems like it'd be a flaw on its own.

