Return-Path: <kvm+bounces-24658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B38958C6A
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 18:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E60311F271C0
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 16:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D607F1C2310;
	Tue, 20 Aug 2024 16:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Uw12TomB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637861BB691;
	Tue, 20 Aug 2024 16:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724171908; cv=fail; b=RMYiHueS3CmOF+Wzmet74lRyMO8/VwkekOdtw3yqNbQR66aT90B0FyfcqigDl3MUjoR9C/cfG6+4V+TLze6h+54d3eQbDjVHIeFjonGjHb9tSYzoIwOv7l2O89w2u6hNDUeOGzS44p7fg5qIG2b46B9n/EdYOsvuxn6KgydLt7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724171908; c=relaxed/simple;
	bh=ch2qkNhOLcR/CHRXR784nsl0YOuvWoUdOISNwM2gA2c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y8MZepHbs862LvVzlz8ma06/gIJ8vt9s/fPhbCkf1KEXqIXawpePBW/gWXpdUJmFyo6xNdZ9t3no9SGEMU+ILsBkVuw7HSIHXpDF2HlhySb1N0GqBLPn6N3r3yo4yRVt+rOnhfqvJvers5Cwkp86xejxW2B7Nvo1fSVzLZgx59E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Uw12TomB; arc=fail smtp.client-ip=40.107.92.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hnFqokhEoOxGJIsWoLelobPmSBRwvK8pdgEYz8szqYvLMmg/gWkgRCurmVE+8k4wcDGHLMbl8kAwZPgkXMDMO6R/NDake55JWDbSsmOW1SCwZ6XJuN1Jr+IGOcCo8ZKfdNSgHmRZ6RMH7Z+jwLuFcoV+Ylhari/9+bgNQvIBQSwwanTwPtdY2bys4oxocUWOIbEX15imghgCSTKecG/XO6Y0AlqBhiGmTVVZVM8QlC8seUmehQ72+RIm+uk3Eb9c9FSewr+4SR7fK7xQ94WdeC7daRAmTAZdY50r5TQQtCpuL5aQWP+TLxNoYRMVu5ObXy6h0T+GdKe5nS+NemKu/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KiKAZn17m61PfK0xwd+m39uVMzTAAwqiD7Ja0XPcLM=;
 b=uYd0winY0F4NAkLwYEzdFW40OgWITsOFRC5+OfijEJjoamAucuSnIb1GtJNpA29JHAlf9rBgHedqZeR/5QcFFF7Qc632bGy4CYTa/srXsmkX8ePelv1UxEB0EZbel+Egf/pq+wu1v5SpZOITvozGT7y0ElRZhbLmj7h95YbdKh0dS/+6/+EsontPpU09GQUt9TUKR4cWC3JZj/9QH93QPIxLZKK0Z04EMGYSrrAv64CSjgOLWhNrvHR96D5pe0DksKYQIsbFx9VHuXlMQBt1quG/vR8nn2lPQqvyXQSTKzJBUrP6oESfGuiT3Gd/Ud0j+G1tuIaUtPOCOJ494W1sYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KiKAZn17m61PfK0xwd+m39uVMzTAAwqiD7Ja0XPcLM=;
 b=Uw12TomBW8JXU4YUPmtrncx0SvZNhHiCvfhpP4mCPeSTIrHw7qoZ54CojcKnBnvFoTNKJ1ooSiBg7xxuCksZX923JQ1+x0C0FYWnIleKzABBWaP0m7LQxfiFPS5/KuSaGFXZXzbjzZSgjEu+pthfnekH7rGoRRRFyVnYj2TNQEE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by IA1PR12MB9029.namprd12.prod.outlook.com (2603:10b6:208:3f0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 16:38:21 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%4]) with mapi id 15.20.7875.023; Tue, 20 Aug 2024
 16:38:21 +0000
