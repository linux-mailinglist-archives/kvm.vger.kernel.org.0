Return-Path: <kvm+bounces-47115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC2D6ABD6B2
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 13:25:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 294F517FE17
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 11:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B82A27CB3D;
	Tue, 20 May 2025 11:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="elDCBclS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4452C270555
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 11:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747740290; cv=none; b=ZZz61h3ugwwqGxROtvpGJeVDrQFFx+cYNC0fgapDu6AJQ7zoumSxZDOWu/+oWAnj+9sJUybHf8SmgEo3ukzgXQglRcEn4mKLYmxJvHNDB0XFdBrsjetYxtROtL/YDEL4xcvs5hO9oC833hbmdVLrwMQrY0EGa7mUjMJx3M9U7A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747740290; c=relaxed/simple;
	bh=TuAIH9bfwGkhs90AUwbat8H9o+RJq1imxYa/lL35UsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cfEYYPeA0mtbdJGn1k3PJj98F0FONvJ/GzPzZjxzDyaUv7/z6JBYWvafmfGoJnqpnayC2ZimF65e2u1L4sXkYkzRLsd4cTbgth5Hucx9erefo5UmDfZqWZ39J5Q+vL5VcKdImdC0tQv44phMvMsQR3qh5jCvGwC/JMQuqGfZ3Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=elDCBclS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747740288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fe9XgeFRrKR14t48Y5t/+VDl1Nkl0xKTWni0QoyTko0=;
	b=elDCBclSAR6qvQlWcRE9E1wXas1PC4ReG1izfRpYwvxA4/Iw5Mdzmqcz4ViOrPMr3PuhyB
	ZzwJEfkPDJcyAzfgolvm3ATWd+EXGG9cN02W1IKXlc69wLbXlo3HbfGFxtgiT2kfxg/msu
	yCS0jGMmUUaidY6HhlKKJufa/GD/yqA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-qeyHNs3XOYaIY_XAygQThg-1; Tue, 20 May 2025 07:24:46 -0400
X-MC-Unique: qeyHNs3XOYaIY_XAygQThg-1
X-Mimecast-MFC-AGG-ID: qeyHNs3XOYaIY_XAygQThg_1747740285
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a364394fa8so1702404f8f.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 04:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747740285; x=1748345085;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fe9XgeFRrKR14t48Y5t/+VDl1Nkl0xKTWni0QoyTko0=;
        b=L3WoSKzXi02Mx9sUJNc0Mi4Ph8wK3d73rlzumIHsGC6/DloOhKIbZv/j32us8BG7cl
         Be5In53H5Dv8Np0Md31whZF3Lzx3SMgJreEIbZE0tEqG3R066OXkzttfZm0zpOAgwCTx
         9nPksjkBG6l8rtCKc5sxqBZJKGFm1ueYAghQiGcPbcddikuGjrYj9438tNWlOCiOUnL0
         MWcNIMQZmf2ZxUe1dI6TVOR9j67RaipW/P0LAAfLnBET+tl6var6WfR2YlF0do5XzgJb
         ZjpRf94xYsrSM1QsXJaL6YhNp7uRbZUlOg+DHoM10YTl8DFvj96YtKPhVf0CW/tUEtEv
         4dfw==
X-Gm-Message-State: AOJu0YzLqSTPSqh9LnpDu79ojkRQxOFw1/FFjRq2WkHpLxBkxC6cC5nV
	eH6wJbF2pQMTBLbujJK8R0kJui/efj6L4G/VwIpEb3v0hAaBwYcJAaNwgg00GcHfKERNjBLGHne
	Pytd8QrUIn2vu5p4lkjXJhGlF+RkJBBukYvdDNxhWawAqurvh3i4iSA==
X-Gm-Gg: ASbGnctVrPDa6A57kSIQb2VzCwQ++aGqdW91Ev2eywo0qjn5xAZssZ5o4arKbRRJ7LN
	avBiRCanvj2miJU5l9CFhPEkyyjDu6oONSrm4S1gBAkUOvr23QoLqi2+Aro19SBwFKJTYR4B6ua
	icNz3O5EWCCwY7gOcC/kRefHE1Ee273tm1eMcQlCHbWFZ2+rp5bm9o2STsGZUTPPSna5T6BksoR
	QclPNCh93aF553m17c1Xsk/WdJdCBb8mhktAKNeJf3C3PFEZ6WQmNNM8CgbtPF+4VX1/GPpYf0D
	EEWq5hLQu2SzYBjxJNg=
X-Received: by 2002:a05:6000:2304:b0:3a0:b521:9525 with SMTP id ffacd0b85a97d-3a35fe65fb8mr12718952f8f.1.1747740285492;
        Tue, 20 May 2025 04:24:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEofFs1HXEriOPCetmLcj952oc2+OEDOvFvT2d4euNrXMvEB2EHBEoF9oG/uDbOigZv9W8Xdg==
X-Received: by 2002:a05:6000:2304:b0:3a0:b521:9525 with SMTP id ffacd0b85a97d-3a35fe65fb8mr12718940f8f.1.1747740285150;
        Tue, 20 May 2025 04:24:45 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:244f:5710::f39? ([2a0d:3344:244f:5710::f39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca6254bsm16428674f8f.52.2025.05.20.04.24.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 04:24:44 -0700 (PDT)
Message-ID: <0d3a3a42-4141-4c4d-b25a-3c9181d5842e@redhat.com>
Date: Tue, 20 May 2025 13:24:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7] selftests/vsock: add initial vmtest.sh for
 vsock
To: Bobby Eshleman <bobbyeshleman@gmail.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20250515-vsock-vmtest-v7-1-ba6fa86d6c2c@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250515-vsock-vmtest-v7-1-ba6fa86d6c2c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/16/25 12:00 AM, Bobby Eshleman wrote:
> +tap_prefix() {
> +	sed -e "s/^/${TAP_PREFIX}/"
> +}

I think there is no need to the tap prefix to the output you intend to
'comment out', the kselftest infra should already add the tap prefix
mark to each line generated by the test,

> +
> +tap_output() {
> +	if [[ ! -z "$TAP_PREFIX" ]]; then

AFAICS TAP_PREFIX is a not empty string constant, so this function is
always a no op. If so it should be dropped.

Otherwise LGTM, thanks,

Paolo


