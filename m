Return-Path: <kvm+bounces-70117-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QOd/COGOgmkMWQMAu9opvQ
	(envelope-from <kvm+bounces-70117-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:12:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C3845DFEFF
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 566C93120475
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 00:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001FC128816;
	Wed,  4 Feb 2026 00:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QhNc7UtV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3841770FE
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 00:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770163831; cv=none; b=PGwF4PI1UU5bpamcfnpy7XmAPHditshw0MI+77e8PRPgs6SJOAE2bPxwjoPNTGDBzkwWsAYdh/y+sdNY8yv2G1SZcob+23q4i1TRj9aRWO4OE9eJehg1p2ipGV0D2iudsSZYaS+N2CmhNMNRN8mCzuL/Bk0c4X5NfKCH4rPXkNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770163831; c=relaxed/simple;
	bh=+cL1KlAZeM+JmA6qui5M31iMAkVWU2JYES1SjXcaUSM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=octwQf/DcHmjV/0S7iLmK3CYFcqqmSJzgW5Vqfca8WeCggQe1g54NyH1PmfDQmSnd3LGiNboCfjXpwPKckZ4WGj+bch4hcmG73UTAhGPON5mqW3khkeVaPXSUFWfxvjp2CL5ydgfWNchK2iHJJj/bzzatF+IzXrOhZgn7n0AFfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QhNc7UtV; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c5eed9a994dso3721292a12.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 16:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770163829; x=1770768629; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GiWhw84HjKLziV0r3dH07YAQ/LRLY7phMFHrcPaLI4s=;
        b=QhNc7UtVy1/RIdpA6b0HlfcYJgJYOWOGFeLZiqn4ddfZ/b6mgwM8Ob8C4yxw85aOBH
         DapfuMHKNIn0xgsa385l0gXidRJT0XbU7Jtn7vOiHfmR/dz2oMx72qQcc2ALhEMSoiv2
         mNNjEUMsC5lDWGU9Y7ynFZ5RjVexrDgLO5UyWWYOttJbxrIn2Dx1rxmDeODkchMDS5Ep
         if2WTLsxDbCx8kyQ278SWNMpbAJT3JOMFtbcoeHTlmrekNic5oqKCoPVPpI7gErDiN7n
         RwJ+OQlBBVM6gWm5+q0QVYhVjlkI7AmOJCfHCdtzSt/N42bTrdj7mvQQrUufTdHWVIx4
         wfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770163829; x=1770768629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GiWhw84HjKLziV0r3dH07YAQ/LRLY7phMFHrcPaLI4s=;
        b=hsPKjHsQmA2Sth0QcWcr5rScMAX7CutpBXsV2w63dByiPm35NF9DQ/0mCnAsT6wLGo
         6WlyataY5+YJ3oGfCYIOFVMSp5wpbWHEKhVJzdMADeu+WCNhjMbTktAbMyJYx4GjAfr8
         5Mc7fenefvwBzYWH84yO2a5GdwgjyjXH/X4+2mHB030/lA9W5zdx/JVRY7/iwXs7IpTK
         767OkXjb2wIDIsCLLOLxiXWXrSnAXslIVhzcTaMCl9wWQivQIVU8EQCWf2x8EU2Q0kkt
         BmBrm4RPJ8wDbw/EW3/51xkLySAb0Lx3H3eq1qizBeKDIXQ8Cyd85fa0BLyjg9WPVGQk
         CqOQ==
X-Gm-Message-State: AOJu0Yx+Gn8fu6PorspWF9RufxVJyRX2jl7qXKYR3eE9hRf2y4+5wEyu
	i7YZ6nNkNBPH2UeQTFnBYzYJD/eogfkiW4o4LVakirebGmbn1HuEKXivWv0dV4ovw7pDqy+HSD2
	RcZhpug==
X-Received: from pjbsc11.prod.google.com ([2002:a17:90b:510b:b0:34a:b8e4:f1b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2889:b0:335:2747:a9b3
 with SMTP id 98e67ed59e1d1-3548720a3eamr825743a91.32.1770163829330; Tue, 03
 Feb 2026 16:10:29 -0800 (PST)
Date: Tue,  3 Feb 2026 16:10:15 -0800
In-Reply-To: <20260122053551.548229-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122053551.548229-1-zhiquan_li@163.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <177016372870.574944.18012293019277636771.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some
 unpredictable test failures
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, shuah@kernel.org, 
	Zhiquan Li <zhiquan_li@163.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70117-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[google.com,redhat.com,kernel.org,163.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,plt:email]
X-Rspamd-Queue-Id: C3845DFEFF
X-Rspamd-Action: no action

On Thu, 22 Jan 2026 13:35:50 +0800, Zhiquan Li wrote:
> Some distributions (such as Ubuntu) configure GCC so that
> _FORTIFY_SOURCE is automatically enabled at -O1 or above.  This results
> in some fortified version of definitions of standard library functions
> are included.  While linker resolves the symbols, the fortified versions
> might override the definitions in lib/string_override.c and reference to
> those PLT entries in GLIBC.  This is not a problem for the code in host,
> but it is a disaster for the guest code.  E.g., if build and run
> x86/nested_emulation_test on Ubuntu 24.04 will encounter a L1 #PF due to
> memset() reference to __memset_chk@plt.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some unpredictable test failures
      https://github.com/kvm-x86/linux/commit/e396a7422265

--
https://github.com/kvm-x86/linux/tree/next

