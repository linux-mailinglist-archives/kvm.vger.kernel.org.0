Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0832C1C6087
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 20:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgEES7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 14:59:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35358 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727083AbgEES7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 14:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588705180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0QimJWICcVgawJQV6KSoD8l4L46cS4D64iKKzoz7TGE=;
        b=iH34Ipcz3bv5Osnvbn/xTsSkCBToXnXSTDhmu15uMRX1UvsP9bLuVlnoxdH///XNu/xXbQ
        yjs4HfOnW7+NmxZPmTeP3Hu7gHO2u6J1SDis4ES+cwyusAmVt6jrrc+bG9UNqamTpGtIbt
        EADGUOCvCecNk7bufcgjn7brP/7jh+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-JSQ0t69xNUmsWKb7_pld1A-1; Tue, 05 May 2020 14:59:38 -0400
X-MC-Unique: JSQ0t69xNUmsWKb7_pld1A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A802FEC1A6;
        Tue,  5 May 2020 18:59:36 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-211.rdu2.redhat.com [10.10.116.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E81D610021B3;
        Tue,  5 May 2020 18:59:35 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 5A7A3222F75; Tue,  5 May 2020 14:59:35 -0400 (EDT)
Date:   Tue, 5 May 2020 14:59:35 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 6/6] KVM: x86: Switch KVM guest to using interrupts
 for page ready APF delivery
Message-ID: <20200505185935.GC7155@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-7-vkuznets@redhat.com>
 <ee587bd6-a06f-8a38-9182-94218f7d08bb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee587bd6-a06f-8a38-9182-94218f7d08bb@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 12:53:33PM +0200, Paolo Bonzini wrote:
> On 29/04/20 11:36, Vitaly Kuznetsov wrote:
> > +
> > +	if (__this_cpu_read(apf_reason.enabled)) {
> > +		reason = __this_cpu_read(apf_reason.reason);
> > +		if (reason == KVM_PV_REASON_PAGE_READY) {
> > +			token = __this_cpu_read(apf_reason.token);
> > +			/*
> > +			 * Make sure we read 'token' before we reset
> > +			 * 'reason' or it can get lost.
> > +			 */
> > +			mb();
> > +			__this_cpu_write(apf_reason.reason, 0);
> > +			kvm_async_pf_task_wake(token);
> > +		}
> 
> If tokens cannot be zero, could we avoid using reason for the page ready
> interrupt (and ultimately retire "reason" completely)?

If we are planning to report errors using this interface, then retaining
KVM_PV_REASON_PAGE_READY makes sense because we can then introduce another
state say KVM_PV_REASON_PAGE_ERROR.

Thanks
Vivek

