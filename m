Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E587B7755A4
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 10:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjHIImx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 04:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjHIImw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 04:42:52 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748DB198D
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 01:42:51 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-687087d8ddaso6266290b3a.1
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 01:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1691570571; x=1692175371;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TrtPDxAEcqilg4TX4aQgmvdeFUGgEe4Z7iRGQc11hbI=;
        b=MBnMFpxXrRY5OSyAUBw0JnfmG6GlX3JVagq7+CIiyxMHZB56sb+mPMr2dBL7y4Hd8a
         EsKILdQmTpphQ/KFt033uIZ6s8xE7Uxye3XTX5KNj3Z6kS1IZAL0IsxwD3PpJP9sEFdL
         b1jnn0qi6kEns7E0iNw/CDgqFRfQNsA/VW/Ke5m9ZMCUnC+vBOkgJWoFmNXXCHaSj3LY
         zUgWm8lAfQJRv0jOX7Nvy/ajtEUzyWCbSUtdEcKSzUeT7UDhvonRvqCv6OUH0gEIYZ+x
         2bjkrvCzX+2cqYaSz86Cb08mQNlmLNzxdXdmClscwyMv+olqzWzLvyKGF8bsFNXddbZu
         I/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691570571; x=1692175371;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TrtPDxAEcqilg4TX4aQgmvdeFUGgEe4Z7iRGQc11hbI=;
        b=Yu7kgL1RC99Yn9R2DDE0YTE5FvgmZmQpg4JzRnF7uaCl0aplSkqNriyzzUramBHr/5
         y7ex439KOYzp5eEXDJUN8uj3CuGa8H+TgdTFkoU7o0qiKXYDbyUqhrL70opn8yaATTSB
         DYV9BjM59ueQGp0wb3WUhVcfL1pN/T+lD17zWl3TXY5yZ2BsV6/KJXVPYdjh4mntHXOF
         Toft2VW/C1iMV7HM24lAUyIzCw20iR7i7F6syPPLPeRDiJ82DXXZPRZoEjdsMq9SskT0
         Z8hmyTmZSKC5/pFyj10HROUjQRwEj0J5yHF0Zt640l6M+osjCALlkhEdmJexsKYizmkg
         P7SA==
X-Gm-Message-State: AOJu0YxcxumFHEcN85FtHdxITgL2upz8TNwNrGz9aud94IU6aWCc537X
        4fKQOH1B4H5cXVnG8sS6npqlZQ==
X-Google-Smtp-Source: AGHT+IH9+zQDvaIeSAqfahQYX2IWJi807U1+EK7ALzBJC8Ag5ZKk0Pb2y0IhQjMaeSRZkIQo4OhBeg==
X-Received: by 2002:a05:6a00:9aa:b0:687:2e26:9ca9 with SMTP id u42-20020a056a0009aa00b006872e269ca9mr2334049pfg.11.1691570570847;
        Wed, 09 Aug 2023 01:42:50 -0700 (PDT)
Received: from ake-x260 (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id i5-20020a63bf45000000b00563397f1624sm6731096pgo.69.2023.08.09.01.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 01:42:50 -0700 (PDT)
Date:   Wed, 9 Aug 2023 17:42:41 +0900
From:   Ake Koomsin <ake@igel.co.jp>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH] KVM: x86: inhibit APICv upon detecting direct APIC
 access from L2
Message-ID: <20230809174241.36dd569d@ake-x260>
In-Reply-To: <ZNLUQ6ZtugOjmlZR@google.com>
References: <20230807062611.12596-1-ake@igel.co.jp>
        <43c18a3d57305cf52a1c3643fa8f714ae3769551.camel@redhat.com>
        <20230808164532.09337d49@ake-x260>
        <ZNLUQ6ZtugOjmlZR@google.com>
Organization: igel
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Aug 2023 16:48:19 -0700
Sean Christopherson <seanjc@google.com> wrote:

> > The idea from step 6 to step 10 is to start BitVisor first, and
> > start Linux on top of it. You can adjust the step as you like. Feel
> > free to ask me anything regarding reproducing the problem with
> > BitVisor if the giving steps are not sufficient.  
> 
> Thank you for the detailed repro steps!  However, it's likely going
> to be O(weeks) before anyone is able to look at this in detail given
> the extensive repro steps. If you have bandwidth, it's probably worth
> trying to reproduce the problem in a KVM selftest (or a
> KVM-Unit-Test), e.g. create a nested VM, send an IPI from L2, and see
> if it gets routed correctly.  This purely a suggestion to try and get
> a faster fix, it's by no means necessary.
> 
> Actually, typing that out raises a question (or two).  What APICv
> VMCS control settings does BitVisor use?  E.g. is BitVisor enabling
> APICv for its VM (L2)? If so, what values for the APIC access page
> and vAPIC page are shoved into BitVisor's VMCS?

BitVisor does not set up APICv at all. It also does not setup APIC
access page at all. It does not try to emulate APIC at all. It only
monitors for APIC INIT event through EPT_VIOLATION mechanism only for
its AP bringup and stop monitoring after that. As I mentioned in the
previous mail, when BitVisor runs on real hardware, it lets the guest
control real APIC directly.

As it is a micro hypervisor, it runs only one guest OS. Its main focus
is on device access monitoring/manipulation depending on the
configuration. It tries to avoid anything to do with interrupts as
much as possible.

In mean time, I will try to get deeper into KVM internal. Thank you
very much suggesting on KVM-Unit-Test.

> > The problem does not happen when enable_apicv=N. Note that SMP
> > bringup with enable_apicv=N can fail. This is another problem. We
> > don't have to worry about this for now. Linux seems to have no
> > delay between INIT DEASSERT and SIPI during its SMP bringup. This
> > can easily makes INIT and SIPI pending together resultling in
> > signal lost.
> > 
> > I admit that my knowledge on KVM and APICv is very limited. I may
> > misunderstand the problem. If you don't mind, would it be possible
> > for you to guide me which code path should I pay attention to? I
> > would love to learn to find out the actual cause of the problem.  
> 
> KVM *should* emulate the APIC MMIO access from L2.  The call stack
> should reach apic_mmio_write(), and assuming it's an ICR write, KVM
> should send an IPI.

When enable_apicv=N, interrupts work properly. This is why I wrote this
RFC patch.

Regarding SMP bringup fail, The thing is when L2 Linux guest runs on top
of L1 BitVisor, it is not going to rely on KVM specific features at all.
In this case, it seems to me that vcpus possibly can not change their
state to wait-for-sipi in time once INIT is issued (might be due to 
scheduling?). This does not happen when BitVisor runs on real hardware.
Once you have time to try BitVisor, please let me know if you can
reproduce the problem with the default configuration. Trying with
-smp 8+ on a machine with many cores might be easy to reproduce the 
problem. I test mine on i5-13600K.
