Return-Path: <kvm+bounces-24329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A73953A99
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 21:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A996B25646
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A1013A884;
	Thu, 15 Aug 2024 19:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="EhpxBra6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C91770FB;
	Thu, 15 Aug 2024 19:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723748891; cv=none; b=WVmusEdelpGGQFZS+lcWF63l9B4P4KnNG/IZ1I/sZM2ajdiCCx+PxJRejtghMMAQfi1nMfFQlkkUGOF/0ra2kXsC7DbJnwd3dRVV91DAto6Sl+8Ti/afsC6qFC9hWT6Wn5dCaVo9UUqHOc3E9L6ADa8oBnJL6xE38crMBzTyvcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723748891; c=relaxed/simple;
	bh=tEGEgIcRKXDTkmdRvTVw2CvUW7+3ffACZCr/9mvjZqo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=MfLmPVBKtiGH6ZTtx0b04HN+IlFlRv+jGhX1lQamDc7Bq3mZYvdA659fh0gvLQpqwBZ8VCEsUI7lwTzg6DnwXLIyT8+oqomdxCgqU7c3th9T9Q86tHDUnfKX6+cdRbDdgKwwDscLQu4LqusfGsc9lQjU0y/ONY9vFPrXVRbSf90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=EhpxBra6; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1723748890; x=1755284890;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=tEGEgIcRKXDTkmdRvTVw2CvUW7+3ffACZCr/9mvjZqo=;
  b=EhpxBra6vw31bbYRBZ2ZgRjliKc0sS7PH0jjNW7n3BoOuEo9VjA28r0z
   N7xeEfoPOiCk4dndAit/tUD7s4zc1Hm6JseK2IFT9bf2bOzVB4RKivhqs
   0/iS2Nn4XhdPGKNiFSgohT3At1nfrXKPetHl1BHQ9PLlcm/6nLtm78Z9s
   Q=;
X-IronPort-AV: E=Sophos;i="6.10,149,1719878400"; 
   d="scan'208";a="115649481"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 19:08:09 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:21068]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.187:2525] with esmtp (Farcaster)
 id 7c28823e-4999-43b1-ba3b-b0e1f64f96e0; Thu, 15 Aug 2024 19:08:09 +0000 (UTC)
X-Farcaster-Flow-ID: 7c28823e-4999-43b1-ba3b-b0e1f64f96e0
Received: from EX19D003UWC002.ant.amazon.com (10.13.138.169) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 15 Aug 2024 19:08:07 +0000
Received: from [192.168.11.28] (10.106.101.5) by EX19D003UWC002.ant.amazon.com
 (10.13.138.169) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Thu, 15 Aug 2024
 19:08:06 +0000
Message-ID: <3ea89d7f-fc29-4c80-a123-94673e526ca5@amazon.com>
Date: Thu, 15 Aug 2024 12:08:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/4] mm: guest_memfd: Add option to remove guest
 private memory from direct map
From: "Manwaring, Derek" <derekmn@amazon.com>
To: David Hildenbrand <david@redhat.com>, Elliot Berman
	<quic_eberman@quicinc.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	"Fuad Tabba" <tabba@google.com>, Patrick Roy <roypat@amazon.co.uk>,
	<qperret@google.com>, Ackerley Tng <ackerleytng@google.com>
CC: <linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <kvm@vger.kernel.org>,
	Alexander Graf <graf@amazon.de>, Moritz Lipp <mlipp@amazon.at>, "Claudio
 Canella" <canellac@amazon.at>
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-3-e5a29a4ff5d7@quicinc.com>
 <c55fc93d-270b-4b11-9b38-b54f350ea6c9@redhat.com>
 <396fb134-f43e-4263-99a8-cfcef82bfd99@amazon.com>
Content-Language: en-US
In-Reply-To: <396fb134-f43e-4263-99a8-cfcef82bfd99@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D039UWB001.ant.amazon.com (10.13.138.119) To
 EX19D003UWC002.ant.amazon.com (10.13.138.169)

On 2024-08-07 17:16-0700 Derek Manwaring wrote:
> All that said, we're also dependent on hardware not being subject to
> L1TF-style issues for the currently proposed non-CoCo method to be
> effective. We're simply clearing the Present bit while the physmap PTE
> still points to the guest physical page.

I was wrong here. The set_direct_map_invalid_noflush implementation
moves through __change_page_attr and pfn_pte, eventually arriving at
flip_protnone_guard where the PFN is inverted & thus no longer valid for
pages marked not present. So we do benefit from that prior work's extra
protection against L1TF.

Thank you for finding this, Patrick.

Derek

