Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC876A0BB
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 20:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjGaS7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 14:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjGaS7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 14:59:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E63109
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:59:46 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bb7b8390e8so29521535ad.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690829986; x=1691434786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QaCjkfq4GN48OOcuB8c05SWee45tE8EdW2QBnU8SY4I=;
        b=EiK2WSAmGmaqQEvSbbJ3JZEviDOaWmDe8ynJ3FXfHSP/Gkq3ewW9MqltZrXpWvrzDW
         U9bv1T03LHepVLA5BbKnCuHkuwClGkn+0sOPSTPpIVR6mEyzHPzUKXpNIq5HzthZxA4E
         iqDLe092brH/rfizjd+pi0E28u3OHdojmPk2G81QdE+OJGKiT/d/d+vqrEMd+YM1IJk8
         P62xw1aoItrCOmWCT0FXXNNx9O7alPW+tVaGUUUH0qTNz8h6RCeMPjejlw6PtVbGQX2f
         MitOMblbL4w/dKmnsYOIU1Hx3YNIxeQH+bT6ERIlpeopNXt6IGkJIh71PRnfSSXUOGQ7
         mF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690829986; x=1691434786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QaCjkfq4GN48OOcuB8c05SWee45tE8EdW2QBnU8SY4I=;
        b=c5e8z73tsMM2k0+4XwSNwKk0bQcVX+DPN62NHklT6/0quyd6w4KC5q6pXIRf/9HByN
         slDqSnlisPKxzWg/nw1YLCjfbDCqP5ML/FeOLgM2FDrBPIFMKHDinwRugOHfMK+Vz+xl
         TU+p8iL8hE4D7oZnnlISDifAgKJR1bTTmTc8c5SGuMVyrdnB17iiALHJJqMYVYZ26tr2
         nk5eJFtHgp0uMeiyLT39YNtA65Wv5GAeHWl+88XM3WQ/0GZZHgYUfJUpab2L9DoDmx++
         EpFtgNArfgzK0cfHpIverKTOhhaNSuyYWOUh9bcJF2QZiFrTzqAAnKSatNTVwr47R78M
         nHHQ==
X-Gm-Message-State: ABy/qLb90n6Eq10ht9Zh9kUUczZysi1aa0tDK8L1jyFaIV65sxWCLbjK
        qWqzEzGf1ktMRF+xmHKMsKBT2w==
X-Google-Smtp-Source: APBJJlFiuOPF4Y0ss6mOyzZftVPO6k6O/8jXu5ibwwUQfSMvrDykbWBbfTI1DEL3Vh4aQjrofJsK7w==
X-Received: by 2002:a17:902:9a87:b0:1b9:dea2:800f with SMTP id w7-20020a1709029a8700b001b9dea2800fmr9370914plp.8.1690829985516;
        Mon, 31 Jul 2023 11:59:45 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id jk17-20020a170903331100b001bbce3d4774sm8949893plb.79.2023.07.31.11.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 11:59:44 -0700 (PDT)
Date:   Mon, 31 Jul 2023 18:59:40 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: Documentation: Update the field name gfns
 and its description in kvm_mmu_page
Message-ID: <ZMgEnJFj72ZARUOP@google.com>
References: <20230626182016.4127366-1-mizhang@google.com>
 <20230626182016.4127366-3-mizhang@google.com>
 <ec65c77a-3499-6278-f352-9bbe25a44b96@infradead.org>
 <ZMf1TkrUjP6+/VSC@google.com>
 <ZMf8T8kdiDJlqtmS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMf8T8kdiDJlqtmS@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023, Sean Christopherson wrote:
> On Mon, Jul 31, 2023, Mingwei Zhang wrote:
> > On Mon, Jun 26, 2023, Randy Dunlap wrote:
> > > Hi--
> > > 
> > > On 6/26/23 11:20, Mingwei Zhang wrote:
> > > > Update the field 'gfns' in kvm_mmu_page to 'shadowed_translation' to be
> > > > consistent with the code. Also update the corresponding 'gfns' in the
> > > > comments. The more detailed description of 'shadowed_translation' is
> > > > already inlined in the data structure definition, so no need to duplicate
> > > > the text but simply just update the names.
> > > > 
> > > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > > > ---
> > > >  Documentation/virt/kvm/x86/mmu.rst | 9 +++++----
> > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > > > index 561efa8ec7d7..4c9044b4dc6c 100644
> > > > --- a/Documentation/virt/kvm/x86/mmu.rst
> > > > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > > > @@ -221,11 +221,12 @@ Shadow pages contain the following information:
> > > >      at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
> > > >      The spt array forms a DAG structure with the shadow page as a node, and
> > > >      guest pages as leaves.
> > > > -  gfns:
> > > > -    An array of 512 guest frame numbers, one for each present pte.  Used to
> > > > -    perform a reverse map from a pte to a gfn. When role.direct is set, any
> > > > +  shadowed_translation:
> > > > +    An array of 512 shadow translation entries, one for each present pte. Used
> > > > +    to perform a reverse map from a pte to a gfn. When role.direct is set, any
> > > >      element of this array can be calculated from the gfn field when used, in
> > > > -    this case, the array of gfns is not allocated. See role.direct and gfn.
> > > > +    this case, the array of shadowed_translation is not allocated. See
> > > 
> > > I cannot parse the before version nor the after version of this sentence (new version):
> > > 
> > >                                                   When role.direct is set, any
> > >     element of this array can be calculated from the gfn field when used, in
> > >     this case, the array of shadowed_translation is not allocated.
> > > 
> > > 
> > 
> > Sorry for the late reply.  Why is it not parsed? It just means that when
> > role.direct is set, do not use gfns. The gfn can be calculated from the
> > base address + offset. The base address here is the 'gfn' field in
> > kvm_mmu_page.
> 
> It's a bit of a run-on sentence with confusing pronoun usage.  How about this?
> 
>   When role.direct is set, the shadow_translation array is not allocated as the
>   per-SPTE gfn is simply an offset from the base gfn, and KVM doesn't track
>   access permissions for direct shadow pages.

I think the problem might be that the sentence is slightly long. To be
accurate, we have to mention access permission which the original text
did not. Also, I split the sentences and try only using short ones. The
overall description will be longer. How about this?

  shadowed_translation:
    An array of 512 shadow translation entries, one for each present pte. Used
    to perform a reverse map from a pte to a gfn as well as its access
    permission. When role.direct is set, the shadow_translation array is not
    allocated. This is because the gfn contained in any element of this array
    can be calculated from the gfn field when used.  In addition, when
    role.direct is set, KVM does not track access permission for each of the
    gfn. See role.direct and gfn.
