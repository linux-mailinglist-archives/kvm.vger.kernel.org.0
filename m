Return-Path: <kvm+bounces-26149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D75B1972262
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 21:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19EF3284267
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 19:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221AB189BA3;
	Mon,  9 Sep 2024 19:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PuFL4cjz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ACE17588
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 19:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725909115; cv=none; b=tTMpJhn51vJMK2QEnls35dgFalgSSPP9vb2nQ9YN1I5hgzEWI7kK8Zv6jZLNIJAC0qHYkBr4G4wOqLbU6r+Kv795CiYI1oi+vfs5SleBxjD+IRkyE0ae+WJtHJlCrYzVSLxEgzgmWNwC4xQQGCqWMgRpCqE1vhjHak0DtRHvq1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725909115; c=relaxed/simple;
	bh=zndEXXrBf3suPdcgFqdqvO3P8HQrrM5vFvZhoVMzWxg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cJH4U5ZPOFyC03TXzWScQf60E4R2CwAqWOjB48B/46e+XW95Qfw4+Q5syFEL37WYIoX7mZrG3U1gqJIfdL5Cglms6+r+UdqcWmVtX1gwCdc9EOD41NJDdsREpx4F7KtgYCV657xuvK5hjJlql8tisJXnQUCt7ZxJKxjKtP40HJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PuFL4cjz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725909112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5sPSJH7sx8TT8vephZ961tLUcAIsPRNREdt62HfflFk=;
	b=PuFL4cjz4b03t7SrncGQFPHr0ZEOCsYJCYMcjJdzmYd/K59fEVDGWrijNe1oAf6KOZmA7r
	YYfChPMEDpQMJFwErncnUqHqtNEXsRi903eemCUgmqdjZoXtybPXkgrmWQnyWRcxKaduZc
	M98JWgpB+F4cmb2uKbLb53YQqDw75pc=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-Fzr-uYNTPQidRnxeWs9jpQ-1; Mon, 09 Sep 2024 15:11:51 -0400
X-MC-Unique: Fzr-uYNTPQidRnxeWs9jpQ-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-5e1cd853298so1492201eaf.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 12:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725909110; x=1726513910;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5sPSJH7sx8TT8vephZ961tLUcAIsPRNREdt62HfflFk=;
        b=uEbX3LMii5T5UkaekLflR7m79fo3VLhwzo25iHDmgn2ctq6W3K8dooRjaVm7otfFcA
         +8/gmvQunq+CuiuqMb0L2gIM8v3ma4rgulf5cLb6Dlsp8t49jAqNIHg0VNS2W70F5FrP
         CHWum4Ku1SgFWDpPvlqweR5ZHzgrVB7qwpjFOVSujB5P7C9TOqMaBWgGXufU+qp+bYlc
         VeWLKigdVyMxHejWwRJOLC7jBLauqD10cZRAhitl8/lDZ1T3LFbtxohkznQoMJCtvw+U
         DbWKI/0nv9dx13rjBKCHFNlZrt1lHZrWmBc1sm32j4iRgL8RknLf0uwuDQf+USkMu+Ld
         nywA==
X-Gm-Message-State: AOJu0YyUrwahPH7htQ4mWUYcQZVpIqx5ilQnGyYgIqEQVneCiWaOkuu1
	8idEo/06owFtE8zrItiznvJ9Vp7/lTW1maQizVEixLyQR24cyvI10f1Oxmm7lvvC+40swCUSbtY
	OqDG6cSher4afOfQs9l7w6e54DAAhiSAWOoctzFyFotxP9Qt90w==
X-Received: by 2002:a05:6358:7691:b0:1b8:42cd:19b3 with SMTP id e5c5f4694b2df-1b84d2ff61amr220903455d.28.1725909110171;
        Mon, 09 Sep 2024 12:11:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDyIe1YMoL6snR+uNukfxdBjZXJuocOTsnMVfwPCJowbkJePwRp71cfWJBS7eNe3EepSdnUQ==
X-Received: by 2002:a05:6358:7691:b0:1b8:42cd:19b3 with SMTP id e5c5f4694b2df-1b84d2ff61amr220899855d.28.1725909109624;
        Mon, 09 Sep 2024 12:11:49 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a7991f7fsm242462385a.62.2024.09.09.12.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 12:11:49 -0700 (PDT)
Message-ID: <61e7e64c615aba6297006dbf32e48986d33c12ab.camel@redhat.com>
Subject: Re: [PATCH v3 2/2] VMX: reset the segment cache after segment
 initialization in vmx_vcpu_reset
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
 x86@kernel.org
Date: Mon, 09 Sep 2024 15:11:48 -0400
In-Reply-To: <ZrY1adEnEW2N-ijd@google.com>
References: <20240725175232.337266-1-mlevitsk@redhat.com>
	 <20240725175232.337266-3-mlevitsk@redhat.com> <ZrF55uIvX2rcHtSW@chao-email>
	 <ZrY1adEnEW2N-ijd@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-08-09 at 08:27 -0700, Sean Christopherson wrote:
> On Tue, Aug 06, 2024, Chao Gao wrote:
> > On Thu, Jul 25, 2024 at 01:52:32PM -0400, Maxim Levitsky wrote:
> > > Fix this by moving the vmx_segment_cache_clear() call to be after the
> > > segments are initialized.
> > > 
> > > Note that this still doesn't fix the issue of kvm_arch_vcpu_in_kernel
> > > getting stale data during the segment setup, and that issue will
> > > be addressed later.
> > > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > 
> > Do you need a Fixes tag and/or Cc: stable?
> 
> Heh, it's an old one
> 
>   Fixes: 2fb92db1ec08 ("KVM: VMX: Cache vmcs segment fields")
> 
> > > ---
> > > arch/x86/kvm/vmx/vmx.c | 6 +++---
> > > 1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index fa9f307d9b18..d43bb755e15c 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -4870,9 +4870,6 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > 	vmx->hv_deadline_tsc = -1;
> > > 	kvm_set_cr8(vcpu, 0);
> > > 
> > > -	vmx_segment_cache_clear(vmx);
> > > -	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
> > > -
> > > 	seg_setup(VCPU_SREG_CS);
> > > 	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
> > > 	vmcs_writel(GUEST_CS_BASE, 0xffff0000ul);
> > > @@ -4899,6 +4896,9 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > 	vmcs_writel(GUEST_IDTR_BASE, 0);
> > > 	vmcs_write32(GUEST_IDTR_LIMIT, 0xffff);
> > > 
> > > +	vmx_segment_cache_clear(vmx);
> > > +	kvm_register_mark_available(vcpu, VCPU_EXREG_SEGMENTS);
> > 
> > vmx_segment_cache_clear() is called in a few other sites. I think at least the
> > call in __vmx_set_segment() should be fixed, because QEMU may read SS.AR right
> > after a write to it. if the write was preempted after the cache was cleared but
> > before the new value being written into VMCS, QEMU would find that SS.AR held a
> > stale value.
> 
> Ya, I thought the plan was to go for a more complete fix[*]?  This change isn't
> wrong, but it's obviously incomplete, and will be unnecessary if the preemption
> issue is resolved.

Hi,

I was thinking to keep it simple, since the issue is mostly theoretical after this fix,
but I'll give this another try.

Best regards,
	Maxim Levitsky

> 
> [*] https://lore.kernel.org/all/f183d215c903d4d1e85bf89e9d8b57dd6ce5c175.camel@redhat.com
> 



