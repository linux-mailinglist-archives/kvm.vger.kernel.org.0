Return-Path: <kvm+bounces-71726-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qM9SEnZLnmkSUgQAu9opvQ
	(envelope-from <kvm+bounces-71726-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:08:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF3B18E881
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF2EB30428B8
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B937921CC5B;
	Wed, 25 Feb 2026 01:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SN+X9/Ic"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF22518B0A
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771981676; cv=none; b=h8DnLdWcSkHkUSJQOHh3mM5vR6rU9amzK1Lr+6xm/FdLIh3G9A8PDOswX2/jQqnyqfflBnKuAyvEB6pghVy5znJGVTjs4YT30Pmyk/Te/KODqNmgYxvY1GqDlhFRh65Sxd/21iCRDyu2GoG10yIuwZGMyrl97+Qp3QOecDtQ4Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771981676; c=relaxed/simple;
	bh=IOuz76W6dN0mUPK1fxy9EUTGoV06lD7u2mjN7dCscsw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J2wDWIo7K2aW8YaKs9ro3BGjdpsAyiwObxPxuhKF8Vl+snH1BptYGf4OxqWeNcu42SYpiq2uWuIOmKOUEITrBq5SgPZ6sxcv3SM75exyZ7Kds0F5FL7XYCBUpZ4q6AviU8eGHtm0E5z0Pg1UclwOBjvGsmcEZzVPurFnf9Md10w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SN+X9/Ic; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aaf2ce5d81so77830285ad.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771981674; x=1772586474; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qfICrdoZGU5dSpy1k+lwPY/4a2xC7bOahCW28VqC+Hk=;
        b=SN+X9/Iczq2jbZK/WMuS3PkDhSUp4zf0MnThO534W1Mnvgu62dGcZrfc66Vauew0JA
         BCb/dRcaYg1svl1alhzEgltr1fZqVFpoANeXGpACJpQh710CdWJYWUX9ceGaQBlmYEh6
         kLHYq9XW2h2Wx+3RbgPCn9avdbiIMY+QXe0qL2w1H23urEPy4M3BPWGUxE32l39SZ7Mx
         xP1wZtzH5YnAwJ+kNUvdl6MrHX7sfHnWR9+5HlHvDzLeTFtS9mPuGIxXnMc/v55/XF1Y
         OO4JCI7FssAJzPathfGhbrxym6LQ6RgLzfpGqQINn4YlW9wrq2wQyINVibP+TBpuIPHL
         bX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771981674; x=1772586474;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qfICrdoZGU5dSpy1k+lwPY/4a2xC7bOahCW28VqC+Hk=;
        b=w/YayGaxSKmUkVUZr9BtN0KYyFf/kaAy2OFkbvEKK/sGLPbXwmFHkHKmDMqwl0Y0Wu
         pUiH0MGys3L3f2brVk8aiBbbLiJNaQeDoWKPNJEkMP6KjFzxqx9Cb6lU2wk72sfQ31ms
         434e8sXB5CLRFwfxMgce/6HI/TSA/CNiBjDyyUyCGhP7EHKgz5Jk3fVb2XQm3qL/BbCE
         0OUj+5pKqn8lyOcKb0PFBOV1jwI6wjYuILz/+Wwk29r96IIsXEXD3Cmitfs+mPSV0QrE
         Mi4LjY8DrXFuQ0m8jYQb6imS5vuVCt4lwr81BiZs95wSrC4oQPyCYBipttSeVjbVfTcl
         Oj/g==
X-Gm-Message-State: AOJu0Yz9xXk5CVBh/u5Atjmx7izlhXQpvVKWOajSj4zpAKaAv5zKWdpW
	hFKgJh03zsmdgxciyoSLTT1Au6WhI2BZuAVCHWqaQP5wM6frRGW4MplyGpMLgW6rZFP42R70oHk
	HCz8HtA==
X-Received: from pgk28.prod.google.com ([2002:a63:a1c:0:b0:bc5:4dbd:5a2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4d0f:b0:38e:9ebe:5267
 with SMTP id adf61e73a8af0-3959f66cb2dmr567132637.57.1771981674026; Tue, 24
 Feb 2026 17:07:54 -0800 (PST)
Date: Tue, 24 Feb 2026 17:07:52 -0800
In-Reply-To: <10d3f95717b7072e30576b7e3931ea277399fdf8.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <10d3f95717b7072e30576b7e3931ea277399fdf8.camel@redhat.com>
Message-ID: <aZ5LaBCiG2PFFXyG@google.com>
Subject: Re: Question: 'pmu' kvm unit test fails when run nested with NMI
 watchdog on the host
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71726-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9FF3B18E881
X-Rspamd-Action: no action

On Wed, Nov 05, 2025, mlevitsk@redhat.com wrote:
> Hi,
>=20
> I have a small, a bit philosophical question about the pmu kvm unit test:

The problem with philosophical questions is that they're never small :-)

> One of the subtests of this test, tests all GP counters at once, and it
> depends on the NMI watchdog being disabled, because it occupies one GP
> counter.
>=20
> This works fine, except when this test is run nested. In this case, assum=
ing
> that the host has the NMI watchdog enabled, the L1 still can=E2=80=99t us=
e all
> counters and has no way of working this around.
>=20
> Since AFAIK the current long term direction is vPMU, which is especially
> designed to address those kinds of issues, I am not sure it is worthy to
> attempt to fix this at L0 level (by reducing the number of counters that =
the
> guest can see for example, which also won=E2=80=99t always fix the issue,=
 since there
> could be more perf users on the host, and NMI watchdog can also get
> dynamically enabled and disabled).

Agreed.  For the emulated PMU, I think the only reasonable answer is that t=
he
admin needs to understand the ramifications of exposing a PMU to the guest.

> My question is: Since the test fails and since it interferes with CI, doe=
s it
> make sense to add a workaround to the test, by making it use 1 counter le=
ss
> if run nested?

Hrm.  I'd prefer not to?  Mainly because reducing the number of used counte=
rs
seems fragile as it relies heavily on implementation details of pieces of t=
he
stack beyond the current environment (the VM).

I don't suppose there's any way to configure your CI pipeline to disable th=
e
host NMI watchdog?

> As a bonus the test can also check the NMI watchdog state and also reduce=
 the
> number of tested counters instead of being skipped, improving coverage.

I don't think I followed this part.  How would a test that runs nested be a=
ble
to query the host's NMI watchdog state?

Oh, you're saying in a non-nested scenario to reduce the number of counters=
.
For me personally, I prefer the SKIP, because it's noisier, i.e. tells me p=
retty
loudly that I forgot to turn off the watchdog.  It's saved me from debuggin=
g
false failures at least once when running tests in a VM on the same host.

> Does all this make sense? If not, what about making the =E2=80=98all_coun=
ters=E2=80=99
> testcase optional (only print a warning) in case the test is run nested?

Printing a warning would definitely be my least favorite option.  Tests tha=
t
print warns on failure inevitably get ignored. :-/

