Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3C8C04E1
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 14:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfI0MMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 08:12:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfI0MMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 08:12:19 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C822A6412E
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 12:12:18 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id w8so937310wrm.3
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 05:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1BKH6Vd2y0kjt5qb+nb7wXA/qqVsC/VTzacnT15CY10=;
        b=gXX1iLE30VjKRDUsdxr68w0HNqHqcvcyKp3dBju2fDF9/qSVQ/RmoOem0GILwZk5u4
         5hplliWi2yPDZf7Rb6g/dxSt9X3gpc4KelU9Hu2nGFVaUkQ5UNZOaw/md76mczrHZgHg
         Z83wKyXaqzrP2jpc8syc9uYe0fV0QN97SiKA85u+evAuQwU4AH5EQhjLxFtmPdCM9WU2
         n8AaKTXuzsF5dnqP7nsO60ZlU6U3xIQNX25/l62UfoqP+Pj4og1fufTsXZ1Wg6o/3bW5
         uDKuW3g7T1bb9sCv/rV0rSeGI94Q0YZpDlaV6N+1NZFf6ztk8LNmcYZZwCI81H/i2aJS
         cyCQ==
X-Gm-Message-State: APjAAAXvvGU0hELKmkNHJeAJFARnJjI5aJe7wh43VTsIfbOadyAWSQLd
        nlJaRqhS96+rzA/4qj10XNzfWFGAHP1Detb0YuKQylb0Dmz9T5k3LnqaJn3bgsZw0digYiZyEJh
        rI6bOqFOlhaob
X-Received: by 2002:adf:f58c:: with SMTP id f12mr2689595wro.38.1569586337497;
        Fri, 27 Sep 2019 05:12:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxSk514eVf6BTYDMpnjdeyawo4kXOVNU56dKCoFHmvIyY7JVO1ee097ZFa9WRpTPQgMqrYSNA==
X-Received: by 2002:adf:f58c:: with SMTP id f12mr2689586wro.38.1569586337260;
        Fri, 27 Sep 2019 05:12:17 -0700 (PDT)
Received: from vitty.brq.redhat.com ([95.82.135.182])
        by smtp.gmail.com with ESMTPSA id a13sm6204997wrf.73.2019.09.27.05.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 05:12:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>
Subject: Re: [PATCH 0/2] KVM: nVMX: Bug fix for consuming stale vmcs02.GUEST_CR3
In-Reply-To: <20190926214302.21990-1-sean.j.christopherson@intel.com>
References: <20190926214302.21990-1-sean.j.christopherson@intel.com>
Date:   Fri, 27 Sep 2019 14:12:15 +0200
Message-ID: <87o8z65468.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Reto Buerki reported a failure in a nested VMM when running with HLT
> interception disabled in L1.  When putting L2 into HLT, KVM never actually
> enters L2 and instead cancels the nested run and pretends that VM-Enter to
> L2 completed and then exited on HLT (which KVM intercepted).  Because KVM
> never actually runs L2, KVM skips the pending MMU update for L2 and so
> leaves a stale value in vmcs02.GUEST_CR3.  If the next wake event for L2
> triggers a nested VM-Exit, KVM will refresh vmcs12->guest_cr3 from
> vmcs02.GUEST_CR3 and consume the stale value.
>
> Fix the issue by unconditionally writing vmcs02.GUEST_CR3 during nested
> VM-Enter instead of deferring the update to vmx_set_cr3(), and skip the
> update of GUEST_CR3 in vmx_set_cr3() when running L2.  I.e. make the
> nested code fully responsible for vmcs02.GUEST_CR3.
>
> I really wanted to go with a different fix of handling this as a one-off
> case in the HLT flow (in nested_vmx_run()), and then following that up
> with a cleanup of VMX's CR3 handling, e.g. to do proper dirty tracking
> instead of having the nested code do manual VMREADs and VMWRITEs.  I even
> went so far as to hide vcpu->arch.cr3 (put CR3 in vcpu->arch.regs), but
> things went south when I started working through the dirty tracking logic.
>
> Because EPT can be enabled *without* unrestricted guest, enabling EPT
> doesn't always mean GUEST_CR3 really is the guest CR3 (unlike SVM's NPT).
> And because the unrestricted guest handling of GUEST_CR3 is dependent on
> whether the guest has paging enabled, VMX can't even do a clean handoff
> based on unrestricted guest.  In a nutshell, dynamically handling the
> transitions of GUEST_CR3 ownership in VMX is a nightmare, so fixing this
> purely within the context of nested VMX turned out to be the cleanest fix.
>
> Sean Christopherson (2):
>   KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
>   KVM: VMX: Skip GUEST_CR3 VMREAD+VMWRITE if the VMCS is up-to-date
>

Series:
Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
