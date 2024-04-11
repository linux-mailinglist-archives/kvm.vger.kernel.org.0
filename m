Return-Path: <kvm+bounces-14227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9221D8A0AC8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 10:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8DA9B21B5D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 08:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DFE13F01E;
	Thu, 11 Apr 2024 08:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RQfAMumc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AXGH2R2C"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20B913E3F1;
	Thu, 11 Apr 2024 08:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712822496; cv=fail; b=jyB5ueEIC/QfGW0bAaru8gFjDS7MFIOoh/AnZprnC1MVmaIa9mH74RnMkxgPTYQT5rdYoluqk8D668i0nydVzqcChPrwLpCgWxI2ZGqiYDbg901Kfbp1fAImMymAcEd1AgdjY4WwNyGVp10/D1ML2TfvPQQplkMDNiC4aIhRqWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712822496; c=relaxed/simple;
	bh=5FyS4gOwUG2o0sEl6es4ubGLoVKgyMc+hi3zxukiu/o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ui/hb4KZ8DFhguuR42UCDHj7LuFz0a0gRDzJk06MltpPx0K3XypMhiUEZAhupTcQeZb3zTfuaL1ZJLWMYhSWKI12U2m4R5xUBNwrIvmPF+VF1D+mERerq1U/rJsknnYz+gY5maxCQaEFnZEe7GnLpuIG6GaQXIlMemX4kD0VkH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RQfAMumc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AXGH2R2C; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43B75fH1016093;
	Thu, 11 Apr 2024 08:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=kTvvMmV+x2zettTB2uz4uENl41dDkJEHmbMseE6edWk=;
 b=RQfAMumcMLGpD7HL2JXNEAMkd1DJVJowFPeTnk3ru7rsjepwIKNhHBzI6hfuCe5hlcfP
 vNu1vv5Y+w8pSY2i6IEles9s8IeNVeBZ3tZLDPPAU0XoNxnnpDKuzPLQb/wqxcWizLht
 uXocYz2QfEEv7hAVRp/IK7ppL/MgBM6OegXkgpnkgRpHmd9gw2Kfb/Th3f0YclRDP/Jg
 h3+G3VWtbGuQoeYEbX8hcEr6QDjt288jJ5Qc4tZ/BxKelN3KOGFJtdbON8v1iAVWaHOd
 3aT+ybvhnyW0I9ak9Vk2zf6s/43I4emVyYhxt1RiGMLpuXEpUYHs3nXusq04NewpOUxC Rw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaw0294nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 08:00:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43B7Cg0x010532;
	Thu, 11 Apr 2024 08:00:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu97egw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 08:00:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=og7SvdYcGUaCwLf35IrYkZWBOwjuqrYYEOuJ9iY5ien90CCkF9hFGPvRkb99+V/scTNfPuqPkTmlJaHh8jOz9BCj6qo8C3ICa5P3opGc7WYxd8QEcX/Qx66PgoyEzjiy5Pr91z7G7ghIrR9H5hRyF4UIfmNO8RnBDNLimWiBTJYzLXhkr2pOYDvyBhEA3/i3rOuy9ixNOGPnvN2sloA5vAcsVNjnwHdy2kJJ0jh9Azp6fgdgyvB2HLb6F9t+telFlirWbMO0+UIzAqp2vsgQsucJOmzYi0E03Ye52/ZoJLw0HzCk/Agt1/khZyijkd2Fv9jJ/uwGOn5TBE7FM5UYZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTvvMmV+x2zettTB2uz4uENl41dDkJEHmbMseE6edWk=;
 b=Zbe0aU9zlA/asTt1GZlvqEvjl7kdFB757no3mkUdxA30sns2CjVj/Mh6bbvBr198w16hJUVLqEpGBr6I1+FMHGG/IziD/Xzvz0dmPzpoOqFaw1+b05rUROArXr2sOhUF4jHW2RXaCsfSxldnr3t3+oBtOJle6NRs1Qj5aEWWIC/GLTQVATM/AiHL8aasBSqNmcxeptelvPhsMtf2bkm9qoeAth82NY9gKuYm9sNh/DLKbgXT9id8Oy4GV9ozTDjw0mA5mY9hsMSyE5NojESOBCY1RvnlNmg9KsEC2z4PnhSDqqXT8UuVz6hc+v3UmxeB2C1yxULXIhv1LmrE0ry+mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTvvMmV+x2zettTB2uz4uENl41dDkJEHmbMseE6edWk=;
 b=AXGH2R2C0xg17lgN/Ha03fCvOxwphSyQgAbAr6c/P1XJTR3VJ/R8fhO1deuSJwoRlW6GrXRlWWkDn76ERVNDOYtWHPyGcsVcJpNf0kdFE5J2z53S0oNVHa/539PrQmbFmPLsNjEn4RGTXBWGoVLcu78GWjh5u/UMGbIM+XnC78Y=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by SN4PR10MB5655.namprd10.prod.outlook.com (2603:10b6:806:20e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Thu, 11 Apr
 2024 08:00:44 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44%5]) with mapi id 15.20.7409.053; Thu, 11 Apr 2024
 08:00:44 +0000
