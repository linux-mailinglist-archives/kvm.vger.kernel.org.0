Return-Path: <kvm+bounces-14251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE238A1568
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:21:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C68AB20A10
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 13:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D70914D281;
	Thu, 11 Apr 2024 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ndjpkF/g";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yJk5mmxI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E26634EA;
	Thu, 11 Apr 2024 13:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712841667; cv=fail; b=cacDltiCcct47pkAIsA6WQb7nMAZ6gmomhWyvdQsBpJFVHTriN3aCWsCCUCV6n6C3PxFwpV/HhkEn7y4uJFdkKap3lhTPCbmmAzkXSwpmrGFs3ehWXpYVdFyYqm3RRrBK2JpDNkB/xFiFsDfshIqqoa37Ox8Ip8RyT7VkwVtnmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712841667; c=relaxed/simple;
	bh=HiO+NbMEbIHVbw46kcIcra+ZPtJ7mOMlulNj5fpHKyw=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pGuJsTbJJAGtT6zT419AAizF05G3Ibshnoqam+663ERHzRcZfZM6+XJGgH15ZzshvBG8/t+6/FBH/wCAplWWrlSX+gmriw8gOzFpOkWdT+ty+Hg2/1Olf7NUC92na/RfK3TyNcxNIkY67XaJopRNf3gqOb1mcyk55IN/hWqPEy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ndjpkF/g; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yJk5mmxI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BCo7Da023666;
	Thu, 11 Apr 2024 13:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=CaYDYxCMWv5LN/13Q7Kk86zFpbQO1+lobxKpYA0FnCc=;
 b=ndjpkF/gPnSP9KShE2alOzXzp8JmlQMdhm18JJJ8PrCwLvtLp+2pmzuMUReyanerVyYZ
 n60/M9gh16CWYhZpkgUs1N1Gnm6SusScFqSZhsQOZgG+K0MsfvpTAYfk3rAMxUCox+Md
 44YutKr9j/7CG7EGchWYht7rTNwh5TnD2k2hpgs/KiMxbi17m9rpyfVFgBCjOAFSoUv7
 vAq38+qG4j+2z+2a8BeUcXeVg1VBCnWaNhEM4M0XphPETLvBJT87iRMJwsDw8B9LHwXS
 i9atVnmp77dTQxgp3fxH3c58is1byWgkzAL+Fqj6tpJ45nJGyLQ++vfB2CpGA1hsRF1l 5A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax9b9dnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 13:20:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43BD1T0f032298;
	Thu, 11 Apr 2024 13:20:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavua416j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 13:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6+c9BLG/NDkQMeH/96aKQZdB7gulKwPdabwOnwlP+io3tMv9mHudnelKUADql9nKlVlOvhJENP6ppjxTqV0Z97D8fLEIEHY2xe08aKl5+oOVbaxZR+YAw1713cYSZvuc8AwrzbU/6obZlUkijVNO2a9kptcenCSWWbuMovH3reE3d2lAogwvcGCigOguNrQD+AV/PiYMNTwOEY/Y9eWCWVlkGiBSB/TqYm8WmOJOOR/L5wvfES0jeXjPAjIjEPDkjAtFddZOzADi2NzJq6RJgFJh0smeQtWksuY8tmohhXd4LDkQa/Zi7QnOlHslA13JsbXE0IFEwa1eMZNvF7fpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CaYDYxCMWv5LN/13Q7Kk86zFpbQO1+lobxKpYA0FnCc=;
 b=hei1lq9TZb9GahvkQJvqtjHNZ23rEg1S88gQtz4WfcwUmfiFrIzFqx0h4SK3tHVSojASkVtlX7+SY3KNaRGshveCo84BbBw1xXnifdQ50r32uU9uZUl4F6vYWAOShcBMRPDwFyWekLfS75FkYzz0SSFiIhhoLGtquNM5BPMp6sZzd918kR3knQtyimtiZalWcMD9YL3lz0UbMxLYJjZ8+RCWLMB7r0nAex3N81geT64CsVR6lDECBQCHpq90FvxvmWxRVuy2zU8Ae7ceiAAxViR6cb8lhDy+byPBfIwZlF7NlJTHPRhjMab4EH4qys0KMxRSkuhV4Z/pX24R+kWMjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CaYDYxCMWv5LN/13Q7Kk86zFpbQO1+lobxKpYA0FnCc=;
 b=yJk5mmxI9h5Q61xvNPQjCoQ2RJ9v7CiIGnp7zhDmb/rXm7QngYu4aK3mp5rk/1xqG+HyCJXmf8EydMyHD+puL1xkUgULuB5MVNRXyambh/yvi8TksVIeobIs3XfleeNuKpZCWMxeMI9pi6UEQ/I11u4tYCFbCGh2cuJvOYjwd2s=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by CO6PR10MB5649.namprd10.prod.outlook.com (2603:10b6:303:14c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 13:20:35 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44%5]) with mapi id 15.20.7409.053; Thu, 11 Apr 2024
 13:20:35 +0000
