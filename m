Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF13C16F61D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 04:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgBZDdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 22:33:06 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34314 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgBZDdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 22:33:06 -0500
Received: by mail-ot1-f65.google.com with SMTP id j16so1698091otl.1;
        Tue, 25 Feb 2020 19:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nAuQSDRahRWvh/vYkNzOtlSh60I0RAv61gNTFTFOsjs=;
        b=RJqqS7hkNae+vFD3w5QVk5o9bnNDLXSHHp1dt++J5YWq3q7h3yFv2pj54P3Y4whroz
         HcyQXYoBbEPewRaT2Fv8HCA1fg8I1buEob6QCR6uo2lGtTr23YukvZ5tykoUbJYR/pX+
         dbJ8oQSMdEm9pwu0CnwHSrHnTOp7WiB1K5Wkt56u9ihEBN758F/igzkb2srNE+GvwUdH
         OXOm+0lfUtuWt0TYYLC0wX8/VIIunY+ydePvKsHh4EAUp5LVtRue0a5JK7LHCB4GGDYu
         2tZlr5TApNnDS18QiUwO9TnJ2YJXwyKlUuAwdDpp0vu5gdrGWZWU7IRaDkpVxB1kH+md
         wtrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nAuQSDRahRWvh/vYkNzOtlSh60I0RAv61gNTFTFOsjs=;
        b=rpddsdwvu7sXv+9v+b67PxZbEHHfUCHXRjvI5dJBCCHrBsWwUL4k9I5FsCn7VLehCz
         wWJ/z+vD+9zT8/9PBN43iDGWAQhsSetBh7S8CI1YcVQIxEZG7ojPSEqckD6MaPqaKDmd
         OscWqLG9Ed0mI/ZMCCib0zJAoOtGYPXcpGZkiJ65Tj45q0awGPrvV5i2/xKMOVOurDGF
         5+NSkxOu5rdykL8a3+uDelY5rQq64oGg86ZnfyUlMV8BBkP6TA/jcebJAgoTgNkd22TM
         EjCHzn/cuflrDHYpkuLIUBZn5jdKFJJ5014kth4vCcRQrZTfM8a5MlVqkg0NW4K6hKlh
         ukXA==
X-Gm-Message-State: APjAAAWBCmToMoZ1pnA27TnT6mQvwomMRryH84uGph5Aq732n4WBDjLB
        n3ksTVGzfhKyMJNSTWrF9Vr2eIoEPxbvGuIg74RuToC4S7POFw==
X-Google-Smtp-Source: APXvYqzRAj4nyh2dngKFn6VI/cdgGnlu2Fv8iTw+DGtJVZcXcPPMQyvp8siup6ZVBQvXwVzKfhoplxgS2Uqtg3jWtD0=
X-Received: by 2002:a9d:63d6:: with SMTP id e22mr1421440otl.185.1582687984972;
 Tue, 25 Feb 2020 19:33:04 -0800 (PST)
MIME-Version: 1.0
References: <1574306232-872-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1574306232-872-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 26 Feb 2020 11:32:53 +0800
Message-ID: <CANRm+Cz0RnF=roCkJf-X8pEyVY5wH4ZgQKWv8o0Whu59t8_A2w@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Nov 2019 at 11:17, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in our
> product observation, multicast IPIs are not as common as unicast IPI like
> RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
>
> This patch introduce a mechanism to handle certain performance-critical
> WRMSRs in a very early stage of KVM VMExit handler.
>
> This mechanism is specifically used for accelerating writes to x2APIC ICR
> that attempt to send a virtual IPI with physical destination-mode, fixed
> delivery-mode and single target. Which was found as one of the main cause=
s
> of VMExits for Linux workloads.
>
> The reason this mechanism significantly reduce the latency of such virtua=
l
> IPIs is by sending the physical IPI to the target vCPU in a very early st=
age
> of KVM VMExit handler, before host interrupts are enabled and before expe=
nsive
> operations such as reacquiring KVM=E2=80=99s SRCU lock.
> Latency is reduced even more when KVM is able to use APICv posted-interru=
pt
> mechanism (which allows to deliver the virtual IPI directly to target vCP=
U
> without the need to kick it to host).
>
> Testing on Xeon Skylake server:
>
> The virtual IPI latency from sender send to receiver receive reduces
> more than 200+ cpu cycles.

Testing by IPI microbenchmark(https://lkml.org/lkml/2017/12/19/141):

Normal IPI:           Improved 3%
Broadcast IPI:      Improved 5%

w/ --overcommit cpu-pm=3Don

Normal IPI:           Improved 14%
Broadcast IPI:      Improved 3.6%

    Wanpeng
