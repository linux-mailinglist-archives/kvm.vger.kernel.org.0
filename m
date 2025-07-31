Return-Path: <kvm+bounces-53774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FCFB16D11
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E71777B521D
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A9220F062;
	Thu, 31 Jul 2025 08:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iHB9ePte"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A151235971
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753948923; cv=none; b=beS98zvPQMpWB1m40+ScfsRp6rp2ygcffarADy/kkqEBnJRU4q05XOhb86MguwbZYDSYgX56FnnGNSccp3MKN/SnkQNW3cIXL+UG0kzG8iavTFgVdszTRR3gjOHuBA+Mw7in/2LS99BYvUiCHk37SsJTNjm9PC9a42EnGjSKn+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753948923; c=relaxed/simple;
	bh=LcAqJ7x/hkHgTux6gZtuAebLsx1Ln3OpuPN9qKEn+CE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MwvmisIokO0JcSwf2WxsvGyC/m4tC/sAmziqzOwbYjlCH2OqrchgvTdcFfprrNVidkBnDFeOS8vIGRt0yvSKfD7wZObrqdwdSuXBAAszb72lGO/dneIvk1gT5BUOikniS9Z98uMaOXFIYk9zCTQjA9/0CH6Y7tWLz11Gnk1E+TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iHB9ePte; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753948920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1JJijs4W2vHC2VDBttSaecYsyLQnG1kUwLx2TkZowLU=;
	b=iHB9ePteHf8ZYchRMsHErqrf5v8LuyGn6/PbrwPkRy/htwY0fqynZzutSWw/bRLrjv1YR7
	Ygll1mu0PAmtIdATXUF7PxnhQ1frnxqEm3pELP9Vr8NoS252GsWbLWim8Dmp/0vkySZC0A
	pJKe+HgXIn2+z+C8oIoYMT1BegQfxWU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-_Aa6xmtOOiO429I7zwpIbA-1; Thu, 31 Jul 2025 04:01:58 -0400
X-MC-Unique: _Aa6xmtOOiO429I7zwpIbA-1
X-Mimecast-MFC-AGG-ID: _Aa6xmtOOiO429I7zwpIbA_1753948917
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451d3f03b74so3093135e9.3
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753948917; x=1754553717;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1JJijs4W2vHC2VDBttSaecYsyLQnG1kUwLx2TkZowLU=;
        b=PqJS7C5k6rn78RRVEpCn4OCSM+AMezJ/03KngkWJFaXztr4G9pZEwNA/aCMHzZByUa
         jqUvQlFIH+PI7sQQuNNbGfdWp8AaZdIqT6QmKInrgfBhe8pf6tuHshLPLjMZK0S0qFsv
         IQTlmDQOdpRgOXO1aSh+SXk29OO4ZPmhWOMCdUYz8Qm1ITDx4CAyxKS2y/DyzU111SeY
         lPWP34c6gUBLbJBDMz9mrslSHX4V0j23VWhzVXYOU2K7gtmlDQ1z7kSAwFfeAakrCaGc
         aQ2uTMk37GThhCcEoz67PX4a3Y3Cwpld3OYBmKkVpLNmBxgjf9VrfdMbnxPCtUTS+rk6
         /Uxw==
X-Gm-Message-State: AOJu0YwkptDT1g/r75Z+3DwNhOp+Sb5qhl+yFHFCOymS5mOUGHkC7x0i
	PcOoE25e2tPSKjaPDBPmifnarYhOJHiFAOzD87pXLOzOHUkDpy7r+r0SW7uSE6ik+/EXcTECRwe
	aMaJZRozj7HIx7TSwPzUrw2uWUM3vHEE/mO82AG8EkHlyT3+f7C+JkA==
X-Gm-Gg: ASbGnctC7qr7RfEovKpXcIQClXYxM1TDaKXCg4qHd3OrOboSDSnj2nMy7a+hM4cNP7e
	Si1Sn1L2oXEEUOUM0+3R7FbUKURnRgNjc2gayNfW2JAC7AvDFXNtQ8oWB8zhbYPukszEokP7aMs
	J8oGXkK17mT9hAlX9neT4xZdldtb/jK5LEOqE7LRWqD1+LFmnH89Js7u4XONeku9O47v+k0agB0
	tWW1Qmct3BvAqa7maofgeNdOtd2pd1ywQBzhqxRyHDnXWgpE7U7ul2g1LnJ2Wqp35olvnZLuM5Q
	8oJFMvlpc+cEqX5FeJ7whGIrVuTNdU/ggZfTf52sKCPOEeZL1AjaycZh9KlMxwP2Fr/Ud5edKt/
	uUnz45xnduo5IjoNp9Nq6MykRApn0J0QUSrk0SUaFqpkbCPGzm/lMZ2Gnkf/1gEtw+9E=
X-Received: by 2002:a05:600c:8b77:b0:43d:fa58:700e with SMTP id 5b1f17b1804b1-45892ceaecbmr48174705e9.33.1753948916690;
        Thu, 31 Jul 2025 01:01:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyLz/naDKoYXO0ZrbHzB0TQqBQIY0shm63Y9kIehrjwG6I0rtLZZVVvO3oMjdHoQbbfXbHRw==
X-Received: by 2002:a05:600c:8b77:b0:43d:fa58:700e with SMTP id 5b1f17b1804b1-45892ceaecbmr48174345e9.33.1753948916261;
        Thu, 31 Jul 2025 01:01:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458a3038121sm10902415e9.1.2025.07.31.01.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:01:55 -0700 (PDT)
Message-ID: <33b6deba-a1bb-4515-a659-9822b5b13d95@redhat.com>
Date: Thu, 31 Jul 2025 10:01:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 15/24] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
 Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>,
 James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-16-seanjc@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250729225455.670324-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.07.25 00:54, Sean Christopherson wrote:
> Rework kvm_mmu_max_mapping_level() to consult guest_memfd for all mappings,
> not just private mappings, so that hugepage support plays nice with the
> upcoming support for backing non-private memory with guest_memfd.
> 
> In addition to getting the max order from guest_memfd for gmem-only
> memslots, update TDX's hook to effectively ignore shared mappings, as TDX's
> restrictions on page size only apply to Secure EPT mappings.  Do nothing
> for SNP, as RMP restrictions apply to both private and shared memory.
> 
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


