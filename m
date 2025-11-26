Return-Path: <kvm+bounces-64663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C81EC8A13A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 14:42:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D39F83AFA0E
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 13:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB77316915;
	Wed, 26 Nov 2025 13:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zwmer1qX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BB531DD97
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 13:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764164525; cv=none; b=Vs3Dre97+U9jqQScLKJ2nF1tfr8m2Kwq1R3uFD001v8UNpV/Eliv5CFiwr4+qoH2vaqx9W+6dV3UICXQkPkpaqpSI5dwxZDtXNVMhplIYQqJ8tCNwldpp3tOfIH1bs2UJEUXzTe5t62XYktg+J2kSdPXoAlTaAfSloGcXcQCee4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764164525; c=relaxed/simple;
	bh=Yu94GZno9rV0tcqXvRpi31LC93AOQQi8lcsIxgVQN1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nbqLsLjrIL5mR0dmuVuVFXNo1W3VNTaqQcr1tmcZR7DsG81jZwjOjDt3c3e2B+62xvSb3b7QG+wYzAnAENKyszY7fup+GGMHHyLqaBIuhlfQvxq3I9RTb1Gr6dqwfr+g9tMS/SMfdKZ3LztaQQlu85JYMwlW9AO2hYFwqJLn2b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zwmer1qX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3437f0760daso14790626a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 05:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764164523; x=1764769323; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hi7pYVwY94FRC9osXq/z4z/CUVsDJubPaw0GvUGSXyM=;
        b=zwmer1qXxxud7CHrft8xUGxeIvE9DfX3o8m7DPTG1QtjUtD6ARVyggOW75m8o2ZGRz
         QjTTKWFopvsHJ+WKdp/rtYwcv6EBiNJAvV/+CDnWPrJDnOqREtAMKF7FVRhCMWvoXwFE
         xnzZFB3ISxd82OCIsLFoEQ+7nOGziSZlmKvmGEray7Pbjv86oBtyYlcMJPHJVDs3HtXm
         SM628olkkrQ9yqMQ/jElXeG0oWI5pI4LXSTpt01z1jVaqBoHd4qO44bDTpiOAms8it2H
         rMELZ+3VeQu9GANc2G5bejaRoazqqd1N/7ANcKx4eXey2gcGIFWiw2vV61ooDf5tDgPq
         C4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764164523; x=1764769323;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hi7pYVwY94FRC9osXq/z4z/CUVsDJubPaw0GvUGSXyM=;
        b=thRiwFRZ9l+gtAVDvzx3ZqpPThw11g53F6AQPLmwWi0+YBguU0giQPmKyrX1TToZ7A
         2MhVh0xx4kDXZAOOr30MPZ1GMht5W+A3A0JMiTQMN9IOzi7qdz/dgSzMyohCK9v/LADk
         iiMdAr0uhW5tq//JsrTbuxz3vvPXVNxH19pCT+QPVKqHKa0fxXCFrL2A8Iq6XOQrGfDv
         etn/7AQePuZPWo9XyFjyN8Db834FKNwElvV8cf/O1LtT4Knuf39uAvhhHj/DjyNvxi6J
         2FwAfsf280U4pNM5/rlABQM8RVp4UnlCFcNZQageLp/SavOKKp2rBKpMsdXD2koF0H31
         Xslw==
X-Gm-Message-State: AOJu0YwX5oRnnXHwSAhndGrDVYt7fcx+Bn5G2wl/eXxCX1AIOfN5ajV2
	bsQcrUrjEcNskPbqOrsA4czChDRZlJDBgPKlkXicr0Ro9ETlzPP+YXo9gnCemrG7Q5ICYUdf+eD
	BknMRHQ==
X-Google-Smtp-Source: AGHT+IGs8Sar/JTWmmANWx2dsWeSKEBetRk0lKEtzZZxdcHE3TgWw8IDsf3Vs1YNSJYpBVta6YPRhNuCEPE=
X-Received: from pjblt24.prod.google.com ([2002:a17:90b:3558:b0:340:b14b:de78])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3502:b0:32e:a5ae:d00
 with SMTP id 98e67ed59e1d1-34733e72350mr18844586a91.13.1764164523417; Wed, 26
 Nov 2025 05:42:03 -0800 (PST)
Date: Wed, 26 Nov 2025 05:42:00 -0800
In-Reply-To: <CABgObfbvYC9mGL8x1JSQwmq7BT9j7gwf11nmHsumOumd4P0abg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-9-seanjc@google.com>
 <CABgObfbvYC9mGL8x1JSQwmq7BT9j7gwf11nmHsumOumd4P0abg@mail.gmail.com>
Message-ID: <aScDqIjHMGHJBQ7M@google.com>
Subject: Re: [GIT PULL] KVM: x86: VMX changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025, Paolo Bonzini wrote:
> On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > The highlight is EPTP construction cleanup that's worthwhile on its own=
, but
> > is also a step toward eliding the EPT flushes that KVM does on pCPU mig=
ration,
> > which are especially costly when running nested:
> >
> > https://lore.kernel.org/all/aJKW9gTeyh0-pvcg@google.com
> >
> > The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df5=
6787:
> >
> >   Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.19
> >
> > for you to fetch changes up to dfd1572a64c90770a2bddfab9bbb69932217b1da=
:
> >
> >   KVM: VMX: Make loaded_vmcs_clear() static in vmx.c (2025-11-11 07:41:=
16 -0800)
>=20
> Pulled; there was another minor conflict due to the introduction of
> kvm_request_l1tf_flush_l1d().

Shoot, sorry, forgot about that one (obviously).

