Return-Path: <kvm+bounces-59325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A5D3BB134A
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6870B7AF2FE
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594A0285C8D;
	Wed,  1 Oct 2025 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l450vly9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0366F220F2A;
	Wed,  1 Oct 2025 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759334670; cv=none; b=NLOtLEr1NPbHtPEA/Y5dVKsP3pIxL30vxRIJF56I/kipXrGMb/whMVZCQ8QWGq+C94sA4llatQSTvrt+1K33B0tsG9mNmsfZKB5Z3nLPcBOwJk3DQLnvH3VRkZFkaupEUOb6O4T1BRCYi6M8PjHOILZ27+guKn4+WER3DfD6HQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759334670; c=relaxed/simple;
	bh=b4PZt7GhY8vtuTdOFy/dzLL1lC5+b8+tcI+iXRcP+NU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEnISLHLzWQhMtSFb5mzU6LIrrN7RKPy/2EdKe2hdtcR+uN8bNvBdNTk1vbJle30wvF4R7qzs9AnOyCgeZ7WVm2GKrK00JUr7/I+Y+rkEu0TtCkucue5WlIqk/eFSpT4fVA0neJ8+Q7RdKnnxoXtQ7LMmqXOF9lZW0fwc/1bMq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l450vly9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591A6UHN020668;
	Wed, 1 Oct 2025 16:04:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:sender:subject:to; s=pp1;
	 bh=ubRdxyTKNN6EP8FcuHKiYz1hqVBgmkU7Xv2ow0o+854=; b=l450vly9Fcxu
	+KlXaM+7Nt5FcKznSZT09C+xLwG6SECCa65XKmL8WxLIHOqPTaID1lVWmDukClli
	QkeM3DRl9ljwO0WYKrZrXQSQdf70PSqoix6y/zgHD27PpUV53eszdNifFaIqgqnq
	udRE93ViwYPbah8Kz0vOCfhttky3hF3veWk1X9qsh4jz/vQfngmkVAtIJpdU/pEX
	dya4MpuqGMsa5tcuA/JgXMZjmVCfbyDXxjCjWz+yCrF6k0R0bN7cziTBMyZ7gzpo
	blufBR7aUW4GoheKEmhjMjJtnpbr4wuQS3ilZzlxLQmztn1Fu3V4hcyCmTLk6uJS
	vnDJQZ2A/g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7kugmry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 16:04:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 591G1aGm007293;
	Wed, 1 Oct 2025 16:04:19 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49eurk1jx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 16:04:19 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 591G4Fl348234830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Oct 2025 16:04:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 688A62004B;
	Wed,  1 Oct 2025 16:04:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 570F820040;
	Wed,  1 Oct 2025 16:04:15 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.180])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  1 Oct 2025 16:04:15 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.98.2)
	(envelope-from <bblock@linux.ibm.com>)
	id 1v3zJP-00000001q82-0M3U;
	Wed, 01 Oct 2025 18:04:15 +0200
Date: Wed, 1 Oct 2025 18:04:15 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        helgaas@kernel.org, clg@redhat.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 04/10] s390/pci: Add architecture specific
 resource/bus address translation
Message-ID: <20251001160415.GC408411@p1gen4-pw042f0m>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-5-alifm@linux.ibm.com>
 <2d049d60868c0f61e53e70a73881f8674368537a.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2d049d60868c0f61e53e70a73881f8674368537a.camel@linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=T7WBjvKQ c=1 sm=1 tr=0 ts=68dd5105 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=8nJEP1OIZ-IA:10 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=hFhDQMQP5WLE61zUqAQA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: GmOlmIA73OLk-OZ6r_51B7u-g9hHQI5B
X-Proofpoint-ORIG-GUID: GmOlmIA73OLk-OZ6r_51B7u-g9hHQI5B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfXzgWnj6Yes4VL
 0l0mdynqDmqLpC+WmZkKLdXUuKdeyAnTwMvbpIzGuxxw3HmjvhU/7D2ar17yOL9BOchQTln6nGj
 Bq5WVsX16cNHarXpq+s3FhgM1r6XWa03QWZ8HZfM/kadaDavtv697emsngA8inbuujOkiTIR8mX
 ZT487z0agpX5JiNSdrrTHfflpiSAtfpMivHkUfFxcrYpY9TnXT2b5WdnigceYO0uG2rXxkOKfCj
 tQmE4sLY92m9njUlVxppQzt3V6kftt4XFpMOSzEV2o3IMeD3SW/ysH8AXW1gMhFZd5nxEvO81PN
 UBUoa0vB+nKAY//A0xLb5UIx8c/44g4c+ZckR5Y6LJ0bXITvlArTkjwPpTlGOrxpR5eNGTR1I/J
 rzEdOyi90MWQ91IERdKXxszfDjjoCA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

On Thu, Sep 25, 2025 at 12:54:07PM +0200, Niklas Schnelle wrote:
> On Wed, 2025-09-24 at 10:16 -0700, Farhan Ali wrote:
> > +void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
> > +			     struct resource *res)
> > +{
> > +	struct zpci_bus *zbus = bus->sysdata;
> > +	struct zpci_bar_struct *zbar;
> > +	struct zpci_dev *zdev;
> > +
> > +	region->start = res->start;
> > +	region->end = res->end;
> 
> When we don't find a BAR matching the resource this would become the
> region used. I'm not sure what a better value would be if we don't find
> a match though and that should hopefully not happen in sensible uses.
> Also this would keep the existing behavior so seems fine.

I was wondering the same things, but I guess it matches what happens elsewhere
as well, if no match is found

	void __weak pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
				     struct resource *res)
	{
		...
		resource_size_t offset = 0;

		resource_list_for_each_entry(window, &bridge->windows) {
			if (resource_contains(window->res, res)) {
				offset = window->offset;
				break;
			}
		}

		region->start = res->start - offset;
		region->end = res->end - offset;
	}

So I guess that is fine.

The thing I'm also unclear on is whether it is OK to "throw out" this whole
logic about `resource_contains(window->res, res)` here and
`region_contains(&bus_region, region)` in the other original function?
I mean, the original function don't search for perfect matches, but also
matches where are contained in a given resource/region, which is different
from what we do here. Are we OK with not doing that at all?

> > +
> > +	for (int i = 0; i < ZPCI_FUNCTIONS_PER_BUS; i++) {
> > +		int j = 0;
> > +
> > +		zbar = NULL;
> > +		zdev = zbus->function[i];
> > +		if (!zdev)
> > +			continue;
> > +
> > +		for (j = 0; j < PCI_STD_NUM_BARS; j++) {
> > +			if (zdev->bars[j].res->start == res->start &&
> > +			    zdev->bars[j].res->end == res->end &&
> > +			    res->flags & IORESOURCE_MEM) {
> > +				zbar = &zdev->bars[j];
> > +				break;
> > +			}
> > +		}
> > +
> > +		if (zbar) {
> > +			/* only MMIO is supported */
> > +			region->start = zbar->val & PCI_BASE_ADDRESS_MEM_MASK;
> > +			if (zbar->val & PCI_BASE_ADDRESS_MEM_TYPE_64)
> > +				region->start |= (u64)zdev->bars[j + 1].val << 32;
> > +
> > +			region->end = region->start + (1UL << zbar->size) - 1;
> > +			return;
> > +		}
> > +	}
> > +}

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294

