Return-Path: <kvm+bounces-64495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EE2C84C70
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 12:42:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2FCBB4EA0DB
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3EE31619E;
	Tue, 25 Nov 2025 11:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PgkEP+Ck"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52F92EBB84
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 11:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764070884; cv=none; b=Yak7Qh0eYhVL4LUUA8U6tXJu2H1ZrF7bCo9TlQgm0ATnZOn54RHeWFfNpG3p+KkbtFnAe9x9AzBObaybd9HPomFRE9dUMfvN2zA7uXtFCGH0jdVV4EwlmiO/3jXkfXR/8RZ0DaKTSM8NJHmZnpULgYydj0LOFWtw9oS5oecO6ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764070884; c=relaxed/simple;
	bh=DtI53OXTlRBHZs+wCJngBpbUxe7ettg+pvM+R/v5cdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZFghidxb6mV1aHQrcwTk3TO3XYoZ/ZefxrRlxpI5//YxIbo71gCZNUqgtRVd4k4AJXB43CnsB4+uK17pp4pj0UL2WTSbYRJpdP9WH15NQbDE1lIgIBbaIw2mCyYfSJLiItmDrQ7XFBxfCDbM4LNtF5cgrsTB3KjOlfyf99D63M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PgkEP+Ck; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso2358051a12.0
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 03:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764070880; x=1764675680; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0LTcLhj6ntTCdqIbjV4lT3OOvO84ukZM2W90NMOA1OU=;
        b=PgkEP+Cku/QN+9WB3Bdw3/ZU3/ZOvJCUmYEw+QhR7gmn64D9I1iFesTIPbXYAJ4Cnx
         LezASWIfCsBisMh+3uvEQX00ER31K0+bQMe3ZwqHDkW29cHZ/yvEMiu09g8nFLpVeacf
         N6s+xd+uQMnSYkRQQjkMsZPDbP66xl8Ewtm0gB1Dj1IFFlnG1uv4TWf7RufnvYU4MFZw
         hib13W8ysK11nyVT6pvMw79ECa28ZszKEN1B5D62n/CIat8avar9J/cLcP6HwTOHquyE
         StqZxnjfol1UDWH2AvTmw4vAowkRnFCWyh53zxMufK3rphcfhWy1taSzOSNKG0sHu8mF
         xzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764070880; x=1764675680;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0LTcLhj6ntTCdqIbjV4lT3OOvO84ukZM2W90NMOA1OU=;
        b=NQPFj2UG4RC+jjO3CwG/E5TXWNFgs/7pPnnwYA3TcYp/gjIBfLLGVMqI2aAwXte9X9
         neDJHw1EP7hHjFSa33MCkHxUHVuIHKLJCSctS81CkO2SSaVUKIwJj89svZ4uN3xrwRPN
         D7nmoiHhtU2sha8urKyoqAhNNloAhgxOyEWDe/xl9yYN1KKv70r23cELYYOQ3GI6RKDO
         29QtEOdWlIYEumAsFij3M9F/HFwdicQ4/6RThlMnk5YAZasGzFDlfgV2Wfx+egaYLfgO
         mrqHNkn7TaOUmx7DYiMNUCq2KdyMKiLKpstVFMvvaIFw9+nyNAckPopHCyZwJw7w9Pmr
         48Rw==
X-Forwarded-Encrypted: i=1; AJvYcCW6g7Wx+po1Q5jrq+JUBuYR+rpW1/8c9S6ofhNHyo4R8Fuz861mgm7raBJS0vVEbeLWQ40=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbsDXm7fqeTXriZRzHDtUusAQ2vA4V5wdwZACpUJ8I4y30mFx3
	nyPGnOBOpJ2bhKnJtWhh+Yv4BJCDGyre1XN3+LeuIsIRfdknxoL7D87bFihSJDhPM54=
X-Gm-Gg: ASbGncvbHh/WgUPy7LPshA2eH28Fq8thHYvcPAvjHSE+3tGCvY1jm2wFwsYSJtcVB7u
	L2zKxY/5c4HxSxlr0HYlGuaif1AYF4IlY0+C2D2jVeKtH2/EQZddCVyucnwFEwJnEbAGmsZ3wZS
	/jppv88ZhYKu/KdnNzU6TnS58WzWTmE9tGFWhOFe8X6zZ0f0Rfq6SrgeTsJOL9pQF6O7voHJnfG
	+kqUlFKgxz3zSurRuLeHh1MtudStKtSWppjJW9jIc0/fB5a1qM3UVu859IlzWk4IFOZlrva99Zi
	0szmA3sq/tJMCm+dONCNI1SA42/jdq2cfpMIroHp+0Q9dhQRkQYZLpWOxtheVWcxvaADXDDFrus
	btBSmwihSiAtKRFJUAHNqTwtBavvfxK8W8KdC1hWfFOnItFdKSUowMfXynZ5HPT724lys5Skupt
	Hu+9ROHh9IGbU8lKlZMwd8OrQaLhzRtB9ouKdf
X-Google-Smtp-Source: AGHT+IGlOkF2UtrVncRznNgcRYimG5o2vgswCVg/z9Mqcc7GYmiwJ4ita2QTXSAYMfVYORTtgx4Fow==
X-Received: by 2002:aa7:df0c:0:b0:62f:9091:ff30 with SMTP id 4fb4d7f45d1cf-64539624040mr12540717a12.3.1764070880224;
        Tue, 25 Nov 2025 03:41:20 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-645363ac996sm14690309a12.7.2025.11.25.03.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 03:41:19 -0800 (PST)
Message-ID: <150c4314-dba4-4137-914e-b1aacf69290e@suse.com>
Date: Tue, 25 Nov 2025 13:41:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/11] x86/vmscape: Add cmdline vmscape=on to override
 attack vector controls
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-11-1adad4e69ddc@linux.intel.com>
Content-Language: en-US
From: Nikolay Borisov <nik.borisov@suse.com>
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251119-vmscape-bhb-v4-11-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:20, Pawan Gupta wrote:
> In general, individual mitigation controls can be used to override the
> attack vector controls. But, nothing exists to select BHB clearing
> mitigation for VMSCAPE. The =force option comes close, but with a
> side-effect of also forcibly setting the bug, hence deploying the
> mitigation on unaffected parts too.
> 
> Add a new cmdline option vmscape=on to enable the mitigation based on the
> VMSCAPE variant the CPU is affected by.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

