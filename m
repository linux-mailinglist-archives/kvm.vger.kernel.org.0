Return-Path: <kvm+bounces-16483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A388BA717
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 08:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAEAD1C220C4
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 06:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B5C13FD7C;
	Fri,  3 May 2024 06:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HesRkNBt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F78F13E8B9
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 06:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714717893; cv=none; b=Kyhb9H+LXeQmq4O1BnoCxVygECNiuea+WgfIoO4Mn3Ao9efinzdCYQ6FfEIsh4KmkQimMzP/YbraPMzpHUI/2PGeYQeMUZeLOa6BWVGOpBaxXwzXXWSsC55Q04xwK01R3UURgy4jfZZUWPCGqSEU/eu+7nmIWvHMbQdypqeJ9J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714717893; c=relaxed/simple;
	bh=/k3xWdMgShjeKINrRFoN+mgMfP7B+8ERCtmBHko8Kwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cNXoUw1rMVCHPBed0nCRMjomn1n6scUd8b6oUZcLLFNyTcTQ2GJVVxXFEMg/80gotMRZUWRgIKYSMWZUdxp5LqG79V1m/TKThLWeNUCGXkel7UsHsA8iFEVVCY0OsJeItWROiliPyzNwS2Ey7+jVpCmUeTfVc1N9dZYwuKVyoGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HesRkNBt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714717890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ru7a1UJMZGiekMzJlOvjyZbD1x5iZtjKj61gAnG8XH4=;
	b=HesRkNBtcFX91AffTqwMt52h4z1PJvCzPNAbqWcNX13p7Xu5NG/AI613lJxZJvhTp1j8YA
	a+vpoAj6fOE7twb1VKCaD9f6nkVBveqUDKiPGgbB+8yDHc+UnAsPwqWIrs+D104Lb0yL+6
	ZFyi6aSEBQz/7fL/1HtqcDxvOf/DO98=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-or83uDTjMcGQCd_EXjvIwQ-1; Fri, 03 May 2024 02:31:29 -0400
X-MC-Unique: or83uDTjMcGQCd_EXjvIwQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-79088c219ccso1319451185a.2
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 23:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714717888; x=1715322688;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ru7a1UJMZGiekMzJlOvjyZbD1x5iZtjKj61gAnG8XH4=;
        b=E52Z25uHvf07cFLMHaNFypCiG5IOIbUVKp2KM5pHnfr6hV8ncoseOsKFvqqJWmy8ht
         9RnqGdCHndMLqs8MIdPUy1aBETAFdK+j/cUhx0gj769ysHcZVmGMEksPHPA3IHQEQ/q2
         d8SL/HVG8pt0EBKucMBu6RZcB/782uu/l2+T3eEL8vCIwdLpGn4wJwJk82F7Y7FXeo0o
         4HSCrxd8ZcG4fV1PE0UBAJHwqLxYI17UoEUkjOBIGudE8aZeFZt8Kz70CmmCqPA/SgNt
         s9t4OTLIGGgtFCJkh2eRvsqLW0VS1+Qn0HTifNQXdrVq/H7E5oT1BnHKGtJlsHryLg0E
         ieXg==
X-Gm-Message-State: AOJu0YwanxQqYu7P3tp+Bm45WJFniSSKhWgFBGu/I1M4AT0Mg5zBB40R
	lr3DEuEg39HVhIr8XTQac8Dn2cto9MFgEtPXbrkPN5SUoOsdtmVXc1QJ7bft4a+KD64RnGrLNSE
	xcUBukeI5NMIVLWKmEwWc3eJsJrnFnlhlf4L/eLX/nA+SUQm1JQ==
X-Received: by 2002:a05:6214:212c:b0:6a0:7791:3d74 with SMTP id r12-20020a056214212c00b006a077913d74mr2110433qvc.38.1714717888556;
        Thu, 02 May 2024 23:31:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1Dga5FWv3i3GruLvpP7waHREgEVAElmfgI+VC2Dyk7gUTbqY914Gr+XZoFTGAjOhsby7yUQ==
X-Received: by 2002:a05:6214:212c:b0:6a0:7791:3d74 with SMTP id r12-20020a056214212c00b006a077913d74mr2110422qvc.38.1714717888254;
        Thu, 02 May 2024 23:31:28 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id mi8-20020a056214558800b006a0f4921e8esm956269qvb.119.2024.05.02.23.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 23:31:28 -0700 (PDT)
Message-ID: <46c7d737-15d0-4bfd-80da-cd9e41725b3a@redhat.com>
Date: Fri, 3 May 2024 08:31:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/2] shellcheck: Suppress SC2209 quoting
 warning in config.mak
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
References: <20240503052510.968229-1-npiggin@gmail.com>
 <20240503052510.968229-3-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240503052510.968229-3-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/05/2024 07.25, Nicholas Piggin wrote:
> It's not necessary to quote strings in simple command variables like
> this where the pattern makes the intention quite clear.
> 
> config.mak is also included as Makefile, and in that case the quotes
> do slightly change behaviour (the quotes are used when invoking the
> command), and is not the typical Makefile style.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   configure | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/configure b/configure
> index a8520a35f..0e0a28825 100755
> --- a/configure
> +++ b/configure
> @@ -420,6 +420,8 @@ ln -sf "$asm" lib/asm
>   cat <<EOF > config.mak
>   # Shellcheck does not see these are used
>   # shellcheck disable=SC2034
> +# Shellcheck can give pointless quoting warnings for some commands
> +# shellcheck disable=SC2209
>   SRCDIR=$srcdir
>   PREFIX=$prefix
>   HOST=$host

Tested-by: Thomas Huth <thuth@redhat.com>


