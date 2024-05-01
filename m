Return-Path: <kvm+bounces-16293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 940D88B83DD
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 03:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFAEB1C22AF6
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 01:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB8F5C99;
	Wed,  1 May 2024 01:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QvkQ7AMB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OfysmQi7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7344400;
	Wed,  1 May 2024 01:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714525294; cv=fail; b=VCFPKbSwB5UF0mOB768D+6GVm3Y5jUr2xoZ5nRoRrCs9Ag5lDDm6spq0A6DavjvyySrFqrA8YpmbyA6e4POY1bFhvaTLpyJ419vbldUrqaj5pFGMd0hPSfGBA5mIyRdKvtOt+uofZSpm5+EBIPV4E1wx2wih2p4s3hhqFIRwfEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714525294; c=relaxed/simple;
	bh=/XIP6Azm1vAnPhhYlEG1WJZhwHDDmE1SZMLllQD9oVE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sTM96pM3HhyzHvBELqYhLPE782pE8y7o50wXMLtVxJYNBptBRb5InU28UuhVuQAC7oC/pUS+/ZdgIVysGz+Ail7TRdrjH2zPMXDyRW74KiiyHxTykxrfYI887ucyytR7PPE1+udm5YDVUOnY+jHB2GEZ5YvcLxYwNVXxljodK8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QvkQ7AMB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OfysmQi7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UKTuIj014020;
	Wed, 1 May 2024 01:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=7j7ZsO/QauoxLggwG3cX2XqDCx0/r/4BsVa3+g03Egk=;
 b=QvkQ7AMBSj26CyStlj470Dyj0KNb7O+0gZWKIsfGTRwXI3uOJvC4Wu4pM08qH9eHTJyF
 HunloaisqVdj+jKGnc0W/xikqfSgG9oB8CRFdPS3CQtUmiGxXqafTIYEICH1p4MRyRSY
 IevoIKgil/NcZ7Rk86mPCFIn890kZyi9DkB2M1DqwiizbaTWkrCvhutYu08gFk++v+CD
 pD3BcxcKSSjr5YiULOwrm0asQ+fE5196scJ73wkxiAEHbkt96ZLQxTQ9Ll61oku2+fgs
 ldwMXxzjEn9FZFcdhfCXF5Ca2yNu4sKAe4ZIwdNEs0nzRNlrzOl0vBnfe+3lgOiN9QkR Sg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr9cpgjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 May 2024 01:01:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44101uWL016713;
	Wed, 1 May 2024 01:01:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqtertqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 May 2024 01:01:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4B1IPBK0G+98VfbnmOFcCGGKp4AJIzz45fWDEgXOSV7pIR4p++O3uAc72RDJECGNYEeHYrR2Ve3VWZxYIClZph46xyR1yxMpcD9ica62JVxqA43vTE9NVaKq8yBcWmpRV0v2XkYHWJ/itzqm0CxeVpIKFcalB4W9bJxIgk/hU0uXyd48waurQqtyYrTuXdU7C64AH6WJUX+MpVZNLsMFUDlP0p3fotY27l6G2BZay2mUm8v/StMMxQNVREVx31SB3qh/H6MmGzIe9abC2mYe2oDcxUFFIL4iVTAORbkc2O9SNckFC55bEFIYp0rGzwTEn6vnnETnnR2W5BaadQAEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7j7ZsO/QauoxLggwG3cX2XqDCx0/r/4BsVa3+g03Egk=;
 b=alRmCeb+uMVurO3zkBRvduUz/pVuFFZRxL1uO1bjEx245povwhnQQdfXcwMenFUvCMpLoSJA5Qo/i1qQUNqe7j35Qh5Z+fPo7DGk+/emP8BZ15GT2oqQDSVy+2gylr7PYcGptGSXSgZOdLKCsoY3Z2TLt51kQm1PGXzwg/Seev70sGu4rzvi7eDpjwBIgRvDVpgMcoj6cp6ML0rtUnNtM5fn1KgOYH365XsUupZJ6W+pQ72nxA6ohdBX/Qefvfpxar4x9pZQjca5DFffIDPk3ohF7UoTKwdUspP/wQXFSfGUALS7RyUJe8Itr5GvPnNPUm/4A7vFzRB9kafXTfFKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7j7ZsO/QauoxLggwG3cX2XqDCx0/r/4BsVa3+g03Egk=;
 b=OfysmQi7RkZCtV+kSEXxdC9clIxURvP/xAcam8+yx1ykmTBH2NepOupiS/kCX67coJRbTU9NK5/1T4QjLEcnkvlIj3QHvC4HoqO2jKoJ/D+Roh7iKKlIYStU0sDkCK7w5+JHuINEFrlEackcou+srGoqyRRivDlttMjb5nJ3ASw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4121.namprd10.prod.outlook.com (2603:10b6:5:21d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 01:01:13 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.7519.031; Wed, 1 May 2024
 01:01:13 +0000
Message-ID: <59d61db8-8d3a-44f1-b664-d4649615afc7@oracle.com>
Date: Tue, 30 Apr 2024 20:01:11 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] vhost_task: after freeing vhost_task it should not
 be accessed in vhost_task_fn
