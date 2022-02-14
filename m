Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81B24B5DF4
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 23:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiBNW4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 17:56:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiBNW4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 17:56:06 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD52181A6D
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 14:55:58 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id p190-20020a4a2fc7000000b0031820de484aso21090541oop.9
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 14:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=spvxDtlt5+ktYj36AIdEZJqVu99chNyMvvg7tUj6aEI=;
        b=ZxoPU7z8gw60MenkYz/71ZB8IHJtK55kzry17nNMiOoPCBbB9a9GpJmtQk2u9HzxXf
         ttPOzToK6CQosy3TFNr8UhA7rjlORwnVoYMiEMSi1OoEBwPVAneoJTttniuFw1QDZui4
         14lUz+fltfC6tGSZLL8QD9hr2aFjbC2CHde7IXMf68Xczu+1WE2YA6+kE/axfu/CfQEj
         rQfI4PyMKspBhtc2tNuFE+zbTpmD36Cx37Zkha3QiGVFea07BIjEaR+dDWa56p/JanNo
         3uFJlj9qz1ND+9frWgWXzDaR4UUJpyZQxQdiJYYKB3QZdyd14KhttSLPuhZSbG7yE5qS
         iOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=spvxDtlt5+ktYj36AIdEZJqVu99chNyMvvg7tUj6aEI=;
        b=jgRXrSog08b8bkHOFY3wrqQViEm4y6+hFU3qOTri43yIff0MgnuxMKjYj0dm9nZ5W3
         l38aC0/MvVQmhsX/O6KWFrwqWEZaHQxtU3j48r6+uLuCJzeILxQ+oGgehJtTcUF6EpL9
         0JqtOpC2RVEbYMx4Meh/2WrYN7k+dmPs7AYEJeuCsVHi7ruXP0slnpUZQnN+qip6ONkh
         eIr3cE4LuoKwByaIZAaXQ3XbUwZ1/LVMDc62NhnhCgPMe/oGEjNUGx2KSLUH2O8rn0tn
         vdzn3mpflSNAmy0vNBUIlps1yu3HY38LM7pM2l35u/eoV3nGQ7h9pInL0cW2XCDVI606
         x/Tw==
X-Gm-Message-State: AOAM532GX4PCP7g6e5mLHwFvIiEnMzHAXnCNTQwBMeQmQ+JcJ7To/U1G
        M3INc7bOt6ATYnVa3T9tALIIF0XqLsGAg0O2FagTLJrMLKphcA==
X-Google-Smtp-Source: ABdhPJxxa4N11anClftEoIwDrshqyvafuilNJDSgQQlBcWlv0kKPstz9WgCkoy1RZuqUyJT5Cyk6X3FOr/zwxeUvJZ8=
X-Received: by 2002:a4a:ddc1:: with SMTP id i1mr351889oov.96.1644879357011;
 Mon, 14 Feb 2022 14:55:57 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
 <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com> <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com> <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com> <CALMp9eTOaWxQPfdwMSAn-OYAHKPLcuCyse7BpsSOM35vg5d0Jg@mail.gmail.com>
 <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com> <CALMp9eSjDro169JjTXyCZn=Rf3PT0uHhdNXEifiXGYQK-Zn8LA@mail.gmail.com>
 <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com> <CABOYuvZ9SZAWeRkrhhhpMM4XwzMzXv9A1WDpc6z8SUBquf0SFQ@mail.gmail.com>
 <6afcec02-fb44-7b72-e527-6517a94855d4@linux.intel.com> <CALMp9eQ79Cnh1aqNGLR8n5MQuHTwuf=DMjJ2cTb9uXu94GGhEA@mail.gmail.com>
 <2180ea93-5f05-b1c1-7253-e3707da29f8c@linux.intel.com> <CALMp9eQiaXtF3S0QZ=2_SWavFnv6zFHqf_zFXBrxXb9pVYh0nQ@mail.gmail.com>
 <8d9149b5-e56f-b397-1527-9f21a26ad95b@linux.intel.com>
