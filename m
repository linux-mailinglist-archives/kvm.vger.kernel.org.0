Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CDE3EDC57
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 19:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhHPRY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 13:24:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhHPRY0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 13:24:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629134634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nSfEWJW5VOF1+UGUOs92UACFZJr9fBBVMgZfpcfs9E8=;
        b=bCk07uH4d7basUuUHZwHLs8X9qaCJGwkHGgnNbiRyZRZfuOclwwlDEZZ9BW2W76Rmf1uXd
        svZC/gxFtdpEErfF4ZMg/wuScTwnAR5/Nb301bJR+3JNLdXA/RctUvYKmp6tAKBLLnxiIz
        xX1t/247IXtG0vvIwoOibzq4tXDuEYM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-IZ_YgRp_Mx-MmTJRP1mpNA-1; Mon, 16 Aug 2021 13:23:53 -0400
X-MC-Unique: IZ_YgRp_Mx-MmTJRP1mpNA-1
Received: by mail-wm1-f71.google.com with SMTP id y186-20020a1c32c30000b02902b5ac887cfcso8056252wmy.2
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 10:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nSfEWJW5VOF1+UGUOs92UACFZJr9fBBVMgZfpcfs9E8=;
        b=sdQ8/TUFcWgzYkVeH5QaO7SQRkPCXip2old7ctPnhUFtefJSDmz3hpF7SUuWbxfsgz
         znNb8VYTfX6+u4jipX17ctg49xbAskwSL6euPRCLWtiyP/KcB3kIQz154O5n76iIE/ri
         dJvXhtf3UqNGlULTl80Qx5wb60pTP+dBFLrVhMecVu95rPs0pcn6+4NwsoIoQQRcMCck
         ex9oi5TyOkYTbmc9KYZMZtHTB19bheZ7cTldRQYtnhC/JyXKGQIT27OJNqsCc6Ky5bKR
         TlgGLvZ9OsUF27gZyJX1ljWoAcutg1fIwG0qGVybLTdRp61pEPq8yMvb/KwKsMwoNN+Z
         l8kg==
X-Gm-Message-State: AOAM530GA4kFNZT9kVBFTl381xMSHrVKPcUphhxrXz9EeRzVsJVsyFIS
        QV/qOMinSrFDXD3vZkOJ7Y92I6siGt7Maux33hHsMY8NUyGT5FZQpIOkZ0vV5mRMySX5as7ruUt
        xz+UMdP6/8LRm
X-Received: by 2002:a5d:5228:: with SMTP id i8mr19797566wra.391.1629134631854;
        Mon, 16 Aug 2021 10:23:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxr/EULMz4YbGdtxkphQbMYTUQwPQrwSV/ywAqLyZsVMQ2DuH8UYDSePKurq0qGPBM/cdYDjg==
X-Received: by 2002:a5d:5228:: with SMTP id i8mr19797558wra.391.1629134631711;
        Mon, 16 Aug 2021 10:23:51 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id u16sm129532wmc.41.2021.08.16.10.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 10:23:49 -0700 (PDT)
Date:   Mon, 16 Aug 2021 18:23:47 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, qemu-devel@nongnu.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        jejb@linux.ibm.com, tobin@ibm.com, dovmurik@linux.vnet.ibm.com,
        frankeh@us.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YRqfI0YlNZ6Xowwt@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Paolo Bonzini (pbonzini@redhat.com) wrote:
> On 16/08/21 15:25, Ashish Kalra wrote:
> > From: Ashish Kalra<ashish.kalra@amd.com>
> > 
> > This is an RFC series for Mirror VM support that are
> > essentially secondary VMs sharing the encryption context
> > (ASID) with a primary VM. The patch-set creates a new
> > VM and shares the primary VM's encryption context
> > with it using the KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability.
> > The mirror VM uses a separate pair of VM + vCPU file
> > descriptors and also uses a simplified KVM run loop,
> > for example, it does not support any interrupt vmexit's. etc.
> > Currently the mirror VM shares the address space of the
> > primary VM.
> > 
> > The mirror VM can be used for running an in-guest migration
> > helper (MH). It also might have future uses for other in-guest
> > operations.
> 
> Hi,
> 
> first of all, thanks for posting this work and starting the discussion.
> 
> However, I am not sure if the in-guest migration helper vCPUs should use the
> existing KVM support code.  For example, they probably can just always work
> with host CPUID (copied directly from KVM_GET_SUPPORTED_CPUID),

Doesn't at least one form of SEV have some masking of CPUID that's
visible to the guest; so perhaps we have to match the main vCPUs idea of
CPUIDs?

>  and they do
> not need to interface with QEMU's MMIO logic.  They would just sit on a
> "HLT" instruction and communicate with the main migration loop using some
> kind of standardized ring buffer protocol; the migration loop then executes
> KVM_RUN in order to start the processing of pages, and expects a
> KVM_EXIT_HLT when the VM has nothing to do or requires processing on the
> host.
> 
> The migration helper can then also use its own address space, for example
> operating directly on ram_addr_t values with the helper running at very high
> virtual addresses.  Migration code can use a RAMBlockNotifier to invoke
> KVM_SET_USER_MEMORY_REGION on the mirror VM (and never enable dirty memory
> logging on the mirror VM, too, which has better performance).

How does the use of a very high virtual address help ?

> With this implementation, the number of mirror vCPUs does not even have to
> be indicated on the command line.  The VM and its vCPUs can simply be
> created when migration starts.  In the SEV-ES case, the guest can even
> provide the VMSA that starts the migration helper.
> 
> The disadvantage is that, as you point out, in the future some of the
> infrastructure you introduce might be useful for VMPL0 operation on SEV-SNP.
> My proposal above might require some code duplication. However, it might
> even be that VMPL0 operation works best with a model more similar to my
> sketch of the migration helper; it's really too early to say.
> 

Dave

> Paolo
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

