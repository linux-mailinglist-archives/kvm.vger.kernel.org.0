Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528641BCF6F
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 00:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgD1WHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 18:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726256AbgD1WHu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 18:07:50 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B83DC03C1AC
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:07:50 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w6so532965ilg.1
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tO+DbU6KByMbcPRw+6fwaWiCfeYN7nbol6e4reDVW4I=;
        b=KO6SmP63VTyTeoVjCJWFexYShARMTWk/xWvofiwo+kHGO9i/UDgHdyyCCoXkK4QH5l
         ZjT1dkx6I6kmN3S/hKj8qJ9eEDqbmeIL8Po8V0gxgReZgJ6c3LBUv3FMiZ3ofGbtnJJw
         eDZUCwiRljta71iiCpa4A+H2PO2athl9CEgH0UX8soxSGvvZUo1I89OmlyUQXN8S33KW
         Oph7WTf1SgbMsQBJGiy1esxg+6s2gw1w4AsWiTpwNFAxfH0phtZLPXk2dyYXiIh4f+v3
         sEll7nAgPDTmrwiBwjWMcbaHtVNYHOWYMHIxQJHuyow+P3uPA7awaSWg6BdysGz3NyCN
         sKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tO+DbU6KByMbcPRw+6fwaWiCfeYN7nbol6e4reDVW4I=;
        b=nlkgKRybmO2AC9NGGdHcC1wazRUVb4o4vaesG8qQvsTWEi2jar9RhmlESoFVqvIHbT
         NwMgIEYsCCs7THZBxI03xhJ/XaTJcoacOjxxgWjwY9mLvuEUca0kqQOcMDmVDGXZykZT
         ACwYHiYsBeYAOq6x3+bUMEY95URXj9gqW7DFvTietY7w/sOMyskhunM0IXFDeEho6ceK
         SFpKYwuXvl9Dg8lDtoZ82H46qaIslcdWdf8UlUxHAtiplGRx+p3eOrhqFBBXuTyFerJp
         KS+11RdyqmhgatL40qXuS20DnjaqSQHRoi08WApup+ce29l3sspawTsasWQhDLD1HwKr
         ftVg==
X-Gm-Message-State: AGi0Pub0ScHnCbtdipB3tPiRIfpu9tcxDf9/UF7XrjdgZrChVMFfxd6q
        ytwZjoW4ZpWs00n9FF5UNyKVeq4bmxQjU7B2fE3KeA==
X-Google-Smtp-Source: APiQypKs0cmslzkJ3/IcooJcMOg8zkJMwhBrgReyRcwYDpGk5UtUrhKE6RN9vlWUAMwJZzxOofrOHp1/2jrvavOGpIk=
X-Received: by 2002:a92:d186:: with SMTP id z6mr27561585ilz.119.1588111669486;
 Tue, 28 Apr 2020 15:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-12-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-12-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 15:07:38 -0700
Message-ID: <CALMp9eQybxs+Zq66uAfVz3bc=571V7H8YVEhm7AuftpcZ5NLRw@mail.gmail.com>
Subject: Re: [PATCH 11/13] KVM: VMX: Use vmx_interrupt_blocked() directly from vmx_handle_exit()
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
> Use vmx_interrupt_blocked() instead of bouncing through
> vmx_interrupt_allowed() when handling edge cases in vmx_handle_exit().
> The nested_run_pending check in vmx_interrupt_allowed() should never
> evaluate true in the VM-Exit path.
>
> Hoist the WARN in handle_invalid_guest_state() up to vmx_handle_exit()
> to enforce the above assumption for the !enable_vnmi case, and to detect
> any other potential bugs with nested VM-Enter.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
