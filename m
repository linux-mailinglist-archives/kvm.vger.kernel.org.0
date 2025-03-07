Return-Path: <kvm+bounces-40461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF63A574DC
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 23:25:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 093F67A8622
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1655A2580DB;
	Fri,  7 Mar 2025 22:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XGX/qeY2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C782417D9
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741386321; cv=none; b=mWmGoN/VbvTK6qCcDgzkyCJjxK8EnJRGXuAcWlrq7br+++x0fBMnDW6NRRe5qrK7+rRWTux0TBMtqRHe8Wz7K1e4AJFjQ7LtVRQU164ByJjdKlueYFhIQOtzhPlpT+eR+7cNvp5RgtxUy608rnJov/oJpthcbmf5D8aJhkqqg8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741386321; c=relaxed/simple;
	bh=MJy5GT9HWfT7YDiOzuWVrwp2wIlETZ7ehzMD+nSSstc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dRsZxXReqFBVJl6FNjKIMZ2aoEoT5pRxOS8wquRqTqVaTW1HUA/3l4fUlr3iIln8yNcDgPj9vxpQQNfEHBc9b0JL5jlcy/y5/062tzFHOOvCmLxM6bzlXlNq2L+0qcV6AbEFGskNiS4T31OLDUqAwfa0gaTor9lpndLaTsO3oC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XGX/qeY2; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39129fc51f8so2033276f8f.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 14:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741386315; x=1741991115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cRC7TXcNY3iZUKceOw/KL3MRlQT/aiJ+WJL3TuGKc6w=;
        b=XGX/qeY2pFjod3piCNR5b0dQLurUOvh6yFT0ouokLIRgM7X0jWbhtb2LZQcukG4GfH
         UNvtzRacwBWrbC6p9CIfHeq1S7YVUjjhzaOXuQgJiZfD1aJjaXdthJdX+Cq2Yray71eK
         ET4jvtw8QSz7YtrqjXyGGlG+cPBPyAkcnIpBuwVl/u3rFOr66dPbziMBNAQTJzFvzbZh
         HIIbxJsCImbVNZSMBkPxFVHKBnDIgpAePjzQ8EiF9aLuz0QgsV99mor6TgdX3Lpa6pZ8
         kgYUzjqWi+5OLqnx74dvHhpP/8eSab3HmosZlNYj3qVHfMYp8wrTtahzPwna4CQC1+L9
         Parg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741386315; x=1741991115;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cRC7TXcNY3iZUKceOw/KL3MRlQT/aiJ+WJL3TuGKc6w=;
        b=YzE7UtFEaB7O776g8dH6uTNrF6R5RgzRIK/kzfSu8JGsrC2+2Tj4ZHedqyV4RRIyRZ
         QXErSnEcNGE4F9v570cwjVl6XUkc9At9xQOIpeqO9uJNtZr9tWtiPzN4ZC1edr0WZ8+i
         S8ADwW1pNwyPYNGdeI6AvkrinQ8xwyIPvsk8OBj6+xgE6t7xBt+zZzcAzDldCOYx9R6f
         HOsMo/6W74SoACjWDTQscUIOyZRxjY7lJOiJUGh00Ud2rs45e+ysvRbOP650de2IJxRu
         0ek+gbenKxpFDaouWoWHMdLCWIChZcDxO8hzYhLwHuddn9zOYHGDFu7C3ZLRgZf68CaW
         VctA==
X-Forwarded-Encrypted: i=1; AJvYcCXTvW+hMWBzfYMga9DyzIl3N6PY3l4If3BdbIXughNkuBLYS8PmhEb+KJKDyzZby2M8FTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJYNuk1EF0SZeuU+W3u048jeuecy9qjWRpGe6zZgquL7tXoB0B
	9OGbH1JeAsSuNqX6D9z5C4XNIMeEyDWWPCosNnhBql2aSQB0/bl8uCzbsnq4tgXU2feSYl1ECDa
	pGHo=
X-Gm-Gg: ASbGncshJGSAbb7YFJI/kuN7carRzfZ4HuihRfn1GnbvNnByacqYKug7yxhSlEGp91F
	Ugad41I5N66xlfCWa3KbHIPvQ82LuSsRnydAywB7dQ3hSw3SoTpafrFbzuSLSDONxBW7vyyavf3
	a1HrlxUWo36PLnuyK2Gn1D6Y08rEAHsPEQQO+Ge0+hgIlPIhmzGh62cnzPGlxtDb9pKS0ALNsAF
	i7NlU/SZJga+ubxQzdhxWyUrRlQbWrMCWwIOioG6McE3BYPJqDCyKTLQHVYFveI3AsOw/zB5lGR
	YuNtq3MyPOoNXijSwITf9BLzMVS1wSt1pe6RiywzorxSuCt0xLi0TuxVJn8s05ormi7CeSx4/YO
	818AJ0Q4Xtx9q
X-Google-Smtp-Source: AGHT+IHKZVGym/fOrROxYCJZQ2letPzSG0LPSvK62neBJgbnoPem+/02emxaWNx+wZuHc96RPLciuA==
X-Received: by 2002:a05:6000:1842:b0:38a:8ec6:f46f with SMTP id ffacd0b85a97d-39132dc4335mr3399845f8f.53.1741386314711;
        Fri, 07 Mar 2025 14:25:14 -0800 (PST)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd4352ed7sm94111965e9.26.2025.03.07.14.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 14:25:14 -0800 (PST)
Message-ID: <8c511d16-05d6-4852-86fc-a3be993557c7@linaro.org>
Date: Fri, 7 Mar 2025 23:25:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 richard.henderson@linaro.org, manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Maciej,

On 7/3/25 22:56, Pierrick Bouvier wrote:
> Work towards having a single binary, by removing duplicated object files.

> Pierrick Bouvier (7):
>    hw/hyperv/hv-balloon-stub: common compilation unit
>    hw/hyperv/hyperv.h: header cleanup
>    hw/hyperv/vmbus: common compilation unit
>    hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
>    hw/hyperv/syndbg: common compilation unit
>    hw/hyperv/balloon: common balloon compilation units
>    hw/hyperv/hyperv_testdev: common compilation unit

If you are happy with this series and provide your Ack-by tag,
I can take it in my next hw-misc pull request if that helps.

Regards,

Phil.

