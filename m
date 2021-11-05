Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054B8446995
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 21:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhKEUYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 16:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbhKEUYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 16:24:20 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D99CC061714
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 13:21:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id n85so5356250pfd.10
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 13:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FChUXutBpeRG92vMItY2zirb2KiX64mqNa6lRjXS4/o=;
        b=XhJq67XOVehGKyOlop0ZgXHOTZHwcQNzObFkCi6/KagxRodpEZ8yllo88wcXd9u5A4
         JyHn3eOSHm71QE0Ho4vu+PMzSC+hk/kpLn0XoWAl+sEDJCXJH8yRiSGn+WDU3uzo/0Jz
         vKuoP+xD9+dM6PIdOwrxBIcZiSTMvIRnKJ1ZTnCiCFNuTdGdR0au4APz76smsdf0FTJU
         MNMzCzzdiPQ0CIWIuM2KFOvXL49l2ImI8P3640AzVXeG075F7RRRDlC4KR+jmtTfyE56
         DSWnC2bV/xJ5K5cAgxAaKeJQrMHJdJxDe+n/OzOHw9DBQw6HJa62AhCnvmDdn0hwLrnK
         Xi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FChUXutBpeRG92vMItY2zirb2KiX64mqNa6lRjXS4/o=;
        b=6kjtwiCBEMzsjBB0HR3g/J6DcLI8Sf4TnHJPq4luXR3WzziEFyW700ngt/G4SpwdBn
         c9mQXTKpMyLsbzu+jpG8TSG1B1pdD+NtMKccGaKpLICvkX6rjj0yq4Aa9BIHXfhtgngR
         LGL1yEShdFevLDiRyBb0AtBNqhXveNkWUOUk8GC5Ywlftiie37osjrl25da5F+FTygVA
         I+BLUoDlhtGQGrk6K2fTuEEG65kiPa7l2DZSR8mxbiUZ7AKlEJLvyFRzvuTqOAZ0QNXw
         HRyKqmvTurCuutJCLZ2Z1WKUA17CFkIXGHg9Ez0o0cpNMTzYInR9p8Igm8h+qp1xq+MA
         T8Qg==
X-Gm-Message-State: AOAM531yzanY8AgWdCkn2vVvgCJztuXhscThCYaD2BojI9fiRI9L8Pzo
        6o0Y005pnZj10HKoZbrKeuhltA==
X-Google-Smtp-Source: ABdhPJwJsyZkhGzgEWjIobCpYAvoWgic/EqtGUxZtysje8E+26IpZ1/HH08l9V0rneyI5sI9Ep2Vgg==
X-Received: by 2002:a05:6a00:c8f:b0:481:20a8:7c61 with SMTP id a15-20020a056a000c8f00b0048120a87c61mr32575696pfv.8.1636143700318;
        Fri, 05 Nov 2021 13:21:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c12sm5054054pfm.50.2021.11.05.13.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 13:21:39 -0700 (PDT)
Date:   Fri, 5 Nov 2021 20:21:36 +0000
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
Subject: Re: [PATCH 5/5] KVM: Convert the kvm->vcpus array to a xarray
Message-ID: <YYWSUJ1qzhfqjQow@google.com>
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105192101.3862492-6-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 05, 2021, Marc Zyngier wrote:
> At least on arm64 and x86, the vcpus array is pretty huge (512 entries),
> and is mostly empty in most cases (running 512 vcpu VMs is not that
> common). This mean that we end-up with a 4kB block of unused memory
> in the middle of the kvm structure.

Heh, x86 is now up to 1024 entries.
 
> Instead of wasting away this memory, let's use an xarray instead,
> which gives us almost the same flexibility as a normal array, but
> with a reduced memory usage with smaller VMs.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> @@ -693,7 +694,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>  
>  	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu.  */
>  	smp_rmb();
> -	return kvm->vcpus[i];
> +	return xa_load(&kvm->vcpu_array, i);
>  }

It'd be nice for this series to convert kvm_for_each_vcpu() to use xa_for_each()
as well.  Maybe as a patch on top so that potential explosions from that are
isolated from the initiali conversion?

Or maybe even use xa_for_each_range() to cap at online_vcpus?  That's technically
a functional change, but IMO it's easier to reason about iterating over a snapshot
of vCPUs as opposed to being able to iterate over vCPUs as their being added.  In
practice I doubt it matters.

#define kvm_for_each_vcpu(idx, vcpup, kvm) \
	xa_for_each_range(&kvm->vcpu_array, idx, vcpup, 0, atomic_read(&kvm->online_vcpus))
