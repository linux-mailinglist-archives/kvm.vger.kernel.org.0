Return-Path: <kvm+bounces-23628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79AE394BEA0
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:37:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A2861C22000
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 13:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E861018E746;
	Thu,  8 Aug 2024 13:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sJ6wbF9N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879B418B482
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 13:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723124246; cv=none; b=vBts4n52nkYrUe1UzTye1nSOlkDudZd0vjmil9+tWz+nAhLgEX4KlPZ1+vQKZmqvwL5JaFn4r+eC2MnCGslj6DOB6z9HFyCeCgL7aBKXzbD3aEiEniIhfdysfNAsG9ryGP9HNxLYrDMUYx702vX4NZ//94fndz++5FSqj6Z1rjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723124246; c=relaxed/simple;
	bh=3ZiTOAaXUPmHMS+kcP/7fLCSSJvy0HJAPk8oCSO93e4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWOkdL/MIMZ9LvGY6TepnXWFWIVttuQPIUjMS9R3cDcSTD4Y3tyJ2iM1hCoTEK3B1VFHOC+2B+07mY2ZEzDCamTyehZU3Q3qhnrpS5BZ5arGsN7mYLKmPnS2Os7TGbMCzJBSB34J+kMHmLULB3j/xvwbMxbBIe5dTMl21es4xZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sJ6wbF9N; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-72703dd2b86so85842a12.1
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 06:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723124241; x=1723729041; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XVChcYY30Mpv4pcrAWYyddiPC20nI4GsEyGh5Z8PoV4=;
        b=sJ6wbF9NuWemgk+CVIcZ7ElWmsHZUhNO5Thb4E59bsBhgy8ROvRpz4XfGqIhCBM+m1
         oanCivvzQ+H8IdyfKAAggF64Hr8L67dPaowYXjdqP/JNqFrIzcYa/3wQ5H5YonJGjJX4
         w4KFUdu8wxIBFv5zFDe3nbHtIxd9etzXBliwnFCdzIgIB1aVL4k9X4xYcpnHVo9k32qg
         u/YNLNECNKbynU7HNUdy0Zg8Gm0KENVVga/605HMY7C4Yj8qFWJ9pubJntwpXRs5aBaJ
         g8diXNllRWq6qxymLu5eHwmskQYtfzfwmgJpVo6+Ca+GZekTlelfBpI6AXmD9AVkotIo
         V27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723124241; x=1723729041;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XVChcYY30Mpv4pcrAWYyddiPC20nI4GsEyGh5Z8PoV4=;
        b=cOFDzNdE/5hWW+/2WDxyWdXL9gTVuo7ccyNRm8a5IameytmyTYqyv5da5u/uNSr8WS
         AnU1p235aQuZdFGQ1yrgTC1l0FSz1JO8tgSVuhr9gOoicjsFJa5P1rWXd3BX0JRjYlUu
         4xeH2FnnfcCxmjD2Mewcjg7H+z7z/ARD2T8Bl8LXJnNbgbB+s6b3MEqwMWZjTL/9GrnW
         7onLKTZJQosPAx82ynt4yQ6rCTYw7ta++yWvxUCBIoHeS8/9hk4DP8dxfHGLbC+vt6K0
         hoyohWhdeMHuYeP1vpSGwrawJxpVSsQEcjxnqSVFns+VBaTZ14ZKwyrsJKoeXCeUPWeV
         jtWw==
X-Gm-Message-State: AOJu0YzOlgzrrn+7iApX1J8lbbE2jVC+uc5ZbgPH+nUkZGTaIqI2oRMP
	8U1M4l8RvmcaKn8J5rBMC9rhTdr4Ur/DQ2IYTx9sJUXm6ZkxR+brIN3gFqotfdY=
X-Google-Smtp-Source: AGHT+IEk6xoZ/zlRSb3U/GJSm3CHUT6KiD1J07T2LKOms6ygd4Jc8qBlHMKfZG58uLAif+L2dix3TA==
X-Received: by 2002:a05:6a20:7487:b0:1c4:84ee:63d1 with SMTP id adf61e73a8af0-1c6fd05f845mr1187450637.9.1723124241540;
        Thu, 08 Aug 2024 06:37:21 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f219f5sm124997345ad.29.2024.08.08.06.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 06:37:20 -0700 (PDT)
Message-ID: <35c7b39f-415d-4d23-bf44-75e655f3eb8a@kernel.dk>
Date: Thu, 8 Aug 2024 07:37:19 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_blk: implement init_hctx MQ operation
To: Max Gurtovoy <mgurtovoy@nvidia.com>, stefanha@redhat.com,
 virtualization@lists.linux.dev, mst@redhat.com
Cc: kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240807224129.34237-1-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/7/24 4:41 PM, Max Gurtovoy wrote:
> Set the driver data of the hardware context (hctx) to point directly to
> the virtio block queue. This cleanup improves code readability and
> reduces the number of dereferences in the fast path.

Looks good, and that is the idiomatic way to do this.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe



