Return-Path: <kvm+bounces-13386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEAF38959EB
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 18:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1B861C22BB0
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 16:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A7015990A;
	Tue,  2 Apr 2024 16:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4EQPnccd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6366B2AD1E
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 16:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712076194; cv=none; b=PmoaFN3aWLV22FZ/1U1tq5GYujdcSnF03iG4Qiouku19ci5D1jmch3YBvqG4f61lOqGPTdUtZ5xD/ZTp6vnZwb04crzxhM+MYuJ1S/ZX/jMmthEYCrLKvXU6d5bUkOSHsgq7i04RuFU6SfjqQFs/btEyT8wPvwD/Yfi3AVcyzMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712076194; c=relaxed/simple;
	bh=riG1sGW0LAhZ2RlsuiATG4JTDf+SyaueGMxSrJRrTwo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bIHUXw9o/J8eda4AYXxR0lKANV8e+iiBrnzX4uHmBgBT1WGGkUvNGtd+quUexHW6KKxeR+zfmraJZPYtJWLPKLEq1gWN4FFl7Dj4g+89EIkgpaFKCrU2zUoGEoE7W5mP0XvasH5B/cNQZ/iW3VGC0Z+BpWFyoQy9JMPgD1zDno4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4EQPnccd; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a468226e135so651427266b.0
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 09:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712076191; x=1712680991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=riG1sGW0LAhZ2RlsuiATG4JTDf+SyaueGMxSrJRrTwo=;
        b=4EQPnccdnePS8ONTzPgpwY9kN6TGncDigQkBLklg5bJuO8r72K+Ab465zIehaZM1qs
         cd18WSY8zThNDVDuODvUHvnd814wqiUSjEE3x4h6r01824hT1sp+RmBMtNZ9DzusnBLi
         KKUCPLh+HNbbZJxEJtBTakmxq4uawqek0RSmhwtxSlzMSIJmyC9Q9vHwr7/jiYthMXX/
         G3pQx6JME9PZX5vGJd1X96dSOCbiLEc2fsJCM0t8CnlrWawDr9GnC/qNF8xIqrw9yJaI
         7DtubyM2TQo4pw/Lp0Wtq1prPNY3jrKFgAUYfPCDC5VZqhVP1VHsZFZSmumYpu/BBS1t
         XBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712076191; x=1712680991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=riG1sGW0LAhZ2RlsuiATG4JTDf+SyaueGMxSrJRrTwo=;
        b=byxQScNvRvPNruz84brJ3xyqPR8/UNS17eLuR21NcbdfgmPmrabbDdASta4ikSClNl
         4Q665n/H2MQb/6+0EcFnP+f7kuuKeLn54CeEGV+2EVMX1O/yZX4FfsHTcVCWe5dZjy/7
         2+ye3yXijJHmEMiK7evvIKAivFKpHiWxkrP+NRx/Q8bivbOHzdsD+zn4z6JhTZGvY5pO
         0T8EZnaF7wYpjtFzFd7ulwm8RgA0N2uDoFjKdG7b21cVF8kwkUzMpw4xOG2sAX3uueRx
         NMHUtKBthdlnR/vUNJ1QkF+u2mWJcDtPEpiiRdaUuIlYoD+p5+zutpGSrW33K4WGYtM5
         m3Ow==
X-Gm-Message-State: AOJu0YwpwpWyPDKjsxI9Cv+4yWKzlE+q7j/OSi2LpP9b8zfDsMgGNTDJ
	uKiqoyn5nhwW5699xKbXbQ5MFftZcrQtEDFFAsqCdNI/hRqPh/Nwyo9TM74HZSSLZjowNr4B4vp
	Jah8r6cmJ2wQfawswCzmGkJnpDLEWZeSvnUHO
X-Google-Smtp-Source: AGHT+IFaAFs5HfCQcjom/iuntzx5AEiS61s41MUTcAaiM45OQ0E838QGY5JS4c8Zn/0I0+QDR3IMFnsV/Wzl/l7W1JM=
X-Received: by 2002:a17:906:d9cc:b0:a4e:109f:7b4b with SMTP id
 qk12-20020a170906d9cc00b00a4e109f7b4bmr8885798ejb.41.1712076190553; Tue, 02
 Apr 2024 09:43:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205181645.482037-1-dmatlack@google.com> <CALzav=d0w=u3n4CcSWVOv=A-9v+x54aP+KVGBOrZ0=F+R5Yy-A@mail.gmail.com>
In-Reply-To: <CALzav=d0w=u3n4CcSWVOv=A-9v+x54aP+KVGBOrZ0=F+R5Yy-A@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 2 Apr 2024 09:42:44 -0700
Message-ID: <CALzav=dBj3y2P4BvEO4j8_Bzb8NMd7kmJd4O9XF-N9CffNiFdQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 11, 2024 at 8:55=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Tue, Dec 5, 2023 at 10:16=E2=80=AFAM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG to avoi=
d
> > blocking other threads (e.g. vCPUs taking page faults) for too long.
>
> Ping.
>
> KVM architecture maintainers: Do you have any concerns about the
> correctness of this patch? I'm confident dropping the lock is correct
> on x86 and it should be on other architectures as well, but
> confirmation would be helpful.
>
> Thanks.

Ping again. This patch has been sitting since December 5th. Is there
anything I can do to help get it merged?

