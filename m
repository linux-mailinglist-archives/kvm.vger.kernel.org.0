Return-Path: <kvm+bounces-55876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECF85B382E7
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 14:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A916F46130B
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 12:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BCD350829;
	Wed, 27 Aug 2025 12:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dI/qV9Ix"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62BF212D83;
	Wed, 27 Aug 2025 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756299320; cv=none; b=Xi+LujULFkXbd+c+xr8DlHOKlERhPuJ8tyREOMYcS8BJx7auccYKnebhe0ZuqL8AbfO+kFOBz4Ep5gRR+EYR4sST9D3gVJMJ4EBT/DauSHgD670RlCp/Undk8kMWQL+hcYBhSjiJrJWvQV/eqS2YNzqUTo+B/Rfq6i3X7YVEIfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756299320; c=relaxed/simple;
	bh=9rDoKdChWIUzpABU24QXETA9agk9iq4Gu2GQ2alIciI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U2H7icJ0lz7pSV1C4h/RvalUbgAfKJn4VXrEDIbO3b6KeGpiZOX76Ff0Pyi2Jg3hdW3aH5beyWDOXjp1C2y304MRUPMVnVaoaLnXpq5yi7NYt3li6BpG5i7JrkTa/0j3MdQ22LP3tn4PMIbPVjiR4SXLQqMvCrR9JpwSyCfvmiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dI/qV9Ix; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb7ace3baso1209288966b.3;
        Wed, 27 Aug 2025 05:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756299317; x=1756904117; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rDoKdChWIUzpABU24QXETA9agk9iq4Gu2GQ2alIciI=;
        b=dI/qV9IxbM+sDzn+9K+SH6mrJLqG9MhK0R7a9dEiDCbxn6wcI4XJyuS2XbuolYZ7o4
         yAOlHyMUCl7o+Ttbz6sK1GmpdUUkEhPt4o9kmPktioaM/8GF0Cs6YJQu3ai7xmNM7wl0
         fgkUqAgPyFs5z/t7KwfN31NvtZcZ7NDJwDimfhBzEX731ZUvU1tSkNmWHpij5napU4kI
         gHpLXhjPD6Kl/Q/367358ujyWU1F+DntWgivLT0PGE83WmQ2W57nGVTK3JL9t/QM/7wz
         cyTW6+YolouikiG7CJ1uRZHMdYdlKrHDWI/I+FJW7SWjg4Mxb4+x1vaDXHhIMXjJflm1
         K1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756299317; x=1756904117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9rDoKdChWIUzpABU24QXETA9agk9iq4Gu2GQ2alIciI=;
        b=ITMdTjZ1btV/+JGznK7QNAz9mCMVppunCYnkZYK36ZEF489VXIJeT+G+flB/AtmOZt
         ysUUABFLEsai3bA488UoGUl95eYTRaSL3zhCT139a/Cmdcp71gV3mnOm3ItcFg1TzjKR
         JCPJOju53NqeQ2/RB7MXpjjZjsM8IfEuTrLiOiAt7fmtQCXoZck+wogtgtnypYtwCaAn
         PvlCHZKBn4umsQnXeWWf/OCZtzCQQXxp0zzy6tf8L4q9+6+sKvcFPCQM/LTUwPzW7mV1
         +1gfswtG22GUvKPpdnmED2nopHVm0TSOSi/DL37+GABDCPEzhbZm6iHYy/9jQwSQuYPa
         vECQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNDG3eLisgXxwEpx4HyHgeJjwYXyVXWshH/cyeaMkABZNcQ8FRuq1E9beLJPybJwm4yt3DgHd4YsgUTy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YztJLtiTo2+6EiEubT1wc4McMhYXpqLesRZLN461D0KD8lw5E4O
	8VEkK/glR8sX31Ced9QgMxqa0/XnZByqFnmJ2b5iP8wH5QvZk8nE0OORVfZSUlNCENL4avsGCrz
	hFuNwWG+GNqquI9gnsC9OnWJQ2aP8QV0=
X-Gm-Gg: ASbGnctTOODYHuSyqnale3sPmBQiimEBD18eo2BxYEKXvO9vD3e2N/974scOSzuHCXK
	fgqlddy+J8A476PRlVZNjSTqf9MrL5/jsSxBnc3bCr9D3Ju3OpB0etOXNSlB5nVI8HX1iKBolYT
	pnwD1zAykhoFD/86SZqyWHlHmPgEsoWPN6xYfJUKXcM2fBol0L9Or1l+EIAe3i61l4U0quk/o6W
	LFVXvYP
