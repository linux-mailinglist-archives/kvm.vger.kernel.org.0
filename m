Return-Path: <kvm+bounces-59437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B23BB496A
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 18:46:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0EF619E256D
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 16:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2066258EFF;
	Thu,  2 Oct 2025 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iJJlSgvJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C1F23183F
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 16:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759423591; cv=none; b=sZMsDqRl+5RmkvJTMSKSG+Gy9I+7wQmUC46C2/dA+Nwyy8JpjNvm5nF6SSI8hD2TY7Kn84PmmjB3mK9G8Xvku4637n1mM9eFEw2HRFcfLs72qOKzyQeL+x7Dsnw3dH1SEPcgC05LE5k5+ouSwXu0BmY7QXdzOnvpSa90hPs4oi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759423591; c=relaxed/simple;
	bh=vA7jealyvtopMOC5RwiAr5GmUWf8uULud80PXLmDeds=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IBYH0mHfXxlyQ/D4X/VEgtmeEZj4DXHamgolq2GmTXXWC60I4rJBVfIzy1sbhfxN4sCWVAimMeVla8KfESNNnnENtsxrtcd70X5J5gGMduZPC1xcMKxNK8+zfRD53VFsU4LIRZxXO4dAAezTnXyQd1f+1eYPWM4/i3lLfFAIpiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iJJlSgvJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 592DcqPu018505;
	Thu, 2 Oct 2025 16:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pbhKEa
	E1DBlDRKYZ27gq35MgCt3ia1W2prQ54VRuuz4=; b=iJJlSgvJZE0txa0d60CSr3
	hwQjVm+nIEE5/WOGu3+aBuUeQgF/fRi7rwfZjQOiQ9o0ZkNwA/s7/3eiuOzFk/i4
	WKucmJ7Z+ztl91g8HbqZLfVAeHYIx6/TB4Fup9sPxNNQz5ASCxMLpXwenTHWPJM5
	NXfvd4V9gfYDtUFzUed3VTbEqqreY/kgKcZUuDnwt8y6q7Jr+svThk08syqQxfr3
	ANH22HZUi1yU/rrJt8u2SS4TSPTOPXM1uBNnWyBEaU46H6aAn0uIrpCEGfXYveiZ
	da0xSIdIZUq+idchaa8Wo3F22m1bIcNM0XS/OjJaH9cjpFxoRBAGDdVL4wRSGgIQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e6bhwq5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 16:45:53 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 592GSKMD008352;
	Thu, 2 Oct 2025 16:45:53 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e6bhwq5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 16:45:53 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 592GIiGc003325;
	Thu, 2 Oct 2025 16:45:52 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49etmy721d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 16:45:52 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 592GjoDD30605892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Oct 2025 16:45:51 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D91095803F;
	Thu,  2 Oct 2025 16:45:50 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50E0958056;
	Thu,  2 Oct 2025 16:45:48 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.134.141])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Oct 2025 16:45:48 +0000 (GMT)
Message-ID: <387abc0573ed488798ec805451a5e7e6c79b9a0b.camel@linux.ibm.com>
Subject: Re: [PATCH v2 06/18] hw: Remove unnecessary 'system/ram_addr.h'
 header
From: Eric Farman <farman@linux.ibm.com>
To: Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
        Jagannathan Raman	
 <jag.raman@oracle.com>, qemu-ppc@nongnu.org,
        Ilya Leoshkevich
 <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Jason Herne
 <jjherne@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        =?ISO-8859-1?Q?C=E9dric?= Le Goater	 <clg@redhat.com>,
        kvm@vger.kernel.org,
        Christian Borntraeger	 <borntraeger@linux.ibm.com>,
        Halil Pasic
 <pasic@linux.ibm.com>,
        Matthew Rosato	 <mjrosato@linux.ibm.com>,
        Paolo
 Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Elena
 Ufimtseva <elena.ufimtseva@oracle.com>,
        Richard Henderson	
 <richard.henderson@linaro.org>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Fabiano Rosas <farosas@suse.de>, qemu-arm@nongnu.org,
        qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>,
        Alex
 Williamson <alex.williamson@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Date: Thu, 02 Oct 2025 12:45:47 -0400
In-Reply-To: <20251001175448.18933-7-philmd@linaro.org>
References: <20251001175448.18933-1-philmd@linaro.org>
	 <20251001175448.18933-7-philmd@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Se/6t/Ru c=1 sm=1 tr=0 ts=68deac41 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8
 a=aGwGTAKf3ZeqeKgWoQ8A:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAxMCBTYWx0ZWRfX5K2/3oNHL62q
 mPnN8/B+etDF9KFrdn/UxXWqa+l73ypEUWjN4e3pwvRWAfgWeBH0u51VuWlp8uLlvA17M+YHyio
 iAENZpRMES16emUC23NDKzckmhhB/rLaTLynMQ/UaOPpOXCnCh+m1frDOedv7qHt/EQMq0/i7La
 HJkcAKi+laDJ4+JQlZD0cE+ukw078y7+UJV6xgVmdT5JrcnuaSA4tbiSCktG7c1DaoA+SeLeiQ/
 uiRYtdRBmbiMRdqRyV2ShF67XGzmUPx8FclcxIK3ANbAIsC0Qhl7SWlfEBBwBmmnwXmo0XUfOeu
 TxkS0gyoY3LOG2bpxJUFeMLBAG2OD3H7s8x7O/NowuJia7oaQ+DLSM/B6PhjEKFKAD7g/tjVt2V
 Hr/oDpywz0z6gJEAZxKbafXcoM14og==
X-Proofpoint-GUID: Ip_bUE8ZxJcETWq2tmqVsME2d70jhphX
X-Proofpoint-ORIG-GUID: dQR6yCoHl9AulGC0oIbXH9W_n3wmFPRR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_06,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270010

On Wed, 2025-10-01 at 19:54 +0200, Philippe Mathieu-Daud=C3=A9 wrote:
> None of these files require definition exposed by "system/ram_addr.h",
> remove its inclusion.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  hw/ppc/spapr.c                    | 1 -
>  hw/ppc/spapr_caps.c               | 1 -
>  hw/ppc/spapr_pci.c                | 1 -
>  hw/remote/memory.c                | 1 -
>  hw/remote/proxy-memory-listener.c | 1 -
>  hw/s390x/s390-virtio-ccw.c        | 1 -
>  hw/vfio/spapr.c                   | 1 -
>  hw/virtio/virtio-mem.c            | 1 -
>  8 files changed, 8 deletions(-)
>=20

...snip...

> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index d0c6e80cb05..ad2c48188a8 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -13,7 +13,6 @@
> =20
>  #include "qemu/osdep.h"
>  #include "qapi/error.h"
> -#include "system/ram_addr.h"
>  #include "system/confidential-guest-support.h"
>  #include "hw/boards.h"
>  #include "hw/s390x/sclp.h"

This was added in 9138977b18 ("s390x/kvm: Configure page size after memory =
has actually been
initialized") for the purposes of calling qemu_getrampagesize(), but that g=
ot renamed and later
moved by c6cd30fead ("system: Declare qemu_[min/max]rampagesize() in 'syste=
m/hostmem.h'"). So I
agree this is no longer needed.

Reviewed-by: Eric Farman <farman@linux.ibm.com>  # s390

