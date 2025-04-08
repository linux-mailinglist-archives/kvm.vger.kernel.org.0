Return-Path: <kvm+bounces-42885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C45F5A7F4BB
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 08:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76E6D3B5D54
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 06:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE0626139D;
	Tue,  8 Apr 2025 06:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mskJcags"
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348D525F7B8;
	Tue,  8 Apr 2025 06:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744092548; cv=none; b=f73B2r2gfcAe8xSZq2ypf+8g3QpNaZqVoObi/8fyLwVTyXXmWQiMsvsiINWUc1mAdzd9g+EBV48OHaA6tG8opSTjm0QI4cFS0S7Xus7dsHez28HBwv2rNg+IRYZ08fj9+qx3whB5hnugY9q//YwZIS9yVeRXhbn2iL20PWPrsg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744092548; c=relaxed/simple;
	bh=g0dTaV+ONBTXwDj87Xb1/HxT2I2apNuWX/IGCJLFQKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8Ezg017ZIzCVSPpflWSFKipqOUNEJxPwcp46ze8//JKex5f6pBPS8MtVbjzqckqCpfBjxZ7F19Z+dhtDpxlGOb82tJ7hyfxIKZDtcMU+stan3xRpoMCD+wcG5G8uVoNvOEDzcDv4D/m6/WUO29EbiLTmlnWECBBTJzs6Cp0pME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mskJcags; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e7Kb4SNn/EgtB4bJKa5yE6xoPLXUqY2wROH++Khm8QE=; b=mskJcagsqWEPW11SwOyLFrYJuL
	bzxsclsnbBnBZ9NYk90EVw/XJ8L3y5OmCQ/79S+J3OZsNbgR4bq6jbCwM8HMHERCIZCbRht/NSc/z
	k9K+ijeL3/T+BQMxahAtXae6OgTpW1Z78FY59RhOtI1tqd31Fpc42W6/sDaSPEpaTQ40lW+TXQ3zg
	SlZHrZ7t9lCxs1YThOhrx/QC6UMw3g4elt/5D5Q1ixU9e1Z/086D/RKAWywwjN/eDili1t6TvYs0d
	WaaSMQ09seVeY6XtUFjd+sOdLJuDMsiiwACkcVwdbVri5mZUREqPHTMiZqeJxR9ljtNyGdFg4cZSh
	AdzmeBEw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u228F-00Dn1L-30;
	Tue, 08 Apr 2025 14:08:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Apr 2025 14:08:23 +0800
Date: Tue, 8 Apr 2025 14:08:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	thomas.lendacky@amd.com, john.allen@amd.com, michael.roth@amd.com,
	dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org,
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, aik@amd.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v7 0/8] Move initializing SEV/SNP functionality to KVM
Message-ID: <Z_S9VwUgN-zcWv1e@gondor.apana.org.au>
References: <cover.1742850400.git.ashish.kalra@amd.com>
 <Z_NdKF3PllghT2XC@gondor.apana.org.au>
 <CABgObfa=7DMCz99268Lamgn5g5h_sgDqkDoOSUAd5rG+seCe-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfa=7DMCz99268Lamgn5g5h_sgDqkDoOSUAd5rG+seCe-g@mail.gmail.com>

On Mon, Apr 07, 2025 at 09:53:19AM +0200, Paolo Bonzini wrote:
>
> Thanks, go ahead and apply 7-8 as well (or if you don't want to,
> please provide a topic branch).

Thanks, I'll take those two as well.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

