Return-Path: <kvm+bounces-11525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4165877D28
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:45:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DF0528206E
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BF822F07;
	Mon, 11 Mar 2024 09:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MW96k5cQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B98D22064;
	Mon, 11 Mar 2024 09:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710150308; cv=none; b=Hp0Qqv4aqOHczjFCTHS6fm/Pt8qgkrMfhm8Ge1S+Bd7IYr9N+gRHcYlxBvlAzTNnGFQndI7si+uoWwuTzinD7wGZgocyeFzuFQJOzi2l2nScCMmdJgm17bZ8NcSAFsPxyPbi+y8xQxu1jLA0PeG8vljI4NPtVGKga4KzPzoidHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710150308; c=relaxed/simple;
	bh=z2OHh73biGOQOvhh94EAmWFrnkKV7sHA8EvKeyoKAQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q09Zsg0SbA/0/g3rCNp1knPwwSIxahmjLvU24oKwVjpk5Btb9GyAvSPKHNky3v71uGZZogC/NhSD/2qGwoqOhaigMhFHXbdT8XUf5EIm/LBYRlTpRTWRByawnyBMVYMqhs0QB5NRoCPj9SFepyNyZEL7Efmvdv0Yl8QzkNdQ8q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MW96k5cQ; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-dcbef31a9dbso2568960276.1;
        Mon, 11 Mar 2024 02:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710150306; x=1710755106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvdlHR4piVNF+K4lqhyTa6DmBRyDbU95ZsTEoaJ4pfE=;
        b=MW96k5cQO6FchHjM3ymZJ8UE4UxPrigjdxLFv1wSSBuZ3+2qWtKEJM1CUdS6kuwauD
         ZZO6VHc6aiS//6ZVixVPUTyg+iwLGyLPSziQxg3vfKny/Vxar6tR/YhVaw3VS8ykrSs1
         A5rmLuK+wAoF0+zyDlGavpMipIHBgUq6HZOpOC1mV9oMcir68tKb7Shet1/IOT+iwCS1
         qde9Xg66Msf5TCEnDJnhv+4+ZAMHzPIN7NvugMjrKyXO4Rv0dpdrDAhTu3dwPmEXsERT
         0KtfFrKHte/F8zNHQKCx0OI6AklLTNZ5v4V9a3+u8uK5tc8IGyhfl7cb8pmW6zsjtHGZ
         WBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710150306; x=1710755106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvdlHR4piVNF+K4lqhyTa6DmBRyDbU95ZsTEoaJ4pfE=;
        b=JeeApmiynVaTMXGdjIajhSzWSXUFWV0egbl7I1V6cVI03deJdinajzchHV+Y5491Zx
         jRgF1Cn42MyuDArVwcDlPcngVIy4NGUusUPG9R+18eymc+7lVbnTt6kETGrj0/EnaqtB
         xNoGjDbiovhfzZdSvRvGsCZY73azqcMqX7JQx9mD2KBMvcd8tHR9of/JNSv2opPlvzas
         Ai+GbV7nT1v7P26DMOCPk6fQnjT5J6UhzxiCpW2SodYn/wn8sQvfimjohWkUZ3JCMfzq
         9W0/clV4lOpzim5p7jCIKYUWpy3bSpawWm7AXzoyvBI6ejJ+y9lUI7zS1B1WonleCSeO
         v8WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWh5o4ZzxYGKqNy03MvUwqDhEeYmlXC5ADyhbI052Khp+l95UIBZs9fFOWjBCeqXgnnxDuc7MzHSOIXCoYAtJRww/34rw+xxPDAmpdvAGGskZJRQtwXWYCYmGHkXqgFzZSy
X-Gm-Message-State: AOJu0Yw2WYXRxfCl1gp/5/5sn4zfKwaT4U0dbYxVgA5/y+GoqXEy3eKO
	rhF1BZDkNS8rukwB/3EIaTl6qWlX/Z0d8eMD0QgwMj3OenloJcNtyiszsMLQD1f8Uk1V51euqO1
	9iT2E7IIAUhA3NqRTN+yAuu7jVXo=
X-Google-Smtp-Source: AGHT+IHXIvx9RtkZLKht8FNNH7tbt3HWIRTA9GpzWuRcxx9B9FRiKw0n8LPKOHkooxk86b6kiylzZFRxZvCNmkyIyYc=
X-Received: by 2002:a05:6902:50a:b0:dcd:128:ff3b with SMTP id
 x10-20020a056902050a00b00dcd0128ff3bmr3061831ybs.38.1710150306234; Mon, 11
 Mar 2024 02:45:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229065313.1871095-1-foxywang@tencent.com>
 <20240229065313.1871095-2-foxywang@tencent.com> <ddc5e199-ef8c-4ce9-8fb0-4f6227fded2d@intel.com>
In-Reply-To: <ddc5e199-ef8c-4ce9-8fb0-4f6227fded2d@intel.com>
From: Yi Wang <up2wing@gmail.com>
Date: Mon, 11 Mar 2024 17:44:55 +0800
Message-ID: <CAN35MuR+E4-2xKkVjffqEjdZ1NOMnrdpmck+LT6_i2EjCzO_rg@mail.gmail.com>
Subject: Re: [RESEND v3 1/3] KVM: setup empty irq routing when create vm
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "atishp@atishpatra.org" <atishp@atishpatra.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, 
	"foxywang@tencent.com" <foxywang@tencent.com>, "bp@alien8.de" <bp@alien8.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>, 
	"anup@brainfault.org" <anup@brainfault.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"wanpengli@tencent.com" <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 8, 2024 at 12:06=E2=80=AFPM Yang, Weijiang <weijiang.yang@intel=
.com> wrote:
>
> On 2/29/2024 2:53 PM, Yi Wang wrote:
> > From: Yi Wang <foxywang@tencent.com>

> > +
> > +int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm)
> > +{
> > +     struct kvm_irq_routing_table *new;
> > +     u32 i, j;
> > +
> > +     new =3D kzalloc(struct_size(new, map, 1), GFP_KERNEL_ACCOUNT);
> > +     if (!new)
> > +             return -ENOMEM;
> > +
> > +     new->nr_rt_entries =3D 1;
> > +     for (i =3D 0; i < KVM_NR_IRQCHIPS; i++)
> > +             for (j =3D 0; j < KVM_IRQCHIP_NUM_PINS; j++)
> > +                     new->chip[i][j] =3D -1;
>
> Maybe it looks nicer by:
> size =3D sizeof(int) * KVM_NR_IRQCHIPS *KVM_IRQCHIP_NUM_PINS;
> memset(new->chip, -1, size);
>

It seems better, I'll update this patch. Thx a lot!

> > +
> > +     RCU_INIT_POINTER(kvm->irq_routing, new);
> > +
> > +     return 0;

>


---
Best wishes
Yi Wang

