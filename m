Return-Path: <kvm+bounces-39663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF9EA492F8
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78D81189544F
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 08:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A631E8339;
	Fri, 28 Feb 2025 08:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GwqQpQdB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8267D1E1C3F
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 08:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740730092; cv=none; b=PFqtC6RfREssEc2JqqmQEM2QZK4FucxzosMhWb31GoT+rO4DEDnANGRWKh1zP0XJh8zHy/9tx93A42gVHjqAk75mWhv+d1X16Gl0a1uj86783SBVJk9SEN4+Xx/2TMxJ32HyQP0gGiOkGyay329QtfvO7lRQwjE/lQEVr8mSsjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740730092; c=relaxed/simple;
	bh=r9GSmtMicPcq5rW2NPP7VRMa9gYB5kx0AW78fr0QhO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tySBY3E/9wz+Nz1xMbGe2aJH7uT78xBk5M7KBMqM1QSbehxy2akCFX+tX4CXRhsPfVLI/BuPPryfPI2q6wip2xsJqNSR6s6Z14RvTvFdecDjDLjJbpeokyx21h2t4iv8YAtlyjCerey5qfm2NNbkq55uKvl32AXNngmz/H3tTwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GwqQpQdB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740730089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdUTuAdjhkxdXouf9L2YfL8fvPAf9Q3Za2OJ9RnA1QY=;
	b=GwqQpQdB4AxZuofKRmSjci5r9TUXHyO7hc/7/QxKbPbmxzxKGwaTqBOOGc1rL9m9rvqMFt
	g1MDmQZbP7+71Hxl4DDYhelb4lUdsfYz79wf+o0RsFnwRf0GbYyIRXTM4Dk2zX/CYXtPDy
	4e1meH0ZtrGnUKIdZPcHBuO1FTIiG+0=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-tY4D4xAGPqacXf6L0XiNDg-1; Fri, 28 Feb 2025 03:08:05 -0500
X-MC-Unique: tY4D4xAGPqacXf6L0XiNDg-1
X-Mimecast-MFC-AGG-ID: tY4D4xAGPqacXf6L0XiNDg_1740730085
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5236260d1bdso307112e0c.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 00:08:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740730085; x=1741334885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LdUTuAdjhkxdXouf9L2YfL8fvPAf9Q3Za2OJ9RnA1QY=;
        b=D2wDM9+RZwADHR19j3JGaq9YjnfEuHWUqt04BHJc6NDucg4r0B8nJMbDhKtClQ6uuR
         g6QqKmKX8XJgdfq56ibLgJEUCuj+Qp6fQWFLUKFwFbCmcrMCJLjcvKT1KuJ1qsKCcqnR
         uiNR0NB0J6csbwAiJSDmxtUfjVjoAD5Mgjn9YCr39i14qdo1Zu+onLRBeb2kyo9TLDvT
         7L9w3PBY6cr1nnD0BAG6Qr8aIYqfY2tgUaNBnWW1A2xI5uS4R8f5ns7lvRu4asm4xpIs
         9KRj+ApTCJg3GXtdlXB0EnFw++3osU4jtxHRIT+ZBrPFzUpW3zd2QtAj5MZ8FUBhBQmW
         Dv6A==
X-Forwarded-Encrypted: i=1; AJvYcCUM5aGgfOKU+Jb93b2IUNZzPJYBU8P+jAm/tiPStvhjI/hr3YSEt90WonJCNy6RlAyttFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrRWyYxZBwltAjuJjy4J6QKxGycUFG9yh77224xINjdOJvbK6I
	QqLdzBwDGdTf98pLSyzTSyAWQu+kNtG7E6mcjBh+OakwuN8IilbwLi28BljKGy/hmIt2tn4yj3V
	FtvLsdm6T7oYr0z4bd42azP6zA9sfoJLNZ3b2WviVcWjS9UzJ9G079u4TjzXEq8ZA3Ho/u7XJjW
	TxGkEFd+m2WeK4XlLTPOkVDQAZ
X-Gm-Gg: ASbGncvmcTq3XvwM6sRwIyYYnBuJpHyzBh+67bhsQH6lrZVyAcu9di/glvHajMexJPv
	xkFvzwtq+QeCKTuBgl1SErEjh590LBdn9l67+11O4c5SiL1Qp1kKTtYzFd8WpK5AXhdUuHPi0mg
	==
X-Received: by 2002:a05:6122:8293:b0:520:4fff:4c85 with SMTP id 71dfb90a1353d-52358fa2777mr1810209e0c.2.1740730085125;
        Fri, 28 Feb 2025 00:08:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHnzJbPx76VPjBpQt7am7d8LKNakTr6F/2ZNTopcxram3/9GKreE3AEQUVie6mNxSMpVmuq6MObJy/GAXT7g5A=
X-Received: by 2002:a05:6122:8293:b0:520:4fff:4c85 with SMTP id
 71dfb90a1353d-52358fa2777mr1810203e0c.2.1740730084874; Fri, 28 Feb 2025
 00:08:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250227230631.303431-1-kbusch@meta.com>
In-Reply-To: <20250227230631.303431-1-kbusch@meta.com>
From: Lei Yang <leiyang@redhat.com>
Date: Fri, 28 Feb 2025 16:07:24 +0800
X-Gm-Features: AQ5f1JqPk0QRBHoltnkDQ29vhpwSBSIPKORj3Gk6lgM7TDuBtJyK6aRdH4dto9I
Message-ID: <CAPpAL=zmMXRLDSqe6cPSHoe51=R5GdY0vLJHHuXLarcFqsUHMQ@mail.gmail.com>
Subject: Re: [PATCHv3 0/2]
To: Keith Busch <kbusch@meta.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, x86@kernel.org, netdev@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Keith

