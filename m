Return-Path: <kvm+bounces-53773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB54CB16D01
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 09:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0150D5A7627
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 07:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D76029E103;
	Thu, 31 Jul 2025 07:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQ0sDcFu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD4129E0E3
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 07:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753948791; cv=none; b=R8KlPOuHOyeauaUxxl+3ET4M9tqJ6HzDMi5QKrmZFJoiDu8Haf4m84fPey8FOcQAmS/SmzgGO4GXbrsAUM+UiK3NpU//fShsyG66GcjQOSSBFenktkfjtjn0XhzL/jhmN3zKf9NWJEvZhPZdVMsa50B0bKjIADEmLraqR3oopfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753948791; c=relaxed/simple;
	bh=Rh5KGmO6nn3QgQqbICZsq5PSwxP68xc/q8rIDAHX2WI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bvt5KWtZk7zenj5+dNIA0P6iEEKn2sKKxpahk/OilKuqD9H3yl6814HqbhT+F39uh4niqcN9M0s39L8U2CCA24EVhDDZbs7BnMbMSEabuRNdHL6xns0aRSwuabF2Dx/a7UQD6gUbH3JHoe//O/gH1fDdSwJWxRAl4E/of/Xgy48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQ0sDcFu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753948788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6+RLlKz+LEp4zVkeHQztjvSyQ4kPuNOLYMNbmdtknD8=;
	b=IQ0sDcFulD2UbtamMf1iaJABGh77j78+PqizpQOh+1l2E3LfgvtgjtKU4fRaQ9PiSGIpuS
	W5GbPT2A4ZQrfwIH5ezwCePFhqTrNsDDcstRA3CwXAh2eUoYCiv46taivUu9B59xobjNBm
	MZssUGJJi5H7MihNA0OW/ujFEmgTa6E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-ZwCB4gzeOIufrMEpHdkFtQ-1; Thu, 31 Jul 2025 03:59:44 -0400
X-MC-Unique: ZwCB4gzeOIufrMEpHdkFtQ-1
X-Mimecast-MFC-AGG-ID: ZwCB4gzeOIufrMEpHdkFtQ_1753948783
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b783265641so88812f8f.1
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 00:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753948783; x=1754553583;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6+RLlKz+LEp4zVkeHQztjvSyQ4kPuNOLYMNbmdtknD8=;
        b=xP2/GzvyHxmNltRuTQrdonUBYAcsPljVQDS3mYuzADh543NWSBpAJxeVjXJPmMhGlq
         zd3q0hatLWhXPzY/sWirWeQf1W6gsG1yIkXM+c/J9/Mv14FwKKrdkonX4eXYBS2inbwp
         zRmcxHtMMA4C5ArXmi4LzycR0iuBVfGFgbSkXz+LL6Y/QqaVuwHB3kM8k1h13Y3npMRq
         I8gS3/tI90Iz6v9oPEgD3t9MOf1/AQ1neXrQpbacv55oa7bbLH3IHSUl1ugiUJfIvXMD
         s3I404X4IT8j4oWoSArKyoAL50vTfYhkHuuBqB2xpl+5AeyvIvLjpVVuxJw28HwuujZP
         ilSA==
X-Gm-Message-State: AOJu0Yy2jXvGMtRojJwdYv+e8lwLXMrrBIyG2ZPruiJmC5OLIEWj+VAq
	k7PDtjO6Rl52lEkSnw0XG1TfyGh/cwM37T6lK9YllLLazOso+pfqSb3FyhXCvGZzXMUrmwO18wT
	iYOrOde31CFTJTns0YIyYzdH2f23fb+TCHBilR4xZcgr4zv4nfwtHXw==
X-Gm-Gg: ASbGncsjSpJSJvRQBrB6qJJ4Gac92j+8OkmDRJIYbrStQJnFI0Hf+LRZ7KGfrSlL+tO
	2vQ0x9sKbMJWFYiagodICzHB0TpZtlbYJVDlAkGYcZQEC6rG17+5xsbiG5I7ekCFOhQ15C1ZA8s
	EKt2orqRN+aCnL5wRqlkxEez9DOZFAtDeWaQGc6TEYE06m1Tg0vGLzM8HKNgYdoSj/qjQckiX5T
	Z7/CTV1P/GPiBpnQLo7CrX3kxCjHeJB1RIl1bVFfRD3q1ZcPwCzf9GkNc/Nx7ri6mIjfhn/wkB+
	2xqRUoADkmkJmxKjeYTYOXBSU4H+ZsGE0Vx0Gd/Zs48PXb3qb85yCTUi97kSNDeKFlsol2TzjS1
	wWuDK9UHMBy54WrN5FmSxGohAhmMKZDg/QMdNNOdVH8OOZaHw/jeDn4OZ+r3r3wXr7lE=
X-Received: by 2002:a05:6000:188f:b0:3a5:2465:c0c8 with SMTP id ffacd0b85a97d-3b794fbe44emr4764614f8f.7.1753948783212;
        Thu, 31 Jul 2025 00:59:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0c6FGDFwWmf3aG+Pb56FiyL3qnF5sXlaAOIZlX1CgExfddmeal6RHVRaf8zAwrRjcXWN6sQ==
X-Received: by 2002:a05:6000:188f:b0:3a5:2465:c0c8 with SMTP id ffacd0b85a97d-3b794fbe44emr4764586f8f.7.1753948782792;
        Thu, 31 Jul 2025 00:59:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c47908esm1474307f8f.59.2025.07.31.00.59.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 00:59:42 -0700 (PDT)
Message-ID: <829fe6be-56b2-4807-8fd6-cc24a2c0aa5f@redhat.com>
Date: Thu, 31 Jul 2025 09:59:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 13/24] KVM: x86/mmu: Hoist guest_memfd max level/order
 helpers "up" in mmu.c
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
 <20250729225455.670324-14-seanjc@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250729225455.670324-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.07.25 00:54, Sean Christopherson wrote:
> Move kvm_max_level_for_order() and kvm_max_private_mapping_level() up in
> mmu.c so that they can be used by __kvm_mmu_max_mapping_level().
> 
> Opportunistically drop the "inline" from kvm_max_level_for_order().
> 
> No functional change intended.
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


