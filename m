Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893A454BBC8
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358201AbiFNU37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358171AbiFNU35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:29:57 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3194EDC2
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:29:53 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t25so15698096lfg.7
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i1JbdaTpMJydG2La5gQ81SLd4rzBeviDTlLKc1Eh/88=;
        b=GeEzs3PaW1MdOrbgFZ/otLfl3Zbs0O9rwiW5jR3wEk7DxOJJMNNaAAd9x3vM+ls+vP
         SYoWgeoNHoBptIJJOojShXU13QiM5QUde3iyhfQnGylp3dfOJv1fd9e/kqkjVyDsO8Ak
         VGmpHA6oteHXGscOvQXivDkJlXHLf+JVvDS9MfT9/GEguVMCR0iw3TFO1dHFfJjQdgel
         dBmPayr75a2wpNqnj2UDwqzxBz7W+DedtpboLm1h6z+y3tXbGBua9JMlFEW2dL7oKJdj
         GChzCb3cE3z0NztobHO7Cc7W8M+GVhNKCvicnUoH5y9Sz2wExD7QaUw7d1WhJejCLPgo
         KCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i1JbdaTpMJydG2La5gQ81SLd4rzBeviDTlLKc1Eh/88=;
        b=Zq/sFJI5T/hRRVTl1H1g8MSveeiulajb+XrLxd6+Q+QxEltYAkQy9PjkpxOwuq+LWX
         3c7OT1NSwIaISQ3jETL4EgHOXKLu9OVy4YSr3cft6mxvfXAfnQoYIiLpv8N/0ElMd5TU
         qSkllifsYKnsiPCAB/8LbK5MbDO/hYqPWsB7s4n11of+l2GyO3K+gH0A9kqJR0b3A7IN
         8pPN61f3mXo4L3qa/ZNmy6Gbynn8zJgRjUJxeG6eX0A5Dfrzkbq0EzGftZ99aHjKdoEp
         FRarwc3ckIK+wz1eOn5GaiGtGV861wTPjm413CmKTMOvICbhTqMCo8BYCUTyIspNRhYU
         pvag==
X-Gm-Message-State: AOAM531lynWpN65sSUD0woN2e+XAJAmjwJig9Zh66pdbxl45wzcQCCf/
        ZxLV3qNo3mw3BhHCyBUq3QIrHZJlUaW9eWZ5E80dww==
X-Google-Smtp-Source: AGRyM1uB8vovM2S7g0G+YvxGib/s21Ys3d7Mu/guzm6mTRKwWFEw+NzAwM1UtOZyS5AKzwwfYb7eQjcwM7Mj92nnSGc=
X-Received: by 2002:a05:6512:238c:b0:479:8c3:e11b with SMTP id
 c12-20020a056512238c00b0047908c3e11bmr4044322lfv.456.1655238591503; Tue, 14
 Jun 2022 13:29:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-24-brijesh.singh@amd.com>
 <CABpDEukdrEbXjOF_QuZqUMQndYx=zVM4s2o-oN_wb2L_HCrONg@mail.gmail.com>
 <1cadca0d-c3dc-68ed-075f-f88ccb0ccc0a@amd.com> <CABpDEun0rjrNVCGZDXd8SO3tfZi-2ku3mit2XMGLwCsijbF9tg@mail.gmail.com>
 <ee1a829f-9a89-e447-d182-877d4033c96a@amd.com> <CAMkAt6q3otA3n-daFfEBP7kzD+ucMQjP=3bX1PkuAUFrH9epUQ@mail.gmail.com>
 <SN6PR12MB27671CDFDAA1E62AD49EC6C68EAA9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6r0ZsjS_XtVYnazC8-Z9bHQafLZ7QFq2NqcRQ2gZbUyPg@mail.gmail.com>
 <SN6PR12MB276764F83F8849603A2F23478EAA9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CABpDEum5cmODpA1HQUqG0doKv32AqZ0L9eA88nfg=F=OTMigxA@mail.gmail.com> <SN6PR12MB2767FC7AD341378116DD147D8EAA9@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB2767FC7AD341378116DD147D8EAA9@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 14 Jun 2022 14:29:39 -0600
