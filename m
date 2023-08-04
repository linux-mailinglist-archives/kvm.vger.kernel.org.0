Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9B2770BAC
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 00:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjHDWDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 18:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjHDWDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 18:03:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E8319B
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 15:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691186556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7XeJdVl8/EwMUOdjx3edZoXx1Zn1CMa9oW0ZCIdFrDM=;
        b=TeoY2YZpBF7YdrwFMyO1Zq6G86TeWDEUNNKiTdLibhBGb4nj0IJdm5P8Qy8wuRjNnJwtJz
        F50bHrMTZE6mVvu6g+6T8Ej87aifH3OWXLvDUIynuX66M/3H/nlQdEeYq6ClSm/L0g8wEp
        2UHKFVgG40wxqe0E+VxV6h2+NTCYCAo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-839X-fBmOMuc2miPac72rQ-1; Fri, 04 Aug 2023 18:02:34 -0400
X-MC-Unique: 839X-fBmOMuc2miPac72rQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5223854ef71so1660044a12.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 15:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691186553; x=1691791353;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7XeJdVl8/EwMUOdjx3edZoXx1Zn1CMa9oW0ZCIdFrDM=;
        b=jT7kmR/prDcqtZjogXKRg+G+RmYqf0hbD+6V9dp/LCk1xNcaTAkL9WIWX6QaTtBw2z
         KVavHrCXYSYEtJ/MCVnouf/ueFWhVuKLh/86q6x2JhW9bV3O0cf4Wm0ui0RyQKQljYjs
         9TWbNFEKjgan6CGi5mwEu8GDItpy9RVq9UdMi1anZgTWxqeXzaE97hYm61Y6P676R+Zw
         +UxyB7U+6us0Grjz7xELRwffWFMKx2l+lgpSKPiyAQQSJdVIrlICakUM/Glb0477w/6r
         TKPMLQOEcphcxJ+K+utudvd7c7SghjdwQcYZyOEJiz1fAwEDbF1kNOYzt4TFTPHACQ/N
         hUYA==
X-Gm-Message-State: AOJu0YzkuP6lZzOto7F4jCGXsTlJWHd/6moaTjyQig9XUGW3giOotGuq
        VrMiuEUh46TW0qrwDlru0vVKp2pxO/qe2oxgm37/5K/iNs3J4bvm5qcIYe7wTRwXa6i9rvvmGps
        v9vUYvAWRrISY
X-Received: by 2002:aa7:c6cb:0:b0:51e:309:2e11 with SMTP id b11-20020aa7c6cb000000b0051e03092e11mr2389833eds.36.1691186553785;
        Fri, 04 Aug 2023 15:02:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0tj1V215ZmqouMVSJ2M+alZff9GBiz+Yk8qF5u4t9uMgWOORSyfJG5ZAuBVk+SWA9STrj2A==
X-Received: by 2002:aa7:c6cb:0:b0:51e:309:2e11 with SMTP id b11-20020aa7c6cb000000b0051e03092e11mr2389825eds.36.1691186553557;
        Fri, 04 Aug 2023 15:02:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id e26-20020a50ec9a000000b0051873c201a0sm1780958edr.26.2023.08.04.15.02.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 15:02:32 -0700 (PDT)
Message-ID: <3075190f-d8a5-0d7d-56e9-671a2052d20f@redhat.com>
Date:   Sat, 5 Aug 2023 00:02:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 17/19] KVM:x86: Enable guest CET supervisor xstate bit
 support
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-18-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230803042732.88515-18-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/23 06:27, Yang Weijiang wrote:
>   	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
> +		u32 eax, ebx, ecx, edx;
> +
> +		cpuid_count(0xd, 1, &eax, &ebx, &ecx, &edx);
>   		rdmsrl(MSR_IA32_XSS, host_xss);
>   		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
> +		if (ecx & XFEATURE_MASK_CET_KERNEL)
> +			kvm_caps.supported_xss |= XFEATURE_MASK_CET_KERNEL;
>   	}

This is a bit hackish and makes me lean more towards adding support for 
XFEATURE_MASK_CET_KERNEL in host MSR_IA32_XSS (and then possibly hide it 
in the actual calls to XSAVE/XRSTORS for non-guest FPU).

Paolo

