Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC631628E8
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 15:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgBROyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 09:54:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46176 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726634AbgBROyX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 09:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582037661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oAYE5zIUMBfPxzBexfTcLOpuwobiWBtk76M7O7fy2cY=;
        b=UTdQyjGkLMxIRYccyXdsFBNPeAkjs6IBEFg+zBn04HIHnJtywMyzIv3emvDQPEmzSOeWva
        6ZXbJLqSWGFe3aI8KFbNATzZQ5Ysju7WOpAAu+f5LaP3s3mquprWKR8lGsqmLSHC7UjTKL
        sJSVmlpY94UDCUMYdI0oNvM/3g2ftX4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-k8R_PEdsMJi-1sH_2BzZYQ-1; Tue, 18 Feb 2020 09:54:18 -0500
X-MC-Unique: k8R_PEdsMJi-1sH_2BzZYQ-1
Received: by mail-wr1-f72.google.com with SMTP id u8so10945353wrp.10
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 06:54:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oAYE5zIUMBfPxzBexfTcLOpuwobiWBtk76M7O7fy2cY=;
        b=qc74GZuvokPYXSMbjZotmWYKLT60w1J3WEIg/JLQ1DW1KNUBnre+M3D3S/g5A9Sm5V
         vk2Jbw+SGOsLNxUuIj397lAKPI7ybyEt0p8F3/Zgvy8oJ3s30/coiGJ1iVQw/A6UkC9K
         51/Xg++XaYK8CHPOzN7vOGBYRMfBalUo4I2wbjFT8EjIYSX0EytHVuG8szx0Mo2Zk3bC
         7gBDhnYUCpB3CtQ/1pN9l1c//y9uYf4Z387hW5GGkVg3q0JDPHe3xO+vLhd/M5Q1rm6X
         nrACjdCdoYBxe57cLOa9AEnFTmRVn834f1CnftmNU6TJWocDQ7t4Ztvc4uieAWyWbpR0
         wfjQ==
X-Gm-Message-State: APjAAAU+n2OAAwHdF8Q5+2saf5VZU0jzyFxpFjAS67wYn+yFgfbFZGqW
        sAJUmnz5Tvv6IXduA2qUE83L9L1M/6z/02tXpKg8nvcQ/SqIdCUw0Zd02f1V37MoX0viZOwvB7v
        xToXGn8lREBnh
X-Received: by 2002:adf:f606:: with SMTP id t6mr29394030wrp.304.1582037657390;
        Tue, 18 Feb 2020 06:54:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqx3KNJMO5F3fa7ubC1BaO9mmpNeE7KVzCllzDAfvWz7/f13qvu0EW0swAoA822SBicvqKuTfQ==
X-Received: by 2002:adf:f606:: with SMTP id t6mr29394011wrp.304.1582037657204;
        Tue, 18 Feb 2020 06:54:17 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a13sm6288184wrp.93.2020.02.18.06.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 06:54:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/2] KVM: X86: Less kvmclock sync induced vmexits after VM boots
In-Reply-To: <1581988630-19182-1-git-send-email-wanpengli@tencent.com>
References: <1581988630-19182-1-git-send-email-wanpengli@tencent.com>
Date:   Tue, 18 Feb 2020 15:54:15 +0100
Message-ID: <87r1ys7xpk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> In the progress of vCPUs creation, it queues a kvmclock sync worker to the global 
> workqueue before each vCPU creation completes. Each worker will be scheduled 
> after 300 * HZ delay and request a kvmclock update for all vCPUs and kick them 
> out. This is especially worse when scaling to large VMs due to a lot of vmexits. 
> Just one worker as a leader to trigger the kvmclock sync request for all vCPUs is 
> enough.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v3 -> v4:
>  * check vcpu->vcpu_idx
>
>  arch/x86/kvm/x86.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb5d64e..d0ba2d4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9390,8 +9390,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  	if (!kvmclock_periodic_sync)
>  		return;
>  
> -	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> -					KVMCLOCK_SYNC_PERIOD);
> +	if (vcpu->vcpu_idx == 0)
> +		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
> +						KVMCLOCK_SYNC_PERIOD);
>  }
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)

Forgive me my ignorance, I was under the impression
schedule_delayed_work() doesn't do anything if the work is already
queued (see queue_delayed_work_on()) and we seem to be scheduling the
same work (&kvm->arch.kvmclock_sync_work) which is per-kvm (not
per-vcpu). Do we actually happen to finish executing it before next vCPU
is created or why does the storm you describe happens?

-- 
Vitaly

