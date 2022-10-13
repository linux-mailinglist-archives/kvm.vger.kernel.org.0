Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54B75FE345
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 22:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiJMU2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 16:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJMU2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 16:28:52 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02DD11A
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 13:28:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so2882764pjl.3
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 13:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pjZYLcZ7x2MFwKv23wly1cpFhKT4QSKKNRPHHFiWhRY=;
        b=PnUyqFqiYlwwvrikyVK75hFrpWDD+Kjb1bsfhRy8d5QvhnJJjfycUvWmOe5Z2Q4xCB
         grZwO0xR553yhiOn4Nau6ISXEun4m8K7POV3p/idGxhntoTA1VF9hr2Nnhtqs1Wc2h2V
         /qwgyJjTLGx5rI8a1BD1HthflyP0nEhbMAWwPVI9j2w0Q4k6K8l19hxSb+GAdLCNLpQ1
         qXrqI9sYzAG+42Fd/Ucp8JZlDi1gSJ2GvmiF07WHCJ/nlKlbVbaQl5gdRu5T1WmfR8tV
         TpZ1MYlqZoLIdgIRt/x0HJNtEnE/bxDSPwfAMEBrUDkkU1a3GljC/dSfj/Xt9fQUK4Wj
         rxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjZYLcZ7x2MFwKv23wly1cpFhKT4QSKKNRPHHFiWhRY=;
        b=ogSYSYW1FXnN7yd2ubL8oiMreK3jAyfjVN+birDG59QXlXmv5SrXEaCY/973XdA2Yh
         EGvI9hTgWGIxM5pyd6tUEWfDgbsNyv1Ey/vh7NxxvjQVM9lrGSaEPo+b+YR/E6tPPXCc
         t92XfDU+meb9PfmI4E71vO1DomFon4j2s8lA2db/xNIMNZJ86UH9GBABbM184ZE3ratj
         wCzJ4krfVWsQxLE93AHVyg7dary8MOu/OdTBlpbzl8aNRMjrZiGnJim9m5okTpwZAtfP
         mpo7pptpH+f1FN82ZBoPx03M7P005kk01w9/zMVOaj0A80VoDg3uEba6YbkBUd2Li6M+
         5K6w==
X-Gm-Message-State: ACrzQf3Gf6/DipaTC/syV10vs+k1eMY6KdRynYLsExNxbviwR1p/roMk
        k2fCxUrDklGZC+EdxjVuUwBO+mCO01qvZg==
X-Google-Smtp-Source: AMsMyM5RUJQQ5Kgj07zf1DDaNRfnVzXYdidRkcqnPUhAqFfmVi05BE5dyJnpxyOxf1w8xc/RFdboxA==
X-Received: by 2002:a17:902:d48d:b0:183:1d43:fd34 with SMTP id c13-20020a170902d48d00b001831d43fd34mr1764191plg.46.1665692931353;
        Thu, 13 Oct 2022 13:28:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090a64c600b001f8c532b93dsm181597pjm.15.2022.10.13.13.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 13:28:50 -0700 (PDT)
Date:   Thu, 13 Oct 2022 20:28:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 8/8] KVM: x86: Fix NULL pointer dereference in
 kvm_xen_set_evtchn_fast()
Message-ID: <Y0h0/x3Fvn17zVt6@google.com>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
 <20220921020140.3240092-9-mhal@rbox.co>
 <Y0SquPNxS5AOGcDP@google.com>
 <Y0daPIFwmosxV/NO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0daPIFwmosxV/NO@google.com>
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

On Thu, Oct 13, 2022, Sean Christopherson wrote:
> On Mon, Oct 10, 2022, Sean Christopherson wrote:
> > On Wed, Sep 21, 2022, Michal Luczaj wrote:
> > If this fixes things on your end (I'll properly test tomorrow too), I'll post a
> > v2 of the entire series.  There are some cleanups that can be done on top, e.g.
> > I think we should drop kvm_gpc_unmap() entirely until there's actually a user,
> > because it's not at all obvious that it's (a) necessary and (b) has desirable
> > behavior.
> 
> Sorry for the delay, I initially missed that you included a selftest for the race
> in the original RFC.  The kernel is no longer exploding, but the test is intermittently
> soft hanging waiting for the "IRQ".  I'll debug and hopefully post tomorrow.

Ended up being a test bug (technically).  KVM drops the timer IRQ if the shared
info page is invalid.  As annoying as that is, there's isn't really a better
option, and invalidating a shared page while vCPUs are running really is a VMM
bug.

To fix, I added an intermediate stage in the test that re-arms the timer if the
IRQ doesn't arrive in a reasonable amount of time.

Patches incoming...
