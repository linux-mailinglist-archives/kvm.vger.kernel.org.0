Return-Path: <kvm+bounces-14236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CBB8A0C7A
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 11:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7779285356
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10C214532B;
	Thu, 11 Apr 2024 09:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JrWlgRy3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RAYxij08"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2B3144D20;
	Thu, 11 Apr 2024 09:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712828036; cv=fail; b=NxW+vmCrPrQiUisIjNva8kbvJcn+98buoZLd7Dp+6qgqXTxuOXLgOYadNHejO8nXcr57zu4MslYiDaECpIWYGSK65XTURLN8EH55riuQtrN6SlxVfx1k1+4+5ShUWph4GWG2Ceg94zJTZFuoFAuWYgu4mfdtx6cw73zyWl4w+xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712828036; c=relaxed/simple;
	bh=XNCV3xf56pxbY5egLn2dlBGQ7z42WqHk5QXRzDyC/kc=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IsE+mwbzAHxbIKyl1GIR1KvyA4RZ0IG4M5gMoM7jvtWBjzrUjgqa2IjEOaA+5TaJzQrwrjvdNg38RocL2T5T2Eje4oim4YMbuyoqquYgXrDfkI7pV1l8l2rBhdJnfZ0doAYxrA1S13f4aJ8qf5r83sZDp7hlMEJHlEx+PRmvc8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JrWlgRy3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RAYxij08; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43B91qcO031639;
	Thu, 11 Apr 2024 09:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=WT09OwZto/osrQx19vqdlLj/d2zVCTwwM+LPobOM2cI=;
 b=JrWlgRy3Q3CqoxsIWptOYJlZSSMYHlEqs/FJxMT3BvrcuXNgSCIDEbEAVe9d+cy+7+xJ
 1QLmX+w8VldHkrJ4KOkCworazCky+F54ZxVclObS+lMkXFNGjzKGHbhuFmOZcIzEVo7U
 U+UBKR5hFbeZhDBcL6T6GEcQH6dNGVGoqdXLo7faCINlOIkP/mHz93EVliG3c/e22WE3
 nAfyVOsJPIGVRCmiqjwYMMYjj0m0/+W/CIo0twdGnEwaAsJUYKzN9BtpvuWks9MMmiAI
 zovpoEMlfdFhQwqMlDeXN+blt208d94gEJhhNxQc7MoLg16ml/vNHV3d+wV0XvjxJ7+y Ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax9b93f0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 09:33:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43B8WUML040072;
	Thu, 11 Apr 2024 09:33:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavufjs56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 09:33:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnjFoyJ15j7Z06Ssf7GTeHzwDw+EXwyDJvFuyIfCfUcNUcpep7ObkQ24K2Z+gji2Zlfes8rY2lQMcaG2ENVU179+v0efD50WVBSbybAUvMcrZ7/Q11X2Bs8v7YQv6vI/3zEaC7tlGDYY/qX12OejhaVJdshM0Dj1MzS1tTMuHES9elqAR1biio/LNrEu/Vt6sZsbVrodVaT4FEK38d3eWF7Y1EvTiq6Gm1JTii8qovIGeTFOFQDmhHNGXKGkCaDbVIi0kQmjLbnrGbz/eP5+v6CGn7aoO+VSBNQtLzC9c6gYbLvoTA2eYWyKLOTSreB0Ml89MqD9dVOTeufRmdm/Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WT09OwZto/osrQx19vqdlLj/d2zVCTwwM+LPobOM2cI=;
 b=U7yPLeMKQaYCxdfiw2KxJIE0N0n7lX5NwUQp48N6A19mp4j92+wvS91u3rsqhH37PkEo+40EocKpxE8nLdA8wcDCL6uBZA/9rec8iy70wH79mLWVojeQJ0xeQHj0i17GNOANp18/NSipiqwu/VSsKV/A1Qzq2EnvF5IFRNmfk0O7MZgd85u4AInfYyDuAoj5fTkyznmZiRK3cZTAKRXMTia48934BKP4zuY9ZYoZSqrb7FICBTxV5OIF8G7R/reSv/XeeheUrqUQ5Bh6WC+OelurUManFImXgFjT9Oc368QEdcNOopvTX6ma1jbYft/7Tks5/HeHn8Q4hjGcNEfX9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT09OwZto/osrQx19vqdlLj/d2zVCTwwM+LPobOM2cI=;
 b=RAYxij08HR79BBRgAZcYtfqhT90+FAh7Sv4Ap0RywXBE0QJSO3EbsKccrLjJ8gHGun1vuEAnJaxfJwrF+loeNXsxZ1eOCSCyzODm7Fi3RkI7a2l/4L/u/1Zi3gL/7k0DNqNvBMCcvwrw6fYpBl27/ulqJMReL9dOauQdb95wHTw=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by BLAPR10MB4978.namprd10.prod.outlook.com (2603:10b6:208:30e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Thu, 11 Apr
 2024 09:33:10 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44%5]) with mapi id 15.20.7409.053; Thu, 11 Apr 2024
 09:33:10 +0000
