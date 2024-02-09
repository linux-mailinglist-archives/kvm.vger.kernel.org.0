Return-Path: <kvm+bounces-8402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 459F484F0ED
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF8A8282469
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 07:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE78565BA7;
	Fri,  9 Feb 2024 07:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dToVorwG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20754657CA
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 07:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707464626; cv=none; b=shirgfdPWGCoywD9XSMHAqaVkn9hPB95S0y767DG74j+8unv6cIygVYQF4mvXMEfpZa/IeFvbnkcGCrJyUUivxOR7EifVS9+NMCSfR+6WfIuSW08KVjy/t92LrNsRnyftGMHCRLvYp5SKbkKETlAohenBlMgaLsGuj8IiWWpvSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707464626; c=relaxed/simple;
	bh=j/vRJan6i8+nJuusUqpxQYk0kwoxhm071oN71FOT140=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l8O4oJQCCI5YSTlyeeRGxEGh7g+uFyiVS1KKkgnP6RHpcOHgVotgFdhEIX9tqt4Jsx1A0J2E8QkPBxUREVZaGhT/gmEB8fMwPXjC8OAGpsYeD4RzGyfbmKuqry053UcsQVbaxisVyJrnVGbOYguF10+rFKECUpXsjuiiEOOcbjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dToVorwG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707464623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uGf78GSSLTQpF5Eiu1od52sEG+/7hU+ZiNNhjo8N8WA=;
	b=dToVorwGUta7TBePvOEAE4V5TpJFI8A8vTV9A1EBVDWtEFD/JiFlk1vtoVtR0ZzuNbioLm
	RYEh5lxryR3wIoGmurJ0hCZiZambftfbMPzJ0/Fmq67OeRRJd8FO11P8YUvwhefiNATpUG
	sNPn41yiJEjABODonpYJR5WekN1ncvs=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-ZSrh_QxnMbeMg6vrhYLlIA-1; Fri, 09 Feb 2024 02:43:41 -0500
X-MC-Unique: ZSrh_QxnMbeMg6vrhYLlIA-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-dc746178515so1210025276.2
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 23:43:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707464621; x=1708069421;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uGf78GSSLTQpF5Eiu1od52sEG+/7hU+ZiNNhjo8N8WA=;
        b=Dzn0rmdO1Sp8vxBQOuUHFQ5QaaHnndjNwYKVIzNrH5f8hruWsZSW2nVhEnAkjBDz4N
         lnCmG+BEMwwkeojjtDupQHRmPwUNz7IGv1C2m8y+1JFUs1TWVi9Kw5KbB9a38sgjUWrl
         tdu+6gtcOfbo3PRZe/xhJEMLYzJv1A7vx8T6bfRu7ccs6XmjxxKhlyirRdjuzAB5HZFB
         Alnqsu33M6k3No8Liv3UWvFMsc3h83IyZ6sotEp6xXNL9s9C4uhhx/zRFhMYFegHblQE
         brSal8IIvF/C0EllOD2gEgX59RrFJQ3F3f+EVm39B5s5byHPnH70cfyuiL7iCTo0kG6x
         +AkA==
X-Gm-Message-State: AOJu0YxS8aUtVF9DAzrI2CN29/6i01NO6OwbfRyzxgqP2RRK6KOp+yRt
	yl/ynm5zdwftW0043qj9NnjmuG1BWLeMyG4FuXyuqTns0XqwM63aH01R/11VwO8aOsNbhXKEmDl
	x3svWFutx1MaBqscDgCUnkBy02JWqXgopRWUQVUqwwDWmQZaKQQ==
X-Received: by 2002:a25:aa52:0:b0:dc7:43d3:f8ad with SMTP id s76-20020a25aa52000000b00dc743d3f8admr648607ybi.17.1707464620937;
        Thu, 08 Feb 2024 23:43:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbgR3CX6WL1xJqNIMgL+kDPRru4nEZNqoR3X4gAa+eKU/MkxNMcm314BtV0Lijrngudkcgkw==
