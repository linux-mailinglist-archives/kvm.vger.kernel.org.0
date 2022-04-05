Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B604F49B0
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444002AbiDEWU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573698AbiDETnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 15:43:07 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71A61209A
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 12:41:07 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p8so410405pfh.8
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 12:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mSWn+bwJl0JXyj3IYwZGhRTiDd7qYXvMXLFtGw/g+rg=;
        b=AlCCPq+JKrSyY6/MdAWK+LJuFWEhXLOG2iRM8eu949iBowZOgYJpjjEZpvcwItS8+d
         FEsIJdYmNNMsbMLSdUVjIs4nmz5vT7bZ7g0IC7PS/W33SVLgyOhPMKVc1hrkM/ybgdzd
         i2jtISpWLxcxVWQR/Nn5bREeHtnuDwJpw37LvO7wCQo11vKt0AwUemLOuwYj1VFxKVXR
         hMIICCbOonqXvUjzSbqP4umdws0neDr1awH1mbCXQOE1HRfpfmMRHUA++iIBc/IcROVl
         uvLnKsuTqIOV5nEgg1TUvo47C8T7k/JqnB0mapIqQiPSvV58KN+OHoUlSQjUoTb3h1mP
         6oAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mSWn+bwJl0JXyj3IYwZGhRTiDd7qYXvMXLFtGw/g+rg=;
        b=3G2zLs3DuWjtlqmzC+qx+RcI/OFFLWdt2mPg6KDaz4CQb1cmxpgHpJj4pAn3iJBltB
         bDT1UoL5cBTxyXC8wr2G5LK+rAEbMX/Y+eAsh7MfFE3J8qKgUiyf6nT27KtZ121+FSQY
         p8M8x3GQvaEVddR6ygQyNPHlPgghisKlJZOcHE4ByFphnjyQF2AqsD3RZL/gfcXmuiyA
         h+YyZIEHspKzju5WFBgB9Ab9HIocIP0EXNO47feaQ0vW1Sx05eVIcfRpB8lI4CuErfK5
         Syf/8HbEncxEA15EkMO1sZ18L1JXz2eJnzKjwufs9iFbh8kky68zpcDae5rOhbf5D6PO
         iEBQ==
X-Gm-Message-State: AOAM530j974wChOxV0YzCPBBKFHSGjbsh0OTroqODWupGNhrqKy+cUUT
        nsTEAYzWhYULsEZoq6zvvps/7w==
X-Google-Smtp-Source: ABdhPJwz4yMK7s1pjudVER/qr9fFsGeQA/N/GsijRhlaiArSrhqko6pULldJx680awQe2eXzGIRGzw==
X-Received: by 2002:a05:6a00:1828:b0:4fd:e0e5:6115 with SMTP id y40-20020a056a00182800b004fde0e56115mr5257368pfa.52.1649187666833;
        Tue, 05 Apr 2022 12:41:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j9-20020aa78009000000b004fde2dd78b0sm11969754pfi.109.2022.04.05.12.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 12:41:06 -0700 (PDT)
Date:   Tue, 5 Apr 2022 19:41:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        brijesh.ksingh@gmail.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH v12 22/46] x86/sev: Use SEV-SNP AP creation to start
 secondary CPUs
Message-ID: <YkybTnVYBKZ1zvz6@google.com>
References: <20220307213356.2797205-1-brijesh.singh@amd.com>
 <20220307213356.2797205-23-brijesh.singh@amd.com>
 <YkuMTdckSgSB9M6f@google.com>
 <f4369605-7c8d-1a89-bd0e-b82710d0772a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4369605-7c8d-1a89-bd0e-b82710d0772a@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022, Brijesh Singh wrote:
> Hi Sean,
>
> On 4/4/22 19:24, Sean Christopherson wrote:
>
> > > +static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
> > > +{
> > > + int err;
> > > +
> > > + err = snp_set_vmsa(vmsa, false);
> >
> > Uh, so what happens if a malicious guest does RMPADJUST to convert a VMSA page
> > back to a "normal" page while the host is trying to VMRUN that VMSA?  Does VMRUN
> > fault?
>
> When SEV-SNP is enabled, the VMRUN instruction performs an additional
> security checks on various memory pages. In the case of VMSA page, hardware
> enforce that page is marked as "VMSA" in the RMP table. If not,  VMRUN will
> fail with VMEXIT_INVALID.
>
> After the VMRUN is successful, the VMSA page is marked IN_USE by the
> hardware, any attempt to modify the RMP entries will result in FAIL_INUSE
> error. The IN_USE marking is automatically cleared by the hardware after the
> #VMEXIT.
>
> Please see the APM vol2 section 15.36.12 for additional information.

Thanks!

> > Can Linux refuse to support this madness and instead require the ACPI MP wakeup
> > protocol being proposed/implemented for TDX?  That would allow KVM to have at
>
> My two cents
>
> In the current architecture, the HV track VMSAs by their SPA and guest
> controls when they are runnable. It provides flexibility to the guest, which
> can add and remove the VMSA. This flexibility may come in handy to support
> the kexec and reboot use cases.

I understand it provides the guest flexibility, but IMO it completely inverts the
separation of concerns between host and guest.  The host should have control of
when a vCPU is added/removed and with what state, and the guest should be able to
verify/acknowledge any changes.  This scheme gives the guest the bulk of the control,
and doesn't even let the host verify much at all since the VMSA is opaque.

That the guest can yank the rug out from the host at any time just adds to the pain.
VMEXIT_INVALID isn't the end of the world, but it breaks the assumption that such
errors are host bugs.  To guard against such behavior, the host would have to unmap
the VMSA page in order to prevent unwanted RMPADJUST, and that gets ugly fast if a
VMSA can be any arbitrary guest page.

Another example is the 2mb alignment erratum.  Technically, the guest can't workaround
the erratum with 100% certainty because there's no guarantee that the host uses the
same alignment for gfns and pfns.  I don't actually expect a host to use unaligned
mappings, just pointing out how backwards this is.

I fully realize there's basically zero chance of getting any of this changed in
hardware/firmware, but I'm hoping we can concoct a software/GHCB solution to the
worst issues.

I don't see an way easy to address the guest getting to shove state directly into
the VMSA, but the location of the VMSA gfn/pfn is a very solvable problem.  E.g.
the host gets full control over each vCPU's VMSA, and the host-provided VMSA is
discoverable in the guest.  That allows the guest to change vCPU state, e.g. for AP
bringup, kexec, etc..., but gives the host the ability to protect itself without
having to support arbitrary VMSA pages.  E.g. the host can dynamically map/unmap the
VMSA from the guest: map on fault, unmap on AP "creation", refuse to run the vCPU if
its VMSA isn't in the unmap state.  The VMSA pfn is fully host controlled, so
there's no need for the guest to be aware of the 2mb alignment erratum.

Requiring such GHCB extensions in the guest would make Linux incompatible with
hypervisors that aren't updated, but IMO that's not a ridiculous ask given that
it would be in the best interested of any hypervisor that isn't running a fully
trusted, paravirt VMPL0.

> The current approach does not depend on
> ACPI; it will also come in handy to support microvm (minimalist machine type
> without PCI nor ACPI support).

Eh, a microvm really shouldn't need AP bringup in the first place, just run all
APs from time zero and route them to where they need to be.
