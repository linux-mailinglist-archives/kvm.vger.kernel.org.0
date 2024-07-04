Return-Path: <kvm+bounces-20950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A80F927363
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 11:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B8C91C21891
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 09:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E181AB526;
	Thu,  4 Jul 2024 09:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h9P6Iyti"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F7D1A38CD
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 09:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720086831; cv=none; b=A1M0XXiPIBdnlen4O8gWsWh+PFrskh/stDy0l0OjOB0h4VWSWf0gtFOgsmYZFxY8L6zAGJcICmOTg8uQS7DZ54XEuF10MPp3Fnozp2jqtofMqBPA64jBRCzNjdYL54gMzRkq2ZSVJpujIJyUSvi+DYgaLwAqJ5Km6bTPpkr8i5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720086831; c=relaxed/simple;
	bh=lFwN7klfV1Gn22BHhOWAcF3G8RTqVRfrRyy/Zhidv18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o1aZoeg9DnWhhsnQwo6IK6CNBk4/mO6xD4OeH6SgsJeQvlm5XljE4OMoihVfA8ZZsIZYIQq0TU7CQvk/vglSyw+YV60K4m3mZqkvGALta0V0C1QbxAFqxjMQEnK7KzNO0Jwiaauqp4wcUB0lq4Q85CyLI7k227qkornGY4JCLbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h9P6Iyti; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720086828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lFwN7klfV1Gn22BHhOWAcF3G8RTqVRfrRyy/Zhidv18=;
	b=h9P6Iytix334XkhNL3KCcefqDO55Om1CFgp6aGKVmu7+gLXZT68MGBiSKwr28AhHdybkDe
	mE4Qrbr/2LmqXvpv3ft142bVXVZPMOpQM2CQLW4bpuxrdyEa6i9bB9Uj9WwsXjBq+T50sG
	EdiRvKWusCy2EsYBR6iVSUqhH4xgLCM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-DKd6yuc-P6KvxwCTsD-kTg-1; Thu, 04 Jul 2024 05:53:46 -0400
X-MC-Unique: DKd6yuc-P6KvxwCTsD-kTg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-367987e6ebcso398399f8f.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 02:53:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720086825; x=1720691625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFwN7klfV1Gn22BHhOWAcF3G8RTqVRfrRyy/Zhidv18=;
        b=lfvX9I2GTBLvbtkcxY39ec/Hk/u1y9MyMGUDrLRQtyBX26jHw9mxlSct+EqM3pM3q3
         DWcdL/vDEMpsWHwGStygnv8X8VedRtG6UajqjzlofCwCPe+RHxLk5vMr0Dsw7jPnWD1a
         rOWknC7oMCdThyx6UCMuiHEkflSCbgfVpJsW5FpGeDzKQYqmAPKBWj4wEejGes12lBFh
         2s+hIfAmgIsGSVIfQFORN8TXH8PUP4RFtnwlFGC2cTCm6qOGxzZ6pEgiKa3EdK93q5jS
         ffQMPfBbynBFqKnZMN3ClKEwLF2NnxNOrDbPkrOkDMJT4MgbfXB8ACXaPmUzKn/3e0/u
         rITQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgbAvwwva9wxtmz6wXy+/fxcZFF8pUwBEFXARxr0MkGfrNQMMN0J8A2WecvNFK8GgC5KcoL2tmpUHk5y3722GCVfY8
X-Gm-Message-State: AOJu0Yyq1EkVwZWMHs5ICuKZQFCLMGplA2G+lbX7EKBrDyEaTAyd+RRZ
	GvFg/ma6Zz+yZiTy9qE1+Cv2AEaFwAsH7zKuE2vFEQ5OtfiK7309w9AiuBWqFRJGY5ua1SVan2M
	o7TT0jOuEeKFVtnnxkXOawhkoS4Kjeh3Sy3+bRO4mXPZezrHOAuY1msWjR/bXgMt1UM1m6tn9AC
	ZfUtLrD5nGrDcpQah1Tboou5zr
X-Received: by 2002:adf:ebc2:0:b0:367:434f:ca9a with SMTP id ffacd0b85a97d-3679db85af9mr960885f8f.0.1720086825209;
        Thu, 04 Jul 2024 02:53:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGY/HpM9wSh0ELdFeoqqhrzd44QPH6iJElBQT1rrcFoxhPiV2knLIShRKH29kicVZVdZYH5dBG47G/Xy7K8q4U=
X-Received: by 2002:adf:ebc2:0:b0:367:434f:ca9a with SMTP id
 ffacd0b85a97d-3679db85af9mr960872f8f.0.1720086824853; Thu, 04 Jul 2024
 02:53:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240704000019.3928862-1-michael.roth@amd.com>
 <CABgObfYX+nDnQSW5xyT3SjYbQ72--EW5buCkUuG_Z_JPFqfQNA@mail.gmail.com>
 <ZoZge_2UT_yRJE56@redhat.com> <CABgObfbf1u_RvRTcoZFepFWdavFnkqNwUCwHm1nE4tNKmM8+pA@mail.gmail.com>
 <ZoZtxUPdDmnFaya6@redhat.com>
In-Reply-To: <ZoZtxUPdDmnFaya6@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 4 Jul 2024 11:53:33 +0200
Message-ID: <CABgObfZwmvpHE-cadR1yu_a4pftid9=N7X50HBfeCYokLge6-g@mail.gmail.com>
Subject: Re: [PATCH] i386/sev: Don't allow automatic fallback to legacy KVM_SEV*_INIT
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 11:39=E2=80=AFAM Daniel P. Berrang=C3=A9 <berrange@r=
edhat.com> wrote:
> > The debug_swap parameter simply could not be enabled in the old API
> > without breaking measurements. The new API *is the fix* to allow using
> > it (though QEMU doesn't have the option plumbed in yet). There is no
> > extensibility.
> >
> > Enabling debug_swap by default is also a thorny problem; it cannot be
> > enabled by default because not all CPUs support it, and also we'd have
> > the same problem that we cannot enable debug_swap on new machine types
> > without requiring a new kernel. Tying the default to the -cpu model
> > would work but it is confusing.
>
> Presumably we can tie it to '-cpu host' without much problem, and
> then just leave it as an opt-in feature flag for named CPU models.

'-cpu host' for SEV-SNP is also problematic, since CPUID is part of
the measurement. It's okay for starting guests in a quick and dirty
manner, but it cannot be used if measurement is in use.

It's weird to have "-cpu" provide the default for "-object", since
-object is created much earlier than CPUs. But then "-cpu" itself is
weird because it's a kind of "factory" for future objects. Maybe we
should redo the same exercise I did to streamline machine
initialization, this time focusing on -cpu/-machine/-accel, to
understand the various phases and where sev-{,snp-}guest
initialization fits.

> > I think it's reasonable if the fix is displayed right into the error
> > message. It's only needed for SEV-ES though, SEV can use the old and
> > new APIs interchangeably.
>
> FYI currently it is proposed to unconditionally force set legacy-vm-type=
=3Dtrue
> in libvirt, so QEMU guests would *never* use the new ioctl, to fix what w=
e
> consider to be a QEMU / kernel guest ABI regression.

Ok, so it's probably best to apply both this and your patch for now.
Later debug-swap can be enabled and will automatically disable
legacy-vm-type if the user left it to the default.

If you want to test this combo and send a pull request (either to me
or to Richard), that would help because I'm mostly away for a few
days.

Paolo


