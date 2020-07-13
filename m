Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADCA21DF7E
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 20:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGMSWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 14:22:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50714 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbgGMSWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 14:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594664555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2oYyaWcgfJiqLq1WHDsrJOK0cX6P8HhkN2BpaAn4h60=;
        b=FrzRlFCHQdb5Hw42f8+H7cFYifIUVRFimBU/StV1RBlCPp2J//9wN16a7gclepcAnrGNnX
        IpmMsNB9fazkR6SAF7/+OELcshtw/fI+KwZymAZNf19jMNXSrVVTG6c7kcT9yv0Mv8I8Cw
        ocYZO4rGBoUjdpZovrBj5bw6mTKHUbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-WZBatit_NiGP-1IXs3KhyA-1; Mon, 13 Jul 2020 14:22:31 -0400
X-MC-Unique: WZBatit_NiGP-1IXs3KhyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 023648014D4;
        Mon, 13 Jul 2020 18:22:30 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD65779222;
        Mon, 13 Jul 2020 18:22:28 +0000 (UTC)
Date:   Mon, 13 Jul 2020 12:22:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
Message-ID: <20200713122226.28188f93@x1.home>
In-Reply-To: <20200710042922.GA24919@linux.intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
        <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
        <20200709211253.GW24919@linux.intel.com>
        <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
        <20200710042922.GA24919@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jul 2020 21:29:22 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> +Alex, whom I completely spaced on Cc'ing.
> 
> Alex, this is related to the dreaded VFIO memslot zapping issue from last
> year.  Start of thread: https://patchwork.kernel.org/patch/11640719/.
> 
> The TL;DR of below: can you try the attached patch with your reproducer
> from the original bug[*]?  I honestly don't know whether it has a legitimate
> chance of working, but it's the one thing in all of this that I know was
> definitely a bug.  I'd like to test it out if only to sate my curiosity.
> Absolutely no rush.

Mixed results, maybe you can provide some guidance.  Running this
against v5.8-rc4, I haven't reproduced the glitch.  But it's been a
long time since I tested this previously, so I went back to v5.3-rc5 to
make sure I still have a recipe to trigger it.  I can still get the
failure there as the selective flush commit was reverted in rc6.  Then
I wondered, can I take broken v5.3-rc5 and apply this fix to prove that
it works?  No, v5.3-rc5 + this patch still glitches.  So I thought
maybe I could make v5.8-rc4 break by s/true/false/ in this patch.
Nope.  Then I applied the original patch from[1] to try to break it.
Nope.  So if anything, I think the evidence suggests this was broken
elsewhere and is now fixed, or maybe it is a timing issue that I can't
trigger on newer kernels.  If the reproducer wasn't so touchy and time
consuming, I'd try to bisect, but I don't have that sort of bandwidth.
Thanks,

Alex

[1] https://patchwork.kernel.org/patch/10798453/

