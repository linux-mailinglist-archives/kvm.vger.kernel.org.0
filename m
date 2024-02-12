Return-Path: <kvm+bounces-8554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7352085144B
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 14:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDE031F21D76
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 13:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A2C3A27B;
	Mon, 12 Feb 2024 13:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQ13ahZq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D7E3A1BE
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 13:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707743592; cv=none; b=Skbz3tdQfvXP3Yy+y7+0HPm3g2rXeZYNx9pPdLA6Agsz3VrCACryvXh7s667b9uArh5JNsxlkBzJ24udpOIwO0gKkI3zHBVXdLEpY7yvHBz0sERc22huS4Ig1IbuhJQBD2nGrPPoA+XhEkkI6M+Nq2WszrcFq9XCA4gdreZyX7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707743592; c=relaxed/simple;
	bh=VGqK2EXbpd35gsVz1xmG61zXP49yz5ANJzMkWNNw1mQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j/WP8ZINL7TPsk3NHb2dXsZid60AyvdQgfArT9VAreF8IeSIQRNh3k307wbF22czMKnNotGnfZ1SVEaVIwi1iktMAM5VQFaYTV9E6VjLl4TOo00vkPRkSK4+BoIL3Yk+gKCBUJHuQ0cQwk3kzJ/tdN9QcEUioQLaaoG3scZt3vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PQ13ahZq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707743589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Hww63RycILkhWmUV7kV9IBG+ru1x1IcPxqyllH9PLOo=;
	b=PQ13ahZqgTbzXYrgl4EWnRZgjZz9P/6+x7YHI1pL3K8obyu17OpW8Wl4K4a9+n5pYA9aUe
	AOw8cbF2T3E4e31eVFQqsIpdNCwlg5MYYrJyIK4FEvg0jtChgYN4ugWwS6KQCWBSaOnltJ
	lE0Hi/dAHBkDXElrX34/zzVbSsaoKwo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-wPZn73kPM_ugTxYodwNrMA-1; Mon, 12 Feb 2024 08:13:08 -0500
X-MC-Unique: wPZn73kPM_ugTxYodwNrMA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33b2238ceceso1523496f8f.3
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 05:13:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707743587; x=1708348387;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hww63RycILkhWmUV7kV9IBG+ru1x1IcPxqyllH9PLOo=;
        b=gc/20jVoUEbupu5YiGc2Lv3BYYEMgYrVY5UhJGm9wgt7Ex9CX8DMS6ErPYokIEBiMx
         fxk4+naF/BAqCwZQQjUaRCccSyYLwmNjUiZs5QTm9r9XKVGZWKrMREM/RkqtrOzB/3gD
         6EuhaanuIkVfmqgLVviqCHxCILAt1NLNwNuaYvTdQua3jzxgDY9Ft5H2ocDUW025KcYy
         fdT8AITQ1H7JQnI1nvJ9ULksOSJv/t9Yt3jHpxy+Vx6VJqVezNG3SN72HoW2Njw25pVC
         MQceFuIOHonPI93mZYA1nYHjCSc7Ny4Z5XomD/ZRPsYllfB7Q20WLDOySBnuQ9yGpszH
         hTyg==
X-Gm-Message-State: AOJu0Yx79+SgVPBpeM4KoiuzsM1D/iUulq4QGiU1JgJm8lPD41HnULMR
	L5ARUJuc6/e3B/mPKv475OR52clz5CJFvb8IiVsBp4Te6LZK+Uy9z7IWGTmbsUxPAuO31r0YEVA
	mg8mfRtoazgBJy8dN+hUbbKXBOS2MfD4PfVqXtK09TMr1YkV1YA==
X-Received: by 2002:a5d:6486:0:b0:33b:2300:9cdc with SMTP id o6-20020a5d6486000000b0033b23009cdcmr7236107wri.46.1707743587332;
        Mon, 12 Feb 2024 05:13:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEReINvzzr3H3VeDrYjZvaBxMo8PW95UvCVHUhmv21+hC5vvpCm8WTG48/ufAWGbGiAoJPPvA==
