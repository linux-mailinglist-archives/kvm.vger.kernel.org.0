Return-Path: <kvm+bounces-68875-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uM51MPEDcmmvZwAAu9opvQ
	(envelope-from <kvm+bounces-68875-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:03:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA5665ABB
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0761D8A9696
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D793930E0F8;
	Thu, 22 Jan 2026 10:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EqhzdSoQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QU2/B6PS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9017E41C2E9
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 10:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769078985; cv=none; b=BkNA+uUTHmeyuBL38UutWGfzf0tp6gQd5g88QfGCBUH5Ba0q2xoPfDVwkkhXbbMjjLF4bYqhlx7LnozvH/HsXmmYbE8dEO+8a+yRmMgvXy7v8lAaa7soBh+0KuF1WnbEcwaAmTwEr0ztsr9KWw7xzZG5dFFKuxMsJ5XdYsG/bg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769078985; c=relaxed/simple;
	bh=9pHa7bLyMeTGpz6H02mZHd7zcpWoymcyT8XHTqQtuFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hCv+Fm8PxkdnNzoIzOKQ/Rc97WxDXXQ8ZddmyZWkb3U2Lk3JK5uL+sbZwgMImGx1Yb2NDXtpaVwn/dj6yWFFbhFoknBJUEkkhsvl0HHEz3qLeEiDYzPehlbDUagih9Ot0LITuPvJ53Vizd+NimCZRI01qbS1BeOVRdpftkCHVYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EqhzdSoQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QU2/B6PS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769078982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jgIPM8OpxHeNCGRc0vlcUybvvkTGH2w92IIDkMB7o/4=;
	b=EqhzdSoQ6sUxpio/6YAntji9VLkPjX0s5navw9CtskpfR/oQFpr21assim0Upmg3jEVbUi
	cgfoBuh8jP9fmVkV8Jl6tb+mNbGPsz2Cxwa0zFqRk3kIJAqXuYkfXl0vTFotddogTXKdrs
	VhDPT6xgXeTK22OceXq6i7MrQvr5v1k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-oV1XeICVPk23Y5e5uC-k_Q-1; Thu, 22 Jan 2026 05:49:41 -0500
X-MC-Unique: oV1XeICVPk23Y5e5uC-k_Q-1
X-Mimecast-MFC-AGG-ID: oV1XeICVPk23Y5e5uC-k_Q_1769078980
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fcb6b2ebso593165f8f.2
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 02:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769078980; x=1769683780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jgIPM8OpxHeNCGRc0vlcUybvvkTGH2w92IIDkMB7o/4=;
        b=QU2/B6PShOkLwjdi8TMaeLLpdv82t97G2Do4RWGZTJHclZA6Ni17A1doAMACe+U1tT
         8WYUIHePCvBNOT5iWQaeBXRduGBOmzu0e03t3BFVEWmT2BUhkx5W/BPWVr7dn819ybfX
         OP99kqDFUrXgvMjn4y93KtUOhu4otonxYiysA6HtfQS1FxphBy3vQHOC9AbcJZkdHJDu
         U8PayWKz2TPViQoZEv79cHE4VZ/egnrd7W5EcHnE595Fe+JuFqjb8ApAatlKRp3vTrXZ
         YrIaJxy7lPCdqAg0EDjxMwEz7OdF/FD2AXuZCS25MHnZRRJ1Yn+7bAJBfKzG/nyeDcRJ
         ZFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769078980; x=1769683780;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgIPM8OpxHeNCGRc0vlcUybvvkTGH2w92IIDkMB7o/4=;
        b=HIPGAEytdJTaGcz8LRxK4kJzXONuYR3yC0ICgjYSRI4bnULKGrGYM0pj728hS5B3Je
         ntbS/hfoAPWfs30fqjIH3roc8OK4ronkwTEh2lmFPjyhg2saTNLjXIrXlRi84X5nOLg0
         iAU4qQiWh69OZb5jVY14DBuvyDDf7NtbL5sM1P/a9n1zYVT50s81VvJKnYmqzSXu5nHN
         x9EtmB9tP3GlnXYgcLtSPeimILRyK89PeW6pj+5sBnZMppGplE35S97UY4Ac9XzYSTeo
         Q9tu/VTxGcoQ958XMR3N5KxGhL7oU/7/AnE7Nyj5V+8qKiwlbwG7AP0DWkdqShqcuH6g
         Vi2A==
X-Forwarded-Encrypted: i=1; AJvYcCX5AaIdIXd9XJAtBvnnm4O9Rv5vIeabxgjl0tpzA+Lr6UZWBILeIi9ueTrPurM9JqbIuGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9EJZ/advZ9F1+wnb27/DTwVbVE6dEelxh9JYkkSUeG1+iDWND
	+Gd0UK/fOwku6qxh7Nf9oL9mKK7LKjh9fIR2nsF1cPboxJW0i9NQBF+tZN+TJseA2l24+ZHXYJ5
	VO74CIVYquk5BFBjfzRM//Ht2Of7BSZ7FwY2IrWGtcW/qgQQLaMdwEKc8ZLxNaQ==
X-Gm-Gg: AZuq6aKss8wb7qjcj9xU3zvXyTfR0RGZeo9GM6/GLLKheS984dGa3NdT/4YJCmI53M1
	TL65+vpf6bo83z7SGYuV4utQZwvF8zhWhWw/A5wvXGZdCV4K8GGDRCtiqm+yqoZXJnlaZ1tWaRE
	Tgwkgq9gr/U4qoadwZp0396x2SUJzynOIDMcJTr/Jlk6i+c3DWopjcNeEqVIgDuDTGyfEKTv+fJ
	qxaNq4D88orcSNjMyghaSGBY+q4yVOctnd0vjqkF7PGw1yqUkUDG8NyomR9QaLLEVfwCvMGKl6l
	EZ/OZWhB2qCVLJrkYmts72288EvyyAcv8+muwxmvpglj4WPPXKR1pQMi/PA1orY0KXwPBpSHB4T
	pg/YlY+w=
X-Received: by 2002:a05:6000:4021:b0:430:f1e8:ed86 with SMTP id ffacd0b85a97d-43569972babmr29574161f8f.4.1769078979819;
        Thu, 22 Jan 2026 02:49:39 -0800 (PST)
X-Received: by 2002:a05:6000:4021:b0:430:f1e8:ed86 with SMTP id ffacd0b85a97d-43569972babmr29574099f8f.4.1769078979369;
        Thu, 22 Jan 2026 02:49:39 -0800 (PST)
Received: from [192.168.0.9] ([47.64.112.255])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43595609c8asm16397866f8f.34.2026.01.22.02.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 02:49:38 -0800 (PST)
Message-ID: <05fd4f96-9a91-4459-9166-8af2e5db9539@redhat.com>
Date: Thu, 22 Jan 2026 11:49:37 +0100
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
 <aW_4p65WIEuQO4UQ@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <aW_4p65WIEuQO4UQ@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-68875-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 7DA5665ABB
X-Rspamd-Action: no action

On 20/01/2026 22.50, Daniel P. Berrangé wrote:
> On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
>> Hi Marc-André,
>> I haven't seen discussion about the project ideas you posted, so I'll
>> try to kick it off here for the mkosi idea here.
>>
>> Thomas: Would you like to co-mentor the following project with
>> Marc-André? Also, do you have any concerns about the project idea from
>> the maintainer perspective?
> 
> The idea of being able to build test images is very attractive,
> however, actual deployment of any impl will run into the same
> constraint we've always had. If we host disk images, then we
> have the responsibility to host the complete & corresponding
> source. This is a significant undertaking that we've never been
> wished to take on. IMHO publishing images in GitLab CI won't
> satisfy the license requireemnts.
I agree, and I think if we go ahead with this project, we should not use the 
gitlab-CI to build and provide these images. It would be better to build the 
images on the host that runs "make check", similar to the precaching for 
assets that we currently do. The built images could then be stored in the 
local asset cache so you don't have to rebuild them again the next time your 
run "make check". Does that sound practicable to you?

  Thomas


