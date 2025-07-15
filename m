Return-Path: <kvm+bounces-52521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B3E5B06437
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 18:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58A303AA7A0
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C56025B2E3;
	Tue, 15 Jul 2025 16:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/LbzX5Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3953824E4C3
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752596509; cv=none; b=gjElL+iVWTh2uO0YcleE8oOOJAbqVpkBLRBgKwCoJX2fXbF3uYo1Tu6VrR1TJlItJvLo+jKXghCnG8g2J1RebvXIK/YAk+phxPA69Q7rWFvMZSKVvLgg6UDG0GTbc9Tr+azwZ0iLZt232d4VZPbbCkoOt3EcNUYD/E5BBtqPL8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752596509; c=relaxed/simple;
	bh=Jt9jyTY5uhTybwRVE0s1sZLMJxoOM7qxL1+7N2ncjNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XAHNeiJEvBJ5qrtbAwLBHVAiwPQ1MB+TWod+i1JFw7TOBb0EqwrqDRIpYZASsDxs+AN8iR7djWvvKdBIYhLBWVstGnJXlYFuNzmjRxTA4LxQ0Dl3JuEWqeve3T0rDOJVTNUoQt/LUbKC8vuaJzn+imMnGlt9Q/KyYs5Xi+Yfks4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/LbzX5Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752596506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZLQKCgb3UqjKZgP7whg0mrQnuiKO/lw8RlSpFrlAQc=;
	b=V/LbzX5YN17b8T+8GkF61KBoHsaUlSqBxenDPsA0FkG0j3FS4zfgkqp5WipMmSxkMqa0EY
	7abAdtqLmjZIp/c7oCRU3M6dZwHCT9hFg7hJfsX6rTdEAwzU79iDzbaIXzB0cN4aJSzBC6
	qHqvjHn59m8wunHDAf1Kbh/JnNHN6n0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-ZvW4l9IzNnah0tnyjguUJA-1; Tue, 15 Jul 2025 12:21:45 -0400
X-MC-Unique: ZvW4l9IzNnah0tnyjguUJA-1
X-Mimecast-MFC-AGG-ID: ZvW4l9IzNnah0tnyjguUJA_1752596504
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a54a8a0122so2950113f8f.2
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:21:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752596504; x=1753201304;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VZLQKCgb3UqjKZgP7whg0mrQnuiKO/lw8RlSpFrlAQc=;
        b=oXSAGxSovLwIx5pJmwH2naT3P65qSYsp80gm046Xzss44EqggM/hyu69XkH06v0kwL
         zULC4CTqDg8p3PpVKeIhnB39tdRvVNpg+oLszauSwaaLaf27HhKkxYWfNQZ0JjTKgbY9
         KYqf283Rk17eoMAOmJYN6X416Bqs20in9UhRGv8JnTTna9CA13Q0Ajd/7q1TaABj90KK
         IRTixVNmDSQEBB1A7leqr1qu/3YhRqgeQrfiQAsy+fH9Bimz1EssDz2akI3PyzcoHp0D
         FHvrMOS6acTuU4bEeKsE70ilz3G0JTbDNMUEEnluOZWhSgGZFvDyLZV1cQ/HRp7XJOYc
         Nx1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXyIJ6GPqZ1gJUjSaOh1Y/pBa3NXxxGxigBBqkjGTZhafsKX4JX42CmNz8OGq/z1hURF+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwtU8zO9VUYuK3AAgeCsiAvB3D5uYENfhDRtEEIbaDEvumwmOg
	HJaCBx66g2evzlLZa0SGDDLNGxbleYBvLrmBylk3RnWpv99774whw52u9IVX3h1BT/KLfk7BcLx
	AboJBS+r8ynZHOwzf4N8bZdympgp323CaDqJK4vEeqI+t+nZM5dJDNQ==
X-Gm-Gg: ASbGncu5H4c0l6WVlDTSJeeF8UjlKHdY0JDtOoJpqx3fAWom0hHrROkAVLurq+4TOl2
	VQVs90ddH8bbvCW9v9mzp7xs7eThKZIOGGbqCRZrqnP8iRWHK39UGHIiOsOIkQk2O2Rq8bGjj+W
	MMfgw575dMCMTaDZ0nwPtvtL+VuVqCY4JTq2ZFU4uieiveoWaW4LJIH2v5OHPw+nziopMYYqbiy
	xIGUmlD7oFnHKXBLZSPbOArFPW6krg5cdhXMAiOV02L6Si8eCfjeWRCGflaRyoUR7wldNfu6Een
	b94DFuHJmacTLATwY9CRxa+EQCL8E+Zf4IGCwCBiuGQ+Caha0Qvfd/+q8V7WG+HS559BNbH1QFR
	ANyfCVCmKh8Y=
X-Received: by 2002:a5d:648c:0:b0:3b4:9b82:d431 with SMTP id ffacd0b85a97d-3b5f188062dmr12660719f8f.13.1752596504252;
        Tue, 15 Jul 2025 09:21:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFjcZRJiPD4zHE+0lra8fOt9B6ubbaYYVrgYE4PkZvLn9utF/Uyi12I1tJIDD5QFG+igeVeg==
X-Received: by 2002:a5d:648c:0:b0:3b4:9b82:d431 with SMTP id ffacd0b85a97d-3b5f188062dmr12660699f8f.13.1752596503827;
        Tue, 15 Jul 2025 09:21:43 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8bd18a2sm15366931f8f.20.2025.07.15.09.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 09:21:43 -0700 (PDT)
Message-ID: <f1381483-a507-4420-a0c9-52bf8131e6e6@redhat.com>
Date: Tue, 15 Jul 2025 18:21:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 06/13] virtio-pci: implement support for extended
 features
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
 <eb1aa9c8442d9b482b5c84fdca54b92c8a824495.1752229731.git.pabeni@redhat.com>
 <8af39b78-a95d-4093-b68c-20b556860a09@rsg.ci.i.u-tokyo.ac.jp>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <8af39b78-a95d-4093-b68c-20b556860a09@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 9:42 AM, Akihiko Odaki wrote:
> On 2025/07/11 22:02, Paolo Abeni wrote:
>> @@ -158,7 +159,10 @@ struct VirtIOPCIProxy {
>>       uint32_t nvectors;
>>       uint32_t dfselect;
>>       uint32_t gfselect;
>> -    uint32_t guest_features[2];
>> +    union {
>> +        uint32_t guest_features[2];
>> +        uint32_t guest_features128[4];
>> +    };
> 
> I don't see anything preventing you from directly extending guest_features.

Uhmm... I have a vague memory of some interim revisions doing that and
failing miserably (but I have no log of the actual details). I'll try to
have another shot at it.

Thanks,

Paolo


