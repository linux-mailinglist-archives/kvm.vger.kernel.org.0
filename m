Return-Path: <kvm+bounces-34000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8559F59AF
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 23:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 339DC16B4C8
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 22:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA24C1F8ADD;
	Tue, 17 Dec 2024 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EHk+UU5x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E125155CB3
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 22:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734475412; cv=none; b=iEH7lIV8Gd2UuV30/xgZRDm3/f+ShPlyqrLM2SsiXroS8GnFQvFaBLjqXm/XUMbxjkla7Tcm17a5/IbLiVK5IQ9HLLs2BvmzcdO5qT3/kvv2n5f2lTISCUSGj9owWoLTpRFCOPGyp1P2NUQhOY5X/EgN7E7l6wFTC7uVYqXM0eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734475412; c=relaxed/simple;
	bh=994MJ09Sr4Z/5FzEqZGcBH3QrWNCbzBKYIcesCa2bcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uOq7HBA3vuBMrqlbgPhhEwwKZ+LnWAd78tWvaRx/jJr2IpshYznNE6rcClBumYpI27TX7GPPjZpdUzleDHOiGgSuzyO5g5PTm+Sup7fbd97IKwEbDNxg8r26bfbRWWzYGKJklmbu3d9Tprs3WOJNzVI7uZT/0H5PN3bNQ6BGGoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EHk+UU5x; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-728ea538b52so8703593b3a.3
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 14:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734475411; x=1735080211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vCq9Ztj9U6pXHxYqVLTYw1eodyLSiro285ZqKow+kW8=;
        b=EHk+UU5xEWKDlXF03/JQK7Df0pwOecKeaXof0/hd23jn7eDGq8XoJrdghyQYiR9ALI
         MAezM70bkBlj4Zvm8La8fw7MUoaESs0bT4ZapPQKJ5pNW6zucFSLtilAmiawZ3/WxvFA
         fOreup89NZRouilbrpiUZMeaqObb6AsaveVJCSSeMJN4cgCuQzLs9f5ULpLdEdNzAwCf
         VIc5nfwp1OvIVTbqNrL8MuyzFaYhHPqrgo3be0ccYzI6AEca0y5Bzt1AUPGtkEn3bnMh
         W0/sCTR9nGrPm7834BVGHy/viGtiIdqnATApQkBg7GX52u3xvz6bPNdvq2rvwwB50PVQ
         UF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734475411; x=1735080211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCq9Ztj9U6pXHxYqVLTYw1eodyLSiro285ZqKow+kW8=;
        b=fdM9d0leSDKOmuf8Dsiux1AFOklxq/nYy3MkY0+JG7RmYez1OOkJPJay2PpQ+/t1v/
         /XxgNPMNWTlfu4wmYqrzFyGN1xXxSFFCHAKcv7bfsfm9pec9OtiiwbC53g9F6gSrrwzq
         lldN0Nw8Rl52pWGy6rw9DNdp0MhU8pFG/CfBFA12iVqvzxQ+qqI6EUyUCFNy538rJ39U
         CHjH8QGBsPX8bIPfOXn/byefiWbsUk1FYAckM5IyTIRkIVXynNfxx3XrUUFJea/9xFrt
         lybDIHv7MK/cIEW6hspfOwNDMh0w0RgQczOQVNrBAiNbWsNKFnR7TOAzth50E8UicGAG
         F/SQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ1NwydVdzgBdnlAASEwYAr2/FbE2i0OWMBKgRyHDQJojvJB+3+JX+S1vyrGb+mryvlGM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0cx4oCMOHp5TxExQE/E6oPsD6Hq72QKmJogIhXATck0/CexzK
	elueBs40B9/PmWURzNBAoJnoBeDCbnEwyTloDvBvJoT22mjkBrqGOSzjk7qc71fdMFYqNwNCdoN
	Fhg==
X-Google-Smtp-Source: AGHT+IEzJo3ccDiLC0PMTGOM9MiGewOZoohaKjl+HxNVFnLs6ZJ9mtf9uo+4FnrFnhMMpqDcltj/MuzMtoA=
X-Received: from pfbbu13.prod.google.com ([2002:a05:6a00:410d:b0:72a:8b98:3f48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e14:b0:725:ef4b:de33
 with SMTP id d2e1a72fcca58-72a8ce3be4dmr1013485b3a.0.1734475410888; Tue, 17
 Dec 2024 14:43:30 -0800 (PST)
Date: Tue, 17 Dec 2024 14:43:29 -0800
In-Reply-To: <bbda7d0d-48c0-4c05-a107-85a30b5c2987@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241206221257.7167-1-huibo.wang@amd.com> <20241206221257.7167-2-huibo.wang@amd.com>
 <Z2DIrxpwg1dUdm3y@google.com> <bbda7d0d-48c0-4c05-a107-85a30b5c2987@amd.com>
Message-ID: <Z2H-Y5eskBqeYo9Z@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Convert plain error code numbers to defines
From: Sean Christopherson <seanjc@google.com>
To: PavanKumar Paluri <papaluri@amd.com>
Cc: Melody Wang <huibo.wang@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Dhaval Giani <dhaval.giani@amd.com>, Pavan Kumar <pavankumar.paluri@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 17, 2024, PavanKumar Paluri wrote:
> >> +#define GHCB_HV_RESP_ISSUE_EXCEPTION	1
> >> +#define GHCB_HV_RESP_MALFORMED_INPUT	2
> > 
> > Where is '2' actually documented?  I looked all over the GHCB and the only ones
> > I can find are '0' and '1'.
> > 
> >   0x0000
> >     o No action requested by the hypervisor.
> >   0x0001
> >     o The hypervisor has requested an exception be issued
> > 
> 
> GHCB spec (Pub# 56421, Rev:2.03), section 4.1 Invoking VMGEXIT documents

Ah, I only had Rev 2.00.  Found it in 2.03.

Thanks!

> 0x0002 as well.
> 
> 0x0002
>  o The hypervisor encountered malformed input for the VMGEXIT.

