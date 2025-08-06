Return-Path: <kvm+bounces-54107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2800B1C4A0
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 13:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A0C656097A
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 11:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8E428AB11;
	Wed,  6 Aug 2025 11:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVV6SRq+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE5F18035
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 11:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754478626; cv=none; b=U34biVk3scw/vyAF8h4xB8yKqVfM2NR+Xvv4l9kYPyRnA3k7fw0/dSnAoGqoF9cKhuoVMnHhZtJl/LMmNztI1YIMkwN2nShrqZokOyT7lNQGaJvp0A0+6Nw1SwoYc6Kn3CcVPz00ZZPjqxZLsnXgwSGFjlCQDePLRtXTPt1Gy/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754478626; c=relaxed/simple;
	bh=GxKLud4jcr8g+22R+KwttLpr71c+aSuT7ZFv+s6yU7c=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=aHgZB4aRw5sXCU/HI2A2lkacC8crBRbHq5jWoXbUOOpJTuHqLeqsn6L7dYZ8V8Ssw77lXCDR+WBUJJpsxNhAV7dBqSlEfzEyNma8ZBmvTaDYzOQEQwPsCHZm4biGtn6s122XQZRLNtxgg2tZKtkOWkukq2SsERupTh5reLU8sm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KVV6SRq+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754478624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=XAY7c1HtX60oJJVxckLBFD/t6sL+wBhfaXA+lmyJDz8=;
	b=KVV6SRq+dBg0pyRZzgVDGi5X/ezrhDcYObUk087uw625zSdUZ0s/+x51HWZr7oXX3CzVMz
	6N/TIM/w42ZNGW0Cpd3Ecb/kKkp/L4061hECF7n3YL00HeR24q7Tif69fsgFDXN+++XUrt
	vSumAKn440avHc3Q8VpXnSxGrbXjAg0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-WYxA8aibMRe--rkuo3YNXw-1; Wed, 06 Aug 2025 07:10:22 -0400
X-MC-Unique: WYxA8aibMRe--rkuo3YNXw-1
X-Mimecast-MFC-AGG-ID: WYxA8aibMRe--rkuo3YNXw_1754478622
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b836f17b50so2881193f8f.1
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 04:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754478622; x=1755083422;
        h=content-transfer-encoding:organization:autocrypt:subject:to
         :content-language:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XAY7c1HtX60oJJVxckLBFD/t6sL+wBhfaXA+lmyJDz8=;
        b=whGKjDJvsYKxUuAf1QcQgZerJamY3vYuozInU8rQsw6341WyuKk0JgTEC7dL2pDKox
         ZZuDkc5dy6ZBxjIGEjikWVViv1S0TRZ3jW093UXlhToNpjk9H8mpFa8+ZX+xUmRSbFfU
         FAym6Eh5ZYr7SroNstKdKV8kRpd/+nKRqYg3mMAUz8UJRtJkQbmSYCrvbVjiZqAKgY3w
         ytDkviaHAGHR6K4O6TKSs7J4j4wVye1u9Hf69RX3IKKmaKNOWwzvZw6Drck9AlZt5cKO
         AlMW0DJ7+SjXEW++Y/R+knrLylfk81kgaenU/HIApUbdYfFGoXztarYz8JoRzBLynPM4
         Chnw==
X-Forwarded-Encrypted: i=1; AJvYcCXS245tf9tu4J7dy/FbPRmpjjaPtp986HssaAi0Cdwlb2g92sF2XpUY3lAHs9SxXRexaZs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8ZW4m16qAjxSSUr+qTiWcYlh+IJm2CnXAveoLZVAWJ+/Wx9MJ
	5GiaqLcJwh5MvUbYHWnYi4TVCoOG1zpJl2yEe15q+7acUM76elMkLn1GpbUlw9HQIADiaU6ffI9
	5pgrv8lEXIyFjulxiZx+XtaFw9EOp+5neMeDUqzxSLskAUY7DkIbDqQ==
X-Gm-Gg: ASbGncvnnhprSl5KPJYZNCidQj0nEX8CQ2gMPbykYax9uu7lqIjIedIWr7w3I/fq6FU
	mOzlttmEKix69L3KT6zfoVr9rbsL4FllcnNMgHC27lhYC5xDEUrqrfhSWr8os2T1rRdiwdc82pq
	dm1GAakriwsveN+9G+kgqGDvYJRUnO7UwA0jNnBktwpjyYazOXhr3RVe/Fvfv47YpGTP8YuVAUr
	CiukTqB9LJGouXNn7gEi8BtmSuApGvexJXXKg4jcFZhB78Sic7ncD9Uws0VE53dmTlH1wStraLR
	5ttSUob0df3ooDSImasAEN712wUrClgC90vfSOzt/S/6vLpxPW5V5PNFFoCGPhtgUaRrXGJXk8o
	sM3om6htvUyl0LyadjN5N7POVtXYuimL6Z48o5/OLupAK/URIAtkLVPZ8c21Vbqf74X8=
X-Received: by 2002:a05:6000:288d:b0:3a5:1cc5:aa6f with SMTP id ffacd0b85a97d-3b8f41ab508mr1975863f8f.34.1754478621327;
        Wed, 06 Aug 2025 04:10:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQzGmG7gVuLaEDM5KBNP9RBSztU6v4bneU6B2Iy0jHsPSiD9zV/vDYLW9EhPrxzI/pFKH+Bg==
X-Received: by 2002:a05:6000:288d:b0:3a5:1cc5:aa6f with SMTP id ffacd0b85a97d-3b8f41ab508mr1975811f8f.34.1754478620676;
        Wed, 06 Aug 2025 04:10:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5862be7sm48237635e9.15.2025.08.06.04.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 04:10:20 -0700 (PDT)
Message-ID: <92ebd740-2dec-4531-ae91-0591eaaf6281@redhat.com>
Date: Wed, 6 Aug 2025 13:10:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-08-07
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday, 
2025-08-07 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

For now, it looks like we will be covering in this meeting:
* Using VM_PFNMAP for guest_memfd HugeTLB support
* More on memory failure handling

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

Cheers,

David

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing


