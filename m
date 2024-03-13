Return-Path: <kvm+bounces-11724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B398F87A52E
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 10:49:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1843F281A57
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 09:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A2F23747;
	Wed, 13 Mar 2024 09:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SotP+6kL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c+EWEGIy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F328F22606;
	Wed, 13 Mar 2024 09:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710323388; cv=fail; b=cE8xTWAG8FmicIOcag7D6enRQ1E1uX7qFsiACDYlV9H3SAqiU7m3HAB7C1Dcux4P0dXxOa/PTIPmhNN1AXRNH67+nEzDSSnsSOFZWEZ+lhcvFeZxMijNjqDbdR+JMPEZBeVh4esXngagdL1cpFRUPPcETt25RQG63UNDWpkv6wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710323388; c=relaxed/simple;
	bh=f1hBN1VtIlKexbi+0lQU3pVckJ5XdkbjU4FuXRq+4rU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ryjC2kCnUh3i4iuWplebm60fwoNZ8sA4WykFuWMMa1d9IWUsWGQNhWlNOFW8SwtdPWsmpvVrIDoNon50C96g6ZuiW+3R31Imhz+b5RYwDNXFVlUTfRh4lrYd6delO4xzFGIv8IATaywKD4E+0sABk53yO4preOpCKk9YIUxUsWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SotP+6kL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c+EWEGIy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42D8iFiX011275;
	Wed, 13 Mar 2024 09:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=1HvIIsx9c/usegn3AXeCI9wUzHkb2dpZGMXFcgeC6nM=;
 b=SotP+6kLd5pIZcHuV/H6r+eHBZKoIU2iMDeHe/9Km2lUGn5jM6O07fAvE42rW9GkVr5M
 Tv0DQg+8SHjHUgkYNzOtYK8OT8gWphTPwZIngC1mynmvFxMsFsmt41elcwFwphc6NPH0
 NHkytQZIlQz0XqQnXM2sfCPbinw//vX+itbzB/Dxmbdd+tT1G3FN6gsRQpU9/FtjktVl
 9gnsdVg09kh2URA8FZgKjoz3E6R+dsMNFaWKKxFcH/ermZHeMFF1NaxlJNoSXmNoNB2Y
 b0huesb72ZCrmMx4MFTomiQqoUF901M17MyyGWVdC/oxti1W5du80RFW/xyRSGTuXmNV dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrec2gdwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 09:49:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42D8esia004779;
	Wed, 13 Mar 2024 09:49:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre78sr6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Mar 2024 09:49:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVOy+rl8zNbY02ODvcKrIxhLIKNuopR5OnyQIW2Vfv6QyycLtZWFuOAWvGqVPKRbYZHB8kjGJkrPUG3bOVoUf/ceBhFqF75SLWxDsIMdo1cmo3Odq7XGe/dXUExUQuOLXb67EchcN3PSi2JZtqe/2p61UrPbj//XvCJcdaKjBJP6cnG5LuRiSPLhpbAfInGLTDebteE61XniSUjb/grOJC5wIY0G4t/LE8VQ8Gx//H7a2CeRyxulLkUwpLAL7BINkIIEUOV17aMwx0/S2t+rapY9uzpZRijgNDc+9WI7X/HnAPdW4nhMGQWHp3s82tU35CvC8f16vTIpBhy+NRQNaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1HvIIsx9c/usegn3AXeCI9wUzHkb2dpZGMXFcgeC6nM=;
 b=dL9uuBTN5mCHQBHgdBzFHkdpGY4Ef0HS+IyK3zn0yeNEyn2Bt+qliclVp6lrZgk+0TTVlzu6Qoa+f99K7uuOzX3PlnVzUl777KSUyxAOe0Qs6Y43tGqhyp4rznbCnuLyUKfhfugi5Ue62g3FNSFYoqG++rCbf0aUQVkqOgLGZxln3jTz6rluNS8OlGLcaGphoOAyMTLEVYqASSJaL17S/nGxzMUHoXDG+lw5WJm7oKTE6czlQtxrb2dZCNeUV+++B6ZFdBAXlGUVCAwybfLv+XOnAS8lTZvtWzVjeHvrGAJEAZ7RzfNmSPxqPuKvZ+nRXE+EoOMhlI6GSJDT0ypJQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HvIIsx9c/usegn3AXeCI9wUzHkb2dpZGMXFcgeC6nM=;
 b=c+EWEGIy/l2O2WV7UkZi3XPbBKfmqOSczzy5GCXBS+R1nDseszsESVESRssdgTB/KeuGs1hbnWmf0ATKXtgducCn9yF3nfc4jKvFUKkqBE+7d9fFpnydkATqFzousTW+lLNrYi702ggBsSpMaPh6lgomYBLVxvPhacw6Uvbi4nY=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ0PR10MB5744.namprd10.prod.outlook.com (2603:10b6:a03:3ef::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Wed, 13 Mar
 2024 09:49:37 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%7]) with mapi id 15.20.7362.035; Wed, 13 Mar 2024
 09:49:37 +0000
