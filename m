Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B726036E752
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 10:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240093AbhD2Iri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 04:47:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53262 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239919AbhD2Irh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 04:47:37 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619686009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kHswT2jDsMipWNtyamEbQ6UzsQ/KBjJJLmUiEm7N+L4=;
        b=m47Zu631+9u8FlUrxbxPWR/hy2tj9n1mmU4jXSHTB7lMVT6uTqyRHD/r20qxTyqI2n5haT
        +sVsm4jxfVtIWu/ko/KhJxz6tN3zMObJIKY5J01woaE717JGjmTIgJTQfF+QsRXMaHq36+
        wDwMpl8nhngfmxWU9cTLND3m4eXqXqrWhtX7kLPIl7PcY8xRFSHabrDS8H9ybe1fGyDBzl
        8IGnWZkBO+vE3lc3gpTDUQ3RHsm/TO7Er1J+7o9y4JnTkmu5zJkM/B4rma5KNBRduiE1aA
        4vh+ZTP4Qxum6HT0sph3uaZzvEj9UzqMEHP/PmYam8PFcqskWcZfK+0O+S9Tlg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619686009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kHswT2jDsMipWNtyamEbQ6UzsQ/KBjJJLmUiEm7N+L4=;
        b=lZimm/D2q4FscZj3ZcaogdCCgH27aBYOxB6pEVm4YlRD/7ed43dpAbKE0hKX3M7WIqhq2r
        fqvYFh+hGFJoJpDQ==
To:     Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Guest system time jumps when new vCPUs is hot-added
In-Reply-To: <e33920a0-24bc-fa40-0a23-c2eb5693f85d@linux.alibaba.com>
References: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com> <87lf92n5r1.ffs@nanos.tec.linutronix.de> <e33920a0-24bc-fa40-0a23-c2eb5693f85d@linux.alibaba.com>
Date:   Thu, 29 Apr 2021 10:46:49 +0200
Message-ID: <875z057a12.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29 2021 at 07:24, Zelin Deng wrote:
> On 2021/4/28 =E4=B8=8B=E5=8D=885:00, Thomas Gleixner wrote:
>> On Wed, Apr 28 2021 at 10:22, Zelin Deng wrote:
>>> [   85.101228] TSC ADJUST compensate: CPU1 observed 169175101528 warp. =
Adjust: 169175101528
>>> [  141.513496] TSC ADJUST compensate: CPU1 observed 166 warp. Adjust: 1=
69175101694
>> Why is TSC_ADJUST on CPU1 different from CPU0 in the first place?
>
> Per my understanding when vCPU is created by KVM, it's tsc_offset =3D 0 -=
=20
> host rdtsc() meanwhile TSC_ADJUST is 0.
>
> Assume vCPU0 boots up with tsc_offset0, after 10000 tsc cycles, hotplug=20
> via "virsh setvcpus" creates a new vCPU1 whose tsc_offset1 should be=20
> about tsc_offset0 - 10000.=C2=A0 Therefore there's 10000 tsc warp between=
=20
> rdtsc() in guest of vCPU0 and vCPU1, check_tsc_sync_target() when vCPU1=20
> gets online will set TSC_ADJUST for vCPU1.
>
> Did I miss something?

Yes. The above is wrong.

The host has to ensure that the TSC of the vCPUs is in sync and if it
exposes TSC_ADJUST then that should be 0 and nothing else. The TSC
in a guest vCPU is

  hostTSC + host_TSC_ADJUST + vcpu_TSC_OFFSET + vcpu_guest_TSC_ADJUST

The mechanism the host has to use to ensure that the guest vCPUs are
exposing the same time is vcpu_TSC_OFFSET and nothing else. And
vcpu_TSC_OFFSET is the same for all vCPUs of a guest.

Now there is another issue when vCPU0 and vCPU1 are on different
'sockets' via the topology information provided by the hypervisor.

Because we had quite some issues in the past where TSCs on a single
socket were perfectly fine, but between sockets they were skewed, we
have a sanity check there. What it does is:

     if (cpu_is_first_on_non_boot_socket(cpu))
     	validate_synchronization_with_boot_socket()

And that validation expects that the CPUs involved run in a tight loop
concurrently so the TSC readouts which happen on both can be reliably
compared.

But this cannot be guaranteed on vCPUs at all, because the host can
schedule out one or both at any point during that synchronization check.

A two socket guest setup needs to have information from the host that
TSC is usable and that the socket sync check can be skipped. Anything
else is just doomed to fail in hard to diagnose ways.

Thanks,

        tglx
