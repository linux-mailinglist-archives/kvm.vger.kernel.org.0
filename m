Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585FE666107
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 17:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbjAKQzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 11:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbjAKQyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 11:54:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBC018B0C
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 08:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=8H4AwAA/6i7aWAECp9a70v+AONnnkOC/ud5i95CYL4g=; b=qrSRycd5iOyDO6hyWyn+oMeKlx
        H5EH3bZkJ0ozOy301sRdZoaqsViqKaYMfbszlTKY/uDoXBQJQn9iM9kuj0HmqlYSsSO8WpKm8M9tw
        V9DnplDTyDvAmBd2dlHTb2kaJEL8rHOeB+lhiZoraUrMRd2gVqPUaEtxzizdgJLVDsSehLceIzS5m
        TzWqiyMH/BSK4O+eI7DME1B9BeCkKthwyppAlWk4qyOTqtO5TrjcjIWa8K4VnkKzytE9gF+cmpNHJ
        8DTmQJDVsRC+IfanV/5d4YU9i44JeYMUv4PLCesJAzYT9+AZmIYXv8m1mjIp879wZCaTZOUBalD/d
        wi8kue2Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pFeMq-003kGf-08;
        Wed, 11 Jan 2023 16:54:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1AA4D300472;
        Wed, 11 Jan 2023 17:54:29 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0069C2CA25088; Wed, 11 Jan 2023 17:54:28 +0100 (CET)
Date:   Wed, 11 Jan 2023 17:54:28 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, paul <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        kvm <kvm@vger.kernel.org>, Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH 2/3] KVM: x86/xen: Fix potential deadlock in
 kvm_xen_update_runstate_guest()
Message-ID: <Y77pxBsxac0z71RI@hirez.programming.kicks-ass.net>
References: <99b1da6ca8293b201fe0a89fd973a9b2f70dc450.camel@infradead.org>
 <03f0a9ddf3db211d969ff4eb4e0aeb8789683776.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <03f0a9ddf3db211d969ff4eb4e0aeb8789683776.camel@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 11, 2023 at 09:37:50AM +0000, David Woodhouse wrote:
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 07e61cc9881e..c444948ab1ac 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -272,7 +272,12 @@ static void kvm_xen_update_runstate_guest(struct kvm=
_vcpu *v, bool atomic)
> =A0=A0=A0=A0=A0=A0=A0=A0 * Attempt to obtain the GPC lock on *both* (if t=
here are two)
> =A0=A0=A0=A0=A0=A0=A0=A0 * gfn_to_pfn caches that cover the region.
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0read_lock_irqsave(&gpc1->lock, flags);
> +=A0=A0=A0=A0=A0=A0=A0local_irq_save(flags);
> +=A0=A0=A0=A0=A0=A0=A0if (!read_trylock(&gpc1->lock)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (atomic)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0read_lock(&gpc1->lock);
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0while (!kvm_gpc_check(gpc1, user_len1)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0read_unlock_irqrestore(&g=
pc1->lock, flags);
> =A0

There might be a problem with this pattern that would be alleviated when
written like:

	local_irq_save(flags);
	if (atomic) {
		if (!read_trylock(&gpc1->lock)) {
			local_irq_restore(flags);
			return;
		}
	} else {
		read_lock(&gpc1->lock);
	}

(also note you forgot the irq_restore on the exit path)

Specifically the problem is that trylock will not trigger the regular
lockdep machinery since it doesn't wait and hence cannot cause a
deadlock. With your form the trylock is the common case and lockdep will
only trigger (observe any potential cycles) if/when this hits
contention.

By using an unconditional read_lock() for the !atomic case this is
avoided.