Message-ID: <95902795-0c2c-43cc-8d87-89302a2eed2b@oracle.com>
Date: Thu, 11 Apr 2024 15:20:29 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
        konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>, Andrew Cooper <andrew.cooper3@citrix.com>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <d47dcc77-3c8b-4f78-954a-a64d3a905224@citrix.com>
 <ZhfGHpAz7W7d/pSa@chao-email>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <ZhfGHpAz7W7d/pSa@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR1P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::11) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|CO6PR10MB5649:EE_
X-MS-Office365-Filtering-Correlation-Id: 632a79a2-c697-4abd-c5e6-08dc5a2a2bf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Yesrb10d3ENM7k6zRNZGSt6AO2P3NJNSRGX5uvUMY7tUj+HpQr+VjBay+5bvq0J3FWIugr941wKnVWz2+jqrqnjvt8AdUhLz5ixR5X+b/6pDo/KotSXkNDAUNuuKCk+gX/eVSk8Cc3bVUJd1ZZYSHDAcbUWq8OV5fZC3MliG03sBX16/Kwm00hgtwYrKgCSweTXC3EjXEu+RrqW+zbBJ8hF3TlmeN32mgEAn2s3wMC2F5RAA5U38AQKnxeXf4/le2/OpEFnQr66sqMlQddRk2PBZE8nGTaAbvXa9yhHJpe/ln/h/lsZNQLn52OkoZ688vmBlVJfU/8EkyswtElQHYh3oSx4vXOq2ZihHFf1HpgPLSZSIt24Z8WOUM/q8x1SNd52nZ7HzLoG+iTxH1z07SS4qGHwAkNcIDAvJZJk+9kU66gM0FdkAaXTW8wfFRK2eLeJFUUbh88Iv866SLtlFFZJDNACLTrajO3uLrJ4rTjUXxJK6lAN6hC+O4YIGCT8eLNZlRX+w+MUXRqvC7bmWs8xpQoHSO4k/mHojv82Az4E56E+BH2BVNnPe22ZdK6DvlDLZoECR9YsGmjbbKzaSwT6bVY3hpQQHWUmnJtSkSaUAqlIjTbYm2N/HUtRRtGhjZt29eSV0JrA+28aom7pcoLWE5DoBCNy20pt5cPI8WAs=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dTRocjM1ek1NeGJJVnhYM2xxU2Q4OGdJR1JUSVExSHk0WDBhbG5Bd3Y3dXI5?=
 =?utf-8?B?MFVBK2tub0dLSmFjNkpla2ZUK3lJWkdHeVVaWFBQMFFzOGxxbmltU3JGL2hB?=
 =?utf-8?B?R1E1UTRIQWo4aVJiR2xZSnd4aHo1QjlLeTZ4OFBMQ25ybll0aXBleGV5dlNp?=
 =?utf-8?B?enpYNFYzdktRVllwREEzYjY2NEN3Zml0c1dyemdUQmFJOG9yWHljSEw2NXlw?=
 =?utf-8?B?UlhGb2tCTnRBVkNWWGdLZzJpM3lRZDdMSGJBYWNoUnlId3crK003Y04yYUV0?=
 =?utf-8?B?L2pEeW5MUVF5dU9rNmV1UDRRbXBPNGhGRFZpb3pYZzhna0U3RVdvaXhENFpq?=
 =?utf-8?B?VnRVbkc4YzRRd1B2dy9MN29TZ2lqNTBSeS9Bckk2U3A3MFB6NE91UzhHYXFS?=
 =?utf-8?B?aFVqU0VhblFMeHBHdWpuZnRjV1FNamlaY1hNZFNCSC9qM1dBaU9RbHhoaTY4?=
 =?utf-8?B?SkdVN3VhTTc2MVdNZzYxOFN2aW1PMXNmWDJyUlFMU0hmUTBLU051cEtOWklJ?=
 =?utf-8?B?YkRhQzc0UFh0Y3hEYmpDdDlFSnVCV1dmSDVEbjl5Qk5ZVzBJd0FlZ1pZNVdu?=
 =?utf-8?B?blJ3d0RaQXB0eGZHUW1MZUJoUjlpL08zR3lGeCszSVkxS1FHTXZ2dm1XMlFo?=
 =?utf-8?B?Z2dyRFd1Z05rVDM0SXN6STlmSGZDV3ZGR0ZYRy81OVlSYWdBWHlWbm92Z2tw?=
 =?utf-8?B?RFNkVGtiUXlrcllzNTd2L0Q5UEY1TDUwaEI1am5Zc2k3dTJOUW45dyszQWI5?=
 =?utf-8?B?U2h2aGRvZjJXUFk5dlFDOFNyTFQ1SWNGckVoMGhiSWtVd0x1Tkc1SEVsSDBw?=
 =?utf-8?B?dlFFZGRtUy9ONko4OXJudlRmZFhwd2lnWTVvRmszeUVGU3FicFJWZ3lTOWhU?=
 =?utf-8?B?RlM4RCtxMDBkVWpaZENMbmtRSVV3ekdVa01aZGdYdThOeUdBZzNRN2hqV2N3?=
 =?utf-8?B?M0t4eDBsMlM4dEJqK21CeDNsRzRHS29jSUpialYxeGRDOVRuQmNOaHBzQ0lS?=
 =?utf-8?B?aE1SZW45ZEJwdmppREZuZFE1ZWhldk1uUVdCYkViZlM0N0dySjFVUm8rWmIv?=
 =?utf-8?B?eitDVnJWQ1o3SzM5azZXYVkxK2RiOG9ma0Zsa0MyZUllbW41N1JDV2VHTURa?=
 =?utf-8?B?N0FNOHBlOVVrTW9uMlhyeW0veURhYXEwZzJuRFdYYlQweUtmVHA5OE9TbElX?=
 =?utf-8?B?M0NKdFhsN1VOeW40azhiNDcxZktPUmV5WElVNWhzRkRuQ2FwM1UyRDgxWHJG?=
 =?utf-8?B?Y09yZEUweVQzOU9xUDM2MkxlMTJ6cGtIT2VGV1Q3TXdraGxDTnRPL3VMWDF6?=
 =?utf-8?B?QWRSdyt6eXZKY3kxTEhlbEQwVWE4RG9EeWdqR2NlZFQ1V1M0Q3BGUVNNOTho?=
 =?utf-8?B?UjM2c3VQcjFpWmdLaEFhNDVMZE1veU1abnlCRDhYTWE0Tkt2VzgwNGpGT0dh?=
 =?utf-8?B?M2FTdTIxN1JCaEhaNlhYTXlYMkVsM2J1Qm1BZnBMUS90a3E4RGlWSE1xcFE1?=
 =?utf-8?B?SmlYUi9LSmNhRTBjakVsMEhaemkzWW1uTDB3VWFOZUpyVG1qbVEvQWlVTGdK?=
 =?utf-8?B?eG5VeVhtdkY1eWpZUUFzaFE2KzVqN1pJUlhMN2xhcjExdTFnQTF5b3hDbjVE?=
 =?utf-8?B?NnNMVkNSTE9DOEtLTTA4eXJHTGU2L2tFWm1zUEthQll4dktzQksyYWhTQW11?=
 =?utf-8?B?TWJOYk15NHo4dVJMOFZiOEFrYzdqYk5jTmJWcDJiT0hlbE9LajBXbFFneExq?=
 =?utf-8?B?Yjl2Y2R0VVR0TkdxZHZMSDVJdUZOandKbWxEZlFNd1V6bXoxa2E3azFXa2pR?=
 =?utf-8?B?ODQ2aDUrL3A5ZUNxZ1RUVFRTazk5OUIwWmRPa05nYzlrdzlKMzlyWkZWVDBz?=
 =?utf-8?B?SmN4aVozT0VrVUptcC9UNG4wcUtnVGt4MElTL0J1aTRxaW9nSjN4ZE1LVDZ5?=
 =?utf-8?B?bE44enlTNWQ5aWRQeFJjQzZCK05XTHV1TzlwcDlQdG9UU29XN3JzQnhrdTVF?=
 =?utf-8?B?MDkrcVJUM2pKdk1jNWI3MkM4QnF3RlQzU2psdTFvZWlNZHVFKzdCMmZncGZz?=
 =?utf-8?B?VjFIZmJHcitaV3psWFhGNENUcTVQT0hyZ2o4dkN6bGw2eStPQ3FhYWcwYlp2?=
 =?utf-8?B?cmc5eXNXSGtxaTJEZmVZaVRnV3RnMDZHRSs1TldEVTdSNXFGT2Ztck1wWmhS?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eYzQt3b3qGMhHkJNmJYGR5877dJXfnf5sVQQq+vo2pdpau7beL6Tl8Lm/j8/iTIV8HWqkUKQr/u3/8JccuscC/CuDOEZC/hGg9A6qwJcsp70dS1G51JxoyGnNLETWlAJ1AB0WPfWnB/g4Sd+/cnouNJf3LUc2Lgx8eEyC4UA7KMJHctJM0wSUMApkQf3vlBcLTp+nJPvvptK+k0td2jLNEZx1M9ScbV9XNrvEb/Sa1u+bLwCJ4bxr3GYN36ZduFaCLeogbZpWJS3vcxRkiFFP7BDV6XnVRZFHmfzxQ7TWPbVoQ8rLwmfcbdIJV6SB8b3U06Dmv/+4l/tkExEh4BDDEhANYCmwC6qg7NWzNDBAASmwEQxCuWMPQpBbzGErOKp7KTXGmEPs8PeUPNmmMasHryWFhndvGu0vgfWEjI67NwIbO2jzapzYAM8PksusR1E7eCskW00Fs2FiuTVGoZ2gusLBbvjSUTSuE5ex/4bkUQM73NXMG9eJfFNF1lgjxNO7FvC9ywu3hsW23/3l1uyHYJTr0ajSE5U96dW6hzUmqlaNenfXBthLvvFl9CPB1wiOXdIUa2LXAM74G3rRvbCgWgO0rqb3rcoCxnoZPQZAog=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 632a79a2-c697-4abd-c5e6-08dc5a2a2bf2
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 13:20:35.4054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIwBhEAchNQHypb/tIUWqVfJK0TduFR4h3NSSEiI/YaL3QcVbS09tCt0FKE0/UepoLQkDTtNlS8R7hpxMuZjIZUdLdGYmhOrvTU5FjNu46o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_06,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110097
X-Proofpoint-GUID: UNBWoE-P_2CsCSTetAZcUxyGV4LoWDYj
X-Proofpoint-ORIG-GUID: UNBWoE-P_2CsCSTetAZcUxyGV4LoWDYj


