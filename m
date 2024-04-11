Return-Path: <kvm+bounces-14244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9A48A13C6
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 13:59:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E64032898AC
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 11:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8590214AD0E;
	Thu, 11 Apr 2024 11:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W73w90zT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2FC149DFF
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 11:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712836775; cv=none; b=G9ELKo+s+o910ANBUQB4aJJskVaqEIkuGuxgo9J5pDwg516azDmnE/03OqOvvMhc8LUO5XnvGEAwwbC6se9OzWhF9UojpvwP9Bs7BzyFGNeDd4INR/HgXHLItsgRAGeh3Djrq25r9ie9YljmkwJItBJ2LDEkj5Ao3MOASWfleq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712836775; c=relaxed/simple;
	bh=mX3sidVSjS2bnQNT6WmHnJpo+VRqF9Eia8CNXy9wZKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QxvZSW5HIdyAJOXQqLTBLuXGA5F65ziE4uNhVhsJljZbk/FM+X5u8b2V9R3BM490csshB3Plv+fmbSQ/5dVCCNxytd9Y/9BNpPBOls4xPjGQ947izn9bPv/w8dGwDvXfTok1Tq0JSbHTrDaJNDnCharTn/BRwVRxlrK5MZUT3U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W73w90zT; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56e47843cc7so5249305a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 04:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712836772; x=1713441572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/d6rzWM3RKzS8a1pTpO5jIX42wetHh6wJ1iYR9ZIqe8=;
        b=W73w90zTdsDvcUmEBoWG/hNJ8A1feBM0uZ5cKYPUPDX4juv4Jf8rfWyZjDVdajZUX4
         sOisyJLS+BujHfoD/ghSOMwCaxfgycnmPNr0/qLag2kUSmvBKhhNBR7X0+mSUsp+z39u
         0tU2IFqQbBVSOojNGqK4sgmX0xsBpyCZpqNJqvDOD2v4CLCcqpaBLFB8shzHY8mklN1V
         LpIoW2YzxLwvK0f+ibVARJU7kae6SDzTnQCv3K+LQvh/37H75LhJ1TW72GAcU9o7KgfY
         Uu8feBdfgyCtsOsoyUfqrZEUIKYgp/DV2djbN+KuSrNDGK3ghRxXCDdLm8uI9YmX4LvV
         xhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712836772; x=1713441572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/d6rzWM3RKzS8a1pTpO5jIX42wetHh6wJ1iYR9ZIqe8=;
        b=D3K9iiInFoejYG9RidsEhoXRr9Kk2qQD5g5ahIunrN/L1nXCvlEK5Om+ZKIhQ2dsQe
         wbrGhOm0KPRDM1rhWzBRwi+VpsvE97pZXUGXYAJ9s0mWnklDhZvufnBLy978rTmllS+g
         Hr4tBq0zSZQR96WBu0lf55yq/Bnnb+nXMKtE8OgoM4qLzg8JXV1BtmqzAWhGyi8eMXjy
         aezt07Z8eNFcdmUeyBU6GRU+h7uFXMh/4yfuHRUE/Gyd0Rd+R9puX1fSDK+Y8O04tFIT
         WCANH0CT8XhD5VPECOUV8G27/mmq2ROzk3FF9vgcxp6uhhGIzuTPYPO3m2/8h8MEwsOt
         xbXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUujo90x24AV10I6SFbAFROWySKHbTe6XqFS7lh5CsIfALRrZKmyIJGUruZLhwhX3KzowOKbwfVm6R+B2OiaHqt9HBr
X-Gm-Message-State: AOJu0YxrPKBKBFyE+UAjIuq4AgzVoDdZL2VV5S8bU5phUgNo1AIhoM0B
	UZhTagPcLkb9yS//P/a65skbmjOaz2BwG+Oer4Er83RZqpsE91GjgKP0feNUIpavlqkhrIqUovi
	bAvY9xlA6ykSExQBes+hENI8LdbHPnI09N50lQg==
X-Google-Smtp-Source: AGHT+IEZBE9CL57fOOXD8ugzG94aVuACdJqyvRZTMYuJSwpOa7Bv87fyLUCo3wLcrD4iUaiGj7OvJ3yAGelTW7TO9iQ=
X-Received: by 2002:a50:a45b:0:b0:56f:daae:7cc1 with SMTP id
 v27-20020a50a45b000000b0056fdaae7cc1mr2385706edb.23.1712836772124; Thu, 11
 Apr 2024 04:59:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411104340.6617-1-philmd@linaro.org> <20240411104340.6617-10-philmd@linaro.org>
In-Reply-To: <20240411104340.6617-10-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 11 Apr 2024 12:59:20 +0100
Message-ID: <CAFEAcA_XHVWAiMZ8iw3xVVjnHs+aoxQB=uUjBQy7EGmSj14U+Q@mail.gmail.com>
Subject: Re: [PATCH 9/9] target/i386: Replace sprintf() by snprintf()
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Apr 2024 at 11:44, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> sprintf() is deprecated on Darwin since macOS 13.0 / XCode 14.1,
> resulting in painful developper experience. Use snprintf() instead.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  target/i386/kvm/kvm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index e68cbe9293..a46d1426bf 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5335,7 +5335,8 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_r=
un *run)
>      case KVM_EXIT_NOTIFY:
>          ctx_invalid =3D !!(run->notify.flags & KVM_NOTIFY_CONTEXT_INVALI=
D);
>          state =3D KVM_STATE(current_accel());
> -        sprintf(str, "Encounter a notify exit with %svalid context in"
> +        snprintf(str, sizeof(str),
> +                     "Encounter a notify exit with %svalid context in"
>                       " guest. There can be possible misbehaves in guest.=
"
>                       " Please have a look.", ctx_invalid ? "in" : "");
>          if (ctx_invalid ||
> --

This is a case where I think we would be better off with
g_strdup_printf():

 * the buffer declaration is a long way away from its use
 * the string is long and it's not trivial to confirm that
   it will fit in the buffer
 * it's quite plausible somebody will come along later to
   clean up the wording of the error message and not notice
   they need to enlarge the buffer
 * it's only for printing a warning, so it's not going to
   be in a hot codepath

thanks
-- PMM

