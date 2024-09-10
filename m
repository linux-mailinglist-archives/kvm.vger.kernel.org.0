Return-Path: <kvm+bounces-26179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B31D397267D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 03:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74B36285DE5
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28452745F2;
	Tue, 10 Sep 2024 01:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fjJXirRf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5459B6F30C
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 01:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725930469; cv=none; b=oQjn2vUk8pVKVacozXlauedXTLdnom84W1bXekRqKHtcww9Tt6hOX0q8W+8dVPO2Phz1l5C6kbn6XD1TFjHL6//1bjHoiBg05Vc2Wpm4YN6s0vAV03KcVTqUVe5AhaLooXzfascjb3vNXYOr1QBDEfOJmjpB+0b+oK0N1XE9+5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725930469; c=relaxed/simple;
	bh=ATHsS1AmT3JG3F7YpaxSATtnFZdtl+P+auqorHApaBw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QZI4yl7MIN7NPh22HyGX0EP5gtHN1Dt18oYN5jUvAvEw+4YocnarhtJ1eWsgpP6eajFE2k5KuBZ7Ii6Xrp44Ei+IRwqMI36p89jFIe0sB/CYddhbTF57zL8pVhJWiULxmofu1FOywdaLkmLm5AsD7DYS8IJVR/WTTBvpQK/ftOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fjJXirRf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725930465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e1Tybp6E4T4YrtJAbYUVLevBkFVS1yDP1bl67K5nnks=;
	b=fjJXirRfiKbd1IDYcxbVwJzmtaEaHkd4MvEQH4sxIZDqSnZJcRytnzQaZww5G5E3UbkIQd
	pCIplYSwWY9Ef29+9OwTLWI6mQSeH63lu3vGqtKSAPr/uLGcGsS4R2ndQSCjm9JFzxIA/W
	NwTjeKwclJndqLQDoBbads9LAlzvUyg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-_p3vi49-PbiT10G8Kx4Bow-1; Mon, 09 Sep 2024 21:07:42 -0400
X-MC-Unique: _p3vi49-PbiT10G8Kx4Bow-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6bf6bcee8ccso82250576d6.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 18:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725930462; x=1726535262;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e1Tybp6E4T4YrtJAbYUVLevBkFVS1yDP1bl67K5nnks=;
        b=eTv1UlXAibxKrhFckn3517TFgQumMiapv8KO4kZAJ4w8FwwqKBWE3didbnjPEyrqYw
         AiNAeK7onDdJEzgJKbtMxesCmULe/O1x+1XE5DYBqWbl8jIgMhrqntl6X1Rj0+DaH/FA
         aNuDKIX7NjM2obx/x4OUzob050TfmUnGq6AlA5so6mQqRoZcif62pPowgXyIX2cocrf/
         Vvrf6OPq+EKLMktrAgH5TOHNJ37iL8guQ3qg/1EZKuYLjtUKguQ7qjN8ktnmbxoHrQKk
         S5wJrwaE4kRTpGZa1Q1Wm5NW0IlpD7Py56XYs0qGoGdyGYV4q4h9OYOlYUUNtGvez6Kj
         /MkA==
X-Gm-Message-State: AOJu0Yye3u98f6wME0PH+BJN8Bmlw3PkaDLUyBj30V5OANiiVkp8+PKx
	MCRR2iAf9NAEzwccvpddsXHrU2Un19nIUNnaf3G8UjUx/ffLy64U0S+l/5e+RzNuiN2SZbQXMpX
	eYmOx6PA7qad6QhivI2CCtrLX5yASunePQhp1QzbZbtzv07X60g==
X-Received: by 2002:a05:6214:3f90:b0:6c5:1616:b5c5 with SMTP id 6a1803df08f44-6c532ad6e5amr117463546d6.15.1725930462107;
        Mon, 09 Sep 2024 18:07:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1iFOB9OlXSHTVdnaaPPLfkmO7lh6TSHwWW9yPfAV+5I6XTNWVIUUSS2xEO1Zny6HH9/PWvQ==
X-Received: by 2002:a05:6214:3f90:b0:6c5:1616:b5c5 with SMTP id 6a1803df08f44-6c532ad6e5amr117463226d6.15.1725930461611;
        Mon, 09 Sep 2024 18:07:41 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c53474d890sm25672526d6.94.2024.09.09.18.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 18:07:41 -0700 (PDT)
