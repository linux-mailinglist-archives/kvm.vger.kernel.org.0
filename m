Return-Path: <kvm+bounces-61031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C219C071D9
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 17:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6CE33A4DEE
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 15:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA54932E72F;
	Fri, 24 Oct 2025 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="cKhl6nPx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B713219A7D
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761321440; cv=none; b=XOft18UhPMpZlz4+OJkMGJwH87GBDaTanzhuBSSoZBKZQzTxI+00KlAf3poL1KqZfuO6/C87KhybD/2zmB8s3nZ9IU/6v817m33wf/0SoHKBzg13gZNti+BBfjrX4qtDSMLrm0dx8in8BTY7kEBVPAa+srZRUYZ+zck+HrlJHw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761321440; c=relaxed/simple;
	bh=DWiGG85ath2jzAlAPFhCB5oiKw5XwqI4VvMQg5Ys3AE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xd657PMftKSZgZi6ntGm+877HwzDgwPbGgD/zfJ7oErKWi+P1wxkm1LUE7Wl22Py1BqYXxr6id108QLKmJjXZil/d/9cYGwqqjYvDmLBWx70UQqT15QM3eIoJTh0+S52IwhZavv+0fP0g/n2tI8c1sqsePLjQ8/BOWaBnauPKFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=cKhl6nPx; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-430c6eef4b9so9785775ab.0
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 08:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1761321438; x=1761926238; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWiGG85ath2jzAlAPFhCB5oiKw5XwqI4VvMQg5Ys3AE=;
        b=cKhl6nPxIbxNpBchdLjhJBjAXQhHgqsFhwdHgVjBRPOKfAVZEexL7+I8mWSiLWNLH6
         KyABMzivBfsFPfryh5+Q9HlDx3J0RsgrIK6A0RySNUjzh6Zfrqcdl1vv2GmVJ88i9lB8
         V1/jxBo4ZZ60NF7IeMuO7jyf8zNgwlz3A5z9c1z3pFWu9i42GcWORZdC+Rz31kKpq6pO
         5TQtBY54kDCs2cmqZakOtsARt8t0tOCAFMFPifXaFLQJj4iZGguX2tv5aaAsRSAI4XDA
         +SoHeLnpP0KFlgLaKugyK0T2jxByhZiSUPatFP/AFlFfAZ8SEl8roGvZPQz+NhU1DEth
         vkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761321438; x=1761926238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DWiGG85ath2jzAlAPFhCB5oiKw5XwqI4VvMQg5Ys3AE=;
        b=b9zhoJ/uyQm6gEmCSSq7hBxYG6fDvprVBq6flHJzgmqNYzhqqaDr027ee4ibyHpe//
         Z4ScJoxlrj3nIu+q0sJn/kAM/UrtyBz/WuEY7O+q7Ao4AfFgQvJawMOGmwgqg7Th4EQT
         1nNWB5NgGKmHEl2p+M1Fy7rgbTweLDqvYCGXaX5gQXMXP2PYJqgBIJd0l47yl7eH6bka
         5zDPA1Z+QzSOGRgY/vbNWeT1R8Zm+TP1R77PP4yuZpEiJ307NURPNjWIyzckP9UmLC9/
         310vaMZdyNSXpBOf9DFwV+ejtKG2x4ju0ljYPQexdIhQ0IBPgTHVYMP7OLKGBw0guvtf
         aW+w==
X-Forwarded-Encrypted: i=1; AJvYcCWN6VSZaLFGD0vXzdc1PeIy7+sfT0/xqlPTmAKxnrGjbQ7Mio085W6SJrD8qSZR2J80/L8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb0rK4Nj4OFRCcpggMCzVRsduSrF5bt7DI205PW3wSzgWecA9A
	oCfpO3J5w4r0iVI5WlK2WVossdp30gPbw04Fkdv88s0Fsl6cLyaoGtX/PG45JlLXa8WM09UVR+g
	uiXYWOJT0ASZsiOr012YBjT1DIJI6I6NS0m9ts6jzhQ==
