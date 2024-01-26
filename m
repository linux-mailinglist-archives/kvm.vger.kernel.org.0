Return-Path: <kvm+bounces-7195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B032983E1DB
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 664721F287A4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50FF321A06;
	Fri, 26 Jan 2024 18:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ERBLH5Pi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7874210F3
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 18:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706294631; cv=none; b=ZPnu95yMsx+SeTo7cb7lUKqxoQP5G7DTi//kqT396GgB1J/gwKB+v54Iyn1VVsZlGIIiZeHRwknMO1pmYBFyTFwzyAZc6KRfBlDOpJJqEcUrlGG0CA6jPLLC/AyyPy3xgUCt3hel93GCKqbxf6exhH2LOZoIBQBt9xDITVh1HbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706294631; c=relaxed/simple;
	bh=GTDjsu6rhEo2jOBPARRAChZuzZfYp4I5irbMSymKoVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ClcYs+YcRRdEJ3utCvh7FdRt1JcX71GyDWhflcLx13U9VL8NIUAUcRXoabXQN3xfvb/BNj009Vv0DehiHwJXBk1YbOcwGiD6njluqlnScbn6mPqLW8KI6xDSHiBanMPWuVkCHbTDK5u0FpUVApjgU8mVIF8nUzwerzrIPOLaxOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ERBLH5Pi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706294628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gjr2qXp3L4j2942eOUz5zFFxnCl3RL5KDAtLwwiTpOk=;
	b=ERBLH5PidWzOKeZLne6FfGYhK1MxOkr+Gs5JHflrlnAd5ETYjYI0hjL1LOoSkKTuZbZeD0
	ZkumvE0Z/lPPmG5Kh/msXTslX/OOiqKgOIfjx4HejWv5QUUKlWpQjr1N+4W2wSYW2iH8FZ
	dI3UNUfhFq0Yg1aqTSC9HiIqkp7aDDg=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-HDDMhHfKPquJRhgGSd7TCw-1; Fri, 26 Jan 2024 13:43:46 -0500
X-MC-Unique: HDDMhHfKPquJRhgGSd7TCw-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-467b0b7f260so194632137.3
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 10:43:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706294626; x=1706899426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gjr2qXp3L4j2942eOUz5zFFxnCl3RL5KDAtLwwiTpOk=;
        b=cM7KGyR/fVlo2Rlz60izH8ZEdfmT1ZLzyc5md5+dGIynb/060F/y6diuvromBZ4JvZ
         /xpE9G6gipLtx01thRPWl1VoAKC7DrFAvMyByYlfG7u5fw0QzspxMhYmXavUxUyH0m5C
         JLDOKOocAbFi2Lc85b7xvaJfA/8IbUqn9CmyF3G1iQKcJM30oSPEOpMxIEctAqlU8KJA
         vIZCdd2Y2cO5QVKAi6bp+gZCkPGP9U3GY1v5sfm7xRuSujXDnMKplsMs2hrMr/Y/N4IX
         MIkFurfw9cFLqvaueIoyYeXghOkH0UxX8M+m/3KfF7d4b0GxwbrAMdbrLQFVViXbGmVY
         hPAQ==
X-Gm-Message-State: AOJu0Yyh1zipLHBz3nmmxOr2a9IRig067udSVZwCRzZEeUSYTNV/FSGT
	EZsuxs6ESSDPqarnq8FEuKz8QOWtkOrgrorm7lzWbm8hDmf4EPJz33ub3+TS0bwGBWLCIqDzKQR
	/u7ChTELS4ZNtsNLrH31FC6p4Ls6nmprS3fXNuDklMhqmIOs0seY76+Ajj8XgBUDYOp27j6JXDG
	ZVbCs/eOAHSqeTE2uAn1SbN1i+
X-Received: by 2002:a05:6102:2929:b0:46b:2484:706 with SMTP id cz41-20020a056102292900b0046b24840706mr291426vsb.1.1706294626197;
        Fri, 26 Jan 2024 10:43:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFeiYnaGwaRTPw/BuT1W1AJZWARSelaRPkVdIBhgQa1W/zS8FnDAO3yU8hld1a5HB0rBdrk+7Re9sseBLVfHU8=
X-Received: by 2002:a05:6102:2929:b0:46b:2484:706 with SMTP id
 cz41-20020a056102292900b0046b24840706mr291419vsb.1.1706294625961; Fri, 26 Jan
 2024 10:43:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124130317.495519-1-kirill.shutemov@linux.intel.com>
In-Reply-To: <20240124130317.495519-1-kirill.shutemov@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Jan 2024 19:43:34 +0100
Message-ID: <CABgObfbQ72PQ5u06cOeowjzWqiQmWNn83xOWGE12R363dWOK_g@mail.gmail.com>
Subject: Re: [PATCH, RESEND] x86/sev: Fix SEV check in sev_map_percpu_data()
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 2:09=E2=80=AFPM Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> The function sev_map_percpu_data() checks if it is running on an SEV
> platform by checking the CC_ATTR_GUEST_MEM_ENCRYPT attribute. However,
> this attribute is also defined for TDX.
>
> To avoid false positives, add a cc_vendor check.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Fixes: 4d96f9109109 ("x86/sev: Replace occurrences of sev_active() with c=
c_platform_has()")
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Acked-by: David Rientjes <rientjes@google.com>

Queued, with "x86/kvm in the subject".

Paolo

> ---

>  arch/x86/kernel/kvm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index dfe9945b9bec..428ee74002e1 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -434,7 +434,8 @@ static void __init sev_map_percpu_data(void)
>  {
>         int cpu;
>
> -       if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
> +       if (cc_vendor !=3D CC_VENDOR_AMD ||
> +           !cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
>                 return;
>
>         for_each_possible_cpu(cpu) {
> --
> 2.43.0
>


