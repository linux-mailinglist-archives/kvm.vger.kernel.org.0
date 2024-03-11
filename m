Return-Path: <kvm+bounces-11542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D41D287813B
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89BFB285536
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126FF3FE28;
	Mon, 11 Mar 2024 14:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bOcJSvXU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBA63FB81
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710165819; cv=none; b=BzeFw9qa8lZiYhGcZ25aQH2kQ/2QFSbSiTGZmKWOuod0I89GpWdNVsBzqSbGo/GBYswKRaBMnUa9GsmorkKqc1aH8+3qlMp/MzULVvB35yzkrTFmFVPboxevMAUHSpDn6dhnbosYpeTxOroZxHWP3WIOf3hiOlet91UH9ct6bG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710165819; c=relaxed/simple;
	bh=uFwC0wKHNXk3x4j9pEfnsufSuDKMcsLEdD2GQK6haPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JdMlokjWerMnGvw67Ijn8FSEZXovgJ/VkBfWZfkGgv8iTpj3ILVXOOnhmyd7hZFAkeHqzoyX039SvXJMpkLPxh88QCKkkakvgLN96JoihhAeus/Y8nUyc3ae1bnI+qIhl3R4CQo0w2gTcWkZg/QOAmMgpqRORWDAPqPCg+WkFMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bOcJSvXU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710165816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SpjvKzONwN1WvYedl5HUfn8KeqjVQbSv8SD0MqULuGo=;
	b=bOcJSvXUfg1Qmm7MjMy0AIk6ynEI71tiYH/Nvgc3Se+6bJou8CXHDzZ6gp4VTvmvRM8h3q
	wg4VXRmHiS3eWBZOIP2IIwUWn+FxbfNjaXqSa7MqHLKf0TMDJ05Iax//A6jSnA8NLIqXwk
	VRavy4DM8bF8+vvr1BCb1STBM5El+GQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-zpXl6FwCMDCW3tadPS7SYA-1; Mon, 11 Mar 2024 10:03:30 -0400
X-MC-Unique: zpXl6FwCMDCW3tadPS7SYA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2d3fe91d29dso34094461fa.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710165808; x=1710770608;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpjvKzONwN1WvYedl5HUfn8KeqjVQbSv8SD0MqULuGo=;
        b=az1bW20tufkRtFhPXCvD+bzIqLIaniqi4/Fyg1rppZDvZMOQzZJfOtbvJsx7Idzsj6
         341XdROZ1WUduwh4CHxYk95r++hIA2WT+bZhwyNXWAVYoETc5WAlZAfjPRxXBwLLHrDW
         yaO/eIfFu/jHcb+m9R/JA5HeqbYKJRROnTIM9VZcQT30l1pq0GsOE0cgTapwgzTNQT41
         6bPEU7ajwDHRQnN+YPHSf0gJCNINAQUPbpgGorbPeiTq+LsewDdEfRUNS/7ECZ3zngCO
         99SyvCIoZRQ8lM21Z5L3b3pq/H6AMmpdX1OOAdWTMdai2JEnldayuMMqm5eRvUjQmixZ
         NxIA==
X-Forwarded-Encrypted: i=1; AJvYcCVieI/+LAsvW4LrbqcFC+VmgzTunPgDrhlGAx+vDV1Iemnpb6k1vnOSG/ylcAB6jyLEhPVksuVikkgKxLz6EA7vppfR
X-Gm-Message-State: AOJu0Ywe2/LK7C70nDw44w3mog0SWj6FR+784mtQfqtwPKoDl6CQUr1E
	p6r9R3aUvWE9zgC40bnvjuNu5YknXHB4zDMmVbIGli10+q1+UzzK1no9KialWOjZcMRFGvUXmL0
	i/wXJ0TrQvaOblZxABOU4Ef26UKjLEOtt51x+hDeEc+k4wDTkJg==
X-Received: by 2002:a05:651c:14f:b0:2d2:abf0:1c0d with SMTP id c15-20020a05651c014f00b002d2abf01c0dmr3939177ljd.47.1710165808452;
        Mon, 11 Mar 2024 07:03:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCA2GUDM9NamsljAMo439WsiCclbH+XYQaf2bCUMQ8lybA4XqUzWWAwlx0Cw9i8NHaUvaAxg==
X-Received: by 2002:a05:651c:14f:b0:2d2:abf0:1c0d with SMTP id c15-20020a05651c014f00b002d2abf01c0dmr3939164ljd.47.1710165808078;
        Mon, 11 Mar 2024 07:03:28 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id b2-20020aa7c902000000b00564e489ce9asm3016297edt.12.2024.03.11.07.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:03:26 -0700 (PDT)
Message-ID: <bf5b1b4a-dfa2-4cb7-9f86-f5565bda2aab@redhat.com>
Date: Mon, 11 Mar 2024 15:03:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.9
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
Cc: ankita@nvidia.com, bhelgaas@google.com, jingzhangos@google.com,
 joey.gouly@arm.com, maz@kernel.org, rananta@google.com,
 rdunlap@infradead.org, seanjc@google.com, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <ZeyQ5TK3pULYc32o@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZeyQ5TK3pULYc32o@thinky-boi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/24 17:40, Oliver Upton wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.9

Pulled, thanks.

Paolo


