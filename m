Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA86A4FBAC2
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 13:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244923AbiDKLWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 07:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiDKLWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 07:22:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37CD742A03
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 04:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649675986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FjKusdcXN/svcmlawOVsWWcBk1qRxJxq3tOJtjRM3qU=;
        b=ftRKXN+XvisfzNy8U91BajPJPYQiEAV6fnnUcXp1df0R4ZKd9UNc9hVohGipOYV1xkFXrQ
        JAyZ+qFyYJIyAt80oDSW2s3VUlkJ3nXwtC12lsr3udR+WWkakl5s2olkhUOlxZ/AKerzNP
        zoiUZlz189PXmoOYXGuxadPuDgmC+xE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-pd0k5aJrPX68mJ8PavE1jg-1; Mon, 11 Apr 2022 07:19:45 -0400
X-MC-Unique: pd0k5aJrPX68mJ8PavE1jg-1
Received: by mail-ej1-f71.google.com with SMTP id qb5-20020a1709077e8500b006e8942c5339so739984ejc.14
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 04:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FjKusdcXN/svcmlawOVsWWcBk1qRxJxq3tOJtjRM3qU=;
        b=AivbHxeTZBD2mcMBDJjlMI7m8w07wpM/0aQ5OVPF5YmxcWcepmjWOfbgHppJ9Z4rRz
         wc1X+KXXhTYq/H0Gx2lX42Tx0KCu9w6UyjGkakuUm96dZQeHRU37J4NMsPJAOAfE1RI6
         44ICAPxzPj/rIwn03LhmgVAHTdzv8UvR3oqqNJWmHj9w9hMAKDfwIzo1exBRbqpUOWRq
         FmeYzch8TDUB2jsZxNH8wqjO2c/DluHlTWro6Cae9pQ1n9UFcDBAwGAZuAoZcrU6f4xE
         zfkoRPOQKObUNjzxVUDAS1WWS0dyoTfVm8bnFYp1N6y5mLHF0/nWDdrt2fdP/nS3xkqY
         +k5g==
X-Gm-Message-State: AOAM530j8en8UGb2Lv0XexfHcv3fvfqqV/UbGP+4BAwMbnjE6HClyxy8
        tIlMRg/8bqEenJLaCs+7mnV1s/xtn3hSZsBcRbQYJzAQ7TiN9JT33tN+BGC3ddV+u/Jt+5z9JSu
        34M3BJ8AIbz3P
X-Received: by 2002:a17:906:7111:b0:6e8:973a:1515 with SMTP id x17-20020a170906711100b006e8973a1515mr2645572ejj.308.1649675984064;
        Mon, 11 Apr 2022 04:19:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUvNAro+h5LGDSH7dNHuSRzLrFf9n39vBmpdd1x4PS7yTMqCT5cnNc8/AomnXQVO2my3WO7w==
X-Received: by 2002:a17:906:7111:b0:6e8:973a:1515 with SMTP id x17-20020a170906711100b006e8973a1515mr2645556ejj.308.1649675983900;
        Mon, 11 Apr 2022 04:19:43 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g2-20020a50bf42000000b0041cc5233252sm11955251edk.57.2022.04.11.04.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 04:19:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 16/31] KVM: nVMX: hyper-v: Direct TLB flush
In-Reply-To: <Yk8x2rF/UkuXY/X2@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-17-vkuznets@redhat.com>
 <Yk8x2rF/UkuXY/X2@google.com>
Date:   Mon, 11 Apr 2022 13:19:42 +0200
Message-ID: <87czhn7tpt.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
>> Enable Direct TLB flush feature on nVMX when:
>> - Enlightened VMCS is in use.
>> - Direct TLB flush flag is enabled in eVMCS.
>> - Direct TLB flush is enabled in partition assist page.
>
> Yeah, KVM definitely needs a different name for "Direct TLB flush".  I don't have
> any good ideas offhand, but honestly anything is better than "Direct".
>

I think we can get away without a name inside KVM, we'll be doing either
'L1 TLB flush' or 'L2 TLB flush'. In QEMU we can still use 'Direct' I
believe as it matches TLFS and doesn't intersect with KVM's MMU.

-- 
Vitaly

