Return-Path: <kvm+bounces-57603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C59B5832D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1A837AFF1F
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41B4298987;
	Mon, 15 Sep 2025 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k6Vq5qJG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BE92836A3;
	Mon, 15 Sep 2025 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757956571; cv=none; b=hi8lqn2Oo74SGUlx5S2UjLwWvnYlBVbINj3iDTvvSLABdgm2TBBnbdjTGg9LGUDPzSzkK2My9y2EYpjJRgkGuMptzFtpZuryuphYitwgHbzBzV8+eODq/XoydsFK48jXwY+4sMbZKlTK6uq7B54tgaUKfbqVfBHjUs3HXUmjYpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757956571; c=relaxed/simple;
	bh=7Cs2abMlYfg0Hlz8i95zu7AVNuUpQjULT/Uojb8KiBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzIe/b5M9P+rzJNu3ufOtTzJcgBslOTNbYhuXfpcRaF05GguDR3EAw2V7rBEDlmAX24Xsy7VM0G/5bcAxJMLrFMGcDMNRgSuTZkSxGSVEaRo3Y/zXukHqdsnsSEvWGysdMTPt52iVBcZuD/UXnZKXrRkX1chH9MwJZ2ChwaEvZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k6Vq5qJG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F9aurC018695;
	Mon, 15 Sep 2025 17:16:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=O5vLmc
	YVSWD9a8z/T+INdDdPEgZT9xY4BDXnkFZLLVs=; b=k6Vq5qJGlIo9gYYwFZduZB
	qcTfo7VHbDSCPHV5akD+b9BtJchToYTZVXJTgo1+UGGjjIgsG2k53iGSeOyuvsgE
	KvdFzxwlBdjUvDH21+fRiQ7bRWAxW4+0i4RU8IIXojZbFnLu43UO5yPAa8XWC+hm
	WBxQzKFJqwTszujeFQoUNBcBmvFWGA39umNGfMUQYjNRZ7qcAi+5sT61A5TtMr2p
	4FaarheteOWJvFYq7UdbpUm07BPjNDq9xneAYPsdZyy5FCXxVzqLRr4Susxl9/af
	9XjA9sxHEbvKHValz5vo+iHgNivnOja1b1hfhZ1eY0n+/dtxMJQCry+UbwoOfFmg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496gat2feh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 17:16:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FFAAEM022316;
	Mon, 15 Sep 2025 17:16:04 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kxpfk5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 17:16:04 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FHG3JY28312314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 17:16:03 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F377058058;
	Mon, 15 Sep 2025 17:16:02 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F9355805B;
	Mon, 15 Sep 2025 17:16:02 +0000 (GMT)
Received: from [9.61.244.242] (unknown [9.61.244.242])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 17:16:02 +0000 (GMT)
Message-ID: <cd1fa387-df80-4756-a2dc-5acdd0f09697@linux.ibm.com>
Date: Mon, 15 Sep 2025 10:15:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/10] PCI: Avoid saving error values for config space
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        helgaas@kernel.org, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
References: <20250911183307.1910-1-alifm@linux.ibm.com>
 <20250911183307.1910-2-alifm@linux.ibm.com>
 <20250913092709.2e58782d.alex.williamson@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250913092709.2e58782d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BKWzrEQG c=1 sm=1 tr=0 ts=68c849d5 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7ShtpSrotxfIQnzH-x0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: nguE7s-SaO93ZD5vfbu3cCLJ4fUP4Zr5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDA4NiBTYWx0ZWRfXx27Yvp/YKJlf
 DBUqCiEb2BckzbXw6GOuWarGUqcRYhSq5Az+pM7qHjf6Ci5ebATFUHuXBsQHOzaJMJhX3/aP8pM
 RyfcGayKZDics4vS5iq/I2uXNVoywKYUw6oaLrnw9EwpqOcDxdhleTGWWkyNupF9p9fSPalqd0d
 lmDaE0z01BDlS+pS476p3mB2YjRXJdU9vVy49m8rVj6tu7NasTxojbrNpSUpB3I9UKwytQBOwob
 9vonT7ymuymrGYi78kUObCUE0lxL3QvfkV5eR72+FODRxAJkhVQkInitCcZiJ8VGDTiqFutHZsN
 zCqTymTBkTK+zI/sXTu0p51fYXe/8ApZGKmu3C/wuNUz+ewLRpVS2R+adA1RGpLT438qlwS1O9v
 xg2Z04jY
