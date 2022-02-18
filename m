Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA12A4BBFC9
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 19:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbiBRSrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 13:47:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiBRSrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 13:47:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48B4D12AC3
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645210011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j4AtUKdetjfbUWDMIVmKhaD+IokO5XwjAf4ZeGwgD5o=;
        b=E5hDTvi1kINeQjElv13278gp3KAhL6LJtTMG6mWLSPUwiiybVDm1F7bV4XoSpabUMMlzzQ
        nZwmZumZ1A6CDZng6lmj9HCMavv0/TKEvN2e8Ni2wpsvRKV/yS0KB9rljh06W+sx/G9uPT
        0PfYd+dEA3505YdikZN9IyjD+rcn07s=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-sLBLRU7XONClf3f08lamNA-1; Fri, 18 Feb 2022 13:46:49 -0500
X-MC-Unique: sLBLRU7XONClf3f08lamNA-1
Received: by mail-ed1-f70.google.com with SMTP id s7-20020a508dc7000000b0040f29ccd65aso6046137edh.1
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 10:46:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j4AtUKdetjfbUWDMIVmKhaD+IokO5XwjAf4ZeGwgD5o=;
        b=0aOAZCPX84hByabLgyFOXreM6V1+rgfJhRH2zWaUt7qDJP2ryHkJfxgMGGjM1Dqhao
         DBuwGa1EqYp1PXE1dpmFZcEB/V0Rgh+gYDt771P+a2zS8h9Au9rr55LOV9JkD/oH3JKA
         B8hmtLNu1yNE+tT4szf9qU/CqdliqnOh8SS/KO1X8JQcEnip7hBr/DJXXUbq6W1zd3ig
         hQ2qOjppl/8oKbjGnNjvmkhYorK99HbE+VDCG6oVJMDfJBthxP4FoF7PoZhMjKmqcTxD
         TF2tOZ/hEzfmccUjeCaWauzFQdVHuO7S+T8uD1Vo5grrNCfXxL53r7uIbBCWrlW5FMJh
         bRxQ==
X-Gm-Message-State: AOAM530QmBsJoG4mlLF/3G2i0EHEEedsXYMxngGWd9tMa0wvh7qUeuDY
        HUAYK41ATfbVRRt/SRuYulcpY99LnCjLVclS9j0brxls/n0gDrOOIYyLNoJsB6zPhrq0Wi0SFdh
        3ylod9FFkF3Ro
X-Received: by 2002:a50:c082:0:b0:402:c2dd:5567 with SMTP id k2-20020a50c082000000b00402c2dd5567mr9769567edf.113.1645210008656;
        Fri, 18 Feb 2022 10:46:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqzh/mZWjIeLwSt0SDcmglddr5v+ON2zOTKVj74G+ah3yUrrEbyn4yp0hjVEDGrhAorl500Q==
X-Received: by 2002:a50:c082:0:b0:402:c2dd:5567 with SMTP id k2-20020a50c082000000b00402c2dd5567mr9769554edf.113.1645210008412;
        Fri, 18 Feb 2022 10:46:48 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j9sm2491562ejo.106.2022.02.18.10.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 10:46:47 -0800 (PST)
Message-ID: <219937f8-6b49-47db-4ecf-f354b110da1c@redhat.com>
Date:   Fri, 18 Feb 2022 19:46:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 07/18] KVM: x86/mmu: Do not use guest root level in
 audit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-8-pbonzini@redhat.com> <Yg/nc1jjtUD2fhOR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yg/nc1jjtUD2fhOR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 19:37, Sean Christopherson wrote:
> Since I keep bringing it up...
> 
> From: Sean Christopherson<seanjc@google.com>
> Date: Fri, 18 Feb 2022 09:43:05 -0800
> Subject: [PATCH] KVM: x86/mmu: Remove MMU auditing
> 
> Remove mmu_audit.c and all its collateral, the auditing code has suffered
> severe bitrot, ironically partly due to shadow paging being more stable
> and thus not benefiting as much from auditing, but mostly due to TDP
> supplanting shadow paging for non-nested guests and shadowing of nested
> TDP not heavily stressing the logic that is being audited.
> 
> Signed-off-by: Sean Christopherson<seanjc@google.com>

Queued, thanks. O:-)

Paolo