Message-ID: <ccb21523-54b8-770a-bdac-c63f9c8080db@oracle.com>
Date: Wed, 13 Mar 2024 02:49:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, isaku.yamahata@intel.com,
        hao.p.peng@linux.intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        linux-kernel@vger.kernel.org
References: <20240312173334.2484335-1-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240312173334.2484335-1-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0042.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::17) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SJ0PR10MB5744:EE_
X-MS-Office365-Filtering-Correlation-Id: 11aa45c9-1e7c-46ea-2631-08dc4342e51f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	V+TBVFj+Z6XhHGbdo5zXXMA891B4oAvW9teWOgEI90JkCTcf0lj+UV9YW/EHxCclA66RLTvdJpoVyuqEtsqE8APOuQ80fch6UQPGMb7HmpNRi/mweInQXu9pFeDBFZkRZp2mYdyN7zVaChL419vJIStfo7vWx6AnPXTOV4bGhOd+S/nAO5k5fGQl6CEhsJi1oyrBj2GFHIO0qHch+w7qXgIdfw8EdqSOse9nETYQwz509LDpFS9Q6xL5vpKdUsMZx2iIiz/sMuydt69h7j3p++ZWclYfF+m/TY/vQiS4zyFHjC4UOasrx7zXLLZy3hyo1kPngK8K8OQdGLHAi4+vXozGG+scMba7UolJ1AVW0nvHmfnF8LN/dC2jsfIXQpNfLanBN9UXUP/kKiDt5DiH2VcKTWJChBcLC69jX4fQf5n4VA332FvM+mtv6bU4GsrK2f3h8KejY4oih4SNzYxrhRamqhNTpPuKjTZD9j0qfxEJBCGmYL62qJKxahSE5jg6dJqT2An71SETuS9cVNz0Yf7qcGb7WWJ0+8w4ef5Ie7nPeRVpqHWhT51fuI0leZOovYEd2a7pcHRUA0VDYbDHs6yTow+j1eWw2dDVQ2jVU3BihBVhbH/Tt7gBRNZ/ImraQesGNiPCnhjw0KKQj2WH9mvWQ2e1GvLv2/ihVHRFABc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cjIwL3Rpb1hhMFRCdTBEY3RkYWIwUUhoUWJ6eGFFMTM0YjYycVlWNVZCSW9w?=
 =?utf-8?B?S1NJK0NqRGliNyttRHA2ZGxoS2pyVkpYOGtJZ2pINVBoOVZGUWVZdjRScjJY?=
 =?utf-8?B?WmtFeSsvZFNWUThyay9ubk9FQWZWcjFOWm1nNi9PSVVOVnhjY1lNVnNoQ1J5?=
 =?utf-8?B?eUFwdXU3VEZ2NHFTcDFvaHQrRFVtdEtqVXRCeG4wZlpFS1k1UEdRei9obTNq?=
 =?utf-8?B?SW1HS0JQTmdxOFlJd3lPWlFXYTl5TzRlNGRhZ2NmZkkvUjVta0IreW84NFNp?=
 =?utf-8?B?dE5NRE9mSmRGcVNjUkF2NWJ1REhQanplWmlycXBkbnM4UXFVM2tsZm4zVFRs?=
 =?utf-8?B?dngrTTRkV29xYjVmTk1XSzNkNWJrYWo2elBxWEJSUzhwTUN1NWQ1c1N5cldN?=
 =?utf-8?B?ZGhmTzh3RGIxd1RKWUxwUERKNkNEdVdtOU5hd1NIbW9URTNSK21pT1UvVlhE?=
 =?utf-8?B?RGYwTU8vTExWcFdRQ3d0dWw5aEdnL2c4UElmM0xZN0tPblh5Ui8vQ28zUUFH?=
 =?utf-8?B?Y3BpWWJCODk1RFJYY3B1VDhJSWZBODk4Z2EwdDd5TEVHQjNxODNVejJWQVpp?=
 =?utf-8?B?cnBwdXJOSFpGT1VNcEhkaXFsM2QvNWFaMVZ0c21BV1Fjc01Dc2ViYVQrcVdu?=
 =?utf-8?B?YnhtNm16WXd6aW82WEJEamhOb2ozajExQ2w5bUlTK1gvaElOcDVWbFdjS01h?=
 =?utf-8?B?UVNtTng4THlWdnk0d00vd3VMTUxhNDJ1VlI4S0IxaWtPVm9FQis5VnR5SnU3?=
 =?utf-8?B?bis5MEQzM2lZZmhOenpuZHJBNHZtdXB5ZjFTMEhtWmtxbFpGakpsQUY1QmVo?=
 =?utf-8?B?c1UyOTB5TWcyTjFmbTB0NlczSkhHajBGNVk3MnY2cFRCaWxXS3EvbENWQVhJ?=
 =?utf-8?B?K1c2T091eEpVUkx5Tk81bXdEYnhBNWZYTGRHb2RmKzJDODFKaHFQUEd0Q3V3?=
 =?utf-8?B?NXpwVk52ak5QeGc2RFF1QUlXTkdNejNPdUxGYmZoaWN6YXZpT0M1MkdHRlRn?=
 =?utf-8?B?V0pOaXVKdHVHR2hNSjRQYnNOcHQ4UVh0SW1KVnp1SjRuL2RvZFdqSHRrUVQ4?=
 =?utf-8?B?WHZ3Z0JVWmU3TkFRUnh2Rkt1T2RmemgxemUxeVFSRTJpRjU0c3oxcUoxYmFG?=
 =?utf-8?B?cGlFZWx2Y2lXbUdQMzJ1MllvWERKRGF6SHQ0UWV0OGM5Nk0wcEh5Q3RWd214?=
 =?utf-8?B?SkQwNkx6dmYyaWh2RWhUM1lYc3RucEdDdmFDR0tKM1FHak05TlpkbmJVMDFl?=
 =?utf-8?B?N3VxMVBXRURzYit4aVNxTzllNXFrQVZ6K1FCUjZPWXJvcy95NkU1MFBrTmlS?=
 =?utf-8?B?MFhnMVlJUWRoc3RlQnJ0blF2d3Q1S20reUFFQUZQSWx1am8yQzhQNU82ZHlZ?=
 =?utf-8?B?YkMvUnl0c01wUER2OXh0bmFJa3dJMVBneFBaVXFJUVdTenNLeThyMXBtNjBK?=
 =?utf-8?B?TnhuK2tRMStCYXlBbmdkOHgwMHlBZG9DMVVvTlVmNTliOVVDc2h1YjVYazlt?=
 =?utf-8?B?TC9BeXpkYjREbHl3cVNvOUtWd2FBWlYyOG15ZlBqS2NHekUrSnlET1dLTkVt?=
 =?utf-8?B?bCtyaUJ0RmMrWGdsalBWTDZ0UDRISm1pS21mak5UZVN5Z051dmc2R0JQWGpr?=
 =?utf-8?B?dUpueVB1dG9wQUNCYzVScGg5elRJL3ZPNE9vK1J5WnpyWGYxSkZmd3NWcEcy?=
 =?utf-8?B?a3VydVJ0b0pMay9qVWk4MXhZYkdLSkw4WldyUXhNZTZ4bVRyeUg5bmFBWTVx?=
 =?utf-8?B?L1NlMFY5QjBrWmludzIzL1JidEhBQkgzU2R2T2UzcnJpV28rWEtQQTBkMzc0?=
 =?utf-8?B?dEw4MHh5ZEdtT1VzcHJhZHN0QUR1NVJOcUQ3NE9weGExZHVlRkJlUDFmbW44?=
 =?utf-8?B?UTNPeTYvTlU3TzNwTEVnd2NRYVpIWXVXT3RnN0JjS2Z6ckRkbjRWUVNSR3FW?=
 =?utf-8?B?Nk1RVCtOZ2FQSVhxMFVGY2RkNC92QlFBZUdGVkZmUkpLR3ZFeUtXWEFmTSsz?=
 =?utf-8?B?M3VYbTNDSWdrMkwwRjVkSERJZy9SRU9QeTBITzRhajF3YTdwMXZEZ0VaVHI2?=
 =?utf-8?B?RlVwbHFRdDhxeFZTQTFOaFZCV3dLaW5mV2xlY2pGZm15OWFaN3RnSjlqaCty?=
 =?utf-8?Q?U/1aX+e0bpUiq1Lenmjuc1rFz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ipZkdGg6xsTkWGUvj0HKormJ0EEaufpqp1wyqxi92ruEMj47HZMI8QTzR4GnSHzHSCPq3ejpvRByccOeKK7LH++gbm7DgnlVeIJHUGUuTohzwtFEMYbU0lh8CxgEb0UwpjJKo3oIzSRjEcHQ2E94sxh+FYwmerh5ELWF9rhl+6EuLC4wqIbSu0NjHYcLHho+//0geDgi2H4dQZhhdC+emGN6dsx1RzgY2Eda49tC1tiVzNcYXWnm0EAJeI4qekn/v4UTBve7aZcXpSs0fCEbHRW8vj/9r4nglMOScjXE56K5quvEScIQi4+U76iD3qS8MypZfBewEK0zcLJdsbqodu8ydoLY/rZ+Dc/7N6LdJwKHrWL5Jq07ISDKlRU8iihY7ktTCCArG26NPNWwsK59SAg3CbTlclab8CTFUtjvRBFlNd/kPdG0ZP+ajpRJgDpAktBVr2wR0BRmgurOKeW+ZLl2/33o7S3LXql1HvptzMeoq32lfJy8odICsT7Rgwh8A6vPXm80fmVJCluKGC17UnajSb3Hj5maICFBZyG4+QGrGmW1/9Jl0enCubIAIRF9+l8E8xLL8ZshDHRs5WTXlN9YR81Jzcli1/Zwe0Tia48=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11aa45c9-1e7c-46ea-2631-08dc4342e51f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 09:49:37.2341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJ55NmXh4HG/BqsUOSen89HCAJvmrI1BTZIB4FyjxgYslbcZsn9oaFF9pfFjt0eyW0TdGiFmJHtAtc+xmXuvCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-13_07,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403130072
