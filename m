Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C8B596D3F
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 13:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiHQLFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 07:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236234AbiHQLFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 07:05:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5177FFAB
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 04:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660734333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=koEJ17EkMuiifFe0GL3YnkhTBSC0XSjMKGEWlVUiBCE=;
        b=N5Lc+ce1/AZqlVHrzbDsn8WhDJQwWNyLkB4BdzFxqD7Tf7ydMbTnL+AuDzOD1IGa7t5i0o
        joKcbq2yA2hThKCwvc6iVehBKbtBWXn9ajnxDxVj19G7EEdJAzk8Xu1AtHoibOlPtym375
        lJ3wrqifO2G+b9+pvIYPWwdi4BZJZ+4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-228-3z7spnlnOMycnim_L1_wcw-1; Wed, 17 Aug 2022 07:05:32 -0400
X-MC-Unique: 3z7spnlnOMycnim_L1_wcw-1
Received: by mail-ed1-f70.google.com with SMTP id m22-20020a056402431600b0043d6a88130aso8492097edc.18
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 04:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=koEJ17EkMuiifFe0GL3YnkhTBSC0XSjMKGEWlVUiBCE=;
        b=efT26C2d6KrUQIKgXA83zFmeoTDreTsBKthQzLFnEJH0ap532mVZ6xWQeB6m6beslv
         /RFxFD2eQ4uBcj7OmQwdu+Wejfq6bWWmodXlMhNZ48ArOGZePktWmfVHxPECFNSvqtq1
         ZInMpxxg6hR0aJjRR3WY2U+TKGWa7wrAwps46hY/nj2LNlP58DkjH2/4PDa0rAxF3igw
         9WtMAyUdFTfPtlQ3/uBLZZ0SLwkSr7nJJnkPehmuiFu9NlZPPwbp8WqU38au6MdTDMJu
         BqylYlmxt8Ao2C7Z8J1KZVvNMxigOsZRfbrdhyb99pWuOnDM2XrLPKcmw/jjAMj/YLTV
         fLHA==
X-Gm-Message-State: ACgBeo0BzEGWy9oq7roAH5oRjAy78ndyQ77YSpjS20vPNyIQBrbTt0M+
        Et8a/jLArSqzDZo7ubWsMaPKJIr4zev3+4uIPysvvVEAZtW3TRNdzYO0AbHbjTq/HHuHarG1SbF
        oM63uwoH3u7uk
X-Received: by 2002:a17:907:628c:b0:6ee:70cf:d59 with SMTP id nd12-20020a170907628c00b006ee70cf0d59mr16435801ejc.402.1660734331597;
        Wed, 17 Aug 2022 04:05:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5c8IFWZuGKlWCZOMVH9BjRaCUp6BdLO0jPPTy5lPcG61T3LTdm8B7qsGHnDEfueWrBGv3r8Q==
X-Received: by 2002:a17:907:628c:b0:6ee:70cf:d59 with SMTP id nd12-20020a170907628c00b006ee70cf0d59mr16435788ejc.402.1660734331415;
        Wed, 17 Aug 2022 04:05:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id ky5-20020a170907778500b00738467f743dsm4322541ejc.5.2022.08.17.04.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 04:05:30 -0700 (PDT)
Message-ID: <8e675228-b140-08c8-e8d4-2bd0d1121911@redhat.com>
Date:   Wed, 17 Aug 2022 13:05:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] KVM: Rename KVM_PRIVATE_MEM_SLOTS to
 KVM_INTERNAL_MEM_SLOTS
Content-Language: en-US
To:     Chao Peng <chao.p.peng@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220816125322.1110439-1-chao.p.peng@linux.intel.com>
 <20220816125322.1110439-2-chao.p.peng@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220816125322.1110439-2-chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/16/22 14:53, Chao Peng wrote:
>   
>   #define KVM_MAX_VCPUS		16
>   /* memory slots that does not exposed to userspace */
> -#define KVM_PRIVATE_MEM_SLOTS	0
> +#define KVM_INTERNAL_MEM_SLOTS	0
>   

This line can be removed altogether.

Paolo

