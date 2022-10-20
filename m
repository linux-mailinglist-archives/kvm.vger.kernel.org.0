Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B6260599C
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 10:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiJTIWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 04:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiJTIWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 04:22:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DEE171CFF
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 01:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666254145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NXxC5THgAjtEYfgbLwABUhO1u5EsuU0JRYrQfyg0GwE=;
        b=GSTGPFRV0HIksq6uiqH5BHD31Mfm4kGsbNEBEH+2UcO6JTa76uhqRUoF2JWsH/s3R60Klx
        HxDS5ztEGny7ZFnjpF9POITdKn99Ia6gCF226/Tfag45FhMx16YbkjsN/zIqE0V+muWucP
        8ZtToTFJXqk/GOUaSjBLGNy7EF2EAA0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-Dp48Nrj5M_C6PRbyFV0GDg-1; Thu, 20 Oct 2022 04:22:23 -0400
X-MC-Unique: Dp48Nrj5M_C6PRbyFV0GDg-1
Received: by mail-ej1-f72.google.com with SMTP id xj11-20020a170906db0b00b0077b6ecb23fcso9082986ejb.5
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 01:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NXxC5THgAjtEYfgbLwABUhO1u5EsuU0JRYrQfyg0GwE=;
        b=grYHHTsDeWXdauOtLlyiHtrov1NIKlwoFs/Tws/Z9fctGgrV0E34TpT2hH9NgRnUUe
         BRVefpzgMMMavKIhu6bduwwWxeLw6va8/xtVVarSQ6nQEujPwNB8nAN+JzrA4LowCd0W
         ooY3zkKB9WYAp16ut5Y/vfEhsrk7rg2n+e1/+RDN1hN/oVBAjFhwD6fdc/6HZSBtJyhf
         lFdEYLUd0xOtZU0p8sjjrtLkYCz7UqtEM/ANCsqKsx8du1YH73MWADQZjEmwvV1u3sAt
         6MaVQj5byak6gOre6BhTmT/QodWiCEBMx7OjIw3KqtZuuxvMaaE+4fFCz4QMLhI/zWhL
         NySA==
X-Gm-Message-State: ACrzQf1rDxQdVCipOhPETXDZ0L+LFbPwvjEXUdzg7/npbNLvvoptbWll
        IgCU9fgBgdb7O8pHkFoIMvzqUlG/2qLZUTFiLIC3tZ9GyykXevMs6tJKLzdyS8l+jMj00LIMvA6
        bRoyYj2IUu9ek
X-Received: by 2002:a17:907:971c:b0:78e:63f:c766 with SMTP id jg28-20020a170907971c00b0078e063fc766mr9957387ejc.330.1666254141383;
        Thu, 20 Oct 2022 01:22:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM77hNuYpdTNzaBxaGl4qanwjEest2MmHQgxj9LIOEFNPTGkaoTFS2OSELTfyljEa7SX2DQbRw==
X-Received: by 2002:a17:907:971c:b0:78e:63f:c766 with SMTP id jg28-20020a170907971c00b0078e063fc766mr9957379ejc.330.1666254141175;
        Thu, 20 Oct 2022 01:22:21 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t14-20020a05640203ce00b00459e3a3f3ddsm11633580edw.79.2022.10.20.01.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 01:22:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 00/46] KVM: x86: hyper-v: Fine-grained TLB flush +
 L2 TLB flush features
In-Reply-To: <Y1B4kAIsc8Z0b2P9@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <Y1B4kAIsc8Z0b2P9@google.com>
Date:   Thu, 20 Oct 2022 10:22:19 +0200
Message-ID: <87v8oedhvo.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Oct 04, 2022, Vitaly Kuznetsov wrote:
>> Changes since v10 (Sean):
>> - New patches added:
>>   - "x86/hyperv: Move VMCB enlightenment definitions to hyperv-tlfs.h"
>>   - "KVM: selftests: Move "struct hv_enlightenments" to x86_64/svm.h"
>>   - "KVM: SVM: Add a proper field for Hyper-V VMCB enlightenments"
>>   - 'x86/hyperv: KVM: Rename "hv_enlightenments" to "hv_vmcb_enlightenments"'
>>   - 'KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"'
>>   - "KVM: x86: Move clearing of TLB_FLUSH_CURRENT to kvm_vcpu_flush_tlb_all()"
>>   - "KVM: selftests: Drop helpers to read/write page table entries"
>>   - "KVM: x86: Make kvm_hv_get_assist_page() return 0/-errno"
>> - Removed patches:
>>   - "KVM: selftests: Export _vm_get_page_table_entry()"
>> - Main differences:
>>   - Move Hyper-V TLB flushing out of kvm_service_local_tlb_flush_requests().
>>     On SVM, Hyper-V TLB flush FIFO is emptied from svm_flush_tlb_current()
>>   - Don't disable IRQs in hv_tlb_flush_enqueue().
>>   - Don't call kvm_vcpu_flush_tlb_guest() from kvm_hv_vcpu_flush_tlb() but
>>     return -errno instead.
>>   - Avoid unneded flushes in !EPT/!NPT cases.
>>   - Optimize hv_is_vp_in_sparse_set().
>>   - Move TLFS definitions to asm/hyperv-tlfs.h.
>>   - Use u64 vals in Hyper-V PV TLB flush selftest + multiple smaler changes
>>   - Typos, indentation, renames, ...
>
> Some nits throughout, but nothing major.  Everything could be fixed up when
> applying, but if it's not too much trouble I'd prefer a v11, the potential changes
> to kvm_hv_hypercall_complete() aren't completely trivial.

Thanks for the review! Let me do v12 to address your comments, I plan to
do it tomorrow.

-- 
Vitaly

