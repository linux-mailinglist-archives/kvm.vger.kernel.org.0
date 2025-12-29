Return-Path: <kvm+bounces-66785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F9DCE7C68
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:53:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DDBD301A1DC
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F772DC33B;
	Mon, 29 Dec 2025 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IJIa1nh6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3D72F0C46
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030781; cv=none; b=q1Cbfb77oqz8du6xTljdAr3H00NuV1U6TADffW+MPQV9mUnCfkLef2q/3AnchJgE7oOQYOQRDA/1qBz0hcZHkZ2b5jma0ZrS0rXf2dgbZtzKWUBgQAICDzKvVuBD6Jmt6NyDb9GLEmS0cmST789Nv1B0geha3jvuJittIWgIUPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030781; c=relaxed/simple;
	bh=lOhvIslxcOzKCuVqQO/2WSfUR4eHgL4s6CQhRdY9b4I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BdrmmMfdullyGbE7hQbwA7fVUR67mOvPtjXfGg4dl3SgS/c1pZBINVFNCK+8zDFsb++kKvDW1WYM/2o3depSX2VhXjAR5l4ZpoVQ8pYLiiF2/AWOag7P2ThZp0AGop44VfJw2V/DmG/xKqFnyYbJVsR7+LApnaXTSnV1bM6bo+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IJIa1nh6; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a0a95200e8so80543735ad.0
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767030779; x=1767635579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JXVKq/HEthezyNMxbCgoWKubtztbF9R/uCreixEgfcU=;
        b=IJIa1nh6+OeumJAX5sxE0Aoxr8byzfBpxXoCwn9fFEmbaAMSx54rN8E3pbuYHQOoO7
         hjTCx5+/jTb3lRChEO/Vhmddld9x1H+CTdxLq3QMiaKu1LeyQ1DI99YhHwrMlO1kkRH6
         uN+ChrHhf84nQox6qyljDfJOFpsfvWpaBxYWTHvJ6f6CwD2gy7XZm7L6YWdvq+iLk/Wj
         ZMbol33IAzzFMTfIWQzVV/5V2Zww2dzGhUGuDgrc3YNXnkVp1097GJhkHiC+KhAB5K1P
         lZlgleirHJNyvXaK9xC+k0kJw2K1MPjOR5o5e+DNykV1jBWSl6BOk68LLy1SHTtCF0zJ
         q0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030779; x=1767635579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JXVKq/HEthezyNMxbCgoWKubtztbF9R/uCreixEgfcU=;
        b=bvLiGsajEUsk0+WEQ93LH0wLf8imHFfjHfwIVVFHoQ7g9nkY97ZdANnci4ShqJNzDE
         MzAOU7jsRIvbiQe3D1NLoroCP15cTfhChAU+t3kNhVTVExIjL7d24xqkMZKLC2K+JXM+
         Vz7dcIvikL05R+vLhnOO8h0wYhROIC1Cv6Mx+5rilhc04Q3/k/76xdxNpACs6l7HWk0N
         pas/65Zx0NujT6P8PfzF0Q2tqsYXU2wHucsSoZswNcEaiqqQ6nMjn91lr/7Wo+2ft+lM
         u7yY2GHLZyWV+a3WBRWfZo7Ws50ylU9P38FugMQSyEAMh0fpK0ZHMARGAPMoi18EFs2u
         kEJw==
X-Forwarded-Encrypted: i=1; AJvYcCWOaI+qzSBdObnZA/5Pafr1/9Aj4DJA7dD0nKMpbNrBkDDeulxWr8yfvIB+7YA78sx8QyY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8J9PGaJUiWODyshhiPPk7JF1iVSSPw7xNS9dU5yTqzDbKe1Lv
	myXUZfjD5P1OXm6OKazDZWp2D0zKCNp4igOvwVgEJW2WoaCSJ7iW4onnItvCMYk4mo4=
X-Gm-Gg: AY/fxX6s+6wyPPt6EfnZi5uiiX07IiRL5ezYH+2DgULyGhS3IaHM4P0vmr0f1BzQS4/
	hFklWzP0e7MIy/PymohdD+pKztQfEeOXm4RckHm+P0pJvJeLqDI3vlxJ2pPKVtER6aicEEOuhK1
	n23sByLBAPrglgYjX4dorGYJVwNGxXb8ERwmGZX2QoDFnEw+mVocHjYNMD0LF13w/4Ow/lZcSO6
	LFao5BoJZYOTce0f/56/kLKO+So5QRLplI6LxtMzSLFaPghQrU6sWiM2Hfkd5n1BhMhJu+VAMV6
	2KrAsK5pgRBSr+Bk5TtPMVLy23/4KZJpZl1yK1BZZqCSL3gY2ztU0WIabqq/S6b3mL3vV5LRAeJ
	5rWBw3wdLs/K4z6AQTE/UUsbvZsXd4pKwqVdRxKeeiJ8RnNXt6yblFfe+VRlvTaxnuiPlLJ6hib
	D096MxpJJ8AwOm5kNNhXKK5Ox/TnATB+3v3/qN67lACYheufd4KpuBK5pZ
X-Google-Smtp-Source: AGHT+IE8OINlogN+WfsdC+idVXsEeRftu34+jwS7SuX9GeIq8z0GhKxIEvVbbEonrNhYvUm6LW37KQ==
X-Received: by 2002:a17:902:f70f:b0:29e:9387:f2b9 with SMTP id d9443c01a7336-2a2f232bab4mr277428275ad.24.1767030777287;
        Mon, 29 Dec 2025 09:52:57 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a322d76a19sm229092615ad.101.2025.12.29.09.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:52:56 -0800 (PST)
Message-ID: <bf7b5707-2b4d-4153-9aa9-155b677b6c44@linaro.org>
Date: Mon, 29 Dec 2025 09:52:56 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 07/28] hw: arm: virt: rework MSI-X configuration
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
 <20251228235422.30383-8-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-8-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> Introduce a -M msi= argument to be able to control MSI-X support independently
> from ITS, as part of supporting GICv3 + GICv2m platforms.
> 
> Remove vms->its as it's no longer needed after that change.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   hw/arm/virt-acpi-build.c |   3 +-
>   hw/arm/virt.c            | 112 +++++++++++++++++++++++++++++++--------
>   include/hw/arm/virt.h    |   4 +-
>   3 files changed, 95 insertions(+), 24 deletions(-)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


