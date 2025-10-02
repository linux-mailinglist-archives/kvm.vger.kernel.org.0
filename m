Return-Path: <kvm+bounces-59433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46460BB46D0
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 18:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F37CC1C4F78
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 16:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C7C156C6A;
	Thu,  2 Oct 2025 16:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F5WUH+dp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EED27453
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759420816; cv=none; b=u8dYekeYg0tBimgqfcx9cuO+srT2jtiI63NWigb2mSpsesOohWstNv8HGO4frTfGnaMRJptSXHQYjSOS1ovjfguI9lKFcOjbSIh0opEwUqiVuBI+u+wRWWiBVEOKIOjyKCHo1MX6Ha214I1PVlq1ESDdbsVsBQP0mOcEop6wLuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759420816; c=relaxed/simple;
	bh=Va9hhOqQSlAtHL974PlzbQiumNuVt7AeCwV28zkvhrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AsjRc+mf+EAVAW+RTDeZfv5tLz0Ono6UJ0LCViTTb4zPxz9+STpXPXMjFVlvVop1GAEZJZI9wd97LNvQFKUl2Cki5rRxoBWfuEizVR6F8WACSGmCVLF1hBGyICJ4+1CKwe5DVXIXciwYZKO8UtgaWTjM+fqHwjNT+RJslNojehc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F5WUH+dp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 592E9t9V018653;
	Thu, 2 Oct 2025 15:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=49Nv2Y
	YeoMMwXHOaEyzR9holLnVA2RQqZsSjdwPmojA=; b=F5WUH+dp3wMvfdVGJy6phY
	GXnRCkZT2hJvEvtMO+VsQsQKyE3qHt0noslhao6YsQKvoGU0ZUL8uwgTYxvaCBjH
	75hf+VH5dgWkL5ah6D1/xmeslBkqRnFjXckN7aqkAKe+u6WHZ/nwiQEI3wFmC9Qa
	G8kkn2l8yfQ0C84I6utfuqm54Jy8iZgBeRZreDQcLj/iNyAhsNFi6qND1e8HSMEq
	9ejUSYd0NJGGtJd9/0+29dVpU3fxdytrwRks4DOOA95eT2l3l+Yt3P9pJUkTRrLa
	qEjO3HDPkjP6eAvDnL7prvQjPFm0IVFqot9/SJSmTs3iNAjzUAEvj6WB+CD1ynVg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e5br5kvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 15:59:35 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 592FxYx0006339;
	Thu, 2 Oct 2025 15:59:34 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e5br5kvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 15:59:34 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 592DGICt007314;
	Thu, 2 Oct 2025 15:59:34 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49eurk6mn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 15:59:34 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 592FxWqA25494112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Oct 2025 15:59:32 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B72D258059;
	Thu,  2 Oct 2025 15:59:32 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4F3458060;
	Thu,  2 Oct 2025 15:59:24 +0000 (GMT)
Received: from [9.39.17.63] (unknown [9.39.17.63])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Oct 2025 15:59:24 +0000 (GMT)
Message-ID: <a8be844e-5f9d-478a-a96e-b76bfed9c764@linux.ibm.com>
Date: Thu, 2 Oct 2025 21:29:22 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/18] hw: Remove unnecessary 'system/ram_addr.h'
 header
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
        Jagannathan Raman <jag.raman@oracle.com>, qemu-ppc@nongnu.org,
        Ilya Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Jason Herne <jjherne@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        kvm@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>, Eric Farman <farman@linux.ibm.com>,
        qemu-arm@nongnu.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20251001175448.18933-1-philmd@linaro.org>
 <20251001175448.18933-7-philmd@linaro.org>
