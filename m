Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8DA4E77EC
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 16:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357435AbiCYPgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 11:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378499AbiCYPeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 11:34:50 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CBC17E27
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:32:13 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id bn33so10802545ljb.6
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqAwg5Oe0ABBOfGoX9y/4LgWIX2OVsyxY46msHc+wyg=;
        b=ZMIqbgNe+2ITEtw+XQ2yUO5BaYaigXz5b80FzNWyJm+UO6fQ1oEwvSR/gtJR5BbIpv
         XjzggeVYDiglIB95xRlpgMc44LMJwsLKIJV1pPRj5VO5hqc2Ev5Kbt72tNqRT+/l1sRq
         HbQ9aF0bk4OKOF9PAcs644vbkh740F3aDjn3GtBJaHd4I/PKN8hjIK3ILPBOOXOI0N2F
         stiDATdIDYZQWGB7fhE178uUw5DGydLPvzn6IoZ1wgTG9nTjFcHLTLGidvXHCHFJFN6z
         TbCHt5/lopL1PYPpJ42XD4PB19Z3/46Oz4cxbw0++NGfmca4u/zPHIjiWfvRAURuZKj6
         YtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pqAwg5Oe0ABBOfGoX9y/4LgWIX2OVsyxY46msHc+wyg=;
        b=VNC8nUQAZBfH/J2jO9unZKd3wc7vOlB4VXiHJVp+SHmSboRKZ/szgNy68XHgbqLQs5
         e/gCt5yw9K0r0EB3LBV+qU4sGiMzcxWv83aScs1UIQe4aMAF0sb1oq+0x4DcTB/mq2X4
         RB5v250id/ey1Hjze//q0UesKErc2fYMSEKSR/AI477kaCzUafma3J7qvCc8k8YCzQGb
         7hmE8EAjMz20sr5uwf3Zq78tu9ENtw05Z7t9mLXLTIRxdttX9VDnH2t2EdniwXIVwUsq
         oinpEYKkrzNMoOqFmKRnV8HB8mMwWcAduaoKnKb2J0Aom1cZTI8Ifem10Xelvja2HbQl
         b7qQ==
X-Gm-Message-State: AOAM533Ng4JVHXJ3x+4HBXqNTuQbLXjPHnto33dg0IEx7mtiwkQxnLD5
        H7dnwYals4cXZHYgpaLj0e+4jGvH718OX5bM48sM5A==
X-Google-Smtp-Source: ABdhPJw+hSmT+YBuv+j3btvbGvxRqinB1Vxe+1MI2P+uYUf5Vx5jPhvQj0/vPsEjNIJkSTGaNx/5KFlkLKziDfWBWEI=
X-Received: by 2002:a2e:1617:0:b0:24a:a6b4:40b2 with SMTP id
 w23-20020a2e1617000000b0024aa6b440b2mr974521ljd.83.1648222331100; Fri, 25 Mar
 2022 08:32:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220325152758.335626-1-pgonda@google.com> <d0366a14-6492-d2b9-215e-2ee310d9f8ae@redhat.com>
In-Reply-To: <d0366a14-6492-d2b9-215e-2ee310d9f8ae@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 25 Mar 2022 09:31:59 -0600
Message-ID: <CAMkAt6rACYqFXA_6pa9JUnx0=3vyM6PeaNkq-Yih4KM6saf6PQ@mail.gmail.com>
Subject: Re: [PATCH v2] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Mar 25, 2022 at 9:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/25/22 16:27, Peter Gonda wrote:
> > SEV-ES guests can request termination using the GHCB's MSR protocol. See
> > AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> > guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> > return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
> > struct the userspace VMM can clear see the guest has requested a SEV-ES
> > termination including the termination reason code set and reason code.
> >
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: Joerg Roedel <jroedel@suse.de>
> > Cc: Marc Orr <marcorr@google.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
>
> This is missing an update to Documentation/.
>

My mistake. I'll send another revision. Is the behavior of
KVM_CAP_EXIT_SHUTDOWN_REASON OK? Or should we only return 1 for SEV-ES
guests?
