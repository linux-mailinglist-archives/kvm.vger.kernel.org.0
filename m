Return-Path: <kvm+bounces-52513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2401B06210
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31C601AA20FB
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 14:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652B51F3BAB;
	Tue, 15 Jul 2025 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmFbwg+n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4CE1E1E16
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 14:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752591169; cv=none; b=bCkHSSK5abAbAfEZgVeObFwhVWydkiXnOM1dOoJWD2uF8t3erd5DMfHxVYTobhKA22wNQjgAnmpCax+kdwA+A7Fl6s6NeaGBos2ov8XS+G9WnB1DzBT+t7o6vheeSnAiimZFWDReuGr7ho1/gyP3NBsBFapoIAXQ4WmK9D/3wCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752591169; c=relaxed/simple;
	bh=uw5AthP+xve8YAAuQlwvGc0h5oJLR8XoQSTCG9P4yK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GLST9nvvPSUc9/wRRTxfaYHeNCCYj0o9c4bLUvxfYEjH/x1Sjd37SqzNFORjo8UiSejPq0owyHseDf4piKajZR/HZFZd9ZmalMVWUne5EEvMvp3mUS4Duj+FbFRevfENjWejBKxfYSsps4MX7RKTN+2zqk3gbOf8AIhs8lvo8IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZmFbwg+n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752591167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bxQZ8Hie5T3HCgWx3/R4T32KxcUlxdlQ0fcB+aBwW1M=;
	b=ZmFbwg+nL6GcWGcXsHrd8BPB02YwA2fmUuMmDL8Ukw6BD02i4KNT7vemMs/JpncnCbY2It
	XJm7j2E8sl+da1Gc7ZURI84VAh9L/kY4Yk/WF7KYajZFeybFGqxfQk9yIhY+LXWf25JRts
	UAA3ct6A0ASX9JiLkJVTV/nEVvx+dok=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-A1jUVEOWO3KCnSd66ZAWcg-1; Tue, 15 Jul 2025 10:52:45 -0400
X-MC-Unique: A1jUVEOWO3KCnSd66ZAWcg-1
X-Mimecast-MFC-AGG-ID: A1jUVEOWO3KCnSd66ZAWcg_1752591164
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f85f31d9so2200954f8f.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 07:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752591164; x=1753195964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bxQZ8Hie5T3HCgWx3/R4T32KxcUlxdlQ0fcB+aBwW1M=;
        b=Z5AW55Dxv23nlKDQH2Y7gobuVDYiAx+GHWAhPyNgyrSLChnjqF/isZ2ObCvyUTi+ys
         +4rkIlXBdifP2yeOyDy58sv6Qu8dPe+UJOMZVRYBqDum9CYt66OiegkaY7MdIUPRRdM1
         TfCI2lElX8srsGwytfq3t1GDYhJQVae4z4+Rugdw4nJCZIwinW1VW4pg5ZHhQFr2c9Y9
         JCRIJcbqekRS7VtY7DGW67GV3oCKzpW6CvCuQIGnJNeA7wSS/7Xr1pF1QfZkJJ0TuUeg
         plVQnT5d5IdDtKDoXT2BcOIcFS3cjFaRCUbM0RQHBM51o4MQjqWNFSnsl2N+1Z1kXAeD
         AUZw==
X-Forwarded-Encrypted: i=1; AJvYcCUKoVNkEgd5PUHsmU4li3y9xZuSwER7JQv9XVEZqNKz+nZZptVkW4w3e7bOZtvFBVv4afs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhqhK4oprpfq4ncOZI6SeToPtU6j0nVXiqVCa4uLUK0FDljEMl
	ObdzJWD0jrpYtDnMWZLQBMGQ5BPI+p5WM1eTZiBq7HkcFUuARGBKLkLr3FtOXznu8j7X336xnsN
	ZqhswsTdzzC7wj8HfM1XvfN7Oqql2zHPbsb5ociVWKDKXdKVZT3jFjA==
X-Gm-Gg: ASbGncuNIUJ+2yZC6bU/lZEX3lt3u4Sd/W2/lccEBEUrySD9Ik0bU1nmoTSDklY+vyq
	8LIHRGSwfP/g4vDzF4aCdWP+1ZgxzXc/DC65uruYxa7U3V3hpXjLdK1xe4WA9h7Fs5nkrz/ZBy2
	Xy6qdB8jvc3rYdKZSxG0O+J8k5U84nszd3ds6ZKZVPdQKNxYdEfKA1JiyenHifuxxlcCpHTeoE/
	2uMPLEHu651n1deCfXwBtc2bJP/EbsgKQpT98TwJF9wf/wBAJgu/2gXAE60oTJz6MtG7rJfAfRM
	Y+4obIbhf9/TTsJSsvd600Sh2WzyP4KEdBrI/bzYeXRyKA7DoR9hjp3z8+mqDxdnWauwww37AZx
	2fefA90DwQiM=
X-Received: by 2002:a05:6000:2c08:b0:3a4:dc2a:924e with SMTP id ffacd0b85a97d-3b5f187b273mr14409316f8f.6.1752591164409;
        Tue, 15 Jul 2025 07:52:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHvBquKJxzCWKzr/INp7RLFyz+PGA2ulyXDvLI1kn0nN13gZk4ELGhhUPuBfVbo9Gg/8knmQ==
X-Received: by 2002:a05:6000:2c08:b0:3a4:dc2a:924e with SMTP id ffacd0b85a97d-3b5f187b273mr14409291f8f.6.1752591163964;
        Tue, 15 Jul 2025 07:52:43 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8bd18ffsm15081072f8f.9.2025.07.15.07.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 07:52:43 -0700 (PDT)
Message-ID: <bbf7744c-9340-4d59-804b-87f7ff9bdcc4@redhat.com>
Date: Tue, 15 Jul 2025 16:52:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 01/13] net: bundle all offloads in a single struct
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Dmitry Fleytman <dmitry.fleytman@gmail.com>, Jason Wang
 <jasowang@redhat.com>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Luigi Rizzo <lrizzo@google.com>, Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>, Vincenzo Maffione <v.maffione@gmail.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <6e85b684df9f953f04b10c75288e2d4065af49a2.1752229731.git.pabeni@redhat.com>
 <d434b098-aebc-42cb-b589-d84f7bd78c21@rsg.ci.i.u-tokyo.ac.jp>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <d434b098-aebc-42cb-b589-d84f7bd78c21@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 8:36 AM, Akihiko Odaki wrote:
> On 2025/07/11 22:02, Paolo Abeni wrote:
>> The set_offload() argument list is already pretty long and
>> we are going to introduce soon a bunch of additional offloads.
>>
>> Replace the offload arguments with a single struct and update
>> all the relevant call-sites.
>>
>> No functional changes intended.
>>
>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> ---
>> Note: I maintained  the struct usage as opposed to uint64_t bitmask usage
>> as suggested by Akihiko, because the latter feel a bit more invasive.
> 
> I think a bitmask will be invasive to the same extent with the current 
> version; most part of this change comes from the parameter passing, 
> which does not depend on the representation of the parameter.

Do you have strong feeling WRT the bitmask usage?

Another argument vs the bitmask usage is that it will requires some
extra input validation of the selected offload bits (most of them don't
make sense in this context).

Thanks,

Paolo


