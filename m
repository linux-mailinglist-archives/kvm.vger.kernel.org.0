Return-Path: <kvm+bounces-38837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0068AA3EDA3
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 08:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02D64188C8CB
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 07:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EEB1FF611;
	Fri, 21 Feb 2025 07:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FV0ObCjw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1391FF1D7
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 07:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740124343; cv=none; b=TUzau5qvAPzLWUNV6ujNsfxxdBFTZdGeP+PSsuwLqUnGZzbrXeyKIs1V5idymTl5rzS7QlwMd9YnSscFDQq+Sbv3b+Uhz8NKwSv+tECUgJ0IPqCwGMgmKZDj3wxGjCyyCy8xPWoX8vTWgIHgmKZ6jigQ4KxvW147piWKER4M7AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740124343; c=relaxed/simple;
	bh=RjnkR8CLqAhZybuqbBDTZjGpwudzdSm6aoF+/1gHzNI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mNVcnAh8//ohlVnNCntDZ7MpDI0cDO5B/+1xPNVfxqOhonVNBNJJJi9axB2cq0uvzSfRoeRskh6ZN8iYeMW4bIZUXcQmIuIBAsn1F9E+Fq+pP3NG55v5QnEwP0RBnA+P0Q4TtI6KcCo/J7KSH6E/Ub/6q0ZpM5OkT2i0Ny+sRG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FV0ObCjw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740124340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rOI7Z+k/jw/HwkIzU4wUrpSnIOnbW4yX7Ts578dd7m0=;
	b=FV0ObCjwh4dwu+eUAUJwGc6DHvZPhzZvmwaSK5EEq039NJ8thWuapDS1q2rteb2yTzUPQn
	eBXLr/A+m5WbRUFHegEAgAcHDSvqo2Dbdra3QXQJByqq7Is00mAuEifc6NhrJ990DNxZ89
	MRHcskpFJ3uC+KvQqk/Nr9a7hDE8FlM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-rsTeqsm5NSCV3mJzJuhKzQ-1; Fri, 21 Feb 2025 02:52:18 -0500
X-MC-Unique: rsTeqsm5NSCV3mJzJuhKzQ-1
X-Mimecast-MFC-AGG-ID: rsTeqsm5NSCV3mJzJuhKzQ_1740124337
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4393e89e910so9543995e9.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 23:52:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740124337; x=1740729137;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rOI7Z+k/jw/HwkIzU4wUrpSnIOnbW4yX7Ts578dd7m0=;
        b=rYMwvPUynuIGjgab7Bis6AdYTKj9luicUvz0Cf6KHPH3i/YoPxhacrWncAJUBLpKt1
         ZkDFurfy9O4XdByALcFgh59jw3WyzhbFHU5sHUIM1NKBauy0msEa+O1WwMp/ygLy7uLH
         KlUjlJ0FLBjWynu3SmIbAoOQ/yk/VkZoUjM9D7j9YhjPNU/uS8DZQAlcHmhyZpS8uluD
         tr0ck7zNtqVtbUyQgT/Duh8mEt4NI1QET8qugRtlY8fY5/FkiephNEu/cTSIN9Acyt7F
         k2ORfkwTappP8aJBST/q4eg5H9OBD+XWXpLlBONeHkHHQT8050TMjqZEvivyPURDqCGs
         ITzg==
X-Forwarded-Encrypted: i=1; AJvYcCWCmsq2Qv1CrwUfS2odJ59d1IWj9JTwXHhi+CKbWKRcTPKcFA1B8rMV0S7uvYTr0c4ZfmM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsB60tRkkjzQS8KtktrRCN1YDDXqqk0s0sWwiP+yaSNEWp+u9G
	LKi/EeQnt62Pzx5RgeSaGPsiQTKMWu5PWLoV9vN7N+3EhKiSh/Pir61mj4vx6qfVtzmE7q0heaz
	guPudUusAbseJIqfj1Fw72xWflSyNOX1ybZLERCb1Ad0PHv9YTA==
X-Gm-Gg: ASbGncvll0Svabb+sb/xi4cLB10ULBXpc8yLB2tSRy7lPkvb0fNzmPeIXSP7cDZNIQ7
	qnjDepz0H4BfUrUk7bqq/zZS4EABkZz/OmD/ZdRWToI3Iiutr0Ry4LAMPi0mYyqrKUWr/zjrqsH
	PYWsTVitdH2T3WblixvbXMvr707Le8yRT3rwMHQfTe8NG/TQEyfodUJy+lQ4pCeN8WpPZ7/b1R7
	LqSdeXwUZZX9zE5dV95c764s9MOL4Aqd7qr8h7wYSqC9xasaDJVaku0+QxoGQ9WdJIORbzwiJBw
	sEgnUpTPIwoTf6BYVir+lOBlSkHUE2fPVsUuqEX1Pb2QBTIV9+j84qkuo6XsP2OR
X-Received: by 2002:a05:600c:5246:b0:439:9a40:aa09 with SMTP id 5b1f17b1804b1-439ae21d202mr13079545e9.25.1740124337017;
        Thu, 20 Feb 2025 23:52:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6RndQ6ymoZEFzvzfDt+1GKRpaPngpEuFYmDAHqGLJUcufH5YS8MWYZmZqlHO+/W+nddETwA==
X-Received: by 2002:a05:600c:5246:b0:439:9a40:aa09 with SMTP id 5b1f17b1804b1-439ae21d202mr13079435e9.25.1740124336660;
        Thu, 20 Feb 2025 23:52:16 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02ce735sm9240925e9.3.2025.02.20.23.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 23:52:16 -0800 (PST)
Date: Fri, 21 Feb 2025 08:52:15 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>, gankulkarni@os.amperecomputing.com
Subject: Re: [PATCH v2 02/14] KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest
 and userspace
In-Reply-To: <86r03squ0w.wl-maz@kernel.org>
Message-ID: <5f9699c5-ccc8-9339-bfca-1ace8d7f86b6@redhat.com>
References: <20250220134907.554085-1-maz@kernel.org> <20250220134907.554085-3-maz@kernel.org> <af16f5bc-4300-54d3-b480-c559ec070a44@redhat.com> <86r03squ0w.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 20 Feb 2025, Marc Zyngier wrote:
> On Thu, 20 Feb 2025 17:36:35 +0000,
> Sebastian Ott <sebott@redhat.com> wrote:
>> On Thu, 20 Feb 2025, Marc Zyngier wrote:
>>> Since our take on FEAT_NV is to only support FEAT_NV2, we should
>>> never expose ID_AA64MMFR2_EL1.NV to a guest nor userspace.
>>>
>>> Make sure we mask this field for good.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>> arch/arm64/kvm/sys_regs.c | 1 +
>>> 1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 82430c1e1dd02..9f10dbd26e348 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1627,6 +1627,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
>>> 		break;
>>> 	case SYS_ID_AA64MMFR2_EL1:
>>> 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
>>> +		val &= ~ID_AA64MMFR2_EL1_NV;
>>> 		break;
>>
>> This would cause issues when you update the host kernel while keeping the
>> guests register state. Could we allow to write (but ignore) the previously
>> valid value? Like it was handled in:
>> 	6685f5d572c2 KVM: arm64: Disable MPAM visibility by default and ignore VMM writes
>
> Yeah, this falls into the same "shouldn't have exposed this the first
> place" bucket. Annoying. Something like the diff below?

Yes, thanks!


