Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A21631CC6
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 10:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiKUJY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 04:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiKUJY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 04:24:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE65920A1
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 01:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669022640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gw/DHwFv6oMPQxg9XQawxp2HS3B6iVz/+oELdN8mjIo=;
        b=gaZCzvE8mG3ehlnl3s2VMjm2JT9lj4fuKfGsHjIc/2HMVIvHK3NVe0lcKpz+blKqo/7Qcy
        zSUPltlYomyZmarsbOXA+kLxPQ8B2TymD8HWJZEUhssslh8Vk5ybXxPuTVXNj1ijLC9RnH
        FxJhem4h8ym8YlX6N84GgbofSNGxUwQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-2Tq0ETw0P_6Ufyg-gz8_-A-1; Mon, 21 Nov 2022 04:23:58 -0500
X-MC-Unique: 2Tq0ETw0P_6Ufyg-gz8_-A-1
Received: by mail-ed1-f72.google.com with SMTP id m7-20020a056402430700b0045daff6ee5dso6501603edc.10
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 01:23:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gw/DHwFv6oMPQxg9XQawxp2HS3B6iVz/+oELdN8mjIo=;
        b=KcedOjeIf5vLUoh8+ONkQXiNd4dsIRwav0n7yqNkqlMoOf0j2r99msKGxZBtBEwew3
         2RJubEXFymtahBUfWqFH3N2T5RrNk70+ruecA/jbTTWStjvElcvQc/VyzT19UXXJiQIb
         qonk5fvvHcA51fhdDd80kyOTjbHRq1LKhFcAxDYZySKKYiFH0vW5M0PdDbg6z5UVSQcZ
         P0AhYRP9RURTmbdsE0V/P1QLKMYPG22MESnxnnbPnmIHOhU6lT/gAbCsanfc+kkZRp7T
         iHlgjW7Z+Qd9umZ0V6Yer3qDsfF6GIsNTRfdGxKM8XFpi1Wz56vua//Kv4iwt0FxXh3i
         mt6Q==
X-Gm-Message-State: ANoB5pktN2eNlURh+1Bs8oUWPXeINWR2PVpfY7vzqerXmKQsijqhumUo
        mlZRYqIi0B9Llt6X2TzfYsvqURIRDe9x3SkFO7Ng8Zl/YkNeg343TdxeIQuTtu37fs6bwb3J8E7
        0McZ6idOVdzqt
X-Received: by 2002:a05:6402:180d:b0:469:58:b18b with SMTP id g13-20020a056402180d00b004690058b18bmr12854223edy.240.1669022637643;
        Mon, 21 Nov 2022 01:23:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf64rITTXZVwm1Bpy9vbZw5NV5kcsPV9tnmzZykDNJnDY9sKDgsP9u2m610t0f0MoUlJnJTGcA==
X-Received: by 2002:a05:6402:180d:b0:469:58:b18b with SMTP id g13-20020a056402180d00b004690058b18bmr12854212edy.240.1669022637461;
        Mon, 21 Nov 2022 01:23:57 -0800 (PST)
Received: from ovpn-194-185.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id kz24-20020a17090777d800b0078d957e65b6sm4757455ejc.23.2022.11.21.01.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 01:23:56 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     KVM list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: KVM 6.2 state
In-Reply-To: <89e2e3f9-ad89-3581-4460-f87f552d08a5@redhat.com>
References: <89e2e3f9-ad89-3581-4460-f87f552d08a5@redhat.com>
Date:   Mon, 21 Nov 2022 10:23:55 +0100
Message-ID: <87a64kmzis.fsf@ovpn-194-185.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> These are the patches that are still on my list:
>
> * https://patchew.org/linux/20221105045704.2315186-1-vipinsh@google.com/
> [PATCH 0/6] Add Hyper-v extended hypercall support in KVM
>
> * https://patchew.org/linux/20221019165618.927057-1-seanjc@google.com/
> [PATCH v6 0/8] KVM: x86: Apply NX mitigation more precisely
>
> * https://patchew.org/linux/20221004093131.40392-1-thuth@redhat.com/
> [RFC PATCH 0/3] Use TAP in some more KVM selftests
>
> * https://patchew.org/linux/20221012181702.3663607-1-seanjc@google.com/
> [PATCH v4 00/11] KVM: x86/mmu: Make tdp_mmu a read-only parameter
>
> * https://patchew.org/linux/20221001005915.2041642-1-seanjc@google.com/
> [PATCH v4 00/32] KVM: x86: AVIC and local APIC fixes+cleanups
>
>
> Of which only the last one *might* be delayed to 6.3.
>
> Sean, if you have anything else feel free to collect them yourself and 
> send a pull request.

My "shameless plug" here would be:
"[PATCH v2 0/4] KVM: VMX: nVMX: Make eVMCS enablement more robust"
(https://lore.kernel.org/kvm/20221104144708.435865-1-vkuznets@redhat.com/).
it doesn't add any new features, however, is intended to make
KVM-on-Hyper-V enablement "future proof" against possible changes in
future Hyper-V versions.

-- 
Vitaly

