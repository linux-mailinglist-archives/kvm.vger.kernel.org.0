Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E9E4D0DCD
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 03:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244741AbiCHCEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 21:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbiCHCEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 21:04:51 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C6437AB2
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 18:03:55 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id t5so16052825pfg.4
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 18:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zPzE/KfxbqfCkt+sqJq4FYPy7nIua70yVKy4tSIv5RA=;
        b=VwTw70sJKoLQiysdLPX6D/SefpFSl81t2xvKLz2JnVk36UTyxEl5w9/YGj7WWqSmkY
         MAej2K+cZwfZGKdyRuU00RuqRFS36roucvKoFEEPiErMtBRcvM2FfumcB/DIyYdl/ST5
         hIIM2MIjKXmhrt1rDRXTKheQtHHk1kXMQn4+3Src+BzTTa47Dh5Lr6lCgoIBgjm85IDk
         2gfDrNbvHZ9+NrJVQ7IeAyS1zlA4lO/FiCAZUv1v+hSBWUaUvI8DkHOWCiLM1k+u2NiW
         8k7r8UkOpplGn27bT12UbxpgH+VvUjdUjMPnC9HYpz+zWUdDrIUJDAY6sSzpTGaOKehV
         ZubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zPzE/KfxbqfCkt+sqJq4FYPy7nIua70yVKy4tSIv5RA=;
        b=opp9lDf7Yuv+eE9Jt6inRfYID9zR+e6Pba2XzCY/4nGWuYKCPZgf5UBl+b6D3u0Mcv
         0U/NKv+IfGgvTumsJUx3/P6zSlzvK65f778swM8YFfdQ4nTqn1TjiKjyB1FZOm12HRG/
         8XR/lkwYRUizJn43VFnhw7iCOuqm10jlgRG2d/CLkVUsfh1Y+nN17nrWuXZV0RnxrvWE
         V8YkuJzxJ9Aa63/BNRFmUt30AydjXzmIFzdhs/PNmTPE7kJZkGBJ2gj8rLBOFbJgjVwC
         /9RsZNqP5tWfC4hdo5iGChrDYPna6DpKIPapbhwh5MiisJwRgAGF00AxOt7XgW5HLzzH
         X8gg==
X-Gm-Message-State: AOAM533v9NUxNyHupd9FE+1WrvZ5wHPZEdUe7iVHR0PzWMAHQuSzW1rn
        mcgs38iR1IbCfOutZa3cY6fYUg==
X-Google-Smtp-Source: ABdhPJySyxMD46AZLFdfyu+2YVLdLlsgsst7NXg+2/aGLlTxFGSpNWOI/il55Lz0Dbvf78yMXeM+kg==
X-Received: by 2002:a05:6a02:18b:b0:362:c8e4:d8f4 with SMTP id bj11-20020a056a02018b00b00362c8e4d8f4mr12427851pgb.86.1646705035060;
        Mon, 07 Mar 2022 18:03:55 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i192-20020a636dc9000000b0037c7149fb0asm11654410pgc.89.2022.03.07.18.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 18:03:54 -0800 (PST)
Date:   Tue, 8 Mar 2022 02:03:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: Improve virtual machine startup performance
Message-ID: <Yia5hsoq2ZZJM8gx@google.com>
References: <20220301063756.16817-1-flyingpeng@tencent.com>
 <Yh5d7XBD9D4FhEe3@google.com>
 <CAPm50a+p2pSjExDwPmGpZ_aTuxs=x6RZ4-AAD19RDQx2o-=NCw@mail.gmail.com>
 <YiAZ3wTICeLTVnJz@google.com>
 <CAPm50aLJ51mm9JVpTMQCkNENX_9-Do5UeH5zxu-5byOcOFsJBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPm50aLJ51mm9JVpTMQCkNENX_9-Do5UeH5zxu-5byOcOFsJBg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Hao Peng wrote:
> On Thu, Mar 3, 2022 at 9:29 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Mar 02, 2022, Hao Peng wrote:
> > > Thanks for pointing this out. However, other than shadow_root_level,
> > > other fields of context will not
> > > change during the entire operation, such as
> > > page_fault/sync_page/direct_map and so on under
> > > the condition of tdp_mmu.
> > > Is this patch still viable after careful confirmation of the fields
> > > that won't be modified?
> >
> > No, passing around the "init" flag is a hack.
> >
> > But, we can achieve what you want simply by initializing the constant data once
> > per vCPU.  There's a _lot_ of state that is constant for a given MMU now that KVM
> > uses separate MMUs for L1 vs. L2 when TDP is enabled.  I should get patches posted
> > tomorrow, just need to test (famous last words).

Famous last words indeed.  Long story short, the patches were mostly easy, but I
wandered deep into a rabbit hole when trying to make ->inject_page_fault() constant
per MMU.  I'll get something posted this week, though exactly what that something is
remains to be seen :-)
