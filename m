Return-Path: <kvm+bounces-43946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA58A98F61
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 732191891F0F
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDCF288C93;
	Wed, 23 Apr 2025 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EhonNnAs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FF22857E4
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420401; cv=none; b=aBLv4aiATCLBxpWeLIgds6mpvxy2334ncxUjf92Ka9WzSusFB2uZ7HexyEelkoxB6JhvYvOpegU4tHCy9Uj7+EuUZipTS04IdrTbLiTkSz0dhionOJ39zS24Zi82RLE/a0tl4LfD1fKIrWA9J7APoZpgD6c3Dep0DluHVJtdrPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420401; c=relaxed/simple;
	bh=joC8MPhe7Y4rGylApsFiNVu3DF0J+Ie5/Hv0obGM2hM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S1s4nXxzDmdj4Qz/GPO+cWA/+2VrKpi1fiRfV3RPobX5bKnAsX94q8GKRWbIM8iqa3mUqgQ3qbDBHi06V/+gsDCbCoEsOns0n5XwxdW2UM4Yotc2zmhMBm3l6TLPHKrb+xch3ZLANht1q1JwxM1c/9VxE/ZxpR6vhV17dFhUYAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EhonNnAs; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b048d1abbbfso6666189a12.0
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 07:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745420399; x=1746025199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R3Z3M3/CXlzJB2P4gpatwmi73KDGw0Pwe4smUmYNNEg=;
        b=EhonNnAsFn4kFGC9hvM8WD6c6OJB1QYdf0t386rmMxnFA7VO9j+xdbBvsOQy9w4LyZ
         BUfkolovdtL+BYW4c6PX8uBIuZtrpLne8s27L0/iDfpWCzwNCNYK3uE2JVNp4Zla4jAb
         uC7oQLYIWxBXZA/sZDBvwwGkOLUYHoctTpuHTS1IB56t5XHjcfMNEleGPl4kt9FL4ZYh
         6b5YgPXVZDGgxWlDlVjMvTf6ajoaFldmf5in5wXE9ZTaANW9xJTDeMGgYObU9nnTn7O+
         WCyGs94dvnB2MRITDGlequiSdOchmbv9vBJVomj5TEWoZjDHRp/7BOiWeutxAOhjb08g
         h+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745420399; x=1746025199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R3Z3M3/CXlzJB2P4gpatwmi73KDGw0Pwe4smUmYNNEg=;
        b=js9fLBzmu3GUC8ZDFVTr3pHO5OBW3zDM1jMf9mcUEOVv9YVNPkJNAjWOthHJDWXmYk
         wNCa0Q0SSzZUhviHhfv70yx1LI3bDvj41kP/NgCNL0y/lrMrSfPfyQnEKfjMXHegWXim
         ie2iYFlZQRsAfZ9xTHCTZMsnR5wzJ4Wph9xTmv0IdhCV7KOKq1aL+eg4txIxdOsyBN1f
         sMh60y4bW8tIWqZMec7Zr/QSgMPhWIy91RysQN0AII2+0H4bRkKVV2spCQ9VIhMFfB6P
         MuSKosJARmujD5mPgPswokeOoWHOpgHmMwRfB9YGD2pfqH1ltolapjs0fFe2GA7EwdYn
         T1/g==
X-Forwarded-Encrypted: i=1; AJvYcCWb2ZOdlQiKFvKL4/avKXU+G2TTdYAFlx5JtQ074oVAliZXwrWus78bbPrDA4AHqYXAYX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKUvOEwRiadukLM9pT5iCjaLifadR0kRQMXl32mJis8MVxKWCh
	WmjSvH4KaHdUmd+odn8e06Oe1F119v8XoKEkSyBpX0AZPTenHONjEmXkXO7CFr7C36H1Atosivx
	EKQ==
X-Google-Smtp-Source: AGHT+IGO/Sd0tdO6i4UFNRj94tDZvIUgQD1LkF3gNieibzRpO8k6bRf3NkI2HYbT67Asea9crY0mzdt+CSE=
X-Received: from pgbcz4.prod.google.com ([2002:a05:6a02:2304:b0:b0d:b491:d409])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7887:b0:1f5:837b:1868
 with SMTP id adf61e73a8af0-203cbd0b606mr31028743637.29.1745420388576; Wed, 23
 Apr 2025 07:59:48 -0700 (PDT)
Date: Wed, 23 Apr 2025 07:59:47 -0700
In-Reply-To: <20250423092509.3162-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250423092509.3162-1-lirongqing@baidu.com>
Message-ID: <aAkAY40UbqzQNr8m@google.com>
Subject: Re: [PATCH] KVM: Use call_rcu() in kvm_io_bus_register_dev
From: Sean Christopherson <seanjc@google.com>
To: lirongqing <lirongqing@baidu.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lizhaoxin <lizhaoxin04@baidu.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 23, 2025, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Use call_rcu() instead of costly synchronize_srcu_expedited(), this
> can reduce the VM bootup time, and reduce VM migration downtime
>
> Signed-off-by: lizhaoxin <lizhaoxin04@baidu.com>

If lizhaoxin is a co-author, then this needs:

  Co-developed-by: lizhaoxin <lizhaoxin04@baidu.com>

If they are _the_ author, then the From: above is wrong.

> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 11 +++++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 291d49b..e772704 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -203,6 +203,7 @@ struct kvm_io_range {
>  #define NR_IOBUS_DEVS 1000
>  
>  struct kvm_io_bus {
> +	struct rcu_head rcu;
>  	int dev_count;
>  	int ioeventfd_count;
>  	struct kvm_io_range range[];
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2e591cc..af730a5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5865,6 +5865,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>  	return r < 0 ? r : 0;
>  }
>  
> +static void free_kvm_io_bus(struct rcu_head *rcu)
> +{
> +	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
> +
> +	kfree(bus);
> +}
> +
>  int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  			    int len, struct kvm_io_device *dev)
>  {
> @@ -5903,8 +5910,8 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  	memcpy(new_bus->range + i + 1, bus->range + i,
>  		(bus->dev_count - i) * sizeof(struct kvm_io_range));
>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> -	synchronize_srcu_expedited(&kvm->srcu);
> -	kfree(bus);
> +
> +	call_srcu(&kvm->srcu, &bus->rcu, free_kvm_io_bus);

I don't think this is safe from a functional correctness perspective, as KVM must
guarantee all readers see the new device before KVM returns control to userspace.
E.g. I'm pretty sure KVM_REGISTER_COALESCED_MMIO is used while vCPUs are active.

However, I'm pretty sure the only readers that actually rely on SRCU are vCPUs,
so I _think_ the synchronize_srcu_expedited() is necessary if and only if vCPUs
have been created.

That could race with concurrent vCPU creation in a few flows that don't take
kvm->lock, but that should be ok from an ABI perspective.  False positives (vCPU
creation fails) are benign, and false negatives (vCPU created after the check)
are inherently racy, i.e. userspace can't guarantee the vCPU sees any particular
ordering.

So this?

	if (READ_ONCE(kvm->created_vcpus)) {
		synchronize_srcu_expedited(&kvm->srcu);
		kfree(bus);
	} else {
		call_srcu(&kvm->srcu, &bus->rcu, free_kvm_io_bus);
	}

