Return-Path: <kvm+bounces-53558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E278B13F35
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDB573A84D1
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521B42741BC;
	Mon, 28 Jul 2025 15:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WXrr1j7w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F1126B75E
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 15:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753717641; cv=none; b=DGGtKmwRbZtXGDHW1EotZ/xD/S6hQCCOSU2o6vJZhcnpLEMsWi1xQR3xU4QPxie+1QiZiW2h13mPhVZD5b8g21B6472980aHYcfyxHeRbi6gzaa8MSzjBy9LGrFzfcF03kPJT8TmvqjT9R+GKe3f0ZqeAjrLt+NVRX4JrmU2ZE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753717641; c=relaxed/simple;
	bh=egEuEBlsNKwrfzIztqb0TZJdB1FrMTRyzYhn8Er615U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nSx26CbfwTnEOx/pw8bu3Q68LWefpdIC8GQUZIvcf13V3a/0Bp7uM2KwP46sww88D/JvniIGwxoA0hnHKp7h5mHGKnqCRE8moZbUurfjO5rWUgPL9H/BP28t7OL4jm0DmFIH8SjVJfOLGq91OX5YpqnhlhOel0lHGh75MDCmOC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WXrr1j7w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753717638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Wtgg7/5DZCONUh3qG3g+QKqH7gdzPFy8ZnZGt8cpek=;
	b=WXrr1j7wOF/yMTkCX9Syy9avDrGFio2v+OqCKboDEQ7MWEQyshGMSI56H0+X2bPcIZx/Ty
	8zdLJoUgTgbZSdySC4MVRCPfSixRkt2+7LZbQ8+/OemBCqStz3BYIxMirxeTp124ag7K/c
	2I/pE1JZUa+pE7oeCSbd03pd6hqzvgY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-ke1LX52HN7SOsev8s0VTxg-1; Mon, 28 Jul 2025 11:47:16 -0400
X-MC-Unique: ke1LX52HN7SOsev8s0VTxg-1
X-Mimecast-MFC-AGG-ID: ke1LX52HN7SOsev8s0VTxg_1753717635
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b20f50da27so18094f8f.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 08:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753717634; x=1754322434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Wtgg7/5DZCONUh3qG3g+QKqH7gdzPFy8ZnZGt8cpek=;
        b=LLuOkFFiUzSpD5q6vJxzGZeK7vy44IrCT+60lOG7QJGLNwtK1y++qB4FXhrtp6t1zJ
         /5p63R0zCFJSTljZzuB2A4/sRDjzf0w15Cwo2WAMlcYhddgKkpep5Nf2/pg70Fls73Mz
         CO5xcnxm2uBPvNV2H1tntLXt6WwKA+1UN+MGTKABs498olaTrViab2+oSdddOEjXNodT
         jyOkurjm7bPn79hsjG8K1ETixzDKMWIWSTb3djMUJq5iKa72FudP15jXc5YkJiLFXa5G
         UMCr/w+M/OGbwtZD85nr108S3M4E+VeeUz9CW/+9Ct5Xmqc9biuxS7kj7n1oVWy5bPXJ
         Dvzg==
X-Gm-Message-State: AOJu0YwFGvwFl6ZQ5D4ruGCkOLCatkef8rWiGb7/EkN7bdjrURodxBDE
	twwdKW6vZnp9AgNhA7DDn7UWtFgE4RxtEsR03apBgeIfFrP48VkT+zIKB4jJjplNvQnacupWiDH
	qfrPB2WqyTwuxgnr4VcCpGxmMv1dbyBcbQTb+cDBiF5EnSd6KWYk7ngdrWSsdYks2QRE8QhVqw9
	Ut//nzmBqVzxkoW6h6ApddDQ2YuBK+gesiF/kbMWE=
X-Gm-Gg: ASbGncs24sctpZHXhHaGRfw37UYzxVgulw5Kx2y3Mrm6tOVxaeP81KdxYZ7to513WUz
	feFbUPZVdimSgP9HizYrijYfC3S5p1kdz6+hQduT15vkwvbtJr2ubx/ovR0aqXMd2XUk7d1thIE
	PTMUkw7CX+oIH1Fz+ue9JJ2Q==
X-Received: by 2002:adf:a392:0:b0:3b6:1e6f:6219 with SMTP id ffacd0b85a97d-3b78e61f76dmr31684f8f.29.1753717633843;
        Mon, 28 Jul 2025 08:47:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEuUHh2z9sR3e6IbuZjWrbdwq+hlIKVlO+oMmkrmiIewdVjOer41IlJpF2WIwA6ygSq5MtN+KcAQYw/quy6K0=
X-Received: by 2002:adf:a392:0:b0:3b6:1e6f:6219 with SMTP id
 ffacd0b85a97d-3b78e61f76dmr31669f8f.29.1753717633375; Mon, 28 Jul 2025
 08:47:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com> <20250725220713.264711-13-seanjc@google.com>
In-Reply-To: <20250725220713.264711-13-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 28 Jul 2025 17:47:01 +0200
X-Gm-Features: Ac12FXwGUZbd9mg0v05ty49eqrNrq8qFqZGXKq22GPDdO5lkh_Fh1cjjSjkkQQk
Message-ID: <CABgObfZWvtskg-m94LRHqN=_FtJpFtTzOi3sEhiAKZx1rzr=ng@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: VMX changes for 6.17
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 26, 2025 at 12:07=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Add a sub-ioctl to allow getting TDX VMs into TEARDOWN before the last re=
ference
> to the VM is put, so that reclaiming the VM's memory doesn't have to jump
> through all the hoops needed to reclaim memory from a live TD, which are =
quite
> costly, especially for large VMs.
>
> The following changes since commit 347e9f5043c89695b01e66b3ed111755afcf19=
11:
>
>   Linux 6.16-rc6 (2025-07-13 14:25:58 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.17
>
> for you to fetch changes up to dcab95e533642d8f733e2562b8bfa5715541e0cf:
>
>   KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM (2025-07-21 16:23:02 -0700=
)

I haven't pulled this for now because I wonder if it's better to make
this a general-purpose ioctl and cap (plus a kvm_x86_ops hook).  The
faster teardown is a TDX module quirk, but for example would it be
useful if you could trigger kvm_vm_dead() in the selftests?

As a side effect it would remove the supported_caps field and separate
namespace for KVM_TDX_CAP_* capabilities, at least for now.

Paolo

> ----------------------------------------------------------------
> KVM VMX changes for 6.17
>
> Add a TDX sub-ioctl, KVM_TDX_TERMINATE_VM, to let userspace mark a VM as =
dead,
> and most importantly release its HKID, prior to dropping the last referen=
ce to
> the VM.  Releasing the HKID moves the VM to TDX's TEARDOWN state, which a=
llows
> pages to be reclaimed directly and ultimately reduces total reclaim time =
by a
> factor of 10x or more.
>
> ----------------------------------------------------------------
> Sean Christopherson (1):
>       KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
>
>  Documentation/virt/kvm/x86/intel-tdx.rst | 22 ++++++++++++++++++-
>  arch/x86/include/uapi/asm/kvm.h          |  7 ++++++-
>  arch/x86/kvm/vmx/tdx.c                   | 36 +++++++++++++++++++++++++-=
------
>  3 files changed, 55 insertions(+), 10 deletions(-)
>


