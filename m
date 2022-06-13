Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D5E54A084
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 22:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350037AbiFMU4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 16:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348973AbiFMUzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 16:55:48 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C027B278
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 13:28:25 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id bl34so9150793oib.1
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 13:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F1BsEzeoJMGJfvvWlT/Yu0nVhqbd5OzaqJq8yfmd928=;
        b=JE0WnPM6vgb2044eluqDd1QRq5BRoZM06OJVAu+pqiZAxQBntiuabuVIEJzTs29mq0
         LuWHt3nNEIguHoHF7n2TRWK8oxP49PJzX8zigOUmK/fufogl0VpOd/FSJhPcY9uVaBqC
         fFK6/zI+CTG48d48ohqGB+XgxBJ8bgy0GeIkBoHTddeBxaOsJVNfyINcbEjSj8tHY69G
         WViB6Ggo6eNlW1YLG1HkDKHj4dyBYBV2fMdGJItoNPdU+1XkzVNwAGH/OiwvR3mUClQl
         ovNg/5deQcZtwWLI0KZl/J4j2rCcyF70dcUGmybFGp3xv31hD2bETZFxAUK5cBqrcUoc
         TXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F1BsEzeoJMGJfvvWlT/Yu0nVhqbd5OzaqJq8yfmd928=;
        b=mKZh2/tXV6TKW33BNpyDQA69CPZXc2j9rpdtNu4ypOcFcms3+YRUmPox1sLpDIAeAh
         LwX15TIHg+EB0oM6aJMMmKKMGqhSfh5ZqvoP9/IFga+3NArdpADIB0Hm+qserpa3eHFv
         BVy/jlXpSeO5VSJ51Dmv7IUqqBFUq3VA5zgHhQ+dVvxo5b4SHxnY5So+MgLYOpGdz8ys
         MQd8lGBZ6311MlDHkbauYoeVgsnek/gRCWHTIgM1Kd9c1m39bFueS+cNsfa8kmJd1zXD
         dEqXOyniNXOuDBXGSZ+xuaaVMv8M/2guHzwj7tJ2C1chrQE71aRJaNwPKdJgAd49Dnyd
         f+Qw==
X-Gm-Message-State: AOAM532ChAbxzeA2nSVq7k2yUyT7GkQjc4pzQxJxsltAHmNs4y2GF/+X
        wFRUN8CW6UG8yLZWgW+r+0h3YUr+tdZvWkCU+VL0og==
X-Google-Smtp-Source: ABdhPJwb061Tr8q4AswjXAIT3ltkV7Vxsykz1cnTDu6h03hM4CDgmE8X8tOldoAZyk7w/HTImFqlver27uiqFjBKnZ0=
X-Received: by 2002:a05:6808:1189:b0:32b:7fb5:f443 with SMTP id
 j9-20020a056808118900b0032b7fb5f443mr268221oil.269.1655152104815; Mon, 13 Jun
 2022 13:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
 <161188100955.28787.11816849358413330720.stgit@bmoger-ubuntu>
 <CALMp9eTU5h4juDyGePnuDN39FudYUqyAnnQdALZM8KfiMo93YA@mail.gmail.com>
 <5d380b11-079f-e941-25cf-747f66310695@amd.com> <CALMp9eRnC1RgRwj64TJcXdhhL6g835N_-E8FbeHVre6aX=18-A@mail.gmail.com>
 <17a3d97e-3087-e79a-120d-b4a45f6c4fba@amd.com>
In-Reply-To: <17a3d97e-3087-e79a-120d-b4a45f6c4fba@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 13 Jun 2022 13:28:13 -0700
Message-ID: <CALMp9eT1_G1yp30K=DqEUsV=yK_w9KoU_ANnSPq4ueqzBTkLZw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, peterz@infradead.org, seanjc@google.com,
        joro@8bytes.org, x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com
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

On Mon, Jun 13, 2022 at 1:16 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:

> Ah, yes, I get it now. I wasn't picking up on the aspect of running older
> KVM versions on the newer hardware, sorry.
>
> I understand what you're driving at, now. We do tell the hardware teams
> that add this type of feature that we need a VMCB enable bit, e.g. make it
> an opt in feature. I'll be sure to communicate that to them again so that
> this type of issue can be avoided in the future.

Thank you so much. Might I also ask that new features get promptly
documented in the APM?

It took us an incredibly long time to figure out why just one vCPU
thread would run slow on every GCE AMD instance. It wasn't always the
same thread, but the slow vCPU thread would still be slow even after
live migration. On a guest reboot, the slowness might migrate to a
different vCPU thread. How bizarre, right?

It turns out that, on UEFI-enabled images, one vCPU makes an EFI
firmware call, which sets IBRS. You can't see that IBRS is on from
within the guest, but it is, because of the sticky first non-zero
write behavior induced by virtual SPEC_CTRL.
