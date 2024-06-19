Return-Path: <kvm+bounces-19929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B47E990E4C2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 09:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 442E11F26425
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 07:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9028770F6;
	Wed, 19 Jun 2024 07:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UkTFh0FQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCB9762D0
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 07:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718782980; cv=none; b=OJmQ8jcJYsqqpHboKUgt0/VIQyA5yTkune5+0uCJvD+h3EkbBaquheMSjAt+Sq76pkbUAGAbioY25wikOJzMtU3OlziyAJMmbxJftGXil3Z1hErLr63Saj2JaGRqt815aOpzi7ijcFQkW9bzqzKjraoPvM4JV7dIw2TtRNlF1oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718782980; c=relaxed/simple;
	bh=wo8sj+P5gfd4/4MTUT2kcVpHgn4PfwmBdwy7au0uFQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SN1cwh+tA8yR7WATvF4eR6LlFi2Tj9OU+lexVoyyS1K49YK4KD2w5DgkW+ykwEin6M7t7mv9Uy4Lyze90Yk6hJx4zhkOCWfE1WbUmfVsT2NKLpwts4poTRnG8G0NVcW+yo9vRgsU0xn+Ukh3zSkPBlf6J13nAsq3F7WiOrQTdSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UkTFh0FQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718782977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=d0PCuJaFh0BeKQ6THbuGU38LurLYWx1XyWy+pWtBlow=;
	b=UkTFh0FQmhcd3LFxg+SsIqTNTC1aBq3zbs91ULxhm30YWSYh0ILpW7FrUe/K4OaGUXDTW3
	Ap5LCq3gmFNkFt2q00KWgr1c+KIUTnoR/BW8M4UzJQJ2jTk8t5TLx9QfJkJINmxx3ypQ81
	SokeKP5QAOxX9Y/vAPcz/8BiwWW9fTQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-4t24H8zZM6S4BenLvfG14Q-1; Wed, 19 Jun 2024 03:42:56 -0400
X-MC-Unique: 4t24H8zZM6S4BenLvfG14Q-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b50a228363so1441586d6.0
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 00:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718782976; x=1719387776;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d0PCuJaFh0BeKQ6THbuGU38LurLYWx1XyWy+pWtBlow=;
        b=feVUxiO0rnR8oE/METX3LuNczab75+7bltUZ6y6CQ6Vp9huK3qJS5gwqdoDDDVl9su
         xVZ+DRbvxD6Eecr0jwb1xGDMAOpUUnTNFKqIQyHfFCkh1N4M31P/m6TnH5L65L1jlGkm
         alOQ+Kt1T6CKZ98Kv0aohg44JGVla1hEovpdPgq98UoNb+nfMavlxZMcgTgTNRZEubC1
         PuabRGEbBZVyCASq2OXD22S7y43FPHZEvFcMkpSdp1ApkbCVm/M5MwA4TKChgN6kz/z3
         PPu/p87kVRQqxJMP4igYI7U3/OiQHAOCy88vpG/qB8aSzzsMmhHOlrUnfamjzZnBtZlO
         eoVA==
X-Forwarded-Encrypted: i=1; AJvYcCVwpA7da9bQhr4XJA3JnvRK6lm6L1yBas/qjWSmmJ1gW7z28Ce3zsObHcrIE+zLQJZTpxhrbEr8ozCUzOwTuCkAfkf/
X-Gm-Message-State: AOJu0YwyPLcGzN+BfzHBiDCzHPt6WJX/9Co+UBa+ebcmHwyznlmjUXCz
	wm7hNtWVvC4dxkYGI/Ed4/c4UvgluT33JAcI9Xe6cW/BaUy93oGEY/8+l9HDdYn5/72MXbQy1XW
	y70lnChBGQWhRS7Twvh0QQ48u4EKx7X8A5jUiha4VzR5i9AUUQw==
X-Received: by 2002:a05:6214:4a42:b0:6b0:825e:ab71 with SMTP id 6a1803df08f44-6b501e0298fmr19273116d6.1.1718782975710;
        Wed, 19 Jun 2024 00:42:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF57ewfsPjs9BM8HjCA0hXanIA7oYoR9WJdGRtThTNDMmLI/93qudwYeANIvuzEti/6UVRCww==
X-Received: by 2002:a05:6214:4a42:b0:6b0:825e:ab71 with SMTP id 6a1803df08f44-6b501e0298fmr19273026d6.1.1718782975424;
        Wed, 19 Jun 2024 00:42:55 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-117.web.vodafone.de. [109.43.178.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b2a5c2fbbasm73667146d6.60.2024.06.19.00.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 00:42:55 -0700 (PDT)
Message-ID: <ce7a12f2-9067-4f1a-8449-a943ebd50667@redhat.com>
Date: Wed, 19 Jun 2024 09:42:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v10 13/15] powerpc: Add a panic test
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240612052322.218726-1-npiggin@gmail.com>
 <20240612052322.218726-14-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240612052322.218726-14-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2024 07.23, Nicholas Piggin wrote:
> This adds a simple panic test for pseries and powernv that works with
> TCG (unlike the s390x panic tests), making it easier to test this part
> of the harness code.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/rtas.h |  1 +
>   lib/powerpc/rtas.c     | 16 ++++++++++++++++
>   powerpc/run            |  2 +-
>   powerpc/selftest.c     | 18 ++++++++++++++++--
>   powerpc/unittests.cfg  |  5 +++++
>   5 files changed, 39 insertions(+), 3 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


