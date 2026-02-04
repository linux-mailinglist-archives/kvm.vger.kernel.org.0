Return-Path: <kvm+bounces-70123-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBPRJayPgmkMWQMAu9opvQ
	(envelope-from <kvm+bounces-70123-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:15:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EE996DFF5B
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E94DC318560D
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 00:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4734E3FBA7;
	Wed,  4 Feb 2026 00:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1myNOOIJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5534227713
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 00:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770163869; cv=none; b=Xa/hdqbmFTAucSyHusRbre0jX5xK2q0JBJEC4i5Mvxnk8T3mxGu5jX+w27rJ2A1CXTqbskurNk3cvUhMaK3Rwep3S9olaIHkeCCdvIBKJTGUTrkXYIKS4eTViJ8GBh0y9/NJ0fVt5GF+BIkG2j7ldHr5A+9/db6S9bn8hvLAP2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770163869; c=relaxed/simple;
	bh=ICObr3RXNQrcT1sXSqfxJaZWh1NvVxjHGslDwmmumOM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z+0cLjp9S+TqkD+uEuAZeGUZ1ohhZb6Z9ZtPwd3suyL8jOj4W02orL2HSC1FCI5sMwucxdpYJxyUsQh4YQWByk4nsO7PmzORB8dhcTy5dP66vZVKlj54ClNZfcY6alu+chx/WGFiPtEv7+Vlw+phPFZQYYZTqA4RivaeJklguOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1myNOOIJ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a863be8508so80784965ad.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 16:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770163867; x=1770768667; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VYwGkq4tvz7SkzV+rZAFA2QLwjBHcMshI0mHagHtwiw=;
        b=1myNOOIJGfCA5IOgX1ed9njiYib2FGYGRiXOI1nhVpDG03vDs05ee8+8zhZSaNzDyd
         3kuc+77IUtX4qYrJFICmbcHUKq/Yzj1Ip5M/voZf6icUmWj69pqX8bY37ia+RRNburmI
         CDTfKH0XQMjYj+NWj/fXn5Z78H2jgOmoEDwKQ+BE/PiER8WXTv+wZaXJa5sMuB2uGEc7
         6F7/jrhgdq4JQSfXzmxAN4R8WA1UPKXkiM9ZRLhPse33wQ6dTe/r4v1ZW58zLxPDTBZS
         QxtnUMWtNkwAyVPsyR+VtnZWP5f2GmGHpo2Sj2sF7pDsBaQ9saeZt/65O0JUObCApvl9
         F0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770163867; x=1770768667;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VYwGkq4tvz7SkzV+rZAFA2QLwjBHcMshI0mHagHtwiw=;
        b=d0NrmfdCFxU8LDuuGdutrEOOi7RJApBDbSIz3ydZABZ+GtfUT30It5y+6PbRX2WBt5
         0Go6IBs7+QWmob1Og6/UlewL+PCyLhfmFrX5K8sFBjmXlFQICqVdVfCKvPSevQF68p8E
         SoVXPHvHbJrO+3w2bsl/yHdG5RzEBxoRVQyji2QoU3kNpTFF2TStGbWs3/VGrHVWhjaN
         m/izOjf3GV7dwgIJ4CUwHLtUqeiLirD6y6sO3hyX87lahTVv7JDOwHVk63QAlOP+rtdb
         QNdK+Rk3Iywsv+qHUfmx2x8/FijB6iRnVndKAzUHHBpGD9cfJexVZwEC+UOaJdlZBclS
         XAKg==
X-Forwarded-Encrypted: i=1; AJvYcCVhG+ODLlAnQlMMPzW3rBmA8tm2yUqLlT3Owh1H7uNwPbt/pGFHUuz2Y0sPu9IVI0VNTU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxtybY8eN6EyHn5Cgw3U2bw/J8S55HgqgQTD5aACl/lJPK+Ouq
	Qb4R+clv0P0O7lNz5K5uCQFYG3CDlk/izdWb6e6kzOw0H0scvWsgnhXAp4L4g0HiwHH9jTJOKwL
	fXxms2A==
X-Received: from plgw2.prod.google.com ([2002:a17:902:e882:b0:2a9:1508:533a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:191:b0:2a7:8bf3:5677
 with SMTP id d9443c01a7336-2a9341371b8mr9635655ad.59.1770163867558; Tue, 03
 Feb 2026 16:11:07 -0800 (PST)
Date: Tue,  3 Feb 2026 16:10:27 -0800
In-Reply-To: <20260109231732.1160759-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109231732.1160759-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <177016365652.574271.13292347664843792807.b4-ty@google.com>
Subject: Re: [PATCH v7 0/2] SEV-SNP: Add KVM support for SNP certificate fetching
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com, 
	liam.merwick@oracle.com, huibo.wang@amd.com
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70123-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EE996DFF5B
X-Rspamd-Action: no action

On Fri, 09 Jan 2026 17:17:31 -0600, Michael Roth wrote:
> This patchset is also available at:
> 
>   https://github.com/amdese/linux/commits/snp-certs-v7
> 
> and is based on top of kvm/next (0499add8efd7)
> 
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/2] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
      https://github.com/kvm-x86/linux/commit/fa9893fadbc2
[2/2] KVM: SEV: Add KVM_SEV_SNP_ENABLE_REQ_CERTS command
      https://github.com/kvm-x86/linux/commit/20c3c4108d58

--
https://github.com/kvm-x86/linux/tree/next

