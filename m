Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55DB2A69D0
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 17:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgKDQcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 11:32:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725896AbgKDQcD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 11:32:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604507522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sYaj2UXtsTt0xHMWJvAK4qSBAxg5IaDjFNjZ783AMQs=;
        b=hS5PzTx/qTiMzegT1no5+0zx7JIHm/E9O1i5+/F2GuLVp6NlSochRhb0yTMUKnlhWBkwwX
        4JY7nAUnImzVH4FKDN5Ps8AJVv0ifTx8ckA24mVVI0siDEoTtfFu1EieD3Bwt/XLKUtRDM
        U3M/e1Zb0faxfe1xOeNNv342GKWsBZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-JbqCzlhHMgqZWGBdniYdUQ-1; Wed, 04 Nov 2020 11:32:01 -0500
X-MC-Unique: JbqCzlhHMgqZWGBdniYdUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 802551084C9E;
        Wed,  4 Nov 2020 16:31:57 +0000 (UTC)
Received: from ovpn-112-92.rdu2.redhat.com (ovpn-112-92.rdu2.redhat.com [10.10.112.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D2994DA35;
        Wed,  4 Nov 2020 16:31:55 +0000 (UTC)
Message-ID: <247d36e9a0f2b06c8a4008c634d008ef4403c579.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: use positive error values for msr emulation
 that causes #GP
From:   Qian Cai <cai@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Wed, 04 Nov 2020 11:31:54 -0500
In-Reply-To: <20201101115523.115780-1-mlevitsk@redhat.com>
References: <20201101115523.115780-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2020-11-01 at 13:55 +0200, Maxim Levitsky wrote:
> Recent introduction of the userspace msr filtering added code that uses
> negative error codes for cases that result in either #GP delivery to
> the guest, or handled by the userspace msr filtering.
> 
> This breaks an assumption that a negative error code returned from the
> msr emulation code is a semi-fatal error which should be returned
> to userspace via KVM_RUN ioctl and usually kill the guest.
> 
> Fix this by reusing the already existing KVM_MSR_RET_INVALID error code,
> and by adding a new KVM_MSR_RET_FILTERED error code for the
> userspace filtered msrs.
> 
> Fixes: 291f35fb2c1d1 ("KVM: x86: report negative values from wrmsr emulation
> to userspace")
> Reported-by: Qian Cai <cai@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Apparently, it does not apply cleanly on today's linux-next. Paolo, is it
possible to toss this into -next soon, so our CI won't be blocked because of
this bug?

