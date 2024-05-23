Return-Path: <kvm+bounces-18076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 636288CD9FD
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 20:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B581CB228A9
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 18:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F5D763E6;
	Thu, 23 May 2024 18:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LeOzc9oE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L9BJ2mO4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1939B20DF7;
	Thu, 23 May 2024 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716489076; cv=fail; b=mc6QwGjdH67eMQKecm/txvSqGNgb4Clu0O3FmsRS+00zTQomH32heNgRr9of2EIxtwZJ49jTlHe15ZBdC1EI8OhSRz6koRLMIgnwjEvAoa4ShX6ke+MvVWNOrv6YABjwxCk+RHTVHLh/ziJ8G3gu76wzyk7QIKtQ+tslQOGHtfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716489076; c=relaxed/simple;
	bh=YRMEoF+BK6Bs3/zg3tXRrEs4L7HV22D5EqFBo5q3eBE=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pTZs3eKPawtOXX7s49i8OGQsHeqDsDqhab2IsOuwd4/rS0V28yw9/W2sWfmcKERGw3Nl6zlzJU6CQt7mo6KhBCDUyU5auS3DgJTsrEptnbvi/E7PSpWoMcNlVIhtG+LXx6hRTmO51BIzGqMzORm6Ec5/bC25mZee41SXE58Pc5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LeOzc9oE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L9BJ2mO4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NI7jwq006721;
	Thu, 23 May 2024 18:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=r3WQ3jSHp1Xxj4q6mgTpKiRyLyq6xJ6r5YbhVL6tJ4Q=;
 b=LeOzc9oEIXZuHcWt0uos1cKUY5Q83KGwRzXw1mNmnlNTfSuTfeSiu16yLYALoZKacKzO
 LD3At8zxmzyzt87NrtNHke9qABh71BnXDzNwrt6riCscP1/GMa0tSPxYDHSFLUMUoXXb
 uxR8uBQwzrX/g3qmmeNJF66DjiN+lgyCwC7qZ5oQnugOuiAaebJSUt8buWcQM80vjxXa
 E4kNdXnrmbaH/l2MwO7jA9jOzyS7hihia54DWFnRe6rlzwjzOv0TnBBel1lESRtFaUvv
 PeSWc7yK2l+tNu6A06rNXoDuPwuTJ1W4iai5cEW6Ozl29qfj4ubK3dcztiVU+5ZZm7U3 zA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mvvav4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 18:30:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44NGxSXE013792;
	Thu, 23 May 2024 18:30:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsacy4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 18:30:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xarsnjy3iPtkTL0jDaPPmPGWUs4wOeJFG58DtEBOuv5cYCqwNFVGo1T0grHmweI7hYpzlA6m4pHoY7mgE/WCXiFmF7RQS2HXd0n0YRc6cAVt9ckgO3TXUB3nG7iQiMettoX73x3HJH9AYlsKY+wlq6oGg3sfxSiAR9bkJAg6s0uDLavkrg3Xiqa7H9/GDND+fmBxmkpeCh2ezooGWUuyGfpHZdrYJ6Udv9lw6yy8aBp92uFhoZgfvOQUmB0/BXhNIYjJ54g9tSKwGSfmc3al4VfcB91GkZ6jKm516vhiai7G9Sxs0H0ng/plqfqjFqgPlYDOcfU9UNWQV4z7yCVGHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3WQ3jSHp1Xxj4q6mgTpKiRyLyq6xJ6r5YbhVL6tJ4Q=;
 b=WitCmFaxNY8AX48ekxHGiNApZ+OPv3BGiQpiV6p02MhIFQq7P/lZOV11z9KlCRmKrVbMPLuGWjGoVJ0YOkFcyxJi5HXgKwsntO53YAGPggVv0DvG1yw96KOy2fvJAcHYblOARaNls3CWg7xS7vWH6V7RfSY24PQoV2ZuWnvqRBTh0ADzfjxxMBq8yi7dkxjkZCg4mRW2APlRgmvozOxf5ndZEqmqAYrkx20Mu0fsUujtvh44ML+nNC9T84yOgxy9ecVoiC3IZHVJfDUEvk+5qxqiG+KxalGSiXXl6v/vfUFhumjdK0uGM9BnIy06vpkwxCUexIsIoh9L1a7ZqpcfKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3WQ3jSHp1Xxj4q6mgTpKiRyLyq6xJ6r5YbhVL6tJ4Q=;
 b=L9BJ2mO44PSO/lmfvnYc+oi3s9VhWXHFRRkHQL2H5Aa9qTE+RZ6QAttaydcLsntZVUkJyXUqEgzvfyvKkD96RyAiBLVIOvbMrpvUIWZI1rZTi9Qo8cu02ipxJv0vUT/SFBHMF9nAnf0STvZrVVbqJtatqXgZBJSHhax2aU+fKdY=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by BN0PR10MB5063.namprd10.prod.outlook.com (2603:10b6:408:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 18:30:50 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%6]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 18:30:50 +0000
