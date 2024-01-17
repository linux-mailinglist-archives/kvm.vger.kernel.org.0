Return-Path: <kvm+bounces-6396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4744B830949
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 16:12:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B1351C219F9
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 15:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1111D22321;
	Wed, 17 Jan 2024 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lI3/Z8+3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3EC22305
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705504332; cv=none; b=YzOj5kxS9Miqh47U0D3Q3VZNKTUYarwizXJCDwkiIN9QPQyS15R3J+sfion21YcKoHijNwDelsLy4OLUkceuKw8cKnddo557R88GZLbfypC1+eh3fNXr/MsZUFpi2qYByx5W3EQoBKd7IpGBOHMgdGiMm9Af07v9CEzzsMq7Jrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705504332; c=relaxed/simple;
	bh=75vbpDsoAcKuunxIpZQCSNEMzm0YJW7388b+nIzg5GU=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=VqMvpmVLivwENI8/bdtN2l87CRH2cP+4WEy1qaU6GXizuC9bFvWPQ2Lknazurmeq5jwtTZwV+DtdcB490qGC3cft7v3vjOnD7udPwfTxXmdAxSzp3uEqTK69zR5C7tkVBtMShe7LdEOwuSQ8YB3qSY4jOKr+a6WFLOs73nulUIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lI3/Z8+3; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e6f42b1482so167628967b3.3
        for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 07:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705504330; x=1706109130; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l0YJIsKmr+pmUu1PHG5HX0Tr0h5ouB2GP2FXSLWbYDU=;
        b=lI3/Z8+3c5DFNB5NO8wVnTworZUpIiZm0bw5IQCJqU1HzqoG28uqMT2HpEKuq/kbh4
         QkiaUpZOxNVN0N0US4c1L8GFLVJqXt1ngJb28y6SOOPRgLVkT/N+olEt0xG+HhVG+MWY
         rH9Ay4OAZmqtdbJVrczDT/EmVQ6V91+FjsosNiFQQ0YQLLzmjstwEZA/crX5nYAx9x9E
         oAjmHaddSHqTktfTdrvdNVV61nutNstUjM7eHRUyXze/RSBWFkBEzWcJJNgdaQKglOtf
         FKxy4CC0iMhBxZQjE6BuV+OBkX8870aGKSiGJ5rE/QhL1IBSrBCa9D9BQ1ohS5CPQOQq
         vddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705504330; x=1706109130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l0YJIsKmr+pmUu1PHG5HX0Tr0h5ouB2GP2FXSLWbYDU=;
        b=Wo1gncBtNMI+Ldua/X8wn8iyY2TjfaNYQFkA/7mS/ZqecfOlg2nf7q+AlaP7fiY71C
         GB1hMh1xZSoW4IQgwteXC3hSt0HwLCWVU88sRWdn0yNiAhx1hqr0a+LyHdGochYB/8x7
         c61rq3BT2AXnneHPa9jTvqJBs8DCfgkpTVGaTdFlPK3o3+to7gEO+hFZSccKbR6wqA0+
         bOeHWOe9MgXYH+1VrbEEGDDfBuybL5YW5i5VWY9QCCTgwKFtrI0ZBDmnmvMQs68iqD/T
         tL8AtGh5Iz34JytQ1ju9/YZ2nJD0ehqnLuZvJSSkvSHDUu9/QVTu5Dp4RL2yNIwPGkmU
         S3Qg==
X-Gm-Message-State: AOJu0YzlzGYIuKbmRP73Z/zt9LCGuXCTgd+9UEoutPEuYG1gd56anHKX
	fEgI2+OSlgtImvSCXZTeIAdkrKACqE4m8Dwz3A==
X-Google-Smtp-Source: AGHT+IHLINH20oLOsKxHQFk+Am7brJ1C7Bq8De1VlhInw3/wj2JwfOm0e94bSGMl7mHkpqiE5WeNET/LonQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:fd5:b0:5ff:416c:24c4 with SMTP id
 dg21-20020a05690c0fd500b005ff416c24c4mr1337698ywb.10.1705504329807; Wed, 17
 Jan 2024 07:12:09 -0800 (PST)
Date: Wed, 17 Jan 2024 07:12:08 -0800
In-Reply-To: <20240117064441.2633784-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240117064441.2633784-1-tao1.su@linux.intel.com>
Message-ID: <ZafuSNu3ThHY8rfG@google.com>
Subject: Re: [PATCH] KVM: selftests: Add a requirement for disabling numa balancing
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org, 
	yi1.lai@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 17, 2024, Tao Su wrote:
> In dirty_log_page_splitting_test, vm_get_stat(vm, "pages_4k") has
> probability of gradually reducing to 0 after vm exit. The reason is that
> the host triggers numa balancing and unmaps the related spte. So, the
> number of pages currently mapped in EPT (kvm->stat.pages) is not equal
> to the pages touched by the guest, which causes stats_populated.pages_4k
> and stats_repopulated.pages_4k in this test are not same, resulting in
> failure.

...

> dirty_log_page_splitting_test assumes that kvm->stat.pages and the pages
> touched by the guest are the same, but the assumption is no longer true
> if numa balancing is enabled. Add a requirement for disabling
> numa_balancing to avoid confusing due to test failure.
> 
> Actually, all page migration (including numa balancing) will trigger this
> issue, e.g. running script:
> 	./x86_64/dirty_log_page_splitting_test &
> 	PID=$!
> 	sleep 1
> 	migratepages $PID 0 1
> It is unusual to create above test environment intentionally, but numa
> balancing initiated by the kernel will most likely be triggered, at
> least in dirty_log_page_splitting_test.
> 
> Reported-by: Yi Lai <yi1.lai@intel.com>
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
>  .../kvm/x86_64/dirty_log_page_splitting_test.c        | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> index 634c6bfcd572..f2c796111d83 100644
> --- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
> @@ -212,10 +212,21 @@ static void help(char *name)
>  
>  int main(int argc, char *argv[])
>  {
> +	FILE *f;
>  	int opt;
> +	int ret, numa_balancing;
>  
>  	TEST_REQUIRE(get_kvm_param_bool("eager_page_split"));
>  	TEST_REQUIRE(get_kvm_param_bool("tdp_mmu"));
> +	f = fopen("/proc/sys/kernel/numa_balancing", "r");
> +	if (f) {
> +		ret = fscanf(f, "%d", &numa_balancing);
> +		TEST_ASSERT(ret == 1, "Error reading numa_balancing");
> +		TEST_ASSERT(!numa_balancing, "please run "
> +			    "'echo 0 > /proc/sys/kernel/numa_balancing'");

If we go this route, this should be a TEST_REQUIRE(), not a TEST_ASSERT().  The
test hasn't failed, rather it has detected an incompatible setup.

Something isn't right though.  The test defaults to HugeTLB, and the invocation
in the changelog doesn't override the backing source.  That suggests that NUMA
auto-balancing is zapping HugeTLB VMAs, which AFAIK shouldn't happen, e.g. this
code in task_numa_work() should cause such VMAs to be skipped:

		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
			continue;
		}

And the test already warns the user if they opt to use something other than
HugeTLB.

	if (!is_backing_src_hugetlb(backing_src)) {
		pr_info("This test will only work reliably with HugeTLB memory. "
			"It can work with THP, but that is best effort.\n");
	}

If the test is defaulting to something other than HugeTLB, then we should fix
that in the test.  If the kernel is doing NUMA balancing on HugeTLB VMAs, then
we should fix that in the kernel.

