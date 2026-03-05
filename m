Return-Path: <kvm+bounces-72840-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJN1A1a5qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72840-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:11:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71BA1215EB9
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:11:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56CEE319FCFA
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1AE3DFC89;
	Thu,  5 Mar 2026 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NvqzQXr0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1754246BC5
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730508; cv=none; b=gMdjqd+bqa+gwMtxlQ0WQ+dE4QiCPv8jCVVTSXImniM87yGdfiHEcFAb/qtHtSaJEK/rgdd0l7rwz72I0xkJN/teKftdEQjaF6CgJOGefzKv3DVSLFN4WOW5M6EQg25LD4r3PFfJuu7/TJ0Aw6l6jNhr7/7OJalaINH9t/la4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730508; c=relaxed/simple;
	bh=O8F/OpKEPqoxckJjW/M18dzfpFqrB6MLhJmUth4rs8g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OU9JhXkKvAuqepADsA6yZYBYd8SdAanrR5PAKkIgXlXiGLXQZtxC6TRw6yYJSYguoZl9ZWzk+XJrOXpAFdF17YckMAlCekj/OQzCz9bmkQhB4M3Y014BfUdH3EaODRQ3l3tNZlTc2046PaKwsoJ140BUPSjMwqt3W5Y5fU2FgCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NvqzQXr0; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7387c70046so840539a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730505; x=1773335305; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tF1alokY3YId0A55xxADUd9WJcgKIT/tUWOmNO1S6To=;
        b=NvqzQXr0QwJ4ZFCD+BOxYx6nRvQZCk06NCzBm4HBHGRHD/L7X185PK88Foso0frCod
         6f647Ae0GtVGAFXwA9HUHHINFCHF5mN1Pr/tIyKiyGowsuZgNEwSBOhQM8QZQEEmg0ln
         yD//jdhqsH3MaXzHJ9xai+mBtP3f0DX7U45HcgB5Cof67ZzdtWtHy3D1PzOJVABpLpIB
         3C7CiD+mezX7TJyGPx0PU4ToIJQWuYNW5XU8PQ6K/OF/gxBRdx9lEayUn+/zNTsQllM8
         uV5A9DmsRP4cG4ihwzSINlWdh5fGPWmjk+IYASecGRM+qTD6qe4ezX0TDuDCC+Ja/Dzn
         L0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730505; x=1773335305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tF1alokY3YId0A55xxADUd9WJcgKIT/tUWOmNO1S6To=;
        b=dmXidVo3FRlTyhkAScOXSCPuwzqwP8KFkhNF2KCteDTtr3UzaHaXUUVlqm79Urz3VG
         vi6lCGaTVCh99V4oe3Im6YQofTckbU2KyE4QzrgVXoU4mCxWeL7iaO7eMBXIIws86qLS
         GHdd+xwxc2c+D/AWMZctHeBwUxaoJ2Ao8Fblo2k85H55stAaaigBEyflx/rfTWoL1y2Z
         B7uukRZa1lhxawppdEfuBcmEA8hs4gkGeZPO3Kv31Df8zfieo6fL3SLXBRGylCKOmMj8
         M6DRaT4SVK9jRAdR6R8NN57rOw6rT5clt7aKxxcdH85gAOp9mc+9lRsXKZ3XYKbmQfYu
         yz3A==
X-Forwarded-Encrypted: i=1; AJvYcCX9dyXXxyV0Wy5eValnGTI2GeYWab7GrOwN74lgb1K89DuwA8d9sScflheqrQKUMh2kXLU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2gqhlKBBIc/BoqMWGcIESi794S5zDchqZazl476gVrAcnJ8fr
	otlTotzgvaE+3UY3pgH1DmFbx29YTY8vxrAQoBrd82YMMsHkSZHdhgtbjXiOoQjn0npVDd23LtI
	kujdY5A==
X-Received: from pfbhc17.prod.google.com ([2002:a05:6a00:6511:b0:829:9082:12ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:7494:b0:81f:4a06:6f5
 with SMTP id d2e1a72fcca58-8297292ea94mr4681316b3a.4.1772730505109; Thu, 05
 Mar 2026 09:08:25 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:31 -0800
In-Reply-To: <20260302205158.178058-1-kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260302205158.178058-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272959239.1566071.6075460406863903774.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Increase 'maxnode' for guest_memfd tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Kai Huang <kai.huang@intel.com>
Cc: shuah@kernel.org, shivankg@amd.com, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 71BA1215EB9
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
	TAGGED_FROM(0.00)[bounces-72840-lists,kvm=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, 03 Mar 2026 09:51:58 +1300, Kai Huang wrote:
> Increase 'maxnode' when using 'get_mempolicy' syscall in guest_memfd
> mmap and NUMA policy tests to fix a failure on one Intel GNR platform.
> 
> On a CXL-capable platform, the memory affinity of CXL memory regions may
> not be covered by the SRAT.  Since each CXL memory region is enumerated
> via a CFMWS table, at early boot the kernel parses all CFMWS tables to
> detect all CXL memory regions and assigns a 'faked' NUMA node for each
> of them, starting from the highest NUMA node ID enumerated via the SRAT.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: selftests: Increase 'maxnode' for guest_memfd tests
      https://github.com/kvm-x86/linux/commit/afa85076709d

--
https://github.com/kvm-x86/linux/tree/next

