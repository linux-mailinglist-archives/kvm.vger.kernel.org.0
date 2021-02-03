Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5755130D0E4
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 02:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhBCBhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 20:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhBCBhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 20:37:01 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3B3C061573
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 17:36:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l18so3590915pji.3
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 17:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=opcqxiP9Xf8gHPgADeMXSxCYS/VX084Gu2Z5G35pT60=;
        b=GNtc7wzH0QU5jlPXZgM2sql00Ns8qYLqPu9MDqgymnfoCWb70rr5qbRSq014KZI+QF
         EtH4du5NQ0wXy9Pg9beIR8pqo4XKQrDhizKCN3LeHubBn2sgf0U+ni+bwk9JP7SCTofP
         OPSDHJemtwKV7lt/YIkx5ycYXo21zUHejZ+bMnKcl05o16VKc827pB8qClnh90vVkLvm
         4eBXovhNninlnEElTQdHPMSfjVv3jKHZIt1D1+98MBRMqnJuZN4k4opTGWYudgedxQO+
         0OwP2dE/6GmQm+2Pv2cLsA8PzWJFAT1r8o7fvlsOBxFAEOcIB/LIySknMWsiI4wXUoqy
         e9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=opcqxiP9Xf8gHPgADeMXSxCYS/VX084Gu2Z5G35pT60=;
        b=nMmfyNib30+xfgeJW9sZruyhIbo+3AmYNBe+NrfZGHRPyKW7QCdA2qND5ccc09aYtZ
         fGBghQxnYPDM+qbp6gKP3dp5OGzSvZ2C0yJweff7XA30CZRdexY55dWSwpv2Zizw6mEL
         nhLygX36rtB8MsOnOKVGu36nSqRD7jigcxPl8kCaDfbECOY729LLBAoLoc3qm0K9smMp
         L1aA72l3ay0Zf+DjWB7Ao9eApVQ9bbJCFj2JXCVYv+UXw1QLkRatK8EKir7YnIqB9/mX
         T3589nnQBiYoE2w/4ur50UtavgejuFdB2DQySVo9AxyZQGAjuJynM5ufBuXkTQkyN8MU
         VBIw==
X-Gm-Message-State: AOAM533Nl0P3H6TyziPUHqY3xd+yGoPpnYnc4uPvSNiIilFSdHxU+od1
        UN2DJ/69Y3Yk/31COsdCePI8tA==
X-Google-Smtp-Source: ABdhPJxoG0EhX5q7rDGZ3PIxaTFASz8Pc2rYtU6KEZ44Rnr6cb1CppuEt74qOEKpfZNr7Qxx3OmPfg==
X-Received: by 2002:a17:902:e541:b029:df:df4f:2921 with SMTP id n1-20020a170902e541b02900dfdf4f2921mr786634plf.52.1612316179501;
        Tue, 02 Feb 2021 17:36:19 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id 145sm206747pge.88.2021.02.02.17.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 17:36:18 -0800 (PST)
Date:   Tue, 2 Feb 2021 17:36:12 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
Subject: Re: [RFC PATCH v3 23/27] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-ID: <YBn+DBXJgPmA1iED@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
 <f60226157935d2bbc20958e6eae7c3532b72f7a3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f60226157935d2bbc20958e6eae7c3532b72f7a3.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > +static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
> > +{
> > +       unsigned long a_hva, m_hva, x_hva, s_hva, secs_hva;
> > +       struct kvm_cpuid_entry2 *sgx_12_0, *sgx_12_1;
> > +       gpa_t metadata_gpa, contents_gpa, secs_gpa;
> > +       struct sgx_pageinfo pageinfo;
> > +       gva_t pageinfo_gva, secs_gva;
> > +       u64 attributes, xfrm, size;
> > +       struct x86_exception ex;
> > +       u8 max_size_log2;
> > +       u32 miscselect;
> > +       int trapnr, r;
> > +
> > +       sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
> > +       sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
> > +       if (!sgx_12_0 || !sgx_12_1) {
> > +               kvm_inject_gp(vcpu, 0);
> > +               return 1;
> > +       }
> > +
> > +       if (sgx_get_encls_gva(vcpu, kvm_rbx_read(vcpu), 32, 32,
> > &pageinfo_gva) ||
> > +           sgx_get_encls_gva(vcpu, kvm_rcx_read(vcpu), 4096, 4096,
> > &secs_gva))
> > +               return 1;
> > +
> > +       /*
> > +        * Copy the PAGEINFO to local memory, its pointers need to be
> > +        * translated, i.e. we need to do a deep copy/translate.
> > +        */
> > +       r = kvm_read_guest_virt(vcpu, pageinfo_gva, &pageinfo,
> > +                               sizeof(pageinfo), &ex);
> > +       if (r == X86EMUL_PROPAGATE_FAULT) {
> > +               kvm_inject_emulated_page_fault(vcpu, &ex);
> > +               return 1;
> > +       } else if (r != X86EMUL_CONTINUE) {
> > +               sgx_handle_emulation_failure(vcpu, pageinfo_gva,
> > size);
> > +               return 0;
> > +       }
> > +
> > +       /*
> > +        * Verify alignment early.  This conveniently avoids having
> > to worry
> > +        * about page splits on userspace addresses.
> > +        */
> > +       if (!IS_ALIGNED(pageinfo.metadata, 64) ||
> > +           !IS_ALIGNED(pageinfo.contents, 4096)) {
> > +               kvm_inject_gp(vcpu, 0);
> > +               return 1;
> > +       }
> > +
> > +       /*
> > +        * Translate the SECINFO, SOURCE and SECS pointers from GVA
> > to GPA.
> > +        * Resume the guest on failure to inject a #PF.
> > +        */
> > +       if (sgx_gva_to_gpa(vcpu, pageinfo.metadata, false,
> > &metadata_gpa) ||
> > +           sgx_gva_to_gpa(vcpu, pageinfo.contents, false,
> > &contents_gpa) ||
> > +           sgx_gva_to_gpa(vcpu, secs_gva, true, &secs_gpa))
> > +               return 1;
> > +
> 
> Do pageinfo.metadata and pageinfo.contents need cannonical checks here?

Bugger, yes.  So much boilerplate needed in this code :-/

Maybe add yet another helper to do alignment+canonical checks, up where the
IS_ALIGNED() calls are?
