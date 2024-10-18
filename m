Return-Path: <kvm+bounces-29176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F759A4299
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 17:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9FE1B26284
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 15:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A10202637;
	Fri, 18 Oct 2024 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="io+A9U+H";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="io+A9U+H"
X-Original-To: kvm@vger.kernel.org
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBE12022E6;
	Fri, 18 Oct 2024 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729265797; cv=none; b=ui+O5C79a3djXzI4TLOAsm1DQxUwv+628OO285YUicxQYP/Zo/ow/dPYdzA19DDp4X85fbossfPHpmkubxNcq1Np7XqBGS7QTU4GJAQhnHQfWOgi4inhnC6Ntq+zod8DLPO6KPbf6iS3n7T7QzCJbCzaQJVkonoRRRFnh782Sao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729265797; c=relaxed/simple;
	bh=3KuPTPKFRs/xGs+UxwmvV37m+aAL2k4H0fIxMFw9Q+Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=Hnf325AFfjhYSGPUvw5jdXYsBZ+eQupoqCfA65R8GsCanlnrw4yH8K0IERWr2sE4Fj+WdQhqgsvKbm2lk8x7sQ0495tSXOaxxchUNov/mh1cUJ1IfrZGuTu9WZUQNMZzHHAv3qXgQki69kfqY4tQdAoGCpgkDH7Jgh/QEeUhauo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=io+A9U+H; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=io+A9U+H; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1729265794;
	bh=3KuPTPKFRs/xGs+UxwmvV37m+aAL2k4H0fIxMFw9Q+Y=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:From;
	b=io+A9U+Ho/1pTA0LKynKBJTFNMvyilAO5oeke4JCURYuKI8wh8fsAYmaOUmmYTOZy
	 A5ZJ4dy/CCURDMEZDjx9au3qSMTUzJ+fDd9Odut9yFFpNOAlKazTEYorISIOaTFip4
	 jqbaKRrIACZ43iFt8wKcdpYrcwlgE6k2hCNAKFVk=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id BDDEF12874E5;
	Fri, 18 Oct 2024 11:36:34 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id l_H6ysM2xXpH; Fri, 18 Oct 2024 11:36:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1729265794;
	bh=3KuPTPKFRs/xGs+UxwmvV37m+aAL2k4H0fIxMFw9Q+Y=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:From;
	b=io+A9U+Ho/1pTA0LKynKBJTFNMvyilAO5oeke4JCURYuKI8wh8fsAYmaOUmmYTOZy
	 A5ZJ4dy/CCURDMEZDjx9au3qSMTUzJ+fDd9Odut9yFFpNOAlKazTEYorISIOaTFip4
	 jqbaKRrIACZ43iFt8wKcdpYrcwlgE6k2hCNAKFVk=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4ACBD1287459;
	Fri, 18 Oct 2024 11:36:33 -0400 (EDT)
Message-ID: <6028e1a0fad729f28451782754417b0be3aea7ed.camel@HansenPartnership.com>
Subject: Re: [RFC PATCH 0/5] Extend SEV-SNP SVSM support with a kvm_vcpu per
 VMPL
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: roy.hopkins@suse.com
Cc: ashish.kalra@amd.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	jroedel@suse.de, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, 
	thomas.lendacky@amd.com, x86@kernel.org
Date: Fri, 18 Oct 2024 11:36:32 -0400
In-Reply-To: <cover.1726506534.git.roy.hopkins@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> I've prepared this series as an extension to the RFC patch series:
> 'SEV-SNP support for running an SVSM' posted by Tom Lendacky [1].
> This extends the support for transitioning a vCPU between VM
> Privilege Levels (VMPLs) by storing the vCPU state for each VMPL in
> its own `struct kvm_vcpu`. This additionally allows for separate
> APICs for each VMPL.

I couldn't attend KVM forum, but I understand based on feedback at a
session there, Paolo took the lead to provide an architecture document
for this feature, is that correct?  Just asking because I haven't
noticed anything about this on the list.

Regards,

James


