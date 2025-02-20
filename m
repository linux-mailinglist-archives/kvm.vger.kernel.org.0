Return-Path: <kvm+bounces-38776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB21A3E4B7
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2188A16E75B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA0924BD1F;
	Thu, 20 Feb 2025 19:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M+vIwVGw"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3FC1FECA7;
	Thu, 20 Feb 2025 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740078330; cv=none; b=ko2/tsuqOXwwbkgovPGdIIJMbsmNbBbiR07cQzVlB5r90VIr7E8zQOv8H1wwz7xmb+y26AOtJWmYcIF5tpGqzbxstTM2NhtzHue12BC53lTgEuh5z657aEnJ6hMKp/1O8oSEHMiW13m45q1t6Le0auDoJl2dTOFZufC/YhK9RSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740078330; c=relaxed/simple;
	bh=j5gLjXv9KLHl31my8GhJFk830HhR2rfbj+/Hco4Eqc0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=MywcSJ9q5F68PylbwoE52Poohtcfwg7dIcR9T8XxYnp6nnLJtfSXPR6C6h7x689gwuEsBQjo+OiAYqPq4RDJeH5BbXRW8hcKTUzS+V25riReh4+8bwrNedueg2+jSlhzxrx/J8FQmuCgQSKRE7Chcymk8I6/KO53wZZU3X12m3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M+vIwVGw; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=HHsmy/T1QOBAiuFCBnIjRk7qQN+0m/qoy0sAIcyf4fY=; b=M+vIwVGwBLuH+/flrSJakib7sd
	idfsicGX7RCReLdCZgf2tPx9CENBAqsNvYLlRADvFtdcq7ftNAZPs6cIWbe2Sp+ytvVABud8AtEo+
	03nTM63/P9wOp06eXWbM+Ut5jVMxC+7rXfk3opkgF60x3HbI2zoLhV+nbhKOBJm97S9H0Swivhcre
	0qS8w2KVK9J6gpxiQW9AkV3p7U8An16SL6fB9A0vQn0UCGP8q+2tnmuBtF0RC/flmiNevtxi7ezLM
	pmRKwyCb0LnCmCew4nTuVgjh8p/HaxCp+PQxByQrKCsS37ExqK67SVRcHoMBDxpvcb7fOUPQ8f/e/
	zxtsl5BQ==;
Received: from [2a01:cb15:834c:4100:a434:bcd6:3fe2:a973] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tlBr4-00000002V6t-0yxF;
	Thu, 20 Feb 2025 19:05:22 +0000
Date: Thu, 20 Feb 2025 20:04:36 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joao Martins <joao.m.martins@oracle.com>,
 David Woodhouse <dwmw@amazon.co.uk>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_1/5=5D_KVM=3A_x86/xen=3A_Restrict_?=
 =?US-ASCII?Q?hypercall_MSR_to_unofficial_synthetic_range?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Z7d2OSNSXIi5PAiR@google.com>
References: <20250215011437.1203084-1-seanjc@google.com> <20250215011437.1203084-2-seanjc@google.com> <DC438DC0-CC4B-4EE2-ABA8-8E0F9D15DD46@infradead.org> <Z7d2OSNSXIi5PAiR@google.com>
Message-ID: <3A169373-3F1D-4938-8505-F75D1F5CA726@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 20 February 2025 19:36:41 CET, Sean Christopherson <seanjc@google=2Ecom>=
 wrote:
>On Sat, Feb 15, 2025, David Woodhouse wrote:
>> On 15 February 2025 02:14:33 CET, Sean Christopherson <seanjc@google=2E=
com> wrote:
>> >Reject userspace attempts to set the Xen hypercall page MSR to an inde=
x
>> >outside of the "standard" virtualization range [0x40000000, 0x4fffffff=
],
>> >as KVM is not equipped to handle collisions with real MSRs, e=2Eg=2E K=
VM
>> >doesn't update MSR interception, conflicts with VMCS/VMCB fields, spec=
ial
>> >case writes in KVM, etc=2E
>> >
>> >While the MSR index isn't strictly ABI, i=2Ee=2E can theoretically flo=
at to
>> >any value, in practice no known VMM sets the MSR index to anything oth=
er
>> >than 0x40000000 or 0x40000200=2E
>
>=2E=2E=2E
>
>> This patch should probably have a docs update too=2E
>
>To avoid sending an entirely new version only to discover I suck at writi=
ng docs,
>how does this look?
>
>diff --git a/Documentation/virt/kvm/api=2Erst b/Documentation/virt/kvm/ap=
i=2Erst
>index 2b52eb77e29c=2E=2E5fe84f2427b5 100644
>--- a/Documentation/virt/kvm/api=2Erst
>+++ b/Documentation/virt/kvm/api=2Erst
>@@ -1000,6 +1000,10 @@ blobs in userspace=2E  When the guest writes the M=
SR, kvm copies one
> page of a blob (32- or 64-bit, depending on the vcpu mode) to guest
> memory=2E
>=20
>+The MSR index must be in the range [0x40000000, 0x4fffffff], i=2Ee=2E mu=
st reside
>+in the range that is unofficially reserved for use by hypervisors=2E  Th=
e min/max
>+values are enumerated via KVM_XEN_MSR_MIN_INDEX and KVM_XEN_MSR_MAX_INDE=
X=2E
>+
> ::
>=20
>   struct kvm_xen_hvm_config {

LGTM, thanks 