To: Hillf Danton <hdanton@sina.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Edward Adam Davis
 <eadavis@qq.com>,
        syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux.dev
References: <20240501001544.1606-1-hdanton@sina.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20240501001544.1606-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR16CA0022.namprd16.prod.outlook.com
 (2603:10b6:610:50::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4121:EE_
X-MS-Office365-Filtering-Correlation-Id: ed262578-b212-4d51-74e3-08dc697a3238
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?aDFQb1dBem5DRWJqUXJnaVpBblYvbUErSjVlZ2E4R1o1Ry95UUIzWlB5bHkx?=
 =?utf-8?B?dTNTTUc0UGdmRzRERXhleSs0eGVLczZuZGFvVkphUXNEQkFlZ05GclZSR1FD?=
 =?utf-8?B?ekVsaXZ4QUsyd2xtNVFFSXFFbFo0M2tvVUl2T1RtOXdsYkI0cWRuSEJSZ05N?=
 =?utf-8?B?U2hPeVY2enlhMDFIMzI0ZnpnRUJnNWJsNWxaRnNUdVRLenZyZEtQY3ZNbHNH?=
 =?utf-8?B?WlQ2dWtjdXFuVGV2aGR3Z0JCK3lkQnhLcnVQcHJ2RjVYVG8ySHN5NE5KakZw?=
 =?utf-8?B?Tk9PQnhKUGxLWVRiUWl2a1hOWWY0aDRaVUtjYmdlUlBaZWN2eXh1Rk03SFll?=
 =?utf-8?B?dXVFZ1gvOFRrZXpkMjVUWi82SEZ3UjIrcms0MEw2U1JSeVJKMUxib0FjOHJG?=
 =?utf-8?B?VGdBMktkYU9CRDVudjhVSE0vVlg1MDB3RFRpNmdSOGZZQUFTVXNOdEMzRkV2?=
 =?utf-8?B?UDJCUkZQQjc1S3FhczhCYkRYdy9xamVTT0V3eStLNGd2RTJ1OFd3THd6UVpS?=
 =?utf-8?B?ekc2WEdxdkNjaEZNa3ZicTdjYjBjMitnaWpKNDUyc0dJSzlCaElSTVBQKzZE?=
 =?utf-8?B?VzBNZzUxNll4V2JLZWtvTWgveE9wU3ljRXM1ZmJFSmVteXVmMVBzSm5UVFNk?=
 =?utf-8?B?d3VOZGhGM0tKLytrWTQ2Q3ErRlRGWE1TNDUxKyt4dmZWd2RSeTZUQzF3SHpk?=
 =?utf-8?B?S2VmaGRJT0FPb3JrcjBzN2ZUTjRmWG1vV09RZ2tYblowM0l5RnkzeXZVZWo1?=
 =?utf-8?B?NElOdzBKS0R3MDNDR25OR0FjZ1QveGErYk92b3pnTitqM1NVaU1KdXlGZU0x?=
 =?utf-8?B?NGtSSmRobHI5TnJZRHdGRmplQ3JTTFNGS2JVdWV2K09aa2hWc3U1Q2Y0ZGhO?=
 =?utf-8?B?ZVhQSkJCdkluK3RWS0trQUQ4ckM1S28xeWtod012RVBxKytWb3BmTVpHN0tj?=
 =?utf-8?B?T0ZsWDJ3ckFFODU1YzJwQWYwOFhYQ1pvYmdVRkZrTmNrZklHcng0Y0hMNk5O?=
 =?utf-8?B?eEV3UzJDaDdZdVZxc2tYSFdDQURuM2ZQOWt6QWVpRzhnT1hQSGIxT2VrTDJG?=
 =?utf-8?B?aHFyV1Y4RFB1aE9WaEhYNXhHYmZRcC83R0ErTUVLS1JFWklaQnNoTnlqVndj?=
 =?utf-8?B?Z25SY24xa0tBc2JGY2dXNGFVZzBTaVRCS3M4Q0xnYk5YOEZBakdLMmQ5N2FM?=
 =?utf-8?B?U29aTXdPb2VJQmxUZmJXRks3OHhJcCsrWDFoWnpyQzg4RXFYVE8zR0RGalQr?=
 =?utf-8?B?Y0Z6aS9SQmpjU2hRdmsvakpkQWljRXNPMzFZeGtjLzEwWldYVSs5Z0RhUUlk?=
 =?utf-8?B?bHUyRkJHMHdlQ1BTMkMrN1dHcytnUW1UTnZHUmJXRE9wUkVZMFJiZSthTStD?=
 =?utf-8?B?K3BpeHo5allnSVNEaGpDSzNpQ2tVZ215eEp1SjQzVWdUMC9pUjRlbmpNZUhx?=
 =?utf-8?B?WmZ6cDdPSDlaVVkwV3VBd1htZlY0V3VjY3pRdWFIQW1JSnlWTXhFMHFQdkll?=
 =?utf-8?B?dFJIRGM3OG5ESzNSeXpGbFhaa2JaYXNEMndyWU5Oa2RaaW1qZmpnWW1aaW40?=
 =?utf-8?B?clBLY0k0UHNpQ1hZem5objVJa1RXQVM3c0NXVy9aeDVwU2UvZ2NWMkxrQTg0?=
 =?utf-8?B?S1ZIVHJXN3ppQyt0Y3FPQXZ0WWR5eG1BZzA0UDZjTHl4UVpWTmN3NDZpS1E0?=
 =?utf-8?B?VTBpdk5aZVBkWHcrRG42eEpRN0Y3WjVZV1EwYlJvWVRLUWlIT093d3ZnPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MVFkbG1KbG02WDBXbTVKZ3Rab3hvWU5sWWdPSmg1Nlp3OTA1eEc1Vm9aVWpX?=
 =?utf-8?B?bFFDc3cyQkN2T0lFUHd2cjc2WFVPd3lSeWlGQkd6aFU0MWlhUGJ6aTFldEtv?=
 =?utf-8?B?TjB0eS9zeU83UHVTL1RIMVZYWDBaWE9hbFZkSGZuYk5KSDlSeDlqR2E0Wmls?=
 =?utf-8?B?T2RBNGNjSGVwVUdVMHNMaXlPcjMwbWIxY2NKUUc3TjY4eDdmZXlmMmNnLy92?=
 =?utf-8?B?bGxldVVrOHZFdXBKMXM2NE9ub1djNXFXSmpsNkFEWVNNME03aktRYkRjbjlv?=
 =?utf-8?B?V0N1Y2YwOHFtZHZvb1FUUUhqSUppdXdmbVhaYk5TMDNMcmFlTGVjU0Zjb3FW?=
 =?utf-8?B?SlBYZFRBcHVIZGNHaWQ4VEtkcVJjcFJXUk04cjZiYlNCbFRFaU4xeGtqVGpn?=
 =?utf-8?B?S0xiS05vdnBoTnJlcnFnRHJJcG5aZldWMmVyd0laa3FSZnBjYVhsTU5ZaUIr?=
 =?utf-8?B?K09lMTJhRUNiQVFGSVJMOEhMWGlOUit0bG1yRlV6bHZUcS93OGZVRDh3QXh5?=
 =?utf-8?B?VFhnZDExSlc5S1lYTmtBb2w1N2tISk8reUNVUVBIVDhxNmdKeHJUQVRlK0Fm?=
 =?utf-8?B?TEphVUcwZm43YWRpck1wY0ExTWlZWHJ2Z3BUME1DMjUybm1xWHgvMUd0eUlM?=
 =?utf-8?B?bEtNRmwxaHpsLzFFRjc3WGRsaTFldk50VnB3cmQrZVBGNUdaZzdwZEwvUDZR?=
 =?utf-8?B?ekRMcThjZ080L0FEZGU5ZjFxLzJ2VlZzN1NiOVl4d3B2czNNZlA5OGxGNGlI?=
 =?utf-8?B?b2toU1FTSlU4cjhVaG5EZytJZ3NXcjFTOGNXQnYxWUs1SUkxUW05ZGUwejBu?=
 =?utf-8?B?YjdwbHduTmwvWEZKcEpGM2NGcExyVU43Y3gzMitDRnMza2xCQVhYUlVPN2No?=
 =?utf-8?B?RXpuNmZkTm5YS3RQc09TVFN1dFFBZW9BUFBFdlA5akljdjhNN3JDaEhiZUZ5?=
 =?utf-8?B?bmpnL1dMb3RtNVloWENGdHVueFFrckVBcGFuRTZVQUJHYTZLTVVPdUpDT3gz?=
 =?utf-8?B?aWRoVm91YVFxbHNhcCtNQm02OWMyZ3hPMXliVlJwMmhINkJKMDNhaEdtSVpu?=
 =?utf-8?B?b3kzVG9SMTl1SnZOMk8xaFp1ZWc0T3Q3R1VIeTdZR0p5NjJINGtzMzN5L2du?=
 =?utf-8?B?aTE3OWwvaXEyb00yMWVEVkpLOTVmQ3BwUDFkYmZiMVgrZXpLQkIyWHFGZDBO?=
 =?utf-8?B?T1RjSjRPYTl1R2Mrd0VlZEp6THRKRytVb1hHVG1JWVRSQVZ6cFpMdGpsR0Jx?=
 =?utf-8?B?NGNXODBnMUhOMFQ5ck5rc1RKY0tZd25vUUJPZ1J6TDBydURCTlRra0c1OUpN?=
 =?utf-8?B?eDdEZ29NQkFlWHcxRHFTRS9TUTZvZDdJUmpJOVoyOFV1YjZMSjlCYmdsMnNu?=
 =?utf-8?B?RWVsM0xnR2NNd0Q3YTFEdjNZWXFTSHMyWWNUZW40M0RxOWxyM1dLUEt0Qlp3?=
 =?utf-8?B?Q3FWVXh3TWRnOEVzSkdPbG1BMGlOWGVOcFVkUm9Rd0cvbTBWelgxZHMydlYv?=
 =?utf-8?B?ZURqWGo4VTRpR3dMMnhBY2s2N3c1dzR6cFNIV2lRWlpKL3cxa0hLT1ZkUnhO?=
 =?utf-8?B?clNQVUJONGZBWkE5OWw1WDB4RW13eVJKZzFuUVVkbGpobTFKNktuYWZPQzdv?=
 =?utf-8?B?bC9lU0lEam1ZQnlzU2NFbXNVMjF1YkpJL0hmK0xGN2x2R0Z0eUwzS0xNdnNM?=
 =?utf-8?B?RmdYUDhPVW9TN25XclV6OFc1SSswdTZseUpUM0VsaHBYMkZlYTZ4b1Q3WURP?=
 =?utf-8?B?SDFEYlFYdDJBU1hockt0WTNmdUtaSS9SRWZmN3p2VWQwejZnY09ZVkZCVDA1?=
 =?utf-8?B?cnRiL3FmaEJzSGtYTlZvbGNnUWN1VUYxd2VwcE1Zc1ZtUktHc2JPVUx6VldO?=
 =?utf-8?B?VUJ3N1A3TUMrZHJZUHlVYjB1UzlveUlXNTBBNEFnV0J5OVFBYm1CZDdWejYw?=
 =?utf-8?B?L2NDTDBMT21wRE1MRXZLeGwrUFFCdEJTK096YjBIVDV4QjNLTjk1YStCY0o1?=
 =?utf-8?B?cHUxeDdHZFl2b2J0YTF5cUFCbVJyM0Z3alMyNG1pVTYzN2VHbE9WaVBtT3By?=
 =?utf-8?B?b1lnS0ZLRUVCT0R2UksvNHFQdlM0QnU2QzVkNm9ZS2JTWHdKenZBbWRvN3Z0?=
 =?utf-8?B?MTBTMDRGd3lCbFZGbkhvYUJva25ML09TcVIzMThDREN5U3JjUTFFbHdkR3BO?=
 =?utf-8?B?R1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5hpH5pofg8DqW+MKKW6qn6HT81r/Znq0ddZ1KD1TpfwXJftQBFoZRHtd+CRHtO7kQKPwy5oFMn6PABcxxhXdvsItSxeT+7KA2DOGNP6ay0stvWh15a0ZXs0KnttKez/F4o1ousp+V3mXATYFdNeT2hfMtzRjO9oejDV6u1LxIy8kYzAmEKSR6GDFhv9ku/XlXh8SGiUKNL8KJR5uklswreuc42gjSURqFHjkXXouN8ZGG54x7BWTeTcPWUnGNP0ksyL7mZ8Brs/+2u9LvyM1U23y0U47rzXnLpXxevjzxyvJkbKByxTeuXpoBUtTWzMZpDwyeij7th/TBgqv8mHV6LkrpZQdLh6/cv8cTltevVJEyXKFLtUrdsSFBZhoi4OCix0g2f8DhHnlixTtcHBaf1eq6sNYCQQOp7ov/AzYtuX1m5p3EcKFNKizTHjr2DU5OR3nMatNxtZCAAkbd8UyZj1VunyHmRr5EGlnX8za7GsdJcSUPJiCfGLD9zJHJIcWB69V5AHYI67idiUn9LitQYThUkigvc5KuSIqGDa4B6rtEWbYLmM4Sgq/jJAnJDCFkvWahfExmDh+e1Kxw2TYN3ik0gMnRzyg4j4jdSoNYo0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed262578-b212-4d51-74e3-08dc697a3238
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 01:01:13.0320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvGGTU62/X993kLjOtbXQ/YhnSyT6XmvG/5jyfbtLD8LpCe1NY1Wb2GfDNCx5UF8WX6dATXe5hzChLYpoCycabeVMR2waLEp3FSPyxI2aJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4121
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_16,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405010006
X-Proofpoint-GUID: IitefCj1Idr92CnS7ZbmtkHTA-_AGIHe
X-Proofpoint-ORIG-GUID: IitefCj1Idr92CnS7ZbmtkHTA-_AGIHe

On 4/30/24 7:15 PM, Hillf Danton wrote:
> On Tue, Apr 30, 2024 at 11:23:04AM -0500, Mike Christie wrote:
>> On 4/30/24 8:05 AM, Edward Adam Davis wrote:
>>>  static int vhost_task_fn(void *data)
>>>  {
>>>  	struct vhost_task *vtsk = data;
>>> @@ -51,7 +51,7 @@ static int vhost_task_fn(void *data)
>>>  			schedule();
>>>  	}
>>>  
>>> -	mutex_lock(&vtsk->exit_mutex);
>>> +	mutex_lock(&exit_mutex);
>>>  	/*
>>>  	 * If a vhost_task_stop and SIGKILL race, we can ignore the SIGKILL.
>>>  	 * When the vhost layer has called vhost_task_stop it's already stopped
>>> @@ -62,7 +62,7 @@ static int vhost_task_fn(void *data)
>>>  		vtsk->handle_sigkill(vtsk->data);
>>>  	}
>>>  	complete(&vtsk->exited);
>>> -	mutex_unlock(&vtsk->exit_mutex);
>>> +	mutex_unlock(&exit_mutex);
>>>  
>>
>> Edward, thanks for the patch. I think though I just needed to swap the
>> order of the calls above.
>>
>> Instead of:
>>
>> complete(&vtsk->exited);
>> mutex_unlock(&vtsk->exit_mutex);
>>
>> it should have been:
>>
>> mutex_unlock(&vtsk->exit_mutex);
>> complete(&vtsk->exited);
> 
> JFYI Edward did it [1]
> 
> [1] https://lore.kernel.org/lkml/tencent_546DA49414E876EEBECF2C78D26D242EE50A@qq.com/

Thanks.

I tested the code with that change and it no longer triggers the UAF.

I've fixed up the original patch that had the bug and am going to
resubmit the patchset like how Michael requested.


