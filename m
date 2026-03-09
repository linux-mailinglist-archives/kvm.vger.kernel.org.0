Return-Path: <kvm+bounces-73259-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aCeKCdBprmkGEAIAu9opvQ
	(envelope-from <kvm+bounces-73259-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 07:33:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8C67234384
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 07:33:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7D77301174B
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 06:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEB535AC02;
	Mon,  9 Mar 2026 06:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="g6xBMB+2";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="f5eO+Veu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C80D34CFCA
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 06:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773038025; cv=fail; b=gZrNLkuMeGN6yLMJPgjnx/ycUhCJxY+MyYDGc+plQdRnai37BnLZlO/T5mWV+sV4y4AOcQrb3FkHm06Pe7qmZW//PHGGMtOmsudcqGuaY7NO6lwjcHYzaMNVFv5xsXNBAVC+Etx2uDKgaDQdZnScPhCu8o0P2dGBsMyA/+UcPw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773038025; c=relaxed/simple;
	bh=A7fUhdIFpFsOjdW//n3h3WVisJ+RqBLMufw3k+w+clM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q5Oe2B8+5znTrteEduUhC5eIov3VIDbWYioN9tmTDBXHog+uT/Fy7gRRydtrWF4gw7zP+U7VF9HfcUUbrTQ3P0J92cVSxdPzGjv5RdRSR1L44xTqMypyY8xeuAzjsTm++E34OW7AyFbq2PVO6r63FBrQvnVS22o/rJPodEjUPE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=g6xBMB+2; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=f5eO+Veu; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628LmB9K2417137;
	Sun, 8 Mar 2026 23:33:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=A7fUhdIFpFsOjdW//n3h3WVisJ+RqBLMufw3k+w+c
	lM=; b=g6xBMB+2Fxgz/pWdBzON7gdclh5nwEfULWu0A+GXVxvazV6kdicPlDle2
	JA7Te/noKxvhYHFErDwbEibEHSYnvllSBdPhbf9cAKsTFrVHceIOWijs14NLVu1Q
	2t6s3Ltfn03h94Y4fQRphAr2aDBlrJPfHMBKnlbzLQcunw7HEDw1Z7caNGqk2Owq
	Ax/GV9grU+TiwNxy7nHxybpxoRIDC3zi1f62VSZbsp4JZpBw5E9p/Vb1EnlrEvBo
	xK20UJTFvsnc7EG3uB06AvAUN64N27yvEui5h63cOTKUqJV92z8DQYdE0nzIqERl
	/aGK0dWJz+VTPLnYkW1OATfSQenmQ==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021084.outbound.protection.outlook.com [52.101.62.84])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4crmeytnas-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 23:33:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e59fk7WTMsnbYPM2kWkPgdPAhGh7Q9XMI8s21P8mOcNd8Y9nQp/vbYETbiTU3Jkeeg8Vb9BZ5mgFTTdJ197uD/zk455lDE9HSe5L6l25oGXBgLPwy7rTU+Vzh4V2RrRLt9Cft4kRMN0d/C4MJvj0WsX70SgojdMITAqQZ9IFjM3k5FUvkAocv8Xs3MEAIEC5Wcfb1cZi47+utRmF3qfi/KQ/A7kERc4SbU47BdKkuZM+ZFeEUFQAADLXoAHustvv60gIsXBYC2TUmN1FcIlBiIt2mCNmUhkq+CCkpFWyX9SpjJd3oS6MD6Z/9hKWmqe+7Xx2DTdcDdAsWfJFycPYeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7fUhdIFpFsOjdW//n3h3WVisJ+RqBLMufw3k+w+clM=;
 b=b2na/3YQc+JZywLZC+qRM3HqZqQk4BAEPGfWVAaJfGwpD1t07YbzBvSjErwBCrpmxoxGioBBZnctGIvXq4STBWTNtyNoBe1aN5sSQUkLUREMS+i2Uq5SPE8zX7HK87tDkj2Ct/TCECaTAF1UPPxwM7kZM0hkivBjdT4WautD27koaVUcwleoPnzX8xyiu9djkC8zGP03THawGcLpdHp7RMhEjaa1NYw2VD6IlLDz0SZ3iGb9gdR3KFGYl3jTJJt632N/ZaQ8YnjazG0SfupTSykOg4u39GqTEXFM2MUsRwjMYLxrrk72RuBEhGgDGXP5UPO2IhU1v1vw1DHhkJO+UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7fUhdIFpFsOjdW//n3h3WVisJ+RqBLMufw3k+w+clM=;
 b=f5eO+Veu95XzD+W8S0p+sHoEfh+zRefGLpVXxdSRfnq9oLipQ7FGAAe+zKDrOYRSRscll2pmOnCamg3xrLSUbOMd8HXt5saxMSuAJ91Etp6ZNIdj+8jIztZ8ccy7A/i4l5xcdRvesgmI4xHhRLftcMkkiOGP6XJuRZNccgrOJ8Ocp/8X1tGTkeuGA8k6wgqsqtvTDJixq4Cys21XBdqBIxbx6Vdxj5a10kap/jqRyxwXq4g6UZwMYqh9qWEEBgqbeekH6iURkHHxQlJoKhZNKXjWiwMmIAzQ/Z/NDOgLNdjHM94MNOcxEpR2jMmfoCuLjpfek5fhtaxRGfulGzuN6A==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS2PR02MB10871.namprd02.prod.outlook.com (2603:10b6:8:2b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.24; Mon, 9 Mar
 2026 06:33:23 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.20.9678.023; Mon, 9 Mar 2026
 06:33:23 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Mohamed Mediouni <mohamed@unpredictable.fr>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Jon Kohler <jon@nutanix.com>,
        Mark Cave-Ayland
	<mark.caveayland@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/1] target/i386/kvm: Configure proper KVM SEOIB
 behavior
