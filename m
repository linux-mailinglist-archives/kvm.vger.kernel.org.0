Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F853ED865
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhHPOBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:01:53 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60186 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbhHPOBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 10:01:41 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A767421DD3;
        Mon, 16 Aug 2021 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629122469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmqfa2UunehoeozKut2ZQc6fJWOON8YgBnQ/2Wb5cCc=;
        b=MV+hkeQDkdENq+vQrGYU7lGmGYgdVRb78qom8odxESJPDsQCvY2XtFmZ26CywrGjpqsuCi
        EVIj7M5kozbcLC+5/4NLJ8VPeDliAvdO0ji8fziEKYlPZRgX3o04RK9iK9ImT/JBdUuFXB
        S38pVXwSrf6KXyWjqgBoM9VwomNgaTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629122469;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmqfa2UunehoeozKut2ZQc6fJWOON8YgBnQ/2Wb5cCc=;
        b=DDFLZSXRqHSv2Rv0+TOLME0tbNzatLvnN0KGa2Mv9ur8hkDXKQRhNzKLPQLuAAHkSsTsPu
        VAtWXzD2XxRtA3BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4076E13BF2;
        Mon, 16 Aug 2021 14:01:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tcY+DqVvGmGvFQAAMHmgww
        (envelope-from <cfontana@suse.de>); Mon, 16 Aug 2021 14:01:09 +0000
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Ashish Kalra <Ashish.Kalra@amd.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
References: <cover.1629118207.git.ashish.kalra@amd.com>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <4ffdca0d-a495-07aa-316d-4dcee5fe8007@suse.de>
Date:   Mon, 16 Aug 2021 16:01:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/16/21 3:25 PM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> This is an RFC series for Mirror VM support that are 
> essentially secondary VMs sharing the encryption context 
> (ASID) with a primary VM. The patch-set creates a new 
> VM and shares the primary VM's encryption context
> with it using the KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability.
> The mirror VM uses a separate pair of VM + vCPU file 
> descriptors and also uses a simplified KVM run loop, 
> for example, it does not support any interrupt vmexit's. etc.
> Currently the mirror VM shares the address space of the
> primary VM. 

Hi,

I'd expect some entry in docs/ ?

Thanks,

Claudio

> 
> The mirror VM can be used for running an in-guest migration 
> helper (MH). It also might have future uses for other in-guest
> operations.
> 
> The mirror VM support is enabled by adding a mirrorvcpus=N
> suboption to -smp, which also designates a few vcpus (normally 1)
> to the mirror VM.
> 
> Example usage for starting a 4-vcpu guest, of which 1 vcpu is marked as
> mirror vcpu.
> 
>     qemu-system-x86_64 -smp 4,mirrorvcpus=1 ...
> 
> Ashish Kalra (7):
>   kvm: Add Mirror VM ioctl and enable cap interfaces.
>   kvm: Add Mirror VM support.
>   kvm: create Mirror VM and share primary VM's encryption context.
>   softmmu/cpu: Skip mirror vcpu's for pause, resume and synchronization.
>   kvm/apic: Disable in-kernel APIC support for mirror vcpu's.
>   hw/acpi: disable modern CPU hotplug interface for mirror vcpu's
>   hw/i386/pc: reduce fw_cfg boot cpu count taking into account mirror
>     vcpu's.
> 
> Dov Murik (5):
>   machine: Add mirrorvcpus=N suboption to -smp
>   hw/boards: Add mirror_vcpu flag to CPUArchId
>   hw/i386: Mark mirror vcpus in possible_cpus
>   cpu: Add boolean mirror_vcpu field to CPUState
>   hw/i386: Set CPUState.mirror_vcpu=true for mirror vcpus
> 
> Tobin Feldman-Fitzthum (1):
>   hw/acpi: Don't include mirror vcpus in ACPI tables
> 
>  accel/kvm/kvm-accel-ops.c |  45 ++++++-
>  accel/kvm/kvm-all.c       | 244 +++++++++++++++++++++++++++++++++++++-
>  accel/kvm/kvm-cpus.h      |   2 +
>  hw/acpi/cpu.c             |  21 +++-
>  hw/core/cpu-common.c      |   1 +
>  hw/core/machine.c         |   7 ++
>  hw/i386/acpi-build.c      |   5 +
>  hw/i386/acpi-common.c     |   5 +
>  hw/i386/kvm/apic.c        |  15 +++
>  hw/i386/pc.c              |  10 ++
>  hw/i386/x86.c             |  11 +-
>  include/hw/acpi/cpu.h     |   1 +
>  include/hw/boards.h       |   3 +
>  include/hw/core/cpu.h     |   3 +
>  include/hw/i386/x86.h     |   3 +-
>  include/sysemu/kvm.h      |  15 +++
>  qapi/machine.json         |   5 +-
>  softmmu/cpus.c            |  27 +++++
>  softmmu/vl.c              |   3 +
>  target/i386/kvm/kvm.c     |  42 +++++++
>  20 files changed, 459 insertions(+), 9 deletions(-)
> 

