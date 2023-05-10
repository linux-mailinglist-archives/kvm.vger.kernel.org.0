Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8218E6FE748
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 00:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjEJWfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 18:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjEJWfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 18:35:51 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560ED2121
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 15:35:50 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-644c382a49aso3089057b3a.2
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 15:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683758150; x=1686350150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AXWsa967kWQ103ztzoiQqsYOxAfVBnqmOcMcaXXMfK0=;
        b=hLPWW/6LDB/o0VythM97kkqBcdiN8QKk6IiYT09S3iCYw+9ptyULgVnnrfSVpDLPG/
         v8+BKDKTTzlFxWyxdH88CSwQ9Q7gGmZJRyBCLBKw0gOzF5+YFIpi/JSuswBIutnBSYzL
         GS2z77PT2rgQL8ZZfCE/wTqNMqV7e/1euiQGssFAPGJhr6Lo839j5RDDbX0MFFi7Uteu
         a6sN5Eks3+vJhPj+kQAAkaN3jmlrWHiXFJorO4Z6pyAT1oSXARtLsiLT2NqXplxoa339
         ZgljXKLDsdeBXqdS4dccC1WgQ6cNVBmZQ3FEGdbpCb6SxVYLx5mgqkP8eyeYrqz86rQD
         V4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683758150; x=1686350150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AXWsa967kWQ103ztzoiQqsYOxAfVBnqmOcMcaXXMfK0=;
        b=XMjP2baO+erfSgC9eD+BjgzQ/LlR56cI3PWC3dSH1SOTB4QUrQ4lKiQ4XFMpsYJ1mG
         ocRtoBJVuQbBE0ZJuSQJu8pEztij99jJPaa8K3ZSP7oO9BwF4WfSE3xbdKR38gM/BD4b
         ne2frxtZO7t2OdYZv8XQdW4Cdzl5NWV7+zrvhqqQHjlaTbz/Vm/+7YUP5k6OeKNI3cHp
         LL26qmajQntyzk9Xgs3+zQ4i8faRc60l0lbw4aQhW/nv0ViUAoiByVijAxdzlrw7CPQA
         ht+haijr6j/eOB7xGfCMt8JSOU5lpIqCvhId6dLYOTUoWgEU4LL0GkX9GUxhmcORs7uu
         s0IA==
X-Gm-Message-State: AC+VfDzSGEDF06+0OESaS8emlJb42nsGzgL9nKyvQWo/0qF+BbHOs26s
        YMgsEAQSe5ZGqjmJ2bJVvRbrvBeFSRw=
X-Google-Smtp-Source: ACHHUZ5Gy9IA+Ru/c8L2WMQy1v0wXipJ7RD7p6ZiiwmW9YlFbl+2mMgwKT81N6fwSPogBVGQ0I0240fyYmQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:bd0:b0:63a:ff2a:bf9f with SMTP id
 x16-20020a056a000bd000b0063aff2abf9fmr5274082pfu.2.1683758149940; Wed, 10 May
 2023 15:35:49 -0700 (PDT)
Date:   Wed, 10 May 2023 15:35:48 -0700
In-Reply-To: <ZFrG4KSacT/K9+k5@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZFrG4KSacT/K9+k5@google.com>
Message-ID: <ZFwcRCSSlpCBspxy@google.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oliver.upton@linux.dev, jthoughton@google.com,
        bgardon@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 09, 2023, David Matlack wrote:
> On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> > Upon receiving an annotated EFAULT, userspace may take appropriate
> > action to resolve the failed access. For instance, this might involve a
> > UFFDIO_CONTINUE or MADV_POPULATE_WRITE in the context of uffd-based live
> > migration postcopy.
> 
> As implemented, I think it will be prohibitively expensive if not
> impossible for userspace to determine why KVM is returning EFAULT when
> KVM_CAP_ABSENT_MAPPING_FAULT is enabled, which means userspace can't
> decide the correct action to take (try to resolve or bail).
> 
> Consider the direct_map() case in patch in PATCH 15. The only way to hit
> that condition is a logic bug in KVM or data corruption. There isn't
> really anything userspace can do to handle this situation, and it has no
> way to distinguish that from faults to due absent mappings.
> 
> We could end up hitting cases where userspace loops forever doing
> KVM_RUN, EFAULT, UFFDIO_CONTINUE/MADV_POPULATE_WRITE, KVM_RUN, EFAULT...
> 
> Maybe we should just change direct_map() to use KVM_BUG() and return
> something other than EFAULT. But the general problem still exists and
> even if we have confidence in all the current EFAULT sites, we don't have
> much protection against someone adding an EFAULT in the future that
> userspace can't handle.

Yeah, when I speed read the series, several of the conversions stood out as being
"wrong".  My (potentially unstated) idea was that KVM would only signal
KVM_EXIT_MEMORY_FAULT when the -EFAULT could be traced back to a user access,
i.e. when the fault _might_ be resolvable by userspace.

If we want to populate KVM_EXIT_MEMORY_FAULT even on kernel bugs, and anything
else that userspace can't possibly resolve, then the easiest thing would be to
add a flag to signal that the fault is fatal, i.e. that userspace shouldn't retry.
Adding a flag may be more robust in the long term as it will force developers to
think about whether or not a fault is fatal, versus relying on documentation to
say "don't signal KVM_EXIT_MEMORY_FAULT for fatal EFAULT conditions".

Side topic, KVM x86 really should have a version of KVM_SYNC_X86_REGS that stores
registers for userspace, but doesn't load registers.  That would allow userspace
to detect many infinite loops with minimal overhead, e.g. (1) set KVM_STORE_X86_REGS
during demand paging, (2) check RIP on every exit to see if the vCPU is making
forward progress, (3) escalate to checking all registers if RIP hasn't changed for
N exits, and finally (4) take action if the guest is well and truly stuck after
N more exits.  KVM could even store RIP on every exit if userspace wanted to avoid
the overhead of storing registers until userspace actually wants all registers.
