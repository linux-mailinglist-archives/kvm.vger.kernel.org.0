Return-Path: <kvm+bounces-60179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33214BE4CDC
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A56D01A66B2C
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD62723EAB3;
	Thu, 16 Oct 2025 17:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lKaVn24f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAA423EA9F
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634911; cv=none; b=GXNemQxrCELw4fy73XEvFXdc2OiVxWXb1fLN1GXYGeDaO+4bO/g82bwyQG5RoLYEFHpEr+P3wD6JCt1qgcQM1WMZr8NsCQlhvhi6yCgDfDAD8ZZv5Y/8bVQuzrkIXw/nA+9IkG4y5u/0xJjiC5yhhjSGOILv75ap+nsIbRP0pTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634911; c=relaxed/simple;
	bh=KqiKLXNlxQU9H8bkmkY9dO2qGaW4ibvhvrhXjxowego=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YyaUYFQqpEMNNtWacWK+/haRhUq9HCrWJVsrjKZ/PbsSN16Ctif/c0ZzQBbLV8asyk6a3nwGKW6wb6h+B0wmoPIi0m0tnwh10qVKJs0ANIRqYi/ho+y/oqSD1IKEHZ0pipjUSxPqh99RirQD1ic+hlqyW5AQS+QJziHG2SocgWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lKaVn24f; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-789fb76b466so1035640b3a.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634909; x=1761239709; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tof3EVSvHhBUpVi7ajOyVgIJrNKqbMisVbLCxByvW5s=;
        b=lKaVn24fBkeXwfISZL0tsociAJMOmJU/gzXbrzzH4xTd4yxAVjdbFXsiqEEOpBdcWD
         m8yuW9fYvYYYxUVNuIYS+rsnOoR5mvNjjCpuTr9YxagQvJJw5YjsNzXYL5Kitc5Evx1p
         VmbYPktYdrhtr955KgzEaKuM2l34+IHxqXbtb+DVx87vr6WBz8s75tqg5o09UxMpCBK5
         Uq7k7baVqbVrXK2JSUFhjeNcb3QplsvegvkQBb329njSyuGetSIQgvg+U0Pj/8rXRhCv
         ksBMXmBApXtC5abAnfqtDD/9Besc04kEJNHObgz4/C/1y3wpJTU+DqEfW2LLXCFNHHe1
         oVBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634909; x=1761239709;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tof3EVSvHhBUpVi7ajOyVgIJrNKqbMisVbLCxByvW5s=;
        b=eI61h7z2DABDh/2N4Fgzz1rqFKRrdv9QvOqcNhNTE2Yo0Tx8e4eT4E8NJ88yb/jAkq
         Zkf8jitPfjdYMOQ2sDIycUrL6B7Gbm9Y92gS9YF02ziDcvQhoELQypuqTLV3GBB2P5HI
         40tgUnp3JQF7SVWBfHGt842LwhtTHS4ul7aEOQpP38andyYTPNwSDGFmlAkXkZATbXLe
         33RrlU8IotNPcXFWz7BIlsBzWH7aIc9eSGSFyzp30v86pc/+t0a9bCQ0W7zIcCnsyaLP
         tIfALFsW2Eep0tET4Fw0vQD8+W1UWTtRPe3PnmJ/14xiv+TbypW5pPQQV6Un/9YChzU8
         1zSg==
X-Forwarded-Encrypted: i=1; AJvYcCWLq83G/6L7VJrSRhnkvIslgVsED2sJCTVHaJBu/P7bfrwtHEllBDDvWN0781u+40SSDiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT6fFnCoc0V+E0kehJLgOzpFaDux8JX+hnbmS0PFSbvXxUIgIi
	czTHausqryjqDTvZI87kPtBJWesOjve3jzgBw8GwodINWLh7b1DZLN5RQ+jox6924Y0=
X-Gm-Gg: ASbGncuvRGPbQgDqxS+Om9BMByhOanJg/qmf6pGeu5WvU/4s6BkCAF02lMUiqKZfC6a
	XgPOJl5ETG4RAYvDms7ejefiucpYmHGL6jAFh1TZvtV3DKZpDWnSP/T4eDHuhHRDlYDWHYesnn/
	d19CrXKChmFVKe4bHoHFQXPrXr05plm4EXnxfSAfI0aNKajBQUaI3YCHqKRhFHondMLsSjwafD4
	NNomW7jf0y0JbegsR3eJMbB+zp4giSlQ1RZHWyEdbTTkQGv6A0DXQ0lhCCttVPEsqy78vdLUHci
	okbLjpkB0dgG4A3doE/OJObsEOJ3v+SIF0i49/Ly+guwKgYODamw9Hoqn5LFYYIztBN/vxxVAM7
	ybHivhNzYJLXhE7tdoKXsdiajpAubiKyrboPFSfbFqqGZCwbJLIwdx1A1tJzc2KKVsaPaWifp5A
	z0NRma+eZKDe6T
X-Google-Smtp-Source: AGHT+IHfOj2/RGEhI9uYqAiueQ5geH38L5kdOF1sE9vNJMIOJ7LSbEsFzN5vZE3JkIhfd+nJud+MPg==
X-Received: by 2002:a05:6a20:3c8e:b0:334:9c41:bdcb with SMTP id adf61e73a8af0-334a86445ddmr785445637.58.1760634909132;
        Thu, 16 Oct 2025 10:15:09 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b060962sm23224426b3a.1.2025.10.16.10.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:15:08 -0700 (PDT)
Message-ID: <faf3cd2b-4961-4d7c-899f-bfaa9f2ee271@linaro.org>
Date: Thu, 16 Oct 2025 10:15:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 23/24] MAINTAINERS: update maintainers for WHPX
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-24-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-24-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
> And add arm64 files.
> 
>  From Pedro Barbuda (on Teams):
> 
>> we meant to have that switched a while back. you can add me as the maintainer. Pedro Barbuda (pbarbuda@microsoft.com)
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   MAINTAINERS | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


