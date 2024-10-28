Return-Path: <kvm+bounces-29855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9CE79B31CC
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 14:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E1362848D4
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9E31DC04B;
	Mon, 28 Oct 2024 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NYs+3bbn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AED1D5178
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 13:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730122530; cv=none; b=pxoKbRzpyNe+ApGIXvaBFZXldKcCtgXHhlTGJlJXHp1H69C9KGKLYCeU+xNWxhRCVmvY2Y5c4SO9xk7o5gFFRWdMS/cWiwZBdgkVVLXhohq+owRgvoFD+SpOODdu0mS0mIFYWJOBmt9TGaKGu1BY/OuQbOFRhZanpGrWKXi3qlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730122530; c=relaxed/simple;
	bh=HNBks9e1vl34WmEjVbpxdvo08eotgbDW9SoN+CEgU+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f6OZQ5yJUmehMccM6uwvSfUeA3QuivqteG5vd185RaiUDdsKLIWiZavw8l1lQl0CswVNKfQMMDLCB5Hx08bJw1TyvPjUOlDUz3OLUORnF+c7pztQL+oZpbc+m+SlHIpa3270TYeA7YOVq2QEASiKRdKFrXw8zK4Z+Dx6WdhVEIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NYs+3bbn; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c941623a5aso8603562a12.0
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 06:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730122526; x=1730727326; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aakmLMmCxXB7wpvkPBt3r392oce9ATpj+r1roqlA3L8=;
        b=NYs+3bbnN1KTnfPOGzEPmX4UmOaVKt7c0ic0yN2ZkDd1gckcuOBqPUazn/zO4anTsv
         GFoyehvM0XQTBeU8n7ympvstoJttjzabVQKdTPaUAbFj/ZvZIQEjFXxUE7sx9EaJHsUf
         +vEHzv+ZlgQQnVnEwO157J8ApA26+WqrxKWlXZbNkFq4QNGDaRavH6rhfJcejEFYUytE
         Gz/uuTTPeWLfhxEnM0v1C/59TlwwJmqlwHdWkjSO3BCMxkvORehQFgxbrOOpS2EPcBy4
         CvZzCyeqatjTeXwNH7xYr8yg+Q4jlLRW8HVa5Q51wDRmzoJ8/DJKipBHwyqbhrOvvFtV
         DCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730122526; x=1730727326;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aakmLMmCxXB7wpvkPBt3r392oce9ATpj+r1roqlA3L8=;
        b=vlVMMsx5qRzzAK5i2z/rAt6hfpavIiqtREJFlzItIT8jF7EneylsXsdzf+uHvOX8PZ
         FyxO/UcgbQxL8LKPYKsNqmCNap9NXTT+4XkWxM95OaB6uD4bTCmHgpVieaKchO01VF9x
         OS48XrD/pKXe8/9hvbDdBIqbsPn6TpiKfW/gH3f86bF6d2ahF6l0fPgOkqdRv//5cmel
         uydDrvb8nQhIo2y6ic7puNpQ8OZd1+jg8T1Cn0JiR05yRLxLRTNyeyYg3pV6+rUPcbVj
         Ii5/e0+MndjM8A+b2QMCzlSdns8QWktDL3aBXICVQngUq0BWSnayC55CrsHYbZD8FVQC
         Rgdg==
X-Forwarded-Encrypted: i=1; AJvYcCWW24CWxZtzPO/F3SaXWN9Da9Y5yoE4fdxc7eXwWtvHfAzJ6fma0XV0IPswRJZ6wXSF7Mg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCYzGwTGwY5X4S6JxcmFBEUPeLGLgPtplpkNr5tq5pmdohE8en
	v2v9WPwpdHGr4V7cQpZMVwX7q6fuv0TX/tNkkoohVARvIMFsOGdIfyiBl0Zi8PI=
X-Google-Smtp-Source: AGHT+IFRZYdc1FZgv9Sm+y05+0k0ikQkXWpLJMCtLfi+YlSesKp0fLzYfhcuL5wkvAKY/4NmpykgmA==
X-Received: by 2002:a05:6402:268e:b0:5cb:d554:4090 with SMTP id 4fb4d7f45d1cf-5cbd554424bmr4438909a12.14.1730122526300;
        Mon, 28 Oct 2024 06:35:26 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7465:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7465:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cbb631d240sm3140487a12.59.2024.10.28.06.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 06:35:26 -0700 (PDT)
Message-ID: <37561b9c-b012-469d-adb7-c301829c1863@suse.com>
Date: Mon, 28 Oct 2024 15:35:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/10] x86/virt/tdx: Add missing header file inclusion
 to local tdx.h
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, adrian.hunter@intel.com
References: <cover.1730118186.git.kai.huang@intel.com>
 <3f268f096b7427ffbf39358d8559d884c85bec88.1730118186.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <3f268f096b7427ffbf39358d8559d884c85bec88.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 28.10.24 г. 14:41 ч., Kai Huang wrote:
> Compiler attributes __packed and __aligned, and DECLARE_FLEX_ARRAY() are
> currently used in arch/x86/virt/vmx/tdx/tdx.h, but the relevant headers
> are not included explicitly.
> 
> There's no build issue in the current code since this "tdx.h" is only
> included by arch/x86/virt/vmx/tdx/tdx.c and it includes bunch of other
> <linux/xxx.h> before including "tdx.h".  But for the better explicitly
> include the relevant headers to "tdx.h".  Also include <linux/types.h>
> for basic variable types like u16.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

