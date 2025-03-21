Return-Path: <kvm+bounces-41672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EBE4A6BE61
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 226C4189AE14
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C7F9461;
	Fri, 21 Mar 2025 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N01XIK1x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611171CEEBE
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742571392; cv=none; b=TXKtWibEI3p3XnRN57JyAhD4/QSpMi8C4AlvJ1Qt0QJPLd9z7tgEyDHnMEXHdOBN9i/WGDwKF8YPB2/nK0qZAqAWJ09kyL9BzbiQCFo7X6DLHhIbNq9SMoora6U/nww0h4UMu+NGoixKttQQ6K4Zqk0l9Ru/kr4BU8ebl77SjXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742571392; c=relaxed/simple;
	bh=dEuyYzVZ1nLw94PamDWiHGDaH5KsGWoSexIg6f+Nft8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kwElodqMGtAMvqdo24dzY9lgPAXWbmXjs+5oKxmpQ1IbEdoMDZJkmI1mXusPSKtx4oLR0xSg9IGDdVt3Vhs5Wz8R+gmxgzI0webqixlcHj7TABUX4EVOTbZDZ8qiXfSaLRs2DQYCJmdr4np94gS7a3R3VawUHrzDtkEyIRQOZiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N01XIK1x; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2255003f4c6so42513575ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 08:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742571389; x=1743176189; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1XrcnI8/sSn+DKJfn9g/ACfk6EsflbS3NmSa9fiFXcQ=;
        b=N01XIK1xaFPInLTioD4p1FuSWPakPn5umN2IyYWo4duqqxEKaJr41AugpbmwR2DoTf
         0/m1mAtpJAOwTIKn+NZhGTo4mkp/V87MMJbT+vhvFxO2FH5UpE6BKLfaohm0ibXbe3Qq
         ZEPbZvRq1I38stdxSUvXn9Lv1krdeeB38WUcl80i+Hw//L5ZsZrbEPSrSfSq4fsxK0CP
         nM9q62QMmPHDSuqu7XYbKW0EQIHpeuFs/pw1p6ph0fWX6XNmGapI+zKGv6CUh9odMCns
         HLkUwHYku6kP10YLMB7PatejtC8Q2WKV8c+od2Cmrn195AN0xMm6Yk+qtWzg9fpjOEDX
         gGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742571389; x=1743176189;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1XrcnI8/sSn+DKJfn9g/ACfk6EsflbS3NmSa9fiFXcQ=;
        b=vsYMCd2o+veEW2Mu64AuU3R2JAKnzwVxIpt793LPH3YD49EakIfCmLyUfkY4BCDv/J
         pq+SS905mr8+6uWtpHHDfXR0IXwMUfCofg/G77nHs15Nbg4o1OonaF6dmpR67PALqzzU
         +qc5yiTfOmESNg5KdDgNSIlzIKbIrQfTQfRjSmjzMOwib/WEaqxUselgOGC/CQYXfBcY
         hdqhZbFdQ2sguOLddxPR9tZGd2SNDe5EoecgHRVYhWSTIWkJpYpUqlmT1PnZMTU77eMV
         ZI11k1ME9IoE1iyZ7msWZyglitajjhhWtbOm/C98P/0WoLsp7Tu+ugyupBr6xhtORYET
         gtTA==
X-Gm-Message-State: AOJu0Yx5bW8MDVGS5JsRXZ8YdfQTHyrJPtXkmQUPwhBva/Y3jFdF4V3Z
	Vk3pC4arvHsSt0XbeyudRStg4jAS15fKfy/Q8fLnKbq8/rI3jB8kHE2A1mvNF5M=
X-Gm-Gg: ASbGnctR490YK6AEz92LJFk8fLVJNAO68F8A8Hqxz7CXegz7wMAwK9Pywa81jz0nnhV
	isOBXyCsy/mV8fJjn8iPftWDNAM1DVKNJ+lPVdBue2JBCkHILsz/58JS5LzNXrTRuBystZnGeyt
	ETU5zzyX/zS5TXkriNooIuk7gu40w36u0zmlTz7TOwfd8NADlgu4cZqPyJtack/clHLaNVTOwZ+
	sOOQA+YU4EXYRjKNjgg22Autri0rpg/F7bibLXdKBF5u+J9qHqxWxwogBav5yDhTE6CgWwCn8LQ
	JHmH6fxg/N87fLye2f/oeBG1coRNDb9yY65raOaOg8v49b4PM73k1M/Ih9ChCSkOSYF5a2g5+Bz
	msN1GbRCA
X-Google-Smtp-Source: AGHT+IHJWViTwcKfPKoLy1dU4C8myvJLYRcls55PV5nSU6Vmh6oW9S11ryDhM4HtSbU3j2AR+5qbTA==
X-Received: by 2002:a05:6a20:c997:b0:1f5:7c6f:6c8a with SMTP id adf61e73a8af0-1fe43311d2dmr6722330637.35.1742571389478;
        Fri, 21 Mar 2025 08:36:29 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a28467e9sm1611739a12.37.2025.03.21.08.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 08:36:29 -0700 (PDT)
Message-ID: <85f93712-7612-4016-9fd3-4f8f135da95d@linaro.org>
Date: Fri, 21 Mar 2025 08:36:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] exec/cpu-all: move cpu_copy to linux-user/qemu.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-4-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-4-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h | 2 --
>   linux-user/qemu.h      | 3 +++
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
> index d2895fb55b1..74017a5ce7c 100644
> --- a/include/exec/cpu-all.h
> +++ b/include/exec/cpu-all.h
> @@ -32,8 +32,6 @@
>   #include "exec/cpu-defs.h"
>   #include "exec/target_page.h"
>   
> -CPUArchState *cpu_copy(CPUArchState *env);
> -
>   #include "cpu.h"
>   
>   /* Validate correct placement of CPUArchState. */
> diff --git a/linux-user/qemu.h b/linux-user/qemu.h
> index 5f007501518..948de8431a5 100644
> --- a/linux-user/qemu.h
> +++ b/linux-user/qemu.h
> @@ -362,4 +362,7 @@ void *lock_user_string(abi_ulong guest_addr);
>   #define unlock_user_struct(host_ptr, guest_addr, copy)		\
>       unlock_user(host_ptr, guest_addr, (copy) ? sizeof(*host_ptr) : 0)
>   
> +/* Clone cpu state */
> +CPUArchState *cpu_copy(CPUArchState *env);
> +
>   #endif /* QEMU_H */

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

