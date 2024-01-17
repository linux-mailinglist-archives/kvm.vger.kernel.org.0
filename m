Return-Path: <kvm+bounces-6364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8519882FE15
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D27328A57F
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 00:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C00179EE;
	Wed, 17 Jan 2024 00:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gpq6a7hR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667407493;
	Wed, 17 Jan 2024 00:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705452422; cv=none; b=Eb2NPvxdxDxp6KG6GjVjpqav3hTYzox1VkR5GU1KWblK9ofZ2bggb25EKO3scFNqEUYpgiIYl/hRg/Pra2IGchb/mkDZyFwF4jh8NkFJedPhHbFBtyAMSPV3Vqjt4viVjAxA+kU15SOAsPKRCePONBhU2LZJbr1ruPTJH593RqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705452422; c=relaxed/simple;
	bh=X9InlawFstBGxNScZTHkILj/mXtio6Yl4UfO0dHueu4=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=fh/QTbW4NHehQaDB5eXbW8DzYLbFiHpiBwc/zAi2F4sVY1bo6pT4QTm3dH8pLawAdzFxXKzR/cGxpMcEz0N/aNjPaZMGRLuNNDokntr7QEzauog/Aj12dt8AZuYZiDbhIufkv2c79S0w4ExfNVb+XI00hmUE39MwC/CXlsIHdLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gpq6a7hR; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-db3fa47c2f7so8768080276.0;
        Tue, 16 Jan 2024 16:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705452420; x=1706057220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9InlawFstBGxNScZTHkILj/mXtio6Yl4UfO0dHueu4=;
        b=gpq6a7hR9WGiBRE/p+rqQqYbiOSOQ0J5th/r5IPsIyA5FRWcFyS7vgrCNWcgtKol1/
         V5BDHUcfS6PQKIN/1GjXKtIW5TYfvDO0h9ndpmuotsKN6+v7HnZU/tIXRo4dFuPlW7ki
         bU5HelT1yLRpSb1hcXIGyzPlYBqwZyesFuAZB+W3spylyKYVx6v/kTzFfB1dXV6j6V59
         zhhteSVzEZt2tTuRP6UZDkDFzRFw+bLVodd7yr+wlQGcC5eXVpysOE9OtckH2a5fPs7u
         4HvziCbwb4PbvEUOYCNvxjWrPJPW38zJv2RNA62AjFqHNOacovacS/hFqFR4b2eQYe8y
         AOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705452420; x=1706057220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9InlawFstBGxNScZTHkILj/mXtio6Yl4UfO0dHueu4=;
        b=lO9kqxHznQnCsMRrx3Z1gBWZ9d2NkX1PPZo3rKUMVE3HW6EagnsAa8V2q63t8VGd2p
         8IjH5G4Uw0J2h8tumYA2NBAfYyY/shKOytH429TolfMwt6asQhVJ82RstdxbRbVOfzm8
         qbUU6/x+o3KjuaA5+7F1chHKsxIjpDg5YAbzmtXgFKySKvyrboVylEHuL2Rol2qUm3JZ
         3gqx4UwvI/I2v3pgiYP0yuFlpmm3smo3mCtqkCmnuxJPBslSXy6D2p10/Oty50rflBQz
         74xUFl6I3JpTunlPAx6UlzNqQ4O9lfcgq29JSdWfpkE4bFJIbcjqRWnwQbeOw6tU7sqL
         8uPw==
X-Gm-Message-State: AOJu0YwvFxBr9dn6MC7q2SKqJGtA/gCLMsbYJIxVAb0ENGRCcQQIeXZh
	Q8KLExe5TsEvO30kY+0hRoidRDtX+vbYVXLhPnM=
X-Google-Smtp-Source: AGHT+IHasD2VICwcJnewF3FZn++RvMvk9+/28DJTYBgl/i5H2vkxSLI7WTuDY778nK6zGKQ2is+V4DrZRbgFczBi0f8=
X-Received: by 2002:a25:4686:0:b0:dbc:bff8:5228 with SMTP id
 t128-20020a254686000000b00dbcbff85228mr4438870yba.31.1705452420251; Tue, 16
 Jan 2024 16:47:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240112091128.3868059-1-foxywang@tencent.com>
 <ZaFor2Lvdm4O2NWa@google.com> <CAN35MuSkQf0XmBZ5ZXGhcpUCGD-kKoyTv9G7ya4QVD1xiqOxLg@mail.gmail.com>
 <72edaedc-50d7-415e-9c45-f17ffe0c1c23@linux.ibm.com>
In-Reply-To: <72edaedc-50d7-415e-9c45-f17ffe0c1c23@linux.ibm.com>
From: Yi Wang <up2wing@gmail.com>
Date: Wed, 17 Jan 2024 08:46:49 +0800
Message-ID: <CAN35MuTOWYvboZtk_dQXEQ_+vDEO+ao9pzxLSkJj3x8RboAsSw@mail.gmail.com>
Subject: Re: [PATCH] KVM: irqchip: synchronize srcu only if needed
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	wanpengli@tencent.com, Yi Wang <foxywang@tencent.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 12:50=E2=80=AFAM Christian Borntraeger
<borntraeger@linux.ibm.com> wrote:
>
>
>
> Am 15.01.24 um 17:01 schrieb Yi Wang:
> > Many thanks for your such kind and detailed reply, Sean!
> >

....

> >>
> >> So instead of special casing x86, what if we instead have KVM setup an=
 empty
> >> IRQ routing table during kvm_create_vm(), and then avoid this mess ent=
irely?
> >> That way x86 and s390 no longer need to set empty/dummy routing when c=
reating
> >> an IRQCHIP, and the worst case scenario of userspace misusing an ioctl=
() is no
> >> longer a NULL pointer deref.
>
> Sounds like a good idea. This should also speedup guest creation on s390 =
since
> it would avoid one syncronize_irq.
> >
> > To setup an empty IRQ routing table during kvm_create_vm() sounds a goo=
d idea,
> > at this time vCPU have not been created and kvm->lock is held so skippi=
ng
> > synchronization is safe here.
> >
> > However, there is one drawback, if vmm wants to emulate irqchip
> > itself, e.g. qemu
> > with command line '-machine kernel-irqchip=3Doff' may not need irqchip
> > in kernel. How
> > do we handle this issue?
>
> I would be fine with wasted memory. The only question is does it have a f=
unctional
> impact or can we simply ignore the dummy routing.
>

Thanks for your reply, I will update the patch.


--=20
---
Best wishes
Yi Wang

