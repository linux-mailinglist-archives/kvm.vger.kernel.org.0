Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A7862E320
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbiKQRdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiKQRdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:33:06 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411BB79E16;
        Thu, 17 Nov 2022 09:33:06 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d192so2479465pfd.0;
        Thu, 17 Nov 2022 09:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=irBTpzdt3UKRDSaNb8P0V0IX9do/eaeR5wsA7XkY2ZM=;
        b=he3HAFo1vLSohQ1GDMkdmyEQuAtzCtKtgHDZ9rpSjs/rlQYgBG2tiS79xmS9Or1e8X
         C2uBPXlyMuubFKL8UqsXYX0n27S5LwIYGhWJkkZe5qXRkrrRjpIezlltEoyKSIR166Rn
         dZ5HCa8vzD4epku1LfsNmvU8CLXTd/fKYF6ELgR8SE6XfL/ZRhDihUj3KpmndifWM4ur
         cj/o4R9gxWPfMwfmofXWxUFeJDhlw70mq2cV6+5ZEm7VszZOWHjadrcz5wM0iviLwCTH
         Y34E6E0Xlxc9S8nLc4UiwngYQINpmL8DdA0PhP6qHlz900Nfsb5unfx2oSKJR/JJwbak
         MugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irBTpzdt3UKRDSaNb8P0V0IX9do/eaeR5wsA7XkY2ZM=;
        b=bLAaxue1bEXUh5Zl/0FKUOFS1FvKvL4ue+tMjepImAfxlGhu/O2DhOKAuFihTbSLwQ
         IKNDlfg8/Nmw9fer4zdt8fQphAH2TcE7vDNbxVQmBDW+PG77/m6zuseR0e7It3sRKl9c
         6/AjjzSOd9iUeok/lziR5dz+PL1TsiWoWQH5wv4yFH4mAy5QrpB+PIHWSFnnaH0QTpnk
         nU8SdpRlZ5i5yHsTgUf1IBmstl1y+xUwKdwtff/aUWKP6O2qg+BwmZVAQtrr23Yu3m0t
         vk0//iFI4kgnFd2ASY/6DlHEBrJxJNi0DXvFbuB3e7YZfE453gEhrLn7g80pSQruUPFq
         Thcw==
X-Gm-Message-State: ANoB5pnHhOpXIT7OZt2QSPAuSCZ9ldGtxXYPP1y/DGLTgW3zz49ZsFqr
        Thsg924szY8OnIE1vZiENAey+5sotUo=
X-Google-Smtp-Source: AA0mqf5uJqta9XJjikgXOcN3zPD0sje1CAgXFsnL+Bp0lgoCql9d0jjeN9rKmGWuTl37VIGedFZ3KQ==
X-Received: by 2002:a63:171e:0:b0:476:9983:b395 with SMTP id x30-20020a63171e000000b004769983b395mr2972617pgl.355.1668706385524;
        Thu, 17 Nov 2022 09:33:05 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id 34-20020a631362000000b004597e92f99dsm1220728pgt.66.2022.11.17.09.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:33:04 -0800 (PST)
Date:   Thu, 17 Nov 2022 09:33:03 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20221117173303.GB2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
 <0feaa13fa5bf45258f2ebb8407eaefadf5c48976.camel@intel.com>
 <20221114231835.GA2350331@ls.amr.corp.intel.com>
 <CAAYXXYzM4=X5euL_cMx=YnPR7=8k9V_VY2ZyLs-RKz76DB2DcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAYXXYzM4=X5euL_cMx=YnPR7=8k9V_VY2ZyLs-RKz76DB2DcA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 04:22:13AM -0800,
Erdem Aktas <erdemaktas@google.com> wrote:

> On Mon, Nov 14, 2022 at 3:18 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> > > I think you should explain why MOVDIR64B is required, otherwise this just comes
> > > out of blue.
> > >
> > > Btw, is this absolutely required?  TDX also supports Li-mode, which doesn't have
> > > integrity check.  So theoretically with Li-mode, normal zeroing is also OK but
> > > doesn't need to use MOVDIR64B.
> > >
> > > That being said, do we have a way to tell whether TDX works in Ci or Li mode?
> >
> > As long as I don't know.  When clearing page, we can use
> > if (featuremovdir64b) movdir64b else memset(0).
> 
> -- sorry for resending the same email, for some reason my previous
> email was not in plain text mode--
> As far as I know, Li mode and Ci mode both are working very similarly
> and require movdir64b to clear any poison bit previously set. Why
> would movdir64b is not supported in a tdx capable cpu?

In practice, movdir64b can be safely assumed to be supported, I think.  Strictly
it's not guaranteed by SDM.
There are two options.

1. Assume modir64b. If it's not supported, KVM refuses to enable TDX.
   + Don't care CI-mode or Li-mode
   - not strictly conforming to SDM. In practice, it won't matter.
2. Don't assume movdir64b.  If movdir64b not supported, use memset(0).
   + strictly conforming to SDM
   - needs to care Ci-mode or Li-mode.

So I'll choose option 1.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
