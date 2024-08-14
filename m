Return-Path: <kvm+bounces-24183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C3D6952190
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D08FF1C2146F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9580A1BD00F;
	Wed, 14 Aug 2024 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BZTM1FSP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5608B1BC082
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723658042; cv=none; b=kngGvwd0kWTEY4iUR1RYPkFUTSazNwKyyEdQalz8Q9ANTALwi/wtk1WOAk8ZKnHyNDG2m+ySajxmNsHWv2CYYz+NERdlpqgosGL+xEZ5svVuYcpJUwv87KbUyoTQGOOogtxYlX0TQAFb7YpIK7Oez/d62JoF60B/MQqavqe9+qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723658042; c=relaxed/simple;
	bh=K9ZcCXNR6AhP16LYTClrH523SOz36Om1uAG1kkWUekA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rz7Th5Gj6p1Ffq/Yhp2aOxBn3vPlaoJK7SqF0LnhzH9tg13okxsAYho0+zhx+eoaYL/8VPOQwNpYsdbczHiZEm8Nuug5TVOOE4c0zCG6+3T63mJc9JFxc5o2SYKVJlH8i+Iziz7ccOlypYIwghyrk14CjH/0km5ODDKUlpu5bIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BZTM1FSP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723658040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aqW1pStkkqE8bSHAyK2eetUPj2vtzB+TVj0YShqKUw8=;
	b=BZTM1FSPQVW5zw/8N/grYxcDGW/1Skdz+elwCDe9QAG9wu9ZI3GUHbDHxFaM40xTO2xOs9
	AjLUFvIwy2uYzHNmdsYmQv1z38/PC7zHgTClT0vtmgsebzD0VgFgO/lgNf/oW3pFIFu+zi
	TxAhP9Isvo89im5iVmdrFyEA7kkOczI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-Zc7D2JWVM12GRGjMT2vAaw-1; Wed, 14 Aug 2024 13:53:58 -0400
X-MC-Unique: Zc7D2JWVM12GRGjMT2vAaw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-369bbbdb5a1so49363f8f.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723658037; x=1724262837;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aqW1pStkkqE8bSHAyK2eetUPj2vtzB+TVj0YShqKUw8=;
        b=bewb//BSTnKwSwvCaujAVFngr9FfkDkgsr70Yfa944/IDoqsDRa22QeWRFhsxWViNv
         T3lydbtDjEy++ZvMEMC585vnHgOdvT/AepjouQnLN/eNAW9P3q3PJmB+kEEOaNWTp9re
         FehhdF1lUbZoVWEvTsctXjGVGntKw5KQPvoLEBsgDFW84eA3akTQRen5PGebJ/FT78ID
         7AUlfH1IZXiDkk3RMdakXK8XIiBQgITal5SSqW5wjnAQUMj7T8DY7xUZSFFlaRqLhOj4
         3xHkZAncWb/XXXJ2+ToBenAYvpieOij8vKOrkmjo/mxzmvijPnNO/Xmt6fbz46Ir4rCY
         3DNQ==
X-Gm-Message-State: AOJu0YzjR7WDZsPo94kaA24sydoeZK0OVlSulWLxXm1fJvfzrv4thUdc
	hQP1zNvHLWSpQkiJ5Cn0+2Ite2RaelTCOxfbeRE69itO8UD+q1DuHhWF27TBfMk8wFZGVizvGnL
	FJUneY6dX2Qz9SBgKJT5zBCxzDB864pVmydLZsuf1z05Zhr6PNw==
X-Received: by 2002:adf:e3cf:0:b0:366:e9fa:17b with SMTP id ffacd0b85a97d-37186b85f8dmr478963f8f.1.1723658037486;
        Wed, 14 Aug 2024 10:53:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0gtugkRTcQm7G8pkJF3tmkwxTEKg02g/XJX7ambB07oT/yEXqXmEM1X4Q43rWoTjJipEklw==
X-Received: by 2002:adf:e3cf:0:b0:366:e9fa:17b with SMTP id ffacd0b85a97d-37186b85f8dmr478945f8f.1.1723658037010;
        Wed, 14 Aug 2024 10:53:57 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-36e4e51ea09sm13463097f8f.71.2024.08.14.10.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 10:53:56 -0700 (PDT)
Message-ID: <aede9ea1-099a-47db-a133-28ad22206858@redhat.com>
Date: Wed, 14 Aug 2024 19:53:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/22] KVM: x86: Check EMULTYPE_WRITE_PF_TO_SP before
 unprotecting gfn
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerly Tng <ackerleytng@google.com>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-18-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240809190319.1710470-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/24 21:03, Sean Christopherson wrote:
> +	 * Retry even if _this_ vCPU didn't unprotect the gfn, as it's possible
> +	 * all SPTEs were already zapped by a different task.  The alternative
> +	 * is to report the error to userspace and likely terminate the guest,
> +	 * and the infinite loop detection logic will prevent retrying the page
> +	 * fault indefinitely, i.e. there's nothing to lose by retrying.

Putting myself in the shoes of someone unfamiliar with the code, I might 
prefer "the last_retry_eip/last_retry_addr checks" to "the infinite loop 
detection logic"; after all, you're saying in the same sentence that 
it's preventing an infinite loop.

Thanks,

Paolo


