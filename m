Return-Path: <kvm+bounces-26213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED85D972DBB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 11:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 702C01F26514
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 09:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7123418A950;
	Tue, 10 Sep 2024 09:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cK9jDbq1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7572E188CAD
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 09:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725960822; cv=none; b=OKswiSfYlOh3wLYqH5DckOx68j2AypGGibp6pTDtHs//zBEJTbWhPRKWYZoFUpqd1bdBwgZCCffmsAcKWgLx+92yrmBgz+p+gQTHfeGSgYSemr9YII1Dq4lB6fTCOp3HIl4Cqg0i8A8j/YC+xU6qwtsNYJ0gb15mwwCK26Gu8lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725960822; c=relaxed/simple;
	bh=ri1hMeK5o+XzdQ9OkjcuD30wr+MjvkhWyqq7xNEgMSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qj+LRMDNt3cv/VDytpXQCqPXXje+3v8VkTMcnWtNoZmTnax+mc8MtTYw/UprTMfj4mU3t49y7PenJAWYanw+Qc/44qUl8P//d6Q18DMTNiLnrQVrDfiHNne928yzSBMP1VP3Xr1RQ3H4GKPO/Zm1wnZfZV4gy05UGm5SWyhpdQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cK9jDbq1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725960819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wFalV50WlLwE3Z9x4eWYmOUJUBNHneNBuQ/Z2pR2B7M=;
	b=cK9jDbq10uW+HYq9l20qeQpJJHU7YN/yv1kzkGiyqkRLtoXYXL2GLodtQJQ39JskjUybeg
	QaL+n4sMag3eanVy7wGqYwCVkX38WdP1C9qVm39ieycsCLjiHVXW2+hSlPf2siPtlYPsR6
	AC3Hi0JghtST5KCo4KYatFfJMMc5cZ8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-SJSEB6nlOlmwisOOLWtpwA-1; Tue, 10 Sep 2024 05:33:37 -0400
X-MC-Unique: SJSEB6nlOlmwisOOLWtpwA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42cb2c9027dso4759195e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 02:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725960816; x=1726565616;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wFalV50WlLwE3Z9x4eWYmOUJUBNHneNBuQ/Z2pR2B7M=;
        b=AHrdDu68z0muabjHvNSV1b/NTGvBEKcNP9/zn+DgctzJUmvk6y+XSi6a0Ls4PUrsE2
         neG3zrVc9Ev9zj6C5hSBjXwW8VTrbP2AnFdY0nhlZf+4ia9fSJXY6ck+eG6EDqDbcLKl
         hegAoVHWo+z0t6XtdpvblT/ZyI83q3hJcu1Ahsdn42gvl3GF0MWS0/bGSbMIsm3pX9p7
         337xj2QJ/zG30xbXQ8PVS7PZJzRjL6Yaqjd9uRJ6qNXJUAyhTDUdE0B46JP1jI/c6BPL
         lDxOqD/TMMrQjtreko0TD4H2lsIf1r89PumT6hI0jZBQ8nvfTCg/QL5+CdB76i2Nxvc5
         HcnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFejuRn6htZOTRSpYu5zax3YPe6XmP1cpaN7zxQDEHTXCiIASwxytbjXFFdoaWuJXU6zk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs4lwj95+KKxyOwz/850bi0Og88+u/B2FcaSmSkwp6gHjDCFgM
	8h8W3sSlOsNCUX5BhXPzitiW1btXP9nHsHRanMrTwueRTu4is644YdoYjR5GNObUo/Nz60oGsOc
	e1d3zWyLIGUN+aJ1FnoRiNiGg9ESuZu97tP9PJYrLvgbmxdxqdQ==
X-Received: by 2002:a05:600c:4684:b0:428:23c8:1e54 with SMTP id 5b1f17b1804b1-42c9f98ad8emr94504675e9.18.1725960816007;
        Tue, 10 Sep 2024 02:33:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMoXn/L8ZkBRwwM0tJhKYyFjWG0mDIW0WF6tt+LzX/pj11SrhpE1hgLkx5jMhfYDnQOHQ2TQ==
X-Received: by 2002:a05:600c:4684:b0:428:23c8:1e54 with SMTP id 5b1f17b1804b1-42c9f98ad8emr94504385e9.18.1725960815489;
        Tue, 10 Sep 2024 02:33:35 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42caeb81ac0sm106235805e9.34.2024.09.10.02.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 02:33:35 -0700 (PDT)
Message-ID: <128db3b3-f971-497c-910c-b6e2f9bafaf6@redhat.com>
Date: Tue, 10 Sep 2024 11:33:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>
Cc: "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "dmatlack@google.com" <dmatlack@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-15-rick.p.edgecombe@intel.com>
 <5303616b-5001-43f4-a4d7-2dc7579f2d0d@intel.com>
 <a675c5f0696118f5d7d1f3c22e188051f14485ce.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <a675c5f0696118f5d7d1f3c22e188051f14485ce.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/9/24 23:03, Edgecombe, Rick P wrote:
> KVM code tends to be less wrapped and a tdx_vm_destory would be a
> oneline function. So I think it fits in other ways.

Yes, no problem there.  Sometimes one-line functions are ok (see 
ept_sync_global() case elsewhere in the series), sometimes they're 
overkill, especially if they wrap a function defined in the same file as 
the wrapper.

>>> +        * which causes gmem invalidation to zap all spte.
>>> +        * Population is only allowed after KVM_TDX_INIT_VM.
>>> +        */
>> What does the second sentence ("Population ...")  meaning?  Why is it
>> relevant here?
>>
> How about:
> /*
>   * HKID is released after all private pages have been removed,
>   * and set before any might be populated. Warn if zapping is
>   * attempted when there can't be anything populated in the private
>   * EPT.
>   */
> 
> But actually, I wonder if we need to remove the KVM_BUG_ON(). I think if you did
> a KVM_PRE_FAULT_MEMORY and then deleted the memslot you could hit it?

I think all paths to handle_removed_pt() are safe:

__tdp_mmu_zap_root
         tdp_mmu_zap_root
                 kvm_tdp_mmu_zap_all
                         kvm_arch_flush_shadow_all
                                 kvm_flush_shadow_all
                                         kvm_destroy_vm (*)
                                         kvm_mmu_notifier_release (*)
                 kvm_tdp_mmu_zap_invalidated_roots
                         kvm_mmu_zap_all_fast (**)
kvm_tdp_mmu_zap_sp
         kvm_recover_nx_huge_pages (***)


(*) only called at destroy time
(**) only invalidates direct roots
(***) shouldn't apply to TDX I hope?

Paolo


