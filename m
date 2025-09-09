Return-Path: <kvm+bounces-57108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6794FB4FE14
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 15:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFFD44E4884
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 13:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E6234A331;
	Tue,  9 Sep 2025 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J0s6bTjR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A6E3431FF
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757425508; cv=none; b=lkGPHaYynh8ZPtgerM9fb5RH03LY81R0D875LVX85VGcKisPDbqYxgn5vsLHo7ZjVBOhBMOEgbveLhkeuu62zMvjGRl8x2UJEZzZmlG3ugOq1EzeyjThYFmu0KaooiBVPtME7HgR21qDgMHQ8gntbVxZ2iUn0/WZOwXVOpYRbmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757425508; c=relaxed/simple;
	bh=ENKhO7lmiNhb5G2bgE6pBOiTO7AJKt6gqD/IBN4lWwo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KVALYaonxenClUsvgVUBB5R8Baa5PnCmTVxRo7X4QXo1RS8X2ZiOIec2/7X+FBV2qV62eZGJUXdN6zPlq62azDESPokZCy+6n2e4+7s2D0IA0y/nI07w9jv1yBqETHb8S5KeTcUmvSqno1+ACcLUAyPnYFAVDN/OdUGm4G481Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J0s6bTjR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32da1357bf2so1752981a91.1
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 06:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757425506; x=1758030306; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qn2zi/7J+iyg494tdy2kZv2JyMDDtFbWj2UOTuXwNmc=;
        b=J0s6bTjROjAa53Z/tjnirkmc7nuXaug92EFC9VkbCQQCSXEhI3irkesCNGbOsBj1sh
         gswK/pBMtHbtxzKe5ID3mF7ix8GH8K36/3h4ObyucwxYdYvdk+d+Q8JOBSlCxzLe3ynl
         DuvsrWjeFbJDUmppcBHNMcDeE9xLuBJRvnRyj1XKLzwJZV7I5Zw4TBj0csZexv8qKGTp
         QSYMsDdgGikYNT6wbz7kQuRQbsmTeFS/h/W5khGL9HqQgbsmklUpeWZ6fz/N5TD4v0Mu
         uS/sH2AZFivDTOUAp5K8X4iQIqmhB0Zcyu/qJp0fBtUQkRVTqV/tvZ7uRNqJevBnxp2R
         W59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757425506; x=1758030306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qn2zi/7J+iyg494tdy2kZv2JyMDDtFbWj2UOTuXwNmc=;
        b=gnsEKpW7MonkOb+2bmdtixZzKwN6JNFumXIMh6XUnL37fI8L0Wc+yfwQIbKxSXF3uo
         yPVR5mSr2iMYa51a9z/YLKGHuqC8D0hQOibQxv3KhJwQkPNc/EE2MwmMjRoOSuYWFEEO
         Wkmye65LkTgqI7RMuQnEy7ZkYZUkbNGhSiymf4G5V2qLs3ZDJFJxFuV8i/8wIbYf63ol
         473m+N7ICRx2se20JIzXKImJqfXFLWEqb41gY2rYSjHwqsCSaiNpzTbTKFSyWaTZmLay
         1uiPOP9YbEAZqTsnLJwZEOVY041ST6ylDWopDv/icFDpd6e/jVsdloM33sRqjv36x1Hn
         OaFA==
X-Forwarded-Encrypted: i=1; AJvYcCVjTfKSaVuTKT49BXjAf1qTLJJWPGpIN0blZw0uzTf/I4dE+6jZJw2wdd2b77FAYXtFaKM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr0Re3jWUHnEeGc7iSggFXU+4UOYsy6R3IH5ne6BuoMPTnemnI
	Ht8xZEeDfiqVnE4isGL/QGSzwwbEPhmAejI/p5j5Is9DvOh7D/dPfwmg3F7qCL1xmXnKdeYtRBL
	eS1fDEA==
X-Google-Smtp-Source: AGHT+IEiKctnxhjATdRdSheVFoKSsBIIFr/SPSqQTp8ZU+FER3+ZY1kRQ08tw8vcuWl7ATgmdnFngXHPK/o=
X-Received: from pjyd8.prod.google.com ([2002:a17:90a:dfc8:b0:325:8e70:8d5e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fc8:b0:328:a89:3dc8
 with SMTP id 98e67ed59e1d1-32d43f19a21mr14704499a91.14.1757425505993; Tue, 09
 Sep 2025 06:45:05 -0700 (PDT)
Date: Tue, 9 Sep 2025 06:45:04 -0700
In-Reply-To: <aMAKBUAD-fdJBhOD@tlindgre-MOBL1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909101638.170135-1-tony.lindgren@linux.intel.com>
 <20e22c04918a34268c6aa93efc2950b2c9d3b377.camel@intel.com> <aMAKBUAD-fdJBhOD@tlindgre-MOBL1>
Message-ID: <aMAvYIN7-6iqQNBt@google.com>
Subject: Re: [PATCH 1/1] KVM: TDX: Fix uninitialized error code for __tdx_bringup()
From: Sean Christopherson <seanjc@google.com>
To: Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 09, 2025, Tony Lindgren wrote:
> On Tue, Sep 09, 2025 at 10:55:18AM +0000, Huang, Kai wrote:
> > How about we just initialize r to -EINVAL once before tdx_get_sysinfo() so
> > that all 'r = -EINVAL;' can be removed?  I think in this way the code
> > would be simpler (see below diff [*])?
> > 
> > The "Fixes" tag would be hard to identify,

No, Fixes always points at the commit(s) that introduced buggy behavior.  While
one might argue that commit 61bb28279623 was set up to fail by earlier commits,
that commit is unequivocally the one and only Fixes commit.

> > though, because the diff
> > touches the code introduced multiple commits.  But I am not sure whether
> > this is a true issue since AFAICT we can use multiple "Fixes" tags.
> 
> Your diff looks fine to me, however my personal preference would be to do
> the fix first then clean-up :) 

Eh, fixes can also harden against similar failures in the future.  I don't see
any reason to split this one up.  The buggy commit was introduced in v6.16 and
Kai's suggestion applies cleanly there, so the more aggressive fix won't lead to
stable@ conflicts either.

In short, let's go straight to Kai's version.

