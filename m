Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6203556149C
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 10:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiF3IR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 04:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiF3IQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 04:16:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EE13113D
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 01:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656576868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlMiGdcIrFpDBLHk8xJFJfVXR7N2zgyrgxr08eYwybI=;
        b=bKufcNdZkDoUjHJUOctPDKSRSBv34EtRstMtgBDBTeKcwrdh3TzHD5si7n5er1jSE2NiyP
        CGbS/4RSSxXfDv0Kd9zP/gFneiqpJCz669VZB0/fWgo1pTpeWGq+KkwqoWr9xXrzMGiFkC
        rYZTcseF+YfhgiptDfywPyV8CHZ1sIA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-E0G5gzM3NUi-gjb9LvJ5rg-1; Thu, 30 Jun 2022 04:14:27 -0400
X-MC-Unique: E0G5gzM3NUi-gjb9LvJ5rg-1
Received: by mail-ej1-f70.google.com with SMTP id kv9-20020a17090778c900b007262b461ecdso5870153ejc.6
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 01:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zlMiGdcIrFpDBLHk8xJFJfVXR7N2zgyrgxr08eYwybI=;
        b=D5SeBVMOfGifdqpH9b5nvhPqA8FVrNMV+qnfUbMqj/jAgyTJsDNNdX2v5RBCG/CMJg
         L0tAk20FQyXYjXIQlndcvn0j5qq+hQUjw55e3p3sZmqRZPvUYGm6gV956owYEVSdO0za
         PbDkYAapWGzUABcYGCDWht/0u9GlE4StxI6npM5zZfuJUKZq5AHl+k09t1UJESOMvlYI
         DeVjBxgRC5qyLNePCO3ZiEwYo4SdAz/VaRJ6FHnnbFCWVME4iiDGszZ7Si0l+AWdwl2m
         fYoQQ3yyL0oF2jYkaIN6XC+mv4lG7e+HEYZXo84X31IPSZYu4mPhOUghFoc2d84JG7iH
         Birw==
X-Gm-Message-State: AJIora8/kuxnOdvE4FJGGMuC0nEMd6ArJevDl3tJXrQFr6T1ALS8tBtZ
        Ek9RtmFiE6SWxRCd59ZaD+oF+eKwdua+eEqmQ7hzadGreLdy/2DdtgMrqp/i8x4Yf8Em9g+qmrL
        iDSb/0S3heSGO
X-Received: by 2002:a17:906:2bda:b0:726:3b59:3ea9 with SMTP id n26-20020a1709062bda00b007263b593ea9mr7435890ejg.43.1656576866183;
        Thu, 30 Jun 2022 01:14:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tLG2WWX3FE42f0Pc7Gtu8T2vGqmsUiCHmaIDWC+JmhfkmKIzYY2TjuTHZ6kp+oNe8KDqo3FQ==
X-Received: by 2002:a17:906:2bda:b0:726:3b59:3ea9 with SMTP id n26-20020a1709062bda00b007263b593ea9mr7435876ejg.43.1656576865965;
        Thu, 30 Jun 2022 01:14:25 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r1-20020aa7cb81000000b004357b717a96sm12695498edt.85.2022.06.30.01.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 01:14:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Dong, Eddie" <eddie.dong@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 04/14] KVM: VMX: Extend VMX controls macro shenanigans
In-Reply-To: <BL0PR11MB3042FA68F1EA02B5300E01168ABB9@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220627160440.31857-1-vkuznets@redhat.com>
 <20220627160440.31857-5-vkuznets@redhat.com>
 <BL0PR11MB304264B62299D642FF906C298AB99@BL0PR11MB3042.namprd11.prod.outlook.com>
 <YrpbiWw1E4DXQ962@google.com>
 <BL0PR11MB3042FA68F1EA02B5300E01168ABB9@BL0PR11MB3042.namprd11.prod.outlook.com>
Date:   Thu, 30 Jun 2022 10:14:24 +0200
Message-ID: <87o7yash3z.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Dong, Eddie" <eddie.dong@intel.com> writes:

>> -----Original Message-----
>> From: Sean Christopherson <seanjc@google.com>
>> Sent: Monday, June 27, 2022 6:38 PM
>> To: Dong, Eddie <eddie.dong@intel.com>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>; kvm@vger.kernel.org; Paolo
>> Bonzini <pbonzini@redhat.com>; Anirudh Rayabharam
>> <anrayabh@linux.microsoft.com>; Wanpeng Li <wanpengli@tencent.com>;
>> Jim Mattson <jmattson@google.com>; Maxim Levitsky
>> <mlevitsk@redhat.com>; linux-hyperv@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH 04/14] KVM: VMX: Extend VMX controls macro
>> shenanigans
>>=20
>> On Mon, Jun 27, 2022, Dong, Eddie wrote:
>> > >  static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, =
u##bits
>> > > val)	\
>> > >  {
>> > > 	\
>> > > +	BUILD_BUG_ON(!(val & (KVM_REQ_VMX_##uname |
>> > > KVM_OPT_VMX_##uname)));	\
>> > >  	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);
>> > > 	\
>> > >  }
>> >
>> > With this, will it be safer if we present L1 CTRL MSRs with the bits
>> > KVM really uses? Do I miss something?
>>=20
>> KVM will still allow L1 to use features/controls that KVM itself doesn't=
 use, but
>> exposing features/controls that KVM doesn't use will require a more expl=
icit
>> "override" of sorts, e.g. to prevent advertising features that are suppo=
rted in
>> hardware, known to KVM, but disabled for whatever reason, e.g. a CPU bug,
>> eVMCS incompatibility, module param, etc...
> Mmm, that is fine too.
> But, do we consider the potential need of migration for a L1 VMM ?
> Normally the VM can be configured to be as hardware neutral for better
> compatibility, or exposing as close to hardware feature as possible
> for performance.
> For nested features, I thought we didn't support migration if L1 VMM
> yet, so exposing hardware capability by default is fine at moment. We
> may revisit one day in future if we need to support migration.

Not sure I got your point, nested state migration is fully supported in
KVM. When migrating a guest, KVM makes sure the list of features exposed
in VMX control MSRs remain the same. This may not be the case if you use
something like "-cpu host" in QEMU but the problems are not specific to
nesting.

>  This MACRO do help anyway =F0=9F=98=8A
>
>>=20
>> The intent of this BUILD_BUG_ON() is to detect KVM usage of bits that ar=
en't
>> enabled by default, i.e. to lower the probability that a control gets us=
ed by KVM
>> but isn't exposed to L1 because it's a dynamically enabled control.

--=20
Vitaly

