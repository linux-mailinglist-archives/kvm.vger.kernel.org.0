Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9A729891C
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 10:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772591AbgJZJHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 05:07:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1772512AbgJZJHe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 05:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603703252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SEprIZYzYLqEdMCsaNu8aMt1VGMkVphvSgSzQPUy25I=;
        b=AJcSzrBoLRDFHHQ79euDn1qHoCNJflaakiXDoYtMj7mYj/GSxovEWyI7MuuPk9DkjtQVnD
        u9LdEfa61ib0YiFLvsVNNspEnE3mtdMQPIDw6ybIpiIQ10O7XW7LupQjJUR4Cp/KRRpriq
        HbeakCIX/x32HbCdqnz+nFBICA7AnfE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-lBBaTlUCPsSRC1HzvBjl2A-1; Mon, 26 Oct 2020 05:07:30 -0400
X-MC-Unique: lBBaTlUCPsSRC1HzvBjl2A-1
Received: by mail-ed1-f71.google.com with SMTP id n16so3874222edw.19
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 02:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SEprIZYzYLqEdMCsaNu8aMt1VGMkVphvSgSzQPUy25I=;
        b=tzYw5PAh/FOUjkXGK3MBM3i8MhV7foet0BpKvUzfyp+isBzwooDW/f1V5zXLkkGmew
         oyAAcVUH3WiqW33NCSc/YjzDMgK9tHxjM86QyE8jDoTsR5WN6b6kfRLDgAYolVBLCiQ1
         QKfeZBM1UZjEPXWncGVKNdQudhro2y/8QwvwTOEKAjxbQ4VXL51tWJd5tg0sJI5AC79G
         YFqXeNs4f/wfrePrWPbXNTYOw3qN8ucUDjereU0vuPft/h50/StN32bMF+213RTnnpv5
         vxB22uf1mN7YboI6eG2J8AOyi/CTT+kLfB0dcWu9H6f04AGUeJ0/SHbXBJZEpxaqJfhN
         e3vw==
X-Gm-Message-State: AOAM5335I0KYY9DZjUi5tObfqB6BC4nI2WWVGrNKwJ8/tLKN1Z4nWO1f
        pSe0sZ1bSP8J755khN6AupoDZBg1BLNDro9/GZdzzlbwuGzVm+kFldDJM4LXLFTw83k/jlEyvis
        HAvn9PR6JTvtl
X-Received: by 2002:a05:6402:17e4:: with SMTP id t4mr14983333edy.118.1603703248806;
        Mon, 26 Oct 2020 02:07:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyX4twJBC9HPBWYucM43/xc3UpxKMK4mGRFRdSjt4DfA7Dv5k0xH1dFdpFyxML5HhEiX+nyfQ==
X-Received: by 2002:a05:6402:17e4:: with SMTP id t4mr14983326edy.118.1603703248577;
        Mon, 26 Oct 2020 02:07:28 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id mw1sm5438635ejb.1.2020.10.26.02.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 02:07:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Steffen Dirkwinkel <kernel-bugs@steffen.cc>
Subject: Re: [PATCH 2/2] KVM: X86: Fix null pointer reference for KVM_GET_MSRS
In-Reply-To: <20201025185334.389061-3-peterx@redhat.com>
References: <20201025185334.389061-1-peterx@redhat.com> <20201025185334.389061-3-peterx@redhat.com>
Date:   Mon, 26 Oct 2020 10:07:27 +0100
Message-ID: <871rhl2w4w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> kvm_msr_ignored_check() could trigger a null pointer reference

'dereference' but I'd also clarify that 'vcpu' is NULL.

>  if ignore_msrs=Y
> and report_ignore_msrs=Y when try to fetch an invalid feature msr using the
> global KVM_GET_MSRS.  Degrade the error report to not rely on vcpu since that
> information (index, rip) is not as important as msr index/data after all.
>
> Fixes: 12bc2132b15e0a96

Fixes: 12bc2132b15e ("KVM: X86: Do the same ignore_msrs check for feature msrs")

please (checkpatch.pl should've complained I guess)

> Reported-by: Steffen Dirkwinkel <kernel-bugs@steffen.cc>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ce856e0ece84..5993fbd6d2c5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -259,8 +259,8 @@ static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
>  
>  	if (ignore_msrs) {
>  		if (report_ignored_msrs)
> -			vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
> -				    op, msr, data);
> +			kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n",
> +				      op, msr, data);

I would've preserved vcpu version for non-gloal cases, e.g.

if (report_ignored_msrs) {
	if (vcpu)
        	vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
	                op, msr, data);
        else
	        kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n",
                               op, msr, data);
}

>  		/* Mask the error */
>  		return 0;
>  	} else {

-- 
Vitaly

