Return-Path: <kvm+bounces-59269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD553BAFA78
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 870CB3B5DFA
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD9E19DF4F;
	Wed,  1 Oct 2025 08:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XXsZ90Nw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822D1226D17;
	Wed,  1 Oct 2025 08:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759307620; cv=none; b=ke69nPiS+yGfqpaRB+Ha4gjvtb9H8l45uZmWPVr5aLHtuCviya43BwKPnO8wbMZAEle41hA5W0FxbcEybg5ShU+5NaxxvpQTajoXae9EAVKIU7O8psKe9OKSWiYALXIpprZpSTd95Zt8gYVskdVUyj1gLdKAESO0YYMGgShDqfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759307620; c=relaxed/simple;
	bh=9A+KfhdYh8LaOB+g1RUzkpSHt6pT+lse1tnongyRkCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJpj6umULTawK6GlljIt2j+/HGlQ+oIu7nk1rCvh33wq007/+nZ+x1aFWoNgUaTpudy36BSyVRNYKdJQPiEm1x1P6up41JPOB3zAL8LknzJuFUgUZhNDlGK4ukoyrZEIdJ4H1U+x/2DR+CUVUqUfBm/dY6ja4k0Z26suA/7KGt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XXsZ90Nw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5915AWf7030392;
	Wed, 1 Oct 2025 08:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:sender:subject:to; s=pp1;
	 bh=kChBbUHvSPPdRIDmV3EOM8sUaY9q/Dx7lYU4bBN7TcA=; b=XXsZ90NwIUxI
	i7w8Z/I7aGiFMG0jHJfqhVDk6z6qcRuP8C/OYEnq12rZdLc6+lxt+9fVZcV4lpHI
	YEjYrQG/v/2/xNaEzMfQIO6m8zWyRoXI7RaSJQ4Zr8ny5dfCUMux9P6DlA/v2wRQ
	vmtFSSnVhFjl4rvfWcPKZwyimzi2aKq99XmG7MehP+CewRYIatBRJrpQjE3utlEk
	seREA+ZTkAbHCU+djyVwKlN3p/D/8zu8ZKaB35n4PRyjYawmwGf1z6CthbA/itbu
	apbhv5ojLlK+cmiF40GpIOxeGX2b4TF1gnHVCQV5sLdyQoyDN4IYjwthq8jfLL0h
	ZSpgLcA6Tw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7e7e93v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 08:33:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59180G3E020074;
	Wed, 1 Oct 2025 08:33:30 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49et8s81fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 08:33:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5918XQdY56426980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Oct 2025 08:33:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A577D20043;
	Wed,  1 Oct 2025 08:33:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9438E20040;
	Wed,  1 Oct 2025 08:33:26 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.180])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  1 Oct 2025 08:33:26 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.98.2)
	(envelope-from <bblock@linux.ibm.com>)
	id 1v3sH8-00000001DfE-1RV8;
	Wed, 01 Oct 2025 10:33:26 +0200
Date: Wed, 1 Oct 2025 10:33:26 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 02/10] PCI: Add additional checks for flr reset
Message-ID: <20251001083326.GC15786@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-3-alifm@linux.ibm.com>
 <20250930100321.GB15786@p1gen4-pw042f0m.boeblingen.de.ibm.com>
 <1f5abbae-7a7d-402d-ac6e-029cdc3b0d63@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f5abbae-7a7d-402d-ac6e-029cdc3b0d63@linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N2EGonN2OkUwauiOa_CIsZ3N0dyYEjd-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyMCBTYWx0ZWRfXzb2Xtv+D8Kx+
 CJriuNPdAh/D2tNK2GnmySwxicyRCspFp2KuOPN6QQezHiea+X608uJVwUYXMkxAoSOqLwkxx6N
 w/oQiYnf4u4Smo6MEup3tRke6hW38l7bgne5QpI9WbuNjPB5Kr7f1m1N1k7U/JRlIHUCopcf2BB
 CZtohS60AzGa0pCwXcExxMBKPnsDX9+L6znUR4IJxvigRbVjQO2RobinbggnRYzkHQ9/78TJzBI
 cBhvAyNZMGMY+p8noIvcM76080rkfDlhoJb2++4lFFiIdoJahdnMMF2/TZ3p+S2ile5VJvmgRbo
 V4bxMClNmRjkQoKEW0jg9qjamzV+ssVo0+nE/olP/PLuCoRxgtc5Jdz2sDHSi/ENZ76y9O/KK91
 p6REunvNn+mxcZg+BXhcKWvvwTfj+A==
X-Proofpoint-GUID: N2EGonN2OkUwauiOa_CIsZ3N0dyYEjd-
X-Authority-Analysis: v=2.4 cv=Jvj8bc4C c=1 sm=1 tr=0 ts=68dce75b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=8nJEP1OIZ-IA:10 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=ersEkfyWTpBJs_UulfkA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_02,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509270020

On Tue, Sep 30, 2025 at 10:04:25AM -0700, Farhan Ali wrote:
> 
> On 9/30/2025 3:03 AM, Benjamin Block wrote:
> > On Wed, Sep 24, 2025 at 10:16:20AM -0700, Farhan Ali wrote:
> >> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> >> index a3d93d1baee7..327fefc6a1eb 100644
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
--8<--
> >> +	if (pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &reg)) {
> >> +		pci_warn(dev, "Device unable to do an FLR\n");
> >> +		return -ENOTTY;
> >> +	}
> > Just thinking out loud, not sure whether it make sense, but since you already
> > read an up-to-date value from the config space, would it make sense to
> > pull the check above `dev->devcap & PCI_EXP_DEVCAP_FLR` below this read, and
> > check on the just read `reg`?
> 
> My thinking was we could exit early if the device never had FLR 
> capability (and so was not cached in devcap). This way we avoid an extra 
> PCI read.

That makes sense.

> > Also wondering whether it makes sense to stable-tag this? We've recently seen
> > "unpleasant" recovery attempts that look like this in the kernel logs:
> >
> >      [  663.330053] vfio-pci 0007:00:00.1: timed out waiting for pending transaction; performing function level reset anyway
> >      [  664.730051] vfio-pci 0007:00:00.1: not ready 1023ms after FLR; waiting
> >      [  665.830023] vfio-pci 0007:00:00.1: not ready 2047ms after FLR; waiting
> >      [  667.910023] vfio-pci 0007:00:00.1: not ready 4095ms after FLR; waiting
> >      [  672.070022] vfio-pci 0007:00:00.1: not ready 8191ms after FLR; waiting
> >      [  680.550025] vfio-pci 0007:00:00.1: not ready 16383ms after FLR; waiting
> >      [  697.190023] vfio-pci 0007:00:00.1: not ready 32767ms after FLR; waiting
> >      [  730.470021] vfio-pci 0007:00:00.1: not ready 65535ms after FLR; giving up
> >
> > The VF here was already dead in the water at that point, so I suspect
> > `pci_read_config_dword()` might have failed, and so this check would have
> > failed, and we wouldn't have "wasted" the minute waiting for a FLR that was
> > never going to happen anyway.
>
> I think maybe we could? I don't think this patch fixes anything that's 
> "broken" but rather improves the behavior to escalate to other reset 
> method if the device is already in a bad state. I will cc stable.

Right, adding a Fixes tag doesn't really make sense. But it does help with
accelerating recoveries, so maybe a stable tag will work :)


-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294

