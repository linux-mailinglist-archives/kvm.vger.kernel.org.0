Return-Path: <kvm+bounces-35868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E04A15810
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:19:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FCFD3A2DD9
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD051A8F84;
	Fri, 17 Jan 2025 19:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="azmKw0Ei"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521421A23BD;
	Fri, 17 Jan 2025 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737141588; cv=fail; b=hiJxKxWHYxfetw6M1+EBUXXMk8LM2SZk9nNwArXBMguk/BzMIxoeeTrAvuA0Pqz581ghqW7ZEtSkUc5cPBOtmlmm4eHRtvs++nocpx7bhb32BzDqMJyM/3f/fZ2P48eWpDxhaIZpddou7dMbUnzM7QBHaPMj9wN8KyvqBvBcgRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737141588; c=relaxed/simple;
	bh=RFuI2suXg0sIC9TWuRuqTe844hsrHJxKsL0YNbhhRig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JOyEuMkOrq4YPQIxZ+vRO/fwhNDAPvWTN6PkYRov+3K+DaWfWEC04dymrPjZtJrbcHjb00+mIbv1ewg3C9kmv01dClADphITcuw+aHmUVa7CgUBke88RuXDExMsRdn9FDSeO6d7mUCBCjKXH3o6MHaoVRHMlO5lidABpwm/42yE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=azmKw0Ei; arc=fail smtp.client-ip=40.107.236.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vC+63wEqs8AEh4aSwKqz3rqNri5h/LrOKbRNeoiED3dQh+jxYRweOMbNUNuSC+P4g4iDOC2/kTHx0gWl+hS0vbJKs9H8dATkQHpN+0QXEO6VuoOyKlgteS+NeZNSo9Eue21gUI18cHvffkvyF0og0kkqENsufo6f+V6alB+R1CxpYlB4/0x48I+OUsnDJPwv6D+v/1xkZB5NJ/aGIs6oj2RMPxdJI3prjMQobbVCSQN4TKtoO+FLuZ0Pqk7p8AMfqkUn/cGFUwL3biGkxNe9lALvat5O2dlnFKgpFyEhRoSmbZ9U+hJdQfeR0GllmM1nboJYmbddtqC0Jsis8G1syA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFuI2suXg0sIC9TWuRuqTe844hsrHJxKsL0YNbhhRig=;
 b=uOVNsmq6y9lE88f5MZXQiRCrNaPT77wLgLdS4vLB6ivSbg0ZJWJExf5KPqBExxh0+o1DO7sWCw+PPktDeufAWUN96xBbO8jeggJe8KM/qQPyWyEMFalAFS08SOmB6vAF0CvlNZEebguqYJYrRJxzzXyjOxCsRZla0waiobsucTuN+6MSCSDCIhK/DmgId3W1K24QGGCF4EScxSSmqxjiIIv6tGyl4Qq4qSoCbdoAs/nDT85zalKUj7L8l4QX6wKiefiiJ384p7x7yWI9NfTSqWA2VxVwCJGVilNYMhSJ31p9fXv1bZbJP858ReBhtRkcaxURgqyAdyCtpef500n5yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFuI2suXg0sIC9TWuRuqTe844hsrHJxKsL0YNbhhRig=;
 b=azmKw0EirZdHs91TEgo8GNhnWlUL1YDSd+731ZdQBzDyMzqh4B/l5kE911pgrx7OzEq+TWIoc5fbpJAoGMYN49EHg2e8qyugyfoNlGPZ+E+TfMAMB4sTEmomtZi+T6OmrDkQ1Bca+eKA/jDxfor4Qg9LOo9ZPZtH2EYntYRm7x29kNZOdVvENP+nUx6oOU2D5dZFD9dA6sEJHBdditvy555GdDQwtgIqXrriFyTVRuOXTbHGQnyvDF/iM2PLxqwFzU5B+Jstaw/qnbxgOvWvVG19iNhpiqCYZpYxdODpHqbo8mE6MOCTVAkrtUgA7LkSYV6Li4yNwOedbfv6d+HEkA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.16; Fri, 17 Jan
 2025 19:19:43 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 19:19:42 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Topic: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Index: AQHbaPPMr+5jgewsKU+/Cqp4ayIU/LMbSQ4AgAAJq1M=
