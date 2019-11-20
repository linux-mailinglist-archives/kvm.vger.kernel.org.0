Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0431030B0
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 01:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKTAY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 19:24:56 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33552 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKTAYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 19:24:55 -0500
Received: by mail-oi1-f196.google.com with SMTP id m193so20871418oig.0;
        Tue, 19 Nov 2019 16:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zj3yLRE9mChhE9Y5QGgi6KN2BsNMSKx/IHvPGJJ4ykE=;
        b=N5ceSSCtzoVYd7iWmBRN1bNulvCxzlk98qJxo5GJC2GT0yGtml/gsqVSXUc/6f2z7B
         /B2QEx0Xb7YN83EJzchBuA/6w8aSfHAoBNSCRkriEyIaq2uGRtOV669JZUgyea2oG44I
         LqJKHxpmWlLhfTO3Rje/4Cws36BPCyGziJAjDfjypf1F+5wkEmV8GsWizJ6K0QalJ401
         n0zDibXvyF8ThW8ZkY31NOL2YM07T6UxAZprDik5ozePdBf+Sw7+KXRBmTZX16Wwm+eU
         M1SOaiCp3KItHzsk4k57Fnlz+5PqS6ngQcpe9f6FOT0DRXytQRpmtJbuvnmRRu2sLixo
         1LjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zj3yLRE9mChhE9Y5QGgi6KN2BsNMSKx/IHvPGJJ4ykE=;
        b=m2kXgQpTH7RR5lGncDu4PlvJUaTUGLPK47yIz7BlGQVfYRd00CnviHtOShG5EyNrOg
         TePe6iXS7tfBLzNnz+eFmc41M+AehTnTBOZCdDC9auqSC1npSdsATs3xRypyowZt9Gwx
         l5nIEuQHWOTFrxzTot7EezS2iZtLl1H40SWLiVezuawOB6YnzJFUsHGpyp6wdTBpgfRC
         e9lNAfv2qqCqfP0ILtCXgxKKgYojHichIYMzQvK1h+xJTDtKvComKalXN4dg5zr5Vukl
         8i7OI1wyJpRup4Go+feu39gWPtf1k5kQKPcPUohiQ2Gik9tuBEFbqL/gTX5Qqr2Iycye
         bgbQ==
X-Gm-Message-State: APjAAAV7cOdoN94eZWIG3QJtAB5IwW+iXYUsAxwiTKdBjY2g3hAiwHox
        UnKv2JO/YxBK78TNXVkfMdCJxxyolgS2MWmLFc0=
X-Google-Smtp-Source: APXvYqwYstFBjOE8Vj9Xkx2HuJs1+y/ym1TelXMeCJ9cB3n84l7i0dToEzNfAGh26gB0O2pGZVRK/wLAi2CQrcZLQcA=
X-Received: by 2002:aca:5015:: with SMTP id e21mr255434oib.174.1574209493397;
 Tue, 19 Nov 2019 16:24:53 -0800 (PST)
MIME-Version: 1.0
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com> <20191119183658.GC25672@linux.intel.com>
In-Reply-To: <20191119183658.GC25672@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Nov 2019 08:24:45 +0800
Message-ID: <CANRm+Cw6vKHnfq4G0wmKmbs63vXbVGtPBPpxZBzr1JL+HTaYGQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Nov 2019 at 02:36, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
[...]
>
> From 1ea8ff1aa766928c869ef7c1eb437fe4f7b8daf9 Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> Date: Tue, 19 Nov 2019 09:50:42 -0800
> Subject: [PATCH] KVM: x86: Add a fast path for sending virtual IPIs in x2APIC
>  mode
>
> Add a fast path to handle writes to the ICR when the local APIC is
> emulated in the kernel and x2APIC is enabled.  The fast path is invoked
> at ->handle_exit_irqoff() to emulate only the effect of the ICR write
> itself, i.e. the sending of IPIs.  Sending IPIs early in the VM-Exit
> flow reduces the latency of virtual IPIs by avoiding the expensive bits
> of transitioning from guest to host, e.g. reacquiring KVM's SRCU lock.
>
> Suggested-by: Wanpeng Li <wanpengli@tencent.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Hmm, I welcome the idea to improve the original patch, but this is too
much for me. :(