X-Proofpoint-ORIG-GUID: FZxrsCGpf42Lir45i1jSTI0Y0U183oJ-
X-Proofpoint-GUID: FZxrsCGpf42Lir45i1jSTI0Y0U183oJ-

I have tested that I can reproduce with the most recent kvm-x86.

[  495.011678] ==================================================================
[  495.019933] BUG: KASAN: vmalloc-out-of-bounds in
hugepage_has_attrs+0x1ad/0x1d0 [kvm]
[  495.028984] Read of size 4 at addr ffa000000057c008 by task private_mem_con/16295

[  495.039536] CPU: 43 PID: 16295 Comm: private_mem_con Not tainted
6.8.0-rc4diagnostic+ #1
[  495.049231] Hardware name: Oracle Corporation ORACLE SERVER X9-2c/TLA,MB
TRAY,X9-2c, BIOS 66090600 08/23/2023
[  495.061126] Call Trace:
[  495.064157]  <TASK>
[  495.066600]  dump_stack_lvl+0x47/0x60
[  495.070789]  print_report+0xcf/0x640
[  495.074922]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[  495.080886]  ? __pfx_radix_tree_node_rcu_free+0x10/0x10
[  495.086933]  ? hugepage_has_attrs+0x1ad/0x1d0 [kvm]
[  495.092544]  kasan_report+0xb0/0xe0
[  495.096546]  ? hugepage_has_attrs+0x1ad/0x1d0 [kvm]
[  495.102212]  hugepage_has_attrs+0x1ad/0x1d0 [kvm]
[  495.107641]  kvm_arch_post_set_memory_attributes+0x2b5/0xa80 [kvm]
[  495.115052]  kvm_vm_ioctl+0x215a/0x3630 [kvm]
[  495.120236]  ? kvm_emulate_hypercall+0x1b0/0xc60 [kvm]
[  495.126482]  ? __pfx_kvm_vm_ioctl+0x10/0x10 [kvm]
[  495.132300]  ? vmx_vmexit+0x72/0xd0 [kvm_intel]
[  495.137655]  ? vmx_vmexit+0x9e/0xd0 [kvm_intel]
[  495.143080]  ? vmx_vcpu_run+0xb52/0x1df0 [kvm_intel]
[  495.148809]  ? user_return_notifier_register+0x23/0x120
[  495.155168]  ? vmx_handle_exit+0x5cb/0x1840 [kvm_intel]
[  495.161494]  ? get_cpu_vendor+0x151/0x1c0
[  495.166234]  ? vcpu_run+0x1ad0/0x4fe0 [kvm]
[  495.171404]  ? __pfx_vmx_vcpu_put+0x10/0x10 [kvm_intel]
[  495.177757]  ? restore_fpregs_from_fpstate+0x91/0x150
[  495.183807]  ? __pfx_restore_fpregs_from_fpstate+0x10/0x10
[  495.190241]  ? kvm_arch_vcpu_put+0x50d/0x710 [kvm]
[  495.195810]  ? mutex_unlock+0x7f/0xd0
[  495.200063]  ? __pfx_mutex_unlock+0x10/0x10
[  495.205114]  ? kfree+0xbc/0x270
[  495.208824]  ? __pfx_do_vfs_ioctl+0x10/0x10
[  495.213685]  ? __pfx_kvm_vcpu_ioctl+0x10/0x10 [kvm]
[  495.219681]  ? rcu_core+0x3d0/0x1af0
[  495.223801]  ? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
[  495.230794]  ? __x64_sys_nanosleep_time32+0x62/0x240
[  495.243211]  ? __pfx_rcu_core+0x10/0x10
[  495.253527]  ? lapic_next_deadline+0x27/0x30
[  495.264294]  ? clockevents_program_event+0x1cd/0x290
[  495.276271]  ? security_file_ioctl+0x64/0xa0
[  495.288009]  __x64_sys_ioctl+0x12f/0x1a0
[  495.298340]  do_syscall_64+0x58/0x120
[  495.309360]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[  495.321567] RIP: 0033:0x7f1a24c397cb
[  495.332094] Code: 73 01 c3 48 8b 0d bd 56 38 00 f7 d8 64 89 01 48 83 c8 ff c3
66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0
ff ff 73 01 c3 48 8b 0d 8d 56 38 00 f7 d8 64 89 01 48
[  495.364168] RSP: 002b:00007f1a241ffa08 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  495.379294] RAX: ffffffffffffffda RBX: 0000000100000000 RCX: 00007f1a24c397cb
[  495.393694] RDX: 00007f1a241ffa50 RSI: 000000004020aed2 RDI: 0000000000000004
[  495.408770] RBP: 0000000000ae68c0 R08: 000000000041b260 R09: 000000000000000c
[  495.423691] R10: 0000000000000001 R11: 0000000000000246 R12: 00007f1a25b85000
[  495.437640] R13: 0000000000ae42a0 R14: 0000000000000000 R15: 0000000000000001
[  495.452119]  </TASK>

