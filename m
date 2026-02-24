Return-Path: <kvm+bounces-71623-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJqzHmvKnWmxSAQAu9opvQ
	(envelope-from <kvm+bounces-71623-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:57:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 328561896ED
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8775530C4EE3
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 15:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5900E3A6411;
	Tue, 24 Feb 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VUGl+uCz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619D23A63FE
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 15:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771948620; cv=none; b=shU0T7SjoIMqggIKe9Wl0IcCYUG1l9Eo5BJuRjSQYDJYk0dvrT8oBKY6DxKIjYhTYus4SeYMc3HzmKYte69gDtxWKOTb65PvQ+tyDAWoH6GzdXxa950d6iVw63p5Qgruy4qCM4j8K+4sGAId2RXttzK7uYPEpstH2tBjLPNuHXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771948620; c=relaxed/simple;
	bh=+Go39KXWHDr2yruK6unSW/Z139dwJgL63l/ih2f/p2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bGoSxh2Wz9rTgeOiAs/ZA2Vb6yfzknAE6Dt4wNYQHQ2d/1ivIe51KLJseAxWDkbJVQGuttn0NEQHIpni3itWpYieFnK9ZlSTWv46HCs4jbi17cH3u3md3/E7CrQCttgvSpRfhO3PXPY4F99a+Qu9tAulcQWgQKBpyBHAVC/9KQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VUGl+uCz; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a75ed2f89dso53658185ad.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 07:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771948619; x=1772553419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UUn1eg8rhg8NItYQxRzifuO9+3kK3puijcUJa/nIhq4=;
        b=VUGl+uCzHXh0ouMyplP4l1nUBE5aNtCijNpnOAQP2d0XEefftOy0C0ZiKGJolOOEyU
         hu9XhuCi7RXGPhtIosCliaQBQBDKQez+SEfRsYXDwdD+izIBqfmigF0An7pVSV2u3m6v
         5ybfXxHGEMpBGqE4BdA5UYwszYggMHVmFafNGKB4n8ifR2+t+9kWlYkHmqO444nWCTO5
         aeXRR9UVowBN2QWL5WMvPAeYQ3kaq8wTzku0cOWN1qs3lZcxMuzCiGGEzHmPrIi9n+V9
         1eqpPhEzl8sMega2gdhZGbAdyVZBZ2bNND0CNHOdCW+1mK65j+hG1ju2BgcwDyaQ2Iib
         3xmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771948619; x=1772553419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUn1eg8rhg8NItYQxRzifuO9+3kK3puijcUJa/nIhq4=;
        b=IC0XwG8uybObgRILmrueNqcpaAsUCZILEFGaw5yXGZro9FvHMlVsTv1jUt3AllLTyc
         B8AecotA9AKngirc2mM8YyDATZj0LSDQ0x9dOl2QIXKyls+KHOhajP2M2gUkNS5HlAFK
         qNzjxW9MAD3HIoAp2xLznTM6rOcNCumNqyfUjLBnOiexl71FOZyZqKQ6DgaNRoxDS9qC
         dkYRW8ZHNywh7CT3BuHxDIYPnS0vl8rEkUMWhJGmg6M047qMl4oqmldEeUA2JOB/eOdk
         DRK6rLdB9ByA2Qn5tetzcxOuykm1OW7KVvmewwHOKIqbbqKss53sXd/QSPtQRA3SqdwP
         HlTg==
X-Forwarded-Encrypted: i=1; AJvYcCWHxTotRx8s1ICpvwpBOY96cp9uQ1eevnAp6LzeOkZtcwv0Cgzo+ZB2RBobmNnlGdHQPnw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye0i53RqlgOkfCRUuQziuPW1CJCm1RYcUB5sT9B6wFJ86qhlnr
	cVRe4CCOCPqFIjt4tehalvkMQmisO4t+9uusYUpEK8DU3JT1OA3zbU338WD49ElYUPSxZ0WHzrr
	AA5N9hA==
X-Received: from pjbgl23.prod.google.com ([2002:a17:90b:1217:b0:352:c130:fba7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2442:b0:2aa:ea8e:f118
 with SMTP id d9443c01a7336-2ad74454f60mr122111415ad.3.1771948618621; Tue, 24
 Feb 2026 07:56:58 -0800 (PST)
Date: Tue, 24 Feb 2026 07:56:57 -0800
In-Reply-To: <4d17f847-0269-4a97-aa28-d3350faaf9c0@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212103841.171459-1-zhiquan_li@163.com> <4d17f847-0269-4a97-aa28-d3350faaf9c0@163.com>
Message-ID: <aZ3KDSYdDQgx_y9r@google.com>
Subject: Re: [PATCH v2 0/4] KVM: x86: selftests: Add Hygon CPUs support and
 fix failures
From: Sean Christopherson <seanjc@google.com>
To: Zhiquan Li <zhiquan_li@163.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71623-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[163.com];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 328561896ED
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Zhiquan Li wrote:
> 
> On 2/12/26 18:38, Zhiquan Li wrote:
> > This series to add support for Hygon CPUs and fix 11 KVM selftest failures
> > on Hygon architecture.
> > 
> > Patch 1 add CPU vendor detection for Hygon and add a global variable
> > "host_cpu_is_hygon" to identify if the test is running on a Hygon CPU.
> > It is the prerequisite for the following fixes.
> > 
> > Patch 2 add a flag to identify AMD compatible CPU and figure out the
> > compatible cases, so that Hygon CPUs can re-use them.
> > Following test failures on Hygon platform can be fixed by this patch:
> > - access_tracking_perf_test
> > - demand_paging_test
> > - dirty_log_perf_test
> > - dirty_log_test
> > - kvm_page_table_test
> > - memslot_modification_stress_test
> > - pre_fault_memory_test
> > - x86/dirty_log_page_splitting_test
> > - x86/fix_hypercall_test
> > 
> > Patch 3 fix x86/pmu_event_filter_test failure by allowing the tests for
> > Hygon CPUs.
> > 
> > Patch 4 fix x86/msrs_test failure while writing the MSR_TSC_AUX reserved
> > bits without RDPID support.
> > Sean has made a perfect solution for the issue and provided the patch.
> > It has been verified on Intel, AMD and Hygon platforms, no regression.
> > 
> 
> Kindly ping for any review on these.

They're in my queue, but I typically don't apply anything except urgent fixes
until after -rc2.

