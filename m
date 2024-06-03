Return-Path: <kvm+bounces-18631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 907918D8141
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0E1F1C213B1
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD2F84E07;
	Mon,  3 Jun 2024 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lUx+Cgvf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5477E1366
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717414189; cv=none; b=MJXU3hxy0PvLFnjIOxDPynYCT+ZRYPyNW6o+XW3Fx+Zfr7FGvfaXGaN22JPrs6yh9fXpaowxf8OUwl1Nu0cZDNwKScTV4PyYU4o+kO5Skxkm519FfrBKx6GODy3cyv5h9xAGgXztlYKMv58pC/Y6NCtmcj5yIJIHknHc/Svj4WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717414189; c=relaxed/simple;
	bh=rpQUf9SQllt0B9K1Hh6ViZNhUlJ93C7Rfm3i+kAmgrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y+ZgfUTB38NQZiG1EAfbZBuHUzPemm3Ys4AmJFE42SVqFNkRLs6kLZqvkYOz7TcRkJ7MpneQ8oXal75xhVvMLSKxA6BCBXXCb08rHe/8HIOSEOUzJjGIWx7TF82+7QM5OBrb6+YwNrSvtPOFvydUJUtfY4E7IOEGqFjoV4LtgpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lUx+Cgvf; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42121d27861so38037275e9.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 04:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717414185; x=1718018985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SLnxUcJCvwam8NR4TAMOEi8I7SnlVM7G4gOpinBNE8Q=;
        b=lUx+CgvfX//qf4D4pu85/G81R45Wn39CJCSUMNMneQpeiY+PtqnLMc4/ctAHGS3Rrr
         g4oWFAQ3Ni3CAIZgMM8FMVzA4GbgK9tZqbKmMgSlhP+F8dQyd87fwDGj9zX6G6zNVbwY
         I1qvjdv9IK8ZkzZbDAGBi67QHsgdoWJ6bEetPrLIycCHHuuBhaOS7Gr/Q7TEQ0LXzof8
         OvIzijfSnfo/reCYXo4RWNP1PPFFN5kw2DDWJ5MRzIsFjzLJZNPpDNyMedcqVrijNGLF
         IZIspo4ujZVuKj/jRyum1Qn9pkhvIhR9rQd49S2bbUMywR4zVt0H/F+iEm6XK9pbBIDg
         MpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717414185; x=1718018985;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SLnxUcJCvwam8NR4TAMOEi8I7SnlVM7G4gOpinBNE8Q=;
        b=GdwWnSjo0VBttD+NMkgMqX3BIcAUp5tWe/WjgAL0j2D8nFWl3Vl9r+29Bo5ik0sQhT
         x3KMzyVx4Ob2pspswtuV23F19A1ObiQSdnBa3HDR1QKH16niWaBYCpiDf1XhygESeIyx
         mpDjq7DVy3vCIp4gLdpGTLmgAQMXF6mYLiihMceyUVWH6eBwOYDYsnXf/9dN8FIHvwsK
         arOnFQUpja/7XwyAIIKVSp9SOtAqQVbLC9/h6xfb4yeeWQHvb9J3hvbJFSK5lFaSuAD7
         wSvm6p5YhEQnoEepKPFpw3yx6v84rVAWN4PTFUXbMjB1TP5EDs7g+VO33dMTLuho6ODz
         0khA==
X-Forwarded-Encrypted: i=1; AJvYcCUHgyPMss+159AEYy1U4FOLwm8OWWmoQ46zlCAIT+CvUKT9bV+NUu8om3m80XUpLm4J/6QQbBSGTQTIjJtMskUzuGhJ
X-Gm-Message-State: AOJu0YyFm3MozuDTog7AoqkUPghA/rP4bvEl58iD0OkcykhV5+nA3CHv
	tEabL64wJEIBFDc7xy697rkG2ZSk0eVqGlCLkjGVNmR4K38wri7+nQzPryPJfbk=
X-Google-Smtp-Source: AGHT+IHjptcbICMOvw98IRefbTpUVCv3dgn136ed+lZOXrMcu/+Lxkisji2UP+2kAbwtIgGXr9OceQ==
X-Received: by 2002:a05:600c:1c85:b0:421:2b8d:9cea with SMTP id 5b1f17b1804b1-4212e0ae4b0mr71855815e9.39.1717414185561;
        Mon, 03 Jun 2024 04:29:45 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.177.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4213ad0aa15sm48578905e9.44.2024.06.03.04.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 04:29:44 -0700 (PDT)
Message-ID: <a4bfd8a3-8d07-4990-8b73-331a301f9545@linaro.org>
Date: Mon, 3 Jun 2024 13:29:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] cpu-target: don't set cpu->thread_id to bogus value
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Yanan Wang <wangyanan55@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Reinoud Zandijk
 <reinoud@netbsd.org>, kvm@vger.kernel.org,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
 <20240530194250.1801701-4-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240530194250.1801701-4-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/5/24 21:42, Alex Bennée wrote:
> The thread_id isn't valid until the threads are created. There is no
> point setting it here. The only thing that cares about the thread_id
> is qmp_query_cpus_fast.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   cpu-target.c | 1 -
>   1 file changed, 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