[  495.467231] The buggy address belongs to the virtual mapping at
                [ffa000000057c000, ffa000000057e000) created by:
                kvm_arch_prepare_memory_region+0x21c/0x770 [kvm]

[  495.508638] The buggy address belongs to the physical page:
[  495.520687] page:00000000fd0772bd refcount:1 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x1fd557
[  495.537219] memcg:ff11000371954f82
[  495.547263] flags: 0x200000000000000(node=0|zone=2)
[  495.558820] page_type: 0xffffffff()
[  495.569018] raw: 0200000000000000 0000000000000000 dead000000000122
0000000000000000
[  495.583833] raw: 0000000000000000 0000000000000000 00000001ffffffff
ff11000371954f82
[  495.598872] page dumped because: kasan: bad access detected

[  495.618236] Memory state around the buggy address:
[  495.630053]  ffa000000057bf00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  495.644646]  ffa000000057bf80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  495.659130] >ffa000000057c000: 00 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  495.673448]                       ^
[  495.683659]  ffa000000057c080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  495.700596]  ffa000000057c100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
[  495.716978] ==================================================================


I cannot reproduce with this bugfix patch.

Even the 1st range at line 116 (0 - PAGE_SIZE) can reproduce the issue.

112 struct {
113         uint64_t offset;
114         uint64_t size;
115 } static const test_ranges[] = {
116         GUEST_STAGE(0, PAGE_SIZE),


The memslot id=10 has:
- base_gfn=1048576
- npages=1024

Therefore, "level - 1  will not contain an entry for each GFN at page size
level". If aligned, we expect lpage_info[0] to have 512 elements.

1GB: lpage_info[1] has 1 element
2MB: lpage_info[0] has 2 elemtnts

Issue happens when guest_map_shared() the 1-page (1048576 to 1048577).


So far the comments are conflicting. I agree "It is a little ambiguous whether
the unaligned tail page should be expected to have KVM_LPAGE_MIXED_FLAG set."

The below says KVM_LPAGE_MIXED_FLAG and lower bits are different (although
functioning the same) ...

/*
 * The most significant bit in disallow_lpage tracks whether or not memory
 * attributes are mixed, i.e. not identical for all gfns at the current level.
 * The lower order bits are used to refcount other cases where a hugepage is
 * disallowed, e.g. if KVM has shadow a page table at the gfn.
 */
#define KVM_LPAGE_MIXED_FLAG    BIT(31)

... while the below implies the they can be used as same.

/*
 * Skip mixed tracking if the aligned gfn isn't covered
 * by the memslot, KVM can't use a hugepage due to the
 * misaligned address regardless of memory attributes.
 */


BTW, the number of entries in "struct kvm_arch_memory_slot" is not cached. This
brings some obstables when analyzing vmcore :)

