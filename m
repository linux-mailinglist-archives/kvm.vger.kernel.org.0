Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2962500786
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbiDNHuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbiDNHuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:50:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 163FDF3
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hLR76CNlBvCn367FjMy29XVyfR2fU9onpgPKm9lbY1c=;
        b=c0rSiyZ0ME/HiilHlbtK5rFQ6vq7PexU0xxWEkQyHOc8JyzTTUCYBEF0GqPaVYXn4o5voZ
        I7sHHh9xqKDNOeBwFQfBZMRvqfFUQ1YfXOmvRTep+JjntzenpzXPXkCe7wy2AkupRncb4W
        LAdx2ibVYUo5QP3QhjxbwUqdvHbdB0g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-HnhzIOE0OZG52jhu8kpTVA-1; Thu, 14 Apr 2022 03:47:33 -0400
X-MC-Unique: HnhzIOE0OZG52jhu8kpTVA-1
Received: by mail-wm1-f71.google.com with SMTP id az27-20020a05600c601b00b0038ff021c8a4so1466055wmb.1
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:47:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=hLR76CNlBvCn367FjMy29XVyfR2fU9onpgPKm9lbY1c=;
        b=EGzPdKbByvVGSUuXIOTnOZ6MXoSmw1AC858CXCRvIQf1USZEHiRwG5R63ved4gbPID
         lOahKhmuO6LnBaThYMAaOY20enQ8fSs19ZUiyxZHq/F+DwXNwFj1hdHQY0JQFvEa02Re
         CJpFXeGjvZjCXyGixnL2s1s4cJpR+EFUDnYhKKhK0Z9PGkGEYnoR8d0bxUUDagNQptyQ
         SCIIR7PjFm+2nSEEALw7L703XMNgSzrLexpGC9PZFQZeyTGYQ+GlNMxyWCz1snwoywW1
         Tu4Nru5i+I07TL7OXvl44yQASVd7y8llqbKPHflQkuSoDL18m5UuWfAdXzDwK/RFatbK
         LCoA==
X-Gm-Message-State: AOAM531xzvTAnoqYek1prEk4MlMRHY2nbnRDW5pt50dhPT0/SaLUXj9I
        y48qxgufQ+OorGIwqNjft/Uene9rykFKkc8Dj6CnB/OeZocyIpd9+fqd2Q87s+kAxwGUbPd2OfT
        yGNiZRoiu8Hqh
X-Received: by 2002:a05:6000:1684:b0:209:7fda:e3a with SMTP id y4-20020a056000168400b002097fda0e3amr996958wrd.709.1649922452678;
        Thu, 14 Apr 2022 00:47:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEJVPZguqe+57EiWbrcBRp0bTCz82V4YapmfmKU9u/wpnFSTs9cs8DetLk5K/Yq5vV4Bkr4Q==
X-Received: by 2002:a05:6000:1684:b0:209:7fda:e3a with SMTP id y4-20020a056000168400b002097fda0e3amr996947wrd.709.1649922452438;
        Thu, 14 Apr 2022 00:47:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n42-20020a05600c3baa00b0038ffadd6e4asm169831wms.30.2022.04.14.00.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 00:47:31 -0700 (PDT)
Message-ID: <2939c0cb-8e0c-7de4-7143-2df303bbb542@redhat.com>
Date:   Thu, 14 Apr 2022 09:47:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 00/22] https://www.spinics.net/lists/kvm/msg267878.html
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
References: <20220414074000.31438-1-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Uh-oh, wrong subject.  Should be "KVM MMU refactoring part 2: role changes".

Supersedes: <20220221162243.683208-1-pbonzini@redhat.com>

Paolo

On 4/14/22 09:39, Paolo Bonzini wrote:
> Right now the "MMU role" is a messy mix of the shadow page table format
> and the CPU paging mode (CR0/CR4/EFER, SMM, guest mode, etc).  Whenever
> something is different between the MMU and the CPU, it is stored as an
> extra field in struct kvm_mmu; for extra bonus complication, sometimes
> the same thing is stored in both the role and an extra field.
> 
> This series cleans up things by putting the two in separate fields,
> so that the "MMU role" represents exactly the role of the root page.
> This in turn makes it possible to eliminate various fields that are
> now redundant with either the CPU or te MMU role.
> 
> These patches have mostly been posted and reviewed already[1], and I
> have now retested them on top of kvm/next.
> 
> Paolo
> 
> [1] https://patchew.org/linux/20220221162243.683208-1-pbonzini@redhat.com/
> 
> Paolo Bonzini (21):
>    KVM: x86/mmu: nested EPT cannot be used in SMM
>    KVM: x86/mmu: constify uses of struct kvm_mmu_role_regs
>    KVM: x86/mmu: pull computation of kvm_mmu_role_regs to kvm_init_mmu
>    KVM: x86/mmu: rephrase unclear comment
>    KVM: x86/mmu: remove "bool base_only" arguments
>    KVM: x86/mmu: split cpu_role from mmu_role
>    KVM: x86/mmu: do not recompute root level from kvm_mmu_role_regs
>    KVM: x86/mmu: remove ept_ad field
>    KVM: x86/mmu: remove kvm_calc_shadow_root_page_role_common
>    KVM: x86/mmu: cleanup computation of MMU roles for two-dimensional
>      paging
>    KVM: x86/mmu: cleanup computation of MMU roles for shadow paging
>    KVM: x86/mmu: store shadow EFER.NX in the MMU role
>    KVM: x86/mmu: remove extended bits from mmu_role, rename field
>    KVM: x86/mmu: rename kvm_mmu_role union
>    KVM: x86/mmu: remove redundant bits from extended role
>    KVM: x86/mmu: remove valid from extended role
>    KVM: x86/mmu: simplify and/or inline computation of shadow MMU roles
>    KVM: x86/mmu: pull CPU mode computation to kvm_init_mmu
>    KVM: x86/mmu: replace shadow_root_level with root_role.level
>    KVM: x86/mmu: replace root_level with cpu_role.base.level
>    KVM: x86/mmu: replace direct_map with root_role.direct
> 
> Sean Christopherson (1):
>    KVM: x86: Clean up and document nested #PF workaround
> 
>   arch/x86/include/asm/kvm_host.h |  19 +-
>   arch/x86/kvm/mmu.h              |   2 +-
>   arch/x86/kvm/mmu/mmu.c          | 376 ++++++++++++++------------------
>   arch/x86/kvm/mmu/paging_tmpl.h  |  14 +-
>   arch/x86/kvm/mmu/tdp_mmu.c      |   4 +-
>   arch/x86/kvm/svm/nested.c       |  18 +-
>   arch/x86/kvm/svm/svm.c          |   2 +-
>   arch/x86/kvm/vmx/nested.c       |  15 +-
>   arch/x86/kvm/vmx/vmx.c          |   2 +-
>   arch/x86/kvm/x86.c              |  33 ++-
>   10 files changed, 219 insertions(+), 266 deletions(-)
> 

