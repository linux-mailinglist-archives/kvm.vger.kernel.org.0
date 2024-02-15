Return-Path: <kvm+bounces-8764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 872CD856497
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 14:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73876B2CF11
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 13:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308E2130AFC;
	Thu, 15 Feb 2024 13:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LdUzMAYS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE57D12BE88
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 13:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708004150; cv=none; b=egFowOSOg+eXyuIovkuT4X1kUQ2vx1WSXXtacjlQhIhxAf5AsaQ2k7MwCH+Il8fMQEdurLxI/MNcs43TbKFIiYHqSltgpoTmoQ9p9mO/bTFDPLN6q5CvEtqSe/+WWRtnO9Gjk8pqwcmv/ZOy8Pc//hb5kB3NJ1xSydhN0VN3dvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708004150; c=relaxed/simple;
	bh=20piVqpde4RqY3y0TzGE+6g2PggMnDnosLc4y+UW99s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rX06Lg3YNeOqMMx40qyPHk+RRAeNeaRIYEaNLW/2gADI3jPik4w04s/ifALa8kf/VkyTwgErX2ucCQi3lY4I5pluScLdhstwQ7QJ/df8BIcdySP9XQRLj7DEbLGS7ZPiY2wSSSujjQgVJ5bl57YqGscMYBk6yQhTSW+/9osXRic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LdUzMAYS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708004147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=20piVqpde4RqY3y0TzGE+6g2PggMnDnosLc4y+UW99s=;
	b=LdUzMAYSKrK+ZFxg+UcWSogaYIjQZiuB65uNhu6RSkwCDffpTLizGXmVp8P/RiBKoANYqr
	2cr81h3hcOPMzXFJN8Xd94HClX5mxQWHttqHgP5ZDjvXEO+T+GeqHImpoy0XdciYpHRavW
	nPqeH2bLhFdKS/jibjm2+0UKwBdFPyo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-echnFo5vNV63Du6KFH1QTA-1; Thu, 15 Feb 2024 08:35:46 -0500
X-MC-Unique: echnFo5vNV63Du6KFH1QTA-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5611e1da4c6so610211a12.1
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 05:35:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708004145; x=1708608945;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=20piVqpde4RqY3y0TzGE+6g2PggMnDnosLc4y+UW99s=;
        b=Tq9Xog3w7salgbK6FXOeZfTnwmCyrm/2jYlPsjm5VoS8y7gF1EGVmxIwTnRPAdQRM4
         GuJBxPXibxmhe4dh4eWvKlNGJ2ycZTFCWGnNtXsXGiV40sLGWpHMS4aqzVz+OSBLwiiG
         nqW/cxnT+n0JY9N7LrvMuo0QLPAIHxWf88BrTwT7XqTx1dfTGtNoTrOaj5QSdLoU3JEA
         edtwpKl0TVKLSNk2pTsfBSPIuDuPbqzZ+AxSAmTMAm6/yw1LMY9nNc/q4o3m/sIeNVvz
         h6N0wE/BGQM6i07ceT/M02q5J2CdvW5cozR78JvQJBSfyxDSwgMJblLC9I/8w2B11A5K
         ejZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFHWg6z4hyCy57kDUeVN/112jy3QKHtxpEEq6JI+VwdYroa6B6oXJbdxDVAqprjZdcGnDcs365XI+znsao6x6SMugX
X-Gm-Message-State: AOJu0YwSG9o3dB0idBNur20Fn2gRdk5gViUB5OetyhwQX3E/BkcY8RZc
	gxm3swdQr3j09ecgWrzgG2wKrIYajJIvseqPbFAoMcZ2NfH/L5WzWvHaI/3GeQE7FNjkPOYHst8
	7ybtZNUImw70kZHdkwvqxP9L7nI7JfK1p2+kj+ANdyu6fsaJYpw==
X-Received: by 2002:a17:906:e209:b0:a3d:a650:e5c with SMTP id gf9-20020a170906e20900b00a3da6500e5cmr817629ejb.29.1708004145425;
        Thu, 15 Feb 2024 05:35:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvwTkJbVnAshk1LTQZ19nIFvBJCziSBfAoCbrYbPMpTlj1lX6UFxd9eoPIyuhNE2CuS09YfA==
X-Received: by 2002:a17:906:e209:b0:a3d:a650:e5c with SMTP id gf9-20020a170906e20900b00a3da6500e5cmr817609ejb.29.1708004145089;
        Thu, 15 Feb 2024 05:35:45 -0800 (PST)
Received: from [192.168.1.174] ([151.64.123.201])
        by smtp.googlemail.com with ESMTPSA id o15-20020a1709061b0f00b00a3dabd0fdddsm238738ejg.15.2024.02.15.05.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 05:35:44 -0800 (PST)
Message-ID: <de6f7789-a9a5-4ff0-b0a0-3f0e9b439580@redhat.com>
Date: Thu, 15 Feb 2024 14:35:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] KVM: x86: Add is_vm_type_supported callback
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 aik@amd.com, isaku.yamahata@intel.com
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-8-pbonzini@redhat.com>
 <20240215003358.pjqfz3zik3s26nwt@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240215003358.pjqfz3zik3s26nwt@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/15/24 01:33, Michael Roth wrote:
>> +bool __kvm_is_vm_type_supported(unsigned long type);
> It's not really clear from this patch/commit message why the export is
> needed at this stage.

Yep, I'll remove it.

Paolo


