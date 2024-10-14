Return-Path: <kvm+bounces-28722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B47B599C6FB
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 12:16:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B368FB22B9A
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 10:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2F7B158D6A;
	Mon, 14 Oct 2024 10:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WU1t3x14"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1028633998
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 10:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728900986; cv=fail; b=vA3/2zHoSWbe+TobxGusAcOAwYgG67Vj7Fe06t6Y79GJ/9bOO4Gxio0sC+QwgVbmxneGL7X8+rkPNjXEdg6hRTIx0PBJyPm+/jLxVtK32hq1/C9B0zL13l+N3BpkBF1oxlB/kaLjbEq5f2FCXzyz4mKwo3tjzNAxerSSBfu4QGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728900986; c=relaxed/simple;
	bh=CcvQN6hyxExs85GOey4za0NVG7dv2xh/fvWm9DA0Qn0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dyMillhkDArQDcBx+IJL7tMTzj/yTnHw6OAVh0lBHRnf3tUYtv/tX5tNAj1kZ2Iu444P9/Jqecba8x0Z5Tq9c2wcOlrGq6+Oaq0/V3OeGgFSnwzbB8LcfeAQL+2Bm/hxAOr10eGhUa+AZLa67IZQNAWOtpSDgvwgBMJK9cRkVdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WU1t3x14; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sh75EjplMJPArorWcGtg/HZ8HwMG2WWWoVQt7uoMpRH0u5WugJsWcgfnZ+G5plm0SQIpMlO15YEfiKXGlnBvRWuCzfS0DrgGE5jIPCbGUk/EKrWnTVCrNACRD8Tl2pK5WmM8cPC1Xnnq7i9IL6zPzIZ2EzDclKvof5uZG0fGyio931MkH3CysxUxIhRSf2ICAf04HfqMUAi8RX4x3JKJY4EEOqNCE2cMztLDN8b+94wzEN57xFk7rPg/YAFIhOSh8iS+RoFzXBj3xSmTilE+f8qZ52xxtCXuiRliKWrFFpxa9KoRJB8N8kVWi2JOnKyRG2dxZmJllS1QOT69R4TLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcvQN6hyxExs85GOey4za0NVG7dv2xh/fvWm9DA0Qn0=;
 b=daspWsIA6Vs7pcMgMMVR5+IhfVMMQboqT7yFaIK1OXiakajSiX6WQxwfCPsLe5EGywcYEPlzQxXk2ZuYAS/sFOjDhyz6NncxH2+eectx3pshbQn42EkvAuKsnNoLxzeuLTF/WhyK5CYuLYrlwjBvW6mmrKN5mObULMAzwDkFYVFQNG7/YRumHba4hF4nQnKQU0TBxcxs8w8TTD/sZfnBk4S/Qk8FtbZZtmN3RBDnXC1xPeGRFtrpOQAs5rS93r6zCnGdxm/M3I1xujcCoFg/goISm87kcyjYwk5JJdIu2psAT8ps+3oE/+DFl3qzFSue9XLG8cWUU9Ng9P4VQ5Yxjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcvQN6hyxExs85GOey4za0NVG7dv2xh/fvWm9DA0Qn0=;
 b=WU1t3x141HVRL2yNKJZLrA4v14/Sahf8aPqhHbX5GYwMtk58wQ84QyOYSBhb5M69itewfdy7jMHnqXW3InVju2qcQKzCg4uaiZzCtJYHu+88ZOIiCjDKjzH53qWMe/VvQWeLi+V3o54N319Z1sbGviYjsXlc4RBm+gJzsFh1QJdtFYidHML4f8E1oH0QLiAk+sWKNojXZpZIX8JTCc6nimlVmWh+TgIQXNDTv0HOV+YWMATfUF7e0/K8JjR6XU7swib0fwLz01lmGQ3BnCGE7FstB9bkkhyOR6SQVnPuJbImcGKe2eoaYd/PZSW6p8LQwizMSx7V/O8Eum6C+DciVw==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 10:16:21 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 10:16:21 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, Jason Gunthorpe
	<jgg@nvidia.com>, "airlied@gmail.com" <airlied@gmail.com>, "daniel@ffwll.ch"
	<daniel@ffwll.ch>, Andy Currid <ACurrid@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, Ankit Agrawal
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>, Ben Skeggs <bskeggs@nvidia.com>
Subject: Re: [RFC 02/29] nvkm/vgpu: attach to nvkm as a nvkm client
Thread-Topic: [RFC 02/29] nvkm/vgpu: attach to nvkm as a nvkm client
Thread-Index: AQHbDO4GpQSqgXz+o0mAzuqOllnurbJp0SGAgBxZPYA=
Date: Mon, 14 Oct 2024 10:16:21 +0000
Message-ID: <200b246e-6add-41bc-b8b6-440b3c9b62f0@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-3-zhiw@nvidia.com>
 <2024092650-grant-pastime-713e@gregkh>
In-Reply-To: <2024092650-grant-pastime-713e@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|LV2PR12MB5990:EE_
x-ms-office365-filtering-correlation-id: 5e4b0a75-6530-4aff-59a0-08dcec394053
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RWJXTlczUENmQ0RaOUdGZ2tSRVBRR2daN0xsN1hlSHdEVVhrNEFkR1hYbkor?=
 =?utf-8?B?dXlSS2NmdGtNTDFrcFpBcWxSdWkydzlRU0pkU1RpZmEzUUxMd2pYM20wWkts?=
 =?utf-8?B?OTJEazVySTNMVHpiR01lRUowNUp0Tlc3RDEvUU85M0VWaVhWR0t6cU9SSitF?=
 =?utf-8?B?Um5kK0pzcyttYXh6eXlOSXM4b0RkRGJ2eTJtUjZ0OUEvSkZqTzVqRS9ob3FB?=
 =?utf-8?B?U0VqTC9ZeERUdUJGaXZLanoyMDZhc012aG5FT1hmdXgxSG9rb2xYaGk1Rnp0?=
 =?utf-8?B?VGE4NFNZQXlpTDFsSER6Sk81NENzTXd4TUZ2blZCTnlBUTRPRXh0RTc1OEp4?=
 =?utf-8?B?VXR5QmFnMkh1Y25kWDQvdnVRalhTUDJpVUNJNGxFYUZaNkpPTy85eU9PVVZ0?=
 =?utf-8?B?SFJZelVBTmVYenFBNXYvSHZjenBwRTFMeis2d3JldGpuZ0I5OUNPam45MWVZ?=
 =?utf-8?B?dEgzMlVxN2NKYTliclRUYnQvMWpnTW41L0llOVRUUWYvc0FRcVdldTlNc3ho?=
 =?utf-8?B?Y1NTK1RxbExRNDhsOUd5b0hZbmJKQkh2WWphaWRVR1hDTDlxalI3RDMrS1hq?=
 =?utf-8?B?YjRydFFpQW16VGZyNU5rQldZZWc3WFlhZWtHeEJMSlo5cGJLdkFKeXhySmpw?=
 =?utf-8?B?MVRvcXA2cFRHdHYwR1V2dUM3cVpOWUxENGY1N3p4c3ZFZVNvSHVWR1BidmNU?=
 =?utf-8?B?WmhEaTlXVXo0ajRmOTVIZVplQXMzNk1XU3U4bVVIbXpjQkFBcWtrUkVRRW8w?=
 =?utf-8?B?bzZRWWRkVHRWbmRPeDF1ZlVnNUREU0Y1SkpaQ0pGc3YzbE1kZ1l2QVovTFlv?=
 =?utf-8?B?aGdMRkd4MHRVSEhndlN5Sk9UTUdJcXZrakROOTd3MEZHTzcrVzcrZXlTNXRh?=
 =?utf-8?B?WTg1TlVEcUI3Q3c3ZE1RYWN6ZlRGK05EYW13Y0d3T3ZTeXZmamtNV2dGVEkv?=
 =?utf-8?B?WDJGUUdlZXVkc2Z5aCtRVitWM3BETmI4OEY1aTdHTVNvTTB2K0NpcFZ3eFlK?=
 =?utf-8?B?UjVDdjhoUUxCTk9rUmhpSXBVUGtCOUxoYzkrUzVNeUt0bWhnd0p5Slh2eDZy?=
 =?utf-8?B?RHdvbHd0eldRWVk4Z3B1M2pZMURuWndndUhSRExXcjR1aUpac0pweFl2Q3F3?=
 =?utf-8?B?cG5nekJjOGpqMzVOQXp1WFc4Q0hlL3p5SVlmM3VEdGxCMEFjb1Z3d2l2TmV5?=
 =?utf-8?B?ZWtDaEJvVnFWM05CanVUSUZVRmNnTmx3aU0waGp6bi9FZWRwV255dE03TEFr?=
 =?utf-8?B?cGs2ZnhxMTVWb2c1QnpqWnQxMlJlanVRRTNuTEFZblJoTW1XZTN3RlQ2MmQ1?=
 =?utf-8?B?Skk1Y3lXalBLUytHaGhUS0N1cXJXaFY5RWtnS3kxN1g3TVh4Zlg2OTB5Qjhq?=
 =?utf-8?B?Ry9ZaFRmVmtBQW43eklDa3BKc3ZBOC8wcEY0K1NjVEQzRUJtZTk5NXlWUnZQ?=
 =?utf-8?B?NWdtdzRDZW9NTGg0MkJHc0RyNkdjRjgrd0Q3MmEvUld3M2gyeklYRHBpOTRn?=
 =?utf-8?B?QS96R3VQbUMwNDE4cHcvRXNUOXVZWEtPaWIrajE1aVRTRVVMSmVnQnN0Nncx?=
 =?utf-8?B?RzN2Ykd6cm5UVHhPNEwzellRSjNaSHZxRWNYTWw4NGFjV0hYRmtsb3dYZU9j?=
 =?utf-8?B?dC8xNDNHRzk0RkxDQ29uY2lPQ3ZFYS9RRnMyM1dObnV2Ky81T2ptbmF4ZHdW?=
 =?utf-8?B?VXBrVWUxMGEwUGRCR1JzL3NJTjI3WkRtelNRcGdIejBZQ1QxZEg4d1NjLytN?=
 =?utf-8?B?RmRGN0o0UVVkYTgxdFZSYXlEaWFKU01mQzh6VmtJS1JUS0dlMStFNk9sV21G?=
 =?utf-8?B?WUFkN0Z0Q1paeDlQQ0x4UT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R3ZpbXZJNXYrc1VEbzd3WVdhTGttV3J4ek11QzgzS3MvT1V4ckQ5NzZRV3NK?=
 =?utf-8?B?ZEt0WjBrSkErWmVPS0FZUnIrNm42Y2d6a2hyeG0zNkNjbGZQNUtrTzBrNGsv?=
 =?utf-8?B?MlZHamFLRkQ3WGJIZ1g5N240S1BwNktDbjlwS2g5WjlLVU9LcE0rQURoTXlv?=
 =?utf-8?B?TlJVMzNCTE5hSDI5Z0hiQnRNY2lyd202dEVrSmNRNFBaNjhBWElmMjJFcjY1?=
 =?utf-8?B?UGVidElMNkw2Qk9ZQlNaalN4RFlGSmw2UVhFTThYS2tOS2diNVVPVEFuQ2dS?=
 =?utf-8?B?SzZ3MkVNckxncWZjd1djWmJ2THZBWDhuVzkySFE5d004R3gyak00SWt5WVQ2?=
 =?utf-8?B?dnpzNENiYjhmZ0tlWmNKcENBdFlpUDNXc0syc052bjRGVm9lQkFyV0EvU1lr?=
 =?utf-8?B?NTlFSWlkdlAvRkE2VDB4bFhVWUZjb010ZTA5cXNEV2Fkdkl4Y2NOUDlLcjQ4?=
 =?utf-8?B?SUxQVDlIamorOGZ6UVZkN2tXRlpaS2REZ0RDNlJYN1czdWhtZTJRdFBmeXky?=
 =?utf-8?B?OXQzTkdGQnZHWUJEMzJTcit5R2VBQ2ZDM0U3MFliVUt1MmlnTFZGbGRsZkVn?=
 =?utf-8?B?ZWJRYkJ6TTJ0UGt5b2JYYzlGQzQ0L0h6ZFJRWkgxeXd1YTRZZDVyNmptVFE1?=
 =?utf-8?B?TGpzeXFUeWdJZGRuSitsbnFSL2hmMHZjWjFDb2JpSEd2RzI5UEh0cEEzOTN4?=
 =?utf-8?B?TXJoZ0NDbmV2QkF5Z3QxSEYzWWVDTVlpODQ1eGVseVQ2UmJlOW5XQ0lnYkZu?=
 =?utf-8?B?b1B3WDdqTFB0SFZ5TkJjQ3VqRzJmWmExUTZCQ3YwbnRSbnBiZnJGZkNtbWNS?=
 =?utf-8?B?ZUJ6enRyZnVMaEhOVm9jalpwQXNmTFQ5cnlLN0lUR3BEYXE3aWFVRUo3amxs?=
 =?utf-8?B?bkhnVm9rZ1BralZKR1R5UFVQQ3c1Ykt4ZHBMRzVBTmFIci93VnVOWmcwSGdu?=
 =?utf-8?B?blkvcnlzaHNwcTNRL0xNSjRJSlpjZXhKTjlqVlRUNzdQcTZMNnFZMU9udlhS?=
 =?utf-8?B?N0NJVks2WFhUQjFvWGZ3ODVKdEViRmxSL29FTmx2Q2l5RGRtQm5TUmltZzVQ?=
 =?utf-8?B?dCtMaE4zMXRLU29lcFpjd1BYSHc0NldzMHo5ZzlvYnlmbitOcnJ0NkZvM0hP?=
 =?utf-8?B?b010eGZRUHZqMWxBWU1RbUxNUGxYNkVZN3RiZi9XT0RlVE9hTXlIOFJ4UGRu?=
 =?utf-8?B?M3NodjZZb1hpL1p6YzZlMXQ4c1czWnVZQUxQZUNmNGtHclo4bTY3MU9mRDBN?=
 =?utf-8?B?MEFzekZRYnFqbnJ2TzZkWUtvNnphZ2VRMEIyRGREQ3QrRG9GQjc2cWJxcXZv?=
 =?utf-8?B?RG1Ib1ZQUWY0Unh3Y2YzSGdBem9qTWRvYkJxRVk3VStXb1VTZFdtY0dQcWxY?=
 =?utf-8?B?bzB5czU3ZjI0eDVSNkZlM3ZETkd6dGRDK0dRNVZWOCsrUS9BTlhZY3FtM25t?=
 =?utf-8?B?OG03UzRnN2FwSFp2akhsSWJmZTdnaXV3dWxoTW9ndTNxcUltczBzWGtoS0ZE?=
 =?utf-8?B?bko5LzAwaFl0MHBNT0xCUFlENFpiSGp6OURDV0hoSXFXcWIrdlV1RUxaei8y?=
 =?utf-8?B?bFFqNU1HZThEL0tibURHeFgzM2FsZGVuYVpLNmdjamRyREY0WU9oY1Vzc1gr?=
 =?utf-8?B?NWw4ZzRGLzB5eUQxVHR6S3RWQmlUSHJJN0FPRHI4SlMzc0R3ak94Z212Ry9t?=
 =?utf-8?B?NnVpdWdyWXgyZktPM3Z4ZWZzWFpUZGFvSnpBWVZuRWFRaTJYZFBNRHF6S0pQ?=
 =?utf-8?B?VFlJR0ZlbzFZak51SUY2VzZ4Q3ZsaExJQzlOL1ZmdUlaQUl6T2UwdlE1cW9H?=
 =?utf-8?B?MFdkSjBCVE04ektmYmZJUjNrQXlEV3pvSzdJRFkyaC9iOUxrd2VCSlBsdUx1?=
 =?utf-8?B?Y3AzNUZPZERYYm1hSDJDdTAwZlFzdHR3NSthdUIzY0pKLzhCc2FpUExHcWJh?=
 =?utf-8?B?eUVqcU1lMEhpRCtWYVhML09vd2xZK05XQkh2dysvNmpkeVZ3c1RIM3Z1dEFu?=
 =?utf-8?B?RlFETldWUHlLbGZ2L1EyZGc0UEdFMVA5SnkzUHo0TjNuczRiSHU0RGlsaG5S?=
 =?utf-8?B?SlNqcWRkM0UxTWRmY0hpQ2lLUTc3bWFSZS9aazRZV1hvR2Jka2hLNEp5b3M5?=
 =?utf-8?Q?Dp+U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBEC4A99809C5244BA2419FF85880A47@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4b0a75-6530-4aff-59a0-08dcec394053
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 10:16:21.6244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +oJglW33XEuXx921tc2FRRIFrVQmdQCjIoj0gNOSAdW6iuaPEgeHS33jy7TNT9MU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5990

T24gMjYvMDkvMjAyNCAxMi4yMSwgR3JlZyBLSCB3cm90ZToNCj4gRXh0ZXJuYWwgZW1haWw6IFVz
ZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiBPbiBTdW4s
IFNlcCAyMiwgMjAyNCBhdCAwNTo0OToyNEFNIC0wNzAwLCBaaGkgV2FuZyB3cm90ZToNCj4+IG52
a20gaXMgYSBIVyBhYnN0cmFjdGlvbiBsYXllcihIQUwpIHRoYXQgaW5pdGlhbGl6ZXMgdGhlIEhX
IGFuZA0KPj4gYWxsb3dzIGl0cyBjbGllbnRzIHRvIG1hbmlwdWxhdGUgdGhlIEdQVSBmdW5jdGlv
bnMgcmVnYXJkbGVzcyBvZiB0aGUNCj4+IGdlbmVyYXRpb25zIG9mIEdQVSBIVy4gT24gdGhlIHRv
cCBsYXllciwgaXQgcHJvdmlkZXMgZ2VuZXJpYyBBUElzIGZvciBhDQo+PiBjbGllbnQgdG8gY29u
bmVjdCB0byBOVktNLCBlbnVtZXJhdGUgdGhlIEdQVSBmdW5jdGlvbnMsIGFuZCBtYW5pcHVsYXRl
DQo+PiB0aGUgR1BVIEhXLg0KPj4NCj4+IFRvIHJlYWNoIG52a20sIHRoZSBjbGllbnQgbmVlZHMg
dG8gY29ubmVjdCB0byBOVktNIGxheWVyIGJ5IGxheWVyOiBkcml2ZXINCj4+IGxheWVyLCBjbGll
bnQgbGF5ZXIsIGFuZCBldmVudHVhbGx5LCB0aGUgZGV2aWNlIGxheWVyLCB3aGljaCBwcm92aWRl
cyBhbGwNCj4+IHRoZSBhY2Nlc3Mgcm91dGluZXMgdG8gR1BVIGZ1bmN0aW9ucy4gQWZ0ZXIgYSBj
bGllbnQgYXR0YWNoZXMgdG8gTlZLTSwNCj4+IGl0IGluaXRpYWxpemVzIHRoZSBIVyBhbmQgaXMg
YWJsZSB0byBzZXJ2ZSB0aGUgY2xpZW50cy4NCj4+DQo+PiBBdHRhY2ggdG8gbnZrbSBhcyBhIG52
a20gY2xpZW50Lg0KPj4NCj4+IENjOiBOZW8gSmlhIDxjamlhQG52aWRpYS5jb20+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBaaGkgV2FuZyA8emhpd0BudmlkaWEuY29tPg0KPj4gLS0tDQo+PiAgIC4uLi9u
b3V2ZWF1L2luY2x1ZGUvbnZrbS92Z3B1X21nci92Z3B1X21nci5oICB8ICA4ICsrKysNCj4+ICAg
Li4uL2dwdS9kcm0vbm91dmVhdS9udmttL3ZncHVfbWdyL3ZncHVfbWdyLmMgIHwgNDggKysrKysr
KysrKysrKysrKysrLQ0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDU1IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL25vdXZlYXUv
aW5jbHVkZS9udmttL3ZncHVfbWdyL3ZncHVfbWdyLmggYi9kcml2ZXJzL2dwdS9kcm0vbm91dmVh
dS9pbmNsdWRlL252a20vdmdwdV9tZ3IvdmdwdV9tZ3IuaA0KPj4gaW5kZXggMzE2M2ZmZjEwODVi
Li45ZTEwZTE4MzA2YjAgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vbm91dmVhdS9p
bmNsdWRlL252a20vdmdwdV9tZ3IvdmdwdV9tZ3IuaA0KPj4gKysrIGIvZHJpdmVycy9ncHUvZHJt
L25vdXZlYXUvaW5jbHVkZS9udmttL3ZncHVfbWdyL3ZncHVfbWdyLmgNCj4+IEBAIC03LDYgKzcs
MTQgQEANCj4+ICAgc3RydWN0IG52a21fdmdwdV9tZ3Igew0KPj4gICAgICAgIGJvb2wgZW5hYmxl
ZDsNCj4+ICAgICAgICBzdHJ1Y3QgbnZrbV9kZXZpY2UgKm52a21fZGV2Ow0KPj4gKw0KPj4gKyAg
ICAgY29uc3Qgc3RydWN0IG52aWZfZHJpdmVyICpkcml2ZXI7DQo+IA0KPiBNZXRhLWNvbW1lbnQs
IHdoeSBpcyB0aGlzIGF0dGVtcHRpbmcgdG8gYWN0IGxpa2UgYSAiZHJpdmVyIiBhbmQgeWV0IG5v
dA0KPiB0aWVpbmcgaW50byB0aGUgZHJpdmVyIG1vZGVsIGNvZGUgYXQgYWxsPyAgUGxlYXNlIGZp
eCB0aGF0IHVwLCBpdCdzIG5vdA0KPiBvayB0byBhZGQgbW9yZSBsYXllcnMgb24gdG9wIG9mIGEg
YnJva2VuIG9uZSBsaWtlIHRoaXMuICBXZSBoYXZlDQo+IGluZnJhc3RydWN0dXJlIGZvciB0aGlz
IHR5cGUgb2YgdGhpbmcsIHBsZWFzZSBkb24ndCByb3V0ZSBhcm91bmQgaXQuDQo+IA0KDQpUaGFu
a3MgZm9yIHRoZSBndWlkZWxpbmVzLiBXaWxsIHRyeSB0byB3b3JrIHdpdGggZm9sa3MgYW5kIGZp
Z3VyZSBvdXQgYSANCnNvbHV0aW9uLg0KDQpCZW4gaXMgZG9pbmcgcXVpdGUgc29tZSBjbGVhbi11
cHMgb2Ygbm91dmVhdSBkcml2ZXJbMV0sIHRoZXkgaGFkIGJlZW4gDQpyZXZpZXdlZCBhbmQgbWVy
Z2VkIGJ5IERhbmlsby4gQWxzbywgdGhlIHNwbGl0IGRyaXZlciBwYXRjaHNldCBoZSBpcyANCndv
cmtpbmcgb24gc2VlbXMgYSBtZWFuaW5nZnVsIHByZS1zdGVwIHRvIGZpeCB0aGlzLCBhcyBpdCBh
bHNvIGluY2x1ZGVzIA0KdGhlIHJlLWZhY3RvciBvZiB0aGUgaW50ZXJmYWNlIGJldHdlZW4gdGhl
IG52a20gYW5kIHRoZSBudmlmIHN0dWZmLg0KDQpbMV0gDQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9ub3V2ZWF1L0NBUE09OXR5Vz1ZdURRclJ3cllLX2F5dXZFbnArOWlyVHV6ZT1NUC16a293bTND
Rko5QUBtYWlsLmdtYWlsLmNvbS9ULw0KDQpbMl0gDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9k
cmktZGV2ZWwvMjAyNDA2MTMxNzAyMTEuODg3NzktMS1ic2tlZ2dzQG52aWRpYS5jb20vVC8NCg0K
PiB0aGFua3MsDQo+IA0KPiBncmVnIGstaA0KDQo=

