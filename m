Return-Path: <kvm+bounces-57395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D73B7B54D8C
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:27:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1A5D1726F8
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 12:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4858A2FF15E;
	Fri, 12 Sep 2025 12:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aFsXhQzJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D452427B4F5;
	Fri, 12 Sep 2025 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757679794; cv=none; b=jsHc5PL7aVw6pEMAMZ9dLFnzCDakUYDwQMN+t+7O63HVghf46gpon+4nsgGBMpbacuzMHhYKNLn7Iiht3guKVa0287x8OdUTA3MfNlHqToFqAd2e/ILYn/OirXmdE5HsnGBGAK7J/hEBxfHx1litQm8kXjz4tZwLVL+4io613jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757679794; c=relaxed/simple;
	bh=bH4NRMgWnPXPHJ94kL2TjjMeV3PNPXB41VeHrC20Y5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bV6ytQlmH9ygZFj6WdGwt+u6z8CcWQjmpMMpPxpmdph0MmXXkR1+IQHdC/nDUCLpYi49O3Pmj/02JTWpeumYsUqRpZRUo0/usBnFhbX6m+CqBsBTqPmij7HrRC8TvuibicxuxLGp1ihii0+kqahQcgkwEtnZItvzgxKERRegaPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aFsXhQzJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C6F43A027074;
	Fri, 12 Sep 2025 12:23:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:sender:subject:to; s=pp1;
	 bh=9ux8ILTUeDcvga5jYs95DD4PIL2aOHphcYBxHMQbne0=; b=aFsXhQzJduxW
	OVtpT7SZwurzdlwzOIRkUaz9Mf744udZxtuT6WajNpQVfJyZjIDfDqKdCb3UGyMR
	Sp8fNnsCP+Uo/LG+yF4TUw7ggFYrndS4TYv6sFaq0WJkJYhKH2rzdmqh4PzNbqeE
	G7Kp48I4uxsJPbbaPFbfCKoGCLP7EEyOewYFLsW4mwxkjz6Rov4ErmFrx74u31Uq
	0oMHaN8P8aCFiPGjzmMN1vY67bKmhyuHUoWvuo5W5Q7s0VmjGkcbPbbk1MQtcDVt
	6rjIdlLmXROnBeJO9jRh03F4mGv0rkhF76iEVpTJkZlR7fNgYH3o06dzEhJnKZwW
	I1VGalTh1A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcta2gr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 12:23:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58CB0oSV017163;
	Fri, 12 Sep 2025 12:23:07 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmtq2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 12:23:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58CCN0fb52363584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 12:23:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE6E42004D;
	Fri, 12 Sep 2025 12:23:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDAF32004B;
	Fri, 12 Sep 2025 12:23:00 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.78])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 12 Sep 2025 12:23:00 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.98.2)
	(envelope-from <bblock@linux.ibm.com>)
	id 1ux2ns-00000002uha-2OLi;
	Fri, 12 Sep 2025 14:23:00 +0200
Date: Fri, 12 Sep 2025 14:23:00 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, schnelle@linux.ibm.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH v3 03/10] PCI: Allow per function PCI slots
Message-ID: <20250912122300.GA15517@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-4-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250911183307.1910-4-alifm@linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX3TNJOphnH2il
 jrBpLiBmr1DdZdMx+mcIweDwmZ+wZdH6httyq+5D/gQ0h+M4iYAllWqZ0VskJIBZ1dRB4vPei5u
 8wFkfpqRKy6YbwxQ+mt4mMGfAaTTT2fmFmN1MtJy+Af2GwwVdJSqb5C2mZ0LDJSaffXSlYyJTHV
 md6zyVH0ByfJBeeHJ/idmWgRjeoz7EWm7ym+2znVp4zKbXqNIZFapj4Ot9eAWeppAoqwjMjyFFy
 bQ+oXp5sbVtXB29EKHV/X7pZqnQcTkFkuZb+BWSa9qgy/F2dHzvbrOsJvRt6tSTXQMaMLylRBC5
 fLOW5J8MBSum64BqZa6k4TcDd+p8cdPi4Y9ImSNZZ8KM8srvKNjrTJ8vDnDt6PiHvg3vV3XFCkx
 l4mn4fhW
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c410ac cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=8nJEP1OIZ-IA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=TjuGVM56yl0YPUG8lfgA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-GUID: AUWlo5yUzZA2zKTw0JinpgK5xuJm9dp7
X-Proofpoint-ORIG-GUID: AUWlo5yUzZA2zKTw0JinpgK5xuJm9dp7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

On Thu, Sep 11, 2025 at 11:33:00AM -0700, Farhan Ali wrote:
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

Stable tag?
Reseting the wrong PCI function sounds bad enough.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294

