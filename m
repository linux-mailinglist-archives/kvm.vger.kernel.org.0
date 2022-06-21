Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A8455338B
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 15:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351628AbiFUN3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 09:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351597AbiFUN2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 09:28:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9FA125C64
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 06:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655817861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u736UGku/JrRJ1DksO+V4OLlrYIRIw9y+gv92kWBcJM=;
        b=IuMxgONpExw7RBnnK/cC9wGbnTcWbCFvoOKnND2sIqdZA2OaE+IySx+dDz3cqpHPdIP3xV
        kUfe8r9OC82VULiTWCAx9++xN3DV42NJZJA18+8huu3yxn3O8B+9dQ779/ekzd7bkezDHJ
        45+ydW9qLt4I+IvoT0SebLyhUKUaolw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-unVYpwhNNSyatNiFKHB7vw-1; Tue, 21 Jun 2022 09:24:19 -0400
X-MC-Unique: unVYpwhNNSyatNiFKHB7vw-1
Received: by mail-wm1-f71.google.com with SMTP id m22-20020a7bcb96000000b0039c4f6ade4dso4298681wmi.8
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 06:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=u736UGku/JrRJ1DksO+V4OLlrYIRIw9y+gv92kWBcJM=;
        b=JaR8Jxl3LAA0zbCFR6jCBoBuJENBQPIr9Bp+9EhlbD3bmudmUVpHsOwGKL9ZYkv9f3
         OsIgofEyIJcw3EYhigZkZtSE10E9WVzATuqIP4ajCckiEuZou2iH2E//vBI3iWJ2ay3F
         1I/HfJ75M+hKta6ikyDuWigHcoQqwdsaKwrb75zEtTJRJeuAgCtI50kWLomq2inUZ1pu
         we36N7QLmyAgYwT24EKmbxFFAQVrIgsEp7Y2fmWEPGirp0OM2J6wNcnv6MMnYjwItEqK
         4lAE6/9VK2l3EYowWeP6h/IMI6U2s359dJr5CBbmwsysEEMkiIgFt/clNW6kKzD2xyVo
         Xl0w==
X-Gm-Message-State: AOAM531tWsQfYW3cWMiF5kszjXIOt7NztK8Cub9vzb2gw7ubklQmMx4k
        +Bldi+YjPm9ZhHQUm8/CqlPaCLm/+II8C0+JoeZuJ3NxFGi3xBjjlw8hItbvpso6R9bWKXzXCzc
        Qn+VPTuuIyYNB
X-Received: by 2002:a05:600c:1f05:b0:39c:51c6:7c85 with SMTP id bd5-20020a05600c1f0500b0039c51c67c85mr41896734wmb.33.1655817858755;
        Tue, 21 Jun 2022 06:24:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2vHsz7ni0WNOKWRzoORK2MuOU/fyqYFPbMjIK0vgwy2HJOf9+5BNaiEvUfNHK0WjXot0RhQ==
X-Received: by 2002:a05:600c:1f05:b0:39c:51c6:7c85 with SMTP id bd5-20020a05600c1f0500b0039c51c67c85mr41896715wmb.33.1655817858571;
        Tue, 21 Jun 2022 06:24:18 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e7-20020a5d5947000000b0021b95bcaf7fsm2737151wri.59.2022.06.21.06.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 06:24:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 17/39] KVM: x86: hyper-v: L2 TLB flush
In-Reply-To: <e22c7352-bafa-3ebf-c842-ed706579a619@redhat.com>
References: <20220613133922.2875594-1-vkuznets@redhat.com>
 <20220613133922.2875594-18-vkuznets@redhat.com>
 <e22c7352-bafa-3ebf-c842-ed706579a619@redhat.com>
Date:   Tue, 21 Jun 2022 15:24:17 +0200
Message-ID: <87wnda40am.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 6/13/22 15:39, Vitaly Kuznetsov wrote:
>> -	tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu);
>> +	tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu, is_guest_mode(vcpu));
>>   
>
> Any reason to add this parameter?  

Yes) Other users (all from kvm_hv_flush_tlb()) set this parameter based
on whether the calling vCPU (*not* the destination vCPU, which is the
first parameter) is in guest mode or not.

> It is always set to is_guest_mode(vcpu) and, even if it wasn't, I
> would add the parameter directly in patch 11.

I can move to Patch11 if necessary.

-- 
Vitaly

