Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2DB3908D1
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 20:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhEYSXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 14:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbhEYSW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 14:22:56 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DC7C061756
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 11:21:26 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id j12so23412591pgh.7
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 11:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+BZyml4QNPakkE47UBP4P5/G1VBzFvh2K0aZZhlkKa8=;
        b=YTp2x0SQduyFfOcah8WlxA2ladVZsZv1Mf04xl1F3UzQdo3jswV2APsR5l9zoB8tBC
         gsVxNtVPCv+bxn9p0Vt4Sasg2hJ8LHbioxgs/cyNlwh6RCapCa97pgskCD61LMsUgiF/
         zqh7PILQNlnf1OmIXPIJMED19VYeU6MjKR9v9+9tOHgdlNeMqhtWTiQK1WFVEN7rGEly
         AUSGN/i25EDEpMb+rkHMgR2Z4BY8dM4jF7gg5iPbMYFzHr25MElN0jPJeiTmPfrhEekJ
         RsDxi1BzI/hBRxDWQ/kNhH6wyOFUtC3UhZiNcHMLnTTmBugwKKc838+fqZQZmqja4rMS
         kaig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+BZyml4QNPakkE47UBP4P5/G1VBzFvh2K0aZZhlkKa8=;
        b=EpvkayrKPLFSGFa00XQbVzZ9c7uksEvhnKNd2gztupN66+HJHWgT5+oWVouBmDrTKR
         cjmPvu9kd+2l7Cmre6t+/CqjPl6rttYlOJzuT7CG8pSapExN12M0f6gYxUGNkevDc1yP
         +w0oD+9BGylTRlqk1RPOtigrJuXSQkYoT/ouWgWFl5APjWQ8kl/Q+tOLRdO5kEdGzlkE
         tWp55Brr9dDgnxQ7mt+oi4PwkJiH9sWoIvmyO1/SVUaIbzOD61YcplCSoAChJJoj7GqD
         mdJ+neSaAt+wTHdCSxKs2l/0OEzXVigxPTu2Ao51gVkDie1D7sQXRQTU0CYk60ftusCz
         SL+A==
X-Gm-Message-State: AOAM532/1a6tswXcsd2F2tZb7UXvJdUSfjC0SQIuTi4vyUMvLQhKAz1d
        Ftx82d8Uojh9UD2nPf2XNEwzUg==
X-Google-Smtp-Source: ABdhPJzWYlLigzgP76oNS+BdV10DlODEGG/NGo+XEV3m2Apt0qjB8ZjsTQMBilWhlfDHImNpF7khlQ==
X-Received: by 2002:a63:de4e:: with SMTP id y14mr20294242pgi.30.1621966885319;
        Tue, 25 May 2021 11:21:25 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k1sm13323160pfa.30.2021.05.25.11.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 11:21:24 -0700 (PDT)
Date:   Tue, 25 May 2021 18:21:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Stamatis, Ilias" <ilstam@amazon.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
Message-ID: <YK1AIfr/Ot4ND5Pn@google.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
 <20210521102449.21505-10-ilstam@amazon.com>
 <2b3bc8aff14a09c4ea4a1b648f750b5ffb1a15a0.camel@redhat.com>
 <YKv0KA+wJNCbfc/M@google.com>
 <8a13dedc5bc118072d1e79d8af13b5026de736b3.camel@amazon.com>
 <YK0emU2NjWZWBovh@google.com>
 <0220f903-2915-f072-b1da-0b58fc07f416@redhat.com>
 <YK0nGozm4PRPv6D7@google.com>
 <204c0b60-5e39-eb61-da85-705c56604cde@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <204c0b60-5e39-eb61-da85-705c56604cde@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021, Paolo Bonzini wrote:
> On 25/05/21 18:34, Sean Christopherson wrote:
> > > I actually like the idea of storing the expected value in kvm_vcpu and the
> > > current value in loaded_vmcs.  We might use it for other things such as
> > > reload_vmcs01_apic_access_page perhaps.
> > I'm not necessarily opposed to aggressively shadowing the VMCS, but if we go
> > that route then it should be a standalone series that implements a framework
> > that can be easily extended to arbitrary fields.  Adding fields to loaded_vmcs
> > one at a time will be tedious and error prone.  E.g. what makes TSC_MULTIPLIER
> > more special than TSC_OFFSET, GUEST_IA32_PAT, GUEST_IA32_DEBUGCTL, GUEST_BNDCFGS,
> > and other number of fields that are likely to persist for a given vmcs02?
> 
> That it can be changed via ioctls in a way that affects both vmcs01 and vmcs02.

That holds true for any MSR that is conditionally loaded/cleared on enter/exit,
e.g. userspace can stuff MSR_IA32_CR_PAT while L2 is active, and that can affect
L1 if L1 is running without VM_EXIT_LOAD_IA32_PAT.

I'm not saying that the above is likely, but neither is changing the TSC scaling
ratio while L2 is active (I assume it occurs on migration, but in the grand
scheme that's not a common operation).
