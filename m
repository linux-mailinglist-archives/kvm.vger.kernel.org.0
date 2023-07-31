Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B68E769FCE
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 19:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjGaRyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 13:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjGaRya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 13:54:30 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854DDDC
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:54:29 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-686be28e1a8so3184809b3a.0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690826069; x=1691430869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ye1hBUjkNRk39gbDG705nkaSiiZ5DkFSScU/cjrv98U=;
        b=yD59vn9kqIM2hU9m6M6C5eYC4+NgiocCNfCOTTv2AfStv9/CAubB/d7o5PgACopPv8
         8uWIzKfh1TGzdd/7w4E1rL5mrr6gAN9Dl40sy7HmU5fW2avaWsp9viSmnLI2TZ1cAGXW
         wADO2+xJ10Sic7OVzGWoB0L9ACqz3C8cbNVTl0Xl9LfFDCXkF/QzlSXhskTo5QMuHEXY
         I0p4bB03w3aKxnzVvRx74a3sX6VtB5HXT4eL/v3LWM49QN23Y2+YmY4OSyqS9Z+X8OBp
         5xxacTaZB9U2+LoCB9PE06OBW/AhKDIg8fuxZjsKhmTj88yw237yz2K2+Um/mroMWROR
         MRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690826069; x=1691430869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ye1hBUjkNRk39gbDG705nkaSiiZ5DkFSScU/cjrv98U=;
        b=FT5Zc7VoNN4jP1mi5uE0k2m0apFW5Jmn0VZcAckzXHWcodtP/Rhrw18s2O59IEdvI1
         FGIceUifXZAD5aODfiAoaPlHSejaD7jNIQw0GxFwhsfQqbMeo9hBwpLwY0Ie5nWpP9mK
         w84ATmPAKo4AV+1KujG5heDUKkwMLEFZ4N1+pYE0BO+k+qA76FQQHRJUFw/5Q4ykxvC7
         TuuE9pOhN+U4yu0/Lwwyw7a1dOcRT1kInArwjyAWX134PUsCBp0xCmZj7++8RLh0GR+G
         A50AOGWxXkHyLxEQ28lYMfYvKK8i5rPFd/GtCM9cDnDvDZQ5xct9RUZhg7Ulch54zvZZ
         jW5Q==
X-Gm-Message-State: ABy/qLazSTtNL49FvyBWs2TNACxzmBWXMvs82LRm6UgBe2aUs7BUWm/s
        jqx1Gd43xIq/NJe/MTaaxj0dbw==
X-Google-Smtp-Source: APBJJlEbEnRkq29IMUQ+Kip8yG6iM7uCvIqvaT6P3hXS9+YRDB58ekn1I7Jthg7ZpOUWG0IsWJ7r7w==
X-Received: by 2002:a05:6a21:7182:b0:133:b3a9:90d with SMTP id wq2-20020a056a21718200b00133b3a9090dmr10372183pzb.36.1690826068797;
        Mon, 31 Jul 2023 10:54:28 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id q23-20020a637517000000b0055b4307963dsm2001743pgc.23.2023.07.31.10.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 10:54:27 -0700 (PDT)
Date:   Mon, 31 Jul 2023 17:54:22 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: Documentation: Update the field name gfns
 and its description in kvm_mmu_page
Message-ID: <ZMf1TkrUjP6+/VSC@google.com>
References: <20230626182016.4127366-1-mizhang@google.com>
 <20230626182016.4127366-3-mizhang@google.com>
 <ec65c77a-3499-6278-f352-9bbe25a44b96@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec65c77a-3499-6278-f352-9bbe25a44b96@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023, Randy Dunlap wrote:
> Hi--
> 
> On 6/26/23 11:20, Mingwei Zhang wrote:
> > Update the field 'gfns' in kvm_mmu_page to 'shadowed_translation' to be
> > consistent with the code. Also update the corresponding 'gfns' in the
> > comments. The more detailed description of 'shadowed_translation' is
> > already inlined in the data structure definition, so no need to duplicate
> > the text but simply just update the names.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  Documentation/virt/kvm/x86/mmu.rst | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > index 561efa8ec7d7..4c9044b4dc6c 100644
> > --- a/Documentation/virt/kvm/x86/mmu.rst
> > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > @@ -221,11 +221,12 @@ Shadow pages contain the following information:
> >      at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
> >      The spt array forms a DAG structure with the shadow page as a node, and
> >      guest pages as leaves.
> > -  gfns:
> > -    An array of 512 guest frame numbers, one for each present pte.  Used to
> > -    perform a reverse map from a pte to a gfn. When role.direct is set, any
> > +  shadowed_translation:
> > +    An array of 512 shadow translation entries, one for each present pte. Used
> > +    to perform a reverse map from a pte to a gfn. When role.direct is set, any
> >      element of this array can be calculated from the gfn field when used, in
> > -    this case, the array of gfns is not allocated. See role.direct and gfn.
> > +    this case, the array of shadowed_translation is not allocated. See
> 
> I cannot parse the before version nor the after version of this sentence (new version):
> 
>                                                   When role.direct is set, any
>     element of this array can be calculated from the gfn field when used, in
>     this case, the array of shadowed_translation is not allocated.
> 
> 

Sorry for the late reply.  Why is it not parsed? It just means that when
role.direct is set, do not use gfns. The gfn can be calculated from the
base address + offset. The base address here is the 'gfn' field in
kvm_mmu_page.

> > +    role.direct and gfn.
> >    root_count:
> >      A counter keeping track of how many hardware registers (guest cr3 or
> >      pdptrs) are now pointing at the page.  While this counter is nonzero, the
> 
> -- 
> ~Randy
