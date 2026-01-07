Return-Path: <kvm+bounces-67294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4FDD0053C
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 23:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0D8563018304
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 22:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49A92E62B3;
	Wed,  7 Jan 2026 22:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wz28oRNv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ab+ZtrwL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573D423373D
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 22:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767825209; cv=none; b=jg0zc6So0g+0nNvaLBT7LD0dgfpi1mOdFh+7Z/RAqQyioPBSYFaWFMXCxsyDs/q/7hRLRxBS31Q4c5zm6OI8OO1N9G0qVNYFJUHnajnKyPfnPUfMp0OyYYLnUJWK5OeAhvA55aD8vS8LBWS6jLOZ7RS/2MU6q9PCSETeJgiv/sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767825209; c=relaxed/simple;
	bh=nKQQImQ1hZC5gl08Mlnp8GyGft7UUB1mwBlEWEHAg/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cnypn7ExdEhg6WmcU2OB0odRqlk/pe2Z7A+KBZJ9KTznlN1vupdn41L3TC97Vs7lr0HQJQ3YGHGQdIbv/Xfg8mpdWuZAdP9ipN04NFF8fu3iTtXF5LhhcJhcs1xD9HkAtzkja1G6Fnr/lb8O88q7ppENZrc8ADQZ+wJbND5B7Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wz28oRNv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ab+ZtrwL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767825207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YKiv0UN+Y/p0lp7y1aVLPcFYjbDuoHshQ2ZIqZot05Q=;
	b=Wz28oRNv7Tfaji1yD6+9NWC7gjZN1QOXRy9Bfd8VwT5M4XOs8AEbWplZH9nFLtQHmd/xc+
	8CLUwNYafE4QBz3G7tj4ieTsMYn4wVt8o4w4+VSrH4XOR6zk7fePhJA9s/xlqOwDCBcPuk
	BgTq70zNJY68Ejg4WG6Q0aZ92GfUKc0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-IhWbJLJTMpmIzV_FwTU79A-1; Wed, 07 Jan 2026 17:33:25 -0500
X-MC-Unique: IhWbJLJTMpmIzV_FwTU79A-1
X-Mimecast-MFC-AGG-ID: IhWbJLJTMpmIzV_FwTU79A_1767825204
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-432c05971c6so994703f8f.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 14:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767825204; x=1768430004; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKiv0UN+Y/p0lp7y1aVLPcFYjbDuoHshQ2ZIqZot05Q=;
        b=Ab+ZtrwL5eymV8NoWxkQwhIjjnTc6GGSwgC/M62pwAbGL/arJ23wdrN6mGqwdmdRIM
         OFtF6Ou5lamYp+71Ah+HcXERkykjnj07Ng8idOwvRD1SqVDr4AXseDkyIyTiaozLtaZU
         SoPa2K7kK0AFMJBzzKntVjs9LTpAfn9ZO2djTGWrGDTn9qUwia9rVQ9J4sPdB8t/LyGV
         07nA2g+OFpHxT3ns5k5df8tWPFvpwEBPXPkQKj6Ssm9qW3C7wScasesZi9qJo2rs1PSC
         zl7wZ37wvxCQYjekT7iPv0KD3TRR8QUXPXyZYSPBqH1FjupjB2L7B5KV0n0CpVYTrINW
         Is1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767825204; x=1768430004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YKiv0UN+Y/p0lp7y1aVLPcFYjbDuoHshQ2ZIqZot05Q=;
        b=C/stMUbj5TgddxGZWewWUrJqGZ0KtjLpvb3LTHiwjjEzqhMyjmsYc1rKe41Ly5tF3j
         OZPmOwijr4YGCizKMCqs3J6jMXLjGXF9q2W0ts0aPy5dAzgnmU+KuiWxhQ26/kncT8FV
         dnr/WaWMVAqBBaG3IOLjBC59mjvFLt5RpExnbXDsy4MQqMGKdd/f4RcGMZbMUT/FRgFG
         gvRajDbEJOAD1ELkWXogd2WqakrrmjUInOoIBlUy6m4ngxb70CeJi8+jENZSXnrnCaBJ
         mDRQLlI5UUCuAjw3BRGrT+zvmG3V7sO54eH3zNo54qIvMNhnMlAuVmFLn6YJ+fX54Ldm
         ad0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCrhVycZyzIfaM7okGlFSC4B/cEpYO0QoN3olE0IghG4OD68+H0lQOANdNmOy59l2Q/C4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzyt6p8diuxPImCvnFg/gyB4V8n+XHcnvknBmxtJO3jahrTMgCO
	h28Sc1LPPXvINDE7cRvzVm4usf+tVfGPV0hovOZ0hOLSsLDzeGnuVo0QaNx0v3qJ6p+2JRmLjBv
	+wMS5ZTfzDjDBIMd0sPW4bN+XxJU3n4h50nW0uU7kSj/X/bsoaGZMB5IAfKEKrSqwXH0vjuTDBv
	DSb1WNLXmfJKQGHH2hCgYgnU/MwMVu
