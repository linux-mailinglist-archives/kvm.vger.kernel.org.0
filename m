Return-Path: <kvm+bounces-65181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D68C9D3E3
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 23:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3AA13A9852
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 22:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7F32BE033;
	Tue,  2 Dec 2025 22:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wZXONmSM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389981427A
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 22:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764716043; cv=none; b=jQhCJMMwoRqaAyh6uUoFG1DW2N35YF0Yt6UU6suRLCXdnYjnWBFyc2stKaqFz8/gyl4zXZbEWO+S3Ov2m0LYYTDPdG7Eau2AW2KXYEZYsTLrR4lytXejDtCA1e+mhqFxp1Gznt48MV+kivdkZ3GPJK3j+wWlIBQFJzIaVIjSUrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764716043; c=relaxed/simple;
	bh=ENe/WRirNyHG1IWMvrXSWYpz00WtserxsDI8/ZjmMBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V74ZrxMQ0pLQOfGgwivW/6bkTEf2rkWnjGhUZ692T288TjlwC5J6ZChPt99XfTSyVHFd3E9Fsbv6toyVDBpukJZLlh2pP+ajoY5EI0pHUKQ0l4O0fmtRRb7DFv4ssqJbEIxoAT52CR5WRghyakCeH6swd+1edZZMPWrNjF+2INc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wZXONmSM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436d81a532so9655902a91.3
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 14:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764716041; x=1765320841; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QG9G/tnjjLhGLFb2Fr75b/c3OH3iIFVZ6TVY+cHObjY=;
        b=wZXONmSMLFcmqSC1Dh20GI7nT14I8hrmDwm9ccP0PSz9dKbSYPYbrqsLcRV2sa2+8V
         22t9iZHaxb3P9R0povR/I/siKrEYh/apo0HTVqOfwlm5gmIkVGZa/R96SslvIJCzMDnq
         weY2B8525Sa8kCFl/BpJ0u22m/i3Ft0GPEWvYbYdfIaRezx9lOIvM+IMTWNuymfeKsJj
         Jw1Pcq9oimLdN4Z6TT8kelCTS22/I64EsD4A6f09iuYer4pNyY3f+HSFwl6dN40zRh3Z
         Dm0xMd6Ddl6EHbZTl3NrBeYkpGqCrwnl0FE8LB6TJdMcgw7v8W8YK+FpnHK5zEkt2wfE
         cw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764716041; x=1765320841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QG9G/tnjjLhGLFb2Fr75b/c3OH3iIFVZ6TVY+cHObjY=;
        b=nIQXxLTwGDlG4xSrxkf6BHNslhx66/UxJ8MDFDHTUBublxUFt5348kpJc+Ri9KUoH5
         kLeb/6fbtBo9CPzmaVa3pjpbbTDAzsisdJgCJneBCdKYFWXHmohTkvBgn9k0bnZ32mcB
         Df4fEp8V3R6t8rnNKU9SZ0dzlv3VZfv1B4jDfTAIk9NfKEcfcrkHnex1eHE60MMgW8dA
         nUNmE4039LB6dMDL00ABApHn4QsOeF8HkuFaGdtmWeXbj5FAbrI0Xg02ouFeDiSD+wrf
         Y4cbIlRAPwYJX6WkyDBpK/ARTzdd4DE0LJHF4uw98fotlKNPgaDbtTlkJY1qacflW8wl
         BLJw==
X-Gm-Message-State: AOJu0Yx/tNun9DMF4ZixV5ldhdcWPBvluvoVrrRECPTK+OcQDX1hHPRT
	nNoupJBmfuAw2rWsh+GGps4LhLyVgcgCpB0lc3KnLq9PHUFiw+lysW4ajCuNb/wriO6Gca47JWc
	/CI3dsg==
