Return-Path: <kvm+bounces-70847-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cETbONCHjGmHqgAAu9opvQ
	(envelope-from <kvm+bounces-70847-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:44:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 854A8124E42
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 415F8303A842
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37899313E3F;
	Wed, 11 Feb 2026 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DIz2OFRk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EED230C60D
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770817427; cv=none; b=o2ooCw8sBmJTe8UDufSAI6FcHyhyGz4hQBiZz1UoPnYK12MtD+lqNUMg+w9IM7sfoCNiyax3dgX4Jw3d9T4hjOyU/6xT3JVLd0EhHIiDneEMcsGD3L2w5nMxZeUhMhwYYrjUE4JudOnKd9wZPLp8FWc4WUhyUPoLBJtHDLr9CtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770817427; c=relaxed/simple;
	bh=TZ37Bvrlg4hdozP4znjkGc+qBp+utNqS1MSxc4bdZWk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BUAbmmpK7oiQMXSuvSeWf0jbavL1Wd2NPMjD+SmUKL6BCYU8N7+90WVBexPT1rEYwhtTrETHs/io9Urgl+1F37taYoH5MOW9jvVFscdm3LojrLrq5Ga3T+tLp7yRi2srV21LEHQR4NsSA/Z9cSAkb+jGoDBirDn18a0iSvfhVhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DIz2OFRk; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4801eb2c0a5so64687945e9.3
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 05:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770817424; x=1771422224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I12FfwhrrfoTxr7Gt77WEm65McdkOndmZF3CuNey6Xg=;
        b=DIz2OFRku3Btq+1UK3qI9ujMi0h4aLuhqGOdB3ywp/EQWcSIU6z4nJttz5B8aKh/Gb
         ixTt0WMXpQbVB0b7BQPQhxCpREKO8UpFHTx1rb/QbBEV0mb5zxkXqT6rcRUIt3+kPF8H
         YJDu0YHNW3qTwS0lbCxvj4Kz83HglPp5FCD6ENRj1jFlCMZmFqlvowtjOeby5JYk8Jp8
         eC9BgaG90sOJMSd+MKRwzqIz1eYwtbV404CVH146IPR9ih8U5I5Dw9OfbQlEtfGCDNl1
         y9WM2fgeaihlVxpHfz/dqStcBH7aJCGs4prmulAYxpARY84J2kOSdocVYETmFuHPkHyy
         L64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770817424; x=1771422224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I12FfwhrrfoTxr7Gt77WEm65McdkOndmZF3CuNey6Xg=;
        b=NN8vzI/oGMoysXLwxt5KVsE8nYnUTM2fA7CrWV9J/abPxFJzxccA/YlgqYHlvnCY73
         aNl/uLeyAK7dKBNtHg88iztUZXeVe5ZoqJFrQbujRM5XyZGz9ItXDrPgs7KF96giUEs7
         vPxBijUO+0GbCRgMH8uOCWYasQ5XdjxDwxZiYeaxo1+bDLYoPa7LFXqbYev4CVkhYr+m
         bXpnJ0qtkVhtPwxzzXwMY53K2b5sFJZhtxKb4mucWmgbOWiAwO+T34ZFQYbo8lmLXKl2
         XF3bx6jF+TdMtKWzdC69Y+alf/gedrB0eV0oy8OQigtCtN5EEHq0qK/0wNxTY4MKXvAs
         hEXA==
X-Forwarded-Encrypted: i=1; AJvYcCUCHwpkaJjxrqe6JRieYbD3xkIRXeOhrSnD/6jsKvBUa0ZabJCIeEPoymzWwFKrmTwYlPk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz5YbzsQHcf/QS5dR6jfmHBciA4pGTmRQ2jSg6Xu9omfpw0uPt
	+X0lrjQIw6WsF1hDQ6V/xR/ED8DCmUp5Q7zr4BxnNKJTdRDOqqyZ6/JOqbwuRg==
X-Gm-Gg: AZuq6aJhecAyNf0hfOY66pShzuwi1QlKDnzfEHD5HMGigaa7jWwVSJ3AgIX/2LkYtdJ
	nn3oQ8VSp3omcs0K2MGbtxu1c93GfTbK/YfRJ70LXnDGqX3ndRgL9yiqacFAFEqxM3rkTu8uyYm
	bFnHR2E9DxdeFLuRLTgxyIl5pFdAKpu/XqE2MsCKRxqCTv4XGIWXcgIz2YI7VDCFSBAYCVVUJ81
	D+oc9xHUGnOdbOjGPZzQqJFheK903mUVEnEc6dVjNJpKHKxcBy2AyfX5K+N2hGxWP0699x4UBFW
	o3SijGHIAy4x9KjrAyiamm0ZqHX5bdvSRWCy7FEYMLwIPi03Toi0Ou/xdSvZYsrnRW04oHYDGmr
	iPp8KOzmUUt/RLMDqeOBa595BD40tGmylhT4eTj9MMcsxiDcMlosE/JI6M7H9l+a7rERODqlPRB
	ghCE3slTMM6HMZ6YJPu5Uyh0qJz6+Ybpt5hZ98zdGAdM0sdiwI2u34BMQhns6r+0Cq
X-Received: by 2002:a05:600c:4e49:b0:477:c478:46d7 with SMTP id 5b1f17b1804b1-4835081ec5amr78701245e9.22.1770817424144;
        Wed, 11 Feb 2026 05:43:44 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d989165sm54303495e9.2.2026.02.11.05.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 05:43:43 -0800 (PST)
Date: Wed, 11 Feb 2026 13:43:42 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: ubizjak@gmail.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@kernel.org, pbonzini@redhat.com, seanjc@google.com, tglx@kernel.org,
 x86@kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
Message-ID: <20260211134342.45b7e19e@pumpkin>
In-Reply-To: <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
References: <20260211102928.100944-1-ubizjak@gmail.com>
	<2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70847-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com,google.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[citrix.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 854A8124E42
X-Rspamd-Action: no action

On Wed, 11 Feb 2026 10:57:31 +0000
Andrew Cooper <andrew.cooper3@citrix.com> wrote:

> > Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
> > inline assembly sequences.
> >
> > These prefixes (CS/DS segment overrides used as branch hints on
> > very old x86 CPUs) have been ignored by modern processors for a
> > long time. Keeping them provides no measurable benefit and only
> > enlarges the generated code.  
> 
> It's actually worse than this.
> 
> The branch-taken hint has new meaning in Lion Cove cores and later,
> along with a warning saying "performance penalty for misuse".
> 
> i.e. "only insert this prefix after profiling".

Don't they really have much the same meaning as before?
Perhaps the branch prediction logic is ignored (which would make
getting then wrong very bad).
But here (and a few other places) the branch really is 'never taken',
so perhaps the branch hints should have been removed 20 years ago
and now is the time to add them back?

Of course, the branch-hint can only have an effect when the branch
prediction logic gets to see the branch.
The initial instruction prefetch (etc) is done without regard to
the contents of the memory being read - so initially all branches
are effectively predicted 'not-taken'.

(I got the impression that some AMD cpu 'attached' some of the branch
prediction info to the cache-line - and would use it when the cache
line was re-used for an entirely different address. Hence the issues
where non-branch instructions would be predicted as branches.)

	David

> 
> ~Andrew
> 


