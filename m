Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3CD38B78D
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 21:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbhETT27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 15:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbhETT26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 15:28:58 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BEFC061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 12:27:36 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b7so5518768plg.0
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 12:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iml5vlQyJ5aEreLAznsInz2oxovRQjUf93YcskiYZ98=;
        b=Ccjt6etnJXJ4WcP01qXkL2lfD/cv42N3HR1qjpYZw8PuN6vMin+IjrlHmSqms17p6/
         xwXuXDA1nj/LcWD8zfKNtYQhQB7kBc9BHoI9WRdweuRJSYIrxAezJWHEIEchkl/quhvO
         uCs5SqY8laivgv3a/6KDrvx9Wjcc/wmt8XRPsM/1c9ow0WzZreh0xR5JiW3fYwcfSnv0
         J01AGvDDic4e0oIxKgv8odZ/Swug+TnG6nHy84dInVlHh/488bxQ5tCwu5k9JEJG+ZzR
         moCak2rvvXvH8DTTaYPFlAe1LNrDUtMInUHUp6eJL34qHehnJvcMTpyD24Pb/Q9y8Ya0
         u87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iml5vlQyJ5aEreLAznsInz2oxovRQjUf93YcskiYZ98=;
        b=lmrmxlb2EOqWpJKYQEC9+vGU99Lxfoe3MoZhop+oo5ABZ97TSH0MgaBYPDswtVfUqz
         DSDPMEw2VcdK88ud9XZm9zSFvX1p0/0HRKGX0+i+Ly6dKmgIgUleAGPXMenUpdIO+bih
         hNNB0uw9n+apZ5qUYmqBxsI0IPdM/F30P4wFA2q6fA9wkkWTs8ZWTFjy4x5vCUIm0LE5
         z5rkyYuVRlO86m+nbU+J0jzajAm2Hode4aYWtsosbSAAPu/auAPD1h3OS20xlg/eUP+U
         T0ycZ62SvM8Y0J27ZyB2MZYp8/eHofMjk02M9RKNqnc78ytBMTeIcFArty7SGdjg3Q7h
         BqTQ==
X-Gm-Message-State: AOAM532UNmktIK7MrjmjMMHZRBizK/NY6q69Q1deg73E8fCGLXa02X3d
        fjfmdk867RQ60U3W29gUBvWJvw==
X-Google-Smtp-Source: ABdhPJxBU9g/ParfT51FLqKHBwMv1a0NYQuBdJP6RrmijUlsvTURa81MSKwY66DOztWp/KW89x0xhg==
X-Received: by 2002:a17:90a:7e03:: with SMTP id i3mr4949220pjl.197.1621538856218;
        Thu, 20 May 2021 12:27:36 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w125sm2495213pfw.214.2021.05.20.12.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 12:27:35 -0700 (PDT)
Date:   Thu, 20 May 2021 19:27:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
Message-ID: <YKa4I0cs/8lyy0fN@google.com>
References: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
 <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
 <324d9228-03e9-0fe2-59c0-5e41e449211b@amd.com>
 <YKa1jduPK9JyjWbx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKa1jduPK9JyjWbx@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021, Sean Christopherson wrote:
> On Mon, May 17, 2021, Tom Lendacky wrote:
> > On 5/14/21 6:06 PM, Peter Gonda wrote:
> > > On Fri, May 14, 2021 at 1:22 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> > >>
> > >> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
> > >> exit code and parameters fail. Since the VMGEXIT instruction can be issued
> > >> from userspace, even though userspace (likely) can't update the GHCB,
> > >> don't allow userspace to be able to kill the guest.
> > >>
> > >> Return a #GP request through the GHCB when validation fails, rather than
> > >> terminating the guest.
> > > 
> > > Is this a gap in the spec? I don't see anything that details what
> > > should happen if the correct fields for NAE are not set in the first
> > > couple paragraphs of section 4 'GHCB Protocol'.
> > 
> > No, I don't think the spec needs to spell out everything like this. The
> > hypervisor is free to determine its course of action in this case.
> 
> The hypervisor can decide whether to inject/return an error or kill the guest,
> but what errors can be returned and how they're returned absolutely needs to be
> ABI between guest and host, and to make the ABI vendor agnostic the GHCB spec
> is the logical place to define said ABI.
> 
> For example, "injecting" #GP if the guest botched the GHCB on #VMGEXIT(CPUID) is
> completely nonsensical.  As is, a Linux guest appears to blindly forward the #GP,
> which means if something does go awry KVM has just made debugging the guest that
> much harder, e.g. imagine the confusion that will ensue if the end result is a
> SIGBUS to userspace on CPUID.
> 
> There needs to be an explicit error code for "you gave me bad data", otherwise
> we're signing ourselves up for future pain.

More concretely, I think the best course of action is to define a new return code
in SW_EXITINFO1[31:0], e.g. '2', with additional information in SW_EXITINFO2.

In theory, an old-but-sane guest will interpret the unexpected return code as
fatal to whatever triggered the #VMGEXIT, e.g. SIGBUS to userspace.  Unfortunately
Linux isn't sane because sev_es_ghcb_hv_call() assumes any non-'1' result means
success, but that's trivial to fix and IMO should be fixed irrespective of where
this goes.
