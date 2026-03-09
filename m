Return-Path: <kvm+bounces-73325-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UCJGH3jqrmlRKAIAu9opvQ
	(envelope-from <kvm+bounces-73325-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:42:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D52EA23BEDC
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D78B930C5744
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E46C3DA5D5;
	Mon,  9 Mar 2026 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oCZco0nZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB2C3C1995
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773070591; cv=none; b=KRHsxZPdrQ6/VJrwADjHOoyPd8J+dRW+V4PT1zx7IUZG3d9d35nqD2Ss8e3PB9gGUvR5K2C5yVzKu432MQvwo9jF5orKtMPgnnT3fZgWv9V2U3LOFEWRqt3ki34duN092gZSjMdUHGrrUHH7FC7Aowy6ZykqfK0Qs0DVyGAKW6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773070591; c=relaxed/simple;
	bh=8STJekAaFwPzLSmMbD5LEd1DImwS08qunVsBresWQtI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tYqIbpohWBhtcbZQ0MmqvqyrbQbt+YOT1/P5ZptyWkCnj2R3F8WVRlyRyJq2Iv5hLop3aylSf0F/ApJ8+854j9KWayba8GlfHCEnhFmZGaweKCzhqew9OaXz3bSPuqvAu/mka13rMyeO22dXa78gKf/vJx9Af/dyNrtIox7UjEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oCZco0nZ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c738563e61eso3212393a12.2
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 08:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773070589; x=1773675389; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z/VyzIuCqmA7zPKt1jhrtzJRnA3TqN016b76izXw4pE=;
        b=oCZco0nZ43jrwY+ZxAtyaVEEgTaXQMbp6lPi/CY/6WfJk+W77uh9L1EgxctynQwOgw
         FH5d1N0L8+22oieqZQmww/jnsmHq+LMhL4bPOwEodFcuqPFnE8CdoByj61a85ot6+bCR
         3QnhpGQBCWkhUkJiXdMZyP8h7eXJYO7Nkyt54phWsckzgrHBNKlzRlMgbwee7xK5Btlm
         VKhNw7SQb18eHMnfYjcbtxuDPb4qGHKiqgfkKDP0ZzRPL1A/56WQWWSbvzNTrcvjgSKU
         uFrmx/9MArkuim/illB3+TRn51xaFBii7eAHC6wun3EoNmebNQ8tdJqKbBvOOmLqu/wI
         xDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773070589; x=1773675389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/VyzIuCqmA7zPKt1jhrtzJRnA3TqN016b76izXw4pE=;
        b=MoKHnPH88u7KuWB2p2ZyZ0NKmD8NBTIVEVFMDHAg3jHF1QtuSZP1POzBONbMzNCh99
         x3lTb6GMWXlhKhu3E6JKX1dBTAHlWkki74vsN96dlVcS3KITbTPzmd0JTW6xRTeYciJi
         JuDDWJP3J82EJhVAngrm/tYL/EBRn9jcTQ8cgphHTOGvsU/wNLBfZOj2NMonfF8ekvxm
         9tb7+BB9wnoBTYTMToKYnMaVXmD2+2twDWl+l/fUGWBREAAzC1oSA/h6ujl+GXOc6RGZ
         mYI4+X78nE2sJ+UwnsZZBJPuVzDHXSz9RY8BlkU0ADaThZnqHwfZcoqeNanqmeQFYzVj
         ADpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfeX4A7pnpxS8H1HPXE0JQ1WYD2DGHaqPyxsS1+BONzjjY9exa3Tpsws++x1xviF9c3kg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpVhJSQkCf6w1kcqR8c39TyWRCOniwMqkFI+yxvtymWnBle2mL
	q/PL1uId0+vfQn216q72TY3C82U9t+GGsWICQjzBviOGUBbpRv/WqBg/2TlBqq4Y+arA6iDgfRN
	NvBPk2A==
X-Received: from pgbfe16.prod.google.com ([2002:a05:6a02:2890:b0:c73:9d90:977a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3289:b0:398:9820:f6de
 with SMTP id adf61e73a8af0-398982100e0mr2684067637.49.1773070588807; Mon, 09
 Mar 2026 08:36:28 -0700 (PDT)
Date: Mon, 9 Mar 2026 08:36:27 -0700
In-Reply-To: <20260309092132.2484-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260309092132.2484-1-lirongqing@baidu.com>
Message-ID: <aa7o-4eHAfTikGec@google.com>
Subject: Re: [PATCH] KVM: eventfd: Remove redundant synchronize_srcu_expedited
 from irqfd assignment
From: Sean Christopherson <seanjc@google.com>
To: lirongqing <lirongqing@baidu.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: D52EA23BEDC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73325-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.939];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The synchronize_srcu_expedited() call in kvm_irqfd_assign() is unnecessary
> when adding a new irqfd to the resampler list. The list insertion is
> already RCU-safe, and existing readers will either see the old or the
> updated list without inconsistency.

It's not required for kernel safety, but I do think it's required for KVM's ABI,
e.g. to ensure the resampler is visible to readers before KVM_IRQFD returns to
userspace.

> Removing this call reduces latency during resampling irqfd setup.

May I ask why you're micro-optimizing VMs with an in-kernel I/O APIC?

> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  virt/kvm/eventfd.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 3201f60..facfeab 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -450,7 +450,6 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  		}
>  
>  		list_add_rcu(&irqfd->resampler_link, &irqfd->resampler->list);
> -		synchronize_srcu_expedited(&kvm->irq_srcu);
>  
>  		mutex_unlock(&kvm->irqfds.resampler_lock);
>  	}
> -- 
> 2.9.4
> 

