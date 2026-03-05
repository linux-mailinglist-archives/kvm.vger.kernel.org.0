Return-Path: <kvm+bounces-72862-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMMYKmi6qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72862-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1E7216002
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F3E7C3083DA8
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931383E7147;
	Thu,  5 Mar 2026 17:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JNgjk0IE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4783E557B
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730733; cv=none; b=fsw82FFZQ5BkPDj/yoyrH7qzrHhdgOEsqG6mMIlM+2Sr0qn32+Aq+l53PcfJg3vz2FVZ7nBqWnjBMXP0sJrxXlqL9io6vxWH1dn4RY1x+iNknV7ECo3R2Zz6RdbAwfwyM198xH8dHD5SnrIApX9jY53wiWWKlKLvTSw+YjzyJzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730733; c=relaxed/simple;
	bh=ACFr2OhPuCGST6Z9o4HPkpYoodrDKequHtND0/F2Qis=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pMR3uhhXIPRCvh+42xpdNH7gL12g3YYBIWFkxygrQhyb45lT3jwT2Jobihn8/yNJbjkGasF5C1Sq1zwRyk5tnqoA3/v0JJiOqYnMjT8x/W20NDPfJBILPuIM+aniUsd5Fp5UsgtiFmvEmsUNzsp77M084k+VkYvhIEmm6O/Lxdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JNgjk0IE; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae467f128fso48060575ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730732; x=1773335532; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PlM9Daikr6BhoLrUMNCE8WDUjOiic394LLOjxhE0Phk=;
        b=JNgjk0IE4utwnyNBmsmAJS/ewfMV/EFC0hsgbiogOwcEsNVanNUNtw5WuBiePcNz1E
         1bvuLjwVQJB9Lj0xeZedhVwn1U4cr6G2xHdh+Yw2MzV1qXQ1jqlzhl1yJl2/IgT5JN2k
         EAvzvqJh/HhT0T+l9fF0OqU54Juxfx1DI2NrxSSN1jsv4/gJHlttrZf9Sq5eED8LJmNq
         8oGwK3UGgLyTaPLha/r4Px0NGOjde/20KikB3LPRVzNauYiZ42YKtx55ZdQTpeuxkvjo
         2+n02XiSj789N5cG+Bblr7VNgxr5KXdIovCwyW67Ks8vmGtgHRZYm3CE7wXLpMEBjnj8
         2Eyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730732; x=1773335532;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PlM9Daikr6BhoLrUMNCE8WDUjOiic394LLOjxhE0Phk=;
        b=bDU7EsiXh/qtSPFl5jKCtrd9pRsb5Um2RzjVFkm22tNZ8kXkvu8cw8FRAguUlmmKon
         v5H+0ja/SgTvlUCZhmXxGHOAH86tc98eusLyc5wsGseuqz3Y5PtkIBIB07C40FZ+eLVZ
         1bvoZxOPZsGJ6tlXWYeeRbu2WfYarh+7GpuBAMlYuFr7dLamqrd4nP413YgUQrjJr4Oz
         1OsVVJWi6BGNdxzJX0Iy1VSRQlcwksMq4lggSaJZjPD+PWMfwxRx1do1TNU5nUVccbcU
         5Bh8YE2/Bce9ysGXw9mKDcNL8Z/v+5NFXsjoApu2BpjDaxc3Zs/1yXdnZZhae8D/23E3
         j7gQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+qu2OpHbB1Xqd3/l7FCXlTHd3BBDK9wmbnhD6Sz0HV5MghFyDDFpfto7NhLwkzQ/pr30=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4MouRfqFJf152NTbN4x9eog8HQJeM1XGMTG4STIoqWY0WMsSk
	DwaPkysaahf4rhXd8PZxe9/hA+qCuT42YHRBdnmXrN/ZkFsqt3+gtEKCg+2885STncMNjRIuaZb
	MNkVkuA==
X-Received: from plha5.prod.google.com ([2002:a17:902:ecc5:b0:2ae:4ac1:4017])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:90f:b0:2ae:5848:baf0
 with SMTP id d9443c01a7336-2ae80130936mr4176035ad.2.1772730731970; Thu, 05
 Mar 2026 09:12:11 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:13 -0800
In-Reply-To: <20260210010806.3204289-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210010806.3204289-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272928930.1563279.2472653538935168755.b4-ty@google.com>
Subject: Re: [PATCH] KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 4B1E7216002
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
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72862-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, 10 Feb 2026 01:08:06 +0000, Yosry Ahmed wrote:
> When restoring a vCPU in guest mode, any state restored before
> KVM_SET_NESTED_STATE (e.g. KVM_SET_SREGS) will mark the corresponding
> dirty bits in vmcb01, as it is the active VMCB before switching to
> vmcb02 in svm_set_nested_state().
> 
> Hence, mark all fields in vmcb02 dirty in svm_set_nested_state() to
> capture any previously restored fields.
> 
> [...]

Applied to kvm-x86 nested, thanks!

[1/1] KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state
      https://github.com/kvm-x86/linux/commit/e63fb1379f4b

--
https://github.com/kvm-x86/linux/tree/next

