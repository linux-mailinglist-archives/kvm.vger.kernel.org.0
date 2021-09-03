Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1DD3FFF58
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 13:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348819AbhICLpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 07:45:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348247AbhICLpU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 07:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630669460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HpnKnHLGzPAJzdSBbsC3pLsaD4HC3lArEEuQ/lWlcJQ=;
        b=IeG+L9JMi1VdrHVbbN/ZiuERp+0L09BPOLAprxjOzlF8sP23qEWo7StkM4ZK0AEzVm+NHk
        2IOYxM8rrUiXBIQkP/sHdtUchji63tds/1skb/ezI1AJiE07NL1eVfqlQxz9s6qCxHqHNX
        TY32j7mnGCYYjkepsR4yJc38gMYDUOo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-l1qeq1Z9OUOb11CxQaajPQ-1; Fri, 03 Sep 2021 07:44:19 -0400
X-MC-Unique: l1qeq1Z9OUOb11CxQaajPQ-1
Received: by mail-wm1-f72.google.com with SMTP id f17-20020a05600c155100b002f05f30ff03so2562414wmg.3
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 04:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HpnKnHLGzPAJzdSBbsC3pLsaD4HC3lArEEuQ/lWlcJQ=;
        b=r/OuwHPaKI1xFUhKWI6nh6FB+M/fi40OnwXoIHdPCQ57jMNKQlXMb4sJydrG0gjvOd
         V88yQemXzfV1nMEluT4sJ2lLJjJkP2Owy3WtakTuYlGlRKvwx2JiYxGIqSVUiI1C+GQ+
         hfakjuo6mnyOEsz7byZkrdrbIpRfmhcgK0vCo0Ph7qMUHlxRVqhOYHxH2cjqLDNOYLC3
         qbBJHQsr0WK2uBrkiq77OxJST++unuB6b5xA8G/nAzE7iQoQvfjdHUUzrP+TELnSxrJ2
         LZaV+ScsW3uBk+ZM41PqBGaUDfdBDGbsOLniuplBTxpaeIfsjO3WlFPdzMWlTlac18oH
         8uOw==
X-Gm-Message-State: AOAM5325otN/QbcmuEu+/6Akn0VqM3ruHE+j8kUzG4hEkPrZ1yBikynk
        Y328RUFPz9KptDLcIq68MV+Azc/aLX/mczh6Y/9wu6dx2tXmInPH9zLLUlH+rlnZVMZv3fdT1Bi
        TCokS/YeVUczQ
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr7972767wmb.5.1630669458564;
        Fri, 03 Sep 2021 04:44:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9hLzrRRw3Zz73eixW1LRZLLtVB/uAe147wUhFALHXixvcPP///Nzyhh43bUtg7HVFfciNig==
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr7972738wmb.5.1630669458289;
        Fri, 03 Sep 2021 04:44:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u27sm4682490wru.2.2021.09.03.04.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 04:44:17 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jiang Jiasheng <jiasheng@iscas.ac.cn>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Jiang Jiasheng <jiasheng@iscas.ac.cn>,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        jarkko@kernel.org, dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/4] KVM: X86: Potential 'index out of range' bug
In-Reply-To: <1630655700-798374-1-git-send-email-jiasheng@iscas.ac.cn>
References: <1630655700-798374-1-git-send-email-jiasheng@iscas.ac.cn>
Date:   Fri, 03 Sep 2021 13:44:16 +0200
Message-ID: <87czppnasv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jiang Jiasheng <jiasheng@iscas.ac.cn> writes:

> The kvm_get_vcpu() will call for the array_index_nospec()
> with the value of atomic_read(&(v->kvm)->online_vcpus) as size,
> and the value of constant '0' as index.
> If the size is also '0', it will be unreasonabe
> that the index is no less than the size.
>

Can this really happen?

'online_vcpus' is never decreased, it is increased with every
kvm_vm_ioctl_create_vcpu() call when a new vCPU is created and is set to
0 when all vCPUs are destroyed (kvm_free_vcpus()).

kvm_guest_time_update() takes a vcpu as a parameter, this means that at
least 1 vCPU is currently present so 'online_vcpus' just can't be zero.

> Signed-off-by: Jiang Jiasheng <jiasheng@iscas.ac.cn>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0f4a46..c59013c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2871,7 +2871,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  				       offsetof(struct compat_vcpu_info, time));
>  	if (vcpu->xen.vcpu_time_info_set)
>  		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> -	if (v == kvm_get_vcpu(v->kvm, 0))
> +	if (atomic_read(&(v->kvm)->online_vcpus) > 0 && v == kvm_get_vcpu(v->kvm, 0))
>  		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>  	return 0;
>  }

-- 
Vitaly

