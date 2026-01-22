Return-Path: <kvm+bounces-68878-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBbkOJwMcmksawAAu9opvQ
	(envelope-from <kvm+bounces-68878-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:40:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5108B66209
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:40:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 159087AC78F
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A393D423A8B;
	Thu, 22 Jan 2026 11:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZbuhQ+Si";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQ3eDl4F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFFC3BB9E4
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 11:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769079924; cv=none; b=aZGFSgkXoldin4X/5Fa9XvxtFUx7cqb2QUQWn9lf9EsJ6I8pQnVLOamsX6oWaWq/lDuOhyvabgcTQq9MWHwboBPFHTI+mjA1JNOre8FJgoN7akjqS0yLsj8smL6YTfr7sNQ7iMVHKWo8ZS60bu887AIKn9RyBVu3TQEBg405CyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769079924; c=relaxed/simple;
	bh=v17C+UqSsgX+dwMkYH3VvDAteFFyOhWTVIJ826kpLTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YkQKPCCNSQ/573XWEPC7L4eMzf8aQp/0RyPaHkhIZX3MIMN2tecvLJ+H2QpMZKGiSBPG1ow9y1Iui4gW7v5y0s6b47dOhw55S0heaPnwsHgSkyWNiJPoL/ETyQYsasj4hsAUF7mesD07UQnjpFA+MR2SlXhFjXD7Ue4rWj2RH24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZbuhQ+Si; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQ3eDl4F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769079920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=30noYZHuWAssSIqIEcBn/MiCq2hJ2f1fdsIQNRSpmKc=;
	b=ZbuhQ+SiMPg7CjIa7UimOd3o7wOF4Z+50ArYHGzDD/ocIW4P4kpYc0XNdktdT422/sADjs
	CfCEQI0aVWv8cNI3UR7AyX66Xfo2MQL7WI25qa9uYMwIwLALe4i+C1+AD/zLJCjFY699Dx
	RlpeEywyrB6zQVv+6M8MuOq8pJ/axqI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-r5QT56bwMCGwM0Ap1O7o8g-1; Thu, 22 Jan 2026 06:05:19 -0500
X-MC-Unique: r5QT56bwMCGwM0Ap1O7o8g-1
X-Mimecast-MFC-AGG-ID: r5QT56bwMCGwM0Ap1O7o8g_1769079918
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4801ad6e51cso7474205e9.2
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 03:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769079918; x=1769684718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=30noYZHuWAssSIqIEcBn/MiCq2hJ2f1fdsIQNRSpmKc=;
        b=fQ3eDl4FKcBmh6CBq2y0hhoR5EY408uqK0roWkhiZ9oRoh9drI2jbF705VLmAWoyp3
         VfN3I0wbQSgUa2858I5MpHwvQsnM+/c6ANitoByMmDchu0N+Yv+ir4U3E52HlfiS9Obz
         YPmiGLJccFkB2SG0iplwkLEh8nr/j40mUtICpMqyP6LN727esv+oaUA89a+tY683uv+a
         BjFFPo+7Da1E/uy2Ztq6V2XumFbqCb8LrF4mrPVP43PBaueGP6dAKNfDqUClapRZ0pH5
         1KP3ZRrNbH1bex9X6SMUTU1G93zIiLnOeX3fPc3r835xEw0J6x0QYS3wrhR4ve4IsutB
         anYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769079918; x=1769684718;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30noYZHuWAssSIqIEcBn/MiCq2hJ2f1fdsIQNRSpmKc=;
        b=eIeU4REFJ+UOso5L2s40xaXxQCOe9sBCNTdtpTYLB8fT9Pa4VUZUMerIIr4Y+Hyyxj
         ByQcH9w6F78QB/g1XrFR+ny2kZk+3AvT/0c1Nlrt/s2Y7OuQ1mrrOwnf7F4TK6BDcYwP
         neHp7Rm68F+RPN2okw1oVB6lodIpVwPIeqXsBp/W8N9Rb5hubf1N7FhSG8uD1RH6QxVe
         Gt4xob1cJ91P2BKThejO8JpGV+40tnN+qnwBk+D9hpBvk6it4TkwL14I4FNMJkMFUbN6
         Vn7ASAr6IMk6Y7wyHLbyabDyFsPK5RTBt4raMyR+hTT20DcyYvNJJCEjqOD1almu2lIN
         Nerw==
X-Forwarded-Encrypted: i=1; AJvYcCWYQDZ7YLUNYWV7Zs7rf/04qUJGYz+o+gIJtgGww9EwPf0ic1sxRmVCczU5H6Wr9T/RjOk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7hOUB6nP9BjkcrzN9s03sth9cYzmFYC1+aj+w3Z1M2OQ+9a7u
	XQxImZge2nL92FlXbxEna5M/927wJVh5vdPpQ4EXzvyhTFFvI9fOQRxeUsrcvzE0XzwHcer9fqx
	oXyXe19vOMIXMaa6xdmwa6+4MR2xZIBwaJfXGJ3uiD64DNSWXYcYlNQ==
X-Gm-Gg: AZuq6aK2MU2HsAnW/TluesjpI7CuPAKJlMYRV81N1DBqPPFpJenx8AVVetlItFqBubS
	EIFSz4jyoMKO+PTfTNUsVUHYCC/60ofMgEhDKjjm6iLdoXP/riD6uTjfwsxHlH7LdBUXrv47EIi
	KcRD/VHa1AP4x3PB423hp8PESnoImUiUcsw1UxoWWpbGl2u4msQsI+A9ioSug7Nv1if0ikb+RPG
	mMcPMgHJU70TTh6oBwpzIsouutmw56UyegLrw6Hu1Wh5a3vAhVJgLpA1cdAw990KsktwPXwfZka
	yeqNzDOZzOwRJthKzjUnHbFA7EQpXI/MahVm5GJww+Nr8eR5GYTmpx6xDpgjv2oursUlxW9K4KG
	P7msANfA=
X-Received: by 2002:a05:600c:1549:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-48038b7872amr181948855e9.27.1769079917829;
        Thu, 22 Jan 2026 03:05:17 -0800 (PST)
X-Received: by 2002:a05:600c:1549:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-48038b7872amr181948165e9.27.1769079917265;
        Thu, 22 Jan 2026 03:05:17 -0800 (PST)
Received: from [192.168.0.9] ([47.64.112.255])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48042c773e3sm48917535e9.20.2026.01.22.03.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 03:05:16 -0800 (PST)
Message-ID: <995d4aaf-bbff-42be-9114-1f04bb51e37c@redhat.com>
Date: Thu, 22 Jan 2026 12:05:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Call for GSoC internship project ideas
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
 Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
 Kevin Wolf <kwolf@redhat.com>, German Maglione <gmaglione@redhat.com>,
 Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 Alex Bennee <alex.bennee@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 John Levon <john.levon@nutanix.com>,
 Thanos Makatos <thanos.makatos@nutanix.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
 <aXH4PpkC4AtccsOE@redhat.com>
 <130b8f26-2369-48f5-bbd6-e27210707b9f@redhat.com>
 <aXIAmeEWMFjQM84o@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <aXIAmeEWMFjQM84o@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	TAGGED_FROM(0.00)[bounces-68878-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCPT_COUNT_TWELVE(0.00)[20];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thuth@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[buildroot.org:url,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 5108B66209
X-Rspamd-Action: no action

On 22/01/2026 11.48, Daniel P. Berrangé wrote:
> On Thu, Jan 22, 2026 at 11:43:35AM +0100, Thomas Huth wrote:
>> On 22/01/2026 11.14, Daniel P. Berrangé wrote:
>>> On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
>>>> Hi Marc-André,
>>>> I haven't seen discussion about the project ideas you posted, so I'll
>>>> try to kick it off here for the mkosi idea here.
>>>>
>>>> Thomas: Would you like to co-mentor the following project with
>>>> Marc-André? Also, do you have any concerns about the project idea from
>>>> the maintainer perspective?
>>
>> I'm fine with co-mentoring the project, but could you do me a favour and add
>> some wording about AI tools to
>> https://wiki.qemu.org/Google_Summer_of_Code_2026 to set the expectations
>> right? Since we don't allow AI generated code in QEMU, I'd appreciate if we
>> could state this in a prominent place here to avoid that some people think
>> they could get some quick money here by using AI tools, just to finally
>> discover that AI generated code is not allowed in the QEMU project. Thanks!
>>
>>> IMHO, our baseline for functional testing images ought to be
>>> a Linux Kconfig recipe used to build a dedicate kernel, plus
>>> a busybox build for the target.
>>
>> Not sure if we want to add kernel compilation time to the functional tests
>> (even if it's only done once during the initial build)...? That could easily
>> sum up to a couple of hours for a fresh checkout of QEMU...
> 
> That's absolutely *NOT* what I was suggesting.
> 
> We should have a 'qemu-test-images.git' repository that maintains all
> the recipes, with CI jobs to build and publish them (along with corresponding
> source). Those prebuilt images would be consumed by QEMU functional tests.
> This would be quicker than what we have today, as the images downloaded by
> functional tests could be an order of magnitude smaller, and boot more
> quickly too.

Ah, sorry for getting that wrong!

Ok, so this sounds basically just like a gitlab-CI wrapper around what 
buildroot.org already provides. ... not sure whether that's challenging 
enough for a GSoC project?

Also, adding this as a separate repository will easily burn your gitlab-CI 
minutes if you don't have a dedicated runner for this, so developing this 
feature might be no fun at all...

  Thomas


  Thomas


