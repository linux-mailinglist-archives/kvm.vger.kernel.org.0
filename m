Return-Path: <kvm+bounces-70393-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mF13FF9EhWld/AMAu9opvQ
	(envelope-from <kvm+bounces-70393-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:31:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74DCAF8F8E
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:31:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7453E3006900
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 01:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABEF23E358;
	Fri,  6 Feb 2026 01:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eyLGTqTe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF0C3EBF07
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 01:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770341463; cv=none; b=MSywUomuvSWQy5DCZQhDKpsayhTgW9ErhW83cXxCUVzGL10IUk+8+whTFtpS+zYDW7yQSF1YC6aMJ/mhnKpLS7BTxBqJkRjXVmlf0XCdc3yJ8DFVf247DUDAQVRxA4/CXp0aWWLsEWePt7dcSWhZNYDS1hRIw3HYEuEYKNI+fVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770341463; c=relaxed/simple;
	bh=ELORHn9fbJjQH5Anwg9+axXPn5ABNHTg5QwG5DlC098=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gbqTbjMpZDip3qxT9NVkQ9EVUtUe+lCKK/e8Y6fJm8PbkglKyeXMw6631B6Vj4qADrgWWmEFXaHHTGhRKalcWNJqVM1tzmBcNT2UP9StTArwYCC6R+pYqB+LI4bL3R8P7OE5g3EV3KTQ53aBt7OpU+4+6ORxK5jGRn9VNL8Nhac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eyLGTqTe; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a92a3f5de9so9920805ad.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 17:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770341463; x=1770946263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EZsMKgrBGHcicHKcR8XAFs5upw/32h8e04Mo8thD/4M=;
        b=eyLGTqTe/U8eyB017/mshzU0iGsCOTOp57DxpY5+9FR1Vn5VjHR5ERbDTDteaFr0YL
         cnBhEIE+sqmM8g8LbFq/rFIKaOaPpWn3sIlUwJuL7ScDrn2tIr68HXLucEtPo9VT0X6r
         Xf0kXy0X5ZzyWupIBjDKS+Jd2iY14bJEAYVZk6vuVvT/0cTuwxc8cKnSS8NXUzv0UnDq
         nb9s2MwXHG/nalxMjSVcI8EEnhFB05+b7wCsNDJnHYD4+Du1M9foGhVwJzdrkeBND/TF
         dmu2B+Uk7YiF/H/mV0bNlAFIzKivPDNRqKXfO8FBYSNO0Pt3u3QLdTCN0K23OUKtj88U
         NUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770341463; x=1770946263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EZsMKgrBGHcicHKcR8XAFs5upw/32h8e04Mo8thD/4M=;
        b=szKKFZjX0XkSmV0aEuL5bvEk8Ou2W9RorlwM2pEam1OyDbBRPsszuI2fuj9TYOqyhO
         PKtHaUmGOSPZjntc55K6RrgiVBUO/F+L+n/s6PKH8l3o9EtkzChTBJruEPONjqCGsBgR
         +frw4alpOZluHuJ27io2BFyMh62pYgAn3MpIeAAnxutH9oe6YoX9uys9okF/l1Dd9sBg
         b1ab4rGR1yWEcPuSpoiBtrAAj0KZHjjGrNTpOPMQbPJcKZmJtONc6ubItXnFNxiHpXJp
         MLAoxSL5Qx9prDH1Llbmqu6JJIENPyOfmLSps9LmF3gYslQcxwUzmsX45JnkRbx7ONq5
         ZDvA==
X-Forwarded-Encrypted: i=1; AJvYcCUQGS/UBTrNc7t1DdQR/zUcezaO1KT8J1igoAuifjlc9Qh1JquDC6wiOX2cY4PGnjFe/yo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/XUbEbS8is5u62qQjIHznGslJVhIXlGI4A28I3CViD1wh9Vcr
	R4/GnedWlyGqII5BjW/TJFZxRZ0to6FWGpDee535vgnwjpMRWyhVBzdChtortTVeL9iD0GQk3Kk
	FHfTR6g==
X-Received: from plod6.prod.google.com ([2002:a17:902:8546:b0:2a0:903c:f08f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d2cc:b0:2a0:afeb:fbbb
 with SMTP id d9443c01a7336-2a95160bd31mr11756335ad.1.1770341462779; Thu, 05
 Feb 2026 17:31:02 -0800 (PST)
Date: Thu, 5 Feb 2026 17:31:01 -0800
In-Reply-To: <20260115011312.3675857-22-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev> <20260115011312.3675857-22-yosry.ahmed@linux.dev>
Message-ID: <aYVEVRV-ASogp5dF@google.com>
Subject: Re: [PATCH v4 21/26] KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70393-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 74DCAF8F8E
X-Rspamd-Action: no action

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> @@ -244,6 +241,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
>  #define SVM_MISC_CTL_SEV_ES_ENABLE	BIT(2)
>  
> +#define SVM_MISC_CTL2_LBR_CTL_ENABLE		BIT_ULL(0)
> +#define SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE	BIT_ULL(1)

Since you're changing names anyways, What do you think about shortening things
a bit, and using the more standard syle of <scope>_<action>_<flag>?  E.g.

  #define SVM_MISC2_ENABLE_LBR_VIRTUALIZATION	BIT_ULL(0)
  #define SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE	BIT_ULL(1)

Yeah, it diverges from many of the other bits in here, but frankly the names in
this file are *awful*.

Actually, maybe that would prompt me to send a cleanup, because the fact that we
have this set of flags is beyond ridiculous (I geniunely don't remember what
V_GIF_MASK tracks, off the top of my head).  And in isolation, I can't remember
iof V_IRQ_MASK is an enable flag or a "IRQs are masked" flagged.

#define V_IRQ_MASK
#define V_INTR_MASKING_MASK
#define V_GIF_MASK
#define V_GIF_ENABLE_MASK

