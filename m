Return-Path: <kvm+bounces-71161-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CCZ+CHmVlGneFgIAu9opvQ
	(envelope-from <kvm+bounces-71161-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:21:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E0714E101
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 85A473012D0E
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF9436D513;
	Tue, 17 Feb 2026 16:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qH3n/si0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16A136E47B
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345266; cv=none; b=MdpPGI/jTDtOWopYgtAcAVSQ9cPA63TcoZMJ545C/YN+lDac0NokcX+lFHsQfDQimVYFsaSgse0Dg8sbiH1pHH+saSBlze9oN7ZZKVvKDdpf+K1dB4DhEab3Y9H7yIUfwHfEdgoxrCUJyC20YEFsP9sOwQkF8fSfY9CzCZKXplc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345266; c=relaxed/simple;
	bh=eZEe8U40ghU/K15ooJWXSf63PwA1BaHVbEpt8R+8p4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CZHQjkPKTin6V2+0IYIf9TJp4DtRXBFNju/MFMTOEZzmsHYtYPScIkERodJJUad4Yi5ujZSNQKgNrBnbb+E00LpGFpjRDMaMZifyfOj0Jqgla+82CEhJirqFz+ehaRzp6j75/zpKPPG0A12PLu71sm2Z7u5czTzSfYyrfu0TGLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qH3n/si0; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6df833e1efso15099898a12.2
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 08:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771345264; x=1771950064; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iWP/bwIx7Xqh2wLp9dGsn82lhgqSno2S73rZTaTg0ek=;
        b=qH3n/si0aqjaR6esWyGiE+dxlOFUtqszKsVbHKyIN6pSsas0ZON4kp/DwFfak/KuHz
         PATtEGP+IsWsxTNec3dBbcOQ/B0LVMgRasJYMO4u+9qSgjZyBbTbZjL6rALA+aDVXkVX
         ahppLZy+XN32wyjR8CXO2p3Yvw3I4X/amPkCVflQYyia9LseL3Y500+yIXbaGrO+WzoZ
         H19VNiQalL6az7x0Mruzk39ZFYu4hCibJcdp3R7BzNbxrmvVrIcGMaQNinZ9WhNL7ho2
         YGQDhGyINvmagDE4beN3pIGpsiNeST53jP8MX17+QTFTKxhgouHjz6bqErJTOSHQISEh
         3qPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771345264; x=1771950064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iWP/bwIx7Xqh2wLp9dGsn82lhgqSno2S73rZTaTg0ek=;
        b=azdRJeHdOnXEj40nXb0CJWlS9ndHFh+bg0hvQgzXkEAbm0EXXQyDeZczjLK4XHvGBq
         aBlCpgK40DhQBlpn/pb56Ztkixl5VcAeWFxsbDsMZBEz2FoYdYBEf9YLOz8T6yZAVjPu
         HBjhWyCvi2owAwuHonve2z/m/pouahZSvhfpF79hJFQRSlf1Bmm2XO8hopXiWEejHW+4
         Is77PWMwQgCBfoTHjamSLoEH2xKsBUTTarWDLI1XiMYt1AdEiM4ujzNK9TAHW5/xtlv1
         nYotDzEcal6VvrjtT8O5ZW2GR6u2KU/MOl7wHsgVqwd+pn13Flr+IsxAvGieAVVm1a5d
         Q6/g==
X-Forwarded-Encrypted: i=1; AJvYcCVHnQdmz2MzUR4NcmPsgqwu0P5rNYxD5mMHT5YAAd6Zj5nuGFRwLAGjy23c7ll/8RPqJU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWwvW2R2RL5cTtRlOVPi+Uznmvk3IzbKztx7H3wEAkz3bbtAZ6
	cr93/jSI3JIUKPjxh1dYVL0M6YKJwPBX4UX3sLQm34nXexmevLi5AWLy4eLAEeUC5O0jExtL629
	yF4bTYQ==
X-Received: from pfbfb25.prod.google.com ([2002:a05:6a00:2d99:b0:824:af69:6dae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:808e:b0:824:93e4:2ddf
 with SMTP id d2e1a72fcca58-824c5ea253emr16113080b3a.13.1771345264049; Tue, 17
 Feb 2026 08:21:04 -0800 (PST)
Date: Tue, 17 Feb 2026 08:21:02 -0800
In-Reply-To: <tencent_EAB2053E04BF4C7F996CEC61331C23154007@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260215140402.24659-1-76824143@qq.com> <tencent_EAB2053E04BF4C7F996CEC61331C23154007@qq.com>
Message-ID: <aZSVbjPhURBe1Rj0@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Use dynamic try count based on vCPU count
From: Sean Christopherson <seanjc@google.com>
To: 76824143@qq.com
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, zhanghao <zhanghao1@kylinos.cn>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71161-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[qq.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,qq.com:email]
X-Rspamd-Queue-Id: B3E0714E101
X-Rspamd-Action: no action

On Sun, Feb 15, 2026, 76824143@qq.com wrote:
> From: zhanghao <zhanghao1@kylinos.cn>
> 
> Replace the fixed try count (3) with a dynamic calculation based
> on the number of online vCPUs. This allows larger VMs to try more
> candidates before giving up, while keeping small VMs efficient.
> 
> Formula: clamp(ilog2(nr_vcpus + 1), 3, 10)
> - 4 vCPUs: try = 3
> - 64 vCPUs: try = 6
> - 256 vCPUs: try = 8

Why do larger VMs warrant more attempts though?  E.g. what are practical downsides
of trying min(nr_vcpus - 1, 8) times?

