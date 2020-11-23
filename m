Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9612C1477
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 20:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgKWTY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 14:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729265AbgKWTY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 14:24:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C957C0613CF
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 11:24:56 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id o5so24366792ybe.12
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 11:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=90VIOO1p74EA8hY3x50vda5a5ym/lg0uKWR1Pv2K87s=;
        b=O7aeyASeFshazuGL9dQApDfdOcdEwZdJP/yBudh+uGvLZckx6wJAy22iKx/QNBgWAR
         sPEGea/fCBXnbX9kLBuN+BVMU0Ie/mqn5NYcc6eyn0BxZRK6VTKku3Z5Eo4J8EkWuIiH
         OojbKP4RJnc3o/y7jYg28uaeFMehPcNfVTDGc5NLluTWaOAmw8x/VqxJDsif/lIwIk04
         BzYsV2ovSNcD6HlVp1w4jKazEmNj/OtPYXqx8clE8V5WOFuslSlj5fsrmo+hufNtLni5
         JcpOsuObzjJ8h+pZnPpqUHBk7BHt68Zng3tfCKeD6RMXABFoX/K+LJOmsTVOAllMK4qe
         JXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=90VIOO1p74EA8hY3x50vda5a5ym/lg0uKWR1Pv2K87s=;
        b=WHvbLnzyY3/mcOqeYCfqeUdHvD/+vFQD60Efcuw7EYfSJI+1yGL3f6Wnue0qvIZQaw
         guCPemU4n7PL1f0oBjX+tS1Z71iJ8O+XWBSwF1g1SjhCnGfPv2JwBnSlq3MliNeRFrMm
         ok5XcHhBrxrg0ctu8yp/SafKlosM1ElLbxKeZH885mWQiusUtl4X19xjcnhKyms2+Ipk
         Vr2CSd+7wc62+J238p4e4tQ1QpKhFPQoLA3bgsVhdUOZxskZJd9xTvN0D+FsHND0bpc7
         Eh6b1c15CYJYSM+jZ/baBcyMtXggbJoRecAbQ2j6Lo3cv0rPRpUi5IkVFgFWp8Jgc0Qb
         Q7Ow==
X-Gm-Message-State: AOAM531QI/t7pisHiqOvcPvFKq+N41Uv98IAyNyU1zB8K8/xquDdc5cw
        dvRsnU91c7M/OJ5bBDX7bhNMWveNdJU=
X-Google-Smtp-Source: ABdhPJzfvu5fgdg+Y65TRzGeZrswPyXC88UrQg3Yp0CgHwV2T0rdq3h+w5soMX3W0KFNCbduEhuOK1nUfcc=
Sender: "oupton via sendgmr" <oupton@oupton2.c.googlers.com>
X-Received: from oupton2.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:136])
 (user=oupton job=sendgmr) by 2002:a25:6945:: with SMTP id e66mr1633874ybc.319.1606159495815;
 Mon, 23 Nov 2020 11:24:55 -0800 (PST)
Date:   Mon, 23 Nov 2020 19:22:24 +0000
In-Reply-To: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
Message-Id: <20201123192223.3177490-1-oupton@google.com>
Mime-Version: 1.0
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
From:   Oliver Upton <oupton@google.com>
To:     pbonzini@redhat.com
Cc:     idan.brown@ORACLE.COM, jmattson@google.com, kvm@vger.kernel.org,
        liam.merwick@ORACLE.COM, wanpeng.li@hotmail.com, seanjc@google.com,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>On 27/12/2017 16:15, Liran Alon wrote:
>> I think I now follow what you mean regarding cleaning logic around
>> pi_pending. This is how I understand it:
>> 
>> 1. "vmx->nested.pi_pending" is a flag used to indicate "L1 has sent a
>> vmcs12->posted_intr_nv IPI". That's it.
>> 
>> 2. Currently code is a bit weird in the sense that instead of signal the
>> pending IPI in virtual LAPIC IRR, we set it in a special variable.
>> If we would have set it in virtual LAPIC IRR, we could in theory behave
>> very similar to a standard CPU. At interrupt injection point, we could:
>> (a) If vCPU is in root-mode: Just inject the pending interrupt normally.
>> (b) If vCPU is in non-root-mode and posted-interrupts feature is active,
>> then instead of injecting the pending interrupt, we should simulate
>> processing of posted-interrupts.
>> 
>> 3. The processing of the nested posted-interrupts itself can still be
>> done in self-IPI mechanism.
>> 
>> 4. Because not doing (2), there is still currently an issue that L1
>> doesn't receive a vmcs12->posted_intr_nv interrupt when target vCPU
>> thread has exited from L2 to L1 and pi_pending=true.
>> 
>> Do we agree on the above? Or am I still misunderstanding something?
>
> Yes, I think we agree.
>
> Paolo

Digging up this old thread to add discussions I had with Jim and Sean
recently.

We were looking at what was necessary in order to implement the
suggestions above (route the nested PINV through L1 IRR instead of using
the pi_pending bit), but now believe this change could never work
perfectly.

The pi_pending bit works rather well as it is only a hint to KVM that it
may owe the guest a posted-interrupt completion. However, if we were to
set the guest's nested PINV as pending in the L1 IRR it'd be challenging
to infer whether or not it should actually be injected in L1 or result
in posted-interrupt processing for L2.

A possible solution would be to install a real ISR in L0 for KVM's
nested PINV in concert with a per-CPU data structure containing a
linked-list of possible vCPUs that could've been meant to receive the
doorbell. But how would L0 know to remove a vCPU from this list? Since
posted interrupts is exitless, KVM never actually knows if a vCPU got
the intended doorbell.

Short of any brilliant ideas, it seems that the pi_pending bit
is probably here to say. I have a patch to serialize it in the
{GET,SET}_NESTED_STATE ioctls (live migration is busted for nested
posted interrupts, currently) but wanted to make sure we all agree
pi_pending isn't going anywhere.

--
Thanks,
Oliver
