Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2647640D38
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiLBS35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234445AbiLBS3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:29:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1C4ABA18
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670005724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8vn06SZ+VaduZoYlgoSlK8jrmaKqNMOIQKLCGO4Vcrw=;
        b=dBE75m3UQ9p1hhBlK25EIYm0LfR4V5a/5ejrUMlFpLCjwEKsokQHI8YOSmR6W/t/QaWYgK
        4QhJe66qigpnePDXf4cFsB02yTTUdi9IVQ6m4/+FOZfW1ifBhyk1CF6GUTZocQFPnE+rda
        yTgZkoj+ecuFEv+22u9tRzMvfH4nYHM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-131-LbDmTvVTMTKbBt1jwqI9Pg-1; Fri, 02 Dec 2022 13:28:43 -0500
X-MC-Unique: LbDmTvVTMTKbBt1jwqI9Pg-1
Received: by mail-wm1-f71.google.com with SMTP id f1-20020a1cc901000000b003cf703a4f08so2241760wmb.2
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:28:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8vn06SZ+VaduZoYlgoSlK8jrmaKqNMOIQKLCGO4Vcrw=;
        b=BSvgp4t16M0PeRM19UWo1i+thhBn4Fh7y5j7RFpEGWIe/COw7Jr/jD5bcAUV1lWx9q
         EerXGZ0bXy1vRoKlXb1Z4eqAH5fu54N+tISxoTWG4MdX1mGYlBq6IuECHH2fVccJ78/j
         U1F1R9DoC8drD64dTWhc9xVkjHBJCOvmKPmEtc47Vuzj++H8wCOWQAgkGBlQ61bvQR2x
         5+/yTRXEpq/lmNEoGLtAFncdfJ0PoP35BZImgQO2xxTabR0C9sA2h5lhpcVG1Hj4bD2Z
         Z2mIr9JdA1UY6q4Pa6vUwPSZOdrvMO2+JmAftmOEECCfaizgWKt6YYJsaOp1ZmMrBDwq
         p8EQ==
X-Gm-Message-State: ANoB5pleaHVELW2akiPLFX10x//zzBZyeHaP1yOuBrbIQvPjbXQZjEcb
        Ygpy37+y+dPWYIYadlN9b2rqfGfEl2sgEZkwT1SptR6ioMgRdXgzm0Z1GZ3yDddoay+TuZfp6HJ
        LXPzlPiAjK+Mf
X-Received: by 2002:a05:600c:3109:b0:3c6:7abb:9d2b with SMTP id g9-20020a05600c310900b003c67abb9d2bmr44578791wmo.182.1670005722261;
        Fri, 02 Dec 2022 10:28:42 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7XtUbUxWPwP7a8PUr3pTjavfnXhpJV/U1GzQDMdG2n2oZFjjh0Z1ZPPUvNLTW0zl8z6MT+mg==
X-Received: by 2002:a05:600c:3109:b0:3c6:7abb:9d2b with SMTP id g9-20020a05600c310900b003c67abb9d2bmr44578784wmo.182.1670005722062;
        Fri, 02 Dec 2022 10:28:42 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id q17-20020a05600000d100b0024207ed4ce0sm7683394wrx.58.2022.12.02.10.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:28:41 -0800 (PST)
Message-ID: <73c38166-cf8c-e407-4fbc-c8a99c1dc2b5@redhat.com>
Date:   Fri, 2 Dec 2022 19:28:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 0/2] KVM: Halt-polling documentation cleanups
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20221201195249.3369720-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221201195249.3369720-1-dmatlack@google.com>
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

On 12/1/22 20:52, David Matlack wrote:
> This series makes some small cleanups to the existing halt-polling
> documentation. Patch 1 moves halt-polling.rst out of the x86-specific
> directory, and patch 2 clarifies the interaction between
> KVM_CAP_HALT_POLL and kvm.halt_poll_ns, which was recently broken and a
> source of confusion [1].
> 
> [1] https://lore.kernel.org/kvm/03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com/
> 
> Cc: Yanan Wang <wangyanan55@huawei.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> David Matlack (2):
>    KVM: Move halt-polling documentation into common directory
>    KVM: Document the interaction between KVM_CAP_HALT_POLL and
>      halt_poll_ns
> 
>   Documentation/virt/kvm/api.rst                    | 15 +++++++--------
>   Documentation/virt/kvm/{x86 => }/halt-polling.rst | 13 +++++++++++++
>   Documentation/virt/kvm/index.rst                  |  1 +
>   Documentation/virt/kvm/x86/index.rst              |  1 -
>   4 files changed, 21 insertions(+), 9 deletions(-)
>   rename Documentation/virt/kvm/{x86 => }/halt-polling.rst (92%)
> 
> 
> base-commit: 7e3bba93f42e9d9abe81344bdba5ddc635b7c449

Queued, thanks.

Paolo

