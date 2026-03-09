Return-Path: <kvm+bounces-73314-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHTqDYvkrmmsJwIAu9opvQ
	(envelope-from <kvm+bounces-73314-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:17:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEFA23B7F5
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:17:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2D1630672F0
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FCFA3D412B;
	Mon,  9 Mar 2026 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZTKEBHhN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7222798EA
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773069117; cv=none; b=TbI5hkUpzzuMcnQP21qPonmI2PkAFVFDGAXhY8cGV32+eBuEpJkLtMvT8q08lH6P4afbWEYDMJjtxpQbtFJSDR0jHMh4DdrA9qzn+prVrYEwiuQNur9XmQHDkkgpQpniXV33GqzlK2X66DKKrJ3WMQrU42m2t1CQuPERCv/zii8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773069117; c=relaxed/simple;
	bh=WHWSTNxXazjEHbaDul2KHgXggE8GoC1Wh6tm7vlAwik=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XPBzFOzBMy812dL53frVRaOVX2k4RgzTEo4w+tfAFEwCliM4Kl5FH/ksJfY+PDWbsEbj5nrQPjsKlNiTCjfFXKghjl5RPDfMptyznVdBGrTQkRSwaDQR1H+qWAVgQnmzOm/elleWjayDHg9u/1PHlbR+qb6vh1BXr2kClTA+4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZTKEBHhN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35842aa350fso54567493a91.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 08:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773069116; x=1773673916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WHWSTNxXazjEHbaDul2KHgXggE8GoC1Wh6tm7vlAwik=;
        b=ZTKEBHhNAwpEx4JMb7Ol2uNLDwDvB500iekLUvFZabf2tPfoR5sqUY5F4BECnPiqvq
         GGmTmaxkpX7ZsNcn+SR+WSLduqONHkhk10oOavVTnXvwulED6joFyxe2bfKL8jRqOTBl
         XARORQQLAWf+Ca7uMT909eEaCaM5Goba5kAmohK2wPFMv1QgV8fCj5bWc6By5nFRiAOq
         YDRi7Vv/2dIbRP5WnHhcOviWAz1xvSnplnTdo8U/1v/9ncwMRUMD2LtZIZQZH1D4MGl7
         gtmFsePDdKvl7fau68R2ppBPbzrQA9v7dE7BSNAth3ko+wc0VXAdhz0FapA2uNjiIYGl
         qc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773069116; x=1773673916;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WHWSTNxXazjEHbaDul2KHgXggE8GoC1Wh6tm7vlAwik=;
        b=qCCHpwAafu9lvuE3F4KTkUoE0G86CCgHcv9TQGJ5NH3j5H2Bh1Zcsfla1/MsIg6J0U
         Q0Lf5+bMmynYyY9dEFyF9cX3AsG3v8r0H7lC6u4txbiNNjKHUa2OldF1xv2qy23O7slj
         c/l8bfhCp6GVWeDAa3O08pMopVnPvag3lMhjUXV6BbCddb5i3mzENTNKwwv5tuiwY0Js
         iX9Bld6IxShosr889PgTMlckuVRiBMhv2Wzz7OV2yEFJQ+SuzLIDn65Seq5LmK+g1mQn
         sDf0jE94fADN9wl5NWLu5l1bmFWTNIkVa10unkH9Ycsf6fxODdWKblySvuBhtzVskkvP
         itTw==
X-Gm-Message-State: AOJu0YwKWtzcBJCqdIL5w1TTiNFxOIs48UcZX+JN+cEDorm7pACMiMPr
	rBAAipgkUG3lwJc2bfPF0X0WzjHUZadFppG/wLuf69r7eTJOwuLSzNLGXhKHYRROUoQyz44o0Rk
	c6h8N6Q==
X-Received: from pgbdn1.prod.google.com ([2002:a05:6a02:e01:b0:c73:9b89:427a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2884:b0:354:a57c:65ec
 with SMTP id 98e67ed59e1d1-359be3075femr9761517a91.20.1773069115813; Mon, 09
 Mar 2026 08:11:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  9 Mar 2026 08:11:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309151153.2159611-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2026.03.11 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8BEFA23B7F5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73314-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	RCPT_COUNT_THREE(0.00)[3];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.960];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

In continued protest against Daylight Savings Time, PUCK is canceled this week.

As luck would have it, I'll be offline the next two Wednesdays as well, so PUCK
is also canceled for March 18th and March 25th.

See y'all in April.

