Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05016ED630
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 22:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjDXUfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 16:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjDXUfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 16:35:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C35D59D5
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 13:35:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b92309d84c1so23344016276.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 13:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682368537; x=1684960537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l0MSB0945IeDbGQp04rwPUWUysYiVEFGxMNvNn3R9Dk=;
        b=qaA5kj5BLRufFr7HOEwoBj3xuBzT1MM3EqwX810KDK1PJXDmUfYJ4nLm6oNBrqzq5D
         kejv9Yn+BLxpQduLI7gZUWw5gg/LBJYf3iyGlCxVa9XwjUZ25tQcKo5XQXlK34L7VDCT
         e8a1tXQmghUZAYQ9+o8GJvHhq+yTaQ4YM0XuenE3DXhhq66Er3TLgg2gNW3i+21vEsNN
         Y7V8kMT8/uufww59U8/Jw4hwCThUoOVjtCfYbwbJT0IT92HGuHwvl5gdbMD9oZslPNIp
         hcbYSB3xiE3IY0nL4OfpglITPYjFC/j3293vJZ8dlb/JEUjXuPa3xYxVo+u2J/DS9N39
         lCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682368537; x=1684960537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l0MSB0945IeDbGQp04rwPUWUysYiVEFGxMNvNn3R9Dk=;
        b=AQ68mMp9QVIuvYWAnxIA4QZ6vcnZSLCOA1HO4/i/+QV76bCVoonWwFR7oLQfJ6j4mM
         eCUBkgyF71FkfHumE5r0Pse/SCy8tfRMCJr52AFz18I8JRTNsTnFtVRi23tOiZq7Uwv3
         rbPW0NiN3Kebuq3WyBOVmwuKz1JA5GvuMaYAmfv+jYTV2Tn4aorTzCCcDI6KBrHtFsLp
         q5rzmwZmWcbPGk6NHcown/bwDADFEQEtBcqkL1LNQN0yY/82tfk/DL6q8Hfa+5ICLcyK
         tBoLYSRGirwEbaN5L/CLOnvmKDqJ1CWr/tJAnsbxTqglNoxujZhBe2hwfrbK8HQ68RlW
         5g7Q==
X-Gm-Message-State: AAQBX9cbgvDKvXqDa88gfIi9CC6HIJR1UK2lnIMZlP4UzqeazCA22Mal
        YIlTz9Bd76P5WzO5FDLj+i9eGNtXKz0=
X-Google-Smtp-Source: AKy350alWB2/sn7vnmKB09ekH2Ungj1lC+xvK8PVtElvPqniaZwd+kmU7CpSimCq0rTDwuANLLp2/iz809o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2b88:b0:54c:15ad:11e4 with SMTP id
 en8-20020a05690c2b8800b0054c15ad11e4mr8066797ywb.0.1682368537764; Mon, 24 Apr
 2023 13:35:37 -0700 (PDT)
Date:   Mon, 24 Apr 2023 13:35:36 -0700
In-Reply-To: <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com> <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
Message-ID: <ZEboGH28IVKPZ2vo@google.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Sean Christopherson <seanjc@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Anish Moorthy <amoorthy@google.com>, Peter Xu <peterx@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023, Nadav Amit wrote:
> 
> > On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> wrote:
> > Sean did mention that he wanted KVM_CAP_MEMORY_FAULT_INFO in general,
> > so I'm guessing (some version of) that will (eventually :) be merged
> > in any case.
> 
> It certainly not my call. But if you ask me, introducing a solution for
> a concrete use-case that requires API changes/enhancements is not
> guaranteed to be the best solution. It may be better first to fully
> understand the existing overheads and agree that there is no alternative
> cleaner and more general solution with similar performance.

KVM already returns -EFAULT for these situations, the change I really want to land
is to have KVM report detailed information about why the -EFAULT occurred.  I'll be
happy to carry the code in KVM even if userspace never does anything beyond dumping
the extra information on failures.

> Considering the mess that KVM async-PF introduced, I would be very careful
> before introducing such API changes. I did not look too much on the details,
> but some things anyhow look slightly strange (which might be since I am
> out-of-touch with KVM). For instance, returning -EFAULT on from KVM_RUN? I
> would have assumed -EAGAIN would be more appropriate since the invocation did
> succeed.

Yeah, returning -EFAULT is somewhat odd, but as above, that's pre-existing
behavior that's been around for many years.
