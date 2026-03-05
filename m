Return-Path: <kvm+bounces-72848-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qJrDEkm6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72848-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:15:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C35215FD5
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:15:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08424316CE41
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788133E3D8B;
	Thu,  5 Mar 2026 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNJ79M0b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF04C3E0C41
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730614; cv=none; b=BfV5yqnBmYJjy1GokdMGKXX+6J0lTtPm1CpZ+jQ8RsmBc+l7AK07MdYM8Uci9pr6qDiZcYnPZ5o/X0gKLQbPRL2K5Qz3Ri67TXKez6FLfgzG2Wan1ofB6/b+q3wkGMot1cDaBGSamk+rw3yC8Fv33hcSzwFgHOb0B1/l/QTpHBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730614; c=relaxed/simple;
	bh=6sBwKyUbRd9J+grCl8h3PzA4XqMCb7x6zWm6vV1drEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AFPd2vCFDa3iNqd151FY1UmwWiFUbZUsFpJ6I4ntTQafqeROzqOd5WojneCMfTssyKEriDNWFcERsHPvxUUo7hbdjoZ7HL0NYQq0O9blUSPz0cgXvbmMMjOc/fxrNwdgv08ZCyjSrrbyUxdUb8AeHYV4HV8ed2P7QXP/9m8avdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dNJ79M0b; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3598733bec0so24723122a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730613; x=1773335413; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v0hxi3yT/I4nROe6cF1oq7d2xk2QqN7INhdUeeNWiiI=;
        b=dNJ79M0bA4S8P+EjE3YguW5b4/NHASRkdxBJETgfFEseejXA3sfHXyTT/elDIi3dlN
         dxUWvpw6+Mbiv8czao7TEHLyaKOd/ymQnMUAyDtzyqwcTOWwOB2BqdbsI8tMMLhuPRdr
         ZYu67BOBknai60FtoJ9R+8bgsF1Ccn6w4v1P5Iq3FHrq/+a462KznqjrmBTY6/HtrSE5
         jeFXdlv7iuCk/yi+uPAA9C2cRJsTx/5hToOY6lJGIKrvzZ3O6+dqtQDtCFi80gvZCV49
         ck6RpFYi6awfn7YqKie+UnYjCV415npGO2okRDJRgOVp52qCzAGv41s2PLcqo4ZTFxlB
         7IjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730613; x=1773335413;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v0hxi3yT/I4nROe6cF1oq7d2xk2QqN7INhdUeeNWiiI=;
        b=M4RDPbvpFE8EvsI0iALOOPxSmxWMJGZCl0c8piIAKNwmOoSQRktVkwHoQt6jQ1v0SL
         KLvwvsegpD8LY72mHXIfobJRTpIE4pZtIjF1ZlDqO9FEQ3OFnUs4QjdkBhyfhOqG+ddD
         nmFPxbHN2AU2OQeyLUfL6dCwyuYGyd6s4nGAdvGOnk3A4dZwm0hwy8O2wvIhP3RNFe+v
         HA6XEh7Yn1Nh5uODt5Czhh8bTn5FefHcYbp0xWSE+PYdWJJYDmN8bFcROV/OkO6U7mGs
         RL46pf0G1wB+gSfg+etc2i4cof4VsYv0rDzPSwdbq1SJ/Ly3qeQc/O+yuuoCDaCS6v8U
         GLiw==
X-Forwarded-Encrypted: i=1; AJvYcCUbINswXlhOCMSfcFZ4t3RVoanlL8boI41fPIy7YoB2EBY0HcfExp+cTaIoU8rOeveaqOc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwb8Ob+/wTF7ooCDVfrLw3MzeH1I+65uqs/dvql6OGEztxLT9d
	tz2wF+p8ZpTxcE7jJdzAfkCnxEcaBXoG+Q6KkunZvZUtfWVUmyRdPCl6ucd+IsfgBA8KRqkO4fj
	XPUx6lg==
X-Received: from pgac15.prod.google.com ([2002:a05:6a02:294f:b0:c6e:2f6b:9048])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:354:bfb7:db0c
 with SMTP id 98e67ed59e1d1-359a6a3bce5mr4965472a91.22.1772730612981; Thu, 05
 Mar 2026 09:10:12 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:45 -0800
In-Reply-To: <20260129172646.2361462-1-ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129172646.2361462-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272879598.1559970.14064744720620776773.b4-ty@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Don't set FGP_ACCESSED when getting folios
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Cc: david@kernel.org, vannapurve@kernel.org, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: A2C35215FD5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72848-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, 29 Jan 2026 09:26:46 -0800, Ackerley Tng wrote:
> guest_memfd folios don't care about accessed flags since the memory is
> unevictable and there is no storage to write back to, hence, cleanup the
> allocation path by not setting FGP_ACCESSED.

Applied to kvm-x86 gmem, thanks!

[1/1] KVM: guest_memfd: Don't set FGP_ACCESSED when getting folios
      https://github.com/kvm-x86/linux/commit/6dad5447c7bf

--
https://github.com/kvm-x86/linux/tree/next

