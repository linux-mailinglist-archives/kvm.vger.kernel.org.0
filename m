Return-Path: <kvm+bounces-63431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B683C668EB
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 9AC8D2988B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 23:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97953090E8;
	Mon, 17 Nov 2025 23:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bDBEnV1v";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0+qvAsY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CB716D9C2
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 23:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763422421; cv=none; b=SFe0GK28rszGzaR/i+Wl4ojU0u0EvD75VB6pVJsB0fb6C/YSTHgCW+vmGAxTY1kh02UBJyafOQjYOMibnK8gI9bz9RXBJNjmBoYESLKGruesy1iFAVaw3jXI+EkOM5ujSMkAQ4OpTyIMaMQBd8wO1+/J67QxHrc/YHVvT2i15aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763422421; c=relaxed/simple;
	bh=fCV+MIravNPiFakCDvEWNy0tcox/CryPOQTio8ybjZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uzRNdlUlhKAa0QOMOB/Nt6MtsWxxRtZ0jLcPaXwRg9VWZPADrl9tkU/xjo0GNp9yRwRtGOX8zuil1YHujn/ZhGcWe0W/Pe9DmB45bXTpFqq9z2VnSx5TEBLRCLJ4DoGYZxegk7OrwqmmguTDLuhBmiHGm7WkEtR5nYMDEYhB8GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bDBEnV1v; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0+qvAsY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763422418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DTmPCWP5yUG6kt1lSRM5JqSWIVqSKscA3TRQG2EFuec=;
	b=bDBEnV1vq526PioMN7dHDA0DYBeMRfBytPgxO4JB2VV1Tsswtt7ajlYKnrRgD0q6mwBIg6
	t2fEvEcyHlZ7BjD6WcTxtEqbTShRNunDwgdZ0C8faewBYFqhiAdFG3wmXO2Olmtuy8qXBP
	O9bETZxG+AelXzWDlYU8srP63LJ/4Fs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-cOva8WDCNhyqlJ9QdKbL7w-1; Mon, 17 Nov 2025 18:33:36 -0500
X-MC-Unique: cOva8WDCNhyqlJ9QdKbL7w-1
X-Mimecast-MFC-AGG-ID: cOva8WDCNhyqlJ9QdKbL7w_1763422415
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b2ffe9335so5352689f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 15:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763422415; x=1764027215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DTmPCWP5yUG6kt1lSRM5JqSWIVqSKscA3TRQG2EFuec=;
        b=W0+qvAsYITYLsvS8E8ekwmN8Kt/lE5h1hQmvzJaH3y2adN/x7GrE5NW0fG/ddsFeFv
         oOzrcnZUMlbep2J2eJeJFgsMpliQcEDwI60jR5SK1ai7xj304oIJWv/8uYtIgKp0hInK
         J3wslmeJvNXtLh4ePZTifhZEe1oL1vVEw7kxds6uH98AmOtH/AF3K/u8wDdqWehOROhS
         FQbfRC5I57rF2zJgrptLdgUyPuVnWPs0EGylNzfa/Pgcb9rHTLH9lgcuy1S6TqO7CRn/
         0O5JGiYJ1vgZXI4Ptrl5nYlzNAzsXKBVTL40p+zty0BjNjHQSOxkli1q+4Sf8wXO344h
         UvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763422415; x=1764027215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DTmPCWP5yUG6kt1lSRM5JqSWIVqSKscA3TRQG2EFuec=;
        b=JOxPvtybn5w5T3lQwit0L3l5i4EZXtkt2/z52jfCJase0ZFQ1IDaaU1nr6B16sei6Z
         Cm3zY4rIFzA1TNlPAV3+lX8UK3oNAPVOq3LED/54k1zZeZymjLJXyq7xHryo4rDA2hgX
         RTQA0KZtStyYE7DSl3Yo8yLnCZme9dbpMbVlOg8eKIn8XIpOPDkSVMiXCOZ9/VOjVyNH
         jR3HjNDBsd3e27T3nVTCx+d0UOaR+7oUOZ8LHab2nhnjj2N9E4c5l88BaYO0hrTmjPj5
         P7gHiciwrAPh2buQkwJDh9IOHFe4x7LvmHY5mBqgEWo340lMXGPpFP6lTohm8E9RVo/U
         Rd1Q==
