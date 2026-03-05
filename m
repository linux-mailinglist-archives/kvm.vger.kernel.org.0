Return-Path: <kvm+bounces-72852-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMzGLIC6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72852-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3429021602D
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9458E31DE544
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3EA3E5599;
	Thu,  5 Mar 2026 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T2NCgSWb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B243E1208
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730643; cv=none; b=FzWYyuCm17Qf6CeMd+T4CdJiIbF1XjthsPlMOyBmtkACb1YJi9Avj7dEGnt5VgbgL+wl8CEZxWoasaQm+zddVCIutwC67ZY+qwTotF+pRH84vbBBm13xEMOEmVeobFGuazPUbv6yWU/N06cp+1I9oU1a5uGSQRBsdD15KhM04Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730643; c=relaxed/simple;
	bh=BgXCe+EccglOVSlP/bo2iG4iGCrk8Y0BFtDD24vZGWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YXB3W7wBeKW0kBmudWfeAAY9tb+6iPhwZ6/nfRgifPe5I6YF6+w2yWIKq4mk4lcjvBbX8HQ3U6eg1LmefxPLH/RsVegQZ86/GgOPwuL2aynXPG1QQMaWG+sSdLqfKtdq8XcyM0Y3nM0YvMPjtBADrSd4fdvI4b32kqLG45kHsDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T2NCgSWb; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7398e393a6so86081a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730642; x=1773335442; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+htKiNWdniqhpURRDUFSHaItriT9yQJbQMXUKWYvD7w=;
        b=T2NCgSWbHLjUNZMYqQPFNjtYGyac/sKlv7J7zmSMea98KQWxOmoUknsdBzlTX40KuE
         ZJ6vEJVoXFR8togUZJ9L2J4i4J1TjhDpJHlqKlvhPVjLt1TddTBDsleMCojkXh8B3UrU
         L55kwww1feZ+BHFCMYWwxXgIHyEAigutrkRpmSVRtxwoMuIjMN0b7aoSL9ZNoKV2dR2X
         1J4NM80wUIvt3qeKDWwRaZUhO7j1mVOeFcjKy3KdnDRHDuhJJ+0A41dXBZRiqN0xOPLT
         a+S6Mu3BCQRxK/u1Y6rUIds/yLbr6X7MFBH4jo27eoKVcQZ9ezQChBvVm/ku4363P7Yg
         gV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730642; x=1773335442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+htKiNWdniqhpURRDUFSHaItriT9yQJbQMXUKWYvD7w=;
        b=bBEq4zm2ABwqCrdGtoFUAiYhwso3lGOBYpOBmflczr/KhkuJxTnx9PDT4kwt9xprr/
         XxVBzlHeoR+G2wb0uu6zGoN9McW6TVtIpSXHyeUjm97r5mRz5nHPdQjvv/jCD7C8kbMR
         m3/7IFVZiJ/7s3cSMu8853TRiy3XYspAYzyC1TzV0eN4B27yd6FMNnpmVvBlTY327cFs
         maSfwQotK2hkC5s1uZEPZxfq7OPb9GMCjsYqZjpUkn61Km+dVkYmjOHjgARMnwYk6xn0
         TfDqEitcI/Adek6HU9+/ja5Tez47YqLJgAVZA4U/Kcxm4RJSFQABQ9YMfNgI4U8A8NIv
         j1HQ==
X-Forwarded-Encrypted: i=1; AJvYcCUptrPMURFL8rVUun2LfiEzMILEYUOXTCNI5w9yxGkWPDK6JPO/kS4x0JxXqc25Wz85UCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YygcuidNjtsLYOnk+xlLgwJ9sqtngjiRJnpKWgKzyLbrpNVx9Dm
	VxJ8iZPAZp6U6mMkSrWeNUCKt6293QCh+YsF89TXeHRM9DV7Vd3XUNywTX3RLtQ28EKn5OTQLLY
	+RGeK9A==
X-Received: from pge20.prod.google.com ([2002:a05:6a02:2d14:b0:c73:7c6b:a192])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c91b:b0:395:d33:8460
 with SMTP id adf61e73a8af0-3982e226184mr6337214637.52.1772730641961; Thu, 05
 Mar 2026 09:10:41 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:53 -0800
In-Reply-To: <20260212212457.24483-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212212457.24483-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272957575.1565689.14934592520888621130.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Zero-initialize temporary fxregs_state buffers
 in FXSAVE emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 3429021602D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72852-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[google.com,vger.kernel.org,kernel.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, 12 Feb 2026 22:24:04 +0100, Uros Bizjak wrote:
> Explicitly zero-initialize stack-allocated struct fxregs_state
> variables in em_fxsave() and fxregs_fixup() to ensure all padding and
> unused fields are cleared before use.
> 
> Both functions declare temporary fxregs_state buffers that may be
> partially written by fxsave. Although the emulator copies only the
> architecturally defined portion of the state to userspace, any padding
> or otherwise untouched bytes in the structure can remain uninitialized.
> This can lead to the use of uninitialized stack data and may trigger
> KMSAN reports. In the worst case, it could result in leaking stack
> contents if such bytes are ever exposed.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Zero-initialize temporary fxregs_state buffers in FXSAVE emulation
      https://github.com/kvm-x86/linux/commit/e1df128dc00b

--
https://github.com/kvm-x86/linux/tree/next