Message-ID: <d391cba7-e20a-41dd-b395-3923893bdbc0@amd.com>
Date: Tue, 20 Aug 2024 22:08:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
To: Sean Christopherson <seanjc@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 jmattson@google.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk,
 peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com,
 arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn,
 nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 ananth.narayan@amd.com, sandipan.das@amd.com, manali.shukla@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
 <20240808062937.1149-5-ravi.bangoria@amd.com> <Zr_rIrJpWmuipInQ@google.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <Zr_rIrJpWmuipInQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0054.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::29) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|IA1PR12MB9029:EE_
X-MS-Office365-Filtering-Correlation-Id: 654d1a15-36ea-4f0c-5ee9-08dcc13680c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d2tpNTM1T0FTWGNIaXlZQVFyWlkvYXVDTHpTbWxqdW1rTjJad3JqdEtLdkE4?=
 =?utf-8?B?b1E3OFFJY1hrRndtQmlUd3JrOUp3UFI1TU5ZcWYvQkJ1VWVHMnlubnNUMS84?=
 =?utf-8?B?dVJ0NkxZY29BUjdDLzlnak1wY0xzYURGejZrZ0dTWjEzZ2VvNHlhL1lwY2xk?=
 =?utf-8?B?cUZwcmExZnRyZlNiZEhBYkZEeHF2SmZvaHlMbFRrR1hTN25yeXAzR3FZUHdU?=
 =?utf-8?B?a1M0MUkraE5JV3Bucnh0cHBnenRVMUMrWGlQa3lmdkpnUWNQY3N5K1ZKdFJh?=
 =?utf-8?B?dWtuVTNUTEFJRVM5L28yUVNsV1FCZElIUFlFQ1A2V1JFZkJ1WHAwMWVOMFFQ?=
 =?utf-8?B?UWsrcVBHRElkckpCS01pU0graC9TbzJ6akkzVHRZS09oeXhhTEFrakxvY1pt?=
 =?utf-8?B?VW9uZFpGOWdhaWhPYVVUVGI3azM3R080VWFPa3RlWHd1eThQa1ljZE5FSENO?=
 =?utf-8?B?VjIwTU5rbTBOcGpTV1c1RGtFSFJtTEhROTQ0SmhGdE51cWtNZVQ5aExrVnB5?=
 =?utf-8?B?NUVkeGpQMnowYjlwSFdVZWpyaGl1aVlNTVZKdUpJTFpMci80Mjl2b2hHY29Z?=
 =?utf-8?B?WDdqRSt0R0h4SCtyQVBpbkNZcUJsd0JsQmJYQjh6RjhVeDR4ZjJQY2Y5RVJW?=
 =?utf-8?B?U3Exdm1XdUhybGYrbFkrSUJJSitPMXVyamZNayswcG1WbzBBT2owcDJ2WXdm?=
 =?utf-8?B?YjFSUm5nQ3hNcFpRTTRibUFUdURWdzVkeHRXTWNQb1hVREJ5a3RLTnlnM2o0?=
 =?utf-8?B?cU5SWXFFRE80aDFQbExGdFZVTGMxZUFyUCtKSjFKWEFvYlRRNVU5WnlGQ0dQ?=
 =?utf-8?B?d2hFZ0gzYUVUYnNLdTBOTk9WaWM0QlZpSm5hZ3lJK3pCL2pNaG4vZHhJRldl?=
 =?utf-8?B?N1A2bk9jQnNzQzEvSms5U0dtYkNkS3pURGFlRmk0SW00SG5kcndBVXJTeTdO?=
 =?utf-8?B?aDlEQVZaY1lxeWlIaUJEYWtZeTBGT3hIL3RkUTB1RHU1N29kSmo3ZmtvZUNM?=
 =?utf-8?B?T011NERiU01Sc0dsV1VhZGpKQStUOTRhZ3BiZ0xmQ1RFaDEwWDkrTW14WWZl?=
 =?utf-8?B?RVA1dWRUdjM3UGVUWksweXF2U2xTNk1tQU1RdDlybm9BZm40clJiNjhxMHNI?=
 =?utf-8?B?VkluNlR0RGJlQmtLVU1ScVViUHM5bUg3YUxqSG5lZTg5KzJwVU16YzVZUU5W?=
 =?utf-8?B?VXRERk5OZWZwTFA4OU0yWUU3RXprclVIY05vMU9kL28vUURWTlJuN2t5c2N4?=
 =?utf-8?B?bnUzSWRxSWtWL0lBbXVlOGVuVDJHUzM2TmdRWFN4OStxWGZpa3hvNkp5SlY0?=
 =?utf-8?B?VWFxZEFnTEJ4THVnYUh3RmNaL2l3WUhnS3BSaXpnOXJmOGJTTXZTekdITzVQ?=
 =?utf-8?B?bnEydkt6djU5VlVZbU9XVmtOemhPLy9DdUtoOG5DWVQ2bjYxNnZZUlREdi9k?=
 =?utf-8?B?U3dDZlU3YllReFNVVWUzbWRrQkpqeWdBSGF3WjZ0Q3RtUEVWV2Ryc2tlczVS?=
 =?utf-8?B?aThTREMrOVBKc1I4ZTJxSHRiRWE0MTVENytLaSt1dW9JNmhUVEd4NTFUUmla?=
 =?utf-8?B?ZjdzL1VSWHNVb1JHdW5DNExoRHhNSng2Ym0yRkFTYVlUQS9VRGYwY0hlT3VM?=
 =?utf-8?B?Z0hzV0xjeE96SlZHL1h0akFISGFlVWR6NHFnWmJKU3lsRkJXcytEM3V6TkZ2?=
 =?utf-8?B?T3VVS0ZiWUtOUytFdW0xSmUwRTRQUG5mbm1tSWVzUzhnaUEraVpLZURDZVhw?=
 =?utf-8?B?YXNCcDZxOUdkUWd6SWxpbUY2WTAzbm5hRWhYdTFLZEIwWjhybXl0eVhXNGpj?=
 =?utf-8?B?dnU4UFVlLzNJVTlnN1hYdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEVBZzdMdi9jTVBxMjhRZXZkZHVZeFExVVVXeng0dCtrOHZXZ1R3eUZDM1FV?=
 =?utf-8?B?YmVmSEt4QkFMVkZyMXVQT1RVREJJbE5KMXZsdGNpelBwbjJhR04ybzY4RHNu?=
 =?utf-8?B?Y0t4RFZGaklyS2oyMGNVcGlQOEJzM2w3Y211SUh3QTBBOUdnYWxTM3RvNk5M?=
 =?utf-8?B?ZXJnK2tRZis2ZDFzT3Q3Tm01cU5KTHozV3d2QzV6N0lMYzJiV0t4YWRzY3g1?=
 =?utf-8?B?NWVudFhrY2tmVTlzZnZuVlB6N3pIVENaQVdrVUZkZ1U3L29tQk95WUxPT1hF?=
 =?utf-8?B?cE94ek5FUFl0djRGTjE0bFp0RzlKQWl6TkFibUVlazRhWGFlSmYyN3RGTGxa?=
 =?utf-8?B?cmgxVTgvTG11NjAvZDQrYWorOGhpVXZpN29IcVlCemREbUVtTzdIb0FjT1ox?=
 =?utf-8?B?WFRzUFBoNUI5U0M2NU9wMmIwQ0tSU0VKcVZqbzFFR1kxOHVmay90REl4UXlP?=
 =?utf-8?B?VC9QQTd3TnVuM3gyN3krRmQyVDVoNWdKeWtCVXo4d2JsTGY4TmZKWGhDT2lC?=
 =?utf-8?B?bk1iUkRKQU9QK0I3Q0g2SjFSamxMendqUVRqYkV1SEVQT2tqc0NmVGl6aGhS?=
 =?utf-8?B?K3lkcFZZdVc2a0xmNVZLUVZLLzVFS3BJaWkrZmlDWVE4QmN1YXlPY0JPM2NR?=
 =?utf-8?B?bnpOS2xRcWtQYmhybkd5cmZ3cThxNUVGVmM3UlpGeXRkTjBvMlFFZVRwbUow?=
 =?utf-8?B?NmN0UGFxSkdNMVlzcjhFTEE3UnZici9iU1g2c0ZYc3JlUy9oUTNxZUhDL3My?=
 =?utf-8?B?eUxoYk5zT01sKzhVMk0zK2hNUGNOeDcrU1hZS0JvalF1Mjl6bUpDb1VzTTY1?=
 =?utf-8?B?RGlVcmxaWjJ6R0tnV21abmhpQWJIbXVaTWRWSTRiS3d0cXFBZnA1MWpqN0x5?=
 =?utf-8?B?ZU4wcGlXOTJiclFGT1d4bDcyTHo3aWg0WDNDNDkvQTNLaVUyVWYzS0hQMjd0?=
 =?utf-8?B?V1plWTJDUy9DUkQrU3Q3ZmM3UkNDWXVkaVd0MTExc0swNHNPYWh1VWRIcHhZ?=
 =?utf-8?B?SnBiajhkcGVPQlhIZVR1ajJwNVVlMGZqdUMyWGdncVdVS0d5VGF1TDB6Uk5Y?=
 =?utf-8?B?RzRxRVkwTStEZUtkTnVBMnRTUUxTdWZiWUlncDl2SFJjT3YybEkyY1Y0dmNR?=
 =?utf-8?B?cDNHcEFPSHZ4RTdlaFBhQ3ZkSjJSaUc1YUVmQm84NEhLREZnUXFZaTRtMHpS?=
 =?utf-8?B?cXlBcGh2bHNPNElxUXVlTlhBMDRNQ3oxTUpidTRZR2VYUlJSckhtQ3o4N2Yw?=
 =?utf-8?B?WVFraWNhUnl3c0UvQUNrbUc0Z2ZRZ1Z2bUxwMWFia3lOVElzTkk3c0duS3FN?=
 =?utf-8?B?Y0ZWM1BEa29TNkFGdVpOblk5c2YxRUZPTW42ay9zbkZ1TVRkWkF1SUxnZXNj?=
 =?utf-8?B?cDBxWlpNaEt2YStIMENRMkoxc3QwcUFuYUF4c0NPVzhEd050eUtvMDljbWJK?=
 =?utf-8?B?Y0ZhTmRMQ1FRYTlNRnVSSUlLOHVQaWxZYlRtWnhoOHVpWVRsNFJIR3dDUUZB?=
 =?utf-8?B?aWNWbm1FUVgxVHB0QTRFNjZSSThkNko2TnNxNTFCMmZEbTU2VEF3TWtJYjlY?=
 =?utf-8?B?MG80YVdJd1c1QnFxY0hXcHIwVGI5cmNzSnRlY1ZwbEFlMnlzWEFCSVJRYWQ5?=
 =?utf-8?B?U1paWVVOUlVZdWY0eDRQV0ZQUUxtN2VOSFNrS0lpVUtsN2JXY055YWhKTmxP?=
 =?utf-8?B?ZlgxUVk4ZjIybE1xdnkvenMrZG1icXk3R2dCcE0zZFVaMnJEa0Z3YUQrUFNJ?=
 =?utf-8?B?M3REMk9MdEVsTjUvTiszS09RVVJvUmswVXZYaEx5M3hSRWlHWmRTUzVoWkVC?=
 =?utf-8?B?ekE3WWg5aDFtbDJ6cEdIOE5wUXNORG15dy9SY1NUSWRpS3c1dTdDWkJ5d1F5?=
 =?utf-8?B?R3lsRWRrSks1enFDZnU3blNFOUxJemJUZmFYTk1mcVNhNkNrZ0YwL0ZFTnRY?=
 =?utf-8?B?c0FpUEFvcERXZDdhb3NwMkpIZjJGUWJmR2ljNTBxajd2dXdXQzZNYWZtQ1ZH?=
 =?utf-8?B?RU95VjM0YjZKcjAzSlZkTUpFbXBHeUpVNEhrOWNlM2VHdVZUdXJaRWNxMVRG?=
 =?utf-8?B?MU5RejZRUmVzUjlvR1JZWTZiWjhXTUREaFRGZmg5Tkd4VzNyRnU4TFVVWFds?=
 =?utf-8?Q?J3wikD/y77iKm9gyxhSMxwp8f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654d1a15-36ea-4f0c-5ee9-08dcc13680c2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 16:38:21.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMypDacSMQmPCqrDftPwcR8j62ojdC/2JarFWEJJkcfwFRUlfCQgPghaxXbpl+8GPYuMEfXob3/xsFzUgJCXJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9029

