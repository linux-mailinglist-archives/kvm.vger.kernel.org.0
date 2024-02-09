Return-Path: <kvm+bounces-8400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 026C584F0BF
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C1FD1F2616F
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 07:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9707A657D2;
	Fri,  9 Feb 2024 07:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YGzJRq0u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FE7657C5
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 07:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707463754; cv=none; b=Rzkag1zkGUcfXswj4H+GAVwhOyA5ik9sxxodZddISyMKeUq1PaZQ3qAK/LnclrCYqswyAb34vpWVft0WfshFnKvT1Q/OndA9HGmBQTKAUQQu51BsZd1TJohTFB+tUKuZEXyNc1S2XKVUtyGpdhOhSrppFESWrgmut+4pRObLjqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707463754; c=relaxed/simple;
	bh=xcZp+8mbHI9tXdmnrUIdeuEPJKN3vo4PeeisEgwX/ZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kPNaf0TZZGyR5rHLL1gz898P2f3OjX95Jrr3bpPaaqSIhqtZ4CIrttyTrmNVtKQRM60Eozwqbfq21M2qg9u44ILObDw7MOUHJxptCV6nb5Na0/8syE6/8FEFpbXhHtWeG+TvDaUYPkZPP89i9v9dy98WxHZpgZZjOilWNGNFN98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YGzJRq0u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707463751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/kCQkh1KyEVD4cmjxJdTLiN9QRnCpv4ZYb6SgTC6zQo=;
	b=YGzJRq0uhYJKfgIBbI9MURxwYQteEcBy0ecKvIMwvKiFYWrOoyL+ClKVOZJqUw9fwZvdpB
	4UKME4PpDui24bVu5ym/LL6MNkGtr9y0W3i5tVv5Br+Wkly9FJ7bnToiFocYi2DTEw5v1H
	/igI9g60zaKkQDKCRRD01shCPk/v6p8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-lqnVaRkNO265-YfGITKuLg-1; Fri, 09 Feb 2024 02:29:10 -0500
X-MC-Unique: lqnVaRkNO265-YfGITKuLg-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-42c516d5324so5522481cf.0
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 23:29:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707463750; x=1708068550;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/kCQkh1KyEVD4cmjxJdTLiN9QRnCpv4ZYb6SgTC6zQo=;
        b=b4WjPgVcoZRA10K+yFFXk04T15jNYMeFbp1bXVC7dHCAXpNy7HpfmJSwdUarGMrZmN
         l1+O/iYdxM9TlTvQ/oVtj54rBRXFHg9jTg/zOQkGAVheJQsx9X9ueObPE17fVQD0kxHZ
         zkp6Zql/pfZpHWHQPd3KiMBOuTnbmtXj36BHMjo0hW3cUy1iYTrh7F2m2iTswSC5OF/S
         owP/6KaHBkObiD5ONqg2BpxsyUHqcvPYlrfWTfwn67YlaRZq6cXDrnpuU+YBWt/Q+tcQ
         mH0jItnBwp9a4p0oYUriua5rcSBDOD349/CYMRG8+WWT6pXx7z2c2BgHv14xAqfZ3oaX
         3ahg==
X-Gm-Message-State: AOJu0YwVp2Vt67iZSW+5sqeQJ9ko1bFnTOa0D/I55VovEOTfLr6iOimo
	u6xqpDaB8p5JjTzJg2M0G83TymzazU5mREdRAOnKqOG8ScDnLlm5FezuSjf7Sf3BD0Bf1esbOt5
	R0lAWHFOfAOlv3rx/EPnRgYZF/CT8/TKvf6NToVdLa/5SsIuJvg==
X-Received: by 2002:a05:622a:1893:b0:42b:eba5:ddfa with SMTP id v19-20020a05622a189300b0042beba5ddfamr1059551qtc.45.1707463749924;
        Thu, 08 Feb 2024 23:29:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMxjVKgUnE4ZnmcUKcBrw8kAOVCQv/Rc0MeOA1nppU8LiVZdGnfF07uBuSMXuz36m7DpRJVA==
