Return-Path: <kvm+bounces-48669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7CD8AD06C8
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 18:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A633C3A6FB1
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 16:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8506D289E2A;
	Fri,  6 Jun 2025 16:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UNWxfO22"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129741E5B95
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749227888; cv=none; b=oIvJ34+2P65/3VJpAqI+ElFGV+dEY5hWHAD2c3Nye8GrqYXBtELqED0XwGMNuqNKO8pi8YT09tEvYx75eNU5vGxqyrHAFuGwd34FYfoHqYkzIIYiCAE++zdcTqFl1sD+KTmZrE/ENcaRarkCappobCl904MXzKAW9N/tQ1KTl+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749227888; c=relaxed/simple;
	bh=QrbtuDMMlfo+hBepFmzEgOKu5bVEHlmY04wQwSs1g6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PcgY1abs9AY52f+XdzGfl/AQyjp9cV+zp3cD8eJGyz9Wnugnvx5XtTGJY6ciG9+ohnKTJqjIImoVj4ppjkl6iXsft0Tl2LJ/hSs7BRtYRrg2koxYcl9DLHrZv+qyjXQyWtESqwR12SpFD0GBSEPa6wLZ8iEF/eY2nj3THqCLhP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UNWxfO22; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749227886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Dl57DhiFOMo8GkH+ogQuHIs3xd9CNb2ax4ce20G2fls=;
	b=UNWxfO22A2m0p6o4n8J+0T5MhXpI2tJFFkWqF7wCTQ9oKVWztUPUTG17AamO+zBxDGYazB
	reBQutbFKKZaXzsLIDKNFVK/y0zhWdpyDbiXRhASXLz6WWweOIgPaXXv0EOSgIj/mQr59O
	4hVZHg9i/zB4mZfTIeMJIRf6JMHCJHs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-eKsiEvkkNoik4G48Bs_ryQ-1; Fri, 06 Jun 2025 12:38:05 -0400
X-MC-Unique: eKsiEvkkNoik4G48Bs_ryQ-1
X-Mimecast-MFC-AGG-ID: eKsiEvkkNoik4G48Bs_ryQ_1749227884
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a52cb5684dso1063690f8f.3
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 09:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749227883; x=1749832683;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dl57DhiFOMo8GkH+ogQuHIs3xd9CNb2ax4ce20G2fls=;
        b=CpTJ56YR36h2TTRrJoz/VdCcgMtwiaNf1eHSjH7YhyZYSnyThfhHkIy6Uo+L1fQiVs
         Pm/+pmITokosTEoIMqRhika6PeZUnplBm1C0drpNMes1610Ec9IrKPPM8orAzkcmBPcR
         EMyzyXOr9w1kW2o4RoRMe7rDNAP2+VqgEEPV+LMhHOOHyGJY15ICVabsKqWxw9nqB4ex
         Wgm4V0FRSxpP2ti6JQf7S5eMZjarbC4c06ZLfIeWtuwJeIg3MzoN2prw3BvYLFTVDdBv
         cryWaQpbwuuQqm0dAxDJ/IgLPbj86X/9cXZncXkyHIigWWUuSglkl9xyrybg6RZiYmtx
         1+iQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwXoNXJkcNLwQwjADFpmYXLT23w4XiKOG8Kj1dbYIUGnYsgUBbz1rJTtvbHRoVcKt2bOg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS5q0oVVS4764EGfXjg4YRd+UVptcILWg7tdf4L1DPzYqhYWyF
	RsVVi/ISgyBPCTRUvoaqf3y2MDOYHLSr/UPurUK94BHVuJslYYcjr2y78Dm8PpZCFdd0mu0ZSaa
	1fE/9g2zapb3mEuR3KQBSGCj+eElyaSUgw5P+RqBaN0kc9pzc/vA+DA==
X-Gm-Gg: ASbGncvutJuFt/HXXioPpFblbonPu664g93i9NzPuvtC9sLYuiCfAxRyLiv1dM8UbJ/
	6akp11SnextrkcOjwos1oj9az27ObIXiC3XzDF8cIU+S3Biyrr7E3XnNxdAN9ScCUfaWRCpgydI
	xz/qbGs16WeorxfpYNWwpVsSV2+UWeuZOvu6vhSkjkR9HFFmCyhrUho31RYSYJldJP8vWlA6SpX
	YW9s1ZtmgWiTfd/yNFp2UCIux4kig0NFBajmCkdmWWQDj3xwgLuiUx36lPp0BM9nuZ1Q8ToPme8
	po8FveSO49M+N6XnaGw1AgJ8
X-Received: by 2002:a05:6000:1a8f:b0:3a1:fe77:9e1d with SMTP id ffacd0b85a97d-3a53189ef17mr3476971f8f.16.1749227883688;
        Fri, 06 Jun 2025 09:38:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNKzC3mqWUAPIgFlamw5SfU5I0d4hNXj2UIm4VZTEITVURrNiwn6xofps9u77e0T4I4TQ3vw==
X-Received: by 2002:a05:6000:1a8f:b0:3a1:fe77:9e1d with SMTP id ffacd0b85a97d-3a53189ef17mr3476940f8f.16.1749227883282;
        Fri, 06 Jun 2025 09:38:03 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a5324364c9sm2410666f8f.51.2025.06.06.09.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 09:38:02 -0700 (PDT)
Message-ID: <a0e2c1a2-23a1-4527-b638-b06df3fc5fc6@redhat.com>
Date: Fri, 6 Jun 2025 18:38:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/29] KVM: x86: add planes support for interrupt delivery
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com,
 thomas.lendacky@amd.com, ashish.kalra@amd.com, michael.roth@amd.com,
 jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de,
 James.Bottomley@hansenpartnership.com
References: <20250401161106.790710-1-pbonzini@redhat.com>
 <20250401161106.790710-21-pbonzini@redhat.com> <aEMXrbWBRkfeJPi7@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aEMXrbWBRkfeJPi7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 18:30, Sean Christopherson wrote:
> On Tue, Apr 01, 2025, Paolo Bonzini wrote:
>> Plumb the destination plane into struct kvm_lapic_irq and propagate it
>> everywhere.  The in-kernel IOAPIC only targets plane 0.
> 
> Can we get more aggressive and make KVM_CREATE_IRQCHIP mutually exclusive with
> planes?  AIUI, literally every use case for planes is for folks that run split
> IRQ chips.

Maybe, but is there any added complexity other than the "= {0}" to 
initialize the new field.  Ready to be proven wrong but I do think 
that's one thing that just works.

> And we should require an in-kernel local APIC to create a plane.

I don't think it's needed either; if anything the complexity of patch 25 
isn't needed with userspace local APIC.

Paolo


