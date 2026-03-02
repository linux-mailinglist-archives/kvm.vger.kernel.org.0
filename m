Return-Path: <kvm+bounces-72397-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id w6ppIRS4pWmDFQAAu9opvQ
	(envelope-from <kvm+bounces-72397-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:17:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8721DC908
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34AE63183FF6
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 15:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014AF41C30C;
	Mon,  2 Mar 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P1H1H/zY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5A541C0A3
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 15:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467061; cv=none; b=rzEwd10IHfYEL/Wef/n2nAdu7GUQoCEj4HjiTRswEKS1NkAStG3Q0HRuxuKjAmjIaYoaiWHH+/sJBOc9b2fhkqdBKFVSiSbVDFvqNd/NJ3Ggm3B0wmjRswtHSOv6mEzPdDGFMUNmvveo998WEdywNF8IAPBlkqSaye+TP7BOOWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467061; c=relaxed/simple;
	bh=iYsd3Elf0ik4GJpr4eGq44qKeDc6FOSqBZtqVOSshJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hGNOOtCGg9k+xxdJ8LKAtAl9DbEAHQdcWYmPefbN+mLHsD99+e+Fk5Zch4yl+rqH5UyF0i2JgEUGEKdX2JKoi1xvHP8nyj4tMm8xmJtsuUn5zwKkhsr12Ob6B5/agZjy+zI/VMWncPf8t1cCIZcoCco3bbp/neEsVSHf6GrRtc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P1H1H/zY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354490889b6so17279790a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 07:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772467059; x=1773071859; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ta44dSkyUYoWSHu8DjFcJDUvqHtZprEgi2FuVoYoKhw=;
        b=P1H1H/zYZoibKL1lGEcVpuz8c6BDWHwJEYFNS4Jua76NRE5innUXZ8hsEA2CcexsiY
         tClaS3cIVl82DPhOnWJElue/vEuShWsawQNJPPHKMyjjYpcPGXof4w151ZCpr+RBY4K6
         4CqQQdDWMYZq8GgrWm7qZcgye3SZ2A1fkDZsPTwu/tmKvgtFkWri3Hw1xoXjO29eBwpt
         Hbtq7XkQHrX0ESOe5DKUZjmqwp8UqJr5JkkB2+BAl7TjfsroiaF3myWgDDN/5eOpJDvV
         DwMjvTPESSOOTuimsTvxNGBl/f7p2gKop400EIyK0PQAX/tJhLIUxm+zu9fCVfCn5wpy
         ogCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772467059; x=1773071859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ta44dSkyUYoWSHu8DjFcJDUvqHtZprEgi2FuVoYoKhw=;
        b=XmmqHcTttXf6dG4vQxdZE8f8mN8oVe7o5lJRaQRpUkRwCm3lxeOburJmxy3D4HPEGY
         lfAMt/+cJDKf1LTIH6Udapsu8XHlYTkjDnqsOSEWU6829D3VmU3NTr3GR9S1xeGRTFMq
         4C8qf7MGFvgIkbcP9q1t8nrc/vOi93FfmnBeBykQoP2Muy20PJsUTVxtAVGVo/bKiWyS
         zv3pSO8UYxSaRVaxFrQ+qDmVVOLIVd1Ab85GlRdL9/TKlx8q99ygYNLTArxAzq+gtSFo
         Nn8qverbsTq56JE3/gqQlfCGOldhIHEBxF44SWFPTn3pSS9zn41PY9yXkNvaUjohA3Wc
         9+LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW6eORgpmskoEqUe6pf08p/shGGJWG01ZoXuP4DmG/JQ1MNMFth00Poz8oZWpkpXy3ji4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5073AQbDvFadhtp/IdSl10CNkuZP35reXp1bSG9haB3IdnAAd
	+1p0nUi5vw5160Lx8PeKyXHqM0PWGfdnbpSbz1LzRUX47sAfzAA1IJiS80kJlNcBdxH/O6MTCDI
	4YP4sKw==
X-Received: from pjpy12.prod.google.com ([2002:a17:90a:a40c:b0:359:8e40:28c5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c0b:b0:359:8cad:bcdc
 with SMTP id 98e67ed59e1d1-3598cadbd66mr3700334a91.10.1772467059132; Mon, 02
 Mar 2026 07:57:39 -0800 (PST)
Date: Mon, 2 Mar 2026 07:57:32 -0800
In-Reply-To: <20260302090739.464786-1-kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260302090739.464786-1-kai.huang@intel.com>
Message-ID: <aaWzbCEWbStphJPh@google.com>
Subject: Re: [PATCH] KVM: selftests: Increase 'maxnode' for guest_memfd tests
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, shivankg@amd.com, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: DC8721DC908
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
	TAGGED_FROM(0.00)[bounces-72397-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:email]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026, Kai Huang wrote:
> Increase 'maxnode' when using 'get_mempolicy' syscall in guest_memfd
> mmap and NUMA policy tests to fix a failure on one Intel GNR platform.
> 
> On a CXL-capable platform, the memory affinity of CXL memory regions may
> not be covered by the SRAT.  Since each CXL memory region is enumerated
> via a CFMWS table, at early boot the kernel parses all CFMWS tables to
> detect all CXL memory regions and assigns a 'faked' NUMA node for each
> of them, starting from the highest NUMA node ID enumerated via the SRAT.
> 
> This increases the 'nr_node_ids'.  E.g., on the aforementioned Intel GNR
> platform which has 4 NUMA nodes and 18 CFMWS tables, it increases to 22.
> 
> This results in the 'get_mempolicy' syscall failure on that platform,
> because currently 'maxnode' is hard-coded to 8 but the 'get_mempolicy'
> syscall requires the 'maxnode' to be not smaller than the 'nr_node_ids'.
> 
> Increase the 'maxnode' to the number of bits of 'unsigned long' (i.e.,
> 64 on 64-bit systems) to fix this.  Note the 'nodemask' is 'unsigned
> long', so it makes sense to set 'maxnode' to bits of 'unsigned long'
> anyway.
> 
> This may not cover all systems.  Perhaps a better way is to always set
> the 'nodemask' and 'maxnode' based on the actual maximum NUMA node ID on
> the system, but for now just do the simple way.
> 

Can you add:

Reported-by: Yi Lai <yi1.lai@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221014
Closes: https://lore.kernel.org/all/bug-221014-28872@https.bugzilla.kernel.org%2F

> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  tools/testing/selftests/kvm/guest_memfd_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 618c937f3c90..b434612bc3ec 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -80,7 +80,7 @@ static void test_mbind(int fd, size_t total_size)
>  {
>  	const unsigned long nodemask_0 = 1; /* nid: 0 */
>  	unsigned long nodemask = 0;
> -	unsigned long maxnode = 8;
> +	unsigned long maxnode = sizeof(nodemask) * 8;

Pretty sure this can be:

	unsigned long maxnode = BITS_PER_TYPE(nodemask)

>  	int policy;
>  	char *mem;
>  	int ret;
> 
> base-commit: a91cc48246605af9aeef1edd32232976d74d9502
> -- 
> 2.53.0
> 

