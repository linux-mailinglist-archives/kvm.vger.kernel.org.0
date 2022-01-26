Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C44F49D401
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 22:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiAZVER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 16:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiAZVEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 16:04:15 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAADC06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 13:04:15 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i65so773923pfc.9
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 13:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Acw9Em8xaw/M5Bnl6JsRgrQbuqU6ch2maKM+1hN6N9Q=;
        b=rFgfQCNdPO75brZXQnnhfCHUMnZiyncD47Sg+h8xCEFVu/K/etmKAloTn8skbsRqdf
         /xBbUUoINTQcUU+epR9ZYpUbNwSLwY9FJ2yv+cnuzklt8iAT0UekI5NUw4Vy733+zJBK
         Slx3+xiqjOkgbKKTQKJokBTGHgAjjsWlG54ZgTa8Zv8pbgzpCC1S4CnNQiR+Nen2fgEX
         f5Ces5KcvG8K9ydzksTtDFUlp8YvwOKyzGAThEqUfa64qbxWOCC4/O+gKMssVvAredPt
         H+4lGpFYX3obPA4dCuSSPZEvaOj7S2VPZRvvvqIhiJirqr6FPtzhBS6ZhWamJtuesNyw
         WqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Acw9Em8xaw/M5Bnl6JsRgrQbuqU6ch2maKM+1hN6N9Q=;
        b=4ApeIjnQ1S2omRWonvhrxulgwZ22rcnXJN5QJqkxffVzBXdC+uUFnVEisUn22xiH/9
         JI8EP0dfXolelUJKSF+AOlrW7tV7UtZUeLHTv53Ppq+Q5DmUwq7iVy2Mi/qrM9ruEOXj
         jUfh+5I90YLQDWILZcnNXVWmTWUKL3Z50OoxFwe505NeySLoAXRtz4lxc+Lkt354LeHu
         zfzi3WMinE+ibYiy+SsTw7nBhWNDxvRvxMNbsUbI6kBNs861S2IW+URIQmgBJ4WnVrrw
         bbeOI6W32FhHIaQRTizUIjIxDo4c5dzcbOIQDe1RxeBSRwm3+A7stmrStnDTndcRHJ7l
         1Zlg==
X-Gm-Message-State: AOAM532cHGDoVjCWfeFLCXTP99XqwcOwaDAXhaHHHnB22ZbLhVWtpQaN
        NfiH9XNBlwh6CsUTgcbcswco5Q==
X-Google-Smtp-Source: ABdhPJyWkOlA4unamYjrG/nnRV/yWL2u9ZmOyNXtrFyOjy7mmF95GSe4kiy8/xjHvA+V3HZt2m12sg==
X-Received: by 2002:a05:6a00:888:: with SMTP id q8mr408780pfj.6.1643231054734;
        Wed, 26 Jan 2022 13:04:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l21sm2990121pfu.120.2022.01.26.13.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 13:04:13 -0800 (PST)
Date:   Wed, 26 Jan 2022 21:04:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, agraf@csgraf.de,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v2 1/1] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YfG3Sqng7pn+SnG/@google.com>
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
 <20211220055722.204341-2-shivam.kumar1@nutanix.com>
 <Ydx2EW6U3fpJoJF0@google.com>
 <d610ce6d-3753-405b-80c7-b6c5f261fce2@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d610ce6d-3753-405b-80c7-b6c5f261fce2@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 24, 2022, Shivam Kumar wrote:
> 
> On 10/01/22 11:38 pm, Sean Christopherson wrote:
> > On Mon, Dec 20, 2021, Shivam Kumar wrote:
> > For other architectures, unless the arch maintainers explicitly don't want to
> > support this, I would prefer we enable at least arm64 right away to prevent this
> > from becoming a de facto x86-only feature.  s390 also appears to be easy to support.
> > I almost suggested moving the check to generic code, but then I looked at MIPS
> > and PPC and lost all hope :-/
> > 
> > > +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_FULL;
> > > 
> > > 
> > > --
> > > 
> I am not able to test this on arm64 and s390 as I don't have access to arm64
> and s390 hardware. Looking forward to your suggestions. Thank you!

Posting patches for other architectures that are compile-tested only is ok, just
be sure to note as much in the cover letter (or ignored part of the patch if it's
a single patchy).  I don't think there's anyone that has access to _all_ KVM
ports, though there might be someone that has x86, arm64, and s390.  In other words,
inability to test other architectures is very normal.  The arm64 and s390 maintainers
will need to ack the change in any case.
