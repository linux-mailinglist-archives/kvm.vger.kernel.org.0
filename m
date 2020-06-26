Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1906A20B7D1
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 20:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgFZSHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 14:07:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41937 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbgFZSHj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 14:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593194857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mh8Kb7lcXyeDUsTLpHNhFiDt09C/jNnPC1a+PBHnv+Y=;
        b=ZGFksRhYusONU+ujPVhtbAVXqU4+kjgpmMlxFMZ60AL9hvuOCRJFp3/rmVrM6OR9SbF2fs
        1wRZzUnX+n1aV4M00oU0Z6+PUBDc8tszEUiNO5XmtoSPWGbCLHG1KZFG3d8l/RhlRlGMV+
        +Ii3t/k0/dw/yF+821I1CTEiKqQR/Zs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-quFF2uhINLuf1oYPUwPZUQ-1; Fri, 26 Jun 2020 14:07:35 -0400
X-MC-Unique: quFF2uhINLuf1oYPUwPZUQ-1
Received: by mail-qt1-f200.google.com with SMTP id c26so7043300qtq.6
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 11:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mh8Kb7lcXyeDUsTLpHNhFiDt09C/jNnPC1a+PBHnv+Y=;
        b=eZjJzemKJ2hOmtlS+iLBFZmVtH5DTOo4cdNnqBwKkWdRXNWiawMv1EDn4vJH767/gV
         ubC7umgqVLokFdbkLlXUYfpMskjv2Jceo75dTwgKKWOIRPabEwPn9mFlFOrooOLQpvUA
         OEUGVpSWfCsiFUHyxrJAlqBKrcJ/bX4a/SqTKYlV37vbwupYIIqi9k617+BUT+8OPyo2
         ueDdjnvQHiMBYrcK2l48HXUGd1c2WvDFXAp7JxZ2EFAJxKAqj96nz/vEcfojS39FEHCW
         APCnUQYpra9t5E4Ex1xCd4k7NrdtY4pPZOJ7tjWMR7SQFYmjWapRHKRM5W/FHRV2S4uy
         U1jQ==
X-Gm-Message-State: AOAM531hwOqsvx1/3Vj80uMmJTMEwBDO6fNMBJPAvGn/Xhc6rbOog9+c
        +oK1Cw/16n71Gd99jd/GE+ETR1e1jgCjhNlMNBzHkBZ2im03Re/LhYVIqlxtgqTMtOsZccdL5oA
        /wAr0VrArAeke
X-Received: by 2002:ac8:4143:: with SMTP id e3mr3974347qtm.28.1593194855161;
        Fri, 26 Jun 2020 11:07:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0KwT5G7Jhs+C2QIApsJEqS5S1foXp/1ArAPbj3XXBF8uECgb5oGbIGI1cp1HnXU4S80aHHw==
X-Received: by 2002:ac8:4143:: with SMTP id e3mr3974318qtm.28.1593194854928;
        Fri, 26 Jun 2020 11:07:34 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id v2sm8827585qtq.8.2020.06.26.11.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 11:07:34 -0700 (PDT)
Date:   Fri, 26 Jun 2020 14:07:32 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200626180732.GB175520@xz-x1>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200625162540.GC3437@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 25, 2020 at 09:25:40AM -0700, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5eb618dbf211..64322446e590 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1013,9 +1013,9 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>                 *ebx = entry->ebx;
>                 *ecx = entry->ecx;
>                 *edx = entry->edx;
> -               if (function == 7 && index == 0) {
> +               if (function == 7 && index == 0 && (*ebx | (F(RTM) | F(HLE))) {
>                         u64 data;
> -                       if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
> +                       if (!kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data) &&
>                             (data & TSX_CTRL_CPUID_CLEAR))
>                                 *ebx &= ~(F(RTM) | F(HLE));
>                 }
> 
> 
> On VMX, MSR_IA32_TSX_CTRL will be added to the so called shared MSR array
> regardless of whether or not it is being advertised to userspace (this is
> a bug in its own right).  Using the host_initiated variant means KVM will
> incorrectly bypass VMX's ARCH_CAP_TSX_CTRL_MSR check, i.e. incorrectly
> clear the bits if userspace is being weird and stuffed MSR_IA32_TSX_CTRL
> without advertising it to the guest.

Btw, would it be more staightforward to check "vcpu->arch.arch_capabilities &
ARCH_CAP_TSX_CTRL_MSR" rather than "*ebx | (F(RTM) | F(HLE))" even if we want
to have such a fix?

-- 
Peter Xu

