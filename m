Return-Path: <kvm+bounces-35824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58BAEA1546B
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:33:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6361C3AB6C8
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E381A08A6;
	Fri, 17 Jan 2025 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0VL4va3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB3619885F
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131492; cv=none; b=uTaxOVC4935SQ03AEeX3MyPZTeu2b3NdrevfyRZ1eJBe+UU+Qncr/aua0v0/6dHUnoslB4IdJckODx1UTa4jtraeT1NVnwVu5MmchMr5phNo99MrvQRDUkKYq7EIHJcJjPuXKJt4q+mkKisHqV0C8D99z+/aoNjI/K7G3QQVxfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131492; c=relaxed/simple;
	bh=SUzw+Oq73Ti5mrMSVS2BVl5YvYwhL8yTQv6MVPwzzqM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OFLCFs+97LdPFH+kCZQO5jLVrdNEVtvCy0rFhBllljNMxdxPxqy7uY0iKa2mrsEmKhc9uLb0JXTnpJ7ZOOvQsaC6lBLThlZecdPA+YDwjmZjrBO9NxIh5oxQUC7ZM/+cUZRwDDL1ma+S6W51rRYN0FS7eDp12dpEZXpsA/Sq8l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0VL4va3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737131489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5kZSArTqPW7y8wazAkzMJhveaDrun60pF6L1VI/G06I=;
	b=L0VL4va3EYGS1+b3jJXcrWBEz2BnwDVHobZkrPovHFlQYK608MBtXdqQHqN/REFyyqDrig
	n2KqA114o3HI4fi4f86l4s6ugqt0QwKk3tvxTUbzVGGpzrGkhOxW8yP2S2LGQDrCz0E7Kv
	SnrgVVX3I7uxjISX9E5lUBS8GwZXhfE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-EZ3U80_4O-23Tsghhji4xQ-1; Fri, 17 Jan 2025 11:31:27 -0500
X-MC-Unique: EZ3U80_4O-23Tsghhji4xQ-1
X-Mimecast-MFC-AGG-ID: EZ3U80_4O-23Tsghhji4xQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43646b453bcso11628115e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:31:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131486; x=1737736286;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5kZSArTqPW7y8wazAkzMJhveaDrun60pF6L1VI/G06I=;
        b=OpNm7OHKvE1NAMpwadKH14jYynltyeD3K187ZU+OctIeTqxey2DGdszHbPLm3CS6ka
         Z8bvS4gFFrX1ahjq5NpJ3Fwhc4k7UaZS02AVCcn77O4aO1ZwE2iqF8OFlxpLslb01RAy
         Cl3jj7r6kz2NQgwCwRZuBxHjd31FGXDvA1TzIcIU11xli0cscvfhF/8f44wQZ/AOhonc
         2GB0yG5R0THIytokizMr/lYlpmzGXaTH2wwmmxjFNdpWg4FKNpFSLQV8W6OvKO5xX96Z
         TftX3QzWHyk6Zylxk87gMH6vBqfb/jedJus+HMwpS19VVwO/RSqShBXlQgJwTcXgemkd
         C/SQ==
X-Gm-Message-State: AOJu0Yyl5im2YYbnkvHvS2ALlWqexmGvDR2R4BT7uK9c951cc3uL1/oO
	FxZYxkaYtiDsPBArp/NNJEAeRjpu/xt3SvtAOjsb0XdnNciP2XRRSySVSA8kji7nEB92na9CvkW
	aS4cPyIn3b6X1XEd7pqMSdyjMBzdYJZx8wsAGjqx7vbEQnLQMZg==
X-Gm-Gg: ASbGncsh1KCOgb+Jn8I80XEJ1AdmMK8evh+cUC/d/58i0sjykBh1NlSXQJANMn38+CW
	kKjCh+4e3TwyLmQuizCD+8EhKlztpmeWqLxF1SZIDd4ObrnXlFOl7kk1qHS9hc5sBkZ6mfo8fpQ
	Ne1TzrcnD8URBpA9jeD8/ARQndfW/WmHUjOcb2leynhmq8zyVlKzTwxo6b4/PnSfkX6IE5E3oYx
	K9WFwV4hSqpnSkSKYUvv8Xy0ywES10SJ/hukVfmV1dQMAkzqfs=
X-Received: by 2002:a05:600c:5486:b0:436:51bb:7a52 with SMTP id 5b1f17b1804b1-438913c9c93mr33958885e9.7.1737131484803;
        Fri, 17 Jan 2025 08:31:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzybavdrtbNIcjbRCoDzaMdvU1XI2nGM8kEOYRxgMRQWuVVlEmre8BK1gVG96AlnqvHu/htA==
X-Received: by 2002:a05:600c:5486:b0:436:51bb:7a52 with SMTP id 5b1f17b1804b1-438913c9c93mr33958405e9.7.1737131484456;
        Fri, 17 Jan 2025 08:31:24 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74c4751sm97808145e9.19.2025.01.17.08.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:31:23 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Dongjie Zou
 <zoudongjie@huawei.com>, stable@vger.kernel
Subject: Re: [PATCH 3/5] KVM: selftests: Explicitly free CPUID array at end
 of Hyper-V CPUID test
In-Reply-To: <20250113222740.1481934-4-seanjc@google.com>
References: <20250113222740.1481934-1-seanjc@google.com>
 <20250113222740.1481934-4-seanjc@google.com>
Date: Fri, 17 Jan 2025 17:31:22 +0100
Message-ID: <87ikqd8krp.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Explicitly free the array of CPUID entries at the end of the Hyper-V CPUID
> test, mainly in anticipation of moving management of the array into the
> main test helper.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> index 9a0fcc713350..09f9874d7705 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> @@ -164,6 +164,7 @@ int main(int argc, char *argv[])
>  
>  	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
>  	test_hv_cpuid(hv_cpuid_entries, kvm_cpu_has(X86_FEATURE_VMX));
> +	free((void *)hv_cpuid_entries);

vcpu_get_supported_hv_cpuid() allocates memory for the resulting array
each time, however, kvm_get_supported_hv_cpuid() was designed after
what's now kvm_get_supported_cpuid() (afair) so it has an optimization
to ask KVM just once:

        static struct kvm_cpuid2 *cpuid;
        int kvm_fd;

        if (cpuid)
                return cpuid;

        cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
        kvm_fd = open_kvm_dev_path_or_exit();
	...

and it seems that if we free hv_cpuid_entries here, next time we call
kvm_get_supported_hv_cpuid() an already freed memory will be returned.
This doesn't matter in in this patch as we're about to quit anyway but
with the next one in the series it becomes problematic.

>  
>  out:
>  	kvm_vm_free(vm);

-- 
Vitaly


