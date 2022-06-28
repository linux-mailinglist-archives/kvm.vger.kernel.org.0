Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6099455ED1C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 20:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiF1S6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 14:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiF1S6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 14:58:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4E241157
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 11:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656442702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2lf7QwNhxdo+quqMTGK7aQY+8Wzt942aQ0JT7PbSYKk=;
        b=MXSIJWSTJ2Zzjp3qqraBUAbQD7rRJj3KZdpGGi4hsK6xv5bPbkACX1OT83+SBUvA9Fg30M
        BSLt6O4zOsiubHxjhA01LcZGRW2me5nqLKtYTloFSuN9ddgOMkECkkgaWLv/uYKPHCVLUY
        NCprf8pMAPRNpbyJhkXU6VXrTO7SqOA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-KlCW9uyAM2isEdFb-kD59g-1; Tue, 28 Jun 2022 14:58:20 -0400
X-MC-Unique: KlCW9uyAM2isEdFb-kD59g-1
Received: by mail-wm1-f70.google.com with SMTP id h125-20020a1c2183000000b003a03a8475c6so4975789wmh.8
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 11:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2lf7QwNhxdo+quqMTGK7aQY+8Wzt942aQ0JT7PbSYKk=;
        b=lgRl4+WdTnXGD5BQ5SaZIl5Wie0R7BTHCuao79cdP77vxk9KNN1zDTWCzjWsj4LIdS
         45p3CF950SjggjZtRD7u0EtQXzxOmboXt+XXusE7TNBN5UzVLfzggugd/As2efZ7wrCs
         GQuvZmPBEjs3eBIIquBLwRIiA8vJeyvskzYRhbfGncvBSp7eqxnrnaV7LDVrmbI1Ein1
         u8Tch4/6UJLlcsKJHGs3XUF4/VV6sYmwF3wotbfsFTgq9jMa99lJnszMOY2pE5F0gZq5
         v+ig0xqP7tZ7Sy84q+vydfUAqlW/W777kw/TCtNAJNkc4RU+qtsdXE8pUMk8IrBE+JlO
         /sYg==
X-Gm-Message-State: AJIora+VqAc/s3FhpYNhYiHpZo0lsSdDECk1Z9LxHmAZHyCky/Zw28FC
        CsV22PTW86SkKcxTh6JFZ9FOSf3ag8WoqODWm33cz1/b67d0z5+vmBVc6JYwl7bDh7s5oJo/6/T
        uVA++MANT5tKh
X-Received: by 2002:a05:600c:5022:b0:39c:7f6c:ab44 with SMTP id n34-20020a05600c502200b0039c7f6cab44mr1136446wmr.97.1656442699726;
        Tue, 28 Jun 2022 11:58:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1szlySBmm8GkNFrjrCF0IMcWnh1Lja8Zw3SseqWkis7etEldh2DCLEG7RhUJHJijP9HlpeLSQ==
X-Received: by 2002:a05:600c:5022:b0:39c:7f6c:ab44 with SMTP id n34-20020a05600c502200b0039c7f6cab44mr1136417wmr.97.1656442699439;
        Tue, 28 Jun 2022 11:58:19 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id s2-20020adfea82000000b0021b90d7b2c9sm14365759wrm.24.2022.06.28.11.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:58:18 -0700 (PDT)
Date:   Tue, 28 Jun 2022 19:58:15 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
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
        "seanjc@google.com" <seanjc@google.com>,
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
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: Re: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Message-ID: <YrtPR+qylZ74ciMT@work-vm>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
 <YrH0ca3Sam7Ru11c@work-vm>
 <SN6PR12MB2767FBF0848B906B9F0284D28EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
 <BYAPR12MB2759910E715C69D1027CCE678EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <Yrrc/6x70wa14c5t@work-vm>
 <SN6PR12MB27677062FBBF9D62C7BF41D88EB89@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR12MB27677062FBBF9D62C7BF41D88EB89@SN6PR12MB2767.namprd12.prod.outlook.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Kalra, Ashish (Ashish.Kalra@amd.com) wrote:
> [AMD Official Use Only - General]
> 
> Hello Dave,
> 
> -----Original Message-----
> From: Dr. David Alan Gilbert <dgilbert@redhat.com> 
> Sent: Tuesday, June 28, 2022 5:51 AM
> To: Kalra, Ashish <Ashish.Kalra@amd.com>
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; linux-coco@lists.linux.dev; linux-mm@kvack.org; linux-crypto@vger.kernel.org; tglx@linutronix.de; mingo@redhat.com; jroedel@suse.de; Lendacky, Thomas <Thomas.Lendacky@amd.com>; hpa@zytor.com; ardb@kernel.org; pbonzini@redhat.com; seanjc@google.com; vkuznets@redhat.com; jmattson@google.com; luto@kernel.org; dave.hansen@linux.intel.com; slp@redhat.com; pgonda@google.com; peterz@infradead.org; srinivas.pandruvada@linux.intel.com; rientjes@google.com; dovmurik@linux.ibm.com; tobin@ibm.com; bp@alien8.de; Roth, Michael <Michael.Roth@amd.com>; vbabka@suse.cz; kirill@shutemov.name; ak@linux.intel.com; tony.luck@intel.com; marcorr@google.com; sathyanarayanan.kuppuswamy@linux.intel.com; alpergun@google.com; jarkko@kernel.org
> Subject: Re: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
> 
> * Kalra, Ashish (Ashish.Kalra@amd.com) wrote:
> > [AMD Official Use Only - General]
> > 
> > >>>  /*
> > >>>   * The RMP entry format is not architectural. The format is 
> > >>> defined in PPR @@ -126,6 +128,15 @@ struct snp_guest_platform_data {
> > >>>  	u64 secrets_gpa;
> > >>>  };
> > >>>  
> > >>> +struct rmpupdate {
> > >>> +	u64 gpa;
> > >>> +	u8 assigned;
> > >>> +	u8 pagesize;
> > >>> +	u8 immutable;
> > >>> +	u8 rsvd;
> > >>> +	u32 asid;
> > >>> +} __packed;
> > 
> > >>I see above it says the RMP entry format isn't architectural; is this 'rmpupdate' structure? If not how is this going to get handled when we have a couple >of SNP capable CPUs with different layouts?
> > 
> > >Architectural implies that it is defined in the APM and shouldn't change in such a way as to not be backward compatible. 
> > >I probably think the wording here should be architecture independent or more precisely platform independent.
> > 
> > Some more clarity on this: 
> > 
> > Actually, the PPR for family 19h Model 01h, Rev B1 defines the RMP entry format as below:
> > 
> > 2.1.4.2 RMP Entry Format
> > Architecturally the format of RMP entries are not specified in APM. In order to assist software, the following table specifies select portions of the RMP entry format for this specific product. Each RMP entry is 16B in size and is formatted as follows. Software should not rely on any field definitions not specified in this table and the format of an RMP entry may change in future processors. 
> > 
> > Architectural implies that it is defined in the APM and shouldn't change in such a way as to not be backward compatible. So non-architectural in this context means that it is only defined in our PPR.
> > 
> > So actually this RPM entry definition is platform dependent and will need to be changed for different AMD processors and that change has to be handled correspondingly in the dump_rmpentry() code. 
> 
> > You'll need a way to make that fail cleanly when run on a newer CPU with different layout, and a way to build kernels that can handle more than one layout.
> 
> Yes, I will be adding a check for CPU family/model as following :
> 
> static int __init snp_rmptable_init(void)
> {
> +       int family, model;
> 
>       if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
>                return 0;
> 
> +       family = boot_cpu_data.x86;
> +       model  = boot_cpu_data.x86_model;
> 
> +       /*
> +        * RMP table entry format is not architectural and it can vary by processor and
> +        * is defined by the per-processor PPR. Restrict SNP support on the known CPU
> +        * model and family for which the RMP table entry format is currently defined for.
> +        */
> +       if (family != 0x19 || model > 0xaf)
> +               goto nosnp;

please add a print there to say why you're not enabling SNP.

It would be great if your firmware could give you an 'rmpentry version'; and
then if a new model came out that happened to have the same layout
everything would just carryon working by checking that rather than
the actual family/model.

> +
> 
> This way SNP will only be enabled specifically on the platforms for which this RMP entry
> format is defined in those processor's PPR. This will work for Milan and Genoa as of now.
> 
> Additionally as per Sean's suggestion, I will be moving the RMP structure definition to sev.c,
> which will make it a private structure and not exposed to other parts of the kernel.
> 
> Also in the future we will have an architectural interface to read the RMP table entry,
> we will first check for it's availability and if not available fall back to the RMP table
> entry structure definition.

Dave

>  Thanks,
>  Ashish
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

