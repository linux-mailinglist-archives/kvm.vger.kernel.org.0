Return-Path: <kvm+bounces-46773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B27AB96E2
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 542F3A01608
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 07:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58C222CBC7;
	Fri, 16 May 2025 07:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bu1sQAAX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655C019CC3D;
	Fri, 16 May 2025 07:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747381926; cv=none; b=m+R7tDvGS9gQW/+rdGiz24X1ebuNHLF37BC3/YbQX65Bkg6s71/PxmSKcBLsxphAo+FuDM4aGOr6OXYCBaLaZRhFFV/aZl6IC0lQ8I2vKcHC6vzpFDZqrEmWButhR+gYJqg79Q0KoLuFQkB4sysnEeIdiTcSkJwR4B+tIehOCaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747381926; c=relaxed/simple;
	bh=SVuKXCGj/7B/whhXrusKH/C7G4Boc4zOdgjOBusvJUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HQjP6iLNVgWn9nc6+p6PVc/DEQSJc4nngPq05D4fA81BbQolGwhhJ7WY0uRkt13EVahAEfzVAR37XEY5BrLVgyp2M42rU6srAbe56AFvewJq6sIu/CZeIjjWsZhbEel3eu+zrvcJCdOxQr7xQ0GJroQmO7XKzQdC7EfDtsEUSQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bu1sQAAX; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-327fa3cece6so18298401fa.3;
        Fri, 16 May 2025 00:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747381922; x=1747986722; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eoXm5o4suzGFTYY5rdZqNPh4U5i+lWoDCLG6w4UKKeQ=;
        b=Bu1sQAAXDPRooezx883mdo59wfA9uInFU5HJoEb78VyPH2C7vTrvEkzGLxf8VBRcXJ
         N3BiHfNlwy6STuxA7N5XQRNNsF2tVvW7jzT1uSnGg2HtdN8jIr7Yd81xZNY/GO0I0itA
         bjBWSzha0vpUyrNx03wkYx0i5Iv+qNMbb7IOSwPwLXD2RDg2ztbq16HCO0yYsJhWSmMY
         obyg1VtHXIGdVEFikLJSSp4kZUgvD7FtsxCrN1695WpvD9dJhOfRQ/Bu4odn4bIIqFC9
         FldeYBplXTaeENU9CQ2SXLO53h6ktO/u5qPAgQep12TpzjZKLkHpBHQBE2Hwc4Z1gCRZ
         jnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747381922; x=1747986722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eoXm5o4suzGFTYY5rdZqNPh4U5i+lWoDCLG6w4UKKeQ=;
        b=GURmTMkprbCeAVPsGTMSk51eAcTw4aK+d6QyImukVaS7nC6yll24IUK9Vj40GANol3
         zz4J0nRKUcfvsxGodsEVKeie/wM9oQdgTbRrR9ahLIXeCXSNjxMPOP/dFXQcJEhAZT5f
         k2Ry5A21NS6uXzgW329vofwvHpzIA+6Etr6Q6nZR13g9L5Zk44mqmrAoQ1nnTOcmtjl9
         k8QkmSrdmbuIHh5jIUM9KPulUw83jsdCUczpp96O/qohnQoUvq812TbPEstDO890/n03
         rQKUQiJ4g/lw3kzXwZNuVHdu9MjygVpa2MR1dMLB5xjKh67p39XFLzLxma/Gn8OhBBvK
         vPng==
X-Forwarded-Encrypted: i=1; AJvYcCUgscnqWgs0+8FAGstw0syZ8M6kVjJKyuC7Nrg03VgCN+skbBpYjua6Gxnxh952BjgszE0=@vger.kernel.org, AJvYcCVYd6OawSj1h/FjYBYxnLGNwcKLLbU8cL/3p5dwmdpN6ZAMsB3P68pz8rd0sgYk59UuJuzV1GEJmH9q9NRN@vger.kernel.org
X-Gm-Message-State: AOJu0YzVV6nN3w3xaIxhxO65wolveTWEH8FwRTGYV7AEUw7k13DaDHmC
	rjGVz98upzvoPIJzkFReHIRzUZf5qYxvWGYQ6kt51jx3n0i9ZdLzhofXGNqQdw7E5U1/g8gPfZa
	c6LGgT/oLkRnFVU8Js2iWKXnQHqzInMs=
X-Gm-Gg: ASbGncvywYGrQQJO4EwsX/f66gNNXaZeX5FOK4tQntFWKDrCLcY7V2bJ1PdymoT7spE
	F/Di14eP5I+dcphdffDiXigu2ov4runAhMFAY1GI6saPIXo8eDMuSIMHj775ifbjuneUl1HXqxQ
	WZoAJa2tMjV5WsU+GEB0TAfzLFtzmi9gqA
X-Google-Smtp-Source: AGHT+IG0k1HfHErcjyt9UnnNCHtTUUIyy9cay2f9NiptQYUe8IiwicLu7EVqawy0NSGddEzQCzLdj/3rpy8rtxg74zM=
X-Received: by 2002:a05:651c:552:b0:30a:2a8a:e4b5 with SMTP id
 38308e7fff4ca-328077917e1mr7382711fa.27.1747381922119; Fri, 16 May 2025
 00:52:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250512085735.564475-1-chao.gao@intel.com>
In-Reply-To: <20250512085735.564475-1-chao.gao@intel.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Fri, 16 May 2025 09:51:50 +0200
X-Gm-Features: AX0GCFvQIHrKhWBqY5HZUiaCr7YpQaIuo0VzyzRBnasZaLwdOeH3IdMPQ6Kj6Us
Message-ID: <CAFULd4Y3VvqNS8VEvw0ObnqnVDtsC-q3kDEnyc070=gZ9oehgg@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] Introduce CET supervisor state support
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, dave.hansen@intel.com, seanjc@google.com, 
	pbonzini@redhat.com, peterz@infradead.org, rick.p.edgecombe@intel.com, 
	weijiang.yang@intel.com, john.allen@amd.com, bp@alien8.de, 
	chang.seok.bae@intel.com, xin3.li@intel.com, 
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Eric Biggers <ebiggers@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Kees Cook <kees@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Mitchell Levy <levymitchell0@gmail.com>, Nikolay Borisov <nik.borisov@suse.com>, 
	Oleg Nesterov <oleg@redhat.com>, Samuel Holland <samuel.holland@sifive.com>, 
	Sohil Mehta <sohil.mehta@intel.com>, Stanislav Spassov <stanspas@amazon.de>, 
	Vignesh Balasubramanian <vigbalas@amd.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2025 at 10:57=E2=80=AFAM Chao Gao <chao.gao@intel.com> wrot=
e:
>
> Dear maintainers and reviewers,
>
> I kindly request your consideration for merging this series. Most of
> patches have received Reviewed-by/Acked-by tags.
>
> Thanks Chang, Rick, Xin, Sean and Dave for their help with this series.
>
> =3D=3D Changelog =3D=3D
> v6->v7:
>  - Collect reviews from Rick
>  - Tweak __fpstate_reset() to handle guest fpstate rather than adding a
>    guest-specific reset function (Sean & Dave)
>  - Fold xfd initialization into __fpstate_reset() (Sean)
>  - v6: https://lore.kernel.org/all/20250506093740.2864458-1-chao.gao@inte=
l.com/
>
> =3D=3D Background =3D=3D
>
> CET defines two register states: CET user, which includes user-mode contr=
ol
> registers, and CET supervisor, which consists of shadow-stack pointers fo=
r
> privilege levels 0-2.
>
> Current kernel disables shadow stacks in kernel mode, making the CET
> supervisor state unused and eliminating the need for context switching.
>
> =3D=3D Problem =3D=3D
>
> To virtualize CET for guests, KVM must accurately emulate hardware
> behavior. A key challenge arises because there is no CPUID flag to indica=
te
> that shadow stack is supported only in user mode. Therefore, KVM cannot
> assume guests will not enable shadow stacks in kernel mode and must
> preserve the CET supervisor state of vCPUs.
>
> =3D=3D Solution =3D=3D
>
> An initial proposal to manually save and restore CET supervisor states
> using raw RDMSR/WRMSR in KVM was rejected due to performance concerns and
> its impact on KVM's ABI. Instead, leveraging the kernel's FPU
> infrastructure for context switching was favored [1].

Dear Chao,

I wonder if the same approach can be used to optimize switching of
Intel PT configuration context. There was a patch series [1] posted
some time ago that showed substantial reduction of overhead when
switching Intel PT configuration context on VM-Entry/Exit using
XSAVES/XRSTORS instructions:

Manual save(rdmsr):     ~334  cycles
Manual restore(wrmsr):  ~1668 cycles

XSAVES insturction:     ~124  cycles
XRSTORS instruction:    ~378  cycles

[1] https://lore.kernel.org/lkml/1557995114-21629-1-git-send-email-luwei.ka=
ng@intel.com/

Best regards,
Uros.

