Return-Path: <kvm+bounces-34164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 907BF9F7DE5
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 16:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66F92166E45
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 15:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3958822654C;
	Thu, 19 Dec 2024 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AKXo0KBP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82E1221D86
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734621840; cv=none; b=jNvT1Zw1V8ODj/GO8hZWFO4XyNKx2aNfrecviI7vVahur9QdABhlA1BALHJMuG/6LAn8cUgz4GCI4Pe6LOdGoIX5spVUI9rnZsgcFzlkmAE9UYOnfx3L4bPdCMqWkhHeazebn/X1fieudvsqAxjHOUF6eQCbI2zm4Z+zqhsHFDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734621840; c=relaxed/simple;
	bh=vQ52mRiElqCZNzqac3CSN8kfDYDhKf+LTt9VTB9knUM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SfledfWJEeIbtsUUCMN1tr9ds8KHzL7kD1PnpfKi9FvRfnrvLTxBbbQm8RV6HK9XUMF/mfFPeG19xZ6sdx1DCrtu6EFm03Hs7JxCR7QWsghQsnKnmKXyCRK6Pn3/s7XvaD6m2rTWaFVaHjG+IVNpRzx9Itjjmwjhsp0ygiBh238=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AKXo0KBP; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-728f1c4b95aso961702b3a.0
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734621838; x=1735226638; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tWsNmzzST8lcMxSYcBiJLWeTL6YuFmSorOwIwOomjFE=;
        b=AKXo0KBPpF20Nk7y2gEsktTi7MxfhjFPHIUscAF5WukhU05OMGF5EHIGf5kblKmHKO
         Xk2oq+GUOUnuKXeGMT5A3kMJSR4Hnff4ud/lDrJ3zHQTjs/n3yfs2Gc6AxQE/kSgPenN
         EZ4jOD58Jl9CoXB8YH45Hy9xCkMyALZ39vpim6Ow8Pa7CQUwXwGjSviPRIbYQDVmHbFn
         Rh0GBj4quGN1qw6B92FwGWBP8FLEewMbowijB9vBxpO4GP1ZK2WxBxM4uVTgIZVBPfSv
         F7oruY/hv57IXicNvoMoxWYlmNsaWww5mjh5RTmkYSLpRsgV+w/7fz26kUNums5M+jCX
         mxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734621838; x=1735226638;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tWsNmzzST8lcMxSYcBiJLWeTL6YuFmSorOwIwOomjFE=;
        b=jb06tIGilERtpH/WbzOgwPgK9+vYGaatYLBdpbWyFjsKWOGuekHBS1Gi/YtVE9x7sp
         +dh25BWEb/JSTJv240iAIfrX0ueQbe6MAJBc1J6N19wf5qtmh514JeTjgoOdC/41atMN
         d30bNPNOa46PtbtTOZrRms9FhiGBvgScqRncckXcmNXxnA3lKokb0brlkSChWOzSMD5N
         9nP/LXx5b+6CAJCAWoqVde5Ah6Qe5cq/imiNHYsFxn+ekzc/volln/GGz6L8Oc9g6zkW
         zLT1eecSZxXPxvuM/EQ07/1OVYfIDjMSfJqOepXnbonPcoH4sBXF2J+Cz5bz9yq6PoS4
         hZwg==
X-Forwarded-Encrypted: i=1; AJvYcCVb1opTZd0jN5j+6JNzYG+gKMCdxIfJSsauZ6Ek/lq4ZB/EyMXdI2MkeVi2JxoYNXZljCA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqeqjRUgXkQdQJ+C1aMmZwz5NINDQb3Va5T2S6en19+lccW9Aa
	WcPC8cN1ebKtSMTF+qASHUbrZdGmmWrbulwpu3+CnJuGIR7WdXo9cxcIpjKgwOATUtNS76XEDub
	gIA==