Content-Language: en-US
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20251001175448.18933-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDIxNCBTYWx0ZWRfX9j1FOVrb4509
 qfCYPRax2rCWhZqAHP9VmlF9h7/d/TxBDklocwd1bXyNFUe8qi97Lj95o0360IM6apX5slj0Wea
 14srfw+zQbF767i+j8K/8m72/B3si/ie4+R/f6rWfJiUB3s/D2GRPu3FWPlPzc+NO+cvvPU3/LP
 m+xzIoGWBV8ablbBgXUWFVon0LUF19VYrSxKwQnXj/m+howO277g77HPTdOJ1TnVdZ7Sz9wHoVf
 Bdaw539xusyIHiOco6OFec2gd8iA9mi6PAKT0hb63Sq6YiXCzYf90k9vegJZesQfAxgeYlQuVTM
 bv1Exjfhn+4Jjh2i4FvLdAh3lV+XDuRsvdPP0bllIE4bzC6KpXO0svv2pGr6DuLeMO+c2iNQWbi
 a0apf+EwTkjhotwwergFKfwPLKoN3Q==
X-Proofpoint-GUID: _sTzRmx2JvTfyNX5c7eTg3ZhC81hz2hy
X-Authority-Analysis: v=2.4 cv=LLZrgZW9 c=1 sm=1 tr=0 ts=68dea167 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=f7IdgyKtn90A:10 a=p0WdMEafAAAA:8
 a=KKAkSRfTAAAA:8 a=7QiekktFJ9-DGVFJoSUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=poXaRoVlC6wW9_mwW8W4:22
 a=oH34dK2VZjykjzsv8OSz:22 a=p-dnK0njbqwfn1k4-x12:22 a=MURpYVOlrLSSKvKaDb7l:22
X-Proofpoint-ORIG-GUID: WqkSPwF_agVqCWD6jmSEn5sU8-klpXmM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_06,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 clxscore=1011 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509260214



On 10/1/25 23:24, Philippe Mathieu-Daudé wrote:
> None of these files require definition exposed by "system/ram_addr.h",
> remove its inclusion.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   hw/ppc/spapr.c                    | 1 -
>   hw/ppc/spapr_caps.c               | 1 -
>   hw/ppc/spapr_pci.c                | 1 -
>   hw/remote/memory.c                | 1 -
>   hw/remote/proxy-memory-listener.c | 1 -
>   hw/s390x/s390-virtio-ccw.c        | 1 -
>   hw/vfio/spapr.c                   | 1 -
>   hw/virtio/virtio-mem.c            | 1 -
>   8 files changed, 8 deletions(-)
> 
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index 82fb23beaa8..97ab6bebd25 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -77,7 +77,6 @@
>   #include "hw/virtio/virtio-scsi.h"
>   #include "hw/virtio/vhost-scsi-common.h"
>   
> -#include "system/ram_addr.h"
>   #include "system/confidential-guest-support.h"
>   #include "hw/usb.h"
>   #include "qemu/config-file.h"
> diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
> index f2f5722d8ad..0f94c192fd4 100644
> --- a/hw/ppc/spapr_caps.c
> +++ b/hw/ppc/spapr_caps.c
> @@ -27,7 +27,6 @@
>   #include "qapi/error.h"
>   #include "qapi/visitor.h"
>   #include "system/hw_accel.h"
> -#include "system/ram_addr.h"
>   #include "target/ppc/cpu.h"
>   #include "target/ppc/mmu-hash64.h"
>   #include "cpu-models.h"
> diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
> index 1ac1185825e..f9095552e86 100644
> --- a/hw/ppc/spapr_pci.c
> +++ b/hw/ppc/spapr_pci.c
> @@ -34,7 +34,6 @@
>   #include "hw/pci/pci_host.h"
>   #include "hw/ppc/spapr.h"
>   #include "hw/pci-host/spapr.h"
> -#include "system/ram_addr.h"
>   #include <libfdt.h>
>   #include "trace.h"
>   #include "qemu/error-report.h"

I am seeing error while applying patch series:

harshpb:patches$ git log --oneline -n1
29b77c1a2d (HEAD -> review-20251002, upstream/master, master) Merge tag 
'rust-ci-pull-request' of https://gitlab.com/marcandre.lureau/qemu into 
staging 

harshpb:patches$ git am 
./v2_20251001_philmd_system_physmem_extract_api_out_of_system_ram_addr_h_header.mbx 
 
 

