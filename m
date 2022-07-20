Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABBA57BFA9
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 23:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiGTVeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 17:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiGTVeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 17:34:16 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41AF61B3B
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:34:14 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gq7so2751065pjb.1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1zPvOAfNQSKYRymm+iaox5ob/omLNCeEyMBAD2pYWSM=;
        b=pnrNrarI97nFqDUBSLy8dacdW2PdHQo4VN3LHAYfHJRkO7veBaIQV1oXbkiQDgU5L8
         jOlrBSmzg2EiIBTXZEGliLbzlMeaVv+5wvj3bX+uJ84DvL9NZrC1fHXfxnzKgTHWJ/zD
         DQuIIiEpiSemJ9USa5UEKmZzi65rop/ZduyQf2tv7UDSgwe3HbwkWhLo0nLI4F6DUk2Q
         csQdHcG8Sr5ga7DcgoSOmD3ln/lVAY2prGrH9ciqBlHbYuyBKIgDkyfblKR7Loj4ZKhY
         0G0eTkhkmPyl7PmuwQm9u0pjp7sxd7RqTsU73kqty2uV269PiWCygQCE3mzvgTQFfF3x
         LMHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1zPvOAfNQSKYRymm+iaox5ob/omLNCeEyMBAD2pYWSM=;
        b=Gpsx6oOd3wCIoIIeMCZLrI8pOMQPVPBh4Q/hNpal6h69l7lECJ7eDC6M9yzlp3gwem
         drLEA9GcKZBJ/BTRcBVZR7hn/DfvC5p6noVi/mL+Ivg8oOsyhpJl8Hy7kbn7O+4ffu9c
         TQQ4M/2e1Ej0+iHGFBU/WpFz0+4XEg6cI2ERUHgJxWBejoL803KhNfq6TX8sjopeqwB+
         7uFYE2aZlyEacLYiAcOkyYAOCIENOTkqOssSpQpAqXdE38HnR9+ga3saNUVRNesDbUek
         iJMpqJkDuzBaV5yMJ2yX9I+WRyJf2hw3L/OYk4YrSHnGzL8zGQmRNj2UpU6G+//DMgRt
         xpKw==
X-Gm-Message-State: AJIora+oCf6fIOVBBPARMPz76O5gHu0zdiBd3GzV30vdS/FIgmDLPUyd
        s7XUt8pzZqZll+I4XxZSNPlv8Q==
X-Google-Smtp-Source: AGRyM1vAdYfw9RIxDHrYdR6qtPxUT9OHkYPEAy5IdYgfrX7zq3OBl0MJqfUaJ/gA3DXc5mEUZoUFfg==
X-Received: by 2002:a17:902:9692:b0:16c:4f81:b7 with SMTP id n18-20020a170902969200b0016c4f8100b7mr40889241plp.92.1658352854058;
        Wed, 20 Jul 2022 14:34:14 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id r18-20020a170902be1200b0016784c93f23sm24799pls.197.2022.07.20.14.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 14:34:13 -0700 (PDT)
Date:   Wed, 20 Jul 2022 21:34:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: nSVM: Pull CS.Base from actual VMCB12 for soft
 int/ex re-injection
Message-ID: <Yth00gK0DWjukLgq@google.com>
References: <4caa0f67589ae3c22c311ee0e6139496902f2edc.1658159083.git.maciej.szmigiero@oracle.com>
 <7458497a8694ba0fbabee28eabf557e6e4406fbe.camel@redhat.com>
 <d311c92a-d753-3584-d662-7d82b2fc1e50@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d311c92a-d753-3584-d662-7d82b2fc1e50@maciej.szmigiero.name>
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

On Wed, Jul 20, 2022, Maciej S. Szmigiero wrote:
> On 20.07.2022 10:43, Maxim Levitsky wrote:
> > On Mon, 2022-07-18 at 17:47 +0200, Maciej S. Szmigiero wrote:
> > > Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
> > > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > > ---
> > >   arch/x86/kvm/svm/nested.c | 9 +++++----
> > >   1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index adf4120b05d90..23252ab821941 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -639,7 +639,8 @@ static bool is_evtinj_nmi(u32 evtinj)
> > >   }
> > >   static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> > > -                                         unsigned long vmcb12_rip)
> > > +                                         unsigned long vmcb12_rip,
> > > +                                         unsigned long vmcb12_csbase)
> > 
> > Honestly I don't like that nested_vmcb02_prepare_control starts to grow its parameter list,
> > because it kind of defeats the purpose of vmcb12 cache we added back then.
> > 
> > I think that it is better to add csbase/rip to vmcb_save_area_cached,
> > but I am not 100% sure. What do you think?
> 
> This function has only 3 parameters now, so they fit well into registers
> without taking any extra memory (even assuming it won't get inlined).
> 
> If in the future more parameters need to be added to this function
> (which may or may not happen) then they all can be moved to, for example,
> vmcb_ctrl_area_cached.

I don't think Maxim is concerned about the size, rather that we have a dedicated
struct for snapshotting select save state and aren't using it.

IIRC, I deliberately avoided using the "cache" because the main/original purpose
of the cache is to avoid TOCTOU issues.  And because RIP and CS.base aren't checked,
there's no need to throw them in the cache.
