Return-Path: <kvm+bounces-59299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8279BB0B87
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 16:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66951189F524
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 14:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF690259CA5;
	Wed,  1 Oct 2025 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X6qWM/k6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DF61D5CC6;
	Wed,  1 Oct 2025 14:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759329260; cv=none; b=uyuYyxF5E7nANWjawlZ2gPbphSFAALkMKywmp6/f5TAQxCa1xGYSNucvKSJmxgsUzcn49qTsNASpUEfwZLxzOEA+W80MQiip0JQPmNvaE/sr0VXTDgsHNpnE+tL8hYG66u0Qzudj62OHrs4rhgW2aDM6uLi1OQ8lClAsZk6Zkeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759329260; c=relaxed/simple;
	bh=gZ0aK9IQKDvO+Ef5+9kKEKr7z/4eiUZrlmSl34QzkUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZgf4BJ9oz0sbShrim3Zb7eXZNTq2/EUj8w+LcOWE3bAZ8Yq3d85e6SuwAe/vjXBPoWcDQb5yhZA5zFMvKqvxYLbzJzynAEqTWWe9JmMe8qLr/gj5Iu6aWAsAQ0odrjUspoJKtOITQ0Uzq7/OdfLWAbjmmD1+bNY623pvToJFL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X6qWM/k6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591CLDWU024085;
	Wed, 1 Oct 2025 14:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:sender:subject:to; s=pp1;
	 bh=TL73tMV+Bun7zMiTYo8zTSJVoBGB9sDpy5MwJeZiSxU=; b=X6qWM/k6XrCW
	IzJjaiO9dyth/Yxs2CIi2VWUYq3jEbArPb3fpzTsZv6xxiet8EZ8HU1IiDMWMp/U
	UZqE8ww/gua+3hMXM9dVjSsiF0AAKUX93xwhKob5TEw/OS/gvN1+j3QYI/pLj1Le
	Wjnj6GxJJvDa6Qv9ClwyziIloY1WRB8cB3QR64Lf9q2WpJ1EU93FNxFZU1jgERk+
	jC3ad7aYGsniZL8xK9vCGYK+01Ko34GSAreFwV49Dqd7N4MyRaacV5sr+UMXJw8v
	PVy0nlcaJedN6zST6dOs+eOMx4W4a3i3rQCJxvGC8WGm+SYS+Vi4+VAPt9Jzofc/
	z5+ho3nGaQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7kug4jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 14:34:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 591CchVJ003314;
	Wed, 1 Oct 2025 14:34:12 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49etmy1c1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 14:34:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 591EY8Oh37945810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Oct 2025 14:34:08 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 940DA2004B;
	Wed,  1 Oct 2025 14:34:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 829EF20043;
	Wed,  1 Oct 2025 14:34:08 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.180])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  1 Oct 2025 14:34:08 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.98.2)
	(envelope-from <bblock@linux.ibm.com>)
	id 1v3xuC-00000001iDG-16kq;
	Wed, 01 Oct 2025 16:34:08 +0200
Date: Wed, 1 Oct 2025 16:34:08 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH v4 03/10] PCI: Allow per function PCI slots
Message-ID: <20251001143408.GD15786@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-4-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250924171628.826-4-alifm@linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=T7WBjvKQ c=1 sm=1 tr=0 ts=68dd3be6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=8nJEP1OIZ-IA:10 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=JLdZ86f31E_vRC4OAtoA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: lYzqNPjjy1x0jK_n4qSydhzOvFPDuRag
X-Proofpoint-ORIG-GUID: lYzqNPjjy1x0jK_n4qSydhzOvFPDuRag
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX+yQTFFRgJ763
 dZjqq78PLh3lec1JlU9dnignBDB8YinFn08lkYE3A/49Pns0v0/0VoyeQ70u+G30Y0pZXKJQpFR
 8nf5pG4m2iF4xAlEj6AtxahepBXe5MjXdYhPGluc4RfAIAUFPudnJQGV8KtD8wZnbzbZeFVlqrm
 eQgsK/5OXkNd96TOafN7DIgPIGT0Vr+/UbLW0RwN79660dd7XgoyQl7uDzBshZJhdWhEemQWtXo
 FTvQLdxpDtMpFbM9yKda62bw8il0s9LmXf4SdX+ga0NIFE0xcpjO04oxZ39rbS1uI4xYFRfeDb9
 Hi9WIXJMgKZhwxOCt1Pag8eM2mkdko8RWRWkjeXKRbLKX6Yab0XMlvjztUPA6idA3m54IPzhCKb
 SXpM4rJ/PmRUQKrpx1w7CRD/wweDeA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

On Wed, Sep 24, 2025 at 10:16:21AM -0700, Farhan Ali wrote:
> On s390 systems, which use a machine level hypervisor, PCI devices are
> always accessed through a form of PCI pass-through which fundamentally
> operates on a per PCI function granularity. This is also reflected in the
> s390 PCI hotplug driver which creates hotplug slots for individual PCI
> functions. Its reset_slot() function, which is a wrapper for
> zpci_hot_reset_device(), thus also resets individual functions.
> 
> Currently, the kernel's PCI_SLOT() macro assigns the same pci_slot object
> to multifunction devices. This approach worked fine on s390 systems that
> only exposed virtual functions as individual PCI domains to the operating
> system.  Since commit 44510d6fa0c0 ("s390/pci: Handling multifunctions")
> s390 supports exposing the topology of multifunction PCI devices by
> grouping them in a shared PCI domain. When attempting to reset a function
> through the hotplug driver, the shared slot assignment causes the wrong
> function to be reset instead of the intended one. It also leaks memory as
> we do create a pci_slot object for the function, but don't correctly free
> it in pci_slot_release().
> 
> Add a flag for struct pci_slot to allow per function PCI slots for
> functions managed through a hypervisor, which exposes individual PCI
> functions while retaining the topology.
> 
> Fixes: 44510d6fa0c0 ("s390/pci: Handling multifunctions")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/pci/hotplug/s390_pci_hpc.c | 10 ++++++++--
>  drivers/pci/pci.c                  |  5 +++--
>  drivers/pci/slot.c                 | 14 +++++++++++---
>  include/linux/pci.h                |  1 +
>  4 files changed, 23 insertions(+), 7 deletions(-)
> 

Looks good to me; thanks.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294

