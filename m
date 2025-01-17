Return-Path: <kvm+bounces-35786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD126A15269
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13D19166AD7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 15:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6058D1917E4;
	Fri, 17 Jan 2025 15:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K0ZfD13Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3491F15CD74
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737126514; cv=none; b=Bgp8IYmefB9WBT67MDkHZp19RJtAduLS7nqRMFj953fZkFflar8IKZCHyszScIAc1XC/0VlKXUtnqh7Njq88Bfe69nCM9Y26YGyHklJ6zSrjcKDymS/nwHgHKrazJG9m4xGMjITJh+Tu1neQ4d+yDnmXHYXEdtWfgiZbA+JWNZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737126514; c=relaxed/simple;
	bh=bWErs4QOqHckU3k36YBCWG6QozKjHcGpU4f6KrtLWaw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ePvu7f0eWs5GtjhQcU/HNpykWRMmpIgkTUDCrRXDpk7NHRSVu77I7/jBX2li4cI67mdTNM1mzRGA+sVUmCQ1zW578/OAv8mz97YSks1g/k1e1rUlfT2YAk+aUL45sMClDPI/mkJlZ4MoXy6vVygrb06KBNAxUHO9OBd74j1NGRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K0ZfD13Z; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9204f898so4123044a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 07:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737126512; x=1737731312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3YaZGFwmyF9uOBZwFaSh7/G86/LFKPzPcCNcQPwegjc=;
        b=K0ZfD13ZiknqWAfkvVgWMBr2y//c4mMjYLLFDB0GDa5TUE+qjhFBczfKWyF2gUVShT
         76m7PrD2xAuoiCXYvKzUqtrj2wCdUQ+1spS9FT8kVHhYtpzdkMfnbIOSpyqrw6hgh5c9
         aKWArAk70AUaIIEa1KUtGQ7nNVwY5cj6aIHOFpkUzb+H75iCghRsYz5wG+uPguk7bgAe
         X5i88Z2dNsfXKqL0k3cXlVQYvcaAw5TPVxePjKUSR3lauTLkHh/pP7AGfhebTfHbsfIu
         Ly3Cioz5ruamGWFiRZggSqGM6k43E77F8QqOop70702pCD5TuhGSvP/ZU4yW/PZhssUk
         vyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737126512; x=1737731312;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3YaZGFwmyF9uOBZwFaSh7/G86/LFKPzPcCNcQPwegjc=;
        b=mfgZZ7hwUDZ6PKNjRm0ObQTxEBhCai70xGTMFwP2OZOQddWRcwwogKQ8dQ4rfDoXUm
         DZfeW4Ue7/YAIQH5J3jVqEiZd02BhfVFdlj3LVCdi+bfozoTrV/KMB7oLoUgshZuT+9I
         XJqRwlG0qow0eg7g64mB/mTZMOWn6tULuElSeAWBqLxuo5gK4PK3l68lusgD13OOVvkD
         KGi5YaHistQiPaFg1V5WMhGxtrgOfDRDevdE5Fdrcq8cmMqynIwUBAyA7Cy8QE8AcR5v
         tqRglZ8Jij+0UAOG3Wd63hxwlXBjBNkt6WEZH2iOFmFY6Q1SQ6LZSQ5Q2CkaEoUH95ni
         Dpow==
X-Forwarded-Encrypted: i=1; AJvYcCWi6SouTuRdOzncu4/0COukZr3etUqzxkzX6jo+Jtnw18SF4yzNFJMggKD3YNsx5clXF6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDi83C9fMCGQZARuJ25X7RHMa5HkeZKupLMCJjyMtYIRwkNKZ2
	+zqbnduuG7TKS1pUJGuT3eqAj+2GInxqrpYK11DPc45mI+mqLu8uZfWhKTlDrt7kP6vFXO6uLjt
	nZA==
X-Google-Smtp-Source: AGHT+IH4ol7lmKI8KivBFLKJyqPQ8nvh/dW1PSDT4D7jWlQrx8vl201ftRRIOFbIuOhKJqE35WZCQZoLioE=
X-Received: from pjbse11.prod.google.com ([2002:a17:90b:518b:b0:2e9:ee22:8881])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e183:b0:2ee:aed2:c15c
 with SMTP id 98e67ed59e1d1-2f782d4f2cdmr4142592a91.28.1737126512563; Fri, 17
 Jan 2025 07:08:32 -0800 (PST)
Date: Fri, 17 Jan 2025 07:08:31 -0800
In-Reply-To: <85a8bebd3c92292472bd50c6a03d85365c4979b1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com> <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com> <61e66ef579a86deb453bb25febd30f5aec7472fc.camel@intel.com>
 <Z4kcjygm19Qv1dNN@google.com> <19901a08ab931a0200f7c079f36e4b27ed2e1616.camel@intel.com>
 <Z4mGNUPy53WfVEZU@google.com> <80c971e62dc44932b626fd6d22195ba62ceb6db7.camel@intel.com>
 <85a8bebd3c92292472bd50c6a03d85365c4979b1.camel@intel.com>
Message-ID: <Z4pyEis-6gmBrO1k@google.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025, Kai Huang wrote:
> On Fri, 2025-01-17 at 09:53 +0000, Huang, Kai wrote:
> > Btw, IIUC, in case of IRQCHIP split, KVM uses KVM_IRQ_ROUTING_MSI for r=
outes of
> > GSIs.=C2=A0 But it seems KVM only allows level-triggered MSI to be sign=
aled (which is
> > a surprising):
> >=20
> > int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct kvm *kvm, int irq_source_id, int level, bool l=
ine_status)
> > {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_lapic_irq irq;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm_msi_route_invalid(kv=
m, e))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!level)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -1;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_set_msi_irq(kvm, e, &irq=
);
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return kvm_irq_delivery_to_a=
pic(kvm, NULL, &irq, NULL);
> > }
>=20
> Ah sorry this 'level' is not trig_mode.  Please ignore :-)

Yeah :-(  I have misread the use of "level" so, so many times in KVM's IRQ =
code.

