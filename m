Return-Path: <kvm+bounces-41682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA06A6BFFB
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 348DF7A5D50
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3223722B8CD;
	Fri, 21 Mar 2025 16:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EcKXUvCl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6B2146A68;
	Fri, 21 Mar 2025 16:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574777; cv=none; b=tl9rZBsl8RKmDaRZYVBRmOF80SMXyo9H/Qar1hLmdz+gE3uO7HQ2LVrzMGDMmXfnZ3+igioulY62bPVmbW0keL2i8KBWHHN4DhEIkSW7S04PniAIlsAHJKnW+BhzW8T2KrT6uF0aHqt9i1VD5zjW/jj6oxLbV7TujLKv7+Qs+sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574777; c=relaxed/simple;
	bh=YTLuIXdDI4Phph3SsFA3yeBSpr+Krtyyd6zr0VxeM6M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=qdQN1sB9TyrgsBIuKorRO+w7o+MimYTf/Pe1PIpD1/rkbRTdsoOymlDqtNwPrZKiBflzqE8xHK7Ps+8y3tZ3g52q9jDlhgD4z1tBOB/Iq/XyXfuH0l+u6WBp2rXflv4FtnsMtZFnUWkX/eW3e2NZjeQoFyEP5Ie5Vrc0Vmu0fBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EcKXUvCl; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac2af2f15d1so287422266b.1;
        Fri, 21 Mar 2025 09:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742574774; x=1743179574; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5VtqQllqAlt5z/LSCgNOXSJPwmdjLCJ+X1y58ZO+PPQ=;
        b=EcKXUvClzkkjcj1qzi7qX/GQuGehwUCSnEAQSZSQ4i689huH4sMvwSQEybJdJWjWgx
         iXKWI4u3xBrnfBkc2C7u+EQoofW4rOXdLQm/VNlev8ev9fSw5PVbDbGVg2mY9wx4mwcn
         uDqwXvnh5ZeOYFo7JXeLC9w4YkX1IE47WwDjDRquqskqG4lqkYGSnAM3XWE8GiwQWOiq
         fmWRkkz3gTS+HG0VdoRAn8Kttuk20LWnCjZB4Q7fYjBNPD/s+pK2qOVTbx2Ry0PBzNuO
         rKrOai90mmbP2VGPZWFnZULS98xho8Zrm65HzFQD7VzOE1rC2/QOVnmUV5A/4vIcwm4s
         ncdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742574774; x=1743179574;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5VtqQllqAlt5z/LSCgNOXSJPwmdjLCJ+X1y58ZO+PPQ=;
        b=oU7q5uM6n+ALe3rQmVjXCInenV1TgSq0cQ0us/Mb6Igjs2zNtzaIYPfIGktHt6pPPZ
         Z4lCfp4yuLIj0sKMUyNit7Ihkz2ayq+HGxghbkTdmeyenU9EtYdzvd+dtSBN5bBl4CGi
         FtJOHNua/5rdHGxBxzZG/cEeIBhX7FDnui1ltdlvoD3Rr2Bek31hg+Z+UgCT8e50KpSf
         sDkIpc04u8NbzUGB4O6If9rgwAmB/kIHr/v0ycxX0lh+5+X3f1C8ZoZpzL/9ouSnmQaA
         gDytzsOYyHTA0uHxIar4qt64dBrQ5esc56GskEPbLr+mf+N1CJQKdH29CthecxhAZOkX
         k7Tg==
X-Forwarded-Encrypted: i=1; AJvYcCUhglix1NA4bOWNrEXIK5yLWlwl0PERku7ryJoJxPZHPM4ZKwT1V11DKtGQm3RF5YRX0ag=@vger.kernel.org, AJvYcCX8QpYjPjODdhZeIS60f5uT/nwWNGDCgyYWgwhv7xNic6X/lKa+cHDz6aAkvbXxqL6sQfM0YdK3tlgevran@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa5bu0BhDgdYdhHcIGYktRp3cSYbIX6QVKzpADwrTXy6C+C7MS
	eE4VAc4X/fCeR2CSnq6H91IMXpVKd51jO3R0ZuhHtbjC1+BajCM4
