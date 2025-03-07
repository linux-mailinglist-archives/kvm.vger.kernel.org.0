Return-Path: <kvm+bounces-40316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF08FA562C2
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 09:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFE1D16AA70
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72431C8637;
	Fri,  7 Mar 2025 08:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R47plaJA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150CC1C861C
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 08:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741336934; cv=none; b=V6g7edvGFmIgJeH2broZGuIgLo4KdHdfqWlCkdqpoEp1da4snNdQeKcqdcyCWCtBz4RZTIBwGrLRzB9wnx7eU7IcmbtanMc716FyQgUh6ZgJ9K92vbkx42UVqP4t/FJC2QrbC0VuIZfvIX+v/E9HwBOhGowL+PK5kqzqVmAyqA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741336934; c=relaxed/simple;
	bh=p+NVUiFSYjN8axbaY9ze5DTO4F9jB5QKK7NNqeO4vOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fu1Dk8WZt6BgLPcs7reAEC0AofA2KRe2K+lXaDnXi/L9fYxRS54OsMeohB3FGI0lhhPwzSZkp1S8sY4HKxYQ22uSLb9xtmWN6o7rN8aWRn+icUJgy9FN43fruQFCM7i7pOux7j3HAfZqQSgAmU+thP+ai6biOJNgWRXYVvDwaiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R47plaJA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741336931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l8faWtD+xJ1942m4oDwtKpTnc6C+l89fRhpPKTFDxTI=;
	b=R47plaJA8LNqKmqmCxXSI7A98DxRc1HzBIGb7ws+wDnrfzhyFvPHFkD+CNQNyYt1UejseD
	/pITRjfuNG9haePO42FnG2/RRSWE3aeh8DCNhljv47fqjA3brfE+otO73hkVODPpQvZtKv
	L/idQiv/eZP59ggNG1vIXQjbQ4VVyac=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-3P31iXpzPv2umueTGeorYg-1; Fri, 07 Mar 2025 03:42:07 -0500
X-MC-Unique: 3P31iXpzPv2umueTGeorYg-1
X-Mimecast-MFC-AGG-ID: 3P31iXpzPv2umueTGeorYg_1741336927
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3912aab7a36so635401f8f.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 00:42:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741336926; x=1741941726;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l8faWtD+xJ1942m4oDwtKpTnc6C+l89fRhpPKTFDxTI=;
        b=BTwil7R0r+1pz+pzTir2sQhpXQin0ELuQVbnggrHDgR+K0cxR6dhmiOwnA/RX7TEud
         PzyDOwyty6WqWAsYNjTUDOJV270ydoC0CHj3OLErbF8PZmgFf2iegHJv6Jng14YN/YK6
         b6GukzOJgCrK3f8pHNW3Y3oTmootIz5cS/gahGH8Uoh+jP9QLsRbwfaVj/Waqb9wT3WK
         qsJFJxXe1TFju+sYB3B+fk5NGKsQbKTlCSraqTsYaTihwT3sXbbaEAYqX72RS9gUY620
         8QvUTRwtML/NZF0IXDNXd7fxe4ZalPv/IPhp7Uprjw4quj/r5fsV+SaYbX1O/PnML8VW
         Rzkw==
X-Forwarded-Encrypted: i=1; AJvYcCX1AQ6nbhUKgJ1GnwLn21hs4sVs9DfDxRpqhwRZ6b9+miyWpl2D5KFY3ornuuXmACxF8jI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp3ntPL77tKwUYDsiiO/RdkNnge65Hup8v+eW9QMh0BAhIcRI/
	cbR0bcJRnsckt+oh83d5bGRO+GglyG3HluTLSRJaBC58jOFKNCTtwdZ5H29Rz5+ioGofTz9uwau
	Xf355Gjudy8CEx2F3HhFg9Bf4ik2Z1boYXAsLKBA8Ub+yjIDVow==
X-Gm-Gg: ASbGnctlyBm/KDB6oyMp9Q9GgKG03DCo1IBFimlvHZ6wfav3IMROhl/VyTz/6NBOCN1
	u8KkmHRbZjSIF7ZBqOZoXuBNke5ttqz/3PmRf8hDtoJEqJSN/oE0yK/IRFIOdiGG1xCmaIcYuLG
	tGnjy57ZYrVPY99+xwwBBeOitsz4xC7VWA0cZEIAmXi93rl+Eun3d1b5lBCoIV2k4ne6dYlsmab
	opHnPakKyycTlKxARJe93CPsmv95IkDlFC4hTPXMX0pLSMcizk8DkCKbiBy3c/BR7iv49DEnabF
	iA9Bk2IiGepzTiaFxicCbE5KF5K0Ioo4re8SxY3nM5E12As=
X-Received: by 2002:a5d:64c3:0:b0:391:31c8:ba58 with SMTP id ffacd0b85a97d-39132d16dd6mr1491123f8f.10.1741336926631;
        Fri, 07 Mar 2025 00:42:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFEvTfkOOstDpIQCVNVrNI5tXKqN/Unz1X0joyz13KAcVi+91nu9TMSHHsyDlvACic/Oa9C5w==
X-Received: by 2002:a5d:64c3:0:b0:391:31c8:ba58 with SMTP id ffacd0b85a97d-39132d16dd6mr1491095f8f.10.1741336926296;
        Fri, 07 Mar 2025 00:42:06 -0800 (PST)
Received: from [192.168.0.7] (ip-109-42-51-231.web.vodafone.de. [109.42.51.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfba679sm4602122f8f.8.2025.03.07.00.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 00:42:05 -0800 (PST)
Message-ID: <2c0bd772-0132-4053-bd22-aac88a8dcfee@redhat.com>
Date: Fri, 7 Mar 2025 09:42:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] Makefile: Use CFLAGS in cc-option
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
 lvivier@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 nrb@linux.ibm.com
References: <20250307083952.40999-2-andrew.jones@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250307083952.40999-2-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/03/2025 09.39, Andrew Jones wrote:
> When cross compiling with clang we need to specify the target in
> CFLAGS and cc-option will fail to recognize target-specific options
> without it. Add CFLAGS to the CC invocation in cc-option.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 78352fced9d4..9dc5d2234e2a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -21,7 +21,7 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
>   
>   # cc-option
>   # Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> -cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> +cc-option = $(shell if $(CC) $(CFLAGS) -Werror $(1) -S -o /dev/null -xc /dev/null \
>                 > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
>   
>   libcflat := lib/libcflat.a

Reviewed-by: Thomas Huth <thuth@redhat.com>