Message-ID: <65fe418f079a1f9f59caa170ec0ae5d828486714.camel@redhat.com>
Subject: Re: [PATCH v3 2/2] VMX: reset the segment cache after segment
 initialization in vmx_vcpu_reset
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
 x86@kernel.org
Date: Mon, 09 Sep 2024 21:07:40 -0400
In-Reply-To: <61e7e64c615aba6297006dbf32e48986d33c12ab.camel@redhat.com>
References: <20240725175232.337266-1-mlevitsk@redhat.com>
	 <20240725175232.337266-3-mlevitsk@redhat.com> <ZrF55uIvX2rcHtSW@chao-email>
	 <ZrY1adEnEW2N-ijd@google.com>
	 <61e7e64c615aba6297006dbf32e48986d33c12ab.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-09-09 at 15:11 -0400, Maxim Levitsky wrote:
> On Fri, 2024-08-09 at 08:27 -0700, Sean Christopherson wrote:
> > On Tue, Aug 06, 2024, Chao Gao wrote:
> > > On Thu, Jul 25, 2024 at 01:52:32PM -0400, Maxim Levitsky wrote:
> > > > Fix this by moving the vmx_segment_cache_clear() call to be after the
> > > > segments are initialized.
> > > > 
> > > > Note that this still doesn't fix the issue of kvm_arch_vcpu_in_kernel
> > > > getting stale data during the segment setup, and that issue will
> > > > be addressed later.
> > > > 
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > 
> > > Do you need a Fixes tag and/or Cc: stable?
> > 
> > Heh, it's an old one
> > 
> >   Fixes: 2fb92db1ec08 ("KVM: VMX: Cache vmcs segment fields")
> > 
> > > > ---
> > > > arch/x86/kvm/vmx/vmx.c | 6 +++---
> > > > 1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > index fa9f307d9b18..d43bb755e15c 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > @@ -4870,9 +4870,6 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > > 	vmx->hv_deadline_tsc = -1;
> > > > 	kvm_set_cr8(vcpu, 0);
> > > > 
> > > > -	vmx_segment_cache_clear(vmx);
> > > > -	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
> > > > -
> > > > 	seg_setup(VCPU_SREG_CS);
> > > > 	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
> > > > 	vmcs_writel(GUEST_CS_BASE, 0xffff0000ul);
> > > > @@ -4899,6 +4896,9 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > > 	vmcs_writel(GUEST_IDTR_BASE, 0);
> > > > 	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
> > > > 
> > > > +	vmx_segment_cache_clear(vmx);
> > > > +	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
> > > 
> > > vmx_segment_cache_clear() is called in a few other sites. I think at least the
> > > call in __vmx_set_segment() should be fixed, because QEMU may read SS.AR right
> > > after a write to it. if the write was preempted after the cache was cleared but
> > > before the new value being written into VMCS, QEMU would find that SS.AR held a
> > > stale value.
> > 
> > Ya, I thought the plan was to go for a more complete fix[*]?  This change isn't
> > wrong, but it's obviously incomplete, and will be unnecessary if the preemption
> > issue is resolved.
> 
> Hi,
> 
> I was thinking to keep it simple, since the issue is mostly theoretical after this fix,
> but I'll give this another try.
> 
> Best regards,
> 	Maxim Levitsky
> 
> > [*] https://lore.kernel.org/all/f183d215c903d4d1e85bf89e9d8b57dd6ce5c175.camel@redhat.com
> > 

Hi,

This is what I am thinking, after going over this issue again:

Pre-populating the cache and/or adding 'exited_in_kernel' will waste vmreads on *each* vmexit, 
I worry that this is just not worth the mostly theoretical issue that we have.


Since the segment and the register cache only optimize the case of reading a same field twice or more,
I suspect that reading these fields always is worse performance wise than removing the segment cache
altogether and reading these fields again and again.


Finally all 3 places that read the segment cache, only access one piece of data (SS.AR or RIP), 
thus it doesn't really matter if they see an old or a new value. 

I mean in theory if userspace changes the SS's AR bytes out of the
blue, and then we get a preemption event, in theory as you say the old value is correct but it really
doesn't matter.

So IMHO, just ensuring that we invalidate the segment cache right after we do any changes is the simplest
solution.

I can in addition to that add a warning to kvm_register_is_available and vmx_segment_cache_test_set, that
will test that only SS.AR and RIP are read from the interrupt context, so that if in the future someone
attempts to read more fields, this issue can be re-evaluated.

Best regards,
	Maxim Levitsky


