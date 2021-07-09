Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371183C2BB8
	for <lists+kvm@lfdr.de>; Sat, 10 Jul 2021 01:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhGIXo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 19:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhGIXo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 19:44:27 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD527C0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 16:41:42 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 75-20020a9d08510000b02904acfe6bcccaso11140233oty.12
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 16:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ysED+EtgywRRyfLQ+jMgZLbkLHO3Z0rVx+0A/e4Ytzg=;
        b=tFpPjKDTA3iJrDRqBz6nxTTQyBPFbL2FwRHQzs2HAb5o6GCyr8TNaWBr2MgZ0Eme1C
         vtxl35fnTI+PThSA67uN57D1RMZ1oVIwDWpEJHR+kHcMJXgorPl+kH+B/GVmKb+BR5f7
         NcuGPbhXWlOPB8uetKt4vZBWq28nKT/8hPR1jBTJfoniTlvMOV1tWBRYumkkVJ0lX0P2
         66EAXOrV0jBS00w+pSYOU5P/nB0RjEID1LwVv4QLkyAnjXlky8nm0h6a+tWNk30ULfKM
         Kz8Yew6OAoLa9ZcJ/InbsjBf0Rm9evGv4WZMIrP+DNXTMFIB/o9rr4+PgHNRlJZCRkW4
         D+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ysED+EtgywRRyfLQ+jMgZLbkLHO3Z0rVx+0A/e4Ytzg=;
        b=XiYCPslIaF5nB12PIuO3ePFvb93kiBydWIvAAga7IAwMitGum3YfmBXpWpqPaIhU+5
         B2AhLaCrwohHp67wVQOiY3DLABbawmmt/JoQKJPrrTiCQ7VjKLRARgmqRw8//d+DTbS2
         BXpYxa5ZqZbCcdYRBz5jJ7frRXyqEJjAFEfDFXZSS0uJcQPQ3ozKvDYWeb8BgIf9+ecx
         7PQ/ciWfO8zX0olxU6dKF5H1dL1/nY3lWxBGjQnEYhXNN6R/diwd+tHoCqN34jcn1nN0
         nkz/JQtTN4sxQY5bqF3XR2oqxZhy7bEG5WCX0m/3VGnwa//3M4G1P1516HAPt1zw7Ksg
         sPdg==
X-Gm-Message-State: AOAM532q46PVX5JaL8iQlTUL9r/mgSb2DTkoSMDfkQE8W4DlrfF1yxsX
        Ov7AWr2NksNIfMHphy2wM7xa1yCZevGOx/VdhHJxig==
X-Google-Smtp-Source: ABdhPJwV+qcBCVXP/o5Q0wmleKQykhH+TMVEIfd10bL1GX7+58DjtfANrzTGxdvPezQ46ApF3/lJeDK0k42aVNAPdo0=
X-Received: by 2002:a05:6830:25cb:: with SMTP id d11mr24904957otu.56.1625874101788;
 Fri, 09 Jul 2021 16:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com> <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
In-Reply-To: <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 9 Jul 2021 16:41:30 -0700
Message-ID: <CALMp9eQ+9czB0ayBFR3-nW-ynKuH0v9uHAGeV4wgkXYJMSs1=w@mail.gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL state
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 9, 2021 at 3:54 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wr=
ote:
> >
> > If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
> > and reload it after vm-exit.
>
> I don't see anything being done here "before VM-entry" or "after
> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
>
> In any case, I don't see why this one MSR is special. It seems that if
> the host is using the architectural LBR MSRs, then *all* of the host
> architectural LBR MSRs have to be saved on vcpu_load and restored on
> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?

It does seem like there is something special about IA32_LBR_DEPTH, though..=
.

Section 7.3.1 of the Intel=C2=AE Architecture Instruction Set Extensions
and Future Features Programming Reference
says, "IA32_LBR_DEPTH is saved by XSAVES, but it is not written by
XRSTORS in any circumstance." It seems like that would require some
special handling if the host depth and the guest depth do not match.
