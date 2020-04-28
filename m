Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886B41BCB20
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 20:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbgD1Sys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 14:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731504AbgD1Syr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 14:54:47 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD83C03C1AB
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 11:54:47 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i19so24391494ioh.12
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 11:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C18IvcKIUPmqhWrNgGQA3HNdNJlQg6Mgu7oxvCya4yA=;
        b=L9xOTWTy9tw1EFj+TKRAx32qbXnmGcmWjC9j+1VFE2M+ENXZSCUF5FaAziHTxmF4H0
         OyMKlGYZ2xM60lfspQhpw9mEylRaIPO32BPXwBYQSIz4taZP3Ui7derpShjsvTSAHNKo
         hs32y1/Re/uF3tXYVScQ7RyDjnYTLYKpVWNJTtHWTkVaackmgtpv1sDnV1FxOh4uq2F9
         4RDSvp0pwjqMIry4z+GsOylTQPvWIjwpv3hWcK8HvhFbAt5Xut9zXnDzTAAhtFKdSvV+
         Ky0ttH1cEZ4Eqly2TWn+V2KcFl11plVaHKk+n7PifWmJegn4DSSsqLOLodv1QIOjOl1E
         XE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C18IvcKIUPmqhWrNgGQA3HNdNJlQg6Mgu7oxvCya4yA=;
        b=mZpsXNl/TG2rvWbdIOYEN/PBoL3M/LBs4c0quxcSg9HikR1vcBAwd5TKMRadN10SPU
         sIzmVuQFjqpVvbPIODMP36oQBjVTot7Wej465Ya94zf/HqhQJ5eaAs43QYohmOXRErCZ
         xaAYL4/TjdG7E/uH7NYx9iu4Nju8PsRR8uDKMkpUP/NE6HpmooDLa3dukyK8oVCRUKx2
         /QSDzLIc0QozABBUlXw9QfpGIvrLIgfF6om2t9hvtnryol8YBs64jad92WytAexa93kv
         GfpKuptAD6NQqeBIRMnOFZM/vXwCnekwXO5PXHJqw71iGCd+ZGsdvVUDDRZ2IzELSGXa
         +SGg==
X-Gm-Message-State: AGi0PuYo/43WMXL+1lwV7X/fxOcCH+plEGCosjaP2yGx1kSVeyWYJXqD
        p/+xsvNSIRlG1efpov60qs0LZjN8NJwipIJyo9qDvw==
X-Google-Smtp-Source: APiQypKNUmcUlXwHdS61LpkDlzHCZSbCAeLZkmmYY+dHTh5R33ZwUxkPBkV2Jz+PT0FIsbrOye9DX+T7bTM7OrBnW3M=
X-Received: by 2002:a5e:a610:: with SMTP id q16mr27415990ioi.75.1588100086060;
 Tue, 28 Apr 2020 11:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-2-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 11:54:35 -0700
Message-ID: <CALMp9eRD9py=N9hDSon5GPzuiZw1Z+3xHv9umu1_qKzWczz0PA@mail.gmail.com>
Subject: Re: [PATCH 01/13] KVM: nVMX: Preserve exception priority irrespective
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
> Short circuit vmx_check_nested_events() if an exception is pending and
> needs to be injected into L2, priority between coincident events is not
> dependent on exiting behavior.  This fixes a bug where a single-step #DB
> that is not intercepted by L1 is incorrectly dropped due to servicing a
> VMX Preemption Timer VM-Exit.
>
> Injected exceptions also need to be blocked if nested VM-Enter is
> pending or an exception was already injected, otherwise injecting the
> exception could overwrite an existing event injection from L1.
> Technically, this scenario should be impossible, i.e. KVM shouldn't
> inject its own exception during nested VM-Enter.  This will be addressed
> in a future patch.
>
> Note, event priority between SMI, NMI and INTR is incorrect for L2, e.g.
> SMI should take priority over VM-Exit on NMI/INTR, and NMI that is
> injected into L2 should take priority over VM-Exit INTR.  This will also
> be addressed in a future patch.
>
> Fixes: b6b8a1451fc4 ("KVM: nVMX: Rework interception of IRQs and NMIs")
> Reported-by: Jim Mattson <jmattson@google.com>
> Cc: Oliver Upton <oupton@google.com>
> Cc: Peter Shier <pshier@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
