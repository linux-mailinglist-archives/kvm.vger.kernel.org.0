Return-Path: <kvm+bounces-18718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA9F58FA9FB
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70FBC28973D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D9513D8B5;
	Tue,  4 Jun 2024 05:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HcrOnKCE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2095113D517
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 05:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717478978; cv=none; b=c1V9oETp3Z62Gg4I00dla3rDozVyQyrpoTxUO3S2d1r4JGJwFXu9up0vQGHrEEemF+qY5/0A4gRz/CcxXG6GamswtRAU9a9h/2grGyF/z8aPz3WUAOLivq8crHjKHT67RuctGBHi/6UHt+aToCKtVVnX/3DWtExG0WpvIPkitis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717478978; c=relaxed/simple;
	bh=JVJOcj5DjZJasFgqUksRJTUnfPh1QbKusNOq8jNh4Dw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FAuOExGXW2Z9gE2fmKffVmIbmyeXzWvCMFlgG1ibCh9DbwQQXUkvhgQ6aG4b1aGlJ3pMs91es2cYWpqWLqpvKNigxqidxVz/c/zqyQoDPokbCCGlnsimHBSdLcohoWbEB2EZs7MxdY+bWpHdNKaJpHarqzpj8LGWxYSypQRRh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HcrOnKCE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717478976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uC9h8iozDq7i2RghyTyklT/3RPm/0Yb1pGP56gWrQmA=;
	b=HcrOnKCE0+jDoyNyOkz0E1b2U+RCMymCLkGlqBPf4Bu14gWcCPqCKGWM0/J+RSjzBTBDt9
	03AkpHBm7HAtMXP5dvTjJAyQzkLltLvwRtsTihcPlCCq6SmimOdy76i0WpAFrZ4T161ueb
	h3tk6VCxtF8AxPslhXZg0B6KmGvloJA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-vmarCEK_O0ms_H5FhtfcIg-1; Tue, 04 Jun 2024 01:29:33 -0400
X-MC-Unique: vmarCEK_O0ms_H5FhtfcIg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4210d151c5bso39317165e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 22:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717478972; x=1718083772;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uC9h8iozDq7i2RghyTyklT/3RPm/0Yb1pGP56gWrQmA=;
        b=ZTYXxFVjZXPRF+N5/a0jbLCmeteS5mxPtJhQfJVtQSbPolyE10puwaHReZPkdatq3O
         IJ6ITE5jfUgr9uLJifnDf8xhJ+5LmfXrknQMxyuoOpcyAQMqEMOrt3VG33fBf2SaTudq
         mB+Vr3zFqsDWw74fAB+MwW9LU5Vw+ik7lIpqo25aoSq5q6rOPJy69kAoAsAkYjYWWOlp
         kUGF3pqQbhxzNV6DNHRLoeBzIJKQD9higCfINCF3IjBevLVTOeJzwQ6zACRVRemkbV51
         dso7A23TDjcuBOmA116++hHepAMPYgzuq6qQu/O4AHHp6y9NzJw0/nLCLCfy9cY+op+F
         jI/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhnot4XWZXiV09HscKSNfT/4TmdE3X7Nsu1tiNeqybHbmliabfp47f73HWRxpHt8RJJTFtWmL92XDMjB3OeLTSIrY0
X-Gm-Message-State: AOJu0Yxg2+Exw28YWjQUZTJjAkdFbnOeikNptPwr6r7/X9ffRq6tZh7N
	xshytRqYMjybaTuoQM2osQ8JBmrx/nI7vR3qt+ZwXu9nOK8Oar56AJSYDKHmYehiKTJ+rO08/3h
	wjE+RktkwEgVoi5pH+tZqTQxEhY1XkYJw5fQ67Keulr0blmoQ7Q==
X-Received: by 2002:a05:600c:1e02:b0:420:fe60:c387 with SMTP id 5b1f17b1804b1-4212e0bfe45mr91850325e9.38.1717478972193;
        Mon, 03 Jun 2024 22:29:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKMgzkkZoe1uqtMnLBqrh3yimfsTWuU64Fd2MbFZ8XmQ0JrTTufEpon8mb25lTdiWDsPKWKA==
X-Received: by 2002:a05:600c:1e02:b0:420:fe60:c387 with SMTP id 5b1f17b1804b1-4212e0bfe45mr91850155e9.38.1717478971789;
        Mon, 03 Jun 2024 22:29:31 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42136e0d9fbsm98666845e9.28.2024.06.03.22.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:29:31 -0700 (PDT)
Message-ID: <f559f65b-a0ac-4810-bc5e-11edf46b693f@redhat.com>
Date: Tue, 4 Jun 2024 07:29:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 20/31] powerpc: Add atomics tests
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-21-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-21-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---

Please provide at least a short patch description about what is being tested 
here!

  Thanks,
   Thomas



