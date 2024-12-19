Return-Path: <kvm+bounces-34157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B8D9F7CF7
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 15:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 280801885E14
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 14:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C6D225780;
	Thu, 19 Dec 2024 14:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gWPBM449"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283012248AC
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734617909; cv=none; b=oIw3JxhR8syvvOaEDdpB4qFBmhhKxScH+n6/3HSI86n8REmlEI0Pjsr3FODTOD1hLmUw4Usoyw2j163iJWiw3Nw1ToLMWsmJLET0qXR/ZCxWQGRxCFW6O4vj46lrYFi4uJw2AYEKeF/iB0BLL7+VyTUMn+xE3MYaDl+RamyQkPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734617909; c=relaxed/simple;
	bh=vLG9kPuoHx0+xQ58zNt7HXrIyxPOrmcG7sCl0c6udvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n0EhqO1Txm2VeU4K0GJKW1eWaDIS7plIPkVS4WxKXhjMvG77u7Q4I180mQJQ74RmsoELUnvIZ7zUF8pJtxHiwg8cz/CzIQulz7qID1rL9c55c5TotmVFMi83hP8c8vB8mXEwh+Q4Qc9P+vhHHOIIlN6ttu0mpop5783ZsUsGIRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gWPBM449; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734617905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uw0WyIzdNdoj9sLuog5bBO4sTY/gkZIaesJXP2inpks=;
	b=gWPBM4490yBstSoC5Yurm3dlpBZqN2NRhctKQW+LOr5zgvv4gOT+lFwoGdr12/Zu3bPSoA
	W69CnMi3DUa1LKhcddlvMUQuFVVaCzIhM2eudpJKWDysx9vtXRAZT8k2wfgAyDhWfwnyh+
	IDfL7yaxB5htCbFOT2IdDSj9pbja3qE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-xk-gUNLaMUaFS2tL_2KHgg-1; Thu, 19 Dec 2024 09:18:23 -0500
X-MC-Unique: xk-gUNLaMUaFS2tL_2KHgg-1
X-Mimecast-MFC-AGG-ID: xk-gUNLaMUaFS2tL_2KHgg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43610eba55bso6920525e9.3
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 06:18:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734617902; x=1735222702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uw0WyIzdNdoj9sLuog5bBO4sTY/gkZIaesJXP2inpks=;
        b=nkkErJ9UcfhQ0jTYUWxqEg/OJXpTS7/s8hEhkuMbgLym8mMZNSlAGSRDsKijBuVIJs
         mgSiUoh3jaWMI3XgSTuKA+S2AYOXj/atrst3QAB2XGnpVtV8NCZhO5fhVR8iRgyp3wr2
         ZDz9d5k9aKc+BIltnPI2I0mWZu9Z8uIQXUlONEZQ0pMoJUF8F/k05jFPtQt6hZhVuFKJ
         C1/95vhCv9blSGvU0YRNIJbp8fiLS5tqItGbAj1eNL9kbhFXkCRHEwbBYCb9zjm5Ua9J
         Td6cJcsodaKxSg73kUBZG2d2vb7rTWiZsx3Q3hFNZzzUGTgwd1j09ynox+eiYbjzUkqg
         f7mA==
X-Gm-Message-State: AOJu0YydZYhZlReHk2JRIAnxN7IAe3UnpTtPU2iemRKEbeGRH/cxj0Kg
	Rw5+wYO+0W8Bh6pVa0XzJO3re+y7pEwMDAPXkGwKcGK4CO1kWVXSrnGqw3xiqgCruqsZyT2Xt6j
	pqPIPOgelR3sUIGHGS2yXN0kxGOduvcazFwMB/Q0weVCorZixvOgp6LBRrH+TlH+e8uSAk3Oor3
	nTGy8yBXfppkuUWtJZCNdAH1Y8
X-Gm-Gg: ASbGncsdQANU9VmWXqP499N/w4gSgxAeUQ6FOgpmr+x+QIV2iJaGSRA1FkITXUMj8Ol
	o5cqkeBnjp7bQESZktM1iL/HBt439XU+whBEsGA==
X-Received: by 2002:a05:6000:4b0b:b0:385:fae2:f443 with SMTP id ffacd0b85a97d-388e4d64ac2mr6523973f8f.34.1734617902469;
        Thu, 19 Dec 2024 06:18:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGAB8xzYbjB08n9ion0b6l9CsTZBnILubONXdCn7TaDUN/pvPp/Ayod3SWyvEZ0EdHCsCtZ+K1GhBErF3cT1Rg=
X-Received: by 2002:a05:6000:4b0b:b0:385:fae2:f443 with SMTP id
 ffacd0b85a97d-388e4d64ac2mr6523942f8f.34.1734617902089; Thu, 19 Dec 2024
 06:18:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241009150455.1057573-1-seanjc@google.com> <173438868282.2574820.3350549298279234722.b4-ty@google.com>
In-Reply-To: <173438868282.2574820.3350549298279234722.b4-ty@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 19 Dec 2024 15:18:10 +0100
Message-ID: <CABgObfad2=y7RckXsQY6TVQF21qVgk0gJ-M-nUz+eQiPCN_Kiw@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM: Fix bugs in vCPUs xarray usage
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Alexander Potapenko <glider@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024 at 3:44=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, 09 Oct 2024 08:04:49 -0700, Sean Christopherson wrote:
> > This series stems from Will's observation[*] that kvm_vm_ioctl_create_v=
cpu()'s
> > handling of xa_store() failure when inserting into vcpu_array is techni=
cally
> > broken, although in practice it's impossible for xa_store() to fail.
> >
> > After much back and forth and staring, I realized that commit afb2acb2e=
3a3
> > ("KVM: Fix vcpu_array[0] races") papered over underlying bugs in
> > kvm_get_vcpu() and kvm_for_each_vcpu().  The core problem is that KVM
> > allowed other tasks to see vCPU0 while online_vcpus=3D=3D0, and thus tr=
ying
> > to gracefully error out of vCPU creation led to use-after-free failures=
.
> >
> > [...]
>
> Applied to kvm-x86 vcpu_array to get coverage in -next, and to force Paol=
o's
> hand :-).
>
> Paolo, I put this in a dedicated branch so that it's easy to toss if you =
want to
> go a different direction for the xarray insertion mess.

Go ahead; we already do more or less the same in
kvm_vm_set_mem_attributes(), so I guess that's just an unavoidable
weirdness of xa_reserve().

Paolo

>
> [1/6] KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()
>       https://github.com/kvm-x86/linux/commit/1e7381f3617d
> [2/6] KVM: Verify there's at least one online vCPU when iterating over al=
l vCPUs
>       https://github.com/kvm-x86/linux/commit/0664dc74e9d0
> [3/6] KVM: Grab vcpu->mutex across installing the vCPU's fd and bumping o=
nline_vcpus
>       https://github.com/kvm-x86/linux/commit/6e2b2358b3ef
> [4/6] Revert "KVM: Fix vcpu_array[0] races"
>       https://github.com/kvm-x86/linux/commit/d0831edcd87e
> [5/6] KVM: Don't BUG() the kernel if xa_insert() fails with -EBUSY
>       https://github.com/kvm-x86/linux/commit/e53dc37f5a06
> [6/6] KVM: Drop hack that "manually" informs lockdep of kvm->lock vs. vcp=
u->mutex
>       https://github.com/kvm-x86/linux/commit/01528db67f28
>
> --
> https://github.com/kvm-x86/linux/tree/next
>