X-Google-Smtp-Source: AGHT+IGmUvtSYpU2PNr3cYRU0AgkhwMuw643VsMeCpo/v6gnGPtYySVv5u88L3bISsqAABXTw/MmgDxPDcE=
X-Received: from pfbeh4.prod.google.com ([2002:a05:6a00:8084:b0:728:958a:e45c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1311:b0:72a:8b90:92e9
 with SMTP id d2e1a72fcca58-72a8d0310c1mr12598351b3a.5.1734621838249; Thu, 19
 Dec 2024 07:23:58 -0800 (PST)
Date: Thu, 19 Dec 2024 07:23:56 -0800
In-Reply-To: <faccf4390776ca78da25821e151a4827b1f8b3a9.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com> <20241214010721.2356923-10-seanjc@google.com>
 <39f309e4a15ee7901f023e04162d6072b53c07d8.camel@redhat.com>
 <Z2N-SamWEAIeaeeX@google.com> <faccf4390776ca78da25821e151a4827b1f8b3a9.camel@redhat.com>
Message-ID: <Z2Q6jK1E0KfX7n7l@google.com>
Subject: Re: [PATCH 09/20] KVM: selftests: Honor "stop" request in dirty ring test
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 19, 2024, Maxim Levitsky wrote:
> On Wed, 2024-12-18 at 18:00 -0800, Sean Christopherson wrote:
> > On Tue, Dec 17, 2024, Maxim Levitsky wrote:
> > > On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> > > > Now that the vCPU doesn't dirty every page on the first iteration for
> > > > architectures that support the dirty ring, honor vcpu_stop in the dirty
> > > > ring's vCPU worker, i.e. stop when the main thread says "stop".  This will
> > > > allow plumbing vcpu_stop into the guest so that the vCPU doesn't need to
> > > > periodically exit to userspace just to see if it should stop.
> > > 
> > > This is very misleading - by the very nature of this test it all runs in
> > > userspace, so every time KVM_RUN ioctl exits, it is by definition an
> > > userspace VM exit.
> > 
> > I honestly don't see how being more precise is misleading.
> 
> "Exit to userspace" is misleading - the *whole test* is userspace.

No, the test has a guest component.  Just because the host portion of the test
only runs in userspace doesn't make KVM go away.  If this were pure emulation,
then I would completely agree, but there multiple distinct components here, one
of which is host userspace.

> You treat vCPU worker thread as if it not userspace, but it is *userspace* by
> the definition of how KVM works.

By simply "vCPU" I am strictly referring to the guest entity.  I refered to the
host side worker as "vCPU woker" to try to distinguish between the two.

> Right way to say it is something like 'don't pause the vCPU worker thread
> when its not needed' or something like that.

That's inaccurate though.  GUEST_SYNC() doesn't pause the vCPU, it forces it to
exit to userspace.  The test forces the vCPU to exit to check to see if it needs
to pause/stop, which I'm contending is wasteful and unnecessarily complex.  The
vCPU can instead check to see if it needs to stop simply by reading the global
variable.

If vcpu_sync_stop_requested is false, the worker thread immediated resumes the
vCPU.

  /* Should only be called after a GUEST_SYNC */
  static void vcpu_handle_sync_stop(void)
  {
	if (atomic_read(&vcpu_sync_stop_requested)) {
		/* It means main thread is sleeping waiting */
		atomic_set(&vcpu_sync_stop_requested, false);
		sem_post(&sem_vcpu_stop);
		sem_wait_until(&sem_vcpu_cont);
	}
  }

The future cleanup is to change the guest loop to keep running _in the guest_
until a stop is requested.  Whereas the current code exits to userspace every
4096 writes to see if it should stop.  But as above, the vCPU doesn't actually
stop on each exit.

@@ -112,7 +111,7 @@ static void guest_code(void)
 #endif
 
 	while (true) {
-		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
+		while (!READ_ONCE(vcpu_stop)) {
 			addr = guest_test_virt_mem;
 			addr += (guest_random_u64(&guest_rng) % guest_num_pages)
 				* guest_page_size;

