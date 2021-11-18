Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E4A455EEE
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhKRPIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhKRPIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 10:08:53 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7E5C061748
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 07:05:53 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i12so6304162pfd.6
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 07:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PyOJmNDJ7ySHWAlZWuDvzPXAYSo4keDAIOBrs50i1/k=;
        b=NUsf2HrS5831XwAoAYEWfdNDlgJtt1oQ8JEw7BXmMqeko8zqpIGHq9ADQykVhIKKZr
         WcFxxIIWGT9mzf/Frbs7ymOBBtJg17O5w1qEpX3TZTRZeVf6czoscrinY18/Ws4AW8ne
         15emH0q0R6PLtPaxZzQqgYHXWcpQdTsmAfCv4G9lxXvGIauC6EImOPja4QcuZznRYBoc
         Qbsu1RTYjYe46ZNftxehgXcFanI3/W5FM/8Ux1R+uEIdueMbChbEMlksxKyqG2LcovP/
         53QJdyllwj+8D3S+c+oS82qh7XO7Zfd/rR7TCi7zqOZTz5V+RZm5X47X5BtDrDoKsgT2
         aBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PyOJmNDJ7ySHWAlZWuDvzPXAYSo4keDAIOBrs50i1/k=;
        b=E7Ot+4YaGOpBrojzehW5CwE+cLgpl2PKqygf6FB1Z2STyoYo46Ul+sB5gIgSFo4UUW
         byKL1WvG7etCxLRpwQuGL2/ccwIB3nN7TBXpY8LEt9GTW1QL/VkyFzglZb/7szhBNRWc
         fosNyx+o5QuPLEyXjUmD9C8hZ7TL2jZNcBKsdQ5F1nm13QQpWPS1FzpGXJ62wwQxzKzY
         1+IGzT5o46sgxMn9AKGFfp6q32dFfkTQoIYrgXrm9H6kJrqOycZAEoG3sUSjeleEIW7D
         hh9Ft7CeUGjeUznLShKA5LEqhHAmhjEpqyKBs0INPKQEit+gUEMpmIQa9r0xcg2oD3Qm
         XbsQ==
X-Gm-Message-State: AOAM530p4g40VZQRIZp+f2cLg5nMz04wESwt4Fu5PTPWojfj8nrHZXV2
        6B3cJ3FhSROS1IT5r/CdABnNxg==
X-Google-Smtp-Source: ABdhPJzmK2EVdC611FBJPaM8gSJsE6RTnIQXGSA2C54bPEH4r02LgZJE0MX3LoxLvloDVgF2R1FKzA==
X-Received: by 2002:a63:6945:: with SMTP id e66mr11804275pgc.9.1637247953010;
        Thu, 18 Nov 2021 07:05:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p21sm4042831pfh.43.2021.11.18.07.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 07:05:52 -0800 (PST)
Date:   Thu, 18 Nov 2021 15:05:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 4/4] x86/kvm: add boot parameter for setting max
 number of vcpus per guest
Message-ID: <YZZrzSi1rdaP0ETF@google.com>
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-5-jgross@suse.com>
 <YZVsnZ8e7cXls2P2@google.com>
 <b252671e-dbd6-03a3-e8b5-552425ad63d3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b252671e-dbd6-03a3-e8b5-552425ad63d3@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Juergen Gross wrote:
> On 17.11.21 21:57, Sean Christopherson wrote:
> > Rather than makes this a module param, I would prefer to start with the below
> > patch (originally from TDX pre-enabling) and then wire up a way for userspace to
> > _lower_ the max on a per-VM basis, e.g. add a capability.
>
> The main reason for this whole series is a request by a partner
> to enable huge VMs on huge machines (huge meaning thousands of
> vcpus on thousands of physical cpus).
> 
> Making this large number a compile time setting would hurt all
> the users who have more standard requirements by allocating the
> needed resources even on small systems, so I've switched to a boot
> parameter in order to enable those huge numbers only when required.
> 
> With Marc's series to use an xarray for the vcpu pointers only the
> bitmaps for sending IRQs to vcpus are left which need to be sized
> according to the max vcpu limit. Your patch below seems to be fine, but
> doesn't help for that case.

Ah, you want to let userspace define a MAX_VCPUS that goes well beyond the current
limit without negatively impacting existing setups.  My idea of a per-VM capability
still works, it would simply require separating the default max from the absolute
max, which this patch mostly does already, it just neglects to set an absolute max.

Which is a good segue into pointing out that if a module param is added, it needs
to be sanity checked against a KVM-defined max.  The admin may be trusted to some
extent, but there is zero reason to let userspace set max_vcspus to 4 billion.
At that point, it really is just a param vs. capability question.

I like the idea of a capability because there are already two known use cases,
arm64's GIC and x86's TDX, and it could also be used to reduce the kernel's footprint
for use cases that run large numbers of smaller VMs.

The other alternative would be to turn KVM_MAX_VCPUS into a Kconfig knob.  I assume
the partner isn't running a vanilla distro build and could set it as they see fit.