X-Gm-Gg: AY/fxX4nhQc5M2ngvM1rtVZOLsOn+LcxZoaSrMWIYBLCZsif50tBaScyJBV2knpde1F
	URXbAC/LMjE3RHzk9OrnzZm/ndF/mczeowyzcaRw6Yf7wSCgV8ALBQWKyJuDUflM018jwDrgkLE
	8bZjD2BOCzKiUif7+lvryKGvn+W5ZBEKzFD51lNSQ2EOY9X1vB12GOH3JBkxEY9UYZ5CbDFg43F
	RaWmfR+/wL+vYoWVfrlaiQ7io712oHIVtMfccuPGxS0X7jMvscUMQ1KWPUBCCHp7fTUfQ==
X-Received: by 2002:a5d:5d83:0:b0:432:86de:f396 with SMTP id ffacd0b85a97d-432c3778dbamr4719706f8f.26.1767825204297;
        Wed, 07 Jan 2026 14:33:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIN2Du1SnTyzg+3OHwU4Q86kR8t4orcibSR0LaDUW1yBL0SOLJpnq1WRIlbR5jNipu5lBqW9irEzFt4CIPLS0=
X-Received: by 2002:a5d:5d83:0:b0:432:86de:f396 with SMTP id
 ffacd0b85a97d-432c3778dbamr4719684f8f.26.1767825203946; Wed, 07 Jan 2026
 14:33:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260101090516.316883-2-pbonzini@redhat.com>
 <c79eaf34-766e-4637-aa09-7eebbec26e0d@intel.com>
In-Reply-To: <c79eaf34-766e-4637-aa09-7eebbec26e0d@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 7 Jan 2026 23:33:12 +0100
X-Gm-Features: AQt7F2q_9pEgHsXT2Qg_PuwHAW8sbGhk3udXGcbrhYZaUfOKpfpMhUAIMA8t1t8
Message-ID: <CABgObfZz4hBscKLMhzTK4YMVWPRiUbH9m19qV4a-2DZ9C76XmQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever XFD[i]=1
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	x86@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 1:29=E2=80=AFAM Chang S. Bae <chang.seok.bae@intel.c=
om> wrote:
>
> On 1/1/2026 1:05 AM, Paolo Bonzini wrote:
> >
> > Therefore, XFD can only go out of sync with XSTATE_BV in the above
> > interrupt case, or in similar scenarios involving preemption on
>
> This seems to restate the scenario already described above; I=E2=80=99m n=
ot sure
> whether the repetition is intentional.
>
> > preemptible kernels, and it we can consider it (de facto) part of KVM
>                             ^^^^^
> I assume you meant 'we' here though, you might want to slightly rephrase
> it, given the previous debate:
>
>    https://lore.kernel.org/all/87iko54f42.ffs@tglx/

There are two possible "we"s:

1) the code - in the context of this patch this would be "we force
XSTATE_BV[i] to 0" or "we can be preempted", and I agree it's bad form

2) the community, or the maintainers - this is the case in the commit
message, and I think it's acceptable. While I (Paolo) cannot forcibly
come to your computer and clear XSTATE_BV[i], I certainly can decide
that KVM will do so. :)

> > ABI that KVM_GET_XSAVE returns XSTATE_BV[i]=3D0 for XFD-disabled featur=
es.
>
> On my side, testing on AMX systems, I was able to reproduce the issue
> described and confirm that this patch resolves it:
>
>    Tested-by: Chang S. Bae <chang.seok.bae@intel.com>
>    Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>

Thanks!

Paolo


