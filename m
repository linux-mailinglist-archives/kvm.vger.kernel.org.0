Return-Path: <kvm+bounces-18845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2128FC2DD
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 06:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BF551C21C6C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 04:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC6613A418;
	Wed,  5 Jun 2024 04:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BOMPJtHD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DDE13A26F;
	Wed,  5 Jun 2024 04:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717563338; cv=fail; b=L+hg8B9AYTObfZ+RANatYunItVE79p8uLBgKccWXS3jeKvGf0s4FoXvzkUqRmDVaCorxtfNpKLXE/+MlLxVtuBF0Q4z6FVC2AQCACq9uiIGdWbtnsx94qJx90NQChhV9HkilldAac8xsoHHDN3Ddxn0Shk+j5fonJ+8rIWtWGWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717563338; c=relaxed/simple;
	bh=Dw40Za6YpyfzklaCShxYP79pnru38WSfuGkBYHcfbGI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i6NcYOxgL0r3n3uhcCXMR9CvdPsiUaJPlAHmoAMK4nhXO8Nmysgy+xSFM2IBAlNrXckOLPJHr6qNDUPhtaWqVATwffCpS1Klb2GvM7w/0lM33H2V/1LyYJYUjytC0wyK4L/12piH9DM86D+kzQZSB8+X9XKqFZM182iL5BaPu7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BOMPJtHD; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ydk4TlpPq55yepI7oXYEEwr/8ag2VZmNy4qPsCRmaMgFutopZ/iGWmgYYLbUz1kGbXMHe0HNrukStqu2NLkDCxbqVUC/Krvrodo1Oj7eZB17NM49qlvjRsb3ggXKDRjG/z08w5pXE7jpgqHz+cR8iImly1dszYgaC39Od4Abn/y38S6+ykQiwTAKiHsNpyioyvFe1dhJbGrhEqkbzWHK4RBdaOJk7uoSFGfUhfyNXFiddqHVbbvi5qKxW4eqn7ct7DZGo1GlODhNtTFHsYgZ34i0oyYlCbkVIF/+Fnz+wH7Dl8Y8YscZcj3NY8tztUpBE2p1XqJ6crdkiI1IDc0R7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qll2ZFvXuqmKnBTKydr/q68ZUX21MCE6/09QmM660oQ=;
 b=T1gctGJ5hwNVhU9n5BeFcG33NpG13YqWE7tYJMDJJbMoO0PLTQphUxSAfA6r4GCvgWxGhJcLz4gWeiKnKb4OKrwgNfR5f6wHOpZbyRqW5tkuZninzpC98Ucdpjg6FUrg39XHqvG/Wl8eVPuAgBovOTEQH8eBJUp8iTcPXRnIwLS/5n7VFcN+rkyZvvt82f6nX1wW4tdWuhkTzlPt5GyafjLvqfrXbDTQGvIonvkPWkQb03cqlHRkIJR29Ufrwl9BMqw+9VUOKbancmzOUtVwqIxFd3LPaGU4G9xtWrZMhpKpyw5brGUknh8xEjDdbtZm/Egl4YvxYfHl9v6ZJzgCww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qll2ZFvXuqmKnBTKydr/q68ZUX21MCE6/09QmM660oQ=;
 b=BOMPJtHDJk/lyh2v9B74rIkWZVxplvPojmECoofaepyiP843m61V7aWLLRbXsg/l5pV4azEsWNoyT2xZSlvnlqsw4RDFnPqbU4QTIqw+yzGZ/8D7MwXxgy1cXYxGIbDeCg41mppt9rnDepkQWDiI4ClTBrdH24Q9QmaPYLQwIzY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Wed, 5 Jun
 2024 04:55:31 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf%5]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 04:55:31 +0000