X-Google-Smtp-Source: AGHT+IGo7ZDuIYyGNvg5SzJeKFzR26U0Ft7ZAZSYPKBbG+RkcFL+nwuYPn11kDLDD70feQZmNtaFvkEYNfo=
X-Received: from pjbmf13.prod.google.com ([2002:a17:90b:184d:b0:341:c8a:bd40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c48:b0:341:8bda:d0ae
 with SMTP id 98e67ed59e1d1-349126c857fmr328338a91.20.1764716041503; Tue, 02
 Dec 2025 14:54:01 -0800 (PST)
Date: Tue, 2 Dec 2025 14:53:59 -0800
In-Reply-To: <DS0PR02MB93218C62840E0E9FA240FAF68BD8A@DS0PR02MB9321.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20221005211551.152216-1-thanos.makatos@nutanix.com>
 <aLrvLfkiz6TwR4ML@google.com> <DS0PR02MB93218C62840E0E9FA240FAF68BD8A@DS0PR02MB9321.namprd02.prod.outlook.com>
Message-ID: <aS9uBw_w7NM_Vnw1@google.com>
Subject: Re: [RFC PATCH] KVM: optionally commit write on ioeventfd write
From: Sean Christopherson <seanjc@google.com>
To: Thanos Makatos <thanos.makatos@nutanix.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, John Levon <john.levon@nutanix.com>, 
	"mst@redhat.com" <mst@redhat.com>, "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>, 
	"dinechin@redhat.com" <dinechin@redhat.com>, "cohuck@redhat.com" <cohuck@redhat.com>, 
	"jasowang@redhat.com" <jasowang@redhat.com>, "stefanha@redhat.com" <stefanha@redhat.com>, 
	"jag.raman@oracle.com" <jag.raman@oracle.com>, "eafanasova@gmail.com" <eafanasova@gmail.com>, 
	"elena.ufimtseva@oracle.com" <elena.ufimtseva@oracle.com>, 
	"changpeng.liu@intel.com" <changpeng.liu@intel.com>, 
	"james.r.harris@intel.com" <james.r.harris@intel.com>, 
	"benjamin.walker@intel.com" <benjamin.walker@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 02, 2025, Thanos Makatos wrote:
> > -----Original Message-----
> > I think it's also worth hoisting the validity
> > checks into kvm_assign_ioeventfd_idx() so that this can use the slightly more
> > optimal __copy_to_user().
> > 
> > E.g.
> > 
> > 	if (args->flags & KVM_IOEVENTFD_FLAG_REDIRECT) {
> > 		if (!args->len || !args->post_addr ||
> > 		    != untagged_addr(args->post_addr) ||
> > 		    !access_ok((void __user *)(unsigned long)args->post_addr, args->len)) {
> > 			ret = -EINVAL;
> > 			goto fail;
> > 		}
> > 
> > 		p->post_addr = (void __user *)(unsigned long)args-
> > >post_addr;
> > 	}
> > 
> > And then the usage here can be
> > 
> > 	if (p->post_addr && __copy_to_user(p->post_addr, val, len))
> > 		return -EFAULT;
> > 
> 
> Did you mean to write __copy_to_user(p->redirect, val, len) here?

I don't think so?  Ah, it's KVM_IOEVENTFD_FLAG_REDIRECT that's stale.  That
should have been something like KVM_IOEVENTFD_FLAG_POST_WRITES.

> > I assume the spinlock in eventfd_signal() provides ordering even on weakly
> > ordered architectures, but we should double check that, i.e. that we don't
> > need an explicitly barrier of some kind.
> 
> Are you talking about the possibility of whoever polls the eventfd not
> observing the value being written?

Ya, KVM needs to ensure the write is visible before the wakeup occurs.

Side topic, Paolo had an off-the-cuff idea of adding uAPI to support notifications
on memslot ranges, as opposed to posting writes via ioeventfd.  E.g. add a memslot
flag, or maybe a memory attribute, that causes KVM to write-protect a region,
emulate in response to writes, and then notify an eventfd after emulating the
write.  It'd be a lot like KVM_MEM_READONLY, except that KVM would commit the
write to memory and notify, as opposed to exiting to userspace.

