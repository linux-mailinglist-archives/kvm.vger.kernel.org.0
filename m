Return-Path: <kvm+bounces-50132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6DFAE20D5
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F13F57AC681
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41042E3366;
	Fri, 20 Jun 2025 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrFtQNNZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9D5E56A
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750440262; cv=none; b=l70AbB7PgORE4k+le2zsVl2vzdARwu/gJOSDWwXBizPXYAnaMBpI0NhX7zATNEIiGuuyuiQ2Co7l4MjnMsATFaD6SUhD58rgRf6vat8R1IsL72hCN15+ruQVj6NjvJHZ2t416XFEsJQyhjEMJ2IS81tPns7AhndzWduLzYGPmLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750440262; c=relaxed/simple;
	bh=ouz3BUK71qOdTrcFId1tCc8lvLAtnHB4kyG9Fz0uMwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rxnBbBflH0Qlrr49hlMmIy7r9YRoCo26zGD616yjU9x0MkhTaixnrMn+CagNfPxMJbiKfi2afKZK3di9oZm25SxWJ1H83EM4kUZL1rF4z+N7jmJGepJtoIwpsbWc/Re9s1QjcUC14oP4ZrtJqG85trmLz1lrPMCeVrEvJ9wlg/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FrFtQNNZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750440259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ouz3BUK71qOdTrcFId1tCc8lvLAtnHB4kyG9Fz0uMwQ=;
	b=FrFtQNNZWBJGFhyARZ1gYXZ8in0T4az4ge2N3ISe75OywxmX379QClpmIWrh+mw2g8MUbA
	nAwbFGD02jF/9H0hApOcJgMy7608UqrZCX2UCsWP8n6kz79RwPghea8rfxPAGxUJg9YwH4
	48pqdK5xJPDli1udoX3Y/o5COSUugNs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-2AwXZl7eMXCzuEttrwt53g-1; Fri, 20 Jun 2025 13:24:18 -0400
X-MC-Unique: 2AwXZl7eMXCzuEttrwt53g-1
X-Mimecast-MFC-AGG-ID: 2AwXZl7eMXCzuEttrwt53g_1750440257
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a579058758so1002579f8f.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 10:24:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750440257; x=1751045057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ouz3BUK71qOdTrcFId1tCc8lvLAtnHB4kyG9Fz0uMwQ=;
        b=Nb2TfkENXW41QzhOiGVtwwRPbOIzwPpVVZzKAEXZPDmOcgbb47b1+e83t1e3RJFyAV
         MH1zDMbxl4EP7RaGXxfVMzXibMG+JWsuri9OU9m3GU8gFKX72V34JnEUpzS4D3dB6YMR
         cpBJ7xre6ybjABQy2vkwA4HzaF7lccn7ZDuAFmWe4aMzuITOjLdR5EOh71wGWcudKUh0
         A6+vZpaVMdrAtpXEN+EWEHpQr0NShpyMjlMr65w5ito4ob7bsCLMSxMXQvsx83S4Abf+
         d1SblZKTwn15iUe8pIRbdF+TYbotRRV2kiSFMmKGag1YMZJDcXCyP2//cgEDnc7xLkvT
         Ab9g==
X-Forwarded-Encrypted: i=1; AJvYcCVGWrjTyUByjwvSe/sccbA0C9Rkd6cn01HfOAtYJ+JJNUwUTuUlj2j/BhWDdPfsqmxj/BI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzAS/32gTrfPGHkp7rL+wUuro4j7KktSkbuNHweY+NF8ay2/iv
	Le8tsD5uB+FTjTW0yhSTV9+EEwrR6vgZsiJGZFks0yWBVAPjBTMDMHJiPgDjK3s+ZzCDttJcKc1
	GYEECsjEZvDEKeZjRrAGKtDk/0IsgYSN1ujtxkehkU5Sjk61em3NB98F7+yjydCN0YuIbIaMZHm
	KW83wPMwEicxd19xbHBjWhpffH5WWj
X-Gm-Gg: ASbGncuKYWANlWnyqGHrt883c0g0G2G4fGDwcuwZRNK+id9gDK7x6MyeASjdjd2oYvm
	zGqLtdpFySTqWonqyO7v22Q2UBtPqnFwuLQK8uKlra2beVSy5jwyMbxIEql4LTDgmvVY92Gcqre
	trP8I=
X-Received: by 2002:a05:6000:4021:b0:3a5:88e9:a54f with SMTP id ffacd0b85a97d-3a6d1190d3fmr3089883f8f.1.1750440257147;
        Fri, 20 Jun 2025 10:24:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzSNBBR9lh2YVwg0otvhsrN0GZIOUDSmvBzwBZQnhs02lqRP/ovcayV2ZrRxHVdI4ad6FdQbT+m6pkvwdWTMk=
X-Received: by 2002:a05:6000:4021:b0:3a5:88e9:a54f with SMTP id
 ffacd0b85a97d-3a6d1190d3fmr3089867f8f.1.1750440256798; Fri, 20 Jun 2025
 10:24:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619180159.187358-1-pbonzini@redhat.com> <3133d5e9-18d3-499a-a24d-170be7fb8357@intel.com>
 <CABgObfaN=tcx=_38HnnPfE0_a+jRdk_UPdZT6rVgCTSNLEuLUw@mail.gmail.com> <b003b2c8-66fc-4600-9873-aa5201415b94@intel.com>
In-Reply-To: <b003b2c8-66fc-4600-9873-aa5201415b94@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 20 Jun 2025 19:24:05 +0200
X-Gm-Features: Ac12FXy-GTA8U_5UssPP3xQlLeaRcgwss_Pc_eC2Tf8z0JTOgXpp0nOdWVbSL54
Message-ID: <CABgObfadU2_XLM8yGQrx9rDswfW3Dby10_nxzTBUdYGASQuOaw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] TDX attestation support and GHCI fixup
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	"Huang, Kai" <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, reinette.chatre@intel.com, 
	"Lindgren, Tony" <tony.lindgren@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, mikko.ylinen@linux.intel.com, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2025 at 2:48=E2=80=AFPM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
> > The interface I chose is that KVM always exits, but it initializes the
> > output values such that userspace can leave them untouched for unknown
> > TDVMCALLs or unknown leaves. So there is no need for this.
> >
> > Querying kernel support of other services can be added later, but
> > unless the GHCI adds more input or output fields to TdVmCallInfo there
> > is no need to limit the userspace exit to leaf 1.
>
> I meant the case where KVM is going to support another optional TDVMCALL
> leaf in the future, e.g., SetEventNotifyInterrupt. At that time,
> userspace needs to differentiate between old KVM which only supports
> <GetQuote> and new KVM which supports both <GetQuote> and
> <SetEventNotifyInterrupt>.

Yeah, I see what you mean now. Userspace cannot know which TDVMCALL
will exit, other than GET_QUOTE which we know is in the first part.

By the way I'm tempted to implement SetupEventNotifyInterrupt as well,
it's just a handful of lines of code.

Paolo


