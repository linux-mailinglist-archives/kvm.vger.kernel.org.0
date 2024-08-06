Return-Path: <kvm+bounces-23426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA9C949775
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 20:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CD091C2166C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA987580A;
	Tue,  6 Aug 2024 18:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qNV3ANn/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59C83C485
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 18:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968413; cv=none; b=iPts2AHLG70EdAd6l6NYfEE1Er0Eap1LBjQon6ZO57AibYY8S7ou/5+Alefe5IQw+47L+0SHWXJlAOzMUNvy7/SzAGTLhhQPdju4/h60Hm08VidEC3fzNRcNC3RUbi+4QvRODAv9nsX9UOoWS+r8NQqSN+P13u45q9L3pusstJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968413; c=relaxed/simple;
	bh=ts64ONWj2+7xWVVnPqL5qtLUTr8+jtp5loVaHUChmn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qEq/JPfVkySDUvxhqlC9S/eW0ixu8Qydn8TP/mkGE+E9b9v1uwV+HtsWXP41Nf8fPmE3uUxlvQZASJ8IxBDfTLUDv0DZ01LtBT1Efybph370wuNbs9YxW9jRRkCbGkJb47SfJiD9joQXO43dYeBkw0Q3VS84acGR9FsHbV8qL8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qNV3ANn/; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7a843bef98so105454866b.2
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 11:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722968410; x=1723573210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=F2Q8ARQWPkZG7WAqjFmxJ/8+odByxc1YLJGGmnQA2as=;
        b=qNV3ANn/Y3weEVmgw83QQcO4ymtwxJTAbu+8qVEaQAwZ+nimK4GMqsaLLWwyXtweCl
         AAZrayC/F4NNhKPFvnHr5hKZy2AJ0meHZyvkgx93nCkRVQkG6W+/ZkGeGFtT8q6/uvNe
         p1RdyeIOSNmZT2S4B2+0AwWHenTfY8IQUCQjG9OyBHXg5dZxYXJnrv8x/LKtpmluBDSh
         vwmizlxzTD4NPSiBKjfj31JRMNRy6WXLXh+buy2vDbsSz161QGjV/JW4TQiXeKVEtKwq
         Ju5ROf8bWE61bbzQfUgWOSbvEQKdaAfL/0dqZhEreaMwT0DNeCW7Qzrd7tKS83aza7op
         X0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722968410; x=1723573210;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2Q8ARQWPkZG7WAqjFmxJ/8+odByxc1YLJGGmnQA2as=;
        b=w8lN5JWaujX5zMaQ6D1C7byQTwunuHmibpF9pQmG25eboxmHAfeFBDEVBkXpdrxHYf
         8fOtW2+R5grg+XgfE3cNG+fWsdxevYu9MQE/NXM9LeoKa5ckCdAWV1iFSxVGmPPxk3tc
         yU5Hl7Or5A3dd2BTz7VsYjWzYywFkm32QJWSP4M2Jih37bds3wWA0yt+Dr7cwOiEtqi+
         5nL6IBM7t6qW94CiUa7cwUrFpu490doHqmEofPWB3G8v/konfayETFks5k2zi50mYy7z
         E8x7yTkget0mc1zH3mLDJzdANj0pt2wjNzbUXrMUHTQEs54b68l1xiUQt482nXjC9yMq
         jKXw==
X-Forwarded-Encrypted: i=1; AJvYcCUhbuNS1UsPHr1o3vMIocCri6dPK0Jp3pchEV5zn3KYYNrgmYL13Q1PYE2eFazV4dEKKY1Kh4RiG/5JD288qLVHWtoR
X-Gm-Message-State: AOJu0Yw1f3X/FNxD7tV+FVPMz8eZrwmFFaQ5FhirFaZv9vKRC/dUfCJ0
	Wt1JlUTWDSqbzYby9gzPhpzIRj2MYaVYoL31HRex7X0jcp0of69XE5LrFlTSGkI=
X-Google-Smtp-Source: AGHT+IGPn0ybi8q2QWtQUgttzKHLgQajIsoU7p0aIZGtYSOCPmuSWlb4w/FOZI/RAhpXXrZvysLW0A==
X-Received: by 2002:a17:907:6d17:b0:a77:dde0:d669 with SMTP id a640c23a62f3a-a7dc506c299mr1149565066b.45.1722968409637;
        Tue, 06 Aug 2024 11:20:09 -0700 (PDT)
Received: from [192.168.200.25] (83.8.56.232.ipv4.supernova.orange.pl. [83.8.56.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9d89a9fsm563924066b.156.2024.08.06.11.20.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Aug 2024 11:20:09 -0700 (PDT)
Message-ID: <9964eb0b-7466-4e99-8fbd-82f7efab1af9@linaro.org>
Date: Tue, 6 Aug 2024 20:20:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] Bump Avocado to 103.0 LTS and update tests for
 compatibility and new features
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
 Radoslaw Biernacki <rad@semihalf.com>, Troy Lee <leetroy@gmail.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Beraldo Leal <bleal@redhat.com>,
 kvm@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Paul Durrant
 <paul@xen.org>, Eric Auger <eric.auger@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, qemu-arm@nongnu.org,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Jamin Lin <jamin_lin@aspeedtech.com>, Steven Lee
 <steven_lee@aspeedtech.com>, Peter Maydell <peter.maydell@linaro.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Thomas Huth <thuth@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Leif Lindholm <quic_llindhol@quicinc.com>
References: <20240806173119.582857-1-crosa@redhat.com>
From: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Content-Language: pl-PL, en-GB, en-HK
Organization: Linaro
In-Reply-To: <20240806173119.582857-1-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6.08.2024 19:31, Cleber Rosa wrote:
> This is along  overdue update of the Avocado version used in QEMU.
> It comes a time where the role of the runner and the libraries are
> being discussed and questioned.
> 
> These exact commits have been staging on my side for over 30 days now,
> and I was exceeding what I should in terms of testing before posting.
> I apologize for the miscalculation.
> 
> Nevertheless, as pointed out, on the ML, these changes are needed NOW.

Tested-by: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>

SBSA Reference Platform tests can be done in 1/3rd of time is a nice update.

Serial run:
real    6m20,324s
user    12m18,446s
sys     0m36,686s

Parallel (4) run:
real    2m22,658s
user    11m50,514s
sys     0m26,088s