Sean,

>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index e1b6a16e97c0..9f3d31a5d231 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1047,7 +1047,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>  	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
>> -	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
>> +	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
>> +	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
>>  			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
>>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
> 
> Out of sight, but this leads to calling svm_enable_lbrv() even when the guest
> just wants to enable BUS_LOCK_DETECT.  Ignoring SEV-ES guests, KVM will intercept
> writes to DEBUGCTL, so can't KVM defer mucking with the intercepts and
> svm_copy_lbrs() until the guest actually wants to use LBRs?
> 
> Hmm, and I think the existing code is broken.  If L1 passes DEBUGCTL through to
> L2, then KVM will handles writes to L1's effective value.  And if L1 also passes
> through the LBRs, then KVM will fail to update the MSR bitmaps for vmcb02.
> 
> Ah, it's just a performance issue though, because KVM will still emulate RDMSR.
> 
> Ugh, this code is silly.  The LBR MSRs are read-only, yet KVM passes them through
> for write.
> 
> Anyways, I'm thinking something like this?  Note, using msr_write_intercepted()
> is wrong, because that'll check L2's bitmap if is_guest_mode(), and the idea is
> to use L1's bitmap as the canary.
> 
> static void svm_update_passthrough_lbrs(struct kvm_vcpu *vcpu, bool passthrough)
> {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 
> 	KVM_BUG_ON(!passthrough && sev_es_guest(vcpu->kvm), vcpu->kvm);
> 
> 	if (!msr_write_intercepted(vcpu, MSR_IA32_LASTBRANCHFROMIP) == passthrough)
> 		return;
> 
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, passthrough, 0);
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, passthrough, 0);
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, passthrough, 0);
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, passthrough, 0);
> 
> 	/*
> 	 * When enabling, move the LBR msrs to vmcb02 so that L2 can see them,
> 	 * and then move them back to vmcb01 when disabling to avoid copying
> 	 * them on nested guest entries.
> 	 */
> 	if (is_guest_mode(vcpu)) {
> 		if (passthrough)
> 			svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
> 		else
> 			svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
> 	}
> }
> 
> void svm_enable_lbrv(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 
> 	if (WARN_ON_ONCE(!sev_es_guest(vcpu->kvm)))
> 		return;
> 
> 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
> 	svm_update_passthrough_lbrs(vcpu, true);
> 
> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
> }
> 
> static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
> {
> 	/*
> 	 * If LBR virtualization is disabled, the LBR MSRs are always kept in
> 	 * vmcb01.  If LBR virtualization is enabled and L1 is running VMs of
> 	 * its own, the MSRs are moved between vmcb01 and vmcb02 as needed.
> 	 */
> 	return svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK ? svm->vmcb :
> 								   svm->vmcb01.ptr;
> }
> 
> void svm_update_lbrv(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 	u64 guest_debugctl = svm_get_lbr_vmcb(svm)->save.dbgctl;
> 	bool enable_lbrv = (guest_debugctl & DEBUGCTLMSR_LBR) ||
> 			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
> 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
> 
> 	if (enable_lbrv || (guest_debugctl & DEBUGCTLMSR_BUS_LOCK_DETECT))
> 		svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
> 	else
> 		svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
> 
> 	svm_update_passthrough_lbrs(vcpu, enable_lbrv);
> }

This refactored code looks fine. I did some sanity testing with SVM/SEV/SEV-ES
guests and not seeing any issues. I'll respin with above change included.

Thanks for the feedback,
Ravi

