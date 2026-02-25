Return-Path: <kvm+bounces-71860-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QCFLKys1n2m5ZQQAu9opvQ
	(envelope-from <kvm+bounces-71860-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:45:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EAE619BBD9
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C41B73028534
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA923E8C5F;
	Wed, 25 Feb 2026 17:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tnsk8RNq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A863ECBDA
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 17:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041509; cv=none; b=HgFD9CEP5+7gAs4VwYNWvz0PeroFdAqfaHhc92Wwe8wxbmQs5HiUamoGqbbXhitSjqRRDbnO1C3PFo2q8kg/Ivg8KKjgSzdSbbTnBYzoOpOdvEUQTcC9ThPrrm1mLPNz7bFALkrraPAf2UIaxsNKMr11iy9fDGcSmjMqrbPiZTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041509; c=relaxed/simple;
	bh=P/hBoEMiXYtzSJAai3x+/Zjn0NP0IL/2TZ2kRQnBAyM=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=lWC3sD0ln2gYKnBzvOwxOAq/xzQvdtAbK7OJ+mFTdWw+RHr988RwWBnQ7jtyhZAQkjMizfUKuvEqtQCh+KBzXW+c3Zeu/nlMTU7qkvevBcq+GCUR+oNaTAE/RO3t4pjUpJtLiNlWSY169SWkIektocjE1pJvPvgXn7Pcm/47ZnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tnsk8RNq; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d18cbba769so68914682a34.3
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 09:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772041507; x=1772646307; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P/hBoEMiXYtzSJAai3x+/Zjn0NP0IL/2TZ2kRQnBAyM=;
        b=Tnsk8RNqXvrlURO+79j6rF/IGLZCfEuUzOW/l9ObO7BYIMHuN+2+1ZBZOsq/GFkKY7
         cC3DH8/VfTSsrr+mnpD+rmyzz+qghMIbbudXX+ILgf2yvu6XOgSr583TwOPDFiQ28l3G
         s4b8uBB12KRjdukTBU3l5aiuEjCsw8tR+ZxQNaT5etDSIotFLgWXPuP8fOweNGwEKyC1
         n/Z9rLMkZwWi7fhEt2u4v4A/OH7ZwE74MZTo4E0c1+UBa/tAK/z+jRKs9j8EQIiBqx3/
         3s11m+bKzy88u02gt+7+ESYdDYyRIB+0SEJBfRGaBnd05QuFfD2/mFSCm60cO/noRbYV
         fDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772041507; x=1772646307;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P/hBoEMiXYtzSJAai3x+/Zjn0NP0IL/2TZ2kRQnBAyM=;
        b=gvunCdU3vSu9TxEJ6M8kRj/o+CsfT4xMQmv4sYaAyEc0Q4DA5XNrgyz0T1jgsicH+y
         mzIAFfyu5m6MeKDqXCdNn4UkBH6J78jXrVEaDfENLZU+AwI89IBsVH7k2k6ZYXakEiRP
         r5QuZJ0VEVIV48R92Sk/fZwhypEV8z6qMYj4mpYPD8YgPrTUoCK9S1kst7vh596Urt1A
         FmtZq/9XOrmo79UyZWfuds+lLDSY65j/GXFHBBYhLSEIuqf9nClzSB7/ttBn2SDUlMZ3
         0Z4VZ6kwZD/C+jXujEFk2MT6ge4eSzkGIsB7tsZ0mJYts/5HxRUxlKUjxZczCZgKXdXN
         K2IA==
X-Gm-Message-State: AOJu0YzzplQTYZX9MYaWthbAPEnM1SS4Lkqnw0mDkXl9zPilTm+irr9N
	j2Qq5psvJogcBJpk8err/OLI5rLpvwzVGcgb6JdMPDsJBbCNeBx98+NBDJ6RK9LhQw0pJBRFBb2
	5uX/pbbzuU0cfatvrz4qkQvGlsw==
X-Received: from iobjf28.prod.google.com ([2002:a05:6602:649c:b0:957:6d3d:c3bf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2d01:b0:679:a4cc:e04f with SMTP id 006d021491bc7-679c4618dbbmr8769461eaf.51.1772041506836;
 Wed, 25 Feb 2026 09:45:06 -0800 (PST)
Date: Wed, 25 Feb 2026 17:45:06 +0000
In-Reply-To: <86ldgyba96.wl-maz@kernel.org> (message from Marc Zyngier on Thu,
 12 Feb 2026 09:07:33 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntv7fkogyl.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 09/19] KVM: arm64: Write fast path PMU register handlers
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71860-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[22];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 1EAE619BBD9
X-Rspamd-Action: no action

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 09 Feb 2026 22:14:04 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> We may want a partitioned PMU but not have FEAT_FGT to untrap the
>> specific registers that would normally be untrapped. Add a handler for
>> those registers in the fast path so we can still get a performance
>> boost from partitioning.

>> The idea is to handle traps for all the PMU registers quickly by
>> writing directly to the hardware when possible instead of hooking into
>> the emulated vPMU as the standard handlers in sys_regs.c do.

> This seems extremely premature. My assumption is that PMU traps are
> rare, and that doing a full exit should be acceptable. Until you
> demonstrate the contrary, I don't want this sort of massive bloat in
> the most performance-critical path.

After some consideration I agree. I will try a full exit and see if that
is sufficient.

