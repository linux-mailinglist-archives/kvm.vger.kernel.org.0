Return-Path: <kvm+bounces-24166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96193952004
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52BA5282CCA
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511EF1B8EBA;
	Wed, 14 Aug 2024 16:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UtBqyk/W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69501B8E93
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 16:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723653082; cv=none; b=oIfSiM6fCyVZkayJtDR/bUDhiMGPf9E5FAerxvS4zYQul8TeAyFfK0MqQR4JRz5nJuVBOORDShmJK3cZqmAbo3Jje/pp215KDFeAMxXtWwXFxEktVH0JJk7smjor8du+JYOMAgThPG0+Um7//0Zg2/FRWsMGhbeQVVJmUu7Jq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723653082; c=relaxed/simple;
	bh=NxmivKd8kEPQ/sxZlRaqiuDGo9D8KwQC7HsHytxVwHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NIms9E95/ZPsIq87gHz22pLvUnAP9mfYrlDLpECW3yKomVfv86DscPPt9QfD6hvif890L4io6nKi9Lfmv7nseUq46lZ89SIBKCH5ZGsmskNcRQASh27NE5d9X/Z0/vjJCeeG0tJ880hDIWx4sF+yPlJLLhvE/utiD7ArYnVAFLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UtBqyk/W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723653079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DyDrlzMJYgV4eN7sKN7OibLhZnsQZrgEL1DpU8bq5jw=;
	b=UtBqyk/W60bKs6hN7wxCWRIxK5LxCIOP7GWHJLqvTxefYmbtlfFOOurTJdAOzQYIhcbWYg
	urjFBSFylNe/J8AjqlDxf32lWVhf+uB/668Vh0iVuQ0BIcIk+v/+ObJ0m1P8kOJU64PpoZ
	OydXda3jabdTS26OJZWItowXq1sFNMs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-6W29ZEd1MbKuPE16cSciRw-1; Wed, 14 Aug 2024 12:31:18 -0400
X-MC-Unique: 6W29ZEd1MbKuPE16cSciRw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-36832c7023bso37118f8f.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 09:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723653077; x=1724257877;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DyDrlzMJYgV4eN7sKN7OibLhZnsQZrgEL1DpU8bq5jw=;
        b=kmh3oFUkWj/6Rd9LpYfucy/9UeGh/BKLNyKsmSBxHrQ7ze3s/M+MLg7+C2yy/TggRU
         GgQFLdnhEF/hcBMll22XuVZMZY9EuQWeTKjXav+8huBBydbR56es2gRfwbVHT35Gkm7V
         XYCtUwwbUnzEC0LeycD8URIkEsO5ebR/69BMrtwzolKqzZl3LtMGJiH3MY5SDJElK6OT
         ot2f7mcP9QuT2ddlQ/c/SX0/P46dlcW+I5jqay+spXg6TtUv1gQf7wsMyNfZMIVmbhaZ
         druEk4Rio8l7gGmzOisV4ebj4CmOPzSOsDgQL41e8DxOlTCQHY6oU8nOPKFtQEMDoTJf
         OD3Q==
X-Gm-Message-State: AOJu0YxVYoyFeSWrGcbDGs47bxvQxlMsIEdQEZQyFFSBWxHa/HTIw6Ok
	ZC/F+2MMuq4UylBgiR6rN6lrTOM2PdG9+3N5wWh5j+UWI60Cpjudtv0KXZY1yYbsDMtK6mlgvzs
	c7qBmJeWct2V5tx1qcEHyJr5ghPysCnT4saCgxxR8OR4c+hkdQg==
X-Received: by 2002:a5d:4286:0:b0:364:d2b6:4520 with SMTP id ffacd0b85a97d-37177652008mr2235826f8f.0.1723653077173;
        Wed, 14 Aug 2024 09:31:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgy5MLN3nMAW0ZXZGGk2Wcsf6W7hFNNXPWO3ECBuzDROA/FM0EmSpEWD7i6swgGe/K8o5rZg==
X-Received: by 2002:a5d:4286:0:b0:364:d2b6:4520 with SMTP id ffacd0b85a97d-37177652008mr2235801f8f.0.1723653076593;
        Wed, 14 Aug 2024 09:31:16 -0700 (PDT)
Received: from [192.168.10.3] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-36e4c36bd0csm13245245f8f.22.2024.08.14.09.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 09:31:15 -0700 (PDT)
Message-ID: <a6ba22a3-4e4b-40be-a196-79ae2265a97e@redhat.com>
Date: Wed, 14 Aug 2024 18:31:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/22] KVM: x86: Disallow read-only memslots for SEV-ES
 and SEV-SNP (and TDX)
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerly Tng <ackerleytng@google.com>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240809190319.1710470-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/24 21:02, Sean Christopherson wrote:
> Disallow read-only memory for all VMs with protected state, i.e. for
> upcoming TDX VMs as well as ES/SNP VMs.  For TDX, it's actually possible
> to support read-only memory, as TDX uses EPT Violation #VE to reflect the
> fault into the guest, e.g. KVM could configure read-only SPTEs with RX
> protections and SUPPRESS_VE=0.  But there is no strong use case for
> supporting read-only memslots on TDX, e.g. the main historical usage is
> to emulate option ROMs, but TDX disallows executing from shared memory.
> And if someone comes along with a legitimate, strong use case, the
> restriction can always be lifted for TDX.
> 
> Don't bother trying to retroactively apply the restriction to SEV-ES
> VMs that are created as type KVM_X86_DEFAULT_VM.  Read-only memslots can't
> possibly work for SEV-ES, i.e. disallowing such memslots is really just
> means reporting an error to userspace instead of silently hanging vCPUs.
> Trying to deal with the ordering between KVM_SEV_INIT and memslot creation
> isn't worth the marginal benefit it would provide userspace.

Queuing this one for 6.11, thanks.

Paolo


