Return-Path: <kvm+bounces-72843-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cE41B525qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72843-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:13:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C59215F13
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3D7530B3D58
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47823E0C72;
	Thu,  5 Mar 2026 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zoTXZgoo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF893A4F41
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730556; cv=none; b=jaq1glrvMCUqTVzCpl1XAxiRfzp3af+Ehuk2Xc3jIwB51GkNG47YIaps36ADq2Rtku6UsiyERb0e9RH9Xp/8C5Ekr5i/IQUAMicl//EI0fAT5IuGw2wOxGymCfEOSuxMN3ONf14bzqwiUVBrrSbqLJYhUd0WxorGwRUhPoY339U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730556; c=relaxed/simple;
	bh=sfX80c4qvXwdmqM5xl6QJiajmZbJkMPvDPQboA+f33s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T3VZoMQMkOz7TZkdv6Qtbpu59vJz14cGGDKZv3SsJxpDYaD/SuMPRL3YFV2V2/9oQXYRCnmfe1zL3RF01vxqMB9JXDxL0Nb2kpGnUHqE5vwQQRdaxCownmCa1vHksaX85YK4XDEfOmLfqXevYwgENthdqabkT9rsB4p05ZP63Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zoTXZgoo; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae66ee7354so25827225ad.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730554; x=1773335354; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7fUuB38TxJCzu+MRahQiTijhmMb+jIckl6Hj1TyDzdw=;
        b=zoTXZgoorSHS5DLpVXG8TVmhE2B7SJFs6DuO1KB8bN8bSBT8bmcwE61OPDsiUDKMYI
         s6HCsAYk8+pP0bWroAyEibj0hwlsaVPD30JiX5EL+c3EQ15O+GaxAsfGIDDqYGsxHrtg
         +2bYWUAjN4Q7+iY9uXjvK41btigcKYbW6Aem3jAPxmkzOf46qSHqRT+dQUiqRPnUQ5dw
         P+qPztUlirOqfIq8HL+vYSjBDrQCFkQgSNkzHkahi5qL83r2p1S7mKT7O+6mBUfV1VMh
         qgqruxSNqkstddAPDjIfVB8kbcjjY/Pb+LHQQsD5Z9abBpebn7ist/Vgu6II4S5QGnxG
         RBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730554; x=1773335354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7fUuB38TxJCzu+MRahQiTijhmMb+jIckl6Hj1TyDzdw=;
        b=SpZGQTwt4+/qC0w4+esnPJcqAPmCDdicjweRvENMoMd1gxT7n8DExtURUxhT0ZDjmo
         xeu5xweEXsqK+Iyd5E3gp8m5k0mt6+kgJOGkjdHcGSs8GNnlNDMz2xzk8w/XsCZGVIsJ
         GwQbcmW3xjOrlHFIcc1r+6DlhFC6Zm2kUID8HryjgvHVDEVBx+zLS7d0HBdV1dND3Oun
         fXifVqp4BHXEoa+yGVla7qmq7ftGCn5uydOMHiP9CbzGfssAQSj8sG7hSY8nmlivSf8D
         xyufxT0AZG1Igrn0dpdKjKiNEpu7RCx3eT5h1vlrq8Fxu+xOi3+5x/m6LXzR1b/raw1e
         PYBg==
X-Forwarded-Encrypted: i=1; AJvYcCXOuhKjtztvJDLVpq0z2HBfgfCVGJt4C5fU0LWqQ6UetgMSzVLOGmHwuWFH/cbaZj4qZUM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvk3muHkUh+TDdXEenewyYZlHhOVmG9l0pHxUoe/EVqCNrAPlU
	efnvcRJmOI6g/2PfcwYlrOJ4tH4YeMII/lY4PMdwNWLTTOPJdtCsHkYrU9BTu/YLqKMrFYTBU2I
	E1WaXxw==
X-Received: from plly15.prod.google.com ([2002:a17:902:7c8f:b0:2ad:ac39:8f0b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc6:b0:2ae:5598:1db2
 with SMTP id d9443c01a7336-2ae6abb512cmr62372415ad.56.1772730554284; Thu, 05
 Mar 2026 09:09:14 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:37 -0800
In-Reply-To: <20260220220216.389475-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260220220216.389475-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177273037884.1572046.9315819141730304141.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Fix a wrong MSR update in add_atomic_switch_msr()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: B2C59215F13
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
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72843-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, 20 Feb 2026 14:02:16 -0800, Namhyung Kim wrote:
> The previous change had a bug to update a guest MSR with a host value.

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: VMX: Fix a wrong MSR update in add_atomic_switch_msr()
      https://github.com/kvm-x86/linux/commit/5d3f0518caa7

--
https://github.com/kvm-x86/linux/tree/next

