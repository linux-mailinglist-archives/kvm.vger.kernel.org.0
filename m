Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EB11B6E41
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 08:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgDXGiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 02:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726051AbgDXGiO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 02:38:14 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D10BC09B045;
        Thu, 23 Apr 2020 23:38:14 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id j4so10638695otr.11;
        Thu, 23 Apr 2020 23:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kgtdeLLirDcYUa0WKIp40D/3j8a2GshzI0q29q+2ksw=;
        b=fRs8hN2TAI292KXDF698tVkU1H3z8WWtndsAvX0JVRnmvmxD4PzP8jZUwH9Q4t1lJH
         jLus/Nn8fmNU0c16B10UEjKz9FS+JE5cv1AU8UwED0wWJO9VNCCp8tlb5UJTl6Mp3kPA
         2DkJKMjDY/ApRqKTj73jI30+TeFDeYM7EEgfIsuMAGb4qlt03VUR5YOjnuuf9E/ShjO8
         9YfnwYOoIVDWSxFlfwV1MZa+0t1XwZxI/WFnl1llt0S1qm3VIxsBRseiuzHEDwMpfcHN
         VoBupdSwIO8x2BHGJFbUHdBNxCEkVWok1Gme0IRpc0xe2bGtb1EcBYC1vtajpLQqBdkj
         B2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kgtdeLLirDcYUa0WKIp40D/3j8a2GshzI0q29q+2ksw=;
        b=H2G3RDpH2JCyJ4r1Sndn6VRt7J5+TImM9X4lO/SLBh+6aJtw7LB21qnvITeoHKdw0u
         VtRqKDQhS00Te5KAclRFQkmoRRF/EeMqHt2qpaDPzt13usq/SyvF0MmOEIVnsEkFezvU
         CDNAyE1j6DOOqgWgC/RIHzV5wKgbxnt/fVCPzW0ymbqt897y+ZaSujlxiyMh9/iv1bxd
         oKBD06sVCFeBckD6qR9DNFCAOOtccTHGmRoP+Oo2VnoF4jtQyAzYcoHE+sK6j+BNYFFl
         5dMkYPuBMBOdGq+vtw+WBxmo8/4M6RCTEa/TxYTRMtUPy4AUrs5d1kRi8iNr4Qg2w+/r
         b+gg==
X-Gm-Message-State: AGi0PuYJntFpV7B5U1WNClNUC9xIizMP9OHpwcfb8vN49UJKC7in8xQI
        t69If6mnZTUYXnIF22mjB68Naxp1I6yW/nL8hgo=
X-Google-Smtp-Source: APiQypJgjEi9DQJcYqvaHVJii9baHVd2hXM4G2q/PMLqpVouAfVskfNaz3bT1qMAif0yzEYm72zXQ+RALcOrVeiIIyA=
X-Received: by 2002:a05:6830:20d9:: with SMTP id z25mr347333otq.254.1587710293470;
 Thu, 23 Apr 2020 23:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
 <1587632507-18997-6-git-send-email-wanpengli@tencent.com> <99d81fa5-dc37-b22f-be1e-4aa0449e6c26@redhat.com>
 <CANRm+CyyKwFoSns31gK=_v0j1VQrOwDhgTqWZOLZS9iGZeC3Gw@mail.gmail.com> <ce15ea08-4d5d-6e7b-9413-b5fcf1309697@redhat.com>
In-Reply-To: <ce15ea08-4d5d-6e7b-9413-b5fcf1309697@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 24 Apr 2020 14:38:03 +0800
Message-ID: <CANRm+CxxQ1oL0fKmnxAv739nsjDg_V7Pgkmm==7CfPQUxBHW4w@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: VMX: Handle preemption timer fastpath
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Apr 2020 at 18:29, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/04/20 11:56, Wanpeng Li wrote:
> >> Please re-evaluate if this is needed (or which parts are needed) after
> >> cleaning up patch 4.  Anyway again---this is already better, I don't
> >> like the duplicated code but at least I can understand what's going on.
> > Except the apic_lvtt_tscdeadline(apic) check, others are duplicated,
> > what do you think about apic_lvtt_tscdeadline(apic) check?
>
> We have to take a look again after you clean up patch 4.  My hope is to
> reuse the slowpath code as much as possible, by introducing some
> optimizations here and there.

I found we are not need to move the if (vcpu->arch.apicv_active) from
__apic_accept_irq() to a separate function if I understand you
correctly. Please see patch v3 3/5. In addition, I observe
kvm-unit-tests #UD etc if check need_cancel_enter_guest() after the
generic fastpath handler, I didn't dig too much, just move it before
the generic fastpath handler for safe in patch v3 2/5.

    Wanpeng
