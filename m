Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A674B433A6F
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhJSPdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 11:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231235AbhJSPdV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 11:33:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634657468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4ZZ2V3d1ENj2cvVD/XE+NYgjnFFwr8bKUmLsCXgLg2Y=;
        b=baWzkCJQEErXzdZsZVOGVKG/Q0CGmiOsAMgM1bY+XmUV/vsW2HI+r6TyonvgDeZ7KtpRr8
        yAPRz6P4l8CvZ12+EOZpfLe0/uoM6+ZzQb7jBy3gZBcStscQZYGlA3GmaTWlNTPvt3ucj1
        YPaYJ42mbrW4mHHgMrh4PkB0ZdZeBoA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-lC_9v-9HNRi404qZdlkLrg-1; Tue, 19 Oct 2021 11:31:07 -0400
X-MC-Unique: lC_9v-9HNRi404qZdlkLrg-1
Received: by mail-ed1-f69.google.com with SMTP id e14-20020a056402088e00b003db6ebb9526so17890822edy.22
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ZZ2V3d1ENj2cvVD/XE+NYgjnFFwr8bKUmLsCXgLg2Y=;
        b=clKI0h1QIiBzxF9bM0b5DWjh9XNuHI7JMnHmAco/Cu+4DFkm/6sS19cSY0OzL8FtwQ
         U80FYF8zf+7MQoLH6rES3cYLXln6ottWAZHXLumbAjs17oTTW3O18/Uk1Q78T9fC5mp5
         KBfJFWO0lLALObu9TJDjkRZde1beKfaa4+/COV4w3v/eSYxhee3OHglpxnyW/e/NErKz
         dknJHLxjs8+MmubwinebXSIzftITI63tDANtSG8V6boZqgEC4DKHBM0zQ1k1eCeDfTB3
         sL7MEWRP26IQW2n9tauRVlgr9qeR/5wzlJCGPn3JgQ+Yi+WdEGHbvfQFLqaPkwcGrynu
         Xf/w==
X-Gm-Message-State: AOAM532lRB6OO9L+fQeX9Bbv7YpBM9U2t5r6CXQBEfgzp6/EvXAq6uMA
        7TlShK8hUngOY5Qs/zMc2j3yNdrvozXm4FO5Q2hPoqP+Putt42e3EI3QQaQtE7g0oMDEJrDoIz1
        ei90gg45uygUH
X-Received: by 2002:a17:907:7f24:: with SMTP id qf36mr21605766ejc.491.1634657466004;
        Tue, 19 Oct 2021 08:31:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcZ7hx0Fe0ncByC2mKYQVamv9GIdxHqm03ELigWcpj7TkWL6O2WCirWmQmeIT3EWXMoSIg9Q==
X-Received: by 2002:a17:907:7f24:: with SMTP id qf36mr21605675ejc.491.1634657465237;
        Tue, 19 Oct 2021 08:31:05 -0700 (PDT)
Received: from gator.home (cst2-174-2.cust.vodafone.cz. [31.30.174.2])
        by smtp.gmail.com with ESMTPSA id v19sm10629270ejx.26.2021.10.19.08.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:31:04 -0700 (PDT)
Date:   Tue, 19 Oct 2021 17:31:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Zixuan Wang <zxwang42@gmail.com>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86 AMD SEV-ES: Add test cases
Message-ID: <20211019153103.6bvrualmzksdaav5@gator.home>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <20211004204931.1537823-18-zxwang42@gmail.com>
 <6a5a16f7-c350-a48d-c5e7-352455b57c09@suse.com>
 <CAEDJ5ZQbXK=Gtf_QH2PMNEOBo++7vsa84zZ3G8rzM=TH+JUrQQ@mail.gmail.com>
 <CAA03e5HL0aiByPGiO5mescTHNM=DT69Kx=ep=cS-De8u+tvaMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5HL0aiByPGiO5mescTHNM=DT69Kx=ep=cS-De8u+tvaMA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021 at 07:14:47AM -0700, Marc Orr wrote:
