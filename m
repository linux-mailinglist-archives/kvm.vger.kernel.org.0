Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0174C77F3
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbiB1Sg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 13:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240013AbiB1Sf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 13:35:59 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833195A5BC
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 10:22:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v4so11888617pjh.2
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 10:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TC5WiqkCFLoU1QGEplbU3eysjvNMWhtnfYkOJt02MA0=;
        b=hMyspOKgZOh/Ufrmm9tci+z0S3zoYzYJyKJs3Yrm/tObCNp2dmB65rLxOXe9aPh1Nl
         TxQlxZ3HRWOzXIgcI3dGfGwws61Byy9QnPvazR8xBTQQAb22NgcwaQBiiVyxoAsDvPUT
         Hp4t/lwg90D3L7RHNHhSOZaeq6MfofdVweExrIE7dmcUDBXKQmzHAzqGUbeFaSgKNYxu
         vj5F1WPG55/ARqoHwrAygNBTjU0j/zVlct+wBYprKjYpksaqFNL+tQNBhqee0mjmXv/x
         WD5Ce9lYABYJCGF/xJSwX89018HlV5Sze8lUjXf0es55t33mlYXSLSc91lrIUaxkSaeA
         07KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TC5WiqkCFLoU1QGEplbU3eysjvNMWhtnfYkOJt02MA0=;
        b=ScyksTv2mEeh7/V8xJkQYRg96LKO47L1oqX2dFSxCDZ/fZDFujKY6HY75/c95G77u3
         aS/RHjkuVLOdG4ji665Z0jHkUS24bTN75GvyiNvI9yzDkHcJJNPaMar6MF8s4dQi566/
         NLcWy38ahKKFjuxW53CtBhCV7PAHBA4CCfj+LNscr3u7MwGOM/z5mqxiFeRmK6K9Q6Hz
         Y3YiQ0ioYOMsOKkCWDcfGRqyxlbqM+6JKi1ho3VBuFRJc8XHRWODM702lk8MvxWTBKEr
         jqjZMo4BHhp2JnX2JvMDaLKWkTYR0FRN+jq9hmRpqB2di2N5NoZ7HaHl2fdk0fHOmAbH
         vFdw==
X-Gm-Message-State: AOAM532azgPFEOQgiMkRS6xVY4L6M4GJUsZSChqdeGdyG1WeUbsOVnNi
        SPfKw6PTxfJF9RWljr3+tpzvyA==
X-Google-Smtp-Source: ABdhPJx1nHQEYQvyyVeIo2yav8iqso20LjHTShkH2kF7xoF4ELYazZWCS9V9a6aPcVNJyyLuc955CQ==
X-Received: by 2002:a17:90a:6508:b0:1be:d59c:1f10 with SMTP id i8-20020a17090a650800b001bed59c1f10mr425313pjj.229.1646072526877;
        Mon, 28 Feb 2022 10:22:06 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y12-20020a62640c000000b004f104f0ee75sm13263991pfb.185.2022.02.28.10.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 10:22:06 -0800 (PST)
Date:   Mon, 28 Feb 2022 18:22:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH] KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2
Message-ID: <Yh0SyrFvu6UBwsj3@google.com>
References: <20220226002124.2747985-1-oupton@google.com>
 <Yhz5dRH/7gF45Zee@google.com>
 <Yh0NyuuzIymt9mgt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh0NyuuzIymt9mgt@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022, Oliver Upton wrote:
> On Mon, Feb 28, 2022 at 04:33:57PM +0000, Sean Christopherson wrote:
> > On Sat, Feb 26, 2022, Oliver Upton wrote:
> > > KVM_CAP_DISABLE_QUIRKS is irrevocably broken. The capability does not
> > > advertise the set of quirks which may be disabled to userspace, so it is
> > > impossible to predict the behavior of KVM. Worse yet,
> > > KVM_CAP_DISABLE_QUIRKS will tolerate any value for cap->args[0], meaning
> > > it fails to reject attempts to set invalid quirk bits.
> > 
> > FWIW, we do have a way out without adding another capability.  The 'flags' field
> > is enforced for all capabilities, we could use a bit there to add "v2" functionality.
> > Userspace can assume KVM_QUIRK_ENFORCE_QUIRKS is allowed if the return from probing
> > the capability is >1.
> > 
> > It's gross and forced, just an idea if we want to avoid yet another cap.
> 
> I had considered this before sending out v1, but was concerned if a
> userspace didn't correctly handle a return value >1 from
> KVM_CHECK_EXTENSION.

Ah, right, userspace could theoretically check "== 1".  Blech.

> Turns out, I can't even find any evidence of the KVM_CAP_DISABLE_QUIRKS used
> by userspace. I spot checked QEMU, kvmtool,
> and a couple of the rusty ones.
> 
> The only other thing that comes to mind is it's a bit gross for userspace
> to do a graceful fallback if KVM_QUIRK_ENFORCE_QUIRKS isn't valid, since
> most userspace would just error out on -EINVAL. At least with a new cap
> userspace could follow a somewhat standardized way to discover if the
> kernel supports enforced quirks.

Yeah, a QUIRKS2 is probably easier for everyone.
