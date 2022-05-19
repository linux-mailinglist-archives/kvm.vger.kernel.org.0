Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD04352D664
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 16:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbiESOq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 10:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiESOqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 10:46:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 249324248F
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 07:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652971613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IYenpcwbemxE/tpiqt4OT+PMDoY+cz7r/DOS2tuXYQI=;
        b=R+Y1ITuTnpCTOOkL35yKlpu1UXYGH/daEoCJMDizwX+ozNgGaPXgvnKSZ9T8J5vOvoiuAw
        bPiQ3ResLMzzbEYuRuRuMj8Y2k0AP75nDNRzh0l6lNNHXw+cpZ63LtiyfO/sjTUcnzGd0V
        u5tLH0/6MBAPQog6Td2aX2Poj5o5B+8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-Atcql12pMLOm4JtzefYZmA-1; Thu, 19 May 2022 10:46:52 -0400
X-MC-Unique: Atcql12pMLOm4JtzefYZmA-1
Received: by mail-wr1-f70.google.com with SMTP id s14-20020adfa28e000000b0020ac7532f08so1639875wra.15
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 07:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=IYenpcwbemxE/tpiqt4OT+PMDoY+cz7r/DOS2tuXYQI=;
        b=8Ir/nztiAyfS4rUCkFQBe9FmeprlMJ9vN+l1D2QWHwCQKVPQLHnbCHD4W7FyC9Dt3m
         G9v2oqejQHmtdHSDNv5YEv92ijTmdHL2XvHgNLOYBPMY3wcj1kdQ0DNXga6Z1cdDqcOS
         DJOnyPWOzJwElL3qFRPn2TTkh637xS/90/IlMdx6kEhE9+6ShkEgz+eZNbMsrHX4yhnU
         wfov4BFQShgBpzxUC+Umye1ExrSJwNEF6PP/tkgEn/8EVvi0/eunCjudEP/OwlJ9UdMN
         +PX2jCel4oGMSdFtM8LSucU3RKrpi6cNVZ5KvrOE/4iuJ57GI+Zc3e61Bo316lpcHks5
         3VaA==
X-Gm-Message-State: AOAM531Jfmz+BXqQBlrJzlJE3uBCfFhKXKufsmdKoc5L5r7hyvJH/WxR
        niDWxG0V+Anq03TyiN4pUw0onwp2IbeKi6w//Esm++ESQb9bYblNeGWqpTiN9RcjdComjtNFIhp
        Oc1Kp0QJKP6YK
X-Received: by 2002:a5d:674c:0:b0:20d:87e:8d6f with SMTP id l12-20020a5d674c000000b0020d087e8d6fmr4389528wrw.40.1652971611084;
        Thu, 19 May 2022 07:46:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyr6JwGKaZDuEnW7utGBQ+cruIn2morLnGA2beoQBpy8dow5R22hQX7c9kMilfKrC6KCUQoKg==
X-Received: by 2002:a5d:674c:0:b0:20d:87e:8d6f with SMTP id l12-20020a5d674c000000b0020d087e8d6fmr4389505wrw.40.1652971610845;
        Thu, 19 May 2022 07:46:50 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a7-20020adfbc47000000b0020c635ca28bsm5370388wrh.87.2022.05.19.07.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 07:46:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RESEND v12 00/17] KVM: x86/pmu: Add basic support to
 enable guest PEBS via DS
In-Reply-To: <d7461fd4-f6ec-1a0b-6768-0008a3092add@gmail.com>
References: <20220411101946.20262-1-likexu@tencent.com>
 <87fsl5u3bg.fsf@redhat.com>
 <e0b96ebd-00ee-ead4-cf35-af910e847ada@gmail.com>
 <d7461fd4-f6ec-1a0b-6768-0008a3092add@gmail.com>
Date:   Thu, 19 May 2022 16:46:49 +0200
Message-ID: <874k1ltw9y.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like Xu <like.xu.linux@gmail.com> writes:

> On 19/5/2022 9:31 pm, Like Xu wrote:
>> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>>  =C2=A0=C2=A0 lib/x86_64/processor.c:1207: r =3D=3D nmsrs
>>  =C2=A0=C2=A0 pid=3D6702 tid=3D6702 errno=3D7 - Argument list too long
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0 0x000000000040da11: =
vcpu_save_state at processor.c:1207=20
>> (discriminator 4)
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2=C2=A0=C2=A0=C2=A0 0x00000000004024e5: =
main at state_test.c:209 (discriminator 6)
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3=C2=A0=C2=A0=C2=A0 0x00007f9f48c2d55f: =
?? ??:0
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4=C2=A0=C2=A0=C2=A0 0x00007f9f48c2d60b: =
?? ??:0
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5=C2=A0=C2=A0=C2=A0 0x00000000004026d4: =
_start at ??:?
>>  =C2=A0=C2=A0 Unexpected result from KVM_GET_MSRS, r: 29 (failed MSR was=
 0x3f1)
>>=20
>> I don't think any of these failing tests care about MSR_IA32_PEBS_ENABLE
>> in particular, they're just trying to do KVM_GET_MSRS/KVM_SET_MSRS.
>
> One of the lessons I learned here is that the members of msrs_to_save_all=
[]
> are part of the KVM ABI. We don't add feature-related MSRs until the last
> step of the KVM exposure feature (in this case, adding MSR_IA32_PEBS_ENAB=
LE,
> MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG to msrs_to_save_all[] should take
> effect along with exposing the CPUID bits).

AFAIR the basic rule here is that whatever gets returned with
KVM_GET_MSR_INDEX_LIST can be passed to KVM_GET_MSRS and read
successfully by the host (not necessarily by the guest) so my guess is
that MSR_IA32_PEBS_ENABLE is now returned in KVM_GET_MSR_INDEX_LIST but
can't be read with KVM_GET_MSRS. Later, the expectation is that what was
returned by KVM_GET_MSRS can be set successfully with KVM_SET_MSRS.

--=20
Vitaly

