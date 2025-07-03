Return-Path: <kvm+bounces-51506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3447AF7E6C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EFCB7B99A7
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2BB825A658;
	Thu,  3 Jul 2025 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nw4e49Mx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AE62580DD
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751562742; cv=none; b=bzBXYTw0D4PeL9dLypO58wDa4rydlVpBr7RiN3yl8y0SAe4ay8M+dbSoXHWIS73cn8JPOInr8xX9a0mks6MHMlfbO2IQrCpnRq8QcFrh8GLf5tlruz2pk29uPoQkcvgor6bYrU+9maRbZ1D1hI3V1vjDBAGimT4jKmSiFnhUh38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751562742; c=relaxed/simple;
	bh=DhNMmtYYhdUJXXCh8YQg3enTBCN0EK6Joz0YI0KvKmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=afQVtlITYFQ2k/ZlQlQBoBX7rocFh/H1QGDfMgsijWbOrPpZigLvvRlnqf9Y+MtWqXgS0/aGFdjPzNdAm361aqAIyOXtmj3yhdlhrBSgG4llIQIIVZH5+7l/gdVjqIje5Q8zEC/2X29LTFBzcTzzLJ0rUFEFWkb9XdW26Xcs8B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Nw4e49Mx; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-60ef850d590so59840eaf.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751562740; x=1752167540; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6/h5ogdXiK/uVnXKXSarY5BqW1pH94waISk54G7iHsE=;
        b=Nw4e49Mxfzyj29/ku0qNJkQIwhov1AZ8/0CXbtZu+eJUBwiv1tHg7GMlK8bdy/BbzW
         p9iaVNoaIbJ1t3dacbMI27sGpDqLJadt4Q3WD98TR4fQlA76PBinh1YHdxJ4JPmFllfJ
         ajNMcpP/VsjvznDjNcrjWZ8ch8KpVVTt0lClM0r+eHx1kjG5UT23ghdrpatBT8nsEC8g
         M+urR6qpcMbChPHPzsBwWYZ79LGkJ652p+wcfwYpusaAX6b3cdA1SqmslkWvXbEUMFpD
         YuDw2RfWmkcua9ABSv0PbIB013dmU/7s/nkgD/9CnAut2Wu2FQGmIkznNd/ALhT94K0U
         GnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751562740; x=1752167540;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6/h5ogdXiK/uVnXKXSarY5BqW1pH94waISk54G7iHsE=;
        b=rY0TIXZZI5gfv2NNGy1oPXmPnlZYOYaQ/D10PVGVRdZXkdh/PtbkYOOPPHWaXXhUC8
         Ij8Pc6WeU+uHLOCs2AHzQwyG3pcvxiuDEJbj1eN1lVVs2fBsXimBOrOoOW58YPqYD3a3
         ELI9zEpMFWZ2t0fyV5ksn7TsgbqTN20LMhHDGIkl9ybUTcJeHja25FPsDLZQ7fOyEvNn
         szmdV6qotC5hb3YPbmqU92jthYth82rc+lqxRqrJOXj6iTj+xVUCIuI43bntQhqij7YQ
         LZqMfJMw8sKOpFeSR85vR6YMctny0ixOb4SL4D85dYsPl4F8LZdR8J5Df/y7Fl9JA3Zi
         m7GA==
X-Forwarded-Encrypted: i=1; AJvYcCVDVhjN00tM7oYFRDD+HAvwvzqyH/5BlPzr3DXtC3C9cSj+gELrY+QQZWeGfV8uYWIIwU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrVXof3S8ddfiiJTtMiqt+l4BJD0/3EM1OTOj1TY4+3t/+K3jp
	3cipxUhjZNpVpc7fgeyTpkG8CJG5HchwDQ+r3TaZ8Gm9shLRqtXX6BhgLBy+rypEyfk=
X-Gm-Gg: ASbGncsBRaFDJxI/4rn8DGsT6q5CwaBrLK6+EHdWp1NxWIopK5hoIWJCYUpWCeuX/ss
	eq9GJQvhnzN4/ytsNBi3AGjBlcMm1145tFNeBNsseh/92xFufM16w5G4QM83WIjruf8+F1/hTQu
	hUNGNLv7dHu2QBusWuV4bREWb0Kx2UILWbxBMrvq22EBsfxZxEg602mulEkzkc4ssGa/lCmJIXb
	8ydbEKxrXP9rKhSB9YOctWokvZp+7PYd6AFo6q8MtpHjatOmP6n0WUx/+qC1XKU+r+HJ4UTAHvG
	qTnFTL1OlSRlVapD2kF9fbBfPB5MIO/BLSCVEJRZ1NgAG8cn89gG+4HlmtbU47ylS8VxfNZeYBb
	a
X-Google-Smtp-Source: AGHT+IHO3PrCujEgrAw6g6GPk8HJE/F+6HZ9nBPMuesrhWcWeahUViOMPUZmK+mDUFvWB5LU9spA0w==
X-Received: by 2002:a05:6830:348a:b0:727:4356:9f07 with SMTP id 46e09a7af769-73c896c3e46mr3517299a34.14.1751562739981;
        Thu, 03 Jul 2025 10:12:19 -0700 (PDT)
Received: from [10.25.6.71] ([187.210.107.185])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f93833bsm29086a34.51.2025.07.03.10.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 10:12:19 -0700 (PDT)
Message-ID: <de651fac-251d-4bec-9b27-6add2da0de4a@linaro.org>
Date: Thu, 3 Jul 2025 11:12:16 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 23/69] accel/tcg: Remove 'info opcount' and
 @x-query-opcount
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-24-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250703105540.67664-24-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 04:54, Philippe Mathieu-Daudé wrote:
> Since commit 1b65b4f54c7 ("accel/tcg: remove CONFIG_PROFILER",
> released with QEMU v8.1.0) we get pointless output:
> 
>    (qemu) info opcount
>    [TCG profiler not compiled]
> 
> Remove that unstable and unuseful command.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   qapi/machine.json          | 18 ------------------
>   accel/tcg/monitor.c        | 21 ---------------------
>   tests/qtest/qmp-cmd-test.c |  1 -
>   hmp-commands-info.hx       | 14 --------------
>   4 files changed, 54 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

