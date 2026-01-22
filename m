Return-Path: <kvm+bounces-68873-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIdDHvIBcmmvZwAAu9opvQ
	(envelope-from <kvm+bounces-68873-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:54:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F2A658DD
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 39EAA88913C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F9640B6F1;
	Thu, 22 Jan 2026 10:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HCohk/ue";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OBNOIHOG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA853ACA5D
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 10:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769078625; cv=none; b=VZHAOR6BfvZKP+5EVnM3DkxkDW3iSdKELJY67irXbO8UA9q64Z+2zEmEgmqGJaAYUSekeP81JgiHU9GTwswo63xt0ailxgMkIUoCYd06JwJCgvdkwj7IuIcfOLS0zqfDsFDYJXwwKsaXK+4uQM0KzjvFjYGW8CHyetoZklgIeTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769078625; c=relaxed/simple;
	bh=Pbakclvu2aAfHYcwgpOBxvRLCs2g4Ta6PjR4sBDyLfc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cjetsIO1emcwF5tXU1mw9vD8uhi4GERtG7PMWr5UCWGC+y5lGTqsxHq5LnCptcPUoHSUddR6FxKe3HUqlowymhuIxuwRuLaFsvTPt16Pmmw57jnQ6FBnjyTEA/jNsZCSVuunoTlHb9klYNl1SsaUGGS+XbYwJ/LSBQ19iGstoGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HCohk/ue; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OBNOIHOG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769078621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LTltZq9+JCsUWsSmaaNgTGkB37YX5SdewpF/HCOajP4=;
	b=HCohk/ueHVpJt/CTGF+IenCYqHJnLVXCIhzENHhqVRwtSnhhipJdaAJcGAtw0kMYgE44e6
	IymgeTq7fceQsFnTa4TkMeo9zV1WnnbJRzQFBEAu5oWw2jyUe/jXGT59PNvFus2IzGKl+U
	R56QZYt1IT9Vj90v85YOgRLLhkGG2hE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-CFM3ZHx3MgeAUdbGcLYQfw-1; Thu, 22 Jan 2026 05:43:39 -0500
X-MC-Unique: CFM3ZHx3MgeAUdbGcLYQfw-1
X-Mimecast-MFC-AGG-ID: CFM3ZHx3MgeAUdbGcLYQfw_1769078618
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4801d21c280so5497665e9.1
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 02:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769078618; x=1769683418; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LTltZq9+JCsUWsSmaaNgTGkB37YX5SdewpF/HCOajP4=;
        b=OBNOIHOGsI99n+j6jyMC8zxpeM90Ul1dKUrPA3Xk0dLx5Mfw1nMo03p4N5A5dUCifO
         +e6mr3+pie5HovWUDRw7pKQIByd+9I78Wwu/kLU4nWGPnzg1iZ/w3BswPKgazkPJgKCa
         wxoouTpZCEsTQ11CZ3AQnfF2G0g1I1RTDoqcS489JsDvWU3VnsIgj4cF5xYGll36WFHt
         EqDD1NSqwjmrdy/nMIYzeFyVZzjMIYmL00Q0xTTd3uD3/KVIV5uJ6lHRUGba345fDqYz
         hiqEJTFJb6uFsw61DjPde/t9TBKBuaY7XuzX0z/u72mf1WPNsjnCDSUsSsOjIBLRMcCk
         PFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769078618; x=1769683418;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTltZq9+JCsUWsSmaaNgTGkB37YX5SdewpF/HCOajP4=;
        b=Qr9eJBqB8jR+BF7uvESEICDVMwjO0HDogMBzuJlm+0+OX7OEvWFUscYqQVSNNniEm1
         qg84AIf95iwdn/PGKmJa6k7sSJ/GQbWmNmQhfLH4eScJ2hRw1hFdpN6QO5S2SjV7+LRx
         YE/6NMpVdnIjGj3xvzsiRgMRJssJSF2ORXHrJVKYfYWQn0fy5N0VkYT2mIemYwXYrTyv
         VjMtFVmNbW90mJTWz8rFaFbynmyBlCSuJsAkdYXmLCr3mE3kOL/oAyavrAkYj8VLUXwm
         B8mJMseR0NOAdwIMho8aRGp9NWOUhfEtHEa91Z4Kxp7T4djgkgVzyRGyQlOaobOX4jDY
         siOg==
X-Forwarded-Encrypted: i=1; AJvYcCW5M6Yic9YyaxrGptdEvwCDpZJJQN2I6yYc/ug9R8QlJHZwifv4BJfEOzusY6IOSoZwM4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyM89WSo2XkbCtcYB60vMThaNs4xJhR+Vof5Cyci+oKFOBG/Uzv
	R4zfsDJ+7KVCBIQqEH0KUA2mBV8RGsP3L5NfdlCw5tzuyNlvZIjoNYGpRv1Frfzs6mmbhlAdeon
	H9XWa4Z8e1dDZMz+K0DcHtFES/sfssQcF4k3p8aVnVcqmLLd/6XFNYg==
X-Gm-Gg: AZuq6aLhKpoWj5HXpP7y0LPqb2ss2L2LKfJGVhfY7Ox7IkYrPzZes/wUYnNwQfuQy25
	1rMYhze2gtIN0XsVhXXlBoJuoJOG1n3+0lcDOSEWCzocojizFmrEa4cX8vGaSJ21Pgz4pBttPmA
	eolGetEtopd4/NGJfMVqPZbY64Pdnk4+JnPXqLaQdbVUbPn64n3iuwik6D30rRYcRS8I83+gDPp
	u4338spRE7Ku8gsP6hCHyeJLEE9Dn1iUsokHnHbHFUV1vbbzN7ok7cdyum32EDi3kj/RhSyRRxJ
	Yp7B5mwGOK0xzjEaa8EEjdKytKjlRqkMVcy9rbI0mMUSynemyEQIfUFt/MTbzQc2A/J0AwziFGm
	qfZAKU5M=
X-Received: by 2002:a05:600c:4e43:b0:477:73e9:dbe7 with SMTP id 5b1f17b1804b1-4801e358875mr290739725e9.35.1769078617730;
        Thu, 22 Jan 2026 02:43:37 -0800 (PST)
X-Received: by 2002:a05:600c:4e43:b0:477:73e9:dbe7 with SMTP id 5b1f17b1804b1-4801e358875mr290739265e9.35.1769078617247;
        Thu, 22 Jan 2026 02:43:37 -0800 (PST)
Received: from [192.168.0.9] ([47.64.112.255])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804252b02dsm49755985e9.5.2026.01.22.02.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 02:43:36 -0800 (PST)
Message-ID: <130b8f26-2369-48f5-bbd6-e27210707b9f@redhat.com>
Date: Thu, 22 Jan 2026 11:43:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Call for GSoC internship project ideas
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Stefan Hajnoczi <stefanha@gmail.com>
Cc: =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
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
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <aXH4PpkC4AtccsOE@redhat.com>
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
	FREEMAIL_CC(0.00)[redhat.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-68873-lists,kvm=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thuth@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,qemu.org:url]
X-Rspamd-Queue-Id: 02F2A658DD
X-Rspamd-Action: no action

On 22/01/2026 11.14, Daniel P. Berrangé wrote:
> On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
>> Hi Marc-André,
>> I haven't seen discussion about the project ideas you posted, so I'll
>> try to kick it off here for the mkosi idea here.
>>
>> Thomas: Would you like to co-mentor the following project with
>> Marc-André? Also, do you have any concerns about the project idea from
>> the maintainer perspective?

I'm fine with co-mentoring the project, but could you do me a favour and add 
some wording about AI tools to 
https://wiki.qemu.org/Google_Summer_of_Code_2026 to set the expectations 
right? Since we don't allow AI generated code in QEMU, I'd appreciate if we 
could state this in a prominent place here to avoid that some people think 
they could get some quick money here by using AI tools, just to finally 
discover that AI generated code is not allowed in the QEMU project. Thanks!

> IMHO, our baseline for functional testing images ought to be
> a Linux Kconfig recipe used to build a dedicate kernel, plus
> a busybox build for the target.

Not sure if we want to add kernel compilation time to the functional tests 
(even if it's only done once during the initial build)...? That could easily 
sum up to a couple of hours for a fresh checkout of QEMU...

  Thomas




