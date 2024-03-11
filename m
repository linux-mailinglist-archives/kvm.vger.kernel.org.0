Return-Path: <kvm+bounces-11520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B04877CAF
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F09B7B21575
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF711B599;
	Mon, 11 Mar 2024 09:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O36B833w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3508C182C5
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710149232; cv=none; b=qE76XOuE9V1EKb1kyGACIhd2wQ4bODAyYYUJ5fVSJvdfg1UvlyR9/1PuYzXgXH6Kc5I1w8aszzFq7+Dx7p0BoSUMGFiFEwAB3siY2WklkcF/oMq34/jbbe/lYegX2ysdAZFXzRQZxMnvFhG8Knq3qQH0hJ5YU0VOteRXubEWNfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710149232; c=relaxed/simple;
	bh=8zth3mwh/cKPnkQ6EEGd+vNlUKFtCYJEHeMahy8I+ig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LMgzvxpWfuPYo0KO3XArU+PCt4jWeov4CJKRZU0Y4TMs3osenlUtiDS6205LLYi+ICdt2Oe+uX06wnMsXeSE9wghItuFLRSqVu04bHUY1xC8wkkyanKqaFfUWpSYFRMrTjCJiZpgVRdg/md/iXKZr1iSv2TzhV+dV0jgGg3Q0PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O36B833w; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d26227d508so62471601fa.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 02:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710149229; x=1710754029; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zth3mwh/cKPnkQ6EEGd+vNlUKFtCYJEHeMahy8I+ig=;
        b=O36B833wjbt9pzmoazpVzuUNkLTfp1nP2WhbIVSQOVvTvZBHK8BV93SGk7kqviCa4P
         EPYckrbjkccK241xjHbMFTLgaXZzQF8ONLFbr+lU7e6+CEIVqvdfqCmRKMFB/kOhcSBF
         6fXifaAfY33MBNxaam5lSnhFqjSATP4vpGM4tYopd39OpN1UxoECUTb7a5bW8SCfYSBd
         4GVeYeW9XTunNhcETlOlMTy/XShG37mwM/G7QIHElTEQL4fYEOsKceGeC/j65eIDjp0c
         wLdtTx6vJREsf89/FCRPnh/2ALeT8+NeQ7XSHKnV+hF3Qd4XhTpxcmkDwDAQAFjfLaVk
         +dkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710149229; x=1710754029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zth3mwh/cKPnkQ6EEGd+vNlUKFtCYJEHeMahy8I+ig=;
        b=TXaXir19MmTlmeSC+Gg1yx8zJXIYu3uqE3Mrz6qzgnlx8fetHRjsVKtf63kUU0Uc2W
         nkEZMr3bbcyNKZQt2HMcY+Kgb5zad9nPbBijNkCqazfZ+5aY4r1oBF0qYQp32+DLDRNb
         r/BzIE72t9w5/vAl6ahkOKxcRtcdN+mcpB5VIiI+/B7gbijaStuvBAvKN0Pcryrrn9Xo
         Fxi7P+qHDS9iEw7EnjROt7pm47PgLOM+Bk0O9zS9T9D2XWnHrnnwKVle8S27QER4nlk4
         7mO046hmF+jlK2laSpuuPT4NNDyGMe6OgoemElXOtsp4WW8M7nXs47vdgVlsqC91288s
         asfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXh7bRBni99G/QOT/w1tmJNnG53Agwxo32NEqligaZZw3sFiwORDNXORl9P8Cq4CuHrX+Hlgw2hagT9+KZSJ0Vhh3mt
X-Gm-Message-State: AOJu0Yx5/nnOXtQ92dtIio8WfRbwgNPuKjZdHEY9kMtIeMOLiXkWyAc8
	OVDwaAN025EelWtll6JLS3pCWuUqOIQaR4ftF4hg5uUdA4zzjqRQyYg0HtDUIp9dALrb2x7ZKVn
	sYnx4OHeXCex7Td/U238vR94hGLGAcEpq3lqK
X-Google-Smtp-Source: AGHT+IFzr2Y971s9TIBNchuVSVv96nsdJjBYbviMit/edW0+/JwqZBjOrNfaM4862cuUg6dthFfgr61zIEYjCiYlE2E=
X-Received: by 2002:a05:6512:3baa:b0:513:b102:7d93 with SMTP id
 g42-20020a0565123baa00b00513b1027d93mr690098lfv.24.1710149229222; Mon, 11 Mar
 2024 02:27:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <335E21FA-7F1E-4540-8A70-01A63D8C72FA@amazon.com>
In-Reply-To: <335E21FA-7F1E-4540-8A70-01A63D8C72FA@amazon.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 11 Mar 2024 09:26:12 +0000
Message-ID: <CA+EHjTxpBM6LyqGfE_y--Uy1oR4oP7Ozcp3mBwFvAijOZe0i+Q@mail.gmail.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
To: "Manwaring, Derek" <derekmn@amazon.com>
Cc: David Woodhouse <dwmw2@infradead.org>, David Matlack <dmatlack@google.com>, 
	Brendan Jackman <jackmanb@google.com>, "qperret@google.com" <qperret@google.com>, 
	"jason.cj.chen@intel.com" <jason.cj.chen@intel.com>, "Gowans, James" <jgowans@amazon.com>, 
	"seanjc@google.com" <seanjc@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Roy, Patrick" <roypat@amazon.co.uk>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, "Graf (AWS), Alexander" <graf@amazon.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 8, 2024 at 9:05=E2=80=AFPM Manwaring, Derek <derekmn@amazon.com=
> wrote:
>
> On 2024-03-08 at 10:46-0700, David Woodhouse wrote:
> > On Fri, 2024-03-08 at 09:35 -0800, David Matlack wrote:
> > > I think what James is looking for (and what we are also interested
> > > in), is _eliminating_ the ability to access guest memory from the
> > > direct map entirely. And in general, eliminate the ability to access
> > > guest memory in as many ways as possible.
> >
> > Well, pKVM does that...
>
> Yes we've been looking at pKVM and it accomplishes a lot of what we're tr=
ying
> to do. Our initial inclination is that we want to stick with VHE for the =
lower
> overhead. We also want flexibility across server parts, so we would need =
to
> get pKVM working on Intel & AMD if we went this route.
>
> Certainly there are advantages of pKVM on the perf side like the in-place
> memory sharing rather than copying as well as on the security side by sim=
ply
> reducing the TCB. I'd be interested to hear others' thoughts on pKVM vs
> memfd_secret or general ASI.

The work we've done for pKVM is still an RFC [*], but there is nothing
in it that limits it to nVHE (at least not intentionally). It should
work with VHE and hVHE as well. On respinning the patch series [*], we
plan on adding support for normal VMs to use guest_memfd() as well in
arm64, mainly for testing, and to make it easier for others to base
their work on it.

Cheers,
/fuad

[*] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com
>
> Derek
>

