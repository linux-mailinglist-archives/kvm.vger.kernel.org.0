Return-Path: <kvm+bounces-8411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 588AC84F18B
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AED79B21FA6
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35D7664A9;
	Fri,  9 Feb 2024 08:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CAT83+1o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248725258
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 08:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707468265; cv=none; b=RdHTPWPlczDbum8b429lmT0nMPfYmckDT+gprWwXla6ccO3yAmqofQ+OpeArhPpBnD42BSKUrKhOY/KqyvpXpWyBlPCAMFsqIqg1CqSNmzYNeKKCT1WP9ly3WxKDFF2sVj/A0MolnoXdZ7Kh/yTXHb4xno6+KAn/61/51sSQjiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707468265; c=relaxed/simple;
	bh=UN0oc1Ydv3nZlDkaV1qLHXqrGaQ5s/7JdQA92+72UIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RRMsdXcLd8gfQ2wmQYOerL6B9a3nk4BjG+igWUsBQhRjg8ycg98ER0iMne9zY27kcoLiiVE6Qy+1bqo8a6a72lGBIVh8PvF/38qOCi6/TwE8J5UFhrhTqydc2RLWn/fj7hpSoYYtYFyZeRJf+5eZRL5hLWm3xVZsOhW8t4f1pzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CAT83+1o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707468263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U7QtO/B1x4WufwQY1oNwKENexJgfIV0+MC7DbRCbPo4=;
	b=CAT83+1o26BNsNsXCqiiTFkToARK8+hGEKb+nirX8mc7UECFCcZOod8WWYAs8KopwuOYHi
	JS68daqAPhfZ3uvGxttD7xeXeBrqSw+AktQckQCwYi/CINolcaX50wvt6QdKr+VvJ9FooB
	ZkZ8Biq5NqkZSOV3ixfDzPeu3yEjML0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-Gg-Cv0CcOJ6RMe7jjDNWQA-1; Fri, 09 Feb 2024 03:44:21 -0500
X-MC-Unique: Gg-Cv0CcOJ6RMe7jjDNWQA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d0a4fbc9e4so6395141fa.3
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 00:44:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707468260; x=1708073060;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U7QtO/B1x4WufwQY1oNwKENexJgfIV0+MC7DbRCbPo4=;
        b=c9Wglj0zr5NLOWVPr+frTf7W9BLF2z/TQ1sJoEmCHU42NseqxucKDfDibAtWGJ5EjD
         XTMlwPAszyNHN3IvHy24MTKogW8GEdU5PuAagKpeSALzWes8tlgFtlDjCT65+dvrs07j
         AMZEwKsM0EWLij7XOJ8N73WJ4pBbJXEpk/yV1z3/02XmiQP+KUXOjL85pDhmkfPF1YzF
         F7+1s5+tixQqzKhgmHWwlRTB5IZi60YrfmBz3/9somCx8L9sJeBGW4HZFLIZ8DSDSGPp
         ZEAIa8zDuXu8GyaE1nk/ZAtfypzt32A41DN/2SDZbVwy5t53lRsdaAL7Nu2u+vkPuyNu
         hiKA==
X-Gm-Message-State: AOJu0YyI9psVsc6Rt8b28SY5wGLBf2FAzMTYVYdIVLTB2LWPCprWpmnb
	Q+DgdtfpOKYyLwrb1p/zG9LF2xrn+HDlB4VIH1sSEtr1XNxXsc6gsUEmjsMWdPSlnBTB1SBOMWU
	+wJn2PdSc92iWunv0HV3lcAU9qmcy1hFhFahMpya/Dz6ROL1sQA==
X-Received: by 2002:a05:651c:556:b0:2d0:b253:80a3 with SMTP id q22-20020a05651c055600b002d0b25380a3mr749837ljp.30.1707468260079;
        Fri, 09 Feb 2024 00:44:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExo4Va4vXoHmBq8wvDBuEJSUmovGi8JmBxMxEdUP0VcD1G/DihY+Pf+/ZtC1ZcSG55ehLn1w==
X-Received: by 2002:a05:651c:556:b0:2d0:b253:80a3 with SMTP id q22-20020a05651c055600b002d0b25380a3mr749826ljp.30.1707468259730;
        Fri, 09 Feb 2024 00:44:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUX3xO2UBOKHsulzBgJXCo+c9o13YuMCXT6KfqyOigRL6wAP7ek3CquA8zy7n6yth5G3JmN+KgXWxjLyYrxTgyICsjxDD+JJ61L5Yq3A6k42jGrRP0DQQo9RnWKaPz1QWIk5NXPhU5RCjfRrge01SqjWX06Otf2Jy3du8nD1aZbyAhCnbRlJlHGMUARScP2rCvy0nRpHwFquVVcTLAHt1S7tzTWteleBqtMSo5Jw4xut8ELBRnZJ9P/lwSv7EoXEWVvzT66FerI6Fz+vTSp9ddk4blAN6lUFANnMMdzXArMNCyafcAC+o+Hl3HsNYK3bgafP3U1o7xJ/NnJGANqIzJHBJQD8Jt758n7HeeAUgsokd4Xv4hRIAGydQptEvprNZ+eRnZnr8NuOlx/FE/hIEKkHPbzlma2pc8QoJLv9R0ksDTXLsf3wVC01gdSpdrUk7F0tNFkBzI8uW2ji9uH2KOkaGE/PxmMMZ85gwvFlsBWqP4aqwRUSi3OAtivY83fWBYmLkzG+Pd2JL1E6hukmTu+9oKJ
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id gs36-20020a1709072d2400b00a3729ce6321sm523654ejc.166.2024.02.09.00.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 00:44:19 -0800 (PST)
Message-ID: <94104ce8-faab-411a-866f-1d7b2aac78c8@redhat.com>
Date: Fri, 9 Feb 2024 09:44:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 4/8] migration: Support multiple
 migrations
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
 <20240209070141.421569-5-npiggin@gmail.com>
 <74f469c3-76ee-4589-b3ec-17a8b7428950@redhat.com>
 <CZ0EVI7IZ9YY.3EF4ZKA9IXM5I@wheely>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CZ0EVI7IZ9YY.3EF4ZKA9IXM5I@wheely>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 09.39, Nicholas Piggin wrote:
