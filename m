Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09422510B0C
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 23:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355319AbiDZVPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 17:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiDZVPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 17:15:35 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC6A75E5D;
        Tue, 26 Apr 2022 14:12:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id z16so19077311pfh.3;
        Tue, 26 Apr 2022 14:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dTNHzgfUOL4osO2j/zaJgcQDZH2hhUWA+/riZkN8hcc=;
        b=qrMvkpn1dhwLTmWBJPXzi8j82SmulVrBUqm+++Hg5yAlQt7JM9rqoaaQVhTL6+Qirj
         VkJnyWNCuwEF77pl3w3Yn7v1OKFwbznYzvA+WvXSzFqL9xqGq8WxuyLRTsOS/scvDpnx
         JS0tSuTVCGy0Oy+cOvHHdP9pgB1SHu2Y11M/T/aTLxvVm4AofVOpoX59bRz1GJkHajRb
         dyX/f65P2Ygha/5H8VxyqInUOsDxU1zXBQDDWwJB7lp6H0O0C7SW1rnjmXMZC/ChgwI+
         4xGvewgx/OvuNHOJ6X1uXSTWSZJ+eyaDI70Y0KmaG/FzPcX97+XoNr6Bn6LsM1gjSbJJ
         zxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dTNHzgfUOL4osO2j/zaJgcQDZH2hhUWA+/riZkN8hcc=;
        b=uwhsM5AKpA+4XB36HZDaNrLtvon15V/k7GmTKXmbQAucaTVGXpqiXFCqhnkL6R8Tqk
         kTvLF4b9hBLOe26Oz1dEeh+9Ky17tMNzos9m45wZx7QA7T3tMpMNjXWE92JqDmtYesBg
         sS7GHGXlh+wuFqddnP4N0wV6I7XqloTgV9Xm2xedzeC8zcCcfyTPQZUb3FbkZcG576rc
         mIhl/XpfEGysztkdHGrwCRK09bz0e+VwVuBRcUVD/V6YsUyg47ZwR4f2r78xWQaYNLxY
         E71Am5wWTfAvrbCPMJ0qiGMGx20y0Y3+CvYlHHWj/P7uw5+AsK7lBmXxhuIbttWQO6PT
         fxhw==
X-Gm-Message-State: AOAM533939sTNKIEeiUQGpKFYTISK8t8QtOqksC/nR7l7V0cNgPdZy7d
        C/CmvOMaKHLommDcgn125J8=
X-Google-Smtp-Source: ABdhPJyOnqoegYBSF3apdSPf31rkfnNuc96uFOcVS4nbde0MYTQIrogR4qYfOw1CqlklwjUpY7Oqag==
X-Received: by 2002:a63:2b8a:0:b0:3aa:f59e:a4a7 with SMTP id r132-20020a632b8a000000b003aaf59ea4a7mr15560768pgr.91.1651007546318;
        Tue, 26 Apr 2022 14:12:26 -0700 (PDT)
Received: from localhost (c-107-3-154-88.hsd1.ca.comcast.net. [107.3.154.88])
        by smtp.gmail.com with ESMTPSA id f14-20020a63380e000000b0038253c4d5casm13765851pga.36.2022.04.26.14.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 14:12:25 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:12:23 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 048/104] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <20220426211223.GA1719560@private.email.ne.jp>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <7a5246c54427952728bd702bd7f2c6963eefa712.1646422845.git.isaku.yamahata@intel.com>
 <fb83aaeed48c7da071f0e9f3e4b36e9145ad5c63.camel@intel.com>
 <CAAhR5DHFi14LzAt+3t-1tSFMLZYmtx-TxXSovh8m4=R=5NsdXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhR5DHFi14LzAt+3t-1tSFMLZYmtx-TxXSovh8m4=R=5NsdXA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 25, 2022 at 12:10:22PM -0700,
Sagi Shahar <sagis@google.com> wrote:

> On Wed, Apr 6, 2022 at 5:50 PM Kai Huang <kai.huang@intel.com> wrote:
> >
> > On Fri, 2022-03-04 at 11:49 -0800, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
...
> > > @@ -914,14 +1014,23 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> > >       u64 new_spte;
> > >       int ret = RET_PF_FIXED;
> > >       bool wrprot = false;
> > > +     unsigned long pte_access = ACC_ALL;
> > >
> > >       WARN_ON(sp->role.level != fault->goal_level);
> > > +
> > > +     /* TDX shared GPAs are no executable, enforce this for the SDV. */
> > > +     if (!kvm_is_private_gfn(vcpu->kvm, iter->gfn))
> 
> This should be:
> if (kvm_gfn_stolen_mask(vcpu->kvm) && !kvm_is_private_gfn(vcpu->kvm, iter->gfn))
> 
> Otherwise, when TDX is disabled, all EPTs are going to be considered
> as shared non-executable EPTs.

Oops, will fix it. Thank you for pointing it out.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
