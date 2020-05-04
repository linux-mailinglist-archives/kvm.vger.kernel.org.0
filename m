Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A281C4A95
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 01:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgEDXtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 19:49:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24818 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728192AbgEDXtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 19:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588636149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZkeyqFAL3/DJbDVDMhDFSBl4H5QRa6a+zc27WJ/8Chw=;
        b=CgtScQaYceYJEHHcGZQDrpDq9TQzIizrLwrJQ8gDEKlwJGl2m3I+4r1g/R7lodfYjZ5wjb
        cKs5IZneTswryRaxqh2drYduKKx4oNtK3QJH1dfulEoS0diBdo6M4BnTjZPvvY4i0pyIvD
        M2xaj8OvTfLjGNKjxpmV6JWOTGXgIjk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-Yxftv4s2OSusI0hE0rwDLw-1; Mon, 04 May 2020 19:49:07 -0400
X-MC-Unique: Yxftv4s2OSusI0hE0rwDLw-1
Received: by mail-qv1-f69.google.com with SMTP id f4so460837qvl.9
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 16:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZkeyqFAL3/DJbDVDMhDFSBl4H5QRa6a+zc27WJ/8Chw=;
        b=X8I9/xOGcoEEXoztLtshPjqcXNrd8zSI2+FFEoMa/O8Vz17UyZJWIQc0V/NiZWmMH0
         vIAtw6BYijydhCa/9ny+tjFGVsuaGo1fgHUaoJN2OvNVfueD1EHiCGszpqhUcd4AQ/FV
         YDA+4bfNaB5v+LfeL+3tf+NOS3kJyt/AOePayXhSR08UygJkkBb2vSzyNy3vMvp6nD1q
         +jcW/LP6hFdzVQDmnVi4S/Pdfjk9t5kpG5W78LGez8insJzlrwPb6b3iM5aFwiRd7b2f
         8AU4vMdrV5xEMCA6ko0V3wGwPbAuqpbS1vCEScKnAUZh46160wccDxv8cIakMQbwd9QC
         9HTw==
X-Gm-Message-State: AGi0PuZ36k3cuhduR3Cp0qFTlCnq7SAxFafxAFIyfEZMfrs3bhfQy+kt
        kLXEN7/jyWUzNVv4uwys6PiKHimOrdEl6s3IISlRQaHdNjdhxmHjKYKxOI4c7g9bISYkg9xqFS+
        h+SMvcsnxxsPa
X-Received: by 2002:a05:620a:16aa:: with SMTP id s10mr940478qkj.216.1588636147150;
        Mon, 04 May 2020 16:49:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypKoCmo8gaqMseWeGmZz7Dc0qcLoeE3sC8IOP0DtMBxSJM5IQXCouFJFJIvwkOebC9rKa07efQ==
X-Received: by 2002:a05:620a:16aa:: with SMTP id s10mr940458qkj.216.1588636146822;
        Mon, 04 May 2020 16:49:06 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w69sm484937qka.75.2020.05.04.16.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:49:06 -0700 (PDT)
Date:   Mon, 4 May 2020 19:49:04 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 0/3] KVM: x86: cleanup and fixes for debug register
 accesses
Message-ID: <20200504234904.GG6299@xz-x1>
References: <20200504155558.401468-1-pbonzini@redhat.com>
 <20200504185530.GE6299@xz-x1>
 <06dcafe8-8278-a818-ad76-36f3bbbcc0a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <06dcafe8-8278-a818-ad76-36f3bbbcc0a2@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 09:20:05PM +0200, Paolo Bonzini wrote:
> On 04/05/20 20:55, Peter Xu wrote:
> > On Mon, May 04, 2020 at 11:55:55AM -0400, Paolo Bonzini wrote:
> >> The purpose of this series is to get rid of the get_dr6 accessor
> >> and, on Intel, of set_dr6 as well.  This is done mostly in patch 2,
> >> since patch 3 is only the resulting cleanup.  Patch 1 is a related
> >> bug fix that I found while inspecting the code.
> > 
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > 
> > (Btw, the db_interception() change in patch 2 seems to be a real fix to me)
> 
> It should be okay because vcpu->arch.dr6 is not used on AMD.
> 
> However I think a kvm_update_dr6 call is missing in
> kvm_deliver_exception_payload, and kvm_vcpu_check_breakpoint should use
> kvm_queue_exception_p.

Seems correct.  Maybe apply the same thing to handle_exception_nmi() and
handle_dr()?  It's probably not a problem because VMX does not have set_dr6(),
however it's still cleaner to avoid clearing DR_TRAP_BITS and set DR6_RTM
manually before calling kvm_queue_exception() every time in VMX code.

> I'll fix all of those.
> 
> > I have that in my list, but I don't know it's "sorely" needed. :) It was low
> > after I knew the fact that we've got one test in kvm-unit-test, but I can for
> > sure do that earlier.
> > 
> > I am wondering whether we still want a test in selftests if there's a similar
> > test in kvm-unit-test already.  For this one I guess at least the guest debug
> > test is still missing.
> 
> The guest debugging test would basically cover the gdbstub case, which
> is different from kvm-unit-tests.  It would run similar tests to
> kvm-unit-tests, but #DB and #BP exceptions would be replaced by
> KVM_EXIT_DEBUG, and MOVs to DR would be replaced by KVM_SET_GUEST_DEBUG.
> 
> It could also cover exception payload support in KVM_GET_VCPU_EVENTS,
> but that is more complicated because it would require support for
> exceptions in the selftests.

Yep, I guess the in-guest debug test will still need the exception support,
though I also guess we don't need that when we have the kvm unit test, and
anyway I'll start with the simple (KVM_SET_GUEST_DEBUG).

Thanks,

-- 
Peter Xu

