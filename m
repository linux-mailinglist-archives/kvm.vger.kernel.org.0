Return-Path: <kvm+bounces-14673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C36FD8A56FD
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 18:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6AB81C21E44
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 16:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471E380026;
	Mon, 15 Apr 2024 16:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BApmuDAt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9A979DD5;
	Mon, 15 Apr 2024 16:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713197034; cv=none; b=IFoVLQpFpHZ4WYFea8INjLrnp/eI++Cw2NYq+lpRSd/CyvvoswoVkZLxj0mZlO9mZJhfANQEjg2rrHbz9DJNHCM85RPwxoLZNM0Zn9w3oOSG1TxR8ijczCXUuq37qiFjTVT7Q29JSJVMnNNpvLuVt1S2bV9YXp0C0AuUC3MoxOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713197034; c=relaxed/simple;
	bh=eRNqsnu2gggpUPFWgp9U5SWpDCENJohEVqbf6eu8y30=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=oBvEs7Kqtnl71qT7CdA7IWp3PtOuECgKMj4v9msHQsyPoGdsT0ztpb31ff3xoU0nLdhNeRxFPfkGwYGMJAIbh63mJKiE4mdhzk0cWgZOBXlska0x/OOJinzioqCTPBrQANd5J+u5EsRRJP2MRfrb9coxnNVga9t0oKocjNNTZiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BApmuDAt; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713197034; x=1744733034;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=eRNqsnu2gggpUPFWgp9U5SWpDCENJohEVqbf6eu8y30=;
  b=BApmuDAtNAZ92w2IHlP1JVthdPcAWTHRuTV97fXabuO+GiSiq+o8lyuS
   z/nQpMQLk8ffHqc3VWBvFNQco8iulXe+vJ4Dzqeu1/06ljoqkBFdOMrCH
   njLjZv/GQrTfsRi4qRQIIxeSZIbY6ZCzQNuQMw1WxzDH12JroOrk1hZDu
   Q9IlY2QNUoar9hmrbzh5yyVFPRh2+s6Yq8Fl3q6VD2yOgEsjjx7SRXIJP
   nkP4YsL98AmaLg3MSQSjBigpVHfX/GaoyrEAfASeqqUc338SkR3Ihg8b7
   vPKKpePQSgAPWJZmbpqyQtvo6rKBwA5E60WdgS4D7e7LUEoWnr37t6u4O
   A==;
X-CSE-ConnectionGUID: OO3W3y6OT82G3tK6N+7qbg==
X-CSE-MsgGUID: 9rHW795JR26f0GnLN3l8HA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8703769"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="8703769"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 09:03:14 -0700
X-CSE-ConnectionGUID: cV6mMS5KT5+Khu71lQelUQ==
X-CSE-MsgGUID: pEs01NjfSe+wVT96RpHFcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="26624362"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 09:03:09 -0700
Received: from [10.213.164.211] (kliang2-mobl1.ccr.corp.intel.com [10.213.164.211])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 07FDE206D892;
	Mon, 15 Apr 2024 09:03:06 -0700 (PDT)
Message-ID: <ab2953b7-18fd-4b4c-a83b-ab243e2a21e1@linux.intel.com>
Date: Mon, 15 Apr 2024 12:03:05 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
From: "Liang, Kan" <kan.liang@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, mizhang@google.com, kan.liang@intel.com,
 zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, jmattson@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
 <ZhgmrczGpccfU-cI@google.com>
 <23af8648-ca9f-41d2-8782-f2ffc3c11e9e@linux.intel.com>
 <ZhmIrQQVgblrhCZs@google.com>
 <2342a4e2-2834-48e2-8403-f0050481e59e@linux.intel.com>
Content-Language: en-US
In-Reply-To: <2342a4e2-2834-48e2-8403-f0050481e59e@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-04-12 4:56 p.m., Liang, Kan wrote:
>> What if perf had a global knob to enable/disable mediate PMU support?  Then when
>> KVM is loaded with enable_mediated_true, call into perf to (a) check that there
>> are no existing !exclude_guest events (this part could be optional), and (b) set
>> the global knob to reject all new !exclude_guest events (for the core PMU?).
>>
>> Hmm, or probably better, do it at VM creation.  That has the advantage of playing
>> nice with CONFIG_KVM=y (perf could reject the enabling without completely breaking
>> KVM), and not causing problems if KVM is auto-probed but the user doesn't actually
>> want to run VMs.
> I think it should be doable, and may simplify the perf implementation.
> (The check in the schedule stage should not be necessary anymore.)
> 
> With this, something like NMI watchdog should fail the VM creation. The
> user should either disable the NMI watchdog or use a replacement.
> 
> Thanks,
> Kan
>> E.g. (very roughly)
>>
>> int x86_perf_get_mediated_pmu(void)
>> {
>> 	if (refcount_inc_not_zero(...))
>> 		return 0;
>>
>> 	if (<system wide events>)
>> 		return -EBUSY;
>>
>> 	<slow path with locking>
>> }
>>
>> void x86_perf_put_mediated_pmu(void)
>> {
>> 	if (!refcount_dec_and_test(...))
>> 		return;
>>
>> 	<slow path with locking>
>> }


I think the locking should include the refcount check and system wide
event check as well.
It should be possible that two VMs are created very close.
The second creation may mistakenly return 0 if there is no lock.

I plan to do something as below (not test yet).

+/*
+ * Currently invoked at VM creation to
+ * - Check whether there are existing !exclude_guest system wide events
+ *   of PMU with PERF_PMU_CAP_MEDIATED_VPMU
+ * - Set nr_mediated_pmu to prevent !exclude_guest event creation on
+ *   PMUs with PERF_PMU_CAP_MEDIATED_VPMU
+ *
+ * No impact for the PMU without PERF_PMU_CAP_MEDIATED_VPMU. The perf
+ * still owns all the PMU resources.
+ */
+int x86_perf_get_mediated_pmu(void)
+{
+	int ret = 0;
+	mutex_lock(&perf_mediated_pmu_mutex);
+	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
+		goto end;
+
+	if (atomic_read(&nr_include_guest_events)) {
+		ret = -EBUSY;
+		goto end;
+	}
+	refcount_inc(&nr_mediated_pmu_vms);
+end:
+	mutex_unlock(&perf_mediated_pmu_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(x86_perf_get_mediated_pmu);
+
+void x86_perf_put_mediated_pmu(void)
+{
+	mutex_lock(&perf_mediated_pmu_mutex);
+	refcount_dec(&nr_mediated_pmu_vms);
+	mutex_unlock(&perf_mediated_pmu_mutex);
+}
+EXPORT_SYMBOL_GPL(x86_perf_put_mediated_pmu);


Thanks,
Kan

