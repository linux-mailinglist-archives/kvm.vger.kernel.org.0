Return-Path: <kvm+bounces-58035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A75C0B86204
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B50E1C881EC
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A76253F1D;
	Thu, 18 Sep 2025 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c0T4xEja"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A902475C7
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 16:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758214342; cv=none; b=NVFZsTpf0muJuC36YQHLZ9Grxls3J971UABLxRyit6MN5EhtYwNh++/WUnG2v10c1dHTqJqFErfi35OdTeYk2fOima49gNxK/YUjTFC0Yj5NtzJLpJW/W2rBn84bN0gWlw/kor28JgGeSV/L1/VVDX0YF8icN108iDT6SUJ+ka4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758214342; c=relaxed/simple;
	bh=g+mvzN6J31AfqxKTFRmGGmksy1PcEAtdFhY3hfNn26E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PyChCrKtS297jEerI6BEEfI6f29EuyVjuiV6j3U9DZP2lS3LSFIXOPZ5Jyb8uHoKmiRmHoFr7e6mQwpeUdEmnKf7e5HcNxiRB70m3Ge3TJvrpxFV81fuyBdQW7UZdHLC004388vCGfnZX5glcPnAIc6GLki4LO7FGppWc2ucKPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c0T4xEja; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3304def7909so1205490a91.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 09:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758214341; x=1758819141; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TsOm7EtOKhXmScTczmTf6QtxSQ4DX78bGCwpxVq0Ey0=;
        b=c0T4xEjagwMG50CIaqueHk0sCeB2lgAViBiIgpzCcmdGsxt0rcUBDPSRGSho+SQgJu
         bZQhZOGxzILqrD8SpT8kdz3EyBhU4E3b9bRQmzEuYiXpOyArjjbtE8EhAFORUUSGvWSk
         vJhG+hkyad5fu7QCqiG1KAACD44dxb332xzWw0gLXaxsSdWYe/39UvbnPnRFNoixlzjR
         V7j0l/AzIusZH3cQlmyh6ensJJHomRUlC/oeIt3BINHokq82dyIWdQkXE/3W3A5awF2I
         fVQStxtxU7gc1/tP7fcKkuWN607h172P5uSbSUoOWLJyUlv6tvZfh8wWVxVSmUIW4DJV
         jYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758214341; x=1758819141;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TsOm7EtOKhXmScTczmTf6QtxSQ4DX78bGCwpxVq0Ey0=;
        b=eww8Bqe663BJUkXQcxzV6TqPKFzoathbsqiSS2dzVHGuZrpbzWh31EcgEtUZt2+JF5
         9sXRn9w2OcA7MJ8f36RzZ+cdqcqXeOUoAJX8LstakhKI2yeOXuPP0vzrH/uZtMUBuTks
         2AfWE3lHUhoSWiNabtFsrnycdD8hruhAVWLrAxWT5BA1qzb1IVvXEJz3AOun8e4B/5VL
         YnItrbllKHj+mEPpkdPVwYb2lDT7NtYC0tjdNCqcOG4R7cKUfBn4HR7vtYmyVqGQ5Dpk
         Plscxr9kEsZnvq5uDSFjHVHSKUIsFXlFSS9W4BxWVhaLwGw3K6sN7K/vXyC2JX+ZQJXV
         kljw==
X-Forwarded-Encrypted: i=1; AJvYcCV7DwwH6NTLajd2/0D32PGqLfY088Zqlz2K4zlfCenNiM0xLrqklSKJ32f6r7N5USQrXng=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPazbsz5Wm/6CUFAdOIRtf4joLL7DU6N1QrdBgZXzi2Ow+/1SJ
	b47AJfQcgpTsvMm6Mp3PB03MKRAKTfxH7GMnYmVrPw2Hm6C9d+d8R+MmpMTrZq5Om4/KZ/W2I3L
	REPDqHg==
X-Google-Smtp-Source: AGHT+IEZkwSUL2OHRLRPak5y7ADnxAbFSYdsmOIZcHrSCCNpbNhv66RerRTNz5VfhHWZmuNmvGLbT6SRYfY=
X-Received: from pjl3.prod.google.com ([2002:a17:90b:2f83:b0:330:72b8:fcc0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:498e:b0:32e:2059:ee5a
 with SMTP id 98e67ed59e1d1-33097fce1b2mr65859a91.8.1758214340696; Thu, 18 Sep
 2025 09:52:20 -0700 (PDT)
Date: Thu, 18 Sep 2025 09:52:19 -0700
In-Reply-To: <20250918120658-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827194107.4142164-1-seanjc@google.com> <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org> <20250918154826.oUc0cW0Y@linutronix.de>
 <aMwtd40q44q5uqwr@google.com> <20250918120658-mutt-send-email-mst@kernel.org>
Message-ID: <aMw4wx5ENt-odhYS@google.com>
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited task
From: Sean Christopherson <seanjc@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 18, 2025, Michael S. Tsirkin wrote:
> On Thu, Sep 18, 2025 at 09:04:07AM -0700, Sean Christopherson wrote:
> > On Thu, Sep 18, 2025, Sebastian Andrzej Siewior wrote:
> > > On 2025-09-18 11:09:05 [-0400], Michael S. Tsirkin wrote:
> > > > So how about switching to this approach then?
> > > > Instead of piling up fixes like we seem to do now ...
> > 
> > I don't have a strong preference for 6.17, beyond landing a fix of some kind.
> > I think there are three options for 6.17, in order of "least like to break
> > something":
> > 
> >  1. Sebastian's get_task_struct() fix
> 
> 
> I am just a bit apprehensive that we don't create a situation
> where we leak the task struct somehow, given the limited
> testing time. Can you help me get convinced that risk is 0?

I doubt it, I share same similar concerns about lack of testing.  So I guess
thinking about this again, #2 is probably safer since it'd only impact KVM?

> >  2. This series, without the KILLED sanity check in __vhost_task_wake()
> >  3. This series, with my fixup (with which syzbot was happy)

