Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40FA54B314
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 16:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbiFNOZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 10:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238361AbiFNOZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 10:25:42 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B8A2DAB5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:25:41 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 184so8621790pga.12
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=++2FJZM3XmKFOWmeZLk4Tc/bXoJkajjMGZdDaFE91Ak=;
        b=oCxGZ6IO3OfSgOPoPBUPd0fiLYpROnXslENGxXf7TzOmQuSpuCeYBRLLkSgH8YtI2i
         AO5GYl2XDuTzPqgLofZF6Wu3Uk/y7dSigP9lNtkN0ZS1AEfCPHT5L7M9Nb4mVxy+CO/r
         fXtVEW7qltJEvnWF4kfglAFL/EjuqNPXHTNtQYOKuqUjej1FyQD009T/m8k6e28opkHm
         Hp0JYKd/j+5qmHooFsabPlr0NFuHjgfCKQlOoYdpe2xchQL3NRpfoCUalugrleF3fDPk
         nkIpsGnxNUxS+JbdJJ5WnJrGBxxsoGmCpsOHBX1wbm5p0wUQYR+A5uuJvX59+JjEEhtU
         5Ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=++2FJZM3XmKFOWmeZLk4Tc/bXoJkajjMGZdDaFE91Ak=;
        b=iwsmzwS4EeB4HvFBa9qC47oq7IYos6AkfrWNuo3Haz3UABIm457nJEytVDq0h8N0qB
         ER0flWzVEKqx727yGM/swEiEPpFAe1IyVJyS8qn10akHJ1simY4wtprg8ewfvdDHQbjk
         YDX+qbGff+n8mQk5ybOzD+aYcyxvnHGa7HpueOukfq+HoslTKoQuu4dGhQ/b6fV39NMU
         tt2CsUSSD8ZRUqYtVd4LA3ECP/tPbsJMNRwupGzc2BcgCmOyVR6sHxzpzTGVq1gehtIu
         OlyMRf8UytmR83wwI8P4tbQwTkhY/C+fLVNZEn7KNHjhLQZopj4ZaewCIPUNAiu8lMH7
         lMFA==
X-Gm-Message-State: AOAM5315tDgWCLltpm/dLRUULXkZFNaq+J00csi+aRWsKnYQIIy1Alpy
        DH+dSONgARRcFsqG+1yauM0qJw==
X-Google-Smtp-Source: ABdhPJwMjR5voJxaAFi75bkKPArlvIqwhMvD+kKcWFfgqi3fPh81Vo8kGjTSuVrVrhZPH1me0ae5Ng==
X-Received: by 2002:a63:9b0a:0:b0:406:8c31:47e6 with SMTP id r10-20020a639b0a000000b004068c3147e6mr4706269pgd.329.1655216740728;
        Tue, 14 Jun 2022 07:25:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090a1f4100b001e31c7aad6fsm7484546pjy.20.2022.06.14.07.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:25:40 -0700 (PDT)
Date:   Tue, 14 Jun 2022 14:25:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] KVM: x86/mmu: Bury 32-bit PSE paging helpers in
 paging_tmpl.h
Message-ID: <YqiaYJCjhNc8arf5@google.com>
References: <20220613225723.2734132-1-seanjc@google.com>
 <20220613225723.2734132-4-seanjc@google.com>
 <CAJhGHyCMsc4g7rdW8td5vOA5iAZBu7+hewUJW8tUXX=_-UBVOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyCMsc4g7rdW8td5vOA5iAZBu7+hewUJW8tUXX=_-UBVOA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022, Lai Jiangshan wrote:
> On Tue, Jun 14, 2022 at 6:59 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Move a handful of one-off macros and helpers for 32-bit PSE paging into
> > paging_tmpl.h and hide them behind "PTTYPE == 32".  Under no circumstance
> > should anything but 32-bit shadow paging care about PSE paging.
> >
> 
> Moving code from paging_tmp.h is on my to-do list.
> I don't think the opposite direction is preferred.
> 
> And is_cpuid_PSE36() is also used in mmu.c, is it a good idea to move
> it into paging_tmp.h?

Huh.  I've no idea how I missed that every time.  It definite should stay in mmu.c.
