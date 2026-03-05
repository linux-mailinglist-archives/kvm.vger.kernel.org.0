Return-Path: <kvm+bounces-72870-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WEhsDA+7qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72870-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:19:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B092160D8
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7D5263070BA0
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05A693EB7EF;
	Thu,  5 Mar 2026 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iRcOiIbF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474F93E3D91
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730791; cv=none; b=iZ7iibQExo527WH0YYi/xgbYXYEq83cFNopI2vW0vpMchuBKHFEqrGZSUtKYlg3UBEtEzoJZ8HE4G2LIn4rEnoTnzZBB26CVqCaZfPc7Q3kfbDIkPYCwGxmkKUw4Z0djPnBbaGzIRVrUQMUIzoTPFZi1Nbmu/1cO3ILQHEg6LK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730791; c=relaxed/simple;
	bh=Fz3G3Z5CUb5GrsRoilSsxcmoG+VPiuH3K0kyK3aJ/zk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=szPQ81YGNfdbfgTowOg/F4L+4OjZQck3v2NfiDA1q30+0RBMxAGdFEowrPflsK2fj7SvHAzFuJBRWYcWlo7pMG4pBVtYQjmEbDAXWIPETaxONeMNhSBVfPXMf2A9+3L7a32fu12b7JxVz+hnhZ0EObZqYy+xXUDUaMKscLR3y2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iRcOiIbF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35983ee9f3bso5150363a91.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730790; x=1773335590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=toKHjbhSQYEtn1NXwk4TcR5FSrtPRj/vRbKjJXmaJuw=;
        b=iRcOiIbF1TD/VbAG04Q0sYrVGoUMcZyEHRTZ51na5FBjnRFkefqLuIT0eqollq7mmH
         0sR5KmRfw4bkbZZjMo/9FKgoPLSSlsUtGni3ZtegTh+VXzY77gjw+Id3FqgJjh4j5Sur
         fThXtEolT4Xhyv08jUUT0BwV1tH1D18iMdQmkMc78SlLcxA5K0VJtw1eSChiQm839Y0Q
         du0R/GuzdnoLm792wr4lfwMQPPtr4/aDiUmvuewaleCax0/AzSqSyNnunry1b2X6EOwB
         SCezFmYPLjzNBSP7FwcfAte7cgHtNjl8wwaDMEmRXKhIoqP15I/qtwh+wd1mUyIqxy4y
         Q+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730790; x=1773335590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=toKHjbhSQYEtn1NXwk4TcR5FSrtPRj/vRbKjJXmaJuw=;
        b=I2DNUwsGCHj2fcvlUrCZI4fOG+Zepsp01uSqaZ58/fx8IVy6P6SyBE6OM0blBRp3iI
         9CEDPfo+l0wxzx8t223WoJkirMrXvMgQg+xTns/3quz3Q3muLxpiyB6g/EOMMHa5DVQa
         VKMUfOcXUf8Zg/wZxRv50csRnxY+N5I+7JG/V/jpEfEUIdiajuRpTOd1T6q0zoC6N4Vs
         9AW31dCDDCtvI4KnCLT+rR5J68BD6nxp18OXbW6DAnTNAcJvcebaNL6/AmrmauwfHYQB
         r7NyNApWlccngN0UNOkeVgPvaGu+JRs3FLhpUmSeR/Vx0lrnE9BG61gnKguNgkD+gbqW
         zErA==
X-Gm-Message-State: AOJu0YwQVPrtONehaNLatjLde7aD5Dd9rNKQ2e+3ubYqYZC16o1m4+NG
	GINM6LcSL04a7yz9OhzimtBfODFbBAVZcGPJ4KZ40lrOREMDFEB7yz1Q0zy8frw4yV9xVcZu87T
	XARcyUw==
X-Received: from pjat8.prod.google.com ([2002:a17:90a:d08:b0:359:8e19:6edb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ace:b0:356:22ef:57b9
 with SMTP id 98e67ed59e1d1-359a69b5602mr6363722a91.3.1772730789529; Thu, 05
 Mar 2026 09:13:09 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:29 -0800
In-Reply-To: <20260212103841.171459-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212103841.171459-1-zhiquan_li@163.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272958168.1565880.614050090321272252.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: x86: selftests: Add Hygon CPUs support and
 fix failures
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, shuah@kernel.org, 
	Zhiquan Li <zhiquan_li@163.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: D6B092160D8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72870-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[google.com,redhat.com,kernel.org,163.com];
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
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, 12 Feb 2026 18:38:37 +0800, Zhiquan Li wrote:
> This series to add support for Hygon CPUs and fix 11 KVM selftest failures
> on Hygon architecture.
> 
> Patch 1 add CPU vendor detection for Hygon and add a global variable
> "host_cpu_is_hygon" to identify if the test is running on a Hygon CPU.
> It is the prerequisite for the following fixes.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/4] KVM: x86: selftests: Add CPU vendor detection for Hygon
      https://github.com/kvm-x86/linux/commit/0c96c47d4345
[2/4] KVM: x86: selftests: Add a flag to identify AMD compatible test cases
      https://github.com/kvm-x86/linux/commit/53b2869231d3
[3/4] KVM: x86: selftests: Allow the PMU event filter test for Hygon
      https://github.com/kvm-x86/linux/commit/6b8b11ba4715
[4/4] KVM: selftests: Fix reserved value WRMSR testcase for multi-feature MSRs
      https://github.com/kvm-x86/linux/commit/9396cc1e282a

--
https://github.com/kvm-x86/linux/tree/next

