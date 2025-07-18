Return-Path: <kvm+bounces-52900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8241B0A6AB
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7F76A82D6E
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16531B87F0;
	Fri, 18 Jul 2025 14:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DpiZCNOv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6A64503B
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752850430; cv=none; b=TBODLgoaWKOYmhDg3n9iZeFPP8z6AZcHEzpGGRY8MQLv0wl4WguCQlLg0koJCBAYtEXu/9SIDMLOk8BDg2RYYWMKSAEq4hSeAVEgYVkzAeuQghEYikbrZKYFzk0mSkHsK0tTGG/DM/YCB//SIPCjfSj+aSQNtx83LUxjkOCQChk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752850430; c=relaxed/simple;
	bh=mN3hzgJiNNPNWOhTNaA5bwuVe2pOkU891xX3VE06RGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VXSX6oEx0ON26zyTABrKBNBHTBOe8L7P9RD97v33ggD0un6SE9rN4zx6RmuRR1YHRzDoBaor7Ur1OSJFB1rarZ50CDDRb5xKGs9zkE2qFizEs8RZ/bcypn2hdnjxMJF7Jt35ua1Dz7AfmZKu5LFIHUsKDozfsdArzejv6tymf9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DpiZCNOv; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a588da60dfso1359534f8f.1
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752850427; x=1753455227; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cRq4mZGW6hHwIgirPnFC0Ellx4rYs15LC6saX2uSxGU=;
        b=DpiZCNOvhZvyMJVGLNNEhZFz8PHOXuVCCTQ6nFW1m4TxhGl28B1880wvU8aa2150oe
         VqVXSvYliamqWRqKSpzhnjgG2uVcqBmJltIifj+48weUlnNx+AAj/rJX6q/BNeMFqgwM
         Nk2ilRx8XxoewyrbBesIhnO2VJRRbvu2bYhSosN+ktzgMVfEVak3YKdynRVqlSGm/oJ5
         Py2/mmX/R0NtMhQvCHJLZENlyCO5ojQwOGFiJc8rAnzxY2LnnWma2Lf/kI/zINXR6jpO
         jagHkQzOoemjsjI4Sxo43VKJVaqDRAKdPw2SksrfBGeKbbOdDb8JgOyQaIo1IjjlxZYE
         hmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752850427; x=1753455227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cRq4mZGW6hHwIgirPnFC0Ellx4rYs15LC6saX2uSxGU=;
        b=taFARFem8lSCeX3885gsahGRRadlscr8Qg8grVgW4YNPLhCHQgXfjuCed2ljuM25/A
         0RGc3/DwM6Qz2ans/vqt1fSXgzp8wDzS69AB0Q/FZxQ5EBHMP1nYZx2mZHhvmIFBHuwP
         aFqlC93wcicseDATRvXwkTpf6tButuS5oi5r44zxEoR2vHGQmMUc60TO5fZ6DsdxAd5m
         kavJLIX07j1v1EwX3AoTDrbXCQVf3SrlPTBW8bAqNHsmD9Q2/HOJXlV3gzX+E/o3RkB3
         2zybgA21w8/0aV6glUxAN5HHDZ7/4shE/KH9ywrcpf3LO3Fk0KtHF/WfHRUtAIJBZklb
         X74A==
X-Forwarded-Encrypted: i=1; AJvYcCXwrh6Ywac6bgmruprp292KV1Cu0bl+6waBx25yczGC85vsMlAltB6KriIX/o2fl6ur95M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxDxlWME0I9euLt3VsDsvLAeWM+fAGzWNXaR7nPgG9sIYUK2DJ
	e8M8oMiSbMqX/qnzpsBlIHJsMzKjb1CIv3iPoNVKmpIEJoxsxX6rLwyr9MWLHyz+Zw==
