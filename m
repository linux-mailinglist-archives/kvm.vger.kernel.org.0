Return-Path: <kvm+bounces-59421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E01BB36C1
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 11:16:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6F7C170A69
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 09:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B333002AD;
	Thu,  2 Oct 2025 09:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GAQhLXtu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3FB2F28E5;
	Thu,  2 Oct 2025 09:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759396584; cv=none; b=BGCFkSVvyEFMjG7wf0Zh9/4fSy7Y7gy7B6WLuls0VjBEWewkwbz8z923P/xI4rkmHYX4g75RhxzL52DvAFNGYQfeuBz4wwcupzvfJ7L+dk8S4ED5Exrnmnr0UIEumm3UUxxxS+x1lstP3x4J0xHpDE755CO7MXIfZSjbcTGKycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759396584; c=relaxed/simple;
	bh=6Dqu7GkU07vTPH97+sZbR9B+tfqS7526oW8QJaf6uQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5CKJ+BqlxaO8Nq1/EsA5pL2u5SfR5O9CVOOBdYzOrTFaesbH0dfWvOMuzO2ydwqVE7++VRNFPi0m0eFyLwsUZjgyk5q0awnK3iMwDUUSn3csTN1VBxcnV/b/IJExy6D/Dy7UtI4zsR0RJI4eb1NSsqKf6NoM/+/Ft2ZI+my7OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GAQhLXtu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5923ECVg023759;
	Thu, 2 Oct 2025 09:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:sender:subject:to; s=pp1;
	 bh=XItbSJ6u+BslKjA8QdV32lIftmJziyQwztI01eNhG74=; b=GAQhLXtuhNVl
	A/54zTv4ccUg6NRAqwz+cpLJGAKEARi3nYATz72QIZopMbmF74eRT+T8YjyT9tQd
	D8skREgpB0X1S+IBHFAAwjz+OKOf3Qjcd5y6Ge1t+RVTXCi9ue8z0OSzzlEV7bb5
	unJ/PM9dnyxb0aUgRtrS4gU+1Ldf905dq1iI3zoH7vyFvGddNy5rxjO+gwFRlsiR
	NlsW6TKROP6nxEK5LgaaKpis84Bdr1KHNMEIdX/dBIAWD0WQY2JgTlPbzRKhBNYa
	MEZQNICmsI6IQODKAwzVNTtryQOLrCkQtMI/klPXTHxuQmtc5GUDIUKcvqU12GpB
	+LYwZ/+9vw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7n84gdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 09:16:18 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5924lHQD001554;
	Thu, 2 Oct 2025 09:16:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49evfjd0ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 09:16:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5929GD3E44695920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Oct 2025 09:16:13 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD0682004D;
	Thu,  2 Oct 2025 09:16:13 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC1E52004B;
	Thu,  2 Oct 2025 09:16:13 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.63])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  2 Oct 2025 09:16:13 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.98.2)
	(envelope-from <bblock@linux.ibm.com>)
	id 1v4FQ5-000000026Gu-2DY1;
	Thu, 02 Oct 2025 11:16:13 +0200
Date: Thu, 2 Oct 2025 11:16:13 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <20251002091613.GD408411@p1gen4-pw042f0m>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-2-alifm@linux.ibm.com>
 <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kAbQJP4S4NwLneDspLkjhKzd0tXO9o_e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX1VFY2bcCYi8Q
 qSfDB5+DR0Xnale9h74820lb+xprmK9H97upJCPrsIEe4tKt7/t3OIY3L0fD98JDEn7tz86kPVq
 VPUtyE4J3YZNVXTpU5g73hef0jwDonTwmhpBkkC7f/pLmYABZxOZdwET38dy4mBtyhilniSNuP7
 iF1CqEIkQVUJ5fZvOm1XMbnglZfTFGah65E4ISfC4KGknEDVv/wCh/DUQRjvzSgoXl7hE8zjpgw
 aGy9MLGtzS2rBjq8q4dI0JxEqY89Zqq2NfDKYU9vmZIxuu099pnMktH3W41WxjfhE9gUyBY8M2P
 Lk7fonNXWLhykPVmEgXu5aQBvlqdDu4D5TdwpzI4O+gIjMSP+gHJMedT1MlCjQPb5oqNf204LXI
 TH2Ey5JGeuJ5Lhz1MRtYQ+IAX61ncg==
X-Proofpoint-GUID: kAbQJP4S4NwLneDspLkjhKzd0tXO9o_e
X-Authority-Analysis: v=2.4 cv=T7qBjvKQ c=1 sm=1 tr=0 ts=68de42e2 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=8nJEP1OIZ-IA:10 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=em1G25Uw2J8WQFataU8A:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_03,2025-10-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