Message-ID: <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
Date: Thu, 11 Apr 2024 11:33:04 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Content-Language: en-US
To: Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org,
        kvm@vger.kernel.org
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::16) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|BLAPR10MB4978:EE_
X-MS-Office365-Filtering-Correlation-Id: ce825197-a73f-4086-7e52-08dc5a0a6719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	sSA7ZaRScEO69hrIaQmJKc/be+yMYIDHLEifFs+39+XPlY31PpTtonQJN5Jtk6unArP7offBtRD0lyRIUkwEr2tXiXKQufPTjk5RsBUbx4j0rKPj4yH932aGZxuQrhRfKoDMOSkUvDsipdEVXIk7ZTCBbnua5InOO8LYhRlX3fRBrwRy8hCoO3wKBSgnKdYtZfVQzEMDm1QNIrUzNzzuwe+SFQr6zCTD9lKPpOoyxLbHzfIR8pxqQLuHc9tWjkgri2reuHl5sX+QBaYomYD/fDYfdL4+PJnX1/DTjDcZPFNhh8pmzIpJVCEomUlo1uHl0eAoOKZrt8y1WQQtKkavmnQ9wkJkL2e87jmv8nqFXVOMCyTD+EKvzdgeqUELvnX41jTqweb2GBfEwMyN//DjL+PnsnyU7tW9VV/fUcYOhOWVhhD6I1oNHfZbfrHZ0nbXmF+qDzp30oXJmuIcOOqdLP/qhRcDM8lqrZ+YVcp5XFRUhwQYxgOS16WJIQWLJSCC/GylES6yzOvcJK0x4NTAi/yYZpHaC+uG7szPscvZ9+zznzF/CnGHGmnHIXpWbnlmgFm0LSISwanvivsuPfW5/L5F0Vow0uW4/2JgVle/x8k2Bpzlp/dTQHRaTI1j5YkdeKJfo968bjqh3k2OvmVvNw3aZdbgrUdwzx7nFUCO0Y4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dXpPaVB6QXBjdVlJdGdrOGk3U0VzU0EvTWFCWlVWUFdPRFlvMENVQ3JjUDd6?=
 =?utf-8?B?QzBTbDBzcHFoZTZKVFBKSWtMTzhDeTNGN0RUSHF2Z1dpUGY5RnZ6dnpjeVVR?=
 =?utf-8?B?ZFAvd1cwRWpzRlFMN3l0ZlJuak1RTVlmWkcwV1BvTkhRc3VzT2N4aUlPQzRw?=
 =?utf-8?B?T2dnTnpwUlE1K2RzcG9OeDBlR3pGSzBxN3I5OCtHSTBBdXhEbmw2aG9PUlE0?=
 =?utf-8?B?b0FydkR0MjZ1aHREVzFCVkpucHF2ZmthZGZLcTZrWW9pakFlb0RPNEQvcFdm?=
 =?utf-8?B?TlBZaXJ3TXFsT21jNVB0MEpuL25KOEFRQ3RJUUNmaGkxTXRlaFozcjFzTG1X?=
 =?utf-8?B?STlhWTQwbDlmVmd0V0ZSUTk4cXRWUnBxWnM3UXRsU3ZjdXRPUEYyS05SVS9H?=
 =?utf-8?B?TzR3dWRjYnVheEU3b3pjUVVKTklkNHNYTVdrYzF3WFFSRUhUUXJWSE1xdlYy?=
 =?utf-8?B?VDAxK2VlaGkranpoM2M2TDJCN2VROUU3bERwb05kcWc5QTRmM2JweGlpaGdt?=
 =?utf-8?B?MStFZ3RvVFUxTmpQUU1uWTJMNnhoOGF4L2FIZDdSWVY2YkF4OXJjMUdjTWta?=
 =?utf-8?B?QTRCWEVzNnJSK0l6S3F5T3JXVUp1cmI5cGk5R1VRV0hRRS8vMExIc3ByQi9X?=
 =?utf-8?B?cHVrOVNIc2lhMHlpQ1BDazFucktnWlpKVk41ZWNpakpiem5oMmJGa2ViYnQ4?=
 =?utf-8?B?SEdtSHFHQUszaVc3YVJiRVN2SG9QYncwS0hBZ2E5TjF5YnpKV01sSWNFZ0tz?=
 =?utf-8?B?RlJ4OEp0dTBWOWt4S3p1cWZiaW56YTdmTzJEcndWakI5dzArNE5DZ2h5KzJm?=
 =?utf-8?B?VEZCVHR0Vk1TZVRkUkc5bGovSmlwWnphSE5tOXgrTThnYVFYcjBiT21TbTJo?=
 =?utf-8?B?VDZybysyUjlVbkVhSlpFVU5iK09RQmJ5a0FmRWo4R0RhckdYUHJvS2pydlBp?=
 =?utf-8?B?V2gyMEN2RkpHSVBHMmdBZSt0ODRMdFZRYzZ6WGdFTUphZkI1Q01OVTRFY003?=
 =?utf-8?B?RnFyRHhRL2VLYWZyTDhHMlZTbFdRVnFkRE1nRGpLczh0Z0ZadUF4UENVWHdT?=
 =?utf-8?B?cmdIcXd1aWtNYnc3QVpOd0xUOXc5S3JiNW9weXd4cVlwSzM5NCszaWtmTzln?=
 =?utf-8?B?NWUxT0hFb2RVNExrdEsrNnZ4VGUxMXV4dXVncnJnUlRpQzhGSmR4V0xOUWJj?=
 =?utf-8?B?dWJlNm4velRhUkRoaEJLbm10aXpxVUpOOVV1T3I0bmxXUzl6TEZYZys3V0Yy?=
 =?utf-8?B?Qk9QenRRWUJ5ZzJrdlJ6SGd1aGkzNEd1aStja0o3RndUcnQ3RGNKbEJJbFBl?=
 =?utf-8?B?UUlVbzdKRU5ZcjNiSkJWR2oweG1qdHpaRHdlQ0lCTnNBV1R2Mk5GUFlmMUor?=
 =?utf-8?B?OW92cVBoYmFuVytXZWZNSmgyMW5CTHpHNU8xbVJlamZvOGxGMWtEdFl4U0hj?=
 =?utf-8?B?MExxMXdUTUkrNVgwb3MzWlloOXN1N0IyNm9PZWlEdkRuc0hiNkNZaG56RjFz?=
 =?utf-8?B?K3ROdVRGOXpmaG5uT1BhZFJGcUYzQVBoRmRVM3haU1h5Z0VjQldhZjFjMHl0?=
 =?utf-8?B?RkNCUDdyNUdnVUhvT1RKV3NFZnBCNVZ3dSt2Mi95ZWxNT0JjQWdrVUVMUFFR?=
 =?utf-8?B?bzFSWkE1TTlaYzdDOFNRTlZWcHMxY2FWRFlRd090WUtpWnpYSWtFdUZZWENh?=
 =?utf-8?B?NzBqVU8yWVd1SkNTTVZiS3JpdDViQnovQXJQZ0RXMkhPbDVUYUxGdk9GTWxQ?=
 =?utf-8?B?ejhKVHZnYmdkY2FyOG5yMTZlNlljbTFGakkrdGJWc2JrNkJ1OWxORnhCQVcr?=
 =?utf-8?B?YnY5RWtxUEkzRENGc2xPZTMzZDdUa1l6ZVpNanJ2MFYwb2w3K1BiVlYzQ2Mr?=
 =?utf-8?B?bXo1TzloVTB1MEVnbXZ6c3pLL2ViRXM0K09KQ3FKVmZPT0VZUEc5akdmdWJL?=
 =?utf-8?B?SmVNRUtjeE9wc25yZnRJTk1NdHUycnZqcnR3MlJJMHVTMGdHbldoKzZOVWxu?=
 =?utf-8?B?T2Z2SjdIV0t1NnBIWVZzUGtxbGgySUwzUlRsWUJOeXN2MWxvbUtnR0Vzc2VG?=
 =?utf-8?B?ZXBxLzNqYlNLRVR3UWE2S1RrM25VTTlRMVJxOXVVbG0zeVhLOG91WnhxWkF2?=
 =?utf-8?B?SWRCTGdaR05xVXg2S1M0eFc4R0RTMlRBdHVKdWVPRXBZWjFhUGp6dEwwOW1y?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	N0jZ81LlyDQo9fEDQwy7+SpYmzmUmCuVhFvr3QvLSwCrkT+Voq6xabUepdNK6g42pDBIiIc529ECyQ03eQomZumpfE1+A/DhrhP5Y2TMKhOw+0UXgifg6dYuUNQrCcxMcUGVM5SY0+pYVXXZlXncu8uLHsEqJfne+bn+gupTXx+MRWb1v195Iwi+jNQ4DQbavoX22C1e3cUnNrSGjbuapBgZK1HKdhEmzM89AOLQOK5MDKWsBcZZsoee7zEvXaCTZMpfmPiN7VIG4w34bAXIOTosu6Jgth/DFZCjQeA8ZWzY2kx8RdLKdJGt19YiB361yxkx1nhXEIDWPg2p3NDKU+hXG5Cwkl87PNJXuOBYw/n71K6s9wQlgoeeoAMiGIDXtclC29XpNSWCQauEk1njlVbZl/KFT7J3vYsqwfTdXehUHnMDhq7Y91Ty+Jk6lgy3iZsAAzX227bbPx+wBhcVDWCWCuxdiHvO6hPYHX/tDk6ROlNadxLaKh/7Vt+8ibm/MTkYUXdbs/Ymnct4tEBqBKWOv8tjZ3eseHf3XXDclNAbpTwc9VbG6ldDeA6UwB+UEDkfW1FJMMXL48KSX/TYz63id0zC35MLSLBmxDB+v30=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce825197-a73f-4086-7e52-08dc5a0a6719
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 09:33:10.7855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBdglWP6yl/u74YGa+NI+0C2Bz0qygYcvo54HYjD5afI/tjOizCMXUk19zveiVB7h0tUku/sUh6O8Ln7f2gukyImEQFaHRIeYo436/2W2S8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_03,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404110068
X-Proofpoint-GUID: _UYGKtuEz38Ip1SWRS1y9pzaULrH3f7b
X-Proofpoint-ORIG-GUID: _UYGKtuEz38Ip1SWRS1y9pzaULrH3f7b



