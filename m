Return-Path: <kvm+bounces-28870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 147E499E3C9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB2EC2816C6
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5262D1E378C;
	Tue, 15 Oct 2024 10:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="hpzbXP+g"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0812915A85E
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 10:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728987884; cv=none; b=b60YfuM45fk0eKix7URBENUa5hmO6TIGhh6JQLvDPCXtiiToxdDCUBPbC4TAGs0OpArbM08scSoTC3ZpTgS/u2n6oLYp7QL9QMm3/RBKXsbccchD+Bgt+5mp9nk9fp12qwatlpVleMMi3DeHws3T4wzEAUH2nmJOJDZk/VFCcWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728987884; c=relaxed/simple;
	bh=Hu3EIvo1IDc2GQm39omPxpxcmIVR+pxmF/6cRBKM1Do=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L+Q+tMXWiLa3cmBmWM+C++0X/P1sVVFCEc1aUvJnMje0CJRu7IfEvvSacPMnRAoNOtn0fUPnMuGmzPwoEeYMREUSnFsQkrSwRRM34QS0kr1J+I1uvLNwZRTpX27RcPGGokczy8ztakIqDDcl/TbKakUpdK5EhNc8sK1i/MIpthI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=hpzbXP+g; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1728987883; x=1760523883;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=GxYqLpqJb8K7cq4WXoA9RdzwHI3Quk7+YibJjMM5VD4=;
  b=hpzbXP+gsqERC/EBuP2/ALu96qzvEX1aYbg/ObuJQs795HR8GJg4pUVr
   vcmZqjXcV/Eagd6faLpRKto0I+3AdBwMZO4ePEeRLUhqH/tpGI7YCC34t
   vCBfq/y1VqYlWqAXjwj3iv2gJWW+HtWaxZP2GkJEKQnjEJy/zI/Www4Tu
   w=;
X-IronPort-AV: E=Sophos;i="6.11,204,1725321600"; 
   d="scan'208";a="343194556"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 10:24:41 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.29.78:27665]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.3.23:2525] with esmtp (Farcaster)
 id 2509b8a1-c2ad-45fe-a17b-167d65c1b619; Tue, 15 Oct 2024 10:24:40 +0000 (UTC)
X-Farcaster-Flow-ID: 2509b8a1-c2ad-45fe-a17b-167d65c1b619
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 15 Oct 2024 10:24:40 +0000
Received: from email-imr-corp-prod-iad-1box-1a-9bbde7a3.us-east-1.amazon.com
 (10.43.8.6) by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Tue, 15 Oct 2024 10:24:40 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-iad-1box-1a-9bbde7a3.us-east-1.amazon.com (Postfix) with ESMTPS id B45F4405C4;
	Tue, 15 Oct 2024 10:24:39 +0000 (UTC)
Message-ID: <6479cb2b-8c73-4ca9-b691-a5665accae79@amazon.co.uk>
Date: Tue, 15 Oct 2024 11:24:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
To: David Hildenbrand <david@redhat.com>, <linux-coco@lists.linux.dev>, KVM
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
From: Patrick Roy <roypat@amazon.co.uk>
Content-Language: en-US
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On Thu, 2024-10-10 at 14:39 +0100, David Hildenbrand wrote:
> Ahoihoi,
> 
> while talking to a bunch of folks at LPC about guest_memfd, it was raised that there isn't really a place for people to discuss the development of guest_memfd on a regular basis.
> 
> There is a KVM upstream call, but guest_memfd is on its way of not being guest_memfd specific ("library") and there is the bi-weekly MM alignment call, but we're not going to hijack that meeting completely + a lot of guest_memfd stuff doesn't need all the MM experts ;)
> 
> So my proposal would be to have a bi-weekly meeting, to discuss ongoing development of guest_memfd, in particular:
> 
> (1) Organize development: (do we need 3 different implementation
>     of mmap() support ? ;) )
> (2) Discuss current progress and challenges
> (3) Cover future ideas and directions
> (4) Whatever else makes sense
> 
> Topic-wise it's relatively clear: guest_memfd extensions were one of the hot topics at LPC ;)
> 
> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7), starting Thursday next week (2024-10-17).
> 
> We would be using Google Meet.
> 
> 
> Thoughts?
>

Sounds like a great idea to me, I'd also like to join :)

Best, 
Patrick

