Return-Path: <kvm+bounces-21040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 052B592842B
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 10:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4A0E1F22864
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 08:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E36FF145FF9;
	Fri,  5 Jul 2024 08:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZporI4MG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A518A145B26
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 08:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720169540; cv=none; b=maSxVm8FOdIEgLm0UZyOzbTip7h9kI4r56w52dz0o80LeiLM3U9I3bTjsBEzyUG05x0UpC8tCarjqBwLXdQGtmZWWWk28xgBnLMwa9PPb9Dp1MN5Uc7lkPgcWhPM/dX/tro7eIr82rCy7JNhqfvoVK02W+LRyHd+c8k6GoZtd4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720169540; c=relaxed/simple;
	bh=FD6qzwI5ymn+tMirsDTY4+mmM9+OpdMH8NLnieLT7GQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SXKxIKYrdsDsz+ZOm8XDJdyFwT8pyalOFw0ZwEcjOA0jPyh3Hfvg0kLzkV2DVe+R+BX8Cum9a+QCg3PjeV1v1Q7bZXu36y0bJjyqk4AkZwGjHrRa6lx4xKbocCl09OTO/TLreW7ZzNQLTOfMNNj/EcL6WQnGHsFEMMfQmMteffQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZporI4MG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720169537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RcKIuZ0fBHZD+9IdJ+/GkLctQeGZVxaU7Gh2gVlDniU=;
	b=ZporI4MG2Wxw2oA17bEb5X1AGqNx8GQHC0nEebqsfPKxQYEIwOGRxWNpDrZAPdeiaT3Rz9
	JphxrVQV/lbRMie+/p4JopluMp7nWwu8s9Nck/PkSOh+6yjWgNvxuTjucgYliz63nlzUSN
	M7XAivngVgdKQHfzeTVXOJIJO+j7+9M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-fX-SRlxXOtqhOKNVQqZbzA-1; Fri, 05 Jul 2024 04:52:15 -0400
X-MC-Unique: fX-SRlxXOtqhOKNVQqZbzA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42567dbbd20so10978615e9.0
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2024 01:52:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720169534; x=1720774334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RcKIuZ0fBHZD+9IdJ+/GkLctQeGZVxaU7Gh2gVlDniU=;
        b=LrNrqeOWcNeQNr185DnVTaLkOsH66zNBbg2quwEcYube2C5b28QWlfq+FrBobUOVze
         hndWYqmSnAKB9RcNRafsBNDGa6yTu4HnuZVTqSSistuGgYHJfoJpPSGGZGHYaCSbeWsh
         AhettnEZUpTA72T/UB10McKFj+929gdy9Qspq7I7cpDk3uuHmbwDPOHcflMxOG90l7fe
         GACefm5+AS+mGEFZqgjE/pjM82nO7GnBqJJEgtxRI3+sqMnOBC19gZ2uGrE2rrsqVAEO
         NqLtvVF4ZbA1b9mxVDbXjYBhh+VGq/SqcDnbPfbBxUDWvaUVarH5jZXAlFc6LQYUOx5P
         foZg==
X-Gm-Message-State: AOJu0YyZHrt5P/Yk8H1WxjY+7NvhgjeOkQzShMV3hHbxNYT0ZVhOmk13
	NmBvYjaEJOn1jT6D23S8YxlqKWn2Gn1nG2c8y4+Ivh6GOi4/xD62KFMq1AuL32z4E132BAT7h5N
	cgVpSPUbAbBgDZzGMvXiLTG07qLvN2rtxvOhgnQKBYSaGjZ0xTDhUIR5eYs0irq+JvvouFiSS9y
	pua0TSFIU/1QMQDG04rZcVkKdGlQrcj8BC
X-Received: by 2002:adf:e686:0:b0:35f:1835:3a76 with SMTP id ffacd0b85a97d-3679dd72184mr2746736f8f.70.1720169533940;
        Fri, 05 Jul 2024 01:52:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVJ1oHEtb2JrPH4Vyq4C0cj/a2ZkkiNYu6z2olZgdj4gHF3ikNqZrrKWVJHW4dq6UUFdvsLOq0ZnnsgAJ6S3g=
X-Received: by 2002:adf:e686:0:b0:35f:1835:3a76 with SMTP id
 ffacd0b85a97d-3679dd72184mr2746716f8f.70.1720169533573; Fri, 05 Jul 2024
 01:52:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240704084245.13539-1-borntraeger@linux.ibm.com>
In-Reply-To: <20240704084245.13539-1-borntraeger@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 5 Jul 2024 10:52:00 +0200
Message-ID: <CABgObfY1R8EVOAGJ9p_F1ovA-gTvTedSyprqDsm3HGfCo-FA1A@mail.gmail.com>
Subject: Re: [GIT PULL 0/1] KVM: s390: Fix z16 support (for KVM master)
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	linux-s390 <linux-s390@vger.kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Thomas Huth <thuth@redhat.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Marc Hartmayer <mhartmay@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 10:43=E2=80=AFAM Christian Borntraeger
<borntraeger@linux.ibm.com> wrote:
>
> Paolo,
>
> please pull the following for 6.10
>
>
> The following changes since commit dee67a94d4c6cbd05b8f6e1181498e94caa333=
34:
>
>   Merge tag 'kvm-x86-fixes-6.10-rcN' of https://github.com/kvm-x86/linux =
into HEAD (2024-06-21 08:03:55 -0400)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kv=
m-s390-master-6.10-1
>
> for you to fetch changes up to 4c6abb7f7b349f00c0f7ed5045bf67759c012892:
>
>   KVM: s390: fix LPSWEY handling (2024-07-01 14:31:15 +0200)

Pulled, thanks.

Paolo

>
> ----------------------------------------------------------------
> KVM: s390: Fix z16 support
>
> The z16 support might fail with the lpswey instruction. Provide a
> handler.
>
> ----------------------------------------------------------------
> Christian Borntraeger (1):
>       KVM: s390: fix LPSWEY handling
>
>  arch/s390/include/asm/kvm_host.h |  1 +
>  arch/s390/kvm/kvm-s390.c         |  1 +
>  arch/s390/kvm/kvm-s390.h         | 15 +++++++++++++++
>  arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
>  4 files changed, 49 insertions(+)
>


