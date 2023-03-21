Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6ADC6C266D
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 01:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCUAlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 20:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCUAlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 20:41:23 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE4F28E57
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 17:41:21 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a6-20020aa795a6000000b006262c174d64so4791004pfk.7
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 17:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679359281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wTEJZYqVcEI158soxBsu1HEyyaSjObXbyKvoS5ne1Do=;
        b=qjQrzEd+MBrCThMrna7wKHMVTZdK0O5nPeQIBdN0L47pVMMOEQguqcX1CC/Cj3itFL
         naWKtf45A7FoAmiY/TDvlDQYay60v/RLgHOKvw+nHpOMzF5OPInPCkmsXao2ul23bkje
         zB3+S/k6jSBjITZKdqxT8GKZxTyQfbt0R/IlbX/+eR3VzW/Uxppck0NDsXgAEXqupiOd
         EUcQDb/pAnY+QpT6Qy8DY1gzIEBm1u5jLnR8DmgexAbHeJ2XLeny9WZfsu9oVz0yUKvW
         JARrzyx7hQ9aEV1sxgi0Gzen5khelbW1zLcS+O+mAIv1d36hYxel9JiN6pUC1Fd10oKv
         bBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679359281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wTEJZYqVcEI158soxBsu1HEyyaSjObXbyKvoS5ne1Do=;
        b=dXOr9R5hToOWUJw6vHkdXQCpYELpVhdTc6qeFsMgq0hEC7vx2V5h4YHon1dyBMTj2/
         DvE1Ct5l3qGeQ31H0RXIFeSpb3LO6bAA5rkDEYODrOg4xFvISA9ZVdZ0lnBrF+hfEAv6
         V7UQlbMSOMLGWqBaE5Xt0du+45ZicpPwRKC9wVT1uHnZnSwW/Gblhr88xeBuNRM3Y/Oa
         dcA9tmWqFktDYCk1CV5KA8LRIVMk3nbHD+0D5/mOlo22tJzsRkYLNBd1NnHuycOaF0vd
         rFjWeyOW8jLqL7Z0ONERyZldssRKTtylpBpQWCUZIE6k9mMvCXciwlXX9+A1GkqhyYGy
         M9pQ==
X-Gm-Message-State: AO0yUKUvLKkFGTE6mPPMT4NsM6Usge6nm79DTRC02t7AHtyS3wrIYdhw
        OB+BGTLUmHZFElH1XHzzL9GtCmgDISA=
X-Google-Smtp-Source: AK7set/qvfW/maVa7x7G6D/ZiSU+cDNSgl/APwOLYbHLQAW+sG3U8TwQgGA4gFDbDs9QEZO0OtzCsyXjRZU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5242:0:b0:503:a269:33b7 with SMTP id
 q2-20020a655242000000b00503a26933b7mr143442pgp.8.1679359280978; Mon, 20 Mar
 2023 17:41:20 -0700 (PDT)
Date:   Mon, 20 Mar 2023 17:41:19 -0700
In-Reply-To: <ZBTwX5790zwl5721@google.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com> <ZBTwX5790zwl5721@google.com>
Message-ID: <ZBj9L2VUjEbWbgcS@google.com>
Subject: Re: [Patch v3 0/7] Optimize clear dirty log
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023, Sean Christopherson wrote:
> On Fri, Feb 10, 2023, Vipin Sharma wrote:
> > This patch series has optimized control flow of clearing dirty log and
> > improved its performance by ~40% (2% more than v2).
> > 
> > It also got rid of many variants of the handle_changed_spte family of
> > functions and converged logic to one handle_changed_spte() function. It
> > also remove tdp_mmu_set_spte_no_[acc_track|dirty_log] and various
> > booleans for controlling them.
> >
> > v3:
> > - Tried to do better job at writing commit messages.
> 
> LOL, that's the spirit!
> 
> Did a cursory glance, looks good.  I'll do a more thorough pass next week and get
> it queued up if all goes well.  No need for a v4 at this point, I'll fixup David's
> various nits when applying.

Ooof, that ended up being painful.  In hindsight, I should have asked for a v4,
but damage done, and it's my fault for throwing you a big blob of code in the
first place.

I ended up splitting the "interesting" patches into three each:

  1. Switch to the atomic-AND
  2. Drop the access-tracking / dirty-logging (as appropriate)
  3. Drop the call to __handle_changed_spte()

because logically they are three different things (although obviously related).

I have pushed the result to kvm-x86/mmu, but haven't merged to kvm-x86/next or
sent thanks because it's not yet tested.  I'll do testing tomorrow, but if you
can take a look in the meantime to make sure I didn't do something completely
boneheaded, it'd be much appreciated.