On Wed, Oct 01, 2025 at 10:12:03AM -0700, Farhan Ali wrote:
> 
> On 10/1/2025 8:15 AM, Benjamin Block wrote:
> > On Wed, Sep 24, 2025 at 10:16:19AM -0700, Farhan Ali wrote:
> >> @@ -1792,6 +1798,14 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
> >>   int pci_save_state(struct pci_dev *dev)
> >>   {
> >>   	int i;
> >> +	u32 val;
> >> +
> >> +	pci_read_config_dword(dev, PCI_COMMAND, &val);
> >> +	if (PCI_POSSIBLE_ERROR(val)) {
> >> +		pci_warn(dev, "Device config space inaccessible, will only be partially restored\n");
> >> +		return -EIO;
> >
> > Should it set `dev->state_saved` to `false`, to be on the save side?
> > Not sure whether we run a risk of restoring an old, outdated state otherwise.
> 
> AFAIU if the state_saved flag was set to true then any state that we 
> have saved should be valid and should be okay to be restored from. We 
> just want to avoid saving any invalid data.

Hmm, so I dug a bit more, and I see
void pci_restore_state(struct pci_dev *dev) {}
has `dev->state_saved = false` at the end, so I guess if a device is put into
suspend, and then later woken again, the flag gets reset every time.

And then there is also code like this:

	static pci_ers_result_t e1000_io_slot_reset(struct pci_dev *pdev)
	{
		...
		err = pci_enable_device_mem(pdev);
		if (err) {
			...
		} else {
			pdev->state_saved = true;
			pci_restore_state(pdev);

I don't know..

But I see Alex suggested this before.

> >> +	}
> >> +
> >>   	/* XXX: 100% dword access ok here? */
> >>   	for (i = 0; i < 16; i++) {
> >>   		pci_read_config_dword(dev, i * 4, &dev->saved_config_space[i]);
> >> @@ -1854,6 +1868,14 @@ static void pci_restore_config_space_range(struct pci_dev *pdev,
> >>   
> >>   static void pci_restore_config_space(struct pci_dev *pdev)
> >>   {
> >> +	if (!pdev->state_saved) {
> >> +		pci_warn(pdev, "No saved config space, restoring BARs\n");
> >> +		pci_restore_bars(pdev);
> >> +		pci_write_config_word(pdev, PCI_COMMAND,
> >> +				PCI_COMMAND_MEMORY | PCI_COMMAND_IO);
> >
> > Is this really something that ought to be universally enabled? I thought this
> > depends on whether attached resources are IO and/or MEM?
> >
> > 	int pci_enable_resources(struct pci_dev *dev, int mask)
> > 	{
> > 		...
> > 		pci_dev_for_each_resource(dev, r, i) {
> > 			...
> > 			if (r->flags & IORESOURCE_IO)
> > 				cmd |= PCI_COMMAND_IO;
> > 			if (r->flags & IORESOURCE_MEM)
> > 				cmd |= PCI_COMMAND_MEMORY;
> > 		}
> > 		...
> > 	}
> >
> > Also IIRC, especially on s390, we never have IO resources?
> >
> > 	int zpci_setup_bus_resources(struct zpci_dev *zdev)
> > 	{
> > 		...
> > 		for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> > 			...
> > 			/* only MMIO is supported */
> > 			flags = IORESOURCE_MEM;
> > 			if (zdev->bars[i].val & 8)
> > 				flags |= IORESOURCE_PREFETCH;
> > 			if (zdev->bars[i].val & 4)
> > 				flags |= IORESOURCE_MEM_64;
> > 			...
> > 		}
> > 		...
> > 	}
> >
> > So I guess this would have to have some form of the same logic as in
> > `pci_enable_resources()`, after restoring the BARs.
> >
> > Or am I missing something?
> 
> As per my understanding of the spec, setting both I/O Space and Memory 
> Space should be safe. The spec also mentions if a function doesn't 
> support IO/Memory space access it could hardwire the bit to zero. We 
> could add the logic to iterate through all the resources and set the 
> bits accordingly, but in this case trying a best effort restoration it 
> should be fine?
> 
> Also I didn't see any issues testing on s390x with the NVMe, RoCE and 
> NETD devices, but I could have missed something.

Well, just taking a coarse look at how some other PCI device drivers use the
Command register (this being non-s390 specific after all); some of them base
decisions on whether either/or these flags are set in config space. Now that
this sets both flags, this might have surprising side-effects.
    On the other hand, iterating over the resources might not even be enough
with some device-drivers, since they base their decision on whether to enable
either/or on other knowledge.
    So I don't know. Enabling both just in case might be a good compromise.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294

