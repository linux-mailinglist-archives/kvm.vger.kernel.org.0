Return-Path: <kvm+bounces-40412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B66A571B5
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:29:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B44F41898FAE
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19E425332F;
	Fri,  7 Mar 2025 19:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SoJtJbt8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B3424113D
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375749; cv=none; b=FBbwSs2w+a2VkOMHoGW3BqFg5/M0qbHiB8Coba3rsBQ6/Es0CSg1z75siXsiCiPU8xJIgXtWjClBDbDyPUPt644msUJGPoyr/sqR60QBD/rL0iqvFQdLibhSeLO3qhBmneOx9eGqs+Wy/+TQSdj2KO+i7dkm8bs0eGIULrzv4Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375749; c=relaxed/simple;
	bh=a1a21yFsHy8amlu0Si4PP01+Uw5YIfl9WSWjmUKGCLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S37MkhuHC7csF6c5crfswHvntU4+zAbAMaLIy1MeCLTooLZ7flZKyFabo4hJx2ey3Zbqr+oRPjehgcLRaK+WGXcBFBJ16Go/fUcO/xQNWhlVMfvpMEUagVP2e4AnI00Txb8QSmRWMW07V4j9BloG1YmFqIerD/leom6flEKGBaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SoJtJbt8; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-224019ad9edso56028495ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375747; x=1741980547; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vM/4GoJmU4Et/K89F5VksEx/cMGKR1QrYk0VLQEpzK8=;
        b=SoJtJbt8Lhx7nDVAm4lf0JYMv59Fd7VOqI1vcfJiKAbtUFUGy0FscCEoYz6NZxDYDP
         17eRa31zkBkd/BDiVsozXqTJcaCg18iIkmlJeLWWTZib24RJuhIEnv7CHBjFTN+BQu1p
         AUrujyQlTIB0Klp0wiYwNEm6XQ88oamsbebVnn9aPAgsoFs4NO/g43SFHARnTjmpGFkW
         V9HsnTQYtjPKYmR/X1IZx8eoahJn7QGJYJZHpRWnXoilh9Lus92umnUyykDTa/mUwX/P
         GyVFUh8UlP/44PRU27uVZ7eRWl1TfM5g67oSb9nXL4CT9D+cYE/khn361n4P/CxVERAt
         FU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375747; x=1741980547;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vM/4GoJmU4Et/K89F5VksEx/cMGKR1QrYk0VLQEpzK8=;
        b=A67524T0GaDVQMdSv4vvq+A/XAWovtEuJzGbijUD05JHcQxmjYw6H5fpnbZUX9fBhV
         tGNPn/eDnJLstZnR9NcIR8uZ0pKAA1A631sUgY8fs7A+Iz8vEZv4gxwMM4bBIyDrwFND
         QRFQmY90XQATXk93qNX8vjLf8njky1G4P+8Qoeb3u1EPDXcScbMllbowXZrt2c5/eBjP
         J+HbuHDZtthDPoVH2GLoQyzGif5uQ6krKu8V+XFawUjOyzA4tIm1FDWBFYaHNUDQbYwK
         iqs3hDIR7j7SJIGKWzeHsKw83kH/KxoTna8Kn3+rJpV1GkKfTjT/gkBzdre93wpVfqOt
         TywA==
X-Forwarded-Encrypted: i=1; AJvYcCUC5B3H+V7dKVM+TjVOCoqqh2PI4ET0DhwZO7cYR3Y/uOqFePKjiKpLPGNTqBNdIFb1224=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0+DVZHUfPf4XO6y4jjsF5Zx+LzCFGmwqJmA94ULnEwyfbvYAT
	yc5s8M/fl1+FH4v/kbZwV8fL44T/CJzIrsV6k59BBa2epObfPtAf39sHRg2JkJg=
X-Gm-Gg: ASbGncvA1GggaFabEnMyOrXeJ6OgvnkC4fjwy+ZAMJyr8fuhQ+235eQIyDrvAdYoVAk
	7oeak3qTK7s+HnzLIQeDBZTtKTeZCNgKHXMcGHj1XWT3QtuaeBaAG8FiNhtVTDp5pLwBbBYjAap
	zDfxwqwhHleMuesne7PFeT2yCNFvZMNulYYFUkrsH6vxSTGPJz/CC/CzmNIUxKeQD+CAWdRAsqy
	LE/U74AzEtGC1s4nbcNT1/zgzoC/BafgtZAm9fpRJ8D/DlhVVv18S2Tl51Lo2SeJX6MNGOEFxa/
	Yt2fswqdSlSMWCRcrirHPDKxzfmMTMh+awAcxEC+r4uDllkpKTmgBsSDCRasa6vMf6pKsMtQJup
	YUWlPxP2k
X-Google-Smtp-Source: AGHT+IEvHDSiQH/iV/bTf4XBW74jV5IfsDWGNX3u1y+rGlmccMUjCSOJWBwalVKFe1X3KfgPpwUc4Q==
X-Received: by 2002:a17:902:db08:b0:224:24d3:6103 with SMTP id d9443c01a7336-22428ab7321mr86229875ad.35.1741375746847;
        Fri, 07 Mar 2025 11:29:06 -0800 (PST)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109dd5edsm34064985ad.37.2025.03.07.11.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:29:06 -0800 (PST)
Message-ID: <46f3fb62-1b2e-4f49-a28c-8f1040d9595a@linaro.org>
Date: Fri, 7 Mar 2025 11:29:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] hw/hyperv/hv-balloon-stub: common compilation unit
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: philmd@linaro.org, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 manos.pitsidianakis@linaro.org
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
 <20250307191003.248950-2-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250307191003.248950-2-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 11:09, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/hyperv/meson.build | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
> index d3d2668c71a..f4aa0a5ada9 100644
> --- a/hw/hyperv/meson.build
> +++ b/hw/hyperv/meson.build
> @@ -2,4 +2,5 @@ specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
>   specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
>   specific_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
>   specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
> -specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'), if_false: files('hv-balloon-stub.c'))
> +specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
> +system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

