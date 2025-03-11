Return-Path: <kvm+bounces-40745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B23FBA5B9BB
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 08:26:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68AC618940E4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 07:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5032E1AB52D;
	Tue, 11 Mar 2025 07:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FTaIW1zI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B400F1EDA03
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 07:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741677983; cv=none; b=bfgJdNoYBIWC9qIil2T1TasTVsoy322z1gQzbwde0N1MNwa6dGQ3Obm1XnKm3zh769SLOLbJqetHZPtA8eVRJ9Zw2czqcGIpBEtkpxPlIQhJtdSfmWyXlN/F75lSdN5oF9SJdyKpa95D96pYTAAWJAPraZZgEWV/pKi6vBQ/MlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741677983; c=relaxed/simple;
	bh=K6NjXm0CWknR8Wydk2nktRTLjKXHQuKyL3umuJC6pUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ONZ0hnQk28cbB40HFwPfhAP01+X3OJAxIeYlrGXbprOlzEd+cb6Z6ll98Kzm5IZa+FAYg5ExurMdrN9LabjXKRofHPUb/UlcykeUU2fbz5HSEP6VAtfdG566N8xVPSDmLaKFoVo/hU3exTW6kpjaZjtjeMtv8ek1LFhttKWBZdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FTaIW1zI; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39149bccb69so1634572f8f.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 00:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741677980; x=1742282780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WBH8un9SN3jvdF5o16jBTUcJYgDHmjsu0gBD/ioH79g=;
        b=FTaIW1zIlPHzPXiMy0htRiq441v1OYgITEjVxOZ2wWLku8YsVnYVlzwjNe28oFCUa8
         1eLgFuHVUOfQ7cCxmwafhhka84j9zeIWpZFa7leTWib4IZVBKS/DsvyDFADYyvJRL6I9
         gSK6LxykUVOhqR2vBg0E+4NrMefH6J/d7RscR7Tzw7hcLv6fk+Kmsen9OvYINKLZVy+6
         wcuXalvLStk/U+4Ml1o1NWKVXfepVgRTGdaGe4rDbcdI85srtXLIiGbF7+JRk6kQrgsK
         GwW7LTVi1uDKYjJX8GD/Lq4VNUDiepD9ViEdjW25qfDICdQ5AeQwtT/QFLC8f+1+CMey
         rOPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741677980; x=1742282780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WBH8un9SN3jvdF5o16jBTUcJYgDHmjsu0gBD/ioH79g=;
        b=hLgszd9SmlAfLUJvjd9rFIFCvxKAT4GoFRn95XhuOvWNXzozwJHK17cbCGMmxoqT8d
         GGCbGYJyRdJRxNQiTp+oTlsqLa/AQLzbOk/+KQ7Qrk8pq7PGI9y5G1uzfCg6UaasThZ/
         2XWko2h+RMHHlaQWgWZ9rcby9iezrCUtJBmDb7VhMkM7aoc7kOPIpM3/uiA6A/tVMkT8
         ZkCXzw6mWfqMEeNqL23/HlKaIQFuc4DNo/D/pTjn5xV48TaGlbmX/hdKKvIjgl9LR0Si
         NQj33VYPTq0Uk+qytBE6g5EPCgXiAWLwAl0g2GjLk5RbYEaOQGNuZQMssqqyamOSJ+bl
         EUFg==
X-Forwarded-Encrypted: i=1; AJvYcCUU9QY2dMsWHqSJPe25YwCe47nOBgVRyPYa+sYsNbSpuNHL95FUSt/tthP6GV4xgBaZwqw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwFBE5XlqlW9FV7H4MwasjmQ3SgTRmf6EgH+dNqtkarFLwJuhY
	f70Hqmrqb8AX6Zovx5sChodg+et3KcUrxgx2o0QQtM3haU1gFzOlEs1z+fAnSwQ=
X-Gm-Gg: ASbGncsO6ZB11PIpUhkE2ewmLI3zSk0OEdI6RAjhMt7eqs0k7A8sSIEl8kdFDgablPa
	89qgQRPzAfRUjl8mmoP2TkfMHFntLCLsxuoBD3Ibv8nGy6CD2HB1fbzdRCPrDRNuFA7nnJSZjpR
	tzv0B2fQMtAuuHLYPQk1ldSHHbz9F+SoWHnEf9ojhckX0Z5duywQOkcPekSmh41OCZG+/okxDO6
	AsXJoW8qWO3/nhu8X+4JVZuQ9zhhjlFMJg6O0XIhzCUk0SkSRyCWBwtY28G3+upPGXHUk77fGd7
	+YjKDmYOeMYeL4EEO53wilEBfU/ovvv7Nc/dONZG+ck2TwO5q6hOJthdfBAkoKpyZopIPBhT1t1
	Q0ufyw8iCwpHZ
X-Google-Smtp-Source: AGHT+IGFEKvevhRYU5jwIA+OF5lD7GqYNAbzux+l1q3TxUHSloakvK6wXKgncMmFM2y1SaO/Ty9ZZA==
X-Received: by 2002:a05:6000:440e:b0:391:39bd:a381 with SMTP id ffacd0b85a97d-3926487d48bmr2239834f8f.30.1741677979924;
        Tue, 11 Mar 2025 00:26:19 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8b0548sm176538855e9.6.2025.03.11.00.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 00:26:19 -0700 (PDT)
Message-ID: <f0c7b0ff-a43a-4203-aba1-2e06a462771e@linaro.org>
Date: Tue, 11 Mar 2025 08:26:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/16] exec/exec-all: remove dependency on cpu.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 xen-devel@lists.xenproject.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 qemu-riscv@nongnu.org, manos.pitsidianakis@linaro.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Anthony PERARD <anthony@xenproject.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
 <20250311040838.3937136-8-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250311040838.3937136-8-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/25 05:08, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Missing the "why" justification we couldn't do that before.

> ---
>   include/exec/exec-all.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/include/exec/exec-all.h b/include/exec/exec-all.h
> index dd5c40f2233..19b0eda44a7 100644
> --- a/include/exec/exec-all.h
> +++ b/include/exec/exec-all.h
> @@ -20,7 +20,6 @@
>   #ifndef EXEC_ALL_H
>   #define EXEC_ALL_H
>   
> -#include "cpu.h"
>   #if defined(CONFIG_USER_ONLY)
>   #include "exec/cpu_ldst.h"
>   #endif