Date: Fri, 17 Jan 2025 19:19:42 +0000
Message-ID:
 <SA1PR12MB7199C77BE13F375ACFE4377EB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
	<20250117152334.2786-4-ankita@nvidia.com>
 <20250117132736.408954ac.alex.williamson@redhat.com>
In-Reply-To: <20250117132736.408954ac.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CY5PR12MB6345:EE_
x-ms-office365-filtering-correlation-id: eb0beb14-51b2-421c-f82f-08dd372be567
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?TJCfILvPNyx56gmni2+F04P/TYGzy4qKORUlTCcNdqi8pdmZ4CQHPtNvLF?=
 =?iso-8859-1?Q?Hw0sEg3cU/KPdj3k3cgi5ybisDp6eprQYd0X8HE9TBcDTcDbuojVZiaGN6?=
 =?iso-8859-1?Q?s+p0NFVPyvdCLnRyR83688XjNTtJ33lwCgffPEc7ILc+QYhQQfZHHnNNQi?=
 =?iso-8859-1?Q?q1AihRIOlpomIO62sMM/7IbnCjWsc7PJwOuipfesLVQ1qw2MqxvsGYBSkZ?=
 =?iso-8859-1?Q?qVYar3p53muAG2LoST0aO9sMOFSGEug9H523rOalP5B8QHBhDw+cAA5qZ8?=
 =?iso-8859-1?Q?Cnh4FUFev0IPHmvGRQAy5oiIaa+zN4PLr6/I+u7xI7V0THeufo3DqV8C6y?=
 =?iso-8859-1?Q?Fkp+Ho6aQAc89nCH+FR4l5ehiyNBbwJ1Ao1VSPT7++bY84rnbhpfZoJ4R6?=
 =?iso-8859-1?Q?RudU2o+dBxjcVlYNz0M2zgJsQ884347YT7MVNB/CG+UqzTN6lPDo3SAIK3?=
 =?iso-8859-1?Q?OlmZNQbGgmb9x5Qz8f/QfUtYwtrim+uXQ5k3cOluY2NlUOB3Juby4QKFXp?=
 =?iso-8859-1?Q?9Yb341RFP+tWvwckQqQkMMlUA6jeS91YS83aHl0VWLqm0xD51OuB2NfX/8?=
 =?iso-8859-1?Q?qlggfS1myjktKwF2ERjwtG+DwIeTh/hYNKUqJ/5Ek4QquSwEXlXkpBcZoG?=
 =?iso-8859-1?Q?RkoiPhYZfn/sXWnPvgoBhE+hPZvwPIlPsZkSJr5tZh9q4o1qXjSfLNRi/O?=
 =?iso-8859-1?Q?36+PPfgaXfFw6O0DUSREgbtl3QedRKwHsZW6s5XLhvhxX3qAzr9B6oIh1W?=
 =?iso-8859-1?Q?ICTSjqi0ezK2qENQocr4189fZM7MfYtllyI286GcmHBJfYuvdgLn+8hn3j?=
 =?iso-8859-1?Q?YgOKw79h1ZKGO4YoQFNaSIA7nO1KniQTrm/UA2nOFSHPKp0t5VZRUO39FB?=
 =?iso-8859-1?Q?EmjNKecnqsUKCimCUq1yjUWQd0+W+SvGfjiWx7zw5exCS1iu7EXB2ASCob?=
 =?iso-8859-1?Q?9pD5SzI6YuTuAAjq1YlB2xsRKy2ZCpUPpasJ+m17Uqhl6J/00EJnPnSxSH?=
 =?iso-8859-1?Q?ouLUG7vN4rfHuTmFUfPu14YNPw31WGYPVXc6YRh0kDcfiS/rVxFt58+BOD?=
 =?iso-8859-1?Q?ha3O7ARnLanGWZ9JumuyUUMAyUHzEic3kO5XXJ+d01qjIxuIso7XSFXbHB?=
 =?iso-8859-1?Q?Dzpx3mxw8250w9MUwS4Du+JGDu6hqGCh+kBAzxGa0nvjjlB2mdd/d+obJn?=
 =?iso-8859-1?Q?yhOBQCPbonmYpSuYpSTQou+69aNv3osFmM7vQgDxbZ2oqT0JpXJxBizLnl?=
 =?iso-8859-1?Q?kbZ4IGjJvxWV0Zi0TErsx/l90tcs0azOfs1RcoZnJvuzg5hj7PPDD3EhbV?=
 =?iso-8859-1?Q?taOcxflHigCrhRhO+OW+OnbRuOaBu+guT6o7LjaWQnuKEiIWe4dxz4etil?=
 =?iso-8859-1?Q?I8aZ2M9Bj/pUTdzrqnMVQmgnSTFwJX1S6EUhK9GJR4OxLlVAO4ia56Cnj5?=
 =?iso-8859-1?Q?6dT97LjNC6RH3JgWO+59eHCCVcRqeVmgIiY6W0yT+m/wdZ6ImD3rqAPOYM?=
 =?iso-8859-1?Q?Hhb2YZLqwsEryB88mOgsgs?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?wCEvPH9fEZAkQjXBkhjt6Iq3/uGn73BSJ7+30jaVPKlHMYiWWaTiHaLv7B?=
 =?iso-8859-1?Q?WDCbuIuNbDUW/ylsVm57i25e2/FpiFuxvAu2ipoin/kf8CQ05z+pnN19DG?=
 =?iso-8859-1?Q?Ph32hhbOeyniWsJN6FgFlauGw46JumuSZTj8Vk4r7JpuPFVDqh+445uAti?=
 =?iso-8859-1?Q?VQAMjwPOGCjSfY3X2QvFbUZlEhM0KUkhU9S24pTjtVveTa4AVnfTHAHUuA?=
 =?iso-8859-1?Q?HYyDwLNUrD/+KifNofK+CphErM0/6uzCCb42xvBG+GpD9L3FapC9HWTvfx?=
 =?iso-8859-1?Q?JRdUeAEVsldsaGBPgtK+uSDR3AB36j4ffjeI6aeF2IJ2mnVVenenB1ZoAs?=
 =?iso-8859-1?Q?wc+JzN5XUsF6FGvgs8hAOOtTm2J51Jg6BzSJkLs3+jFYfHERpZbs36Y5gH?=
 =?iso-8859-1?Q?K3yuBN8AKEHNTTSUK216rYHjcb1bUGufqSdPzKbTSZSu+gD8NB50m9fQqr?=
 =?iso-8859-1?Q?zF1lBoTIaqrcA+QtReQBOKZFHA7MVuqVlFhM83c9PdQ5rtOTQWtf7NTKIT?=
 =?iso-8859-1?Q?5Hu8mxbcenQB+s0Z61g/ZKW7CxBSBt+NBsS1Yd+9cXAqeP/oypCGT+UMVk?=
 =?iso-8859-1?Q?qG0ergfyHzO1ur1aVKNdrd7rq8nV0V6MPRJorRh6pZEPIpsGC3T2r8vTmU?=
 =?iso-8859-1?Q?1eMYeWJb9lFkUM9drK6mUdfS9w/7XNB6keSUlgiaR2pQYdWD/G0pXVZKGr?=
 =?iso-8859-1?Q?Fg8UhEjb4kC873XPjcr+HjFLJvq4WZSXEke3JX9+XK2LhJtQEvC/RMZPb/?=
 =?iso-8859-1?Q?he5S2gYBZfSyd3dCHYCl7bpn3LSRIH9r7xNYoFYos2q3rWq8niKgLeQo7f?=
 =?iso-8859-1?Q?pJ9TzPwPzSLps02Im8EcNx7hWQckxQ+0X03oSHyitR++w0NhwhU2OQ0JMg?=
 =?iso-8859-1?Q?sRzqzsOLzOj4D0w864vr37lBJkJRMAB+KYpLkdPWjJgIiyx8/hN8VZOtH7?=
 =?iso-8859-1?Q?9sSHSTlGvJEZx5Q0QsApZWHTQoE4eC1lbQwoR+LiOqkih78KtCsPv/D762?=
 =?iso-8859-1?Q?8hRyFGLxpe+rx/d67rAoR/mlRLeHkLHbhvAXZTSYqBujvSZ9bJXjrV1r2X?=
 =?iso-8859-1?Q?pFZY8SklwwXwHhzCUZJ7tYqA9t4LqqTeNPmfhVIcXCpSlZjqLUiK4jzndM?=
 =?iso-8859-1?Q?bEhPgEjjI0z+Pkffg3PYZHlRh83SsPzfxnw6PMYHraL/xRZO9nMbvVm1vd?=
 =?iso-8859-1?Q?t524wU6grcWNQMZFzDTeQbdP/4tnV+iPStuXlprQXHgWL3vI3foTpuDLvV?=
 =?iso-8859-1?Q?tIn5yaksSFC4VAmqNZKFAXvvIwWFxri/W/0vsycc1l2TGRmmudz6WQHtV4?=
 =?iso-8859-1?Q?6T4DQKBfyPoxPB2vLpStVJgo7GIMj6NSnqnDTSqhvz2b/HnjTOJP3IwpnS?=
 =?iso-8859-1?Q?DOS3xjzHuqAru6z+RBoNSY3oDnYSZ1eJcibGWEnzDJyY5iPKQqGcNAVRtG?=
 =?iso-8859-1?Q?xK7bxaNLSnBLc9zglZngYN3C8oAPvp0p0E5F9jsZcYZmGJYd2htFPWRlIs?=
 =?iso-8859-1?Q?rNbDTXyTWIdYwrt0DeDFaYtxMZSFxl5bhx2QURBwNN/1Gl2ITMNEU3j1Nu?=
 =?iso-8859-1?Q?ZB6/zFe9ri2ZETbhLzTa8RUHig3fjb+5XI+DvhzpigJ+Z1eaiQA/ePejmU?=
 =?iso-8859-1?Q?SAHyMPfFT5d5Y=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0beb14-51b2-421c-f82f-08dd372be567
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2025 19:19:42.8050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 070gQlMk4iIAQqEHzVtNHi3TAXgJRSZmSi4Hz3qNqHPxocvAKOTmPVOfta63Mfxf/UolpcZ87U1vV8ITDGz95Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345

