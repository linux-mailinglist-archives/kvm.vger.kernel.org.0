Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEAD50095E
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 11:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241553AbiDNJLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 05:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237602AbiDNJLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 05:11:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 172846E359
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 02:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649927330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXK01xwL5FfymBT2O/wpbjGm/1sDlFHcoIHw2SavFDU=;
        b=QysLLuvY3cd+YKWYSHCFG8D3GjXzVC1h68M7zupw2QdjESsWHjzdx0qQx9LiG1uPGVd7mc
        RZcuDq0S9t/EMJVrWyILaTLhsWVsz292wK5Vy5TEJF7NjAmS/+1LHk4EDpet/LOpYpmVO8
        WQbG9SStZiOHAjJYj39IscBoIbumjAU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-LnI72VKbPG6dy7Lfmln2Hw-1; Thu, 14 Apr 2022 05:08:48 -0400
X-MC-Unique: LnI72VKbPG6dy7Lfmln2Hw-1
Received: by mail-wm1-f70.google.com with SMTP id 6-20020a1c0206000000b0038ff4f1014fso783892wmc.7
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 02:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EXK01xwL5FfymBT2O/wpbjGm/1sDlFHcoIHw2SavFDU=;
        b=ArUjT+jhnbJNfpBp+b6X3ZVqTh50mxkkpxoImd1dXmUMtgne7Kdgt6YtObxcuyv2Hk
         RKSf5dt88McnFyOnuxXictoOUU+GGiMN+GOYQuOOWUQm8XD3TTZUZ8f28YVf0yfQ8oxs
         XbWSka/mOlPoTwNr0p/q1QfSv8cgXy1qh+4XtBKzgtwedm7lQXTq2/rhoaqOluMWGIpv
         u+ctIxDQz3q+zxl9p3Ool1YA+qXIG+dY0yjc6vQST+rEo3ADjfyYxsBYxCGDI7b4HU7x
         9Wq74ZGPkDPBiafOelAWZLNIi31PyzmDdicONCrpf7goHbnm4+FGLgCpqWEvtcrGU1Kn
         EOxQ==
X-Gm-Message-State: AOAM531gHCnPH000WzECkQ7Zknxw04Q5lQaZ68nPmhXyGTWt5WxLWov+
        DXGkjnXFIJQLWYTwGvQ4LbEAuAUMA66P6w5uso5puJtXylK2/1WMq3WIyf6TNuFL6v2D/Mh5CoZ
        M6UO6hQOTM+eE
X-Received: by 2002:a5d:64a5:0:b0:205:8e66:e9b1 with SMTP id m5-20020a5d64a5000000b002058e66e9b1mr1312052wrp.464.1649927327738;
        Thu, 14 Apr 2022 02:08:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAXM3iNNx7LZYO7MKlv+Z8ZcSXxb0BvT2R6br6VU+ZZLHt08JHqpN2CnaubzNSWxNIqo5rdQ==
X-Received: by 2002:a5d:64a5:0:b0:205:8e66:e9b1 with SMTP id m5-20020a5d64a5000000b002058e66e9b1mr1312028wrp.464.1649927327531;
        Thu, 14 Apr 2022 02:08:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b0038cbd8c41e9sm4947976wmq.12.2022.04.14.02.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 02:08:46 -0700 (PDT)
Message-ID: <683974e7-5801-e289-8fa4-c8a8d21ec1b2@redhat.com>
Date:   Thu, 14 Apr 2022 11:08:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH V3 3/4] KVM: X86: Alloc role.pae_root shadow page
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
 <20220330132152.4568-4-jiangshanlai@gmail.com> <YlXrshJa2Sd1WQ0P@google.com>
 <CAJhGHyD-4YFDhkxk2SQFmKe3ooqw_0wE+9u3+sZ8zOdSUfbnxw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAJhGHyD-4YFDhkxk2SQFmKe3ooqw_0wE+9u3+sZ8zOdSUfbnxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/22 11:07, Lai Jiangshan wrote:
>> I don't think this will work for shadow paging.  CR3 only has to be 32-byte aligned
>> for PAE paging.  Unless I'm missing something subtle in the code, KVM will incorrectly
>> reuse a pae_root if the guest puts multiple PAE CR3s on a single page because KVM's
>> gfn calculation will drop bits 11:5.
> 
> I forgot about it.


Isn't the pae_root always rebuilt by

         if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
                 kvm_mmu_free_roots(vcpu->kvm, mmu, KVM_MMU_ROOT_CURRENT);

in load_pdptrs?  I think reuse cannot happen.

Paolo

