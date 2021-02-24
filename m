Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6458F3242C8
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 18:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhBXQ7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 11:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbhBXQ7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 11:59:18 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A28C061786
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 08:58:38 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e9so1565212plh.3
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 08:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VZ8hDIsebAJtpkdsWq0Ncs/LoZE4TgngyErMbP2wux4=;
        b=AJFeiAeOxt5enEH/SbChIUSGWKDmlV3O6D/Q6SDmzqamQTNgQ2CcEryVke+mnGcGjs
         nXnC4mDw/C/0kL74iMmpR8Y7Do3IF5Oy248Kc7J73HkuISucq40xKocn/4pLzEiMZT3n
         SBc0q+vDTJKKj5i9nu05qbDJ4DGk1t4ZJopzy+2j7EYbJ/UFvoiBOb5gHwqEs/rjuIYN
         ZQ3uFnkVNX4iTpJ/7+w1cGLDxTYHfi+a1yIKwcOCBEBbASuiApSZo8rDJd2CwxXOCpD4
         Ar+J36nQUwsZ1/Tio30o2roLr9dBqcQnl/Otn/1PWDw2ioZD0aSY5xZv7fWZ7RW8tD8F
         U08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VZ8hDIsebAJtpkdsWq0Ncs/LoZE4TgngyErMbP2wux4=;
        b=tSJ36tKIMeOxAn2mWFRxYCastXxtJ35Q7RkoJiDt3nbTDJmYpXGpSFWXDE3KJeKjze
         w+FO/kz1YJDf9A+xXchXAKvP5aZaXN6rWIXehqJL2AC7AnYB6UUpX6IsSOWNF+81ieSl
         s7/+D4XJomSXeZqpcAJ99T1Iw6aQb359ojhcaOnmXFaGmU5+luCd2TDK+50LcmE3zFd+
         SEnlc+lM4bWGGEPjoLV/fqWSwMSbQTT2dxNln2ph9Ml2p4/6zSqGSfWGfbjfnUoV2+tn
         498cuF0q07U2Q/RHKtqBKrCSun0cn/8ZZ21rudeoMx0+MvdEwjX3gk95Ni3y/phRi1Hm
         M10w==
X-Gm-Message-State: AOAM531qVIy+qLaEcwy8UFCb5/g3ZQGLCYHaayTXwrpHmcdE2gIuq59C
        7RcCSyVRuKb8c8kpQW30SHQc4w==
X-Google-Smtp-Source: ABdhPJxIQ9BUuRnnxN6f7J64+/5yVcBvCFTS5YeZJPajgqrOmYZy7dnxwt2OmxE99iMRdGvBxg9eBg==
X-Received: by 2002:a17:90a:e016:: with SMTP id u22mr5517771pjy.155.1614185917838;
        Wed, 24 Feb 2021 08:58:37 -0800 (PST)
Received: from google.com ([2620:15c:f:10:385f:4012:d20f:26b5])
        by smtp.gmail.com with ESMTPSA id c10sm3468728pfj.28.2021.02.24.08.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 08:58:37 -0800 (PST)
Date:   Wed, 24 Feb 2021 08:58:29 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nathan Tempelman <natet@google.com>, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com, brijesh.singh@amd.com,
        Ashish.Kalra@amd.com, Nathaniel McCallum <npmccallum@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <YDaFtRUAZ+P6Nrpy@google.com>
References: <20210224085915.28751-1-natet@google.com>
 <04b37d71-c887-660b-5046-17dec4bb4115@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04b37d71-c887-660b-5046-17dec4bb4115@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Marc and Wooky

On Wed, Feb 24, 2021, Paolo Bonzini wrote:
> [CCing Nathaniel McCallum]

Ah, I assume Enarx can use this to share an asid across multiple workloads?
 
> On 24/02/21 09:59, Nathan Tempelman wrote:
> > 
> > +7.23 KVM_CAP_VM_COPY_ENC_CONTEXT_TO
> > +-----------------------------------
> > +
> > +Architectures: x86 SEV enabled
> > +Type: system
> 
> vm ioctl, not system (/dev/kvm).  But, see below.
> 
> > +Parameters: args[0] is the fd of the kvm to mirror encryption context to
> > +Returns: 0 on success; ENOTTY on error
> > +
> > +This capability enables userspace to copy encryption context from a primary
> > +vm to the vm indicated by the fd.
> > +
> > +This is intended to support in-guest workloads scheduled by the host. This
> > +allows the in-guest workload to maintain its own NPTs and keeps the two vms
> > +from accidentally clobbering each other with interrupts and the like (separate
> > +APIC/MSRs/etc).
> 
> From purely an API design standpoint, I think I'd prefer a "set context
> from" API (the other way round) to match the existing KVM_SEV_INIT.
> 
> Apart from this, the code is very nice and I would have no issues merging
> this in 5.12 even after the merge window.

And I don't think it would prevent us from refcounting the asid itself in the
future, e.g. to avoid pinning the "parent" KVM, which was my biggest hesitation
with the approach.

That being said, is there a strong need to get this into 5.12?  AIUI, this hasn't
had any meaningful testing, selftests/kvm-unit-tests or otherwise.  Pushing out
to 5.13 might give us a good chance of getting some real testing before merging,
depending on the readiness of SEV testing support.

> As an aside, do you happen to have SEV selftests at Google?  I would gladly
> volunteer to write the selftest myself for this ioctl given the
> infrastructure.

No, but I believe someone(s) from AMD is working on selftests.

On a related topic, Marc and Wooky are working on adapting kvm-unit-tests to run
SEV guests.  IIUC, the last open before posting an RFC is how best to make
kvm-unit-tests play nice with UEFI.
