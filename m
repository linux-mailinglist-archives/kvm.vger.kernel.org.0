Return-Path: <kvm+bounces-51776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E770EAFCE1E
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C01181884B08
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA78D2E06D7;
	Tue,  8 Jul 2025 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SP9ycgxx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD41A226D0A
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985869; cv=none; b=WMIZFwh28TKeUunaQanUmbDu+UMnetlz8EqvPmWt3yklPVTIa6Wittsd9TXtXIJPtGCPJ0ErM3OFG7SV779e0llOmuOCw8d0dVmnn2RgZauDFjwAKDFKqKO/nRgDIhXaJp4mBQROuEFiey88hULWqDrxldzcfh572YhfPFr9GOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985869; c=relaxed/simple;
	bh=TXEGRBsgm+n8P+t42R28we4U8CCik0hjXIM15uylAJU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OBik2/LCFCu6yV7wTzpPjqPACPn1vILJQbCTmMKkdEuWEpogJjrgMj4TGvaFtsUv4Z1oOfAw4fSyqQ5nRe9T7IgXfHoW8f1MT2y+LFUrz99zwtqIxbvD+bOFfhpxPqX9n0ll2mdMBa2dv50jezUa6u0J3oWz5kK0PjpwGIq7uW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SP9ycgxx; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74913385dd8so6104996b3a.0
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751985866; x=1752590666; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4Y0LHIYImOnqvxWJNSqr5NHEbLMZdgrbi8mWqVwvxE=;
        b=SP9ycgxxWe9uVDqLKT9uTgkRWv3yG8pB5WdXkOTT8grhG4s7QcHhSos1qYPoE6Z1Hd
         vb4nm45o4AHRi2Hsz0OEgup02EenohWOdAwVO3wBNGLE4H37W/fWR1rERjn69jIaK98l
         RLqcinvtVVYQ8qXJGcVYxKH709aiXBnUbn3fVQFFdagSsYfAWpK4DiJq6U1HCIGtsCHP
         8TME3OvW0X+LMpVVYIAn469JBEtjSi2UqqZN9BZEHcMDs91febIdzQetXqgJmWMCDsHp
         xtKckyXavrhDmvgtaUupof/MdHPWz+hYuaj4mE25G7idqQ/zttbeWk/DL+DOpf6oHopO
         aBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985866; x=1752590666;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M4Y0LHIYImOnqvxWJNSqr5NHEbLMZdgrbi8mWqVwvxE=;
        b=jWqJKDyrhzlrnPa4xgBP1kz4rf8JnUecgDXiMRlUQ4h+IQsmJbm096LuH1f1eYrbfW
         ElfabxsXvk0m0th9eb1zXr/eepyW43o1/VPgt8CV6R1+Q41Gc2G0io6geqruDN0Uvjow
         nJH8bKZrsdqRN+zsiB8akJBEtV1sQfL0AUYCWEYCfd2CVx3RzT7JRpkf4k3q6A0Wb+RR
         5AkNk7qOC7ItuosdHxDbQ5aoc1OObaD+7YuscpuageJNBOYLiKRpMg2adyvWXdhAUmgC
         RKzR7uHhLeFqhmy5OqbRb+HRW9Q/jCFioTg7TNln2bv2OzFxmeV4YUWUFt3VVVWs0RDA
         d0sA==
X-Forwarded-Encrypted: i=1; AJvYcCUry9xx4P3wo4hZtuRRCQFCOSZOnGndgiSR7VEetm4jApiml2ivDXzmElqfCbfDukRl6kk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh7MP8RShr4cGGnGdef3IDYASrcppuGzDEktR4u/q5evMRQyj/
	PKhjXDbvbcZm0X6pFN/QkTcK2TG+tcNPyPUEI+wsOMZCCG0S2FwS8tJSQzLH3WHYBs4sWsxQUSH
	bHrgbeQ==
X-Google-Smtp-Source: AGHT+IEryFAJQIP1RYdnl3B5+MmSaaqt34bQLLxukJow6DGBXYKU32xvLqLVHhWhYnnjS3IC2/q6uMASVdg=
X-Received: from pfus6.prod.google.com ([2002:a05:6a00:8c6:b0:747:9faf:ed39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:80c:b0:736:5664:53f3
 with SMTP id d2e1a72fcca58-74ce6668f9cmr23430472b3a.15.1751985866098; Tue, 08
 Jul 2025 07:44:26 -0700 (PDT)
Date: Tue, 8 Jul 2025 07:44:24 -0700
In-Reply-To: <bdd84a04818a40dd1c7f94bb7d47c4a0116d5e5d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250708080314.43081-1-xiaoyao.li@intel.com> <20250708080314.43081-3-xiaoyao.li@intel.com>
 <aG0lK5MiufiTCi9x@google.com> <bdd84a04818a40dd1c7f94bb7d47c4a0116d5e5d.camel@intel.com>
Message-ID: <aG0uyLwxqfKSX72s@google.com>
Subject: Re: [PATCH 2/2] KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Kai Huang <kai.huang@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Reinette Chatre <reinette.chatre@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"hpa@zytor.com" <hpa@zytor.com>, Tony Lindgren <tony.lindgren@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-07-08 at 07:03 -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index c539c2e6109f..efb7d589b672 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -62,7 +62,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *u=
class,
> > > char *op, u32 field,
> > > =C2=A0=C2=A0	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uc=
lass,
> > > field, op, val, err);
> > > =C2=A0 }
> > > =C2=A0=20
> > > -#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
> > > +#define KVM_SUPPORTED_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)
> >=20
> > Would it make sense to rename KVM_SUPPORTED_TD_ATTRS to
> > KVM_SUPPORTED_TDX_ATTRS?
> > The names from common code lack the TD qualifier, and I think it'd be h=
elpful
> > for
> > readers to have have TDX in the name (even though I agree "TD" is more
> > precise).
>=20
> It's useful to know that these are per-TD attributes and not per-TDX modu=
le.
> Especially for TDX_TD_ATTR_DEBUG. I kind of prefer the KVM naming scheme =
that is
> removed in this patch.

Heh, as does Xiaoyao, and me too.  I thought I was just being nitpicky :-)

Though in that case, I think I'd prefer KVM_SUPPORTED_TDX_TD_ATTRS.


