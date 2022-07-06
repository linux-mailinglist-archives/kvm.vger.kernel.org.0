Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164B75696A5
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 01:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbiGFXzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 19:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiGFXzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 19:55:48 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729EF2D1D4
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 16:55:47 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id t189so21647938oie.8
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 16:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XjN6GpQY4nWOSdliTg5TstOsjxKtEZmHyJPBA3SGai4=;
        b=NWmAlvx+hIMXHWO+G9Z63Eb98yhqT+8AjKLRP1akM1C/W4XpF/H/VknMGxd8Nfsdgk
         XD96M4+0V53EXEOW5Q05c/i0wA05OAnLl+3xhSK8IbfCfn06UCDJcqEHJee6r1N3FPYE
         2+1DT5CQWeMW0/3YDxqmsKfR+2PAZhw7vX2KbYDTj5JKrbDrJ3SmqltaHgEuZBBFV5Pj
         tVkzQe9TPw+SkvcMqMssC3Y5DbldxfUrHYQPtj+NB1QQnlE4tkH8qPz881PauWsSExbZ
         yL4cyXjzMqW9bYA56uFsgLNTWoArD/jIQdvBelaYoLMkmCy7v3AvK5ueEdYsm4tSXnDb
         BYQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XjN6GpQY4nWOSdliTg5TstOsjxKtEZmHyJPBA3SGai4=;
        b=qPVmd0SEFsWI59S3JiPlE8gNQV7IrAjucqnuFLZQjrgXLlp3CJCJmC14jdXaRFP3Zp
         ihftvoDTcyz9YoVEdUjuCT2YqSl6kVgJaNcn1Z+0YMLT+LjMo/VMTKr+iPRMweGy3gRy
         wG3Gx2vXUYs2rumGmC8x1tLKdQxdQhfHOJcEfQZZxCC2OPEIPEyxWX1WU+oPV9Tsz6/o
         XiFs2Vw1uiXyoKPxIy2ZBBcvl5jmxajXSaLIscEXiN80P6AJnppvO9qMSBGNEMPH60o5
         NLjTCshCQMDLfomEIWm2hp1aI7qXocqTcvY3apF9olTmLnuzjYoRWfE/OdLlmD3mlv1D
         ZQjA==
X-Gm-Message-State: AJIora9Xaf14A+zhysSEDnP3A2Qb/FuQCua0NDfAiSnNNWX0L0Ws0Flk
        mVCo0XW/eHu2k9fCmvNr7T9xPl4ssjFEh3ZFWk7XRg==
X-Google-Smtp-Source: AGRyM1u1kGENXV8nStUwrLsg/+fpiYNkh/Rih6iP+xvK5LogBHBd5af9qz8EFu3/WH8UuDYzPZFMJYK0qi2XV/mUXy0=
X-Received: by 2002:aca:5e05:0:b0:337:bd43:860b with SMTP id
 s5-20020aca5e05000000b00337bd43860bmr719740oib.181.1657151746538; Wed, 06 Jul
 2022 16:55:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com> <20220614204730.3359543-7-seanjc@google.com>
In-Reply-To: <20220614204730.3359543-7-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Jul 2022 16:55:35 -0700
Message-ID: <CALMp9eS+54W=w=0UXRvB95OprNbpte=_TDu=c9qzcY0kyRqbuQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/21] KVM: x86: Treat #DBs from the emulator as
 fault-like (code and DR7.GD=1)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

On Tue, Jun 14, 2022 at 1:47 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Add a dedicated "exception type" for #DBs, as #DBs can be fault-like or
> trap-like depending the sub-type of #DB, and effectively defer the
> decision of what to do with the #DB to the caller.
>
> For the emulator's two calls to exception_type(), treat the #DB as
> fault-like, as the emulator handles only code breakpoint and general
> detect #DBs, both of which are fault-like.

Does this mean that data and I/O breakpoint traps are just dropped?
Are there KVM errata for those misbehaviors?
What about single-stepping? Is that handled outwith the emulator?
