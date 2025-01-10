Return-Path: <kvm+bounces-35027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11029A08E57
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:46:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB782188B60C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D58E20ADC9;
	Fri, 10 Jan 2025 10:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="p+9k1nB1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE112054EC
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 10:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736505953; cv=none; b=XN9gQouPOTOT00D6ROZKEg/NYpYMMNE5KFHfZ8JWDauBNyF4PRBDs3oQDqaCvbawULi2c2Edt/hVxnvi2G1hxh2yzkXMF7d8oDc5DUcdqdeEyLC3jQUm+Qzdar8lbhGw0Gw8YwIcfmXezFNcWTjvNOrmIiZpt+1iPWDSG3141y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736505953; c=relaxed/simple;
	bh=xwTt7EqwBQG9jsW/MlOAUi0BI8IrI3gTou3huVPPuY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kEOnxYHQ0HipBQFU0SRYAQINefZKfilMxznJ+sddmW4kXfod9KqfSWI+Qun3JTW4bCxHsKi7/ZHDxVq489CqlW6V/QEco6Y1IMdUIH7cnXS+roe+O7C7krPgoak75MFDEAuiUz/Q6TCkhJUsQH0WcXrchN2E3EhXTg/yHuFQcx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=p+9k1nB1; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2165cb60719so33092365ad.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 02:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1736505950; x=1737110750; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lsqFmJrwySuAsgeQ23Hdp8zYfHgcqjGeQVThq/MnWD0=;
        b=p+9k1nB1y1wLV4WAMd6GxCzPpVGINnfcjx4nS24pw7fZ/hn3Ly9tYIkV5IySy0AbyK
         aOXcSz4wHFF9tbEmM93KdWsCVwG5WqVjTyWSOk65sD/ojHlm9ICq09k1pWkhKAleJW2Y
         GTpwiuoMSgAUOr/YqrhWk0gdTtaC6LTn5HtGSjUDFQo8I1HMsLOeti+9umCaqx44hAZc
         QTyJXAhs//a1i3RM15mcLV/fA+lMeyVQITdrIQtXuahzFtoXTgRyQ4kghTD5jz7Z9KMq
         0wMQx+ee12Ua1YNIKaehndgJ07Kvrs3dmjzDAheUSpLTmyVK9vJRpmy333GkrjNXUT/F
         IiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736505950; x=1737110750;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lsqFmJrwySuAsgeQ23Hdp8zYfHgcqjGeQVThq/MnWD0=;
        b=rUAfwvRp6DVkVHvmRSkqtIV0HAxTmm+vSHpIc1E3ogSWuVHplqNbmoTn3BoPNtasyr
         LA4uMbAul2m0AlGSGYZDI+jawzlHGTy5+4BDVp9G3gQdaEUrnYOUpr0jzoUG53ffRa+y
         yW1kvWZWojeD4XwQQSbFHnVq8dikjLqGeVuWHpiAnjDtt9Cw2sfQuxqXlJE+D6M6JNJU
         odc+l/8FlrD5mS9G8igwJSMYh6hl9rTjG5wNcMzVT4aZ1gxXsXazdbU689iQziPDEcAu
         gUIkzrleuwlyt9tt2+IGobw0toweVboT1Ca5OIxUr2Q/csBqB7a/YdjkC9aOkgKeWtbM
         xWEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhaTthcJGy73R0zaEzRlMQlBtiowkvcy9b+vwkp+T6lWRS33D++USfrF2/ulu4RelYxTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzNDL0iRFn82MNhK8CNRoLiSoneK/uMJkrz7prLLnfQUFWdTDx
	Rkefb0Ibs+m/RGc8JuwskXVNX0hfIyqAvslYygEDWrpo9I1H0RwKj13m2Udq4Aw=
X-Gm-Gg: ASbGnctOiaN5M5Vq9TPD7Fb9e2nYeldPWKR1AW1IoBAmFUx8Lkpw1KEte7SBhoXTdCY
	mKfvOsGroRp4+QmzpHs29xwEwrW2ST927+qxPjsvhdRknFaZWvUrKxCOuaoDGjXS5eY/NWpxTdZ
	QhYpLQ7pGp+NQKdgBJgOn4FlZvjk+FdLb1Bj7+eOw4fFjtNrDoUhsZLMX/ukLlW/CRWyncOQfJg
	kedBq/6RLOa0GhfIX46sQH9k5T/6eMw2bt178/jPy8R4EBFL83rUvcEAQCPDoJs8L0=
