Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D197A6FB5EC
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 19:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbjEHR3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 13:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbjEHR2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 13:28:55 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482C583C0
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 10:28:28 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-330ec047d3bso1180585ab.0
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 10:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683566907; x=1686158907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOloBv+gW5rRTKAGiDzwKXMnSLawFEf1w3x+USeJsAM=;
        b=x0Fn8uZ9rqBD3GI/vHVP93HlXutIX6YlzRAM+Xe+6fQKG5NceDCQ75d2ieFvWQnP6k
         m0NvdbA/+pioqcNkGTkrNK0uUl2yf817YlaZeGSROKGYpTohFgD1lsramV2AE6u2D7iA
         54atEj212tO7Km2RDbWAwvtRg8J83jXTmHQD8IOqyCIU2RdbnY33YzBpYQJiaNkxmeJp
         NuyUIP1fq29ut/5qx1+cBX9AK56dmWG6yKurTEwvZf3KYPUTursR3GcoOo0fScYNmV8r
         WH1Ux35KomncVDkyAE0QXmmnCt1HJm+J43VqLy026wsN21tfo42CvhFHMW0yJzmO33qc
         2j5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683566907; x=1686158907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOloBv+gW5rRTKAGiDzwKXMnSLawFEf1w3x+USeJsAM=;
        b=d49MjfMzPo3dF5q1lvEzE67y2KRZVrTGCim5Fh96RXSXWq9uAK2g9thuR8Szvw2X41
         R0E+HvUwUsh6qtyyXijayqb5QRTAMLfj22XCsJPDxE17Slirg7Im0my3Fr5POgEJZ1Jt
         ojB9Z/O94DcQJYOcYKvFJb+KP1ZnoIGVe8CXmwQUlI27NqQ7YVO6cBhyuhNWrke1ttj1
         mTSeGgwnMFpBSpDjfIxdnCBbInaclrmAPdjfKGCqneTlFpyaiMdAKgZdJLys1hQq+NN9
         o7sf3VBbxDDWFRGKFdqSqGAfPc4xmMJt2wIcU43kN0nBnCAkw5rAaRKJ2khX9oCVHhYL
         v/UA==
X-Gm-Message-State: AC+VfDz7l7ZAVERlZ8MTMFWAcC0rcXWgGFr1X9jbBmyiOryEanBTI/ZK
        yZNLbrRTWo6ljVy9ErqlLuyvkcqqPyiSHXYEM68mBA==
X-Google-Smtp-Source: ACHHUZ7nfpA4vyEv0Cb72GoAH9S/rgws9W8wAODBsWKd8nglDRoj+b/AqklyJoCeCYTRJsFTL6rYyUDnuuptr5He00U=
X-Received: by 2002:a05:6e02:20cc:b0:335:5c4b:2f8a with SMTP id
 12-20020a056e0220cc00b003355c4b2f8amr235833ilq.5.1683566907524; Mon, 08 May
 2023 10:28:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230504181827.130532-1-mizhang@google.com> <c9090d80-46da-ed88-bad9-5a2e6d33d77b@intel.com>
In-Reply-To: <c9090d80-46da-ed88-bad9-5a2e6d33d77b@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 8 May 2023 10:28:15 -0700
Message-ID: <CALMp9eS7KuGkMiZ-RQoYqTQ7TyzLct3OVUCuJUorkg3WBVJ3zQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Sun, May 7, 2023 at 6:54=E2=80=AFPM Xiaoyao Li <xiaoyao.li@intel.com> wr=
ote:
>
> On 5/5/2023 2:18 AM, Mingwei Zhang wrote:
> > Add MSR_IA32_TSX_CTRL into msrs_to_save[] to explicitly tell userspace =
to
> > save/restore the register value during migration. Missing this may caus=
e
> > userspace that relies on KVM ioctl(KVM_GET_MSR_INDEX_LIST) fail to port=
 the
> > value to the target VM.
> >
> > In addition, there is no need to add MSR_IA32_TSX_CTRL when
> > ARCH_CAP_TSX_CTRL_MSR is not supported in guest. So add the checking in
> > kvm_probe_msr_to_save().
> >
> > Fixes: b07a5c53d42a ("KVM: vmx: use MSR_IA32_TSX_CTRL to hard-disable T=
SX on guest that lack it")
>
> I wonder it's the fix for this commit.
>
> Apart from this,
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

I concur.

How about:

Fixes: ea732b38b341 ("KVM: vmx: implement MSR_IA32_TSX_CTRL disable
RTM functionality")

Reviewed-by: Jim Mattson <jmattson@google.com>
