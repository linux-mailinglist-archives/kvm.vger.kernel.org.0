Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783FA5E63A5
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 15:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiIVNeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 09:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIVNeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 09:34:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6792DD574C;
        Thu, 22 Sep 2022 06:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663853662; x=1695389662;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=PNsNTTbrFpDpDEo5G+4qKyWmmpYXK5RcD4hTWFNJfA0=;
  b=bgAvaZ6+hWD3X+UkfSIoTz/Fv9gRkR5oGs5xcwhXXP0P51R5sZdiNSeq
   ajiHFDHoStaEmH+gFneRUzpvuUyQqqJegKgMlg+czczh2Q09WwwcWYLYg
   Lv7PUP2Mi4/6YjBbRTpQnQN5HhEA9CrMK/AOZvgjlrPcnUCEq4BAurNqi
   FGNHlsLE0ZtHJzJRYcNt4eabHWzwVpu8g3BCU+i5JdorjCDgvGQ8/vwuT
   m1zxGDR2jPZ67/WZfU7XpK8Ah+ep/O0pwOoJOVn6SrYFiX7+ccB7DlDI2
   yvEMG19D4M13woqyr2YkM6wHfj3N2BkkUES//Hhovg+C8lb/4xvBSO1Sx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="301706451"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301706451"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 06:34:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="723664097"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 22 Sep 2022 06:34:21 -0700
Received: from [10.252.210.171] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 287B0580C36;
        Thu, 22 Sep 2022 06:34:19 -0700 (PDT)
Message-ID: <27cb9747-8911-b3cc-25d9-9438521db832@linux.intel.com>
Date:   Thu, 22 Sep 2022 09:34:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Dongli Zhang <dongli.zhang@oracle.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, joe.jin@oracle.com,
        linux-perf-users@vger.kernel.org, kvm list <kvm@vger.kernel.org>
References: <20220922071017.17398-1-dongli.zhang@oracle.com>
 <ad2572d0-06b5-7250-31f2-a5efa1048cc0@gmail.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [PATCH RFC 1/1] perf stat: do not fatal if the leader is errored
In-Reply-To: <ad2572d0-06b5-7250-31f2-a5efa1048cc0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-22 4:07 a.m., Like Xu wrote:
> On 22/9/2022 3:10 pm, Dongli Zhang wrote:
>> There are three options to fix the issue.
>>
>> 1. Do not expose /sys/bus/event_source/devices/cpu/events/slots to
>> userspace so that pmu_have_event(pmu->name, "slots") returns false.
> 
> IMO, the guest PMU driver should be fixed
> since it misrepresents emulated hardware capabilities in terms of slots.

Yes, we need to fix the kernel to hide the slots event if it's not
available.

The patch as below should fix it. (Not tested yet)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index b20e646c8205..27ee43faba32 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5565,6 +5565,19 @@ static struct attribute *intel_pmu_attrs[] = {
 	NULL,
 };

+static umode_t
+td_is_visible(struct kobject *kobj, struct attribute *attr, int i)
+{
+	/*
+	 * Hide the perf metrics topdown events
+	 * if the slots is not in CPUID.
+	 */
+	if (x86_pmu.num_topdown_events)
+		return (x86_pmu.intel_ctrl & INTEL_PMC_MSK_FIXED_SLOTS) ? attr->mode : 0;
+
+	return attr->mode;
+}
+
 static umode_t
 tsx_is_visible(struct kobject *kobj, struct attribute *attr, int i)
 {
@@ -5600,6 +5613,7 @@ default_is_visible(struct kobject *kobj, struct
attribute *attr, int i)

 static struct attribute_group group_events_td  = {
 	.name = "events",
+	.is_visible = td_is_visible,
 };

 static struct attribute_group group_events_mem = {
@@ -5758,6 +5772,23 @@ static inline int
hybrid_find_supported_cpu(struct x86_hybrid_pmu *pmu)
 	return (cpu >= nr_cpu_ids) ? -1 : cpu;
 }

+static umode_t hybrid_td_is_visible(struct kobject *kobj,
+					struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct x86_hybrid_pmu *pmu =
+		 container_of(dev_get_drvdata(dev), struct x86_hybrid_pmu, pmu);
+
+	if (!is_attr_for_this_pmu(kobj, attr))
+		return 0;
+
+	/* Only check the big core which supports perf metrics */
+	if (pmu->cpu_type == hybrid_big)
+		return (pmu->intel_ctrl & INTEL_PMC_MSK_FIXED_SLOTS) ? attr->mode : 0;
+
+	return attr->mode;
+}
+
 static umode_t hybrid_tsx_is_visible(struct kobject *kobj,
 				     struct attribute *attr, int i)
 {
@@ -5784,7 +5815,7 @@ static umode_t hybrid_format_is_visible(struct
kobject *kobj,

 static struct attribute_group hybrid_group_events_td  = {
 	.name		= "events",
-	.is_visible	= hybrid_events_is_visible,
+	.is_visible	= hybrid_td_is_visible,
 };

 static struct attribute_group hybrid_group_events_mem = {


Thanks,
Kan
