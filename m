Return-Path: <kvm+bounces-22590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB95940968
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A42F1C22C2D
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 07:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE5818FDD6;
	Tue, 30 Jul 2024 07:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="fZ9dlvG3"
X-Original-To: kvm@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0861238B;
	Tue, 30 Jul 2024 07:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722323936; cv=none; b=MKrKwCm/CB4nPY59LjIHSqdZ6+6ALF2nBpeEBPctAIyvZcibbt8n5o2cOhKjiioCQsx5qc5sKNQJ7O10YBEWRXlQxmFc4+RHEbMiZCujYMUNm4VpKHnHJ2naLg7JiL6FUhxMvXT3cGgWQR5QFAfCZF/h2um1gwkCB5ueJ9A6ts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722323936; c=relaxed/simple;
	bh=mvUXEyj8n0lpm1DcB3kWuWFJ38fz9t5gRU9qJChj17w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlWRljWWQOn8kZXfURHKO2M4R+nUwhHHM+eBK5oQM43WDjJqhNcOrQU2ALE+1yFxxr+wM2Lm4vioAD30mCyoMDALOt0m0Z9HaY2zk78sZH04bUzpluceLOaCKlJtdXnsl6vHRs9R1RxczVvjYZW8G9hmw+hf9oqF6m1epK82xf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=fZ9dlvG3; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Rf+jSDKzJRtUOiZnv2y73slfY9+ej3+jg5VgFOihrfw=; b=fZ9dlvG3u1LWhn4N8+qWBqAo41
	vrou11aCZPC6xlcXnrtvpiPNt/DExWCFnYH3M2esfPQq7tw1IoyW/a/m/BQzv2cYdc0ZFrNlPS3po
	hAOLCnpDLCLe6tVyUSngjI3F3t23cHFw1zinf+MFFhVkOfzY6jnHS2N6O+382R0X0xOXaYXv346/+
	0zbM/KZRRKprvSKe1RG2t0Dpm1TGkrOWqa9mGNSjHvK+q3ViDaknkhRXpdHUpn/cVNc/t5ygIw9zG
	Tuq66ACET/SSJe1Sqm6liNIKZUDPqG2ePtww6fj1gDjKdFulcVakGwNikyIC1s1Ix/E97XRCHRjzo
	y15mhQEg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sYh8F-00000000Akj-3jsw;
	Tue, 30 Jul 2024 07:18:51 +0000
Date: Tue, 30 Jul 2024 08:18:51 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Michal Hocko <mhocko@suse.com>
Cc: viro@kernel.org, linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	bpf@vger.kernel.org, brauner@kernel.org, cgroups@vger.kernel.org,
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 01/39] memcg_write_event_control(): fix a
 user-triggerable oops
Message-ID: <20240730071851.GE5334@ZenIV>
References: <20240730050927.GC5334@ZenIV>
 <20240730051625.14349-1-viro@kernel.org>
 <ZqiSohxwLunBPnjT@tiehlicka>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqiSohxwLunBPnjT@tiehlicka>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Jul 30, 2024 at 09:13:38AM +0200, Michal Hocko wrote:
> On Tue 30-07-24 01:15:47, viro@kernel.org wrote:
> > From: Al Viro <viro@zeniv.linux.org.uk>
> > 
> > we are *not* guaranteed that anything past the terminating NUL
> > is mapped (let alone initialized with anything sane).
> > 
> > [the sucker got moved in mainline]
> > 
> 
> You could have preserved
> Fixes: 0dea116876ee ("cgroup: implement eventfd-based generic API for notifications")
> Cc: stable
> 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> and
> Acked-by: Michal Hocko <mhocko@suse.com>

Will do; FWIW, I think it would be better off going via the
cgroup tree - it's completely orthogonal to the rest of the
series, the only relation being "got caught during the same
audit"...

