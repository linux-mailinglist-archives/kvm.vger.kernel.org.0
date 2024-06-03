Return-Path: <kvm+bounces-18594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E655F8D7ABF
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 06:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D6CE282149
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 04:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73CF14294;
	Mon,  3 Jun 2024 04:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IU8xC8ys"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8926E18E02
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 04:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717388650; cv=none; b=YqgO37TFHCnMJppstkI/U2zldZ7CN7tE2LEaNWR1jmSsQUAaZtjLF0PouLjVAUgHopWakso4T4zME3+4jK5PbfqmNJHt6N0BjFJLgSaf2CIGu+7qCpLQT3yWBfosi6LPrxVXoIQ312vrM+eKYdWCCStM7yT5u+RfTATbxs0rASA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717388650; c=relaxed/simple;
	bh=sfTnllxQACqLFFLhL7b5xgimrrGv36gIKjPFavdSbng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZtJbciTACrLnsQjr2NLZaAeBZQIcTy6060kf7x/5/0DW2Ddn8XG4k5rpQiISvn6JUJpPbmGAImdOmopw1UKPHchKqnqvouG7It1O9K/0UEvgygAWX4kqm+G9V1nMQthSXZmOKIUXNFaTKWJBrwBMTpyb4hxpEXabdbB5vCgf0/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IU8xC8ys; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717388647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=inOtQfasB0+YqkiLD+iQQYNilgPVNJAWgn89BB4WO+Y=;
	b=IU8xC8yswsB1PeeE4dUlJ/qxqk7C/V7eoZhCBzb7OtKyWOUs2nQK992+8Lw5pCyLcLvvhA
	yj99owpSMS7jEaY8jbysfDtY9d2udpVsdb4VK7EmaCJGGwHi1rXyrfZKKZewBo1eEQcLXE
	xabWoCHOTVP4Q3o4wnCySVAPOXa9LUo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-OcAHzKf0Ogm_MCFTIgqFsQ-1; Mon, 03 Jun 2024 00:24:05 -0400
X-MC-Unique: OcAHzKf0Ogm_MCFTIgqFsQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-357766bb14fso1747983f8f.2
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2024 21:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717388644; x=1717993444;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=inOtQfasB0+YqkiLD+iQQYNilgPVNJAWgn89BB4WO+Y=;
        b=vKeTb9VwfPRtHojdjTOb4YtQEqtFFi9CUDET4OgxNeQWIYzEWLUL/JEw5A8TxT42je
         05+vAjmeTZdyXXNsCsZALGkfvo4tjKR9pAVeOES/X6OZSvZVDX7eLzWewqcuSC0WTzfk
         1Fts/7tx2WB6yJrkKCtOHYfFpbtwhOSWfF2zg3KNV9z+C2ITKq18isAdjOyRhUUnHUDJ
         oXH7SH0Rb4W4A+dTWUMkEyPovSUCGwpFENRzvlE2etwiHRdBDUb7p7or4zbPGEI9F9WS
         W+T8a+LeHHlAuKYBuvTkhw7xz4NwFERjEelmY17dxNtNt4iJyoTnRKDb1rMhSXKx1oAl
         Iosw==
X-Forwarded-Encrypted: i=1; AJvYcCUVLc2MlV681Tb4RXaOzkV49j8lFLAL1OgjF4FDSEzwQdb4IOWJ6sQC7rXln50oR1BbQk2TgLxnXZ0BAGegYyFRtMN8
X-Gm-Message-State: AOJu0YzMaHFzbeolgbMjBOeK4+TpFPNT282qIAdGKIyAcG1xP6wSRuU+
	nNNwKACHwKvq3IzwsK0RHlhGmDSSQVA5Xwu2/jJqIVh1wJ9wx+OlwQIIy9FGAvyYjt/EvE+lMXW
	NRIdFQE0rI6EGa9Y0Db9W7VIgtL7+YQXTRDhXPeH4FxYMsbCVaQ==
X-Received: by 2002:a05:6000:d92:b0:354:db35:63ab with SMTP id ffacd0b85a97d-35e0f2898c7mr5736016f8f.39.1717388644300;
        Sun, 02 Jun 2024 21:24:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfD8upLGGrdy43AcfGFrxoz7U9quJN60LMse+zb33yyWuTYqT/+K8m5I5PWMnvQK7rMsk7Vw==
X-Received: by 2002:a05:6000:d92:b0:354:db35:63ab with SMTP id ffacd0b85a97d-35e0f2898c7mr5736006f8f.39.1717388643941;
        Sun, 02 Jun 2024 21:24:03 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-229.web.vodafone.de. [109.43.176.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35e0f97ba3csm7110385f8f.73.2024.06.02.21.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jun 2024 21:24:03 -0700 (PDT)
Message-ID: <9dd41899-20cf-42cc-be1e-ed52e4336289@redhat.com>
Date: Mon, 3 Jun 2024 06:24:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/4] doc: update unittests doc
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-3-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240602122559.118345-3-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/06/2024 14.25, Nicholas Piggin wrote:
> Document the special groups, check path restrictions, and a small fix
> for check option syntax.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   docs/unittests.txt | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>



