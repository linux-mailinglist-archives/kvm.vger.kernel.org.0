Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB177D7868
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 01:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjJYXMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 19:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJYXMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 19:12:06 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C7AA3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 16:12:04 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-5ab53b230f1so255737a12.3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 16:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=clockwork.io; s=google; t=1698275524; x=1698880324; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VdsO2fn4TDNnXV3IAOvr7mAfe6mzBkpBP/ktHPK8l4=;
        b=KX8NFS/ghVLwqNXEKGVpalGylVdQv6fnRskIkvGe1oPxlqbdd67XUH3N/HjYfJVbtB
         OokaejiNLJSFjY6Vl4QvLRBsQI1y8AaMjjmQ6/+fcye1pWodb6HfCrLpEJX3zfekfDjg
         QzwoPy77S4yYgeFPRYBK2gscwQnGlRZzWRIAW7xiIHHDxsIBNlCx2N+y97NVzhqwITFI
         dHttXN/OPX5pwN/B9qQLXMBaaw2MmDwPhc6YYlcCNGIVdgZdXjmyJe/pARCLthXfRtH6
         agjggjLRUp/cqiFdmPOikdrrsBBPu/68N+GOil15KTzY3LL4JTPXqO3LFt10/Tr600dx
         szzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698275524; x=1698880324;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0VdsO2fn4TDNnXV3IAOvr7mAfe6mzBkpBP/ktHPK8l4=;
        b=sJUqL+t7rXlfEtQinQgiECxIfyds8g7Is6WW/XtvIZDfjDLFWJoMw7B0bFQGTLqHyc
         avhh69X+4WLz6hsONm6ijZNDobVQE2BLta3Ei/lTMxrKcPQexmoAl1mPrUuYhqmHb5CO
         Tv7Qnh9228h/SbThOFOfbjoSeSbrxfFiiHkkokI8eooiK4AKYr2ITj6XciFLZLbRkozU
         Clmwa/QFvjylWfiQ8uuVDGScPloEh6EdfyuN9etgQxroSaFCJi3ORtp8A1R102OK71Sn
         zURswxLQqECtisu/JqoIm/cHeaucUAT4Ox8qOVZnKz+qsy4AE5VtFmnLYc2j9n9X6uGK
         8XfQ==
X-Gm-Message-State: AOJu0YzQzA34IiWcqBvvc+AfCtDOWsY098iwvGrvZmWjVfh6nT55Rqip
        MNSI8/ks+xeWtlftq/CX6e4KXv9iR4wFMPxGjhPh
X-Google-Smtp-Source: AGHT+IGsPrxIWaiaVMSVIT9F7AUJzVwm2BFsru/QPcI0gyWnogDDWBa7P9M5p+LDBz2pbiu5xnz6lg==
X-Received: by 2002:a05:6a21:7985:b0:17b:8b42:787c with SMTP id bh5-20020a056a21798500b0017b8b42787cmr6267216pzc.57.1698275523726;
        Wed, 25 Oct 2023 16:12:03 -0700 (PDT)
Received: from smtpclient.apple ([2601:640:8b80:18f0:8032:b29:e788:ff55])
        by smtp.gmail.com with ESMTPSA id a5-20020aa78e85000000b00692c5b1a731sm9746056pfr.186.2023.10.25.16.12.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Oct 2023 16:12:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: Questions about TSC virtualization in KVM
From:   Yifei Ma <yifei@clockwork.io>
In-Reply-To: <ZTf_2MN3uyHFtWqa@google.com>
Date:   Wed, 25 Oct 2023 16:11:52 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2969750E-51D3-4284-B093-23FD27736582@clockwork.io>
References: <594A322A-8100-429A-A3E8-64362E3ED5A2@clockwork.io>
 <ZTf_2MN3uyHFtWqa@google.com>
To:     Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you for your input, Sean.

I went through the SDM virtual machine extensions chapter, and some KVM =
patches and it helped me a lot. My understanding is:

If the RDTSC existing flied in the VMCS is not set, then the rdtsc from =
non-root model won=E2=80=99t cause VM-exit. In this case, the TSC =
returned to non-root is the value of the physical TSC * scaling + =
offset, if scaling and offset are set by KVM.

The TSC offset and scaling of a vCPU can be set from root-mode through =
KVM APIs using command KVM_VCPU_TSC_CTRL & KVM_SET_TSC_KHZ , and they =
are written to the vCPU=E2=80=99s VMCS fields. Next time, non-root mode =
calls rdtsc, the VMX hardware will add the offset & scaling to the =
physical TSC.

Is my understanding correct? Of cause, I will do some testing to verify =
it.

Thank you,

Yifei

> On Oct 24, 2023, at 10:33 AM, Sean Christopherson <seanjc@google.com> =
wrote:
>=20
> On Tue, Oct 24, 2023, Yifei Ma wrote:
>> Hi KVM community,
>>=20
>>   I am trying to figure out how TSC is virtualized in KVM-VMX world.
>>   According to the kernel documentation, reading TSC register through =
MSR
>>   can be trapped into KVM and VMX. I am trying to figure out the KVM =
code
>>   handing this trap.
>=20
> Key word "can".  KVM chooses not to intercept RDMSR to MSR_IA32_TSC =
because
> hardware handles the necessary offset and scaling.  KVM does still =
emulate reads
> in kvm_get_msr_common(), e.g. if KVM is forced to emulate a RDMSR, but =
that's a
> very, very uncommon path.
>=20
> Ditto for the RDTSC instruction, which isn't subject to MSR =
intercpetion bitmaps
> and has a dedicated control.  KVM will emulate RDTSC if KVM is already =
emulating,
> but otherwise the guest can execute RDTSC without triggering a =
VM-Exit.
>=20
> Modern CPUs provide both a offset and a scaling factor for VMX guests, =
i.e. the
> CPU itself virtualizes guest TSC.  See the RDMSR and RDTSC bullet =
points in the
> "CHANGES TO INSTRUCTION BEHAVIOR IN VMX NON-ROOT OPERATION" section of =
the SDM
> for details.
>=20
>>   In order to understand it, I have run a kernel traced by GDB, and =
added
>>   break points to the code I thought they may handle the MSR trap, =
e.g.,
>>   kvm_get_msr, vmx_exec_control, etc. Then ran rdtsc from guest =
application,
>>   however, it  didn=E2=80=99t trigger these breakpoints. I am a =
little lost in how
>>   TSC is virtualized.
>>=20
>>   Two questions:
>>   - does the TSC MRS instructions are emulated and trapped into KVM?
>=20
> Nope, see above.
>=20
>>   - if TSC is trapped, which code handles it?
>=20
> Also see above :-)
>=20
>> Any background about TSC virtualization and suggestions on tracing =
its
>> virtualization are appreciated.

