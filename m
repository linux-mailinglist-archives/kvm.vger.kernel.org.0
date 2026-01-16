Return-Path: <kvm+bounces-68416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC2F1D38A4F
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 00:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E469B309C6AF
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 23:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B59C31327A;
	Fri, 16 Jan 2026 23:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DoVP0jcK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167D327700D
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 23:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606757; cv=none; b=Phee3DGJb/hP9fa+3NaXID0NeTUNhMD/yHlvehwwrLbGYuqIF8xBDKVGv9hQYGfj++F9c3UorP6wd+juBd+exB4aokTlMrUh+5ki/htc+JSijdiIoYMMmDQGyymq/VpOoSX0gXzjrZyigFYMohfzzqANQcJZw2UOf4Tklh/BRPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606757; c=relaxed/simple;
	bh=Y4ibuTWK/y2NGYYtUdKW8D8n76WolOuiqq3hEZSF+O8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ltQTR3jhJrA5qO+w4rookhcdmLuwfjbYlD3eixJ+DApNFfrWBxJVE2PQuyyoik6UsTtMwfqDJzeDW5yVB5myKWlRqLpVlB/MV/6VeDRXbEgzzKyGhkD/qhRvI8hWeGzA2F4CZjpB9O9ACr3BQZq6+zB16Tgo3yLmGYLzDs6KUsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DoVP0jcK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a377e15716so50478355ad.3
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 15:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768606755; x=1769211555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7kNuc4gJ/yZhF3SFPcSQ4SQjDgiZgSDz/EsGj38Yhek=;
        b=DoVP0jcKMDehj7CGKtayd7nVWW4nTBDoFOnJjJXIYAd+fIo+kAZYBVxAkfrtptr9xo
         Alv/8nCuSSqRczpVV7aYz+Pnvwf0XS3zX3vRDF3Wig2s9j+P7o06nMH0IFoV4om9gfrp
         KlZdzbC2VEHB910P8tNZsZ/rlQ/lNQq8tupwetOjdFHkPXcnbYu4o46eDlsrZSbOBkfZ
         iSxJS8Ta7F1GMkp8xsmHCncABwXo06+Zn+u5OP7X9ZXuTHdjl3sKPYmwK857uYmHWHax
         LZiE1bC1UdJJC9fDsug77LrC70O7t4icocuyDS5c+bKkohT1Ulq/r5RS9enE7YpZNXNZ
         6VaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606755; x=1769211555;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7kNuc4gJ/yZhF3SFPcSQ4SQjDgiZgSDz/EsGj38Yhek=;
        b=bo5ZAHBf8Szua0jIXsCKCR9owRv7FakO413Selz0zYSYW/K6d6LNW+y4WX3WXsH4kY
         9dU0VRW3XO3YQfBX511tPbGmZIgxhiVaBkAEu4WLsxSzMnjk/aTHRHfHtcgZoTN9UXUn
         tx/mQ4sAO92j4z1rfjKiOAfJ5fkPcZoQWFyqhm+0PTG1jkvthdE/Vv+JyhJl+7JObyjP
         3uN7cBR+ohvCG2yqWLKaV27aer77QVc450pcTp+9dCAb4Kwq+Ev1HN1CS1BLMD/3pIiW
         vWx9CWg2bdWqbW6W/WVzZSeQs24xFT4TLfARNYYCgqC7bPBX/9xjF5Cyuhrp0dwBlqre
         Sfmw==
X-Forwarded-Encrypted: i=1; AJvYcCXa4RBWXrmvNvsMttRhf+xxJSHf6dY1bvluAdBlfc/UMWKpGg7PerFShmsNfoyds21v0hw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxsndz0GZ+x6gEeT1rwJxGvnoci+jT4vuVWoOHcSwOyyzoZvS03
	ZgjJLGbBLyKGaCRN/P4myNJ4RFNObiiqzS2I/DkKt7ObisdeiiD44zxlPMTYkyTWEesk6lWUGQ0
	hZjaSHQ==
X-Received: from plhn17.prod.google.com ([2002:a17:903:1111:b0:267:d862:5f13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c94a:b0:2a0:a0e1:9c5c
 with SMTP id d9443c01a7336-2a7188583c9mr38668545ad.10.1768606755292; Fri, 16
 Jan 2026 15:39:15 -0800 (PST)
Date: Fri, 16 Jan 2026 15:39:13 -0800
In-Reply-To: <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
Message-ID: <aWrMIeCw2eaTbK5Z@google.com>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce kvm_split_cross_boundary_leafs()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fan Du <fan.du@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>, 
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Chao P Peng <chao.p.peng@intel.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Jun Miao <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026, Kai Huang wrote:
> static int __kvm_tdp_mmu_split_huge_pages(struct kvm *kvm,=C2=A0
> 					  struct kvm_gfn_range *range,
> 					  int target_level,
> 					  bool shared,
> 					  bool cross_boundary_only)
> {
> 	...
> }
>=20
> And by using this helper, I found the name of the two wrapper functions
> are not ideal:
>=20
> kvm_tdp_mmu_try_split_huge_pages() is only for log dirty, and it should
> not be reachable for TD (VM with mirrored PT).  But currently it uses
> KVM_VALID_ROOTS for root filter thus mirrored PT is also included.  I
> think it's better to rename it, e.g., at least with "log_dirty" in the
> name so it's more clear this function is only for dealing log dirty (at
> least currently).  We can also add a WARN() if it's called for VM with
> mirrored PT but it's a different topic.
>=20
> kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() doesn't have
> "huge_pages", which isn't consistent with the other.  And it is a bit
> long.  If we don't have "gfn_range" in __kvm_tdp_mmu_split_huge_pages(),
> then I think we can remove "gfn_range" from
> kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() too to make it shorter=
.
>=20
> So how about:
>=20
> Rename kvm_tdp_mmu_try_split_huge_pages() to
> kvm_tdp_mmu_split_huge_pages_log_dirty(), and rename
> kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() to
> kvm_tdp_mmu_split_huge_pages_cross_boundary()
>=20
> ?

I find the "cross_boundary" termininology extremely confusing.  I also disl=
ike
the concept itself, in the sense that it shoves a weird, specific concept i=
nto
the guts of the TDP MMU.

The other wart is that it's inefficient when punching a large hole.  E.g. s=
ay
there's a 16TiB guest_memfd instance (no idea if that's even possible), and=
 then
userpace punches a 12TiB hole.  Walking all ~12TiB just to _maybe_ split th=
e head
and tail pages is asinine.

And once kvm_arch_pre_set_memory_attributes() is dropped, I'm pretty sure t=
he
_only_ usage is for guest_memfd PUNCH_HOLE, because unless I'm misreading t=
he
code, the usage in tdx_honor_guest_accept_level() is superfluous and confus=
ing.

For the EPT violation case, the guest is accepting a page.  Just split to t=
he
guest's accepted level, I don't see any reason to make things more complica=
ted
than that.

And then for the PUNCH_HOLE case, do the math to determine which, if any, h=
ead
and tail pages need to be split, and use the existing APIs to make that hap=
pen.

