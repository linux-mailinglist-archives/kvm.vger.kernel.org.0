Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D1170FF5F
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 22:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbjEXUlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 16:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjEXUl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 16:41:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B577B1A1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:41:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8b0fc0d35so2704887276.0
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684960884; x=1687552884;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Iul0kHsDDBIMkRjjxSLc4fLniZYBy+EWsFZsDM8Kcto=;
        b=NcgYe7P46NM/BXRpKCRMdSSVwKHKuRWJkiIEXNenTBQ9dAIx3046LHvWtwba4Whnqp
         UeOZqUbBuX4tjG6sFSBIX3c8fsFJTHo3T3j0AIbFQwtul+Uky8dXkRIsq4mDmNXLYOlt
         sQt7wBLPwOVes8EFLbSz6LYB2SNch564wnoNNs0py/WAjNW9WUwFhE2QIG1cI4InxhoV
         wiVu/T9H+LqvQIo+9pJFmwKqTY2LcbQJYj4YQNVfDhu3OSNAFJ86nqVcx1oumaEAsS1a
         BOgzx2lPVHhl/jrWuedMRR7W1nQpGxCpZkWlzvE2s3lJdgozJ1788c14WWbg7N92zZ4G
         kR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684960884; x=1687552884;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Iul0kHsDDBIMkRjjxSLc4fLniZYBy+EWsFZsDM8Kcto=;
        b=CLA5iLDLjtjCS6OK9+T0W5iyowpR8Anoks91kxmlltKQu86nxj4qOJBSRdnii52qdk
         DE95pXtdDvjh9/zkKA4dwPO616kVNeKMXORBzMl++TV3DSfUagCaJyt7ZArTWuIOif2i
         nGcq8eh0iZYR6C/Pl8uzdWgsIqK0SXD9msNTHm1xoLiSCjkAVgUlp3xZJgRmiF46iMts
         40HU7AQ8RQWKCHhm5NnIHe+fcSB4KzZO/crz8at2RTva8lchfTPMkuxuOqX8R3MX28on
         6IdhfGdSn4FQH1LFYfV/FMFfMZKYXque5kKq51pioQv9D5cvEvfkMuwE7sX0na8G5iek
         NObg==
X-Gm-Message-State: AC+VfDx9y2IONQjpx2jwRTbkaC3zTqrCl5xGuF94RRyWOvkb0bRn9+UK
        WiRdBBYs7V/yafEwvXQycGmyNq1qcN8=
X-Google-Smtp-Source: ACHHUZ4R9pCE3083TT4fAAGi9PeTp0eyguidk3+Nfuf1mBmGcVCxAg8KERrjWBo4+VSfROaFY1v4l+KNkZ8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1826:b0:bac:46d0:96ef with SMTP id
 cf38-20020a056902182600b00bac46d096efmr473049ybb.2.1684960884016; Wed, 24 May
 2023 13:41:24 -0700 (PDT)
Date:   Wed, 24 May 2023 13:41:22 -0700
In-Reply-To: <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com>
Mime-Version: 1.0
References: <20230310105346.12302-1-likexu@tencent.com> <20230310105346.12302-6-likexu@tencent.com>
 <ZC99f+AO1tZguu1I@google.com> <509b697f-4e60-94e5-f785-95f7f0a14006@gmail.com>
 <ZDAvDhV/bpPyt3oX@google.com> <34b5dd08-edac-e32f-1884-c8f2b85f7971@gmail.com>
 <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com>
Message-ID: <ZG52cgmjgaqY8jvq@google.com>
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
From:   Sean Christopherson <seanjc@google.com>
To:     Sandipan Das <sandipan.das@amd.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        "Tom Lendacky (AMD)" <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023, Sandipan Das wrote:
> Hi Sean, Like,
>=20
> On 4/19/2023 7:11 PM, Like Xu wrote:
> >> Heh, it's very much explicable, it's just not desirable, and you and I=
 would argue
> >> that it's also incorrect.
> >=20
> > This is completely inaccurate from the end guest pmu user's perspective=
.
> >=20
> > I have a toy that looks like virtio-pmu, through which guest users can =
get hypervisor performance data.
> > But the side effect of letting the guest see the VMRUN instruction by d=
efault is unacceptable, isn't it ?
> >=20
> >>
> >> AMD folks, are there plans to document this as an erratum?=EF=BF=BD I =
agree with Like that
> >> counting VMRUN as a taken branch in guest context is a CPU bug, even i=
f the behavior
> >> is known/expected.
> >=20
>=20
> This behaviour is architectural and an erratum will not be issued. Howeve=
r, for clarity, a future
> release of the APM will include additional details like the following:
>=20
>   1) From the perspective of performance monitoring counters, VMRUNs are =
considered as far control
>      transfers and VMEXITs as exceptions.
>=20
>   2) When the performance monitoring counters are set up to count events =
only in certain modes
>      through the "OsUserMode" and "HostGuestOnly" bits, instructions and =
events that change the
>      mode are counted in the target mode. For example, a SYSCALL from CPL=
 3 to CPL 0 with a
>      counter set to count retired instructions with USR=3D1 and OS=3D0 wi=
ll not cause an increment of
>      the counter. However, the SYSRET back from CPL 0 to CPL 3 will cause=
 an increment of the
>      counter and the total count will end up correct. Similarly, when cou=
nting PMCx0C6 (retired
>      far control transfers, including exceptions and interrupts) with Gue=
st=3D1 and Host=3D0, a VMRUN
>      instruction will cause an increment of the counter. However, the sub=
sequent VMEXIT that occurs,
>      since the target is in the host, will not cause an increment of the =
counter and so the total
>      count will end up correct.

The count from the guest's perspective does not "end up correct".  Unlike S=
YSCALL,
where _userspace_ deliberately and synchronously executes a branch instruct=
ion,
VMEXIT and VMRUN are supposed to be transparent to the guest and can be com=
pletely
asynchronous with respect to guest code execution, e.g. if the host is spam=
ming
IRQs, the guest will see a potentially large number of bogus (from it's per=
spective)
branches retired.
