Return-Path: <kvm+bounces-31527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E10A9C463B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91E5C1F228F8
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A51D71AC884;
	Mon, 11 Nov 2024 19:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pnRSZXIN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCAB132103;
	Mon, 11 Nov 2024 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731355088; cv=fail; b=icv2ZJytgOBPMhvwSM8C7g1R2yvS7Bti3e+21zshahB6+aeaXrRSMlqOwazgNrvZ8DvJ2jAR1n6CLa7WfU59q69zIKaY/u8/WUYBMvPL17Ifjhp8LaaotCL2Khi7e07NZeTYDxy1KaVSjtsA4n/Y0yzQYoRWouA/NfBljHaOb/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731355088; c=relaxed/simple;
	bh=QAipBYCAVHXa+BO8c2K3yoCFsQ4+6Fa8p5sBdC5XK4U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FGXWJbKzuYddcC8RHYTLq+80WyeZaOl9aR6gs2ddBfQgpPFFmbXcFNxgNQgc0MgpyyfO5TCr7g7hz0B0X3x+iZY0zqBrMZXKe/e2e02PHDaIfGk0QRtbQoBa9VttTCsDsaRp1UCXDZDW8g/j3CqEm+6iBQaQKwRAPL6NZ9gELhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pnRSZXIN; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jBFmX/vOxbn2yaKVpZOxQiEGAVvvZNlzNXk0ez5/li2h5Kw7VdZq+pAUU+nUgtPPRZ3LtnHxPiAN1YbEQjEyF6x8bWdJJNAt+pPmCDRccfqNjIegDRvzd0/odH3BmGCVYosu55Hu3MeFfYFpCOWm8lmu66QnBv/ucLtrsENFGYdzVnKB321nSA/H+sbHnLd/SQYBkZnjkR9hY+/NTsx0afO6B9vHPLMBIloW5xPN7YIlbE8OstTDIUpo/5bvZc+jdocpxwls04oD5ITWeQyy8sdsqqGtsnNk84IeD12D8+60kRtNAOAqNuevCKqABfW8hPSJ5QrztpcKbYrK1lhfqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAipBYCAVHXa+BO8c2K3yoCFsQ4+6Fa8p5sBdC5XK4U=;
 b=ngRJNxV3UTNczgA3gvsquIur+6eSd17vqRJPC5PGgb7QTrDU6WA84aKl3qlS3iwia4DRL1mg1BtpO/V42uhp3ZwMEQQcIUiV9/5ryObMEaX+m18youxQHSFpnLUMfX1Jgkevotv/SzWRyJLdDJiIgxPgZ3YSO7Z/zuSgbsu05RV13V7Hb5/MvKBBj9O1A4u33dTAk9fdJWBb5zFbviu8qR/Lat0EA4JAwNRKKn+S8JoDCnrWXmxNsvxUHdKOxLUac2oTkoJ6mW2RvprIvhZM0fCgLDaJWB+YHZqi09dR4W+RlFkLkjNdC/gH+hR8HQoIpunjwrf8ad3dVQXuFVeKpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAipBYCAVHXa+BO8c2K3yoCFsQ4+6Fa8p5sBdC5XK4U=;
 b=pnRSZXIN8GKb/3ZXXL9x0ioqyBNH45/V1jhs+7M7W0AKfdPeM4Me4GCN7DF/nFTwS7/u5RmNUToD224p1kRQ1y0khmQ0MAtrxPamSmCUNqDEXVaCkz0jxVFC6Y2PO8CC6eYmMpHI7pogyeBWztfxW+sOzXvYlwqSYlX9o/TSiPI=
Received: from LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14)
 by DM4PR12MB5820.namprd12.prod.outlook.com (2603:10b6:8:64::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.28; Mon, 11 Nov 2024 19:58:03 +0000
Received: from LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427]) by LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427%6]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 19:58:03 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Amit Shah <amit@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"Shah, Amit" <Amit.Shah@amd.com>, "Lendacky, Thomas"
	<Thomas.Lendacky@amd.com>, "bp@alien8.de" <bp@alien8.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "Moger, Babu"
	<Babu.Moger@amd.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: RE: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Thread-Topic: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Thread-Index: AQHbNFhQEwe18XGdBky6ffKbqr/GHrKyeFwAgAAEphA=
Date: Mon, 11 Nov 2024 19:58:03 +0000
Message-ID:
 <LV3PR12MB9265A6B2030DAE155E7B560B94582@LV3PR12MB9265.namprd12.prod.outlook.com>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
In-Reply-To: <20241111193304.fjysuttl6lypb6ng@jpoimboe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=6481b90d-dae7-4e70-bbf6-bca7b5d84c6c;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2024-11-11T19:49:42Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9265:EE_|DM4PR12MB5820:EE_
x-ms-office365-filtering-correlation-id: c8e3a65e-52fb-4edc-c822-08dd028b2742
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MEF5cm8wanE5MzdOMVIwOU13ZWdCZDlha0NiMy84bUZZaHVNRHFZREk0ZTJM?=
 =?utf-8?B?U1ltZnBPZktPRlJyRzQ0dmVPbk1qTkkvUlFTVWd2aXpLenQ0RW9HcTlITC95?=
 =?utf-8?B?NWhTdzRvNWxrR3BqNUxWUHpTWDkvQlA4Mnl0Z1JiSnNMM0N4eVp6TW95RWgv?=
 =?utf-8?B?MThMU3JyVlova1BiR0xRZElsVHdiUGhHZldmNmRWWTdLZWI0QzRvODJIeUox?=
 =?utf-8?B?ZStQN1hMaklVdzdjMG5pNHlsdWcrMmNqcGkrekI5Z0VCNHp3UmQrMzJNRzVz?=
 =?utf-8?B?cGErazRSVitRL01xWnpxWFczSnNSMmJxK3VHakllUUduOUFwNkMwZmZ6SGI4?=
 =?utf-8?B?cFdKT0RScWo5TTFGNHIrbmRXRlpNN2VjMlFxbXlHVnBJRlpMS1lSSCs4bmtr?=
 =?utf-8?B?a3FkUmZ0eUROdzYrMm1IcjZRNzNCRnJKSFdLTDAxNGtUNjhGVlFzblI2Wnpj?=
 =?utf-8?B?NHBEK3BMT0FmNUdIN3VoVGxoSk95YnRKRWlzNDU2L2Uraytid3lMdEVlQkVY?=
 =?utf-8?B?NWJTRWk1ajZ6NTJTa25SN2drM01lWkFvVGxDdzdRZi9PKzg5UFkvQWU0MXlO?=
 =?utf-8?B?RndSR212NHJiUEFpVy95RUpHTmM2SHZYTFV4Vy9jS2t4UkVnNGRLekVsUnhu?=
 =?utf-8?B?enZ1aUtSN0tJZDcwRTRzdEtxWTFUbUgwWjN5ZmVaT3U1ZkpTK2xDWkFoKzdu?=
 =?utf-8?B?a2ZoSEJxclByWGEvejI5bU1aRE5qRGNYR21OZXdkemFJSVFzb0Nkczd4YzE2?=
 =?utf-8?B?MEVWWTYzWVNzUGpIK3VMSFVBYVB0N3F5dTk2TU0rL0lKUFFTMFlaYjZIVWdh?=
 =?utf-8?B?cmxXajQ1MDZrNGU0TG1GNnQwd05WZ0Y4ZC9MY0pWZ2hJVkdGRitJVXJVcVVn?=
 =?utf-8?B?OHVJd3p0dU8zaDUvODFvc2p5TEVJcllZVEcrZWhoMWNtVW1lc1MxSk9JWlVt?=
 =?utf-8?B?REE1Yldkem9SdUVGMG1FdmZ5RzNteVc4Wk9BZ00zQWlXSWgyYVRZYUVaYVZC?=
 =?utf-8?B?M0VqV2JOTGZwdHpSSVpTU0RnS3RsZmNBWCtCUm1tTXZvdzZWOWxUNmVIK2w5?=
 =?utf-8?B?N3VBWDZodTh3TEJDUkhXcjZGMkIyemw2NndnVXhKVDZpVFVSUUREVnh4UmR1?=
 =?utf-8?B?ZjljUFNPRlY1ZDM5VTVaOUlFWld4T0UwcndEU254eWRYd011Y1cxQ2pDdTBQ?=
 =?utf-8?B?UjdXSlhJSFRZRnppcEFZYisrOG1tT1ZZUi9KUVRlTkpMaDNCbTRrREJ4U3J4?=
 =?utf-8?B?Z1NHajZtTGgvMWlCYWtzRCtXNk81aEpEZnoyMzBOVE5aUFFLb09vVG12Z0lG?=
 =?utf-8?B?ZnJsamxPM3BBYldSRGJKb0hVTE9HaWR6T0RyZVljdnNPK3RqL0ROUmtDdFJy?=
 =?utf-8?B?elY2TmRIN0VEYjFmOTBMRWlQMVlvekNadWxIbzRPbzM5SERiSGNKQTVDK3Rw?=
 =?utf-8?B?TjZFNGJCYk1sRG5XS0EyTHkwelNYd2lxWmUzUHRvSi9VQzRTQVNCZDJyU3pu?=
 =?utf-8?B?RHgydEkxelRjWEdlTU56cnNoQmx4SWZmajJtT2pibWRHRkEyUUNnRzJ3RHRP?=
 =?utf-8?B?eDR1R3ZRejdwcThkeDNxTmlCS2U4b2w1bmlLK0w5Wi93U01Eamhucld4a2hp?=
 =?utf-8?B?MG5MWnFZa1pEOEJ5VnNIZDBFaExId2JmWlladzNCY1dQbGQ2SkZJM1lEclU1?=
 =?utf-8?B?NDFDT1BPaUpBUUlIT1ZoRk9QT2xSK0tKbHdQVXRRajRQZTFieWk3N25XcTZM?=
 =?utf-8?B?ODVxbktrbmdFT1R3MFE0b3NCU0lsYTJvWGxCeG9BSkY2dERHUzM4OTZPS01p?=
 =?utf-8?Q?2jm9baXbzI2z4q2dARaBa6ZiBkuaZTKifJI7I=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cjFadXNaQUk3SXRCNlBLNWZnMEFLcnB2UDZqd0k1Q01wOEhPVTdGQXNvSHND?=
 =?utf-8?B?NFhZdHVsRStuVDJrcjNHQnlvKzNXMm42YjR3emJpN01DdzdTVVZ6d1hleTNw?=
 =?utf-8?B?NVlrRWxQYm4ycXd5UWdKdXVSYU1qSlgxSmdsVHpIcnpVeFAzRlVPQ3hzRTQz?=
 =?utf-8?B?b3ZRMWhRRmJta0djVVVTZS9JUFVIUzd2VlJsQ3RNaXBSdlRKS3I1TmRGRjNj?=
 =?utf-8?B?RFZ1Y2VwYWNGNEZuSlRTcjRaVVlKdzFtRlh6ZVRueUxzUDJhbGhTT29NS2kv?=
 =?utf-8?B?Vi9oYkRjRlAzNjFURXhlTEFEOS9MNzlQaThBdUMvSlY4WE1tcHc0Sk9pNVNL?=
 =?utf-8?B?cW1LYjAwYjZueUxoUEJQZHpOblRVY3gxcE13cFF2Y0pVOHNMZFVkbE83SnhG?=
 =?utf-8?B?d0dzWHR4TDVHL0xhOUNZenBpU2dPMXg5Q2tRWm9maHpsdVJZQlNUZmcvSys3?=
 =?utf-8?B?NUVscWZXMHhNOWQ5WDJhbURSdjlJa2x4ei9ONktBRFZ1YXdBUUVrOWs3ZUU5?=
 =?utf-8?B?dkkrNEtCbVRSZDdKc1ZWcEVITFd0MlpacUJNTFV2WlAvT2JTdkpsMVVlOENP?=
 =?utf-8?B?RzFtUXM4TmIrdDJkTm9PS3BnK1RyQzBsdXphTVJDR0NHaEQwVDNXN05ScjNq?=
 =?utf-8?B?bW13d0NFRnVvcE5JWFBWckpQbSsybENvcEplZm9QNGg4UkNGbFdDZWJUZUJN?=
 =?utf-8?B?SmEvZjMxQVVBVFNSdzl2Mi9RYVgvMmlraU1BZnFkN3MwbkhITldWOUU1UjYx?=
 =?utf-8?B?bThUWVAwWDB3c2JYN1JJWGExWFRKYkpTbnpqaDB1Q21WTGk1SExVRlZFZFpu?=
 =?utf-8?B?VDR1dmlKcURWWjVnOUIwdU9qdVZFUDVZcStlL1hIRmlYVExnTm5PZFExVlg1?=
 =?utf-8?B?WDMyTXlZMXdUeVdjY2thV0hGQ2dsMUhobHloWTBiVUNyeGdGS215eWVYaGxn?=
 =?utf-8?B?d3A5NGVJd2tkVDJzeEpnOS81OEFmY2UvRExoNEFiOGlXRGE5ejNXUHM2NmhW?=
 =?utf-8?B?TnlicXN4TkUyU1pRQU4zM1JXbGl5cTM4c2dnYVJNOWxBdFlZdVcwQTFSSG90?=
 =?utf-8?B?bE14STVwTm1VNzh6SU5RMHFuWks2MmNBbVR0Y2N0YUlZRGNpbWNTUm04bE5W?=
 =?utf-8?B?dFlLRUFHV1NOY0gxRTlFK0Vqc3FtaDhGWVNySzNDTXFodWlSZ3VERUYzT2Z5?=
 =?utf-8?B?YWE4SXpRRkFqNnd1VmpwempmMTZlQkhLa2pRaEV5MVQ2TzJuY1Bxc1NMSzZG?=
 =?utf-8?B?eE52ZUpYc2s1MlFyYno1Y3lDV3hJVHArVGJjM2p3K3JUZm93NHAwZzhJL1Zq?=
 =?utf-8?B?MXNrZUdJdEp0TjVqd01VUFYxbG11RzVNZDBpMVp5cjNwYmtVeXN0bFcyczRU?=
 =?utf-8?B?WWQ1QWF6YWNkRHdPckFRdjBQQVp5QklGTUl5cVJvb2dsRjJ6QUFFRlhZTi80?=
 =?utf-8?B?MmlWdG1wWnhJWDd2MHZmeVdXdlRIaytPeWw5NDcvV3BFOFhmR25xMEszQ2Zy?=
 =?utf-8?B?dlZWM0JqdCtmVzRnUk15Z2NiQlFLSExrSU02dzVQSzlTc0w1VUhaS3ZTQVdB?=
 =?utf-8?B?dTZBNEUzbzdocXh5UlFnZGdVOVRSdWtGbXMzTnZOVlZhMEU3b3JjRGhDeWd4?=
 =?utf-8?B?U1ZJWm9UdStDdTdRb2FYOXg2U2wvYkY5OXZUQzJFRUhuY3BNZXJrY2FLZDE4?=
 =?utf-8?B?Vi9UbTBPV2JQZlpEY2s3YlFSM3J3QWtzL0YweEpRbU0vV0JIblJ4d1RGclB1?=
 =?utf-8?B?L3Y3V2dTTWZ3WUpzc0d2TzRoeDVLZVZqL2xUazVROGluUWFibG85bkJYc1hu?=
 =?utf-8?B?QVRmcWo5TGc4QWY3c2ZqMU9yZCtuc0NvM2NEYktqUjlJbTlEYWZ3VE5hOGVL?=
 =?utf-8?B?ZS9Yb0hHYTQ0Y3NPbGM2Mmx1cmJXSTlEZVlBT1NxVHdZNlZORDBkMUlVemp4?=
 =?utf-8?B?UkZHOGxIZ0JoOEc5SmlRSk9yRkFkZ201akNkaXdZb0lDcHFseXhvdEM0M1RN?=
 =?utf-8?B?Rm1SRW1wekxlNzZQZ3hpaUtXNFFNY3lIak9EMHc4dkcxclBxTFkzSjVmYTIz?=
 =?utf-8?B?UmNqMWptdVg1UGZjTzFMMkE4Z3JUeEhlRXVZc3krN0Ztb2ZzcjVVblFTUms1?=
 =?utf-8?Q?ZzDc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e3a65e-52fb-4edc-c822-08dd028b2742
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2024 19:58:03.8842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L5oSCXkjZuFZmBrCeO6XHA6arjejZ+Z9HDkvMoSQGytBGMMQKwPYyXzFD8+q4FYd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5820

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb3NoIFBvaW1ib2V1ZiA8
anBvaW1ib2VAa2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5LCBOb3ZlbWJlciAxMSwgMjAyNCAx
OjMzIFBNDQo+IFRvOiBBbWl0IFNoYWggPGFtaXRAa2VybmVsLm9yZz4NCj4gQ2M6IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHg4NkBrZXJuZWwub3Jn
OyBsaW51eC0NCj4gZG9jQHZnZXIua2VybmVsLm9yZzsgU2hhaCwgQW1pdCA8QW1pdC5TaGFoQGFt
ZC5jb20+OyBMZW5kYWNreSwgVGhvbWFzDQo+IDxUaG9tYXMuTGVuZGFja3lAYW1kLmNvbT47IGJw
QGFsaWVuOC5kZTsgdGdseEBsaW51dHJvbml4LmRlOw0KPiBwZXRlcnpAaW5mcmFkZWFkLm9yZzsg
cGF3YW4ua3VtYXIuZ3VwdGFAbGludXguaW50ZWwuY29tOyBjb3JiZXRAbHduLm5ldDsNCj4gbWlu
Z29AcmVkaGF0LmNvbTsgZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tOyBocGFAenl0b3IuY29t
Ow0KPiBzZWFuamNAZ29vZ2xlLmNvbTsgcGJvbnppbmlAcmVkaGF0LmNvbTsgZGFuaWVsLnNuZWRk
b25AbGludXguaW50ZWwuY29tOw0KPiBrYWkuaHVhbmdAaW50ZWwuY29tOyBEYXMxLCBTYW5kaXBh
biA8U2FuZGlwYW4uRGFzQGFtZC5jb20+Ow0KPiBib3Jpcy5vc3Ryb3Zza3lAb3JhY2xlLmNvbTsg
TW9nZXIsIEJhYnUgPEJhYnUuTW9nZXJAYW1kLmNvbT47IEthcGxhbiwNCj4gRGF2aWQgPERhdmlk
LkthcGxhbkBhbWQuY29tPjsgZHdtd0BhbWF6b24uY28udWs7DQo+IGFuZHJldy5jb29wZXIzQGNp
dHJpeC5jb20NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjIgMS8zXSB4ODY6IGNwdS9idWdz
OiB1cGRhdGUgU3BlY3RyZVJTQiBjb21tZW50cw0KPiBmb3IgQU1EDQo+DQo+IENhdXRpb246IFRo
aXMgbWVzc2FnZSBvcmlnaW5hdGVkIGZyb20gYW4gRXh0ZXJuYWwgU291cmNlLiBVc2UgcHJvcGVy
IGNhdXRpb24NCj4gd2hlbiBvcGVuaW5nIGF0dGFjaG1lbnRzLCBjbGlja2luZyBsaW5rcywgb3Ig
cmVzcG9uZGluZy4NCj4NCj4NCj4gT24gTW9uLCBOb3YgMTEsIDIwMjQgYXQgMDU6Mzk6MTFQTSAr
MDEwMCwgQW1pdCBTaGFoIHdyb3RlOg0KPiA+IEZyb206IEFtaXQgU2hhaCA8YW1pdC5zaGFoQGFt
ZC5jb20+DQo+ID4NCj4gPiBBTUQgQ1BVcyBkbyBub3QgZmFsbCBiYWNrIHRvIHRoZSBCVEIgd2hl
biB0aGUgUlNCIHVuZGVyZmxvd3MgZm9yIFJFVA0KPiA+IGFkZHJlc3Mgc3BlY3VsYXRpb24uICBB
TUQgQ1BVcyBoYXZlIG5vdCBuZWVkZWQgdG8gc3R1ZmYgdGhlIFJTQiBmb3INCj4gPiB1bmRlcmZs
b3cgY29uZGl0aW9ucy4NCj4gPg0KPiA+IFRoZSBSU0IgcG9pc29uaW5nIGNhc2UgaXMgYWRkcmVz
c2VkIGJ5IFJTQiBmaWxsaW5nIC0gY2xlYW4gdXAgdGhlDQo+ID4gRklYTUUgY29tbWVudCBhYm91
dCBpdC4NCj4NCj4gSSdtIHRoaW5raW5nIHRoZSBjb21tZW50cyBuZWVkIG1vcmUgY2xhcmlmaWNh
dGlvbiBpbiBsaWdodCBvZiBCVEMgYW5kIFNSU08uDQo+DQo+IFRoaXM6DQo+DQo+ID4gLSAgICAg
ICogICAgQU1EIGhhcyBpdCBldmVuIHdvcnNlOiAqYWxsKiByZXR1cm5zIGFyZSBzcGVjdWxhdGVk
IGZyb20gdGhlIEJUQiwNCj4gPiAtICAgICAgKiAgICByZWdhcmRsZXNzIG9mIHRoZSBzdGF0ZSBv
ZiB0aGUgUlNCLg0KPg0KPiBpcyBzdGlsbCB0cnVlIChtb3N0bHk6ICJhbGwiIHNob3VsZCBiZSAi
c29tZSIpLCB0aG91Z2ggaXQgZG9lc24ndCBiZWxvbmcgaW4gdGhlICJSU0INCj4gdW5kZXJmbG93
IiBzZWN0aW9uLg0KPg0KPiBBbHNvIHRoZSBSU0Igc3R1ZmZpbmcgbm90IG9ubHkgbWl0aWdhdGVz
IFJFVCwgaXQgbWl0aWdhdGVzIGFueSBvdGhlciBpbnN0cnVjdGlvbg0KPiB3aGljaCBoYXBwZW4g
dG8gYmUgcHJlZGljdGVkIGFzIGEgUkVULiAgV2hpY2ggaXMgcHJlc3VtYWJseSB3aHkgaXQncyBz
dGlsbCBuZWVkZWQNCj4gZXZlbiB3aGVuIFNSU08gaXMgZW5hYmxlZC4NCj4NCg0KV2hpbGUgdGhh
dCdzIHBhcnRseSB0cnVlLCBJJ20gbm90IHN1cmUgSSdtIHVuZGVyc3RhbmRpbmcgd2hpY2ggc2Nl
bmFyaW8geW91J3JlIGNvbmNlcm5lZCB3aXRoLiAgQXMgbm90ZWQgaW4gdGhlIEFNRCBCVEMgd2hp
dGVwYXBlciwgdGhlcmUgYXJlIHZhcmlvdXMgdHlwZXMgb2YgcG90ZW50aWFsIG1pcy1zcGVjdWxh
dGlvbiBkZXBlbmRpbmcgb24gd2hhdCB0aGUgYWN0dWFsIGJyYW5jaCBpcy4gVGhlICdsYXRlIHJl
ZGlyZWN0JyBvbmVzIGFyZSB0aGUgbW9zdCBjb25jZXJuaW5nIHNpbmNlIHRob3NlIGhhdmUgZW5v
dWdoIG9mIGEgc3BlY3VsYXRpb24gd2luZG93IHRvIGJlIGFibGUgdG8gZG8gYSBsb2FkLW9wLWxv
YWQgZ2FkZ2V0LiAgVGhlIG9ubHkgJ2xhdGUgcmVkaXJlY3QnIGNhc2UgaW52b2x2aW5nIGFuIGlu
c3RydWN0aW9uIGJlaW5nIGluY29ycmVjdGx5IHByZWRpY3RlZCBhcyBhIFJFVCBpcyB3aGVuIHRo
ZSBhY3R1YWwgaW5zdHJ1Y3Rpb24gaXMgYW4gaW5kaXJlY3QgSk1QL0NBTEwuICBCdXQgdGhvc2Ug
aW5zdHJ1Y3Rpb25zIGFyZSBlaXRoZXIgcmVtb3ZlZCBlbnRpcmVseSAoZHVlIHRvIHJldHBvbGlu
ZSkgb3IgYmVpbmcgcHJvdGVjdGVkIHdpdGggSUJSUy4gIFRoZSBjYXNlcyBvZiBvdGhlciBpbnN0
cnVjdGlvbnMgKGxpa2UgSmNjKSBiZWluZyBwcmVkaWN0ZWQgYXMgYSBSRVQgYXJlIHN1YmplY3Qg
dG8gdGhlICdlYXJseSByZWRpcmVjdCcgYmVoYXZpb3Igd2hpY2ggaXMgbXVjaCBtb3JlIGxpbWl0
ZWQgKGFuZCBub3RlIHRoYXQgdGhlc2UgY2FuIGFsc28gYmUgcHJlZGljdGVkIGFzIGluZGlyZWN0
IGJyYW5jaGVzIGZvciB3aGljaCB0aGVyZSBpcyBubyBzcGVjaWFsIHByb3RlY3Rpb24pLiAgU28g
SSdtIG5vdCBzdXJlIHdoeSBCVEMgc3BlY2lmaWNhbGx5IHdvdWxkIG5lY2Vzc2l0YXRlIG5lZWRp
bmcgdG8gc3R1ZmYgdGhlIFJTQiBoZXJlLg0KDQpBbHNvLCBCVEMgb25seSBhZmZlY3RzIHNvbWUg
QU1EIHBhcnRzIChub3QgRmFtaWx5IDE5aCBhbmQgbGF0ZXIgZm9yIGluc3RhbmNlKS4NCg0KLS1E
YXZpZCBLYXBsYW4NCg==

