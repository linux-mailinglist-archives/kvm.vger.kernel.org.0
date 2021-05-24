Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEC138E800
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhEXNss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 09:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhEXNsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 09:48:47 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDAEC061574;
        Mon, 24 May 2021 06:47:19 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so25238376otp.11;
        Mon, 24 May 2021 06:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KI/HnPyleu74KNvwfkl9eC4rz7vQPnZ9pyrBZUB7Oo4=;
        b=jylLaeBs6+nJZqslIGodyIwH1VzYhDm0fWQOz/CNsWFtAeOfSbp/O1yr0X9jgYRT3/
         QBen9S3CfFoUKcz1+OgU6emYz3XEnAz7+mW9FrcWRfSDCNQP8FufPtKNJv0GSSx5J2Sg
         U7/FahaQ6L7Z8z12r6M6/NGxBnr04OW08bmH1xpJIh9yhsahqhKMtLjwrJ6+cV2STk1O
         D31U/EbNxXVTvd5HNIzfGOqwkoysoOskXJh67lx2/3sjHxp/gLM5UI1mp8FvCjdQkKOM
         6K0UahVCFEeikEp7hELNCVwwnSSJfmLNGXakWPNRglXf8IoQa+8MB3wxBIAPxK6BiqfY
         IHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KI/HnPyleu74KNvwfkl9eC4rz7vQPnZ9pyrBZUB7Oo4=;
        b=JjOXBlSxRaA43hUZxvMTiQrhIvqHPiTtJH1peBU70MAw/MU/eh4D+WqdCH5ZDC7aZP
         gHg/J04KLzos0f2gbCWI2QnqvVlHc++Ma5gaMBKpEhdzjQW3i8KdDu5T2JRq9r2q7lZF
         bCve61800cCbA93Q2trC46ASGA/1vD7Ielv1zJt/0aHZmnvQGUARJqVsUka0fbcrglqY
         nHUDSC/zAraVAqzKSBGPbMTLDRG07JcLxkAxncfJxf/VcNtBWXh/74lZBlkohO8MIYeW
         4UgKr3xAEvKQmBOOyCsAuMhoY3tLmnmGW489XOnFWzfDkZ4T+eb0XzfJw6fkV5/mdIY+
         L+tw==
X-Gm-Message-State: AOAM531AH+qWn9PJKCzLcrgnGOWLF9Wkd/oDyoAFgq32q2PNCQSaNfF1
        MVOKHkX61+GQngdIaxgQQhfuSMjh05FRX+uOLCI=
X-Google-Smtp-Source: ABdhPJxsYufT0useln7Ymyca5qFh30PCg6ji3Vb7+XDICaMhVDZBcHZlBVvGDF8nVXZyEtZQ8PCWl304eT2SOQY1LiA=
X-Received: by 2002:a9d:6655:: with SMTP id q21mr17144151otm.185.1621864039105;
 Mon, 24 May 2021 06:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
 <1621339235-11131-2-git-send-email-wanpengli@tencent.com> <YKQTx381CGPp7uZY@google.com>
 <CANRm+Cy_D3cBBEYQ9ApKMNC6p0dpTBQYQXs+dv5vrFedVkOy2w@mail.gmail.com> <889a0a43-0641-70ce-d2a5-ed71bd54e59c@redhat.com>
In-Reply-To: <889a0a43-0641-70ce-d2a5-ed71bd54e59c@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 24 May 2021 21:47:07 +0800
Message-ID: <CANRm+CwES8w0=yoWO3uZ4kC-ZcMeRksQH_p3U-tYcwAvgFg4kw@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] KVM: X86: Bail out of direct yield in case of
 under-committed scenarios
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 May 2021 at 21:42, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/05/21 04:57, Wanpeng Li wrote:
> > Looks good. Hope Paolo can update the patch description when applying.:)
> >
> > "In case of under-committed scenarios, vCPU can get scheduling easily,
> > kvm_vcpu_yield_to add extra overhead, we can observe a lot of races
> > between vcpu->ready is true and yield fails due to p->state is
> > TASK_RUNNING. Let's bail out in such scenarios by checking the length
> > of current cpu runqueue, it can be treated as a hint of under-committed
> > instead of guaranteeing accuracy. 30%+ of directed-yield attempts can
> > avoid the expensive lookups in kvm_sched_yield() in an under-committed
> > scenario. "
> >
>
> Here is what I used:
>
>      In case of under-committed scenarios, vCPUs can be scheduled easily;
>      kvm_vcpu_yield_to adds extra overhead, and it is also common to see
>      when vcpu->ready is true but yield later failing due to p->state is
>      TASK_RUNNING.
>
>      Let's bail out in such scenarios by checking the length of current cpu
>      runqueue, which can be treated as a hint of under-committed instead of
>      guarantee of accuracy. 30%+ of directed-yield attempts can now avoid
>      the expensive lookups in kvm_sched_yield() in an under-committed scenario.

Thanks Paolo! :)
    Wanpeng
