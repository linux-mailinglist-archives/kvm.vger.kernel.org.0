Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD33408519
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbhIMHJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:09:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237454AbhIMHJR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 03:09:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631516882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EWjxh5F2abgIo2Gnc7HdmKlyHPXEnf9KAGWr3gnnOYI=;
        b=MPCRnwyopUdZKF6YaHbT4Y81qoJe02Jdy1wKxzNSJqwMhSDN8UAF+fz2TYE7NskIOdvtl0
        QHcM6VSaugqX/CRkU75/+gxZWiUwjANg1kfbzCTShiUbDExIZLQ8uEsIYJAjYbtK0GLWl5
        syOy9IcEqiM35Xnxc9zSolBRfxGZT4w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-1bRUbm2aNyq_JSNjoy9CKQ-1; Mon, 13 Sep 2021 03:08:00 -0400
X-MC-Unique: 1bRUbm2aNyq_JSNjoy9CKQ-1
Received: by mail-wm1-f71.google.com with SMTP id b139-20020a1c8091000000b002fb33c467c8so4515749wmd.5
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EWjxh5F2abgIo2Gnc7HdmKlyHPXEnf9KAGWr3gnnOYI=;
        b=Gxw4HsPCTYCURJSzjh8UymeBlqBnjP6zyDbl8hUO7cJzsgMsesqriQvze8veERau6E
         VUjhYHqcs5pU3CGgHHmN/2md/R1Evx6bG5jz8eNHw2BTDrduG+fHqL8PE6ots/aKqQz+
         fLHTqQI1MFrDz1ZU/xiFzV9ivZRZ/f/elXTM6awbE5ezUPa7FwkSXL6S9Ron5fgLYP6k
         qyhLoIJ9OSdPY6mdsGhGacrPxgxGtXwHVn02boXpQKp1QML/K0WD70R6uu2OKIRpopFo
         UeeN7p0kEJ4advnT+7x4Hn4kyYcdeDKDBQNV0ohNJTayMWpvke2c92Ajv1+SLXk5/XTY
         8YrQ==
X-Gm-Message-State: AOAM532wlPdK8AgLcx/FH5DWIaPeiTcAocSowG6rd5s8Ejwav21ckT7r
        j3iy+craSfGJgH3UbrRIO+bcOGleNxHPeky3H/05ZhVcYFHhTH18wXFHjvaATFiLIPbeK4LiqFO
        EH6Y9842FLDYf
X-Received: by 2002:adf:e983:: with SMTP id h3mr5459698wrm.231.1631516879788;
        Mon, 13 Sep 2021 00:07:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwF8qp4hFXSGX7z49nSIIL+FQOUxQSvZ93DfhxsC7fRMoJHbuURkT4+vqpjPqMKGLXFk6ybpw==
X-Received: by 2002:adf:e983:: with SMTP id h3mr5459682wrm.231.1631516879583;
        Mon, 13 Sep 2021 00:07:59 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l7sm6455718wmj.9.2021.09.13.00.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 00:07:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Identify vCPU0 by its vcpu_idx instead of
 walking vCPUs array
In-Reply-To: <20210910183220.2397812-3-seanjc@google.com>
References: <20210910183220.2397812-1-seanjc@google.com>
 <20210910183220.2397812-3-seanjc@google.com>
Date:   Mon, 13 Sep 2021 09:07:57 +0200
Message-ID: <87czpd2bsi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Use vcpu_idx to identify vCPU0 when updating HyperV's TSC page, which is
> shared by all vCPUs and "owned" by vCPU0 (because vCPU0 is the only vCPU
> that's guaranteed to exist).  Using kvm_get_vcpu() to find vCPU works,
> but it's a rather odd and suboptimal method to check the index of a given
> vCPU.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 86539c1686fa..6ab851df08d1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2969,7 +2969,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  				       offsetof(struct compat_vcpu_info, time));
>  	if (vcpu->xen.vcpu_time_info_set)
>  		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> -	if (v == kvm_get_vcpu(v->kvm, 0))
> +	if (!v->vcpu_idx)
>  		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>  	return 0;
>  }

" ... instead of walking vCPUs array" in the Subject line is a bit
confusing because kvm_get_vcpu() doesn't actually walk anything, it just
returns 'kvm->vcpus[i]' after checking that we actually have that many
vCPUs. The patch itself is OK, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

