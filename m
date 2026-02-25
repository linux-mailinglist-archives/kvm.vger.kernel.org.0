Return-Path: <kvm+bounces-71858-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KFSHOE80n2lXZQQAu9opvQ
	(envelope-from <kvm+bounces-71858-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:41:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4919919BB0A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 54EED302D689
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7868C3921D7;
	Wed, 25 Feb 2026 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RFGlMuG+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395DC3ED113
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041261; cv=none; b=t0zIrcr3gE4RAAw+/mHfDHA9DRD5p0yMEPab3hZsYAnucHwSqhfY/DX/U4l5J4ZysWSXAL/HnD2Sux8MLEH/uKLz8X7ynPQ/4lid6gQ+4uuERkMs7gu85uaDv0sW6baHPOds3xsFzjPoKpKAkZLD35s//1ruKyH2Vtze9DWEpZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041261; c=relaxed/simple;
	bh=vfPVzGsOpxFMqLnHbeOt97S7ASvz/dPPsmfURT55c2c=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qLQDwv81N8XVWzwxqbxe1fnPP6Ny/2An9pkUweBLISNZLMJQ5fAyI0s8RLuGK2EtT//4n/aTqpHtbXwsl3vcF1adICUT6WczSsFSOtS6udchtnSiLV/MrXhhrMc0owHC3gfGXkr5Ogm8yuaLR7Bou2MFMwBE3A4MxEQFvFrKQLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RFGlMuG+; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d4cb5810a0so46147046a34.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 09:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772041257; x=1772646057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vfPVzGsOpxFMqLnHbeOt97S7ASvz/dPPsmfURT55c2c=;
        b=RFGlMuG+RlBMZrbOsRHSvqyhEwvpeQcTEJJ6pxS/L1GkYKdprHSLNvn0+CqMjCdmq8
         GJqB7lFXU3ZEixmIuTAQTT5v14RH9CUEiJ1bUNpeAJc8R4ox6Mz8r0qJAkicg4UvpHjJ
         G8+VYutk2uWcIi4Z1R1Bo/M3ZoEBT0G7lNZ1MD+z4DDKpuM56Hm+Oirty558xOYgWXPp
         BwbcJmqAS3hXfLbOKsMkUqMzhv7vY1tUBtG+hnKULyozp6sk+8LO6rnsPs6uDFAHZ2Ev
         fqCcQkAHOMuFB4zx9KQkzYAJ+K5uFnNvV7M/Rom9vHhyv796wUcfJZDb9xWBfwo1hZd8
         M4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772041257; x=1772646057;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vfPVzGsOpxFMqLnHbeOt97S7ASvz/dPPsmfURT55c2c=;
        b=Rbc4WoWKHghgni8yUoikHfjpIgbRv5XWpfrNjZi1zdKmWeVoAF1R2xl/vs+mINqJVK
         W97WwHxbaWG1BIRbfMwg71n8w4cd7/1qYYSeZW583137dQWd0km39RGbSv+L9fSFx6i7
         2EuVhgghTFLRJndmL0tFzfU11dd3oO3BFqPnyc6hEH7RjiqJzgemlbUUOBWxQ6gR1NQD
         0//SnGcpQoY0GxqPrnrNolHHj/Z52VA7+RNPbqj9eUpK1/RS+ReoDqOTypdMXmSqbSJ2
         IqbVQI16Op/Z+Hugjb+i+AyknrxLQrC7lOp5lvg0sNXUnDD1Y9zgijDq3fHqSgnaFfiV
         g0RA==
X-Gm-Message-State: AOJu0YyRvGw0acYA10BHE7SpPqghjfl9Pn0GeatvizWTZl0R9cHEu29/
	e8I1Dv9Y5/fcqSBDEQJeeIdnCKA2LGzzQ2mUloP5T7DgLbQIo+J/7zJ5Uei/62B/hCqCGmG63xc
	fIPVHLE+ez39LSOgSk+DwgjfnXg==
X-Received: from iluj15.prod.google.com ([2002:a05:6e02:154f:b0:4d2:8640:5d64])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2019:b0:672:e67a:96cf with SMTP id 006d021491bc7-679c4684cbcmr8062877eaf.16.1772041256681;
 Wed, 25 Feb 2026 09:40:56 -0800 (PST)
Date: Wed, 25 Feb 2026 17:40:55 +0000
In-Reply-To: <86h5rlawru.wl-maz@kernel.org> (message from Marc Zyngier on Fri,
 13 Feb 2026 08:11:01 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnty0kgoh5k.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 00/19] ARM64 PMU Partitioning
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71858-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[22];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 4919919BB0A
X-Rspamd-Action: no action

Marc Zyngier <maz@kernel.org> writes:

> On Thu, 12 Feb 2026 21:08:36 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> Hey Marc, thanks for the review.

>> Marc Zyngier <maz@kernel.org> writes:

>> > On Mon, 09 Feb 2026 22:13:55 +0000,
>> > Colton Lewis <coltonlewis@google.com> wrote:

>> >> This series creates a new PMU scheme on ARM, a partitioned PMU that
>> >> allows reserving a subset of counters for more direct guest access,
>> >> significantly reducing overhead. More details, including performance
>> >> benchmarks, can be read in the v1 cover letter linked below.

>> >> An overview of what this series accomplishes was presented at KVM
>> >> Forum 2025. Slides [1] and video [2] are linked below.

>> >> IMPORTANT: This iteration does not yet implement the dynamic counter
>> >> reservation approach suggested by Will Deacon in January [3]. I am
>> >> working on it, but wanted to send this version first to keep momentum
>> >> going and ensure I've addressed all issues besides that.

>> > [...]

>> > As I have asked before, this is missing an example of how userspace is
>> > going to use this. Without it, it is impossible to correctly review
>> > this series.

>> > Please consider this as a blocker.

>> Understood. I remember you asking for a QEMU patch specifically.

> No. *any* VMM. QEMU, kvmtool, crosvm, firecrackpoter, whichever you want.

>> I had hoped that the use in the selftest was sufficient to show how to
>> use the uAPI.

> The selftests are absolutely pointless, like 99% of all selftests.
> They don't demonstrate how the userspace API works, now how
> configuring the PMU is ordered with the rest of the save/restore flow.

>> If not, I can send out an example QEMU patch to the QEMU ARM mailing
>> list.

Okay I sent one to you, qemu-arm, and everyone else I asked to review
this series.

