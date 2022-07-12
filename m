Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB60571D34
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 16:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbiGLOpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 10:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiGLOpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 10:45:33 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69342D1C9
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 07:45:31 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t25so14319618lfg.7
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 07:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Nsh70CDuTz6nymq/Aq/whTzK7x/oeKxt1w/vVgLpJB8=;
        b=d6kJSkKHZ1XmZiSD2xZ2+ZUO8U6tly4xce6EUsqYoobWB45jyqSqEgyCzbCCSnK1vx
         duoNKCMJEExeOkEbElM0SuXLpxcnuQQW84rZu30wZblW9sbFxgtST/rBgQGytP7Lmf37
         8Cfdns9+0C1WZdpQ6AXCL+zsjJWfNri8CxS3opAWhkPsQT0KPGVgz0vbXpqr0F56buuC
         C8IwZ3efp29FWDR3fB8Jjqj/yD3BjHa4acTwHrupwww1Yhyl4veBtTuaSAOaW04+HG1X
         NpaXfEwQpcLUAVGl0VE7hAGFlfNn0FHtrHwLC8zXjTG7OH4dw1+YlU95m/mbnRd1XPFE
         XYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Nsh70CDuTz6nymq/Aq/whTzK7x/oeKxt1w/vVgLpJB8=;
        b=rnf4tjH7wOPvUhJCjx4wteI9QX7oc9krd6VVVaxFhzcqPAI9bqov+CIl9GK46d/Q9t
         H1e28MEyFJYrcrf3EjByGGd1l2W6AQGRde9h7ImHmfC7NzQD30uZmMBAj5Cm12NSQ3NY
         HmB9w3rnOt3dZk2GqT08h3IfgCjhaJWxbgdiCU+Q/F0Fdf8L/jpva8qXXgIpq4HpEi8V
         NKsr0J7O66TjGVGtovvKJVwZo0+t2y3WM58NR9s6mBWAVbMIZBqt9EiWjpJdhq3A2b5A
         93PGedyFPMTShsJZ+eM0XKDWqmIPaZxXE9BwQfwvmhXbajXJEc0rwxp79JEzujG2T+P9
         6OEA==
X-Gm-Message-State: AJIora+3+SXnl8PdYnc/HdwoEIUPxnxr8adBpRKBDJeqWnwnrrWL7wmw
        MBxynLqH1yTWAnF1c5RAmMRTb5NP5+cpk0RfRG+mjVMJQ/d+HYh9
X-Google-Smtp-Source: AGRyM1sCO7xey4g490fNvKLe/V6ld5tqO+f24a8WZxnW+d8T1nfbiqvw9BOh9iWoT0SemRpaF2zoauHiFINf2/zLsPo=
X-Received: by 2002:a05:6512:44c:b0:489:f71a:a34e with SMTP id
 y12-20020a056512044c00b00489f71aa34emr1736044lfk.402.1657637129877; Tue, 12
 Jul 2022 07:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <6a513cf79bf71c479dbd72165faf1d804d77b3af.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6obGwyiJh7J34Vt8tC+XXMNm8YPrv4gV=TVoF2Xga5GjQ@mail.gmail.com> <SN6PR12MB27672AA31E96179256235C338E879@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB27672AA31E96179256235C338E879@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 12 Jul 2022 08:45:18 -0600
Message-ID: <CAMkAt6ryLr6a5iQnwZQT3hqwEpZpb7bn-T8SDY6=5zYs_5NBow@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 28/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Jul 11, 2022 at 4:41 PM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
> Hello Peter,
>
> >> The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and
> >> stores it as the measurement of the guest at launch.
> >>
> >> While finalizing the launch flow, it also issues the LAUNCH_UPDATE
> >> command to encrypt the VMSA pages.
>
> >Given the guest uses the SNP NAE AP boot protocol we were expecting that=
 there would be some option to add vCPUs to the VM but mark them as "pendin=
g AP boot creation protocol" state. This would allow the LaunchDigest of a =
VM doesn't change >just because its vCPU count changes. Would it be possibl=
e to add a new add an argument to KVM_SNP_LAUNCH_FINISH to tell it which vC=
PUs to LAUNCH_UPDATE VMSA pages for or similarly a new argument for KVM_CRE=
ATE_VCPU?
>
> But don't we want/need to measure all vCPUs using LAUNCH_UPDATE_VMSA befo=
re we issue SNP_LAUNCH_FINISH command ?
>
> If we are going to add vCPUs and mark them as "pending AP boot creation" =
state then how are we going to do LAUNCH_UPDATE_VMSAs for them after SNP_LA=
UNCH_FINISH ?

If I understand correctly we don't need or even want the APs to be
LAUNCH_UPDATE_VMSA'd. LAUNCH_UPDATEing all the VMSAs causes VMs with
different numbers of vCPUs to have different launch digests. Its my
understanding the SNP AP Creation protocol was to solve this so that
VMs with different vcpu counts have the same launch digest.

Looking at patch "[Part2,v6,44/49] KVM: SVM: Support SEV-SNP AP
Creation NAE event" and section "4.1.9 SNP AP Creation" of the GHCB
spec. There is no need to mark the LAUNCH_UPDATE the AP's VMSA or mark
the vCPUs runnable. Instead we can do that only for the BSP. Then in
the guest UEFI the BSP can: create new VMSAs from guest pages,
RMPADJUST them into the RMP state VMSA, then use the SNP AP Creation
NAE to get the hypervisor to mark them runnable. I believe this is all
setup in the UEFI patch:
https://www.mail-archive.com/devel@edk2.groups.io/msg38460.html.
