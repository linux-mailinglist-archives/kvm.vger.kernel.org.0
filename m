Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98F16CC1D3
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 16:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjC1OP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 10:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbjC1OPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 10:15:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA37CDF3
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 07:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680012840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ffLH5bZRJ6YtgLRSBMwzxg/+hZRSIpwmfi4hS4N8Nuc=;
        b=eHw3l14bA7G0/Dq7DHE/y5X/WaB/JnOfrFfcJD26YhXBfioFjQ9qsvlj7N86XpvqEsObFS
        XNKheb2y8iYtwhjnuaQ2xKZIbPQPU5PnnutghhPChRJ/N7wds493yDxRJLHVUD5HiOFq6P
        Nx/ZHttcBuqmAh1qBO55x3egPRDe/4Y=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-SLVJAI6GPtCRZZwvjfINFQ-1; Tue, 28 Mar 2023 10:13:57 -0400
X-MC-Unique: SLVJAI6GPtCRZZwvjfINFQ-1
Received: by mail-ed1-f70.google.com with SMTP id s30-20020a508d1e000000b005005cf48a93so17642916eds.8
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 07:13:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680012836;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffLH5bZRJ6YtgLRSBMwzxg/+hZRSIpwmfi4hS4N8Nuc=;
        b=h383NNo0mfRYXPbk67BwYwn1Y2qnrl1pfsaw2U8w/MABAH3H+lJG7ST7Lg7IxE3o/W
         n0guRYh53CJ5BsgsodA+VunKuYstrqziNg/ln5zwAeOIY/weck7M18uI3hUVMqKFRoDz
         /p0WJk+Oyl/GvIByp2wCesQShzUk+N3zgzAguuRiZ+GMTOAnDYnnIbNzJu3QlC4HZYbG
         jt5uE5zLc8PEQrLhJNnhy2SDyRzSsLpy/Fq+Aktv1uLXt4Tu7iV/3TP1Y3d7+61h+5VZ
         raoX3nDnAWPeZhVgGwuMCTtazpkrYXJ2KeJ0Y2TBc1WnLEd05Lh3afqOfLpv2Zsa+sA/
         WRWQ==
X-Gm-Message-State: AAQBX9ciqQllmNhQsZrxpqd8ZRHRSJt6j9kW/GfLha80ACMIIs4VpqBZ
        9R0WTlX0nkyAXloZOasPq6lxk5do90v4vyU7FhI9TWPx2MY54fibzU5RWoVP7xSR1XXX8EUMhhD
        rgn63GjieXLXh
X-Received: by 2002:a17:906:4c91:b0:946:be05:ed7a with SMTP id q17-20020a1709064c9100b00946be05ed7amr2887638eju.70.1680012835984;
        Tue, 28 Mar 2023 07:13:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZDesR/WhBhPl2B8jond6w5UYfHY//O0l7vDZqE7Ay9Y8tX64ayaBkW6XL6HcuBZ2hIUUWFwA==
X-Received: by 2002:a17:906:4c91:b0:946:be05:ed7a with SMTP id q17-20020a1709064c9100b00946be05ed7amr2887614eju.70.1680012835739;
        Tue, 28 Mar 2023 07:13:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id gv27-20020a1709072bdb00b008b9b4ab6ad1sm15335005ejc.102.2023.03.28.07.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 07:13:55 -0700 (PDT)
Message-ID: <7463da3b-1d52-40a4-97a3-4f912f4f9fdb@redhat.com>
Date:   Tue, 28 Mar 2023 16:13:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
 <20230328123119.3649361-24-zhaotianrui@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PING PATCH v4 23/29] LoongArch: KVM: Implement handle gspr
 exception
In-Reply-To: <20230328123119.3649361-24-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/28/23 14:31, Tianrui Zhao wrote:
> +			case 0xc91:
> +				/* idle GSPR */
> +				er = _kvm_emu_idle(vcpu);
> +				break;

So this is my last remark.  What some other architectures do is change 
vcpu->arch.mp_state when entering an idle state, and at this point all 
calls to KVM_RUN would call the equivalent of _kvm_emu_idle().  This 
requires implementing the KVM_GET_MPSTATE and KVM_SET_MPSTATE ioctls.

This might also be useful if later you want to implement a mechanism 
where vCPUs can pause or resume, for example for multi-vCPU VMs.

You can implement this on top of what you have, but I highly recommend 
that you do it in the first version of what is committed to Linux.

Paolo

