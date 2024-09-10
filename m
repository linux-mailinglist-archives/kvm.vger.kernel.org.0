Return-Path: <kvm+bounces-26223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21ADB97321C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A57DF1F22DBE
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BDFE197A76;
	Tue, 10 Sep 2024 10:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EIiAOEZh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4173196C86
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963236; cv=none; b=pviRqmUZzGEvjBjqmICQXlBWLjdoRECVr9hn1LPbcuWH9/Ox7NdGQxiuAYurCYXUVorAHYGgkOTeIs+eNAJVQXtjNc2A9Mivh9U4y8JRbKOs2yToE3OvXySLiDK/lqXaTqTyQ/beVh39WJwSNEqwgld+6s+WUKb+M3HgT88/UO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963236; c=relaxed/simple;
	bh=DfmBoqhY5ZJUvGoqCesXpmishaSxskD00ID1HShSmto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DB2QuxzUPmi8yWG4vwSIGcHrABg6YUpGfDpooEpmGnax2m7N210KyL/UwSNsOyT3l5ayU/UgtZe0M75zrS7tGc8AhjJw/9rkRPh7JpeSaWyXB01s2ONABx9Cqqe2MuIldJhUeItQFMr3ipiIlw1vOCYj/+VupdoQv0kz2GHGaX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EIiAOEZh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725963233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6AP6r25f65ztGYBeuRMH9nyvJDb+6rpvy3qvP6qysss=;
	b=EIiAOEZhNPvWUerMuciHNURAt6o4BzjmF6snX8sNHc3IpSHjvjBRwOJE4Gj32aTO68ON1f
	/Mpjdz8odVejZqwsut0OAFy4uICfz+RNaE8evfPpqaHFCB1K1fpwG6bt4iM07+XG5PdLFI
	jbEU8aZk8i+LyKYpo3LplHpVp9H9Xdo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-pATC294JOeKfx-IrLfZYtQ-1; Tue, 10 Sep 2024 06:13:52 -0400
X-MC-Unique: pATC294JOeKfx-IrLfZYtQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-374bacd5cccso2930359f8f.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725963231; x=1726568031;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6AP6r25f65ztGYBeuRMH9nyvJDb+6rpvy3qvP6qysss=;
        b=a9IVdhA8Voc7+ogy39EC07TZSyg/us4OOpqxYr7pjzDB5loZOL19MhS4tZsMXFGdPq
         29IRlUW5dJAiw2Gn2KUc7IUJoURREw3ESOaVfiTia4/gWM+MPytPewKarD72B3QrUxY3
         7jU48FonG35CWGTdEKmiqim8t10GYM+patnKoXgtwP3qfna+Btqq7o29//glhFpDl7Fa
         yeR97xsRiK72DyAVp8rH+5bHb+2Sq18UdpgiqxY7/dWk2coMpJWe/xMYv2jBND9rs3b/
         8CUHoWilMm85b6KZ1jb8CmxlY8QclK4JP/prdBgIswjf8QyKl1LbeFP43yeckhnvFvio
         babQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVzdMDPDgat4W+IZ5Do9gOOxlDemhhnqI425WHfuTchTo2negEZf/zZ/QKkFXwppsgQ+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLz8xS3xr/8NqpuwXl0sf3kukMhV1noarQItL4F7SToDSZJLQi
	qfpMWHKstGBhEmXQyqrPRqHY927MKa6uWQuHgXCQptzrHiLUT3YXLJ2dohYhW4+LzJDNXXJ6E7x
	IsXM4+Dwy7nSjfzfvaxqdS92sQk+vbF6qxfBYAPzKFyN9W9VSMw==
X-Received: by 2002:a05:6000:d8c:b0:371:8cc3:3995 with SMTP id ffacd0b85a97d-378896035a0mr8983515f8f.34.1725963231120;
        Tue, 10 Sep 2024 03:13:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy5P0EwcX0ItxKYDRTeq52pENXWKZzMDGIn+kiNA9wiZmAaVMqy9YBbSaqe53p8fp2gaS+DQ==
X-Received: by 2002:a05:6000:d8c:b0:371:8cc3:3995 with SMTP id ffacd0b85a97d-378896035a0mr8983496f8f.34.1725963230533;
        Tue, 10 Sep 2024 03:13:50 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956d37a1sm8431319f8f.77.2024.09.10.03.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:13:49 -0700 (PDT)
Message-ID: <0feae675-3ccb-4d0e-b2cd-4477f9288058@redhat.com>
Date: Tue, 10 Sep 2024 12:13:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
 <kai.huang@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "dmatlack@google.com" <dmatlack@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-20-rick.p.edgecombe@intel.com>
 <Ztfn5gh5888PmEIe@yzhao56-desk.sh.intel.com>
 <925ef12f51fe22cd9154196a68137b6d106f9227.camel@intel.com>
 <9983d4229ad0f6c75605da8846253d1ffca84ae8.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <9983d4229ad0f6c75605da8846253d1ffca84ae8.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/6/24 18:30, Edgecombe, Rick P wrote:
> /*
>   * The case to care about here is a PTE getting zapped concurrently and
>   * this function erroneously thinking a page is mapped in the mirror EPT.
>   * The private mem zapping paths are already covered by other locks held
>   * here, but grab an mmu read_lock to not trigger the assert in
>   * kvm_tdp_mmu_gpa_is_mapped().
>   */
> 
> Yan, do you think it is sufficient?

If you're actually requiring that the other locks are sufficient, then 
there can be no ENOENT.

Maybe:

	/*
	 * The private mem cannot be zapped after kvm_tdp_map_page()
	 * because all paths are covered by slots_lock and the
	 * filemap invalidate lock.  Check that they are indeed enough.
	 */
	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
		scoped_guard(read_lock, &kvm->mmu_lock) {
			if (KVM_BUG_ON(kvm,
				!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa)) {
				ret = -EIO;
				goto out;
			}
		}
	}

Paolo


