Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792DBA4CD4
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 02:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbfIBAdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Sep 2019 20:33:39 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44610 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729098AbfIBAdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Sep 2019 20:33:38 -0400
Received: by mail-io1-f65.google.com with SMTP id j4so25819160iog.11
        for <kvm@vger.kernel.org>; Sun, 01 Sep 2019 17:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4szSGdWikTSvfOlI2VSMhNFPkInN3a4Sa5iwdd297vE=;
        b=QNUDWgyNwQFlmBpUzkoV+pRB7ik1Bvw92k31hlI8WxPiECjPvKBrH96TImrfhAbdXJ
         WMUTQUxj3qbQnqvCLx2HS2BQgR8wEw3Yy6fEozxraY87X4cRFLsBtyu+c9aM/lvraLY2
         4bwgMFl21HyDqZ0Pvk1xmUZ8DXL0DzflDCwLsaNdZDylCBfAN4kODmHXDSt8qYzhlSIC
         1vgBtrQUso7XWBmr8elYb8haMzwj5gTF9OOCFecksmySeHQaNoPX+lh3uzI+UzOZGRgW
         u0CWmlg4ac/rAn9T6Xjx65BcQS6PsqMBpXpYRoFxtRFUj56vJjA8JK5G8oVFYMoobT+Z
         IURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4szSGdWikTSvfOlI2VSMhNFPkInN3a4Sa5iwdd297vE=;
        b=T2KxpmMW9lqRmsx16CU3K/ju6tUvRUYmruW8SLRXYtkPh08k9SutmTTV5aGpJk3vS/
         rLkthFzS0lOvdTyrjXuheCuRf+LrNQ4IGu41q3J75CbD6Fg+GhAJd9D3cWi9YQKYfX7Z
         Pe24fLKMf1Ok+5wbS31Xbdtl2ip0vqsrfdFtf+cu1DPk4gpbLJA2lggWYpyNu2SX1JZM
         HFr88YkwGs6kgqrejDf+bjRCAbk6v82P0RYm+CEQeiiH5LQyqz6zdkXb2/89ZO6RFXjg
         LPfcb8utwFZbaFT9whFMMf9hwv2S6ZNdJ9bvNj8kgPyVmdwaPY4FZPXIzDfAHHsZm+ry
         RscA==
X-Gm-Message-State: APjAAAUBapzjsowmvrqj8UozEn50qooPHcQCMc87PJlYT5hhsnIMIiXs
        i6o8OsNajJmRNRDeDTF0bGCVBLI5az929bd5dDNhCEXcXl/lyg==
X-Google-Smtp-Source: APXvYqz1O7R8GI0cupa8enIScd9mHNEHiZjvk0Omn818jMEuN1iYvpg40xbtehviZu7756oXdfTGrvZ+u8Ur6ATAF70=
X-Received: by 2002:a5d:8f9a:: with SMTP id l26mr14383017iol.26.1567384417863;
 Sun, 01 Sep 2019 17:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com> <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
 <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com> <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
In-Reply-To: <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sun, 1 Sep 2019 17:33:26 -0700
Message-ID: <CALMp9eRWSvg22JPUKOssOHwOq=uXn6GumXP1-LB2ZiYbd0N6bQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 4:15 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Aug 30, 2019 at 4:07 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
> >
> >
> >
> > On 08/29/2019 03:26 PM, Jim Mattson wrote:
> > > On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
> > > <krish.sadhukhan@oracle.com> wrote:
> > >> According to section "Checks on Guest Control Registers, Debug Registers, and
> > >> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> > >> of nested guests:
> > >>
> > >>      If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
> > >>      field must be 0.
> > > Can't we just let the hardware check guest DR7? This results in
> > > "VM-entry failure due to invalid guest state," right? And we just
> > > reflect that to L1?
> >
> > Just trying to understand the reason why this particular check can be
> > deferred to the hardware.
>
> The vmcs02 field has the same value as the vmcs12 field, and the
> physical CPU has the same requirements as the virtual CPU.

Actually, you're right. There is a problem. With the current
implementation, there's a priority inversion if the vmcs12 contains
both illegal guest state for which the checks are deferred to
hardware, and illegal entries in the VM-entry MSR-load area. In this
case, we will synthesize a "VM-entry failure due to MSR loading"
rather than a "VM-entry failure due to invalid guest state."

There are so many checks on guest state that it's really compelling to
defer as many as possible to hardware. However, we need to fix the
aforesaid priority inversion. Instead of returning early from
nested_vmx_enter_non_root_mode() with EXIT_REASON_MSR_LOAD_FAIL, we
could induce a "VM-entry failure due to MSR loading" for the next
VM-entry of vmcs02 and continue with the attempted vmcs02 VM-entry. If
hardware exits with EXIT_REASON_INVALID_STATE, we reflect that to L1,
and if hardware exits with EXIT_REASON_INVALID_STATE, we reflect that
to L1 (along with the appropriate exit qualification).

The tricky part is in undoing the successful MSR writes if we reflect
EXIT_REASON_INVALID_STATE to L1. Some MSR writes can't actually be
undone (e.g. writes to IA32_PRED_CMD), but maybe we can get away with
those. (Fortunately, it's illegal to put x2APIC MSRs in the VM-entry
MSR-load area!) Other MSR writes are just a bit tricky to undo (e.g.
writes to IA32_TIME_STAMP_COUNTER).

Alternatively, we could perform validity checks on the entire vmcs12
VM-entry MSR-load area before writing any of the MSRs. This may be
easier, but it would certainly be slower. We would have to be wary of
situations where processing an earlier entry affects the validity of a
later entry. (If we take this route, then we would also have to
process the valid prefix of the VM-entry MSR-load area when we reflect
EXIT_REASON_MSR_LOAD_FAIL to L1.)

Note that this approach could be extended to permit the deferral of
some control field checks to hardware as well. As long as the control
field is copied verbatim from vmcs12 to vmcs02 and the virtual CPU
enforces the same constraints as the physical CPU, deferral should be
fine. We just have to make sure that we induce a "VM-entry failure due
to invalid guest state" for the next VM-entry of vmcs02 if any
software checks on guest state fail, rather than immediately
synthesizing an "VM-entry failure due to invalid guest state" during
the construction of vmcs02.
