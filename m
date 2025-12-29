Return-Path: <kvm+bounces-66792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1975ACE7C95
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A24F30191AC
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 17:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36DB330D26;
	Mon, 29 Dec 2025 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rnc/R14l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767F532A3C5
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767031053; cv=none; b=QIo7/mNOG3qeU7OOZ2Y5iVy0CmI54UaJYaLnEhpbtamMBby+OtIFIUv+d9ugO0nOljocxyUDbzOC60nntrBlpvZV1UHF7OUgP3PvWyXkvOs1CTQvX1vvsBo0svHvcYCMwDflGPu+/26XJQCil2sxvXwvWZIcfb2FtADqX0mlkeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767031053; c=relaxed/simple;
	bh=KC3NPZjLFCtSoV0siidx2O+eCB4jfUdGXD8KUNq9ao0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HAXfbgxQ9ZhxTgg0Y6+GgHRENCm7WICqia+3WO9u6TylDJ5X/H3FzaTNoQQuQ+pUaNAYkEy3hUXvnCA0EOsQVWcqcrbtaeaTRd6KqlhcI/em6o3QvS+Xq1y7ydXxOe0aLDGALIQrMHudub/T6YcHPqdBeWCn9/ufFPt0pf2i7ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rnc/R14l; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so9207935b3a.2
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 09:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767031052; x=1767635852; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Xy+8eSeOzDb+k1YRCc4hfaw3xrtM1K2VyUwOhxg/MY=;
        b=rnc/R14l9thYKFvYO6fw1VjtFGUEAd/LOO/OW3TLfgzBVxoMlo/0HbG27g+LAQoail
         7wu1nzUo0F1qeL/CjH+6VNQ5RZjl+ptRzQMJuzz040Kb/2gArtA7tRUKU/CNTpoGDGqc
         TtUgPXOZh9c3YNOrEzZwOYMWB8x2Ovns4vTpZ+uk2apdWUgKfY+PopkwuQkpv7LfM3pS
         ps/FlsRHKGr+jpI6WREzq3aFds1LBtidYkjWHY7zeGoxu9XN1qLMkC/MnGo7GrbS5hjt
         /Py7Wyn2ZJbYHYFSKE9eCHCt9UFSVjTRVIzROuk3El5GUncPTskxt3h9vfcSpVPWLgWw
         fgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767031052; x=1767635852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Xy+8eSeOzDb+k1YRCc4hfaw3xrtM1K2VyUwOhxg/MY=;
        b=BAzyob0IzkJBqVVedEE7TnEUW89Pt772oaobttC3sEkJsOgu2wHBmc0an7NwcMD4Jj
         sDDz77NhkrIEJn7pvhwrddRO5Xu0JtFnszrsXOhkFeIoLyWJ/RkC7DMEhy9M70SLScXi
         AIjMhP2NiJ2LSWdTN2Lm9mx5lw3TfkclSGccvKUvv3IW5r2oglRV+OvlO/ENpFbTUUNu
         yUEMJ+dZnwERQtmzLt9SaInwWKGntCKVMQ+BVJfP1EhWgWjQoW55aju08i8GLwI2AoDa
         I3nL+b13BaWaD51wDHu9tI9/xNqwgau9uyVKH9voFKeRfIeWuLCIAS/jHpecsRNzhkG8
         zdgA==
X-Forwarded-Encrypted: i=1; AJvYcCUI4DPIPnQPOFWaM+UNQhaq24/RQlJMaFVEBiqN2fkuvbh/PIuItHE+TDEZLDr4U3ENz8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNj0LKHXED5lczFYfZ6or2ghba3Ibr98ZgD28juh5zlPAWFiw9
	9wSNPH8XlekLjgPcSvEX1COEm+cKvMQe+EQ8x/BsfK9sDiU+Ue/y15/9AQzg7EMA+mE=
X-Gm-Gg: AY/fxX7/G+Tu+WF5Cg+RcoPo3oSSxpQpgrsfZJPhReHn2JZd1DL6jfZHz+V0M1f2KME
	n31HEuFkgTFUZk+N6NizGhjnfjYndEy3aNnK++UmbqypN8b8RFt+7qw8/N9K2G6mZShhuUVChcJ
	bVaj5JCg/508X8+JAOT3l4w0NeuB5mgh4nTCaAIwdxkoxRaaOYpEOERb2vQ2vkPGYQSiLl6oCm1
	j0o1EIlnz4Uxgfmh1x9yWf8Ov+KM2IVBgdnJlzymX73+fMFnZKiMx0TezHM1n6jFz8FtWncuiMq
	L63d1SOQYcGUZ3tvG1pKERTBG2DWP/HzCFfOeUzUaEe9j83KN1OnBLQUpa+X5CtDOTv0nllTvrm
	sl6GC5DPRrVnWGqhvPO7zdxvnqbDTiwddAfVQ6Em9qmqQQuqQ+hswDlPadbike7GCdR6+P2fB6V
	Zo1HH5T1lBhI5R+zINQq09LH5FH0MJ98+b6XSARCUhQSMQBzE01vqUy4jD
X-Google-Smtp-Source: AGHT+IErFKWWqm+GLSQDAJjT1aQGL+KgN1/3vWXPXUMO/eDX2d0jFCrmaASWq0eJP9PPGU3CkfNm5w==
X-Received: by 2002:a05:6a00:39a1:b0:7ff:9fe7:9811 with SMTP id d2e1a72fcca58-7ff9fe7a134mr25809392b3a.31.1767031051602;
        Mon, 29 Dec 2025 09:57:31 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a843a18sm30285572b3a.14.2025.12.29.09.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 09:57:31 -0800 (PST)
Message-ID: <3dac03d3-e87e-4ad4-9fad-2c247c10cd12@linaro.org>
Date: Mon, 29 Dec 2025 09:57:30 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 28/28] MAINTAINERS: update the list of maintained
 files for WHPX
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
 <20251228235422.30383-29-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-29-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> Add arm64-specific files.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   MAINTAINERS | 2 ++
>   1 file changed, 2 insertions(+)
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


