Return-Path: <kvm+bounces-7276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D7483ECDD
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 12:22:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C86CE1C21C28
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 11:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E9C521103;
	Sat, 27 Jan 2024 11:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KKoxAmec"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8059210E3
	for <kvm@vger.kernel.org>; Sat, 27 Jan 2024 11:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706354520; cv=none; b=oHnA/w2vfX6kInwWOQjURjZ3qP0YZlkOQ2IvPx0u0iDiKBatpRXiKTupaFPE0+OeICFYmLhaPqbE2EeMKZP9bnQ9yYQ/gFIVkOfe3x3GztV7iaF7jl59US9egMdW7o7FRAwJ+6b0nqfSxNDYDyE/fWvES8Inst8ANVzlVjn+f+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706354520; c=relaxed/simple;
	bh=hkQI4KwQIxdBD4ZLOqynSRznn/g0/qB6e65on0S7xss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bp54aCimZhR8URYD+zE5zRQMah7RdKiNpTZWP83W9vSf4NbL9ALQIMbx/TvhwwOJNjryDMN3vEFO/almQFa+YQeNLRrLOYDcsmZ7mc/7Aol4gS4vE7whLc/63weSYLsu9JxtZBzP8Jz9uy7ygdT4TgNPRf5kwRr+WcunDmjaUOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KKoxAmec; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706354518; x=1737890518;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=hkQI4KwQIxdBD4ZLOqynSRznn/g0/qB6e65on0S7xss=;
  b=KKoxAmecCdEEG9nZHF4jVGXroOVeOpSydn1GsRXNLAQ50h8oUpvxb4Wj
   5B7PEZ+sW4nGQS80A1CvTCi4wVVRRAm3IZDDJ2xH0cqv9rN7d3Lvqba2c
   /t5anPFhDIohEnFGi7GZAn0C8SRRF4WLTEzAmU7g/BLM7LAABd601Liuk
   5AuXeXkNysUH+UAqNF21syTDqpMqvLDkpWcVyKj5zLJ4qQwqm4JAIQ4yK
   Sa0sizCeusT5nfHLOX4DDGuPraa/RM1imYYqPi8Bf6JJFa/NDHpL2A2iv
   ByTOSyYkYIvbv+N62Ohok97XAV974Pyw6CnWi8I6bCwbBLF24ljhFUNPT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="433829307"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="433829307"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2024 03:21:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930615861"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="930615861"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jan 2024 03:21:53 -0800
Date: Sat, 27 Jan 2024 19:34:57 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
	qemu-riscv@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org, qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Subject: Re: [PATCH v2 01/23] hw/acpi/cpu: Use CPUState typedef
Message-ID: <ZbTqYQFd+8vK+/sn@intel.com>
References: <20240126220407.95022-1-philmd@linaro.org>
 <20240126220407.95022-2-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240126220407.95022-2-philmd@linaro.org>

On Fri, Jan 26, 2024 at 11:03:43PM +0100, Philippe Mathieu-Daudé wrote:
> Date: Fri, 26 Jan 2024 23:03:43 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v2 01/23] hw/acpi/cpu: Use CPUState typedef
> X-Mailer: git-send-email 2.41.0
> 
> QEMU coding style recommend using structure typedefs:
> https://www.qemu.org/docs/master/devel/style.html#typedefs
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/hw/acpi/cpu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

> 
> diff --git a/include/hw/acpi/cpu.h b/include/hw/acpi/cpu.h
> index bc901660fb..209e1773f8 100644
> --- a/include/hw/acpi/cpu.h
> +++ b/include/hw/acpi/cpu.h
> @@ -19,7 +19,7 @@
>  #include "hw/hotplug.h"
>  
>  typedef struct AcpiCpuStatus {
> -    struct CPUState *cpu;
> +    CPUState *cpu;
>      uint64_t arch_id;
>      bool is_inserting;
>      bool is_removing;
> -- 
> 2.41.0
> 
> 