X-Gm-Gg: ASbGncv+PSQGIHVjgd7Jh0prgH6huvESxvNdpwBoimpoQgtNlYbqbP7VcC3z1Ypqtmb
	60lfSUsOMaKkaznl212X1SblDzjqjvg4cvm8TEbMRSxIXu7Ro2NFN0bp3/qwwtCSnjaNvVcFEJt
	lgFT1aWbc/4/hunXaViDvIPHs22dnNfETnc61C3OYmdLS7Fh3XutEEFFYgrX/3h9fxeEuh+RIrJ
	9x2DoTyNT1NgFJDHpsqikXcR3wslqNUoWwxw/XxJhAdXCEqDTB1Rj0s94qyeMcy7ZhyLiRCOPtB
	AomvZVDDFN4W4SSY5iGCABgejJ5i8ZiihYNIi8XTakNMJxnvPjXVp5fmF6IpewgMRGCr+mxc8nX
	ywoJJ9OMsioKzaKTIvdHMcSU=
X-Google-Smtp-Source: AGHT+IFySSYLh9xHP8St5qKBOZs25/rZOQtZkWr9bNMw2ZfLHMspm7dT/CWgLl/qtS2zRpRzwPxntw==
X-Received: by 2002:a17:907:da0c:b0:ac3:f683:c842 with SMTP id a640c23a62f3a-ac3f683c845mr391380466b.42.1742574773426;
        Fri, 21 Mar 2025 09:32:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:dd40:c838:778:348a? ([2001:b07:5d29:f42d:dd40:c838:778:348a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efbd4c54sm174261766b.128.2025.03.21.09.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 09:32:53 -0700 (PDT)
Message-ID: <e5f0ffa362ef8731a61c03882738956bb9f4c13b.camel@gmail.com>
Subject: Re: [RFC v2 02/17] x86/apic: Initialize Secure AVIC APIC backing
 page
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: neeraj.upadhyay@amd.com
Cc: David.Kaplan@amd.com, Santosh.Shukla@amd.com,
 Suravee.Suthikulpanit@amd.com,  Thomas.Lendacky@amd.com,
 Vasant.Hegde@amd.com, bp@alien8.de,  dave.hansen@linux.intel.com,
 hpa@zytor.com, huibo.wang@amd.com,  kirill.shutemov@linux.intel.com,
 kvm@vger.kernel.org,  linux-kernel@vger.kernel.org, mingo@redhat.com,
 naveen.rao@amd.com, nikunj@amd.com,  pbonzini@redhat.com,
 peterz@infradead.org, seanjc@google.com, tglx@linutronix.de,  x86@kernel.org
Date: Fri, 21 Mar 2025 17:32:51 +0100
In-Reply-To: <20250226090525.231882-3-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2025-02-26 at 9:05, Neeraj Upadhyay wrote:
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 82492efc5d94..300bc8f6eb6f 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1504,6 +1504,38 @@ static enum es_result vc_handle_msr(struct
> ghcb *ghcb, struct es_em_ctxt *ctxt)
>  	return ret;
>  }
> =20
> +/*
> + * Register GPA of the Secure AVIC backing page.
> + *
> + * @apic_id: APIC ID of the vCPU. Use -1ULL for the current vCPU
> + *           doing the call.
> + * @gpa    : GPA of the Secure AVIC backing page.
> + */
> +enum es_result savic_register_gpa(u64 apic_id, u64 gpa)
> +{
> +	struct ghcb_state state;
> +	struct es_em_ctxt ctxt;
> +	unsigned long flags;
> +	struct ghcb *ghcb;
> +	int ret =3D 0;

This should be an enum es_result, and there is no need to zero-
initialize it.
The same applies to savic_unregister_gpa() in patch 14.

