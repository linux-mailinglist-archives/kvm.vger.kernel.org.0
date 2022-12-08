Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30366476D0
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiLHTtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLHTtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:49:32 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966B3389EF
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:49:30 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gt4so910486pjb.1
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/iRRuEpq3SHF2tTVNW+V0pd2eP3QVViktpfmGsJo8SE=;
        b=kbZjAjJOckI+jlOCJbuKM/9hTPPtgPZftSrpNxz+6MLKgxGWvBLLNyUR+yLtAe1FHf
         wJpg2MHXkTzpBNyZxTGd1AdsYy4ZLs6dxynTISt9vca/TyPOGTgUZjlcmzeqpYDnp/lr
         nfbOFjW274MxXgm+RUWP24N0ybK+fuofYxDYYO/sGvPoD5lfmmfOO3tdwNjQLoMr4mpd
         /RF/OCtj9uVDzdQiD1V8pMJXjG1PPQFii8S4PnRl+HioQe97ZvVWKQiPgKLeNQV2/HJw
         gBUXqS7+VDy/y8Zx1/EhxyC9Yxe7Bai4askP49YC2QyLOF6z9J+4HJ7bjYXM/dfQMhAm
         uWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iRRuEpq3SHF2tTVNW+V0pd2eP3QVViktpfmGsJo8SE=;
        b=QbiRK2DdRIFc+bldp7gJLVo6PGEMLcZEqX5i4n+DonwToPsszpneYT4QyTRi6Kxi6K
         AO0F7KuBU3x42E6GQRcw8NgLZJil/DGOG04TS7NrJrwxqPD1S5OnxW1gu1S1oBcUNYdj
         zCHcW3/ssO5C1wRnc/Dw7TH6S8DNt38JaTLyLCTkUpQO3pkpjMm4ekZhwfh8PJAnK4a8
         ypKGHbOKTGSheWbhkNohlhU6XNHnFFtJjGfbaxwTGtl+K1fxLuNcfKLUwCzFYC2s6mVn
         ZDNfLmHqOcujz7PmVo8SeWAitVACRrJCrvBYBeAF3dyh9PNGTKH8tPpicxeiZIuNZoBb
         JNTQ==
X-Gm-Message-State: ANoB5pkw1Rk7wU79lOyJaOsX5iMl3AD1oZwaLbPAuQ90s+2hyWftC9Wd
        Ey/Ov9oV53ULWDR09jToCu4oeQ==
X-Google-Smtp-Source: AA0mqf4+sYmN6TRhUnqm6pJbxgGCoSUwTGEipBsiO/jKS6U41yXiKghC+TQNsnXSTcuYW70TLswWgg==
X-Received: by 2002:a17:90a:d681:b0:218:84a0:65eb with SMTP id x1-20020a17090ad68100b0021884a065ebmr1775305pju.1.1670528969909;
        Thu, 08 Dec 2022 11:49:29 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id d15-20020a17090ac24f00b0020b7de675a4sm34718pjx.41.2022.12.08.11.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 11:49:29 -0800 (PST)
Date:   Thu, 8 Dec 2022 11:49:26 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: selftests: Setup ucall after loading program
 into guest memory
Message-ID: <Y5I/xiFMLVbpAZj+@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-3-oliver.upton@linux.dev>
 <Y5EoZ5uwrTF3eSKw@google.com>
 <Y5EtMWuTaJk9I3Bd@google.com>
 <Y5EutGSjkRmdItQb@google.com>
 <Y5Exwzr6Ibmmthl0@google.com>
 <Y5IxNTKRnacfSsLt@google.com>
 <Y5I0paok+dvTtrkt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5I0paok+dvTtrkt@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022 at 07:01:57PM +0000, Sean Christopherson wrote:
> On Thu, Dec 08, 2022, Ricardo Koller wrote:
> > On Thu, Dec 08, 2022 at 12:37:23AM +0000, Oliver Upton wrote:
> > > On Thu, Dec 08, 2022 at 12:24:20AM +0000, Sean Christopherson wrote:
> > > > > Even still, that's just a kludge to make ucalls work. We have other
> > > > > MMIO devices (GIC distributor, for example) that work by chance since
> > > > > nothing conflicts with the constant GPAs we've selected in the tests.
> > > > > 
> > > > > I'd rather we go down the route of having an address allocator for the
> > > > > for both the VA and PA spaces to provide carveouts at runtime.
> > > > 
> > > > Aren't those two separate issues?  The PA, a.k.a. memslots space, can be solved
> > > > by allocating a dedicated memslot, i.e. doesn't need a carve.  At worst, collisions
> > > > will yield very explicit asserts, which IMO is better than whatever might go wrong
> > > > with a carve out.
> > > 
> > > Perhaps the use of the term 'carveout' wasn't right here.
> > > 
> > > What I'm suggesting is we cannot rely on KVM memslots alone to act as an
> > > allocator for the PA space. KVM can provide devices to the guest that
> > > aren't represented as memslots. If we're trying to fix PA allocations
> > > anyway, why not make it generic enough to suit the needs of things
> > > beyond ucalls?
> > 
> > One extra bit of information: in arm, IO is any access to an address (within
> > bounds) not backed by a memslot. Not the same as x86 where MMIO are writes to
> > read-only memslots.  No idea what other arches do.
> 
> I don't think that's correct, doesn't this code turn write abort on a RO memslot
> into an io_mem_abort()?  Specifically, the "(write_fault && !writable)" check will
> match, and assuming none the the edge cases in the if-statement fire, KVM will
> send the write down io_mem_abort().

You are right. In fact, page_fault_test checks precisely that: writes on
RO memslots are sent to userspace as an mmio exit. I was just referring
to the MMIO done for ucall.

Having said that, we could use ucall as writes on read-only memslots
like what x86 does.

> 
> 	gfn = fault_ipa >> PAGE_SHIFT;
> 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
> 	write_fault = kvm_is_write_fault(vcpu);
> 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
> 		/*
> 		 * The guest has put either its instructions or its page-tables
> 		 * somewhere it shouldn't have. Userspace won't be able to do
> 		 * anything about this (there's no syndrome for a start), so
> 		 * re-inject the abort back into the guest.
> 		 */
> 		if (is_iabt) {
> 			ret = -ENOEXEC;
> 			goto out;
> 		}
> 
> 		if (kvm_vcpu_abt_iss1tw(vcpu)) {
> 			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
> 			ret = 1;
> 			goto out_unlock;
> 		}
> 
> 		/*
> 		 * Check for a cache maintenance operation. Since we
> 		 * ended-up here, we know it is outside of any memory
> 		 * slot. But we can't find out if that is for a device,
> 		 * or if the guest is just being stupid. The only thing
> 		 * we know for sure is that this range cannot be cached.
> 		 *
> 		 * So let's assume that the guest is just being
> 		 * cautious, and skip the instruction.
> 		 */
> 		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
> 			kvm_incr_pc(vcpu);
> 			ret = 1;
> 			goto out_unlock;
> 		}
> 
> 		/*
> 		 * The IPA is reported as [MAX:12], so we need to
> 		 * complement it with the bottom 12 bits from the
> 		 * faulting VA. This is always 12 bits, irrespective
> 		 * of the page size.
> 		 */
> 		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
> 		ret = io_mem_abort(vcpu, fault_ipa);
> 		goto out_unlock;
> 	}
