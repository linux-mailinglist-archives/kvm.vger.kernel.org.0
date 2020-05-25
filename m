Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE111E11A7
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404132AbgEYPZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403996AbgEYPZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 11:25:28 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730CEC061A0E
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:25:28 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z6so21110038ljm.13
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8td81KCvxI/2OEeh9Ticm0bkE2svquaArM6q3f8IXmc=;
        b=XKLT64/LoBo+2JIIl8QkJUlGd+R1rZ4tPpmndC6EsNsrmAYZkJme9ja7XOzbKQuAjI
         DtpeLj7Uwu2ur5UuVF0+qw0Hzyrm6BStK7r5dhGafeH+m6ie5MbyhPzq8bbRlSx/Zrs9
         XM91Q282XZynEXJH8uxRSKIjefQa6CinKOcSygOpjeU+MSKFjjsZCfG2ZxZeKG+y7A2g
         hqhzE/+9gzLMwa/uTH3Z6o6JyDar/fj9L9QqWRe1fu1vZgd3rnzddgVk7ShggIBN5o0B
         px2nWL7O1qPc7ug9j389cU1DPjCFFVctI3emZkhkLWmm5h/xEbjFPxgNy7P+KXtiquUF
         QlDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8td81KCvxI/2OEeh9Ticm0bkE2svquaArM6q3f8IXmc=;
        b=p5wNtHwT6k9WxfL6H98FHRCbkjnE8tbA5FwHrgWal1EPTTqCJ70ZJlh0OikufJaHS5
         C7nujzyXXRWfyUSVpmrpWJU2HVlCEKN2hpwmnDvYzxe69OCkRt7USvWBcHKjozSpW8jN
         MSAurEYy9RRabsOUOybGwq7RwauWpS4181cOf9LwTFzHw7/eTT0G301LSKy+GPyn1Hcw
         ucb7EfSvyVRthSD2piCZ2xbm4uGOwrbJ4eNzV2rp4WQJH+MSU2Votb6Z4EsrSbmpZhPo
         T4K1erN+5QgKtCpMVLC5pycg3kHysAA3OJjtN7DgYwTLv/sXiVWNw5mWaiYxYwMypOpO
         /+xg==
X-Gm-Message-State: AOAM533ORWZqktIlRcNTG/PS0PEjwxkIOwuJq0H6vtO3fEpGkrDfIePJ
        3oUlh6FJTw3kWUBe2GPrZpGNUA==
X-Google-Smtp-Source: ABdhPJzf6qWm+gQ1VnQeyksSzu7xA/fy4Zz0Mxz50VNuHIpl3XYpEr226uIZ1ropjN/mf8I4AeBFKg==
X-Received: by 2002:a05:651c:2c6:: with SMTP id f6mr11628565ljo.371.1590420326879;
        Mon, 25 May 2020 08:25:26 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id i8sm5664708lfl.72.2020.05.25.08.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:25:26 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 6C23C10230F; Mon, 25 May 2020 18:25:27 +0300 (+03)
Date:   Mon, 25 May 2020 18:25:27 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 13/16] x86/kvmclock: Share hvclock memory with the host
Message-ID: <20200525152527.7g57us6imlh62x7i@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-14-kirill.shutemov@linux.intel.com>
 <875zck82fx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zck82fx.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 05:22:10PM +0200, Vitaly Kuznetsov wrote:
> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
> 
> > hvclock is shared between the guest and the hypervisor. It has to be
> > accessible by host.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  arch/x86/kernel/kvmclock.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> > index 34b18f6eeb2c..ac6c2abe0d0f 100644
> > --- a/arch/x86/kernel/kvmclock.c
> > +++ b/arch/x86/kernel/kvmclock.c
> > @@ -253,7 +253,7 @@ static void __init kvmclock_init_mem(void)
> >  	 * hvclock is shared between the guest and the hypervisor, must
> >  	 * be mapped decrypted.
> >  	 */
> > -	if (sev_active()) {
> > +	if (sev_active() || kvm_mem_protected()) {
> >  		r = set_memory_decrypted((unsigned long) hvclock_mem,
> >  					 1UL << order);
> >  		if (r) {
> 
> Sorry if I missed something but we have other structures which KVM guest
> share with the host,
> 
> sev_map_percpu_data():
> ...
> 	for_each_possible_cpu(cpu) {
> 		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
> 		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
> 		__set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeof(kvm_apic_eoi));
> 	}
> ...
> 
> Do you handle them somehow in the patchset? (I'm probably just blind
> failing to see how 'early_set_memory_decrypted()' is wired up)

I don't handle them yet: I've seen the function, but have not modified it.
I want to understand first why it doesn't blow up for me without the
change. Any clues?

-- 
 Kirill A. Shutemov
