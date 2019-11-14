Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8F1FBE32
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 04:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfKNDMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 22:12:30 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34913 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfKNDM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 22:12:28 -0500
Received: by mail-ot1-f67.google.com with SMTP id z6so3629642otb.2;
        Wed, 13 Nov 2019 19:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5OyV8nm4c+8EwNXMO4wd5EnSMUz5BFLyuPaD1PISKYA=;
        b=U/8aGNd6CqCqR41sMylYXTumF/M/T9oZFyBCeqDGaQIL9LFqy/FDaeX5v4LuJjBcof
         p0t4CnImcc5A2M6M/qAn8pUunqYUr6RSGH1tLWnXZ1oBPASvHpAib9RUmfNDZeh4ph4m
         lW0mseTnnJX1Fy+NaooR8WicOMriD8b185z4LbxKELnEbkLLrH/EHD6kylocdb3m1bNp
         CDM27IcUt7bJa80IuK2NK6AZmDLuxqqnfpMiLIn5QJwuYX/jWH/pS26lams+UFDjq5kD
         j181wcs12UAlGRWXjIPLA7cs4uBi+aXZnv5zUXZaFQPEbMrLChdNWckVhR+Xlf5TIKu0
         aybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5OyV8nm4c+8EwNXMO4wd5EnSMUz5BFLyuPaD1PISKYA=;
        b=Mn2BrskDOuIx3pzUyrXhSu9k5sznmW4AMOuhBO6R37Crv9v3PYWiDJvGdITzmx/+n/
         iBSaTSyGAsHgftUHXBUZvDtGo3jvFnKbJwRCnDjJSHK/iRPFrDyYUj3VUSQyECjzxA/C
         WrxhWadbEaIAGqZP4qqOXZTPrakRyUy8nktnt5VRer31jwikVgfO+sCNhnOQO9YNIMeL
         JGZBDqb4kE5DcTNPpH3YCgzcTmURcuGfs5JVgnJDMgqUvbBo3dWrSlZonRTnUpqyrt53
         QUYEADVjQAT2NdMRWw/wWBC0mUbKZhuwZafP5uh1JQ4JufPZoNJnX95H8K04/EoZE4jD
         n7qg==
X-Gm-Message-State: APjAAAVgUtPDtg6y27RRBEtNfyubfMnVvEb66bzZsBj7mK16HnjlaHZG
        IhItCDMfjM3+JrW+TajeQGNLq1JnAMxpdJmLwEI=
X-Google-Smtp-Source: APXvYqzYF8zGpMujc6l530oc/eNxy+Z0KByXWKH7T7Shx0NQ84GEE8kWIC+lE6MAjozmASXYfNM5UJ2timNTiA+vJGo=
X-Received: by 2002:a05:6830:1d8b:: with SMTP id y11mr5277603oti.45.1573701147527;
 Wed, 13 Nov 2019 19:12:27 -0800 (PST)
MIME-Version: 1.0
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
 <4418c734-68e1-edaf-c939-f24d041acf2e@redhat.com> <CANRm+CzK_h2E9XWFipkNpAALLCBcM2vrUkdBpumwmT9AP09hfA@mail.gmail.com>
In-Reply-To: <CANRm+CzK_h2E9XWFipkNpAALLCBcM2vrUkdBpumwmT9AP09hfA@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 14 Nov 2019 11:12:17 +0800
Message-ID: <CANRm+CzJ+kiVohGE=nPVw3fGUqHWyeW0hkSs2nA-Quwok8qn1w@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Nov 2019 at 09:33, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Tue, 12 Nov 2019 at 05:59, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 09/11/19 08:05, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > This patch tries to optimize x2apic physical destination mode, fixed delivery
> > > mode single target IPI by delivering IPI to receiver immediately after sender
> > > writes ICR vmexit to avoid various checks when possible.
> > >
> > > Testing on Xeon Skylake server:
> > >
> > > The virtual IPI latency from sender send to receiver receive reduces more than
> > > 330+ cpu cycles.
> > >
> > > Running hackbench(reschedule ipi) in the guest, the avg handle time of MSR_WRITE
> > > caused vmexit reduces more than 1000+ cpu cycles:
> > >
> > > Before patch:
> > >
> > >   VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
> > > MSR_WRITE    5417390    90.01%    16.31%      0.69us    159.60us    1.08us
> > >
> > > After patch:
> > >
> > >   VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
> > > MSR_WRITE    6726109    90.73%    62.18%      0.48us    191.27us    0.58us
> >
> > Do you have retpolines enabled?  The bulk of the speedup might come just
> > from the indirect jump.
>
> Adding 'mitigations=off' to the host grub parameter:
>
> Before patch:
>
>     VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
> MSR_WRITE    2681713    92.98%    77.52%      0.38us     18.54us
> 0.73us ( +-   0.02% )
>
> After patch:
>
>     VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
> MSR_WRITE    2953447    92.48%    62.47%      0.30us     59.09us
> 0.40us ( +-   0.02% )

Hmm, sender side less vmexit time is due to kvm_exit tracepoint is
still left in vmx_handle_exit, and ICR wrmsr is moved ahead, that is
why the time between kvm_exit tracepoint and kvm_entry tracepoint is
reduced.  But the virtual IPI latency still can reduce 330+ cycles.

    Wanpeng