Message-ID: <1c95ede4-7b8c-47c9-b5c4-3f2e5e202b09@oracle.com>
Date: Thu, 11 Apr 2024 10:00:37 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
        seanjc@google.com, andrew.cooper3@citrix.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <2024041127-revival-nifty-8396@gregkh>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <2024041127-revival-nifty-8396@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0399.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::8) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|SN4PR10MB5655:EE_
X-MS-Office365-Filtering-Correlation-Id: af4a6871-012b-4274-93c7-08dc59fd7cb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	9lMIrl8ioIoYWSk/fS8pFOp4Ah+opypNBusTo1km3QMFCQVZfkka994HnRv8WvMD8a2ltHems9Asrwwqw2SuqABg41BWvcjwmXgpPEYDC48KalPaj3Y1WnVoG302a9ZDJX9Md+S45ieoYqgfuGPbTYOWs4r42xKbYhqMbw0qJrblQrxNC2miJojz6wLRfPLmCTHBQbwwVbOKojTSoQPdJyDA9f2ce0dIgLelodgrEopMRvMt0C9/FELlf/QiAi/Nv3mfqBDkgWqPqBRcfrj8OPgfpQZUjUsILb5svlKb2o+igZb6HgQ+Y9IYeSUeNok/htp91zFldYewOwM8Nhn4EM33Fv2DbO+MJKQy7DXqGdNts1B4upoZMpTDq1Zriw87qBQ6j5j1+vW6/QZpesTKJyV8d2WydL0g7U5DidhLoYOc+QLS/oRqRoKZMcWzF0LM9+F1oQ6w6F4THJav1/TeLOKex37qIcrAkzKCtJrTAuwTdFeNm/RCPuu1J2Xvth8Ge3xkf6uNf8VG5BBKgY7UH5K9pGLOiLV2z8im+/rBv6n6Sh+F2ASaWRi8uIF6KaG0ok4GbMvi94+P/cEyICzgZPQvrZ1CRrJ0Y9+aJ99He4Xju97klNrPKp7Q1hEZbuUfF3c5xJ4GDk5xmrNfDhN+ikmm5dXaAiT3u0mXmzgmLw8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WWlkbWFaWVZRS2pBUjlYbDhtd2toWVNXVTBoZmFEemcwUXY2UW13M2xZS1hY?=
 =?utf-8?B?UDQ3NmV4eEFaUSt5T1BnWXZYN2dFVG10Rmh4amt6YkRFRlZWcEQ0bGVLck02?=
 =?utf-8?B?UVNSMFJUUE5mM3Y4ZVNhRlJGdEx0Nm5zcFNsRkxNY1ZqWkVoaWoyM3d1Z2RX?=
 =?utf-8?B?QjQxZ0t0dHlaQW03ZUFnNUkwR1h6UUpWUVFySmVwVTV1Y1gvUzYrcElYUk1p?=
 =?utf-8?B?MGJFbU9Vdy9qcHluQWZCNDhHa1VFYXRZWS96dE5CMWVSWnE2ZnY0T2xaK2dZ?=
 =?utf-8?B?b3kreUlLbit3MzJ5WGloN2lWSndvdkRhZU8zS2Z4cm1lcDVsOFhZUS92LzY2?=
 =?utf-8?B?cElXb1R4UU82VlpvUDdKQmhqV2hsN0dvT3VKYnl3d3hIeVdPSWk4Q2cxL3Iy?=
 =?utf-8?B?bE9FL0dPUG5Tb25kWnZEMXVJaEdGNDRWMFZCcnMrM2tjOTYzOGRDa2I3NVk1?=
 =?utf-8?B?ZTEwZSt1eTJ6S0J6c1I0dWMxQ25vRmFKWE9zWUkzUEw1RDNMUGFPN1F4RUZo?=
 =?utf-8?B?b0MrWklZNk5JWkxaWk83ak5Ua1pkRjdKMGtqVzJ0SE9NeWthdlduRXJnc2Mx?=
 =?utf-8?B?ci9TR0pBNlcwdWdHM3FRd2JGdnRocnJQY3RiV3haWXpnVXBYY3dsQW5NNUFH?=
 =?utf-8?B?QmtQbVRiV3RldEk4TDY2M0dOTE9mcENLNk9MUWljMzRiTWp4QkhMZ2pML0Mz?=
 =?utf-8?B?RGdQSWFMODBGbHZMMmhiMVFRQWNBc29vc2tBQmxqazQvYnpVNU9XdXJ3NWhR?=
 =?utf-8?B?WDBhblNCRzZLMlFENE9KbWdzQm11SUpXL3lrUnhYNDZjaENWSDdFcWFRdi9V?=
 =?utf-8?B?Q05TMkxQWUdDRzJCY0tVRFFJc0tDdjM1WFJVaUdoOGEvcTZnWHVNcUF5eFRS?=
 =?utf-8?B?SlhFT3R4bFZiV0thSW00cllGcEQwR3Izd1F0SXFDMGZBTStLWThSK0xEdzFh?=
 =?utf-8?B?Yko2Mzl2V09hb09VVFFLRUsyMjZ6bnFTVzA0NXZ6M3pndFdJS1R3USthRUk3?=
 =?utf-8?B?S3d6QlFJKzVycnBjTW1zNHNsL3Fob1NhNmJmSENQK3dtVnI3aVZqbVY5Nk5W?=
 =?utf-8?B?bjMreDk3cFRHY21pQ0V2ZHNuSStjQ3JkNHVKREl6b044QnVIZDhNd3liRHl4?=
 =?utf-8?B?OVhLVm1pQ1pZeSt2dE52aGxLSnJIWDB0NGZPOTkrZytwb3NkcFZKUWVwbVVZ?=
 =?utf-8?B?dDMwQzgzemFpQ01jTjlpOFVGUDk4eldTOUlteDlkYlBKbXZtNytlUDNYdDlG?=
 =?utf-8?B?dFNjbE11eTQ3N1BiM01tZDIvWVdNYyt0OThQVmZzcGRYQXJVS1ZoVklWRlBz?=
 =?utf-8?B?N0VlWWNuWDlTcDBTOFVxNTZBYkFLMFMrYUJpSFlHQTFIdEN6aHVTWGltdk5a?=
 =?utf-8?B?akcxMitxNnd4cDhVeVJsRGUzKzZ6eXVWV3RmRE11MXFMeXExUGlmT2poWWZn?=
 =?utf-8?B?Uk9YMGZGTTlkQzA1MEtRa1JZK0J4b3pWT0dtMEtRZVdpWjE3bGhtSUJhc0tP?=
 =?utf-8?B?QUNYUzdSYTlUdFBUU1VCZ3FycEZPTW5jWVBZNmdTcnpjWVNuZW42VGhIa3N5?=
 =?utf-8?B?UXpjLzZ6eFlDQ2VtRkRGUUhhbVJCK0VONHpKM09lTCthVkJ5QjhyMWhpdkpQ?=
 =?utf-8?B?bFJBV0ovc0pzQlBlN0FwczMvanBvV3Exa0hhNFB1S2lRZkVBYWxSMjNidHJG?=
 =?utf-8?B?RG5kdXV3eEJPK2N4QlNxdlQ0YU1WVG1EcnZxUUw4a2NxYUxHbitHWEpDa3ky?=
 =?utf-8?B?YTB1SkwwTkFEVVl5N1pFU0JGZzJMNUVad0E1SmZyRVk5UWhqakFpQVhHR3Qz?=
 =?utf-8?B?eWM2ZVN2S1RUYjl1T1ZKYW1IM21GcVovS0c5dDJRK1gyVnNLM0FVSUtqK1pl?=
 =?utf-8?B?R3UvTWJJT1c0WGp4aS82Q2ZhNlhhV1BLSmJaLzFtdWc5TXZzZnRvbUE4Zkts?=
 =?utf-8?B?TlNSSFNmL0gzdWJWVEllSHFTN1hjaHJyR1c0aU5sUFhjVzAvNlpjSGlYQStS?=
 =?utf-8?B?S0NjZ1NWb09wZmFZcjdrOWJ6bWNLSWJIVVNNMzVTTTVQN3gzczUyc21MYUp2?=
 =?utf-8?B?RUw3SkxiQVVYRGI4QVNTb0s5UlBkMUE5UitiSVJNREFDVnFlVmdnVSt0eVhF?=
 =?utf-8?B?ZTlJaFRxWFBwMFlBVk5yZFM0d0dzUyt0Tk9wOU8rWEpCOWhxZ1RkN1NNdHlm?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	J4c1h2uRBM6puF3Wbaq1ImQfYixmqQO7VeuPFZvknjUJ+UvEIp3av5dXv3ZleiPtr0cAKV2FycUdyh6t2tgnaLryRGQNIEL3Q7xmMK93D+IiC5jY+BuzbaRWilMJP622ht5WC1dAC7lJ0bUqz22xF6u4q1jeOCTAUqzGrfCp8nrvPLrq4QkroK/DupGnxYhSYMlELC9ow8ATdoXdNqv2TQfEc0ll5J7zb7zMOYr2AzsKeGPu/RRrmYN47rGgbd20SrQz3PsZLQlaeHb/25HTt+FDwXAt6m6JhLF7ipNLOjYiPZ2r7yKUOHSeBShLxuwDpWIxQ4oxO+2sovnUR8Ihw9stKQPBy3I7LcwGJRA4cOWNByHhXSFjScNOXkp1JZ5/fv5ikrB5BoijjwymjS/qK3CTHpr+8u++8VeA7ElKtxXXz8eC1qepjId4N84BHjdRXrt3IUQwj3EEyC7A01ZAhlgPU+J5uCjZ5VeJc639hqkuXGGwTcpKtJmQmycdX7BQzOBzMfT/4IJjt7nsL5+aqPEYuiZwQN9Mf/A3MsvCaO1BezOfThA/QGwDqk9KN0FOChyegGrq88085vIcYlEFmUcfVZLjfroGQPmrNFfFiZk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af4a6871-012b-4274-93c7-08dc59fd7cb9
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 08:00:44.0783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KBF5g8AopYNn4wb/DfSdAGf5bz7KtjXFizV50C6Vj7woCfbt/p6OAXRW8SDZ10x+vaLI12Jkod0yskAuklgQ7QfRWNeg+tuJSFujk5BgkGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5655
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_02,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110056
X-Proofpoint-ORIG-GUID: 5vlEvpTjT9BiIss5uC63mN7jdLoiuQtx
X-Proofpoint-GUID: 5vlEvpTjT9BiIss5uC63mN7jdLoiuQtx


On 4/11/24 09:51, Greg KH wrote:
> On Thu, Apr 11, 2024 at 09:24:45AM +0200, Alexandre Chartre wrote:
>> When a system is not affected by the BHI bug then KVM should
>> configure guests with BHI_NO to ensure they won't enable any
>> BHI mitigation.
>>
>> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> 
> No Fixes: tag here?
> 

This should have been done with commit ed2e8d49b54d ("KVM: x86: Add BHI_NO"), so:

Fixes: ed2e8d49b54d ("KVM: x86: Add BHI_NO")

Thanks,

alex.

