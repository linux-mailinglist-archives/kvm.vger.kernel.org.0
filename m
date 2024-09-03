Return-Path: <kvm+bounces-25737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 523D0969EF2
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8609B1C23F8E
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 13:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D06A1A726B;
	Tue,  3 Sep 2024 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dRd2bJfW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73111A7243
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 13:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725369788; cv=none; b=JFXCzYkNBehIPcyXRzSkx99/qk9VRj/CWpMTo85c2kbA1bW7qlv3e0vNUH19/tq0jBFQLRR80t+3Cc8GUAFERmQ3xn4IgE0nrpbrKW6DbK3OxLPewljK/04VZ7CyOix7kHB1POuIqi9GYLW6iI4SaQUrxjkOu2vQhPF9W8Ar8Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725369788; c=relaxed/simple;
	bh=MBvy2sx9Cp9cDDS5Cc7WfpSvlbtzriOn2RkCj9hgyHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=htTa9HfDRsZ21CTwKUnmXw5n8Ru4ghx1aO5ymd3u/jIYRvztIBMWPh2WFiKzqzNQ5FdYKpExfIUfvN4Kei0so+eTjw2RCgdAA4oCuU2n7aJu2F4ndJtjUfij3FJIAO1het42bSdT4lAt3etRO91m0hjlsxEETcd8UqFfZl1f1V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dRd2bJfW; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42bbdf7f860so35961475e9.3
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 06:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725369785; x=1725974585; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pg8rcKyfzksPWHkF9xfw83m8xnGdbzC5DTDw0vHAnr0=;
        b=dRd2bJfW5npWYJxIeVgDybJ5yDjqf8xjkimc6lqoVVDrUmAOlZ+x3Pm5N09sujLut9
         DX/5WWHgSRa+UaTJkEomDgA9xfplEz2mnpiQMIGsFNLjbsRVVX1qjOX/UWAoTiJMgMMz
         DgzH/svZy83X+Yii0x6lWfNrx3P0mH+V/Lb1y7gdbQ/GxDv4pfBoq4CVjkawft/dd2TF
         zvZq2XTSTEO2YiRqxCaQ22/By/i+cWba+GFI8TZ2aN1r3JocHnHwTHHctRfJR0p8iz83
         LIt2hRbkCVh7E8YrvDkPFDaFnt2Q4GnMciCrwaKAsQJc0sK5d7djAx7dE89P/Z6RnQQT
         YaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725369785; x=1725974585;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pg8rcKyfzksPWHkF9xfw83m8xnGdbzC5DTDw0vHAnr0=;
        b=lETF5twL7xWRUkxWdCZAoHs1J5EnbFlLXaVoKZHMset9CmVYJAyVaB40rKU4+wLHE4
         Sko052MHHHX8ZAZOBblfBd4I8BOqfm3ZY+KKL8pmpTR4aVgMBTegu02aSBSOul53vrUs
         0YjJzHUH6iGHrAJhezKi73dOdJIVUsMEHdD7vrFVfSOIvKRB/Bt0kUe4Jq/wgI1vSyfH
         APmifkLgW/K1IznPYEGm2xJP7u5VDOTBCp6T4zPtUGv0KOPNXOTI4AYYZMHjr/sqaf0p
         1lidrAzqC0E+13eDRx+5ikOLPYujXIqy0daDKUpSpr0pIGJNKwJhdic5oAS9z9il1rlr
         h3DA==
X-Gm-Message-State: AOJu0Yy3sV0HXgyc0WMn8zc+Z8KD3uSJ15x4yJjvGS7ppSlUN8mCZqLm
	7FVPr6BFPijZVrCXLpJA5vu8x84rj81b7ayJfdFyeq+OPxnwJNAmodwJprVNjMk=
X-Google-Smtp-Source: AGHT+IGKQc+yXbpf89E6xzb+n6mkjAr3+CWmzkUeJLmz100cO4mg1zCQhCR/Z9aIq+CvBN9nDXJJMA==
X-Received: by 2002:a05:600c:1c18:b0:426:6edf:6597 with SMTP id 5b1f17b1804b1-42bb01bfd73mr116331575e9.19.1725369784951;
        Tue, 03 Sep 2024 06:23:04 -0700 (PDT)
Received: from [192.168.1.67] ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42c88c624f7sm29604705e9.39.2024.09.03.06.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2024 06:23:04 -0700 (PDT)
Message-ID: <77b34e53-46bf-4bf2-b730-4ea0e7ce39a4@linaro.org>
Date: Tue, 3 Sep 2024 15:23:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm/i386: declare kvm_filter_msr() static
To: Ani Sinha <anisinha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20240903065007.31522-1-anisinha@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240903065007.31522-1-anisinha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/24 08:50, Ani Sinha wrote:
> kvm_filer_msr() is only used from i386 kvm module. Make it static so that its
> easy for developers to understand that its not used anywhere else.
> 
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>   target/i386/kvm/kvm.c      | 4 +++-
>   target/i386/kvm/kvm_i386.h | 3 ---
>   2 files changed, 3 insertions(+), 4 deletions(-)

> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 34fc60774b..26d7c57512 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -74,9 +74,6 @@ typedef struct kvm_msr_handlers {
>       QEMUWRMSRHandler *wrmsr;
>   } KVMMSRHandlers;

Isn't it also valid for QEMURDMSRHandler,  QEMUWRMSRHandler and
KVMMSRHandlers definitions?

>   
> -bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
> -                    QEMUWRMSRHandler *wrmsr);
> -
>   #endif /* CONFIG_KVM */