Message-ID: <3cadb384-3493-4f36-a0b9-a3dffbf9fa9f@oracle.com>
Date: Thu, 23 May 2024 20:30:44 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
Content-Language: en-US
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
 <a04d82be-a0d6-4e53-b47c-dba8402199e7@intel.com>
 <1c69f62e-0dee-4caa-9cbe-f43d8efd597b@oracle.com>
 <93510641-9032-4612-9424-c048145e883e@intel.com>
 <5ed7d3c8-63c3-48f3-aaeb-a19514f4ef5e@oracle.com>
 <0fcbfcba-9fe2-414c-8424-347364fcbf35@citrix.com>
 <d9f5a2d4-9c73-45c5-9de9-12a4d1d9ee99@oracle.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <d9f5a2d4-9c73-45c5-9de9-12a4d1d9ee99@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P123CA0032.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::8) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|BN0PR10MB5063:EE_
X-MS-Office365-Filtering-Correlation-Id: e450b140-34e7-4642-643f-08dc7b567892
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WDVEN0ZlZlFYMllqYjMzQnNCT2pGeHg0UysrNDRzYVJkUncwSDZEVTB6TktH?=
 =?utf-8?B?QWhqTUhVaDMvc2MrUDRWbmo0R0l0dXRuekI5L29MSUdYQjNmc29aaUhpVzdW?=
 =?utf-8?B?M2E1bEhaTkp2QTYwQU9DNnNLMWdoYlVVTWdOMmZMVjJHRWgzbGhwU0RUSE9x?=
 =?utf-8?B?QlRrbDZVOGVDUFhScXZEQ3JoUDd0T3hDb2NGd0RqV2xKYTZ4S0ltRVZpN2s2?=
 =?utf-8?B?aFRqbUNxTzlES01TbjN0a2pMU0ZGUUZ3RWVGUWJIRFpRTzFYYWxBMncweFgw?=
 =?utf-8?B?RFJQYWJaYnpxRUl4eWRTQXRXalpBU1RIYys4NFA5RnNPL3RHeEs4Z2h3T0kz?=
 =?utf-8?B?cm9odlVIaEgzamZVNlJoOVpQSDE2THZJV2xUSWhJZ0Z1THlrYk9iNXpVNU5R?=
 =?utf-8?B?RFlDQW9WZG90ZjRnb3l4MEJXYWpmTUQ2L08wNi90KzdSOHlvZS9zK0k4Z3Vh?=
 =?utf-8?B?SlRtM1BmcFlWOVhYekxYK01tZ2c2SFd5dHRxRCtxQjJOM0syd0gxWlNJdy9q?=
 =?utf-8?B?YUt2cDFzN3hlc3BCY2gxM1lNaVlkZzd3VGxxQW5vZ1NRdjNsNm5POU1oZDE5?=
 =?utf-8?B?MURidmJVcDQ4Ym0xU0hTaFpxajdtRUdFUC9kbERRUDBnRkpFT2RrVklpeVow?=
 =?utf-8?B?aWVhcmhPWWVqTThtR1JnS1dsSU5wOVViOWJFTTBtODBzcGtmazgvcDNaNm5R?=
 =?utf-8?B?YnJqbGRIU0VIUVR2M3M2d2hJTUp0UWJTaFI2YWRKc3FXTERMamIxYStXa0pP?=
 =?utf-8?B?M3VwR2doZmNKRklrU0QrQUMyVUJuaVZ5K1Z6Yk03VjB4RTF1aVJRaWszd0Q5?=
 =?utf-8?B?WHRRSTZkNEVxUVRNdGJGV3pvSWg1ZDVmSVhEYlh4QTQyNWdLUnJFR0VkUHcy?=
 =?utf-8?B?Tm9jK3I4REMyQVgveVd6MWRrall6Z1U1RElDS0xEbUtPc2RUMGI4eGJYMVhn?=
 =?utf-8?B?eGQ4dWRRMER5TFhUU1U0WE9zaFVNWnRBUDdKVm4vQXVpWnU1OFB4cGltN21m?=
 =?utf-8?B?Sm5MYi84NTQ5blBQZ0JWUE1wdkIyZFNMa1FpVll1YlZpOWcrcUJTWkVhSkp1?=
 =?utf-8?B?WXdSNXhLL0Vhakh3VENscjVPQTdDR0J0c3VwRlFxSmRLWVlYenNVWEIzMm1h?=
 =?utf-8?B?cTlhdnpidTZoVGE5R0xGSVBkTitBS3pEWjFlUDR5VnNkdWVnOEJJL1p3TUtt?=
 =?utf-8?B?ZTY2Nk5iMUN4dWJibFpacklGdEU4RjhodHcrbTU0UjNWVXMvb1U3SjBoTVNM?=
 =?utf-8?B?bkF0bkYrem43ZWhadWdNaDcxaVhiSk81T3NzcHk0aXhvRVR4Ym1BbkJ1Y1h5?=
 =?utf-8?B?ZEM1OXBFYnRtS1I1dVQ4My94THE2ZXplbUQ1bzRScmwrRk5iY0pLbE4xZjdu?=
 =?utf-8?B?d3pYZGhSVjBJTGwzTlJDTEh6WkljVjRvTHZyMllGWUdhcHBKNEpPdHRySUx2?=
 =?utf-8?B?ckhsd1RldVYvNHVkbE1CVXdrM2syT3JBVGtUL2p3em9RV1krR0VGZTFsaStV?=
 =?utf-8?B?Mng0V1VuVFVRNk1BbXRwRzBjUDd2ZktsdGk1bklpR0F3aytKVEhPdFYyVTRv?=
 =?utf-8?B?ak5TeXJNUUhvbk1aaVdCbWpEUXE5UkwzcWUzb01vK0llMEowRmQ5bVYrT1pK?=
 =?utf-8?B?MDAyK3pvTVkrdE5wdW9CU3EzZThhSzRvaldUUzRwRjU2cEQ0TnNPRnAwMi9S?=
 =?utf-8?B?MkZrV2U5alNMVFBLTU5qT2pJcE9wREFIUVN3cDNDN3dJMXFKT05uTkF3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZjlabmdKZ21PQnNJbG8rNmR5a3ZwaERhSCtsQ0VodUI4ZW5kbVBZcGFlZ0s3?=
 =?utf-8?B?anVwMUtYczh2dDVzMWFENWdmMmNRNjJvMDBpSExhZXJDRTh1TS9pTkN1dTRx?=
 =?utf-8?B?ZWhFa0ZhdzV4ZnEyblhkWGhDamFJR3BhclFneVJKcjl4aGtyS0t0dkJYditw?=
 =?utf-8?B?SmpjSk5JaXcxaU9sWk5MakE0VHE5RkF1cnRraVJFMHQwVWZRTU84dGdadE03?=
 =?utf-8?B?Kzh0cWpPQ3NYU2M4djRRZlN3WXo2bHBPZ1FiSVczN000Zk04dEdid0pWaG9n?=
 =?utf-8?B?M0R6aUZvd016WmFETmxlZ3NLYVNGUEhsaThNbFBjNzZkbmFVSEpncG5uemxZ?=
 =?utf-8?B?ZHR2N2FKZjRaS1h4cGxWdEtZOGtoRVR5cktUZkdpR3ZVR3ZkY3k0dHFsb3NZ?=
 =?utf-8?B?dEE2MzdSblBvT2xYWjQ0RmJGSVBFZEVTdTdSNXJPcEVIL3NVME02ZHVTbWFQ?=
 =?utf-8?B?dzdGSFFDS0tsSE9Dam41ZFV5QXEzVkl1a1dvUElzZDhjT3JGTmVmZERRbVpz?=
 =?utf-8?B?RE1NeHZER1F2VFU4VmJGcExHdjdxT1NyNG43cmpWQThoc0tzYnpQdDVJTkQ1?=
 =?utf-8?B?bThGVi9ENXhCN0tjaU9wTHdLZ2Z1d0dBTVlNeGhzdUVIT25BMUZ0cUswdmFz?=
 =?utf-8?B?aEozQjNBRUc0b2luWFJobDFIRHlzL2FyN0hCZ29yVEpVL1RaUjFVYWhhNVRr?=
 =?utf-8?B?VU1UNnp2N1QyK1o4WmNIQ1lCSEpweU1uWXNYc010TlBya2xrUE8zbGM4KzQ3?=
 =?utf-8?B?RmMyKzZDMWRaNm5hVlhBd2VTcnU0NzFvLys3c3FCbnJXb2R2SURwY3VocWJq?=
 =?utf-8?B?QlZsNUtYZit6aTkycGl2ODg0cXVxNXdNNmowZ0xBbkRobjNJbzhCNXV0eVVZ?=
 =?utf-8?B?MnQ3eEs1MW43QVdFTWNTTEJKdmh2VHdtRUJsa0RQTW9EZzR6WXo4am1Ha1JD?=
 =?utf-8?B?YlFISnUyUE4rcDV3WnJDQzlvU0JySWxyRHZTMGpCTHA2OG52NDdaNVpvQVJa?=
 =?utf-8?B?dGd5SWRmcnVtY2owSitGdzBSQ2VRbmJTU0RXOHYwc2VwOGxiODJJMnYvYW5P?=
 =?utf-8?B?SE83MnhYc0p1TzdWelN0eFN4UVM1bEk1VlZxQi9iMXJORHFWN2JPUTJzOTRG?=
 =?utf-8?B?TUJLVmZZWUIwU09xMDkwSWVWaGxla2JFbWFqRkN5TllzSXRqUmhPWmx1TWJO?=
 =?utf-8?B?STlTNFordTZISUFieTU4N3VKRGRwcFlveVREVnYxNTN1VGlCc1pPemFmSExB?=
 =?utf-8?B?L0s1eDR1WUU1SUJ0ZkFoenFOZVhnaDQwSXUzUjRGdDFTMGRieDVzWU5oL3Nw?=
 =?utf-8?B?SzNwTTI3UmN3QU1UdlpSK1NUdU5kcGRoMG5UbU5DVjZDTy9FWFYvTUtDeHJx?=
 =?utf-8?B?WU13WlYvbWJrVVZadDBqY3NnQzRpU0xkald2bmQzaHovMXV0QjdQMnRRQUpY?=
 =?utf-8?B?cU1pWmdvWEdZc1FqSjVkNU9uRDFiZ3lsSm1wWTVjRlBDS0NvL1JaTWlOak9Z?=
 =?utf-8?B?Ry81OFRtQW1ZSzhhaWVPNERkN3B0T0lCeUl4bWJJVnN3REpMLzlaSkxzbkhq?=
 =?utf-8?B?QTBxSjMzdW9rWlFadVJPTXI3Y1M5c0UyWUNFWjJhaGlrcVBaWkVYOHRPR2E0?=
 =?utf-8?B?TjVyWEJGdGl5WWovNEsrM0RHRVVnNEtsNTBVNCtQK2czbnU0M3ArVHZubjFE?=
 =?utf-8?B?RzhqNHZxcDNJbnRtNTJKQmsvdFpybVNUNWovQWloR2pRL2dRUDlseGg3RG10?=
 =?utf-8?B?bTNmVVBFa3BjaDlJZHpmYWtDVEQ2ei9EQmFnM0xiWUJYQURRb0UzbDV6dDFY?=
 =?utf-8?B?RTJjVUNGaEo5ZllnVEtZRGZ4ZEJiSzZuRGVJd3NVUWpVWlJwOC92OXBnVnJo?=
 =?utf-8?B?dUt3T0d1bTN1eWY3U3RkN1dOODh6OUFZcmpabEwxRFRRd21BZUNkdnZ3NklR?=
 =?utf-8?B?cTY4bWh1eUsxU2ZmYWVJOTM0OXRHa1duc1pNaUh3ZGdPT0ljd1dYMUpaRWJ5?=
 =?utf-8?B?eVlTQnE1NXhTN0EyOTFzVW9SMXErVUdVOTYrTkxLS1kyNXRLUzloTW9VdmJM?=
 =?utf-8?B?VjI2bFgzM3lDcWxZTXZLL3cwMWV2NllLSHRNTXAxMm1vaUthMm05SDBDZks2?=
 =?utf-8?B?WXA4VHQ3YmZyUU5paE1DYU5sQTFtRlAwck5zclRacERkS0JOcG1CQjZjMFA2?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	RUeTszTk7qnz/9HuYSBWKU5JFRzY0ZCekXRydPoZUJXTLxuf3ceQ9uWcTPK8iD7+iDW2mPXBm1PzSsg7GgTpaZrC9SqsBZ3tKhRt21jf4RS5zOY0C1dBYWe9Szxmetoz+ieQxigFPwSn/we3gzMThalBRiywXBtGUS9FkjoTGy51ID7krh5722Xg9qElcSLH74kbLm34kefs8j7+jWQNAttYGdeSfj3EXtAHxF0vH2ifyE7LP/+Dfzx6jSY1SzhosNiDE/ItwDQSQp5tLMvQnsRIcvkVxQI/cng4DmxWdL2aElYlgcs+6diOMQBG2IRaOiMdKAt675SQxb1HAD3iqlDPr0SMGm9gYqwlhV6FcUyJTw/ruOZVD5gjhmtcJzzDkr/ZPH/a7ZxZYehbpogmaKqe/VNxrppc7EzM3rOlPUvsKu4RvMMrkOL4iRXApQATGQc9avGG7kHcBVsop2VZhkADvJd+snI6lPcj85fmWuWGq34CMmYmeRtDCD4Aqm9Bv72/qXmnzaS9RJTeTpgKmZd5UIjP54RQl1WsWlSMAwc6NhmvfaTg94nBqFYdrtjRGWyTOpJseT2aCMiIAEXiZR7scSkNYW4yrqLPpujBuEY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e450b140-34e7-4642-643f-08dc7b567892
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 18:30:50.1941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n5goMUVm8z/5sM7INTUiA+G2ERjyw0VM0ZyBLK6bA1tHDuY76h37MAOfyqMdc3aZjlKNsg/o0wdBiI0LBIUaGBuyEnYQ2w/+GYNICZnYHdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5063
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_11,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405230129
X-Proofpoint-ORIG-GUID: LzEmcPLsYm8XILRAThA6G4VE4E9HLm-y
X-Proofpoint-GUID: LzEmcPLsYm8XILRAThA6G4VE4E9HLm-y



