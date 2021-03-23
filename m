Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9005B3456EC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 05:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCWEmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 00:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhCWEms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 00:42:48 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC317C061574;
        Mon, 22 Mar 2021 21:42:47 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u9so24916981ejj.7;
        Mon, 22 Mar 2021 21:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UVoLGy/DVv4s3pk1Yx0FAlEBZbJ1Lb3xlELXdAaEJ4o=;
        b=oS6j9qlosT6UYmptAOm2kR79KEtyJGQHD0LiZ30pp5+HtiH4HN+Ogf5pW8zil3Uzo/
         CGAus0vUSy78xgNyrDWGM7DxpakafPg7xBt7Dxk4xwp0OpNkhsxTsJQtxaRQ/+KkMl55
         De3Qpry+UT/n8i8mOLROa7HH4kZfSMhoSB4YVr9deZT/nQ6DhpuAe9B4IYxWMxa5AA4b
         co+PRn0/Ac2OaUlKbLo38pJG/rOLZrV53PgZZN/IBgPgUpIwKbjUsAHbBoQEckPHh8oN
         AiBf8GELpAZifndYswSqR1EUeu5DSUfOl23Lznuvth34AAdjtB5Kt0ckguLn05g8Gpfu
         zaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UVoLGy/DVv4s3pk1Yx0FAlEBZbJ1Lb3xlELXdAaEJ4o=;
        b=p3ViGSju4n42trR6NebxSo6Rp1bjwpP7c8GZL2er16HJ5zrI45B9EDSEYSkzya+jUd
         agvFn8OhG01vzldJ0APmT39MyHe7NmgwUUrXmxilaij41o/Y9pdOr2+QCKX6+veCHyJ6
         i2GIFzYarY9aOLfgsm+29bwIRy8qUXepWeWJ+8SJBAD+QoV+rAkPidPhRA04EsZzgwMU
         ZmY7N78ce/660LZ1isjsYRACGRvB0E09r21mAJqSjURh1Hl9xJ513ay64z+6BzToTusl
         kcwep9UbrfHYJdH7IJBFfaCCEtFMESc+YpsBOYCt3G2bcpJlwLUc5O10ryEL5aMXDMzW
         4lsw==
X-Gm-Message-State: AOAM531hncL/Nfr6GxGdPGfYh60VWu0RcRBo2XakwNh0ldxwY+PTWHG4
        QHvWE79OPgYNvAmQsuayNfwjX+QFFsti5al1zQ==
X-Google-Smtp-Source: ABdhPJzCBJImaAQzKd14Mn+lFtSInQcKqNqdsSb9+PGoZ7nJa047HAGSUuqmEnHvRXC1oWR34cswPMvlgZnlnDjW4Fg=
X-Received: by 2002:a17:906:f210:: with SMTP id gt16mr3013315ejb.206.1616474566427;
 Mon, 22 Mar 2021 21:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210323023726.28343-1-lihaiwei.kernel@gmail.com> <CALMp9eST+qAnXLpzPpORn6piVMNi3xY=P0KmP-cKixtCNAOH9Q@mail.gmail.com>
In-Reply-To: <CALMp9eST+qAnXLpzPpORn6piVMNi3xY=P0KmP-cKixtCNAOH9Q@mail.gmail.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Tue, 23 Mar 2021 12:42:11 +0800
Message-ID: <CAB5KdOb+rwsP0Pf_=_OmQYq94+V0FjqWB0uOA4V1MdUpPd7Rtg@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Check the corresponding bits according to the
 intel sdm
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 11:16 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Mar 22, 2021 at 7:37 PM <lihaiwei.kernel@gmail.com> wrote:
> >
> > From: Haiwei Li <lihaiwei@tencent.com>
> >
> > According to IA-32 SDM Vol.3D "A.1 BASIC VMX INFORMATION", two inspections
> > are missing.
> > * Bit 31 is always 0. Earlier versions of this manual specified that the
> > VMCS revision identifier was a 32-bit field in bits 31:0 of this MSR. For
> > all processors produced prior to this change, bit 31 of this MSR was read
> > as 0.
>
> For all *Intel* processors produced prior to this change, bit 31 of
> this MSR may have been 0. However, a conforming hypervisor may have
> selected a full 32-bit VMCS revision identifier with the high bit set
> for nested VMX. Furthermore, there are other vendors, such as VIA,
> which have implemented the VMX extensions, and they, too, may have
> selected a full 32-bit VMCS revision identifier with the high bit set.
> Intel should know better than to change the documentation after the
> horse is out of the barn.

Got it, thanks.

>
> What, exactly, is the value you are adding with this check?

I did this just to match the sdm.

--
Haiwei Li
