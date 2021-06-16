Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B003AA29F
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 19:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhFPRtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 13:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhFPRtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 13:49:18 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BDEC061574
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 10:47:10 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id v17-20020a4aa5110000b0290249d63900faso910759ook.0
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 10:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cM02HS/PMjqrRxsJo7fWslNCAX1mj5zuYgMI3gUj+jE=;
        b=Ts/G6GbnfuolLC1pv72oLVJkb6NI4XMDGBSUkgCzZ55GRrmLuvIagGcSb5rrRFRYQP
         FCFnLUHdRbUTd4KDQ+Bw7vbJ0PWW8pQxe203rrLzBlTSF+AxASAsL3pFmXwFHQL/UnXW
         6KlLhi0anfd/KbIzs6NP8sADATqcK+ZMuAERMxQODbNxbv7bCEN0jYBJ4L5IDhX4J+YJ
         C2CjalXPG1RufF73C9TGNn8LXu0kH9nQ44WKJW5Bv9fycKulgEuSSv9dtYRZQ3oskBg5
         ncLY4pnY9exIv8BZl6WJCGD9MpBVgfBZnM/6rxztLl0FW9iE4fN71qKDBjS6/SU1bLa6
         E3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cM02HS/PMjqrRxsJo7fWslNCAX1mj5zuYgMI3gUj+jE=;
        b=DO/aouatuukXTdcAPYhsZN232ZG3N7K3K+xTELGvGwUWPt1Q+E2qADgT5Q86xJ4j+7
         i18TGV6PMyCbDRKV83zZ7/YIcfD72+V7MF1CYMcXUFz6JXaSk4YZsQHFRyoqFLcC/97i
         o3+qjPOcRatyDLhX0tcrRCc+1+9SZPu9oKDHgpNp/Qe3q4LQIAXS2vRwU1aDx/QKgT9P
         vr0vJH+Q3QiNR0qYi8Sfq1Di7lwfL8DEOBf/tHtvpLCkBReSMldSy74YFYOa2kXZaK3T
         obU8DuFBC5tcvPRwXqvDuHl4kjRwFeoihBLoorT1KmfzFJJchX7S/psFuVgCfjeHre+4
         w0rA==
X-Gm-Message-State: AOAM531FgDkKLUvJKxf7z1ni/Ww1PFyKC39c3/79CkQS+TbvkHD0m5ab
        q9AIwV1tAR7Y99e26P/ILxbHBQ5d/J0KMghUIggGL+OfHE0=
X-Google-Smtp-Source: ABdhPJwgITJKDJxn4RJdjSZ75aD9Or2/gkeLlR19S+7gII19Bn3PsGKUDT0x4GZmloP3+BTcuWv8QKbDyS8AeDafv0U=
X-Received: by 2002:a4a:e4c1:: with SMTP id w1mr972375oov.81.1623865629960;
 Wed, 16 Jun 2021 10:47:09 -0700 (PDT)
MIME-Version: 1.0
References: <DM4PR12MB52648CB3F874AC3B7C41A19DB1309@DM4PR12MB5264.namprd12.prod.outlook.com>
 <DM4PR12MB52646AE63A2FAEAD4DAE76D7B1309@DM4PR12MB5264.namprd12.prod.outlook.com>
 <CALMp9eTOAzr7jCWD_h39uZe7_d6bozvS1YmrASptgcw1fwLN8Q@mail.gmail.com> <DM4PR12MB5264C61CB256AF26522D548DB10F9@DM4PR12MB5264.namprd12.prod.outlook.com>
