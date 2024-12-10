Return-Path: <kvm+bounces-33435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2182C9EB609
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 17:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1A561884739
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 16:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132221BD9FA;
	Tue, 10 Dec 2024 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a39Xg+HA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB74319D06E
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847641; cv=none; b=VGMf0hkUXFRhq3OVD+hGfymXNDJeKzu5/Z6Jdoa57XfYlgTlpuJ4xRbqFxVv5PpOEWzPU2CnkSVAqg8a/ctSwMwU596xk0IYMX2bNMEx3SM5E2FBkdnhKG769O3IEC9gczX3aG4q+AjkvzG/wnm+0quk2JJZvWUIOIwxo8LEMUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847641; c=relaxed/simple;
	bh=SwFKuuyDrUKR3aTUFbR7hOjvNKoNeq17ciZQCDPGEf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iVIAS/MEgtdWxhnpCR6MzBwTjpGfo5LhD1uRzhF3GLDuF2Rnc5mKzls3g7xE6VtZGktyCbzSLGkWJR0iRaSQ+HVB8TPg+z1d8Yk2nE1ilyqUYohNCQWbPYlvZw3530L9qqpELUA/oimEr/1JisJ3fkXo0b586ydyJR5qwyhj1A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a39Xg+HA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733847638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rY9ynKcb4HkcQm4ahyj78rsPHrAzL68gixkqyxtJ3R0=;
	b=a39Xg+HA2MvVTlNrhLvrVmU8Kx/K/f12Z1vFP2Hm2LbcELLMPP6C104072FbRSel2XFXw6
	3hmT7kgnlT+aLu2Snxv6rDMy6dwIIu2xKxdtgBfk8xqh6U4yDFKBoX+yhb1U4r8nZahhED
	wW0PgNzbU9oXHO65L+imLwHamW7JtMQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-wlE9eDunO1iO777KSM5UpQ-1; Tue, 10 Dec 2024 11:20:37 -0500
X-MC-Unique: wlE9eDunO1iO777KSM5UpQ-1
X-Mimecast-MFC-AGG-ID: wlE9eDunO1iO777KSM5UpQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-434f852cb35so14833195e9.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 08:20:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733847636; x=1734452436;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rY9ynKcb4HkcQm4ahyj78rsPHrAzL68gixkqyxtJ3R0=;
        b=Nnr7y8x7WvXGDMxIHv6VAR1l9VgAnUnrO+EZO7NCnSu/di1KHWBhkhdXAXY5Q4Ycx8
         dFLNayKsP9gSC7GRRQxEZTxRcgXuiyA4wlJPZnSwAbQRVLCpgfRXArF0QiQyZMxF2ii+
         3lAjgVCJhbT9IlRM4ZNQSHUAg/A6nYrbFA9kyy+ezG45Tl7kCWK1jx7k398NvATPFB+c
         DjUgWUDzqeTmrj5uQHjJM2IOVHYBpZ0ui+F6W6S15Sq3+MS3hXvUznUogRypLFpucE1J
         E6FXivE4KzJgycWhAOecMviPF2XJEnKThWN4YvNZetcad9ay2IgKaFq1hLsfezlKQJ92
         Nncw==
X-Gm-Message-State: AOJu0YyynEk2yqBfJTL5xpY9NvmEHVWDLCVbnC0J+QQad2kDrQsOrtEQ
	URhKtv23GmnhQiqnZ+aO7ng1Q1o+SD3QgDoyvB6fNditurijKQYqOEKgUssO/25i9rEUU2vF8Z/
	l5wy5PwARrQlKbI3V/iIC5SlAHbK+xXr4mpgP8NkyFc8aeEg8ug==
X-Gm-Gg: ASbGncsPfuqmUqjjcfi0XDnaTuXkXucjfZW8CxKWxY5lQdXSBaH2KItmCqevvXAnUrU
	drEN5n4PTYv6FTI2TaFxjzxr6z1z5APkZmmnreB1zI/1OUD7WDBLITk75TRoZPNxjT/6ugT7yLO
	by0Xx0YhrVxjmV1QAlwKYq/IVlb2QrNgmWLuUU3bjrR4cCxIupqe4BEBKqS49Ww5qe4NZ7vi6ls
	ctRrgCaE8NkRR0LxIuU3zhQ3fH7lRjY26nG1J68DG0cOfgQdlqmnEGj6g==
X-Received: by 2002:a05:600c:46c7:b0:431:6153:a258 with SMTP id 5b1f17b1804b1-434ddeb5afemr143960875e9.13.1733847635987;
        Tue, 10 Dec 2024 08:20:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXIjd0UITMZZ1RM704dGj2qdkRrCQvXjXoueuBP7gFX4aGt9NVwuRrpIaPAkDiHyRSI9zcPA==
X-Received: by 2002:a05:600c:46c7:b0:431:6153:a258 with SMTP id 5b1f17b1804b1-434ddeb5afemr143960625e9.13.1733847635615;
        Tue, 10 Dec 2024 08:20:35 -0800 (PST)
Received: from [192.168.10.28] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-434d526b577sm236701455e9.3.2024.12.10.08.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2024 08:20:34 -0800 (PST)
Message-ID: <6423ec9d-46a2-43a3-ae9a-8e074337cd84@redhat.com>
Date: Tue, 10 Dec 2024 17:20:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] KVM: x86: Refactor __kvm_emulate_hypercall() into
 a macro
To: Adrian Hunter <adrian.hunter@intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-7-seanjc@google.com>
 <90577aad-552a-4cf8-a4a3-a4efcf997455@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <90577aad-552a-4cf8-a4a3-a4efcf997455@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/24 09:38, Adrian Hunter wrote:
> 
> For TDX, there is an RFC relating to using descriptively
> named parameters instead of register names for tdh_vp_enter():
> 
> 	https://lore.kernel.org/all/fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com/
> 
> Please do give some feedback on that approach.  Note we
> need both KVM and x86 maintainer approval for SEAMCALL
> wrappers like tdh_vp_enter().
> 
> As proposed, that ends up with putting the values back into
> vcpu->arch.regs[] for __kvm_emulate_hypercall() which is not
> pretty:

If needed we can revert this patch, it's not a big problem.

Paolo


