Return-Path: <kvm+bounces-6746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A7E839E93
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B9D81F27A24
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB5C1FAE;
	Wed, 24 Jan 2024 02:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HowgVxr5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42321841;
	Wed, 24 Jan 2024 02:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706062337; cv=none; b=FWEm2iuVTkgzbUSBpFvmoy/cYgx+428g4S2t30eumz5d5x9w/IQi6vIUUntC434tBdl6OII+BWvvuZlXnOv5EpAKh/ImkfVQ4GvgPdqQzC78B2fnukxyhP3CuMEKSBAzEZCmGxqtAgKzHhqCmPBviWc1TYS1yL6QVBUcZjSrqWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706062337; c=relaxed/simple;
	bh=+noc2+uSy6VReg2VCfZFuy2Sz/9+swXstnlgtSSnyBU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uVBO/PB8xOgHTzExWI6w49Tf8YWHfBxeyz3WEE6ll2FteP9Y3ak8G1Gp/amuyBumf9vN7jdGZOtV2QTtATk630NnlUjUS3YoX1tsAc9/uiJok6kWsT2J8ABRMogULUlQ0BpxieZIIqjP/QOQB3VJ5BOGiIl9YJOXPyrNJD87+Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HowgVxr5; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-60036bfdbfeso15179567b3.3;
        Tue, 23 Jan 2024 18:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706062334; x=1706667134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+noc2+uSy6VReg2VCfZFuy2Sz/9+swXstnlgtSSnyBU=;
        b=HowgVxr5tklpFJRKNJXSk4phh0soXJ+Btp6JVtU2tcaozWNLv61NFENlJx1aauApkm
         hSmWEUVQzrd7ADR2bVImMN3MytQMUKaHgUZdX+8wjeO6HsH29/V6vf71iqrbqW8e0eVi
         CtNINVMGajkkL4NRdjfv6HD8rvNCwknfQjhWS3LaSVV4p3YhBJrWp5XmE79V2Y37CVIM
         XaKZxIj0y15qUZxCMtvLezty3oTARcGi7Jp2ndzZxVA4JQlPQS0Pm9j6b+J83eQIJBdY
         kyKhpOC1F/ckc1SxME2Qk0fw/Tqzofml38uVrOhpxk7qBoaTww1b95CexRwuDSWSI1/Y
         FPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706062334; x=1706667134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+noc2+uSy6VReg2VCfZFuy2Sz/9+swXstnlgtSSnyBU=;
        b=IiExojiCAYGyVlMDQb5iuTiEcGqjLzygpLZqdYQww42H/LuS8q9xPFA4cM7MadMBvO
         pUoIOLcBJwUMDMcncYppUsvuCMtE2qkcGDdkLYJJ5QUAvXsSxB3Iii2PYPw7lIgKQ/C3
         WzEZP7lR4SEqhYa1vfdhBlGds9PCGmW52KLsvdQdO6HqxU8qyJgWcn0FBtzryPQV0iMS
         N6g+eElff8PoBnhMNcvqX0YxeIm3OzWo0mSEKb78xECl2s4yBvOL2DuGxMhgso1Q+rfz
         YqjJhXqSWlMzNX7yqPmwnK2gvxTM+S9TNf/ifhtkZ92OCzcKMbEtckKUiOUduMd735N/
         QnHw==
X-Gm-Message-State: AOJu0YzCHsvXvQFcT40LfJL3QizssLBK6kgLyml5uh1+AcPOSePp0Zjo
	NKegqxUvSkfLUn3yAOLmR1zMqbrc1oc5ugpV0M4+B3uz+GSgDEuckvsBbejGQQlKtAjSt5ZurSw
	RigQ28ljSKZdPNEhbIuJhmL4eYtA=
X-Google-Smtp-Source: AGHT+IGKW1PDMQnZ4BPz2wV/i0Wzu8Ia11wLP0fSGupx2u4rWFGfUXjyWtxC097tDViEqY4T4pNMLEa1ay1WWW4sJlA=
X-Received: by 2002:a81:7782:0:b0:5ff:9bb9:5478 with SMTP id
 s124-20020a817782000000b005ff9bb95478mr145075ywc.45.1706062334544; Tue, 23
 Jan 2024 18:12:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121111730.262429-1-foxywang@tencent.com> <20240121111730.262429-2-foxywang@tencent.com>
 <ZbAJzFeRa_6NQznQ@linux.dev>
In-Reply-To: <ZbAJzFeRa_6NQznQ@linux.dev>
From: Yi Wang <up2wing@gmail.com>
Date: Wed, 24 Jan 2024 10:12:03 +0800
Message-ID: <CAN35MuRwrQ3D6TZLsE0a0zKqRajpB9vfonxm9dQX67wSV0i84g@mail.gmail.com>
Subject: Re: [v2 1/4] KVM: irqchip: add setup empty irq routing function
To: Oliver Upton <oliver.upton@linux.dev>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	wanpengli@tencent.com, foxywang@tencent.com, maz@kernel.org, 
	anup@brainfault.org, atishp@atishpatra.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 2:47=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Sun, Jan 21, 2024 at 07:17:27PM +0800, Yi Wang wrote:
> > Add a new function to setup empty irq routing in kvm path, which
> > can be invoded in non-architecture-specific functions. The difference
> > compared to the kvm_setup_empty_irq_routing() is this function just
> > alloc the empty irq routing and does not need synchronize srcu, as
> > we will call it in kvm_create_vm().
> >
> > This patch is a preparatory step for an upcoming patch to avoid
> > delay in KVM_CAP_SPLIT_IRQCHIP ioctl.
>
> Adding a function in a separate patch from its callsites is never
> useful. Please squash this into the second patch.

Thanks for your review and suggestion. I will update this patch ASAP.

>
> --
> Thanks,
> Oliver



--=20
---
Best wishes
Yi Wang

