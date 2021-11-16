Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D8B453688
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhKPQA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238636AbhKPQAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 11:00:55 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A7EC061746
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 07:57:57 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id n85so18567482pfd.10
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 07:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mctdfT/mLWAUfvZZLvhHazXaY3Gm15pDMZVIQeirzJs=;
        b=jRvz3gtPvFWZ5WeAmF5DynWdAlHppEXPCykwNGOhANQ4d2QvZpMm0FziEYiDqg9PJ5
         XKk+6nC+XqK71O57sDxaPsuYZq/bKwyCwlVUXYP9A5W1CNFUu4XltPI/vjLdIFys1iOW
         9O7zeIAHG3s7iwvKEB3ycWW4fdccXZ/yVD9TC69Hjcl/ivd6BKPO3jyq0r39p+4HcbVL
         zUfj1U3RoNgvaft+JGK/PJVP9S4wkTDCvI5/7d+sYuhSe5r7wMxyCFB2JrXgVJJF5iae
         EEYQ69hdQVMtIKs5EX29ZgiI+RiXaj+KJFwoFKzi7kqz08jzgzcdHLGpXNjqe7VOfoPr
         2Row==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mctdfT/mLWAUfvZZLvhHazXaY3Gm15pDMZVIQeirzJs=;
        b=5LV8kBnTO+Goy8b7ZyBJNcuEU1swcoQTL7tGjfKmMc+m7yKeEAUe+HrpWBhwtE3sd0
         aGH8gjbi4saKTNELRozFKIkGH2ocRqidyI4qEpMixtgKQgOtYtY2owMxa9DVmkHP4dLY
         x5Z2Cg7oW3UyKDMSNHS6OtiUEfS3S9hRSz9marWPb7Go1NBwHBT/w74uraJ9LfcuUiyN
         Vw63tjZxybSBpwHT8IfdtG0HL/ZqxKwteBH2WzdpH4oLXQP0eMsccoHspHG5P2ekS+Sx
         WoVscmWHbvapqvjP2b9i/bfFKqEoezCS+fo2Upycx7FhNRXOQWzN/v+F8+ancLRggKnv
         qLCg==
X-Gm-Message-State: AOAM530NG6CPKwiWlmaXD91AS/lCqvBMpeGLmZ2xf6z6GJ3TXPtPtIEC
        7YnkM12WDMDNpI0rzolLyXx+3g==
X-Google-Smtp-Source: ABdhPJy3mhqLa0tkkmoYF+8en/twKJl1RoDR89VUSxeBiCMGX+MXuH8mKcqVvkbnWIizd4zB4uhPAw==
X-Received: by 2002:aa7:9d1e:0:b0:494:6dec:6425 with SMTP id k30-20020aa79d1e000000b004946dec6425mr104681pfp.83.1637078276989;
        Tue, 16 Nov 2021 07:57:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p19sm21785939pfo.92.2021.11.16.07.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 07:57:55 -0800 (PST)
Date:   Tue, 16 Nov 2021 15:57:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     =?utf-8?B?6buE56eR5LmQ?= <huangkele@bytedance.com>
Cc:     Chao Gao <chao.gao@intel.com>,
        zhenwei pi <pizhenwei@bytedance.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, chaiwen.cc@bytedance.com,
        xieyongji@bytedance.com, dengliang.1214@bytedance.com,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [External] Re: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI
 feature with AVIC
Message-ID: <YZPVAHMp+aIaEkXT@google.com>
References: <20211108095931.618865-1-huangkele@bytedance.com>
 <a991bbb4-b507-a2f6-ec0f-fce23d4379ce@redhat.com>
 <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
 <CANRm+Cze_b0PJzOGB4-tPdrz-iHcJj-o7QL1t1Pf1083nJDQKQ@mail.gmail.com>
 <d65fbd73-7612-8348-2fd8-8da0f5e2a3c0@bytedance.com>
 <20211116090604.GA12758@gao-cwp>
 <CAKUug92xp7mU_KB66jGtdYRhgQpgfCm67r+3kMOMdbrGOrTQcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKUug92xp7mU_KB66jGtdYRhgQpgfCm67r+3kMOMdbrGOrTQcA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, 黄科乐 wrote:
> > The recently posted Intel IPI virtualization will accelerate unicast
> > ipi but not broadcast ipis, AMD AVIC accelerates unicast ipi well but
> > accelerates broadcast ipis worse than pv ipis. Could we just handle
> > unicast ipi here?
> 
> Thanks for the explanation! It is true that AVIC does not always perform
> better
> than PV IPI, actually not even swx2apic.
> 
> > So agree with Wanpeng's point, is it possible to separate single IPI and
> > broadcast IPI on a hardware acceleration platform?
> 
> 
> > how about just correcting the logic for xapic:
> 
> > From 13447b221252b64cd85ed1329f7d917afa54efc8 Mon Sep 17 00:00:00 2001
> > From: Jiaqing Zhao <jiaqing.zhao@intel.com>
> > Date: Fri, 9 Apr 2021 13:53:39 +0800
> > Subject: [PATCH 1/2] x86/apic/flat: Add specific send IPI logic
> 
> > Currently, apic_flat.send_IPI() uses default_send_IPI_single(), which
> > is a wrapper of apic->send_IPI_mask(). Since commit aaffcfd1e82d
> > ("KVM: X86: Implement PV IPIs in linux guest"), KVM PV IPI driver will
> > override apic->send_IPI_mask(), and may cause unwated side effects.
> 
> > This patch removes such side effects by creating a specific send_IPI
> > method.
> 
> > Signed-off-by: Jiaqing Zhao <jiaqing.zhao@intel.com>
> 
> Actually, I think this issue is more about how to sort out the relationship
> between AVIC and PV IPI. As far as I understand, currently, no matter
> the option from userspace or the determination made in kernel works
> in some way, but not in the migration scenario. For instance, migration with
> AVIC feature changes can make guests lose the PV IPI feature needlessly.
> Besides, the current patch is not consistent with
> KVM_CAP_ENFORCE_PV_FEATURE_CPUID.
> Paolo's advice about using a new hint shall work well. Currently try
> working on it.

IIUC, you want to have the guest switch between AVIC and PV IPI when the guest
is migrated?  That doesn't require a new hint, it would be just as easy for the
host to manipulate CPUID.KVM_FEATURE_PV_SEND_IPI as it would a new CPUID hint.

The real trick will be getting the guest to be aware of the CPUID and reconfigure
it's APIC setup on the fly.

Or did I misundersetand what you meant by "migration with AVIC feature changes"?