Dongli Zhang

On 3/12/24 10:33, Rick Edgecombe wrote:
> Fix KVM_SET_MEMORY_ATTRIBUTES to not overflow lpage_info array and trigger
> KASAN splat, as seen in the private_mem_conversions_test selftest.
> 
> When memory attributes are set on a GFN range, that range will have
> specific properties applied to the TDP. A huge page cannot be used when
> the attributes are inconsistent, so they are disabled for those the
> specific huge pages. For internal KVM reasons, huge pages are also not
> allowed to span adjacent memslots regardless of whether the backing memory
> could be mapped as huge.
> 
> What GFNs support which huge page sizes is tracked by an array of arrays
> 'lpage_info' on the memslot, of ‘kvm_lpage_info’ structs. Each index of
> lpage_info contains a vmalloc allocated array of these for a specific
> supported page size. The kvm_lpage_info denotes whether a specific huge
> page (GFN and page size) on the memslot is supported. These arrays include
> indices for unaligned head and tail huge pages.
> 
> Preventing huge pages from spanning adjacent memslot is covered by
> incrementing the count in head and tail kvm_lpage_info when the memslot is
> allocated, but disallowing huge pages for memory that has mixed attributes
> has to be done in a more complicated way. During the
> KVM_SET_MEMORY_ATTRIBUTES ioctl KVM updates lpage_info for each memslot in
> the range that has mismatched attributes. KVM does this a memslot at a
> time, and marks a special bit, KVM_LPAGE_MIXED_FLAG, in the kvm_lpage_info
> for any huge page. This bit is essentially a permanently elevated count.
> So huge pages will not be mapped for the GFN at that page size if the
> count is elevated in either case: a huge head or tail page unaligned to
> the memslot or if KVM_LPAGE_MIXED_FLAG is set because it has mixed
> attributes.
> 
> To determine whether a huge page has consistent attributes, the
> KVM_SET_MEMORY_ATTRIBUTES operation checks an xarray to make sure it
> consistently has the incoming attribute. Since level - 1 huge pages are
> aligned to level huge pages, it employs an optimization. As long as the
> level - 1 huge pages are checked first, it can just check these and assume
> that if each level - 1 huge page contained within the level sized huge
> page is not mixed, then the level size huge page is not mixed. This
> optimization happens in the helper hugepage_has_attrs().
> 
> Unfortunately, although the kvm_lpage_info array representing page size
> 'level' will contain an entry for an unaligned tail page of size level,
> the array for level - 1  will not contain an entry for each GFN at page
> size level. The level - 1 array will only contain an index for any
> unaligned region covered by level - 1 huge page size, which can be a
> smaller region. So this causes the optimization to overflow the level - 1
> kvm_lpage_info and perform a vmalloc out of bounds read.
> 
> In some cases of head and tail pages where an overflow could happen,
> callers skip the operation completely as KVM_LPAGE_MIXED_FLAG is not
> required to prevent huge pages as discussed earlier. But for memslots that
> are smaller than the 1GB page size, it does call hugepage_has_attrs(). The
> issue can be observed simply by compiling the kernel with
> CONFIG_KASAN_VMALLOC and running the selftest
> “private_mem_conversions_test”, which produces the output like the
> following:
> 
> BUG: KASAN: vmalloc-out-of-bounds in hugepage_has_attrs+0x7e/0x110
> Read of size 4 at addr ffffc900000a3008 by task private_mem_con/169
> Call Trace:
>   dump_stack_lvl
>   print_report
>   ? __virt_addr_valid
>   ? hugepage_has_attrs
>   ? hugepage_has_attrs
>   kasan_report
>   ? hugepage_has_attrs
>   hugepage_has_attrs
>   kvm_arch_post_set_memory_attributes
>   kvm_vm_ioctl
> 
> It is a little ambiguous whether the unaligned tail page should be
> expected to have KVM_LPAGE_MIXED_FLAG set. It is not functionally
> required, as the unaligned tail pages will already have their
> kvm_lpage_info count incremented. The comments imply not setting it on
> unaligned head pages is intentional, so fix the callers to skip trying to
> set KVM_LPAGE_MIXED_FLAG in this case, and in doing so not call
> hugepage_has_attrs().
> 
> Also rename hugepage_has_attrs() to __slot_hugepage_has_attrs() because it
> is a delicate function that should not be widely used, and only is valid
> for ranges covered by the passed slot.
> 
> Cc: stable@vger.kernel.org
> Fixes: 90b4fe17981e ("KVM: x86: Disallow hugepages when memory attributes are mixed")
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> Hi,
> 
> I added cc stable because I didn't rule out a way to trigger a non-kasan
> crash from userspace on non-x86. But of course this is a testing only
> feature at this point and shouldn't cause a crash for normal users.
> 
> Testing was just the upstream selftests and a TDX guest boot on out of tree
> branch.
> 
> Rick
> ---
>  arch/x86/kvm/mmu/mmu.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0544700ca50b..4dac778b2520 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7337,8 +7337,8 @@ static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
>  	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
>  }
>  
> -static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
> -			       gfn_t gfn, int level, unsigned long attrs)
> +static bool __slot_hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
> +				      gfn_t gfn, int level, unsigned long attrs)
>  {
>  	const unsigned long start = gfn;
>  	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
> @@ -7388,8 +7388,9 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  			 * by the memslot, KVM can't use a hugepage due to the
>  			 * misaligned address regardless of memory attributes.
>  			 */
> -			if (gfn >= slot->base_gfn) {
> -				if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
> +			if (gfn >= slot->base_gfn &&
> +			    gfn + nr_pages <= slot->base_gfn + slot->npages) {
> +				if (__slot_hugepage_has_attrs(kvm, slot, gfn, level, attrs))
>  					hugepage_clear_mixed(slot, gfn, level);
>  				else
>  					hugepage_set_mixed(slot, gfn, level);
> @@ -7411,7 +7412,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  		 */
>  		if (gfn < range->end &&
>  		    (gfn + nr_pages) <= (slot->base_gfn + slot->npages)) {
> -			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
> +			if (__slot_hugepage_has_attrs(kvm, slot, gfn, level, attrs))
>  				hugepage_clear_mixed(slot, gfn, level);
>  			else
>  				hugepage_set_mixed(slot, gfn, level);
> @@ -7449,7 +7450,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
>  		for (gfn = start; gfn < end; gfn += nr_pages) {
>  			unsigned long attrs = kvm_get_memory_attributes(kvm, gfn);
>  
> -			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
> +			if (__slot_hugepage_has_attrs(kvm, slot, gfn, level, attrs))
>  				hugepage_clear_mixed(slot, gfn, level);
>  			else
>  				hugepage_set_mixed(slot, gfn, level);
> 
> base-commit: 5abf6dceb066f2b02b225fd561440c98a8062681

