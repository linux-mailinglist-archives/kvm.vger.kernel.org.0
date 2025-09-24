Return-Path: <kvm+bounces-58675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EDD1B9AFBD
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A2BB1B285AE
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 17:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00F1315D27;
	Wed, 24 Sep 2025 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VqAUT9RL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A1C3148B8
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758733754; cv=none; b=b/klv7kJEnb6CM6iARWtG7Ujq4jNKc/Yza6sUTTi1b+Nbv8y+dxJfWf3LQ1pdHz6B1B8WKE50nYbwlUZN6Vwze4AWURY5rqIcp7FWb9Z3A62IuQ5KO2NjjF4Lfd1AykpsOiB5l0BQEVokiL07ZMB5Qb1YG37Rkf5/rKTESKb1to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758733754; c=relaxed/simple;
	bh=jMiNYwcKrtuXeWYP468jwZxuCU0+6U9gklUpjvXly1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tE255jRukGNFZI+t/o/C2CR/QhR0aqHkwPXRzlDjdyTzkEqRcGdFWXbtDuQE15O8EgofSUBSIWDU6cnAb0GOppb9+xVKuXbjeoF7ubTemtb/hecrpFe9pK8I/HuvAeVVTJZfD+WZ7pWOxiszGBQjsozG87a8IQIjd/LZawO7r30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VqAUT9RL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc3aso67126a91.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 10:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758733752; x=1759338552; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XNjb5f+SOj2L7kwdIYPehNVFvoKk+qoLIEIor32uTWY=;
        b=VqAUT9RLKjRglNxK7fXllf6mdPWhOWI0PTVupRgi0bgq0gIdtZB8TsbAZRaMOi2eyn
         J+sVbXfPir0uS38+JgE96wuaILK3EudALyoGWpd9+fd1y/XaW2JaJHK3q9pY5LRluhfX
         AbPs+SCHD/FcWShsXLvMf0NhBCaxO5J1RA25GARuqzpGR45nHIHH70gnRy2M+nqvGGvM
         ZYwzOzi8JPRdLfwb60vaMbLqvBgB6upOIbNTUILioaMxhj/Y3FPB70/sQ1NnoKAOXb+9
         jhDuK9HcZcAr4iyc58O5SH6TOAHVxpvAyVcypwxGzlkhSS5yEVomSUqQdfwf8cOwoboH
         dA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758733752; x=1759338552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNjb5f+SOj2L7kwdIYPehNVFvoKk+qoLIEIor32uTWY=;
        b=TkiBQIe2MWJm5brk1zig55VXcYbFtfgmNvDmSwYGqfivx4FK324pFeGi3vGVyouVQx
         sYrWcmGbdU+x9kLKd0PY7CbjFLB/xkyz0U5AUaTs/qHez2o7uscVLzEpZ++7fv9sFUx9
         xi5RBNlsHYG3cF6gK10xB/3NQeSRiBYxSmqwswOKGH09UL8mxz+3e853NjrgNgoLBlvC
         KBSBveRRoXGTR6dUPihSkvm4fT2GfubcX6Eztldly7rVMPajQZdnlPLGL+Y4SFusv0BP
         Zj6TzkhqyD4mTADr2CitKkJIph1BsShb2tE7azlzQEeJoteVigUbyOGYDsGx9Veihm+F
         SqgA==
X-Forwarded-Encrypted: i=1; AJvYcCWCUwj5NboIJSZqzZ7XVvHV6+/F47ccnXTDKcRFa8/3MeV/tcSM1vj35DCf/HPFSkoDai0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAqGFIm+2SjZuSfnryUktEyUJvY6lslL8xzYOQg2JGACSZ4dcD
	yM3VEsEB8HvVFc/1BNTcQ092NWTSCwC19i1estNCfSSSjoLaR+Artyckhtm/0tap5TbPZuwbGtQ
	henCpag==
