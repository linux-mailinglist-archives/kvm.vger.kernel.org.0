Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA7C770B26
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 23:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjHDVlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 17:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjHDVli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 17:41:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD0EC5
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 14:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691185249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lc7ZeUSNeeQ2dg0g08+fgQtHSCaTeyofmNinP6tH5aA=;
        b=a25vzXLxuQ8zseDXOK7fKJ7zrnQapiWkmmvJTqJTEMU9wUOumQfOXbHU9Wf3OUoKaxCLmu
        FUmRVkSeQtPbwUvD24xYdarQd7dW1BMBJH/qhnc9FtwnnYkurkAR2VSbsbgtlinmdJX03Y
        abM0hMprSGMJoELRPcZw3Sn3/XxP2do=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-CpThuMikPhWk8EoqLcfkLw-1; Fri, 04 Aug 2023 17:40:48 -0400
X-MC-Unique: CpThuMikPhWk8EoqLcfkLw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-99c0fb2d4b0so173180266b.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 14:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691185247; x=1691790047;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lc7ZeUSNeeQ2dg0g08+fgQtHSCaTeyofmNinP6tH5aA=;
        b=UIw4fjoo03bsjoGO82R8jIKqCtJYDuILf2BzD7l+CuvubdsmCS4YEdkrHz5+ll1455
         /ygyo9xzdHnhtLpIwwFYj0zStPynjX0Wq9YcRYoJu7vhDJ9SrbOlHk6809yMDoVSnd5S
         ZXdWBGEVOhoR9V3/GydvreVsUCxWgIPP8rK7Masmcr9bF9z7eq2in4GdDnFJA8nsiXZa
         omz/yZ549HhGG5Ny9CpU6CZ4F9a9xtTcFrMnr1pUggZYIbUfkONbyGmGjYOG1cOO3PP4
         rVwfIc6SQ5Ds23FJ5o7hJkB/eoUKLNhGOAqWyOcHig7mRj3q+VfJF57N9bK+w7ocys5Z
         9THA==
X-Gm-Message-State: AOJu0YwJx7KgN6E4xWLeJ4oVdlnD249feKc4HES44WVScz1ej0pgi+1T
        8Zzr1ORyP2FC2WwPi2liUyuQYelC8suJhfP1ceB9M8yNKX/1hrpa5MR8t0nbiAF85XJPFxeqXOz
        /r7/HLi9FGsRq
X-Received: by 2002:a17:907:778d:b0:992:a80e:e5bd with SMTP id ky13-20020a170907778d00b00992a80ee5bdmr2638751ejc.48.1691185247132;
        Fri, 04 Aug 2023 14:40:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIkq3674mY3nO9JgXO0bDpdqD2PE3Rp7Vm7kknoZJTb4o9BS0gQ6kiAZAXZwnR3JcxMCZM0w==
X-Received: by 2002:a17:907:778d:b0:992:a80e:e5bd with SMTP id ky13-20020a170907778d00b00992a80ee5bdmr2638743ejc.48.1691185246911;
        Fri, 04 Aug 2023 14:40:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s15-20020a1709060c0f00b0098e42bef736sm1838745ejf.176.2023.08.04.14.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 14:40:46 -0700 (PDT)
Message-ID: <b5c8d8cb-90c9-dff3-7f1c-e0f669950191@redhat.com>
Date:   Fri, 4 Aug 2023 23:40:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-12-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230803042732.88515-12-weijiang.yang@intel.com>
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
> +		if (msr_info->index == MSR_KVM_GUEST_SSP)
> +			msr_info->data = vmcs_readl(GUEST_SSP);

Accesses to MSR_KVM_(GUEST_)SSP must be rejected unless host-initiated.

Paolo

