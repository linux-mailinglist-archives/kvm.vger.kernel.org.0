Return-Path: <kvm+bounces-10307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DBB886B9CA
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 22:22:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52A26285DA6
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 21:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E475B70021;
	Wed, 28 Feb 2024 21:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W/6n1Ujf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2051.outbound.protection.outlook.com [40.107.95.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFD486250
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 21:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709155332; cv=fail; b=YCsBjbqS/Uh5WKioECdnTR1VxglkoestXySvTmu+6z/gp2dOCBoJStTFuEgoD+SConnovCjKhJGRTvmjQlLJMfZAD0bT3Wq9B8BxjxyZywM0aY/+rBw0kKixSfkZ1nCz8um9uzX+VXlgC+h3SORB/meh9eSOXolvbnAWhrzIG7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709155332; c=relaxed/simple;
	bh=P+c80z35x7869M7AQiDzlkhC72YHcJGwDEHSGus5GQA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SsfnZsyYA2e3f5TQyVwWhjXmAFyc0oX08fk/g+g40mMwN36sPKRXMBj2ylh8CXUoV8RH4b3DaHIwzQWKfS9qqMxXJjeTqfFFssZ3XC8eT3H3v+hOKV275qKT9OyVbnnk74xf9Dxw73yS8QURIA1wVlqUBmpS9d2ScdP8UhU6O78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W/6n1Ujf; arc=fail smtp.client-ip=40.107.95.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJYxWM/CS9dqA50jCfL4bsx9OMNuYxRO5o2788XkoGOhMSRFa9wNiYsR/S4EAfgVAu72Pn64OtNDDQQadckT6XOR/ncA+U3WV6QfRR3leNZVGUabsn8KHimlSTOYT4wKUjViz5sUW/LqiCnBWODGKVebZvKTk4V4pcD4mltqGv4F5cry6sjY0AvTSWLzMk0FJ+UhUaNEfHu3fcIhJHwitGxJwfR7iRg8LyZuoqYcsUBacdujWz8fsZ91vDHmN1szrq2do9SkJrWNOjwqNp1eiJuqMwkT5dIv0hS19/qOLpJnfu2hd8DKDXBOTXZquYhzJUiOhYYvb4O8inPnbftT2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dj75PmMLN5A6l2He9dZLS881z0useZOtqJ78v8QVRTs=;
 b=PxREaTS2fSd86boqWUJL0eC42kdIGmn16wq9EWkhgIRCR7Jo4tkBHFuMGqGVZF1UYEXT/z2kEj2e8vK4rsDOM0k0NflixBKqY1mDRI+/km90DanafXViKjkyeixROhgALQGg08VSILKYngsjcF9UEfOSds0a/NhWUC8CcvTmn1Vh12Bx5Rg/N0787UMHZlWg3VdWfrN6hkR4YN/cBuWR/CWMVS6qbx7s3j750BQEXBmnL6RdrpsHr3cAtiuV2f/5LWA3Po0rTYWe9vj35JVpae6HRDUlQZG7q2dm0uN5nI3SxYAEPoFDEutE+5Eo31hWB7AYiveFXAq121dmCvwMUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dj75PmMLN5A6l2He9dZLS881z0useZOtqJ78v8QVRTs=;
 b=W/6n1Ujf9V/2mlth7mF71g5/+i7tCdOfhAPIYj2gdPf04stULiIm5C+cfL2HY7/VzKHFbRkuGlZH+r1AVz6CvX9aBJ++SU/yn5t2KeUO3cjLkhQ/ChjcAiKAAOk8QJ9lvmOwM3sEAx+tcVVCG+t4FqeC01rW2otoSXwotP4VPvw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by CH3PR12MB9217.namprd12.prod.outlook.com (2603:10b6:610:195::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Wed, 28 Feb
 2024 21:22:07 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b49d:bb81:38b6:ce54]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b49d:bb81:38b6:ce54%4]) with mapi id 15.20.7316.039; Wed, 28 Feb 2024
 21:22:07 +0000
Message-ID: <3ab53ea9-be77-4ee7-9247-d89c0ec62346@amd.com>
Date: Wed, 28 Feb 2024 15:22:03 -0600
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v9 18/21] hw/i386/pc: Support smp.modules for x86 PC
 machine
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Yongwei Ma
 <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-19-zhao1.liu@linux.intel.com>
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20240227103231.1556302-19-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0092.namprd07.prod.outlook.com
 (2603:10b6:4:ae::21) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|CH3PR12MB9217:EE_
