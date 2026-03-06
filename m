Return-Path: <kvm+bounces-73152-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHK+IPQZq2lNaAEAu9opvQ
	(envelope-from <kvm+bounces-73152-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 19:16:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 839FA2269BD
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 19:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 043D43011D44
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 18:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B67421A07;
	Fri,  6 Mar 2026 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UYBoGLoX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06213321D8
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 18:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772820967; cv=none; b=enxrI5fBRRJxIjyEVcRJpIHcdn6OVv4z0prOInI+/NzG4fLL2vSl07kF7x2bldUsnIaFK6dvrPBQ038W7GOseWW6PTyxZhe4w2cqDTXAUXoxUjPxUFqo2ujFcLR8dUKji9Js/zeZp0hc+NqF3PD+9LoZF+t26os26h4RB35y7n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772820967; c=relaxed/simple;
	bh=1tdcYpzl3fdMepMGTE8GrF3lm1m6nSjKCnlmjJKhXEQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aq+NbpDCla7llE4Eg2fYp3FjkZhevTctRpqv4lizW8amluMe7+bFrvZfszC+SibLu8brdGQOv2W5omS4POMB7onKuBlXfQwm5Ndjn0aP5LJXQ0TYpFMlklI63FFJwDOwvYjF3oEYF/FICLVf+bOwaJ549viTYyP1b1dLhbbbfOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UYBoGLoX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3597f559e70so4569893a91.3
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 10:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772820966; x=1773425766; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1tdcYpzl3fdMepMGTE8GrF3lm1m6nSjKCnlmjJKhXEQ=;
        b=UYBoGLoXyreicI0tnDY571vbNzV7ryQweSFBaOfQdct8AQ/yKIIZXejZOJhxLmB922
         qILs5VjzWYFF+O3a9afnu4e1RTB3qoxW2p9yt9u+lxvDLDi9wMeJyKvW1iKDtm203f8s
         h8Pe/huzXvBo8B1O2geGbUu/jtwOOzaUn4RM6W0GYhKhoHd9W45sAMPDpewSyM3bxoju
         07wQPQm0S674X6Aom642MjqvctkajsH7X5cO5CJsp5ShmX/e7SEwK/q4q97XCqfTM+Ao
         IDoS99RmecLtXdMnk1I6Z9W2Wo2mHSLaHTd/WJUA/G0w02xTH3Sc18ziA4cxE7GVcerz
         zJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772820966; x=1773425766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1tdcYpzl3fdMepMGTE8GrF3lm1m6nSjKCnlmjJKhXEQ=;
        b=IDwtJ9RB+xyZMCpq/Cz2wkTKwRfh2uDqzvRwGuteeeipq99zG8vatnQajoAoTUhq8c
         YDfXDX06yT1mIi2LovuMzNdGSFf3CEuiuwa1a1nwDCgQM5GzzXPMYfHtsRvOvEmyYJ7G
         w8e8mlTjE6iJiyh4PUj34xUp87LzXYN93bkmP9VPAXm0oFs+NzQslcDcXfHGILq1UmEm
         gTLjEOuUh/DkEcyxGkXvLi4xqSrbY2EfczKRA7Xv/wAGk3tNKsUKEipY+E9vF9xm7nHa
         +D3IN+JCNf2cG2D1DQ5dIbxikCbH/ad1qmIFIcZUOhYpS6Qaz7dQePdFttYt//Pb5rWB
         moXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZiBXMRe6qdifwBCO8xx9WrH0R8STQPuoIQjlTJDaUr9KeFVo6mZ5fW6egzQqx6z4aU68=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJVE27SfJVlxIC78GWIyEBwJ4UtLbLz1RyhFZv405kkDOKTr2e
	TeTzc16r6Q1fdlPgmV/PtB2ycxWXRhiqvpe2i4cSKHSX9fQ52z8Aj718l3i/dCB4NDGvIoQ9l9u
	7zAUitQ==
X-Received: from pgaz10.prod.google.com ([2002:a05:6a02:50ea:b0:c73:8fc6:3d6b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6012:b0:342:d58b:561c
 with SMTP id adf61e73a8af0-39858fe967cmr3219839637.27.1772820965820; Fri, 06
 Mar 2026 10:16:05 -0800 (PST)
Date: Fri, 6 Mar 2026 10:16:04 -0800
In-Reply-To: <20260306041125.45643-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306041125.45643-1-anshuman.khandual@arm.com>
Message-ID: <aasZ5NNo7q9MRgzD@google.com>
Subject: Re: [PATCH] KVM: Change [g|h]va_t as u64
From: Sean Christopherson <seanjc@google.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 839FA2269BD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73152-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.944];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026, Anshuman Khandual wrote:
> Change both [g|h]va_t as u64 to be consistent with other address types.

That's hilariously, blatantly wrong.