Thread-Topic: [RFC PATCH v2 0/1] target/i386/kvm: Configure proper KVM SEOIB
 behavior
Thread-Index: AQHcr4eRycrH35elTkivCISxd/xcP7WltDUAgAAJ7QA=
Date: Mon, 9 Mar 2026 06:33:22 +0000
Message-ID: <D74B0637-1332-4FC4-B29B-804E5AC18C33@nutanix.com>
References: <20260309054243.440453-1-khushit.shah@nutanix.com>
 <6A894B95-03A6-49EE-91A2-D3BCB09AAFCD@unpredictable.fr>
In-Reply-To: <6A894B95-03A6-49EE-91A2-D3BCB09AAFCD@unpredictable.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS2PR02MB10871:EE_
x-ms-office365-filtering-correlation-id: d6698256-1e24-4572-d98a-08de7da5c318
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 dqomQedOy9ZvCRQB1KLXF9p0UviGTESNyqwsugyyh5E+C8W8dIClw5qFa1b1hrhCKFpyMjn0t0FpX1vkoTuTwQkmIwflMBaFfPIPezQq3mww5Hn+pbmYMXEx1LuUAbt8O/P8O8c/6Bmvv89B9KtnYgvxf2mA97JOaG05iCIhWU9LA9fRk38sXcWdiequ/+Lf42dJh47jVmKQQ9j5MeYkfonwzQf964f3Wl+MZ2NAS0F9TGjfR6yYiOQoHFfiNZsIT80wvDqr+HqDwm87kICPtxum6zM3AdUfo8UyxwySvu3MkUJEle4xPL6vVHQjTb8Rl8EyQYf8O+eMmeYqYy7mVxyk1F4w/SuBJZYQNtJylCZx5pabWwOVxgoqxPqxNOZVZ8hJf8VDJkc/wcq0Qyfx2NH8DJJZMSob6od83Xq0zRSd+8MJ1N/FswONc+K2tu8g0Fgoh4nMjARNK8a3cBGu6tNxDyNT4zWxSmOJXa28Gzi0jaC2xyjVVNNOXvOnPI/Kw+rP0QvLNdTXd3QzSpkf8x+g0JS0lizRQ3ACXQY58KiTzpZujwlh85ES2dSsgfqM9XFYf4EVp5nHWtwu8sGDjsa0F+UjVTjpqvNdZIJJ3DBd7kE5T6fqUmY7pXA5F/a3+GTIAlGuRYWRfLxCzioMmi0Ijqf2BrgZ0lDe9dXUsq2EcHim9aLxyjKKWQcbgi5PQg6q3LjEySgFJMg999mCaz989VlqjdGc6+BIfuBbZ4AIp3SjGJnoApUVGKj8on09ocNqLU2BxO00WrlalAOA7HehPXSmR3sJU0S7vVUv0Ys=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUJ0NC9oS2l4Z1ZoTXBXUVZNSCtjM2N0LzI4WlhMQjJoU2RoUy9tTVovNUVB?=
 =?utf-8?B?a0pIMm9aZUV2UXM0SnFjQmxFcklnZDdPZnA2Y2krc2tmMDduTFRXTS9CNzBp?=
 =?utf-8?B?RjVmeW4xZG14VHRWWFRzcnY5OWF0WWJDL0Z5VE4wOXozcFJTdlF0a1hvZGhB?=
 =?utf-8?B?b0hnRTVjNGkzTDh6bWVjcTZ1Nm5uVDF1VEs1OUFPWEdkakNUYm4xZmREbnRZ?=
 =?utf-8?B?UXZFR01PMVo5TkZpRFRsR0k4TXNZcGY3eG1LVUhZdGVqSUpBbGhLZEwrQ3Ev?=
 =?utf-8?B?dnpKenF2SHhtWlhDMDQrNTFQOHhkeW8xdmpHdHhHbUZQOFhxNERUYlVaTFZB?=
 =?utf-8?B?ZG81QUpwVmswR0VtbVR1b3k0WFFOaDNkeUZrRlNXQ1laM3UvaElPUHFSSGJS?=
 =?utf-8?B?RU5jZFQrOE9SM25tR2s2S1FhYlNNWVZWeTU0S3RWc0EvSjB0LzRsRTQyaDdw?=
 =?utf-8?B?SW9YZWR5dGF2d2Y5MnBnTDczRnp3YkJGbmpnZEQ3bWlJRHZZam10SDIzdXIr?=
 =?utf-8?B?WlEzQ0Z5SUZzaGdyRkg3YnEyTDFkdWlGYytIdHQwZWVBR3BOV1VGYzVpdmsy?=
 =?utf-8?B?Vjd2RlUzL2dUdU5qNmpLamh0V1U3V05salpRREs1L1VkQjlhVTVIWFhsWFox?=
 =?utf-8?B?MUZsbktNVXlpMCtYMGJacG5mUk14TnhEV0dYS3UxNUIxbTFMTk5UV3lsekY4?=
 =?utf-8?B?Q1lqNkE2M1dBWUgxRURsVnhXYWZ0c3dPQWRnSVN4SEdGVFhoU2VWR1VKK1N6?=
 =?utf-8?B?SDJLek1EK3dWajhRMURYYzJYL1NQSjA1eW5YeUxqbm5QUGNrSitHVlc2aUd4?=
 =?utf-8?B?M2s1QU5LeWJPWnB4TWlXV0xtZG5FTEVkUHI4R3lQNjhzTnllS2FUVDllYW9H?=
 =?utf-8?B?VURqOGd6aW1TQTcwOURXNnlyVkxuckxOaGNuOUdxK2YxbDNWUUZUcmNVby9o?=
 =?utf-8?B?ZHNJZzFHT21hT2t5TXhCV3NXYnk2SUd3RVNqWGEvcVZGc2hQaVJVai8yYkZ5?=
 =?utf-8?B?T1YxZHhTN1VHMUs1bDRHWUlVc25jdFBjeTA5RkViVEdWQWU4ZEVPY2lJMmQw?=
 =?utf-8?B?QXBZYm1uUDQ3MG9mUVRGT0hRVXZWOFlseTl0cVdNZGFmMGRtUUNubEY0ZEIz?=
 =?utf-8?B?WkNYMU5PUHNtbkE0NjBKNmp2akhoVUJIZGlJWFJ4R0Zydm9pL3FldTNuUFpk?=
 =?utf-8?B?UHpPOWdQR3ZQbExZTm5raENYV3hNNjJDbjAyd01pTXB5a3M5azRDd05kbEVi?=
 =?utf-8?B?WVhYQWhZdzRPSk5aR1BXSFkrbkJDb1g5M1MyRGY1N0pkRThvdUtvaE91N1Ns?=
 =?utf-8?B?YXpiUTRKZzAzS3dLRitHVEVXeXdyUDZuelhLRmp6VnJwcklRc09iZ3ZIRnE5?=
 =?utf-8?B?enpsZmdyckZtMW00eFFaYms3WStjTlZxaEpQNDlxTmhwc2pDOEZHeFdwM2dZ?=
 =?utf-8?B?NmxNaDUwYkdnN2JCUTZHT0JqS2pITXp2eWhBUzVZNVhnMTFxMmJiN3NkWFdY?=
 =?utf-8?B?REplODl2WC8yTkdKV3ViTHVTcHRHeTJIT2QxNDJQaElyMDJsajQyS1VmUUZY?=
 =?utf-8?B?bFlDSUNpeDQzajFwV0cwaytmN2pxQ29lMzNyVlViUG85RzZTc1JqakRqTWFi?=
 =?utf-8?B?cStMZU1PUVZkZUtpOHRUVG9abGJ1WFljem5LUWhhZE1PNTBhWU02WkFJTk0y?=
 =?utf-8?B?VkMrMXNFYXpEMVdFRFpFd2djMlIyeGN4V0tlWkhsTUlaMkFIb1BpbzBnbzds?=
 =?utf-8?B?Y25uNGloMkFJanRRc2Z5MHR0a0ZFTEF1b0UzZ3g4dloyQjlkZXBoS2F5UkFV?=
 =?utf-8?B?RU1VcU14eGJRazl0eko2YkQwYWFlL0h6ODV5SERkZFFPc2NhMStzazArT3Y3?=
 =?utf-8?B?Y05pSW9neG9SNkpqRElWWkJBTzlsMnBXNUdKTTRxSmJ6WTgwZVJNV1hQS3p5?=
 =?utf-8?B?YjRGUmsxQkFCeWU3VDdPckxaOGpZcmgrVnJCdTF2VHg1ZDFYZGhUWFd5bU1R?=
 =?utf-8?B?ZEpsSWhuckd6NEhNWXhsZ3czcE9wU0pheXIrZ0dtTXRKZ3FpT3JaNWZsdXpW?=
 =?utf-8?B?SmhMOHRJS09CRFFwSUhoQU9YRVJISFBRUVRiYUhUb252bURFWFY1YzdYczNV?=
 =?utf-8?B?UngzTUdlcEN1aDRHTDBQa3V0VGFacjAyZ1FNL2JFZ1MwZVZxb3NsSmlOSjMz?=
 =?utf-8?B?S1lkWkJBdlREVForNDR6KzNweGlaT1o2Mjc1ckZDc0JJVDNnVmFzd2k3QURC?=
 =?utf-8?B?THlBc3dCNDl1YlZGMTBybTNiRDlUR2pTWUxZdm8vdVlCaWI2MUZDZFVjbzgz?=
 =?utf-8?B?cGlXeDZFaUtxVWNENWxhQ25YLzZIcVVSWDZ5RkxrZ0FiSXhrVXYxSGswMHRU?=
 =?utf-8?Q?cpvsyNZQmsrn0B84=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAF3C4844B7A244CA031A01FB1ECEC58@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	RNkLvkG35V4IrK1XQGXaT+a8Sk8oqwLJyaol9Bcd3fRAoHvmUFg4F85xFBjiWg/uhmzQIki5sdzR+Eb56X+Qo5UzV94V8O715u7Fr76vbnip80b/HXBuhhqyYRmqxAW7pA89j1IKQzX0r6YUBw777pm3/BCMVPODdNkRB+8s8bJ38eed0L5xcHjWgeTpVPrHPljiqWr1+JaRDD84Bqrlw2mrkdAoguMcEbwPj7EkJgl/k4HfE9h1XaPOu47Z804a00YK6b1GH0oemt2uELSnpg5DtFm/8rw31Tb30lrVcY7I1eD/8GeEZ8kG/Te0WV9Pe1coQUK/NVsJ4sX8m/cQ1A==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6698256-1e24-4572-d98a-08de7da5c318
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2026 06:33:22.9280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mLOPRHQvsUIblO3zJVOnn4pR8WSkvppwI+D2LJ+jRTGDaURcuBEwRFzo2Kgws84sa6o1Tj0HjJ9Rium+bP18qN6XRjlcsA+JQOCAXzloYAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR02MB10871
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDA1OCBTYWx0ZWRfXxJ6efOuobPfX
 rBZ/j82xyjqOP0ZR1kjfbyIWYneJdQMNY4tRpElunnQhTSwY1XASwSikmA9mJYH5pVyoxc9aee1
 Yrh2dYZSLdNwkAyEUT4tWzVk+SGhuLgQjFUbIFP7hc7LI5TMkewHNFcnn/1LHlaJ4N30oCRQoEz
 Lzp9em87OJcUZD0Ynt2KB8IkbHGtD8nCCyWCuGJvTIn2wLmaADmCFElC7AWtrRJi9mxbg9fJsIR
 QddxTWDT9NcXSysis3KjfFVSKqSqIlgf4zhcfs2Le+GpcoBdPcXLXJmbt7S7n96X6P+cByPhHZk
 c21LZqxyDk7rQF8Dn1ulskWA9zq7VSCC9Pl1rwh2oMhlZEvC4r5/0+aCA4n60BnSAwFL4c4OFGs
 7BgdmJ/KlZ0s2mFFGMYkxXlTroshIj8h+J+lOxqrQoLi6DRsz+NsNHsWxVaS7EVloG/Y3xrWmrF
 wFuDqWiSXenBOV7a3NQ==
