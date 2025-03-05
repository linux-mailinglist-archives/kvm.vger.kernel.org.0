Return-Path: <kvm+bounces-40166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6845A50347
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 16:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2052188591F
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00CD324E4B4;
	Wed,  5 Mar 2025 15:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e7UdisB8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C94339A8
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 15:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741187755; cv=none; b=bc4JNMu4yEbc74GHFYo58Pkug8RiTrmdZLST4MwHQnXC1BW7zLYrgrc1IE8cANENOJI/we568WYLoNXFvv7BjHDmt2eHeQGtPX7Sj8bI2J6sGOM/joe/vNQ+8g4avgQbGOBBZAkfySNVs0yYdY4LPfIDQnv4uQtsKL6iA7Imb78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741187755; c=relaxed/simple;
	bh=4tqmMQtOiOKnGZ3ZxD4NeG7n/StDSWUcCXtqs+VM+1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G2PhJhijq4yg6usDHEluoEQ6apKAeVwF2izdDKhfT0caZiZtigdpf1PaG3tj3prYqTTN/n7Yn2o9puqjEzBMpT1GGSaJS0IDkQFPEI7mqTQAy0nSwE+Dvg6S14j/GYsoiSzgGlOTZyixAgtxZkpSt3t7AB3kBd/xMkheqJDul4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e7UdisB8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741187752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CiSQrfsCnakgAOeukHOOBIClm9MewAMTBuwPPuO+KAg=;
	b=e7UdisB85vT+4KJAcBjWxBwTPfWH69kgSaEZVWx2xe1OoUSyUl9ZZsom1xOmAXDekb8JNy
	FNKAjMkEKtx8cjlK7Atvj5VW8iohIFquRgUVcqVs/DG2dehoucVMgeIoCNgLbwRcihm4fZ
	vaRXjpxaJnuTXf3KyTfGC7jH22wdRUk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-1wQMR7MHPwOZGVvX8W5V9Q-1; Wed, 05 Mar 2025 10:15:50 -0500
X-MC-Unique: 1wQMR7MHPwOZGVvX8W5V9Q-1
X-Mimecast-MFC-AGG-ID: 1wQMR7MHPwOZGVvX8W5V9Q_1741187750
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3912539665cso293572f8f.1
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 07:15:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741187749; x=1741792549;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CiSQrfsCnakgAOeukHOOBIClm9MewAMTBuwPPuO+KAg=;
        b=jAs2mrdGa/zFiUut4Wmv6BDWDAWBCnzxVem6PmlRbrW73cGBUYAc6eXTNWRUC1iyYB
         eT+hCCwzV8JWxGJnzv+8mVTkh3PQa3u7G4ds9D1Gqb6UsVAuEuumhSqO4ZZq6HKwVUYG
         IVceDcZT9q/AHgKCig74B6Se2XoNGoOQX3hOmGGBtIv2vRe1EfUdYcRfRPAGgx6rHyBV
         idyiPORqCyOs0wk+nBTCN4fhHjP+k6KSj0a9dVSlXvzFPa5iF8i4FRJFpJBbgSnUfxMz
         Ljl2WlVwa6JVaLveqUczuFLRX+g50zJYwofgwC3aUqTEzVdK4xtDG9mQ55/UPdPEAuj0
         Oe7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMPPLucmFzvADvHvpjjZNkUTxakd0IB6IK0hAsYhbmFPjM3B/N4TLrqxeT/nuK0cXOqkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvUSTCugvCAnJeF9Go/DlTIhGNqHkyAhJqpUiLz+XMFgwnyhIF
	iA/er7iUAgZhhjK66pvR+l4S9yLAkTzpuKJElUjFECDyLNEe59vlhvfT5Lm25dLSZ0y8HQ7Jos6
	d55S2/5DAr8uq/a6EHTFo75AEIilnt/H64HnXbvEiFfXnmCDRiQ==
X-Gm-Gg: ASbGncsmwCuJflhKdn7/76O6OaLKODxmL6YAbEHPcG1c3trz/HcnY9Cy21+V1BAqeZ7
	w0HsA/QaLIv1FbwX/sXiQyEn9Eqm4192S6a8h1FmvdJxzfAYigeC7e5rLrO2VtxMgQBduOJvDH9
	j6H8TgtbG5MYZxEVS8qajqPa3kIQED9BWH1Jac0T7lpRShjFXtQVzA0pP8cwKCMcI6jHV04ZzWL
	/Sgd/l3FJAMm8S1CpqmMpc9JrDh1xxBWLTjV4TBhrwNdXPwXACUhMWm0xyB4+WgauWks5UNKX4W
	hNhn3tlX6lg5Y0BYW/VR0HYWSFg7AwusDBYrzF/sdcZu3J0=
X-Received: by 2002:a5d:5f4a:0:b0:38f:4ffd:c757 with SMTP id ffacd0b85a97d-3911e9cbb97mr2856994f8f.2.1741187748162;
        Wed, 05 Mar 2025 07:15:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEcUMEJxhXYSy5ju/XG3xJ3qA0Ba0Gk4MVgFGQ8BCtjKwcDbD7Tg2dj5TJvGKlZef/SJhhDmA==
X-Received: by 2002:a5d:5f4a:0:b0:38f:4ffd:c757 with SMTP id ffacd0b85a97d-3911e9cbb97mr2856868f8f.2.1741187746359;
        Wed, 05 Mar 2025 07:15:46 -0800 (PST)
Received: from [192.168.0.7] (ip-109-42-51-231.web.vodafone.de. [109.42.51.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e479609asm21023593f8f.2.2025.03.05.07.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 07:15:45 -0800 (PST)
Message-ID: <6cd29f92-82ee-4f56-b0d4-3b55b669b373@redhat.com>
Date: Wed, 5 Mar 2025 16:15:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v1] editorconfig: Add max line length
 setting for commit message and branch description
To: Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc: Janosch Frank <frankja@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250131115307.70334-1-mhartmay@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250131115307.70334-1-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/01/2025 12.53, Marc Hartmayer wrote:
> Add max line length setting for commit messages and branch descriptions to
> the Editorconfig configuration. Use herefor the same value as used by
> checkpatch [1]. See [2] for details about the file 'COMMIT_EDITMSG'.
> 
> [1] https://github.com/torvalds/linux/blob/69e858e0b8b2ea07759e995aa383e8780d9d140c/scripts/checkpatch.pl#L3270
> [2] https://git-scm.com/docs/git-commit/2.46.1#Documentation/git-commit.txt-codeGITDIRCOMMITEDITMSGcode
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>   .editorconfig | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/.editorconfig b/.editorconfig
> index 46d4ac64f897..03bb16cb9442 100644
> --- a/.editorconfig
> +++ b/.editorconfig
> @@ -13,3 +13,6 @@ insert_final_newline = true
>   charset = utf-8
>   indent_style = tab
>   indent_size = 8
> +
> +[{COMMIT_EDITMSG,EDIT_DESCRIPTION}]
> +max_line_length = 75

Thanks, applied now!

  Thomas


