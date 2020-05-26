Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223001E223F
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 14:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgEZMuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 08:50:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27721 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728412AbgEZMuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 08:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590497433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MJSM3PD7cXbri59EHpWEca36HJ8EesRGj50MuybBvxc=;
        b=TFaO+/3Vu3SKfbYNBG6sNzw83S/luUq9uqmjqaa5Uo9gQrWc0DF+Ht7oyc4gVyUfpLYS/X
        yyg348EOtJVTMG0SZtYXpK2yWURcaI9yBVkKOThqQXD4bG1Rd8AmvMpn/m7I2qC6eVF8u/
        hFGbQ+itEdYrk4fwJKtK3nlYgBidSLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-Q4pwPJCCOcmmRT7We-A9mg-1; Tue, 26 May 2020 08:50:31 -0400
X-MC-Unique: Q4pwPJCCOcmmRT7We-A9mg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD18D461;
        Tue, 26 May 2020 12:50:29 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-102.rdu2.redhat.com [10.10.115.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C94D10013DB;
        Tue, 26 May 2020 12:50:29 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 0988E22036E; Tue, 26 May 2020 08:50:29 -0400 (EDT)
Date:   Tue, 26 May 2020 08:50:28 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
Message-ID: <20200526125028.GB108774@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200521183832.GB46035@redhat.com>
 <87sgfq8vau.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgfq8vau.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 06:34:17PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Mon, May 11, 2020 at 06:47:46PM +0200, Vitaly Kuznetsov wrote:
> >> Currently, APF mechanism relies on the #PF abuse where the token is being
> >> passed through CR2. If we switch to using interrupts to deliver page-ready
> >> notifications we need a different way to pass the data. Extent the existing
> >> 'struct kvm_vcpu_pv_apf_data' with token information for page-ready
> >> notifications.
> >> 
> >> The newly introduced apf_put_user_ready() temporary puts both reason
> >> and token information, this will be changed to put token only when we
> >> switch to interrupt based notifications.
> >> 
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >>  arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
> >>  arch/x86/kvm/x86.c                   | 17 +++++++++++++----
> >>  2 files changed, 15 insertions(+), 5 deletions(-)
> >> 
> >> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> >> index 2a8e0b6b9805..e3602a1de136 100644
> >> --- a/arch/x86/include/uapi/asm/kvm_para.h
> >> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> >> @@ -113,7 +113,8 @@ struct kvm_mmu_op_release_pt {
> >>  
> >>  struct kvm_vcpu_pv_apf_data {
> >>  	__u32 reason;
> >
> > Hi Vitaly,
> >
> > Given we are redoing it, can we convert "reason" into a flag instead
> > and use bit 0 for signalling "page not present" Then rest of the 31
> > bits can be used for other purposes. I potentially want to use one bit to
> > signal error (if it is known at the time of injecting #PF).
> 
> Yes, I think we can do that. The existing KVM_PV_REASON_PAGE_READY and
> KVM_PV_REASON_PAGE_NOT_PRESENT are mutually exclusive and can be
> converted to flags (we'll only have KVM_PV_REASON_PAGE_NOT_PRESENT in
> use when this series is merged).
> 
> >
> >> -	__u8 pad[60];
> >> +	__u32 pageready_token;
> >> +	__u8 pad[56];
> >
> > Given token is 32 bit, for returning error in "page ready" type messages,
> > I will probably use padding bytes and create pagready_flag and use one
> > of the bits to signal error.
> 
> In case we're intended to pass more data in synchronous notifications,
> shall we leave some blank space after 'flags' ('reason' previously) and
> before 'token'?

Given you are planning to move away from using kvm_vcpu_pv_apf_data
for synchronous notifications, I will not be too concerned about it.

Thanks
Vivek

