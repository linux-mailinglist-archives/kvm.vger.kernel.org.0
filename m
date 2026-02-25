Return-Path: <kvm+bounces-71876-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qB1uNR9Qn2n+ZwQAu9opvQ
	(envelope-from <kvm+bounces-71876-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:40:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7BA19CC56
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A08A13025E21
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E9B3EF0B0;
	Wed, 25 Feb 2026 19:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EaBLNIZP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6618395D94
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 19:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772048410; cv=none; b=IcedRc9DXbfjhDazNos0MCyy7yYrvF6rRDmp5jr5yfPJgjaJlFXfVod34vMQQ6xUF1xoWzatmNFBzKBGaiF4u1C1bydCLZqBxYzY5x4DnpOXEF2He3PEs3Xxysdxueh8rT+x6SCyC37KbSy5vSEdGm2lHkni88xHeDVlWL02740=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772048410; c=relaxed/simple;
	bh=MgnAeozOPsGYkGbQxDk2ydnechfwf59lj8YRAtJ+H5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sO0ueVB5d5cWueVAZfmZtOUYxt/7FpTLoNiUx6Cva8mxtF/1mBTjSjWuChWucGSlqzH3gCKXHy9Jp7i+k5gOww8QuxBOygb+2VsLCyQnZDfiTyriZ1I0uNSehDqugGL3P1//0wMZJfbYKrOufBPbfTavKb31Sd7sy+eLeHHzwsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EaBLNIZP; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82318b640beso75875b3a.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 11:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772048408; x=1772653208; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E6eg/6/iWGN6yvIdu8IOwUGupRbhzHe3YYFy7xHBxCo=;
        b=EaBLNIZPMbX8IalEG7HLfymlCiAcwgQXGfaaxeMA5pJ6ozK2m2Bpd1RqEPbpzoZMyD
         XWJQCsJ0uJAyMRmpALihg/CJ1FTtshdWoSVVKVVYeYz9u23ePU7xoeNpWLL1nWHqQQTn
         YABba1olCUzSF25idIuQX3Zkoo4/0vdE0i2n+gFCtD+wHCHEUj6oo02J/I1tCpCa0eTy
         WYLuzvel9aC0VrxbQnW/ba0X2ZqEn4lV6KhWHbB+VO2BJ1XjQd7sElMjXcUHxnt8aazF
         pLlWhg4SFOZvXECD+Wjys6ZT7QXi6UH+xNsshpLHWTrc8EnbjVduXCCdg5mGH7BGrDnI
         Or1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772048408; x=1772653208;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E6eg/6/iWGN6yvIdu8IOwUGupRbhzHe3YYFy7xHBxCo=;
        b=ZCgrquMU+yYTfJOl69lmo2b16CysoprHSDV6S0YCBlWAzqP0efo/1AlBX+anpKgbfc
         ojuAkTnOSbTARa8SZIx5Oyq0l09YjvY+tkLxbys1t4A1VNZ2NAPuiI8JF1OemvvJ4+JR
         v+b5sW19q/4v1HASaHBZsyM+hqkuD2HEJ+LxXYAd0xu+1+xLB4QbvmYfuvlLL7eTpzD2
         3B5dBEgG7r950zokVumxTIm2I4kqSZcT4vBP51fBr7mcVSNq168WjndYwareADCOvU2I
         YtAwSEXlMjfkA/ewhWUCikCUCSeNFL+f1p9a06LhwZGjdzQLtuVW6n2iRB/tdaJC7w94
         IxTg==
X-Gm-Message-State: AOJu0YxHRgxePJD8pI8zHtqWzFv+hk6g5UChcxcL5kpdvr4N44M7NFQ+
	yM8XfkdNuFKSHyS597Pgi2Ihhs5pQ6dPANw63DIxmaOvhFfmLIXkV1l3oDeY3vTUTEQ=
X-Gm-Gg: ATEYQzwIjPOsLSJgbKBcPmcM+p62evF41wToT44IB53aZ8VTg30ITo6dI1Nl+FNiM3z
	nxt/1OO9diUsRQJq2gHrtLD5NHFNAkGtapa3TOb0TFVo8fTprK+Z3LCuhQHImrDgl8ZZC1AhTWF
	4deM14qrb/kmUvjBi5hxWfTWN/zEsO6xL1+WPLAWMjmF/v7Kj3sN2tx4vKLT+lMHS78gXxywVeb
	OZ3On76GGtfVXPbHb67s/m/Gf7kBIFu1sKTsAsrfe9dFzKmO4/OKNZywcuWPmxoeXTn6tdsnmRJ
	nKrkEDbQWdzdiD2BnpX0KuKX3kVsdCBwg2yweY4lC0SJAEdejCEJDmIL7VLkeSQBgTeb/l0gcPI
	TwPxDMghRp4x5ODSvMw215cU6tC+P4NWcJS+d9CZOcrsSEbcoL7+38rrzQsgmd1HohNvMABewO8
	TEFPAKinXDyotSvyI6lr5pDcaM2M32QybpZUXnDgblmC1D9QVaffQH7MZtEX7XiKDcOTeQ
X-Received: by 2002:a17:90a:c887:b0:356:23be:7ecb with SMTP id 98e67ed59e1d1-358ae808fb4mr13664176a91.12.1772048408149;
        Wed, 25 Feb 2026 11:40:08 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359135ef1d7sm1966201a91.5.2026.02.25.11.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 11:40:07 -0800 (PST)
Message-ID: <805deb11-cba0-4567-b296-7ee35febe18a@linaro.org>
Date: Wed, 25 Feb 2026 11:40:07 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] accel/kvm: Include missing 'exec/cpu-common.h' header
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 xen-devel@lists.xenproject.org
References: <20260225051303.91614-1-philmd@linaro.org>
 <20260225051303.91614-2-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <20260225051303.91614-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-71876-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 7E7BA19CC56
X-Rspamd-Action: no action

On 2/24/26 9:12 PM, Philippe Mathieu-Daudé wrote:
> kvm-accel-ops.c uses EXCP_DEBUG, itself defined in
> "exec/cpu-common.h". Include it explicitly, otherwise
> we get when modifying unrelated headers:
> 
>    ../accel/kvm/kvm-accel-ops.c: In function ‘kvm_vcpu_thread_fn’:
>    ../accel/kvm/kvm-accel-ops.c:54:22: error: ‘EXCP_DEBUG’ undeclared (first use in this function)
>       54 |             if (r == EXCP_DEBUG) {
>          |                      ^~~~~~~~~~
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/kvm/kvm-accel-ops.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