In-Reply-To: <8d9149b5-e56f-b397-1527-9f21a26ad95b@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Feb 2022 14:55:46 -0800
Message-ID: <CALMp9eTqNyG-ke1Aq72hn0CVXER63SgVPamzXria76PmqiZvJQ@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     David Dunn <daviddunn@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 1:55 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
>
>
>
> On 2/12/2022 6:31 PM, Jim Mattson wrote:
> > On Fri, Feb 11, 2022 at 1:47 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
> >>
> >>
> >>
> >> On 2/11/2022 1:08 PM, Jim Mattson wrote:
> >>> On Fri, Feb 11, 2022 at 6:11 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2/10/2022 2:55 PM, David Dunn wrote:
> >>>>> Kan,
> >>>>>
> >>>>> On Thu, Feb 10, 2022 at 11:46 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
> >>>>>
> >>>>>> No, we don't, at least for Linux. Because the host own everything. It
> >>>>>> doesn't need the MSR to tell which one is in use. We track it in an SW way.
> >>>>>>
> >>>>>> For the new request from the guest to own a counter, I guess maybe it is
> >>>>>> worth implementing it. But yes, the existing/legacy guest never check
> >>>>>> the MSR.
> >>>>>
> >>>>> This is the expectation of all software that uses the PMU in every
> >>>>> guest.  It isn't just the Linux perf system.
> >>>>>
> >>>>> The KVM vPMU model we have today results in the PMU utilizing software
> >>>>> simply not working properly in a guest.  The only case that can
> >>>>> consistently "work" today is not giving the guest a PMU at all.
> >>>>>
> >>>>> And that's why you are hearing requests to gift the entire PMU to the
> >>>>> guest while it is running. All existing PMU software knows about the
> >>>>> various constraints on exactly how each MSR must be used to get sane
> >>>>> data.  And by gifting the entire PMU it allows that software to work
> >>>>> properly.  But that has to be controlled by policy at host level such
> >>>>> that the owner of the host knows that they are not going to have PMU
> >>>>> visibility into guests that have control of PMU.
> >>>>>
> >>>>
> >>>> I think here is how a guest event works today with KVM and perf subsystem.
> >>>>        - Guest create an event A
> >>>>        - The guest kernel assigns a guest counter M to event A, and config
> >>>> the related MSRs of the guest counter M.
> >>>>        - KVM intercepts the MSR access and create a host event B. (The
> >>>> host event B is based on the settings of the guest counter M. As I said,
> >>>> at least for Linux, some SW config impacts the counter assignment. KVM
> >>>> never knows it. Event B can only be a similar event to A.)
> >>>>        - Linux perf subsystem assigns a physical counter N to a host event
> >>>> B according to event B's constraint. (N may not be the same as M,
> >>>> because A and B may have different event constraints)
> >>>>
> >>>> As you can see, even the entire PMU is given to the guest, we still
> >>>> cannot guarantee that the physical counter M can be assigned to the
> >>>> guest event A.
> >>>
> >>> All we know about the guest is that it has programmed virtual counter
> >>> M. It seems obvious to me that we can satisfy that request by giving
> >>> it physical counter M. If, for whatever reason, we give it physical
> >>> counter N isntead, and M and N are not completely fungible, then we
> >>> have failed.
> >>>
> >>>> How to fix it? The only thing I can imagine is "passthrough". Let KVM
> >>>> directly assign the counter M to guest. So, to me, this policy sounds
> >>>> like let KVM replace the perf to control the whole PMU resources, and we
> >>>> will handover them to our guest then. Is it what we want?
> >>>
> >>> We want PMU virtualization to work. There are at least two ways of doing that:
> >>> 1) Cede the entire PMU to the guest while it's running.
> >>
> >> So the guest will take over the control of the entire PMUs while it's
> >> running. I know someone wants to do system-wide monitoring. This case
> >> will be failed.
> >
> > We have system-wide monitoring for fleet efficiency, but since there's
> > nothing we can do about the efficiency of the guest (and those cycles
> > are paid for by the customer, anyway), I don't think our efficiency
> > experts lose any important insights if guest cycles are a blind spot.
>
> Others, e.g., NMI watchdog, also occupy a performance counter. I think
> the NMI watchdog is enabled by default at least for the current Linux
> kernel. You have to disable all such cases in the host when the guest is
> running.

