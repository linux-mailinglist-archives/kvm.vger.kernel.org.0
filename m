Return-Path: <kvm+bounces-20940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1009927139
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DF511C22EAC
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 08:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C93121A3BA3;
	Thu,  4 Jul 2024 08:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XPdZAjC4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543BE10A35
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 08:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720080475; cv=none; b=mjyTGAmvbNwofOljYqChvKaTgw4G6pHOXhlbMVsoT/FhkAaZt8+kKY/ueMVpb6pqAbMZ1yiogmj8UaHI6LyBo17yA/p9ETAtm0zspuKIsR2fP9gTt9eoxQqlYAXOkLqKosfL4CY6rLTY3gCAmZLYyBXn1oi56hMYxs8PUF/5P5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720080475; c=relaxed/simple;
	bh=ryUuUqOZOQh9FGCy/R2igwMyWp2JY8+v4v1iOACpeko=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NWit7235bj5saguMigoK5OYCzm+xCMKY4+XUlEfqA2vErRUfZUuk0XMhyAF0yrwvBpdzkVE/14gLzl49Rtb4ILVTp9qR8bQZFXY4Q/PofJv/nze9Hvaie3sGVUl7hFOLzfRHEFjT6aIk2voAlr4wfkfr0MXhWE2NFs/Uzyys2T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XPdZAjC4; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720080474; x=1751616474;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=ryUuUqOZOQh9FGCy/R2igwMyWp2JY8+v4v1iOACpeko=;
  b=XPdZAjC4+5ezn8T1Wza0FpBC58UgvM/7+9zgUc6qcR3+GG/D0tbxiGKb
   ejKXjIoZNDNXZZdssEXbyJfU4nqlMLH4GsL2xMOX6CtmLSrJMsjlP+CMv
   ruZIUPESJRe0f6DP9rQIUXcDi8uwVjagWKnRMm9b1ZkQbO9ctpAHDSB4/
   kVtZaMqjWowEOuY3/+6MOvJ33OZx912tyiSzlNSih8KRZdk9pYunWeWVu
   fZ7L0vlnoaBA4xfBt78rmaqZijEmihWGqNA5XBTCoFRsaOG3fa5xX2kCJ
   n4q6Im6C6QNLMucdZTbzBo4WpGbESjKUj8ZIH9TmBf0EEsV8qAxNMRuPy
   Q==;
X-CSE-ConnectionGUID: uQiMXzP6S8Ku0JDmeqAbIA==
X-CSE-MsgGUID: m4mnpxGTRHKXtHvhBWeZTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="27961946"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="27961946"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 01:07:53 -0700
X-CSE-ConnectionGUID: GOGCVbaOTw+/yyaA19C75g==
X-CSE-MsgGUID: b+gOAhYbTl21BsyYTQJDvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="46939713"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.1]) ([10.124.225.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 01:07:52 -0700
Message-ID: <15c075c7-80aa-415e-a6e4-2c0ff3b0e1e4@linux.intel.com>
Date: Thu, 4 Jul 2024 16:07:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Using PEBS from qemu-kvm
To: Chloe Alverti <xloi.alverti@gmail.com>, kvm@vger.kernel.org
References: <CANpuKBNY0M+22K5T=UMz8iiqWwXy1jaWJNcOerrNK5Nhgqd1Hg@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CANpuKBNY0M+22K5T=UMz8iiqWwXy1jaWJNcOerrNK5Nhgqd1Hg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 6/30/2024 10:19 PM, Chloe Alverti wrote:
> Hello to all,
>
> I am using qemu to set-up a VM on a Sapphire Rapid server.
> I am running linux kernel 6.6.14 in both guest and host.
> I enable kvm for the guest and I pass the --cpu host flag to qemu.
>
> My understanding is that there is some PEBS virtualization support in
> place within kvm. However in the above set-up if I try:
>
> perf record -e instructions:p ls -- I get back "unchecked MSR access
> error: WRMSR to 0x3f1 (tried to write 0x0000000000000002)"
>
> if I try perf record -e instructions:ppp ls -- I get back that the PMU
> HW does not support sampling.
>
> Also I see in dmesg that in the guest, PEBS has fmt-0 (format)
> configured while in the host it is fmt-4.
>
> In general, I would like to use PEBS within the guest to take a trace
> of sampled instructions that cause LLC misses.
>
> At this point, it is not clear to me if this is even possible.
>
> Could you please let me know if I can use PEBS for my purpose at all,
> and if yes what configuration am I missing?
> Is there some other VMM that I should be using and not qemu?
>
> Thank you very much in advance!
> Best Regards,
> Chloe
>
> P.S.: PEBS sampling works fine in the host.

It looks you need the below qemu patch to enable PEBS related bits in
PERF_CAPABILITIES MSR for host model.

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index f2740d9ab7..ddfbbf3b4b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1189,9 +1189,9 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = MSR_FEATURE_WORD,
         .feat_names = {
             NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
-            NULL, "full-width-write", NULL, "topdown",
+            NULL, NULL, "pebs-trap", "pebs-arch-reg",
+            "pebs-fmt0", "pebs-fmt1", "pebs-fmt2", "pebs-fmt3",
+            NULL, "full-width-write", "pebs-baseline", "topdown",
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,



