Return-Path: <kvm+bounces-73309-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id INiCJfPdrmm/JQIAu9opvQ
	(envelope-from <kvm+bounces-73309-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:49:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5081A23ADD1
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D778030B2C87
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 14:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282FB3D3481;
	Mon,  9 Mar 2026 14:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WZwdkyCf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B97C3CE4A0
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 14:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773067304; cv=none; b=MKdwwbzT5xac4cJ7oai5QFmXgnIUnOf5HilYNP1jFTOYPW6NgHqxrqqY+aUFv5XOE4n0Gxwahk5RfIVrvsqExMa25W3+LrvWeHVHbO3m/zMMkN8PM2pvBgCO1Qs9XGevIGJDpDn3Pyon8NI4qXQ0kG8I/3aL8T5o6bzQ8Y1v/TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773067304; c=relaxed/simple;
	bh=d2TNSTuTYNLDJL73E8lfr5UVPZbXdq3OErYvN0fZ0VQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A3EaEOzuyaqBZRS57845uT6GXCXazjqvsOIld+2bbWfCD3pYuHZ2tG07z9vw8jGz6375Lxn9a/rn+S9nKIPccyEIZBpWm4bUeRs/NHPqPCWAr3c5EMp+IMTCwMxyYuNQbMh2QuBfkNEnnipSsn6Q5fnQ6qqrh8+eCTGwdJrb/A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WZwdkyCf; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c738662b963so3177722a12.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 07:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773067303; x=1773672103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8fkzXplAhf91q10YMjMiSTFMndoob2SCXi29ACEuyTo=;
        b=WZwdkyCfBcBR6RhCtMoRXoV+tw2+D4Kce9AFn44e9mpKnFs2BffdZS9bZjT7YWUsgV
         yM/DSSvC9+nONIpfgRbXzXlld0CzXVWxx8ozuVVLZ92nwuC+0vDBnSPpPQjhQCFhRFaB
         JcHR/QUyPjS47zn6Ke7x1zLfpz8nG0co5i4cLpizJlhu45zTz6pvxrT+UIqZ5k3z5/dq
         cPNjs79NcQ3Z+d5qJzySml/2SPR72DQ9juf/x9+TwxAwXGO28n1FUHRZF1FaRhI8VHSJ
         nuR62Bp3SMQdw+pM66nRhy5Rr46GZ52sdk9MISWQlpBL1uzZR9NEvRG5lBlL3YLciuCJ
         gg6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773067303; x=1773672103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8fkzXplAhf91q10YMjMiSTFMndoob2SCXi29ACEuyTo=;
        b=jFH/43G4aG1XHzWFMgT5udEUfoklO2B9HPck4iXqr3+qtFAB554yMCxvcmk1GSsPHP
         DuSsuq15rDl4wmMivWTracR9G9AO8q6a8BCnQGtGuGqF+jD9ApqJARaCSAd719f/wIae
         r7bsxjc2G8ySYV9EC9Bwr76D6+vezbO2ampZzWkARVoAZm30kISevWoNlvY80IwR9bfI
         QF8o8lp8MheXS3C2yrEqz6ZN4tlOo2pvhboHKbubjPbmI+pLzczcbq5qBBVRBrQI5n6K
         be+AZYthDtVqVobSBvV16gKSKVYH5AR7E+vdKybZ7KNj6W4anbhx9Q4XH1rLAxuMfgQg
         GENQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIAZvl05P7XY+cj2cX/5mvUnwFc5mCt83EqL3Gf7dAF/Hs3ddfvCpAMNs/Adx1hc9WIM0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yymh4vYzRh9co/jBfrEP7hSUB3+B4GPFT6d3ruhyKgAeNihKxgF
	VA17dyIxbNbF3kFopUFoweDjM6CTP8XFOD4bCRFl5iNp/xvMvi8mpUhCCXQPo+iZ3OWSZ9YSBE2
	lF1FcjA==
X-Received: from pgbcr7.prod.google.com ([2002:a05:6a02:4107:b0:c73:9919:c4e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:50a:b0:35e:11ff:45c1
 with SMTP id adf61e73a8af0-39858fdab62mr9920621637.18.1773067302652; Mon, 09
 Mar 2026 07:41:42 -0700 (PDT)
Date: Mon, 9 Mar 2026 07:41:41 -0700
In-Reply-To: <20260308030438.88580-2-freimuth@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260308030438.88580-1-freimuth@linux.ibm.com> <20260308030438.88580-2-freimuth@linux.ibm.com>
Message-ID: <aa7cJad4M5hlb3n6@google.com>
Subject: Re: [PATCH v1 1/3] Add map/unmap ioctl and clean mappings post-guest
From: Sean Christopherson <seanjc@google.com>
To: Douglas Freimuth <freimuth@linux.ibm.com>
Cc: borntraeger@linux.ibm.com, imbrenda@linux.ibm.com, frankja@linux.ibm.com, 
	david@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mjrosato@linux.ibm.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 5081A23ADD1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73309-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.927];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Please update the shortlogs on the patches to set the scope to:

  KVM: s390:

I had a moment of confusion because I was like "but kvm_arch_set_irq_inatomic()
is already a thing!?!?" :-)

