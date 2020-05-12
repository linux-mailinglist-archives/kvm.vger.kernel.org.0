Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB361D0087
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 23:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbgELVPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 17:15:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47483 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725938AbgELVPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 17:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589318113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KKbG/7NnQEY0XYYBh6yQ01fFVwnPr8GzaTotsTFKyPI=;
        b=OhvUjbZPOmxI42zPYAmL5lCGF+KFQtKFTutvXpivzYqaGH7+b5CEMiyOZlD5NtRvTrM+2x
        cdnyQhJ/3yqT9WCDemjevx7F2H+IwUJr0Y2fLdWITSvIflNEforEW2d1pzxxB3ENd7Jbmj
        9hhctt9MdJQF8mcTOpTp57HWMatZ3Ow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-5yuVjf3fMuSAd98SLS5sJQ-1; Tue, 12 May 2020 17:15:10 -0400
X-MC-Unique: 5yuVjf3fMuSAd98SLS5sJQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7757F8005B7;
        Tue, 12 May 2020 21:15:07 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-85.rdu2.redhat.com [10.10.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56DB6165F6;
        Tue, 12 May 2020 21:15:06 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id DCC71220C05; Tue, 12 May 2020 17:15:05 -0400 (EDT)
Date:   Tue, 12 May 2020 17:15:05 -0400
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
Message-ID: <20200512211505.GB142860@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com>
 <87o8qtmaat.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8qtmaat.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 12, 2020 at 05:40:10PM +0200, Vitaly Kuznetsov wrote:
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
> >> -	__u8 pad[60];
> >> +	__u32 pageready_token;
> >
> > How about naming this just "token". That will allow me to deliver error
> > as well. pageready_token name seems to imply that this will always be
> > successful with page being ready.
> >
> > And reason will tell whether page could successfully be ready or
> > it was an error. And token will help us identify the task which
> > is waiting for the event.
> 
> I added 'pageready_' prefix to make it clear this is not used for 'page
> not present' notifications where we pass token through CR2. (BTW
> 'reason' also becomes a misnomer because we can only see
> 'KVM_PV_REASON_PAGE_NOT_PRESENT' there.)

"kvm_vcpu_pv_apf_data" being shared between two events at the same
time is little concerning. At least there should be clear demarkation
that which events will use which fields.

I guess I could extend "reason" to also report KVM_PV_REASON_ERROR as
long as I make error reporting opt in. That way new code is able to
handle more values and old code will not receive it.

For reporting errors with page ready events, I probably will have to
use more padding bytes to report errors as I can't use reason field anymore.

In your previous posting in one of the emails Paolo mentioned that data
structures for #VE will be separate. If that's the case, then we will end
up changing this protocol one more time. To me it feels that both #VE
changes and these changes should go in together as part of async page fault
redesign V2.

> 
> I have no strong opinion, can definitely rename this to 'token' and add
> a line to the documentation to re-state that this is not used for type 1
> events.

Now I understand that both events could use this shared data at the same
time. So prefixing toke with pageready makes it clear that it has to be
used only with pageready event. So sounds better that way.

Thanks
Vivek

