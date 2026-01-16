Return-Path: <kvm+bounces-68335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BBDFD33854
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:34:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 079D430AEC46
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D29833A9ED;
	Fri, 16 Jan 2026 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p3J1BbVP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DA1279DB4
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768581111; cv=none; b=XRhLiiRXBWTdgWZ2Izu495P3OvOnoz1jOQGsht0tFlpsogyMEzwPPo0KrPxElryOjkDHksNLCNdsJwmKTxIvWhr22/HFDnSTwyiOnmJTxPm9Mq0cq0Go97oTACfRxZVImsgneBD2bK9u/f1qBkta9byRWcTPhn33d5uP8cU3s1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768581111; c=relaxed/simple;
	bh=WwOl5Ms4vD4Reg8kiGFBT42G+EieoX4/VN5p4YBt7ww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cMWDxRFpHOGrH34o2IL4slUpYqcmMfBvwiPDU6/ew01HnJd26SHIwSrdmgg3N2wAoow5wyAEe2BGvNOEKSRtUGnSCwJX/Ct6gl09GpWsGXqhb3nwJIdK4zac+oqDwIHj27XqoLtQDwtJm4FVFO/I7vYYedPBtI49hdZ7vUAgORM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p3J1BbVP; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0a4b748a0so45802345ad.1
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 08:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768581108; x=1769185908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q+xYsJj/Zpa2XZ4Bo0FtBFObV1lD9OVGRkntRqZgCCM=;
        b=p3J1BbVPvTiGuva59uarJ574+IzB0QKIt5+BiyLFtIof2lVxMTAMX+Ag9RYiapw3Zm
         mMpdoDy69F4CUdP/2Q2R2oETfhE6TX8GDY6PoNtAB4PnO9bX2K/0mI2CBbFjWK+Gh3XN
         ARGSKz/tiGxOSKAjKndQiPzdmqLyYt4w7jA4wAmBEkM8bydm0AF9Tv1xkv9/VOMT3yzT
         KQ0t9c612uwEgLjUQqlDgYqpog5Q5oSWS0gCvPKRV3mtTOapk5jfc2MsQoBKVpWMcfNY
         UryjjLJ+RGxOTjq+H6qeMN2MilVgcgZWDK5H5Sq2TQbAKkm69SwpekS09t+O7/yQvxkw
         6yGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768581108; x=1769185908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q+xYsJj/Zpa2XZ4Bo0FtBFObV1lD9OVGRkntRqZgCCM=;
        b=nwAQ+uIxVcILPUSuSy16TvadsVetaznmkmQXYdiO+OeY0AEPHIegboqiqKRNu22kLP
         rkPKp8sHS2ZtUhKgH9tMHPvUmjSyK/d1S28F5IzU4RRfnVrmM8GR12kgUjRCxxfh2QmP
         3B+DUMQ1GVweGsPdN1TqoRUYS/3iiILm/NIST8081Nqts4l4f/YsS8WgAsn9zS0fzWCX
         mFJLmmag4kUihD0Dc2GLdO/ibN1X0yUcm0vdGkANLR1v3kPJqNwfR4khVIjEM37GIoS4
         4K4VBgjcOvptyZBHIFw9PQLH9LoEhVl4TK2ak+A88IK9O1SQmCkfjnrwtHHzDxqX4qXK
         YK9g==
X-Forwarded-Encrypted: i=1; AJvYcCVHgvsDsA6JqWmCzQVTna22FxMJP449vYalH9W860REnVzIUhoqbnBrNIgTEPw/kGrqJ68=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdZ+c2ipFkwDHZeWI9fd5LiGQsNqSrTEFYNXD1N3BkYYt4lIkM
	Cun3FaJHY+AU+GCl5JM3qJDFOxufpG/NUoZAzkNTzvINBQWQOHWpFMnlwb5FY/j3jJk4XzViIob
	4zt5s3Q==
X-Received: from plbjx17.prod.google.com ([2002:a17:903:1391:b0:2a0:cb8d:f4ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:289:b0:2a0:8966:7c9a
 with SMTP id d9443c01a7336-2a7176cd9c9mr38120145ad.58.1768581107907; Fri, 16
 Jan 2026 08:31:47 -0800 (PST)
Date: Fri, 16 Jan 2026 08:31:46 -0800
In-Reply-To: <ac46c07e421fa682ef9f404f2ec9f2f2ba893703.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com> <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com> <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com> <aWgyhmTJphGQqO0Y@google.com>
 <ac46c07e421fa682ef9f404f2ec9f2f2ba893703.camel@intel.com>
Message-ID: <aWpn8pZrPVyTcnYv@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Fan Du <fan.du@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>, 
	Ira Weiny <ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Chao P Peng <chao.p.peng@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, Chao Gao <chao.gao@intel.com>, 
	Jun Miao <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 16, 2026, Rick P Edgecombe wrote:
> On Wed, 2026-01-14 at 16:19 -0800, Sean Christopherson wrote:
> > I've no objection if e.g. tdh_mem_page_aug() wants to sanity check
> > that a PFN is backed by a struct page with a valid refcount, it's
> > code like that above that I don't want.
> 
> Dave wants safety for the TDX pages getting handed to the module.

Define "safety".  As I stressed earlier, blinding retrieving a "struct page" and
dereferencing that pointer is the exact opposite of safe.

> 2. Invent a new tdx_page_t type.

Still doesn't provide meaningful safety.  Regardless of what type gets passed
into the low level tdh_*() helpers, it's going to require KVM to effectively cast
a bare pfn, because I am completely against passing anything other than a SPTE
to tdx_sept_set_private_spte().

> 1. Page is TDX capable memory

That's fine by me, but that's _very_ different than what was proposed here.

