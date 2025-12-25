Return-Path: <kvm+bounces-66683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8606CCDD635
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 07:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F06F9300DB9F
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 06:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BAB283CBF;
	Thu, 25 Dec 2025 06:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y4ufkNiH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9741EB5F8
	for <kvm@vger.kernel.org>; Thu, 25 Dec 2025 06:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766645547; cv=none; b=CxyFWed6np1iqbT4ntxJ+iCZDw7nVFMEh0QSZEr8ctYxGObF4u5SvzRI0DLkdVBbHKwU1vGie20q3WDHYFRkSErubebMH9KJ1d3j+g4LIPw7BiGsCNvmdwMY+WHC/Gtp/JmYJ/ADBAgBLQebkjJLJJYvaNj/gBz54Jg+09Dfi84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766645547; c=relaxed/simple;
	bh=isd6HGqy/sg2n7ckVNki1fOEFjslzRnZoaWBlNKZw+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CifbL+tQ7G8PqiFN5q4cosC5cZRnl/ii5xGjnnQXj5AyWEeU9TpAQ/TVYB3wtBf6Z9GBJL490aXXvesok4wnvIMQZqbrqV2+fsaaDJCROXO06WBTTXxsR2IlE/ndLmlgo4LSFThAW8BjEcdm13BBHGxLvts57VwebGSEKuglbw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y4ufkNiH; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b89c1ce9easo7338215b3a.2
        for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 22:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766645545; x=1767250345; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3uCWfc7sMOchK6NyBr2nFKxzXIULsvWwWuH2RIHi8E=;
        b=Y4ufkNiHkSJsbgFJLSDWhCRhFBx1oJyxBpn1s1dp6PEMEp1jH3sSjsyxdO2MKK9g4o
         XU/uiycV1GyZHqIge7lpVz1CPblr7V8Q32wdk9azP1GWOzdJgWjW5NQwBJNPlTfyLyW+
         YDtKqoLdDRdlZzpfRulL0hK4oQ/4zA4AFkkG8cLBATmLqT6zb7GlPsf3qDPiwcNoNe1+
         Mopw8RoKD5gAhXLWe+o0v9OSbgRBnGyuLHvsCBZ2E8nNeAKphSQ4C9VNYn/WWl3bBvaM
         rRhJA4HE803EVnFVXDb58XHv2aTCBdAYP7cYfeGoz6+kVs6RpGYLaCI+r1PM7+GKzGt2
         Fu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766645545; x=1767250345;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y3uCWfc7sMOchK6NyBr2nFKxzXIULsvWwWuH2RIHi8E=;
        b=SwHNaQ8788S7AduFNARx5MIkehYtWqiczg4iX0LQcGw9IkwFzfe40wMAnl1Wp/poAL
         gzITwhGYR4Yyz5phRWZMglevUPTsvk5eQZxuUsj3sCK6QNvlnz3KDs9XcgXKL4WlH0Bs
         2ukktYGUn6vKj2WgGiSEmQgZJS+QZYsLXspBvqHfTZyFOTwfx3SoBFWA9rvnUAd126+G
         kADyvzlx4Glo53qutAHrKezk0jPf7rkDJ1yTdlnME4NY5f1EhTFMIuc4LTmBgNZq08KW
         +aA7N2vt0CmfRT+7gfoqFMXlX7wIasfTDnntTn/euxeYD+UgBnQlLXV9c7qZvjacRhLW
         ETQA==
X-Gm-Message-State: AOJu0Ywu/FRpGTNSf97FqHN7ErJFrU2ZK8z+AORPIoNT5HygAtwPlHty
	R4t56GXv0Ur8hspeJk4KyBQPfoWBiOJPz4FkyKPNabQF/tAexCUsEVix
X-Gm-Gg: AY/fxX45BSXsEPfV/ZNGvRMVVMDfkIkuB8qAHdNLJ7QqBL1wc+SDNUgAcQQ2bXWLh3k
	NAbAi4yQLbh0GIqsMYEg0k+V3LdNYyuRMeXczbOiEgQ/86E8K3TJ26mVvPhUHDb/aIq2VuvmNmP
	UhIajcoaa3CMgcAxC1UVyNwYXPmjEYHPV4BeD3fRxcgsHpjJU+xN5KNtPMxL6J42POKnjT0wgYl
	kqMEuZzFLd0twm6Swd3QkDGLYUkXTkis63ibya24bbKFEwi1gaTSDqT+7WNjoULfH3IwhWdYEZV
	RAx/4AZ+mjJh2FWBR63o/p2GDfw5jXKOUdVAiqXtGh1xlFhoRhHmPsOdEsECleyZMqaUWl5QW46
	hrdwggE78xlfeyqf9AsRf2AZTQynfOo9M7zXuEPmMX6dBUatM5I1aVlrPzkh47qThHLhTF9pxVm
	hwi0DWOl8NIQbQMNx6KqZHbNHzcA==
X-Google-Smtp-Source: AGHT+IHag5DUPBAXJdp7qU/XBoBT+pBt5JqBALlHA1O9ZBr3lgysekVSQQSjGNooInOWNccTQZDVgQ==
X-Received: by 2002:a05:6a00:bb84:b0:7e8:4471:ae6d with SMTP id d2e1a72fcca58-7ff67e55cafmr17120251b3a.57.1766645545209;
        Wed, 24 Dec 2025 22:52:25 -0800 (PST)
