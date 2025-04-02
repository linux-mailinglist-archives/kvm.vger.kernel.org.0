Return-Path: <kvm+bounces-42443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E528A786F7
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 05:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 958CE3AD5BF
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 03:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468782309A1;
	Wed,  2 Apr 2025 03:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h13qjSew"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE64A230981
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 03:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743566272; cv=none; b=MI8SZ/wwBvCnvJjq8cjlRZeOgNGGdlaLQoYixoBmsMNrq6yVboCp+HRAjXGjXv50qWDVnRs8gP8oXsZqBmjvcm4xOQPe7Lxy3nXyhS2fHRT43QU/GhS7dFwRWD4VJfmle21jMJBZ4PPgHAYV/pMvnzHaJY3NwXFco1+L2IALQ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743566272; c=relaxed/simple;
	bh=DH0xkte9wSZlLFbj86lkczi4h1F+DZB1Qssy9mm2Sps=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KgiCsEDF1DJbWwDm3U4kTotiHQDID3SpvcjLAPFbVfR4QI5btHzx6xlwmFGN3dxe1OerjGBrTEZpGzz7diMZKgDyik+stjjPCuMqvz4JwmdyanQXDUdke/3WdgMg8mB56QVW05bHLwnvsV7cgjpduteEWnSs5BAW7LwovKAikpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h13qjSew; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743566269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3EHpwcZb7JUmljhMaKtSiGAnELfOUqWRS3brLGJeZJs=;
	b=h13qjSewOus44eq8Q5UPNFcCeCrVWSvmAxJoA/dbkWZvRLZyJtR6FvxKmEY7a1u5ww0E4f
	3aQMT7S7hmWp7jMDdYVQZNfw+vriZCi6z3Whwi6htKmmlnC0nXnxE//63Ia8ihEviGP3RG
	2BEHnUlvxcfxXqpDzThWXNI3GjEbxUg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-F67rrf-sNTGolgHVDxNQBA-1; Tue, 01 Apr 2025 23:57:48 -0400
X-MC-Unique: F67rrf-sNTGolgHVDxNQBA-1
X-Mimecast-MFC-AGG-ID: F67rrf-sNTGolgHVDxNQBA_1743566268
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6eb1e240eddso108021556d6.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 20:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743566268; x=1744171068;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3EHpwcZb7JUmljhMaKtSiGAnELfOUqWRS3brLGJeZJs=;
        b=aXrJmHYtsG8+jfwBdjzs+d5iIJJUC2vCWbMvCyU+R+2pRILyAqnz3Bok/ZeMX5NHsj
         80DuQyxHgN520IWbGexsKGIm0q2SZH+ULCmgs4tp44UQswhORFGxYBlror2aOvf/M9sH
         zAnOL1rzkUC11kvYIe7ApH7v0G6LpWtmv6af0fShMmDvUZ1HS+VCgd1DJH2rvtxy4134
         vL0DAQQmlAzBn1eC5OEJLQvJcW97Nd5/Qvohlrf5XhifI5nr9nQyaS2BwlPru/HsNKtz
         5DTgo6mWTun0gZlXlM8i5hVe6qNE2COI878sByj/blv6Jty5ZeIN2ZvunmhqYO6MQgnB
         htOQ==
X-Gm-Message-State: AOJu0YzIyL9dWyyUKjakNexeCcmwZVcdh9dIOt+eUmHfNMCyxqP19kTT
	TTd2dSWXTJln5TUwdNz9tO9IyKx0XjzyrTvdAkTN++LhfNbgmeYcWVAAgULxJbncLuEWlSwdbkY
	NzaAb9L1CQY9iReRujq8GpzlrlYnwWAZmh+2O0UxMJV7yzsnyhw==
X-Gm-Gg: ASbGncuk+L3P6TFYIUUmWcykFjTulGp5ZkA6R2CnmAtGXMslFV9m6NL+/yTLCi6FZq2
	utm88+/Y3c4Uk/QIuZRUuJWgi/T8JjmkwZ5rK86aMGdb3r1iBVqOoVpCsxBiVurQ+2xjxtlHaKG
	lZqi8fgKlNWWgAyfgoUhf6R5GYk8j7761Y39OId2wDRDYC+Ujcmyk4s4Kg/CAkTPDAp7+ObEtAw
	69pxpFRobn8T+AD0SL00gFDD9ta/4xzSVPfT/iiJLUIxK1IPCuwFwOx3EPFbDd8yRbC9bpE4tQo
	577Bu5zix3QGWUo=
