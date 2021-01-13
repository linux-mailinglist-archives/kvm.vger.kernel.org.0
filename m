Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763142F4FFD
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 17:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbhAMQar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 11:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbhAMQaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 11:30:46 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47C3C061786
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 08:30:06 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id g3so1363487plp.2
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 08:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=30DVT29WJpeEZlk/+prLAyzCIsLavOL7AA+B+M6ksUY=;
        b=ZmvqCdr4T+giCmTNO6m9QDhxYhzCQVAYiG9xgQd27O7tvuMHXCLWAucRvgnYBcHgHl
         jnpsyK3nfjhClbk+BXW/l+XHOl33n48PVlGIQlBeg0SkLDDKqkBIA7wadl71FqLKK5sG
         M3F020c+WP4SpYalQ0NL0RyPXwKJQ3WftywfwJsnZxw4F3n3QXjDweNgE7+2wCyhT0PG
         Wn68rJrdmX9BtmY5Tu+iB0rmNE1zSZEDc1JFzjw/Dx7s1aeBrWBSA9K3tA8qQY7hdXOK
         TbGkmHlSBG9fTYKkxySHNPwaCL1TM+sE0erwCC8n8DJ1rtZMNE5wWjE86ENFMSdIQrDY
         RgHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=30DVT29WJpeEZlk/+prLAyzCIsLavOL7AA+B+M6ksUY=;
        b=CkyAmkdikaexxsPlM2tNeTbGCecIFmYkv82i1To64VcfSRgIkS3oB+yceJxMK7Fnlg
         PgvArBG29ju4ZOULTEyn7PJl3vAF+ENisfYfwRYxwT3xrrbMtUYsplNahnF9GV6p1SRZ
         Odb2N2NRobWpMUoyFsiXfp/+RXPLCUdOjS/VnStUDL8bW7juAJ9OgZmw7HRM3pn5xWn1
         5l8/Ti1qr0+qRdqwaB2M9qgt9tkk0XYG/xt1Z5YHgFRpbESzwuMdkqUQ/X9NxjQDCZ6c
         tMjqmRDO5QHGpeNUxYSat0dKAbDEUcFxUmU/qWTmvK1Q/WgJaanDOXuSNKRd/pSmc17T
         2wxg==
X-Gm-Message-State: AOAM533B0WcfzxBNKoXKlH93VAG1Wr7rtolXXGzyto5hboL+xtH9Sy/r
        JwbyxDWOWxu18MIASLcGGAu3gRChtLQiSw==
X-Google-Smtp-Source: ABdhPJwCAsIJBdELayl098j41Up0FVi5XjPlNxB6sNY82/FLJEY8cw1GPWj4POka2GPEsNtbMUJr9g==
X-Received: by 2002:a17:902:26a:b029:da:af47:77c7 with SMTP id 97-20020a170902026ab02900daaf4777c7mr3192693plc.10.1610555406044;
        Wed, 13 Jan 2021 08:30:06 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id bx17sm3538084pjb.12.2021.01.13.08.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 08:30:05 -0800 (PST)
Date:   Wed, 13 Jan 2021 08:29:58 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jason Baron <jbaron@akamai.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, aarcange@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
Message-ID: <X/8gBuTlYYfBQjva@google.com>
References: <cover.1610379877.git.jbaron@akamai.com>
 <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
 <X/4q/OKvW9RKQ+gk@google.com>
 <1784355c-e53e-5363-31e3-faeba4ba9e8f@akamai.com>
 <86972c56-4d2e-a6ab-11ad-c972a395386a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86972c56-4d2e-a6ab-11ad-c972a395386a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021, Paolo Bonzini wrote:
> On 13/01/21 05:12, Jason Baron wrote:
> > > 
> > Looking at the vmx definitions I see quite a few that don't
> > match that naming. For example:
> > 
> > hardware_unsetup,
> > hardware_enable,
> > hardware_disable,
> > report_flexpriority,
> > update_exception_bitmap,
> > enable_nmi_window,
> > enable_irq_window,
> > update_cr8_intercept,
> > pi_has_pending_interrupt,
> > cpu_has_vmx_wbinvd_exit,
> > pi_update_irte,
> > kvm_complete_insn_gp,
> > 
> > So I'm not sure if we want to extend these macros to
> > vmx/svm.
> 
> Don't do it yourself, but once you introduce the new header it becomes a
> no-brainer to switch the declarations to use it.  So let's plan the new
> header to make that switch easy.

Ya, sorry if I didn't make it clear that the vmx/svm conversion is firmly out
of scope for this series.
