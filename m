Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB9573E5FB
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 19:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjFZRGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 13:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjFZRGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 13:06:43 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E11710C9
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:06:42 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6726d5d92afso1072231b3a.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687799201; x=1690391201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f2t/6AuCGHu+g1mzUi3uHQSoDcB61+uw4A1sl2aTsDM=;
        b=VL9wL2ourXiEvavwXqheIk73JPQwGGIH/H2tda9/Zck/TvRhVxV9oYsIvIrgQb2uoR
         czgVjuZJvSCtc/cyiZpI1tdiOBFAQQxEZNvUpN/teRyo3rlg7ua/6w2MBf4PNwaTjIGC
         NtvQawe+cOaK43vt2lJ5HRfxkQyGbEIAOvS1iFM5Z275b/luF8a5GGF7Lf9NxkJ66W4P
         Ud2s3StNuqd0sR3p6jbbkyzVCnoT9jc3SvLXCJl/SgCqy6x37qogwLNqITcPb1H79Q0Y
         ll7gBl0y8iSAzAvqj/f1e1CjK0Nrbgego8zQl40fh8WlXDSt4H1GSgzTs7teof7ND609
         R+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687799201; x=1690391201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2t/6AuCGHu+g1mzUi3uHQSoDcB61+uw4A1sl2aTsDM=;
        b=J/RWk1ZPSazzoRoIL3X2uig6D/FDSOSu7FD67BMcPUplF72FozM+tjSo3LjLOnEx2d
         rw7XYRL3+dBk/RRMlmecwxqMf4BuFBjpDpeeM0FbL2FHBcWMTI0u2qTRcvxdBTx5d/WK
         yXPG6cJxaCtEH4UXlaRxtGa95HULxNzU+znmn2TkGcMk3JE6JPDZBp84bLCRQuB3dIxs
         4vqOJP9oCBVMHNCIBal2Pe2EoW9uL04uuUiiThFoeVSjB87loGdjnqItl7b7P467fCPi
         UBi7YW/NV1s87a6pkw8c+1cZVsI0qbg9ZCcv0GQwdvUSgIpLg1Itu3pNUtWEGyq+QSr1
         uOlw==
X-Gm-Message-State: AC+VfDyx+xMn0PqnDvRED4DjhhY1aNX1hXTc3hdTPjvtLINT02JHXAw+
        GUxn6aXNDCPgH3HKjmexgVDqXQ==
X-Google-Smtp-Source: ACHHUZ6unRv0OlEcCIZYcuG4X+sRKYMWHVWf1+9GkTHOWMxxJlTDQ3OSvpC2peZAtNC3r4ALhBBm7A==
X-Received: by 2002:a17:902:c1d2:b0:1b5:e30:94dc with SMTP id c18-20020a170902c1d200b001b50e3094dcmr8092819plc.7.1687799201193;
        Mon, 26 Jun 2023 10:06:41 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id s12-20020a170902988c00b00198d7b52eefsm4420214plp.257.2023.06.26.10.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 10:06:40 -0700 (PDT)
Date:   Mon, 26 Jun 2023 17:06:35 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 2/6] KVM: Documentation: Update the field name gfns in
 kvm_mmu_page
Message-ID: <ZJnFm0gD4K0uc92G@google.com>
References: <20230618000856.1714902-1-mizhang@google.com>
 <20230618000856.1714902-3-mizhang@google.com>
 <ZJTnvuoVWLhv0H0f@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJTnvuoVWLhv0H0f@yilunxu-OptiPlex-7050>
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

On Fri, Jun 23, 2023, Xu Yilun wrote:
> On 2023-06-18 at 00:08:52 +0000, Mingwei Zhang wrote:
> > Update the 'gfns' in kvm_mmu_page to 'shadowed_translation'to be consistent
> > with the code. The more detailed description of 'shadowed_translation' is
> > already inlined in the data structure definition, so no need to duplicate
> > the text but simply just update the name.
> 
> The definition of this field is changed, but apprently the description
> here is for gfns. It leaves some confusion if we just leave them
> unchanged.
> 
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  Documentation/virt/kvm/x86/mmu.rst | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > index 561efa8ec7d7..149dd3cba48f 100644
> > --- a/Documentation/virt/kvm/x86/mmu.rst
> > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > @@ -221,7 +221,7 @@ Shadow pages contain the following information:
> >      at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
> >      The spt array forms a DAG structure with the shadow page as a node, and
> >      guest pages as leaves.
> > -  gfns:
> > +  shadowed_translation:
> >      An array of 512 guest frame numbers, one for each present pte.  Used to
> 
> guest frame numbers -> shadow translation info (gfn + access)

Will add this one. I will avoid the "(gfn + access)" since that is
already described in the comments inline and it may subject to changes,
eg., adding more bits in the future.
> 
> >      perform a reverse map from a pte to a gfn. When role.direct is set, any
> 
> Just "perform reverse mapping" is OK?

I will tend to leave that as is, since it is not a major issue.
> 
> >      element of this array can be calculated from the gfn field when used, in
> 
> May remove the "of gfns"

will do.
>
> Thanks,
> Yilun

Thanks for the comment, will update it in next version.
> 
> > -- 
> > 2.41.0.162.gfafddb0af9-goog
> > 
