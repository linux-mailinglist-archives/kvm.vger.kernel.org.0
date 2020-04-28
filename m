Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8123D1BCF43
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 23:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgD1V65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 17:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726778AbgD1V65 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 17:58:57 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89B0C03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:58:56 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id e9so25037619iok.9
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lnb/AuomAQNJo8vC00yUB5kS4MsOuZB4Ct4ocKwuxdk=;
        b=mkX4NZaNgVNkDyA54xwp26Mz+IRfpG1ztLCsGFY2+Q8scP70EZBen1e/opZFQUaqlu
         VJ5Rp3psn0rcwas6GrwhtKAnlAsUMCJwnICnwwnEFuTuYssLk0gb3UiqYMLHl5xTHTzi
         gLhIEZwFQq1pLhwwjwjrCp6Vx9Yt4PsflleMy1hgrW1LffY+tBffmmXWGBUqvxlJ+2Kh
         S15d2MNup5bdK3efqdbfh+lDsG3Tj3O6M4oehDOMG8bH+cLrtwHmg3DVQfN/vJgExQTy
         Sn89OHYrhTvStmTNGHpU5K0R86SV6xMjDV6poX65cA+KQPjNmK97WyfbQHpqPcjQVa6Z
         xG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lnb/AuomAQNJo8vC00yUB5kS4MsOuZB4Ct4ocKwuxdk=;
        b=YmQJ2KCTq1apXJGuIK9h+wRJ95qNzZE392n0cwzKu31FIAXIsmqSOxhZ7GO83XeIqS
         wZMm5USqVxVpbpvEqxUxE/9+THh77nKBqlelc9svPN5K38r7025wqHfac4mTZsH3xsYO
         9G0cZuA+cBlQbsnXHni5EaB0VMmnqkXpiZWRom0fU9xTml3groehr6d7yF3XBCNr/Eit
         Au38Wypo1X/wlPtiiXDjjOzkmvy+nGrOYbcNHg5cXIxShjDf4TSK2HZhKUd9HF0ohT50
         Yr6riEFWcmCgCbPByb1vzsM/tvM2pPE7nXEEnKSM40BEa2b1ITdh76Z4G5KfwLz2m2GI
         piQQ==
X-Gm-Message-State: AGi0PuaW5srV74YEZU7INWgwRuftXsgSvXIHOGWM/GNmu996hnKdgUb3
        zAIsGKimyCgh6E6USs34444mJGUkWqG+Bwx7ENMBiQ==
X-Google-Smtp-Source: APiQypJIb0ErMY4mtUsYmzA6Yv167R2fgOgPSoZqyTb9YnVxaEYquhArv+3g934sjJXNag31V/j4bT9VoIQAlxJU3/g=
X-Received: by 2002:a5e:a610:: with SMTP id q16mr28126485ioi.75.1588111136020;
 Tue, 28 Apr 2020 14:58:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-9-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-9-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 14:58:44 -0700
Message-ID: <CALMp9eQav5s4SceVD=3zYb-RYkNHs+8F3hMUASBYrcJcyUterQ@mail.gmail.com>
Subject: Re: [PATCH 08/13] KVM: nVMX: Preserve IRQ/NMI priority irrespective
 of exiting behavior
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Short circuit vmx_check_nested_events() if an unblocked IRQ/NMI is
> pending and needs to be injected into L2, priority between coincident
> events is not dependent on exiting behavior.
>
> Fixes: b6b8a1451fc4 ("KVM: nVMX: Rework interception of IRQs and NMIs")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
