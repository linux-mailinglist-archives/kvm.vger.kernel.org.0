Return-Path: <kvm+bounces-57401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F25AB55005
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55D403A98F9
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 13:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038C43043D1;
	Fri, 12 Sep 2025 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GlDJ4EsC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C9D13BC0C
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757685035; cv=fail; b=LhIEePzL5oPDtN49Dibfsnak2ZIvKMLPfZQEGjlHoJOF19iNqvekgSNsAhiYOQ6C6wMu49XtaYIpVGBnMLRkbuyudk2cIOXxGT8CxgQ8/2rF4m/jEYETwGnou5jfxHJh4mulBTEeJ1SWrGRZSiaAUb9DkqRkqlufmeumdxAeGQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757685035; c=relaxed/simple;
	bh=NnLLOMUXqMjgNgCxGqadd96ucdC8tzYipJ1roSzWr4w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SezLUHd8KEy2x3Jowm5lKh8tBigCPws3Grxh0oduxlJ+Zxp1YrUJXRnFfWL1DOmcaL+tOOpQbt7LFZN0htjd3WbHCK1GAzvNOrFpxZkOfShW+6l3WK7TLzn+ooqnCAcVcouCw2vQCOTKdldIkm5DS9fLaMC4Gdly7uZ0FZVG2OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GlDJ4EsC; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqSzJOg3bl5YSCGH/yWV35PEwaRtmMkenU8XvlC6A4e+q2RqmMywq6ov7kxt58/taor1bd5fEBdUbK1UYIRQC5fB5hnqzNd4ejyu1fNYadv7EP2/8jkGeKVU7qgqee09yiRDHJcEgxwaXNzQpwDhBLsxFcnbLieGCm1CLbJf/P4EyDDfSuRdYeH3zdDkYt3AQWR5TzSGWZ32fKwJ4o4dwKs2dhe1MbSG0wn2/M2tMhL+qzrmKZahXzwXI782rxixkxtuMVsdCQstWJ0GgLO2yE4nDtPPC+Y2P/ZU0RbKoSJxQNbyM2ek0fqzvIwF1KXXqYexM/kD85tKQr5yugyPHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4JOfSCLqTDp3ljzfhhHMWwYfhEKsLuQWGFCUYJLdRM=;
 b=hS+DWkoRDR8+EL/qSeyHr7E8QBl7YvY2G9EbtpdpdXLqb1Z7v/2AuIsR4MS5W33/K3x3udoesBtGlrgdFQ8fdi//8ncsNHgkMUazFtZ0/ZCTQfneV538zU+E4efzCiCCu3te8gBJ5pSJNXXsjijIoFusiAO6Em9Cg7xAHA0IOxUq13AmUmbRDbrOIQDtCxw8Vwm4pfWh/WbiJZeWowYue0yytl2qUame+1yR1MjMWPum40r7QtyF+fIunaRDt4h6UHEcYoZETuTwsXjno/GPTv/F/3tfJe7gAsq527RG9GyRKddPnxwPPNGLpVqxUWGBRO+YuL2yy5qc2KorzGLZEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4JOfSCLqTDp3ljzfhhHMWwYfhEKsLuQWGFCUYJLdRM=;
 b=GlDJ4EsCsh0vB7lXwSreKA7ZfWNiBPZoQnKOcNGJjZZiSF9Rt7H6nKlXmYCBzuE0NMCKue+p9e48FDzYf6XL2OfkC4u3XUhckJcBYAwM3PfiXsn3zP+IaaPaMwEfUd9bg65r3wVkiTKIZDWHY1kPD1hNT1BYwa93//JMq/z8cq0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB7643.namprd12.prod.outlook.com (2603:10b6:610:152::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Fri, 12 Sep
 2025 13:50:30 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 13:50:30 +0000
