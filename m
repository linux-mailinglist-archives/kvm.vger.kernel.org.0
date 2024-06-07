Return-Path: <kvm+bounces-19060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 471428FFDFC
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 10:27:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6503281494
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 08:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528EB15B0FC;
	Fri,  7 Jun 2024 08:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bhe9/DLi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8C015A86C
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 08:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717748867; cv=none; b=gii+xwzYespTfPDleF8oGKDdCTWvxBhGDhOqfns7960q1gIQEXp9SI4Wj3u+gcXuq67CcAO9HgHX8PVkR7v2Fg/ORrRMbmeSZcbWbMyZh3i7fesgSGHnBlpX77MeCUmChFaGco9ezNPvnx8ON7z7/bjM9M8ZtDq3WOf8JAWn2BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717748867; c=relaxed/simple;
	bh=EW7bKZ5WQXahHLhRzPz5GDqoOvjasCZdis6BWjFnuIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vjj2qYej/cR9SI86K48Y2pzCOHKlCSYC5P3xrSOjrA1nunJhsLUOjKB9Jjd2K7F1Rr+RhN8l582Tu6jRhIdhz1dDGhZk9L4Zo0mcAnUGTtjU8cPgM0MB44cvB8tH6fXat+/MrOrLMvm/Yb5bjCvROVJrdxmT3uD7sZFSSVwafq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bhe9/DLi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717748865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EW7bKZ5WQXahHLhRzPz5GDqoOvjasCZdis6BWjFnuIs=;
	b=bhe9/DLiCi3F0p1/ePBpVh+BvPV88JnocW8IIBD1hiaX5UmvcXnH/Thb5su/6p+raHlcsw
	w9hpXDBpiIERNJjApSnwrbrwEY6OwLXriJxWsGoM4aoZ+fqAZDJXMnxcFGAtK+8GZVgxMZ
	Usf54e2o9eScdwqeGY965oRDDqDgzdM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-a0hSWIjDM4ewYLeqoD7WrQ-1; Fri, 07 Jun 2024 04:27:43 -0400
X-MC-Unique: a0hSWIjDM4ewYLeqoD7WrQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35858762c31so1111144f8f.0
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 01:27:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717748862; x=1718353662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EW7bKZ5WQXahHLhRzPz5GDqoOvjasCZdis6BWjFnuIs=;
        b=MxTNDYPj53ZK2xHNWxfPWihv88bHBdTZMmkftdGqHavh4w4sDG3ZwVYjjG3WMi4bUQ
         BPu3nQpBmxyqlxgGpNZJvF2ZDzH7TAbpVkQna4brTMDaKifQOyXNilAp1i5OgzkiW/Rc
         lPKSPWhHpCmKDKcpKKonnonV6Hlg9y2GY0BxkC/vgjkjgTSE6kttbjo/6GuAe0tPs+Y0
         4Bu6Fg4MrWObGQYSjCsTRo5IQOnqUMhiuyyy3tWFtK+SSOrDp5YlzC3bpOOuhpxUdorf
         scDy5L23/wJVXU3l0cHKcNucwYO3VA+KueXRUqOIS5QoZN4MHsYMyAl77z/iXorn28JG
         PMgg==
X-Gm-Message-State: AOJu0Yxn8AiZVHzn6n162oLd/9FFQR9LtnMt4AEDszf6pXn/sRypZeiE
	47E2+IwtuM5l+I19lICslDUnzbDGMtv3nH7kjK6pfA7MzQQV0Mr72XywnnmXYH6NzOorSQ1UKWS
	cEKASpXBKcCq2DDoYy5i3+LC2k0qYpvXBfjh/zyae5ij2N5ygh99hmLPONHxsCwUniZvz1xgVqp
	p0VgvXULuNoic4OreJcKSHJPld
X-Received: by 2002:a5d:4cd0:0:b0:35f:d07:d34 with SMTP id ffacd0b85a97d-35f0d070e32mr118699f8f.27.1717748862060;
        Fri, 07 Jun 2024 01:27:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxcx0aN4fDEyHXnDykbxT7wUNMAltCScM4CinOTkt0dyaZEr3CuEhHs48CHIy2nbxw/bUho238yrD7V+EzkpI=
X-Received: by 2002:a5d:4cd0:0:b0:35f:d07:d34 with SMTP id ffacd0b85a97d-35f0d070e32mr118683f8f.27.1717748861729;
 Fri, 07 Jun 2024 01:27:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
 <20240530210714.364118-10-rick.p.edgecombe@intel.com> <643a2ae1c0e894a4dd623dfe8c8f7ca5eb897ce6.camel@intel.com>
In-Reply-To: <643a2ae1c0e894a4dd623dfe8c8f7ca5eb897ce6.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 7 Jun 2024 10:27:29 +0200
Message-ID: <CABgObfbsuaZoLSQ6nZFHR9_8N2kjLSLDttv3MeZVCbOs=4H4+w@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP MMU
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Aktas, Erdem" <erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 12:01=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Thu, 2024-05-30 at 14:07 -0700, Rick Edgecombe wrote:
> >
> > Update handle_changed_spte() to take a role. Use this for a KVM_BUG_ON(=
).
>
> I'm wondering if the KVM_BUG_ON() is not worth the cost to the diffstat.

Agreed, it seems like pointless churn.

Paolo