> On Mon, Oct 18, 2021 at 9:38 PM Zixuan Wang <zxwang42@gmail.com> wrote:
> >
> > On Mon, Oct 18, 2021 at 4:47 AM Varad Gautam <varad.gautam@suse.com> wrote:
> > >
> > > Hi Zixuan,
> > >
> > > On 10/4/21 10:49 PM, Zixuan Wang wrote:
> > > > From: Zixuan Wang <zixuanwang@google.com>
> > > > +static int test_sev_es_msr(void)
> > > > +{
> > > > +     /*
> > > > +      * With SEV-ES, rdmsr/wrmsr trigger #VC exception. If #VC is handled
> > > > +      * correctly, rdmsr/wrmsr should work like without SEV-ES and not crash
> > > > +      * the guest VM.
> > > > +      */
> > > > +     u64 val = 0x1234;
> > > > +     wrmsr(MSR_TSC_AUX, val);
> > > > +     if(val != rdmsr(MSR_TSC_AUX)) {
> > > > +             return EXIT_FAILURE;
> > >
> > > See note below.
> > >
> > > > +     }
> > > > +
> > > > +     return EXIT_SUCCESS;
> > > > +}
> > > > +
> > > >  int main(void)
> > > >  {
> > > >       int rtn;
> > > >       rtn = test_sev_activation();
> > > >       report(rtn == EXIT_SUCCESS, "SEV activation test.");
> > > > +     rtn = test_sev_es_activation();
> > > > +     report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
> > > > +     rtn = test_sev_es_msr();
> > >
> > > There is nothing SEV-ES specific about this function, it only wraps
> > > rdmsr/wrmsr, which are supposed to generate #VC exceptions on SEV-ES.
> > > Since the same scenario can be covered by running the msr testcase
> > > as a SEV-ES guest and observing if it crashes, does testing
> > > rdmsr/wrmsr one more time here gain us any new information?
> > >
> > > Also, the function gets called from main() even if
> > > test_sev_es_activation() failed or SEV-ES was inactive.
> > >
> > > Note: More broadly, what are you looking to test for here?
> > > 1. wrmsr/rdmsr correctness (rdmsr reads what wrmsr wrote)? or,
> > > 2. A #VC exception not causing a guest crash on SEV-ES?
> > >
> > > If you are looking to test 1., I suggest letting it be covered by
> > > the generic testcases for msr.
> > >
> > > If you are looking to test 2., perhaps a better test is to trigger
> > > all scenarios that would cause a #VC exception (eg. test_sev_es_vc_exit)
> > > and check that a SEV-ES guest survives.
> > >
> > > Regards,
> > > Varad
> > >
> >
> > Hi Varad,
> >
> > This test case does not bring any SEV-related functionality testing.
> > Instead, it is provided for development, i.e., one can check if SEV is
> > properly set up by monitoring if this test case runs fine without
> > crashes.
> >
> > Since this test case is causing some confusion and does not bring any
> > functionality testing, I can remove it from the next version. We can
> > still verify the SEV setup process by checking if an existing test
> > case (e.g., x86/msr.c) runs without crashes in a SEV guest.
> >
> > It's hard for me to develop a meaningful SEV test case, because I just
> > finished my Google internship and thus lost access to SEV-enabled
> > machines.
> 
> Removing this test case is fine. Though, it is convenient. But I
> agree, it's redundant. Maybe we can tag any tests that are good to run
> under SEV and/or SEV-ES via the `groups` field in the
> x86/unittests.cfg file. The name `groups` is plural. So I assume that
> a test can be a member of multiple groups. But I see no examples.
> 

Yes, groups is specified to accept more than one group with space
separation (see the comment block at the top of the unittests file).
I see a couple instances where groups are comma separated, but that
should be changed, especially since commit b373304853a0 ("scripts:
Fix the check whether testname is in the only_tests list") was merged.
I'll send a patch for that.

Thanks,
drew