X-Gm-Message-State: AOJu0YwWwafeyuTVXWiWRBXH8ipr6jee3uzLyTVhl1nfRVEPRafavCcD
	hb7zZUhYKEeP4ckH7mfxB6viQ7ovr37eQ787xh4QSzj9W7uNe/PBiI3WfRAQ736mGC8vY8K4HSP
	2kbw59NWxW8zeVxq6pOoaUwG6r7Qnk6jp5hpspiz5zQior1BZIcSMVF1D0vTo5TsZYtkcKcA+Vo
	Nwmm/XT2todoUNyEaRMSpyI40OEhcF
X-Gm-Gg: ASbGncthM9CaDO8gbz9DgSoGvd38rms8WvcFYcch07MqvAV0ttUXdi27cX9FqInYOpY
	qfTN1XPlfmtOsIavjs6ZHQTCB+jUqFvBOhWhmqH+Ex+tmFv/WxyNcZtqtAy2spcIrxzMvQ7DSeO
	FvhTl2J3J922oIzwVD7LKdDhCkhYTauo1k8Ggidv6lH7iCc4HSv9rg31kMIUa8gpmiPxNS769g2
	LGYFvEYhNPBTskG8NYrwnfd2QYD+aVZ8EZoZivLhsPhmaY70dshv9tdmQkX/b/kxle0sR4=
X-Received: by 2002:a05:6000:616:b0:42b:483f:da8b with SMTP id ffacd0b85a97d-42b5934b2c8mr14759345f8f.25.1763422415453;
        Mon, 17 Nov 2025 15:33:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEgvslnctD2U8vA8ojf7TmLw21OP9/9/xmd+6CayAR0TnqhEB2EVhpZQGFD9kbAQILEh1Ei7Zcowbj5JFaBaEQ=
X-Received: by 2002:a05:6000:616:b0:42b:483f:da8b with SMTP id
 ffacd0b85a97d-42b5934b2c8mr14759333f8f.25.1763422415105; Mon, 17 Nov 2025
 15:33:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-17-chang.seok.bae@intel.com> <6a093929-5e35-485a-934c-e0913d14ac14@redhat.com>
 <25c8c533-73a3-4cc1-9fbf-4301b2155f11@intel.com> <a4058352-2628-45d6-86d6-92ac1eef4cad@intel.com>
In-Reply-To: <a4058352-2628-45d6-86d6-92ac1eef4cad@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 18 Nov 2025 00:33:23 +0100
X-Gm-Features: AWmQ_bniz2NO3dTEBO0HP5wM74EVYeKGF2exiFaiE_Agih7iEQ94P1JnZ7P9lU8
Message-ID: <CABgObfYYGTvkYpeyqLSr9JgKMDA_STSff2hXBNchLZuKFU+MMA@mail.gmail.com>
Subject: Re: [PATCH RFC v1 16/20] KVM: x86: Decode REX2 prefix in the emulator
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: kvm <kvm@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	"Gao, Chao" <chao.gao@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Il lun 17 nov 2025, 21:01 Chang S. Bae <chang.seok.bae@intel.com> ha scritt=
o:
>
> While rebasing onto your VEX series, I noticed a couple of missings:
>
>    (1) Jumping directly to the decode path skips the ctxt->op_bytes
>        setup.
>    (2) It also removes the logic that detects the invalid sequence:
>        REX2->REX (unless intentional).
>
> Perhaps it makes sense to simply continue prefix parsing. Then, at
> 'done_prefixes', we can check the M bit next to the W-bit check and jump
> to the two-byte decode path.
>
> I=E2=80=99ve attached a revised diff on top of the VEX series.

Yes, that works for me with one change---after REX2 is processed there
should be a "ctxt->b =3D insn_fetch(u8, ctxt); goto done_prefixes;"
because REX2 is always the last prefix.

This also means that checking "(ctxt->rex_prefix =3D=3D REX2_PREFIX &&
!(ctxt->rex_bits & REX_M))" is unnecessary. Instead the second REX2
prefix's 0xd5 byte can be treated as a No64 opcode and will trigger
#UD. In fact this is what the manual says: "a REX prefix byte (0x4*),
a VEX prefix byte (0xC4 or 0xC5), an EVEX prefix byte (0x62), or
another REX2 prefix byte (0xD5) following a REX2 prefix with REX2.M0 =3D
0 must #UD, because none of those bytes is the opcode of a valid
instruction in legacy map 0 in 64-bit mode".

So all you need to do is add the No64 flag to entries 0x40...0x4F of
the opcode_table, and then "goto done_prefixes" will cover that
sentence nicely.

Paolo


