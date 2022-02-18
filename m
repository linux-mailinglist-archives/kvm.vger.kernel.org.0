Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADA34BBE49
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbiBRRXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:23:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbiBRRXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:23:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93BB7120574
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645205008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLmxSPunZdkKjVW0sxyYdXHyDxLpVVtwITCTa0ESLxY=;
        b=VWcHXHkeQ5XwyCp/mxDus7JZW1eqnhMm91nP9Gpv9MJc9lVz60iqf4Ikz5nCwzp6j6AMio
        Lf7XGDwERsDYARdZf7IXDkga+PRiFlNGFbnHElH6nodDoitP7grThMbnZHKdsaNfeEH3cq
        vHicfg3WXjfG/iyDqlhzuAd+SITbK0Q=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-5VPz-Hu4PGKthnIUVtC7lw-1; Fri, 18 Feb 2022 12:23:27 -0500
X-MC-Unique: 5VPz-Hu4PGKthnIUVtC7lw-1
Received: by mail-ej1-f69.google.com with SMTP id qf24-20020a1709077f1800b006ce8c140d3dso3353774ejc.18
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:23:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wLmxSPunZdkKjVW0sxyYdXHyDxLpVVtwITCTa0ESLxY=;
        b=e9Xylcb/uPL1Rx3lNFe1vd9AR7Hf93AEmqG49+KyCDWVbUEw2GVsKz2rk9N87l8+ZE
         mD5xGhzFim+m+XElICVA2Yi2urISwTGJlPlhiKmMiYBXPCEbGqJftWQFL0qEi8BBk5bY
         9LVujdxnpfGoiDG6G1ipw9FbJUTd/aT04Y+UPZzTWW+TFs02om5bmdk3En/wkPiopY3W
         B259qvDmKblB7qZbR1FW/ZsBya0u68ru5heYA5OHuoXI10c91Hw1vb5Sw90KAMC9eBYA
         SXM2tyGJ86Jf4V9qO33lE4l3V1j14mTo89ivs8KR/OoEjfaeVpFco1eDPsfYdNh97Tz/
         iDfQ==
X-Gm-Message-State: AOAM530r0KNuyh41IYosJS9qfqzH6Mde9FSLhYoY7ObJUD7SyX9O50pY
        I+aAeE+K0ZmEwjJSSYburW6ae+zkfe1eql+8uiQK4kLoO60yjEB3mbXkFZ6zvIFnR8TSfOT5shp
        /JyZE2bxKRCl+
X-Received: by 2002:a05:6402:2744:b0:404:ba60:fec6 with SMTP id z4-20020a056402274400b00404ba60fec6mr9180011edd.235.1645205005949;
        Fri, 18 Feb 2022 09:23:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzdIaWlXASY65HPZXhodkvuJC5wJqCuuyoymnUNW/je7psQin+hEy5z4WOcHvtLjzv6WrXDMQ==
X-Received: by 2002:a05:6402:2744:b0:404:ba60:fec6 with SMTP id z4-20020a056402274400b00404ba60fec6mr9179996edd.235.1645205005723;
        Fri, 18 Feb 2022 09:23:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b19sm1466874edd.91.2022.02.18.09.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 09:23:25 -0800 (PST)
Message-ID: <db3e3781-0ae8-7392-b899-b386f4df0368@redhat.com>
Date:   Fri, 18 Feb 2022 18:23:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 03/18] KVM: x86/mmu: WARN if PAE roots linger after
 kvm_mmu_unload
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-4-pbonzini@redhat.com> <Yg/UCQggoKQ27pVm@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yg/UCQggoKQ27pVm@google.com>
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

On 2/18/22 18:14, Sean Christopherson wrote:
> Checkpatch doesn't like it, and IMO the existing asserts
> are unnecessary.

I agree that removing the assertions could be another way to go.

A third and better one could be to just wait until pae_root is gone.  I 
have started looking at it but I would like your opinion on one detail; 
see question I posted at 
https://lore.kernel.org/kvm/7ccb16e5-579e-b3d9-cedc-305152ef9b8f@redhat.com/.

For now I'll drop this patch.

Paolo

