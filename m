Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C533218F4FD
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 13:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgCWMss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 08:48:48 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47329 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728222AbgCWMss (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 08:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584967726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wF/Z91rii7js9BxWiPX/IJSf6cOn716YQpoQOgnhvlY=;
        b=ARrj8gKK3SXwVvsPenusscI6xrrsboAUYUC3b5FR8n8ZRR93y7tZEXKPVL6l5T5Al1Rx81
        97/fL5Ii85gzYTP9Do5JV7gptw/sVihobhsYQxtq7UFMl0U/JhDPH+zSoBkD+ajOxbL9Gb
        7kIjkjkKnAMi29wYBHNPCKA8LzkY7mo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-kK8Mm7PBMrm3VLzVfU6tNQ-1; Mon, 23 Mar 2020 08:48:45 -0400
X-MC-Unique: kK8Mm7PBMrm3VLzVfU6tNQ-1
Received: by mail-wr1-f70.google.com with SMTP id m15so2901108wrb.0
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 05:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wF/Z91rii7js9BxWiPX/IJSf6cOn716YQpoQOgnhvlY=;
        b=MtjIhqQ1MbiSiTP2E30fSNkWWHd87RXDcvsZYshjWOjeV24+D22NQKsgSm3/kjhISZ
         1yrTFgu+QDSkOgGNxG8jAYXvRXaOyLwplm3avhjCEMyBs7tJuCFp3G/N/uYkhrxNVCVs
         KgSeO73L7j2jf8fCQbvJA7VpECjfKgkEzbVnUcAVUgJbNvllbp1dVhGaQZcef1m8Q/sx
         /jJ1Gi74w6+z7ThE0ycUNvEQ5GCinQvy56MK/drv508dEvk8AKnAEdcAGtu0L6nlS855
         wJwmoAzKTkA7uPQqMLThLir6zIviLz3FoTw+jDMsvIKamRN88h+Grs81pNX1lgu+rwcW
         WxHA==
X-Gm-Message-State: ANhLgQ2JfT+nl815goy3HNZdzXFxIUS7qNjWYH3M3AfKYdmbAmcP+Cuw
        v4wgi8QDPvJWW4Y0eVZY1ST1CUb632CJd4uT5WjX6RCeJusMNWEdPa/b4gtqQxTnLcQG1deAhzt
        ymY+vBsSoW6fh
X-Received: by 2002:a1c:5544:: with SMTP id j65mr25700720wmb.60.1584967724309;
        Mon, 23 Mar 2020 05:48:44 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsE+BwUdC/3N3MhWCg3gX3gw8CdW/xveukJtA9Qqd5DxMyzUeCK03I5juokdRkfNo1dgo0DkQ==
X-Received: by 2002:a1c:5544:: with SMTP id j65mr25700677wmb.60.1584967724024;
        Mon, 23 Mar 2020 05:48:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j39sm24686004wre.11.2020.03.23.05.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 05:48:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 9/9] KVM: SVM: Annotate svm_x86_ops as __initdata
In-Reply-To: <20200321202603.19355-10-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com> <20200321202603.19355-10-sean.j.christopherson@intel.com>
Date:   Mon, 23 Mar 2020 13:48:41 +0100
Message-ID: <874kuf9qza.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Tag svm_x86_ops with __initdata now the the struct is copied by value to

Same typo, "now that the struct".

> a common x86 instance of kvm_x86_ops as part of kvm_init().
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b61bb306602b..ab2a1cf6c188 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7350,7 +7350,7 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
>  	avic_update_access_page(kvm, activate);
>  }
>  
> -static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> +static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.hardware_unsetup = svm_hardware_teardown,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

