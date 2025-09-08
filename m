Return-Path: <kvm+bounces-57003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40071B49A46
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 21:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAAE216A039
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 19:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34E32BF000;
	Mon,  8 Sep 2025 19:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uO2ir1uH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D5C28DB54
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 19:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757360694; cv=none; b=RaXHuefY8X3ATbHt5+5ijUVnasOpe+pCyzEc9CcaZoQhBp+1zUieENHcunTavUdPjVf8whLMhgl8L1fImn4cxrqC1OWn1zHVmlYqCoiXL/de0zO28OAH2XjVxLj4k50NSwFKkHdK77DiFX5S45D/AB+qK9WdbnCRBoaUJK2jixw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757360694; c=relaxed/simple;
	bh=xxX6qsulkVirIUPMtxxcMy/WlTsw7wbx1cEPYNOUvQ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OYmNQgk0VcRlwFrBeMK32dyikXW/nL9w7VVjfKaOZpPWV1Dz5lhQL3eyeZSRqBZVseDangCwElWHm2u4HuTBhCEAq16Y8d/cCDbR8ih2P0rxEVZHI9BcTx5d0lCPuwzPoWcZwVT/IaZwp6tvLplf8owVl4dAYQ6u7uIwgMAQQUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uO2ir1uH; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4c949fc524so3736983a12.2
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 12:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757360692; x=1757965492; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+BN9f9TRNhPzZGbZcN/O3Z0X+3jX9IGhyykVuk72IV0=;
        b=uO2ir1uHTtgukzGG0spIgfg73ve9aliGXE89LTjOEkzUnWj/hTErCIvAwFr+M6iZwp
         67gTNZ7b5OA1pa5LjnHBZz0E4YylwDGqL+yFJBQuonphkgqKxrUfSd3Uc2HqnSCBpI5S
         MVHJFjlraIreUeahQLMom+9wo8msLioW/kVGzsjyd2uuf0tVj3a9pF5BSRRUALaUe+TD
         +MXJ9X9NEeVMrRNdykWQLFfDdx6negXe+fNELJaiNW/xZN3i48pB2fWPY2u8uOeLjyoi
         WiUUvDGVritslS0J5MndrANAaep1frTiTnCjmC/OaKTzkBZZQMhEx81BITkVmVwXRlIE
         cbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757360692; x=1757965492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+BN9f9TRNhPzZGbZcN/O3Z0X+3jX9IGhyykVuk72IV0=;
        b=nwZuln1m+cpUwEUfbigVQ+IVXr/y0V0VRJCwwX6w1clrm1O9wUb7yELjy2mA+o8hG4
         1otlToWmW85mOnj3Gm0VwJwnwEYdqyZsOp9pygJmp1UGbSmYPsg2EgE7sPuOToqrcfdy
         XHZrbcIhqr5hrgeTQFRQ2uar+kJOsnSHxPU6bfD3mlrFPICeBGyH285oUU/TcVHdJTBX
         i8Lt/fpoplyHlFCMGVtaYG5hrAAAZH3HjhQQdHy61/o9abjFXIWH+3I3rfQcK42bb76o
         s0dJPL4yEgxvpt2mlpTESQDMXV7zziopnvWPTj8fpqQ2MAvSg+uKnqacp4bwPPvI7VkK
         +gZA==
X-Forwarded-Encrypted: i=1; AJvYcCVvIEN8yUxrsXtCAVYxOkdHs0p6fX3v7TeEy60RQtGCVQ2oFaJ8Rd9n5fDsGhqW7OrnuVk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/w+JflsnjbbOFbdqhiWhwUswdDgw80qd9bvsswmTexBxResZT
	seCcu2dRsjmI8oxvzRWaiEVBr5r4HiLFHfIzoRjqnKTPWTS0u+YDV01/cmuetLSAisnew1HQoMv
	XeTF0GA==
X-Google-Smtp-Source: AGHT+IFxCnWEFD2vXNWgOPEAttN5OOtAqn765A51cfCV4FQPi8e13adf6at6Ei8q1uZLTqO9SeFgLpD0kRY=
X-Received: from pjbsq16.prod.google.com ([2002:a17:90b:5310:b0:329:ccdd:e725])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc4:b0:327:e9f4:4dd8
 with SMTP id 98e67ed59e1d1-32d43f2f4b6mr13695527a91.10.1757360691927; Mon, 08
 Sep 2025 12:44:51 -0700 (PDT)
Date: Mon, 8 Sep 2025 12:44:50 -0700
In-Reply-To: <20250819090853.3988626-5-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819090853.3988626-1-keirf@google.com> <20250819090853.3988626-5-keirf@google.com>
Message-ID: <aL8yMum27Qw_Wkkw@google.com>
Subject: Re: [PATCH v3 4/4] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
From: Sean Christopherson <seanjc@google.com>
To: Keir Fraser <keirf@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 19, 2025, Keir Fraser wrote:
> Device MMIO registration may happen quite frequently during VM boot,
> and the SRCU synchronization each time has a measurable effect
> on VM startup time. In our experiments it can account for around 25%
> of a VM's startup time.
> 
> Replace the synchronization with a deferred free of the old kvm_io_bus
> structure.
> 
> Signed-off-by: Keir Fraser <keirf@google.com>
> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 10 ++++++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e7d6111cf254..103be35caf0d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -206,6 +206,7 @@ struct kvm_io_range {
>  struct kvm_io_bus {
>  	int dev_count;
>  	int ioeventfd_count;
> +	struct rcu_head rcu;
>  	struct kvm_io_range range[];
>  };
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4f35ae23ee5a..9144a0b4a268 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5953,6 +5953,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>  }
>  EXPORT_SYMBOL_GPL(kvm_io_bus_read);
>  
> +static void __free_bus(struct rcu_head *rcu)
> +{
> +	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
> +
> +	kfree(bus);
> +}
> +
>  int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  			    int len, struct kvm_io_device *dev)
>  {
> @@ -5991,8 +5998,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  	memcpy(new_bus->range + i + 1, bus->range + i,
>  		(bus->dev_count - i) * sizeof(struct kvm_io_range));
>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> -	synchronize_srcu_expedited(&kvm->srcu);
> -	kfree(bus);
> +	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);

To address the syzkaller splat, KVM needs to call srcu_barrier() prior to freeing
the structure.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9144a0b4a268..62693f18ecf4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1321,6 +1321,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
                kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
        }
        cleanup_srcu_struct(&kvm->irq_srcu);
+       srcu_barrier(&kvm->srcu);
        cleanup_srcu_struct(&kvm->srcu);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
        xa_destroy(&kvm->mem_attr_array);

