Return-Path: <kvm+bounces-70201-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAgQMEtRg2mJlQMAu9opvQ
	(envelope-from <kvm+bounces-70201-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 15:01:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 26C2EE6C5B
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 15:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B55C830AE14B
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 13:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BDE40B6F7;
	Wed,  4 Feb 2026 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EGuIkZqG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E949040B6D1
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 13:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770213353; cv=none; b=c4791nGS/UjYaGjTePN8pR080r697z4kOGdmMBuSgdrLEpZx11y3qFAf3MKOxLORzm1MQmQr/iZ+OU+7zKfSzA/Eg9sH63bliCIcJ1gid92hQvxml2xKU2+Vaw230k44IQnwxR6eGprVlYmMqy5Tx6eJqZjj8TlThFVTFPccfn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770213353; c=relaxed/simple;
	bh=MM6IWOMXLNT2mQ9XGkY6swDqGEKmsrXvh6kN4gffq3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gbP2dkyLlgnoMlAysBvZPVZXB7bzux3qbIP3+PV90eMLcm1AbTTLLmuUFZ/cobHXvWr7nWgs6vv4yLqtI099rSNcPvqKyoSkcOdilQV+wLg0bEjLDlF5oeQv5lj1CWDDfkPlj54BhsUEpCE2RP5L9hiCBT7n4CKZx9466WW6yuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EGuIkZqG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a7701b6328so179267855ad.2
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 05:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770213352; x=1770818152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nuv6nQZeoQMKkhVL28ufVMESOfPcvvC/wzSfthp2nvQ=;
        b=EGuIkZqGw8IM7M273FmRg8QIiMj47UVB4ioob/OvNwI9XQz+qXlIX1A+SLt7v/e/zj
         NYSXb/5ZCwT7NOht8Ht4N0Vv8Y1oZkirXJ3jCsI3rvZy+HG+dw77L6kG5bXBz9y+J4Ly
         iHi6JOAEQeshKrrABy0blu34r7INNGl4fl5b+QJgZHYt90YLlYCg506xQ/5EG5P0ueE3
         et+ywXH6UsM8PsBLr/ZUHL7LM3WdF7q6RWH99uXDcTA0hY+NMo48R24QG/JqfKIs3XWg
         nyF343MJsZlSeGWDhzMU1kSstZ+4xtdNsBMhpEEWyODRb/6ItIP3BvqJS3MfXPH35oiO
         8Vsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770213352; x=1770818152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nuv6nQZeoQMKkhVL28ufVMESOfPcvvC/wzSfthp2nvQ=;
        b=SH9Tfhz3D9RyNnRz+Eo15CIiDpM7JVNtAFCFsLrESGSd1InXe7Nz2ZWSBVTAHt02hs
         EczNcnXAgAvy3jVC5x9wxlOkG563j+JFJk5Eu3JTl04J6fcLlr5DMchwjCwLsjNCdFvU
         WBlpKe+RaptIoj6KeBVRA+hjrjkGekb9+6JTi4B8PsCYcqdaGDxx6SIEQE0Zb3SpGTz1
         M1Lz4sTH9EWPo5Yvd56/MuLT/eRn02o0PcRfS9VBUhKfrXSloYSopvDZChZ5glgoFTVy
         lpf6VrcUCHExCShn28CvPIC11t/RW+O2vfnG/6tGe4og2zktl2UpdpODLxARPtTryf1S
         XmHg==
X-Gm-Message-State: AOJu0YxkRITZSrks7+aWevXcp0frwRnFITOO8IKwQzLqi9onsh4Xa/bL
	2CmhA3AKfVhsk9T6oHh4NK2bHbmheTYm/Ey2oBvLdypUYr7dZ46TgzwTobhz5Wl5qGs851fr5id
	TrxD+fQ==
X-Received: from plxj12.prod.google.com ([2002:a17:902:da8c:b0:2a0:84dc:a82f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b2c:b0:2a1:10f7:9718
 with SMTP id d9443c01a7336-2a933e95621mr32715255ad.30.1770213352173; Wed, 04
 Feb 2026 05:55:52 -0800 (PST)
Date: Wed, 4 Feb 2026 05:55:50 -0800
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Message-ID: <aYNP5kuRwT33yU8Z@google.com>
Subject: Re: [PATCH 00/32] KVM: VMX APIC timer virtualization support
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70201-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,redhat.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:url,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 26C2EE6C5B
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch series implements support for APIC timer virtualization for
> VMX and nVMX.

...

> [1] Intel Architecture Instruction Set Extensions and Future Features
> September 2025 319433-059
> Chapter 8 APIC-TIMER VIRTUALIZATION
> https://cdrdv2.intel.com/v1/dl/getContent/671368

What CPU generation is expected to have APIC-timer virtualization?  DMR?

> base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377

Please base the next version on `kvm-x86 next`, everything in here is KVM x86
specific, and using a vanilla -rc is all but guaranteed to have conflicts.

