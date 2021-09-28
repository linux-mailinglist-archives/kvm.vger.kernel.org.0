Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD9B41B2F3
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 17:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241577AbhI1PcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 11:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241080AbhI1PcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 11:32:01 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7AFC061745
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 08:30:22 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id y26so55012960lfa.11
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 08:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dR8SwI7xo4O3PMMdZC16ZxBjI2bA95Vf3wk63lcfA2M=;
        b=oLE+6BTJ5k6LXPcuEw3+RcYe2XS/f5mJxXbP1VwlUDABUlzPMLhayafCLsVhkX2NqF
         WpFRgFX/2AhQHcslRSbaiUTVmtqeWR77wqGhY6fXPVo2MlcYMklHxpFc3gCUuHFGZMa1
         5vXdtqUr0EP1jiCZdwLQcHo5V2ZvbH+OdwXMX1fqCmHkwZ27q8UB1hOwMjiL6nsOK1gg
         Ee0CFm9sNd0klFbzde3PVksW/1cxH6cd2mGS03a9Z5V04qklSqZuXpdM/eXNuiQWuKe6
         CS2N4+6Jl9jqTqkXWMcKV/LLzNX7vY/pvky0ao4puIdmv2fHcq51pAmgfToDyk4kf94A
         cjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dR8SwI7xo4O3PMMdZC16ZxBjI2bA95Vf3wk63lcfA2M=;
        b=xrqNEa1zEhuMrrnhSkDlROjOf9dxMGuFw0AwGhkDFmTtpcmqDmNtjyYrm0J3SvraTO
         PVawflBRsNkH0DkDR+EQq+6HXRLL+d9HG6fMVnd+3r4Ij3GflJhpj7Z1Qp4mFHU/hxyk
         nFC8Mfi/4iUMi9QeF8x7u21EyVPDS2cGshyaD7+raOsxP/rmC0qioANDCMGakkHfwmx4
         d17BZuzDNuqBRsjaQcrAl5VZqFnn0/G5TViqduk9b+zvDYip0x4z8Kwaoj7GfXzdCObx
         cssj3I2wq0nC5kNJ0r2Kux/8STpwubMpW/H4XU1ohSW9pf82giVu4K7i+dy48dB0eCCX
         mLuQ==
X-Gm-Message-State: AOAM532GmKIcjPOwxaiedELJF4Eu1s2iVUoMWTPAvrlar8OPR7ADqsDr
        wziRYzs7mGb832r5PZ1RgOUUEQq4hGk+kHiqQ6WQzg==
X-Google-Smtp-Source: ABdhPJzOa2nUIG2Gm7CVTKgXerj2MNhXJSbSLR434OPr+oZn/BNZltUmNgmtWA03xC/qTBo8reGfdRd74MN1kz3m4GI=
X-Received: by 2002:ac2:483b:: with SMTP id 27mr6151373lft.644.1632843020212;
 Tue, 28 Sep 2021 08:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210914164727.3007031-1-pgonda@google.com> <20210914164727.3007031-2-pgonda@google.com>
 <YVMNq4wwjYZ8F7N8@8bytes.org>
In-Reply-To: <YVMNq4wwjYZ8F7N8@8bytes.org>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 28 Sep 2021 09:30:08 -0600
Message-ID: <CAMkAt6q5YbZpnDeFXeQsZcK6WtxdAuMoWqqUwURZ9KLz692MEQ@mail.gmail.com>
Subject: Re: [PATCH 1/4 V8] KVM: SEV: Add support for SEV intra host migration
To:     Joerg Roedel <joro@8bytes.org>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021 at 6:42 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> On Tue, Sep 14, 2021 at 09:47:24AM -0700, Peter Gonda wrote:
> > +static int sev_lock_vcpus_for_migration(struct kvm *kvm)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     int i, j;
> > +
> > +     kvm_for_each_vcpu(i, vcpu, kvm) {
> > +             if (mutex_lock_killable(&vcpu->mutex))
> > +                     goto out_unlock;
> > +     }
> > +
> > +     return 0;
> > +
> > +out_unlock:
> > +     kvm_for_each_vcpu(j, vcpu, kvm) {
> > +             mutex_unlock(&vcpu->mutex);
> > +             if (i == j)
> > +                     break;
>
> Hmm, doesn't the mutex_unlock() need to happen after the check?
>

Ah good catch, thanks for the review Joerg! Yes you are right this
results in calling mutex_unlock on a mutex we didn't successfully
lock. I'll fix it in the next version.
