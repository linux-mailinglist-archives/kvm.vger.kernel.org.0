Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393E46747E4
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 01:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjATAQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 19:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjATAQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 19:16:53 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16649A3141
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 16:16:53 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so7503734pjg.4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 16:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DEPCY4FH8o/XwFLi2kB8iQ/8Z4EhiwjsxNkLh5khKbU=;
        b=qElKliehHax2qwYlhU/Eg8OFlYXDMj6MvsngbY40n7qtZMIH37uziyb1ykEXC54oL4
         txnnLzrubLgvAZhPaR6ezXkv3xfifO2GSb1XCaip2Q3lEzdHntjrsWbGhampHCUY/MT6
         NB5JC0kzvkh7DI28KWlVReA2m49sZnCfts10DTFCbWcizgaqXCgmAefAwpLnDFoV3ga/
         Y61HYbcntH9Ef0EjAqxj9OyHrLjFdl7kWwsEPgCopX1+oTK40DiYPu4N42TKC/9JRF61
         +gGGlB9ZfMESjO4P3nx/a9ZSwpIe9sgg/XfSLKsRxm1XC0eCBT4LYLIc23kYwQFl93gB
         fQ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DEPCY4FH8o/XwFLi2kB8iQ/8Z4EhiwjsxNkLh5khKbU=;
        b=ILAEMmwyQh7uoD7kmUmHuQ79eI80zJXoBy1uFCUilJb5jVf8u5qMwG1E65+SiF5fLB
         vKggh7PGnSWsz7+4rOXli41kjFdRhJhKYEt57WVNtBdnwMyzyM8dF0IsTmLgBbpZzU0O
         nBh8YFJcPWawFkxxKIhl00gZFi3iZULpzzxUvPItkNPMwvsEOYnLvuBrlSBXZ+orZJx4
         hlmslOMh8GaN1YCl5v4DIgtww+0bjwD7BqzxLzUmfB0F8jlUrJy13lpmvgd48a79O03b
         T7AdiXzs+5HkZWM3On3Pefm5glb+RgSHkXfr5LUqyrQ4J8vT5t8XK1iacZme88LuConJ
         mTqQ==
X-Gm-Message-State: AFqh2koIjuClMxrVO0MLGnnonKxrSpp6IQKE+FIcAFkNuYcnWBfN+98L
        TsLtkEjiBYyHgSgJZ+0kuwlnow==
X-Google-Smtp-Source: AMrXdXtv78b6LJfbGg24aE8Prbqx4UwLFqXFtgEWYv5zThMVaL8f60chW7KYaaUoA7dLlLVuVXsjkQ==
X-Received: by 2002:a05:6a20:a00f:b0:b9:14e:184b with SMTP id p15-20020a056a20a00f00b000b9014e184bmr43474pzj.3.1674173812407;
        Thu, 19 Jan 2023 16:16:52 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w9-20020a628209000000b0058a72925687sm18226715pfd.212.2023.01.19.16.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 16:16:51 -0800 (PST)
Date:   Fri, 20 Jan 2023 00:16:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "dmatlack@google.com" <dmatlack@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y8ndcGHUHQjHfbF9@google.com>
References: <20230114111621.00001840@gmail.com>
 <Y8bFCb+rs25dKcMY@google.com>
 <20230117214414.00003229@gmail.com>
 <Y8cLcY12zDWqO8nd@google.com>
 <Y8cMnjHFNIFaoX27@google.com>
 <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
 <Y8ljwsrrBBdh1aYw@google.com>
 <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
 <Y8m34OEVBfL7Q4Ns@google.com>
 <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
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

On Thu, Jan 19, 2023, Huang, Kai wrote:
> On Thu, 2023-01-19 at 21:36 +0000, Sean Christopherson wrote:
> > The least invasive idea I have is expand the TDP MMU's concept of "frozen" SPTEs
> > and freeze (a.k.a. lock) the SPTE (KVM's mirror) until the corresponding S-EPT
> > update completes.
> 
> This will introduce another "having-to-wait while SPTE is frozen" problem I
> think, which IIUC means (one way is) you have to do some loop and retry, perhaps
> similar to yield_safe.

Yes, but because the TDP MMU already freezes SPTEs (just for a shorter duration),
I'm 99% sure all of the affected flows already know how to yield/bail when necessary.

The problem with the zero-step mitigation is that it could (theoretically) cause
a "busy" error on literally any accesses, which makes it infeasible for KVM to have
sane behavior.  E.g. freezing SPTEs to avoid the ordering issues isn't necessary
when holding mmu_lock for write, whereas the zero-step madness brings everything
into play.