It doesn't actually make any sense to run the NMI watchdog while in
the guest, does it?

> >
> >> I'm not sure whether you can fully trust the guest. If malware runs in
> >> the guest, I don't know whether it will harm the entire system. I'm not
> >> a security expert, but it sounds dangerous.
> >> Hope the administrators know what they are doing when choosing this policy.
> >
> > Virtual machines are inherently dangerous. :-)
> >
> > Despite our concerns about PMU side-channels, Intel is constantly
> > reminding us that no such attacks are yet known. We would probably
> > restrict some events to guests that occupy an entire socket, just to
> > be safe.
> >
> > Note that on the flip side, TDX and SEV are all about catering to
> > guests that don't trust the host. Those customers probably don't want
> > the host to be able to use the PMU to snoop on guest activity.
> >
> >>> 2) Introduce a new "ultimate" priority level in the host perf
> >>> subsystem. Only KVM can request events at the ultimate priority, and
> >>> these requests supersede any other requests.
> >>
> >> The "ultimate" priority level doesn't help in the above case. The
> >> counter M may not bring the precise which guest requests. I remember you
> >> called it "broken".
> >
> > Ideally, ultimate priority also comes with the ability to request
> > specific counters.
> >
> >> KVM can fails the case, but KVM cannot notify the guest. The guest still
> >> see wrong result.
> >>
> >>>
> >>> Other solutions are welcome.
> >>
> >> I don't have a perfect solution to achieve all your requirements. Based
> >> on my understanding, the guest has to be compromised by either
> >> tolerating some errors or dropping some features (e.g., some special
> >> events). With that, we may consider the above "ultimate" priority level
> >> policy. The default policy would be the same as the current
> >> implementation, where the host perf treats all the users, including the
> >> guest, equally. The administrators can set the "ultimate" priority level
> >> policy, which may let the KVM/guest pin/own some regular counters via
> >> perf subsystem. That's just my personal opinion for your reference.
> >
> > I disagree. The guest does not have to be compromised. For a proof of
> > concept, see VMware ESXi. Probably Microsoft Hyper-V as well, though I
> > haven't checked.
>
> As far as I know, VMware ESXi has its own VMkernel, which can owns the
> entire HW PMUs.  The KVM is part of the Linux kernel. The HW PMUs should
> be shared among components/users. I think the cases are different.

Architecturally, ESXi is not very different from Linux. The VMkernel
is a posix-compliant kernel, and VMware's "vmm" is comparable to kvm.

> Also, from what I searched on the VMware website, they still encounter
> the case that a guest VM may not get a performance monitoring counter.
> It looks like their solution is to let guest OS check the availability
> of the counter, which is similar to the solution I mentioned (Use
> GLOBAL_INUSE MSR).
>
> "If an ESXi host's BIOS uses a performance counter or if Fault Tolerance
> is enabled, some virtual performance counters might not be available for
> the virtual machine to use."

I'm perfectly happy to give up PMCs on Linux under those same conditions.

> https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-F920A3C7-3B42-4E78-8EA7-961E49AF479D.html
>
> "In general, if a physical CPU PMC is in use, the corresponding virtual
> CPU PMC is not functional and is unavailable for use by the guest. Guest
> OS software detects unavailable general purpose PMCs by checking for a
> non-zero event select MSR value when a virtual machine powers on."
>
> https://kb.vmware.com/s/article/2030221
>
Linux, at least, doesn't do that. Maybe Windows does.

> Thanks,
> Kan
>
