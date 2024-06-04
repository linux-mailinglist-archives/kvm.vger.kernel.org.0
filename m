Return-Path: <kvm+bounces-18727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0598FAA7D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 08:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E15E1C219F9
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 06:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52A1140396;
	Tue,  4 Jun 2024 06:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMO1xokr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7DA13E3EF;
	Tue,  4 Jun 2024 06:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717481261; cv=none; b=Y5cbp6ZXMVm7iOZwKwO0of5B36SErrY/qazlWNJXp563BgS7QnFWU7iXJs+DKHDaKpmPVo1IVnD/wuOePU2D2en/m7gcnPgPLxWuoBW/Dp2RauATWMIkMIcjURRdAmGjLwRTQdcn4/sotSy+81xvZC2hWUrx26jWS9d9NtellRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717481261; c=relaxed/simple;
	bh=iwbFjTc6NZx/ChktlGyF4zKAy/jsfhbthZdM4AE3Gj4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=EZXLmV6AfHhEgcWJsN8wqVkcjERVTz/Nwm7aA7RtbcySi2NTdUYcjyaGtIix4c314wY+umsmdyWinKnvgy4lfKMypIKalwYQN7O+ozxlFw3WVyfag+Ldi74SNseCccozRcA1Dz13TPHmzg79Y/r/fohlMpvaCUA99yB8hvQHGMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CMO1xokr; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2bfffa3c748so4143710a91.3;
        Mon, 03 Jun 2024 23:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717481259; x=1718086059; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHKS9jT7MB7hE/EEMjAH9yW7M5wSwmZc93mWcC255Cs=;
        b=CMO1xokrMBPY8m5ES6UXrCXC0cIcLFn1h6p00thREyUEcuKBJ/axlnIvn6ORPA+O65
         7kDDffeM1mZD4m8W/inSjiKtGSNMBJRDTbGpSySJFJYD1LF1AiemyAprDjgm5z/z8O+g
         wa1AmVZm8np58nTJZQG4wn8zhHBtKH2liHeXt9UaEq8G7M3AI2JQBlIbWz0UcShhHQ5N
         DlB6EqEErESkOrvOHrYXuWYkyCcgFuyN8+xaNuXxT6klXJ6SOTlouEH4T/RIOgAHZl0G
         Rh29MIiu+WlZ1sgpbf8R0qA0XJac428wQe5P6vttCoikr0KHU4egDROfns6E/E1PxmuL
         oHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717481259; x=1718086059;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KHKS9jT7MB7hE/EEMjAH9yW7M5wSwmZc93mWcC255Cs=;
        b=bL8/WqJt5lla8FYcSwWWxHmKrObz+JCEa2LS9oL31NYkrYwzbzlIxrnJ/oK+KskDwm
         6eVtiASuLTfoHWZFFNYqFyN8DXf3oas2Aa6qF98OShJ9W+lNZcgEzw4vDjY1tIdPjv+P
         CQg00+MTSGXpBGHAOGf96a81hqz/1AKekT7jdZie7K5+5jUdZkvhowJJuz2qah0BUDZD
         OkwzZupI3vBD5wt/Q7paQcLjyvROcqboI95kIeXbwbmKCZkqXCrFVTKYllrkK72Jr+Kq
         FzndgIu/xz7tzVhlK0F8o2t2ZT2g19O/hndCfxAp21itNrQJxNMVVKMXtdpW+4DQCZgE
         znDQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4FK551GKvqLoyLr919WtmaUkO4q9kGff45Jq1a0lzEexa8Qfk5Z6bxKmNG/9z9n547svLoY295Md61MVcUMxZGAzJgR55gOHv/FmR182L6+m/7fkoMpPOH1FDt5159SfSjND/t6zhk9+O2Hoa0zGKoy+bYnhjifGyeCAk
X-Gm-Message-State: AOJu0Yyn942LHViEan8RSpEkqh+H2oMa+Gt2Yyd3qED0dVjQxqEpvwKo
	eFlgBvQ4UyRoxiQ9HHkqpckEEwAen65jQDhYKpcPT8cAK5SJHRgH
X-Google-Smtp-Source: AGHT+IGgduKGfFqGFxTIMZY4kIpEo9UbSeOpJKQ2EBgCxLKHZbKJzMZPFI7lJBVexL750l4Obga0Eg==
X-Received: by 2002:a17:90b:d95:b0:2be:9549:799e with SMTP id 98e67ed59e1d1-2c1dc56db3bmr10075761a91.9.1717481259042;
        Mon, 03 Jun 2024 23:07:39 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c2411633e0sm2535857a91.30.2024.06.03.23.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 23:07:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 16:07:29 +1000
Message-Id: <D1R0AHN2MCOS.BPHUJKSV7YSO@gmail.com>
Cc: <pbonzini@redhat.com>, <naveen.n.rao@linux.ibm.com>,
 <christophe.leroy@csgroup.eu>, <corbet@lwn.net>, <mpe@ellerman.id.au>,
 <namhyung@kernel.org>, <pbonzini@redhat.com>, <jniethe5@gmail.com>,
 <atrajeev@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM: PPC: Book3S HV: Add one-reg interface for
 HASHKEYR register
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Shivaprasad G Bhat" <sbhat@linux.ibm.com>, <kvm@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.17.0
References: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
 <171741330411.6631.10739157625274499060.stgit@linux.ibm.com>
In-Reply-To: <171741330411.6631.10739157625274499060.stgit@linux.ibm.com>

On Mon Jun 3, 2024 at 9:15 PM AEST, Shivaprasad G Bhat wrote:
> The patch adds a one-reg register identifier which can be used to
> read and set the virtual HASHKEYR for the guest during enter/exit
> with KVM_REG_PPC_HASHKEYR. The specific SPR KVM API documentation
> too updated.
>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.rst            |    1 +
>  arch/powerpc/include/uapi/asm/kvm.h       |    1 +
>  arch/powerpc/kvm/book3s_hv.c              |    6 ++++++
>  tools/arch/powerpc/include/uapi/asm/kvm.h |    1 +
>  4 files changed, 9 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 81077c654281..0c22cb4196d8 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2439,6 +2439,7 @@ registers, find a list below:
>    PPC     KVM_REG_PPC_PSSCR               64
>    PPC     KVM_REG_PPC_DEC_EXPIRY          64
>    PPC     KVM_REG_PPC_PTCR                64
> +  PPC     KVM_REG_PPC_HASHKEYR            64

Just looking at the QEMU side of this change made me think... AFAIKS
we need to also set and get and migrate the HASHPKEY SPR.

The hashst/hashchk test cases might be "working" by chance if the SPR
is always zero :/

Thanks,
Nick