X-MS-Office365-Filtering-Correlation-Id: e9ca65e5-003f-4ce4-70ce-08dc38a35111
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eQCzzp3EtMzcFaeJpkf2zjcUAUHfN8Irc4Ccpemc39Wmo8b4mSuge352qkl25C8zLeee+sX70B1oNrXgNpHIlBT9IoqDKQAKWyo368OayQf2cOyXj90AqQikOfcY+aj2HvBo1K7xG7/xpsvBvD/qm4i2yNbsAWxI6dI+NWrJSVHZoPFjk3An6tnaO3qo2Lp3NdOF7Kj2nc6PXYZ31EvsBof+AeIh+MFfzggLJSBJiT0wyiaTZL0XjRDiR9m8wloUVmEVBaNN+vBOxi+xJS5zJvtjJfuRjRYh0ppTwwk04ZAfaVh8QCsiBU/r2TSQh8iD0dwuyqJMMyicdlyFMtJh5sqwK9NJnUIyidwdsJzgn6pqMoP36ihVcXS1J/ZRbSPFEZcQpCkxotfJDhd0be5KWNuGgm9yTLdHQT5diz241fx7zhJJLRwItv0fcmdDmiTrhETtNeo1dnSgph59ZfZjg+t0NKdQ0X8gAlAJM0nCkDJ8jTsY7rkxDY/Yprk8kgM0Krw3hCnrDAQ7RmcOqymlH1Jm8bpZTtzJzbVQsEcLay7I5qwt47hMWKgRDfPbGEJYEdClCSr/i7SoQ6hRBkmeLDh8sglAH5t1keiBPZ4CWDIsG6rocEUCRkwNSQwRmsYVpY6PeOspeE4xqR/W09oSNlOjeyUZ6aefKV/xQpUM1xa6J0GDGcfatGcOH0qdfnscA+1xnHDN4RBY8G+7g3yV+g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0NRU0VYMlZDSzVQcXA3azhGY1BscFROdk8ycnd6cVd0enppZWsyYmRwRVBC?=
 =?utf-8?B?Wlp0WGtzYzBEWG5Zb2F6K01tMitnWmdwR1ZjUUJmZWp4M0xSVVN6eng0d3Ny?=
 =?utf-8?B?ejAva1VFM1U1bCt1Tm05UGpVSzhGWXhFU0NnS2ZsYzJQb3A2bVRRZ2hNTFBj?=
 =?utf-8?B?c1RWRm5LTGhnU1IwckVKUDBVZE45OFhyMnpDenpSbTgxWThiRENhblhCMVpP?=
 =?utf-8?B?dzEvTW5tYkdLMjcvdFN4WlJNOE9ZQXBWem1rdDVaKzdvL0NvZ1E4bDV4bFRU?=
 =?utf-8?B?VFJPMFVrNUhXK0xiQ2F6QWI3Qng5NzB0RFZ2QktpeVduc2s0T0ROam9qbTdh?=
 =?utf-8?B?VnlOcnIzWXFyUnY3VDQxRFQ2Z2dMSnZhakVTM3RQYU80VDZXOS8wZEFuUmds?=
 =?utf-8?B?K3hPRjhWWTV1UU1iMmt1SFRrQjA1Nkd0T2NGQjB3a1V1Zms1ZU9QT2RzcDI1?=
 =?utf-8?B?WmpLeXp0cDY5L3Uvcyt2VlhyVFVEeVh6SU9ZMTNGQmU5SUNGMG9tVVdjVDJJ?=
 =?utf-8?B?a3h6b2hCYytLUFZtTWRUbG1MMzIzU0tvV1YvQ2huelNQNmgxWlZPamp2Y1Zx?=
 =?utf-8?B?RzVyTHJNT3VMdCtsVkVsVjNUMlZ2dkxmd1ZHWFM1d3hMdHAvdERLTDYwYUkw?=
 =?utf-8?B?MS9jSjFMemJUdzJIT3ZrNmJML2hIZUR4KzdQS0NESTlId1BkUTBrRDQ4UGs3?=
 =?utf-8?B?YmNvWDNJTVFjZEdJelJGdzJqUDVWaWRZdlBwRVRLWllrQitSQnRtMEVpUG02?=
 =?utf-8?B?RlJmRi8yZmVyNURSNWE2TzdCQzlVdnpHRjRRMmdickVjY21hRUtLZWdFbzNz?=
 =?utf-8?B?Y0xDVGtERlY2ekdPK0xoOTZRQnVqTzAvSEM1VHlIVTljanlUZDR4SjlmWTBR?=
 =?utf-8?B?dE9tUXFaenBLZW9RTWkrY3lCb0l0dWlmQkFwQUFFaFVZeHdhYTdPZGFyQWpT?=
 =?utf-8?B?LzlraGNxYjJ5dFNTK092Z3JUTnNyajc5SFZ0d1lqRXhqc0N0T1VldFhGU2Q3?=
 =?utf-8?B?elJiQmFOWUd2Z0EvVlRLck1DUlNrTnAweTRlRXVqa1lUZ1V1YzZocFpKci92?=
 =?utf-8?B?eTQ3Um5TOXQ0N0Q2YkNjbTNjemxKWkk1S2pxRzJUZDVvN0o3cW13anF2N1V4?=
 =?utf-8?B?OFRuV0J6dFFGaEhNTWhGVXFSVGpRS2FyV0lwNUxBL0FJZEhVYnVYeDQyUUVi?=
 =?utf-8?B?S01DU09rMk5seFdZU0tuSTYvZklwQVo1Y0ZFYURYZkFTM3A3ZjNkNDEwRzRU?=
 =?utf-8?B?d2k4NUdwaVJBWFQybXFRclJQNC9RazRaN1A3ZElzdmJwMGYyMW5YTHFJSURq?=
 =?utf-8?B?eFppNmJmRDRLMW1hVlY4SWFleWZqa0lQS28xeHNXb3JDOTlYdGZxWVVuZTBu?=
 =?utf-8?B?eUdBWkhoSTRPazRFdjNsK0tJOTZTQURTSmphb2hxMTJ5VFlQM0dTTGk3aGpp?=
 =?utf-8?B?NVNXcEh5aFRrSEE3SDVUNGJOcEQ5OUo5NzdFeVFFQ0NYWUlVTVJOTnlWTlE3?=
 =?utf-8?B?akxsVjloYi9Od3B5cGJHQ2lTd2V5RWloa3UrY3U2VU9kMGFsckRBanFzZ05R?=
 =?utf-8?B?ZVBzb2VSdWtEWjdnb1RIMHdlRWE1YjNQbE80cFdMZ29BbjhQT1BWcktmalpV?=
 =?utf-8?B?RWdkY1o5YzFPRk1BZTN5RzBFVWFLbWovOTNONE5aZ09zeWlUK1NQYXU2R2Jx?=
 =?utf-8?B?Ukg4RmI4bWVaV3d2U3RrVXZXanJXdW5ENjlzVmI3TU5tcW40NXpPbzcyK0xi?=
 =?utf-8?B?SjZDS3kzdEhPQVpIeUY1RmlWcVByUUFaR3FkRE5lcjVEN3RuOWxMOURpKzRM?=
 =?utf-8?B?ZGNIUjVnQmh4OEs5b2wrR0p1Y3dzOHZaU1lsbWxJNWhkaVdJZUpHSjFROWpx?=
 =?utf-8?B?RnppejFNeU53b01uSjBEVlgzWkxBMW1CN0d0dnF0eS9Gd0dIV0pUUzlwRkxl?=
 =?utf-8?B?eXhlTm13aXl3SmZsNElmSGtBdk0reHE1VlFlZW1ra1ExU0o5UldKMlI5NWdD?=
 =?utf-8?B?b0NHMllpN09LWUtPdS9YWStkVG9EQUJrNDc2elNlem9ucVRRYkRlY0l4cHZw?=
 =?utf-8?B?SWJwRjlHdjgvSUhkNlI1dDFlUytURjh5WkdXV3lLQTVUTFU3K3R4UGZkcWpn?=
 =?utf-8?Q?4Boo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ca65e5-003f-4ce4-70ce-08dc38a35111
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 21:22:07.3634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4fF4gN96j4xNOCo2bWrzYxchvLxs0rqyw5ddebghqSDt0JdhvWUSX1TZe1Zwt2U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9217

