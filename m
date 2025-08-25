Return-Path: <kvm+bounces-55695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F80B34ED3
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9E1E1A86E0E
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A22F2C0272;
	Mon, 25 Aug 2025 22:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YCq7dl3K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4804129D26C;
	Mon, 25 Aug 2025 22:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756159989; cv=none; b=WmUPyTlvLEwhcJIkZ9y4hBKeY314WGxlO77fgHDAa3CLVTqBZdrThPukGs7yphdC9NfBPi/hIYUZ303XtQI/VkkmS4GT4irMyFPd/h8iqqwDhgB7SJ4pg7oPGohMZ5FteBjNoZv189WpPgreI81mqT2TcKmRGm/45BI50iVJUfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756159989; c=relaxed/simple;
	bh=nCgLZq+Bjog5ABi50odhp9MVlvPuOobFM7/lK0PDoe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FA//lyaezClkF7hZIvWvP5SmDWWOQOVrTkM+1iGkU7stRgnwh7Ntc+v3Ad3vPnhd4yyZF6FyfSwN3jMVLqPLoSh8ALHbJSfwmh0vEvvmrE1o3YJwUmxa98icNJCuyYEJzGfv+YTt70VBl1Cy5MHGexRrJi3NhBDwdwIFiHFpgtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YCq7dl3K; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PBsU14016193;
	Mon, 25 Aug 2025 22:13:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DyDoJL
	FXNMakEJaMTwqN45/jMb1VkpAiNUcp8C+rdyQ=; b=YCq7dl3KCHzzxXyv23LA19
	EtikebqzIPjxxsJ3LHoEbFFRC2LD/fFdK8u302YbmI39Yb9Lrra3x/Ehzp9hu9pJ
	fNZNAnyjHlE/af9+tUWaD+NKCySGGUVNS4M/XCO4JwZNyqhZLt4tctBa8FofCuVt
	YOOC1wDlv4vux62rRzDPnx7CcLjx2BrsKLi7+n9qYbwm+JuoV0Y/GR2FMmpYBn+9
	kmKAXeiENFG0Xnb+hDJXwV5hWuSRFGhw2/MhfhqRqqTEEnngydDGsfXlEQHMVemK
	E/S4PF/5YEnICb+bX/bNk2vxPGEmM6V754UmC9YwBDtba/OefcnytSlGS0j5B+nw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q9752rss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 22:13:03 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PL4Ouj007443;
	Mon, 25 Aug 2025 22:13:02 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qqyu85pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 22:13:02 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PMD1nI17760858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 22:13:01 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 281DF58055;
	Mon, 25 Aug 2025 22:13:01 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 653E458056;
	Mon, 25 Aug 2025 22:13:00 +0000 (GMT)
Received: from [9.61.255.253] (unknown [9.61.255.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 22:13:00 +0000 (GMT)
Message-ID: <eb6d05d0-b448-4f4e-a734-50c56078dd9b@linux.ibm.com>
Date: Mon, 25 Aug 2025 15:13:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] PCI: Avoid restoring error values in config space
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, helgaas@kernel.org,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
References: <20250825171226.1602-1-alifm@linux.ibm.com>
 <20250825171226.1602-2-alifm@linux.ibm.com>
 <20250825153501.3a1d0f0c.alex.williamson@redhat.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20250825153501.3a1d0f0c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OUWsI00jKyAjQRJNHTiR5T5oouzZqu1k
X-Proofpoint-ORIG-GUID: OUWsI00jKyAjQRJNHTiR5T5oouzZqu1k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDA3MSBTYWx0ZWRfX3iuVkrgpd4ji
 BTljPbZ3Ij89GncidmkvL/4QkCwWtQdVdsCmbCxVy4M9T4AaEwEIVjTm5FN8TLUWb+ptm8MCGNQ
 RC1lm+5K3eTQ0jRcPoTatx8GeUJ/5jln7K0m9q6txwe2k6UepjZ4lV1jxsTVLpCm40GPdpIJ9Sk
 giHSKFjEnLf6UVWRjPV6McDGYQ2/3JkXIRce8hpnC/3IfSPBcby+bzF4LBXvg2oDp7FY+oNeyMd
 fFIxHi3Yq8LcTRhP3OBbn3Xa7pnPRR9PDAVdXofCRzCBPAAnggcFn2479X7/IqE+h03RBudO4E0
 XYckIt6iK/tZZHp2Vki6Ay0DGewEVkSCi8IjUu/fLA5tXfaKvwF/kSt3spB+SGiQaLGQKvby3As
 qJjOVEwi
X-Authority-Analysis: v=2.4 cv=RtDFLDmK c=1 sm=1 tr=0 ts=68acdfef cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=ZxKYActtXN1U2Ine1k4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_10,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230071


On 8/25/2025 2:35 PM, Alex Williamson wrote:
> On Mon, 25 Aug 2025 10:12:18 -0700
> Farhan Ali <alifm@linux.ibm.com> wrote:
>
>> The current reset process saves the device's config space state before
>> reset and restores it afterward. However, when a device is in an error
>> state before reset, config space reads may return error values instead of
>> valid data. This results in saving corrupted values that get written back
>> to the device during state restoration. Add validation to prevent writing
>> error values to the device when restoring the config space state after
>> reset.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/pci/pci.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index b0f4d98036cd..0dd95d782022 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -1825,6 +1825,9 @@ static void pci_restore_config_dword(struct pci_dev *pdev, int offset,
>>   	if (!force && val == saved_val)
>>   		return;
>>   
>> +	if (PCI_POSSIBLE_ERROR(saved_val))
>> +		return;
>> +
>>   	for (;;) {
>>   		pci_dbg(pdev, "restore config %#04x: %#010x -> %#010x\n",
>>   			offset, val, saved_val);
>
> The commit log makes this sound like more than it is.  We're really
> only error checking the first 64 bytes of config space before restore,
> the capabilities are not checked.  I suppose skipping the BARs and
> whatnot is no worse than writing -1 to them, but this is only a
> complete solution in the narrow case where we're relying on vfio-pci to
> come in and restore the pre-open device state.
>
> I had imagined that pci_save_state() might detect the error state of
> the device, avoid setting state_saved, but we'd still perform the
> restore callouts that only rely on internal kernel state, maybe adding a
> fallback to restore the BARs from resource information.

I initially started with pci_save_state(), and avoid saving the state 
altogether. But that would mean we don't go restore the msix state and 
for s390 don't call arch_restore_msi_irqs(). Do you prefer to avoid 
saving the state at all? This change was small and sufficient enough to 
avoid breaking the device in my testing.

>
> This implementation serves a purpose, but the commit log should
> describe the specific, narrow scenario this solves, and probably also
> add a comment in the code about why we're not consistently checking the
> saved state for errors.  Thanks,
>
> Alex
Yes, I can re-word the commit message.

Thanks
Farhan

