Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E287239C7E7
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 13:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhFEL3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Jun 2021 07:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229902AbhFEL3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Jun 2021 07:29:35 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5C761359;
        Sat,  5 Jun 2021 11:27:48 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lpUSw-005dx0-0a; Sat, 05 Jun 2021 12:27:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 05 Jun 2021 12:27:45 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] kvm: x86: implement KVM PM-notifier
In-Reply-To: <YLtWjiFb62RFLWzA@google.com>
References: <20210605023042.543341-1-senozhatsky@chromium.org>
 <20210605023042.543341-2-senozhatsky@chromium.org>
 <87k0n8u1nk.wl-maz@kernel.org> <YLtWjiFb62RFLWzA@google.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <a304706273ff750b4aa8b822606fb03e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: senozhatsky@chromium.org, pbonzini@redhat.com, vkuznets@redhat.com, peterz@infradead.org, suleiman@google.com, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-06-05 11:48, Sergey Senozhatsky wrote:
> On (21/06/05 10:00), Marc Zyngier wrote:
>> > +static int kvm_arch_suspend_notifier(struct kvm *kvm)
>> > +{
>> > +	struct kvm_vcpu *vcpu;
>> > +	int i, ret;
>> > +
>> > +	mutex_lock(&kvm->lock);
>> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> > +		ret = kvm_set_guest_paused(vcpu);
>> > +		if (ret) {
>> > +			pr_err("Failed to pause guest VCPU%d: %d\n",
>> > +			       vcpu->vcpu_id, ret);
>> 
>> how useful the pr_err() is, given that it contains no information
>> that would help identifying which guest failed to pause.
> 
> Do other printk-s contain such info? All I can see so far is
> `#define pr_fmt(fmt) "kvm-guest: " fmt` which doesn't point
> at any particular VM.

Look for kvm_{err,info,debug...} and vcpu_{err,debug...}, all of
which will at least give you a PID. Even x86 uses it.

         M.
-- 
Jazz is not dead. It just smells funny...