X-Gm-Gg: ASbGncujRnsX9YwMIoyosxkzULyDfSEPff3bKKtHzpGdK/Pb3aFhYPbwNukKSUGyVjt
	84/UUrsrGLx6snqjQLZX5pWCosW7OD9wXq8nwzFTMJY8ZxgvVqaWlU/4+0R0UfTnUdS0x95bh4/
	UNpRTppd0kyZzgONNC6lHY+b7XHhRAoyJBjb96ZFvXre3ERa3ShHw162/EJymBn2TXfwtvuR9Fg
	WPZCKYJsiFKJWaPqMCi/Ne/6ck3ebi+nmIYNIteodOLkAgX3u6mOt1Vu8fLr2UPQOFK/fvdurBu
	nh/tvPkuMUlnANLPvJkiBzUMeCmiqyZevRiBqoPq/haroswpw4ANXC2TNn7OKukK14ZvFT80Swy
	XDCB8mcbPY7HhWCODHFc2xaIIyzkD+eQBqYDaVIsYruy/GygDhGbMMP4gU4LgpXkqJY79PA==
X-Google-Smtp-Source: AGHT+IHRoLNQ/BOi8gPhfanYsriNie013yEjEncyuc0ze1Z2dpZlN67n7NZfnIUPQdvgGELPGcgEHQ==
X-Received: by 2002:adf:e193:0:b0:3a3:7987:945f with SMTP id ffacd0b85a97d-3b60e5242a1mr10025699f8f.57.1752850427262;
        Fri, 18 Jul 2025 07:53:47 -0700 (PDT)
Received: from google.com (120.142.205.35.bc.googleusercontent.com. [35.205.142.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563f7c88a0sm11817035e9.2.2025.07.18.07.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 07:53:46 -0700 (PDT)
Date: Fri, 18 Jul 2025 14:53:42 +0000
From: Keir Fraser <keirf@google.com>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
Message-ID: <aHpf9vuRK691J7HD@google.com>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>

On Thu, Jul 17, 2025 at 01:44:48PM +0800, Yao Yuan wrote:
> On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> > In preparation to remove synchronize_srcu() from MMIO registration,
> > remove the distributor's dependency on this implicit barrier by
> > direct acquire-release synchronization on the flag write and its
> > lock-free check.
> >
> > Signed-off-by: Keir Fraser <keirf@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
> >  1 file changed, 2 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > index 502b65049703..bc83672e461b 100644
> > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> >  	gpa_t dist_base;
> >  	int ret = 0;
> >
> > -	if (likely(dist->ready))
> > +	if (likely(smp_load_acquire(&dist->ready)))
> >  		return 0;
> >
> >  	mutex_lock(&kvm->slots_lock);
> > @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> >  		goto out_slots;
> >  	}
> >
> > -	/*
> > -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> > -	 * registration before returning through synchronize_srcu(), which also
> > -	 * implies a full memory barrier. As such, marking the distributor as
> > -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> > -	 * a completely configured distributor.
> > -	 */
> > -	dist->ready = true;
> > +	smp_store_release(&dist->ready, true);
> 
> No need the store-release and load-acquire for replacing
> synchronize_srcu_expedited() w/ call_srcu() IIUC:
> 
> Tree SRCU on SMP:
> call_srcu()
>  __call_srcu()
>   srcu_gp_start_if_needed()
>     __srcu_read_unlock_nmisafe()
> 	 #ifdef	CONFIG_NEED_SRCU_NMI_SAFE
> 	   	  smp_mb__before_atomic() // __smp_mb() on ARM64, do nothing on x86.
> 	 #else
>           __srcu_read_unlock()
> 		   smp_mb()
> 	 #endif

I don't think it's nice to depend on an implementation detail of
kvm_io_bus_register_dev() and, transitively, on implementation details
of call_srcu().

kvm_vgic_map_resources() isn't called that often and can afford its
own synchronization.

 -- Keir

> TINY SRCY on UP:
> Should have no memory ordering issue on UP.
> 
> >  	goto out_slots;
> >  out:
> >  	mutex_unlock(&kvm->arch.config_lock);
> > --
> > 2.50.0.727.gbf7dc18ff4-goog
> >