Hi Zhao,

On 2/27/24 04:32, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> As module-level topology support is added to X86CPU, now we can enable
> the support for the modules parameter on PC machines. With this support,
> we can define a 5-level x86 CPU topology with "-smp":
> 
> -smp cpus=*,maxcpus=*,sockets=*,dies=*,modules=*,cores=*,threads=*.
> 
> Additionally, add the 5-level topology example in description of "-smp".
> 
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
> Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since v8:
>  * Add missing "modules" parameter in -smp example.
> 
> Changes since v7:
>  * Supported modules instead of clusters for PC.
>  * Dropped Michael/Babu/Yanan's ACKed/Tested/Reviewed tags since the
>    code change.
>  * Re-added Yongwei's Tested tag For his re-testing.
> ---
>  hw/i386/pc.c    |  1 +
>  qemu-options.hx | 18 ++++++++++--------
>  2 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index f8eb684a4926..b270a66605fc 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -1830,6 +1830,7 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
>      mc->default_cpu_type = TARGET_DEFAULT_CPU_TYPE;
>      mc->nvdimm_supported = true;
>      mc->smp_props.dies_supported = true;
> +    mc->smp_props.modules_supported = true;
>      mc->default_ram_id = "pc.ram";
>      pcmc->default_smbios_ep_type = SMBIOS_ENTRY_POINT_TYPE_64;
>  
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 9be1e5817c7d..b5784fda32cb 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -281,7 +281,8 @@ ERST
>  
>  DEF("smp", HAS_ARG, QEMU_OPTION_smp,
>      "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets]\n"
> -    "               [,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
> +    "               [,dies=dies][,clusters=clusters][,modules=modules][,cores=cores]\n"
> +    "               [,threads=threads]\n"
>      "                set the number of initial CPUs to 'n' [default=1]\n"
>      "                maxcpus= maximum number of total CPUs, including\n"
>      "                offline CPUs for hotplug, etc\n"
> @@ -290,7 +291,8 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
>      "                sockets= number of sockets in one book\n"
>      "                dies= number of dies in one socket\n"
>      "                clusters= number of clusters in one die\n"
> -    "                cores= number of cores in one cluster\n"
> +    "                modules= number of modules in one cluster\n"
> +    "                cores= number of cores in one module\n"
>      "                threads= number of threads in one core\n"
>      "Note: Different machines may have different subsets of the CPU topology\n"
>      "      parameters supported, so the actual meaning of the supported parameters\n"
> @@ -306,7 +308,7 @@ DEF("smp", HAS_ARG, QEMU_OPTION_smp,
>      "      must be set as 1 in the purpose of correct parsing.\n",
>      QEMU_ARCH_ALL)
>  SRST
> -``-smp [[cpus=]n][,maxcpus=maxcpus][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]``
> +``-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets][,dies=dies][,clusters=clusters][,modules=modules][,cores=cores][,threads=threads]``

