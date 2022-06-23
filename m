Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83740557A1A
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 14:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiFWMQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 08:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiFWMQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 08:16:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7377B3151E
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 05:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655986581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5bzHytzbyt3LJ4/dxkxeQpreFgNZKacxErPJ4wA59E=;
        b=B0LfD2kV0x229827MmnrCxoND3KXyjEh8upwnejclhbooyx2BeSUcpFXoYA4SB3TxqUO8N
        gOvmYPBpMT6H+wG3C0RKvM5/2mmEdg7K6NyTR7NCGm/YUcnF0bZoDIH73+bC7SVTrnKyHa
        2Udv29QhVchWNBaPGvT7JExwzm5mhmY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-ZykTjQL0NYSDKDA0eWEp8A-1; Thu, 23 Jun 2022 08:16:20 -0400
X-MC-Unique: ZykTjQL0NYSDKDA0eWEp8A-1
Received: by mail-ed1-f69.google.com with SMTP id n8-20020a05640205c800b00434fb0c150cso15457924edx.19
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 05:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g5bzHytzbyt3LJ4/dxkxeQpreFgNZKacxErPJ4wA59E=;
        b=skca27U5N/ieR8TvL/xOZ1SujhCctXf4keEATG2fh8wk78nMqvPK4GAxOTj9Wkokeh
         IrzhvSHHlUiOMsGWl/sI3mgcCMQRNIAE5cbH28zMcioI98s7efjPmiG6VfxwnpwtBQaZ
         iuyfrgA6YV+yi6g5pCbLCClfDZvS5okQWBc59ohH/bP2X2UqRmZcfGsHBCn3cT1l1ddt
         OAFq8njV3Mq2kFS9jHgmEIk70aGuv3WJl/6yZVesSb9EozZF9Yq56R0+p+TgJrYY/PjH
         HfcidMudYHInDw12/lAlf/J0HW8ZryEQPvbL2xnq8t8wuRD2XuQiHlvh+CG/ySpbymLt
         UAgg==
X-Gm-Message-State: AJIora90ot9y1SDOWHqDnnRWgefaob07mc9x3N1ITS3Hkb0cDmeoynmA
        J3cV/tObdJc4ep3s2zYNLkwNwW597qhKNnp+3/BY6Q+QJ1kqWRXv/WClG/Mlx0EG7Aq6VvS4AjT
        pE7BVaYP4dzjW
X-Received: by 2002:a05:6402:3546:b0:42e:2f58:2c90 with SMTP id f6-20020a056402354600b0042e2f582c90mr10416196edd.84.1655986579150;
        Thu, 23 Jun 2022 05:16:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s5GbGLU/i4oYJJek4q+iHhJv6ku0wmJbThXLZyDHJYQGqHKnaW+A0I0asdOmN8xuRbLwQSQA==
X-Received: by 2002:a05:6402:3546:b0:42e:2f58:2c90 with SMTP id f6-20020a056402354600b0042e2f582c90mr10416167edd.84.1655986578936;
        Thu, 23 Jun 2022 05:16:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id d8-20020a056402000800b00435a912358dsm3953372edu.30.2022.06.23.05.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 05:16:18 -0700 (PDT)
Message-ID: <795f73d0-9f88-28c9-9d8f-41e931f51230@redhat.com>
Date:   Thu, 23 Jun 2022 14:16:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.19, take #2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mike Rapoport <rppt@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20220623074158.1429243-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220623074158.1429243-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/22 09:41, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.19-2

Pulled, thanks.

Paolo