X-Received: by 2002:a05:6214:2aa5:b0:6e8:9e8f:cfb with SMTP id 6a1803df08f44-6eed6206676mr224142826d6.24.1743566267941;
        Tue, 01 Apr 2025 20:57:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTy8f/TqXcAZv/pjj+xQyEtLlNlg8iTt+rX63O+3pxxtogDwH24TIpcDDtJ6plNopV6w6gMw==
X-Received: by 2002:a05:6214:2aa5:b0:6e8:9e8f:cfb with SMTP id 6a1803df08f44-6eed6206676mr224142706d6.24.1743566267609;
        Tue, 01 Apr 2025 20:57:47 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eec9643e23sm70638476d6.26.2025.04.01.20.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 20:57:47 -0700 (PDT)
Message-ID: <1b0fbad5b2be164da13034fe486c207d8a19f5e7.camel@redhat.com>
Subject: Re: [PATCH v3 0/6] KVM: SVM: Fix DEBUGCTL bugs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Ravi Bangoria
	 <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	rangemachine@gmail.com, whanos@sergal.fun
Date: Tue, 01 Apr 2025 23:57:46 -0400
In-Reply-To: <20250227222411.3490595-1-seanjc@google.com>
References: <20250227222411.3490595-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2025-02-27 at 14:24 -0800, Sean Christopherson wrote:
> Fix a long-lurking bug in SVM where KVM runs the guest with the host's
> DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
> context switch DEBUGCTL if and only if LBR virtualization is enabled (not
> just supported, but fully enabled).
> 
> The bug has gone unnoticed because until recently, the only bits that
> KVM would leave set were things like BTF, which are guest visible but
> won't cause functional problems unless guest software is being especially
> particular about #DBs.
> 
> The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
> as the resulting #DBs due to split-lock accesses in guest userspace (lol
> Steam) get reflected into the guest by KVM.
> 
> Note, I don't love suppressing DEBUGCTL.BTF, but practically speaking that's
> likely the behavior that SVM guests have gotten the vast, vast majority of
> the time, and given that it's the behavior on Intel, it's (hopefully) a safe
> option for a fix, e.g. versus trying to add proper BTF virtualization on the
> fly.
> 
> v3:
>  - Suppress BTF, as KVM doesn't actually support it. [Ravi]
>  - Actually load the guest's DEBUGCTL (though amusingly, with BTF squashed,
>    it's guaranteed to be '0' in this scenario). [Ravi]
> 
> v2:
>  - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
>  - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
>    unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
>  - Collect a review. [Xiaoyao]
>  - Make bits 5:3 fully reserved, in a separate not-for-stable patch.
> 
> v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com
> 


Hi,

Amusingly there is another DEBUGCTL issue, which I just got to the bottom of.
(if I am not mistaken of course).

We currently don't let the guest set DEBUGCTL.FREEZE_WHILE_SMM and neither
set it ourselves in GUEST_IA32_DEBUGCTL vmcs field, even when supported by the host
(If I read the code correctly, I didn't verify this in runtime)

This means that the host #SMIs will interfere with the guest PMU.
In particular this causes the 'pmu' kvm-unit-test to fail, which is something that our CI caught.

I think that kvm should just set this bit, or even better, use the host value of this bit,
and hide it from the guest, because the guest shouldn't know about host's smm, 
and we AFAIK don't really support freezing perfmon when the guest enters its own emulated SMM.

What do you think? I'll post patches if you think that this is a good idea.
(A temp hack to set this bit always in GUEST_IA32_DEBUGCTL fixed the problem for me)

I also need to check if AMD also has this feature, or if this is Intel specific.

Best regards,
	Maxim Levitsky

> 
> Sean Christopherson (6):
>   KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value
>   KVM: SVM: Suppress DEBUGCTL.BTF on AMD
>   KVM: x86: Snapshot the host's DEBUGCTL in common x86
>   KVM: SVM: Manually context switch DEBUGCTL if LBR virtualization is
>     disabled
>   KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
>   KVM: SVM: Treat DEBUGCTL[5:2] as reserved
> 
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm/svm.c          | 24 ++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h          |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  8 ++------
>  arch/x86/kvm/vmx/vmx.h          |  2 --
>  arch/x86/kvm/x86.c              |  2 ++
>  6 files changed, 30 insertions(+), 9 deletions(-)
> 
> 
> base-commit: fed48e2967f402f561d80075a20c5c9e16866e53