Message-ID: <adf40ee9-8b8a-4cac-a207-4d3d4ded2135@amd.com>
Date: Wed, 5 Jun 2024 10:25:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV-ES: Fix svm_get_msr()/svm_set_msr() for
 KVM_SEV_ES_INIT guests
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Ravi Bangoria <ravi.bangoria@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
References: <20240604233510.764949-1-michael.roth@amd.com>
Content-Language: en-US
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <20240604233510.764949-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0112.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::30) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|DM6PR12MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f72764e-b9ca-4750-8973-08dc851bba3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmFocDExRHRWZzBHc3N2bEFZMTBwdW5CdDBCd2NwNWtMbE1KTHVqYUZxeWxG?=
 =?utf-8?B?MmxzOGFZRllocThjcmQwQmh0TFZ1UmlTbm5BYURkWFVrUlFqc0d6bGpNU3dK?=
 =?utf-8?B?WXEyK3l1RmJWK1BIRjNpK1JrMkppUFh3L0hNNjNTZ3R5RHF0a1BsclR4c3Y3?=
 =?utf-8?B?TmVNWGUwVXlLK0ZNMnU2RGxLTzBJc1Y3M2dkTlN0eXFxRk1ZdEFITU9Za2hj?=
 =?utf-8?B?TWhQUmhZVXgyb283QXF2VE13OVhGbzVYL1l3T2srVGtORTBRL0tmK0llNEhp?=
 =?utf-8?B?eVRub1k1aHR4L2E3bzlNd0pHYWF6d2JOWXhuMlBtcEcvWXRqeUlQRStJS0VO?=
 =?utf-8?B?cEJjQjIzK1laU0pvK1NoUFY3T2kraW9pZHcyWHdINkF6YWhQbGYyU0VKT0c0?=
 =?utf-8?B?ZC8zb3RuUzlUUnIxS0ZFdW9OMDhMekN6dkZBRGFsWHhDQ2F3VzZPbCtyajEx?=
 =?utf-8?B?ck5vbTJocjd1ZmJpdFJCRVRjZWg5TkxOcXJEdm90QUp1WktENzVEVXpLbHQ5?=
 =?utf-8?B?TjVpS0t1VTlYaXhySG5MT0RYZkNrekFJWHNSZHFzOS9sa1pHYk51ZUNEbFpa?=
 =?utf-8?B?YkcySXVLWmdOVVNoZCtOSm82K0Nqemx2WTIwUXZPd3BXNWQzWWlwT3JJM2xo?=
 =?utf-8?B?WDY0UCtXbGxOcndyS3B3MFdTUGcyMHlRM1dBNEFOZ01tRVgxL2RFQ2RPc2Rz?=
 =?utf-8?B?OWZROWJ3OEx1SHFibHJLY3ZvbGtrbEU3bWRMZ3Z5dTdmK1NHY3BOVFlXUXRJ?=
 =?utf-8?B?aHpaN2JIamdWOVRQVGlSN3V4L1BNSkxBcGJPMzUxVld3OGxpbWNoL2FmSGFF?=
 =?utf-8?B?Q1c4Y0wzOXo3OGhncEkrVzZQY3BpMEllSEFzY0JNM1MzU2lxSi9nL2h1TTNT?=
 =?utf-8?B?T3hJUkN3MmF2TlVGQ3o5THIzOC91QW1SRHRUSFljZXZGRldZdXdzUzQ1SXhO?=
 =?utf-8?B?U0lnVjc1YkkvSEJPaEdzb25iS1l5MXhWT1FubFpLNjFnaHhJRXhYajEzMXdH?=
 =?utf-8?B?OVFvb3lxdEtZN29mWS8wNnJVU2hFQkxhSnFXNFIrUUdLWTdlUVFDZm90a0w1?=
 =?utf-8?B?YnR6dnpjNnVPa0lBbWRuZVlObnVQdzJkaFFNOXE5RmxQODRRTVZsUWNOMk5V?=
 =?utf-8?B?bVZ3SXZUMkFCWVZkOWFkeTU5V2V6bzlDMnFjU05aZDBVeTRvYmZmQllqTUx0?=
 =?utf-8?B?bHl6M3MzMTU1RmwxMXZLdDB6WFk2VGZhMW9YZDcwSzZld3hSeGpNNjFoUGY5?=
 =?utf-8?B?ejlqc2pwcS9tdWlsNk91WFV0dzRHSVJSa0JUdEp6eG5vdlJVTXRCUmRjbERq?=
 =?utf-8?B?MnlsQmtHM2dMRm04UFppamtxbUxDbkJLRy81clBRc3pUYXFZMFVqb2VrQWMz?=
 =?utf-8?B?VkJBZS9vQnptRzl4WXVOYWt1UGNQM2xJN3hKZncwNGMyK3JlRTR3T3RNclBi?=
 =?utf-8?B?ZCt4T3pCT3RUaE9GYmN3cWVjamE3ekxWZlZ6V09sb3NLTndhUW1YMzVrWUd0?=
 =?utf-8?B?QTJTR0ZMOEY3bG05VElNa0xyQ3VPT3NuR2RROHdRbXNldmpVK0tsU04vbzh1?=
 =?utf-8?B?TG9PMmY4TS9tVCt0ZTUxQnZ5M2h1WWYwYW1DVkNlY1hneXB5TGwxUVMvRnln?=
 =?utf-8?Q?/jn1MQ7Qy63aHNJJfUxV7u1FxDUI41Q7JQYvNxDFPOcI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amZoMWNKQW9PZ3RjeDQ0dU84MU0wLy9QSzZBbGl2RzlZMEFKN2prWVBmbFEz?=
 =?utf-8?B?QnNtT3dNeko4TDF0ZjVMOGZ1c0N3bzlmRjhVbzYxeXdSNDA2Zzl1Q1hTdXhi?=
 =?utf-8?B?OGVxek1pWEFjRlY5cmlFYVVUNlo5NXhuRmVBUkc4czlQQUk4OFBjL3NGdjcv?=
 =?utf-8?B?SjlBajlXSFAySFpBMHozWllGWTVtdXhpVGQvc3dRQlhJbnJFZ3o4MmJ0MnEv?=
 =?utf-8?B?R0xGWnJYSGdlSGNNL0F3dU9HTzlRYVFaZm1OOGRTSGhTTnBqaTdKSkJkZTA5?=
 =?utf-8?B?OVkrSllnZ2dxY2pyckYwaG05OEVBbE9xdW5LMkJkamxRZlFnZDZvNWxkN2w5?=
 =?utf-8?B?K1F3THE5MmlMdHcwMnN6VnlrUVpSTHkxeXdSRDV6cVNjVmlqTm9DVC93OTRV?=
 =?utf-8?B?VCtSbmloTVVIdDNzS0VVQ0F0VTl2MWV3UjNNNTl0d1ppZnJBZGtVcjNRTWVU?=
 =?utf-8?B?RUhQT2ZkOVFucnNlcThZM25Zc05rUGVHb29sempGL0htMEZYOHFiOG5SQ3ha?=
 =?utf-8?B?OEpOUFV0dEZ2Nm05L3F6REY0b2JobnpsOFNzZTdqUmV0TlRVUGlwa0pYMkJm?=
 =?utf-8?B?NVhOU3VKZ0w2eWdISnN4NFR5MFpKUnZGNTNjdW95ODNDM1AweUpib1ZzR3hl?=
 =?utf-8?B?OWFpNkNtVmpiV3BSR1RzdGVkZU1raFU1U0t1UDFSS1kvWGVKb1NVdU9ieFdh?=
 =?utf-8?B?S1BSWW91djkwcFV2NmxhK2YzMXlOTXd2UmYyV3FmRzJHRjJtcmU1N1ppcHdx?=
 =?utf-8?B?aUgyaDFQT3RWb01SMGRkYWtMaHV2V2RPQjJFbnNsNW1GSElyTUVtUEJVc1NZ?=
 =?utf-8?B?RDJJY0NMWEFRYWZNWWtuQzlIb3cycUpZb0tzTEEza3RuUzVmelZnUVNuWlRW?=
 =?utf-8?B?TmpPZUtRQWhyM1BwN1ZEYnc2UUZvakUwcXZ5RTBZUlZKV2pJaEVONVVJQktS?=
 =?utf-8?B?cHB3c1pJYVRHZ3EzaXJ4ZEhESDFraVpLQW9VYzZQMDl4SThVZTUzejliOXpM?=
 =?utf-8?B?SWN2R3JpME41RHFyamw0Wm45QWt0aE1TRmF2dmh1Tld2QWZyM0psL2UvUUEw?=
 =?utf-8?B?ejcxKzVsdExkMWNEMFV3QTVQaVFkV3c4L2VjcW41UUNkNFozVEs5eEZjdjRV?=
 =?utf-8?B?d2RKVzAvSWs2bEdVQlRuWjVIQkMwYzdlZEFYTnlCM1NXSUFKKzJhRzNCU2t2?=
 =?utf-8?B?b2VJWlV4SDZDcWxJRndPVDZIV2E5MlRxckY5bDA4cVY0NmN2b2d4aWhZTy9h?=
 =?utf-8?B?Rys1bHJVczY2cUNUWXBCUFRsTHBHZm5IaWJpU2lENmRGQTVCSkdOOTY4SGRK?=
 =?utf-8?B?U2o0NzBkZyt4Y3VZcnN0MmdhRkUwV28rSWFZMUdZalVkYkZUa3dSb0VodHRV?=
 =?utf-8?B?djFyOTZ2dlg2R3h1MG1sMGx4aWUxTThWSjJiUTdlai9WT3pVMWp0V1p6Tk1k?=
 =?utf-8?B?eUxQbGNCSUJpNm1LeXRaUXNiSi9zSm1PQmZjRWRyVURnZG1VNlBvcmk1V1ln?=
 =?utf-8?B?d3RoaUNlY1VRb0YzS3lXZDlkeE5zSDk2c0R4NFVkT0UvbUFiY08zaUdSc0FK?=
 =?utf-8?B?U29rK216OXpoMU9sV3hNNE43VndKYTlUWnNsVWY5N3R2NG9Mc2RweGRMeVV5?=
 =?utf-8?B?cHpHR0VDc1hGZ0RZSGRzc2NZUnRpdzlrWTUxOEZLWTM4UFBBMzk0STJNMVFI?=
 =?utf-8?B?YzduU25LaGJEMkN5ZU5pY054TEphajhramVFWnBJQU9MNG5EaFJFS0VmZVhV?=
 =?utf-8?B?d1AzdE94UWkvVWRlWCtKM0NVRkZTWWtIeXlVTmZCdTZFQzFlbmpYNlBtUVll?=
 =?utf-8?B?dDNsUVZvbTdGUmRZYk5ZLzYzQVVZbmYwMFlYbU8yMnpSa2JrRjhyWW9ucy9K?=
 =?utf-8?B?dERNVGpFR2c3UVI4UWVKSnF0c1ZkYmpaRWFWaFE5dTdlOFcvR0REQnRtanpQ?=
 =?utf-8?B?THdjdXVXZDd0L2R3dGxMWDM5RFdsUzNEbGROSmFadnJ4WHhwcTUwVWgzajdh?=
 =?utf-8?B?S0xWcFFqU1ZZL01aOVpXaExFc2xhRzMzeC96WTFJdjNUV0kxNytZQlJxNUhk?=
 =?utf-8?B?YUhuN2RNaGgvMjlwVXFXZjd6RW5TQ1hLQTcrTk85VlVsSVN1bk1yYTR4V3p6?=
 =?utf-8?Q?kaSvl7DsNFyfzwYJ+y9B604kS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f72764e-b9ca-4750-8973-08dc851bba3a
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 04:55:31.7882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lknLxl2gsmp5Jf+8fQu3NpSBlu7/jEhMAnhe1ERJIegBBF+9RjjFFpl59qIwMOOw/B0nFbmLvusM62rUBO8enQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220

