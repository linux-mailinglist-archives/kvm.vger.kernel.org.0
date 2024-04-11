Return-Path: <kvm+bounces-14276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F778A1CBB
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37C871C2204F
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EAE12C469;
	Thu, 11 Apr 2024 16:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IKJDPPAl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ECF3F9C0
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 16:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712853419; cv=none; b=CID2PIJjX6dYypcpYdNEhs7HimcUSNZ2nAm1Qj5y3b3bsB2Se3EgjPuv/dcb+4EEqxnr3S00Y+CTxed4CJbS7MQTcJd3fFkL7FOTNSZNVeUIFX1XIVpVj7cH7A5jExuIYwCAohu/3t1ob5iG9syW4/NeMmjADR5eG19rL6co0M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712853419; c=relaxed/simple;
	bh=eEnELQu/2XIAOlCbzp6DMkHDaPwjiIZG7X1SIcnqdFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=koeSRE9CwpoVFgn7ppEHLG615lfat5uAFVs+fGyXXVx9SFjXtZd+egzLPhGH89ziTegz8xz/YR216e+EW1nNQ3qHWkpdLhxHz1Sl3aiSM9Medqdlv3dhJ6QBB5RnhGKsva2O3QvsYYtlaZQFIP4tnrgALiWTSlaIGQUR9KM/lvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IKJDPPAl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712853417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6YFASrEU85zMIDQiOjC5J+NUp/1bDDTGCw3PXWonwBs=;
	b=IKJDPPAldRq14xghptwn5KitvuG6M0rrIRHkXHo551+Ox6jowDXSnQp8wVCE7wFy8VTDBX
	sTa7XfHnXx0n4G0MEhAaBCVkvEWqBGmnqv6SnvhFkNaiTCsS3/sI3RFgT9ywnT6Qos1oum
	zwaTjM5BnqVPqnFr6I/Idv+Vcr6sGS0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-19rlv7OqNW2Duc2-l3RAjw-1; Thu, 11 Apr 2024 12:36:55 -0400
X-MC-Unique: 19rlv7OqNW2Duc2-l3RAjw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-417c92b77e1so189205e9.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 09:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712853413; x=1713458213;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6YFASrEU85zMIDQiOjC5J+NUp/1bDDTGCw3PXWonwBs=;
        b=s4A+q9IT378gkqbzdSPh5ek4paci6ujLZgqjF0afhWMDPsCJpZuuiss9/tZcxQANqx
         VLGzDiNtiZRFZv1AO0gYbIK0u/MNVt9aG3Nc6tDJG3KG/fxol2BhGA9UMDsoIwI5+5uN
         xgX7mYOZzi81mI7cSQNwqQPEkORPhmtoZgICIg6hZjf1m/uuR3FV0+SZ5QRziONFjlUO
         Kl+NpEuGFWV3enzahF1gqxcbJFc4bDfB0VNA8ZFgct3GbYhyzqQYJEOOLSXTZt1gE/mc
         z8gNfRInTJTHnLC4s9o8mmgIb06T+4jJpXKiZQttkZbmClx7o3kZDDbDZSGFp9RJi0rG
         lXFw==
X-Forwarded-Encrypted: i=1; AJvYcCUvgwyLKgFKy9ooYhynVsRZ7Cnmj57p8A/MeKjthJ27WAa1FPEY1feeMydMKxSehsXe44wmro5cXYphx8O/WgNZdbG0
X-Gm-Message-State: AOJu0YzMYKjSCiNCzTlBdjFQnWHPikXhduRdOYcXOmvT/GGqqbPKpgTW
	r1O8FYRWNiwFyp9XDLPBQqY5PwCa/a7D3JSrUzkK4EITAIMyko7E71axkkbkelKnNaji5v+Ao85
	QEGPpjJAU/6cyh7VOD3bSsmxSgRTsPNFHCItNjfd0yP6efvllPb21XjbVzg==
X-Received: by 2002:a05:600c:3d0f:b0:417:e6e6:a314 with SMTP id bh15-20020a05600c3d0f00b00417e6e6a314mr243607wmb.14.1712853413133;
        Thu, 11 Apr 2024 09:36:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbaWB9D3JRarQhAsn4Sdpn9QmWPYXlw2wvO4ybww8LysTvw9biDfSoAJOPEVMBJKknWx91ig==
X-Received: by 2002:a05:600c:3d0f:b0:417:e6e6:a314 with SMTP id bh15-20020a05600c3d0f00b00417e6e6a314mr243584wmb.14.1712853412807;
        Thu, 11 Apr 2024 09:36:52 -0700 (PDT)
Received: from [192.168.1.174] ([151.81.71.210])
        by smtp.googlemail.com with ESMTPSA id n3-20020a05600c4f8300b0041627ab1554sm6003674wmq.22.2024.04.11.09.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 09:36:52 -0700 (PDT)
Message-ID: <bd8e7f8b-532f-4372-a3fd-69893e359b42@redhat.com>
Date: Thu, 11 Apr 2024 18:36:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] KVM: x86: Advertise PCID based on hardware support
 (with an asterisk)
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Michael Kelley <mhklinux@outlook.com>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Andrew Cooper <andrew.cooper3@citrix.com>, Xi Ruoyao <xry111@xry111.site>
References: <20240411163130.1809713-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240411163130.1809713-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 18:31, Sean Christopherson wrote:
> Force set a synthetic feature, GUEST_PCID, if PCID can be safely used in
> virtual machines, even if the kernel itself disables PCID support, and
> advertise PCID support in KVM if GUEST_PCID is set.
> 
> When running on a CPU that is affected by Intel's "Global INVLPG" erratum,
> which does NOT affect VMX non-root mode, it is safe to virtualize PCID for
> KVM guests, even though it is not safe for the kernel itself to enable PCID.
> Ditto for if the kernel disables PCID because CR4.PGE isn't supported.

But the guest would not use it if the f/m/s matches, right?  If the 
advantage is basically not splitting the migration pool, is that a 
concern for the affected Alder Lake/Gracemont/Raptor Lake processors?

Paolo


