Return-Path: <kvm+bounces-15292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 101C78AAFDD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:58:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 428BF1C22C57
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947B412DDAC;
	Fri, 19 Apr 2024 13:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mRlK2Ozk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3512DD91
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535090; cv=none; b=jsfhWYcw4Ap3fNRR+ufCvvHqAmx77Vx+JmA3MwKRmTKJZXAJW9LmQG15P+tckxS8PuLf0dSVCrBS04hSJw8okBGFhGx+vWOYA4dQcEiKabG0DxVA8Nbw+F7zXEgMwYc6rTmtuUKKxjhneUE0LmW/W2hGUyyEoWL2CDbyjqKArj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535090; c=relaxed/simple;
	bh=gKtJtEltb2GnPLMyuxs+G7n5EiHdmrtpBSJFJerWnT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kAlK3knYqUKpRf+kIwuGZdvsWt/1zhRU07KTHqCxlwX2xfrnamjLS7cs3Vu7xJS2MFFIOnOJ9ILW/IxDgIMLsKFs6thW1v0265Yt4PRhadhtnFyCQl+FP2H/pBP16agPXLXtnGA2f6IRRHUFLgw2j1yYafK/pGEU9xVny3Vupj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mRlK2Ozk; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso3836034276.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 06:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713535088; x=1714139888; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KgrnEQ6mmP0jFk5Zb1SZY9boKJybsIIVble8n571sqI=;
        b=mRlK2OzkuCq05+LZ6E5NEHj0g7bbqBqXyiw5zvOi0650htfNDK/xcglrJEONnshNq3
         RAXI+oelN0PRLcdYSG+4zJWj5Qj5CBp+/AvPbL75WEDb28f1b/vBFJESveRYjsBtonuV
         6Drn/gFl76UCFwd+THW35DDFtxg1LLTDK/EVb8+cNedWfQ1aT7E0h0ehChwzJ1qGeyLd
         aoL+6WmsQoGrsbAxulbqCHsC4T8xOmamYs02X28bpDHbyssO1+2CK/YcMMqi+VgS4S3h
         WoqIHzO4si2L4Bt0bXtdA6Y+u6dKFOPx0RoNMfULHtspL7n2dg+IMQeWze1L3oa4iL3m
         G2VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713535088; x=1714139888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KgrnEQ6mmP0jFk5Zb1SZY9boKJybsIIVble8n571sqI=;
        b=vuySyE27RDdgH6ifvzZUd0LYuT3uVyHHD+kAM6YTYJ6Q46wOq195QZ2RM3hDdTFtKX
         uIO0DvkZWOffmkBKDQHVNJwABk27YS5XOLev9qYi4ygKkHHcx5f9mS3qczW+FnmvKS6b
         9sR2XQiyIGNk3wigZ4DPOf2XP805dzQgb+AhCkXlERcKUmDPdOPzg9E9PpJS4bkVamt1
         yaVxYtVH75W+/xvo3x/4MB8M+OESb1KDCP/a5jud9zzvH+Z9GkjioVjUzj8GEuDkmCjd
         34EdAH6rKBVo6KpJsR+65ThGk3v2uo9Z5CMpFAPvQawoy6FuQVzX3z07iWiSQBO7RiOm
         KcKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXc99JwClDtsYtlI81Y8lb0sb2idw9JQyfO7DkoePN0JwTxH/kzuhp6130nZKcAJauL7x67eglHhqwKL+/lvRRMhspY
X-Gm-Message-State: AOJu0Yz7VtSMlauatDI3gSzwVIupyG3Fpmze4RBuH9VOeNYXVdLKry9A
	JiPWohs1QQQLoRn4qdCjJrCpEeHcxb9SBpLToiWgMkIevkIthM6Q0q7hF5qvKhEgLqsRkskfN1d
	/hg==
X-Google-Smtp-Source: AGHT+IGomtDJcb51lvQMFTT5YaGoxW/vZTzkUSuhiTLoa8vZxcxiKEVXH4dmB1G1pZ9i7NSp+ryn6A1areA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad8d:0:b0:dc6:e5d3:5f03 with SMTP id
 z13-20020a25ad8d000000b00dc6e5d35f03mr543024ybi.4.1713535088599; Fri, 19 Apr
 2024 06:58:08 -0700 (PDT)
Date: Fri, 19 Apr 2024 06:58:06 -0700
In-Reply-To: <20240419112432.GB2972@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405115815.3226315-1-pbonzini@redhat.com> <20240405115815.3226315-2-pbonzini@redhat.com>
 <20240412104408.GA27645@willie-the-truck> <86jzl2sovz.wl-maz@kernel.org>
 <ZhlLHtfeSHk9gRRO@google.com> <86h6g5si0m.wl-maz@kernel.org>
 <Zh1d94Pl6gneVoDd@google.com> <20240418141932.GA1855@willie-the-truck>
 <ZiF6NgGYLSsPNEOg@google.com> <20240419112432.GB2972@willie-the-truck>
Message-ID: <ZiJ4bqrBUPM0E8iq@google.com>
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Nicholas Piggin <npiggin@gmail.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 19, 2024, Will Deacon wrote:
> > @@ -663,10 +669,22 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
> >  					break;
> >  			}
> >  			r.ret |= range->handler(kvm, &gfn_range);
> > +
> > +		       /*
> > +			* Use a precise gfn-based TLB flush when possible, as
> > +			* most mmu_notifier events affect a small-ish range.
> > +			* Fall back to a full TLB flush if the gfn-based flush
> > +			* fails, and don't bother trying the gfn-based flush
> > +			* if a full flush is already pending.
> > +			*/
> > +		       if (range->flush_on_ret && !need_flush && r.ret &&
> > +			   kvm_arch_flush_remote_tlbs_range(kvm, gfn_range.start,
> > +							    gfn_range.end - gfn_range.start + 1))
> 
> What's that '+ 1' needed for here?

 (a) To see if you're paying attention.
 (b) Because more is always better.
 (c) Because math is hard.
 (d) Because I haven't tested this.
 (e) Both (c) and (d).

