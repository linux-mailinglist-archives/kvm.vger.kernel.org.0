Return-Path: <kvm+bounces-32262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ECDD9D4D46
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 13:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1F4DB23C94
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 12:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6F01D7E46;
	Thu, 21 Nov 2024 12:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="FQjlsSis"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C551D319B
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 12:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732193862; cv=none; b=svQY0jPaNDba9WWOLyRHvtcFrZUD4wTPbFtJYe/8Q1Fgix9oJ4vQnJDqhWgDrhuhmpBppF4heOqe/VS+0Im8Oscf0iBzrIB5CgM41kntBqPylbzrJsKtzj9Lo7wzk7LPNpnupKNvkzWXeBj3B+gxVL3Rs7PlIl089+G6IVTfD/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732193862; c=relaxed/simple;
	bh=YP1Gez/zNXfB+57snXSpA5XGWf0MQvllHzjOVmfuYNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SEILKM7fPIv1r3wFf3cq7xjwh7vxqRIIsXhp1eS98WppVVZc6liSts3mhPDz2t0pNvq8ao34btzzgMlDlLujAsrWsm2tidzeq2IqlT4y17pVx8BkY9tsSaI4Bz8bPtcTvdDUDXkAfd9yA7EW/GERlqQ1ev4KSi1NwGYtOpBbUH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=FQjlsSis; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83abe7fc77eso33628639f.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 04:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1732193860; x=1732798660; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YP1Gez/zNXfB+57snXSpA5XGWf0MQvllHzjOVmfuYNY=;
        b=FQjlsSisg/tLxGwtWbBNDzs0eNj4YGDhoXym8n45IOefG+5+dO9o6j5eLZpfyq5e52
         X/P/WVPcXe9IJGBHUjbNv+lPhygDLT6kP+UrOG2BJBkjd0y/pszR2x7AWWabMeVm+jrq
         HSEkzKsMd8S94pDjSNOj9ldvd00EObeX/+TMpPa9KLSmoqV1Q31YTOI7B18hKcKFe4hy
         5PcvwOc+9T2BH/xXfd44/+tZ1IcKXZHUbgi10JdWi8lT2ZJWG+MW3beWHzv1S8fE9k3F
         1+qZiFWFZGnBGfOl5+UFkQsi7ghjMOhUbnmX5dcA4A7Nrg5KFtlgYBzZwu3UJ6Osi5TM
         2zig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732193860; x=1732798660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YP1Gez/zNXfB+57snXSpA5XGWf0MQvllHzjOVmfuYNY=;
        b=PP4k9eOyIuFC+Gjbk1ioDdWP6SLxT8RJs398AARCe8vDxETLCHEXcXHbadfQazw3PX
         10ryI5eKslAvFkH49woPC2reda9BYwPf5GZIfacM1za7ZCKhusn8QXXAMGFOZe9Bi4yC
         DDChM4cuUCbxXIcSJScS8hx1kd79FAKv9CG/HmJg6jy3ZFjU+I8bCOvRI1cCzgYLRgo2
         23UEtyATuV/O+JGDCz4JwfgyJgaQWzvZRP6llq45exNsNirXV4fUiqT/9ZKkbyySLbj7
         FhcdcUWTYsSivxonAf+5vSGaelNXUr5RhIlkBcNouwgsHCH4Ld1lsInTJtgOeyh1QN9M
         x+mw==
X-Forwarded-Encrypted: i=1; AJvYcCVVI3EQH4DorFQMPt2GjY+KLJftKD0FAdcX5z9ORimQ+BipAjBWIyjjsEtnD5UQFx6s6YU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLcyXt8f4qm6slC5X0Bf1KgIpyUfDGZN5DAkMKzPocmGK8nxyP
	Ctyam0AJ48KuBHBca+JrfrTctxpmVlQvJolpSmbdU9f60KVqW8febUJBkU3eN10f3l6SP4TyKUe
	s0kgJFU6YpkamFxrMoGh+KBTTN1PxGVug3ikRlQ==
X-Gm-Gg: ASbGncu7bokuIdqDrL28okUuhu8YPoOsEZtEMGo//1Z4N1UwcUjZqI8ayaumU47jjuE
	b8o4ysZN0nEiv1ibj5DgaWE5Ogdr+LVdy
X-Google-Smtp-Source: AGHT+IEuMAfheTfDdr4+8Y1kED12kvt+khaXLolzlsHEkGdCT5FWGNrCEZ8eDC0cqfJZJ30dpcXdBsCszFTBAkK5hm8=
X-Received: by 2002:a05:6602:1646:b0:83a:f443:875 with SMTP id
 ca18e2360f4ac-83eb60dc727mr748423239f.15.1732193860201; Thu, 21 Nov 2024
 04:57:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zz7vLEbLFXuRSPeo@linux.dev> <CABgObfb+P7xaLqiPBzshMQTfSRg8B7LSYswzipNTk6bzWkbuXA@mail.gmail.com>
In-Reply-To: <CABgObfb+P7xaLqiPBzshMQTfSRg8B7LSYswzipNTk6bzWkbuXA@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 21 Nov 2024 18:27:29 +0530
Message-ID: <CAAhSdy0fwv+0NFM5H3UYFhJf9fwrTTKe1UupHj9me=OhHXfDyw@mail.gmail.com>
Subject: Re: [GIT PULL] First batch of KVM/arm64 fixes for 6.13
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 4:31=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Thu, Nov 21, 2024 at 9:28=E2=80=AFAM Oliver Upton <oliver.upton@linux.=
dev> wrote:
> >
> > Hi Paolo,
> >
> > Had a surprising amount of fixes turn up over the past few days so it i=
s
> > probably best to send the first batch your way. The LPI invalidation an=
d
> > compilation fix are particularly concerning, rest of the details found =
in
> > the tag.
>
> Sure. Anup, if your second PR is ready please send it already.

Done.

Thanks,
Anup