X-Google-Smtp-Source: AGHT+IFPsdQcQ1JqLrS7hF+DlyZPpDcSA6WD6jF46cfVg9u5bIjzxZ5xlWPHe2yN4Ld9eivHDLICVA==
X-Received: by 2002:a17:902:ecc5:b0:216:7cbf:9500 with SMTP id d9443c01a7336-21a83f36df7mr150799945ad.6.1736505950548;
        Fri, 10 Jan 2025 02:45:50 -0800 (PST)
Received: from [157.82.203.37] ([157.82.203.37])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10e0dfsm11714655ad.41.2025.01.10.02.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 02:45:50 -0800 (PST)
Message-ID: <3a5001b5-9a07-4dfd-8cec-1e5f7180b88a@daynix.com>
Date: Fri, 10 Jan 2025 19:45:44 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] tun: Pad virtio header with zero
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 devel@daynix.com
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com>
 <20250109-tun-v2-2-388d7d5a287a@daynix.com>
 <20250109023056-mutt-send-email-mst@kernel.org>
 <571a2d61-5fbe-4e49-b4d1-6bf0c7604a57@daynix.com>
 <677fc517b7b6e_362bc12945@willemb.c.googlers.com.notmuch>
 <5e193a94-8f5a-4a2a-b4c4-3206c21c0b63@daynix.com>
 <20250110033306-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20250110033306-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/01/10 17:33, Michael S. Tsirkin wrote:
> On Fri, Jan 10, 2025 at 01:38:06PM +0900, Akihiko Odaki wrote:
>> On 2025/01/09 21:46, Willem de Bruijn wrote:
>>> Akihiko Odaki wrote:
>>>> On 2025/01/09 16:31, Michael S. Tsirkin wrote:
>>>>> On Thu, Jan 09, 2025 at 03:58:44PM +0900, Akihiko Odaki wrote:
>>>>>> tun used to simply advance iov_iter when it needs to pad virtio header,
>>>>>> which leaves the garbage in the buffer as is. This is especially
>>>>>> problematic when tun starts to allow enabling the hash reporting
>>>>>> feature; even if the feature is enabled, the packet may lack a hash
>>>>>> value and may contain a hole in the virtio header because the packet
>>>>>> arrived before the feature gets enabled or does not contain the
>>>>>> header fields to be hashed. If the hole is not filled with zero, it is
>>>>>> impossible to tell if the packet lacks a hash value.
>>>
>>> Zero is a valid hash value, so cannot be used as an indication that
>>> hashing is inactive.
>>
>> Zeroing will initialize the hash_report field to
>> VIRTIO_NET_HASH_REPORT_NONE, which tells it does not have a hash value.
>>
>>>
>>>>>> In theory, a user of tun can fill the buffer with zero before calling
>>>>>> read() to avoid such a problem, but leaving the garbage in the buffer is
>>>>>> awkward anyway so fill the buffer in tun.
>>>>>>
>>>>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>>>>
>>>>> But if the user did it, you have just overwritten his value,
>>>>> did you not?
>>>>
>>>> Yes. but that means the user expects some part of buffer is not filled
>>>> after read() or recvmsg(). I'm a bit worried that not filling the buffer
>>>> may break assumptions others (especially the filesystem and socket
>>>> infrastructures in the kernel) may have.
>>>
>>> If this is user memory that is ignored by the kernel, just reflected
>>> back, then there is no need in general to zero it. There are many such
>>> instances, also in msg_control.
>>
>> More specifically, is there any instance of recvmsg() implementation which
>> returns N and does not fill the complete N bytes of msg_iter?
> 
> The one in tun. It was a silly idea but it has been here for years now.

Except tun. If there is such an example of recvmsg() implementation and 
it is not accidental and people have agreed to keep it functioning, we 
can confidently say this construct is safe without fearing pushback from 
people maintaining filesystem/networking infrastructure. Ultimately I 
want those people decide if this can be supported for the future or not.

> 
> 
>>>
>>> If not zeroing leads to ambiguity with the new feature, that would be
>>> a reason to add it -- it is always safe to do so.
>>>> If we are really confident that it will not cause problems, this
>>>> behavior can be opt-in based on a flag or we can just write some
>>>> documentation warning userspace programmers to initialize the buffer.
> 


