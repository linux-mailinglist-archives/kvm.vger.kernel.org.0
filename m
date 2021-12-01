Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C6F46567F
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 20:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239741AbhLATfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 14:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbhLATfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 14:35:44 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30C5C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 11:32:22 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z6so25562345pfe.7
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 11:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CZWjS73ddwqy1irW9SF57Z1/5+llpSsF/UlHdpLsf20=;
        b=WwZ+uZal5LDSsVbb8ggDuyptB5vW613ix+E43x1vM8/MNv5RvFx3Htru6Jk08HPdr9
         sFytDMsZIeJ4INkdxZK4lCDgEw5TsxrS4hCrWy+E4Omz0b+3kYmft/mrCOTvF1w52fZ4
         zZq70NTZlSSQ0HJU6HEuB0N8HGNMhZtQS3XBIAwgf67jn48pYuc/7y2ArEsdp6B2u5hZ
         UPpKiZW/hyb5fF3ZClfJFymNFQx65UfUYfJhSd0KSvpQk9gH8oTmlmCaq4/8wAX7Z3kW
         owDEfZ0yhQiu0G7jniuk4JF7OK0B28kfzXM86z8IETzqAINVKMUZWqywQrC5Vw3a5Nji
         pArw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CZWjS73ddwqy1irW9SF57Z1/5+llpSsF/UlHdpLsf20=;
        b=77jUIs6vDpElvZFwWTp1oy/iKqKUtzC8Ns7C9gC8fs6FF3KRb5s98xWOPrMUxsAvuv
         xtKFDukBnYIiwiluuIRuLDo/XJc2XTg5hWr6ylcZ+MNUKWkgOvgEzn3z0o7tsLXKz/4E
         hF5nLtk3X3FaPDj+s3MpqvYMuJwEyxbNinwwbUFe35HDjS/IS0hy069ZLCcajOG9SH58
         P0hRz6aEY3RZ8g0AYGuWM4q9pC144EM7m7xgsasLlwv0WlTkalCQ6H5bpL34E6dJ9j2H
         uQnDm3v8NV1sdN3f/vS84G8TsbALW7Dd1+9oaBKTMsvyiF7ajBEuwKru7O7bjcOzgM3i
         lXeQ==
X-Gm-Message-State: AOAM533Scqf4t46/69Hx2dfi+C7ySBdrgaMhfFVTIyc/S2dOYVbV8s16
        lHmezTRsZcjwZJqTRPH1zSqNkg==
X-Google-Smtp-Source: ABdhPJw/cQM94bmIq3e1bnf5ez0hbCDPrBfwYK8LB/d0cYiit7zFSsLheZVrRaVltfAEG650aNE5Bg==
X-Received: by 2002:a62:5a02:0:b0:4a2:a6ee:4d8e with SMTP id o2-20020a625a02000000b004a2a6ee4d8emr7996251pfb.47.1638387142244;
        Wed, 01 Dec 2021 11:32:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j1sm573948pfe.158.2021.12.01.11.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 11:32:21 -0800 (PST)
Date:   Wed, 1 Dec 2021 19:32:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/59] KVM: X86: TDX support
Message-ID: <YafNwoPumWQ/77Q6@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <YaZyyNMY80uVi5YA@google.com>
 <20211202022227.acc0b613e6c483be4736c196@intel.com>
 <20211201190856.GA1166703@private.email.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201190856.GA1166703@private.email.ne.jp>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021, Isaku Yamahata wrote:
> On Thu, Dec 02, 2021 at 02:22:27AM +1300,
> Kai Huang <kai.huang@intel.com> wrote:
> 
> > On Tue, 30 Nov 2021 18:51:52 +0000 Sean Christopherson wrote:
> > > On Wed, Nov 24, 2021, isaku.yamahata@intel.com wrote:
> > > > - drop load/initialization of TDX module
> > > 
> > > So what's the plan for loading and initializing TDX modules?
> > 
> > Although I don't quite understand what does Isaku mean here (I thought
> > loading/initializing TDX module was never part of TDX KVM series), for this part
> > we are working internally to improve the quality and finalize the code, but
> > currently I don't have ETA of being able to send patches out, but we are trying
> > to send out asap.  Sorry this is what I can say for now : (
> 
> v1/v2 has it.

No, v1 had support for the old architecture where SEAMLDR was a single ACM, it
did not support the new split persistent/non-persistent architcture.  v2 didn't
have support for either architecture.

> Anyway The plan is what Kai said.  The code will reside in the x86 common
> directory instead of kvm.

But what's the plan at a higher level?  Will the kernel load the ACM or is that
done by firmware?  If it's done by firmware, which entity is responsibile for
loading the TDX module?  If firmware loads the module, what's the plan for
upgrading the module without a reboot?  When will the kernel initialize the
module, regardless of who loads it?

All of those unanswered questions make it nigh impossible to review the KVM
support because the code organization and APIs provided will differ based on how
the kernel handles loading and initializing the TDX module.
