Return-Path: <kvm+bounces-64263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA0DC7BDF6
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 23:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1A603A7E15
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1435830BB9F;
	Fri, 21 Nov 2025 22:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a++AIweF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5641B2C15AE
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 22:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763764490; cv=none; b=Vdd5B4AbM++k+99KZVOuGjEo40lS5FSzjvVNBtB0NPU+zwDvxo1xxhwxAhRVPRYMudsgll1YSOqD6lSVzxTFwqv9GjkArVmLH3RlZKN7EsePql7JqlrrFOintrDQVky//c8UTFn4xZDMh1VpKRd0keOwl33hqZioJ1S9RT6QGhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763764490; c=relaxed/simple;
	bh=Cm8gNTD5HDKhB/YGSur7bO18CAjWuu8P/nm0G7TmJAI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tHAcpdT/GSj/TmtSAAtI7hB0QRm2N+7ojTmz5MGZULhZ0HYzz8FamyqbI015Twp+GoYbpOel4TsS/8utzGBIJMjHQpuA69caHsTJwzQ2QnNZHAPm7gnsX7t1D3sMLRD2Li37jCJReOYHyQObUi/CF9H4BNyJyKQMfTvNZqsh900=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a++AIweF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c261fb38so4694045a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763764488; x=1764369288; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fL7AO/YbZegwLET4orHpyrj5KMZ/eiSlht4bCLj4XfI=;
        b=a++AIweFexP7VfpRBilc1FF4cnSEFgL5Ourd5PPn1p0KN0qKYK0GLL0778623oKbOz
         STtjn6A6pKS0+1tbat6dZ5IsqJAlX6zwgCX6DzCgnyWiUA/kbc8fv2PJ2TcYkAKpXbsf
         iUuhxLt97YLncJ5g9SlPM5fg4cx+5OEoc8BqfjgFntbTi8Q+qwlJXM1XtcpvK0yt+h7w
         IQKxHYgVWIWPaERXaS6Gwo1AzBw4axt8Lu/HY2hcIJ6/t1hQmxURbibwpkVxv/rDdSNT
         JDjzspo/xyTDKCa+vUsuPOEdD0u7B9KI1I/IYBWv0JGCuoTApErQrrbMc9QMQoCWMT/Q
         LL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763764488; x=1764369288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fL7AO/YbZegwLET4orHpyrj5KMZ/eiSlht4bCLj4XfI=;
        b=IEKv4xliS5dNvKfBL0yNjU8sM8m7Sj+4JRw1EnFWYZLmqYV3EvfHccz6saubW6NHH4
         30HSBdOVFLFh0MjsJ2rLS8VKpoXuFZ2sjnqWLpK31C/E5V8rHDQQa94GFGhMq71l1WWw
         IrPY7B/hKSmLfggcpzTkkvhXbrwdfixPbnS/jvKJTkotqTuyx3AJDgkqef/jnfuNxOVP
         1rhyRJ388Z/nTpBgO8DqObGoKQGS6CzqNHmXEOH5whmnNm6P9B/Lh/jncqbAMecQS4nX
         JCVSrBI/i9x+yddm5KvLfumjnUZH7qM7EB/29fjrCbB1rKesWqRUJwqap18OfcjWawUV
         uxeg==
X-Gm-Message-State: AOJu0YzqiMz01oR7VzOp6u14fwyGMwzb2Komei3x4RwsYxfqnuTqJPQC
	D3goPRPnEJPCRYkLr4Ile9nh7CtEEIZBmb0Il86DRBXwpvkxIq3d9GbK4S39yWmdDUua1EHTK9/
	lTBdshA==
X-Google-Smtp-Source: AGHT+IFx38F9ERfpPh0lVhU0L2PRJHoxe79c5A/zraSF90gTXT2UYGC9P0VIoAeDIru6h3DDh0xdhuRVZb8=
X-Received: from pjty8.prod.google.com ([2002:a17:90a:ca88:b0:340:c06f:96e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d0c:b0:32e:389b:8762
 with SMTP id 98e67ed59e1d1-34733d845bemr3846543a91.0.1763764488614; Fri, 21
 Nov 2025 14:34:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 14:34:40 -0800
In-Reply-To: <20251121223444.355422-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121223444.355422-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121223444.355422-2-seanjc@google.com>
Subject: [PATCH v3 1/5] KVM: Use vCPU specific memslots in __kvm_vcpu_map()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fred Griffoul <fgriffo@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

When establishing a "host access map", lookup the gfn in the vCPU specific
memslots, as the intent is that the mapping will be established for the
current vCPU context.  Specifically, using __kvm_vcpu_map() in x86's SMM
context should create mappings based on the SMM memslots, not the non-SMM
memslots.

Luckily, the bug is benign as x86 is the only architecture with multiple
memslot address spaces, and all of x86's usage is limited to non-SMM.  The
calls in (or reachable by) {svm,vmx}_enter_smm() are made before
enter_smm() sets HF_SMM_MASK, and the calls in {svm,vmx}_leave_smm() are
made after emulator_leave_smm() clears HF_SMM_MASK.

Note, kvm_vcpu_unmap() uses the vCPU specific memslots, only the map() side
of things is broken.

Fixes: 357a18ad230f ("KVM: Kill kvm_map_gfn() / kvm_unmap_gfn() and gfn_to_pfn_cache")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9eca084bdcbe..afe13451ce7f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3118,7 +3118,7 @@ int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
 		   bool writable)
 {
 	struct kvm_follow_pfn kfp = {
-		.slot = gfn_to_memslot(vcpu->kvm, gfn),
+		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
 		.gfn = gfn,
 		.flags = writable ? FOLL_WRITE : 0,
 		.refcounted_page = &map->pinned_page,
-- 
2.52.0.rc2.455.g230fcf2819-goog


