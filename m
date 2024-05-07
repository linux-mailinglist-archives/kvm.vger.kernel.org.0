Return-Path: <kvm+bounces-16835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF1B8BE48A
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C4F31C23F21
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 13:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801A115B995;
	Tue,  7 May 2024 13:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gFiAx/6R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFB915749B
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 13:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715089501; cv=none; b=C7kcJahNWxefe7BqdWEghClQN5Xc9sklkyIsvpsMnXahI/vMPMCFEy3kYgrYjk2zHyxBxrIm5WTTLswEFXVB/ldTIhjDcPT+VFlPUb65N0EeraAK96FNyRwJx/sDJk86hfZbQIPLDFGYPR3/EwEXyrdxzOH91XPgWFnQHfNLk14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715089501; c=relaxed/simple;
	bh=+bNDQXqB0ICXwjYLuJtytTUQJ0+O4EkcisNGXb8dTOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gItu4M1eTF0CpAMCh2IHBg3+krskr1mK3qldIulF/e4DslpadVlB0frxJ6aJYACq5uiWpXf8sJWL/lGRzuA1vZZFTMBLaUd3+Ho5AxvBpDaoPupT3Thzy49bRX9PDMc+zpZaoklbjgpqfRLFXMNjjjP9OUOEVEGsSSwbswJuJJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gFiAx/6R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715089499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cuOOW5hFW+e043fKAt9ibEnfcrSGUuZKCUCPWRzssgg=;
	b=gFiAx/6RaV+XJHTaxeTvnkwDNbRWzp33tThPEKPa84opBu3WGAFIkY9BxmU1cNQ357KRBR
	2ieCncNDuOjuQs5m7rWdDa1zOBxK7gaMbnu/6gcGS+fK4XJWwJ0Q3U5xR8N9+SlELyLmD7
	ZtXVBw9Lpcv/1T+Hz+p8rNx+fU5FuS0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-zXuL6A6MMdy98fUzQxGcxw-1; Tue, 07 May 2024 09:44:57 -0400
X-MC-Unique: zXuL6A6MMdy98fUzQxGcxw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-416ac21981dso16791135e9.1
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 06:44:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715089496; x=1715694296;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cuOOW5hFW+e043fKAt9ibEnfcrSGUuZKCUCPWRzssgg=;
        b=GgixL8ZkWC9qUqlQecAfUEPW0WP1uEvbX+I/OV6yn0nkNNAiv1I6kO83kbs8dhkTgK
         i3GXYeycAHIZnK6AkmTtL7SGa0Zu/l9JnQU76J4CUON60F/qIxk8hVrICdGsv3Bk6FA6
         zVmeCs2lSOmrAgzC+tgS8ADVtB6DOyz4OasNPOFAjhoyZ7wWrGwaxZCD2tmRM2kzRxul
         WZMyPKHWkxRskW/XHQ8zUPDBd0Ty5rx4ejvmq8u/hox0i6s1V6vhaC9RPIk+WVOifL8A
         W1iVL5L8Y05V5WoJnNi72Jg5WZ79l+dxfUFbFezR7Q8A4VMkN/8nmKVq1NQAQPeGfE66
         TKyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVotWWJqxpj7gVmFZaISNKo0l4wIsbHtdS2H28D8G5xBPeOsYT2TxSDzrh+47j50qK16rJLVmoyNCph8Pagd5iphxYP
X-Gm-Message-State: AOJu0YyByP/VmOIsHzwjkVzHE0YutxBMIwxLmcUxqOttEs3nx29kEo8N
	/SHoqgyI6gcA17cOWEx5oqp7397j9s4nyaSc0kCvN1cjTIh6QkTcqCQHhzOkTlRhHXxkucj4Qd3
	FjtZ5LvSd2IIt0lmVGVbNxL3KoCw3CVZu1SUTh1e69eyZ6IT76A==
X-Received: by 2002:a05:600c:4f14:b0:41b:8c5c:31b9 with SMTP id l20-20020a05600c4f1400b0041b8c5c31b9mr2606812wmq.14.1715089496633;
        Tue, 07 May 2024 06:44:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3Rs2CKErgkGtZtiF5XiyvHmonaB0XC3+Hm4t95muCGcRheCCRav4n6MAZU914TGsXE8rCHQ==
X-Received: by 2002:a05:600c:4f14:b0:41b:8c5c:31b9 with SMTP id l20-20020a05600c4f1400b0041b8c5c31b9mr2606801wmq.14.1715089496317;
        Tue, 07 May 2024 06:44:56 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-40-241-109.web.vodafone.de. [109.40.241.109])
        by smtp.gmail.com with ESMTPSA id iv16-20020a05600c549000b0041bff91ea43sm19709076wmb.37.2024.05.07.06.44.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 06:44:55 -0700 (PDT)
Message-ID: <b1cda6d5-4a1e-4349-8cc6-1f1ca866c24f@redhat.com>
Date: Tue, 7 May 2024 15:44:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 17/31] powerpc: Add cpu_relax
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-18-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-18-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> Add a cpu_relax variant that uses SMT priority nop instructions like
> Linux. This was split out of the SMP patch because it affects the sprs
> test case.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/ppc64/asm/barrier.h | 1 +
>   powerpc/sprs.c          | 4 ++--
>   2 files changed, 3 insertions(+), 2 deletions(-)


Reviewed-by: Thomas Huth <thuth@redhat.com>


