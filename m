Return-Path: <kvm+bounces-34582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3036EA023B7
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:01:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E02787A1BBA
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 11:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEE91DC9A5;
	Mon,  6 Jan 2025 11:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Pc+4eojU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6670E1DC98D;
	Mon,  6 Jan 2025 11:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736161251; cv=none; b=NTLV7lOQjWjJPQrPOiv7FLCLrVJ/mlosSuDxW9Zwml3jbqONLlKjWGJR8AYeDQwxCK0ylH8Y4noJJK89hnZfPbioXlEdViEo0cKKDTVfk0x6jF70RNUDM/zxXag6+lSlcURTmeBfBkPLDlhLqeKCgKWTqsTjfmcdxCzbpEia0eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736161251; c=relaxed/simple;
	bh=epVUt6AtXxe7XJ0RVS9/SuPxMM19T7pb+boWvz5D5eg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=keVyJOtJpQ13mEjL8w/ixpkaFv8TgOqsJ8CyyoFSWOm9+n6oPoA1fXoKPxCsWrGxmjkq1BwIUGZlCdsF9C29La5UeqEkg0UWfkYdIuJWB/bGuDl9oUxeLeNd84TJCyTXewNUm1ulz85DgggW5iEQKgIslNd0/3hPZYLXlAvAV4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Pc+4eojU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 505NainT007036;
	Mon, 6 Jan 2025 11:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=MMvOnQ3PAmRpfPa+4Bal1+FvmYfaAW
	4Wgr8onGT7XMg=; b=Pc+4eojU4+ztWQVNTlA7JVUyRDicaiYpV8T1V3Tg1fLvt7
	j/e835ZUnDKtkIFWY1uFoGjPppSPPe5ZOojIcNJrDdo8sSMRNrPcoQnPBur0Pc9R
	Aod+kl+X8RbyyhhkDrqTtm344r05jWOEekCavFLIshb/YXPmD1rBVz73djRYXa1v
	HV9k9agOGWp2ATDMLGwzER1GBSBzMHKTDTFEK1CuJn3EvexHL286bnpzQglzgD/4
	LPaNiZNymDVa1F+aY4uxc+JLc2znsoXae+BJ33pYLuNZI+/rAERt/iDB56ue+Vqd
	pvAB+zKyXhdI0QqFewQxmP+DvqSIQwFaRdfhMbCg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4403waj459-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jan 2025 11:00:37 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 506B0bN2007285;
	Mon, 6 Jan 2025 11:00:37 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4403waj456-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jan 2025 11:00:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5067A2dn026179;
	Mon, 6 Jan 2025 11:00:36 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yj11w2pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jan 2025 11:00:36 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 506B0XbU18022732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Jan 2025 11:00:33 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C0952004B;
	Mon,  6 Jan 2025 11:00:33 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D3532004D;
	Mon,  6 Jan 2025 11:00:29 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.19.130])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  6 Jan 2025 11:00:28 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Mon, 06 Jan 2025 16:30:27 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Gautam Menghani <gautam@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-doc@vger.kernel.org,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan
 <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, kconsul@linux.ibm.com, amachhiw@linux.ibm.com
Subject: Re: [PATCH 1/6] [DOC] powerpc: Document APIv2 KVM hcall spec for
 Hostwide counters
In-Reply-To: <fimq6f367gj3ypuke2slogz4i3zt4jfst4kwnrlzps3xinkoh5@arkajtap562s>
References: <20241222140247.174998-1-vaibhav@linux.ibm.com>
 <20241222140247.174998-2-vaibhav@linux.ibm.com>
 <fimq6f367gj3ypuke2slogz4i3zt4jfst4kwnrlzps3xinkoh5@arkajtap562s>
Date: Mon, 06 Jan 2025 16:30:27 +0530
Message-ID: <87r05g1a2c.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bWikSTz9elmrjbakW7_8KUhkOTrKYI1O
X-Proofpoint-ORIG-GUID: HP5fThnEfEFF-rv-yt2L2GsciEvMNfBi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 adultscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501060097

Hi Gautam,

Thanks for reviewing this patch. My responses to your review comments
inline below:

Gautam Menghani <gautam@linux.ibm.com> writes:

> On Sun, Dec 22, 2024 at 07:32:29PM +0530, Vaibhav Jain wrote:
>> Update kvm-nested APIv2 documentation to include five new
>> Guest-State-Elements to fetch the hostwide counters. These counters are
>> per L1-Lpar and indicate the amount of Heap/Page-table memory allocated,
>> available and Page-table memory reclaimed for all L2-Guests active
>> instances
>> 
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> ---
>>  Documentation/arch/powerpc/kvm-nested.rst | 40 ++++++++++++++++-------
>>  1 file changed, 29 insertions(+), 11 deletions(-)
>> 
>> diff --git a/Documentation/arch/powerpc/kvm-nested.rst b/Documentation/arch/powerpc/kvm-nested.rst
>> index 5defd13cc6c1..c506192f3f98 100644
>> --- a/Documentation/arch/powerpc/kvm-nested.rst
>> +++ b/Documentation/arch/powerpc/kvm-nested.rst
>> @@ -208,13 +208,9 @@ associated values for each ID in the GSB::
>>        flags:
>>           Bit 0: getGuestWideState: Request state of the Guest instead
>>             of an individual VCPU.
>> -         Bit 1: takeOwnershipOfVcpuState Indicate the L1 is taking
>> -           over ownership of the VCPU state and that the L0 can free
>> -           the storage holding the state. The VCPU state will need to
>> -           be returned to the Hypervisor via H_GUEST_SET_STATE prior
>> -           to H_GUEST_RUN_VCPU being called for this VCPU. The data
>> -           returned in the dataBuffer is in a Hypervisor internal
>> -           format.
>> +         Bit 1: getHostWideState: Request stats of the Host. This causes
>> +           the guestId and vcpuId parameters to be ignored and attempting
>> +           to get the VCPU/Guest state will cause an error.
>
> s/Request stats/Request state
>
Its is 'Request stats' are this flag currently return Hostwide stat
counters.

>>           Bits 2-63: Reserved
>>        guestId: ID obtained from H_GUEST_CREATE
>>        vcpuId: ID of the vCPU pass to H_GUEST_CREATE_VCPU
>> @@ -402,13 +398,14 @@ GSB element:
>>  
>>  The ID in the GSB element specifies what is to be set. This includes
>>  archtected state like GPRs, VSRs, SPRs, plus also some meta data about
>> -the partition like the timebase offset and partition scoped page
>> +the partition and  like the timebase offset and partition scoped page
>>  table information.
>
> The statement that is already there looks correct IMO.
>
Right. I will update it to reflect L1-lpar stats in v2.
>>  
>>  +--------+-------+----+--------+----------------------------------+
>> -|   ID   | Size  | RW | Thread | Details                          |
>> -|        | Bytes |    | Guest  |                                  |
>> -|        |       |    | Scope  |                                  |
>> +|   ID   | Size  | RW |(H)ost  | Details                          |
>> +|        | Bytes |    |(G)uest |                                  |
>> +|        |       |    |(T)hread|                                  |
>> +|        |       |    |Scope   |                                  |
>>  +========+=======+====+========+==================================+
>>  | 0x0000 |       | RW |   TG   | NOP element                      |
>>  +--------+-------+----+--------+----------------------------------+
>> @@ -434,6 +431,27 @@ table information.
>>  |        |       |    |        |- 0x8 Table size.                 |
>>  +--------+-------+----+--------+----------------------------------+
>>  | 0x0007-|       |    |        | Reserved                         |
>> +| 0x07FF |       |    |        |                                  |
>> ++--------+-------+----+--------+----------------------------------+
>> +| 0x0800 | 0x08  | R  |   H    | Current usage in bytes of the    |
>> +|        |       |    |        | L0's Guest Management Space      |
>> ++--------+-------+----+--------+----------------------------------+
>> +| 0x0801 | 0x08  | R  |   H    | Max bytes available in the       |
>> +|        |       |    |        | L0's Guest Management Space      |
>> ++--------+-------+----+--------+----------------------------------+
>> +| 0x0802 | 0x08  | R  |   H    | Current usage in bytes of the    |
>> +|        |       |    |        | L0's Guest Page Table Management |
>> +|        |       |    |        | Space                            |
>> ++--------+-------+----+--------+----------------------------------+
>> +| 0x0803 | 0x08  | R  |   H    | Max bytes available in the L0's  |
>> +|        |       |    |        | Guest Page Table Management      |
>> +|        |       |    |        | Space                            |
>> ++--------+-------+----+--------+----------------------------------+
>> +| 0x0804 | 0x08  | R  |   H    | Amount of reclaimed L0 Guest's   |
>> +|        |       |    |        | Page Table Management Space due  |
>> +|        |       |    |        | to overcommit                    |
>
> I think it would be more clear to specify "... Management space for L1
> ..." in the details of all above entries.
>
Agree, Updated that in v2.

>> ++--------+-------+----+--------+----------------------------------+
>> +| 0x0805-|       |    |        | Reserved                         |
>>  | 0x0BFF |       |    |        |                                  |
>>  +--------+-------+----+--------+----------------------------------+
>>  | 0x0C00 | 0x10  | RW |   T    |Run vCPU Input Buffer:            |
>> -- 
>
> Also, the row 2 of this table mentions the 'takeOwnershipOfVcpuState' flag
> which is no longer supported. You can remove that as well.
>
Updating this document for 'takeOwnershipOfVcpuState' will be done as a
separate patch and not part of this patch series

>> 2.47.1
>> 
>

-- 
Cheers
~ Vaibhav

