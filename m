Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9824D1C3B
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347894AbiCHPrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347870AbiCHPrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:47:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65C534EF65
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646754386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bzGDmGJpxCbM4uEqV4QXfQcBGzm+1j1w3xgfxlBv/f4=;
        b=HnOa7QIPDagHkHYCINRAutghAoZq8hLYnPIB1zICZS9Dr8fKS9JtrRO+ircdImZBHKETbh
        09sopBOlGlHjQez1XNsaw+YFwI+zoqz+oxhlptGmQsPqn0bFrJcm6XlVYTCX13rx94VVJt
        FrbRiSCg22ysX48PDekWpnfm9SXjcgk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-T9Xp07qYMtefRrnO_LrjNw-1; Tue, 08 Mar 2022 10:46:25 -0500
X-MC-Unique: T9Xp07qYMtefRrnO_LrjNw-1
Received: by mail-ed1-f70.google.com with SMTP id co2-20020a0564020c0200b00415f9fa6ca8so7362784edb.6
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:46:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bzGDmGJpxCbM4uEqV4QXfQcBGzm+1j1w3xgfxlBv/f4=;
        b=YE7vanlkczg3ckN21fxNHRUVpOgb46PgeuSNf22mWlqH3xN28iHf2TNrbsuMXvJqIp
         nH0z5pdZ01UMjMwwCV9qd8lAcgbbEMdmQ8nOxdLWrM4SZLnnLXQLmv6xbqLR4r7I5H6x
         n/XA17vS160LrR8ucPXnrmxENWAgwPqWcfNQ8Z8M0Us1S9UphMmVEG8aMlw3V5Fz3fMv
         5KL03rjxsBViipUKtM3vFS6H0tu0u/CKVirym5Iwwd+jopzUeKq02D9Sp67eKvOVr+Jp
         L1lBajG5zrLOn1E2c1y2OKRSNYwppMk8pn0BGNS9QXF+1rITpS07GX8EipzdJfeoPtHW
         Oa3A==
X-Gm-Message-State: AOAM530K8KAW4Kppbw8nWshD/F0aA9LxEYp4oDnwcrYjcmSlFX62qFdR
        lCm3wUvQ+8/hACIer8RhX8ZviOLkpqnDbbQfk8vQcg8rRhN+kF9rheMQQo3KW+x13pfycSljkAG
        ANzNE2MlvYN/H
X-Received: by 2002:a17:907:7e8f:b0:6da:6352:a7be with SMTP id qb15-20020a1709077e8f00b006da6352a7bemr13429177ejc.612.1646754384086;
        Tue, 08 Mar 2022 07:46:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeMp4IiwCfpJRqOKouV/rQe4lv6DhQxtL0waI4sfR3YSuHTXI0JZZdNdvjjC/HkprevrRp3w==
X-Received: by 2002:a17:907:7e8f:b0:6da:6352:a7be with SMTP id qb15-20020a1709077e8f00b006da6352a7bemr13429157ejc.612.1646754383827;
        Tue, 08 Mar 2022 07:46:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g16-20020a170906521000b006d58773e992sm6001721ejm.188.2022.03.08.07.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 07:46:23 -0800 (PST)
Message-ID: <33d32545-00b4-ea14-725f-bd5e42c63a30@redhat.com>
Date:   Tue, 8 Mar 2022 16:46:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86/pmu: Use different raw event masks for AMD and
 Intel
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <20220308012452.3468611-1-jmattson@google.com>
 <01af48ad-fee3-603a-7b14-5a0ae52bb7f9@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <01af48ad-fee3-603a-7b14-5a0ae52bb7f9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 11:28, Like Xu wrote:
> On 8/3/2022 9:24 am, Jim Mattson wrote:
>> The third nybble of AMD's event select overlaps with Intel's IN_TX and
>> IN_TXCP bits. Therefore, we can't use AMD64_RAW_EVENT_MASK on Intel
>> platforms that support TSX.
> 
> We already have pmu->reserved_bits as the first wall to check "can't use".
> 
>>
>> Declare a raw_event_mask in the kvm_pmu structure, initialize it in
>> the vendor-specific pmu_refresh() functions, and use that mask for
>> PERF_TYPE_RAW configurations in reprogram_gp_counter().
>>
>> Fixes: 710c47651431 ("KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for 
>> PERF_TYPE_RAW")
> 
> Is it really a fix ?

No, it's not, so I'm queuing it for 5.18 only.

Paolo

