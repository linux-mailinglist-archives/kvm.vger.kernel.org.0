Return-Path: <kvm+bounces-54970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81449B2BE37
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 335E072042C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E4731E11D;
	Tue, 19 Aug 2025 09:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rJST/oWY"
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA10931CA7C;
	Tue, 19 Aug 2025 09:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755597232; cv=none; b=GxGXP/InPKbdw8vChJWrj5X3JNy1LzxpVqYpN/4CCsEPwQk1iav1iHp2zqzsvnkoDLFHkIAtNvXAOVEH/mK8aUf9KhVJQdWq38Eu4mtowQtwtNhjqvSEBsJO9Fis0LvrOf8nP+w+7Apvarj1emHCkWmP9O8fBcmKkmxO2/wtWI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755597232; c=relaxed/simple;
	bh=12Pi2sh02JVermxVTx0a5X7Tf0HJ22BFKv1ii4D6grM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOqIEU8qyhAEALJDLOl6918PDhc+PiyL3kZVcnvFnAHpG7WWJIUMKE9eHDYfK4V2EBijr1p0W01CJvNW2iWWWhM5g2ruC74fL9P+0th6ZtUR8oqq7KRUMUJ6TdicXF5SR2DPWAohroV2Wk+cMQJ1t0fSLv2pa9l5Cc/BHw6DPJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rJST/oWY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R+pfRtnnwtFrBP70lLHPGfon4YdNoRjlSeg9+m7E+Jk=; b=rJST/oWYhL2V/A/kwvlWa5nXu9
	hAI8kfmVIJPttAZ13I7B3crwryT7O8hyG6Ix1lwkzXoF7XKWTQO4/NaN/Q+6HNCM6mjB2O/BHTnIY
	ewuQoLf/8geLuBi8+17vDQ4pe2SAo+PGuP4fTYzCYHQhhkPmCf2mb24qTWCsFxz4iuXZltt0Y5aF+
	0q/RlNuvwoYxSywhE0qok0tXqI4LHy8AaLLcpAMdEJ088rroGHTSRqQ7+72hcazNG4xg2ScTZ/Rci
	/AZPakPxbTiZUhP9fg6tjLD0+i1GSHuF3379srdrt45CJJT9dJ4ngKZXQ9WDopmHghCaIykbps9/Z
	7h/IpjKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uoImn-00FTjF-1Z;
	Tue, 19 Aug 2025 17:53:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 19 Aug 2025 17:53:41 +0800
Date: Tue, 19 Aug 2025 17:53:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: liulongfang <liulongfang@huawei.com>
Cc: alex.williamson@redhat.com, jgg@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [PATCH v7 2/3] migration: qm updates BAR configuration
Message-ID: <aKRJpStZKhy8_5-V@gondor.apana.org.au>
References: <20250805065106.898298-1-liulongfang@huawei.com>
 <20250805065106.898298-3-liulongfang@huawei.com>
 <d369be68-918a-dcad-e5dd-fd70ec42516c@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d369be68-918a-dcad-e5dd-fd70ec42516c@huawei.com>

On Tue, Aug 19, 2025 at 05:12:52PM +0800, liulongfang wrote:
>
> Hello, Herbert. There is a patch in this patchset that modifies the crypto subsystem.
> Could this patch be merged into the crypto next branch?

Does it depend on the other patches?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

