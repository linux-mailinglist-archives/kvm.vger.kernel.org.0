Return-Path: <kvm+bounces-36190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C83A18655
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 22:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 284313A83CE
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA4B1B414B;
	Tue, 21 Jan 2025 21:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMH/rs/p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB2B20E6
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 21:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737493265; cv=none; b=opSiDuVdxS42ORqRL9HdZONwLSgHhPBYIu64mo8qDc1L33ZIr4mf2RvdN3QYAruXc0blE49g+kK1evUH0/4eBtS3KJnuL1UiAJk8iIcP5GPyWl06F3Z8/cw0G8fvfm2zQWj2mP/aQBHgzcbCATN1FEK77KfikLGPzC1id4ibA5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737493265; c=relaxed/simple;
	bh=zeWPhc7Ai1pplsbPAnfj4I5A2frFg2fqEiU23C0kLbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sxIzwOnYm/ktHHVrCuyJvIqhHzlkYlpPJrEZne3ehFuLft4I+8ktVzaxzSIlCGIjSjbssnNc2YEndxu5a3sN5hS0caClBTC8+XloKNUujAVW7k6dA/ijbuVI78q11AinqF7r59KyPJsVuZhcBz8pViHFhmAb50HIz02PmxZ5v6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SMH/rs/p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737493261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XHZe+eoQcn0xv+HL3pkM11Ftwz30fQaOaBnUOGYwMnw=;
	b=SMH/rs/pKzPJZuDdXRzUn9fjV+3JQJ1uNB1ugoJOREScRezoLDDC34MGQ6aLA3foZctgOb
	o/CyY6QaIz+A/7mv8ESFZNNdHFzoaJrXnSW1ZVwUqnet5GM+Y0UikPYA/UbKt2nC5toDSC
	qzZVxJjRIZ4zOvfFvhR0ur6qpc3Roxo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-NKn0P96IMdGvDyCfxEL89Q-1; Tue, 21 Jan 2025 16:00:59 -0500
X-MC-Unique: NKn0P96IMdGvDyCfxEL89Q-1
X-Mimecast-MFC-AGG-ID: NKn0P96IMdGvDyCfxEL89Q
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-436225d4389so676195e9.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 13:00:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737493258; x=1738098058;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XHZe+eoQcn0xv+HL3pkM11Ftwz30fQaOaBnUOGYwMnw=;
        b=KiY+PYtxTQLJ952CzPHj4hjtuGnuWxVPdxPOtlpGb9OD3JgukDy1VaZ26/gQp/f9IY
         UINv8smRCGwLvEDodIv9zy2LJrrwE+hAyig4iUC/D8uFyqdCs75bC3ElYIc523ts60wM
         z4XDf/l8UR0728qOVaim69ZwiPC40T1Qd9fQQtpv5dNzzZOx3xQSAoe5lBZ/MvT8Yb/p
         VX9IFqqCwVZZM9HIbPidykFTxBx7QRghKplms/VsKYvOhf6L+Cu/T+u3WbYgy131cUVS
         RVtGrGi+8RcxFgJuhXR+Ak3Ha34QzOHbZkVKFF3+5R2tU0tlFiLRwrHF1vuOBfRHk77x
         XwyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtDi3PS8JsYhLdAzW+UUnuWTlrloblE5xSptAquNyMwxq7VUVLkIuCAf3RsyA+MA/ZoSw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt7fcf9kredW5oBXmNDGEaI2F05pr4rk0pbKGCYiIdE5tgbv7j
	mZ+ethKpVSzPOUZqCCuunkLqLTi0V6L9b3dH0NQi8PRlzPwj3Q0r+kwvqqMIJ5BxhJAiJxc0U7U
	wWDsDbJ81U2M6+suNDRqV6NOtYLP8sWVk/bKrp/bIul5E3m8TlQ==
X-Gm-Gg: ASbGncuOOkTEshKyTMFKbuHne4GOcdSlwtsRHlCzS2OttcbeEEfTGWiQFeXLKDu27no
	+bVMsl6ghjPll7tk2xlVkYPgRPj2YNnL+FZbCpt1zKf4tTasrBV8sB+P4kukqd8S4j9J/UKYHTa
	h53CcsbvvHp4glrxfGZG7GLs1w4qhtMESac7IUO9gPxsR1OveCLcxnXcC0oUs95mDTpFGXrT9Ns
	0ScstuacDgXWvrjT1nmb56JmViK4pVKQ78es8ZOFPxp6My8Px3QbB4hrLsM2H/fs8bv+Km7xvtJ
	8Ds0uQfs8qimPql/emPd/xQ=
X-Received: by 2002:a05:600c:5cc:b0:42c:baf1:4c7 with SMTP id 5b1f17b1804b1-437c6af202cmr231581935e9.4.1737493258086;
        Tue, 21 Jan 2025 13:00:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGeaO/mSfqZrggQWVD2XlTKF8tSSIbwIt9Djq1KEr5xORf6cXwnW4wbmWubecjR2j/OanCZAg==
X-Received: by 2002:a05:600c:5cc:b0:42c:baf1:4c7 with SMTP id 5b1f17b1804b1-437c6af202cmr231581615e9.4.1737493257691;
        Tue, 21 Jan 2025 13:00:57 -0800 (PST)
Received: from [192.168.3.141] (p5b0c6f60.dip0.t-ipconnect.de. [91.12.111.96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890413795sm188903655e9.14.2025.01.21.13.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 13:00:56 -0800 (PST)
Message-ID: <0eb47f8c-5301-4102-9295-428d6dba0e2f@redhat.com>
Date: Tue, 21 Jan 2025 22:00:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/49] HostMem: Add mechanism to opt in kvm guest memfd
 via MachineState
To: Peter Xu <peterx@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Pankaj Gupta <pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-8-michael.roth@amd.com> <Z4_b3Lrpbnyzyros@x1n>
 <fa29f4ef-f67d-44d7-93f0-753437cf12cb@redhat.com> <Z5AB3SlwRYo19dOa@x1n>
 <bc0b4372-d8ca-4d5c-aee8-6e2521ebb2ec@redhat.com> <Z5AKycFhAX523qzl@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z5AKycFhAX523qzl@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.01.25 21:59, Peter Xu wrote:
> On Tue, Jan 21, 2025 at 09:41:55PM +0100, David Hildenbrand wrote:
>> So far my understanding is that Google that does shared+private guest_memfd
>> kernel part won't be working on QEMU patches. I raised that to our
>> management recently, that this would be a good project for RH to focus on.
>>
>> I am not aware of real implementations of the guest_memfd backend (yet).
> 
> I see, thanks, those are pretty useful information to me.
> 
> I think I have a rough picture now.  Since I've already had some patches
> going that direction, I'll give it a shot.  I'll keep you updated if I get
> something.

Nice!

-- 
Cheers,

David / dhildenb


