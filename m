Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473E76BD253
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 15:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjCPO12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 10:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjCPO11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 10:27:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFA6B7DBA
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 07:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678976788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0+t0FQM1SXGREWQfdJtHY3I1HKU/ZnlZED0zT9n5/2Q=;
        b=HpK9JXXpaR9BMxpP3C6B+sSQb3wCiGNbY/HdIZivfLTTDwUzFtdYmWux4pay1KzbGth3AV
        F6HXWGSg3AcRpHAOkA6N+/XUAeayBIJ0G/tVAfNPDwZAUfSxc7kE+JB+UDIInNjWk3JLRp
        Y3cu7MidFa+3E14uDl0DZbLv8/TD5kg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-Bnr19c6RPqqiNrqF15hZdQ-1; Thu, 16 Mar 2023 10:26:20 -0400
X-MC-Unique: Bnr19c6RPqqiNrqF15hZdQ-1
Received: by mail-wm1-f72.google.com with SMTP id bg13-20020a05600c3c8d00b003ed40f09355so832579wmb.5
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 07:26:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678976780;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0+t0FQM1SXGREWQfdJtHY3I1HKU/ZnlZED0zT9n5/2Q=;
        b=uFXEM9CFIqkwgNEl6HOqLDyWRFZR7s5S66g8vnZCn+TPverr3kauY+ynqhP319b6Dk
         bznn5pZCHIs7erGr5kx5SXt4cZJAR7p/c9LkLVS5i+eqLh4stwvA1QSUWiSKlRUPKnyT
         0eUa+FEo9R+XWjyCPRyPzzIxb+e5JVkLAkBwPvmrQ4bMInWhsD9deysF9Q3btJYfoxMJ
         QUk1QXuWiEhZ2hNVfuZ06+F8qCJHfU0zu9Bo18ZAptXFWNux0BHpzmTX/v0wzBNWzKEd
         kf9z5r7bKDqgg11iZjpFKcFDUlM8+jjosyTAcqeeg3bQH1/TEBj957aR4N/s6F3o83LC
         9rVg==
X-Gm-Message-State: AO0yUKUAEO2QVc5Slew1yLL8/4JTQUdz12T2FO2P2pgRqCI6ypyAXqPl
        EX0W/YY9pkFxQJorUKE8udHO/WZvI8hYZ4aNepHioeX5Hjef6aYwOwZBJ6KDepq0jyrrV7r7a8A
        Vx+1gBWK3PCgo
X-Received: by 2002:a05:600c:524c:b0:3ed:352a:a1d3 with SMTP id fc12-20020a05600c524c00b003ed352aa1d3mr6108085wmb.22.1678976779914;
        Thu, 16 Mar 2023 07:26:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set9AFgIwgZtesQeZrKDqTHiyMJr7QX7EG8KXFGvafsXjEIbH9RVzYKFU5l/MjR2qG7KpTFB/bA==
X-Received: by 2002:a05:600c:524c:b0:3ed:352a:a1d3 with SMTP id fc12-20020a05600c524c00b003ed352aa1d3mr6108070wmb.22.1678976779650;
        Thu, 16 Mar 2023 07:26:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l3-20020a1ced03000000b003ed29f5616dsm4998937wmh.4.2023.03.16.07.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 07:26:19 -0700 (PDT)
Message-ID: <904d2bd6-459f-aee9-226e-a94c4a0dab39@redhat.com>
Date:   Thu, 16 Mar 2023 15:26:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/2] KVM: x86: Fix kvm/queue breakage on clang
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
References: <20230315191128.1407655-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230315191128.1407655-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/23 20:11, Sean Christopherson wrote:
> Fix clang build errors for patches sitting kvm/queue.  Ideally, these
> fixes will be squashed before the buggy commits make their way to kvm/next.
> If you do fixup kvm/queue, the VMX commit also has a bad SOB chain; Jim
> either needs to be listed as the author or his SOB needs to be deleted.

I added it as Co-developed-by and squashed the patches.

Paolo

