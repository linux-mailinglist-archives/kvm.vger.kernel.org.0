Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FDC5846ED
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 22:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiG1UMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 16:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiG1UMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 16:12:06 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6C474E22
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 13:12:05 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w205so2826630pfc.8
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 13:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=EplIlrIeqL3qzFgDUGxCxRqOfq3c4zp3SLt5PE7mwGU=;
        b=W1MroCyit8k2GJt5siN1t1/3CC0b3RU0K4uhewMrN4VENd5nCC/xUkSSW/labnEngm
         EbpKboOZXG/G30FXhtu8p7X3zS3WEl6xSOO3rqi+/Abt5c/YVgow09Q85Xn7up7TwlyK
         dUCeZCwZKFnCb8d95f97S99XoOSqMUvxu5xebBv29M+++v2YlNFp4WWACtcDoEP5Mik0
         0JUf9sXG7v7Q8p1dlPRRsreuYMKiCPCJ0ARFjIU85WPUeAZPV5tbynXC1q2J9kwyP2gw
         Yrl0oadQB6gF1iKWkvzuUkTrBejb6f0KyRML3Cm7Ye55dCra8csNTlX25/WV1/9AAswE
         Y+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=EplIlrIeqL3qzFgDUGxCxRqOfq3c4zp3SLt5PE7mwGU=;
        b=2ChyC33HAjE+tkkZKyJevfFRKV8F0nQYsrnFlvtUDOCUuwaaiqsAefh2O95Ff3eWor
         /qeJsZBgNQt99BgxyY6CkZrF7jcNXgsJPgHaHqf2pr/4m9Q4+hIGz8ZhTpC0kfdJb8gn
         yho2hmD1uHHb+T1XxzyVXkmuKypA/PuEJLCOHL1xIWBZ2vnCwFUTPicCV100bi+eh8k4
         o74YN6db8WdMGHCQEVl0y81DmXwCs35QGCWQGluzUqqYiyDjbpXCY2HjdxHyNslae50t
         lNWizT9pVgMsFgb+VxCV+c2lfOrRGtfkgBtB+4T5wTWzJqsaiQ4wtjHTthDESrvagu/H
         INCA==
X-Gm-Message-State: AJIora/aCwmVAShjbWdQo337Md6fMsDDTMjC8oIVTJbWeY0xVJ3hHitz
        dG8jNqfdOGDWpItalXcmZmbPWm9fiHhz/Q==
X-Google-Smtp-Source: AGRyM1swxpHg/ylzgZI9N9Nyjv0QqP/u1muA/l/hbanPTx+q8x8AesqG46mq+DEpIp9m4pEpUedsIg==
X-Received: by 2002:a05:6a00:1c54:b0:52b:a70e:8207 with SMTP id s20-20020a056a001c5400b0052ba70e8207mr227874pfw.48.1659039124699;
        Thu, 28 Jul 2022 13:12:04 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id rv2-20020a17090b2c0200b001f280153b4dsm4296251pjb.47.2022.07.28.13.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 13:12:03 -0700 (PDT)
Date:   Thu, 28 Jul 2022 20:11:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 041/102] KVM: VMX: Introduce test mode related to EPT
 violation VE
Message-ID: <YuLtj4/pgUZBc6f9@google.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <cadf3221e3f7b911c810f15cfe300dd5337a966d.1656366338.git.isaku.yamahata@intel.com>
 <52915310c9118a124da2380daf3d753a818de05e.camel@intel.com>
 <20220719144936.GX1379820@ls.amr.corp.intel.com>
 <9945dbf586d8738b7cf0af53bfb760da9eb9e882.camel@intel.com>
 <20220727233955.GC3669189@ls.amr.corp.intel.com>
 <af9e3b06ba9e16df4bfd768dfdd78f2e0277cbe5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af9e3b06ba9e16df4bfd768dfdd78f2e0277cbe5.camel@intel.com>
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

On Thu, Jul 28, 2022, Kai Huang wrote:
> On Wed, 2022-07-27 at 16:39 -0700, Isaku Yamahata wrote:
> > On Wed, Jul 20, 2022 at 05:13:08PM +1200,
> > Kai Huang <kai.huang@intel.com> wrote:
> > 
> > > On Tue, 2022-07-19 at 07:49 -0700, Isaku Yamahata wrote:
> > > > On Fri, Jul 08, 2022 at 02:23:43PM +1200,
> > > > Kai Huang <kai.huang@intel.com> wrote:
> > > > 
> > > > > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > > 
> > > > > > To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM programs
> > > > > > to inject #VE conditionally and set #VE suppress bit in EPT entry.  For VMX
> > > > > > case, #VE isn't used.  If #VE happens for VMX, it's a bug.  To be
> > > > > > defensive (test that VMX case isn't broken), introduce option
> > > > > > ept_violation_ve_test and when it's set, set error.
> > > > > 
> > > > > I don't see why we need this patch.  It may be helpful during your test, but why
> > > > > do we need this patch for formal submission?
> > > > > 
> > > > > And for a normal guest, what prevents one vcpu from sending #VE IPI to another
> > > > > vcpu?
> > > > 
> > > > Paolo suggested it as follows.  Maybe it should be kernel config.
> > > > (I forgot to add suggested-by. I'll add it)
> > > > 
> > > > https://lore.kernel.org/lkml/84d56339-4a8a-6ddb-17cb-12074588ba9c@redhat.com/
> > > > 
> > > > > 
> > > 
> > > OK.  But can we assume a normal guest won't sending #VE IPI?
> > 
> > Theoretically nothing prevents that.  I wouldn't way "normal".
> > Anyway this is off by default.
> 
> I don't think whether it is on or off by default matters.

It matters in the sense that the module param is intended purely for testing, i.e.
there's zero reason to ever enable it in production.  That changes what is and
wasn't isn't a reasonable response to an unexpected #VE.

> If it can happen legitimately in the guest, it doesn't look right to print
> out something like below:
> 
> 	pr_err("VMEXIT due to unexpected #VE.\n");

Agreed.  In this particular case I think the right approach is to treat an
unexpected #VE as a fatal KVM bug.  Yes, disabling EPT violation #VEs would likely
allow the guest to live, but as above the module param should never be enabled in
production.  And if we get a #VE with the module param disabled, then KVM is truly
in the weeds and killing the VM is the safe option.

E.g. something like

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4fd25e1d6ec9..54b9cb56f6e2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5010,6 +5010,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
        if (is_invalid_opcode(intr_info))
                return handle_ud(vcpu);

+       if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
+               return -EIO;
+
        error_code = 0;
        if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
                error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
