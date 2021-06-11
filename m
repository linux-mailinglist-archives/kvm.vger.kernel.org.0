Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065783A43FB
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhFKOY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhFKOY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 10:24:28 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F60C061574
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 07:22:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b12so2906081plg.11
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 07:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V9LKi/CMslAloLgYPHzBrk4CvXkpDoxlbZy7HuBfzEg=;
        b=pkuhK9c5qSAPBGSLwWk+Hr741IHbVI+7ULYa8ELKHZ9nn1cTQ6T14xvPtMYI/uzrHL
         dEEsxctFTc3CytAFHWrgjn6SOm0MdhQX7VttOigsxfg7qOFY8MpCfb1+tmGoSLp3QLCt
         srmysUEWlnM9mps9qIznOnBE64amJQCW4wclfuDOO8g9t3eZiKZtHuD/Gx+Of9YOT/aV
         JReidt4565mUOCKXsYv4PrwvNQo2y3dP5ZcacRrohyrBQxzFyNef0SxPDkbh71ul1iqy
         wcEDRq2UsehWCXA8G8j7opMEgckgvuKcCcGrub9FoyPzTbChe+DWPMm3XYVG0UrmuDHg
         1s/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V9LKi/CMslAloLgYPHzBrk4CvXkpDoxlbZy7HuBfzEg=;
        b=bpo+7mHO8UAyoxn//tY29WuzNFbCLMYmBlXwzMuYwD1YKD17xo938NFBkj8O/fA2/R
         6sV5ITZGVt/ycW4B+JoTAb/YmraYAppi1UMhzlwGgn6RYQEknpcd5l9xosXmUCAydpm8
         v5ZagstO806sCiZt7yYZYH0B8fiuRk7/GfAdcyOxxAg1sb1IFdZhW5BUNoqA0tWDx5KA
         jxULCGmtSN/wNcWpt4oTs9db9XvbKeCHsdEBamFkQmOHEt3ratq38H8HeX6iAQ7/aNw6
         kVoNQPpbEINqS8RxxD4BCvfYIBB5xZJNg+2kOp9GENM/Gqs5DYEccwBR7FGSfZMSLMmQ
         Juug==
X-Gm-Message-State: AOAM532QZDePn0YiDloH4BfzT47DF+DeB68xpMAlIRaTbFg0UNl/ejnc
        4/tHOSG6MlRNCHh67qpVH6AAiQ==
X-Google-Smtp-Source: ABdhPJwHHxZK3iZe6LilvAzAWn3mvPXw4rKGFSgD6Uq9obg5LrUMj5tKJ1/m5mkA2ZQuEk0lLjoV5w==
X-Received: by 2002:a17:90b:38ca:: with SMTP id nn10mr4926433pjb.127.1623421333642;
        Fri, 11 Jun 2021 07:22:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j12sm5659788pgs.83.2021.06.11.07.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 07:22:12 -0700 (PDT)
Date:   Fri, 11 Jun 2021 14:22:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Calculate and check "full" mmu_role for
 nested MMU
Message-ID: <YMNxkRq5IIv+RWLN@google.com>
References: <20210610220026.1364486-1-seanjc@google.com>
 <87bl8cye1k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bl8cye1k.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021, Vitaly Kuznetsov wrote:
> What I don't quite like (besides the fact that this 'nested_mmu' exists
> but I don't see an elegant way to get rid of it) is the fact that we now
> have the same logic to compute 'level' both in
> kvm_calc_nested_mmu_role() and init_kvm_nested_mmu(). We could've
> avoided that by re-aranging code in init_kvm_nested_mmu() I
> guess. Something like (untested):

Yep, cleaning all that up is on my todo list, but there are some hurdles to
clear first.

My thought is to either (a) initialize the context from the role, or (b) drop the
duplicate context information altogether.  For (a), the NX bit is calculated
incorrectly in the role stuff, e.g. if paging is disabled then NX is effectively 0,
and I need that fix for the vCPU RESET/INIT series.  It's benign for the role,
but not for the context.  And (b) will require auditing for all flavors of MMUs;
I wouldn't be the least bit surprised to discover there's a corner case (or just
a regular case) that I'm overlooking.
