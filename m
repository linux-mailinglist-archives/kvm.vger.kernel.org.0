Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555AA69234D
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjBJQap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 11:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjBJQao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 11:30:44 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59814728A4
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:30:42 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so10378008pjq.0
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7pbPCk9G+eMGJlz2DXYgzPO43JELaoFSUzKNpA+IbI8=;
        b=ekrVTgFd+2VXXqPzUA1TmB7eEwvsVOj1plSjISw1w4dmCThhgVHgMF69L3wYIIMMu0
         rNPYhhhdQAHcD0PrFt0PeMDtV3EZFsHmd0mk/+cKfjNY0YHtTdYy2dV409X+vJS9syiV
         vnyUBvt7qiQM4aidp4qpWCSeI3Fz1Y68/61yAuduMR0CVb5F/wAQXkT0l3i48RjA3u1X
         DBgv6w1apJGrG68WAJJf0pOAUGF3WcctZpO/FoVbomKCEGgf74cHEFZ7OisboiJUn9QA
         49lUG0aRasUAVJzdKsmw0v1LjnIEDks5tBZGKMdNY8myp4pajkaCy3x/447l4JWEdzzy
         5GZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pbPCk9G+eMGJlz2DXYgzPO43JELaoFSUzKNpA+IbI8=;
        b=AKqGHjSuzOHhpIbEUu9fwLQ9FxXp6UH2o3jpti500SjerT46aT10pHPcDSxKujXAUE
         DVem8hBLMz8h5lyeQlLhrtroWLzHUH3zcSVH1Q+AmgXjgGFCRe7ivnKUttw/hSoEFKnu
         eF5Mm2qQaNwdJgqnNUL6kOJYEcroMX6qWuAc69dYKmJor016RGsKQW9f4E2WVKpMNveX
         27xqddqAVqZ3pGt2OamKQU0FznpHVafYADTgtX1GQ0iG+W+DXEDsrX/cL+8n6h2dudnL
         UFiW6NqXcgosNJi3Mr46+vpoxxmiYfah2fSJQWxNg451+1VgOG4ARN8CMCAYfsqqBQMT
         RJPw==
X-Gm-Message-State: AO0yUKUbOc5sNOJV5dPTT+31/Ld/ZbntGKJen/RbphbKnjwJ0OG4JotY
        BD6C/o6VrpFd3uVRcCPBmVOZRunNtpS2jQp7Kr4=
X-Google-Smtp-Source: AK7set/bodZUA39k9Q05Atj0WlAYxPl39q+0Xm2CL30RKaG+0qb8wGuogstqZNPaHCW5RlqVoKBBCA==
X-Received: by 2002:a17:903:1108:b0:198:af50:e4e8 with SMTP id n8-20020a170903110800b00198af50e4e8mr251606plh.14.1676046641705;
        Fri, 10 Feb 2023 08:30:41 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n35-20020a17090a2ca600b00230ffcb2e24sm3199500pjd.13.2023.02.10.08.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 08:30:41 -0800 (PST)
Date:   Fri, 10 Feb 2023 16:30:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
Message-ID: <Y+ZxLfCrcTQ6poYg@google.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-2-robert.hu@linux.intel.com>
 <63c23749-f0c1-28b8-975e-a5b01d070b54@intel.com>
 <8b7155472fa91cca2eaec354a40eaba7de8d13f1.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b7155472fa91cca2eaec354a40eaba7de8d13f1.camel@linux.intel.com>
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

On Fri, Feb 10, 2023, Robert Hoo wrote:
> On Fri, 2023-02-10 at 11:29 +0800, Yang, Weijiang wrote:
> > On 2/9/2023 10:40 AM, Robert Hoo wrote:
> > > Remove CR4.LAM_SUP (bit 28) from default CR4_RESERVED_BITS, while
> > > reserve
> > > it in __cr4_reserved_bits() by feature testing.
> > > 
> > > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > > Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> > 
> > As Sean pointed out in[*], this Reviewed-by is for other purpose,
> > please 
> > remove all of
> > 
> > them in this series.
> 
> No. Sean meant another thing.

Correct, what I object to is Intel _requiring_ a Reviewed-by before posting.

And while I'm certainly not going to refuse patches that have been reviewed
internally, I _strongly_ prefer reviews be on-list so that they are public and
recorded.  Being able to go back and look at the history and evolution of patches
is valuable, and the discussion itself is often beneficial to non-participants,
e.g. people that are new-ish to KVM and/or aren't familiar with the feature being
enabled can often learn new things and avoid similar pitfalls of their own.

Rather than spend cycles getting through internal review, I would much prefer
developers spend their time writing tests and validating their code before posting.
Obviously there's a risk that foregoing internal review will result in low quality
submissions, but I think the LASS series proves that mandatory reviews doesn't
necessarily help on that front.  On the other hand, writing and running tests
naturally enforces a minimum level of quality.

I am happy to help with changelogs, comments, naming, etc.  E.g. I don't get
frustrated when someone who is new to kernel development or for whom English is
not their first language writes an imperfect changelog.  I get frustrated when
there's seemingly no attempt to justify _why_ a patch/KVM does something, and I
get really grumpy when blatantly buggy code is posted with no tests.
