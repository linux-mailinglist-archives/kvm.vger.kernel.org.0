Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127EE218C8C
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 18:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbgGHQIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 12:08:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22386 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728148AbgGHQIb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 12:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594224509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QZSDpxKOQ0yOTVRj+Axry1+tC2WUTV/cuuz+l9MDwuY=;
        b=fCHJUUIUxs8Fv8sijaf80wvMH1lmM8Hg91ORELncthKfyUnzCZbcoQpzN4u1tpHMrMY+7t
        27i6yhWLUQWszZ4GAuHt30ohR6vubtorLL93wBvj0P4IwJFyIUjeGm9jDvI2kqZFmCIbEY
        OZe0ToC7FZVegwbx1BBef6LndEB3gAM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-Yf8J89FNN8eCORZM22z_LQ-1; Wed, 08 Jul 2020 12:08:28 -0400
X-MC-Unique: Yf8J89FNN8eCORZM22z_LQ-1
Received: by mail-wm1-f72.google.com with SMTP id q20so3463320wme.3
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 09:08:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QZSDpxKOQ0yOTVRj+Axry1+tC2WUTV/cuuz+l9MDwuY=;
        b=bt96iXZPUBuNRDWccTSLf1gutuSwA8bdN46L0+/lcPr8u13HvWJphji4Sb57jSf+tQ
         wAAObXqRxv3QAvxQF5RQDCmUdi8fQRSCYiw/6dv0O/qZNYDtaSrqiefZBcEqfclkGSsK
         7IcdcG7Ony3IDYj1kFjIP4+Vn8pddhJrZkdCkHUB68MTV4UMoMY10FByljZ0GAHXlaW3
         Lgbks579OzHfhvJQQkGt5zyK6fCoQo7x80sl9zspYnP6E0Qy4diMGfCfnR8TbPTAtGKR
         EwSNRb1jZdf4kEXzbNcjctFBSQN4IM2EC+khJpP5WktQVO1GKm1cG+uXE0fBTkbIHbVH
         la1A==
X-Gm-Message-State: AOAM531eYW0q6JLBIDoGSsEzHNr8JF3McVBW5MjSD0s9f0wOsDfvJJyW
        BuE81UQNcVp8arozRnBDjSFXJpR3Y+EZ4FPLV32yL6UB1DcApBQEJ0KNssvKXjbh+U9Sm7Rd4Fj
        54mQ1JbYAE49k
X-Received: by 2002:adf:fcc5:: with SMTP id f5mr65603663wrs.60.1594224506661;
        Wed, 08 Jul 2020 09:08:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqKSJr8ibioW1br16E1Hf04bVWkkD77b2kENKarTRGxFcP4HOD57BkyKpaoACvIO6h8v5JXQ==
X-Received: by 2002:adf:fcc5:: with SMTP id f5mr65603644wrs.60.1594224506445;
        Wed, 08 Jul 2020 09:08:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id m16sm743942wro.0.2020.07.08.09.08.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 09:08:25 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
Date:   Wed, 8 Jul 2020 18:08:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200703025047.13987-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/20 04:50, Sean Christopherson wrote:
> Introduce a new capability, KVM_CAP_MEMSLOT_ZAP_CONTROL, to allow
> userspace to control the memslot zapping behavior on a per-VM basis.
> x86's default behavior is to zap all SPTEs, including the root shadow
> page, across all memslots.  While effective, the nuke and pave approach
> isn't exactly performant, especially for large VMs and/or VMs that
> heavily utilize RO memslots for MMIO devices, e.g. option ROMs.
> 
> On a vanilla VM with 6gb of RAM, the targeted zap reduces the number of
> EPT violations during boot by ~14% with THP enabled in the host, and by
> ~7% with THP disabled in the host.  On a much more custom VM with 32gb
> and a significant amount of memslot zapping, this can reduce the number
> of EPT violations by 50% during guest boot, and improve boot time by
> as much as 25%.
> 
> Keep the current x86 memslot zapping behavior as the default, as there's
> an unresolved bug that pops up when zapping only the affected memslot,
> and the exact conditions that trigger the bug are not fully known.  See
> https://patchwork.kernel.org/patch/10798453 for details.
> 
> Implement the capability as a set of flags so that other architectures
> might be able to use the capability without having to conform to x86's
> semantics.

It's bad that we have no clue what's causing the bad behavior, but I
don't think it's wise to have a bug that is known to happen when you
enable the capability. :/

Paolo