X-Gm-Gg: ASbGncuocM9Koc2wIkV3319AMY+WekxKFvZYe3x+uRU4fkMbYkL4RFVIMlVwYuEhJwh
	kTlGkU+vRuuZzMbb29abxO4MsbX2801MJXKaNdgwALfb+LInmUwrChpfso+ng7rcn1sY3bAEj2O
	ftt1P42bYYxu4pToSg1pITkIgcp8U4TYlQ8RmJUl1sWYlbiGtuRbl1jJvm/hzs5NGkezwmcON3F
	e8XOrSJsgkBvGHTIou2c/hCqu9mHn7wHLaC3Jfcd09uRrNZlag9m2qi+DVGRd1ZLK0l+9FFXm3d
	/DVCbBmn/g0QX9nBPm+LdHlC6eTr
X-Google-Smtp-Source: AGHT+IHEWvX0kFGAJ7kHIWxzKY5dF/OETQwGko7y9vL4NrCbfZQtWvnUvuQjJv0i7nzg2wW4twAN7C9YdUXGq4v36l4=
X-Received: by 2002:a05:6e02:4711:b0:431:d63a:9203 with SMTP id
 e9e14a558f8ab-431d63a93fbmr101492025ab.19.1761321437606; Fri, 24 Oct 2025
 08:57:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1fCCdciZLqmoeWDG_QoOHDi9j0_ZZKYkpGJmWrf14Q-g@mail.gmail.com>
 <20251024133116.73803-1-fangyu.yu@linux.alibaba.com> <CAAhSdy3E7-uC=pwU3c93bj3_xykPnLUcDXgKJtJ0KYeL91tijw@mail.gmail.com>
In-Reply-To: <CAAhSdy3E7-uC=pwU3c93bj3_xykPnLUcDXgKJtJ0KYeL91tijw@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 24 Oct 2025 21:27:06 +0530
X-Gm-Features: AWmQ_blSmL4OTf6qXTR2BfjEwNydZe5Z-dw51LCKSd1XhTinIaUMHniok6lfuns
Message-ID: <CAAhSdy1+TLUgi54uiHg7xomUo7tA_rs7Kt6b4OdUCvDQXjZYiQ@mail.gmail.com>
Subject: Re: Re: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
To: fangyu.yu@linux.alibaba.com
Cc: alex@ghiti.fr, aou@eecs.berkeley.edu, atish.patra@linux.dev, 
	guoren@kernel.org, jiangyifei@huawei.com, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, palmer@dabbelt.com, pbonzini@redhat.com, 
	pjw@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025 at 8:55=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Fri, Oct 24, 2025 at 7:01=E2=80=AFPM <fangyu.yu@linux.alibaba.com> wro=
te:
> >
> > >> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> > >>
> > >> As of commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()"),
> > >> vm_pgoff may no longer guaranteed to hold the PFN for VM_PFNMAP
> > >> regions. Using vma->vm_pgoff to derive the HPA here may therefore
> > >> produce incorrect mappings.
> > >>
> > >> Instead, I/O mappings for such regions can be established on-demand
> > >> during g-stage page faults, making the upfront ioremap in this path
> > >> is unnecessary.
> > >>
> > >> Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table progr=
amming")
> > >> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> > >
> > >LGTM.
> > >
> > >Queued it as fix for Linux-6.18
> > >
> > >Reviewed-by: Anup Patel <anup@brainfault.org>
> > >
> > >Thanks,
> > >Anup
> > >
> >
> > Hi Anup:
> >
> > Thanks for the review.
> >
> > Please note that this patch has two build warnings, and I have fixed
> > on patch V2:
> > https://lore.kernel.org/linux-riscv/20251021142131.78796-1-fangyu.yu@li=
nux.alibaba.com/
> >
>
> Can you send a separate patch with Fixes tag to this patch?
>
> You can base the patch on riscv_kvm_next branch at:
> https://github.com/kvm-riscv/linux.git
>

For some reason, your v2 patch never showed up in my inbox :(

No need for a separate patch. I have picked your v2.

Regards,
Anup

