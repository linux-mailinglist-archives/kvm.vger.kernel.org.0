Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C17754ABCD
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 10:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355464AbiFNI3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 04:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354286AbiFNI2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 04:28:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7A6140E4E
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 01:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655195297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LAvbapudPnPzk48fIwZxvcCB3rdeKUmQMAJB8jP+RQM=;
        b=KBE0tGBZiLxxmzLEms6zMukAg9gae5t3FL050bAzEmwz1ovy0031rt1KvW1+ezs7lXL6mY
        +VRB1gs3JXWdfRh6ONlX1SntH61NEgVj6MZ3wyzJnW0DgCd2catwi1OrJI146oTn32selD
        /sCOcAq49ekyaEEgkMjcuZOgBELNtAQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-97rMZyslM3CFxuZw2bGtLA-1; Tue, 14 Jun 2022 04:27:36 -0400
X-MC-Unique: 97rMZyslM3CFxuZw2bGtLA-1
Received: by mail-ej1-f72.google.com with SMTP id a9-20020a17090682c900b0070b513b9dc4so2569430ejy.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 01:27:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LAvbapudPnPzk48fIwZxvcCB3rdeKUmQMAJB8jP+RQM=;
        b=bxVBSNi3Vp6lxzvuGyNk+fXUvtjPa9ORJ4ydx64pJ7hu4BpWEesMfgVeZigq4E8U3x
         HGnCWrJkHBwF0hAm3vHQ/S5cYcwJb8e37udFekFKa9Zb1X1lYjrXwPu1HZJyf9EnNq9r
         F/baA6YpnfZgIcg5Yhg9+h21vvHU3rcqXlrSrj0vJ8TnTQCrsMgd6ip3R4Mwz4eY1wDs
         TYIDu1G6lY/i2yIasl9rKhNGOEPhvnfMqZe07NxaQiR5K10EMusezpIOFqMJ/3gDd4Lu
         L9laPLACHSImPjYV2CCtXniPQYY9iYsagew1QM/Tsn6xjBVUvyfvNO4f4+Jl18zuca9j
         Hrhg==
X-Gm-Message-State: AOAM531s2zUjHHZ8VY5TAgyjss2c7KNKW4Jryj8AXyrtDszSTH31QhLa
        xxMxgcdPpoQjN3mF8+Nmyw2AtMYMvNkUfAkFKCw8rK3t+grt5oBe5O3BltE7m2s11/9nWygapcz
        rkVAGzstRrHOx
X-Received: by 2002:a05:6402:278d:b0:42e:d3d5:922e with SMTP id b13-20020a056402278d00b0042ed3d5922emr4408278ede.154.1655195255203;
        Tue, 14 Jun 2022 01:27:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyArMks9l2InGVmn0cZh0KOtbB2yTnz7aZqhZERW5BhtV+nz0GXf+KqWsK4BTKi0eJEoWPTGA==
X-Received: by 2002:a05:6402:278d:b0:42e:d3d5:922e with SMTP id b13-20020a056402278d00b0042ed3d5922emr4408257ede.154.1655195255043;
        Tue, 14 Jun 2022 01:27:35 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v16-20020a170906381000b006fec69a3978sm4743506ejc.207.2022.06.14.01.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:27:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     David Matlack <dmatlack@google.com>,
        Kyle Meyer <kyle.meyer@hpe.com>
Cc:     kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, russ.anderson@hpe.com,
        payton@hpe.com, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 2048
In-Reply-To: <CALzav=eWPiii4_zmYifdi_pSS6nUvMEchwQcvD+W2CfOR+-s8Q@mail.gmail.com>
References: <20220613145022.183105-1-kyle.meyer@hpe.com>
 <CALzav=eWPiii4_zmYifdi_pSS6nUvMEchwQcvD+W2CfOR+-s8Q@mail.gmail.com>
Date:   Tue, 14 Jun 2022 10:27:33 +0200
Message-ID: <8735g7k5u2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Matlack <dmatlack@google.com> writes:

> On Mon, Jun 13, 2022 at 11:35 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
>>
>> Increase KVM_MAX_VCPUS to 2048 so we can run larger virtual machines.
>
> Does the host machine have 2048 CPUs (or more) as well in your usecase?
>
> I'm wondering if it makes sense to start configuring KVM_MAX_VCPUS
> based on NR_CPUS. That way KVM can scale up on large machines without
> using more memory on small machines.
>
> e.g.
>
> /* Provide backwards compatibility. */
> #if NR_CPUS < 1024
>   #define KVM_MAX_VCPUS 1024
> #else
>   #define KVM_MAX_VCPUS NR_CPUS
> #endif
>
> The only downside I can see for this approach is if you are trying to
> kick the tires a new large VM on a smaller host because the new "large
> host" hardware hasn't landed yet.

FWIW, while I don't think there's anything wrong with such approach, it
won't help much distro kernels which are not recompiled to meet the
needs of a particular host. According to Kyle's numbers, the biggest
growth is observed with 'struct kvm_ioapic' and that's only because of
'struct rtc_status' embedded in it. Maybe it's possible to use something
different from a KVM_MAX_VCPU_IDS-bound flat bitmask there? I'm not sure
how important this is as it's just another 4K per-VM and when guest's
memory is taken into account it's probably not much.

The growth in 'struct kvm'/'struct kvm_arch' seems to be insignificant
and on-stack allocations are probably OK.

-- 
Vitaly

