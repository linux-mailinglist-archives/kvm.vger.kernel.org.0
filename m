Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2364D1E49
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348671AbiCHROk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348641AbiCHROg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:14:36 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15F822BD0
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:13:38 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id g1so17888972pfv.1
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yX/dqRRjbY7VPqIb5T+iQdlEaEwAOCFRzujlbgFA4Fs=;
        b=ioFeXfXAO5oHOxqQT2Z34H4YMKf90sMolbArQpELVX7APj6xqRx78jAUXwiXQNDTvb
         sTaUe+9lr1Fgx7jzvEfMeeqpMhVTgETLUhugLZjgWbmTpNdt9HNqrRK1WHXFgEQiw4LW
         nRoIEpM70fjUP13UeSjA4n92nOt67IZRZWEnLvX3mKsDfua/BoTMIGv0Q+ztVATlU6H1
         75lKHADKwCJgL8ohSF6WE0IdZhrwj864Sq6/Zs5qTqAptK+pBrc6K9CmJNLLjqbP4koG
         KKqKpKeKrUvQjeTj7igMZg2SNqWaG7pZeo93JwAQDc1ItdEuGknnF0aNCcCnRYvyxbrj
         +FVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yX/dqRRjbY7VPqIb5T+iQdlEaEwAOCFRzujlbgFA4Fs=;
        b=C88M06ux/Vlu2KP23cyF+RyXDdTxbO2doT7r4mJRA9xJzF1LzUCOQl8cSmPmGAehOd
         R2H8R7bKjJ9gNqM6SQe4XH87MMAFFKrwqq1VZQb/k3UrCI43xfidfM9arfukNKIbPuG5
         ng7GEKEnwljloU9XylLjIyFCNm6TIdngNPJIU1Lk/ePU/8LxilcwNuSgoj1g2ww38HrQ
         jG4d9I3O4TFnKt4qXVxfIIH2iEkKw7h7RjOwnHf8PkdauvJQwLYTwiuPnR+IpjDZbMyK
         p6O/aBWR7rqF30GIOoHVg3RhZG7gLaQ/OCx7erTiVvMjTsCwV3ZTq64llvpobKEDih/A
         9imQ==
X-Gm-Message-State: AOAM531MP/xOsDRJkiUhrHb219YQkvDdAJiy9Ez8cFOVRFpwonpla/gU
        buAkiNg1DsDiHiWgGrAGh+l1YQ==
X-Google-Smtp-Source: ABdhPJw6GQ7DePuKOwS9PpsUCiCf3+8HmEtbSA+wwc3EpIYHgbQ9BFe5V/L5cVV/sEQZ+czKLi68PA==
X-Received: by 2002:a05:6a00:1591:b0:4f0:ef0b:dc24 with SMTP id u17-20020a056a00159100b004f0ef0bdc24mr19322358pfk.2.1646759618268;
        Tue, 08 Mar 2022 09:13:38 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mn3-20020a17090b188300b001bf3ac6c7e3sm3472044pjb.19.2022.03.08.09.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 09:13:37 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:13:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 06/25] KVM: nVMX/nSVM: do not monkey-patch
 inject_page_fault callback
Message-ID: <YieOvca6qbCDgrMl@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-7-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> Currently, vendor code is patching the inject_page_fault and later, on
> vmexit, expecting kvm_init_mmu to restore the inject_page_fault callback.
> 
> This is brittle, as exposed by the fact that SVM KVM_SET_NESTED_STATE
> forgets to do it.  Instead, do the check at the time a page fault actually
> has to be injected.  This does incur the cost of an extra retpoline
> for nested vmexits when TDP is disabled, but is overall much cleaner.
> While at it, add a comment that explains why the different behavior
> is needed in this case.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

If I have NAK powers, NAK NAK NAK NAK NAK :-)

Forcing a VM-Exit is a hack, e.g. it's the entire reason inject_emulated_exception()
returns a bool.  Even worse, it's confusing and misleading due to being incomplete.

The need hack for the hack is not unique to !tdp_enabled, the #DF can be triggered
any time L0 is intercepting #PF.  Hello, allow_smaller_maxphyaddr.

And while I think allow_smaller_maxphyaddr should be burned with fire, architecturally
it's still incomplete.  Any exception that is injected by KVM needs to be subjected
to nested interception checks, not just #PF.  E.g. a #GP while vectoring a different
fault should also be routed to L1.  KVM (mostly) gets away with special casing #PF
because that's the only common scenario where L1 wants to intercept _and fix_ a fault
that can occur while vectoring an exception.  E.g. in the #GP => #DF case, odds are
very good that L1 will inject a #DF too, but that doesn't make KVM's behavior correct.

I have a series to handle this by performing the interception checks when an exception
is queued, instead of when KVM injects the excepiton, and using a second kvm_queued_exception
field to track exceptions that are queued for VM-Exit (so as not to lose the injected
exception, which needs to be saved into vmc*12.  It's functional, though I haven't
tested migration (requires minor shenanigans to perform interception checks for pending
exceptions coming in from userspace).
