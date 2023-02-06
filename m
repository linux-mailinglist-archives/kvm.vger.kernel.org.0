Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFDF68C55F
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 19:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjBFSHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 13:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBFSHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 13:07:44 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B466234F5
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 10:07:42 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id bx22so9496427pjb.3
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 10:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qtgxlCHcEg9/GzAJkVDlK65BAtBBeUjha9tRmSPN4Fk=;
        b=m0F2ArAPmzZy09CrcjGX7iTzr+uhlPBQ555MwCtERC8mt63i+Xhj7AiosNKzev2DN6
         c55LVAwhrehy+4ivJEiS0u3Z4e8RtCVNwQ+hUWLBqGM4KLcFfyVkUefMzryCi/WOc6dk
         mvZ9xkMCr1A19Qu+xTfKPOGtjb4qEmEgE7RuQceNAjCkuY7zZ6Gvm1vxsHW4bFS7fTtR
         Q2jxmXu3X7kZPVjfEqW6Cn+uJRF9nPh/D0CEse+ZGKymRshTejV6rfl5J//NvCHQWjOY
         K/T3LABwVp5Knbn/MtITU6ILke3Y54fIkWFBBvXLWkCOMhb56tMI77sCNqON4XcRKEVf
         HnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qtgxlCHcEg9/GzAJkVDlK65BAtBBeUjha9tRmSPN4Fk=;
        b=Z6U3rkvikkgncO2RDCimiqdHU6xqvWwC4ddDdxUEJjl/zS51ZZ7/LlYDPX5pHKyV6g
         wEhVhkO9KAJGWefln5B91XSuhWjWnmz+Yfz16RXNQOTw0tf6AbC3SAaYqtIC5N2pdsuU
         NU83Vqe9Pw/1XbIWdbhB9Efg6LtZPrGDr5M+d40bI5dj+NvW+kpUkxgGu0VdQRyQQ20k
         aASEednS2fuQ3b+u7d5zNwhyFGpLtyGfelzBMOTB9BsvKSaR00/y5MRYPsyfiD6JJUl/
         yTuJ+tgjLwv9mEJ2Xf5/fBdBdoolab9A9AESBAQhgT39yOwHv57wrfsahMrKFrcaSUE2
         gvZA==
X-Gm-Message-State: AO0yUKXnYUxgChLVyn0FyJggjOLxkghIkK5OOhvCAVi9SJDaWUAaUrwt
        PEskZkTFbYHic66FbQ0/S8040w==
X-Google-Smtp-Source: AK7set+FNGN/RCOWlSdzdtzluoZ+K/foAvCsXIhYX06GiwX2da2SFNcUJTaK2kNEudSPg/pNZymBaA==
X-Received: by 2002:a17:903:40ce:b0:189:6624:58c0 with SMTP id t14-20020a17090340ce00b00189662458c0mr39207pld.3.1675706861570;
        Mon, 06 Feb 2023 10:07:41 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o6-20020a637306000000b004d346876d37sm6458097pgc.45.2023.02.06.10.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 10:07:40 -0800 (PST)
Date:   Mon, 6 Feb 2023 18:07:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        rja@hpe.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: Re: [External] Re: [PATCH v6 07/11] x86/smpboot: Disable parallel
 boot for AMD CPUs
Message-ID: <Y+FB6f6MEBy2g3Ft@google.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com>
 <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
 <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org>
 <5ba476f3-e0ac-d630-ce1d-18ab9885496f@linux.intel.com>
 <E2286684-F8AD-4708-9A3D-74C5EAE183B4@infradead.org>
 <434b4b74-54ab-68a3-4a81-9cc02ea75e39@bytedance.com>
 <411cbdb2c8255e48f3e65c59a98bc02410f5dfc7.camel@infradead.org>
 <de7524ce-563c-2ff6-84a5-6a347c36855b@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de7524ce-563c-2ff6-84a5-6a347c36855b@bytedance.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023, Usama Arif wrote:
