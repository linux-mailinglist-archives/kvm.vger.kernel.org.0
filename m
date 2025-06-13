Return-Path: <kvm+bounces-49406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7514AD8A6B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 13:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4AE73A8F6B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 11:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FD42D8767;
	Fri, 13 Jun 2025 11:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMRbJ5k9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33FE26B745
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 11:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749813959; cv=none; b=hynh0d3UPDU0wFgpIcpKwu2T7pZU5Df/r5MdZtBIZ8IOEMa9YzFrtkwfxSlEWTBJlljezpkMDA/0YsZo6qGOwiihvAEfgvm6tNadJVrI7LABZ8j3URcLns5Voga6QWHjib1Ped3g3a98UTCNegewdEhqiGuSEBitJ7Z6pwn+krE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749813959; c=relaxed/simple;
	bh=pk9HppbaBEfEzasCa8/FcOZZbSVG39tJMmN6FNqxJZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V5UXwjmulW4tNKmc0lzCq4NcKVZ1i1IKvWCb+KIrFcY2rV2Hij1Ut9prQNm21E5H7/4DaPD8G0VqwkUp3nMDOAyz5gh/KzdTQjyqGOfrkNP1fbh450Fn+V2FuqHToBkHCc2HiOS2PfwuV5tC9pwN1raPp4evoGYA3o5nBb/MEto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SMRbJ5k9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749813956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OtTPCernLeO8trjul5Ba7rf8xkqDU8wN6cWgKdmxGDA=;
	b=SMRbJ5k9gv2cAaHFvqzEMTj2J24LBF2D0bXgNkSHwLeGQUom2jNuPxdPd4MjUnQX0755cZ
	xTV+9IIaYLsZt2kf+RngyLWlIGGA9l6NRqwOuYM+AhaBHGt9PLuRRz+j0KXrD3IZ1QVyYr
	U2yNcWgcZcAYqJRK/q+ffkGAJEJHTi0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-yrr2wCCtPyC_v87Airc2jQ-1; Fri, 13 Jun 2025 07:25:55 -0400
X-MC-Unique: yrr2wCCtPyC_v87Airc2jQ-1
X-Mimecast-MFC-AGG-ID: yrr2wCCtPyC_v87Airc2jQ_1749813954
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f7f1b932so1297371f8f.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 04:25:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749813954; x=1750418754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OtTPCernLeO8trjul5Ba7rf8xkqDU8wN6cWgKdmxGDA=;
        b=ctEnt2kue9/dKFwxLZDx33iPfz7PU2WnD7NVrFiyyUYqF8kYETr9ZrDvUtU+VSHvgn
         bBzb2+znCeHSlFzGXOLI65Fv4TW5K5HkOiv0hf+I9WPXaQFNWmEPqCSHfsdPrlTOFQHS
         cnNLx+MwoXfGTyDjDQxLgQgh0bSzoFy2NAJqviQos6arKpzzWMWyUZdkQRzGRJRYe4qT
         Trd4iWuI/0liwTYDNc9JAMu41vj2Hqf4j6SlKkiaVYD0zooIbckDL9ToUi76uS9paJbZ
         XN9thwvPIDq2OkxVRwSbXf7XTtgi97b1LzrHZO/mHTPMqjx1roUqM/nlz4hvj0CjiaK5
         U5PQ==
X-Gm-Message-State: AOJu0YxjHKgHPcjC1CNXQDErb9BF0MDIgbeg2pWYY66uLnShnI0nfFIg
	k0SBJJrCMN/G77Rz3B9vZSn6LTPPoOJYxmEH85e01Pl2ZAlNlLGytx5PZRQHZLhUCEA9xydgmF0
	zGWqQqlJIkkayvnUtvHPYi/Vt0aj0gXJYbFX1qCXLltI/nOZdKN3PRhbtT9Y0sTxDW5rEEmeW2F
	HRXWvOabS0E7jqUpssobXgPXSgTGp/
X-Gm-Gg: ASbGncv/2c4tVICcsp9I5v0lujm70XKMaZrixpMTzyV5csLLV70gL4kuUE/SxQecCNg
	LHwDB72M732KZID1lqXNTJ2Vs26TZJ6p2G50/Khes5PNYVZwV6Br/JrizeFlKDOOsM0vmwqVXfE
	ilBA==
X-Received: by 2002:a05:6000:2088:b0:3a5:287b:da02 with SMTP id ffacd0b85a97d-3a56876b131mr2099558f8f.40.1749813953761;
        Fri, 13 Jun 2025 04:25:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMld/3x4YDwMh90w2NXyk+VWJ9yeQ982c+CE56+xJI0QCBv9oJAuu33eFBBEhkpIF8/oIrlYNLdizJLcDlXXg=
X-Received: by 2002:a05:6000:2088:b0:3a5:287b:da02 with SMTP id
 ffacd0b85a97d-3a56876b131mr2099541f8f.40.1749813953402; Fri, 13 Jun 2025
 04:25:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613111023.786265-1-abinashsinghlalotra@gmail.com>
In-Reply-To: <20250613111023.786265-1-abinashsinghlalotra@gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 13 Jun 2025 13:25:35 +0200
X-Gm-Features: AX0GCFsG0Z1jia4q1FPk20VzM1smi77t2aAcOYaXOXqRREflDaqyTL_Wz5tjY4E
Message-ID: <CABgObfbGXpEWtfYNYsEhEANNaR+1to1U-O0s5h1bBsY-u2384g@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: x86: Dynamically allocate bitmap to fix
 -Wframe-larger-than error
To: avinashlalotra <abinashlalotra@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, vkuznets@redhat.com, 
	seanjc@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	avinashlalotra <abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2025 at 1:11=E2=80=AFPM avinashlalotra <abinashlalotra@gmai=
l.com> wrote:
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 24f0318c50d7..78bb8d58fe94 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2005,7 +2005,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, =
struct kvm_hv_hcall *hc)
>         struct kvm *kvm =3D vcpu->kvm;
>         struct hv_tlb_flush_ex flush_ex;
>         struct hv_tlb_flush flush;
> -       DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
> +       unsigned long *vcpu_mask;

The default KVM_MAX_VCPUS is 1024, which is not too bad; you're
probably compiling with CONFIG_MAXSMP and accepting the default limit
of 4096. Adding an allocation for every hypercall is not great, I'd
rather add it to struct kvm_vcpu_arch* instead.

If instead we go for having the allocation, you can use this:

unsigned long *vcpu_mask __free(bitmap) =3D NULL;

and avoid changing the returns to gotos everywhere else.

Paolo


