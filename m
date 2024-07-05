Return-Path: <kvm+bounces-20977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1727B927F9C
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F397B22173
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56D4FBFC;
	Fri,  5 Jul 2024 01:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUFN9Kel"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEC85C83
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142229; cv=none; b=spwEfQF13y0n8nwti8P7GXoKve/SDVNL+BgSKfZARCMwROqjRxETbWwr0VRVpHCa5PkrKLqzYe/pKZIBg96chjEFUqwa/u5e6T7UhX0KoW9oFMY3nWCQcMRddlwakNWVjeObv5yDSjCxV3XcLQ4G26NUZWDTG7ibe+AgX5jO08U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142229; c=relaxed/simple;
	bh=M2XsaSLjo3myZLlMfWnTZ5EEmE2wc5M1Xb04j4FpoYY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EaCsvufoqCJobwzdxPQwIw+b5NTEVRcsY3IBKFcKzSF4wLK9EQ/TppIV6oYjizsjWMzfJ0EEmKMnWLAaVxaRNYkouw0Ne8yRLUA9zaYhP5RDnIwEhCh1to7pQoofFL5o+xOvA0Vwn0O1g4zlBZKEWbJnK+Opo5xdlVsUUOK2whg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RUFN9Kel; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5/IsDMzPNzm19LN/6qZ2CC+/4CQnYpAck10tehVZwl4=;
	b=RUFN9KelmpBEq0m+SfzcXT1R2uI/js2dDj2mGrS7WvfzdN/I78AGyOHZsbNbgbMvEDxbNS
	l4KcAtHVvk4GfBSZnjYaUZaM/bqOKcz31uHd3WdIuD3l0XwAXNDn1uQdsVBnjr0FlKjfrC
	ReFC2zbAvmG/ZCxFf6f4zW3i0xKDFmY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-fY-YaOgCNRmwQer5uuW5zQ-1; Thu, 04 Jul 2024 21:17:05 -0400
X-MC-Unique: fY-YaOgCNRmwQer5uuW5zQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6b5de421bc6so15675596d6.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142224; x=1720747024;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5/IsDMzPNzm19LN/6qZ2CC+/4CQnYpAck10tehVZwl4=;
        b=pSJT0Zy2lG3HWhv3aSDrkKFTYeLZZq1fthu+8Kr4AS0Fndn9aK1et3FVzWK5gzQdEs
         mbb2Hu8COFELf+jMA0zGpYLJwHHiWWsQpsZuzUSJ1e2obHucQ4Wu1O2mQhojHejXsX7W
         3xF/EKzcmlroSalLRx4/AJg5RkXPi63LFpF+36PmDx4y1erlqMZ9Jd9AX8mXnMPYBVAn
         xvtntcQ2Whn/H0Oao03Af12k+K2/+/0wi1M64sZOYbyceGfVqrJUdQFVjZWofp2UQ06G
         tzp9dHrzdg9SJzhX47CP61bdGYLOcrIYyTCGF70/prlirjQfEK7aeX6xz0qqrQK/2buF
         DzEw==
X-Gm-Message-State: AOJu0Yzd6CmZhkQczfq6UzRaWs9XYY37OAlctP6TvdBrR2nyXtJmPLGp
	Qu3YfyBdYKBEzDucZqB7ITtJuYkxhcuBNfcWdZec9yvGGKrFyFdRi38ZkI1nF/PwQIrl/S9n4ST
	I4EjEDXqpe2L378T7+gXPDOS1pHZM4JzXv7NJ9ctbzwcCQZA9Tg==
X-Received: by 2002:a05:6214:acb:b0:6b5:50:4427 with SMTP id 6a1803df08f44-6b5ecfb3483mr31135566d6.12.1720142224457;
        Thu, 04 Jul 2024 18:17:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEB2YSqvGlY2IP37Xtt7hBfXZirjoVh+1Y9q9jt6yXNGfjj7TDp6gQ5K6cxHQfqDUvM/zaVsQ==
X-Received: by 2002:a05:6214:acb:b0:6b5:50:4427 with SMTP id 6a1803df08f44-6b5ecfb3483mr31135446d6.12.1720142224115;
        Thu, 04 Jul 2024 18:17:04 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b5ac3101fcsm62779176d6.125.2024.07.04.18.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:17:03 -0700 (PDT)
Message-ID: <dc19d74e25b9e7e42c693a13b6f98565fb799734.camel@redhat.com>
Subject: Re: [PATCH v2 11/49] KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS
 after vCPU creation
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:17:02 -0400
In-Reply-To: <20240517173926.965351-12-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-12-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Reject KVM_CAP_X86_DISABLE_EXITS if vCPUs have been created, as disabling
> PAUSE/MWAIT/HLT exits after vCPUs have been created is broken and useless,
> e.g. except for PAUSE on SVM, the relevant intercepts aren't updated after
> vCPU creation.  vCPUs may also end up with an inconsistent configuration
> if exits are disabled between creation of multiple vCPUs.

Hi,

I am not sure that PAUSE intercepts are updated either, I wasn't able to find a code
that does this.

I agree with this change, but note that there was some talk on the mailing
list to allow to selectively disable VM exits (e.g PAUSE, MWAIT, ...) only on some vCPUs, 
based on the claim that some vCPUs might run RT tasks, while some might be housekeeping.
I haven't followed those discussions closely.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
> Link: https://lore.kernel.org/all/9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com
> Link: https://lore.kernel.org/all/20230121020738.2973-2-kechenl@nvidia.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 1 +
>  arch/x86/kvm/x86.c             | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 6ab8b5b7c64e..884846282d06 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7645,6 +7645,7 @@ branch to guests' 0x200 interrupt vector.
>  :Architectures: x86
>  :Parameters: args[0] defines which exits are disabled
>  :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
> +          or if any vCPUs have already been created
>  
>  Valid bits in args[0] are::
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bb34891d2f0a..4cb0c150a2f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6568,6 +6568,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
>  			break;
>  
> +		mutex_lock(&kvm->lock);
> +		if (kvm->created_vcpus)
> +			goto disable_exits_unlock;
> +
>  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
>  			kvm->arch.pause_in_guest = true;
>  
> @@ -6589,6 +6593,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  
>  		r = 0;
> +disable_exits_unlock:
> +		mutex_unlock(&kvm->lock);
>  		break;
>  	case KVM_CAP_MSR_PLATFORM_INFO:
>  		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];