Message-ID: <98064a4a-41d7-4071-893e-4cced0afb66a@amd.com>
Date: Fri, 12 Sep 2025 08:50:28 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/7] target/i386: SEV: Add support for enabling
 debug-swap SEV feature
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 "Daniel P. Berrange" <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1757589490.git.naveen@kernel.org>
 <0a77cf472bc36fee7c1be78fc7d6d514d22bca9a.1757589490.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <0a77cf472bc36fee7c1be78fc7d6d514d22bca9a.1757589490.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0178.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::33) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: 41758d46-e9a6-44de-9de9-08ddf2035678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cU1ZdWhlMWw4Q29OK0ozU0dOb2t6TGtYa1ZJcG1FaXUvS3VoWFlVNThBUFEx?=
 =?utf-8?B?dGNMS2NvdmVFY2RjQXVidEhWYng2VGdjUVNLbThlL2tud285WWRMZjlUM0o1?=
 =?utf-8?B?dlg4MXVGOGZORUcrZmsraHBGYkp0WjNKV0t1Z0FUT0wwakdlcnB3M2wwVTZC?=
 =?utf-8?B?OW9vYUlEUUpZTFZIT3Q5djY0RDQwbTRTTVJUaUJvZzZDTGVZdFlUN250MWll?=
 =?utf-8?B?U3Z2R0lsNS90V0FlVlhvYzNlRGxRZEJJSWZFRXlvRzZYSUFBMVZnbS8zamlM?=
 =?utf-8?B?MlFjWHRyR1RaY2gyQ1RDQ2twOGlZaTZkSnJjeVluOWNqTEpIZzBhUFY3RWta?=
 =?utf-8?B?YXI3UEJNSTRyRWhYVXN2cnpxeXlYOThuajJRb0pNUnp2S2hqOXd4VUxrdjAv?=
 =?utf-8?B?L202SzhBTVlkemN4MUZYNTJJeEkxSTVzaWpPc2hsdzA2ZFlMMm5hdUdCV05V?=
 =?utf-8?B?WEhZTGNyRis0d2V2VzhoSk5KUHg4OUhCTHZTdXhmUVVUZE13aTJRRmVHdnZw?=
 =?utf-8?B?TGNsRWV2WEo2aUw1NXlNYWplY2RxWlNrNS9sMGcwd2VLdmVCZjk2eWNOckZw?=
 =?utf-8?B?V0x1ejNrVlJWSG4vS212bEZoUHBlOHVMS3AxMTVHU1p2NVVIWHlFckpWaTVj?=
 =?utf-8?B?YmNLM2pNekdWMlJuYlA4K1VHeldsUFpJZ0ZNNkk2NzBGZU9Fa0RnZzNOcDE3?=
 =?utf-8?B?eVdpWXJETS9lZVpIWjMvbGdwNlhFM0NFUG9QM1piYmI0QUxSQjROWE1aMEZ0?=
 =?utf-8?B?VTNwU3ZiMlFRL1BNbTNqVWpsZzNQbFFMWjZsZTZzKytuaXRpVHpWaFJmZldS?=
 =?utf-8?B?QlZKK29VZEZsY25UN29rQkZQc2FiS2xXZVJ5alFlb0piUHJjbmZVTnkyMTRv?=
 =?utf-8?B?TjByb2wwcmJrYm05alQrQTQ3TUN4ckV4c1I5VkMvMnRCUlRIcFJKbXI4Zngz?=
 =?utf-8?B?RHhTSCtWZm01Z1hPNDJMVVlJR21JQ1ZmYStCZ01UU0pUN0lYWENYYTREb0Uv?=
 =?utf-8?B?ZjlOTzVrSlZBaDZHbGduRkU1cm5ORldSWmI1YTNVbnVTVDRrNGhQMWFlWDZT?=
 =?utf-8?B?T0gvTlc5eDVOUW85RDVUR0pDaE1rOHlCMFJQV1RvRkt2VVl6ak1wRVdXbHVq?=
 =?utf-8?B?MVZHZzZOMEhjME80dTE5Zk1OMVE3RUxVVEpxbittNDZHVkVENXRTbGFCQ00x?=
 =?utf-8?B?dVJsWlR1TWR4bmlOajlUTFpZTlU3dWlhY3hzZHp6QlMxVG5ETVFPc0hRR2NR?=
 =?utf-8?B?cDNiV1dSVnl0Y3lGTURONERzVnRyRmt4d3JLSlpYdE9xWTJpQU9CdHVIUkIr?=
 =?utf-8?B?T1Iza2h0d2o2N0I4d2d2cjRvT3lHa2ZzVm8yRFZodEx6MVNvbVBsdHhvcFls?=
 =?utf-8?B?WWRwVVd0ZnNjb3pHUkJENEJhdUpFT1QwWGtNaEkxaUFxK08wa1JyTENwb3VY?=
 =?utf-8?B?ZUsxeDZnUnNaNEkyQmQ3UzgrU2JXWjFTQlZXSHR6Y0xNdjlLSExYcHJuc2Rx?=
 =?utf-8?B?SjdpQlFxVlBBT0lpZEI1RmJKZjUxTXBnSjBpZ2RBSDE1dlRoTW5VcERJTk01?=
 =?utf-8?B?b2tKWGlkRVBDNTlCU2ZxM01pNEhSNit5NWxtalRvYWFwVW1uVGdyRW1PeEpS?=
 =?utf-8?B?VStrWWN0a3hXbnc3RTJJUnA1N0tvL01LRldzWGlZSk5ENWpQQUpXQWhCWmMr?=
 =?utf-8?B?V1FJeG9vZzVEUWh5RzVxWlBSeHpqeUp5cnMyRGwyOE1BNkRBc2xRRisxenkz?=
 =?utf-8?B?MDU1T3JVZlNuTU4yUG93YSt3eGdZTm9KTk56RUh6ZERpTFNzczF3YTJpYyt0?=
 =?utf-8?B?UXlsNUZpVlhrbG4rSVNhRUtRajNOZVRNRm9tbEx3Q3AxK1hYaW93b0pkaFBj?=
 =?utf-8?B?NDlPWFdtQzNRMU5jNnJLR0kwNnRnNE4xRE8zdEVWd2FnbkF1QlQvYWc5YWpG?=
 =?utf-8?Q?W1HvxyIGaA8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3JCQ0dsdVFCSTlNRlpMZTVRb0FicTc4ZlBFK2FhN0xHZUVyemFXZndIbzNQ?=
 =?utf-8?B?c0R3cDlzdytqaXp4VUNSWDdXQUJxQ0hhMXFwZVJpbC9mQXhOWm4wZVBXY1Iz?=
 =?utf-8?B?bkx4Z0M3SkVsenEzVG5mUU9EVHk0Tkllbk9XOFpwZE5vQ1U3TTRkQXl6bDYr?=
 =?utf-8?B?MzVFSjVwNXlUSmlXVjBnVHoyMEZaYkl4NkZSUEZKVzE1ckVDekl5YXc0Qkto?=
 =?utf-8?B?dCtESEFZeTh1Q3ErT1lCa3BnMjc2VTFSeCs5bmRyUGpjQU8wUmlkdE5jZFdm?=
 =?utf-8?B?NU83TDE4akVOM2dFczZmMDd5d0VzQmhyZWR2cTRjUDduQzU0MmxFZCtGZEVi?=
 =?utf-8?B?S0FrZkJSUm5KNlBNWjJTdlBvK2xObGlLd0Q0YWl2aEluYzN0eHRlVWdVVkZS?=
 =?utf-8?B?eUlac01kaE5QUW9PZmlDL1NaZUtkVC95NWgzWk9IM2RxQWxFSndhZnhIaVBK?=
 =?utf-8?B?QnVULzA5Y0lsSEk5bkc3QU9NMG9SZ21VMm9NeFpLNWhEeWdzeVRwU0dYM3Ew?=
 =?utf-8?B?cER5N201ek5WTnVKSjA2NzJBbTFXMVAvbU1jNjlzQjZyby90NjR3YmR3TE1T?=
 =?utf-8?B?dnlMVzBkczhXY0Y4d2dJQ3k4Und1UE90SGZlRk9yVXRMaWhYUU1tbWRnQjhT?=
 =?utf-8?B?ZmhPTUlJY09HamVqeGY0VG51VTN1VCtGWnhFbHNmeUFHK1hnaXNxU2YwME15?=
 =?utf-8?B?S1M0RVdaVCs3ZzloVmpaUkk0VFBpdm1zN2tKcVVWaVR4NzNpaGI3NUd5L3dF?=
 =?utf-8?B?QXdyQ0huT01MTnBrczRZSWFPSzJxM3JUZ1lyMm0zNFNhTmQzRlc5Qms0NHpv?=
 =?utf-8?B?MllNU001VEVUa3I1MEI0emxvaUpkTHRBRTZubU85UC9TSlE1RWJFVVoxMmlk?=
 =?utf-8?B?bUVPMVdFQkRjay9lbmo4QXF0NXovOGpDdDhBVHltV2p5UTNMRHZWWC9ob2tE?=
 =?utf-8?B?SXNQKzg5MkVnemFBbWZxRkZYblRXd1RVR2piTmpzWXhHN0sxMFljcVp5UkVw?=
 =?utf-8?B?ZmVOVnIrQTg2cDNOSkZZb005ZFIyNjFZRjZqZm5OTlRJNkNVK1c5SnNYbThr?=
 =?utf-8?B?MFRvZEFpenRKYkI0bXZtV1lsVmU5VjdwZHVreEZjSytGMlRCTTdCZlU3UmpL?=
 =?utf-8?B?bnRJbXVEYUw1M2NXemJ4NVVZcDFjQ2Q5MjlBZ0FKcnJFNkZKTHNIbjlOb0xv?=
 =?utf-8?B?VjBmUi9WLytRRVFqYnlreGQ5eWlFb1lUaS9kaHhsYjZ6WEFtcUQyZ1lmYkVo?=
 =?utf-8?B?RlJReUo1b2dWZDVxNGMrRzhuRFV0cEQyN0ZMOElRQWN1NG1iZHhjL1FHMFRK?=
 =?utf-8?B?bEdvalhsQ3FkdDQ5dHZyL2N3dHpaek5FQU5jNllkajUxL3RlMUhpbjEvQW9M?=
 =?utf-8?B?NEJsY2N3ZEVmL3p4V2R3cVY4ekYxZTVlUFhFZlh4SHNya0c0KzNFdUpmTjN5?=
 =?utf-8?B?TC9xYndDUFpSVExkNVNhaDc4RVQyTW0zSVlVb1VROVVQei9CZWdnWXNicWFS?=
 =?utf-8?B?UlE5aTlvMVBVRkNieTc5WG0vdnlESGQ1bEM5Qkh3dnBadHZrU0o0empVVWw5?=
 =?utf-8?B?M2hMZWd2MGYrbjhJc0J5aHkyaUIwR3VtRGhObFhoT2hwWjF5VGFlU1lZNWxQ?=
 =?utf-8?B?WlVjc29renRtZUpveEhTLzl4QllFTHBJeGxQM1dGMkI4MHFoMXFjT0dqVnJJ?=
 =?utf-8?B?dGg3VVI2eFdYSjJlaGpHdGgwVFpnSGkyem8wOVlIZmxRNXFqZFQ3amVsbU85?=
 =?utf-8?B?M2srTjBYVXZJaUdlclJ6MXV6bmhtc2c0aW5qQXFzM2tGaEptSXNBMStjNkNP?=
 =?utf-8?B?aVVMcXF4T2g3ZnNvREhxR2h5VHNIVm9YN1VoTGk3MFNXT1J5SnN2bDVrbGNU?=
 =?utf-8?B?S1BzWG5hbHlUbEFCSlBKUGN3Zk9YVENGMmdFTGdHOGE4dUprb0swZXNsM1hH?=
 =?utf-8?B?VDZPVldtY3JyZTZmU3dqSEJpNXltd29WN1FBbmlpKzVHUkRTN28vU3ppTmQw?=
 =?utf-8?B?WFJwU1FrV3R6UVhTbS90Q0ttRTUvKzlOSGhtSExHNXlUY2tKT29LMmRUWDRi?=
 =?utf-8?B?UnBLdGc4UTQyMUd6T2JZbEd3alR1UktOSVdvOFlIOEZUV0Y1VjVCOHBQY0I4?=
 =?utf-8?Q?cPr8gue0YOpish9BnpvEPAtxT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41758d46-e9a6-44de-9de9-08ddf2035678
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 13:50:30.7565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5kuedYwRjmGRQMUQdH0Le52tXGw1S54sZly3iKnzNYYmmBPKDfj6VH3iGVqOvzFGx2DPjbZQqGxjeFRYlFxTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7643

