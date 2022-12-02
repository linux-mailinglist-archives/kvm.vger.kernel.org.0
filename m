Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F046F640DC5
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiLBSrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbiLBSrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:47:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E499B13CFA
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670006754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4szkQtGyRqLWDiAN3PJMU/y3rPjptoUyxR56C1SDVfE=;
        b=MV0FWIHOOOx1kJV+GAJVNgI/DWGd1D1xTZdc+VdsasKbPyWLuDny9cxzHE4TxwuH8Wm8kY
        ja3XiFscIJyCQR1T2tAa07HnkKeQiQAYSIyW5PUkhJuSW5IbGDj8kRuebKTfoBF34H1bNy
        oAvvY8iBzOE4d6h7mzT6ezBAoa5Tn4Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-127-mGv1YIZNP7i1ibIeTjFXIA-1; Fri, 02 Dec 2022 13:45:47 -0500
X-MC-Unique: mGv1YIZNP7i1ibIeTjFXIA-1
Received: by mail-wm1-f71.google.com with SMTP id bi19-20020a05600c3d9300b003cf9d6c4016so4509759wmb.8
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:45:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4szkQtGyRqLWDiAN3PJMU/y3rPjptoUyxR56C1SDVfE=;
        b=LQP3xkMfjQPuXGQCWPMQz1LLcJytx7n90EaK11HYb2gs4zooXmeZJMngRbWKnZO9WV
         RUs7keufnoYH265yzH9FuiRw7Wt34t5jgNgYinlVLXHg3fO/Aj7xQkmzSf+c3H45ue6h
         2DyQbNhNAl45WYDx0+gZwXkpNgrMxi7EBYiDsdjLl50O/R2soIGqdXYPx5ZILbapuQ2t
         w04XhtwVUCEuXC1SFWVp0o8M6BscUrOn+ZG7n7Ywmt0z/D1yhupOJWNt7eb35B9CuUbo
         dqkBJqIxfepZrR2pXDltELGrdFZ24E0ij5zTVPUVatup/+V1yItbz0krY+PZbSXSvmHd
         ZjrA==
X-Gm-Message-State: ANoB5pniPiPheBvuXC8RgDMuweoXL+lKYxJ7+oTJy0Xaz3dNADjuNJzT
        jurd121lhDZmnd97CUt8Lkv5iFq7MfTlugRyNABsmptaZ/1rE+ZayoTenmniyCzFJOhGIah2aY4
        nLSqm8MuiFEwL
X-Received: by 2002:a1c:ed04:0:b0:3cf:d08d:3eb2 with SMTP id l4-20020a1ced04000000b003cfd08d3eb2mr53618176wmh.129.1670006746059;
        Fri, 02 Dec 2022 10:45:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf75I0ySbXyDDvTLi0a0GRAy5m9CQJGlRIqVScxVQnvNBs+G5fzUxbVpiCqcsh5rvUQrJzLSRw==
X-Received: by 2002:a1c:ed04:0:b0:3cf:d08d:3eb2 with SMTP id l4-20020a1ced04000000b003cfd08d3eb2mr53618165wmh.129.1670006745794;
        Fri, 02 Dec 2022 10:45:45 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bu9-20020a056000078900b0022e6178bd84sm7797765wrb.8.2022.12.02.10.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:45:45 -0800 (PST)
Message-ID: <e7e130e1-4262-05e8-761f-3245c22d89a2@redhat.com>
Date:   Fri, 2 Dec 2022 19:45:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: x86: Advertise that the SMM_CTL MSR is not supported
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org
References: <20221007221644.138355-1-jmattson@google.com>
 <Y0Cn4p6DjgO2skrL@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y0Cn4p6DjgO2skrL@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/22 00:27, Sean Christopherson wrote:
>> CPUID.80000021H:EAX[bit 9] indicates that the SMM_CTL MSR (0xc0010116)
>> is not supported. This defeature can be advertised by
>> KVM_GET_SUPPORTED_CPUID regardless of whether or not the host
>> enumerates it.
> Might be worth noting that KVM will only enumerate the bit if the host happens to
> have a max extend leaf > 80000021.

Actually 0x8000001d, because 0x80000021 is a synthetic leaf (the only 
one of its kind).  Unfortunately we cannot synthesize 0x80000021 
unconditionally due to a preexisting bug in QEMU. :(

Paolo

