Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2FB0175B13
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 14:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgCBNBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 08:01:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50396 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727173AbgCBNBM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Mar 2020 08:01:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583154071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vFEYElovxs1he3jW2L/2OIMoWJCYaK4R5aZbj7powQE=;
        b=FuUV2gj2jcHRvtYO0OqD2T5KN8sjT90IZfmfq7tDlKZYoJz/8vx8Jq6gLJSyPgPNgRiDUm
        MiE9jC/p+4COuNXjE3rVG0DWD6t0ChMrSIuU0g6LAX4mWOMjSWcQZnoB3h/d8fULk5LDZE
        +0S3wECs+n6/Cl6+zkjvRXArt3yb3R4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-66urbnbfP0-nvsLxk13K0g-1; Mon, 02 Mar 2020 08:01:09 -0500
X-MC-Unique: 66urbnbfP0-nvsLxk13K0g-1
Received: by mail-wr1-f71.google.com with SMTP id w18so5793332wro.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 05:01:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vFEYElovxs1he3jW2L/2OIMoWJCYaK4R5aZbj7powQE=;
        b=Q0CbKo008Nw7buvLl7LYDMK/dhw9U7rCeg/1sg/eeMIs0vzHF0KxgMP3PiewJTDRKc
         +V4+6L938akgpX4k+L+QXSaf0WpVZzoT4ERWl+VysxWUsoTvRn6V6zPgnBGL+TeTbmhg
         kp+JOlcVMpRy4F7U0d8CR+gZb7QQ9NKEv9PIVHGgSZKC+x59JMn8ZDGUR8U7aRFqiq/S
         QGYSHCi+C3ZuzQ/7XOgLAnb5+fdguN5AFnoXK+0pm0ngm3B7TsQsPsPL5vqrAV83IlSb
         EQg1E82Li2l4HGTxOEge6yzdxR5UW+vWiRG6VOPKe2IRx/Jmbv1b/eFKS1HMAG10UXF0
         wtNQ==
X-Gm-Message-State: APjAAAUn4SckBgrj1T/14P1G7mxv2tARIlcAEkER4o7UaBBA4GUo0YAK
        hI6GB86OmUH49Ey4EUCI1QJK51tbALnfeL3NPq2Hl5BnQTaGNO4Sw5/bCcINFyWdwj+WuvDS8rC
        EZA/LeJdYNVw+
X-Received: by 2002:a05:600c:251:: with SMTP id 17mr19492302wmj.59.1583154068053;
        Mon, 02 Mar 2020 05:01:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqytInT/vs8uW+zSLol0sFtoMeXPxy5TDYEfalNY4crz/GnJg2mECfgk9LJfq+x+gQ9Zc8kXIg==
X-Received: by 2002:a05:600c:251:: with SMTP id 17mr19492281wmj.59.1583154067821;
        Mon, 02 Mar 2020 05:01:07 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i204sm16306020wma.44.2020.03.02.05.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 05:01:07 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3] KVM: X86: Just one leader to trigger kvmclock sync request
In-Reply-To: <1582859921-11932-1-git-send-email-wanpengli@tencent.com>
References: <1582859921-11932-1-git-send-email-wanpengli@tencent.com>
Date:   Mon, 02 Mar 2020 14:01:06 +0100
Message-ID: <87lfoihpwt.fsf@vitty.brq.redhat.com>
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
> workqueue before each vCPU creation completes. The workqueue subsystem guarantees 
> not to queue the already queued work, however, we can make the logic more clear by 
> make just one leader to trigger this kvmclock sync request and save on cacheline 
> boucing due to test_and_set_bit.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v2 -> v3:
>  * update patch description
> v1 -> v2:
>  * check vcpu->vcpu_idx
>
>  arch/x86/kvm/x86.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb5d64e..79bc995 100644
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

I would've merged this new check with !kvmclock_periodic_sync above
making it more obvious when the work is scheduled

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5de200663f51..93550976f991 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9389,11 +9389,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
        mutex_unlock(&vcpu->mutex);
 
-       if (!kvmclock_periodic_sync)
-               return;
-
-       schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
-                                       KVMCLOCK_SYNC_PERIOD);
+       if (vcpu->vcpu_idx == 0 && kvmclock_periodic_sync)
+               schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
+                                     KVMCLOCK_SYNC_PERIOD);
 }

>  }
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)

With or without the change mentioned above,
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

