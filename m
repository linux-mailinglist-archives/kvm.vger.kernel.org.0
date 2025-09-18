Return-Path: <kvm+bounces-58053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4420EB8736E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:18:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E01FA560124
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 22:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16622F9C37;
	Thu, 18 Sep 2025 22:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KT3x/BHc"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013026.outbound.protection.outlook.com [40.93.201.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A0D222594;
	Thu, 18 Sep 2025 22:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758233908; cv=fail; b=MHzq1mtkLUCIjykb2U3EDYGo9PZtMKzplkyffa8KE+4mj6lq/J/iIXSmdsJbUH0RaUjA4WWzaFA/9+nLFYK+gie7fRQva0WVw1zk5Te0PGcF6FW9Y6A8GEcco7IfI+a5gFYu03hojUNmaXo5gyyTVHe74B/ClKNuHX0x2v/G4qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758233908; c=relaxed/simple;
	bh=pNzSoFDcTuDIuAqGD/UGe7Hpv6WuhBHSsSs8wr6X03s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=agyBmbtpO8ajTcu4EZMwD3DB9b76+mmUlVVJi6Zd4MNRs7YtyUxlpYfweowEJ1B1HZpdO9AP2lK6eSz/XNiQyO0MCc0xTe9awP0KvdKZASeP1k4a0Ksy3l+LaTXd86dvXAUF3YqIaDAymYX0BBQhqVijarJy04YyH7lK6e3+QL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KT3x/BHc; arc=fail smtp.client-ip=40.93.201.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AhPIZLqIOwyl3fwtz56uumpaTgvjGDfP8tAljnm60K0z2Lgu9L/e9anrPEN2ObnBQxMFbh2Xp9z1dvHCxt3kuOueQ2a2Q3LwS6ajOBjFJMVnc4dzHBjLYocayEMGAeinOIe5ZGlYTg6Cjt6GJPnWbB5Yzb+h7EniSrC0sN9QhqGcevzPV/gcs3WakX1Me1asedEzzc5Mywe717gCjxQsVuy9sIpHclu0SDDapr7S7DHZRmlFFAHfZN1T/wKuprLcDKQntVxtR3CnYL/kQmQetVG7+jMcVFovLuyFVjd6gzot7z7vSmbQHxTitkayTjFy4wET19retaLrsCiMeVWVAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tt23Lcj2DNJWZhl7SrI1CP9H5669jFm5ACRx2fTXUWo=;
 b=wrdTDBsur8RLY52oUe3wG/qH4GLlD4GR+pEXSazht2BPzngE3fFi7lBfDircbYmVWaLoTpF5SvJzg1tHxMxWdbQBpiFBs7+kcFls8ZfihexFEtdfs8XSe7A35Awz2phXAJ0qI41OGs43jGsAjen0WZiw3AJZKi6mQS0E7eLqzMNSXdITsJu+5CDxlkd+odYE9NHnVkjeB7adV+uMdhvQTXsdDfgWkWsUp9RzVuMxwsJD7ZugQa0qy1f6mJuW0oiks1dS+/wZYrb1QMnI350wDjjPEvGMvuGSp71NjkKFlbvG0VqH7vBfMFW7ecJldRXDD88zgwk6wHAXzRkTrF50Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tt23Lcj2DNJWZhl7SrI1CP9H5669jFm5ACRx2fTXUWo=;
 b=KT3x/BHcdFcBF+NpWorixCwEHcCROCaraHc6wUzOOgz68K9gBZfZbQ/PUT/wE7Mle9EzxiU9dGReQYmqgl+rXLW9UwiBdEwEIKtkd5RDCq/ooNbZgHlLwfJnyX58ZnVvErWSoh25Wsxt24HbNisUk/vBgosDp7iDmx1kyf71Zv0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by IA1PR12MB6626.namprd12.prod.outlook.com (2603:10b6:208:3a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 22:18:24 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 22:18:24 +0000
Date: Thu, 18 Sep 2025 17:18:08 -0500
From: John Allen <john.allen@amd.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"minipli@grsecurity.net" <minipli@grsecurity.net>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Message-ID: <aMyFIDwbHV3UQUrx@AUSJOHALLEN.amd.com>
References: <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
 <aMnAVtWhxQipw9Er@google.com>
 <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
 <aMnY7NqhhnMYqu7m@google.com>
 <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
 <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com>
 <aMxs2taghfiOQkTU@google.com>
 <aMxvHbhsRn40x-4g@google.com>
 <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
 <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
X-ClientProxiedBy: SJ0PR03CA0222.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::17) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|IA1PR12MB6626:EE_
X-MS-Office365-Filtering-Correlation-Id: 0443736b-4be4-4488-a1d1-08ddf70148d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?akWnSmimHtDfCtBftgOJDgwBUsyeOcQpW8T4dDmUPLlj++xXkj5FAIlCGih0?=
 =?us-ascii?Q?eamAYerk6bwCMmFc7VOapnEusawo8p9xRLHCXATiGd1u8yfi0LdMB++DS4kQ?=
 =?us-ascii?Q?c2Mq6so06GARrB57eoxbrEjBiIwvHHXxHv76UWaAmsSfkN/As2O7kDkf95/S?=
 =?us-ascii?Q?2n8v/FqOla6Zp+wvgTta2EQS1c4d9IaxbAaqGSi9eJ57on6qQAEbaYS1bxir?=
 =?us-ascii?Q?31vpzGzbSD6v9CZnQcyiKcbhrsu+zWeC8S1LAgxh+bFNqNwOh3MRoZKtp/oY?=
 =?us-ascii?Q?9jGG7Ld2oyS9upk1nxGkHgFL+3xNa+vcKt9V+PwM19qLZKTjezLV3kJYG0vW?=
 =?us-ascii?Q?fAe/TyMFcHV4u59iNMOHpQZnp/zeQcK5gqIkTaLZOIXtWXUgWs4FYRiyNRU6?=
 =?us-ascii?Q?vOj9mnINs8HtqWrTbDU2KVXrMbZlmAKNwmhWx1wgRucauNc6ZATDFHsKAV+m?=
 =?us-ascii?Q?kPqUa0RfKrZkSsS2GYtc7qJaVFXTXAQUaXb2XlulE3/psESF/H9HWkFq82fP?=
 =?us-ascii?Q?fSeddxbUDdpgQ9TDaNIdB2MbuzjykQ+SFQYZvjSk5WEV7k86Yfsr61kAr8pL?=
 =?us-ascii?Q?ry5b+ruXc1IiatpmnvOBsGN7DTe4amS4di0UptR8Zfn2YJL65dKNmvAKzBms?=
 =?us-ascii?Q?ZmecWfqVtYzeoxxI/io7H6iB35MaedT5CQPX62lyetoCgwZx/8ihhX7hlXIt?=
 =?us-ascii?Q?ltpKMWpFUeqQCPXe/t8rVyW45Y+mz9nFfBg1Hlle6x36Nv9r0ayPeXxfMlyh?=
 =?us-ascii?Q?bUIovG1YG28ZugBy80tj3qHIOhzGb/vnPra/7DB9NXKF3j5JWjdi7bEzZtzU?=
 =?us-ascii?Q?+wSrW3dKE0cUMuNRdZsxRtBIWjK2i6gftpn0tFpMUiHKjo4shsgKYHO+HW6Z?=
 =?us-ascii?Q?D8Gkg/bCPy/iFntbMoi4zmJE/VryP50mf7IriCM1MRcxFhCXysvqTVgYx4Zz?=
 =?us-ascii?Q?nTunfNNdTVHxlHvKs95hFMoqnl2NJR1joCYCvadwEwjaWVqHZKEan2TqV8J5?=
 =?us-ascii?Q?Z+9mv0ayrsnoNDeuokO9sfYJpnpW2+jPa6uV60W7qh5F8QlCqaiJiwzX010X?=
 =?us-ascii?Q?Zck5jmG0RDOkZQmnl126Y5Uhs5aI3OkKmwS4Z8XIpCnWmAetRFUPuXht+9TG?=
 =?us-ascii?Q?80C6Rw2tgv0yDzRiNraQbdyKMJXxapnBk9rK0s7DmGA22SG10iyui67xagef?=
 =?us-ascii?Q?UiGWtoSbtm6qowQGVRyd8qO23KjycZHpjgEvhPaOaB9awhdcFjA0ifzeJZr2?=
 =?us-ascii?Q?0/EzV+3rqpNQL+4lKo+DSb11iFMYA+WwyhWevc++99gJmnp2FXtv0VBkil+x?=
 =?us-ascii?Q?xyXyWP7V3M1kFiEXRDcIyc63KUVxnDVD5ukLFKN0mI5bhvWzUH/OeW7uCdho?=
 =?us-ascii?Q?ib32DivswT7ykRNg6lKGoX9amBaDJ56WK+vnjiZSJzVsfGsbxI3HXDVzFD0R?=
 =?us-ascii?Q?ryKmvBMIudU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xCp/vSZFB4xQLERUXeFp2GxdOep8Q14bE/iCzBpJezp2jS9W7YpYRmYcVrHX?=
 =?us-ascii?Q?9nyoyBducdWZlu2N1y/7aNajDpzAoiezzu4vvdJaD8zi5DlpEfQh/hVav/8e?=
 =?us-ascii?Q?iE4bKBClZP/XmpmgGFKFHQbbtqyWLZDw4pquz0ow2F81z2Ke5yRkeP9fEzFA?=
 =?us-ascii?Q?nrEcGVNOrSE78V6pVwXj8ofPCRcwca9JLNT22GnCJyrs0ZFNeWdNIK/6V9YD?=
 =?us-ascii?Q?yc9Bi2CmPuVS4Qo5Zy/YgoncQVpenbVRHwrlPGrSYbYAoh+F+CckEXHxn+Om?=
 =?us-ascii?Q?TxRwJvkXYx+OFYnRtbnAM0e4s0bsUjRKIQXJ9QV2CbaU9n2SAH1uLYRr6lAI?=
 =?us-ascii?Q?FfAFvUb786U1ZPq4TSUv+UolO20Fm2m7wf8rS6W0aZQlRGOkjzCxLYG9Yq3U?=
 =?us-ascii?Q?dh9LlNG7wiLfTd5d2RKfPzQNZ0r5LUBeAGn3G3E7dwp4OszIn9u4Qw5N/Fo8?=
 =?us-ascii?Q?r0tFHCe+vZHDVPn78rZPobNKSkr9i1Pg9wyiN+qwgLgKd9YvPDL4TFVNoQ6Q?=
 =?us-ascii?Q?Jr/zbe/lpKVwd12d/WY2D7XDRPNmfRKcAPwGC0XrC3XfNgaAz37FqSIqLkDg?=
 =?us-ascii?Q?YTFlP+LKTtJTTkbBEkrRFUEfbPwb6vY5tStNTAvL4ByVRbWJLNIsw/zSEAbf?=
 =?us-ascii?Q?wM+17dCYtqJv2raT1G20BtIRy4ga67088KlTINzgdGP6vsOi0cVhTexgxx8C?=
 =?us-ascii?Q?5Q4qAALkNVOYhSlCuWXOWzjjc4bQIGMmBE1RKmcvwnj2uFLrrRRg3WbHCSQq?=
 =?us-ascii?Q?E5HK8A8C11aLN+9zlQzCe5lzTeAA2LCeYBqz8V/ad9Ry0Qpa4uSC0yXrxUwD?=
 =?us-ascii?Q?ZQ3met0I1Rsjcax61pJOOdcUfg4ujqnMYGr8cwS1ACWaOjlyOGPFz5f/yeUs?=
 =?us-ascii?Q?u2ly6PusUg4DrgXnPMwB2rsHmCcmZ03Il0mkyhb2/4bFO02VbpMinfzSUrEl?=
 =?us-ascii?Q?E6cstzuQAzps4PVWurVHdY0Ma1B2Xj7Wvsh5yla605X/KEX77TCk5BGtKdzN?=
 =?us-ascii?Q?CEw2oAN7nqzWZCoV72l9wVG6QhGHoSZm0xaitPTTTitXxJZUs5leL7jPhNYs?=
 =?us-ascii?Q?fc1zH8ljjnbNP4T85cogSFWzUclysYM5eedTLXbC6rdvEnT5eM6gQvFhJ4fG?=
 =?us-ascii?Q?mNEuDigXyasYwyzMAPJobkV89NAvyTvDkDxXcRsqI5dbcSbOGknQ76NuHEHJ?=
 =?us-ascii?Q?Qn4eNLDHqNSg59p9Yu7UCMs9ZCVYxpCbIXmlfex3l+lvtOy+ORG6RVxB0Nfq?=
 =?us-ascii?Q?eFWg7ljElOIXbVj+Ho7Y3F10bfg7PkSp7OAPMNWlkj39ufkFXkxcy6u1NDZX?=
 =?us-ascii?Q?dirEJTN/x2XFk3T2UPnxRa2iQbZ6fFspL4pB6rhQxF7YXf39H47tc5U/2hue?=
 =?us-ascii?Q?CKgllmICFhMgKdgYgT5axLjMOfmuTVb6DeMoCjfm9ZzvulkYF/pzAa0f8Bbf?=
 =?us-ascii?Q?BOVSE/5x0I1CnJMCjxP8LOx+cnWfBWa/qHOCiav1tP4rnI6iZV2w9ysyzv+q?=
 =?us-ascii?Q?SwOakOKj3Kj8vZQ85rEIUiuty/bkni/2nhM9fHvVnj7zoYg2MrhqhMoXqIzW?=
 =?us-ascii?Q?XckLLs6IyVECY/LU2FY3Q4RIRfAdedzlL91vKIsv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0443736b-4be4-4488-a1d1-08ddf70148d2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 22:18:24.7249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: io3uxfBGE9hTBSJ6zaCBWf9xfEM1j+5B9GGJtEvR/LGkm4Qlcwa+JwPBJFyCugSZn59CNno6lEOie1jAZKMECg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6626

On Thu, Sep 18, 2025 at 09:42:21PM +0000, Edgecombe, Rick P wrote:
> On Thu, 2025-09-18 at 16:23 -0500, John Allen wrote:
> > The 32bit selftest still doesn't work properly with sev-es, but that was
> > a problem with the previous version too. I suspect there's some
> > incompatibility between sev-es and the test, but I haven't been able to
> > get a good answer on why that might be.
> 
> You are talking about test_32bit() in test_shadow_stack.c?

Yes, that's right.

> 
> That test relies on a specific CET arch behavior. If you try to transition to a
> 32 bit compatibility mode segment with an SSP with high bits set (outside the 32
> bit address space), a #GP will be triggered by the HW. The test verifies that
> this happens and the kernel handles it appropriately. Could it be platform/mode
> difference and not KVM issue?

I'm fairly certain that this is an issue with any sev-es guest. The
unexpected seg fault happens when we isolate the sigaction32 call used
in the test regardless of shadow stack support. So I wonder if it's
something similar to the case that the test is checking for. Maybe
something to do with the C bit.

Thanks,
John

