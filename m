Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A6057E98F
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 00:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiGVWQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 18:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiGVWQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 18:16:13 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F13F8AECC
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:16:12 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c3so5516022pfb.13
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DvsPToDBCg7LtgfTt0+32mRr4nwV5bDezHW9QGpUdCE=;
        b=tNKubLYYtWNcTQODGehA0A/1OYnUmUt4THz1nqFtzCXg5NEC1cRRSaX5PgITuSDLU6
         G06p3vx+0Zy/5ssCW97K9rUlLfZc5yFeacry9qdLA/ORmYtTsf+hvAjNC/xJhwylqGqF
         GDCvsMr0WCfkILIrPPqjC2A917wnhXYY6gdaIIh24eyORjdpEc+eFQw4xlXwr0mFGOr8
         t0qsu5NCtqCDFbFmwAmnJdfZpcKyrltXlmOvzMeAR2KO9zlFDgaPTuZOo1aTJBLWVqyE
         ee6wGHg3FjgjATQas4NYJjEgWhWbsJ+6+ttSV6V751uW+K/OWJqRkxFO+p/brT9lNe06
         X/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DvsPToDBCg7LtgfTt0+32mRr4nwV5bDezHW9QGpUdCE=;
        b=NriZNl0+xQEqOvqk6Y7p6cKUiEvuIMX9vv5ZK5FFfImGE6GZG+ngVzKZ7hBX7hljFF
         K3MVP0SHQdURG6ek1ab7R8MNZDIyM38LxSEl163Wtpvr7gbJWjCPIdr+K3+pBMgDGiJA
         EMuGGohpM/jarOt+FBsgoxzkjhoM84y4YZH9XijKrsHd1Z2DBXTpY+VQg8URUOryN2qN
         GCZSPIxsk+Ge9/Fet8GbtwYxxKrnPKTFCEq7kM2izOUsl+Poc9c0LBiaqhPv+CKifw55
         2YTTQjDBByp3mOW5dH57w9jLUjfCP2G0LinJrctml+jpZoYXuQ4cGp5S6tibwYzNIk9u
         bRGQ==
X-Gm-Message-State: AJIora96vn8NxaJ0A0IvEWSSjQVdvbv1ykOwIt9tg7vXeq7uwrcBHsFt
        asU48zMruVRgOAUds3dzayYOD9DB8gZ5YQ==
X-Google-Smtp-Source: AGRyM1sIc+nLzUHc1jVYbsv19cRcOoKn0TQ6YwR2BWbngZ0ui0Jg+GMpAVTUImqkVk1IcWXRZVwkvQ==
X-Received: by 2002:a63:1246:0:b0:41a:58f:9fee with SMTP id 6-20020a631246000000b0041a058f9feemr1538198pgs.413.1658528171605;
        Fri, 22 Jul 2022 15:16:11 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id 30-20020a63185e000000b0041296bca2a8sm3769062pgy.12.2022.07.22.15.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 15:16:10 -0700 (PDT)
Date:   Fri, 22 Jul 2022 22:16:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        Dave Hansen <dave.hansen@intel.com>,
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
        "tobin@ibm.com" <tobin@ibm.com>,
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
Message-ID: <Ytshp+D+IT8eaevH@google.com>
References: <BYAPR12MB27595CF4328B15F0F9573D188EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <99d72d58-a9bb-d75c-93af-79d497dfe176@intel.com>
 <BYAPR12MB275984F14B1E103935A103D98EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <5db37cc2-4fb1-7a73-c39a-3531260414d0@intel.com>
 <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <YrTq3WfOeA6ehsk6@google.com>
 <SN6PR12MB276743CBEAD5AFE9033AFE558EB59@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YtqLhHughuh3KDzH@zn.tnic>
 <Ytr0t119QrZ8PUBB@google.com>
 <Ytr5ndnlOQvqWdPP@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytr5ndnlOQvqWdPP@zn.tnic>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022, Borislav Petkov wrote:
> On Fri, Jul 22, 2022 at 07:04:23PM +0000, Sean Christopherson wrote:
> > I disagree.  Running an old kernel on new hardware with a different RMP layout
> > should refuse to use SNP, not read/write garbage and likely corrupt the RMP and/or
> > host memory.
> 
> See my example below.
> 
> > And IMO, hiding the non-architectural RMP format in SNP-specific code so that we
> > don't have to churn a bunch of call sites that don't _need_ access to the raw RMP
> > format is a good idea regardless of whether we want to be optimistic or pessimistic
> > about future formats.
> 
> I don't think I ever objected to that.

Yar, just wanted to be make sure we're all on the same page, I wasn't entirely
sure what was get nacked :-)

> > > This is nothing else but normal CPU enablement work - it should be done
> > > when it is really needed.
> > > 
> 
> <--- this here.
> 
> > > Because the opposite can happen: you can add a model check which
> > > excludes future model X, future model X comes along but does *not*
> > > change the RMP format and then you're going to have to relax that model
> > > check again to fix SNP on the new model X.
> 
> So constantly adding new models to a list which support a certain
> version of the RMP format doesn't scale either.

Yeah, but either we get AMD to give us an architectural layout or we'll have to
eat that cost at some point in the future.

> If you corrupt the RMP because your kernel is old, you'll crash and burn
> very visibly so that you'll be forced to have to look for an updated
> kernel regardless.

Heh, you're definitely more optimistic than me.  I can just see something truly
ridiculous happening like moving the page size bit and then getting weird behavior
only when KVM happens to need the page size for some edge case.

Anyways, it's not a sticking point, and I certainly am not volunteering to
maintain the FMS list...
