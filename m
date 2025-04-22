Return-Path: <kvm+bounces-43825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9EDA96DBC
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D2B317FD9D
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 14:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B40284B55;
	Tue, 22 Apr 2025 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZZdKe/UB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C3A283CA5
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745330423; cv=none; b=XpNRzt9nFNfnGV48lqtBd9RUSCjUSuTnIK3B70C+IOKTMoxxyYDbZzclutXKlsT/WHi+trA8s/VKI0LlrAvFhXTm8TIm1Cbaj7PFTUc42btxkn2mN9X94+lAabM/7lyqIEhBL26rzSD9juTRceEwfXXJ9oNI4hz6V6qPZ8hNJe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745330423; c=relaxed/simple;
	bh=Qrd8E6rQGgaNid2lXMdhUjAEhxknwnHpoQgES77+eOY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gojzd7bSyk2Vm7qsewsrgSMTGusCQk+sIQP9TDnVl2FviCJ9eAwNiesIocM58Gw+YUK1KycXT2+wdQJlOpn0ksqs5zulrO5w9sp/GLK1d65KWxtsd+rC33aeWx3AJ51C7lyfulUWwuSOdNcWxN2U0EUiH9Q8NFjJDZAmBQDKLKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZZdKe/UB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30872785c3cso7411891a91.1
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 07:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745330421; x=1745935221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zeMUCrpneE0eM8QQGcgB52tCP0giwOPvb2pL9U/fAAc=;
        b=ZZdKe/UBCoH4ovppiVV1vwp3kfK2Z8ZWFrNyzlKXMuF4irU1eerNrRpfXAXWpKbybD
         TH3aMNrxKEI/wLpRXKQxMB+2EauBg31ePzFSKae8NGuMxZlbZ7w4yfHeGAWAGjdqlWyX
         k+N3tyNhjmieEz3r/SSk72pseyj+eBZknl8q69VwkAkDH7euRD7XlVraQdxno8m3ExgO
         I93Y7l5hmF6HiyNt06KpX5Pk/mFBTUikXKCC3hIBiy/jYLsdZEqJC03kJD105W0fzCsn
         6yKcff66EsxNrRqsXvh0CBN/Tu0zv209mWHn883v/ie0+kvAAuOdQYWb4y7nKJJROpje
         cJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745330421; x=1745935221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zeMUCrpneE0eM8QQGcgB52tCP0giwOPvb2pL9U/fAAc=;
        b=HS/0AL6VfxKErriiYQNPhppm/gM1CGfS7ZqgZ5u5Z4QvnKyU5WoE19MKKQSuEg0Y43
         6IWaAynyxJQ3ht8Ng4H7q0qrqokg2z5400w3hIHPX4bi7RCIuIr0cdzwx8+bN6NsyX6L
         wR1e30cGHBfTx2gJLq7cxXyX578CE89y1kxfd0JB/vjtYh+MvX0rOCm7GzgKKylZCmSE
         XSlsZCoKrprQX52X58Lwjb3I2Z4PSz0+aAxv85iywajqqQ787FCBL4CdFB/sVBHHwxTB
         +2qRdv1PlhVpqymzlRzJyuTyjg53C+JQAMQ+Zeh1XCVRcnlmn0h/24O992s3b0ZLuuS4
         is9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWNol5g6tAMGqPJ7glL6vrk5oIKgD5GV7LbB+gxuf1mpJKIqs4cwOkZIOe5ifDAOhgIll4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh1Z0jmIpDilQnqPMPNCS/wHYtJEp4hcGzGy+hKGejnaoVgZKc
	S53bKQvZH1bs3xI2DZnJHZ6tTjbhjzimExMpdS4MczcnaGmD+tSiNFSUG9E30KD4O2yPFbuh3zN
	Luw==
X-Google-Smtp-Source: AGHT+IEvTg4hIB6sZM1LfDB3TLcVZ/5zwTRjPR6Ejhn7pPEgGGtj2UYeC50jNHB+/sQa6F+bLVoU96ShxpU=
X-Received: from pjbpv14.prod.google.com ([2002:a17:90b:3c8e:b0:2ea:aa56:49c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2751:b0:301:98fc:9b5a
 with SMTP id 98e67ed59e1d1-3087bb4150cmr20535629a91.6.1745330418616; Tue, 22
 Apr 2025 07:00:18 -0700 (PDT)
Date: Tue, 22 Apr 2025 07:00:16 -0700
In-Reply-To: <20250422173341.0901ebaf@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422124310.2e9aee0d@canb.auug.org.au> <20250422173341.0901ebaf@canb.auug.org.au>
Message-ID: <aAeg8A7DMvTAjqVO@google.com>
Subject: Re: linux-next: build failure after merge of the kvm-fixes tree
From: Sean Christopherson <seanjc@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Stephen Rothwell wrote:
> Hi all,
> 
> On Tue, 22 Apr 2025 12:43:10 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the kvm-fixes tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > ERROR: modpost: "kvm_arch_has_irq_bypass" [arch/x86/kvm/kvm-amd.ko] undefined!
> > 
> > Caused by commit
> > 
> >   73e0c567c24a ("KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled")
> > 
> > I have used the kvm-fixes tree from next-20250417 for today.
> 
> I also had to use the kvm tree from next-20250417.

It's a known issue[*], just waiting on Paolo to resurface.  :-/

[*] https://lore.kernel.org/all/20250418171609.231588-1-pbonzini@redhat.com

