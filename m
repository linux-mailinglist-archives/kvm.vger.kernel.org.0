Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C98648A155
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 22:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241648AbiAJVAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 16:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiAJVAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 16:00:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACE3C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 13:00:43 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so1975057pjp.0
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 13:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ER4r2cKmD0xhj/NEaU00zT7fJMtGU64Ufp2y1WR4O9s=;
        b=FORaXwLiER5oOkHT7AjW5DKB8Vog6fugEGYuHb0MeCPus97Hznwb4kB+sBID4QctB3
         oLbgTsR7El8dfX3XCAd49O+L0qWU3yZJmtaFFwIjGa1VApRXDxiuWn20kpqBnoEjkOIq
         uruWBDvQFXuj1hm0fngTQabcVxwsl1q8NU/c+bLPMHdIh+jZUw0tiM3ragp3VyGy+OAJ
         rfPtpVAvL/OA5I+VewsXA1iGTpkBZV8tpyAQnIjt+QLitdfE5NRSwwnxKSa0wQquBey6
         O3Mjogr7ikPggJ3O8ap2OIbdWuDYkaJmzBlkGQG8VOWbDHDk99N8mV+bjsxGGBC/90bw
         KmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ER4r2cKmD0xhj/NEaU00zT7fJMtGU64Ufp2y1WR4O9s=;
        b=6NUR/t5C6KXP+5lAmdzU6/Q+DuLpzAjCqn18ijOtCnl/Akl49tlF6H9B1lTkT1vvRI
         V9ZbUcaud7gKDxpuwFuYPWltIvjwMP0iDSYdcVKCHlBj3PFpMYbZ52pKN7kMYixpk+gE
         12o0xWOIUHdtheyPisw5vD85Bi6+wN+XnYQ+HzwP+xClOVHUDqsI77qYSrczq1Qt7g85
         q/8S7K/vQ5Q23kDW7d6EjswdkyKoK2CHWxilYu1iqdIfOivgu+jClwC7/D9KAcr34SC5
         vsl5JknIwcE6ne4j6yK6upEmkr4oj+mgGmCB6bVAn25w4mTYKpbiD8slvtttd7eSf75N
         TUSw==
X-Gm-Message-State: AOAM532l508nmLV2D7VrPilLSs1h8OiR6sTtZKBCrORoV2naXxiTyJyW
        NHOgjwYG4nqPkYujXO/hPTyadrXjqslKJg==
X-Google-Smtp-Source: ABdhPJwqhTe3rEmyL4vZWhmhJYAZ96b4VNGwkVOyHEYgL/yziDzPEbnXbrgVHOvmzr27s3O1hRc5jQ==
X-Received: by 2002:a17:90b:3b92:: with SMTP id pc18mr32563665pjb.137.1641848442496;
        Mon, 10 Jan 2022 13:00:42 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mq12sm10847819pjb.48.2022.01.10.13.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 13:00:42 -0800 (PST)
Date:   Mon, 10 Jan 2022 21:00:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, mst@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/3] KVM: x86: add vCPU ioctl for HLT exits
 disable capability
Message-ID: <YdyediQZQPB7h/kU@google.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
 <20211221090449.15337-4-kechenl@nvidia.com>
 <Ydyda6K8FrFveZX7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ydyda6K8FrFveZX7@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022, Sean Christopherson wrote:
> Does your use case require toggling intercepts?  Or is the configuration static?
> If it's static, then the easiest thing would be to follow the per-VM behavior so
> that there are no suprises.  If toggling is required, then I think the best thing
> would be to add a prep patch to add an override flag to the per-VM ioctl, and then
> share code between the per-VM and per-vCPU paths for modifying the flags (attached
> as patch 0003).

...
 
> If toggling is not required, then I still think it makes sense to add a macro to
> handle propagating the capability args to the arch flags.

Almost forgot.  Can you please add a selftests to verify whatever per-VM and
per-vCPU behavior we end implementing?  Thanks!