X-Received: by 2002:a5d:6486:0:b0:33b:2300:9cdc with SMTP id o6-20020a5d6486000000b0033b23009cdcmr7236087wri.46.1707743586951;
        Mon, 12 Feb 2024 05:13:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWWeeld+7JwdNTQDsO0jkryY+u3yAmckhW5SgRfY+5fV0ldQLhXXhSGIBvW6yxuM6zRKiccyP3VhYlPNRkp6gCsN4NupAgVtdA53/cZN1jEJvW9vV3mSCetbGX6LwDzEn3zJpuZsXFm6CNGtibvKcTPpb233CZ22JVAPXIXTCmZntQaFS3fMBEcrgnI0PEOEWpVW+Hm9hvrwz+t82XpzsFwC4KNE0TV5Sh19Rlmv0ziwCGeLv6DOUDBWNPVIegCMaIRSoF4C3Zxw2EcsDgQ7Lsdfdsf3B2iFGeDqjN3AUxGZ3OemCE3PMbXHE4Kp5lsdGr55YiNMKbg4GK7AyLyDeK+rhAstxl4MJn+9OumR2Hd4/9tgDhqDsHHZPr+k3UjsfQ4wSTI70zR71/k4RmpH5RXijU020/DjCK8qfsVVvuSrUVtfZ0QIqYeSYIwFksKpKipoURwJ7twbuLZXn5D30oieiRwXmKp4Vm3nm52Us+3cpnJcEJGqkrLeRn+mC+Wpwy1TthMiFKfJWwVJhcO/71VNGpHQTx+sFFbVl4PY/KqwO2U5snvWjBxpmXohzrw4PpUdu2a1f2iNR/J/GF5GwRBGzq8bNS/l3v0a3YGxtjyArrx3aA4MGFJ9kP3F8rxmUWSgmKN7EJwEDrBsbB/u6RofAe3tv4CwuGCyN/ggyOiX71r0C4FH6E/7DDH0RKkQrZl49ObylJ4I4dJjA6xWeWiM6Itpno30Zt1AfZU0jmMkv+JbKTuIG0MgjquGpaZV03XvGtbNbGcevA3XfoWU3l5KhPrsaAN5JyXobw0snxKWjQ7zZ0TIBqmYoAT5taJ1TGPlKfxQ3LXb3tCAcj8iT6R2XUgjIQCZWqsUa5jHxw8h0Q0R0Iq2MNqI2CYyC1zlXUc2Q0iF/lNw6SowtcdKTAUH8MyBD9YN2zO7Dp3Ml1iS1l08wSULWfQqgWMlRbGQBPpq2
 4FEEQifKZjTIU02Tf7cbrbE3std9+7VYMZtSN8ow3ZMho9DSfMsFshcXi7IrBQjs3eaE6roSK1Ci0cvCQ6ZsaY50LI19L30xDdDEsJN60TWYUfLupgPQTHWE7JOryQy4zkCgzfF1srp0GLCDtV3PBfnctsJ5+KPMRBg+dlHvtAfRzm7TXFDOfiJd+Luhuksi21pxTg2vINRJheJIiGsbdMMYI9/ACXKt7i4+gB8H8st97ckVnIGfalVW/sWoJWe88CbAu5yy0wkW3eyV1EAf4W+IBe4Y6m83uKzJWFOhK4vYhveT/wkym+/0Eelze0DHYINSgRdvq8jojh
Received: from ?IPV6:2003:cb:c730:2200:7229:83b1:524e:283a? (p200300cbc7302200722983b1524e283a.dip0.t-ipconnect.de. [2003:cb:c730:2200:7229:83b1:524e:283a])
        by smtp.gmail.com with ESMTPSA id x8-20020a5d6508000000b0033b1b01e4fcsm6805291wru.96.2024.02.12.05.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 05:13:06 -0800 (PST)
Message-ID: <165363ba-d6cc-47a7-ab2a-d3a27a42f739@redhat.com>
Date: Mon, 12 Feb 2024 14:13:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/4] mm: introduce new flag to indicate wc safe
Content-Language: en-US
To: ankita@nvidia.com, jgg@nvidia.com, maz@kernel.org,
 oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, reinette.chatre@intel.com, surenb@google.com,
 stefanha@redhat.com, brauner@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, alex.williamson@redhat.com,
 kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, andreyknvl@gmail.com, wangjinchao@xfusion.com,
 gshan@redhat.com, shahuang@redhat.com, ricarkol@google.com,
 linux-mm@kvack.org, lpieralisi@kernel.org, rananta@google.com,
 ryan.roberts@arm.com, linus.walleij@linaro.org, bhe@redhat.com
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
 apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
 kvmarm@lists.linux.dev, mochs@nvidia.com, zhiw@nvidia.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20240211174705.31992-1-ankita@nvidia.com>
 <20240211174705.31992-3-ankita@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240211174705.31992-3-ankita@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.02.24 18:47, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Generalizing S2 setting from DEVICE_nGnRE to NormalNc for non PCI
> devices may be problematic. E.g. GICv2 vCPU interface, which is
> effectively a shared peripheral, can allow a guest to affect another
> guest's interrupt distribution. The issue may be solved by limiting
> the relaxation to mappings that have a user VMA. Still there is
> insufficient information and uncertainity in the behavior of

s/uncertainity/uncertainty/

> non PCI drivers.
> 
> Add a new flag VM_ALLOW_ANY_UNCACHED to indicate KVM that the device
> is WC capable and these S2 changes can be extended to it. KVM can use
> this flag to activate the code.
> 

MM people will stumble only over this commit at some point, looking for 
details. It might make sense to add a bit more details on the underlying 
problem (user space tables vs. stage-1 vs. stage-2) and why we want to 
have a different mapping in user space compared to stage-1.

Then, describe that the VMA flag was found to be the simplest and 
cleanest way to communicate this information from VFIO to KVM.

> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>   include/linux/mm.h | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f5a97dec5169..59576e56c58b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -391,6 +391,20 @@ extern unsigned int kobjsize(const void *objp);
>   # define VM_UFFD_MINOR		VM_NONE
>   #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
>   
> +/*
> + * This flag is used to connect VFIO to arch specific KVM code. It
> + * indicates that the memory under this VMA is safe for use with any
> + * non-cachable memory type inside KVM. Some VFIO devices, on some
> + * platforms, are thought to be unsafe and can cause machine crashes
> + * if KVM does not lock down the memory type.
> + */
> +#ifdef CONFIG_64BIT
> +#define VM_ALLOW_ANY_UNCACHED_BIT	39
> +#define VM_ALLOW_ANY_UNCACHED		BIT(VM_ALLOW_ANY_UNCACHED_BIT)
> +#else
> +#define VM_ALLOW_ANY_UNCACHED		VM_NONE
> +#endif
> +
>   /* Bits set in the VMA until the stack is in its final location */
>   #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
>   

It's not perfect (very VFIO <-> KVM specific right now, VMA flags feel a 
bit wrong), but it certainly easier and cleaner than any alternatives I 
could think of.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


