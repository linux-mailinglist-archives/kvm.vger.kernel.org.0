Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1103B5016A1
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 17:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240818AbiDNPIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 11:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354223AbiDNOzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 10:55:08 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F11DBD28
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 07:42:59 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so9477722pjb.4
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 07:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qwcuBgImCmXIPh4KovD6yz7yJbjBcIk++srxxrgHoVk=;
        b=PqcPSgK5KCFX0ypEAiiuQ48djSg+e6hRlUoxyQKm5+csfnsgcYel8pbIACDPKdIjKR
         iHjm7BMJeqGyI/nEfPUqUFojs9W5pKDLHiOS5tTpfTgnzcLHRbQoPplRp4MSG2FubYVv
         KJ/sOzMF9j6eDYKI9fm40PvgwjEB8UXsEx0pOCKujwLNY528/tgdDAs2+HcUzJ46A7Mk
         b9kflZvhS0PZbSS+HVeVy4/Zjud0oNXTtCGCdZ8zs7rXuSahBGjWZIxMibg0vEHnJxav
         6HrSLaAsH5Cugsnm62jDxshYpQ46yXTkT2wfGTJk4FYp3Tsukla7/SlJG3Ud0J9oGyjG
         PSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qwcuBgImCmXIPh4KovD6yz7yJbjBcIk++srxxrgHoVk=;
        b=1vHc3gZ+fk63vUgDx9ZjrqgkyHEDofgKCzrTDNY6AusFL5303pGTYffj0SC1lxB259
         ggPd5NGmi/XdTxNwRfbGDzZV9nnnw6kFg7l/aBqP0mGP2aLkufAUCkHg/rhTZJkVXT1C
         xe2wPEYeD7YPXvm9C9rWmrUGeJtWHVj9sTD71v90/fTGT4mHMspu744fp96XiAnq7Zb2
         Av7LNxdDpTfysL4r65+hNCVPn6wx1xQevOvUKKM4xxLbx+rHuloZH2lAzmJEENxMeGyB
         No7dKGpySq0E2N2wvtgu45ex8eyqNupxhxDNwcL+Z0lVLY3wiD89QUIxPsDk405uyN1S
         LtBA==
X-Gm-Message-State: AOAM532PjTyhwOIfRktEihMQ3jdjhwGrn7pAAT6qRjBiC2KSFNdRrgFf
        fDyOLV7BDP1DZNQkJnK3x1DOX/Mu6+nwrA==
X-Google-Smtp-Source: ABdhPJy2PeIS61cClFOl7u9zD2LzLkl4mWHXZ+aCyR9ZnSEJKTwasVdmpha8K+eK6URzneRvPCXonQ==
X-Received: by 2002:a17:902:ecc1:b0:158:6e96:83a7 with SMTP id a1-20020a170902ecc100b001586e9683a7mr18008752plh.79.1649947378972;
        Thu, 14 Apr 2022 07:42:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e12-20020a056a0000cc00b00508343a6f9esm194233pfj.5.2022.04.14.07.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 07:42:58 -0700 (PDT)
Date:   Thu, 14 Apr 2022 14:42:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH V3 3/4] KVM: X86: Alloc role.pae_root shadow page
Message-ID: <Ylgy7tnQAKqyV22K@google.com>
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
 <20220330132152.4568-4-jiangshanlai@gmail.com>
 <YlXrshJa2Sd1WQ0P@google.com>
 <CAJhGHyD-4YFDhkxk2SQFmKe3ooqw_0wE+9u3+sZ8zOdSUfbnxw@mail.gmail.com>
 <683974e7-5801-e289-8fa4-c8a8d21ec1b2@redhat.com>
 <CAJhGHyCgo-FEgvuRfuLZikgJSyo7HGm1OfU3gme35-WBmqo7yQ@mail.gmail.com>
 <658729a1-a4a1-a353-50d6-ef71e83a4375@redhat.com>
 <CAJhGHyDYeQGUWmco=c4TA1uu=33ccW7z0fDLuYjvkGFW5WnDSQ@mail.gmail.com>
 <77699a19-65bd-5088-2f25-1be59364f5ee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77699a19-65bd-5088-2f25-1be59364f5ee@redhat.com>
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

On Thu, Apr 14, 2022, Paolo Bonzini wrote:
> On 4/14/22 13:06, Lai Jiangshan wrote:
> > > Right, but then load_pdptrs only needs to zap the page before (or
> > > instead of) calling kvm_mmu_free_roots().
> > > 
> > 
> > Guest PAE page is write-protected instead now (see patch4) and
> > kvm_mmu_pte_write() needs to handle this special write operation
> > with respect to sp->pae_off (todo).
> > And load_pdptrs() doesn't need to check if the pdptrs are changed.
> 
> Write-protecting the PDPTR page is unnecessary, the PDPTRs cannot change
> without another CR3.  That should be easy to do in account_shadowed and
> unaccount_shadowed

Technically that's not true under SVM?

  Under SVM, however, when the processor is in guest mode with PAE enabled, the
  guest PDPT entries are not cached or validated at this point, but instead are
  loaded and checked on demand in the normal course of address translation, just
  like page directory and page table entries
