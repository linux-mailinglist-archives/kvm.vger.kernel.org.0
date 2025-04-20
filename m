Return-Path: <kvm+bounces-43701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F1BA94812
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 16:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 193C418905DB
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 14:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7638202C2A;
	Sun, 20 Apr 2025 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="002KHmcZ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="G1WFlh5d"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849C51EF01;
	Sun, 20 Apr 2025 14:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745159952; cv=fail; b=ALLkpJiEiag+M1km4bUh69AOuI5cqDF7sCzoEcXkkA3dZMupQ9rxWxvxKLFwxCBA2bea86I63R0mycci0Id+0k03Vh4ZfwW1wUa7rWoPUCdYijtVQYDIaSexFradcxJ22pjonNcwujb6JS8U10d7rbijI9rYGe4Nv0Gyehni6tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745159952; c=relaxed/simple;
	bh=SZXgj10HPf5CprdliybQ3pqNA4bDbO0OpzMI5kJGAr0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UXG6D+UHdXASMyLWXoiyDnDI8SUHALGcj7loCie9QkDuYYquHynujIQTc0I4GK0T0i4CLCFoSMCEHcfA3/tgMfYjoOe+Y3w1yUSE2FkdW/y//SHU3Tm4P+hNt6HRLju/Uv1bl+0RwNlTQQ3wEuOzOLV05WyU1Cy0jqGoKXg5Xn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=002KHmcZ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=G1WFlh5d; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53KDu8kh029858;
	Sun, 20 Apr 2025 07:39:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=SZXgj10HPf5CprdliybQ3pqNA4bDbO0OpzMI5kJGA
	r0=; b=002KHmcZZkqZlSVVkrC5mAz1d288LwoH2RYTB/oaUzNMu3NEE5JKt+IXD
	3WoheYoDCma0SHNTVpO/LF2+Uc0sc6lEuCGVqNlfE4JkeRAXmm7qAuTYqGebf9pA
	rwJznWYklsrx85fYrIry+j5j5UESMVPNBrtW5060E5WNRA4ecOvDGjLiEC3Nwiqg
	6EyZ81h/RzZ5vNa+OHwD1o7btXeoFSNpHpXHWoXEOOZNAN2G5YF4A3d3U6b3syxD
	6MfG5C+XYopKXwZMJOD/Vbur411g9aKGk4BF5VyI61JMNStGglHrHXUmjMvUX7ph
	Y7Qki74kzOKWN+VbzDLZOrq2vwrHw==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010005.outbound.protection.outlook.com [40.93.1.5])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 464bcys9a6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 20 Apr 2025 07:38:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MOReW7eS3nB7Qt/gA7ccFCNe2n5J5wSNb3QoJAxUt6BKBRx5wohu6liGCzAKErKz8UqLpA2myJvm35i/DZ1zLIcuJ9XqIJ2ZDccqJNZW/sV49MPVGeS+wzGTNsCEsVMe4bfKs/RnP4KYeiSdkPKlQX1xOB2hgqnwtzFkfvrKd84rLCEOd0mR+kRxuk10VEjNuomjGbBbfoYZVZu2z36uddTsb6fXye0W8jWxnUwQQAsdkJwkzYPmjhdDpwk42E8yCELZDFpGmRrX1OK43hux+4MVzef6sNPfZKXPatZlNLpYKqDUWAp1fzzu+sTCq4xSrbut+T5lorD5vrZd66vjlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZXgj10HPf5CprdliybQ3pqNA4bDbO0OpzMI5kJGAr0=;
 b=XlBrk6bPbSF5QEsSj66k+g76JDKOlpN8lpTs6Kle0ytL5BfX9r4TlM9aqc/hXaytZXa13iMBFBppGi1WhsPMZw2tDZwD0P8lQ5fAZ4cJhEOO6Sns9D4bMtFrNLTjEf7nKwXysfdvQHfIYPvgnSWSVrpDbcJQOp7v1CZkSa63kJFWWRPPmKk7avHKrcH0dq7syhBLOpEdQdTNcgh48Y1I5cIXD1P+wgB+eqI0w7ARZq3InxrTK4SryVde+GvLmcVsWalBsLxgDGo4jc8uA+KkxivcDdi3seLCQWtsxCqsgfR9KhUj+yBwkBMHQ9BFT7V6Ofd+UT3JW+KwCE1e1CGkEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZXgj10HPf5CprdliybQ3pqNA4bDbO0OpzMI5kJGAr0=;
 b=G1WFlh5dUUnVJhlpoSevRf10hGM5tpA76Gvv27HLsqk72o1cdtISCvU8uKiTVn64YG+iBpja9sf8jG9VEsNuH9SEATFznAVCe2OUXQ9WIYSaMjGPusT5qqpecP+QvU/l/vOcvmkEJECHHBEhY+i6VP45pdM8oznx9Up7T8SwnwVmTXoeeZaPzarNo501/u0es0nEHUV7yO3sOhvUrBYoBbLiMvdAmweR2iQ39FJZz2Bh0FgNP67ZUj6i1eXOcjlDVFV94F7mAiBchNtK7JenIEwTGOlpE8u0XH9Q7LXtpikhZ53OX6pi31Mst4YPz+0nkg4eRn8+dloy4Gjlrt/0mA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH7PR02MB9289.namprd02.prod.outlook.com
 (2603:10b6:510:270::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.30; Sun, 20 Apr
 2025 14:38:55 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8678.015; Sun, 20 Apr 2025
 14:38:55 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Topic: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Index: AQHbsYwmjuQam6Y/SEmtlBggg4gnP7OsKaCAgAB3HoA=
Date: Sun, 20 Apr 2025 14:38:55 +0000
Message-ID: <AFBE3B77-1E27-4CF1-95A4-9EF2D0A746A5@nutanix.com>
References: <20250420010518.2842335-1-jon@nutanix.com>
 <20250420033135-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250420033135-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|PH7PR02MB9289:EE_
x-ms-office365-filtering-correlation-id: a115cc82-293b-4855-b4e2-08dd80191416
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d2FwbHBLVUNKbmFmbDNyckFtLytpYy9VbzJrc08xY2VZZGtVSVN3UDdEdU9C?=
 =?utf-8?B?Y1VUK0JJS25sQWNwMVlQU1g5aFhNL0FBZllpcU9ENDVtM2JKV0J2eERlNlF4?=
 =?utf-8?B?cUkwS3lBYVJ3TzVWaEJRMmhJQm5rY1RpQlRBaFBQMlNmcnY1ZVV1ZHh4TldM?=
 =?utf-8?B?TkZ0dDhwK2JET1lRSzl3T2wzTnZ0T3hJd1U4VnhVZi9jcEdjaS80RjJ5Sno2?=
 =?utf-8?B?cEprTi9ib1AzTFdSa05DTi9lZVBWYmxkUVhYODBzMHZLOW81K3R6eTV1MUpM?=
 =?utf-8?B?QzVsbi80SkRGK2grL0x4T1k0ek52YXRVbWFxeGQ0N0tiT2NLWnM1RHN0ck1P?=
 =?utf-8?B?Znk2akVaMUVNcUhETEZkT0k2YXArb3JuUXo0SWFJbWhON0N3d1daL3krMHBG?=
 =?utf-8?B?RitmbmdQWFRuYmlNUjVkS0NieDVXb2ZFWlhBM0pPckNvMGtVU0ZGcDI2aW1W?=
 =?utf-8?B?K25uTHlyZWg5SGJtS1FjZkZ3SnQ0eXpnWFYwTTlwck8xSktsRnFleUtHNXdx?=
 =?utf-8?B?VzRWcnpJNmVmbUp2KzZnVDdoSkU5TGtQNmZvZDd0YTFMdnc3ZFlwQWgvdUE0?=
 =?utf-8?B?enVpRDkzL2RkRTdNa016QlBvWVdGSDQyb3BlOU5yOU91QS9ESjJyZmQvaFB0?=
 =?utf-8?B?bk1hdjlFMzRId2dXYm1rMlVaZ240TmJrUzdaSHBueFdxY1FlZEk4dk9aVTVw?=
 =?utf-8?B?bjNMbnRxejZkbFJNMUFJSllmR0dEeEtzbFJMV2JOU0RMK2Ywb3A2UG01UWZy?=
 =?utf-8?B?THM4cmhzSDdhejU3aUhUNjNWSHM1MjFkbExWM3FuWEJMYWRncHUxRjB1Tkw1?=
 =?utf-8?B?dGlpbmNqaHg1WXpDNmZtd1QxdjlSdksrMUhySXg0YkFvbEVOeG4rVFhCMmtQ?=
 =?utf-8?B?WDg3UzB6YmJiRXlXQnlBYTk0b1F2NC9zbzNIcnp3c2FwdnVpNi84UDhtejh4?=
 =?utf-8?B?Z21PN0k1WGQxZDlSdmdzNXhNR2V3Q1dYSEJyRHpjdG95Q1JqUjFXQTJBbEc1?=
 =?utf-8?B?M1JNUlFvTEZ5OVVrclFYVmhrSVB5d2tRTHpVMzJ1UCtTbDFDVEJCc2EzUnVp?=
 =?utf-8?B?bW9mRVVOczBQNkxtR2FSWGI2K05qQ1NJT3M3VlFTVUVnSnVWc1VHeWlQQmdp?=
 =?utf-8?B?T2xCUTkvWEZCTFFHVDluNDRpRTJsUWhvOUpmVU5ROHVxRE1IUDFjTjk3ZHVr?=
 =?utf-8?B?TFpLQUtDZ3B3V0QyeXZNZHg1UmRZcTZDTDdkWkx1OWU1T3diWUVXWWwxYytv?=
 =?utf-8?B?S0ZqMTQyNGpEeURZL0luUTNUcWJVMVNiWEJwZUpSd29DNmpqTENhTUFNR0xi?=
 =?utf-8?B?SzQ2UHNqMC9tbTlRbjRiZFU0a3hrZUZiQWpXN0FMUmF5ckQvTzJpT0RWK3ZI?=
 =?utf-8?B?NlErK3FsdUdGam1kaVFSSFVPSEFPWGR3SnhnR29hTUNITW5lc2NWYzgzSC9N?=
 =?utf-8?B?cHBwd2s1MSt2NDdNZlpUNmNmYTc1NGdmOFlBQnNEU3dYbWtaNWk1cGpuOGp3?=
 =?utf-8?B?TE5SanpmTjhsMHQ1aEhaQ2Zwa2N3TEx5U3pub0hhRW5xRXIxTVBQVU5lS0Nq?=
 =?utf-8?B?MGE1WVd4YTdxT0Q4VFp1L3NDeGxHemNTdjZyZzhUSVpYSmxGWXlheWFXT24r?=
 =?utf-8?B?aVVTR3paMnVoMzd0aEJZY044ZU1oU0Nka25WM29FcjY4dWpFQXVLM0c4Vk1P?=
 =?utf-8?B?ekh2WTlxRGlxak9haVVBYnJWN1dhNWRtcXo2YVZyT3ZYZDg5OXlUTXV3MUF1?=
 =?utf-8?B?RVV4R2orc2cvd3Zzbjl1VVBoTTJaaHdtOURWRzZBSU1yejBzVnNHUGxEWitN?=
 =?utf-8?B?ZmVXR3VVUlluenBoMCtSdWQ5TjgyQzhDNlcvUk5IR2J2Um9nUW0wRi9mL29R?=
 =?utf-8?B?MDdsWXJEVTFSUTByYnZUM2ZEa3p4VWpHdzkwT01zVHlGM2FCUWRvR0VkTmFD?=
 =?utf-8?Q?1HtdYS9OHho=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bHBqSFVSU0lkZkliempNNjk1Vzl5aWU2MUw0dk1FczZuU1hlSTNsQy85M0xE?=
 =?utf-8?B?WFhwNUpKZjBCaVJCQkVZOFhtVEptN3FKK1B3clltTGtoQ2pqeFNwbFMzeHh2?=
 =?utf-8?B?QVh3NFlMR2dkVGN5RUNuTlc2cDAzSTErZ0RYbkhLVUNKN0w0QzBNZk10VERU?=
 =?utf-8?B?V2Y3WFEwS2QrckN2eit6bWxwL3dZTGk2NWZDMzUyYUFyamNHS0p1WlF3ZFRM?=
 =?utf-8?B?QWtoZU15aDhhNXM2MjZSaFVtbysvaE1kK21MdXFaaUJvbE5ZeVYwNUxMekZO?=
 =?utf-8?B?M1NGOVNWVnVZMmFPZ25uYTdWaTM3MUhtN0xGMTE4WnV3ZEEyQ3VEaU5YSnA4?=
 =?utf-8?B?OFhhWDRETFoxWk5qTnpZYzZZOVpmcWdUbWJJKzFMV24zWnVYWXdhVmxhY0Ns?=
 =?utf-8?B?bXR3K25lVXNvWHNXNUZpZEdta2Z6bzdmYnFzOWtKcmxJTFhFMk1UczhNSllY?=
 =?utf-8?B?MktDRi9IeTV6SGhWQXQ5YjFGSjNqOHRZbTZOcTlvYmlkLzlWVWJUdnMzQmV5?=
 =?utf-8?B?cXBCNlExa3pYSTlVSy9oclNWVncva3hJOUdHcVp1WWlrVjVZMHhtb01PemdI?=
 =?utf-8?B?MW0wVk1DY0NZVXVMdXI0dmZOck5kKzdzODhXTUkvYWZVdDZNZlNmaDJ4VEp3?=
 =?utf-8?B?Mm9wWmpidDY0MGFoSHp5d1dzT25sVUwxc01xY2hHcFRETGZaMmJzTHVmWWZ0?=
 =?utf-8?B?QUlWZkQxN3cvY2pxbzUyQ0hZK3hva0xiUU9BWjdmYzZLbGpVNTFXbFY4Y1NP?=
 =?utf-8?B?OEJFTUxTcE94ZXJHUkxhQ01nWldBVlhobjB5cVM1ZmVPZnIybHpKYjltQjk2?=
 =?utf-8?B?RnI0U3p0aFdLQ3B0ZVc5bDJKUXhzeUE1SWJVVGlUT2JWRlBuSkwyVkdPM1lH?=
 =?utf-8?B?OFRVbVpaUld1aWZYOXg5Vm5EUTZhQU9vaVVtdFU5TXRQMXBEMTUzM1RycVhW?=
 =?utf-8?B?SGRNQUdMSlRaY1RxQUNqdWZZakNWVG5PR0lVMEljYjRkWWc0SU1JRHh1YzN1?=
 =?utf-8?B?Qmt5cmZLK1dHalVmbG9jT3BucWU2K25USFVIbmE1R0tDcSs5VzBRM1N6WWYv?=
 =?utf-8?B?ZEtkb0lJZlVhaldka1dRRWZXTmxtaXU1SDJKMnJPZE5JRlU3RzBWS2NGUjNO?=
 =?utf-8?B?UHNGZE5pS3FXelUzcGRpQWp6WG10RW9YUUVyZEVVVGVqTFltZ0F0QjJYTzAz?=
 =?utf-8?B?OHFFckJXaStTZDA1LzRwWlRaNWZYcjlNU0tqZ25yMlN5dng5VG5Gby9vbkpm?=
 =?utf-8?B?by9HQ0NTODNLUDYya01TNHRTNXJPMk1xbmlUY3ozZWVpeUdlTHFuOW9WVFpG?=
 =?utf-8?B?V1JFYXJCaCt5MlBtK3RZdkdWLzdYcEE4V3QzZVhYVXNiRGlXRW5qaTVKcGhq?=
 =?utf-8?B?UTdNdDlnbWZkVDRDSWEwNnFMUXBpeERnMUlBSDhRS2phWVhmaVROelZMU05J?=
 =?utf-8?B?QjlVd1pOWlRoYnh1VTVQSk4xV29TM1hEU1ZROVF6aVlsOXRFdHY5SHlPcTIy?=
 =?utf-8?B?aVliN2Voc2RRckdBcXV2RVBzV21PU0x0UzBtNk5mNndXWVlYbDdGRmpQSEVX?=
 =?utf-8?B?NzNVMzdOWUNJTDVLYjNNNlBCdzZMYUkyN3VzeldHeXJXWURTa25LSExYSEhS?=
 =?utf-8?B?cEI5UGxISEtGTzhXSnhLZTRVc1pKbmd6bHoxZzJVSzFBUkF4YTZ5aU5Rb1FO?=
 =?utf-8?B?YTFrM1o0NDlBU3hoZ1RBRHlnVkNoa0pmNlRYMUh4QWk5d1VPcm9kZ0hFUWE4?=
 =?utf-8?B?MTN2MHZVMFZzcWwzVUJSWEpVRzROWWZSUWdpUCtVYVBFNzhRM0hzYXdrT1Uw?=
 =?utf-8?B?VFFtZnJ1Y1BIRmVlSFZzZ2tTdG9YRXRoSHBTRVdieVFYWnBHRDV6QkFPdTlF?=
 =?utf-8?B?U20xT3o2cmdwM0xkZWlleEkxRlR3ZnZpUnoyb2RqQlVTK210dE9wRDc0N0Ev?=
 =?utf-8?B?eUw2bVVOQjVGRlgzNTBBNitic1B4bE5NdE1FbDhnYXAvNXp3dllhdURLdDNW?=
 =?utf-8?B?Z29hMCtYbHc2RUkwcW1VMEdOMmJjZDl5eG5qaEJwSDBZTUFYZzVKWDlxenhl?=
 =?utf-8?B?YXlCVUhlci9lRkhpR0hua1BheUE5NHBBQ1VBWWxWaEZTMHNQc3JiMEUzQjhu?=
 =?utf-8?B?R3pPQUNjM2o4cXJPVkhvdnhkdFg0OUplNUZsRHRMbEJUaWJ5OStFWjROQmlL?=
 =?utf-8?B?Z1VzYmZxeGhFTzl1aGZEbE44eEhoL0JDcm1jMUNZNGFtalVPcURwcE5xNkJH?=
 =?utf-8?B?clFiNnRvLzlNNnR2REFubmVpdkd3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E80FC16260D644B83D5ED809D49DFD0@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a115cc82-293b-4855-b4e2-08dd80191416
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2025 14:38:55.5460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ue4Z4cuTfDYTm4mS/kCeMrMPcPms7976SK1swZO0uu+709yYFEXoEPr+hGmlVMyN2mr5xRmvbmlQIv7hxO5GTMBc5MRGkFtD18ITUvI8UFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB9289
X-Proofpoint-GUID: D-XxwitGFSu0CWg4lTV0D7uQaxni-nhx
X-Proofpoint-ORIG-GUID: D-XxwitGFSu0CWg4lTV0D7uQaxni-nhx
X-Authority-Analysis: v=2.4 cv=PvSTbxM3 c=1 sm=1 tr=0 ts=68050703 cx=c_pps a=94i1PXq8WVRBNmfdvHlv4w==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=0kUYKlekyDsA:10 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8 a=8Q7crdlElA80znR7TPwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-20_06,2025-04-17_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDIwLCAyMDI1LCBhdCAzOjMy4oCvQU0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBF
eHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBTYXQsIEFwciAxOSwg
MjAyNSBhdCAwNjowNToxOFBNIC0wNzAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gSW4gaGFuZGxl
X3R4X2NvcHksIFRYIGJhdGNoaW5nIHByb2Nlc3NlcyBwYWNrZXRzIGJlbG93IH5QQUdFX1NJWkUg
YW5kDQo+PiBiYXRjaGVzIHVwIHRvIDY0IG1lc3NhZ2VzIGJlZm9yZSBjYWxsaW5nIHNvY2stPnNl
bmRtc2cuDQo+PiANCj4+IEN1cnJlbnRseSwgd2hlbiB0aGVyZSBhcmUgbm8gbW9yZSBtZXNzYWdl
cyBvbiB0aGUgcmluZyB0byBkZXF1ZXVlLA0KPj4gaGFuZGxlX3R4X2NvcHkgcmUtZW5hYmxlcyBr
aWNrcyBvbiB0aGUgcmluZyAqYmVmb3JlKiBmaXJpbmcgb2ZmIHRoZQ0KPj4gYmF0Y2ggc2VuZG1z
Zy4gSG93ZXZlciwgc29jay0+c2VuZG1zZyBpbmN1cnMgYSBub24temVybyBkZWxheSwNCj4+IGVz
cGVjaWFsbHkgaWYgaXQgbmVlZHMgdG8gd2FrZSB1cCBhIHRocmVhZCAoZS5nLiwgYW5vdGhlciB2
aG9zdCB3b3JrZXIpLg0KPj4gDQo+PiBJZiB0aGUgZ3Vlc3Qgc3VibWl0cyBhZGRpdGlvbmFsIG1l
c3NhZ2VzIGltbWVkaWF0ZWx5IGFmdGVyIHRoZSBsYXN0IHJpbmcNCj4+IGNoZWNrIGFuZCBkaXNh
YmxlbWVudCwgaXQgdHJpZ2dlcnMgYW4gRVBUX01JU0NPTkZJRyB2bWV4aXQgdG8gYXR0ZW1wdCB0
bw0KPj4ga2ljayB0aGUgdmhvc3Qgd29ya2VyLiBUaGlzIG1heSBoYXBwZW4gd2hpbGUgdGhlIHdv
cmtlciBpcyBzdGlsbA0KPj4gcHJvY2Vzc2luZyB0aGUgc2VuZG1zZywgbGVhZGluZyB0byB3YXN0
ZWZ1bCBleGl0KHMpLg0KPj4gDQo+PiBUaGlzIGlzIHBhcnRpY3VsYXJseSBwcm9ibGVtYXRpYyBm
b3Igc2luZ2xlLXRocmVhZGVkIGd1ZXN0IHN1Ym1pc3Npb24NCj4+IHRocmVhZHMsIGFzIHRoZXkg
bXVzdCBleGl0LCB3YWl0IGZvciB0aGUgZXhpdCB0byBiZSBwcm9jZXNzZWQNCj4+IChwb3RlbnRp
YWxseSBpbnZvbHZpbmcgYSBUVFdVKSwgYW5kIHRoZW4gcmVzdW1lLg0KPj4gDQo+PiBJbiBzY2Vu
YXJpb3MgbGlrZSBhIGNvbnN0YW50IHN0cmVhbSBvZiBVRFAgbWVzc2FnZXMsIHRoaXMgcmVzdWx0
cyBpbiBhDQo+PiBzYXd0b290aCBwYXR0ZXJuIHdoZXJlIHRoZSBzdWJtaXR0ZXIgZnJlcXVlbnRs
eSB2bWV4aXRzLCBhbmQgdGhlDQo+PiB2aG9zdC1uZXQgd29ya2VyIGFsdGVybmF0ZXMgYmV0d2Vl
biBzbGVlcGluZyBhbmQgd2FraW5nLg0KPj4gDQo+PiBBIGNvbW1vbiBzb2x1dGlvbiBpcyB0byBj
b25maWd1cmUgdmhvc3QtbmV0IGJ1c3kgcG9sbGluZyB2aWEgdXNlcnNwYWNlDQo+PiAoZS5nLiwg
cWVtdSBwb2xsLXVzKS4gSG93ZXZlciwgdHJlYXRpbmcgdGhlIHNlbmRtc2cgYXMgdGhlICJidXN5
Ig0KPj4gcGVyaW9kIGJ5IGtlZXBpbmcga2lja3MgZGlzYWJsZWQgZHVyaW5nIHRoZSBmaW5hbCBz
ZW5kbXNnIGFuZA0KPj4gcGVyZm9ybWluZyBvbmUgYWRkaXRpb25hbCByaW5nIGNoZWNrIGFmdGVy
d2FyZCBwcm92aWRlcyBhIHNpZ25pZmljYW50DQo+PiBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudCB3
aXRob3V0IGFueSBleGNlc3MgYnVzeSBwb2xsIGN5Y2xlcy4NCj4+IA0KPj4gSWYgbWVzc2FnZXMg
YXJlIGZvdW5kIGluIHRoZSByaW5nIGFmdGVyIHRoZSBmaW5hbCBzZW5kbXNnLCByZXF1ZXVlIHRo
ZQ0KPj4gVFggaGFuZGxlci4gVGhpcyBlbnN1cmVzIGZhaXJuZXNzIGZvciB0aGUgUlggaGFuZGxl
ciBhbmQgYWxsb3dzDQo+PiB2aG9zdF9ydW5fd29ya19saXN0IHRvIGNvbmRfcmVzY2hlZCgpIGFz
IG5lZWRlZC4NCj4+IA0KPj4gVGVzdCBDYXNlDQo+PiAgICBUWCBWTTogdGFza3NldCAtYyAyIGlw
ZXJmMyAgLWMgcngtaXAtaGVyZSAtdCA2MCAtcCA1MjAwIC1iIDAgLXUgLWkgNQ0KPj4gICAgUlgg
Vk06IHRhc2tzZXQgLWMgMiBpcGVyZjMgLXMgLXAgNTIwMCAtRA0KPj4gICAgNi4xMi4wLCBlYWNo
IHdvcmtlciBiYWNrZWQgYnkgdHVuIGludGVyZmFjZSB3aXRoIElGRl9OQVBJIHNldHVwLg0KPj4g
ICAgTm90ZTogVENQIHNpZGUgaXMgbGFyZ2VseSB1bmNoYW5nZWQgYXMgdGhhdCB3YXMgY29weSBi
b3VuZA0KPj4gDQo+PiA2LjEyLjAgdW5wYXRjaGVkDQo+PiAgICBFUFRfTUlTQ09ORklHL3NlY29u
ZDogNTQxMQ0KPj4gICAgRGF0YWdyYW1zL3NlY29uZDogfjM4MmsNCj4+ICAgIEludGVydmFsICAg
ICAgICAgVHJhbnNmZXIgICAgIEJpdHJhdGUgICAgICAgICBMb3N0L1RvdGFsIERhdGFncmFtcw0K
Pj4gICAgMC4wMC0zMC4wMCAgc2VjICAxNS41IEdCeXRlcyAgNC40MyBHYml0cy9zZWMgIDAvMTE0
ODE2MzAgKDAlKSAgc2VuZGVyDQo+PiANCj4+IDYuMTIuMCBwYXRjaGVkDQo+PiAgICBFUFRfTUlT
Q09ORklHL3NlY29uZDogNTggKH45M3ggcmVkdWN0aW9uKQ0KPj4gICAgRGF0YWdyYW1zL3NlY29u
ZDogfjY1MGsgICh+MS43eCBpbmNyZWFzZSkNCj4+ICAgIEludGVydmFsICAgICAgICAgVHJhbnNm
ZXIgICAgIEJpdHJhdGUgICAgICAgICBMb3N0L1RvdGFsIERhdGFncmFtcw0KPj4gICAgMC4wMC0z
MC4wMCAgc2VjICAyNi40IEdCeXRlcyAgNy41NSBHYml0cy9zZWMgIDAvMTk1NTQ3MjAgKDAlKSAg
c2VuZGVyDQo+PiANCj4+IEFja2VkLWJ5OiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29t
Pg0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPiANCj4g
c291bmRzIGxpa2UgdGhlIHJpZ2h0IGFwcHJvYWNoLg0KPiANCj4gQWNrZWQtYnk6IE1pY2hhZWwg
Uy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+DQo+IA0KPiANCj4gDQo+PiAtLS0NCj4gDQo+IA0K
PiBpbiB0aGUgZnV0dXJlLCBwbHMgcHV0IHRoZSBjaGFuZ2Vsb2cgaGVyZSBhcyB5b3UgcHJvZ3Jl
c3MgdjEtPnYyLT52My4NCj4gVGhhbmtzIQ0KDQpUaGFua3MgZm9yIGNoZWNraW5nIG91dCB0aGUg
cGF0Y2gsIHNvcnJ5IGFib3V0IHRoZSBsYWNrIG9mDQpjaGFuZ2Vsb2cuIEZvciBwb3N0ZXJpdHks
IHYyIHdhcyBvbmx5IHNlbmRpbmcgdGhlIHBhdGNoIHRvDQpuZXQtbmV4dCBhcyBJIGZvcmdvdCB0
byBhZGQgdGhlIHByZWZpeCBvbiB2MS4NCg0KdjEgcGF0Y2ggd2l0aCBKYXNvbuKAmXMgYWNrIGlz
IGhlcmU6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNTA0MDEwNDMyMzAuNzkwNDE5
LTEtam9uQG51dGFuaXguY29tL1QvDQoNCj4gDQo+PiBkcml2ZXJzL3Zob3N0L25ldC5jIHwgMTkg
KysrKysrKysrKysrKysrLS0tLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyks
IDQgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L25ldC5j
IGIvZHJpdmVycy92aG9zdC9uZXQuYw0KPj4gaW5kZXggYjliOWU5ZDQwOTUxLi45YjA0MDI1ZWVh
NjYgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3Zob3N0L25ldC5jDQo+PiArKysgYi9kcml2ZXJz
L3Zob3N0L25ldC5jDQo+PiBAQCAtNzY5LDEzICs3NjksMTcgQEAgc3RhdGljIHZvaWQgaGFuZGxl
X3R4X2NvcHkoc3RydWN0IHZob3N0X25ldCAqbmV0LCBzdHJ1Y3Qgc29ja2V0ICpzb2NrKQ0KPj4g
YnJlYWs7DQo+PiAvKiBOb3RoaW5nIG5ldz8gIFdhaXQgZm9yIGV2ZW50ZmQgdG8gdGVsbCB1cyB0
aGV5IHJlZmlsbGVkLiAqLw0KPj4gaWYgKGhlYWQgPT0gdnEtPm51bSkgew0KPj4gKyAvKiBJZiBp
bnRlcnJ1cHRlZCB3aGlsZSBkb2luZyBidXN5IHBvbGxpbmcsIHJlcXVldWUNCj4+ICsgKiB0aGUg
aGFuZGxlciB0byBiZSBmYWlyIGhhbmRsZV9yeCBhcyB3ZWxsIGFzIG90aGVyDQo+PiArICogdGFz
a3Mgd2FpdGluZyBvbiBjcHUNCj4+ICsgKi8NCj4+IGlmICh1bmxpa2VseShidXN5bG9vcF9pbnRy
KSkgew0KPj4gdmhvc3RfcG9sbF9xdWV1ZSgmdnEtPnBvbGwpOw0KPj4gLSB9IGVsc2UgaWYgKHVu
bGlrZWx5KHZob3N0X2VuYWJsZV9ub3RpZnkoJm5ldC0+ZGV2LA0KPj4gLSB2cSkpKSB7DQo+PiAt
IHZob3N0X2Rpc2FibGVfbm90aWZ5KCZuZXQtPmRldiwgdnEpOw0KPj4gLSBjb250aW51ZTsNCj4+
IH0NCj4+ICsgLyogS2lja3MgYXJlIGRpc2FibGVkIGF0IHRoaXMgcG9pbnQsIGJyZWFrIGxvb3Ag
YW5kDQo+PiArICogcHJvY2VzcyBhbnkgcmVtYWluaW5nIGJhdGNoZWQgcGFja2V0cy4gUXVldWUg
d2lsbA0KPj4gKyAqIGJlIHJlLWVuYWJsZWQgYWZ0ZXJ3YXJkcy4NCj4+ICsgKi8NCj4+IGJyZWFr
Ow0KPj4gfQ0KPj4gDQo+PiBAQCAtODI1LDcgKzgyOSwxNCBAQCBzdGF0aWMgdm9pZCBoYW5kbGVf
dHhfY29weShzdHJ1Y3Qgdmhvc3RfbmV0ICpuZXQsIHN0cnVjdCBzb2NrZXQgKnNvY2spDQo+PiAr
K252cS0+ZG9uZV9pZHg7DQo+PiB9IHdoaWxlIChsaWtlbHkoIXZob3N0X2V4Y2VlZHNfd2VpZ2h0
KHZxLCArK3NlbnRfcGt0cywgdG90YWxfbGVuKSkpOw0KPj4gDQo+PiArIC8qIEtpY2tzIGFyZSBz
dGlsbCBkaXNhYmxlZCwgZGlzcGF0Y2ggYW55IHJlbWFpbmluZyBiYXRjaGVkIG1zZ3MuICovDQo+
PiB2aG9zdF90eF9iYXRjaChuZXQsIG52cSwgc29jaywgJm1zZyk7DQo+PiArDQo+PiArIC8qIEFs
bCBvZiBvdXIgd29yayBoYXMgYmVlbiBjb21wbGV0ZWQ7IGhvd2V2ZXIsIGJlZm9yZSBsZWF2aW5n
IHRoZQ0KPj4gKyAqIFRYIGhhbmRsZXIsIGRvIG9uZSBsYXN0IGNoZWNrIGZvciB3b3JrLCBhbmQg
cmVxdWV1ZSBoYW5kbGVyIGlmDQo+PiArICogbmVjZXNzYXJ5LiBJZiB0aGVyZSBpcyBubyB3b3Jr
LCBxdWV1ZSB3aWxsIGJlIHJlZW5hYmxlZC4NCj4+ICsgKi8NCj4+ICsgdmhvc3RfbmV0X2J1c3lf
cG9sbF90cnlfcXVldWUobmV0LCB2cSk7DQo+PiB9DQo+PiANCj4+IHN0YXRpYyB2b2lkIGhhbmRs
ZV90eF96ZXJvY29weShzdHJ1Y3Qgdmhvc3RfbmV0ICpuZXQsIHN0cnVjdCBzb2NrZXQgKnNvY2sp
DQo+PiAtLSANCj4+IDIuNDMuMA0KPiANCg0K

