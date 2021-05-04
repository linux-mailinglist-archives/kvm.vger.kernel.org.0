Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB43B3732C6
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 01:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhEDXh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 19:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhEDXhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 19:37:55 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E842C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 16:36:59 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id u16so523111oiu.7
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 16:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ZG1nWXtzTYTaXrMK1FVDEfdYcnwUzz0W/Bp4Vm63w8=;
        b=W0/NtpO49BkFw56cUrtxd4cEfAJIY00IrrdCRRM83zOAeUgsB5GNY/mRrQ9guQ+GCu
         zt+IJvmorwCO7B/VnqnHGwHqgBURRJbU4N9fAgchjHtd3fM8mwQ3UelDSkOAA8+3qMf8
         r9JZMox/04J0poAyl2fdpSvJp4JNeW+aKECRZEie7GHgopXF8ef5KvuID8N/VIJ3vacw
         /pAZnyCOMa76HYaURuL4TrKT5xRQmbHMuP/59JFIL5CjKdSjWfNmpOhrGkgBJEeFKtJR
         3qFalKYZueX64+3yV8ur8yG1/8AgITMp2LXEsXIZN2c/2iR9N87REuOR7ayWiX89ltLq
         MGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ZG1nWXtzTYTaXrMK1FVDEfdYcnwUzz0W/Bp4Vm63w8=;
        b=lFQcDGRppcIloi7ulWnn76H1mGcpIdqKaIAyv4x5Gs51/i/O2/mkj+Cik1ySB5KDig
         LPeESx8klkR0dPgHataKXF2ADeyZ7z1cUG/td5lkWW/UFMlcXRrEL7w7lnsie0H9y2rH
         LDxIxTYvhsDof+VvWkZWnJlYzPJDTyV+DRavkC+wRMiztbqUGGbDxmzf+vMr5nbYz6EG
         ekTiPogvLcEAeggK9gKebSUwz9vaXN+Rfuddsi8iOf4khafM2nImbYAt/jeCR1Qv36Zk
         fefq1i4McA3xni8fG4bRZKDn8eESpN817nHj1SKXWSyzZLu1zmnOjMs9kSGzJq34tO6d
         KFGA==
X-Gm-Message-State: AOAM532fUpfpZPZu65ftvf8zk+k2zbTrAwdj3ql9CJ6Pf6JdfR53hjYI
        cdmDKN3kpr1iNbD3hUUabP+AoDSsiyFxGqfcrBNaTw==
X-Google-Smtp-Source: ABdhPJwn/nngurgnvemnAXyxfhI7q1jjWsE5Plk4Zrimr9wx7e+kViDLlODMMe3olSMzacxI1V8LVMwEjPJKagGUspg=
X-Received: by 2002:a05:6808:b2f:: with SMTP id t15mr4766153oij.6.1620171418015;
 Tue, 04 May 2021 16:36:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-6-seanjc@google.com>
In-Reply-To: <20210504171734.1434054-6-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 May 2021 16:36:46 -0700
Message-ID: <CALMp9eQOZyf=U=Y-4CLpB9=nBfVPjOQzcURrTAUNZyugiischw@mail.gmail.com>
Subject: Re: [PATCH 05/15] KVM: VMX: Disable preemption when probing user
 return MSRs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Disable preemption when probing a user return MSR via RDSMR/WRMSR.  If
> the MSR holds a different value per logical CPU, the WRMSR could corrupt
> the host's value if KVM is preempted between the RDMSR and WRMSR, and
> then rescheduled on a different CPU.
>
> Opportunistically land the helper in common x86, SVM will use the helper
> in a future commit.
>
> Fixes: 4be534102624 ("KVM: VMX: Initialize vmx->guest_msrs[] right after allocation")
> Cc: stable@vger.kernel.org
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
