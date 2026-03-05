Return-Path: <kvm+bounces-72942-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLAiFUHaqWneGQEAu9opvQ
	(envelope-from <kvm+bounces-72942-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:32:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED7F6217928
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:32:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 95CAF30058F4
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17488283C9D;
	Thu,  5 Mar 2026 19:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gfAJ7Ccx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76C93E3DB1
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 19:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772739124; cv=none; b=Fv5LJ1laXJsaWtfqosOQCk7CfHZ7Wx+imx7PmGQguTbczdYYP7mrLKsPNfrqcKcd0TTrAKxuXz8D/6rufOnqauGUiVbWU3AR9P2h3lbxsdgbc5AuKpidD50xPimcG7f5hk+QPj0z/H1EJKElGqiP+DCqVWODsD7vNdFKbOYQhLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772739124; c=relaxed/simple;
	bh=G0soVQclDTGU5y+ub1zkJecrY3XQmVy8RtLeefSdyME=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lU65i/9mlL3egkiybIUyIeNxAUJZQnhHggwa4NvqugOmQafOovMG8GVSaPNzs6ASABwD5lDGnu4VL3FOJ55CzHcwFscPZJcjK2mKzJ0+pS4gYxA3LhHbi/qU+uHX3Ms/LsVzpNJMw0CliSAuKgxWRlgxglF78c7vd2IIQPET3uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gfAJ7Ccx; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7385a1476aso980682a12.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 11:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772739121; x=1773343921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hbX6KYOoYHVxeZgEveiirHFVzR+ZQHcnELowLS7usWc=;
        b=gfAJ7CcxQS0L9DbG0aGYIKgL85iR6MIERLaeA/1MozsNyKgGOAvKDoX77g+nZohUZI
         gWx0Xhfarz5ePZW+JvOhOqqcUSE+oEmh5UIBK9PfuU1fJEfO57FYL7xUAbRItqkNmUDi
         GAcd4j4663MGJCAfBkhMkj654E3QGx+6LVBV7pLIS9QP4/zgydEXeu5d0vcvQq6P4y+l
         UlkRtA64VW1Yixa7bKRAXpSW64m1EyL5uQoF4o3SY8pFULb8cjGpdXcX7oOoeIaRlfx6
         WjcipXjn6MhiZc5pjELEOu4gTAc/GBc7UFjheoxEOEBk4W8Sr92OZ8Hoica68Ub0Altd
         op4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772739121; x=1773343921;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hbX6KYOoYHVxeZgEveiirHFVzR+ZQHcnELowLS7usWc=;
        b=gq2Q73sHPWCtKwxm28ZiCsz5dcqW0wr/WvX0c4VVTaUkwOnZmMYE3u8ul37iA+K9Y+
         9qtC45bsxRxEcGlG8TXbQ2Lfa6owJtGIrWyZTrLZWjQQySvO1NZ8GOA2JRHkZEp/aNpA
         lAPg3YzHCB4/HHRJMUb46vRHSZ3Na7kylb3/EtXP0+a567ZhapLMDuMTiyz4Cfj1dfjB
         yAHKUTCSsfdYPNvE0FDyhsR9MDp0K16XIABKjuUCBxW4uXftQiv3g7+RRr2FBT5/hQVv
         Di4fybC05S4L3R+gbXNkBiy+LQ+fP08trK7+Xg7aMDfB+t3cAlgFXLX56BLUJ+Xwai8A
         l2Gw==
X-Forwarded-Encrypted: i=1; AJvYcCVxmHC1UoYE6k4stv8YQ0LTzMCeWjR/lcAulevTz0x4OCg5VyAFQwhXeRoXZxEpNxMw4FY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZO8+TLGecUFg5ZRI+XEFx5iwa9aoPYMIPNarx4sJ4l5Z/Mmbo
	Je+K4dsjPU1H05q94jAZQT/RHoyGLPny7HXWubeDtuZ8nOoVMNHvsz2gtBL/ZTc923UOAVTcQG1
	zG0qp6A==
X-Received: from pjig16.prod.google.com ([2002:a17:90a:5790:b0:359:8cb8:6ab0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d90:b0:359:9df2:465c
 with SMTP id 98e67ed59e1d1-359a69da792mr5458186a91.12.1772739120607; Thu, 05
 Mar 2026 11:32:00 -0800 (PST)
Date: Thu, 5 Mar 2026 11:31:59 -0800
In-Reply-To: <4746a98c3390aab3d5f561dbcd0ce9d14266f003.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aaa7ac93db25459fa5a629d0da5abf13e93d8301.camel@infradead.org>
 <da02314c-e6da-4d9e-a2c8-cd3ee096bc0c@embeddedor.com> <97d40dd0e6abaf28f43d4d8ccf9c547a16c52e33.camel@infradead.org>
 <aanNPwnH7l-j61Ds@google.com> <4746a98c3390aab3d5f561dbcd0ce9d14266f003.camel@infradead.org>
Message-ID: <aanaL-LA4gwTaSH4@google.com>
Subject: Re: [PATCH] KVM: x86: Fix C++ user API for structures with variable
 length arrays
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, keescook@chromium.org, daniel@iogearbox.net, 
	gustavoars@kernel.org, jgg@ziepe.ca, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ED7F6217928
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72942-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026, David Woodhouse wrote:
> On Thu, 2026-03-05 at 10:36 -0800, Sean Christopherson wrote:
> > > +	__DECLARE_FLEX_ARRAY(__u32, extra);
> > > =C2=A0};
> >=20
> > There are several structs that got missed:
> >=20
> > =C2=A0 kvm_pmu_event_filter
> > =C2=A0 kvm_reg_list
> > =C2=A0 kvm_signal_mask
> > =C2=A0 kvm_coalesced_mmio_ring
> > =C2=A0 kvm_cpuid
> > =C2=A0 kvm_stats_desc
>=20
> Ack. Shall we do just the __DECLARE_FLEX_ARRAY() part, including those
> missed structures?=20

Ya, can you send a v2?

