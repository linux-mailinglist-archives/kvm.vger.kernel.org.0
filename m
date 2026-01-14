Return-Path: <kvm+bounces-68094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C23D217DE
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 23:07:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 50210300E806
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1276D3AA19C;
	Wed, 14 Jan 2026 22:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lggvkHTT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508EF3AE6F5
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 22:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768428443; cv=none; b=oYMF6ZClTmLI148cwxODxZmefK9o2xD5QPHFRhYNDTQ/PNNPDsRUXH+xDkujZtwGJ2UIS17A745fB4OJOVETGnDqOjyncNA8fdDNPyAmg+vZGDFlc2wU827bZpTXYa/9GoNJAGWWfpu7fd30njnThaq+puVvah+/e7pLa+fYy38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768428443; c=relaxed/simple;
	bh=ElI84M0BIOSftAGLVaXtQEldUGCc1BnYArgvHMyYoKk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JQtRLeUDQ3fay5qBE5aOYLCRoA1NKSG9vEFNOSrV434X9GZA+vLiyIp04eYS88IBdr8Qh2EZimJ6M/HvhmUO8A61H9zytEqKhit7N0039R9r2gMOfsDuhXKF8QU2/TpUSZ0UCdvB6xFSvW/3lZY/Ie3HcmH1N+Ej9vEfKMOfjq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lggvkHTT; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0f4822f77so5871315ad.2
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 14:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768428432; x=1769033232; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DATGHMH+tRYW0PdOYhPY0pT6PT3USRJNw+EAenWZUkM=;
        b=lggvkHTTXWatg+m8O6ODY7bpqmWLFpEhqIZIHVjHdZN98ybVpa1ArteiwNiXMFcQoD
         i4Cs0YTeIgmVgvO3Y7nkTrfoZA63OQ1j4tWmNj43jtXloU85CvPUmLs3aaaUdHfvGNOw
         2r4Tts2+MHVSvy6uhb6CDt/pbXDSsrV0sqx7zIKCGQEnuIZc7DGTuGIHXu4tWqmzvjtE
         W/Fu4HQurj8e3pZGOpgN5O1yNG0+ADSObWz64MLd3HqNBFX33aUSptlNXlWgYn9nGocU
         w8YNCLO0S+NlcT6RPT08RoLxtymf8KdHA7E4P+36/FVywHXEkSAgA6w7cKkhSZyxaZTf
         2M7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768428432; x=1769033232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DATGHMH+tRYW0PdOYhPY0pT6PT3USRJNw+EAenWZUkM=;
        b=GBzuBjHj/6LYcf9Uvzhp0Q8h7cwWWN6aIcgsygIPpsGaMLiB5VlxsomL5L615nTXvR
         oJ199CJw99mrfPU+wkrHhdRAHg+HPDvj9swOgCJI+/REaEJJ+kO2igk88h8LKCyg26+V
         HJKSgFjtrmV8dNikAcLMoXma8ZM9LthLqL5nKCBpVhTIBpX7KYLUNL9lhCjhsE80pSdZ
         3RJ1o+wjj+pOkQmpmDmD3c69Q7FsZ/IDgvQo3AQoh66m7xRhy/qB/duzh/GjRe/256wG
         xbErVcqKDpzbb1xQPf0E6El8466zy+D/QsR/Scsho4eT1TQnNbF0In6gEStpcslBAERP
         jxdA==
X-Forwarded-Encrypted: i=1; AJvYcCVzsF5/w0eNWEHstz/+iTfQcPmk2t2hORzfd/+fH78nijACznoqmRSiP4wBkVJB6qzxTtw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOr5jZqJApsalkjoxvV44TWYVuU9BjmW1Ykq+cqnWZSE4LJCGc
	BLZ9RBWmROyyNz0J6UgBWJ0UAuKHz6VoTPmH6tnCgnTQVpnVHtCUHhuzBIKqbOohaI2J/unKdvj
	I7waX4A==
X-Received: from plqs2.prod.google.com ([2002:a17:902:a502:b0:2a5:8c4f:4c6d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e78b:b0:29d:65ed:f481
 with SMTP id d9443c01a7336-2a599cbac4bmr36340125ad.0.1768428431740; Wed, 14
 Jan 2026 14:07:11 -0800 (PST)
Date: Wed, 14 Jan 2026 14:07:10 -0800
In-Reply-To: <rlwgjee2tjf26jyvdwipdwejqgsira63nvn2r3zczehz3argi4@uarbt5af3wv2>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
 <3rdy3n6phleyz2eltr5fkbsavlpfncgrnee7kep2jkh2air66c@euczg54kpt47>
 <aUBjmHBHx1jsIcWJ@google.com> <rlwgjee2tjf26jyvdwipdwejqgsira63nvn2r3zczehz3argi4@uarbt5af3wv2>
Message-ID: <aWgTjoAXdRrA99Dn@google.com>
Subject: Re: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 15, 2025, Yosry Ahmed wrote:
> On Mon, Dec 15, 2025 at 11:38:00AM -0800, Sean Christopherson wrote:
> > On Mon, Dec 15, 2025, Yosry Ahmed wrote:
> > > On Mon, Dec 15, 2025 at 07:26:54PM +0000, Yosry Ahmed wrote:
> > > > svm_update_lbrv() always updates LBR MSRs intercepts, even when they are
> > > > already set correctly. This results in force_msr_bitmap_recalc always
> > > > being set to true on every nested transition, essentially undoing the
> > > > hyperv optimization in nested_svm_merge_msrpm().
> > > > 
> > > > Fix it by keeping track of whether LBR MSRs are intercepted or not and
> > > > only doing the update if needed, similar to x2avic_msrs_intercepted.
> > > > 
> > > > Avoid using svm_test_msr_bitmap_*() to check the status of the
> > > > intercepts, as an arbitrary MSR will need to be chosen as a
> > > > representative of all LBR MSRs, and this could theoretically break if
> > > > some of the MSRs intercepts are handled differently from the rest.
> > > > 
> > > > Also, using svm_test_msr_bitmap_*() makes backports difficult as it was
> > > > only recently introduced with no direct alternatives in older kernels.
> > > > 
> > > > Fixes: fbe5e5f030c2 ("KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > 
> > > Sigh.. I had this patch file in my working directory and it was sent by
> > > mistake with the series, as the cover letter nonetheless. Sorry about
> > > that. Let me know if I should resend.
> > 
> > Eh, it's fine for now.  The important part is clarfying that this patch should
> > be ignored, which you've already done.
> 
> FWIW that patch is already in Linus's tree so even if someone applies
> it, it should be fine.

Narrator: it wasn't fine.

Please resend this series.  The base-commit is garbage because your working tree
was polluted with non-public patches, I can't quickly figure out what your "real"
base was, and I don't have the bandwidth to manually work through the mess.

In the future, please, please don't post patches against a non-public base.  It
adds a lot of friction on my end, and your series are quite literally the only
ones I've had problems with in the last ~6 months.