On 5/23/24 20:27, Alexandre Chartre wrote:
> 
> 
> On 5/23/24 19:53, Andrew Cooper wrote:
>> On 23/05/2024 6:03 pm, Alexandre Chartre wrote:
>>>
>>> On 5/23/24 17:36, Dave Hansen wrote:
>>>> On 5/23/24 07:52, Alexandre Chartre wrote:
>>>>>> Should we wrap up this gem and put it with the other entry selftests?
>>>>>
>>>>> It looks like tools/testing/selftests/x86/single_step_syscall.c tests
>>>>> sysenter with TF set but it doesn't check if the kernel issues any
>>>>> warning.
>>>>
>>>> Does it actually trip the warning though? I'm a bit surprised that
>>>> nobody reported it if so.
>>>
>>> single_step_syscall does trigger the warning:
>>>
>>> $ ./single_step_syscall
>>> [RUN]    Set TF and check nop
>>> [OK]    Survived with TF set and 26 traps
>>> [RUN]    Set TF and check syscall-less opportunistic sysret
>>> [OK]    Survived with TF set and 30 traps
>>> [RUN]    Set TF and check a fast syscall
>>> [OK]    Survived with TF set and 40 traps
>>> [RUN]    Fast syscall with TF cleared
>>> [OK]    Nothing unexpected happened
>>> [RUN]    Set TF and check SYSENTER
>>>      Got SIGSEGV with RIP=ed7fe579, TF=256
>>> [RUN]    Fast syscall with TF cleared
>>> [OK]    Nothing unexpected happened
>>
>> :-/
>>
>> What about the exit code?
>>
>> I find the absence of a [FAIL] concerning...
>>
> 
> $ ./single_step_syscall
> [RUN]    Set TF and check nop
> [OK]    Survived with TF set and 26 traps
> [RUN]    Set TF and check syscall-less opportunistic sysret
> [OK]    Survived with TF set and 30 traps
> [RUN]    Set TF and check a fast syscall
> [OK]    Survived with TF set and 40 traps
> [RUN]    Fast syscall with TF cleared
> [OK]    Nothing unexpected happened
> [RUN]    Set TF and check SYSENTER
>      Got SIGSEGV with RIP=bb44b579, TF=256
> [RUN]    Fast syscall with TF cleared
> [OK]    Nothing unexpected happened
> 
> $ echo $?
> 0
> 
> The program runs as expected (but it doesn't expect much than a SIGSEGV).
> It triggers a warning from the kernel but it doesn't check if a warning
> was produced.
> 

Actually it checks that TF isn't cleared after the sysenter, but that's all.

alex.



