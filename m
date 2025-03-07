Return-Path: <kvm+bounces-40416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BECA8A571D8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 336DD189909A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA74221DB9;
	Fri,  7 Mar 2025 19:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cJ7keIUH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524AE13C8EA
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375958; cv=none; b=tDeoPH9tb2nayhigWVE/+JTdxA0dJRscWeixY1h/MwwbfjpJGNtjb6tSr2seIO4IS8zeCG/1ZTeaFw5GU46DXFt+5x7b5RNlU/CjucBBDrK4gkkYX6YN91UGVAUceYD8quV5r/DFoWDWPX5IjkVhoYjkS6Ba/luqtHUKuu0RtVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375958; c=relaxed/simple;
	bh=FffrTgSiP7Eo2fhntkKK1gt2w3zDn5VYWmPmZoKGhOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DLzpLolbAeasxTLgyFdytSyGl+db/yX6iYGFF5jXl1PIPS9sIBWhTpdUV6+2ahvYwClibsIcOZXajWaETVlTJyGE4ryWsjnr+lLh5r2PP6lW2tdz3reAqzuXHBi7X8Ki4DQtLNXCwVfbKFzEYG7gUqgwd2+9Xuomgis9N2iTva8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cJ7keIUH; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22401f4d35aso43634305ad.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375957; x=1741980757; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0or6OEjE+OGp9zcYI11fM1xEyORauwjB9vRtl0EVOZo=;
        b=cJ7keIUHU38rmCB0Y2pfmlPLQ1m1zljkCD41gO1kw4ArP4CLr/iVsxS4eg4+5Lby1Q
         2pdVH1aMxC8veXhrgwJWzkbTl51NIrTsUTrIVE6F9q9rekp4hBQcE4zyFSR61AGqtsaJ
         0Ch6Y35zfR2aWVJDhtJmgQSbigFCgvnPiC2WjDphl7xOnHJS8sMQmJze3ErmGz1e7gsp
         Um4dLWRg0uZDLU/0xWlvFKIK++Vd5T/8/4mJBKajBQcPbSdf6w0ZVgQig4WZceffbB4U
         USZQ8y7Jee3bNGe51ExdLoXZTRbMnmgy5y3LikVJseWoZfZWQSdWf8XiaAz1eS6AcClW
         FPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375957; x=1741980757;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0or6OEjE+OGp9zcYI11fM1xEyORauwjB9vRtl0EVOZo=;
        b=mquBNftqQ0uk/SIAUAM/FUabqYvx6jVTswEH7f6WKRJlZvb+ID10BpXX+T3t0pl3ad
         sgm2GbhsiYXglz6sktAnyZL5F3dQuxsBmqDETXdPaP6AcQUS/aC64KnzXf18+weMspPh
         zlxfELYdITfpEgDhVaSaTTmboQ5JcOOipSmsSR/QCF7PI4/eOancqp/jkw7VadpVcTYa
         D9d6/WYDYZ/s/sqUpqxK2RVfGErOQod68tR0bb2QMrP01osrhYpY4MXBW1rolqwid/26
         8P0Uq0hJSfqnUJJuV/UYqpZQs95ivXtVRDR5HWxVdaeirNbP8I17OFrs6nfjQn1wRVa+
         Y4hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNAIcXEt9AVjHOqVz7YPeN+V0Kzi586jc7ojlp8Bgmb7pNLDIvizIk+3rfKe4ZTRUBVXE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsMzQUDvxnRH8NDDqlVqP5QaF1D5IfI0ozF3OoGy378O9w/Mh4
	yQeeDUi1qpeRRbIhUL/ZoRZFRw8OMguMwdgDWeTvqzmPJlblMsSrMU9Mtj4ERLg=
X-Gm-Gg: ASbGncuzzNeoItZZWvNZVMNgAEDDpZYSCnEH5OHqENlvAkHZhG6UeUK33Qkj7jONQax
	WAP4UYEMB0PTR7T1fAKCUXiFjxg2zDhjFJpelUkXZPYT1LvxMxGkHzSxfkX3Yn5eCwk9a4pNyJX
	gYR3XlIWkUk5R7rgpuqkBiPcFSh2S28WWO8HEzisVKu+zklNhyPDhsXyH7t09tCwhP69rofD9qR
	JUQ5nwFUwJ/1jOEWYaiJVJGXddeIC6TjgfSm5diipw8jElF0/JDhzN5Ck6dulJSFynU4FuuRWoJ
	Y7j65837FIwp39zIO0eRa3/VWbup+8WftKYW7nfZhTBLqFB/ZIlCfKg1ctr50NWEaP2ln+qfLeO
	22/J2lVyu
X-Google-Smtp-Source: AGHT+IEZj2VKRcS/HIeRMhhDDCIIuSREFKSqiT5M4gO/PvOFHDP32YVMVLXfD8/ewPuya0N9YDdIXg==
X-Received: by 2002:a17:902:f54e:b0:223:4d7e:e52c with SMTP id d9443c01a7336-224288695d3mr74052735ad.5.1741375956762;
        Fri, 07 Mar 2025 11:32:36 -0800 (PST)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2242cacbca1sm15033165ad.0.2025.03.07.11.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:32:36 -0800 (PST)
Message-ID: <0d700e16-900f-467b-841a-2e512333f5d1@linaro.org>
Date: Fri, 7 Mar 2025 11:32:34 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] hw/hyperv/syndbg: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: philmd@linaro.org, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 manos.pitsidianakis@linaro.org
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
 <20250307191003.248950-6-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250307191003.248950-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 11:10, Pierrick Bouvier wrote:
> Replace TARGET_PAGE.* by runtime calls

The description needs updating for MSG_BUFSZ.

> @@ -374,6 +376,8 @@ static const Property hv_syndbg_properties[] = {
>   
>   static void hv_syndbg_class_init(ObjectClass *klass, void *data)
>   {
> +    g_assert(MSG_BUFSZ > qemu_target_page_size());

 >=

Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

