Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B91B017F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 18:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbfIKQVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 12:21:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbfIKQVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 12:21:09 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E81B356C5
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 16:21:08 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id m9so2454554wrs.13
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 09:21:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ce9f4OOYgTnzQgzT2fbA3fYovaGBeI2R32ntPEMCios=;
        b=rczh3RZQ3kigPOQeXV+SEaGDPb3cT68anbXEAucdOLF+R/PxVHcqfNQt6TMHNA9X4Y
         8b8VvCNLD0Kz9fnwzvMweOaJPU5xKBqhomb5QIf6cVQ5JHSkBHp83Ufq5GURG7bEhSqA
         ab3h6+D6Ds8nVh8CQIeN9J3tqh7J4/hOm3lUJWgpCji17CGhc/wZ+IGeOvMzSwdk+dtZ
         Y/C/bv98zWaJCabkJ4jUZvPVuQNnROnHQFzmPEGVg7yPfBknc44wkcd0I0h/+KrYQnT6
         vE5662Yi3bXF6HpMmfy/MbRetCujN9lY13oRd21XJGKNCtMkg3D19eRtNkspA2wjTRMg
         wbRQ==
X-Gm-Message-State: APjAAAV0OTSMWDsMcXply+P2E8PRPj0Sdm9idxckvp/ZNQ6cvlqmT2m4
        auwefrb8u/K/GJpfNzR/3Om6hfQ9YKdr3uZ609DWYG8FwL5ed6f253PSeJcJIXVcgSmCG/8VUyR
        VDr43WfZzhYHl
X-Received: by 2002:a5d:6088:: with SMTP id w8mr31355674wrt.31.1568218867304;
        Wed, 11 Sep 2019 09:21:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyeig3fiKbFD/2irb76FhGDExSB4zhQPOwu8+0bWzGaxac68kJ2vDPvuIelu59eKguCUVfHfg==
X-Received: by 2002:a5d:6088:: with SMTP id w8mr31355647wrt.31.1568218867078;
        Wed, 11 Sep 2019 09:21:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id h17sm5911467wme.6.2019.09.11.09.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 09:21:06 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU
 states
To:     Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
 <20190826102449.142687-3-liran.alon@oracle.com>
 <20190826160301.GC19381@linux.intel.com>
 <221B019B-D38D-401E-9C6B-17D512B61345@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <199dac11-d79b-356f-ae52-91653087cc49@redhat.com>
Date:   Wed, 11 Sep 2019 18:21:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <221B019B-D38D-401E-9C6B-17D512B61345@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/08/19 20:26, Liran Alon wrote:
> An alternative could be to just add a flag to events->flags that modifies
> behaviour to treat events->smi.latched_init as just events->latched_init.
> But I prefer the previous option.

Why would you even need the flag?  I think you only need to move the "if
(lapic_in_kernel(vcpu)) outside, under "if (events->flags &
KVM_VCPUEVENT_VALID_SMM)".

In fact, I think it would make sense anyway to clear KVM_APIC_SIPI in
kvm_vcpu_ioctl_x86_set_vcpu_events (i.e. clear apic->pending_events and
then possibly set KVM_APIC_INIT if events->smi.latched_init is true).

Paolo
