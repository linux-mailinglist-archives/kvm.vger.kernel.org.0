Return-Path: <kvm+bounces-56616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0337EB40BAB
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 19:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 685297A45FD
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4288341AD1;
	Tue,  2 Sep 2025 17:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vJVeEJGY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91767340DBD
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756832998; cv=none; b=WoWY5NXxYt/vtp1KU8goT75PasIPmZ56d6XFp9K22wQtSG0YPQWsn+Ofk71O5NNa0F7vC0NC5DmscYK1vMvDpPHJ9GnrkbppISusJE45LOxBcR4glJ3r4cZB6xBu3tY/x22cNn2dR1UzLJfUEnkAVtNFqfz40+qSWCe+hgXjWIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756832998; c=relaxed/simple;
	bh=Dq3iaEisaR2x62gnenzJxtkdCglLNtO7PgkfHaw+RaE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BSle1+kXHa78ufWgoECxD0Cx92ABiYY5T2zjtFKf0K7qBbGHgA9kYSF1sPA4KmoxHzWIjUIiiSanFCrumntEM+hbcBlHASkqTCK8y7UKjjPiSFOIFNvRC4pGgdM79lB2rhntLMTFvO/capomxWRlhyNEKxDnS1K2ak4MW4NvIIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vJVeEJGY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b471737e673so7984337a12.1
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 10:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756832996; x=1757437796; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V4AZbfkCmZQBVaKpnm1tZ59PjsZ5ExHlWjz9wa+l5ls=;
        b=vJVeEJGYZ/la9xThYZQ0o1biow7eYNANMFmNPMI1h7EzhYzuy+GFnf43zhJeafcgk4
         7JTdzHsgf05ee8xb+O554tR4Pgxuzmpcn4mF4ciBoqxKO+f7Az9gW9BrE+bnb48UTIcD
         cT8rNymZWSyMJ3UU8ldDW15ScEmyr5bosVXNZTB2jIamd7y5LbRZf4cxpmD46ITMZnwZ
         CywMQyTGs7JLjNbf49MhYU4z7NxCZaHJ9XSXFnZ8YRZ5KUWnMiUMzH0xZoelds0j1hGR
         gisKV8YiNLeNox0R2HePlnixqrpCFJpVXyBUe6OuWW4DGkehrKVs4zcK/5HYp76tEo1D
         SuUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756832996; x=1757437796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V4AZbfkCmZQBVaKpnm1tZ59PjsZ5ExHlWjz9wa+l5ls=;
        b=B9xBXjBgWsOYr1UOQRIaQVz0+MOK50X3hoj69EoWUUvpO78QRtA98yzkeCrMece+ow
         oCepjneBlNuOSfZHxL7ff0qPpbzKCM3O8MtfS/1Dzsa45rzPbYmgVbeE4fQQpemkA4so
         OsFsRfa1fOTrzHKYhIwA34jtDlrI4q9KXtG74xyEtDmBy+qMhB7R507qHRUte2tk5/vl
         ZPJWfpqPsgwIDpKyajFd938Ytp93ElkTDJaw3VAPdoQp5GBff2HbHhU7PSH6yMJ6PnBr
         bGTxbs00aLBDeHk7FuQwjuxjBLrX+jIujml1+EtK3xIEP23g7Kk+rnZ4sK9YLx7Dw7E6
         5CHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXglVvFIV3S1JwjNbXboHFfK8UiJZYQf6eslPmrW5EcAqBZN0sMUauUbYG0NiODe53Vvzk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh8No4j3Xb3wv0GjYqP3UBRe9oOcW3dVezeJgZ8Q7SfqmfDA7V
	zm7sVPvLWqlWqQYV5URm9uRLZV55TaRdQZfqVM3017Zi2Na8Sm91b9DWpCkyYLOKpIOrDqPMiSq
	esVLyIQ==
X-Google-Smtp-Source: AGHT+IE/xXUwYFqm7bMkauyv9aS4cZHKZ9pDqM1jFJCql7JTSLt/5PxhMaqsUuPRbVGEgCYaZQcgrlSZv+w=
X-Received: from pjbpq14.prod.google.com ([2002:a17:90b:3d8e:b0:323:25d2:22db])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d40b:b0:327:a04b:aac
 with SMTP id 98e67ed59e1d1-328156be03emr17012159a91.24.1756832995881; Tue, 02
 Sep 2025 10:09:55 -0700 (PDT)
Date: Tue, 2 Sep 2025 10:09:54 -0700
In-Reply-To: <17ef5f493d5ef6d76c4dc9ca19f1d4d7fe4c73f9.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com> <20250829000618.351013-14-seanjc@google.com>
 <17ef5f493d5ef6d76c4dc9ca19f1d4d7fe4c73f9.camel@intel.com>
Message-ID: <aLck4twmLDTtiewI@google.com>
Subject: Re: [RFC PATCH v2 13/18] KVM: TDX: ADD pages to the TD image while
 populating mirror EPT entries
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 29, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-08-28 at 17:06 -0700, Sean Christopherson wrote:
> > @@ -3116,11 +3088,14 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >  {
> >  	struct tdx_gmem_post_populate_arg *arg = _arg;
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > -	u64 err, entry, level_state;
> >  	gpa_t gpa = gfn_to_gpa(gfn);
> > +	u64 err, entry, level_state;
> 
> Fine, but ?

Yeah, accidental copy+paste bug (I deleted several of the variables when trying
out an idea and then had to add them back when it didn't pan out).