Message-ID: <CAMkAt6pW5MUvJoh1HRJjwjWp7WuJGdrHf59k_QgCxfPhvmM20w@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     Alper Gun <alpergun@google.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
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
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Jun 14, 2022 at 2:23 PM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
> Hello Alper,
>
> Here is the feedback from the SEV/SNP firmware team:
>
> The SNP spec has this line in SNP_INIT_EX:
>
> =E2=80=9CThe firmware marks all encryption capable ASIDs as unusable for =
encrypted virtualization.=E2=80=9D
>
> This is a back-handed way of saying that after SNP_INIT, all of the ASIDs=
 are considered =E2=80=9Cdirty=E2=80=9D. None are in use, but the FW can=E2=
=80=99t know if there=E2=80=99s any data in the caches left over from some =
prior guest. So after doing an SNP_INIT (or SNP_INIT_EX), a WBINVD (on all =
threads) and DF_FLUSH sequence is required. It doesn=E2=80=99t matter wheth=
er it=E2=80=99s an SEV DF_FLUSH or an SNP_DF_FLUSH=E2=80=A6 they both do EX=
ACTLY the same thing.
>
> I don=E2=80=99t understand off hand why SNP_LAUNCH_START would require a =
DF_FLUSH=E2=80=A6 Usually, it=E2=80=99s only an =E2=80=9Cactivate=E2=80=9D =
command that requires the DF_FLUSH. ACTIVATE/ACTIVATE_EX/SNP_ACTIVATE/SNP_A=
CTIVATE_EX
>
> [Ashish] That's why I asked if you are getting the DLFLUSH_REQUIRED error=
 after the SNP activate command ?
>
> It=E2=80=99s when you attempt to (re-)use >an ASID that=E2=80=99s =E2=80=
=9Cdirty=E2=80=9D that you should get the DF_FLUSH_REQUIRED error.
>
> [Ashish] And we do SNP_DF_FLUSH/SEV_DF_FLUSH whenever ASIDs are reused/re=
-cycled.
>
> If the host only wants to run SNP guests, there=E2=80=99s no need to do a=
n SEV INIT or any other SEV operations. If the host DOES want to run SEV AN=
D SNP guests, then the required sequence is to do the SNP_INIT before the S=
EV INIT. Doing the WBINVD/DF_FLUSH any time between the SNP_INIT and any AC=
TIVATE command should be sufficient.

Thanks for the follow up Ashish! I was assuming there was some issue
with the ASIDs here but didn't have time to experiment yet. Is there
any downside to enabling SEV? If not these patches make sense but if
there is some cost should we make KVM capable of running SNP VMs
without enabling SEV?


>
> Thanks,
> Ashish
>
> -----Original Message-----
> From: Alper Gun <alpergun@google.com>
> Sent: Tuesday, June 14, 2022 1:58 PM
> To: Kalra, Ashish <Ashish.Kalra@amd.com>
> Cc: Peter Gonda <pgonda@google.com>; the arch/x86 maintainers <x86@kernel=
.org>; LKML <linux-kernel@vger.kernel.org>; kvm list <kvm@vger.kernel.org>;=
 linux-coco@lists.linux.dev; linux-mm@kvack.org; Linux Crypto Mailing List =
<linux-crypto@vger.kernel.org>; Thomas Gleixner <tglx@linutronix.de>; Ingo =
Molnar <mingo@redhat.com>; Joerg Roedel <jroedel@suse.de>; Lendacky, Thomas=
 <Thomas.Lendacky@amd.com>; H. Peter Anvin <hpa@zytor.com>; Ard Biesheuvel =
<ardb@kernel.org>; Paolo Bonzini <pbonzini@redhat.com>; Sean Christopherson=
 <seanjc@google.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li <w=
anpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Andy Lutomirski <=
luto@kernel.org>; Dave Hansen <dave.hansen@linux.intel.com>; Sergio Lopez <=
slp@redhat.com>; Peter Zijlstra <peterz@infradead.org>; Srinivas Pandruvada=
 <srinivas.pandruvada@linux.intel.com>; David Rientjes <rientjes@google.com=
>; Dov Murik <dovmurik@linux.ibm.com>; Tobin Feldman-Fitzthum <tobin@ibm.co=
m>; Borislav Petkov <bp@alien8.de>; Roth, Michael <Michael.Roth@amd.com>; V=
lastimil Babka <vbabka@suse.cz>; Kirill A . Shutemov <kirill@shutemov.name>=
; Andi Kleen <ak@linux.intel.com>; Tony Luck <tony.luck@intel.com>; Marc Or=
r <marcorr@google.com>; Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppusw=
amy@linux.intel.com>
> Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
>
> Let me summarize what I tried.
>
> 1- when using psp_init_probe false, the SNP VM fails in SNP_LAUNCH_START =
step with error SEV_RET_DFFLUSH_REQUIRED(15).
> 2- added SEV_DF_FLUSH just after SNP platform init and it didn't fail in =
launch start but failed later during SNP_LAUNCH_UPDATE with
> SEV_RET_INVALID_PARAM(22)
> 3- added SNP_DF_FLUSH just after SNP platform init and it failed again du=
ring SNP_LAUNCH_UPDATE with SEV_RET_INVALID_PARAM(22)
> 4- added sev_platform_init for SNP VMs and it worked.
>
> For me DF_FLUSH alone didn' help boot a VM. I don't know yet why sev plat=
form status impacts the SNP VM, but sev_platform_init fixes the problem.
>
>
> On Tue, Jun 14, 2022 at 10:16 AM Kalra, Ashish <Ashish.Kalra@amd.com> wro=
te:
> >
> > [AMD Official Use Only - General]
> >
> > Hello Alper, Peter,
> >
> > -----Original Message-----
> > From: Peter Gonda <pgonda@google.com>
> > Sent: Tuesday, June 14, 2022 11:30 AM
> > To: Kalra, Ashish <Ashish.Kalra@amd.com>
> > Cc: Alper Gun <alpergun@google.com>; Brijesh Singh
> > <brijesh.singh@amd.com>; the arch/x86 maintainers <x86@kernel.org>;
> > LKML <linux-kernel@vger.kernel.org>; kvm list <kvm@vger.kernel.org>;
> > linux-coco@lists.linux.dev; linux-mm@kvack.org; Linux Crypto Mailing
> > List <linux-crypto@vger.kernel.org>; Thomas Gleixner
> > <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Joerg Roedel
> > <jroedel@suse.de>; Lendacky, Thomas <Thomas.Lendacky@amd.com>; H.
> > Peter Anvin <hpa@zytor.com>; Ard Biesheuvel <ardb@kernel.org>; Paolo
> > Bonzini <pbonzini@redhat.com>; Sean Christopherson
> > <seanjc@google.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng
> > Li <wanpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Andy
> > Lutomirski <luto@kernel.org>; Dave Hansen
> > <dave.hansen@linux.intel.com>; Sergio Lopez <slp@redhat.com>; Peter
> > Zijlstra <peterz@infradead.org>; Srinivas Pandruvada
> > <srinivas.pandruvada@linux.intel.com>; David Rientjes
> > <rientjes@google.com>; Dov Murik <dovmurik@linux.ibm.com>; Tobin
> > Feldman-Fitzthum <tobin@ibm.com>; Borislav Petkov <bp@alien8.de>;
> > Roth, Michael <Michael.Roth@amd.com>; Vlastimil Babka
> > <vbabka@suse.cz>; Kirill A . Shutemov <kirill@shutemov.name>; Andi
> > Kleen <ak@linux.intel.com>; Tony Luck <tony.luck@intel.com>; Marc Orr
> > <marcorr@google.com>; Sathyanarayanan Kuppuswamy
> > <sathyanarayanan.kuppuswamy@linux.intel.com>; Pavan Kumar Paluri
> > <papaluri@amd.com>
> > Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
> >
> > On Tue, Jun 14, 2022 at 10:11 AM Kalra, Ashish <Ashish.Kalra@amd.com> w=
rote:
> > >
> > > [AMD Official Use Only - General]
> > >
> > >
> > > -----Original Message-----
> > > From: Peter Gonda <pgonda@google.com>
> > > Sent: Tuesday, June 14, 2022 10:38 AM
> > > To: Kalra, Ashish <Ashish.Kalra@amd.com>
> > > Cc: Alper Gun <alpergun@google.com>; Brijesh Singh
> > > <brijesh.singh@amd.com>; Kalra, Ashish <Ashish.Kalra@amd.com>; the
> > > arch/x86 maintainers <x86@kernel.org>; LKML
> > > <linux-kernel@vger.kernel.org>; kvm list <kvm@vger.kernel.org>;
> > > linux-coco@lists.linux.dev; linux-mm@kvack.org; Linux Crypto Mailing
> > > List <linux-crypto@vger.kernel.org>; Thomas Gleixner
> > > <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Joerg Roedel
> > > <jroedel@suse.de>; Lendacky, Thomas <Thomas.Lendacky@amd.com>; H.
> > > Peter Anvin <hpa@zytor.com>; Ard Biesheuvel <ardb@kernel.org>; Paolo
> > > Bonzini <pbonzini@redhat.com>; Sean Christopherson
> > > <seanjc@google.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng
> > > Li <wanpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Andy
> > > Lutomirski <luto@kernel.org>; Dave Hansen
> > > <dave.hansen@linux.intel.com>; Sergio Lopez <slp@redhat.com>; Peter
> > > Zijlstra <peterz@infradead.org>; Srinivas Pandruvada
> > > <srinivas.pandruvada@linux.intel.com>; David Rientjes
> > > <rientjes@google.com>; Dov Murik <dovmurik@linux.ibm.com>; Tobin
> > > Feldman-Fitzthum <tobin@ibm.com>; Borislav Petkov <bp@alien8.de>;
> > > Roth, Michael <Michael.Roth@amd.com>; Vlastimil Babka
> > > <vbabka@suse.cz>; Kirill A . Shutemov <kirill@shutemov.name>; Andi
> > > Kleen <ak@linux.intel.com>; Tony Luck <tony.luck@intel.com>; Marc
> > > Orr <marcorr@google.com>; Sathyanarayanan Kuppuswamy
> > > <sathyanarayanan.kuppuswamy@linux.intel.com>; Pavan Kumar Paluri
> > > <papaluri@amd.com>
> > > Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT
> > > command
> > >
> > > On Mon, Jun 13, 2022 at 6:21 PM Ashish Kalra <ashkalra@amd.com> wrote=
:
> > > >
> > > >
> > > > On 6/13/22 23:33, Alper Gun wrote:
> > > > > On Mon, Jun 13, 2022 at 4:15 PM Ashish Kalra <ashkalra@amd.com> w=
rote:
> > > > >> Hello Alper,
> > > > >>
> > > > >> On 6/13/22 20:58, Alper Gun wrote:
> > > > >>> static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd
> > > > >>> *argp)
> > > > >>>>    {
> > > > >>>> +       bool es_active =3D (argp->id =3D=3D KVM_SEV_ES_INIT ||
> > > > >>>> + argp->id =3D=3D KVM_SEV_SNP_INIT);
> > > > >>>>           struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_i=
nfo;
> > > > >>>> -       bool es_active =3D argp->id =3D=3D KVM_SEV_ES_INIT;
> > > > >>>> +       bool snp_active =3D argp->id =3D=3D KVM_SEV_SNP_INIT;
> > > > >>>>           int asid, ret;
> > > > >>>>
> > > > >>>>           if (kvm->created_vcpus) @@ -249,12 +269,22 @@
> > > > >>>> static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd =
*argp)
> > > > >>>>                   return ret;
> > > > >>>>
> > > > >>>>           sev->es_active =3D es_active;
> > > > >>>> +       sev->snp_active =3D snp_active;
> > > > >>>>           asid =3D sev_asid_new(sev);
> > > > >>>>           if (asid < 0)
> > > > >>>>                   goto e_no_asid;
> > > > >>>>           sev->asid =3D asid;
> > > > >>>>
> > > > >>>> -       ret =3D sev_platform_init(&argp->error);
> > > > >>>> +       if (snp_active) {
> > > > >>>> +               ret =3D verify_snp_init_flags(kvm, argp);
> > > > >>>> +               if (ret)
> > > > >>>> +                       goto e_free;
> > > > >>>> +
> > > > >>>> +               ret =3D sev_snp_init(&argp->error);
> > > > >>>> +       } else {
> > > > >>>> +               ret =3D sev_platform_init(&argp->error);
> > > > >>> After SEV INIT_EX support patches, SEV may be initialized in th=
e platform late.
> > > > >>> In my tests, if SEV has not been initialized in the platform
> > > > >>> yet, SNP VMs fail with SEV_DF_FLUSH required error. I tried
> > > > >>> calling SEV_DF_FLUSH right after the SNP platform init but
> > > > >>> this time it failed later on the SNP launch update command
> > > > >>> with SEV_RET_INVALID_PARAM error. Looks like there is another
> > > > >>> dependency on SEV platform initialization.
> > > > >>>
> > > > >>> Calling sev_platform_init for SNP VMs fixes the problem in our =
tests.
> > > > >> Trying to get some more context for this issue.
> > > > >>
> > > > >> When you say after SEV_INIT_EX support patches, SEV may be
> > > > >> initialized in the platform late, do you mean sev_pci_init()->se=
v_snp_init() ...
> > > > >> sev_platform_init() code path has still not executed on the host=
 BSP ?
> > > > >>
> > > > > Correct, INIT_EX requires the file system to be ready and there
> > > > > is a ccp module param to call it only when needed.
> > > > >
> > > > > MODULE_PARM_DESC(psp_init_on_probe, " if true, the PSP will be
> > > > > initialized on module init. Else the PSP will be initialized on
> > > > > the first command requiring it");
> > > > >
> > > > > If this module param is false, it won't initialize SEV on the
> > > > > platform until the first SEV VM.
> > > > >
> > > > Ok, that makes sense.
> > > >
> > > > So the fix will be to call sev_platform_init() unconditionally
> > > > here in sev_guest_init(), and both sev_snp_init() and
> > > > sev_platform_init() are protected from being called again, so
> > > > there won't be any issues if these functions are invoked again at
> > > > SNP/SEV VM launch if they have been invoked earlier during module i=
nit.
> > >
> > > >That's one solution. I don't know if there is a downside to the syst=
em for enabling SEV if SNP is being enabled but another solution could be t=
o just directly place a DF_FLUSH command instead of calling sev_platform_in=
it().
> > >
> > > Actually sev_platform_init() is already called on module init if psp_=
init_on_probe is not false. Only need to ensure that SNP firmware is initia=
lized first with SNP_INIT command.
> >
> > > But if psp_init_on_probe is false, sev_platform_init() isn't called d=
own this path. Alper has suggested we always call sev_platform_init() but w=
e could just place an SEV_DF_FLUSH command instead. Or am I still missing s=
omething?
> >
> > >After SEV INIT_EX support patches, SEV may be initialized in the platf=
orm late.
> > > In my tests, if SEV has not been initialized in the platform  yet,
> > >SNP VMs fail with SEV_DF_FLUSH required error. I tried  calling
> > >SEV_DF_FLUSH right after the SNP platform init.
> >
> > Are you getting the DLFLUSH_REQUIRED error after the SNP activate comma=
nd ?
> >
> > Also did you use the SEV_DF_FLUSH command or the SNP_DF_FLUSH command ?
> >
> > With SNP you need to use SNP_DF_FLUSH command.
> >
> > Thanks,
> > Ashish
