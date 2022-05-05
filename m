Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590A351B9D4
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 10:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346861AbiEEITv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 04:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244257AbiEEITq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 04:19:46 -0400
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 May 2022 01:16:07 PDT
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77A65381AC
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 01:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651738566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LMmVpRWMoRU1azl33Fz0BSTKzhJqKUnbRhnfQ6zZG80=;
        b=AgELYznBL+IModBBvFpR0arpoj9WUvgvbdtAUBe7lRayjSbT7uKV2IZXtkYa3teBb0eYHR
        JI/4BsQHSgf8J9VKWOxHgiOFi3kJrXuMrb2pUI/yoeeRsqkLx4Mj/kD+ogZdhLjJAG+zMH
        CZV9hpQQbfxJMBbNGW1uCJiq8Ra+YtY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-R8d4JQyqMMWfTItScPQj2A-1; Thu, 05 May 2022 04:09:59 -0400
X-MC-Unique: R8d4JQyqMMWfTItScPQj2A-1
Received: by mail-wm1-f70.google.com with SMTP id u3-20020a05600c210300b0039430c7665eso1455905wml.2
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 01:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LMmVpRWMoRU1azl33Fz0BSTKzhJqKUnbRhnfQ6zZG80=;
        b=uHVGhw907uuNegy37ieUHkjl4uxKkOoAaevqN2oU6H06e95uwFCK2MYCtjBFhhZoYQ
         ztxuZJM5ohOTLbwKfq9JrbRCdPmPbMAPCTqbPhynU4K7R3Y30cef9tQMZDgq9otj6Pnh
         4PyaRlCid3KN5+KOh45yp+L11lcBj64NTUZv6yGZLrbSRlNR2q8TUgKbeNVWiMEqLv/i
         1vli7bI9TLpcoZCo6tq13lbRvFFxtNYgvelZH4Ti2r1YFUmF5+GHZZXwRSl+6Ro9I0oz
         XBTba5/baOpYzKpYPvVplsZPRZTzSQZyOv5FNOvzlAYz+TpK8IvEfSbM2GE3Sbk/p4du
         A7cg==
X-Gm-Message-State: AOAM531X442ojtZmJTvQR4huVv5GQmKwopKmitMgV/aDZV423FsuR3Z6
        QAS/vNnSGigedaXb0q+j0R6rrunYaxoN1lWmOpIqGMc8h5yKqgji6W+Puezp+MhFZH2huR4h+0F
        ztm5Ujt+bPiZ5
X-Received: by 2002:a5d:4dcc:0:b0:20a:ddaa:1c30 with SMTP id f12-20020a5d4dcc000000b0020addaa1c30mr18567310wru.419.1651738198214;
        Thu, 05 May 2022 01:09:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxF3SnRl4IY2DzCHNuO4AiJMwnl6yo6g6VmMcLx1KaUXK8q/UHDTDCkU1gWSrtKSdDZPGdfcQ==
X-Received: by 2002:a5d:4dcc:0:b0:20a:ddaa:1c30 with SMTP id f12-20020a5d4dcc000000b0020addaa1c30mr18567296wru.419.1651738198020;
        Thu, 05 May 2022 01:09:58 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bu21-20020a056000079500b0020c5253d8c5sm623451wrb.17.2022.05.05.01.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 01:09:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: X86: correct trace_kvm_pv_tlb_flush stats
In-Reply-To: <8E192C0D-512C-4030-9EBE-C0D6029111FE@nutanix.com>
References: <20220504182707.680-1-jon@nutanix.com>
 <YnL0gUcUq5MbWvdH@google.com>
 <8E192C0D-512C-4030-9EBE-C0D6029111FE@nutanix.com>
Date:   Thu, 05 May 2022 10:09:56 +0200
Message-ID: <87h7641ju3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Kohler <jon@nutanix.com> writes:

>> On May 4, 2022, at 5:47 PM, Sean Christopherson <seanjc@google.com> wrot=
e:
>>=20

...

>
> The net problem here is really that the stat is likely incorrect; however,
> one other oddity I didn=E2=80=99t quite understand after looking into thi=
s is that
> the call site for all of this is in record_steal_time(), which is only ca=
lled
> from vcpu_enter_guest(), and that is called *after*
> kvm_service_local_tlb_flush_requests(), which also calls
> kvm_vcpu_flush_tlb_guest() if request =3D=3D KVM_REQ_TLB_FLUSH_GUEST
>
> That request may be there set from a few different places.=20
>
> I don=E2=80=99t have any proof of this, but it seems to me like we might =
have a
> situation where we double flush?
>
> Put another way, I wonder if there is any sense behind maybe hoisting
> if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu)) up before
> Other tlb flushes, and have it clear the FLUSH_GUEST if it was set?

Indeed, if we move KVM_REQ_STEAL_UPDATE check/record_steal_time() call
in vcpu_enter_guest() before kvm_service_local_tlb_flush_requests(), we
can probably get aways with kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST,
vcpu) in record_steal_time() which would help to avoid double flushing.

--=20
Vitaly

