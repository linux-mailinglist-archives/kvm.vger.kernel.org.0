Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A807561DCF
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbiF3OXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiF3OWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:22:12 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2796B264
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 07:05:35 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id j15so9029873vkp.5
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 07:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/U/mkkXuvUzhtldzXstVOCwXdZiwLEMR3JjS1TBXjxw=;
        b=p3sUogtXJGGFvnOxm2FYtij4BHfWcsq3LPvrta1R3LOtVy7aiv1WBVYCWylzgpc/Y/
         o89fb+7T3fyhyXfZwi3c4oP3oAgBH5oJ38o8zmzf2wFH93PZykG68Mt/Ca4aj1tHfoGV
         nK0kz9AZAP2MJLIUFuliFWf7zfmSz7dgM5sCi+vPSjqCvUKy1WmF1br2ws64kp21gHkI
         vuLtokdOKnINFyUDHfya3YpF4/wy/SNNLoyLKqWTRH7q0HXI4FMlTdhLPZAKVu+Wel3V
         runGc1a2nOXOp/8XlRdifY1dhqUod23Xq95EaOiqbKKBqRiOJEhOLXds84RilD4choR1
         4YqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/U/mkkXuvUzhtldzXstVOCwXdZiwLEMR3JjS1TBXjxw=;
        b=3pSS9SfdNK81yawx9yokoT6UjRj/uZF3iOP/6tTOr5r91h6lhRxiD75F5nwqLaxKWv
         sC0oetV/WaJaVQKRXRzVMFvyKMbTunLjScdQN3IGGvFWy3viMekcwccCTCwjnrSv6dVY
         mouuUf+HgKMGqeuPhyI1dm1UQrTiT0YwYCQcTFCvlJ4gCgVfW3S/ZT+P8dhcRUcYUxtg
         mNmYzQAw9ZzBGGqITw2RhX6xWHyO04Q6KlSOwDcYlrA0RLipIm50WzKpHyyiU74wja2F
         Yd7svnvWzKgcdDAsgeKAbV007V0l27JBGkcDEvDKWus6CfjvuQOm/Oh9uY0sVsSOqV+M
         tE3g==
X-Gm-Message-State: AJIora+JH+o6/54f9Pj0X2SUBvunx6YuTkmpBtO1L+fzUciYL3fSNXg8
        zATQoyl97PDniSQqKQsjR5jgCGxgsvtctE6FiRQtPQ==
X-Google-Smtp-Source: AGRyM1sR1OyBUWl2tb/e7ziZ7Z1dq2HirLBD4w5/cirv+fMOXdA0wzmSs2KVe7ihYpsFNpiB/Sjy8BqHpg2sYpBL7Xw=
X-Received: by 2002:a1f:5f45:0:b0:36b:fda2:2db4 with SMTP id
 t66-20020a1f5f45000000b0036bfda22db4mr7489689vkb.22.1656597933986; Thu, 30
 Jun 2022 07:05:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220610171134.772566-1-juew@google.com> <33bda32a-9342-2f5d-b8ee-8a92c4be592b@intel.com>
In-Reply-To: <33bda32a-9342-2f5d-b8ee-8a92c4be592b@intel.com>
From:   Jue Wang <juew@google.com>
Date:   Thu, 30 Jun 2022 07:05:22 -0700
Message-ID: <CAPcxDJ6UF8NTVtVKY_rkQyJCQaQ_GNWb0ew5xzmW_UNAJxzAcQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] KVM: x86: Add CMCI and UCNA emulation
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Jun 30, 2022 at 6:48 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 6/11/2022 1:11 AM, Jue Wang wrote:
> > This patch series implement emulation for Corrected Machine Check
> > Interrupt (CMCI) signaling and UnCorrectable No Action required (UCNA)
> > error injection.
> >
>
> It seems the main purpose of this series is to allow UCNA error
> injection and notify it to guest via CMCI.
>
> But it doesn't emulate CMCI fully. E.g., guest's error threshold of
> MCi_CTL2 doesn't work. It's still controlled by host's value.
>
Both of the above points are correct.

In fact, this series does not enable injecting corrected errors into a
KVM guest at all, for:

1. It is not necessary since corrected errors are transparent to
software executions (host / guest).
2. Corrected errors can be fully managed on the host side (monitor, re-act).
3. Prevent guest initiated row-hammer attack based on the injected
corrected errors feedback loop.

Thanks,
-Jue
