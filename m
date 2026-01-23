Return-Path: <kvm+bounces-69016-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICWSD0W8c2kmyQAAu9opvQ
	(envelope-from <kvm+bounces-69016-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 19:21:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D610D79825
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 19:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5239F30090BF
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F543280335;
	Fri, 23 Jan 2026 18:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qzwlD6/x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E70926E6FB
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192486; cv=none; b=U3+CWJvEFMH4EMNqChRo+1YN7ejuAajb1w4HNb7w1hElwL218oV6vVpRXo9DCRlqbUgUF8nEyzja/caEOTEm2pwFh/v/U+BlE2bJ/dE1aNr7PIC04wBTLnhMtpGnjA36HbhZvMRpshS50fMuj1W0Iwnm6hlD4nlEl4orxsrQZ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192486; c=relaxed/simple;
	bh=B/e3f9n4D/5COfmGKyp8iAa8BJEIDndW9FwTlQSrCOQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l9KHEW86dhczD1ydg3pDH0C9hV+r5WdeXMXOKLAlytbLi9aDPvz8qeWefnqIOpPfQdiKkpkn7cmGIU1sMbQsdfhydZdR2WA9GFv7iBWAUrhaS6IWp8a2gD+PVUIIKG2y0FXqSwV8HZlzsjwWxE9mugYeWQfg06Z/A7JRHOzhj+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qzwlD6/x; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c551e6fe4b4so1604110a12.3
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 10:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769192484; x=1769797284; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V3qQI0LZscyn4uzqwwAcXgBSVy9A/lS3tIeGNLWTSnY=;
        b=qzwlD6/xezowwo4w/7mvoc/YIazrhAwnaYQaFZBkemGaAmE3mYMJIB89jtFCok4CiX
         pPKI4MYsYqI1bH+AiuOyU6TWyHyyFhYPdrzZ7uV1tncDp8A6MGTxkj3o57Uw7GAOUsKs
         Iep6PqyfVdaro4jvy+mC39ScGUoUmamh7u3rpNsdx2Gd/OuEqM5ahq0WUjtjUYDSZC73
         8CQSwLEM603lZWeDK0aIuu0NUH/KYgFK/2CYxbri+P0ghczDhVxwnS/f6QI2V3d+dIWm
         Pcsx2/7VYadb+gECtpgWqbnRdLjgg7J/CLs/kWh31gkSonocKmAB0QvM17opxdUWQU48
         1Vng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769192484; x=1769797284;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V3qQI0LZscyn4uzqwwAcXgBSVy9A/lS3tIeGNLWTSnY=;
        b=llFNG3NTaLIx+m3MbD4RsnG8G6VM/BOZ1RoDPm367qEPlYs7T4jueY4krLQE4s30qI
         OMpUPz5alYzgJXXxPCmB5Cyu1ivpZPrewkWnf/ikqaYJgMRkp2OBSPLThE4RqCme2i+p
         1uLnVuNyMgZHhg5Jm7HYc6UXGi6cf+SfXgOQHstGubMv3HkqzRuHumwzmYBDYbaiA0TD
         YCn8UXzEOUKYVrA8U3EVcmsvj54HJVoY11ZQeafPKM92zg2lhBw8qufhpN2zjx/PRaO0
         z3Xlg6tukgk+kT1mmwkUt85lPyazA/exfAr7fNdffeiwlxVRW6PT+vUsvNCfRD8o280R
         jK+Q==
X-Gm-Message-State: AOJu0YxwqsJTmnXuyfTAZuxDVHeDk3e74r6ynjD/FATVcWBLObgAJSd9
	kxFeseOZXkZG9PUzcxNxUDLlpG642j/CuQOJDqcTM2wbKadH/i5Ha4VSsDmBDWSC2Mk2jIe8VRO
	ZTaPHrQ==
X-Received: from pge20.prod.google.com ([2002:a05:6a02:2d14:b0:bd9:a349:94a8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:918e:b0:366:14af:9bbd
 with SMTP id adf61e73a8af0-38e6f830530mr3890438637.71.1769192484547; Fri, 23
 Jan 2026 10:21:24 -0800 (PST)
Date: Fri, 23 Jan 2026 10:21:23 -0800
In-Reply-To: <20260115141520.24176-1-graf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115141520.24176-1-graf@amazon.com>
Message-ID: <aXO8I6xuZyZB7CxV@google.com>
Subject: Re: [PATCH] kvm: hyper-v: Delay firing of expired stimers
From: Sean Christopherson <seanjc@google.com>
To: Alexander Graf <graf@amazon.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, nh-open-source@amazon.com, gurugubs@amazon.com, 
	jalliste@amazon.co.uk, Michael Kelley <mhklinux@outlook.com>, 
	John Starks <jostarks@microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69016-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zytor.com,kernel.org,redhat.com,amazon.com,amazon.co.uk,outlook.com,microsoft.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D610D79825
X-Rspamd-Action: no action

On Thu, Jan 15, 2026, Alexander Graf wrote:
> During Windows Server 2025 hibernation, I have seen Windows' calculation
> of interrupt target time get skewed over the hypervisor view of the same.

> This can cause Windows to emit timer events in the past for events that
> do not fire yet according to the real time source. This then leads to
> interrupt storms in the guest which slow down execution to a point where
> watchdogs trigger. Those manifest as bugchecks 0x9f and 0xa0 during
> hibernation, typically in the resume path.
>=20
> To work around this problem, we can delay timers that get created with a
> target time in the past by a tiny bit (10=C2=B5s) to give the guest CPU t=
ime
> to process real work and make forward progress, hopefully recovering its
> interrupt logic in the process. While this small delay can marginally
> reduce accuracy of guest timers, 10=C2=B5s are within the noise of VM
> entry/exit overhead (~1-2 =C2=B5s) so I do not expect to see real world i=
mpact.

There is a lot of hope piled into this.  And *always* padding the count mak=
es me
more than a bit uncomfortable.  If the skew is really due to a guest bug an=
d not
something on the host's side, i.e. if this isn't just a symptom of a real b=
ug that
can be fixed and the _only_ option is to chuck in a workaround, then I woul=
d
strongly prefer to be as conservative as possible.  E.g. is it possible to
precisely detect this scenario and only add the delay when the guest appear=
s to
be stuck?

> To still provide some level of visibility when this happens, add a trace
> point that clearly shows the discrepancy between the target time and the
> current time.

This honestly doesn't seem all that useful.  As a debug tool, sure, but onc=
e the
workaround is in place, it doesn't seem like it'll add a lot of value since=
 it
would require the end user to be aware of the workaround in the first place=
.

If we really want something, a stat or a pr_xxx_once() (even though I gener=
ally
dislike those) seems like it'd be more helpful.

