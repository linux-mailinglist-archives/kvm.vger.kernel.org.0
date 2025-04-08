Return-Path: <kvm+bounces-42931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8574EA8073D
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 14:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4991B1B86E98
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 12:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B949B26A0D3;
	Tue,  8 Apr 2025 12:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="lAnoHnFD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186F02676CF;
	Tue,  8 Apr 2025 12:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115224; cv=none; b=u+sPWr80FVgFT68vKFGBXbSYFIJuFBdI6iF4j8G7zIAdlIGPna+BFlhp25CpjeysiYuWuac3yWy+oKefyi0t6n8QHk4DOABT2eKgNr+9WVn7sXspAoPYI/HfDoU8BeRonuTQaQEAW0wJhe+6/fTjZ3cwJKIRkU2kutvdFQhK2IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115224; c=relaxed/simple;
	bh=nq2Kr9V0iRKj4KAgVfWgH5mjKDMUAxCo9QldS2g1xLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTaDQJTZ4ZC3DiwOLbgFEM7IE/ULe3g+tU3a+SjeOSQXkAQbIbHgax76aeMJMuhUj/9ppFPFMYwy0+n1P6lCfFB3oEoiDwx9cmJ4hpAkbUOn23hrBjChd/Qw/gXmY27xpd9dfgWjn9mILSqnA+0+duXH6vSclA5zdZ2jZh9eFn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=lAnoHnFD; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id A184C452D5;
	Tue,  8 Apr 2025 14:26:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1744115214;
	bh=nq2Kr9V0iRKj4KAgVfWgH5mjKDMUAxCo9QldS2g1xLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lAnoHnFDMj1Xo4jTbJ3bcWpbl3kw57G1fnM6YnNMYGyjf4YScp4Yc6xlbARlSgMUM
	 isjECItBxqvB4kZDevA18/O6noZMBtFBSNZVuEfeST8SoDY3+tNo0mCAFAuKBJDTxZ
	 Ru4CnVZsXz8sOPeiQxx9+5Y1L/KQTfdT/Y2Hqne+ooYsxUMIYB3xvfnYPrIKpfZYaH
	 Ff0IWVpGwf65fsIP7wCTdek2SHu4gUdC8UuZpBEoTKbZdxKN/Xp3MVWkPy/nWlaDMZ
	 DLWG7HyT6OT2uMoKzl1wciRlPLk862ceQlBAdxDGKPkOcuFjsw2WewgJo5SlsOpaWh
	 IAJeHw8N07MMg==
Date: Tue, 8 Apr 2025 14:26:53 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 44/67] iommu/amd: KVM: SVM: Infer IsRun from validity of
 pCPU destination
Message-ID: <Z_UWDSQuD7ZCfhr6@8bytes.org>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-45-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404193923.1413163-45-seanjc@google.com>

On Fri, Apr 04, 2025 at 12:38:59PM -0700, Sean Christopherson wrote:
> @@ -3974,8 +3974,10 @@ int amd_iommu_update_ga(int cpu, bool is_run, void *data)
>  					APICID_TO_IRTE_DEST_LO(cpu);
>  		entry->hi.fields.destination =
>  					APICID_TO_IRTE_DEST_HI(cpu);
> +		entry->lo.fields_vapic.is_run = true;
> +	} else {
> +		entry->lo.fields_vapic.is_run = false;
>  	}
> -	entry->lo.fields_vapic.is_run = is_run;

This change in the calling convention deserves a comment above the
function, describing that cpu < 0 marks the CPU as not running.

Regards,

	Joerg

