Return-Path: <kvm+bounces-18745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5728FAEC8
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 11:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A858E283714
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 09:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05865142912;
	Tue,  4 Jun 2024 09:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bDDtMG3h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C773713B29F
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 09:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717493414; cv=none; b=AJ4wK9pr2srn77pc1N2afquBSHawEaJ+O619VaxMQCROOUWKU6Xgb7bsGbfe9IQvqcgLeYxQ1n+w5We1drsJVX0RlOJjvJI++Zm2SxNtUOZQSznY1MBHiWqaC6k6VKfhExLC4+TEOnZ2Qj2BSZlcqVlas24/+4Z/q95LBGyCMZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717493414; c=relaxed/simple;
	bh=2rBvn6IyrxPggsuq7MCJP9Q2ETBzdicYGZqsK6LqgZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n17f1dXBuib+3hYeeLYufq7su9aCV6dKoKHyYPobQ9TW7akKyfx/RLDJPM8XUFA2m8mAIx5d1H+n8QUYCLbCBYenlkc0ugsvqaDdb1wImPbWE2w3emLOShKBCxK+Dh2k54yyudG2uJRbT+PnfuX1yxaxXFblsFhIYYuN25XWpjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bDDtMG3h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717493411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MA4RHWZZB54ixFBmFLeYFMF5rjCaK/BoxxohQcDKxyU=;
	b=bDDtMG3hQeEVL5A1E+gIBAVmdIcf9Al9qDZ91syx2RZV4tclvCTJZSYagT3YO4puSkxs0j
	ha6W988B+6efyyfcucAOIEoVKo9yqwPvUTnOm6yi4mqrAjK6RPNyyfSdRv2LYngehk1MRj
	BxFEF7Riku+rUtry8PLVDQNJSDcSsmo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-rR2s121MMUKfjRmH7VRnpQ-1; Tue, 04 Jun 2024 05:30:07 -0400
X-MC-Unique: rR2s121MMUKfjRmH7VRnpQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-43ff59d5ea1so41545081cf.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 02:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717493406; x=1718098206;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MA4RHWZZB54ixFBmFLeYFMF5rjCaK/BoxxohQcDKxyU=;
        b=wr3V8MAa/o/1RWnEeJCxYCI0x2Y3t1UzCij4/YobKAxNaRs9cwcZYdWwRMa51u+11z
         MirTFxMddL6WNnHn3zCwagbpwNpg8MxAcDvlwFjQWgNnv8U76UTxfL5W0OtlUs798p0N
         2Pww5WWawBKC17FV4UWtlBdF3hDO464eNy3lHvX++OMlFnROkN7l1yJM0TQjGy+PxU/p
         +fuxQAV9+dTOmoEOkmL5sa17UWhRfMrex1IxxDCK4POmR1rpSLky43D6lKvpe90VAumH
         i/+Q2JiiBEQfAY4SsrKNdUB6UWgGP508lzD8YFD5cwqSfEC6bTRnYSa/wCYJDnSS+uJ8
         qXEg==
X-Forwarded-Encrypted: i=1; AJvYcCV1945+GG3S+7cCnbb7W+VOre43yzYJoL7osWAHZyMNHbiw0CEyTnSOjsZfWcCHFHPlY3cWwNtvfPhb5vuWrs0IYa4t
X-Gm-Message-State: AOJu0Yw9vZNJBBtdwBC5iScOPHWNFQeTCVaaj0XhiRxOoor2Y7Wcoysf
	b7xhBF9UcqtezI69duVYvV6+fyhQR1lGpm0musd+o3dg8Y8jvE4WXBKTZameHizV2pFScPgiOqX
	/0kkRdPZom+xEKt/VBHUbAdD6EcEnhKZzUw5kM8mhSN4ZnjL0Dg==
X-Received: by 2002:ac8:5883:0:b0:43a:b9e1:3891 with SMTP id d75a77b69052e-43ff54b0438mr141778941cf.51.1717493406467;
        Tue, 04 Jun 2024 02:30:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMkEAtB7RruHSjWKVOvxu3ERjIritloNIPoq5U0VtMPdW10N6VEvQBVn65vdmwFCf1bF++AQ==
X-Received: by 2002:ac8:5883:0:b0:43a:b9e1:3891 with SMTP id d75a77b69052e-43ff54b0438mr141778711cf.51.1717493406166;
        Tue, 04 Jun 2024 02:30:06 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43ff93062c7sm42624171cf.30.2024.06.04.02.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 02:30:05 -0700 (PDT)
Message-ID: <e09fb9e6-c077-42b1-8c00-b5fd6ae29b83@redhat.com>
Date: Tue, 4 Jun 2024 11:30:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 24/31] common/sieve: Support machines
 without MMU
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-25-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-25-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> Not all powerpc CPUs provide MMU support. Define vm_available() that is
> true by default but archs can override it. Use this to run VM tests.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: kvm@vger.kernel.org
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---

Reviewed-by: Thomas Huth <thuth@redhat.com>