X-Google-Smtp-Source: AGHT+IEEFAw7VRZh5uzBWM0ssPY1oEd+3BIDE6/+p3DuVzyGw9vRb1TkN/MuzYXjvQlADKZmL/7eud/X++O37jBwZkI=
X-Received: by 2002:a17:907:961f:b0:afe:ad3c:ea53 with SMTP id
 a640c23a62f3a-afead3cf325mr479241966b.5.1756299315990; Wed, 27 Aug 2025
 05:55:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANypQFay9zbp9k0AHpfpm1OJ_shKiLZSmhMjCKFQhnhnuJQr0w@mail.gmail.com>
 <CABgObfZJzicJmpEEmhR=_abfTcT_km1sV0dfmYAt-ry42pFCNA@mail.gmail.com>
In-Reply-To: <CABgObfZJzicJmpEEmhR=_abfTcT_km1sV0dfmYAt-ry42pFCNA@mail.gmail.com>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Wed, 27 Aug 2025 20:54:39 +0800
X-Gm-Features: Ac12FXyjrCy4auXqFpdDvFOG4IUx6ug4GrfHMDsJfc3-xM3r1nBu4s9080Qhq2Y
Message-ID: <CANypQFY74VSbx+F0oGpy+NB0+_NUm3vVJen4BmaL_F6ez73vDg@mail.gmail.com>
Subject: Re: [BUG?] KVM: Unexpected KVM_CREATE_VCPU failure with EBADF
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

Thank you very much for the analysis. You were spot on.

Your suspicion about a race condition in the test executor was
correct. I confirmed this by modifying the reproducer: after
increasing the timeout in the main thread's wait loop before
close_fds() is called, the EBADF error disappeared. This confirms the
issue was indeed caused by faulty synchronization in the test harness.
I apologize for any noise this report may have caused.

Thanks again for your time and expertise. It's much appreciated.

Best regards,
Jiaming Zhang


Paolo Bonzini <pbonzini@redhat.com> =E4=BA=8E2025=E5=B9=B48=E6=9C=8827=E6=
=97=A5=E5=91=A8=E4=B8=89 17:46=E5=86=99=E9=81=93=EF=BC=9A
>
> I have occasionally seen EINVAL and EEXIST as well. My suspicion is a
> race condition due to incorrect synchronization of the executor
> threads with close_fds():
>
> 1) the failing executor thread calls KVM_CREATE_VM
> 2) the main thread calls close_fds() while the failing thread is still
> running, and closes the vm file descriptor
> 3) the failing thread then gets EBADF.
>
> For example, EEXIST could happen if before step 3, another executor
> thread calls KVM_CREATE_VM, receiving the same file descriptor, and
> manages to call KVM_CREATE_VCPU(0) before the failing thread.
>
> I attach a simplified reproducer.
>
> Paolo
>
> On Wed, Aug 27, 2025 at 10:57=E2=80=AFAM Jiaming Zhang <r772577952@gmail.=
com> wrote:
> >
> > Hello KVM maintainers and developers,
> >
> > We are writing to report a potential bug discovered in the KVM
> > subsystem with our modified syzkaller. The issue is that a
> > KVM_CREATE_VCPU ioctl call can fail with EBADF on a valid VM file
> > descriptor.
> >
> > The attached C program (repro.c) sets up a high-concurrency
> > environment by forking multiple processes, each running the test logic
> > in a loop. In the core test function (syz_func), it sequentially
> > creates two VMs and then attempts to create one VCPU for each.
> > Intermittently, one of the two KVM_CREATE_VCPU calls fails, returning
> > -1 and setting errno to 9 (EBADF).
> >
> > The VM file descriptor (vm_fd1/vm_fd2) passed to KVM_CREATE_VCPU was
> > just successfully returned by a KVM_CREATE_VM ioctl within the same
> > thread. An EBADF error in this context is unexpected. In addition, the
> > threading model of test code ensures that the creation and use of
> > these file descriptors happen sequentially within a single thread,
> > ruling out a user-space race condition where another thread could have
> > closed the file descriptor prematurely.
> >
> > This issue was first found on v6.1.147 (commit
> > 3594f306da129190de25938b823f353ef7f9e322), and is still reproducible
> > on the latest version (v6.17-rc3, commit
> > 1b237f190eb3d36f52dffe07a40b5eb210280e00).
> >
> > Other environmental information:
> > - Architecture: x86_64
> > - Distribution: Ubuntu 22.04
> >
> > The complete C code that triggers this issue and the .config file used
> > for Linux Kernel v6.1.147 and v6.17-rc3 compilation are attached.
> >
> > Thank you for your time and for your incredible work on KVM. We hope
> > this report is helpful. Please let me know if any further information
> > is required.
> >
> > Best regards,
> > Jiaming Zhang

