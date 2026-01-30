Return-Path: <kvm+bounces-69752-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJFcLFwbfWlQQQIAu9opvQ
	(envelope-from <kvm+bounces-69752-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 21:58:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C22BE982
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 21:58:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5C8D301AB8B
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 20:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55901376BED;
	Fri, 30 Jan 2026 20:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0qs6aWGt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152FC36A024
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 20:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769806675; cv=none; b=H6BVlMp5HPjs8zdVqppJRm54xXR6m9G8l2QhpcQdPzLK15k0pwlGh6t1FFSBX+AIgkDjYW8E3vTFcIIobgBIBah6eh5KZcxLUoc01nSlXNMi80f97hLkZ4AudT7LW1Yz/VnRDAqTiiJwiY59UvFMNZCwj9POwweqQN50ovXojpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769806675; c=relaxed/simple;
	bh=surdvNyAWb5aFhEVOazzpqaX4SI9Q3dfsvJJRenHXjw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gmjjjdg492yAqZRGW3yrr1kzZLVrI9HS96e6jn24Opsy0IP7305n/0BFLWgxXR7E79Ykw1adom5PBwXlWZgYj3230rdB8EAyDgVVuFdhBRnPTdEvYeR2pcaQMUGL875orP3Fo6vfGkPqIQgH23oFGvJP5nwhov4C8qg+ZEIbs4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0qs6aWGt; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so1742266a12.2
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 12:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769806673; x=1770411473; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KlBn3wgH+Vx1whhSH0EtvZtp0EPVxI1IXEnijlD+ikQ=;
        b=0qs6aWGtY4Cv+OKNQxT7xaYtqguitSSB+PPmSAd4vcgniXrqaTTPgvvQgudY9sLZKN
         NAhmBVfWsuT0drFt9tbYQvd1I0i5bv3y0IHNfNGXDSb590Ofzw+OLW2+GqSio504VRRy
         Nxywf50RkDIzhkZmydd4urjpjkTt0VnCxGpPneLIp5kJmMuKtem00rym3hLSMXfopcvQ
         kJ70wIz74g5s0zw7f2vIpzr2aCeFbNgXt+KrBB7mb0le/IqJXRErwhlYrQm/Lmgh+/oz
         4ZrsxAJmqSTrgOUxTT0Jrr8rNDp4pFSWYOSmetPclyP9qwf/pwPSv3NqD63l00MA/x6r
         9RHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769806673; x=1770411473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KlBn3wgH+Vx1whhSH0EtvZtp0EPVxI1IXEnijlD+ikQ=;
        b=Dz5ouYLzY2f+igtDGylUZzCj3V8h+bAaw9U4R8UGv8toi6eebWtAP+eiZ1gR2oteUc
         iWY4wfIK+hzucfp6DTb2mjKubS1HJRdNpE6rtJcQnCgH0PEEdCXmnUMq3hAQLsNKczpm
         QvB+X0+Ddc1/ZNcFiZXsTOXhk3MAQH/8BycRUbUQbm7CTsmmsiO+fhBVB0IOVAPT8P5C
         EjOUH1TtZ1N6Ip38eqVUx0F1uOyjeKxyQf1b8ypuadNA0qm87rFgPyxPxsXuRSYx9fCR
         KR7xq03Px8R2Tb0M0hTBYjqiip2tDY/vvdNXIQ5wi+r1wgKXj9ZTCyhp7KlwGWSKALMm
         CDjg==
X-Forwarded-Encrypted: i=1; AJvYcCXZrgKsyIHWbt1gRjK4JNthEoCbfyt0a+aUxIboIV0ow0NHRQ0wBNJTpXewUG0HWv/1wHA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3fIdWBJSjdQ9CyKVbTE2XbY3vfOF7h0oKU9ENNJP7IvPOr4kX
	CrnWB3s8ACFp5vW6ruA7MT33JjpMwm2XHF9TgHlYgnxGjGPxwRBv19MOjboWUy8OFqWDupJdKsN
	6RfikWw==
X-Received: from pjbna6.prod.google.com ([2002:a17:90b:4c06:b0:34f:8ef8:5834])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5101:b0:340:bb56:79de
 with SMTP id 98e67ed59e1d1-3543b3b035cmr3442837a91.30.1769806673212; Fri, 30
 Jan 2026 12:57:53 -0800 (PST)
Date: Fri, 30 Jan 2026 12:57:51 -0800
In-Reply-To: <20260130204424.1867-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260130204424.1867-1-lirongqing@baidu.com>
Message-ID: <aX0bT-sKOSEVHHC8@google.com>
Subject: Re: [PATCH] KVM: SVM: Add __read_mostly to frequently read module parameters
From: Sean Christopherson <seanjc@google.com>
To: lirongqing <lirongqing@baidu.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69752-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 54C22BE982
X-Rspamd-Action: no action

On Fri, Jan 30, 2026, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Mark static global variables that are primarily read-only with
> __read_mostly to optimize cache utilization and performance.
> 
> The modified variables are module parameters and configuration
> flags that are:
> - Initialized at boot time

Please make these __ro_after_init where possible, not __read_mostly.  E.g.
force_avic is definitely read-only after init.