You have added drawers, books here. Were they missing before?

>      Simulate a SMP system with '\ ``n``\ ' CPUs initially present on
>      the machine type board. On boards supporting CPU hotplug, the optional
>      '\ ``maxcpus``\ ' parameter can be set to enable further CPUs to be
> @@ -345,14 +347,14 @@ SRST
>          -smp 8,sockets=2,cores=2,threads=2,maxcpus=8
>  
>      The following sub-option defines a CPU topology hierarchy (2 sockets
> -    totally on the machine, 2 dies per socket, 2 cores per die, 2 threads
> -    per core) for PC machines which support sockets/dies/cores/threads.
> -    Some members of the option can be omitted but their values will be
> -    automatically computed:
> +    totally on the machine, 2 dies per socket, 2 modules per die, 2 cores per
> +    module, 2 threads per core) for PC machines which support sockets/dies
> +    /modules/cores/threads. Some members of the option can be omitted but
> +    their values will be automatically computed:
>  
>      ::
>  
> -        -smp 16,sockets=2,dies=2,cores=2,threads=2,maxcpus=16
> +        -smp 32,sockets=2,dies=2,modules=2,cores=2,threads=2,maxcpus=32
>  
>      The following sub-option defines a CPU topology hierarchy (2 sockets
>      totally on the machine, 2 clusters per socket, 2 cores per cluster,

-- 
Thanks
Babu Moger

