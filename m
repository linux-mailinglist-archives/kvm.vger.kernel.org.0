Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15EF1127F3
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 10:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfLDJmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 04:42:35 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37190 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727331AbfLDJmd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 04:42:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575452552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yeu2jri5tiEVORSR6i6yLjnJmv9GRGrMpUSNBJnPLoo=;
        b=Taai8JJOseRjyu1w+fUEQCvxKE4ytZSufR5jjTzMCzHTFJ9qKTnPIfnzPWDV6ZKmiJZXwJ
        NesxDDiv4yOa1TYL0FsErSgitSNGlhByymrQUAT0ZyNUGKHPeIMHbSYifRA9AOPqPoFzc+
        9osKgQSsSokxR6fKchCNlj7QEuv/OQ0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-lA-FD3kRNny6Hl1pQeMVgg-1; Wed, 04 Dec 2019 04:42:31 -0500
Received: by mail-wr1-f71.google.com with SMTP id o6so3364617wrp.8
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 01:42:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yeu2jri5tiEVORSR6i6yLjnJmv9GRGrMpUSNBJnPLoo=;
        b=StDkPrI++iRQP74p0JEUDljZfRRmvKvNgD/Oc0322iqzoY1tGo6fr0mDkyYzxUqTbs
         yibvtUHkrvjhv+Pa2cCHZyV1AoAQl/RJfqPVFquKLm5xDoCwrjr9PjFwnfyGRgH8C3Q0
         8QnWXtQxmgcFn5kiLwt+lGa7rkoYveDDVGunz4HHzFynQRlWSixG1hL+YR0p713FQys6
         UOP1co7eNvwBMmjYAokRZURdP68AZRRPmICmWv5re0PHda0bdXL4v6U96MoAFNAOfqC7
         Jk+rwZE9rDz4NkR5+L6l2J22lrwo6QXsJMbvRpvFW6Nlm7DHQyA4Wvfaq94rxgVo3vEU
         PF5A==
X-Gm-Message-State: APjAAAVJt95MVgWlj70qPSNr4tMPe1OzG4Ua0IIhuDcMY/939uLsQw9E
        pwlw5Dj4A73xWr8uhNreFRnFXrfvbqOBkgiErszoRXUdpI8dgN9xZexwBUTLBilftm8DR0nLoqZ
        8QcbZCW+a0VSM
X-Received: by 2002:a5d:4a91:: with SMTP id o17mr3152664wrq.232.1575452549747;
        Wed, 04 Dec 2019 01:42:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwc0V9i5e3LV/9uQON1wDN8u/+wYDBDXJVfstcq/t3k86JPELREp5McTHLyZgS2EnO20PNKuw==
X-Received: by 2002:a5d:4a91:: with SMTP id o17mr3152639wrq.232.1575452549489;
        Wed, 04 Dec 2019 01:42:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id v3sm7236647wru.32.2019.12.04.01.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 01:42:29 -0800 (PST)
Subject: Re: [PATCH RFC 01/15] KVM: Move running VCPU from ARM to common code
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-2-peterx@redhat.com>
 <20191203190126.GC19877@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a9d3301c-4c2f-9624-dc52-1033b940ef06@redhat.com>
Date:   Wed, 4 Dec 2019 10:42:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191203190126.GC19877@linux.intel.com>
Content-Language: en-US
X-MC-Unique: lA-FD3kRNny6Hl1pQeMVgg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/12/19 20:01, Sean Christopherson wrote:
> In case it was clear, I strongly dislike adding kvm_get_running_vcpu().
> IMO, it's a unnecessary hack.  The proper change to ensure a valid vCPU is
> seen by mark_page_dirty_in_ring() when there is a current vCPU is to
> plumb the vCPU down through the various call stacks.  Looking up the call
> stacks for mark_page_dirty() and mark_page_dirty_in_slot(), they all
> originate with a vcpu->kvm within a few functions, except for the rare
> case where the write is coming from a non-vcpu ioctl(), in which case
> there is no current vCPU.
> 
> The proper change is obviously much bigger in scope and would require
> touching gobs of arch specific code, but IMO the end result would be worth
> the effort.  E.g. there's a decent chance it would reduce the API between
> common KVM and arch specific code by eliminating the exports of variants
> that take "struct kvm *" instead of "struct kvm_vcpu *".

It's not that simple.  In some cases, the "struct kvm *" cannot be
easily replaced with a "struct kvm_vcpu *" without making the API less
intuitive; for example think of a function that takes a kvm_vcpu pointer
but then calls gfn_to_hva(vcpu->kvm) instead of the expected
kvm_vcpu_gfn_to_hva(vcpu).

That said, looking at the code again after a couple years I agree that
the usage of kvm_get_running_vcpu() is ugly.  But I don't think it's
kvm_get_running_vcpu()'s fault, rather it's the vCPU argument in
mark_page_dirty_in_slot and mark_page_dirty_in_ring that is confusing
and we should not be adding.

kvm_get_running_vcpu() basically means "you can use the per-vCPU ring
and avoid locking", nothing more.  Right now we need the vCPU argument
in mark_page_dirty_in_ring for kvm_arch_vcpu_memslots_id(vcpu), but that
is unnecessary and is the real source of confusion (possibly bugs too)
if it gets out of sync.

Instead, let's add an as_id field to struct kvm_memory_slot (which is
trivial to initialize in __kvm_set_memory_region), and just do

	as_id = slot->as_id;
	vcpu = kvm_get_running_vcpu();

in mark_page_dirty_in_ring.

Paolo

