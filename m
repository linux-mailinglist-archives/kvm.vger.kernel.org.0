Return-Path: <kvm+bounces-59315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C062BB104A
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:18:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A04793B2FA5
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679112E11AA;
	Wed,  1 Oct 2025 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ETneQCBg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A8F27A90A;
	Wed,  1 Oct 2025 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759331754; cv=none; b=resGnhfoXbEX1OIYwBoZa2Vbcyf7ZFJJuvbZ0c/Q40u5SsfrRY0WNVy0lVYzRiQyNKl/aNhtOfOh9jZLOeVveT+Cbe9pau/Gi8SyRl1vedYUdkdS+1DSrab0u9mPW1Okh+bXjufVv2lTNDGGFB3ScOnKZnZhylJpSs7cIjtsgw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759331754; c=relaxed/simple;
	bh=xo+LjN+6M5xrDWe0LumImYYdQdiYA36qXm/82TdgDb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCn9alGvdhVTG08Oa4fYl94CeICLqzVpYAyvRhVZ0XFGjrvMGn3z8B8BOBoWKTxS69Sy9LjlsNS3GX+q6Q43FeC7BKXC5zqA8DDBVY0A0aGAGFt9xkC43l03+wJ/Jcu5Z3+WLgfESKPUPqoecNgqm58MX/6U2jNYjKUyaGLNJXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ETneQCBg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591C3qOD026121;
	Wed, 1 Oct 2025 15:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:sender:subject:to; s=pp1;
	 bh=MlDiE1bhc4JPlZ7JkI12SJv+T2Q6ot/KiLSntWAWJ5Y=; b=ETneQCBgyPEn
	1JbN3k+Ey1s4Z1ZFKd0Mjnj2iV4NMsjIJzCPv3R97mMARmB+mNXFgnzlAjcufsDF
	/7J6XC4OWqIDNJnr/a+nypm9UWm7HxVDi6pjJgWmOAHKaVTkFcSAgeODj6Niswsr
	W5jGInZYRjtqV+Nqsp6/6JxRfvnilA5KU6GyyoV/8hvcLkGVHpbvFZD4OgQcaBAk
	pzPDhuYdvWGn8DaIRI8pWiZOeqlJVLYsga4Y3VtGliXyeBS/N8N+8ozlbFkpVx3q
	ZtaMgAjBb6OxDMR00GDWHVJWd+0JkD5oI1qogf74NxBzNANQkQ7611BC2RWf0j0y
	FCdV0syR6g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e5bqyrwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 15:15:48 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 591D6aRP007328;
	Wed, 1 Oct 2025 15:15:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49eurk1bvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Oct 2025 15:15:47 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 591FFhe718088278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Oct 2025 15:15:43 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B7262004D;
	Wed,  1 Oct 2025 15:15:43 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5908720043;
	Wed,  1 Oct 2025 15:15:43 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.180])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  1 Oct 2025 15:15:43 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.98.2)
	(envelope-from <bblock@linux.ibm.com>)
	id 1v3yYR-00000001mJM-0NOD;
	Wed, 01 Oct 2025 17:15:43 +0200
Date: Wed, 1 Oct 2025 17:15:43 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <20251001151543.GB408411@p1gen4-pw042f0m>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-2-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250924171628.826-2-alifm@linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDIxNCBTYWx0ZWRfX70nNezYDrZzd
 kslqs4ddK8xtFuNuxen0NdVxnYvrFmYQWNB+Vto7UiLIRNnJjVehvBbEVubYB50MwVREfH0xdXb
 qPi0QyBMB8ma1ckPQCHSDV59Xve/w4tlrI7w0dMx+IsGl4N47pO77eVzQSu8zNfHWfRjt9mI5LQ
 gwmrtGJZCjm1LAgAdOlCKznjBabA1jZgPmaAV8/vgIQ8To1SWDwQZUjQuSU6R/GYyVwGWQ4gNGd
 nwB+sF9Mq33QJ4ys2JTU0J6pm5lZOUK1e6PuWVnFYfFCzSBbY+oFRd597AeW9jvW48Ooh5edRYT
 mzSaddYGtlclGOofg1uG9bV5JKWeUX0pfFr5P4n+gxDfRlqpWP/j3AaZG3HEUtWotbKfn+m0X7w
 B88stuy1T3cYWckp9wvl6QpIeIye7Q==
X-Proofpoint-GUID: 2W8DL0p3Yhafhks06gyp_QkSmr5xPuYZ
X-Authority-Analysis: v=2.4 cv=LLZrgZW9 c=1 sm=1 tr=0 ts=68dd45a4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=8nJEP1OIZ-IA:10 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=fNfyPmc1JltVXBjRTFUA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 2W8DL0p3Yhafhks06gyp_QkSmr5xPuYZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509260214

On Wed, Sep 24, 2025 at 10:16:19AM -0700, Farhan Ali wrote:
> @@ -1792,6 +1798,14 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
>  int pci_save_state(struct pci_dev *dev)
>  {
>  	int i;
> +	u32 val;
> +
> +	pci_read_config_dword(dev, PCI_COMMAND, &val);
> +	if (PCI_POSSIBLE_ERROR(val)) {
> +		pci_warn(dev, "Device config space inaccessible, will only be partially restored\n");
> +		return -EIO;

Should it set `dev->state_saved` to `false`, to be on the save side?
Not sure whether we run a risk of restoring an old, outdated state otherwise.

> +	}
> +
>  	/* XXX: 100% dword access ok here? */
>  	for (i = 0; i < 16; i++) {
>  		pci_read_config_dword(dev, i * 4, &dev->saved_config_space[i]);
> @@ -1854,6 +1868,14 @@ static void pci_restore_config_space_range(struct pci_dev *pdev,
>  
>  static void pci_restore_config_space(struct pci_dev *pdev)
>  {
> +	if (!pdev->state_saved) {
> +		pci_warn(pdev, "No saved config space, restoring BARs\n");
> +		pci_restore_bars(pdev);
> +		pci_write_config_word(pdev, PCI_COMMAND,
> +				PCI_COMMAND_MEMORY | PCI_COMMAND_IO);

Is this really something that ought to be universally enabled? I thought this
depends on whether attached resources are IO and/or MEM?

	int pci_enable_resources(struct pci_dev *dev, int mask)
	{
		...
		pci_dev_for_each_resource(dev, r, i) {
			...
			if (r->flags & IORESOURCE_IO)
				cmd |= PCI_COMMAND_IO;
			if (r->flags & IORESOURCE_MEM)
				cmd |= PCI_COMMAND_MEMORY;
		}
		...
	}

Also IIRC, especially on s390, we never have IO resources?

	int zpci_setup_bus_resources(struct zpci_dev *zdev)
	{
		...
		for (i = 0; i < PCI_STD_NUM_BARS; i++) {
			...
			/* only MMIO is supported */
			flags = IORESOURCE_MEM;
			if (zdev->bars[i].val & 8)
				flags |= IORESOURCE_PREFETCH;
			if (zdev->bars[i].val & 4)
				flags |= IORESOURCE_MEM_64;
			...
		}
		...
	}

So I guess this would have to have some form of the same logic as in
`pci_enable_resources()`, after restoring the BARs.

Or am I missing something?

> +		return;
> +	}

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294

