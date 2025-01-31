Return-Path: <kvm+bounces-36973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07B69A23BAF
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 10:53:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A38E1634ED
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 09:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA177199384;
	Fri, 31 Jan 2025 09:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ii4EG+C0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E50C158875
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 09:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738317221; cv=none; b=kBJKwZfADuJF4DQFeMCqcxMQnJ6L3e461k36cROLo40IZggPzHO4B1AaRT+TG5CQPs6iPjFOx3nDlzZiK8C+Sp/0GyZJvibmQXuwM4YZR5BKSQCNu2n9My7KWkdpWGDOjdCCcVuSY7h47OSYDVUL2zWHEQwXm4PvASCB83rmvhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738317221; c=relaxed/simple;
	bh=sDp0LogvDMGleGpxLgGfD0E+pdoqUDweM9svnQMHbh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nb+UeXIUjTbRtviH/g+5OR8X8PlHZkrAsDjxgm29qXU9JwEO7y4shIdyYGI1+hZ5UwLmCo46fy9dnWLrM7SqTICi9P5O5AAj3p1ac09t0FsE/dpQUX/zp1yLqZSf1jjCYEwPI4oPRj7jCMvPS2P46eyWg/n09W8Ey6OODcL/v4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ii4EG+C0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738317214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YYPNqOra8BFyjfstATKnn7L/5znUOSHsKzT9bufnwtA=;
	b=ii4EG+C0SklG3JVTamy+RO2sGEgMHLRzJ7+/AkJDefByAsRqGrXw8BVmRMnAmo4awzjHCx
	jI7+3qtLNMHVfFf9Hm2Ixqm2LbrBixG+GdBnrqlnqy6MQHrSOHsW3EuRlHgs80xMiyvQbZ
	yy6x7zVGXVZZbOMl6NaxYvpJIxtju7I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-Q12b9S6lOAu_DL_BWpMZ8A-1; Fri, 31 Jan 2025 04:53:29 -0500
X-MC-Unique: Q12b9S6lOAu_DL_BWpMZ8A-1
X-Mimecast-MFC-AGG-ID: Q12b9S6lOAu_DL_BWpMZ8A
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385ded5e92aso743242f8f.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 01:53:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738317206; x=1738922006;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YYPNqOra8BFyjfstATKnn7L/5znUOSHsKzT9bufnwtA=;
        b=ke5miEun8ZM27HZAihJVLKC0gC6mwmer3kUuuTF6/Gtxcf0uCMc4EUrdXhMSDqzKvf
         /CAYsaH90gaFuzZ0ITudYB6Dcxex1H/sAeUYV4qA8D7DiBWKHPYdVhsoWQxtAkpFlinJ
         lQg77Ixfhd8AhQecWzSCO2rd5fycHZ3edlECmO5VROlQZ3sIYZ/PyLbyVb1OqcbVjCgL
         ZbN+UT75sBRyd/e0u7g14sFd30bHwsHJ4amYpPbMGKjA7wU2XtlUZKvx8IQHTvkK7PG1
         spj8xhWVSS+/NRVMT9Wib5q00Md8blYraqR+j0ojtPPNPJvlvQv53QhTOoSnDIEnBCJM
         CrfA==
X-Forwarded-Encrypted: i=1; AJvYcCUpZHCRLxMDb40sdOa2qjx1prQmDebj9M7supS1D9aZotlx9/sZYymmue8vhKYQ6De+G9A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+VzyO7YjKMTnAWDMl9qFvFmGiEHCUzZgWNMnUN4u0hny2/8U5
	5WlA6ZL7Uc2c/Hs5CkO8zQCTuZ3+xHE3a+s9pkyHr7/nl9s4yFnpMp7+b9kt1rqvBdxvZ0/Bhs/
	deScNZVKDTofh8c5qYLhd3xDxPc0QQ99Edj74be4PIUpENL0Aig==
X-Gm-Gg: ASbGncus2fXKRjVhAVjZa1UnZyYW3m8UHcgbJsLZev9MM60AEdDPIHrUv0ET6QLNSqP
	s+agJWe8zhQwEnRvTdwMcAY2bPSxC/NUXo6kRUa3mgr9m9vaF8j+q/12X/Z3jTLjcks7PeUZD1J
	PmjD+JaBQGiRz2g+pW+DmUmU4n2TcznNGTlm2ptz6cbNBIj9nNTDTOA5KPn1LX/JIbFL9noRP0b
	z4mLg++MAV4yMNBVvnmOfetox8UT4AlcuT7I3rfRDdpNEsm7nElDKZ3l7Y5B+MFyt+8RiGhLrE/
	wDCAzlKcwNfsFTrfj3Sdi8MbgWe8PG8yxHGH
X-Received: by 2002:a5d:5850:0:b0:38a:88bc:aea4 with SMTP id ffacd0b85a97d-38c51b62994mr7934982f8f.30.1738317205939;
        Fri, 31 Jan 2025 01:53:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1OUnxcWXrsuLYO85Kuil251Jy54JqtlSeq7TJvzBXw6TV8UEFyjjaRBqS1dxyAOnH1SqHdA==
X-Received: by 2002:a5d:5850:0:b0:38a:88bc:aea4 with SMTP id ffacd0b85a97d-38c51b62994mr7934952f8f.30.1738317205529;
        Fri, 31 Jan 2025 01:53:25 -0800 (PST)
Received: from [192.168.0.7] (ip-109-42-50-234.web.vodafone.de. [109.42.50.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c0ebfdasm4260678f8f.17.2025.01.31.01.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 01:53:25 -0800 (PST)
Message-ID: <1a0d0d50-7968-440b-a96f-2b97412b5dac@redhat.com>
Date: Fri, 31 Jan 2025 10:53:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC kvm-unit-tests PATCH v1] Makefile: Use 'vpath' for
 out-of-source builds and not 'VPATH'
To: Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc: Janosch Frank <frankja@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250128104141.58693-1-mhartmay@linux.ibm.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250128104141.58693-1-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/01/2025 11.41, Marc Hartmayer wrote:
> If VPATH is used, object files are also looked up in the source directory [1],
> and this has some disadvantages like a simultaneous in-source build and
> out-of-source build is not possible:
> 
>    $ cd "$KUT" && ./configure && make -j
>    # This command fails
>    $ mkdir ../build && cd ../build && "../$KUT/configure" && make -j
> 
> Use 'vpath' [2] only for *.c, *.s, and *.S files and not for *.lds files, as
> this is not necessary as all *.lds prerequisites already use $(SRCDIR)/*.lds.
> 
> [1] https://www.gnu.org/software/make/manual/html_node/General-Search.html
> [2] https://www.gnu.org/software/make/manual/html_node/Selective-Search.html
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> --
> Note: IMO, in the long run we should try to get rid of vpath completely and use
>        OBJDIR/BUILDDIR and SRCDIR instead.
> ---
>   Makefile | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 7471f7285b78..78352fced9d4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -6,8 +6,10 @@ endif
>   
>   include config.mak
>   
> -# Set search path for all sources
> -VPATH = $(SRCDIR)
> +# Set search path for %.c %.s and %.S files
> +vpath %.c $(SRCDIR)
> +vpath %.s $(SRCDIR)
> +vpath %.S $(SRCDIR)

Makes sense,
Reviewed-by: Thomas Huth <thuth@redhat.com>

and pushed, thanks!