On 9/11/25 06:54, Naveen N Rao (AMD) wrote:
> Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
> SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
> objects. Though the boolean property is available for plain SEV guests,
> check_sev_features() will reject setting this for plain SEV guests.
> 
> Add helpers for setting and querying the VMSA SEV features so that they
> can be re-used for subsequent VMSA SEV features, and convert the
> existing SVM_SEV_FEAT_SNP_ACTIVE definition to use the BIT() macro for
> consistency with the new feature flag.
> 
> Sample command-line:
>   -machine q35,confidential-guest-support=sev0 \
>   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,debug-swap=on
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

Should you convert the setting/checking of SVM_SEV_FEAT_SNP_ACTIVE in the
first patch (and wherever else it might be used), too?

If you do, then it would split this into two patches, one that adds the
helpers and converts existing accesses to sev_features and then the new
debug_swap parameter.

Thanks,
Tom

> ---
>  target/i386/sev.h |  3 ++-
>  target/i386/sev.c | 29 +++++++++++++++++++++++++++++
>  qapi/qom.json     |  6 +++++-
>  3 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 9db1a802f6bb..8e09b2ce1976 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -44,7 +44,8 @@ bool sev_snp_enabled(void);
>  #define SEV_SNP_POLICY_SMT      0x10000
>  #define SEV_SNP_POLICY_DBG      0x80000
>  
> -#define SVM_SEV_FEAT_SNP_ACTIVE 1
> +#define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
> +#define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
>  
>  typedef struct SevKernelLoaderContext {
>      char *setup_data;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index fa23b5c38e9b..b3e4d0f2c1d5 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -319,6 +319,20 @@ sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
>      sev_common->state = new_state;
>  }
>  
> +static bool is_sev_feature_set(SevCommonState *sev_common, uint64_t feature)
> +{
> +    return !!(sev_common->sev_features & feature);
> +}
> +
> +static void sev_set_feature(SevCommonState *sev_common, uint64_t feature, bool value)
> +{
> +    if (value) {
> +        sev_common->sev_features |= feature;
> +    } else {
> +        sev_common->sev_features &= ~feature;
> +    }
> +}
> +
>  static void
>  sev_ram_block_added(RAMBlockNotifier *n, void *host, size_t size,
>                      size_t max_size)
> @@ -2732,6 +2746,16 @@ static int cgs_set_guest_policy(ConfidentialGuestPolicyType policy_type,
>      return 0;
>  }
>  
> +static bool sev_common_get_debug_swap(Object *obj, Error **errp)
> +{
> +    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP);
> +}
> +
> +static void sev_common_set_debug_swap(Object *obj, bool value, Error **errp)
> +{
> +    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP, value);
> +}
> +
>  static void
>  sev_common_class_init(ObjectClass *oc, const void *data)
>  {
> @@ -2749,6 +2773,11 @@ sev_common_class_init(ObjectClass *oc, const void *data)
>                                     sev_common_set_kernel_hashes);
>      object_class_property_set_description(oc, "kernel-hashes",
>              "add kernel hashes to guest firmware for measured Linux boot");
> +    object_class_property_add_bool(oc, "debug-swap",
> +                                   sev_common_get_debug_swap,
> +                                   sev_common_set_debug_swap);
> +    object_class_property_set_description(oc, "debug-swap",
> +            "enable virtualization of debug registers");
>  }
>  
>  static void
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 830cb2ffe781..71cd8ad588b5 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1010,13 +1010,17 @@
>  #     designated guest firmware page for measured boot with -kernel
>  #     (default: false) (since 6.2)
>  #
> +# @debug-swap: enable virtualization of debug registers (default: false)
> +#              (since 10.2)
> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevCommonProperties',
>    'data': { '*sev-device': 'str',
>              '*cbitpos': 'uint32',
>              'reduced-phys-bits': 'uint32',
> -            '*kernel-hashes': 'bool' } }
> +            '*kernel-hashes': 'bool',
> +            '*debug-swap': 'bool' } }
>  
>  ##
>  # @SevGuestProperties:


