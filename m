Return-Path: <kvm+bounces-34178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D2F9F85EB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 21:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6AF7188F990
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 20:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647071C07EC;
	Thu, 19 Dec 2024 20:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Psdh15WE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10F1BD9C2
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734640233; cv=none; b=clRR4wyheWBtoQB3nugTkst5VDXT/9OaXEG0sIwzeVWXsBtVCoX/fqJmxRQ+Z1Z0NflekhhYYfaUXpu07RkS15FFnPbWmAee0WdlyzYM6MTJ0WwJX15iciZeB7RuW8m2ns4FEEht5ZjruqGAe2kBH1+1dff+0wU7rvok5nRcwWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734640233; c=relaxed/simple;
	bh=3Zw6fSTWWu5wmDomEKK3VbQK0kpaB1HUHZGPOj7Xe3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zo3VXAWVDkpldl3HsBsKrdERTZ0ZBdwzWnvtYkhKSrlwlKUWp58qcaJM6aMQJjeAYhXsugNyy6Ihl3lTHSz7azvGlqpaQV74NIAR8kcvQtCX7a/X4rPACig0PbcJjAuRz3FgmEcU2J6dQklWZ3yCQ8rr84cf+J2cc/8FTZ1Bh4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Psdh15WE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734640231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dJdGcKb2fG1Rfo5oeZfoPihaFY6dB1Z6koDPsbNC5l4=;
	b=Psdh15WESsuEwLkhb47jtGPqF2IYfJKUYD7AAZdH7InT0scMnGPUbqFmGKuSJ/XPON4BCG
	eQneifl0atpiB8wbGIH9u3+qG2H1esmlZ8zBCTed4f4ndrH5PHwMaVNnW7DKPzr4MyAG51
	uxyrKAYfUWeXqAjGfva6iOWeZfs+VtM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-e5ZsdiUJNIioeQzWEvUDHw-1; Thu, 19 Dec 2024 15:30:29 -0500
X-MC-Unique: e5ZsdiUJNIioeQzWEvUDHw-1
X-Mimecast-MFC-AGG-ID: e5ZsdiUJNIioeQzWEvUDHw
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385e03f54d0so613557f8f.3
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 12:30:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734640228; x=1735245028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJdGcKb2fG1Rfo5oeZfoPihaFY6dB1Z6koDPsbNC5l4=;
        b=P1oaI5cud3SC59W/UUlEJTz5AHZDLf/BWC2zyry79flS2liDiGRLLDrFLKXFT3LgLF
         9HzdqAKTpBkAbUI/F2w3P7Vr750nUpIKfqI8wB28nXeap/CDTt6T1xUPQ/PVeu1Pde+B
         lucJml+F2ZSloTdmdJp7ElQdFSPhPW/BCbS8NJD79KEERa53vMoGpXXwVHa7yj4mCP9n
         aAH3Iv9BgRSh+ifge4EmvdaMonlv6tUTJPKCvsfI6FrDvF8ftu4ekSLOfU8H58kuDeFj
         KjgKtJg3o2c1oVCfFKeStQH0fsJ1zG48GM6+GJvSGxxm05Bm+5JPm/N8sUztWRxWlQcs
         wAuw==
X-Forwarded-Encrypted: i=1; AJvYcCUvEU1FJ/Nn6iMGarSIuPvI5DVfTy8zL5iT9o34Qq6ZuMP6RR9eDqd0G9vYdVh8xGR5cFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHI+mnIrFuPNJUQoSZq7RGx7CJNZCJ+zpSDnb+z8eQLv6P1YPs
	AzTzhHdZ4cDtWoWsahxkM7cm9f76vR2F0jneXws5DuJBnymr/foGb4IlqS7xdoz0DEqErjI3Uqk
	TjsUMg+2brrOneol+CJHzOE6tIgNV5MjsXBYyDi2rtu4hPqgKOscl/x4efc/n8ad66yvNmATKPV
	UjiSybYI19zo4BRqLeaHUTvCfh
X-Gm-Gg: ASbGncu3mb3DdUekhiXeKVzPDeQQqTMx1DwCPKzcUl1bqWphfHR4u+C/DOfW7jvSBBi
	8FdlAWncirWLD3mBbne9iSLStV8r2wVDdIw4iSA==
X-Received: by 2002:a5d:59ad:0:b0:386:4277:6cf1 with SMTP id ffacd0b85a97d-38a223fd49dmr420360f8f.39.1734640228226;
        Thu, 19 Dec 2024 12:30:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEL1qzXBDXxGj0lWtwZ9+Ytv1/FMAHnP0vA9KlbyhJOQ/E0XQzeCd+tlyq/eczKOyHUZCP/tuO3FQf9bA2TWiM=
X-Received: by 2002:a5d:59ad:0:b0:386:4277:6cf1 with SMTP id
 ffacd0b85a97d-38a223fd49dmr420342f8f.39.1734640227914; Thu, 19 Dec 2024
 12:30:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108130737.126567-1-pbonzini@redhat.com> <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com> <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 19 Dec 2024 21:30:16 +0100
Message-ID: <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
To: Keith Busch <kbusch@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, 
	Luca Boccassi <bluca@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024 at 7:09=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
> > Is crosvm trying to do anything but exec?  If not, it should probably u=
se the
> > flag.
>
> Good point, and I'm not sure right now. I don't think I know any crosvm
> developer experts but I'm working on that to get a better explanation of
> what's happening,

Ok, I found the code and it doesn't exec (e.g.
https://github.com/google/crosvm/blob/b339d3d7/src/crosvm/sys/linux/jail_wa=
rden.rs#L122),
so that's not an option. Well, if I understand correctly from a
cursory look at the code, crosvm is creating a jailed child process
early, and then spawns further jails through it; so it's just this
first process that has to cheat.

One possibility on the KVM side is to delay creating the vhost_task
until the first KVM_RUN. I don't like it but...

I think we should nevertheless add something to the status file in
procfs, that makes it easy to detect kernel tasks (PF_KTHREAD |
PF_IO_WORKER | PF_USER_WORKER).

Paolo