X-Proofpoint-ORIG-GUID: nguE7s-SaO93ZD5vfbu3cCLJ4fUP4Zr5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_06,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150086


On 9/13/2025 1:27 AM, Alex Williamson wrote:
> On Thu, 11 Sep 2025 11:32:58 -0700
> Farhan Ali <alifm@linux.ibm.com> wrote:
>
>> The current reset process saves the device's config space state before
>> reset and restores it afterward. However, when a device is in an error
>> state before reset, config space reads may return error values instead of
>> valid data. This results in saving corrupted values that get written back
>> to the device during state restoration.
>>
>> Avoid saving the state of the config space when the device is in error.
>> While restoring we only restorei the state that can be restored through
> s/restorei/restore/

Thanks for catching that, will fix.

>> kernel data such as BARs or doesn't depend on the saved state.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/pci/pci.c      | 29 ++++++++++++++++++++++++++---
>>   drivers/pci/pcie/aer.c |  5 +++++
>>   drivers/pci/pcie/dpc.c |  5 +++++
>>   drivers/pci/pcie/ptm.c |  5 +++++
>>   drivers/pci/tph.c      |  5 +++++
>>   drivers/pci/vc.c       |  5 +++++
>>   6 files changed, 51 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index b0f4d98036cd..4b67d22faf0a 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -1720,6 +1720,11 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
>>   	struct pci_cap_saved_state *save_state;
>>   	u16 *cap;
>>   
>> +	if (!dev->state_saved) {
>> +		pci_warn(dev, "Not restoring pcie state, no saved state");
>> +		return;
>> +	}
>> +
>>   	/*
>>   	 * Restore max latencies (in the LTR capability) before enabling
>>   	 * LTR itself in PCI_EXP_DEVCTL2.
>> @@ -1775,6 +1780,11 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
>>   	struct pci_cap_saved_state *save_state;
>>   	u16 *cap;
>>   
>> +	if (!dev->state_saved) {
>> +		pci_warn(dev, "Not restoring pcix state, no saved state");
>> +		return;
>> +	}
>> +
>>   	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
>>   	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
>>   	if (!save_state || !pos)
>> @@ -1792,6 +1802,14 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
>>   int pci_save_state(struct pci_dev *dev)
>>   {
>>   	int i;
>> +	u16 val;
>> +
>> +	pci_read_config_word(dev, PCI_DEVICE_ID, &val);
>> +	if (PCI_POSSIBLE_ERROR(val)) {
>> +		pci_warn(dev, "Device in error, not saving config space state\n");
>> +		return -EIO;
>> +	}
>> +
> I don't think this works with standard VFs, per the spec the device ID
> register returns 0xFFFF.  Likely need to look for a CRS or error status
> across both vendor and device ID registers.

Yes, I missed that. Though the spec also mentions both vendor and device 
id registers can be 0xFFFF for standard VFs. The implementation note in 
the spec mentions legacy software can ignore VFs if both device id and 
vendor id is 0xFFFF. So not sure if checking both would work here?

Also by CRS are you referring to Configuration Request Retry? (In PCIe 
spec v6 I couldn't find reference to CRS, but found RRS so its probably 
been renamed to Request Retry Status). Based on my understanding of the 
spec a function will return CRS after a reset, but in this case we are 
trying to read and save the state before a reset? Based on 
pci_bus_rrs_vendor_id(), on a CRS vendor ID returned would be 0x1, but 
that wouldn't work for s390 as currently reads on error will return 
0xFFFF. Apologies if I misunderstood anything.

I see pci_dev_wait() check for command and status register in case RRS 
is not available, would that be appropriate check here?


>
> We could be a little more formal and specific describing the skipped
> states too, ex. "PCIe capability", "PCI-X capability", "PCI AER
> capability", etc.  Thanks,
>
> Alex

Makes sense, will update the warn messages.

Thanks
Farhan

>
>>   	/* XXX: 100% dword access ok here? */
>>   	for (i = 0; i < 16; i++) {
>>   		pci_read_config_dword(dev, i * 4, &dev->saved_config_space[i]);
>> @@ -1854,6 +1872,14 @@ static void pci_restore_config_space_range(struct pci_dev *pdev,
>>   
>>   static void pci_restore_config_space(struct pci_dev *pdev)
>>   {
>> +	if (!pdev->state_saved) {
>> +		pci_warn(pdev, "No saved config space, restoring BARs\n");
>> +		pci_restore_bars(pdev);
>> +		pci_write_config_word(pdev, PCI_COMMAND,
>> +				PCI_COMMAND_MEMORY | PCI_COMMAND_IO);
>> +		return;
>> +	}
>> +
>>   	if (pdev->hdr_type == PCI_HEADER_TYPE_NORMAL) {
>>   		pci_restore_config_space_range(pdev, 10, 15, 0, false);
>>   		/* Restore BARs before the command register. */
>> @@ -1906,9 +1932,6 @@ static void pci_restore_rebar_state(struct pci_dev *pdev)
>>    */
>>   void pci_restore_state(struct pci_dev *dev)
>>   {
>> -	if (!dev->state_saved)
>> -		return;
>> -
>>   	pci_restore_pcie_state(dev);
>>   	pci_restore_pasid_state(dev);
>>   	pci_restore_pri_state(dev);
>> diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
>> index e286c197d716..dca3502ef669 100644
>> --- a/drivers/pci/pcie/aer.c
>> +++ b/drivers/pci/pcie/aer.c
>> @@ -361,6 +361,11 @@ void pci_restore_aer_state(struct pci_dev *dev)
>>   	if (!aer)
>>   		return;
>>   
>> +	if (!dev->state_saved) {
>> +		pci_warn(dev, "Not restoring aer state, no saved state");
>> +		return;
>> +	}
>> +
>>   	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ERR);
>>   	if (!save_state)
>>   		return;
>> diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
>> index fc18349614d7..62c520af71a7 100644
>> --- a/drivers/pci/pcie/dpc.c
>> +++ b/drivers/pci/pcie/dpc.c
>> @@ -67,6 +67,11 @@ void pci_restore_dpc_state(struct pci_dev *dev)
>>   	if (!pci_is_pcie(dev))
>>   		return;
>>   
>> +	if (!dev->state_saved) {
>> +		pci_warn(dev, "Not restoring dpc state, no saved state");
>> +		return;
>> +	}
>> +
>>   	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_DPC);
>>   	if (!save_state)
>>   		return;
>> diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
>> index 65e4b008be00..7b5bcc23000d 100644
>> --- a/drivers/pci/pcie/ptm.c
>> +++ b/drivers/pci/pcie/ptm.c
>> @@ -112,6 +112,11 @@ void pci_restore_ptm_state(struct pci_dev *dev)
>>   	if (!ptm)
>>   		return;
>>   
>> +	if (!dev->state_saved) {
>> +		pci_warn(dev, "Not restoring ptm state, no saved state");
>> +		return;
>> +	}
>> +
>>   	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_PTM);
>>   	if (!save_state)
>>   		return;
>> diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
>> index cc64f93709a4..f0f1bae46736 100644
>> --- a/drivers/pci/tph.c
>> +++ b/drivers/pci/tph.c
>> @@ -435,6 +435,11 @@ void pci_restore_tph_state(struct pci_dev *pdev)
>>   	if (!pdev->tph_enabled)
>>   		return;
>>   
>> +	if (!pdev->state_saved) {
>> +		pci_warn(pdev, "Not restoring tph state, no saved state");
>> +		return;
>> +	}
>> +
>>   	save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_TPH);
>>   	if (!save_state)
>>   		return;
>> diff --git a/drivers/pci/vc.c b/drivers/pci/vc.c
>> index a4ff7f5f66dd..fda435cd49c1 100644
>> --- a/drivers/pci/vc.c
>> +++ b/drivers/pci/vc.c
>> @@ -391,6 +391,11 @@ void pci_restore_vc_state(struct pci_dev *dev)
>>   {
>>   	int i;
>>   
>> +	if (!dev->state_saved) {
>> +		pci_warn(dev, "Not restoring vc state, no saved state");
>> +		return;
>> +	}
>> +
>>   	for (i = 0; i < ARRAY_SIZE(vc_caps); i++) {
>>   		int pos;
>>   		struct pci_cap_saved_state *save_state;

