Return-Path: <kvm+bounces-21395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F1892E011
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 08:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10A132833F6
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 06:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5E3E86645;
	Thu, 11 Jul 2024 06:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="foo4IC14"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7D282C6C
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 06:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720679196; cv=none; b=IV7fI/F6X+Hk41Vgrw4CIGkUxN0/M9OdIb3cx8aRqRH/9oWo+8WSYI2Scft6HzAC77SgWXkI07DdDLAgqrErhdBbyRXySab+jlesBNdSip8gDz2otc3NU2yGGyDBbw5lwCygBKhYfk98UBcvraSSpNlW+0lanwGvWN3+4luKmyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720679196; c=relaxed/simple;
	bh=+gUk+O+vVVSZOLwdSplo+LAn7/YjCU+TOgbvUDcAhX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jS68RLsciKDs+p6AXogFF2yV+13q7IaFRcuyyL3DzvonVkCR/pFaxgguU6nKlqPdNXlOPPxBPQhqy86zcq+mU7jBxI9CHQ8UWvOECnKyKN3LQfXzKnCIBij4iFjhQ+HRo3BelLxnfQ6wuylleD105z1K5yUWWf2oKTFPO6zvFzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=foo4IC14; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720679193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=phZpM0E15qIjvG2MozQjUzGMIMax+fx54Fjm0Ee0Y80=;
	b=foo4IC14PBE1XLep+EHE2H92rHEOmLxI+0stRUu9UG2C7iU2RW+QaUXUwjU5b5eaPVKq3p
	f7uC7njiTVhJTpAWV8GzIW7HF4lStvi2irxM9OeokmAIgoweiFTF4avUjxCsRKXBb0pjTv
	q1ZUexB/OlIHU/85NBjee2KuSMOktbo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-BadBmqUkM6OEyYumsM1K-w-1; Thu, 11 Jul 2024 02:26:32 -0400
X-MC-Unique: BadBmqUkM6OEyYumsM1K-w-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3678e549a1eso259495f8f.0
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720679191; x=1721283991;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=phZpM0E15qIjvG2MozQjUzGMIMax+fx54Fjm0Ee0Y80=;
        b=JNgnScC3lXTaAvr2YBPvKvXhqT1BUtHh8RP0pA6ke21xBFimurR1ABo8vuZaWJLGbI
         tUom7QjNkj1UflN5FYCduKOAEQ3c3V15am6w9bfXcWTua0h8Y+S5yjEvHKqbehwCI3C4
         IKJS0q9PXbdPBCXOt2Gtp6lL8YPm8cYJllFYx1ZLF3uurc1ILJBjxgmkRfwKh6Xf8WuQ
         mMLZnw1AQn1jxmusfQaij7uhIYLH4csaxyw8I7zlIImeNOBy8fKye+4/civcNgZFfg/f
         A99vht06Ml+Xr5k3zqsjzBRWIpJdTCtrn0pHybtTuWTEQP5iyq1S9+2q7ty5bda7T+LL
         K5rg==
X-Forwarded-Encrypted: i=1; AJvYcCVvad47H2RikQI+InGcVghX6dLFEmqtIPSc4XNn7kzNi5JBARqAOkERSijdY/anHhPvnmV+4uNrnp3UvULWPTQ3985D
X-Gm-Message-State: AOJu0Yw6WOCH5ZLcLFmIi7GDYWd/5ubkTKmjo/1J+dsbc1Aq4C9+75g+
	yrKfBvWl3tguTxBg33AmGnBKGN7NoxupC1dGN0MTnVU454ZIG9kjNBUNnP1ojJy2SWL78gVNkyv
	CiDlFgIIptB1qJrAl3sxCcTo3Pbp0WGDBP8E+4NACx4IzXEeMhQ==
X-Received: by 2002:a05:6000:2cf:b0:363:1c9d:d853 with SMTP id ffacd0b85a97d-367f0505632mr1555575f8f.32.1720679191350;
        Wed, 10 Jul 2024 23:26:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpxFjj7NiMI1xmtWy0TI38wJOXY2YEJ3Jj7DSBm0Wl5Hb9DKO4dJlV8vOZlAWOvZPr1hgngg==
X-Received: by 2002:a05:6000:2cf:b0:363:1c9d:d853 with SMTP id ffacd0b85a97d-367f0505632mr1555547f8f.32.1720679190949;
        Wed, 10 Jul 2024 23:26:30 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4264a1f22acsm274224945e9.24.2024.07.10.23.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 23:26:30 -0700 (PDT)
Message-ID: <74e92b31-e48d-484f-b819-ef7f07faad63@redhat.com>
Date: Thu, 11 Jul 2024 08:25:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/8] kvm: gmem: Temporarily restore direct map entries
 when needed
To: Patrick Roy <roypat@amazon.co.uk>, seanjc@google.com,
 akpm@linux-foundation.org, dwmw@amazon.co.uk, rppt@kernel.org,
 david@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 willy@infradead.org, graf@amazon.com, derekmn@amazon.com,
 kalyazin@amazon.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dmatlack@google.com, tabba@google.com,
 chao.p.peng@linux.intel.com, xmarcalx@amazon.co.uk
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-7-roypat@amazon.co.uk>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240709132041.3625501-7-roypat@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 15:20, Patrick Roy wrote:
> If KVM_GMEM_NO_DIRECT_MAP is set, and KVM tries to internally access
> guest-private memory inside kvm_{read,write}_guest, or via a
> gfn_to_pfn_cache, temporarily restore the direct map entry.
> 
> To avoid race conditions between two threads restoring or zapping direct
> map entries for the same page and potentially interfering with each
> other (e.g. unfortune interweavings of map->read->unmap in the form of
> map(A)->map(B)->read(A)->unmap(A)->read(B) [BOOM]), the following
> invariant is upheld in this patch:
> 
> - Only a single gfn_to_pfn_cache can exist for any given pfn, and

I think this is not ensured.  You can however use 
set_page_private()/page_private() to count the number of references.

Paolo

> - All non-gfn_to_pfn_cache code paths that temporarily restore direct
>    map entries complete the entire map->access->unmap critical section
> while holding the folio lock.


