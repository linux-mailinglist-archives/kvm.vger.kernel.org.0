Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3575D6D7C9B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 14:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbjDEMbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 08:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjDEMbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 08:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1A61BD0
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 05:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680697816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C3GXrj5/vq69zV8qx7J6eRA4bit5KAugf7Eq6t8FZsw=;
        b=JYHvCAlAY9ObinBgw7w2lOT/+yidF3J2xGflzq3bS/NJiZGJ9KYPFg8U9HBdWmzrt0k/EK
        H9FZNdtDf90KMQPdKdK2DwIAwea5c+D7yT/3Kby+hY96I1tspwGAI/vK8oavr12rIEo5m1
        Rbwf+vjU6mQRhKqO/0e2Y9l6GvSWBVU=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-2RBezu62PUadzH1j5kSpHg-1; Wed, 05 Apr 2023 08:30:15 -0400
X-MC-Unique: 2RBezu62PUadzH1j5kSpHg-1
Received: by mail-vs1-f69.google.com with SMTP id m4-20020a67e0c4000000b004263667c260so12608078vsl.17
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 05:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680697815; x=1683289815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C3GXrj5/vq69zV8qx7J6eRA4bit5KAugf7Eq6t8FZsw=;
        b=21UGDrLhiokGkTcr4Qpzg41BQjdJ+s/IYQe0Q88B+oPpeqL0P0xRmsw35v3Gwzkrhg
         huF3LIgt9c6jVWElDtkpH95AfNXuDNxAWn+lomExA+ZngTXhEkCk19i8QAMZDJgXf9zI
         TFoyGEXw14nHRNQNC6gsPwM0BPqAoHjmrih8f49MChlVHF3yMN690b7xN4Ce7F4y0ryN
         6C8nHfg/zKD3E6hiGHlZnzJkMdQbj8Nz1Hciyel2INBPB1mUDfwqGmMdN+LpM07bzhwY
         P7BGCnPd0boM6Egn2bWDfJyp1DnLrhsSOBsyvSa2LxyQMzI0KwqGC3aqHT58oMuA6JJF
         eXCQ==
X-Gm-Message-State: AAQBX9fjmT5Xfwu87XwP9idVzxKtW41KCMLykx0jAnbnw71ozKzR1yrL
        qI3Slb0GdYeTZGhN5p59Mx3m9Kf+5O57pZWdCdro3ajwUajYaXRnkljUFG3Fr6T8zK4hXCJeUHb
        HGuXFWiq0kR1pJY+pLbGaUCilgmoQ
X-Received: by 2002:a67:d704:0:b0:425:f1d7:79f7 with SMTP id p4-20020a67d704000000b00425f1d779f7mr4842483vsj.1.1680697815030;
        Wed, 05 Apr 2023 05:30:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZWVrFn5g7e+YJRp0HKSNr8gj3Lv/ZvTaL9NH7QwVvqIbpkGKu8U4X0hZjxC1r4mvle1Pd9h29lyXeZEw/xNXI=
X-Received: by 2002:a67:d704:0:b0:425:f1d7:79f7 with SMTP id
 p4-20020a67d704000000b00425f1d779f7mr4842469vsj.1.1680697814765; Wed, 05 Apr
 2023 05:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 5 Apr 2023 14:30:03 +0200
Message-ID: <CABgObfaJwgBKkSfp=GP437jEKTP=_eCktdiKcujeSOgwv9dbiQ@mail.gmail.com>
Subject: Re: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 5, 2023 at 11:34=E2=80=AFAM Li, Xin3 <xin3.li@intel.com> wrote:
> The question is, must KVM inject a hardware exception from the IDT vector=
ing
> information field? Is there any correctness issue if KVM does not?

Fault exceptions probably can be handled as you say, but traps
definitely have to be reinjected. For example, not reinjecting a
singlestep #DB would cause the guest to miss the exception for that
instruction.

> If no correctness issue, it's better to not do it, because the injected e=
vent
> from IDT vectoring could trigger another exception, i.e., a nested except=
ion,
> and after the nested exception is handled, the CPU resumes to re-trigger =
the
> original event, which makes not much sense to inject it.

(Let's use "second" exception instead of "nested" exception).

The CPU doesn't re-trigger the original event unless the second
exception causes a vmexit and the hypervisor moves the IDT-vectored
event fields to the event injection fields. In this case, the first
exception wasn't injected at all.

If the second exception does not cause a vmexit, it is handled as
usual by the processor (by checking if the two exceptions are benign,
contributory or page faults). The behavior is the same even if the
first exception comes from VMX event injection.

Paolo

> In addition, the benefits of not doing so are:
> 1) Less code.
> 2) Faster execution. Calling kvm_requeue_exception_e()/kvm_requeue_except=
ion()
>    consumes a few hundred cycles at least, although it's a rare case with=
 EPT,
>    but a lot with shadow (who cares?). And vmx_inject_exception() also ha=
s a
>    cost.
> 3) An IDT vectoring could trigger more than one VM exit, e.g., the first =
is an
>    EPT violation, and the second a PML full, KVM needs to reinject it twi=
ce
>    (extremely rare).
>
> Thanks!
>   Xin
>