> On Fri Feb 9, 2024 at 6:19 PM AEST, Thomas Huth wrote:
>> On 09/02/2024 08.01, Nicholas Piggin wrote:
>>> Support multiple migrations by flipping dest file/socket variables to
>>> source after the migration is complete, ready to start again. A new
>>> destination is created if the test outputs the migrate line again.
>>> Test cases may now switch to calling migrate() one or more times.
>>>
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>> ...
>>> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
>>> index 3689d7c2..a914ba17 100644
>>> --- a/scripts/arch-run.bash
>>> +++ b/scripts/arch-run.bash
>>> @@ -129,12 +129,16 @@ run_migration ()
>>>    		return 77
>>>    	fi
>>>    
>>> +	migcmdline=$@
>>> +
>>>    	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
>>> -	trap 'rm -f ${migout1} ${migout_fifo1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
>>> +	trap 'rm -f ${migout1} ${migout2} ${migout_fifo1} ${migout_fifo2} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
>>>    
>>>    	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
>>>    	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
>>>    	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
>>> +	migout2=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
>>> +	migout_fifo2=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
>>>    	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
>>>    	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
>>>    	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
>>> @@ -142,18 +146,61 @@ run_migration ()
>>>    	qmpout2=/dev/null
>>>    
>>>    	mkfifo ${migout_fifo1}
>>> -	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
>>> +	mkfifo ${migout_fifo2}
>>> +
>>> +	eval "$migcmdline" \
>>> +		-chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
>>>    		-mon chardev=mon1,mode=control > ${migout_fifo1} &
>>>    	live_pid=$!
>>>    	cat ${migout_fifo1} | tee ${migout1} &
>>>    
>>> -	# We have to use cat to open the named FIFO, because named FIFO's, unlike
>>> -	# pipes, will block on open() until the other end is also opened, and that
>>> -	# totally breaks QEMU...
>>> +	# The test must prompt the user to migrate, so wait for the "migrate"
>>> +	# keyword
>>> +	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
>>> +		if ! ps -p ${live_pid} > /dev/null ; then
>>> +			echo "ERROR: Test exit before migration point." >&2
>>> +			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
>>> +			return 3
>>> +		fi
>>> +		sleep 0.1
>>> +	done
>>> +
>>> +	# This starts the first source QEMU in advance of the test reaching the
>>> +	# migration point, since we expect at least one migration. Subsequent
>>> +	# sources are started as the test hits migrate keywords.
>>> +	do_migration || return $?
>>> +
>>> +	while ps -p ${live_pid} > /dev/null ; do
>>> +		# Wait for EXIT or further migrations
>>> +		if ! grep -q -i "Now migrate the VM" < ${migout1} ; then
>>> +			sleep 0.1
>>> +		else
>>> +			do_migration || return $?
>>> +		fi
>>> +	done
>>> +
>>> +	wait ${live_pid}
>>> +	ret=$?
>>> +
>>> +	while (( $(jobs -r | wc -l) > 0 )); do
>>> +		sleep 0.1
>>> +	done
>>> +
>>> +	return $ret
>>> +}
>>> +
>>> +do_migration ()
>>> +{
>>> +	# We have to use cat to open the named FIFO, because named FIFO's,
>>> +	# unlike pipes, will block on open() until the other end is also
>>> +	# opened, and that totally breaks QEMU...
>>>    	mkfifo ${fifo}
>>> -	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
>>> -		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
>>> +	eval "$migcmdline" \
>>> +		-chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
>>> +		-mon chardev=mon2,mode=control -incoming unix:${migsock} \
>>> +		< <(cat ${fifo}) > ${migout_fifo2} &
>>>    	incoming_pid=$!
>>> +	cat ${migout_fifo2} | tee ${migout2} &
>>>    
>>>    	# The test must prompt the user to migrate, so wait for the "migrate" keyword
>>>    	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
>>
>> So the old check for the "migrate" keyword is also still around?
> 
> It's just the comment is staleish, it only checks "Now migrate...".
> 
>> Why do we
>> need to wait on two spots for the "Now mirgrate..." string now?
> 
> So that the it ensures we do one migration, subsequent ones are
> optional.
> 
> I was thinking we could just remove that, and possibly even
> remove the MIGRATION=yes/no paths and always just use the same
> code here. But that's for another time.
> 
> Actually there is some weirdness here. There are *three* spots
> where it waits for migration.

Yes, that's what I meant (I considered your two new additions like one spot ;-))

> The first one in run_migration
> can be removed, because it can call do_migration right away
> to start up the destination qemu process ahead of the first
> migration message as-per comment. I'll respin with that change.

Thanks, that sounds good!

  Thomas


