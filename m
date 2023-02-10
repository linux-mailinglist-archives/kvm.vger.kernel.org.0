Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202EF692358
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 17:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjBJQc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 11:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbjBJQcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 11:32:55 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFCE1557E
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:32:53 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z1so7005649plg.6
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t4JppvWrlOftFQ6B3KyKDCv+zprstYytu84ajEH+KEE=;
        b=F+foiiOeW08NIyP4t/CJkeoVpetAkQjX83goy9RnWIOlsNLwHz0BcaMSR/eclsb3cy
         3LKJd0DPRrVZa2rKx4XgaJxlcbcMqWRrcfhtsQ+O+0jbkX8GqfTy2CbTYJs6Nc9ZNARL
         DSD4M50ushUyfcpJssaXS/mVUFYsMQ1yDFT+fKoQYtdjWR4w/uOWVMVziIkZ4IL/PEUC
         Ij1gfuop+u8UP+myAl8YyG1q4n2ULwp8/Kfzot+ZVMTa/Y05FOYr/iSfQJTPW5KHbH56
         Z/Ky0DCAWTfzLWSdSJ6HTQpEO9SP6jxhnAF5+1Q+wKOXfQcKVaERftHNZWEgI3CV8Pfn
         6XOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4JppvWrlOftFQ6B3KyKDCv+zprstYytu84ajEH+KEE=;
        b=SgMvhbd7GXc5i/RCQuVtvAiYkDlGPN0KP4x2IPeE+1fDcwih8I/xT9mgGYpWHdapIP
         +dBpVG1+01Ouev6L7vjS8qeCLQknwtcu55aPaF9AjHfe18v4U3TzDU6Tfrc2BdIysRPI
         rFh+CkJoDWwSB4XUT6o5dbNrCRfNZXU2yU9smE/tjXtIGYMloRPsTmKpZgEBFR3lqN8A
         oiIfpK06Q8lw55HiAPBKFAkQ2ZM+l31ePWUvaqdWAmYY5jn4iemy/rkGM+DnBOVhvNQL
         6uUxqqUG0+wMcztrFH1irZuUbNfLNKdHUTblmiLW1gmxTjKRyn+E7jbFcC3Lw40WFZhB
         VAqQ==
X-Gm-Message-State: AO0yUKUKZFAXGzE4AhFhcwokrx0m+sMNPoL4PFVFOp9bcJpHPxtiuq96
        oFE3Wj3Xj+ylyqh/z+YvuM2aew==
X-Google-Smtp-Source: AK7set/STuZlQmxn+y5oGODX2wBKlDA3Bmf+6S4y4o16QGSC10PiJumxCVvNnruiihIijTDF9RMZ6w==
X-Received: by 2002:a17:902:ee12:b0:19a:6fe0:f96e with SMTP id z18-20020a170902ee1200b0019a6fe0f96emr265357plb.2.1676046773092;
        Fri, 10 Feb 2023 08:32:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902ecce00b00196048cc113sm3587766plh.126.2023.02.10.08.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 08:32:52 -0800 (PST)
Date:   Fri, 10 Feb 2023 16:32:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH 3/6] KVM: x86/pmu: Use separate array for defining "PMU
 MSRs to save"
Message-ID: <Y+ZxsfDGCoEXL4lW@google.com>
References: <20230124234905.3774678-1-seanjc@google.com>
 <20230124234905.3774678-4-seanjc@google.com>
 <20230210132335.nrahzzhv62vegey4@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210132335.nrahzzhv62vegey4@linux.intel.com>
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

On Fri, Feb 10, 2023, Yu Zhang wrote:
> On Tue, Jan 24, 2023 at 11:49:02PM +0000, Sean Christopherson wrote:
> > Move all potential to-be-saved PMU MSRs into a separate array so that a
> > future patch can easily omit all PMU MSRs from the list when the PMU is
> > disabled.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 153 ++++++++++++++++++++++++---------------------
> >  1 file changed, 82 insertions(+), 71 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d4a610ffe2b8..9b6e1af63531 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1419,7 +1419,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
> >   * may depend on host virtualization features rather than host cpu features.
> >   */
> >  
> > -static const u32 msrs_to_save_all[] = {
> > +static const u32 msrs_to_save_base[] = {
> 
> I guess the comments relating to msr_to_save_all should be updated as well. :)

Gah, yes.  I caught that at one point but lost track of it.  I'll get it fixed
in v3.

Thanks!
