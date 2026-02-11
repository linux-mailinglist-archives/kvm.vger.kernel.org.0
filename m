Return-Path: <kvm+bounces-70883-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iIy5BBSzjGlLsQAAu9opvQ
	(envelope-from <kvm+bounces-70883-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:49:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 739C3126501
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5ECB5300B285
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095DE3451B0;
	Wed, 11 Feb 2026 16:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oIZpOvpq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DE021883E
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770828550; cv=none; b=VSFAaDyg+8If7i1IoZBfrd8WIJ9RMfPg9qOXQ8hdmSrCHf56PPu9pRLL/6eD2MOi+KSFsJ1303UJENFdCvcv+nGMITuUh+AT67NcqAgScJ8wW7En9x42DmdS8vHFz92QSP4GWBhqpVy+NNIVfQQ2TxKj+uUFw8/i7NkLsAykdfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770828550; c=relaxed/simple;
	bh=1qIcF+XARYKNGSFJLYbRFNXlLBIXsMqJNT9PYdEhX4w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UA4RBPEzBDYLfeovWWWDXeb+kJ/Gr5c/sSXkc5QMYbm7jooZaHtIZmatjRYvSuQSkM942M6G/iIwFBrlpmTvkLT8xW+6lTF9AgY4tRbX6CQbT6TJf/dR52CXPoctGBR0uVe9WvEDzTqMf+hDn/bAgcLL8YMyRdQK8HyxzO9yI78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oIZpOvpq; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e18b8fe1eso532690a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 08:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770828549; x=1771433349; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HZIFoiJwZlgxC78A1qbwuV05jZPWDHpEAvtk+iCE5FA=;
        b=oIZpOvpqSvlxXeUyBq6AdXojFomsoc1AI7FP4CS2p5y74R55fss8hQWv29ONGbgDw7
         AMkg/5jrEMaaI+hSf0E5BTII24ysQzBORImdL0lL1eK/b7TJ94h1Lf51sOEEHgBjvyyK
         scefq319ku32ifF5ghj7sBrY3wIz70yKh/JX46F9IUpdhVukXox/vdBzefKAFoMSSQ3z
         RAHRiIKMH8it5AYbstniyMHCbZ6/sDrdO6/y4Yp5PmBvMWAghw/HnW7yagZdgmzq2JFd
         +qfQWfTo8kLXy4BAlMKwBV8YNIbAt5C5OCMtNrZLxBHubqRbJquE7OA5QJDRVexDoSfL
         1TGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770828549; x=1771433349;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HZIFoiJwZlgxC78A1qbwuV05jZPWDHpEAvtk+iCE5FA=;
        b=iq+jAsKkGMjOoY3cNEOdqKA4l+eLAIIFJmdB3MThsZtAfgUiKRuIFB4zo9srjwBK6f
         TYyT+vyVJog7X1Lpc3TRfhsOZb8vThzsVNYL/vXFWA4WJwAiIe+pl1CTm8Cr9+mBwqBf
         aKymFAKZQ7qazw9SZnMLKSFmJCo4fsI+iH71Sfbb5jh5L5QCHyMfXOgjke0e9DcBkw/M
         H4lqJ5toXhpYhmCMCRcnvPbw2u5V2gzX9/a16jZdR5aXXYAq/abwqQoiZG70xwx0e2Xo
         1oAN65Y2dO3KDDu5y5nDtqgzdTPYtoa9kpWU41KUt+fqYYJQ3gL84bjyX62EbkeBOelH
         5NSw==
X-Forwarded-Encrypted: i=1; AJvYcCV3TlANRaXULk9fOd9j5wYjdRvohXewbKuKtVaXWOLl+e/yIaHWDxJ/EXoAUUcR519KmYI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx33qa54zqZ9SoBPcBgnhVWexYpHH12E9cRUT86GBnM9S7vNdCb
	RdGjhRGFWjdZvpAQvEvMYH0BKc0M6wOAX3pX553kfTLIlAF3JmSbNkmqLy/Qg4LQ4aTlrgL/d17
	9I7O/7A==
X-Received: from pga25.prod.google.com ([2002:a05:6a02:4f99:b0:c08:9db4:d5d2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939d:b0:35f:84c7:4012
 with SMTP id adf61e73a8af0-39447379f56mr21025637.29.1770828548500; Wed, 11
 Feb 2026 08:49:08 -0800 (PST)
Date: Wed, 11 Feb 2026 08:49:06 -0800
In-Reply-To: <18c8bccc-f57f-401c-9b86-248d1632f9d9@citrix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260211102928.100944-1-ubizjak@gmail.com> <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
 <20260211134342.45b7e19e@pumpkin> <5276256b-9669-46df-8fcd-b216f3d3e45b@citrix.com>
 <aYyjw0FxDfNqgPDn@google.com> <bc3784ea-3315-4e96-9cc9-7f837410e7d9@citrix.com>
 <aYyrnjV4ewtXlSeL@google.com> <18c8bccc-f57f-401c-9b86-248d1632f9d9@citrix.com>
Message-ID: <aYyzAk9yCOpDWpV6@google.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
From: Sean Christopherson <seanjc@google.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: David Laight <david.laight.linux@gmail.com>, ubizjak@gmail.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@kernel.org, pbonzini@redhat.com, 
	tglx@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70883-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_CC(0.00)[gmail.com,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 739C3126501
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Andrew Cooper wrote:
> On 11/02/2026 4:17 pm, Sean Christopherson wrote:
> > On Wed, Feb 11, 2026, Andrew Cooper wrote:
> >> On 11/02/2026 3:44 pm, Sean Christopherson wrote:
> >>> On Wed, Feb 11, 2026, Andrew Cooper wrote:
> >> This change is almost certainly marginal at best.=C2=A0 It's not as if
> >> VMREAD/VMWRITE lead to good code gen even at the best of times.
> > Yeah, but adding in them in the first place was even more marginal (I a=
dded the
> > hints as much for documentation purposes as anything else).  Absent pro=
of that
> > having the hints is a net positive, I'm inclined to trust the compiler =
folks on
> > what is/isn't optimal, and drop them.
>=20
> Branch mispredicts in the P4 could easily eat up 150 cycles before the
> frontend got it's act together.

Heh, I'm willing to risk getting yelled at by the one person running KVM on=
 P4.

> However, optimising VMREAD/VMWRITE and not the whole kernel seems
> somewhat futile.
>=20
> ~Andrew