> 
> 
> On 06/02/2023 08:05, David Woodhouse wrote:
> > On Sun, 2023-02-05 at 22:13 +0000, Usama Arif wrote:
> > > 
> > > 
> > > On 04/02/2023 22:31, David Woodhouse wrote:
> > > > 
> > > > 
> > > > On 4 February 2023 18:18:55 GMT, Arjan van de Ven <arjan@linux.intel.com> wrote:
> > > > > > 
> > > > > > However...
> > > > > > 
> > > > > > Even though we *can* support non-X2APIC processors, we *might* want to
> > > > > > play it safe and not go back that far; only enabling parallel bringup
> > > > > > on machines with X2APIC which roughly correlates with "lots of CPUs"
> > > > > > since that's where the benefit is.
> > > > > 
> > > > > I think that this is the right approach, at least on the initial patch series.
> > > > > KISS principle; do all the easy-but-important cases first, get it stable and working
> > > > > and in later series/kernels the range can be expanded.... if it matters.
> > > > 
> > > > Agreed. I'll split it to do it only with X2APIC for the initial series,

And sanity check CPUID.0xB output even when x2APIC is supported, e.g. require
CPUID.0xB.EBX to be non-zero.  Odds are very good that there are VMs in the wild
that support x2APIC but have an empty CPUID.0xB due to it being a topology leaf,
i.e. may be suppressed when vCPUs aren't pinned.  QEMU even has a knob to deliberately
disable CPUID.0xB, e.g. booting a VM with

 cpu host,host-phys-bits,-cpuid-0xb,+x2apic

works just fine.

> > > > and then hold the CPUID 0x1 part back for the next phase.
> > > This was an interesting find! I tested the latest branch
> > > parallel-6.2-rc6 and it works well. The numbers from Russ makes the
> > > patch series look so much better! :)
> > > 
> > > If we do it with x2apic only and not support non-x2apic CPUID 0x1 case,
> > > maybe we apply the following diff to part 1?
> > 
> > Using x2apic_mode would also disable parallel boot when the CPU *does*
> > have X2APIC support but the kernel just isn't using it at the moment. I
> > think boot_cpu_has(X86_FEATURE_X2APIC) is the better criterion?
> > 
> 
> x2apic_mode is set to 0 only in the case when nox2apic is specified in the
> kernel cmdline or if x2apic_setup fails. As 0xB leaf gets the "x2apic id"
> and not the "apic id", I thought it would be better to not use the x2apic id
> if the user doesnt want to use x2apic (cmdline), or the kernel fails to set
> it up.

I agree with David that checking boot_cpu_has(X86_FEATURE_X2APIC) is preferred,
x2APIC goes unused on a lot of platforms due to the kernel's interrupt remapping
requirement.  I would rather have a single explicit "no_parallel_bringup" option
than try to infer the user's intentions based on tangentially related params.

> Another thing I noticed from the Intel Architecture Manual CPUID—CPU
> Identification section:
> 
> "CPUID leaf 1FH is a preferred superset to leaf 0BH. Intel recommends first
> checking for the existence of Leaf 1FH before using leaf 0BH."
> 
> So I think we should switch from 0BH to using the 1FH leaf EDX register.

I don't think using 0x1F will buy us anything except complexity.  0x1F provides more
details on the topology, but its x2APIC ID enumeration isn't any more trustworthy
than 0xB.

> > I was thinking I'd tweak the 'no_parallel_bringup' command line
> > argument into something that also allows us to *enable* it without
> > X2APIC being supported.
> > 
> > But I've also been pondering the fact that this is all only for 64-bit
> > anyway. It's not like we're doing it for the zoo of ancient i586 and
> > even i486 machines where the APICs were hooked up with blue wire and
> > duct tape.

The only thing I can see benefiting from parallel bringup without x2APIC is large
VMs running on pre-x2AVIC hardware.  E.g. IIRC, we (Google) hide x2APIC on AMD-based
VMs so that VMs would take advantage of AVIC acceleration if AVIC were even to be
enabled.

But that's more of an argument for "try to use CPUID.0x1" than it is an argument
for trying to use CPUID.0xB without x2APIC.

> > Maybe "64-bit only" is good enough, with a command line opt-out. And
> > maybe a printk pointing out the existence of that command line option
> > before the bringup, just in case?