On 4/11/24 10:43, Andrew Cooper wrote:
> On 11/04/2024 8:24 am, Alexandre Chartre wrote:
>> When a system is not affected by the BHI bug then KVM should
>> configure guests with BHI_NO to ensure they won't enable any
>> BHI mitigation.
>>
>> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>> ---
>>   arch/x86/kvm/x86.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 984ea2089efc..f43d3c15a6b7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1678,6 +1678,9 @@ static u64 kvm_get_arch_capabilities(void)
>>   	if (!boot_cpu_has_bug(X86_BUG_GDS) || gds_ucode_mitigated())
>>   		data |= ARCH_CAP_GDS_NO;
>>   
>> +	if (!boot_cpu_has_bug(X86_BUG_BHI))
>> +		data |= ARCH_CAP_BHI_NO;
> 
> This isn't true or safe.
> 
> Linux only sets X86_BUG_BHI on a subset of affected parts.
> 
> Skylake for example *is* affected by BHI.  It's just that existing
> mitigations are believed to suffice to mitigate BHI too.
> 
> "you happen to be safe if you're doing something else too" doesn't
> remotely have the same meaning as "hardware doesn't have a history based
> predictor".
> 

So you mean we can't set ARCH_CAP_BHI_NO for the guest because we don't know
if the guest will run the (other) existing mitigations which are believed to
suffice to mitigate BHI?

The problem is that we can end up with a guest running extra BHI mitigations
while this is not needed. Could we inform the guest that eIBRS is not available
on the system so a Linux guest doesn't run with extra BHI mitigations?

Thanks,

alex.