X-Received: by 2002:a25:aa52:0:b0:dc7:43d3:f8ad with SMTP id s76-20020a25aa52000000b00dc743d3f8admr648593ybi.17.1707464620627;
        Thu, 08 Feb 2024 23:43:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU6g1EbNCn917cZPsbp5MO+NEUukYuQnS3RNDprf6cv3wTiBU7QEhHd5yUZYW9Qce6Q+uakpHlHL1ABMIZ9RuQn1oBW6Q67mSmjG/UXwZmwtGMs0JRvaEH6P18YWtmtxeAea1dbNFyEaI8WAfO44dYhNup8uFIOO0URyCcd/ycR5HrJEy/cNshtDkcDkPGrhLAyPT7YY8Ka9YyJIV20mCUc6lRn/GEfeRIiZAk0oceCZ21NlVwg/6kioJWPDVhdrLLgV3g7MjnG/D8CzCGSi3ry6GqqvfoYCHFkzCduzGYGL2vaYSe80DnIN+kCFZJK4V2m/fhPoqBa8JUwRHtjkOrtoOXi7mH4rSLfHdDOmRvjrN62uTaObl1mr48aJygF1P8FMihQ3JlHls4abX05/9ArPJ6IHXSJ4lcYeOCiqDQe4R1AMG1mIJ5i/ZpPqZ40p84vU0FPXrQHVXNzd/MsypENUB2Q5ZU41KmD8+o14mcjgfaKdYeNXcKV7gsyIxhGk+S0Zs7uktfVhxyDvqXIeRsSxNvK
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id i12-20020ac85c0c000000b0042bf5ec20f0sm481421qti.30.2024.02.08.23.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Feb 2024 23:43:40 -0800 (PST)
Message-ID: <9b041258-e412-4745-a213-6798e682ea62@redhat.com>
Date: Fri, 9 Feb 2024 08:43:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 3/8] migration: use a more robust way to
 wait for background job
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
 <20240209070141.421569-4-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240209070141.421569-4-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 08.01, Nicholas Piggin wrote:
> Starting a pipeline of jobs in the background does not seem to have
> a simple way to reliably find the pid of a particular process in the
> pipeline (because not all processes are started when the shell
> continues to execute).
> 
> The way PID of QEMU is derived can result in a failure waiting on a
> PID that is not running. This is easier to hit with subsequent
> multiple-migration support. Changing this to use $! by swapping the
> pipeline for a fifo is more robust.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   scripts/arch-run.bash | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 1e903e83..3689d7c2 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -130,19 +130,22 @@ run_migration ()
>   	fi
>   
>   	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
> -	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
> +	trap 'rm -f ${migout1} ${migout_fifo1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
>   
>   	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
>   	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
> +	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
>   	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
>   	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
>   	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
>   	qmpout1=/dev/null
>   	qmpout2=/dev/null
>   
> +	mkfifo ${migout_fifo1}
>   	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
> -		-mon chardev=mon1,mode=control | tee ${migout1} &
> -	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
> +		-mon chardev=mon1,mode=control > ${migout_fifo1} &
> +	live_pid=$!
> +	cat ${migout_fifo1} | tee ${migout1} &
>   
>   	# We have to use cat to open the named FIFO, because named FIFO's, unlike
>   	# pipes, will block on open() until the other end is also opened, and that
> @@ -150,7 +153,7 @@ run_migration ()
>   	mkfifo ${fifo}
>   	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
>   		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
> -	incoming_pid=`jobs -l %+ | awk '{print$2}'`
> +	incoming_pid=$!
>   
>   	# The test must prompt the user to migrate, so wait for the "migrate" keyword
>   	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
> @@ -164,6 +167,10 @@ run_migration ()
>   		sleep 1
>   	done
>   
> +	# Wait until the destination has created the incoming and qmp sockets
> +	while ! [ -S ${migsock} ] ; do sleep 0.1 ; done
> +	while ! [ -S ${qmp2} ] ; do sleep 0.1 ; done
> +
>   	qmp ${qmp1} '"migrate", "arguments": { "uri": "unix:'${migsock}'" }' > ${qmpout1}
>   
>   	# Wait for the migration to complete

Reviewed-by: Thomas Huth <thuth@redhat.com>


