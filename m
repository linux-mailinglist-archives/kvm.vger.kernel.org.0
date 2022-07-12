Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF518571F66
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 17:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiGLPeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 11:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiGLPdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 11:33:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A468FD36
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 08:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657640025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvXvgma6mjwjAWHd6+YYVyH2hz1GPZg9VsvRaOcyslY=;
        b=aUg2HtlsGDEKV3tmXd8AnhOmeNNNbXF7bKaE8skISow+dVn6IXbtq0bNNEQAYiv1pscB3P
        /x1S7EU5C86JMiryfoiHQs4r/vqc5aTq5hZvAvqSs1u0sbJHMuHJLl8B6HlZElg8+AC59r
        97rhNSxKZboaIXF1LmsepE/s6+J+Z6A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-aYU8f4X4MR6iRCH_zjuw8Q-1; Tue, 12 Jul 2022 11:33:42 -0400
X-MC-Unique: aYU8f4X4MR6iRCH_zjuw8Q-1
Received: by mail-wr1-f71.google.com with SMTP id i9-20020adfa509000000b0021d865ce5e3so1509046wrb.6
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 08:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QvXvgma6mjwjAWHd6+YYVyH2hz1GPZg9VsvRaOcyslY=;
        b=dQlWjTTWIvmSUpFrRUvxNz4Y20JSDK5jampSPjzLC+3oitonDu32RpEOi6qDp5ei93
         U6PbeVKaH1lFsAKOd+7Xouo6pnmumf5gueVP2OhqlSS6HJV/vHry5j2AfXKk2gkYMjIZ
         f1U9jIVKjo1uFhNrhEFGnasv6UdjbA6VnabjxdLta/YsWGp9wChLvnT7ewtngwoQNVS+
         Uq7Rhn53vM4jmq69Yz4bUksxsc8beXLOv/NkllAvXUoKpGq2xZy76r0OURrfsxy6PV2n
         2JOQAUqw0bNoyJe3mmIOZFlolcUI+nBmKgJGBu5pzgvd3Q3m7z5A4eGaY+qlhl6OyH7Q
         zL1w==
X-Gm-Message-State: AJIora+TElBV9sHy1Uju7hF2JYTVkZsADgJffNrDNOP6dDBecRJkTdlX
        MY1j1IVvjoDK1xF7/3fuIqZvTzDE49U+IY8Xv8IiKZIee6AocOCPuKlGGVuSSyrzgOoxL4Wto0a
        rd3yXnWWGlLXp
X-Received: by 2002:a5d:584d:0:b0:21d:b7f8:7d19 with SMTP id i13-20020a5d584d000000b0021db7f87d19mr732904wrf.260.1657640021515;
        Tue, 12 Jul 2022 08:33:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vsohtsRezHd+K1mxMoD6DDUTSf09YMJkQwLUwuJfnXvRlCJvmmUonwXDMUPJZckhIQXtJWnA==
X-Received: by 2002:a5d:584d:0:b0:21d:b7f8:7d19 with SMTP id i13-20020a5d584d000000b0021db7f87d19mr732881wrf.260.1657640021211;
        Tue, 12 Jul 2022 08:33:41 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b1-20020adfee81000000b0021bbdc3375fsm8651134wro.68.2022.07.12.08.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 08:33:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Always enable TSC scaling for L2 when it was
 enabled for L1
In-Reply-To: <ee479e42605d3ed3276b66da69179dbfbcb05dbc.camel@redhat.com>
References: <20220712135009.952805-1-vkuznets@redhat.com>
 <ee479e42605d3ed3276b66da69179dbfbcb05dbc.camel@redhat.com>
Date:   Tue, 12 Jul 2022 17:33:39 +0200
Message-ID: <871quqpcq4.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Tue, 2022-07-12 at 15:50 +0200, Vitaly Kuznetsov wrote:
>> Windows 10/11 guests with Hyper-V role (WSL2) enabled are observed to
>> hang upon boot or shortly after when a non-default TSC frequency was
>> set for L1. The issue is observed on a host where TSC scaling is
>> supported. The problem appears to be that Windows doesn't use TSC
>> frequency

^^^ scaling ^^^

>> for its guests even when the feature is advertised and KVM
>> filters SECONDARY_EXEC_TSC_SCALING out when creating L2 controls from
>> L1's. This leads to L2 running with the default frequency (matching
>> host's) while L1 is running with an altered one.
>
> Ouch.
>
> I guess that needs a Fixes tag?
>
> Fixes: d041b5ea93352b ("KVM: nVMX: Enable nested TSC scaling")
>

I dismissed that because prior to d041b5ea93352b SECONDARY_EXEC_TSC_SCALING
was filtered out in nested_vmx_setup_ctls_msrs() but now I think I was
wrong, SECONDARY_EXEC_TSC_SCALING was likely kept in VMCS02 regardless
of that. Will add in v2.

> Also this is thankfully Intel specific, because in AMD you can't enable
> TSC scaling - there is just an MSR with default value of 1.0,
> which one can change if TSC scaling is supported in CPUID.
>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks!

> Best regards,
> 	Maxim Levitsky
>
>
>>=20
>> Keep SECONDARY_EXEC_TSC_SCALING in secondary exec controls for L2 when
>> it was set for L1. TSC_MULTIPLIER is already correctly computed and
>> written by prepare_vmcs02().
>>=20
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> =C2=A0arch/x86/kvm/vmx/nested.c | 1 -
>> =C2=A01 file changed, 1 deletion(-)
>>=20
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 778f82015f03..bfa366938c49 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2284,7 +2284,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *=
vmx, struct loaded_vmcs *vmcs0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SECONDARY_EXEC_VIRTUAL_=
INTR_DELIVERY |
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SECONDARY_EXEC_APIC_REG=
ISTER_VIRT |
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SECONDARY_EXEC_ENABLE_V=
MFUNC |
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SECONDARY_EXEC_TSC_SCALING=
 |
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 SECONDARY_EXEC_DESC);
>> =C2=A0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (nested_cpu_has(vmcs12,
>
>

--=20
Vitaly

