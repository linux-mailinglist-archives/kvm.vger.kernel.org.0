Return-Path: <kvm+bounces-70288-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCNnJCf8g2kXwgMAu9opvQ
	(envelope-from <kvm+bounces-70288-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 03:10:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 116C2EDE0C
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 03:10:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7095B3018436
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 02:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE09E27877D;
	Thu,  5 Feb 2026 02:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uPBTs/+P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA9A26738C
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 02:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770257439; cv=none; b=pyjw2XEKdpwr78Fo6VOtQShQj9nehXAl4K024Qi4HQWXNS/zH7YES4iTPvv6e4xhbHq8vRHaYWsU1ydpQKxKvl3y4Qc/BsgmsStk/AGfZTqbj+gpImdPEg8So8ATM49TIVWV2z9v10p5sSbFVrbJFn0DinAfoo0caqXNRUI0L98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770257439; c=relaxed/simple;
	bh=9ZdTXtzrOhvRo5simKSEwsH1biecBibpWIc2Pdvnc2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m7oyRJlkXG5fiE91BRF1r058UKc1H/L/QlT3cCVbjn7NxR0aKBDGw4AWkBzbhPKOaC3wHe+VUFEb2p95RACOoOxZC9oQrTGWwdkSwF+HJQJ9VCs84lsC0KpJRzuTPel/aMdEwpjDF0O4XtnLrii/YyAqwlS2dxyqP3giW8zs9gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uPBTs/+P; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7b7f04a11so16415835ad.3
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 18:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770257438; x=1770862238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JdutA3MpqUZBPI7cPMYXXhV0WOf5Qqlo7ixT7ubohgE=;
        b=uPBTs/+PnR0FNiABhXSP0W0MP0CSpRI4n2NluLC3I7gLq0p+IeFJRje4RU72JfQNJb
         fNgwmQoQZn26yAhz0HkeV/JdLdxu8KipQkxNwlfto5uihKu1EIgXGoEhEG+2E2gVN6rG
         mJAjkRN1wCnq/nGPqDAKXnse/t/KKDNemI1SWfst/HBNIi4X9KJ0s8Hpi+8EoYGEHQRd
         34eNCMEqDOzjzXewRSIOSFrHpApRiRHJJaPrgiS6eDLuMs8rceMTcp3arnYX7JbhfJnO
         oJ7iUT5W5RZAAWRIi1GQgetb0qAH7Tvc1YaXzydVDKtqAWCyRKKTRtm1rWpRytir4Y26
         tzVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770257438; x=1770862238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JdutA3MpqUZBPI7cPMYXXhV0WOf5Qqlo7ixT7ubohgE=;
        b=rlRwZtrgD9u33l/7PxQRvpk4OnJpdl4cxIgZ3+gnHevA22uMbhjItRnOb+NbLlAHJK
         72yo9Z6OZEQvYbNA+HQGiYufsvBFIlhPkQcOvKThvwZ9RyqQL76j2iDx6j2FFBRC2WJR
         ox8tUxTx2FcrqIHDgGpk2mhHnr2eTBTDOx0lSMc+NeVRZWWDgmseEFResDsagOj3zeTY
         hy+3XUzzVZ14qgwgvz6bIehY6rOL8uZghS4aKAG+Sft9TkYH4P/+B+fZ61Z/hfpnAhME
         NKv2CYURC/1PqhswwCh2Rp+xOlwsO72EYqJ+gAFqf1X1d16gm3eMUyAkzhQcNCF8Xac6
         jKoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVD9IUubX7BkaTswyiMFJzer2ujXfjXUeFw8TDzo2ylN1uWGlPtZ4COP0cSllM5hnBPRSk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKvUv32yXLnthbEVTC3IZhpzZvRR7C0hlGZMFVMw+e9PEJDTd1
	A7aSRx9bgJxqqGL6pmnuAPdfdIwdpAGbb7X1TpHUO9XgWTtpKqt0yvlMqKzhAGISCfUO9EzWlpr
	dMi5ebA==
X-Received: from plrs9.prod.google.com ([2002:a17:902:b189:b0:29e:fff2:e965])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:196d:b0:2a0:c933:beed
 with SMTP id d9443c01a7336-2a933bc9ba0mr48939935ad.4.1770257438241; Wed, 04
 Feb 2026 18:10:38 -0800 (PST)
Date: Wed, 4 Feb 2026 18:10:36 -0800
In-Reply-To: <byogsjz2vljtzvr7ar4wefm3mrzqxboujz2yugsszgrtkluyks@phifb333vw45>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260130020735.2517101-1-yosry.ahmed@linux.dev>
 <20260130020735.2517101-3-yosry.ahmed@linux.dev> <aYO3AaBqbPy_9XdD@google.com>
 <byogsjz2vljtzvr7ar4wefm3mrzqxboujz2yugsszgrtkluyks@phifb333vw45>
Message-ID: <aYP8HGQrj2aW6NGJ@google.com>
Subject: Re: [PATCH 2/3] KVM: nSVM: Do not track EFER.SVME toggling in guest mode
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70288-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 116C2EDE0C
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Yosry Ahmed wrote:
> On Wed, Feb 04, 2026 at 01:15:45PM -0800, Sean Christopherson wrote:
> > All that said, I agree that pulling the rug out from under the VM is a terrible
> > experience.  What if we throw a triple fault at the vCPU so that L1 gets an
> > immediate SHUTDOWN (not a VM-Exit, a SHUTDOWN of the L1 vCPU), instead of running
> > random garbage from L2?
> 
> I am fine with this too, anything is better than pulling the rug. I will
> send a v2 and probably drop patch 1 (unless you prefer that we keep it).

Drop it, otherwise we'll probably end up wasting several days bikeshedding the
name.

