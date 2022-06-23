Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07AC558B42
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 00:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiFWWgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 18:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWWgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 18:36:19 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644AC4F9D8
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 15:36:18 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 128so880182pfv.12
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 15:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BTIgkUt/48vjwewEjU9IxungLanIaqlKh/SLuzUnxW8=;
        b=RrSsDDhpkfmh/93ukUREG5c2Kn0Yg18gSfBi6eJ2rFn3uAxUl7o02Dw4httkbHRvGR
         N2973T3V/PSs8qlOjCzz6cLbeFspuBnx3+QcM/YctYSmryvIFy6c41h/dpKCZFGe9ywC
         u/V0fX5YCarOYM9/7rqJg/zcaCHolBG189q/cisNemTvGNHvJEo1MruXT9mgAgmsbjHw
         Jt+U64s9Zy/musXJXYahT3+jB6NS3E/ymNyu3gHzfW9a1pOXeGsVv3xwMNE5yJZ/JQwX
         WwRYy3RKk3fHYaGVGQ5uGWnlN0ighUxCcWPzmQYRFY3+C0pBF+2Ni3C689gWYBbt0gDZ
         OQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BTIgkUt/48vjwewEjU9IxungLanIaqlKh/SLuzUnxW8=;
        b=gX/Wi3trWgsoFf2Emc0ROVWtsXMTSiGCUn+b9ZVrLLSboMVFG7y0uqwvxQhf7sMMwB
         Fhf4aUe5bATTKQNsAiadRjq43puBwdf2Xpytvajy2Cx+5XV3XukoeHcwZ8hRdkPg0rEC
         purqEovTB2EawaF221YK0e0gsWcOxZRTOC7n8n1dJtyZFtp1ahgvFjbTYAcahvF7zmcg
         siaZZs981nVtgj0zHYPyLEJgjCdXVnzvdXEa+tujkoqdbrTHVtEGi3FyHGSjdexuySzu
         w4492mp0PRDGmj89wVtVSHnb4+iiJU9YOYIhm0xsMS1mP5qxJqfPAXfbJP6mOH+yGdhu
         mN6Q==
X-Gm-Message-State: AJIora+qPUImegR+1c5KbkHqWGwFcrDIaM8JSSoc+Bh/FYu4QWz3hNaq
        eXckFBHZozYN/2Vqrlo72SFH8Q==
X-Google-Smtp-Source: AGRyM1u6KCaymoEQRa/9nnIjGl1gKuRl4oeOLYwzK0C4D+k0Jn2QSlDuhvvoXtdozKr/n5Lzp3xvEg==
X-Received: by 2002:a63:8c47:0:b0:40d:2d4:e3a2 with SMTP id q7-20020a638c47000000b0040d02d4e3a2mr9566670pgn.2.1656023777743;
        Thu, 23 Jun 2022 15:36:17 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b0016191b843e2sm285051plf.235.2022.06.23.15.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 15:36:17 -0700 (PDT)
Date:   Thu, 23 Jun 2022 22:36:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>, "bp@alien8.de" <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: Re: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Message-ID: <YrTq3WfOeA6ehsk6@google.com>
References: <cc0c6bd1-a1e3-82ee-8148-040be21cad5c@intel.com>
 <BYAPR12MB2759A8F48D6D68EE879EEF648EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <25be3068-be13-a451-86d4-ff4cc12ddb23@intel.com>
 <BYAPR12MB27599BCEA9F692E173911C3B8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <681e4e45-eff1-600c-9b81-1fa9bdf24232@intel.com>
 <BYAPR12MB27595CF4328B15F0F9573D188EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <99d72d58-a9bb-d75c-93af-79d497dfe176@intel.com>
 <BYAPR12MB275984F14B1E103935A103D98EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <5db37cc2-4fb1-7a73-c39a-3531260414d0@intel.com>
 <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
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

On Wed, Jun 22, 2022, Kalra, Ashish wrote:
> On 6/22/22 12:43, Kalra, Ashish wrote:
> >>> I think that needs to be fixed.  It should be as simple as a 
> >>> model/family check, though.  If someone (for example) attempts to use 
> >>> SNP (and thus snp_lookup_rmpentry() and dump_rmpentry()) code on a 
> >>> newer CPU, the kernel should refuse.
> >> More specifically I am thinking of adding RMP entry field accessors so 
> >> that they can do this cpu model/family check and return the correct 
> >> field as per processor architecture.
> 
> >That will be helpful down the road when there's more than one format.  But,
> >the real issue is that the kernel doesn't *support* a different RMP format.
> >So, the SNP support should be disabled when encountering a model/family
> >other than the known good one.
> 
> Yes, that makes sense, will add an additional check in snp_rmptable_init().

And as I suggested in v5[*], bury the microarchitectural struct in sev.c so that
nothing outside of the few bits of SNP code that absolutely need to know the layout
of the struct should even be aware that there's a struct overlay for RMP entries.

[*] https://lore.kernel.org/all/YPCAZaROOHNskGlO@google.com
