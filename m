Return-Path: <kvm+bounces-38458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE662A3A301
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:39:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47F171678E4
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 16:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B1026E64D;
	Tue, 18 Feb 2025 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YKeg9aIv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5114A4E7
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739896738; cv=none; b=itcJh9FwRKwDDTvg+QvoDHlW4MHxd9CWMvY7TYauIGzZp84NoJvk3zGFttIDFtsxourZjrC7WRhKpdwF3EJP0OdbP0iR+MAC9QcutICywba/rspGVWtItI9H5aHCTJAKEaIA7cdiVssmPkWi8tRjgJLvoNiquzq3ItLf7oCaKeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739896738; c=relaxed/simple;
	bh=RH3rP56uby8EG+wYJyP0S0i9RXy3r/rdgw5Kco0+wSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EaFKVwldC/lH9rMWCmZdoubkG9xsTSnmyLbNmL015tINkd8yZm5HM28uu4/mYHcZ9wXoK+cFTCc215qB1+6NfeE3rossyiAtMmv47RZ6itdGPk7U9wkaX2DuqJF9xiLM/8fCBDo+oYFKpalXC6jgaXz4j/ItEkkv64b78wlzYOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YKeg9aIv; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220ec5c16e9so91433855ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 08:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739896736; x=1740501536; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s/2cxuf1JoTO6SVroEVY0mJiDRjaVSu69gtCf8fWHf8=;
        b=YKeg9aIvVnYn+eobOXvC+BAZXac+uQb7rXoPtBFI7J2ISYT4BvtJC+xHpW1CrQvK6f
         TqL3Zhv9ahUBsbdvS9093DKbL04X83QT1v+Zv8dQqJrgILL0EGBOI9yZtChaKnOxor/V
         UV6es+XJhfl9oZp2ppj++xx6aEmNHOjxa1jj66j4gBkCg1kQ9qkJWyzRENCsGT+XSc0p
         PfSOa2/+7502j3lk//OeApp29Y4OkumlGgIb6D5frEbNRQ16dl4yw8+TJwWBylymeJk2
         n15RmcJxCpiLsY90/iu9qLLWjANo8ik9H6ZdqplpCY3LFRROrEl48+699QS8j8/Mgodv
         PKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739896736; x=1740501536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s/2cxuf1JoTO6SVroEVY0mJiDRjaVSu69gtCf8fWHf8=;
        b=EiasenrGBx5lO5rLpu0Or1ULDdN3taJc8/5wx+grK+TKNb4+/VWfuyyeO/XTmCTtIy
         EMj8MOsLLhwkWMu3fRhW9LFBzH6t2WpRYmXhoMKjK841EhC0qg/1YL8x9fS/ZN3tgYl3
         7poUTx5DZ3h1ufqrSMN3mlJN1mHdAvDfbC1XKP3Qe/ueOwoSp+fCWSgxCJ44O+tTDvVx
         RlKp2aFZQWwg7MBt64EvnmzK0rla4nzGezYBd0nuPH9HyqtgKlWTyZmwWUapxlj5WsX6
         7xhWWYNItUIQMAocJok4a5/qgvU/2uwqeIADTx5f79oNOxV9UEgdjYrc4aCeKJKeKeSI
         glog==
X-Forwarded-Encrypted: i=1; AJvYcCXoNn4ldSyJ4RvWL2AdfrRWE/5hKePtxsto51TOv3icEJ+479l/ZRcmJg7d3w+fxIoUwlE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy8mO6VL8C9VqOfIauGQ79mSQo3aEIs+aOnt1EbVbx2KocvtWS
	ai56tqpM3wFmg/VWtADwHnPTHMx21AUED5pP/qNSKtVMUerjfqPQmyd53uMIcEgmP14C+aX0Mfk
	XoQ==
X-Google-Smtp-Source: AGHT+IGz4N5n0ndesWXzGP2ApD6Q37C+sMsEGHLvD3oikIQsMpSyWe7LRrfHaqSbSDOuxeOF+q2qd4wfsWI=
X-Received: from pgbcq4.prod.google.com ([2002:a05:6a02:4084:b0:ad5:45a5:645a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3a43:b0:1ee:c89e:1da9
 with SMTP id adf61e73a8af0-1eec89e1ecdmr4815022637.21.1739896736343; Tue, 18
 Feb 2025 08:38:56 -0800 (PST)
Date: Tue, 18 Feb 2025 08:38:54 -0800
In-Reply-To: <gxyvqeslwhw6dirfg7jb7wavotlguctnxf5ystqfcnn5mk74qa@nlqbruetef22>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207233410.130813-1-kim.phillips@amd.com> <20250207233410.130813-3-kim.phillips@amd.com>
 <4eb24414-4483-3291-894a-f5a58465a80d@amd.com> <Z6vFSTkGkOCy03jN@google.com>
 <6829cf75-5bf3-4a89-afbe-cfd489b2b24b@amd.com> <Z66UcY8otZosvnxY@google.com> <gxyvqeslwhw6dirfg7jb7wavotlguctnxf5ystqfcnn5mk74qa@nlqbruetef22>
Message-ID: <Z7S3ns32Z04sIG2w@google.com>
Subject: Re: [PATCH v3 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Kim Phillips <kim.phillips@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 17, 2025, Naveen N Rao wrote:
> On Thu, Feb 13, 2025 at 04:55:13PM -0800, Sean Christopherson wrote:
> > On Thu, Feb 13, 2025, Kim Phillips wrote:
> > > On 2/11/25 3:46 PM, Sean Christopherson wrote:
> > > > On Mon, Feb 10, 2025, Tom Lendacky wrote:
> > > > > On 2/7/25 17:34, Kim Phillips wrote:
> > 
> > Third, letting userspace opt-in to something doesn't necessarily mean giving
> > userspace full control.  Which is the entire reason I asked the question about
> > whether or not this can break userspace.  E.g. we can likely get away with only
> > making select features opt-in, and enforcing everything else by default.
> > 
> > I don't think RESTRICTED_INJECTION or ALTERNATE_INJECTION can work without KVM
> > cooperation, so enforcing those shouldn't break anything.
> > 
> > It's still not clear to me that we don't have a bug with DEBUG_SWAP.  AIUI,
> > DEBUG_SWAP is allowed by default.  I.e. if ALLOWED_FEATURES is unsupported, then
> > the guest can use DEBUG_SWAP via SVM_VMGEXIT_AP_CREATE without KVM's knowledge.
> 
> In sev_es_prepare_switch_to_guest(), we save host debug register state 
> (DR0-DR3) only if KVM is aware of DEBUG_SWAP being enabled in the guest 
> (via vmsa_features). So, from what I can tell, it looks like the guest 
> will end up overwriting host state if it enables DEBUG_SWAP without 
> KVM's knowledge?

Yes, that's what I'm effectively "asking".

> Not sure if that's reason enough to enforce ALLOWED_SEV_FEATURES for 
> DEBUG_SWAP :)
> 
> If ALLOWED_SEV_FEATURES is not supported, we may still have to 
> unconditionally save the host DR0-DR3 registers.

Yes, that's my understanding of the situation.  If the CPU supports DEBUG_SWAP,
KVM must assume the guest can enable it without KVM's knowledge.