On 6/5/2024 5:05 AM, Michael Roth wrote:
> With commit 27bd5fdc24c0 ("KVM: SEV-ES: Prevent MSR access post VMSA
> encryption"), older VMMs like QEMU 9.0 and older will fail when booting
> SEV-ES guests with something like the following error:
> 
>    qemu-system-x86_64: error: failed to get MSR 0x174
>    qemu-system-x86_64: ../qemu.git/target/i386/kvm/kvm.c:3950: kvm_get_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> 
> This is because older VMMs that might still call
> svm_get_msr()/svm_set_msr() for SEV-ES guests after guest boot even if
> those interfaces were essentially just noops because of the vCPU state
> being encrypted and stored separately in the VMSA. Now those VMMs will
> get an -EINVAL and generally crash.
> 
> Newer VMMs that are aware of KVM_SEV_INIT2 however are already aware of
> the stricter limitations of what vCPU state can be sync'd during
> guest run-time, so newer QEMU for instance will work both for legacy
> KVM_SEV_ES_INIT interface as well as KVM_SEV_INIT2.
> 
> So when using KVM_SEV_INIT2 it's okay to assume userspace can deal with
> -EINVAL, whereas for legacy KVM_SEV_ES_INIT the kernel might be dealing
> with either an older VMM and so it needs to assume that returning
> -EINVAL might break the VMM.
> 
> Address this by only returning -EINVAL if the guest was started with
> KVM_SEV_INIT2. Otherwise, just silently return.
> 
> Cc: Ravi Bangoria <ravi.bangoria@amd.com>
> Cc: Nikunj A Dadhania <nikunj@amd.com>
> Reported-by: Srikanth Aithal <sraithal@amd.com>
> Closes: https://lore.kernel.org/lkml/37usuu4yu4ok7be2hqexhmcyopluuiqj3k266z4gajc2rcj4yo@eujb23qc3zcm/
> Fixes: 27bd5fdc24c0 ("KVM: SEV-ES: Prevent MSR access post VMSA encryption")
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/svm/svm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b252a2732b6f..c58da281f14f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2855,7 +2855,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   
>   	if (sev_es_prevent_msr_access(vcpu, msr_info)) {
>   		msr_info->data = 0;
> -		return -EINVAL;
> +		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>   	}
>   
>   	switch (msr_info->index) {
> @@ -3010,7 +3010,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   	u64 data = msr->data;
>   
>   	if (sev_es_prevent_msr_access(vcpu, msr))
> -		return -EINVAL;
> +		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>   
>   	switch (ecx) {
>   	case MSR_AMD64_TSC_RATIO:

Tested this out with older version of VMM, issue reported is resolved 
with the patch.
Tested-by: Srikanth Aithal <sraithal@amd.com>

