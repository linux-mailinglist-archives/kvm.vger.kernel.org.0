Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3D55E550E
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiIUVQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiIUVQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:16:44 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6E2A00E3
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:16:42 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id e5so7265313pfl.2
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=sh4nf/tEmUd1miKJn6/kAcl9Wj3E8kd7WVZbt4jNU8o=;
        b=ogBoxO3LrxwqQQ7SRIVuERoVZE6Gdagy1dx3mdn2ut0gBZE9tATELfzGad5xs2nkXy
         iOis2gAR0XFaycsbSWI7J84SkuLJXjevcZwhGG+l06YQ215B0SJ4oHKY3LiMVPwdNE6e
         8tnQgmJkM1gaEGfkkJfJiL1eOBW4HMp219Dh6GKkU0c3ltuwMqkhLiaxgRd7nHYkrLyG
         SFeJUscRP74uqSPopi6C6W7kl8FHwpp2AHzCcRG758pCQLNNRYFYaPNO72HR9ntReZ2v
         2GnHQX3jnhG2RMgsUI5S5rQD3k+GMsGiUGcpEp0wRWFIu78f9dNdgxsN1SnHTVVOu/Uf
         DhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=sh4nf/tEmUd1miKJn6/kAcl9Wj3E8kd7WVZbt4jNU8o=;
        b=K3n5sOUDNIHwCYaK/5F4bFCasG1sjXd6Il30pljROlynveddGdYQRTQdRzq5RphD9s
         bTl+R9CSjzv8BGUuMJjqvFdlsj7a5Z1PRpCj9sg8bmpyn/tu9z6/pm+CtPo0L+YR4nC3
         uK9PXM9XthbJZBx2Qf+xeJGXVH3XxQ20rowbjSXkS2hSf/lyc0+6C+k1UOJuEzLSpDXX
         Xsjdpt+WQ+4TWl/zcflt5CB/HNGq1ktwo92mvxat+pWaqZc43nvJtbhat0iGWi6egCP2
         8tCJ4UmEWr2oDCDkSV5aqdV91vgAqAyvJ625LI1uTKxX7j3a846iBx75mmNAeBpPZBp1
         45Ag==
X-Gm-Message-State: ACrzQf12iPVr0ia2EUrT5bFjaV0Mc3Uy9TmHOc7IbMMupNuwqNEJBj4j
        3yU1SIZPbYvSIFU0sn49SGwC/g==
X-Google-Smtp-Source: AMsMyM7gUWK7/YOwc4h5OK29M6VGYSvbsUATTBbOxYuD/sb6e6iIXhXseR+CdxxwL9TdRz+8Zk5pUA==
X-Received: by 2002:a63:581d:0:b0:42b:399:f15a with SMTP id m29-20020a63581d000000b0042b0399f15amr106401pgb.337.1663795002163;
        Wed, 21 Sep 2022 14:16:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n2-20020a634d42000000b0042a55fb60bbsm2337315pgl.28.2022.09.21.14.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:16:41 -0700 (PDT)
Date:   Wed, 21 Sep 2022 21:16:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 14/39] KVM: nSVM: Keep track of Hyper-V
 hv_vm_id/hv_vp_id
Message-ID: <Yyt/Nrh4aoLrNt11@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-15-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921152436.3673454-15-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> Similar to nSVM, KVM needs to know L2's VM_ID/VP_ID and Partition
> assist page address to handle L2 TLB flush requests.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/hyperv.h | 16 ++++++++++++++++
>  arch/x86/kvm/svm/nested.c |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index 7d6d97968fb9..8cf702fed7e5 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -9,6 +9,7 @@
>  #include <asm/mshyperv.h>
>  
>  #include "../hyperv.h"
> +#include "svm.h"
>  
>  /*
>   * Hyper-V uses the software reserved 32 bytes in VMCB
> @@ -32,4 +33,19 @@ struct hv_enlightenments {
>   */
>  #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
>  
> +static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct hv_enlightenments *hve =
> +		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;

Eww :-)

I posted a small series to fix the casting[*], and as noted in the cover letter it's
going to conflict mightily.  Ignoring merge order for the moment, looking at the
series as a whole, if the Hyper-V definitions are moved to hyperv-tlfs.h, then I'm
tempted to say there's no need for svm/hyperv.h.

There should never be users of this stuff outside of svm/nested.c, and IMO there's
not enough stuff to warrant a separate set of files.  nested_svm_hv_update_vp_assist()
isn't SVM specific and fits better alongside kvm_hv_get_assist_page().

That leaves three functions and ~40 lines of code, which can easily go directly
into svm/nested.c.

I'm definitely not dead set against having hyperv.{ch}, but unless there's a high
probability of SVM+Hyper-V getting to eVMCS levels of enlightenment, my vote is
to put these helpers in svm/nested.c and move then if/when we do end up accumulating
more SVM+Hyper-V code.
  
As for merge order, I don't think there's a need for this series to take a
dependency on the cleanup, especially if these helpers land in nested.c.  Fixing
up the casting and s/hv_enlightenments/hv_vmcb_enlightenments is straightforward.

[*] https://lore.kernel.org/all/20220921201607.3156750-1-seanjc@google.com
