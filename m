Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D8139EAC0
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhFHAgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhFHAgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:36:09 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD23C061574
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 17:34:02 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 69so9663459plc.5
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 17:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VjYZkdAh6XPRWdRICkFVqrEq2Tj+cpaidhfkOKHJ4Ys=;
        b=VxDpUN2YqnA3P9FRBWtKzfkmPb7dN1ye0DLknStv0JLAD0lfAYJiloty4u2A2nLkC2
         pGtWItn3Gvk4OP+7W0gKfvq98YmCnreZ6G/AZanLijfQNUOgVlrZ57WL8DFZXizrrFVy
         pmUSWL5JCCSY4etvrLNznIf4K9hXQGkpCBFTVTI4XOMiUB/Joal4/q8VPtGA9Ih4BiOS
         EGSFYbQ82tzTIw30T6l7qvgwYlkqNJqFbJ27IJ0ytbAqLkt0vhbwxiEl8wqEmw5Lt4U0
         wUXZq1UWdi9HNXQISzwxdhUUp292917s71LULkIm/re9u/Z/7gCBLrDa+fqdIoRIgynB
         K5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VjYZkdAh6XPRWdRICkFVqrEq2Tj+cpaidhfkOKHJ4Ys=;
        b=jd3uNuwX3xJz86j+Jdk5ezseVP+H6S+uiGs2CuAmSMflUbcU+h/+snYTudqQJrMjyM
         34Wzv0730sCC0XUPswrSXk5a2wV//2iuwxwxsGTuhuv6PDKZY5mBNm45v1Y89EJ3Am6+
         VNJ1LiIVBEvo23OEqTgWwLv8zBCWGO+DS1GzOKjKTmJSZDn0L/SENCChYNj1sHcqV+Tp
         JnW6aNHV4X9GcMsxuFn7NOH0xgte/FUxc6nsDV2PFGtezmpzxfsjjLl/VCcX6e5M5ftl
         DBfqR3XOzqoXMqNOG5sVBYvA1Or2oo7tJgKFjMYUB356VzI8jZ3E6nL6yt75YmB0xyXi
         I6UQ==
X-Gm-Message-State: AOAM533/aKYi8a+Ni1a8KSu0ejmWB3R0Jl5IjldZOyfTCd1BzJkEpYsB
        2lVQNwvsuqIv3HcSgchsNjsfVA==
X-Google-Smtp-Source: ABdhPJxnA3XzhRo8+VYT28itEv6F2Z/s5O1sM7tVTLKsRNjAihqVyM93md4xbDZEh+bPzrNNoLjm1Q==
X-Received: by 2002:a17:90a:7f85:: with SMTP id m5mr23359411pjl.128.1623112438897;
        Mon, 07 Jun 2021 17:33:58 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t19sm490189pjq.44.2021.06.07.17.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 17:33:58 -0700 (PDT)
Date:   Tue, 8 Jun 2021 00:33:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: reset and read st->preempted in atomic way
Message-ID: <YL668lnelAVNlLWx@google.com>
References: <CANRm+CypKbrhwFR-jLCuUruXwApq4Tb62U_KP_4H-_=7yX1VQg@mail.gmail.com>
 <20210531174628.10265-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531174628.10265-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit: the shortlog is somewhat inaccurate now, maybe just:

  KVM: x86: Ensure PV TLB flush tracepoint reflects KVM behavior

or something along those lines.  Not sure what the best wording is :-/

On Tue, Jun 01, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> In record_steal_time(), st->preempted is read twice, and
> trace_kvm_pv_tlb_flush() might output result inconsistent if
> kvm_vcpu_flush_tlb_guest() see a different st->preempted later.
> 
> It is a very trivial problem and hardly has actual harm and can be
> avoided by reseting and reading st->preempted in atomic way via xchg().
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>

I saw this quirk too, but couldn't quite bring myself to care enought to test a
patch :-)

Reviewed-by: Sean Christopherson <seanjc@google.com> 