=0A=
>> +/*=0A=
>> + * To reduce the system bootup time, the HBM training has=0A=
>> + * been moved out of the UEFI on the Grace-Blackwell systems.=0A=
>> + *=0A=
>> + * The onus of checking whether the HBM training has completed=0A=
>> + * thus falls on the module. The HBM training status can be=0A=
>> + * determined from a BAR0 register.=0A=
>> + *=0A=
>> + * Similarly, another BAR0 register exposes the status of the=0A=
>> + * CPU-GPU chip-to-chip (C2C) cache coherent interconnect.=0A=
>> + *=0A=
>> + * Poll these register and check for 30s. If the HBM training is=0A=
>> + * not complete or if the C2C link is not ready, fail the probe.=0A=
>> + *=0A=
>> + * While the wait is not required on Grace Hopper systems, it=0A=
>> + * is beneficial to make the check to ensure the device is in an=0A=
>> + * expected state.=0A=
>> + */=0A=
>> +static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 unsigned long timeout =3D jiffies + msecs_to_jiffies(POLL_=
TIMEOUT_MS);=0A=
>> +=A0=A0=A0=A0 void __iomem *io;=0A=
>> +=A0=A0=A0=A0 int ret =3D -ETIME;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 io =3D pci_iomap(pdev, 0, 0);=0A=
>> +=A0=A0=A0=A0 if (!io)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 do {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((ioread32(io + C2C_LINK_BAR0_O=
FFSET) =3D=3D STATUS_READY) &&=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (ioread32(io + HBM_TRA=
INING_BAR0_OFFSET) =3D=3D STATUS_READY)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D 0;=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto reg_c=
heck_exit;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 msleep(POLL_QUANTUM_MS);=0A=
>> +=A0=A0=A0=A0 } while (!time_after(jiffies, timeout));=0A=
>> +=0A=
>> +reg_check_exit:=0A=
>> +=A0=A0=A0=A0 pci_iounmap(pdev, io);=0A=
>> +=A0=A0=A0=A0 return ret;=0A=
>=0A=
> We're accessing device memory here but afaict the memory enable bit of=0A=
> the command register is in an indeterminate state.=A0 What happens if you=
=0A=
> use setpci to clear the memory enable bit or 'echo 0 > enable' before=0A=
> binding the driver?=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Hi Alex, sorry I didn't understand how we are accessing device memory here =
if=0A=
the C2C_LINK_BAR0_OFFSET and HBM_TRAINING_BAR0_OFFSET are BAR0 regs.=0A=
But anyways, I tried 'echo 0 > <sysfs_path>/enable' before device bind. I a=
m not=0A=
observing any issue and the bind goes through.=0A=
=0A=
Or am I missing something? =0A=

