Return-Path: <kvm+bounces-44680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17514AA01DC
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B733A5A6095
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B21F23370C;
	Tue, 29 Apr 2025 05:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OBmVBcFO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3EB433B3
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745905024; cv=none; b=gdWnbbwk37nUDrwf4g8cZ/mmrz74gFINmLno+lcdkbI12hgVIBoRJdEbVYR6Z1Ig07qtkjiIGNBGRbWlVaJXmbxRBJy3gVuV3Um6CbIjDV4jbwnXKxwra0UzOgeN46ikLmDHHHxdAUEUf1H/jkBfkwzurR6kLPdurWGAvIuY8kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745905024; c=relaxed/simple;
	bh=T/ay3Q1UyRbqCpLTXDnMIelLI4jNm5sdVcMaWThx7Cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhnGyOV1lkjCt0wHlcfl3HHlagzwLDD6UAkVIcqHDxAgHXT8icSV6ySNS8fni+hNpFWPpj429nhYCmTbjvBVouOIC6gP0invP9zF2mdt6vaOqUKFf8eMU3k+ZY4lElWwGWdUtsB/DRZU6f9IjqxBO0g+KxIs0uMz2Mc3DJSck0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OBmVBcFO; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39c1ef4acf2so4147733f8f.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745905021; x=1746509821; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fdxbfOqh2DB6z+OvNYbD+2Iy/ee1tOeEB+GcS9VWkCY=;
        b=OBmVBcFOGznX+hp5IidAfHDwxlb7wehuxGrD5VYodwS56IEFx8Xsrqe+7EgPyyCbus
         JImpZeXLpWWih4eMDrTLNgdfcAJAQR0nl35CXqhdFF92JUqoXwXbP9Yihs3e+m9X68a0
         DKQkBBqrI3g6SAbbqLcZDErOwWpGSR2tHKlAvpan5SGahnI1ZGHDJvSdSeJkbfNYJS2T
         tEMYGoFDLRIyCrbqJudQ1+hyJgWFYJdyQK5Xlmh6RximT49yNciQD0ir9+XpmAUN2Hsx
         WNie7qQnDJRF0Vx2Rv2iAjGXef9w2A4AGVhUVPjtJCBbtBzDD5Kf12RjnbIcvK81KHP/
         V0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745905021; x=1746509821;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fdxbfOqh2DB6z+OvNYbD+2Iy/ee1tOeEB+GcS9VWkCY=;
        b=B5xSj1ekZ52v0IAI7XVBs45SuOLSs+8kcxPmVdbMbrZLjc628qk99Krpvp5nAIoKhJ
         WgXP4qWNV2GC+/nrBRwoIX+sGQzL1oYcEtN10IEa0iWaEtbAzTfh6qz19jdRfxWkCX+2
         zKB8iyRSxzOegejkMVO+9YLkPPgLh2bSlCHV8+K3qNFL+Ro+9qgpfjNBuRkGtk32zj23
         7Y4Y8SnJSCwHvzhBD9vQmzKj7LBx7EHb7c84d7jtOZPsWOwnQC0LnEza7TKYIx0do4LB
         diAzGTMblSO5N0YE7MQHX8EQkAQTRrRzK/xvS95qRUh3dBRJsZL2liDCBvB5T0NT/a7Q
         pL9A==
X-Forwarded-Encrypted: i=1; AJvYcCVZTuuauz74qUw6+swxKTTyRIvI5Q1yhF+OMz1YSQjzuwvtSwYtRUGKvnCmN+OA8l8Drc4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGL7J9sPjgoi8ouO5aCMPujYkH7VzQarAaK62U71ljbtb+d0wQ
	EAlkcNpCIYGhTiFIqBPi0KLPzBpTF+vpuG4W18aJDqEHO+lbiMD0dcb7ZROF9UM=
X-Gm-Gg: ASbGncuSZVdmElykAI2+vjH0J8AeffarjaTur/4FwVynkxi0biaX3mncOdtVCjTBNK/
	ZCEvBjSy5ND5KsopcHVv511Xyj5gLcpkvMcLOATSCdWdNogSK9Xa5MRxTZZ/59EorYAQ99gTjp+
	v36tM3uUsdGlTserVuLdGP11ks8I5DzGokhvH1EWRBFMrGNNM6545fIprCGwo+3jG97p8A34dQ5
	8dQ707J4Z6D+1PN3f0N2IjIxIk74kj9KeIbZJQ7Uch082v7ZiGMZjxRvJxovoYXw7NxIfQX/jnr
	ung7JrRCzOdofW8aDF75/Ko3pvggJuJi8ZNhPtiJMa/302D/9ElWpvzj0/OiE3k5Dkz/3Is4/83
	g2NUSfc4A2xH9PQ==
X-Google-Smtp-Source: AGHT+IHPSQ2/orz4Fh9+TApHSPnuEOz7ugayFhhxAeqRVwe7oA6djQCIKIaw1NbnQJTqpfETcN8D4w==
X-Received: by 2002:a5d:5850:0:b0:39c:1257:dbab with SMTP id ffacd0b85a97d-3a0894a3d64mr1871645f8f.59.1745905020634;
        Mon, 28 Apr 2025 22:37:00 -0700 (PDT)
Received: from [192.168.69.169] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e5d479sm13271027f8f.92.2025.04.28.22.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 22:36:59 -0700 (PDT)
Message-ID: <9aad9038-2154-4734-a110-7a4d432330a2@linaro.org>
Date: Tue, 29 Apr 2025 07:36:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] include/system/hvf: missing vaddr include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-3-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250429050010.971128-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29/4/25 06:59, Pierrick Bouvier wrote:
> On MacOS x86_64:
> In file included from ../target/i386/hvf/x86_task.c:13:
> /Users/runner/work/qemu/qemu/include/system/hvf.h:42:5: error: unknown type name 'vaddr'
>      vaddr pc;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:43:5: error: unknown type name 'vaddr'
>      vaddr saved_insn;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:5: error: type name requires a specifier or qualifier
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:18: error: a parameter list without types is only allowed in a function definition
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>                   ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:36: error: expected ';' at end of declaration list
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/system/hvf.h | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


