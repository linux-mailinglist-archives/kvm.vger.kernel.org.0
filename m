Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C417376707
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 16:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhEGO2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 10:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbhEGO2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 10:28:20 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5F3C061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 07:27:20 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id l7so10475809edb.1
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 07:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U/6/Fs98j7xjLe1Hn7iMyAo3MtABQ4n40Y84F+3ysxY=;
        b=pvgTaJkZF2AaG05a0BQ6ZgH02yfB8+ljSzKIgQE3X0vZt5qcyFVP2EgFM0a5iCPxUT
         XS5v2rlOHO1IwwiQafXwiiQlhClML593nCSWwI0nGWiUxQ0/3hMy+vN+S+n8HHykT9md
         mS1jXOCk5Qg+pOItwx0C3uhkOEJBWbHKXvufCwmYZq88JGzd1RQmtwqgXY5ydnuarqU+
         izH5INass7F6e0vcM4NfPYAHiIPQHmnoWkAnUJhnu/zgBzKaw1Kp8k83fVyXiQqOaJn8
         iCrf8iFW7tMy67XT80JtHptMi6xUFmVLx3VFjawZ1lDa31ezIdqlYXcfsaPD9R0EcySG
         WiDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U/6/Fs98j7xjLe1Hn7iMyAo3MtABQ4n40Y84F+3ysxY=;
        b=YPJaz18bd3kAFvsLaii1inGEHydknwhoA36itlY2mTDHptRJiULMBTZ3DgZwGQIIwU
         oOBK4XltXEpwlCzXhDl1sWwSYlPQQJCTI4GbWr6Ynjl2gUCEU9W0cLvRwoaoBjRjcwsW
         dtslhBh5ZZSX7ck10sGKduEdsuxbzP9MCgJ5olXQhvamXBCwDLcZoP25DsIJzBn+DWGg
         /ou2XKNCemaItO6t9Fx9/PglVDNQhWef2tKrO4mwSMhUoqxfmvAGGqxpS9pS7eUbub1Z
         emQEiGZo5+UrAUGEPPUZOz4FoK4VZ5QqSF7AH2PXJl+k2a/3fH2V6ON+/eqJO4qyFZHd
         lZ8w==
X-Gm-Message-State: AOAM531oE+4Ej1vZxs7SYNelkCoCa9TZxUO9LSLsLrZ2EoN/oriahnTO
        ky3zWuxtddxwgiOl+sL3iuivX2ATsKLvtXxcoOWXKw==
X-Google-Smtp-Source: ABdhPJww9F/q8phUmIjiYHVsNktXIQgeQWrgOzOa+qi7aJciKKPJTWD+cH2g4gRNKeumkDy3/NesR3/vBs0J+Z3wgd4=
X-Received: by 2002:aa7:d4d9:: with SMTP id t25mr3835005edr.377.1620397638763;
 Fri, 07 May 2021 07:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210430143751.1693253-1-aaronlewis@google.com>
 <20210430143751.1693253-2-aaronlewis@google.com> <cuneeel4avw.fsf@oracle.com>
In-Reply-To: <cuneeel4avw.fsf@oracle.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 7 May 2021 07:27:07 -0700
Message-ID: <CAAAPnDFVR9xXEF_3_rEDhNhbe7r7QCEEiJ399Zv6h+ZUX=EfWA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +7.24 KVM_CAP_EXIT_ON_EMULATION_FAILURE
> > +--------------------------------------
> > +
> > +:Architectures: x86
> > +:Parameters: args[0] whether the feature should be enabled or not
> > +
> > +When this capability is enabled the in-kernel instruction emulator packs
> > +the exit struct of KVM_INTERNAL_ERROR with the instruction length and
> > +instruction bytes when an error occurs while emulating an instruction.  This
> > +will also happen when the emulation type is set to EMULTYPE_SKIP, but with this
> > +capability enabled this becomes the default behavior regarless of how the
>
> s/regarless/regardless/
>
> > +emulation type is set unless it is a VMware #GP; in that case a #GP is injected
> > +and KVM does not exit to userspace.
> > +
> > +When this capability is enabled use the emulation_failure struct instead of the
> > +internal struct for the exit struct.  They have the same layout, but the
> > +emulation_failure struct matches the content better.  It also explicitly defines
> > +the 'flags' field which is used to describe the fields in the struct that are
> > +valid (ie: if KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set in the
> > +'flags' field then 'insn_size' and 'insn_bytes' has valid data in them.)
>
> Starting both paragraphs with "With this capability enabled..." would
> probably cause me to stop reading if I didn't enable the capability, but
> as the first paragraph goes on to say, EMULTYPE_SKIP will also cause the
> instruction to be provided.
>

What about this instead?

When this capability is enabled, an emulation failure will result in an exit
to userspace with KVM_INTERNAL_ERROR (except when the emulator was invoked
to handle a VMware backdoor instruction). Furthermore, KVM will now provide up
to 15 instruction bytes for any exit to userspace resulting from an emulation
failure.  When these exits to userspace occur use the emulation_failure struct
instead of the internal struct.  They both have the same layout, but the
emulation_failure struct matches the content better.  It also explicitly
defines the 'flags' field which is used to describe the fields in the struct
that are valid (ie: if KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is
set in the 'flags' field then both 'insn_size' and 'insn_bytes' have valid data
in them.)

I left out the part about EMULTYPE_SKIP because that behavior is not
affected by setting KVM_CAP_EXIT_ON_EMULATION_FAILURE, so I thought it
wasn't needed in the documentation here.
