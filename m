Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980422D6D8B
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 02:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732506AbgLKB3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 20:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbgLKB2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 20:28:37 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B37C0613D3
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 17:27:56 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id n7so6044022pgg.2
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 17:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fWr8U+kXnUtyCph460iKXgFKQR+fNvbC1nN6Nlkztp0=;
        b=ZaNxqRR6SZMZjPpbyKQMlaMsfq4kbnQKu5FGUzfr/tnasU8gwihwQRX9wnLifpdL1p
         ombS0U5LUkJwjZUht05LBHeIGje3niNFnIL7lQ9ZpeXGjEJkeWoKHpT0JMcvXCb83Y1s
         IBzgauqRon7Bu/Qr79VsjCFHfgPkREz+6CVfOlMuaRP0fyyej+ERPszh3Srnv20ExIIO
         DwOeWgCfzHTdNcZ75X/eSpV5dHEz1umHbASijwfWrmqFWulWziTZFCdrsX90Q/FGsCLR
         uF60anQyUXslPTSJEw9Qi0SA1uqzfMFikLSSunQzOoIur44TlNbSdQUpr83/54kDGLk1
         5sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fWr8U+kXnUtyCph460iKXgFKQR+fNvbC1nN6Nlkztp0=;
        b=HNCvrzuMTj1DgdOh0ynT3ZRlYt02m0IENTj5gStsGUrsDj5dYZGzlAkSTtSo1Cbx5a
         wRQdzgH++eYNtOyR0vUe94wbZ24CNnPCtKyM83s+fe/DMJOsp9j4ogSKll0X6eOupazH
         bOR6h196HzYpwUvAPfUlQSATCn6hAXuviNGfO/oBX6D5U/eLeIOiSKckkdTxac3e+wkQ
         iowORSlVd/76hkIqXc1fSMBH9EAaAV8zTYVpe36oHo5wmOl9leQxdZR1n41u+yWSKtaI
         utAy5hunrz+DcU5GSqQoDFENfmbjBMGnjDRX0ECIRN3Qamtumadwkc4q6rZCc5lCJyXL
         HHnA==
X-Gm-Message-State: AOAM53276OIj+WfGnnPk34QaCfsIC95ozsTQXKCp+zG883KrmlC3GZ8T
        M//Ls44tV25TETyod9PshUWi2g==
X-Google-Smtp-Source: ABdhPJx+i1oAVoAOcuGDKv+cJFLCL/wYuUjwbeD1UVOF/7I/dRrQ8oXkRjiFg+ggxQx2FrmlgcuCsA==
X-Received: by 2002:a17:90b:4b02:: with SMTP id lx2mr10823934pjb.49.1607650075946;
        Thu, 10 Dec 2020 17:27:55 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id y19sm7657522pfp.211.2020.12.10.17.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 17:27:55 -0800 (PST)
Date:   Thu, 10 Dec 2020 17:27:48 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Michael Roth <michael.roth@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <X9LLFMN5CNPIikSp@google.com>
References: <20201210174814.1122585-1-michael.roth@amd.com>
 <CALCETrXo+2LjUt_ObxV+6u6719gTVaMR4-KCrgsjQVRe=xPo+g@mail.gmail.com>
 <160763562772.1125101.13951354991725886671@vm0>
 <CALCETrV2-WwV+uz99r2RCJx6OADzwxaLxPUVW22wjHoAAN5cSQ@mail.gmail.com>
 <160764771044.1223913.9946447556531152629@vm0>
 <CALCETrVuCZ5itAN3Ns3D04qR1Z_eJiA9=UvyM95zLE076X=JEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVuCZ5itAN3Ns3D04qR1Z_eJiA9=UvyM95zLE076X=JEA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael, please reply to all so that everyone can read along and so that the
conversation gets recorded in the various mailing list archives.

If you are replying all, then I think something funky is going on with AMD's
mail servers, as I'm not getting your responses (I double checked SPAM), nor are
they showing up on lore.

On Thu, Dec 10, 2020, Andy Lutomirski wrote:
> > On Dec 10, 2020, at 4:48 PM, Michael Roth <michael.roth@amd.com> wrote:
> >
> 
> >> I think there are two reasonable ways to do this:
> >>
> >> 1. VMLOAD before STGI.  This is obviously correct, and it's quite simple.
> >
> > For the testing I ended up putting it immediately after __svm_vcpu_run()
> > since that's where we restored GS base previously. Does that seem okay or did
> > you have another place in mind?
> 
> Looks okay.  If we get an NMI or MCE with the wrong MSR_GS_BASE, then
> we are toast, at least on Zen 2 and earlier.  But that spot has GI ==
> 0, so this won't happen.
