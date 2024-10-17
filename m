Return-Path: <kvm+bounces-29118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98CCF9A30F7
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 00:48:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCBAD1C21760
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 22:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC7F1D86FB;
	Thu, 17 Oct 2024 22:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DdLPXI6i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pnNDFRWq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EBF1D278C;
	Thu, 17 Oct 2024 22:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729205320; cv=fail; b=Ea2fxoOtnBcGaQyU5L1VEveSzU6HI+Dwk1YjkfS6ye/FCzZ5ZMdRFfdA7tdQmixcvqFxo8LPjAhNAnWuittjMTL9nmy5s+a7dy9ssBuQQOdSNlDxsGPRMDlgCAPWHnAIZ8hHtEfmv6g3k7dfYd02IIX3SFSaKssSnPRY4qNYYsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729205320; c=relaxed/simple;
	bh=BSSuAbqdwOT6t8ppm0C4LkVGN+inVlCCPXSHQ19/Cvs=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=HlK0vMhaH5uBZwS+EP1EkjZ7QKm4BfyuXnEDI4tqHF+ula9vJegiaxwOylpOpDlTuttOR5xC2oOvUJlT5qUJZc7qO2GMVnThFFBy+6X5mSjsh57Yvf51N8JKijdvgRN9/TV9SRVwFtghFV4c/AosY6BQgC2DA7QLb55A5zsT7CQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DdLPXI6i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pnNDFRWq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HKuBtm011788;
	Thu, 17 Oct 2024 22:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=7RXQrk5DjxUTK1lyeA
	rifjgyAXvC9G9PyR49tyCl6XM=; b=DdLPXI6i8sBSs145/R+5A0m6dLNGBikL46
	gjJU/21WKD6KBfbw3rsaRYRTVpTGCFnuiLdWM+WU3IadynNBwnKKRHj73dlXD5dP
	/fc9M4BVDPG6KZmHi2L/9GPXLLOdrtY8qDWxwH499atCKIGJuxw3jtT6MnVZEh7O
	3kxKd9RnRKW0NBt4p2hvLLCAVTCeNRV221aiI9N00hcDakzeneGtAVFu5uZW4fi3
	tQpW87XUiwUPXQWzUu+zdV8yNDG8VdaABpgN4Rs5tAjeXeEavdoegVHxNnnrOzvS
	1bfI/Qf63BJhGZ/+J+YYOMmBd24UKj+Zv30x92DVF9fZ/QisJOAQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h09pyw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 22:47:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49HL56lO027209;
	Thu, 17 Oct 2024 22:47:36 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjhg30x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 22:47:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncgo8jRe96ghkfeLGMpFy+peLOGJ6x5v4xXqE30NbohLXgysjN/G1UyMZBWPdCidMGh0NVuFum1Jp0V/x64zWtQI2+1rnwrZf1J3oPPSrlaMfLJMgAJq7OUIo017LbYQbNdzN7ni7KDRMQ+/0MklSnYqUSU/NBqX+Lj8aD7Zm5NS90VdYTEhhMZV7+lOKNZtvEV8vZsz12fY2gZZ0nGsvBbQzwUH5ZxYC9pG5NiD81BV++mLj7h/qpVJFBejBJ1zEi6LYI5995WEl8VMsEiqDaFRCwWPAOQO9bpnwKVoTRz35goGOaZhsmClXAS8771W6Rvg1XQh3k3blMEkeQQebw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RXQrk5DjxUTK1lyeArifjgyAXvC9G9PyR49tyCl6XM=;
 b=OdBDwUAV1335wKvIbOkS72lmIIUINqjRvdYdWjJr7lXa9U56lDkQd0eWKBrL+ZpOnn+c47LxQ1/VA4N/JpNhKTP4r1VpdCHtKCKiqHFxAp41S5ShZ4FOGOGEGU6w9X4XfS/ijazevJmILfFesRa850g4bJ7j75Th4zb+mXobJ1w7l0a+cMm8uFO0dSo1xBgcQsdEMOrE7YfVEz8JxTqO7Kdst2nHtNL6P/WjtlcoULWwrDaZtObsbwoO4iz5ZvIbp0k31Py8CyhnTRoCD5PutgVL+pfXbAWVBFvLhoa1Kl+Hxu1KhA+5dOVzsFfOFhPSd5qKbXqx5U4vAEKR0LscHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RXQrk5DjxUTK1lyeArifjgyAXvC9G9PyR49tyCl6XM=;
 b=pnNDFRWqDM8fMCyzlq/VnvpX0rmnnwSiFUjBD3lQFImSuCk0BZiDbXxSF9cFqf0RKjUz+QVqbe8bTWMyPwgskfwFGggtcyCPvd7+4iHd75Hvj2LKKig7CikHtoFM62H70znH5343qDaRYKGrc3QFiXP3E2g8EdaYd4fYbGRLJiU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BY5PR10MB4146.namprd10.prod.outlook.com (2603:10b6:a03:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.23; Thu, 17 Oct
 2024 22:47:33 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.019; Thu, 17 Oct 2024
 22:47:33 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>
 <ZxEYy9baciwdLnqh@arm.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Okanovic, Haris" <harisokn@amazon.com>,
        "ankur.a.arora@oracle.com"
 <ankur.a.arora@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "sudeep.holla@arm.com"
 <sudeep.holla@arm.com>,
        "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>,
        "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,
        "konrad.wilk@oracle.com"
 <konrad.wilk@oracle.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "cl@gentwo.org" <cl@gentwo.org>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "maobibo@loongson.cn" <maobibo@loongson.cn>,
        "pbonzini@redhat.com"
 <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "arnd@arndb.de"
 <arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>,
        "will@kernel.org"
 <will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org"
 <peterz@infradead.org>,
        "boris.ostrovsky@oracle.com"
 <boris.ostrovsky@oracle.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "x86@kernel.org"
 <x86@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-reply-to: <ZxEYy9baciwdLnqh@arm.com>
Date: Thu, 17 Oct 2024 15:47:31 -0700
Message-ID: <87h69amjng.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0080.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::21) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BY5PR10MB4146:EE_
X-MS-Office365-Filtering-Correlation-Id: 52fcd4a6-ab3d-4e70-dad1-08dceefdb02a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xaSI+mpJkaYPMJd4RO4B9Vr8/gkFQqaZdj7M6qrhvixyvJpo6Of29mA7GjEi?=
 =?us-ascii?Q?2dCnBAT+JGkVFfnD1B9pqecdNJCvLhHDSPMBoBaRWTGzdpAdrVQFp9aPYSaK?=
 =?us-ascii?Q?YolTaNgi66WPzxkM2AZeoqsU/jjo5FZb6zGBChfnmT52lcXlAtUXsQecRNUz?=
 =?us-ascii?Q?B3qlvK57QN++aOvdvJVnSTukpbTC3dn9YwlJZqz3M4GTBHjAYm+RYWmgCs+L?=
 =?us-ascii?Q?B5vrspktKr85RmglNGleoYQ/+XefAlK7cfyOIlKBEV9abvE60/d5ekV2VLYW?=
 =?us-ascii?Q?VFhaKU1VPKOZOwmxrnvyWwIJbG7S02GX9vfyboIwnpm8QUzsDlccwvzDPNVp?=
 =?us-ascii?Q?6SPqzibjIPTu0s7Zoa3sPjBMRjt3etu0gdc7yjrsvT7njBOO/hvuOoqAYq9N?=
 =?us-ascii?Q?VzibE1G5u8TwtRHi37f8Y4obbLWvlYlcTW5WdLou2yv2VhLWcsy3zf7j49Nl?=
 =?us-ascii?Q?jJP9gQd3UHFVMfYRn1DW+fXqagRBg0SBXFZ4aLbC5Inyql0kIItC0pv4HFYD?=
 =?us-ascii?Q?MYrUwmBJNNX9YU1tyN7hLogNUyHTppZ4JhlMaOTp+2cE0Jk3ohMdCvqWGOpg?=
 =?us-ascii?Q?CLxh43XkN1HAnYQbUHViQ6wZAZnQJ+g9BaR8uALxhMY2mQJev6W7GyH4q/K8?=
 =?us-ascii?Q?5HerI+geALXwlL4NYePxzo8HxaLSvv0rHhgVmns+95ivUuNWghu50VMn8btn?=
 =?us-ascii?Q?Qhmyn4KYAPD6WAfHU0DfkwUg1bEFZV/D0mIhGkhlYquwjNBPLh/1dYKxnvBS?=
 =?us-ascii?Q?BnReKyVm688gxUtEaex6GEPOp1IOc73x9FHzEjfk9WMSv+qT7YS5FvUX6+rm?=
 =?us-ascii?Q?rK3mb362Br7LsOLb+4B9cEWBHzi2bx9f9M8i2OY9VZWJ84owtgj5e2XwTbag?=
 =?us-ascii?Q?8K7aORspdklLB66sJIzP2Yk9IUP86v7EU/KM9nUe1Ke8otQ5LLJxYOKxI/ML?=
 =?us-ascii?Q?SOH8NAfAz7MG0U5sCEJ72uemGFyYR4hEhPKBQAkmiRmNJl0s3Ml22l2DTTOZ?=
 =?us-ascii?Q?ii0xu6Et3DWCZwWX0o2MLjEypF9hrWt6Eg5CkHw9g+pifxHW+yFfmQcKJyqM?=
 =?us-ascii?Q?Z02IezwAJz16A7eGpVuLjPMqqXILITMNZG3qtYLmgstkuAF+iflgGYYcmrE0?=
 =?us-ascii?Q?MF3xHa0w5El5H6rcwvWDUXwHg/7MUt9yy8fwFbWe6LWanHR6hc5bcpUAIs8x?=
 =?us-ascii?Q?dvVpYhzdHw657f5Nk6jFRfs2EC9gvydeQ0QrffNNy5xrJEobWJ3OILKPZegZ?=
 =?us-ascii?Q?fkHaK7PrW0IB5L+t2OsS3brAw6wFE9kNWxdpbxNjX0uwiOcVahXP6GVixQsW?=
 =?us-ascii?Q?9cbExrSLk71jz8slD1VcfeKk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YI/WKJ/1HdPf/dvFcACIMT0sOJh7rtuTNZtmXNiIc8jDFf7Ce3ntYFiGw+H7?=
 =?us-ascii?Q?ZKdcIEzhOIcIQ/7gjSJXKKOCvlIvfozOzPkgPAs9eYK14OknTw+8pehcQKvv?=
 =?us-ascii?Q?IRG8Rr9jNrBF0bhHLI8Z4IfQWN19jLJGwYLlL9rl5MzgOhpHp8JR+y+OW7JE?=
 =?us-ascii?Q?HW4mx1qNTcy6DStuSh9Rg+qqbs+BXC9Rz5IdVT+zMhixxf0swQNKa2O/QcOG?=
 =?us-ascii?Q?EtSZ3dD1crtoj4jyLcqRAjoIuVtAJJ6XrOgvH+k5yEK+RIHiXkqmrpDBnN6p?=
 =?us-ascii?Q?44SW31AYuidfysua/DRZjVqn+fDHaARdSSJYo3nP0qLwsSxc81fZOy832eEx?=
 =?us-ascii?Q?hBu1Cn0YzN3bOpv62DhSdU1xK3eWY0mbUeiziOHZE670jMSgVr0JV+GotYGp?=
 =?us-ascii?Q?b+4axAXa2cNmbSVaKPGMhRDPnrAFCoeFvLa90ilMEiFPNR+vkCtZHHGIchp3?=
 =?us-ascii?Q?Xeoo/JRGb93zT1tW/ju0mB9WGICerrDKkCHvTP/byYhn3KfYRVPaf1nOZSDM?=
 =?us-ascii?Q?Yiqb8ZLezFnv5Yhcq4E1Tz/daA0wxpvtYFKarb7xrUwTCP8STaNOTO9qV43E?=
 =?us-ascii?Q?P3tBF5UxspW8jqve0KZVjR/1wymu5g6v7IQNbb9hbCYGIBo/pNQ3+Ow7VCkK?=
 =?us-ascii?Q?qRWE9ZxnmhT9YtX/MWBB44Z78XmIv3++ObkEkt0UH77uy3ofVLcfAKbZup7B?=
 =?us-ascii?Q?14z5ZghbAoSaW/FjF3QH93XTQDqwJYjS2bcuLe10+ZCfRlipZcdX7NOQdENu?=
 =?us-ascii?Q?RyFhfimTaP1xZd7QlbC9ahm2sSSVR7qRxAwZr7Ap82j4UJ9i5ivwANJRlKxt?=
 =?us-ascii?Q?5lFRiWUCViOD4IUCVYqwCJZZKcXI2dxn/WiutufpEI2sWWjpn73sN8xyzkTn?=
 =?us-ascii?Q?FGKuD1/ydG/0im1nV99BvsC8+Db73mu4x+SPX9S27WUJpTSC7OXNA1njhgyi?=
 =?us-ascii?Q?EJ0Myc9Pjo0hf/TiYFrfdS+u1OorHivEe5ToA86pgoc4PYh5HfQb0LDn80D4?=
 =?us-ascii?Q?KB4ZT+f0ew87cmUJZ9RHASgT1mIszSVa14cexXzaW+xxZgP/4I4z9f+0Ef9J?=
 =?us-ascii?Q?JRluxXEh9SpTlWqEA43bTtDmuBcFalaj4MPFp4cjrxXgt3gcfuBkF28zNUtZ?=
 =?us-ascii?Q?F5ihw8zfdnvv7n7nbvkZgeO15i8Dw3jKH72KDhI7Oq2rj9OG5t2N4rDxNd/A?=
 =?us-ascii?Q?+2RkkFMsR55eQ0s4yrxaPpZDEvrM//owjTyq19/eBZMQlM7OP+CduLw9lI4H?=
 =?us-ascii?Q?n7hOTkKKLjGommR8IzIgvtz255+5rRSrL5IPVMl1OXHg3q+j+wOztQ4gt6uW?=
 =?us-ascii?Q?RiW4O2g58F8gDZy5pRaq7m+UmiDojhAb12CXIpXjNXL+mjhLnO+C0kiUS/xS?=
 =?us-ascii?Q?OKlvAKsunXNk+PCpESx0P3kwTIVPnn4j0EiHcl28hIA3RsxuRBsJkk+GRdJN?=
 =?us-ascii?Q?GbksqU4OkTqYcsAixVpQQ8P5tyUHYgricPHVuw/K2Thv4/yyRlJ7YtQ75I64?=
 =?us-ascii?Q?/c08tjokeeBpoi03XwtIe3/tvELUFsMOZm1RNNdEAYgRbA9fES6z4rX4/tL4?=
 =?us-ascii?Q?ORtWbEeyvfhWnn7mdPjhgP3ivPZFNO/zm/cnPeCAwkD70ow9mZy1MWk14lHU?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9ipdrlKyt4ky4rtXJXns/BS2bRnwfovBh8bOoadGq0cJOW0zGE7LDz/KwhYt4SWG/iRj9cZtrYDBGgUvmQ0NR8RaeeT2NT88/cKdeyoumK3A8CD5JItQOTm8HSdKU+2FcxAmfI7m8GkPZfxJwEG1NZ0FNiStijx/piIy0aQU+8yLKdIroen9kMMJEpIR0B63Mi8HBei66YuQZmLQs7NjHN5YvGjdFhcVTrYDXKjmC+vxVdLFgIdh7zxPMtXSHm18IoGbYYF1RjyE7jBtI5oQL4GTk7YoWzb5gw1011wPVHgWXSFkCDn9jk9LRZZ6WNXJgzWpF9HXyLSFXQO1q4px1LoBHl19gtnT8Qmjzegb65RbiodSDARrs59SXfoErJBLUQa8L2peSziEJQ6tjQdy3A6itJqCbpfgJIR6eES5f2kk9N1r4jacBeyqr2/bppxPgtMw8L2KdVycU3veq7R0wFT7wjxby1OBy59R6tcKmL18uUduLnaAR9W3GuRCvq1x1za5XVbjCFy6byFKBH5vJt3r+YDGSWmfNV2hfa3t37WnLmkoQf5AlEoeiBKnOtsKcxBXFcXkHA9tvumPzld/F7ZHhW3Hk9irmH2TaDAOccQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52fcd4a6-ab3d-4e70-dad1-08dceefdb02a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 22:47:33.2658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPAdX/PQdhfX8pAL9yKh8w2GlDbxbkbww5N5t9LVDw+18yLytimco7F1zPb6UZ74FOeEWSJVxEAqXHIEPdsKCtsOEemOrvY5FNxKq7incOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4146
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-17_25,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=966 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410170153
X-Proofpoint-GUID: ldqSbBAQNHnUm5MewBpKQ831ha0IYdwZ
X-Proofpoint-ORIG-GUID: ldqSbBAQNHnUm5MewBpKQ831ha0IYdwZ


Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Oct 16, 2024 at 03:13:33PM +0000, Okanovic, Haris wrote:
>> On Tue, 2024-10-15 at 13:04 +0100, Catalin Marinas wrote:
>> > On Wed, Sep 25, 2024 at 04:24:15PM -0700, Ankur Arora wrote:
>> > > diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>> > > index 9b6d90a72601..fc1204426158 100644
>> > > --- a/drivers/cpuidle/poll_state.c
>> > > +++ b/drivers/cpuidle/poll_state.c
>> > > @@ -21,21 +21,20 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>> > >
>> > >       raw_local_irq_enable();
>> > >       if (!current_set_polling_and_test()) {
>> > > -             unsigned int loop_count = 0;
>> > >               u64 limit;
>> > >
>> > >               limit = cpuidle_poll_time(drv, dev);
>> > >
>> > >               while (!need_resched()) {
>> > > -                     cpu_relax();
>> > > -                     if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>> > > -                             continue;
>> > > -
>> > > -                     loop_count = 0;
>> > > +                     unsigned int loop_count = 0;
>> > >                       if (local_clock_noinstr() - time_start > limit) {
>> > >                               dev->poll_time_limit = true;
>> > >                               break;
>> > >                       }
>> > > +
>> > > +                     smp_cond_load_relaxed(&current_thread_info()->flags,
>> > > +                                           VAL & _TIF_NEED_RESCHED ||
>> > > +                                           loop_count++ >= POLL_IDLE_RELAX_COUNT);
>> >
>> > The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
>> > never set. With the event stream enabled on arm64, the WFE will
>> > eventually be woken up, loop_count incremented and the condition would
>> > become true. However, the smp_cond_load_relaxed() semantics require that
>> > a different agent updates the variable being waited on, not the waiting
>> > CPU updating it itself. Also note that the event stream can be disabled
>> > on arm64 on the kernel command line.
>>
>> Alternately could we condition arch_haltpoll_want() on
>> arch_timer_evtstrm_available(), like v7?
>
> No. The problem is about the smp_cond_load_relaxed() semantics - it
> can't wait on a variable that's only updated in its exit condition. We
> need a new API for this, especially since we are changing generic code
> here (even it was arm64 code only, I'd still object to such
> smp_cond_load_*() constructs).

Right. The problem is that smp_cond_load_relaxed() used in this context
depends on the event-stream side effect when the interface does not
encode those semantics anywhere.

So, a smp_cond_load_timeout() like in [1] that continues to depend on
the event-stream is better because it explicitly accounts for the side
effect from the timeout.

This would cover both the WFxT and the event-stream case.

The part I'm a little less sure about is the case where WFxT and the
event-stream are absent.

As you said earlier, for that case on arm64, we use either short
__delay() calls or spin in cpu_relax(), both of which are essentially
the same thing.

Now on x86 cpu_relax() is quite optimal. The spec explicitly recommends
it and from my measurement a loop doing "while (!cond) cpu_relax()" gets
an IPC of something like 0.1 or similar.

On my arm64 systems however the same loop gets an IPC of 2.  Now this
likely varies greatly but seems like it would run pretty hot some of
the time.

So maybe the right thing to do would be to keep smp_cond_load_timeout()
but only allow polling if WFxT or event-stream is enabled. And enhance
cpuidle_poll_state_init() to fail if the above condition is not met.

Does that make sense?

Thanks
Ankur

[1] https://lore.kernel.org/lkml/87edae3a1x.fsf@oracle.com/