On 4/11/24 13:14, Chao Gao wrote:
>>> The problem is that we can end up with a guest running extra BHI
>>> mitigations
>>> while this is not needed. Could we inform the guest that eIBRS is not
>>> available
>>> on the system so a Linux guest doesn't run with extra BHI mitigations?
>>
>> Well, that's why Intel specified some MSRs at 0x5000xxxx.
> 
> Yes. But note that there is a subtle difference. Those MSRs are used for guest
> to communicate in-used software mitigations to the host. Such information is
> stable across migration. Here we need the host to communicate that eIBRS isn't
> available to the guest. this isn't stable as the guest may be migrated from
> a host without eIBRS to one with it.
> 
>>
>> Except I don't know anyone currently interested in implementing them,
>> and I'm still not sure if they work correctly for some of the more
>> complicated migration cases.
> 
> Looks you have the same opinion on the Intel-defined virtual MSRs as Sean.
> If we all agree the issue here and the effectivenss problem of the short
> BHB-clearing sequence need to be resolved and don't think the Intel-defined
> virtual MSRs can handle all cases correctly, we have to define a better
> interface through community collaboration as Sean suggested.

Another solution could be to add cpus to cpu_vuln_whitelist with BHI_NO.
(e.g. explicitly add cpus which have eIBRS). That way, the kernel will
figure out the right mitigation on the host and guest.

alex.

