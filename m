Return-Path: <kvm+bounces-23590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A6694B401
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 02:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0759A1F22FAA
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 00:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC6111854;
	Thu,  8 Aug 2024 00:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="b08Es367"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFA039B;
	Thu,  8 Aug 2024 00:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723076057; cv=none; b=AEz4iIEqqZQF6LsSa1SRVkSIRYQMugiIRkWjzWopSEuS6gdj9vgNqlHaWZ84GETRcj2msrfwOXI9PBw4BiGTaxue1WcuQ2Kc0mhI5Lzo3GEPUjR+Rj8pcxJR5AwzxYBcRtcdEtprW7LfOMOSfj4LUMAyF3raGUq4W/5Kd057V1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723076057; c=relaxed/simple;
	bh=rnk6NOm5/KnK6BxpfKd8TEgRBafhnCiGpVfQ3d/QHPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=duj4DYvWsulcw4C0oD8OxpZF78mGVPAqBlFi0fuirRYErXYLYab5td7M0ZjX1rG7wsQbzAHy10II60sOiLSpdzXpHpRCIjZAS5FaiCYfYbe2P9c8n+DnRUiMToKkKRLdTOBHtxg4QVgxn6kgfMXLxArugXZOeQOvIkhKzJ4a5xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=b08Es367; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1723076056; x=1754612056;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rnk6NOm5/KnK6BxpfKd8TEgRBafhnCiGpVfQ3d/QHPs=;
  b=b08Es367ayKGpfJBmbsQt752c9CsU1NGxj4dtSubTJ2XjniSWPn1d9na
   ulFkCn5p7vxuqhBIcvtEe8NrMDq+ipGjrDX+UlcagGbjJR+ov+xYydtdT
   dKnvbPQUiktSJD7yjtFkUekXYosc2axAJImqykomu4VjGw/Tt/KgbFeiu
   Q=;
X-IronPort-AV: E=Sophos;i="6.09,271,1716249600"; 
   d="scan'208";a="672677906"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 00:14:14 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:52573]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.48.252:2525] with esmtp (Farcaster)
 id 95d0d38e-fff9-4f42-8e2e-4808f7d9cca0; Thu, 8 Aug 2024 00:14:13 +0000 (UTC)
X-Farcaster-Flow-ID: 95d0d38e-fff9-4f42-8e2e-4808f7d9cca0
Received: from EX19D003UWC002.ant.amazon.com (10.13.138.169) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 8 Aug 2024 00:14:10 +0000
Received: from [192.168.198.222] (10.106.100.47) by
 EX19D003UWC002.ant.amazon.com (10.13.138.169) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 8 Aug 2024 00:14:09 +0000
Message-ID: <396fb134-f43e-4263-99a8-cfcef82bfd99@amazon.com>
Date: Wed, 7 Aug 2024 17:14:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/4] mm: guest_memfd: Add option to remove guest
 private memory from direct map
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
Content-Language: en-US
From: "Manwaring, Derek" <derekmn@amazon.com>
In-Reply-To: <c55fc93d-270b-4b11-9b38-b54f350ea6c9@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D003UWC002.ant.amazon.com (10.13.138.169)

On 2024-08-06 07:10-0700 David Hildenbrand wrote:
> > While guest_memfd is not available to be mapped by userspace, it is
> > still accessible through the kernel's direct map. This means that in
> > scenarios where guest-private memory is not hardware protected, it can
> > be speculatively read and its contents potentially leaked through
> > hardware side-channels. Removing guest-private memory from the direct
> > map, thus mitigates a large class of speculative execution issues
> > [1, Table 1].
>
> I think you have to point out here that the speculative execution issues
> are primarily only an issue when guest_memfd private memory is used
> without TDX and friends where the memory would be encrypted either way.
>
> Or am I wrong?

Actually, I'm not sure how much protection CoCo solutions offer in this
regard. I'd love to hear more from Intel and AMD on this, but it looks
like they are not targeting full coverage for these types of attacks
(beyond protecting guest mitigation settings from manipulation by the
host).  For example, see this selection from AMD's 2020 whitepaper [1]
on SEV-SNP:

"There are certain classes of attacks that are not in scope for any of
these three features. Architectural side channel attacks on CPU data
structures are not specifically prevented by any hardware means. As with
standard software security practices, code which is sensitive to such
side channel attacks (e.g., cryptographic libraries) should be written
in a way which helps prevent such attacks."

And:

"While SEV-SNP offers guests several options when it comes to protection
from speculative side channel attacks and SMT, it is not able to protect
against all possible side channel attacks. For example, traditional side
channel attacks on software such as PRIME+PROBE are not protected by
SEV-SNP."

Intel's docs also indicate guests need to protect themselves in some
cases saying, "TD software should be aware that potentially untrusted
software running outside a TD may be able to influence conditional
branch predictions of software running in a TD" [2] and "a TDX guest VM
is no different from a legacy guest VM in terms of protecting this
userspace <-> OS kernel boundary" [3]. But these focus on hardening
kernel & software within the guest.

What's not clear to me is what happens during transient execution when
the host kernel attempts to access a page in physical memory that
belongs to a guest. I assume if it only happens transiently, it will not
result in a machine check like it would if the instructions were
actually retired. As far as I can tell encryption happens between the
CPU & main memory, so cache contents will be plaintext. This seems to
leave open the possibility of the host kernel retrieving the plaintext
cache contents with a transient execution attack. I assume vendors have
controls in place to stop this, but Foreshadow/L1TF is a good example of
one place this fell apart for SGX [4].

All that said, we're also dependent on hardware not being subject to
L1TF-style issues for the currently proposed non-CoCo method to be
effective.  We're simply clearing the Present bit while the physmap PTE
still points to the guest physical page. This was found to be
exploitable across OS & VMM boundaries on Intel server parts before
Cascade Lake [5] (thanks to Claudio for highlighting this). So that's a
long way of saying TDX may offer similar protection, but not because of
encryption.

Derek

[1] https://www.amd.com/content/dam/amd/en/documents/epyc-business-docs/white-papers/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf#page=19
[2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/best-practices/trusted-domain-security-guidance-for-developers.html
[3] https://intel.github.io/ccc-linux-guest-hardening-docs/security-spec.html#transient-execution-attacks-and-their-mitigation
[4] https://foreshadowattack.eu/foreshadow.pdf
[5] https://foreshadowattack.eu/foreshadow-NG.pdf