X-Google-Smtp-Source: AGHT+IHmBSRKtmTbEWoMCQbKheLyeNIAmUuDfS5ZXx7MorRmkrBQi2lJSpKP9RyljZwpgrB1REZiWaVCQz8=
X-Received: from pjblx2.prod.google.com ([2002:a17:90b:4b02:b0:32d:df7e:66c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a8c:b0:32e:4924:6902
 with SMTP id 98e67ed59e1d1-3342a241270mr484563a91.3.1758733752603; Wed, 24
 Sep 2025 10:09:12 -0700 (PDT)
Date: Wed, 24 Sep 2025 10:09:10 -0700
In-Reply-To: <aMir-qs5zwmoXU6A@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822070305.26427-1-yan.y.zhao@intel.com> <20250822070554.26523-1-yan.y.zhao@intel.com>
 <aL9rCwZGQofDh7C3@google.com> <aMfMk/x5XJ1bfvzv@yzhao56-desk.sh.intel.com> <aMir-qs5zwmoXU6A@google.com>
Message-ID: <aNQltowMx51v42Bw@google.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Test prefault memory during
 concurrent memslot removal
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, reinette.chatre@intel.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Sean Christopherson wrote:
> On Mon, Sep 15, 2025, Yan Zhao wrote:
> > On Mon, Sep 08, 2025 at 04:47:23PM -0700, Sean Christopherson wrote:
> > > On Fri, Aug 22, 2025, Yan Zhao wrote:
> > > +		if (!slot_recreated) {
> > > +			WRITE_ONCE(data.recreate_slot, true);
> > > +			pthread_join(slot_worker, NULL);
> > > +			slot_recreated = true;
> > > +			continue;
> > If delete_slot_worker() invokes vm_mem_region_delete() slowly enough due to
> > scheduling delays, the return value from __vcpu_ioctl() could be 0 with
> > range.size being 0 at this point.
> > 
> > What about checking range.size before continuing?
> > 
> > @@ -120,7 +126,8 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
> >                         WRITE_ONCE(data.recreate_slot, true);
> >                         pthread_join(slot_worker, NULL);
> >                         slot_recreated = true;
> > -                       continue;
> > +                       if (range.size)
> > +                               continue;
> >                 }
> > 
> > 
> > Otherwise, the next __vcpu_ioctl() would return -1 with errno == EINVAL, which
> > will break the assertion below.
> 
> Drat, I missed that kvm_vcpu_pre_fault_memory() returns -EINVAL on a size of '0'
> (see the wrong comment snippet "Either prefaulting already succeeded, in which
> case retrying should also succeed, or retry is needed to get a stable result").
> 
> I'll circle back to this tomorrow.  IIRC, there was a reason I didn't want to
> check range.size in that path, but for the life of me I can't remember why :-/

I'm 99% certain I was worried about false passes, but after working through the
possible scenarios, I don't see any way for bailing on !range.size to result in
missing a KVM bug.  So I'll post a formal patch with the below sqaushed in.

Thanks much!

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 2dbabf4b0b15..f04768c1d2e4 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -112,15 +112,24 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
                 * slot was deleted) and/or to prepare for the next testcase.
                 * Wait for the worker to exit so that the next invocation of
                 * prefaulting is guaranteed to complete (assuming no KVM bugs).
-                * Always retry prefaulting to simply the retry logic.  Either
-                * prefaulting already succeeded, in which case retrying should
-                * also succeed, or retry is needed to get a stable result.
                 */
                if (!slot_recreated) {
                        WRITE_ONCE(data.recreate_slot, true);
                        pthread_join(slot_worker, NULL);
                        slot_recreated = true;
-                       continue;
+
+                       /*
+                        * Retry prefaulting to get a stable result, i.e. to
+                        * avoid seeing random EAGAIN failures.  Don't retry if
+                        * prefaulting already succeeded, as KVM disallows
+                        * prefaulting with size=0, i.e. blindly retrying would
+                        * result in test failures due to EINVAL.  KVM should
+                        * always return success if all bytes are prefaulted,
+                        * i.e. there is no need to guard against EAGAIN being
+                        * returned.
+                        */
+                       if (range.size)
+                               continue;
                }
 
                /*