In-Reply-To: <DM4PR12MB5264C61CB256AF26522D548DB10F9@DM4PR12MB5264.namprd12.prod.outlook.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 16 Jun 2021 10:46:58 -0700
Message-ID: <CALMp9eR64M0V_FY_tziOwmuJL+QexoP5q1UaJ5Abv=-4=8ohAQ@mail.gmail.com>
Subject: Re: Controlling the guest TSC on x86
To:     Stephan Tobies <Stephan.Tobies@synopsys.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 16, 2021 at 5:24 AM Stephan Tobies
<Stephan.Tobies@synopsys.com> wrote:
>
> Hi Jim,
>
> Thanks for the feedback. Some of the headache that you mention is hopeful=
ly avoided by the fact that both APIC and RTC time domain are also running =
under the control of the (external) SystemC scheduler, but we will be on th=
e lookup for trouble.
>
> Somehow I still have not been able to get it to work, probably because I =
have not been able to match your description with my external view of KVM. =
What is wrong with the following algorithm (assuming that we want to run gu=
est and host at the same speed):
>
> 1) on each return from ioctl(..., KVM_RUN, ...) read the host TSC with rd=
tsc
> 2) before each call to ioctl(..., KVM_RUN, ...) read the host TSC again a=
nd set the MSR_IA32_TSC_ADJUST so the sum of such accumulated deltas

That should be the inverse of the sum of the accumulated deltas.

> Why would I need to read the guest TSC, as you have mentioned in your ans=
wer?

You seem to have a lot more tolerance for slop than I was expecting,
if you are happy to count time spent in the host kernel. I was trying
to get the tightest bounds possible on time spent actually running
guest code.

> Do I need to do something else? Because to me it looks like just writing =
the MSR_IA32_TSC_ADJUST does not lead to a recomputation of the guest TSC. =
(Or is this the answer to my previous question?)

Hmmm. Does the guest CPUID information enumerate support for
IA32_TSC_ADJUST? (i.e., is
CPUID.(EAX=3D07H,ECX=3D0):EBX.IA32_TSC_ADJUST[bit 1] set in the guest?)

> Best regards
>
> Stephan
>
> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Tuesday, June 15, 2021 6:59 PM
> To: Stephan Tobies <tobies@synopsys.com>
> Cc: kvm@vger.kernel.org
> Subject: Re: Controlling the guest TSC on x86
>
> On Tue, Jun 15, 2021 at 5:20 AM Stephan Tobies <Stephan.Tobies@synopsys.c=
om> wrote:
> >
> > Good afternoon!
> >
> > We are looking at the use of KVM on x86 to emulate an x86 processor in =
a Virtual Prototyping/SystemC context. The requirements are such that the g=
uest OS should be ideally run unmodified (i.e., in this case ideally withou=
t any drivers that know and exploit the fact that the guest is not running =
on real HW but as a KVM guest).
> >
> > For this, we also would like to control the TSC (as observed by the gue=
st via rdtsc and related instructions) in such a way that time is apparentl=
y stopped whenever the guest is not actively executing in KVM_RUN.
> >
> > I must admit that I am confused by the multitude of mechanism and MSRs =
that are available in this context. So, how would one best achieve to (appr=
oximately) stop the increment of the TSC when the guest is not running. If =
this is important, we are also not using the in-chip APIC but are using our=
 own SystemC models. Also, are there extra considerations when running mult=
iple virtual processors?
> >
> > Any pointers would be greatly appreciated!
> >
> > Thanks and best regards
> >
> > Stephan Tobies
>
> You can use the VM-exit MSR-save list to save the value of the TSC on VM-=
exit, and then you can adjust the TSC offset field in the VMCS just before =
VM-entry to subtract any time the vCPU wasn't in VMX non-root operation. Th=
ere will be some slop here, since the guest TSC will run during VM-entry an=
d part of VM-exit. However, this is just the beginning of your troubles. It=
 will be impossible to keep the TSCs synchronized across multiple vCPUs thi=
s way. Moreover, the TSC time domain will get out of sync with other time d=
omains, such as the APIC time domain and the RTC time domain. Maybe it's en=
ough to report to the guest that CPUID.80000007H:EDX.INVARIANT_TSC[bit 8] i=
s zero, but I suspect you are in for a lot of headaches.