V3 introduced a new bug, the following error messages from qemu output
after applying this patch to boot up a guest.
Error messages:
error: kvm run failed Invalid argument
error: kvm run failed Invalid argument
EAX=3D00000000 EBX=3D00000000 ECX=3D00000000 EDX=3D000806f4
ESI=3D00000000 EDI=3D00000000 EBP=3D00000000 ESP=3D00000000
EIP=3D0000fff0 EFL=3D00000002 [-------] CPL=3D0 II=3D0 A20=3D1 SMM=3D0 HLT=
=3D0
ES =3D0000 00000000 0000ffff 00009300
CS =3Df000 ffff0000 0000ffff 00009b00
SS =3D0000 00000000 0000ffff 00009300
DS =3D0000 00000000 0000ffff 00009300
FS =3D0000 00000000 0000ffff 00009300
GS =3D0000 00000000 0000ffff 00009300
LDT=3D0000 00000000 0000ffff 00008200error: kvm run failed Invalid argument

TR =3D0000 00000000 0000ffff 00008b00
GDT=3D     00000000 0000ffff
IDT=3D     00000000 0000ffff
CR0=3D60000010 CR2=3D00000000 CR3=3D00000000 CR4=3D00000000
DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
DR3=3D0000000000000000
DR6=3D00000000ffff0ff0 DR7=3D0000000000000400
EFER=3D0000000000000000
Code=3Dc5 5a 08 2d 00 00 00 00 00 00 00 00 00 00 00 00 56 54 46 00 <0f>
20 c0 a8 01 74 05 e9 2c ff ff ff e9 11 ff 90 00 00 00 00 00 00 00 00
00 00 00 00 00 00
EAX=3D00000000 EBX=3D00000000 ECX=3D00000000 EDX=3D000806f4
ESI=3D00000000 EDI=3D00000000 EBP=3D00000000 ESP=3D00000000
EIP=3D0000fff0 EFL=3D00000002 [-------] CPL=3D0 II=3D0 A20=3D1 SMM=3D0 HLT=
=3D0
ES =3D0000 00000000 0000ffff 00009300
CS =3Df000 ffff0000 0000ffff 00009b00
SS =3D0000 00000000 0000ffff 00009300
DS =3D0000 00000000 0000ffff 00009300
FS =3D0000 00000000 0000ffff 00009300
GS =3D0000 00000000 0000ffff 00009300
LDT=3D0000 00000000 0000ffff 00008200
TR =3D0000 00000000 0000ffff 00008b00
GDT=3D     00000000 0000ffff
IDT=3D     00000000 0000ffff
CR0=3D60000010 CR2=3D00000000 CR3=3D00000000 CR4=3D00000000
DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
DR3=3D0000000000000000
DR6=3D00000000ffff0ff0 DR7=3D0000000000000400
EFER=3D0000000000000000
Code=3Dc5 5a 08 2d 00 00 00 00 00 00 00 00 00 00 00 00 56 54 46 00 <0f>
20 c0 a8 01 74 05 e9 2c ff ff ff e9 11 ff 90 00 00 00 00 00 00 00 00
00 00 00 00 00 00
EAX=3D00000000 EBX=3D00000000 ECX=3D00000000 EDX=3D000806f4
ESI=3D00000000 EDI=3D00000000 EBP=3D00000000 ESP=3D00000000
EIP=3D0000fff0 EFL=3D00000002 [-------] CPL=3D0 II=3D0 A20=3D1 SMM=3D0 HLT=
=3D0
ES =3D0000 00000000 0000ffff 00009300
CS =3Df000 ffff0000 0000ffff 00009b00
SS =3D0000 00000000 0000ffff 00009300
DS =3D0000 00000000 0000ffff 00009300
FS =3D0000 00000000 0000ffff 00009300
GS =3D0000 00000000 0000ffff 00009300
LDT=3D0000 00000000 0000ffff 00008200
TR =3D0000 00000000 0000ffff 00008b00
GDT=3D     00000000 0000ffff
IDT=3D     00000000 0000ffff
CR0=3D60000010 CR2=3D00000000 CR3=3D00000000 CR4=3D00000000
DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
DR3=3D0000000000000000
DR6=3D00000000ffff0ff0 DR7=3D0000000000000400
EFER=3D0000000000000000
Code=3Dc5 5a 08 2d 00 00 00 00 00 00 00 00 00 00 00 00 56 54 46 00 <0f>
20 c0 a8 01 74 05 e9 2c ff ff ff e9 11 ff 90 00 00 00 00 00 00 00 00
00 00 00 00 00 00

Thanks
Lei

On Fri, Feb 28, 2025 at 7:06=E2=80=AFAM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> changes from v2:
>
>   Fixed up the logical error in vhost on the new failure criteria
>
> Keith Busch (1):
>   vhost: return task creation error instead of NULL
>
> Sean Christopherson (1):
>   kvm: retry nx_huge_page_recovery_thread creation
>
>  arch/x86/kvm/mmu/mmu.c    | 12 +++++-------
>  drivers/vhost/vhost.c     |  2 +-
>  include/linux/call_once.h | 16 +++++++++++-----
>  kernel/vhost_task.c       |  4 ++--
>  4 files changed, 19 insertions(+), 15 deletions(-)
>
> --
> 2.43.5
>


