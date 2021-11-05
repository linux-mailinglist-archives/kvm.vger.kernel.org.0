Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E64446972
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 21:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhKEUO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 16:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbhKEUO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 16:14:57 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669EEC061714
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 13:12:17 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u17so11720995plg.9
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 13:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qri/F8nrhMHPEDYa4uQBt3JEMiHHv9C5/Jmdnno/6TE=;
        b=cIEyP8aWcsIt4l1x4nbkEBmKTwuf4VKIqebtH0CamXLLrZvDTlRgHn6uwPaIY1qdYN
         Fgiy/kNzJgL6/SmGcy37HITOWEPVyIdCiclDP5nOj+WydYi2O63mGY95RUeOrxL9PvWh
         Gfm1SPQHjJDMZsGGN4DcnnN4SM2ODaCqT/kJ/VZE7yvR3zhk2fJEFqV9YFGRTqZ+jsnj
         Pgh/W1HeccTmRVlizmn2ItiqkKcXfVUFRASIjGOCbR0SyLm177P2qgIaXEww6aWSnQar
         T5v/4lUFkU6kuCFZ6hk4p9nBXBYb6gEsGdXh01NXvay8YV3v3E29TKauFH/h+FbOOdHd
         GGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qri/F8nrhMHPEDYa4uQBt3JEMiHHv9C5/Jmdnno/6TE=;
        b=T0rYbnrVdZYPaAj7zJrDVhZnwba9SDOSoKf4inoA26THUpOVZTHT8fERlP7/vwdKri
         /5sRfiRkxBnG3VfT1iRk6hv7FA7WcFg5vJ8D6G1hD/Ytb2H1wnWsmlv61xqW744hqz+N
         iVPEAhLfCCaK7LshdKKI7p7C1IMBFxnir3K4ye3QVP3eyOp8bnxnPXh0ONb83nSlYiJu
         ryRkhbMsK7IxyYHGIju0tHpPy8fVfUZEEacrelayfZos4jMOrFhB1Sc7XFkshU1V8xwz
         3De+kw4qAG3sysUl/NFF0FRozfEo/A2krUA3NZEDW9Sf5cDxeK+UXZPBmaDmqsQviDux
         nwTw==
X-Gm-Message-State: AOAM532HEpjY3Amb05GMRlJsWeYiuMmcvwLCvzvD5+eWjoEblHqOyuB0
        bpxMeXJkQYxsDh5cU4VHmyjnl/2lXDKGiw==
X-Google-Smtp-Source: ABdhPJw8Bn6P+IE+Qzeo9KqPziiJGvYCB1J6tl8vP7MYz520ZFYD+Cv/5edLbN+g+nahR9ZSMbCUMA==
X-Received: by 2002:a17:902:758b:b0:13e:8b1:e49f with SMTP id j11-20020a170902758b00b0013e08b1e49fmr53627978pll.6.1636143136683;
        Fri, 05 Nov 2021 13:12:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a20sm7760762pff.57.2021.11.05.13.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 13:12:16 -0700 (PDT)
Date:   Fri, 5 Nov 2021 20:12:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 1/5] KVM: Move wiping of the kvm->vcpus array to common
 code
Message-ID: <YYWQHBwD4nBLo9qi@google.com>
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105192101.3862492-2-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 05, 2021, Marc Zyngier wrote:
> All architectures have similar loops iterating over the vcpus,
> freeing one vcpu at a time, and eventually wiping the reference
> off the vcpus array. They are also inconsistently taking
> the kvm->lock mutex when wiping the references from the array.

...

> +void kvm_destroy_vcpus(struct kvm *kvm)
> +{
> +	unsigned int i;
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_vcpu_destroy(vcpu);
> +
> +	mutex_lock(&kvm->lock);

But why is kvm->lock taken here?  Unless I'm overlooking an arch, everyone calls
this from kvm_arch_destroy_vm(), in which case this is the only remaining reference
to @kvm.  And if there's some magic path for which that's not true, I don't see how
it can possibly be safe to call kvm_vcpu_destroy() without holding kvm->lock, or
how this would guarantee that all vCPUs have actually been destroyed before nullifying
the array.

> +	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
> +		kvm->vcpus[i] = NULL;
> +
> +	atomic_set(&kvm->online_vcpus, 0);
> +	mutex_unlock(&kvm->lock);
> +}
> +EXPORT_SYMBOL_GPL(kvm_destroy_vcpus);
