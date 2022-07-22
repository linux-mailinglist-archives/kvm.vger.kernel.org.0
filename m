Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55A257E8ED
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 23:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiGVVfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 17:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiGVVfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 17:35:47 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C0FB5CA8
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 14:35:45 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id j70so6940704oih.10
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 14:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc;
        bh=9WScczfM7tLHRbQ7a/K4AEWRZApP20xQzhsemglgp/Y=;
        b=aLHUbGrR02PJ4ixgBCGa1InFsJsCBWmLb2s2PpIhGy6R5aKyboeaDnWdT3NQtekc6V
         guUdfehOHU3dYQN5slembq6V1+7iHhqE61aDtlHhYlcvIOxfMgEqx+9VlgODK5G6JwyL
         w772qBXwsgHaqQuVb7pycZ6D1xynJieCfB6vQRBrA+be1RSnYN3cD7+Jl8sCkMKaWcR1
         Lae57Ow2LzlcDbwYmpMRe0H7IsW49D8XLHXhHddViCjpEGgMbfgydUPfu/jBSMLqkFDM
         rM/AY1XdzxTerV/nYq2OpfFgNxEM6r/+RDFEOT513F82amDb7HkJoh4MXMSi+ZQF54ZC
         7TNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9WScczfM7tLHRbQ7a/K4AEWRZApP20xQzhsemglgp/Y=;
        b=6gIO2I/kL34nadhJv0pOK1ihUIMcCf8Nio9QlEZIckMtPLK5Q8sEOo6byFstrLonTD
         PFpWgBEgGlT3Sdxbn2qFqJd1F7TcRyL8V+QxsKic3EgDoaCrZg4UGst12fZCxLqK58a/
         vxKkY35UxBSL6xOZQNOLEltPd5pUtbq+r/l8KZ5YMKhJDtNDUW7RtYel1GWFnHZsuFFM
         VJhhtzmxCwYvaEG56RIyc3EMGOzETRI6r/1LOYkcRJO9Gxx06uBRV0RZPEMve+Jawszt
         AeTzdcqF7fXGd9pTlkGKzYXAp+eSOk5BirpZPq0SyLVk3bJ3fKrqsQT1sEwisWG7WRQz
         RWAw==
X-Gm-Message-State: AJIora8ZO3H2MMO7frNy15W9xffNGnYImfut3xtr9Opkzf9fKnXQaZHk
        zanfS/hJSTeVBB3bkb3zMgGRMF+W/8jyyXhJ7KxpiqxRlRRqWA==
X-Google-Smtp-Source: AGRyM1t5gcrsQUWx4KEK+HMA0HWzJU9lnY7v9J33qzIx1kJA7cVjNjW4XbO0pElZifCJQTZMaEZHTjePbIUjqSPjkUc=
X-Received: by 2002:a05:6808:1b28:b0:33a:b03e:5d1 with SMTP id
 bx40-20020a0568081b2800b0033ab03e05d1mr3893621oib.112.1658525744847; Fri, 22
 Jul 2022 14:35:44 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Jul 2022 14:35:34 -0700
Message-ID: <CALMp9eT4-hVw9Gwp00K59JstS52vidSRcV0WW5qEhJvaY6aR5g@mail.gmail.com>
Subject: RFC: The hypervisor's responsibility to stuff the RSB
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that Retbleed has drawn everyone's attention back to Skylake's
RSBA behavior, I've been hearing murmurings about the hypervisor's
responsibility to stuff the RSB on VM-entry when running on RSBA
parts.

Referring back to Intel's paper, "Retpoline: A Branch Target Injection
Mitigation," it does say:

> There are also a number of events that happen asynchronously from normal =
program execution that can result in an empty RSB. Software may use =E2=80=
=9CRSB stuffing=E2=80=9D sequences whenever these asynchronous events occur=
:
>
> 1. Interrupts/NMIs/traps/aborts/exceptions which increase call depth.
> 2. System Management Interrupts (SMI) (see BIOS/Firmware Interactions).
> 3. Host VMEXIT/VMRESUME/VMENTER.
> 4. Microcode update load (WRMSR 0x79) on another logical processor of the=
 same core.
>
> Software may avoid RSB underflow by inserting an =E2=80=9CRSB stuffing=E2=
=80=9D sequence following all of the above conditions.

KVM *does* stuff the RSB on VM-exit, to protect the host kernel.
However, it fails to stuff the RSB on VM-entry. Stuffing the RSB on
VM-entry is necessary to protect the guest if KVM has made any unsafe
changes to the RSB, such as reducing its depth. Though Intel doesn't
spell it out, the responsibility of the hypervisor on VM-entry is much
the same as the responsibility of the SMI handler on RSM.

For reference, here's the "BIOS/Firmware Interactions" section of the
aforementioned paper, referenced above:

> System Management Interrupt (SMI) handlers can leave the RSB in a state t=
hat OS code does not expect. In order to avoid RSB underflow on return from=
 SMI, an SMI handler may implement RSB stuffing (for parts identified in Ta=
ble 5) before returning from System Management Mode (SMM). Updated SMI hand=
lers are provided via system BIOS updates.

I don't really want to do this, but I don't want to be negligent, either.

Thoughts?