Applying: system/ram_addr: Remove unnecessary 'exec/cpu-common.h' header
Applying: accel/kvm: Include missing 'exec/target_page.h' header
Applying: hw/s390x/s390-stattrib: Include missing 'exec/target_page.h' 
header
Applying: hw/vfio/listener: Include missing 'exec/target_page.h' header
Applying: target/arm/tcg/mte: Include missing 'exec/target_page.h' header
Applying: hw: Remove unnecessary 'system/ram_addr.h' header
Applying: system/physmem: Un-inline cpu_physical_memory_get_dirty_flag()
Applying: system/physmem: Un-inline cpu_physical_memory_is_clean()
Applying: system/physmem: Un-inline 
cpu_physical_memory_range_includes_clean()
Applying: system/physmem: Un-inline cpu_physical_memory_set_dirty_flag()
Applying: system/physmem: Un-inline cpu_physical_memory_set_dirty_range()
Applying: system/physmem: Remove _WIN32 #ifdef'ry
Applying: system/physmem: Un-inline cpu_physical_memory_set_dirty_lebitmap()
Applying: system/physmem: Un-inline cpu_physical_memory_dirty_bits_cleared()
Applying: system/physmem: Reduce cpu_physical_memory_clear_dirty_range() 
scope
Applying: system/physmem: Reduce cpu_physical_memory_sync_dirty_bitmap() 
scope
Applying: system/physmem: Drop 'cpu_' prefix in Physical Memory API
error: patch failed: hw/vfio/container.c:255
error: hw/vfio/container.c: patch does not apply
Patch failed at 0017 system/physmem: Drop 'cpu_' prefix in Physical 
Memory API
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
harshpb:patches$

However, changes for ppc/spapr looks fine to me.

Thanks
Harsh

> diff --git a/hw/remote/memory.c b/hw/remote/memory.c
> index 00193a552fa..8195aa5fb83 100644
> --- a/hw/remote/memory.c
> +++ b/hw/remote/memory.c
> @@ -11,7 +11,6 @@
>   #include "qemu/osdep.h"
>   
>   #include "hw/remote/memory.h"
> -#include "system/ram_addr.h"
>   #include "qapi/error.h"
>   
>   static void remote_sysmem_reset(void)
> diff --git a/hw/remote/proxy-memory-listener.c b/hw/remote/proxy-memory-listener.c
> index 30ac74961dd..e1a52d24f0b 100644
> --- a/hw/remote/proxy-memory-listener.c
> +++ b/hw/remote/proxy-memory-listener.c
> @@ -12,7 +12,6 @@
>   #include "qemu/range.h"
>   #include "system/memory.h"
>   #include "exec/cpu-common.h"
> -#include "system/ram_addr.h"
>   #include "qapi/error.h"
>   #include "qemu/error-report.h"
>   #include "hw/remote/mpqemu-link.h"
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index d0c6e80cb05..ad2c48188a8 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -13,7 +13,6 @@
>   
>   #include "qemu/osdep.h"
>   #include "qapi/error.h"
> -#include "system/ram_addr.h"
>   #include "system/confidential-guest-support.h"
>   #include "hw/boards.h"
>   #include "hw/s390x/sclp.h"
> diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
> index 8d9d68da4ec..0f23681a3f9 100644
> --- a/hw/vfio/spapr.c
> +++ b/hw/vfio/spapr.c
> @@ -17,7 +17,6 @@
>   
>   #include "hw/vfio/vfio-container-legacy.h"
>   #include "hw/hw.h"
> -#include "system/ram_addr.h"
>   #include "qemu/error-report.h"
>   #include "qapi/error.h"
>   #include "trace.h"
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 1de2d3de521..15ba6799f22 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -25,7 +25,6 @@
>   #include "hw/virtio/virtio-mem.h"
>   #include "qapi/error.h"
>   #include "qapi/visitor.h"
> -#include "system/ram_addr.h"
>   #include "migration/misc.h"
>   #include "hw/boards.h"
>   #include "hw/qdev-properties.h"