Received: from [10.3.168.204] ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a19besm18352151b3a.40.2025.12.24.22.52.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Dec 2025 22:52:24 -0800 (PST)
Message-ID: <ad38f0c1-83c1-4977-8846-32864973331d@gmail.com>
Date: Thu, 25 Dec 2025 14:52:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: irqchip: KVM: Reduce allocation overhead in
 kvm_set_irq_routing()
To: Yanfei Xu <yanfei.xu@bytedance.com>, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, caixiangfeng@bytedance.com,
 fangying.tommy@bytedance.com
References: <20251224023201.381586-1-yanfei.xu@bytedance.com>
From: Yanfei Xu <isyanfei.xu@gmail.com>
In-Reply-To: <20251224023201.381586-1-yanfei.xu@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2025/12/24 10:32, Yanfei Xu wrote:
> In guests with many VFIO devices and MSI-X vectors, kvm_set_irq_routing()
> becomes a high-overhead operation. Each invocation walks the entire IRQ
> routing table and reallocates/frees every routing entry.
>
> As the routing table grows on each call, entry allocation and freeing
> dominate the execution time of this function. In scenarios such as VM
> live migration or live upgrade, this behavior can introduce unnecessary
> downtime.
>
> Allocate memory for all routing entries in one shot using kcalloc(),
> allowing them to be freed together with a single kfree() call.
>
> Example: On a VM with 120 vCPUs and 15 VFIO devices (virtio-net), the
> total number of calls to kzalloc and kfree is over 20000. With this
> change, it is reduced to around 30.
>
> Reported-by: Xiangfeng Cai <caixiangfeng@bytedance.com>
> Signed-off-by: Yanfei Xu <yanfei.xu@bytedance.com>
> ---
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/irqchip.c       | 21 +++++++++------------
>   2 files changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 15656b7fba6c..aae6ea9940a0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -690,6 +690,7 @@ struct kvm_kernel_irq_routing_entry {
>   struct kvm_irq_routing_table {
>   	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
>   	u32 nr_rt_entries;
> +	struct kvm_kernel_irq_routing_entry *entries_addr;
>   	/*
>   	 * Array indexed by gsi. Each entry contains list of irq chips
>   	 * the gsi is connected to.
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 6ccabfd32287..0eac1c634fa5 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -109,10 +109,10 @@ static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
>   
>   		hlist_for_each_entry_safe(e, n, &rt->map[i], link) {
>   			hlist_del(&e->link);
> -			kfree(e);
>   		}
>   	}

Hi maintainer,

Before sending v2 to address the lkp warning, I would like to ask whether

free_irq_routing_table() can be simplified by removing the iteration over

the entries and the hlist cleanup, as shown below.

The contents of the irq routing table are always replaced by creating a

new table under srcu, so iterating over the entries and calling hlist_del()

is effectively unnecessary. I kept the cleanup logic originally because

semantically it seemed reasonable to clear the data structures before

freeing them, but in practice it does not appear to be required.


Thanks，

Yanfei

  static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
  {
-       int i;
-
         if (!rt)
                 return;

-       for (i = 0; i < rt->nr_rt_entries; ++i) {
-               struct kvm_kernel_irq_routing_entry *e;
-               struct hlist_node *n;
-
-               hlist_for_each_entry_safe(e, n, &rt->map[i], link) {
-                       hlist_del(&e->link);
-               }
-       }
-
         kfree(rt->entries_addr);
         kfree(rt);
  }

>   
> +	kfree(rt->entries_addr);
>   	kfree(rt);
>   }
>   
> @@ -186,6 +186,10 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   	new = kzalloc(struct_size(new, map, nr_rt_entries), GFP_KERNEL_ACCOUNT);
>   	if (!new)
>   		return -ENOMEM;
> +	e = kcalloc(nr, sizeof(*e), GFP_KERNEL_ACCOUNT);
> +	if (!e)
> +		goto out;
> +	new->entries_addr = e;
>   
>   	new->nr_rt_entries = nr_rt_entries;
>   	for (i = 0; i < KVM_NR_IRQCHIPS; i++)
> @@ -193,25 +197,20 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   			new->chip[i][j] = -1;
>   
>   	for (i = 0; i < nr; ++i) {
> -		r = -ENOMEM;
> -		e = kzalloc(sizeof(*e), GFP_KERNEL_ACCOUNT);
> -		if (!e)
> -			goto out;
> -
>   		r = -EINVAL;
>   		switch (ue->type) {
>   		case KVM_IRQ_ROUTING_MSI:
>   			if (ue->flags & ~KVM_MSI_VALID_DEVID)
> -				goto free_entry;
> +				goto out;
>   			break;
>   		default:
>   			if (ue->flags)
> -				goto free_entry;
> +				goto out;
>   			break;
>   		}
> -		r = setup_routing_entry(kvm, new, e, ue);
> +		r = setup_routing_entry(kvm, new, e + i, ue);
>   		if (r)
> -			goto free_entry;
> +			goto out;
>   		++ue;
>   	}
>   
> @@ -228,8 +227,6 @@ int kvm_set_irq_routing(struct kvm *kvm,
>   	r = 0;
>   	goto out;
>   
> -free_entry:
> -	kfree(e);
>   out:
>   	free_irq_routing_table(new);
>   