X-Received: by 2002:a05:622a:1893:b0:42b:eba5:ddfa with SMTP id v19-20020a05622a189300b0042beba5ddfamr1059535qtc.45.1707463749665;
        Thu, 08 Feb 2024 23:29:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUUx7B+ytx1jxJQX4+UCEaD6tXqKT6ucApPaiWJaZykn+w/0+a9uoX07+JiQbkbUn2PocH3WgLLSAwUWCRqHLGHfWw2RM4gftDO26hfG00892hDH/nJBHtY35xRnxec4jWrutSej2X3k58etZWZejKzojLkXvBJ7hvnLpXN0AoJ2560dbm7gHPx7EJppgxU63rFF0u8DPA+3VHkOqpci+TKf9Wp5TIhYbCCaygZuy+m1DQ5pbTM1MKkDYTdZB9UnU9lQPdwTJoEvO97tO2IdFk9FiKPj9ddRMld7j1xZPqY547vGm/HC+tp1mEl/USbhRvbnQ72Ad5RgfOARa2559A6Vt+yf24Q/bOtJmEGg3B6CWBY7L0Rg8RDCDi+fi04SNLskUP7nJczW7S7vwmU2WPv2EqZ+9Y53w1KMMTYX0YLPc/MGl6CV0YUBpPrD4O1KSAwTn7NQhEycInPV/3oHrbqfF7HYyqpqWNB9zMeyggz1/irjDv7QjtE1NmSqRVyQwe64oC6pBEOXKjOMY9TXeo57xpo
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id c19-20020a05622a025300b00427fb1d6b44sm480566qtx.5.2024.02.08.23.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Feb 2024 23:29:09 -0800 (PST)
Message-ID: <4203f6dc-ad8c-4bcd-a366-f50f866c55ec@redhat.com>
Date: Fri, 9 Feb 2024 08:29:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 1/8] arch-run: Fix TRAP handler
 recursion to remove temporary files properly
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <20240209070141.421569-1-npiggin@gmail.com>
 <20240209070141.421569-2-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240209070141.421569-2-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 08.01, Nicholas Piggin wrote:
> Migration files were not being removed when the QEMU process is
> interrupted (e.g., with ^C). This is becaus the SIGINT propagates to the
> bash TRAP handler, which recursively TRAPs due to the 'kill 0' in the
> handler. This eventually crashes bash.
> 
> This can be observed by interrupting a long-running test program that is
> run with MIGRATION=yes, /tmp/mig-helper-* files remain afterwards.
> 
> Removing TRAP recursion solves this problem and allows the EXIT handler
> to run and clean up the files.
> 
> This also moves the trap handler before temp file creation, and expands
> the name variables at trap-time rather than install-time, which closes
> the small race between creation trap handler install.
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   scripts/arch-run.bash | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index d0864360..11d47a85 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -129,6 +129,9 @@ run_migration ()
>   		return 77
>   	fi
>   
> +	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
> +	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
> +
>   	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
>   	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
>   	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
> @@ -137,9 +140,6 @@ run_migration ()
>   	qmpout1=/dev/null
>   	qmpout2=/dev/null
>   
> -	trap 'kill 0; exit 2' INT TERM
> -	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
> -
>   	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
>   		-mon chardev=mon1,mode=control | tee ${migout1} &
>   	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
> @@ -209,11 +209,11 @@ run_panic ()
>   		return 77
>   	fi
>   
> -	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
> -
> -	trap 'kill 0; exit 2' INT TERM
> +	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
>   	trap 'rm -f ${qmp}' RETURN EXIT
>   
> +	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
> +
>   	# start VM stopped so we don't miss any events
>   	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
>   		-mon chardev=mon1,mode=control -S &

Reviewed-by: Thomas Huth <thuth@redhat.com>


