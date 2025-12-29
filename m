Return-Path: <kvm+bounces-66791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D136CE7C92
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B33E33019B76
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A20330D26;
	Mon, 29 Dec 2025 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yWpJghab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23EA2F0C46
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767031042; cv=none; b=uhyA3wFftl+lYjXEFpjulujA6JDsQOJQqI73ZDpng6ZKOCdLEvsYWnzf7dvA4OubM+7gAaw9ZFpFHBBjFI5i4GbYrpsZ3iWAIsOeNaLElMqW6axaVNlRvtO6SVPUg+783W02kMP7/vKtbuXQCZl4rmlqSdLwmISDBVQrEytq5iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767031042; c=relaxed/simple;
	bh=bwRQDxVRAJqb7UPVSkbWlrwcH0jUJ/rS5NwNOc0BdL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QlS2nYX43o8YDQRF9C5SGd+YmzIna4pdlNqnnXRBdnMOvTWQEVDv6fdbvBqQCOBPG8rS4Ws8ObcP0i99Np6Z8f/5DtAL/EF1TOyNdErAelO2cUnYHa8+OydX3ZcK4OQfGBmlgjM8gBbiDGwFrXy8O0Jmt5AMgdOitiETyyEDeqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yWpJghab; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a102494058so50345945ad.0
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767031040; x=1767635840; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ptmPtl9PHyVjyFIR9fDjL8hxPyC+ceFfam3bNYTak6I=;
        b=yWpJghabvbgMkt5Oo7usdcUr1vEwaE3RaQYWTPuHr5gX2dS6NseV2LygJe5IoEDKk6
         6JKwVdznxLTcYBh+cjLn6n4eK19kJc7Thd/yjhg0ijtfTVyGwPhL1fBcnVA7nLeDX8Xc
         RzWPXOJ07Sf0XuUlR5g+CvGF7M0zZHShP/DHR5S02Ub6qV3rlqPt56eZyhEEHrx0N/62
         hhyI9j8ekW3NzltwOc7jVNhpwUyId4viUE1LdoJMnqqjzXC+WZvCcekPcYIh0LCXTNHT
         9ZWkYksdvCaR9SYEghd1dKzCZwfDekSlYUZFTiVnsx+Yx4+xCpOyzSB2VBGLIky8xyV3
         kcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767031040; x=1767635840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ptmPtl9PHyVjyFIR9fDjL8hxPyC+ceFfam3bNYTak6I=;
        b=ETEHLEUJBLGZ43oXO/x0uG0R9jBR/17MRnCbwjT1eaGAsUatl1aZ/moRMmgZYUHtDn
         KK9qgHBkBj4kTb0LDAqjLD3eRBwfQRxBf00bE5/I3/06IALO16FSoBWK0nRDB9Bpu6sg
         hE4kL/3helH0igwx3xLr5eGhM6NslSN8hhjZCSUrMJNlDrhmLQSClITrClEHamaAlyAl
         950LHKkDnY18ji9AZ5T60akFSqjOy6rp0dj9w1SgM6D6yW70tP5EpM9i9yRe+9gExCrE
         +DLKKLpFiQUXIi+rwfZRA+Ds0/sT/W01+AdlZ6Zi5YABi7aQU9CYPR+O+KrM99nLXzQ7
         g9gQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPO6DFIif96Z8jWYUZyPJ2GjYiCOoNX5JANf5epZZtwbo4DzbNhlgZ7kxZ6yxyfx5+cYM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRUFuGYJ0Qfpjmgfa4d/eOHwtTHNDG9nGB2RzPZn+uyB8MEVSo
	QMJjFp788CGGtWdVX8F17o2d1RaTFGeSenoTV5zNUJDBADBk3N3VvnPolxbACoo7n4M=
X-Gm-Gg: AY/fxX67lixs3PZatanmjlHnh7tFjgYu67esstlrjWL+LXqCXH6Sn7A5jsLW1gkg49D
	RhsTyyyGQLTR4o/mmhTk+oZ+458vHeaPPEq7IGJaU0aNQpuCUGu64vTuaJp81jhhBviayikSL6l
	S5sks5x5v5l2yLG5Nu+3yPgbJTNbrcrUvbcEPp7kUwhz7Sfh/fzSkZ9Tu0oRdKfM7v4Tqv6QQkW
	CfLpTkx7CuGrwOrMP2S+H25mTasEAR2JVU/lUrDAIilDQ6eu4QHkDorFm7zv774XIToX3GUyT7v
	rWenkriHvWaftsJ3axmaw2CDwkDh/EIjeetUE945lpX21zCID4ncOTHMlZtfKyn7DOOLsqveCPa
	170Ax5DV7O5D1bXQ09Llr/VXs8S/dwQTOi3MNwwzt3KMlKOI9NRKCWqC+m1fOKEGRjkkEaWdNxw
	z5GA5H2syWygJn0qUua8Ql18Nobylh2odmsxhUZNxV3jMmSsQeSIhV2sFj
X-Google-Smtp-Source: AGHT+IGTwUkOJN/s6/eauxTisj2JxoFXKlUcBqUfGxRUgkjrOrbsTX0al3QtAi934g4EBJJoQS5haw==
X-Received: by 2002:a17:902:ecc5:b0:2a0:e7e0:1d31 with SMTP id d9443c01a7336-2a2caab9181mr388381665ad.11.1767031039524;
        Mon, 29 Dec 2025 09:57:19 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e7720b52esm13647124a91.7.2025.12.29.09.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:57:19 -0800 (PST)
Message-ID: <04228bf4-fdcf-4f4c-b2dc-3279ae5d2e9a@linaro.org>
Date: Mon, 29 Dec 2025 09:57:17 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 27/28] whpx: arm64: add partition-wide reset on the
 reboot path
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
 <20251228235422.30383-28-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-28-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> This resets non-architectural state to allow for reboots to succeed.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   include/system/whpx-internal.h | 2 ++
>   target/arm/whpx/whpx-all.c     | 2 ++
>   2 files changed, 4 insertions(+)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