X-Proofpoint-GUID: OZ0wg7T4LIVC_2BtMMWhyxEuta70brLe
X-Proofpoint-ORIG-GUID: OZ0wg7T4LIVC_2BtMMWhyxEuta70brLe
X-Authority-Analysis: v=2.4 cv=TdObdBQh c=1 sm=1 tr=0 ts=69ae69b5 cx=c_pps
 a=0yFM1XxYkakKyygSKIuBYA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22 a=ulxcwG6o37Ri3b9FGLwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_02,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Queue-Id: B8C67234384
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73259-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,nutanix.com:dkim,nutanix.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[khushit.shah@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[nutanix.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

DQoNCj4gT24gOSBNYXIgMjAyNiwgYXQgMTE6MjfigK9BTSwgTW9oYW1lZCBNZWRpb3VuaSA8bW9o
YW1lZEB1bnByZWRpY3RhYmxlLmZyPiB3cm90ZToNCj4gDQo+IEhpLA0KPiANCj4gVWdoIGFib3V0
IHRoaXMgb25lLCBidXQgYW0gc3RpbGwgY29udmluY2VkIHRoYXQgYSBtYWNoaW5lIG1vZGVsIHZl
cnNpb24NCj4gaXMgX3RoZV8gcmlnaHQgd2F5IHRvIGRlYWwgd2l0aCB0aGlzLiBXaWxsIHRoaXMg
YmUgYmFja3BvcnRlZCB0byBMaW51eCBMVFNlcyBvbiB0aGUgS1ZNIHNpZGU/DQo+IA0KPiBPciBh
bHRlcm5hdGl2ZWx5LCB3aGF0IGFyZSB0aGUgb2RkcyBvZiBoYXZpbmcgaXQgZml0IGFzIGEgQ1BV
IGZsYWc/DQo+IEZvciBleGFtcGxlIC1jcHUgaG9zdCx4MmFwaWMtc3VwcHJlc3MtZW9pLWJyb2Fk
Y2FzdD1vbi4NCg0KDQpIaSwgDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg0KUmVnYXJkaW5n
IHRoZSAtY3B1IGZsYWc6IFRoaXMgZG9lc24ndCBmZWVsIHJpZ2h0IGJlY2F1c2UgU0VPSUIgaXMg
YW4gYWNjZWxlcmF0b3Itc3BlY2lmaWMgKEtWTSkNCnZhbHVlLiBUeWluZyBpdCB0byB0aGUgQ1BV
IHN1Z2dlc3RzIGFuIGFyY2hpdGVjdHVyYWwgZmVhdHVyZSB0aGF0IHdvdWxkbid0IGFwcGx5IHRv
IFRDRy4gV2hhdA0Kc3BlY2lmaWNhbGx5IGZlZWxzIG9mZiBhYm91dCBrZWVwaW5nIGl0IGFzIGEg
S1ZNL01hY2hpbmUgcHJvcGVydHk/DQoNClJlZ2FyZGluZyB0aGUgYmFja3BvcnRzOiBUaGUgS1ZN
IGtlcm5lbCBzaWRlIGlzIGN1cnJlbnRseSBpbiA2LjE4IGFuZCA2LjE5LiBJIGhhdmVu4oCZdCB5
ZXQgY2FtZQ0KYXJvdW5kIHRvIG1hbnVhbGx5IGJhY2twb3J0ZWQgaXQgdG8gdGhlIG9sZGVyIHN0
YWJsZSByZWxlYXNlcyB5ZXQuDQoNClRoYW5rcywgDQpLaHVzaGl0Lg==

