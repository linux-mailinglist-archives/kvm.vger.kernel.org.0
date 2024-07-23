Return-Path: <kvm+bounces-22079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2797593986C
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 04:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27E881C219CC
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 02:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0458B13B5AC;
	Tue, 23 Jul 2024 02:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=NETORGFT2018045.onmicrosoft.com header.i=@NETORGFT2018045.onmicrosoft.com header.b="NiOnYVbg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2112.outbound.protection.outlook.com [40.107.237.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B6C13A241
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 02:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721703185; cv=fail; b=cH72vYsvUKq6dUPh+pZOgtCutSnXy/dI+HmrBou4tYlXC1mEpuUeRUq2ckUx70n59Pb/7mdUvNA4oEnnYlB3DK6q2cLNHTcb1Vz1v0tD5cutVmDCMNphy2JX/gJLLYbwBLW/7cZk8nMscWyeSd2OFPTXEDnJrSZabZ3XpZuYkxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721703185; c=relaxed/simple;
	bh=ZlQ8bwmpTZiANDnM45LVEJgqBafUQsEZP9bqKjuKiOg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nIWvhd3LUkW6SN9sNZwXeMuoMJFqYWEEPZTfWDGd45PiJMsNOiH+6B4BOiznEkzbPUXE+0pnmmUDV9KpXuErYScdYZeUsMVjSe8Tb8qp1Qep1q6x0E0EiEF7m0mdKV0KEzjXckyHar46F7tHZFAE2zlnz8XpSZCFP4VsV55bBqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=petaio.com; spf=pass smtp.mailfrom=petaio.com; dkim=pass (1024-bit key) header.d=NETORGFT2018045.onmicrosoft.com header.i=@NETORGFT2018045.onmicrosoft.com header.b=NiOnYVbg; arc=fail smtp.client-ip=40.107.237.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=petaio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=petaio.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XXj0QIQE7UbeywRUFRbBU7L8WU3v61i1v+DR+JFOt7GUk84Q1BLpEICzgAWOuaFcuplxoH3cSWivmv7d9n1I4C2rI+urTMmQS/PZ56FtpFtxkRXNwmm5T4Vj6Emyl3BlFZwE1F0edw7PDDTQvSoCb2pRw3J3G86fZgFdmknCrgeDc7RxGCMKvfR+1hAao8JNBNCRueyXobZ1EY0zf688yzvBsVv3oS5Y41Mpb0jp6rZUAEt6ESOH38Ch1sCTsWyXh+540x5yOmeYf0rh7lu3Ssdp40AzImjqQuaWLZapDhzcM5sKlzg1hNP+zrIE8ssnpjYjb530VibAX2Gxgppjdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qXKLdN+z4HiWj2AatZhHeQ8Mlr9WKMwHeDyNZYeOx0=;
 b=BAa9ilaxkzOt4vfFFcH9GRv50uRK4TFHs6lsnO5OK2BJshSbVH2Ev6mHfVP5WwBREX1PuyXgzJ+I3VmRxnB2PM5OH9y7G7QWRNrb2Yh/pCePo0silmt/1Muq3aGShflXXvt5Upk7LHmocK8iaDD6n6xanv28QWfr7NZl2KyOyrXiI8ozBVrCLLyUJ4fX14JANpw/93jimMul5apIkYsLt7g1j/oH3y+tnfXQjvy+2RyMw8cV6QGxtvs/rYyuyXsZDiw62x3nKncgt6k+LmwAo8jDKD3K0ojtrxe+aloDf4qUrtc7TnJd+kx29VX4z5yWNSeGqU13HAxmMVmOTA2tMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=petaio.com; dmarc=pass action=none header.from=petaio.com;
 dkim=pass header.d=petaio.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT2018045.onmicrosoft.com;
 s=selector2-NETORGFT2018045-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qXKLdN+z4HiWj2AatZhHeQ8Mlr9WKMwHeDyNZYeOx0=;
 b=NiOnYVbgPTIvRd4E4qo5CsqA8D+xsyq4BU+bphjgg4hI8rY0PocSffXY3PWVD+93WRejMub7uTzneA50QKAfvH/1JUiNW+qWjkwzB4uVdzix5sdSpEWdCqYe21QooNOgzPSVKSP6BASaUlsLPJRUML8Lpnxux2VRMWuCtYLz9OI=
Received: from SJ0PR18MB5186.namprd18.prod.outlook.com (2603:10b6:a03:439::9)
 by SA1PR18MB4695.namprd18.prod.outlook.com (2603:10b6:806:1d6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Tue, 23 Jul
 2024 02:52:59 +0000
Received: from SJ0PR18MB5186.namprd18.prod.outlook.com
 ([fe80::e130:2c25:8cf2:4310]) by SJ0PR18MB5186.namprd18.prod.outlook.com
 ([fe80::e130:2c25:8cf2:4310%4]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 02:52:58 +0000
From: XueMei Yue <xuemeiyue@petaio.com>
To: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "joro@8bytes.org" <joro@8bytes.org>, Yi Liu
	<yi.l.liu@intel.com>
Subject:
 =?iso-2022-jp?B?Rlc6IEFib3V0ICB0aGUgcGF0Y2ggGyRCIUkbKEJodHRwczovL2xvcmUu?=
 =?iso-2022-jp?B?a2VybmVsLm9yZy9saW51eC1pb21tdS8yMDI0MDQxMjA4MjEyMS4zMzM4?=
 =?iso-2022-jp?B?Mi0xLXlpLmwubGl1QGludGVsLmNvbS8gGyRCIUgbKEIgZm9yIGhlbHAg?=
Thread-Topic:
 =?iso-2022-jp?B?QWJvdXQgIHRoZSBwYXRjaCAbJEIhSRsoQmh0dHBzOi8vbG9yZS5rZXJu?=
 =?iso-2022-jp?B?ZWwub3JnL2xpbnV4LWlvbW11LzIwMjQwNDEyMDgyMTIxLjMzMzgyLTEt?=
 =?iso-2022-jp?B?eWkubC5saXVAaW50ZWwuY29tLyAbJEIhSBsoQiBmb3IgaGVscCA=?=
Thread-Index: Adrb2PzAnn9b1I7oR6SOSXca54ByPAAy0fZw
Date: Tue, 23 Jul 2024 02:52:58 +0000
Message-ID:
 <SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
References:
 <SJ0PR18MB51863C8625058B9BB35D3EC1D3A82@SJ0PR18MB5186.namprd18.prod.outlook.com>
In-Reply-To:
 <SJ0PR18MB51863C8625058B9BB35D3EC1D3A82@SJ0PR18MB5186.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=petaio.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR18MB5186:EE_|SA1PR18MB4695:EE_
x-ms-office365-filtering-correlation-id: 4d3a6e87-e19c-49f4-b860-08dcaac28f88
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|38070700018|220923002;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?enluK3BTWkVsUWZJaXdPYVVDUEVBRHlqQlVrbWRQZXo4UU55VkR6aGpS?=
 =?iso-2022-jp?B?S0xXampRYkYyVmd1QUtyM1A0Z2s0Zk1LYUk5bkZLWTlRUThpWUpNZnVm?=
 =?iso-2022-jp?B?V0haRXVQcllqYzlyeHduSDJ2WVI1NWZEZkM0dzBLNDJ1YlBPVlZKREhi?=
 =?iso-2022-jp?B?Zkl0ZmIwUWR6ckxUOWhKQzUrL0ZZOGtUNWdoWnNITkZyTFVPN2NPNVFV?=
 =?iso-2022-jp?B?ZHdHQVovMXMvS3gwTEQ1U01pU1p6di9lelloSlg3RzJOUkVmYmM4Y0Ny?=
 =?iso-2022-jp?B?OTdIRHlLV0Z4NlhibmZhMnRJc3l1Z0RUVm5nMzJVQmVjb2pMRzFzVmov?=
 =?iso-2022-jp?B?b1hiUWpVdXJpVS9MdjZ6RlRUMm1WTlNVWmFacVp6Rm5jeGxGQS9DTytp?=
 =?iso-2022-jp?B?aGJtd1g2M3lvU2xoT0dvNEhPMjlqSGZsa3JrdWtqVTFNRXNZV1F5MlBK?=
 =?iso-2022-jp?B?eWJVcFZueUxIeDJYdzREY1NBalc3MmE4dlFpUXZXVis5RHR0TE1sdGdL?=
 =?iso-2022-jp?B?cXF2OTUrSDQzVFBWTkJyZ2V1SmdFNkJKc3FFa2RiRCt0RHRyTmF3bDlY?=
 =?iso-2022-jp?B?djNDS210VFI4cmVTMWNTaWFDVmx4SXFNL3hiR1k4emFZTTA1THlYOWNu?=
 =?iso-2022-jp?B?MHFSTW4ycWVTYVN6MFR4OGdYUjNFaWtHN0xSLytTcDFHR200dmRCQTFa?=
 =?iso-2022-jp?B?R0ZLWmZUa3E0VVgxaHo0ckJZRjd4bmNFSzlFdHhBRFVOMnBidEVIYTkx?=
 =?iso-2022-jp?B?RSs5QmtZdnBDcmI4Q1cvNVJoa1grZUN1TjRCU3h1YUxYRHdJK2syVUR4?=
 =?iso-2022-jp?B?QkJmenRMai9Kc0NiNUJYUEZwNDZzSU41elZWRWRLNlZ1VUI1dFZld2Zk?=
 =?iso-2022-jp?B?OUVvYy9HV1JKdTVQRlhjdzQ0c1F4TFFqWmIxeWF0Ylk4YWZvcnBwa1RT?=
 =?iso-2022-jp?B?VkNsYnF4RXhHWFV1c1ppUDExWFR5K1lQeXFEK05MUmpRZ09VRUtVTlpy?=
 =?iso-2022-jp?B?ODZPOVV1S0lXNUZEejU3SU9tMmRmVmdaQys3MjVVR0o1ZlZrdTVxNkxB?=
 =?iso-2022-jp?B?UEZGUU96WkVncHFmczY0ZUNTNUJIQmg4U2prUCs0TXVTeWxWbzYrc2p6?=
 =?iso-2022-jp?B?WlQzalY3TUt5Z3BSZVRQaysyL1FGRGVYOWh4NHdkNHlpQnU3RmxnRXoy?=
 =?iso-2022-jp?B?akFqWjdIczJYOHZ4eXZtUGZvN0NDMi95eWIweGFSQW9MZHlGRVFJU1ZR?=
 =?iso-2022-jp?B?cEhNRVBrbGtrVlkxYWhHSDB3VEkvYUJzbXpJV0s4K3p5aDV1cVc3Q21C?=
 =?iso-2022-jp?B?T2IybCttSzBBaGRXc01KS2E4aG5qVGx6VndodHRiTGxld00ycm9hYms3?=
 =?iso-2022-jp?B?VlJGNTh6bC9obEFuazBSeXl6aVhtWG5RZDJVd0IzM0hDbEdTblY5MnYr?=
 =?iso-2022-jp?B?UkdNV0dnRFdPOXp6Yk4zZnZHU1c3UEFjUENwZHZObDBuSHBQR0VVNFIx?=
 =?iso-2022-jp?B?aWM1NVdrR1haSXlQT2lSa2Raa0x1SmFzQ01RNEErWFVxZ0ZNRFpta3c1?=
 =?iso-2022-jp?B?eGh6NkJ1Qkk1K0loaVRhb3l0YzIxa3ZKbkRudGRXL3FYdFAvZDJtckdL?=
 =?iso-2022-jp?B?bGYrdlMrcW9TN2YycXJzeEJXb2NpQUxSc2M4ZnR1RzlJN3NDbzVrb1lv?=
 =?iso-2022-jp?B?enFUQ2FYQ2kwZnNsQXl6a1ArcEplWE9UZFczcElWTmtjYSs1U21nbGFv?=
 =?iso-2022-jp?B?Zi9tM282b0FGVktVYlZKRDJvTjZ6WWxzNk4wK1I1WVl5cTIzNXowUzQx?=
 =?iso-2022-jp?B?OEkyTHFtd0g2Z3VBMzNHenQxeEg3YlZYS2pTQlJFVTlsL0k0dG1FVUdk?=
 =?iso-2022-jp?B?WWpHMWZ2TEpSSE1ybXAxbTczTlBuTXRRcnRzbnJscFQ0eFFPV3BoYVdT?=
 =?iso-2022-jp?B?WVVJZ1V2TTlWQ3VwZjNtb0dla0FYVnMzbW03NUwwZENYaWIrL2ZKUDR0?=
 =?iso-2022-jp?B?YTBvR1pQYU05cmJXNTgveXAvNlJFM2E4UmhlS3o3bTFMVkp5UmlBalFD?=
 =?iso-2022-jp?B?SXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5186.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(38070700018)(220923002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?NzJqaHBQME9URFY5eUNOczh1TVFaamVNcWxzVEdxV1BheWVtaHFyQWxa?=
 =?iso-2022-jp?B?YkZ5amY1UUFNZlhHYW1LY084ZlAxL0ljQUtzQVpvUUlTeE9TbWJwOHdu?=
 =?iso-2022-jp?B?S2N3RU9nZUVXTGRyMmZFZkhvQzMvVHhKeGx2eXgxS1FIRDZWVWNOaTli?=
 =?iso-2022-jp?B?SC96QjJvdU1pRGhua0ZsVi9ycU9Sc0ZZT3VqR0xZRVVuZC91d3l0Ukl6?=
 =?iso-2022-jp?B?eWdTYS84b2lIQ3ExcUw1V1R4QWRqYXRVMi92UTVVVWpkWWxiL0pPZmNi?=
 =?iso-2022-jp?B?YmdaNXhkNVJOZzJaejA0UFM2WHZCK0E1TTdKL2hnNk9BMzMzUUpJTG1Q?=
 =?iso-2022-jp?B?eER0WFk3amRPRVNPaEdBSi9RL3Qranl5QWJhSHc1YlFsQ0hISnI0cTdO?=
 =?iso-2022-jp?B?TXZkeWdPbTd4L3RkSyszNEI0aFphRndYblF1M0dIdllDQmNxYW1mOXND?=
 =?iso-2022-jp?B?M0x1VWFIelFXYkJLcHBZRnk2RGlVT2NPYjYrbE16ZW9vNW5IRjA0NVAy?=
 =?iso-2022-jp?B?Y25mOGw4WHhxY2pVdm5qTkhKMTdLRWxLM1ZIY1lPK3JvQWJoSGdKc0JX?=
 =?iso-2022-jp?B?TFg5aGhSSnNSa0YxVzg0VHRMeXRjQXpaR3JKUGp6YnhyaGw1aUthWXRQ?=
 =?iso-2022-jp?B?YXBHT2g1VUk1VFYwcGk5c3FxbndrNmw0Z0p3QmlIZVVPV3Z3ZjlXQ04z?=
 =?iso-2022-jp?B?YjljUExMOG1sUmp6alNqcUVML2FIUlVpcVM1cDhRL3p1Y3FFMnJPbVhK?=
 =?iso-2022-jp?B?MWQvL1VoMkV6enRUSko3U09hNzc5ZFB3YnZBNVZJWU41bFQrNkIycEdP?=
 =?iso-2022-jp?B?eU9aREpWanZnUldwdnI2UDFvbE90WmxBYkRoWlRXTmxiWjM4UFZ4aU9F?=
 =?iso-2022-jp?B?cXJ2K1Q3dXpuaTV4aTJ4M2JRQlIxV3VpY0F0UFdOTG5YcFNLMHhJNVZE?=
 =?iso-2022-jp?B?OXZwVHhNQU1ubkdxUFVPQ1Z2NUNEcEZPNnlmekRDT3RieHRvT3BXbWJy?=
 =?iso-2022-jp?B?dkpZdmZteE95ZDB6L1JEV2pMU21BNnQ5SnZPelJ3aWtRT1NQbk1ramwy?=
 =?iso-2022-jp?B?bXVIQ0RkdzFjOFF5NVJwSGJRRG0ycFNHdXU3V0k2NE40Y1lZUVd1cDlT?=
 =?iso-2022-jp?B?V2gxTkVxZ3VYZENLNU5OYzAvNFdHc0R0Vy94WU1VVk13RFpaQnpENUlq?=
 =?iso-2022-jp?B?aGszUDFCVWxJZGFjeHlUK09VRi9JT3l2SU1nTHdJd2RDcEpsKy95RXpU?=
 =?iso-2022-jp?B?b2ZhNkJBQ1dJN24xTGVVb2huWFl1ajhyMFEwekNDeDhyS1JZclJhbGtX?=
 =?iso-2022-jp?B?Njcrd1U1cytrS2NDbWc5NGNGMWcxUmNFaWNjelNNYTBBa3ROOVk2enMw?=
 =?iso-2022-jp?B?emRzb1BBbUNGeExudGhNK2pVUFpJMFlLMWlRZkoxQi80ZzhCRGwzbnFF?=
 =?iso-2022-jp?B?Vm4xOXNYcUpXclhxUEZMTFJhdDVjeHZodXlJdzhxeEpQYjhxanBJeEll?=
 =?iso-2022-jp?B?cnZvS3N4TkdySmN3R09WT1I3SlJBY3BtTjdZMkg4SklPWDRORnNKTWdB?=
 =?iso-2022-jp?B?Njh1L1VzSUR2V0Y1bjZVWnM5eVphdlFFZ0dKdHlMMzBYckhvQnVQOExv?=
 =?iso-2022-jp?B?NlVnSFJDUWVXS2JCWVJ6VUNCRHlYN21DQXBreVE4ckhUTGtPNEo4eG4v?=
 =?iso-2022-jp?B?Y1lNWU4xWEZRWmdHeW03SGEzYzZmZzN4OUxrem9tZFEwUFU1YWwvbFRr?=
 =?iso-2022-jp?B?cFU0QXc2UWhlaUlUOUZiZTQzMkhWNzk1Z014d1hFdlM3UnRJUVZnQ2Ja?=
 =?iso-2022-jp?B?MytuWjJWd3g3cjBRMzJYRk1ua2pFSVdWVDJoWWQ1R2dzanNmTk9aV2hS?=
 =?iso-2022-jp?B?L1gxSWVublRtU2lRTmc5NUM1N1FuZ2Fkdy9EU3ZuT0U3WWdoZFZsOXEv?=
 =?iso-2022-jp?B?dVliSWJJR1hPc3FDSzF0V1FDZ3IvNXdobjZ5QndiODB4bDhZa0lTRUJY?=
 =?iso-2022-jp?B?WTkxSEVjRFd1Sk5Wc2tReUsydWk1TSszNkRqODZsQkw1RUFmdkFiVkRT?=
 =?iso-2022-jp?B?bHNPTkt5SG1hS00vWGFWWnBmdStFK1hUZi80di9BUVNqVDZsUkpTV1g1?=
 =?iso-2022-jp?B?RGxsUEN2L01LbndUaUZsZ2x6QnFVZkRucHptaVkyRW9ocmxJcDFLZG91?=
 =?iso-2022-jp?B?ckFzck1VcjZiazI0MmVUYUlwVmsrRllmSTFsV01GNTlHd25oOFlsQmVa?=
 =?iso-2022-jp?B?YiswNmcrNnh5WnBBN2xUTXRLblQrVHc3Rkt0TnFmdHdXc1pIaVNEdnBj?=
 =?iso-2022-jp?B?QW9KOA==?=
Content-Type: multipart/mixed;
	boundary="_008_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: petaio.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5186.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3a6e87-e19c-49f4-b860-08dcaac28f88
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2024 02:52:58.8135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a0ba8444-51d8-486a-8d00-37e5c68c7634
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LYac7l/jr5dBV8RM6XshxliEeR57pM+Vp+RZcO2oI3pSWNKESvYNxiWrNN0tYHus26s5gSAH95lKc+jg8ne8IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB4695

--_008_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_
Content-Type: multipart/related;
	boundary="_007_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_";
	type="multipart/alternative"

--_007_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_
Content-Type: multipart/alternative;
	boundary="_000_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_"

--_000_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable

DEAR ALL ,

No  I  have know the root cause ,  the issue  ouccured when below code run =
my AMD test PC.

So  could you guys  give  some suggestion ?  Will very much appreciate if y=
ou feel free to reply=1B$B!*!*=1B(B

[cid:image001.png@01DADCEE.6F2E3F80]

From: XueMei Yue
Sent: 2024=1B$BG/=1B(B7=1B$B7n=1B(B22=1B$BF|=1B(B 9:50
To: yi.l.liu@intel.com
Subject: About the patch =1B$B!I=1B(Bhttps://lore.kernel.org/linux-iommu/20=
240412082121.33382-1-yi.l.liu@intel.com/ =1B$B!H=1B(B for help


hi,

I am an firmware engineer from china . I want to test the function ATS that=
 need the support of =1B$B!H=1B(Biommufd+pasid=1B$B!I=1B(B

Now I will test some new function =1B$B!$=1B(Bwill use pasid +  iommufd=1B$=
B!$=1B(B

i used your patch from  https://lore.kernel.org/linux-iommu/20240412082121.=
33382-1-yi.l.liu@intel.com/

my test step is

1  use spdk =1B$B!$=1B(B  run   ./scripts/setup,  the nvme device drive is =
changed from nvme to vfio-pci

2  run my example =1B$B!$=1B(Bsee the attchment =1B$B!$=1B(Busing g++ to co=
mpile

when run my  example . the below error occurs =1B$B!$=1B(Bcould you give so=
me suggestion =1B$B!)=1B(B
[cid:image004.png@01DADCEE.6F6C59F0][[ root@hippo ./iommufd.o  Program ./io=
mmufd.o  the map va is : 7fe866435OOO, the iova is O, the size is 1048576  =
VFIO DEVICE PASID ATTACH IOMMUFD PT failed! error is operation not supporte=
d  [rooQ@hippo xuemei]#]
Will very much appreciate if you feel free to reply=1B$B!*!*=1B(B

Best regards
XueMei


--_000_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_
Content-Type: text/html; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:m=3D"http://sc=
hemas.microsoft.com/office/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-=
html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-2022-=
jp">
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:DengXian;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"\@DengXian";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Microsoft YaHei";
	panose-1:2 11 5 3 2 2 4 2 2 4;}
@font-face
	{font-family:"\@Microsoft YaHei";}
@font-face
	{font-family:"\@SimSun";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"MS PGothic";
	panose-1:2 11 6 0 7 2 5 8 2 4;}
@font-face
	{font-family:"\@MS PGothic";}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	font-size:11.0pt;
	font-family:DengXian;
	mso-ligatures:standardcontextual;
	mso-fareast-language:JA;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#467886;
	text-decoration:underline;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:DengXian;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;
	mso-ligatures:none;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1027" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"ZH-CN" link=3D"#467886" vlink=3D"#96607D" style=3D"word-wrap:=
break-word;text-justify-trim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN">DEAR ALL ,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN">No &nbsp;I&nbsp; have know the root cause ,&nbsp; the issue &nbsp;ouc=
cured when below code run my AMD test PC.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN">So &nbsp;could you guys&nbsp; give &nbsp;some suggestion ? &nbsp;</sp=
an><span lang=3D"EN-US" style=3D"mso-fareast-language:ZH-CN">Will very much=
 appreciate if you feel free to reply</span><span style=3D"mso-fareast-lang=
uage:ZH-CN">=1B$B!*!*=1B(B<span lang=3D"EN-US"><o:p></o:p></span></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-ligatures:none;mso=
-fareast-language:ZH-CN"><img width=3D"594" height=3D"284" style=3D"width:6=
.1833in;height:2.9583in" id=3D"Picture_x0020_3" src=3D"cid:image001.png@01D=
ADCEE.6F2E3F80"></span><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN"><o:p>&nbsp;</o:p></span></p>
<div>
<div style=3D"border:none;border-top:solid #E1E1E1 1.0pt;padding:3.0pt 0cm =
0cm 0cm">
<p class=3D"MsoNormal"><b><span lang=3D"EN-US" style=3D"font-family:&quot;C=
alibri&quot;,sans-serif;mso-ligatures:none">From:</span></b><span lang=3D"E=
N-US" style=3D"font-family:&quot;Calibri&quot;,sans-serif;mso-ligatures:non=
e"> XueMei Yue
<br>
<b>Sent:</b> 2024</span><span lang=3D"JA" style=3D"font-family:&quot;MS PGo=
thic&quot;,sans-serif;mso-ligatures:none">=1B$BG/=1B(B</span><span lang=3D"=
EN-US" style=3D"font-family:&quot;Calibri&quot;,sans-serif;mso-ligatures:no=
ne">7</span><span lang=3D"JA" style=3D"font-family:&quot;MS PGothic&quot;,s=
ans-serif;mso-ligatures:none">=1B$B7n=1B(B</span><span lang=3D"EN-US" style=
=3D"font-family:&quot;Calibri&quot;,sans-serif;mso-ligatures:none">22</span=
><span lang=3D"JA" style=3D"font-family:&quot;MS PGothic&quot;,sans-serif;m=
so-ligatures:none">=1B$BF|=1B(B</span><span lang=3D"EN-US" style=3D"font-fa=
mily:&quot;Calibri&quot;,sans-serif;mso-ligatures:none">
 9:50<br>
<b>To:</b> yi.l.liu@intel.com<br>
<b>Subject:</b> About the patch =1B$B!I=1B(Bhttps://lore.kernel.org/linux-i=
ommu/20240412082121.33382-1-yi.l.liu@intel.com/ =1B$B!H=1B(B for help
<o:p></o:p></span></p>
</div>
</div>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p style=3D"margin:0cm;background:white"><span lang=3D"EN-US" style=3D"font=
-size:10.5pt;font-family:&quot;Microsoft YaHei&quot;,sans-serif;color:#2E30=
33;mso-fareast-language:ZH-CN">hi,&nbsp;<o:p></o:p></span></p>
<p style=3D"margin:0cm;background:white"><span lang=3D"EN-US" style=3D"font=
-size:10.5pt;font-family:&quot;Microsoft YaHei&quot;,sans-serif;color:#2E30=
33;mso-fareast-language:ZH-CN">I am an firmware engineer from china . I wan=
t to test the function ATS that need the support
 of </span><span style=3D"font-size:10.5pt;font-family:&quot;Microsoft YaHe=
i&quot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">=1B$B!H=1B(B<s=
pan lang=3D"EN-US">iommufd+pasid</span>=1B$B!I=1B(B
<span lang=3D"EN-US"><o:p></o:p></span></span></p>
<p style=3D"margin:0cm;background:white;font-variant-ligatures: normal;font=
-variant-caps: normal;orphans: 2;text-align:start;widows: 2;-webkit-text-st=
roke-width: 0px;text-decoration-thickness: initial;text-decoration-style: i=
nitial;text-decoration-color: initial;word-spacing:0px">
<span lang=3D"EN-US" style=3D"font-size:10.5pt;font-family:&quot;Microsoft =
YaHei&quot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">Now I will=
 test some new function
</span><span style=3D"font-size:10.5pt;font-family:&quot;Microsoft YaHei&qu=
ot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">=1B$B!$=1B(B<span =
lang=3D"EN-US">will use pasid + &nbsp;iommufd</span>=1B$B!$=1B(B<span lang=
=3D"EN-US"><o:p></o:p></span></span></p>
<p style=3D"margin:0cm;background:white"><span lang=3D"EN-US" style=3D"font=
-size:10.5pt;font-family:&quot;Microsoft YaHei&quot;,sans-serif;color:#2E30=
33;mso-fareast-language:ZH-CN">i used your patch from&nbsp;&nbsp;<a href=3D=
"https://lore.kernel.org/linux-iommu/20240412082121.33382-1-yi.l.liu@intel.=
com/" target=3D"_blank"><span style=3D"color:#4A90E2">https://lore.kernel.o=
rg/linux-iommu/20240412082121.33382-1-yi.l.liu@intel.com/</span></a><o:p></=
o:p></span></p>
<p style=3D"margin:0cm;background:white;font-variant-ligatures: normal;font=
-variant-caps: normal;orphans: 2;text-align:start;widows: 2;-webkit-text-st=
roke-width: 0px;text-decoration-thickness: initial;text-decoration-style: i=
nitial;text-decoration-color: initial;word-spacing:0px">
<span lang=3D"EN-US" style=3D"font-size:10.5pt;font-family:&quot;Microsoft =
YaHei&quot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">my test st=
ep is&nbsp;<o:p></o:p></span></p>
<p style=3D"margin:0cm;background:white;font-variant-ligatures: normal;font=
-variant-caps: normal;orphans: 2;text-align:start;widows: 2;-webkit-text-st=
roke-width: 0px;text-decoration-thickness: initial;text-decoration-style: i=
nitial;text-decoration-color: initial;word-spacing:0px">
<span lang=3D"EN-US" style=3D"font-size:10.5pt;font-family:&quot;Microsoft =
YaHei&quot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">1&nbsp; us=
e spdk
</span><span style=3D"font-size:10.5pt;font-family:&quot;Microsoft YaHei&qu=
ot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">=1B$B!$=1B(B<span =
lang=3D"EN-US">&nbsp;&nbsp;<span style=3D"background:white">run&nbsp;</span=
>&nbsp;&nbsp;./scripts/setup,&nbsp; the nvme device drive is changed from n=
vme to vfio-pci&nbsp;<o:p></o:p></span></span></p>
<p style=3D"margin:0cm;background:white;font-variant-ligatures: normal;font=
-variant-caps: normal;orphans: 2;text-align:start;widows: 2;-webkit-text-st=
roke-width: 0px;text-decoration-thickness: initial;text-decoration-style: i=
nitial;text-decoration-color: initial;word-spacing:0px">
<span lang=3D"EN-US" style=3D"font-size:10.5pt;font-family:&quot;Microsoft =
YaHei&quot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">2 &nbsp;ru=
n my example
</span><span style=3D"font-size:10.5pt;font-family:&quot;Microsoft YaHei&qu=
ot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">=1B$B!$=1B(B<span =
lang=3D"EN-US">see the attchment&nbsp;</span>=1B$B!$=1B(B<span lang=3D"EN-U=
S">using g++ to compile<o:p></o:p></span></span></p>
<p style=3D"margin:0cm;background:white;font-variant-ligatures: normal;font=
-variant-caps: normal;orphans: 2;text-align:start;widows: 2;-webkit-text-st=
roke-width: 0px;text-decoration-thickness: initial;text-decoration-style: i=
nitial;text-decoration-color: initial;word-spacing:0px">
<span lang=3D"EN-US" style=3D"font-size:10.5pt;font-family:&quot;Microsoft =
YaHei&quot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">when run m=
y&nbsp; example . the below error occurs
</span><span style=3D"font-size:10.5pt;font-family:&quot;Microsoft YaHei&qu=
ot;,sans-serif;color:#2E3033;mso-fareast-language:ZH-CN">=1B$B!$=1B(B<span =
lang=3D"EN-US">could you give some suggestion
</span>=1B$B!)=1B(B<span lang=3D"EN-US"><o:p></o:p></span></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span lang=3D"EN-US" styl=
e=3D"color:black"><!--[if gte vml 1]><v:shapetype id=3D"_x0000_t75" coordsi=
ze=3D"21600,21600" o:spt=3D"75" o:preferrelative=3D"t" path=3D"m@4@5l@4@11@=
9@11@9@5xe" filled=3D"f" stroked=3D"f">
<v:stroke joinstyle=3D"miter" />
<v:formulas>
<v:f eqn=3D"if lineDrawn pixelLineWidth 0" />
<v:f eqn=3D"sum @0 1 0" />
<v:f eqn=3D"sum 0 0 @1" />
<v:f eqn=3D"prod @2 1 2" />
<v:f eqn=3D"prod @3 21600 pixelWidth" />
<v:f eqn=3D"prod @3 21600 pixelHeight" />
<v:f eqn=3D"sum @0 0 1" />
<v:f eqn=3D"prod @6 1 2" />
<v:f eqn=3D"prod @7 21600 pixelWidth" />
<v:f eqn=3D"sum @8 21600 0" />
<v:f eqn=3D"prod @7 21600 pixelHeight" />
<v:f eqn=3D"sum @10 21600 0" />
</v:formulas>
<v:path o:extrusionok=3D"f" gradientshapeok=3D"t" o:connecttype=3D"rect" />
<o:lock v:ext=3D"edit" aspectratio=3D"t" />
</v:shapetype><v:shape id=3D"Rectangle_x0020_1" o:spid=3D"_x0000_s1026" typ=
e=3D"#_x0000_t75" style=3D'width:24pt;height:24pt;visibility:visible;mso-le=
ft-percent:-10001;mso-top-percent:-10001;mso-position-horizontal:absolute;m=
so-position-horizontal-relative:char;mso-position-vertical:absolute;mso-pos=
ition-vertical-relative:line;mso-left-percent:-10001;mso-top-percent:-10001=
'>
<w:wrap type=3D"none"/>
<w:anchorlock/>
</v:shape><![endif]--><![if !vml]><img width=3D"32" height=3D"32" style=3D"=
width:.3333in;height:.3333in" src=3D"cid:image004.png@01DADCEE.6F6C59F0" v:=
shapes=3D"Rectangle_x0020_1"><![endif]></span><span lang=3D"EN-US" style=3D=
"font-size:10.5pt;font-family:&quot;Microsoft YaHei&quot;,sans-serif;color:=
#2E3033;mso-ligatures:none;mso-fareast-language:ZH-CN"><img border=3D"0" wi=
dth=3D"643" height=3D"86" style=3D"width:6.7in;height:.9in" id=3D"Picture_x=
0020_2" src=3D"cid:image002.png@01DADC1C.816A3FF0" alt=3D"[ root@hippo ./io=
mmufd.o =0A=
Program ./iommufd.o =0A=
the map va is : 7fe866435&Oslash;&Oslash;&Oslash;, the iova is O, the size =
is 1048576 =0A=
VFIO DEVICE PASID ATTACH IOMMUFD PT failed! error is operation not supporte=
d =0A=
[rooQ@hippo xuemei]# "></span><span lang=3D"EN-US" style=3D"font-size:10.5p=
t;font-family:&quot;Microsoft YaHei&quot;,sans-serif;color:#2E3033;mso-fare=
ast-language:ZH-CN"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN">Will very much appreciate if you feel free to reply</span><span style=
=3D"mso-fareast-language:ZH-CN">=1B$B!*!*=1B(B
<span lang=3D"EN-US"><o:p></o:p></span></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN">Best regards
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN">XueMei<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"mso-fareast-language:Z=
H-CN"><o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--_000_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_--

--_007_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_
Content-Type: image/png; name="image002.png"
Content-Description: image002.png
Content-Disposition: inline; filename="image002.png"; size=8499;
	creation-date="Mon, 22 Jul 2024 01:50:04 GMT";
	modification-date="Tue, 23 Jul 2024 02:52:57 GMT"
Content-ID: <image002.png@01DADC1C.816A3FF0>
Content-Transfer-Encoding: base64

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
TkSuQmCC

--_007_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_
Content-Type: image/png; name="image001.png"
Content-Description: image001.png
Content-Disposition: inline; filename="image001.png"; size=37770;
	creation-date="Tue, 23 Jul 2024 02:52:57 GMT";
	modification-date="Tue, 23 Jul 2024 02:52:57 GMT"
Content-ID: <image001.png@01DADCEE.6F2E3F80>
Content-Transfer-Encoding: base64

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

--_007_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_
Content-Type: image/png; name="image004.png"
Content-Description: image004.png
Content-Disposition: inline; filename="image004.png"; size=177;
	creation-date="Tue, 23 Jul 2024 02:52:58 GMT";
	modification-date="Tue, 23 Jul 2024 02:52:58 GMT"
Content-ID: <image004.png@01DADCEE.6F6C59F0>
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAMAAAC7IEhfAAAAAXNSR0ICQMB9xQAAAANQTFRFAAAA
p3o92gAAAAF0Uk5TAEDm2GYAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAAAZdEVYdFNvZnR3YXJlAE1p
Y3Jvc29mdCBPZmZpY2V/7TVxAAAAFUlEQVQ4y2NgGAWjYBSMglEwCmgHAAZoAAE5et71AAAAAElF
TkSuQmCC

--_007_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_--

--_008_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_
Content-Type: text/plain; name="iommufd0716.cpp"
Content-Description: iommufd0716.cpp
Content-Disposition: attachment; filename="iommufd0716.cpp"; size=5775;
	creation-date="Mon, 22 Jul 2024 01:43:27 GMT";
	modification-date="Tue, 23 Jul 2024 02:52:56 GMT"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHN0ZGludC5o
PgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxsaW51eC92ZmlvLmg+CiNpbmNsdWRlIDxp
bnR0eXBlcy5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVk
ZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4KI2luY2x1ZGUgPHN5cy9tbWFuLmg+
CiNpbmNsdWRlIDxzdHJpbmc+CiNpbmNsdWRlIDxpb3N0cmVhbT4KI2luY2x1ZGUgPGNzdHJpbmc+
CiNpbmNsdWRlIDxsaW51eC9pb21tdWZkLmg+CiAKc3RydWN0IGFyZ3MKewoJX191NjQJaW92YTsJ
CQkJLyogSU8gdmlydHVhbCBhZGRyZXNzICovCglfX3U2NAlzaXplOwoJc3RkOjpzdHJpbmcgdmZp
b1g7CglzdGQ6OnN0cmluZyBiZGY7Cgp9OwppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltd
KSAKewogICAgaW50IHJldCA9IDA7CglpbnQgY2Rldl9mZCwgaW9tbXVmZCwgaTsKCQogICAgc3Rk
Ojpjb3V0IDw8ICJQcm9ncmFtIG5hbWU6ICIgPDwgYXJndlswXSA8PCBzdGQ6OmVuZGw7CgkJc3Ry
dWN0IGFyZ3MgcGFyYT17MH07CiAgICBmb3IgKGludCBpID0gMTsgaSA8IGFyZ2M7ICsraSkgCgl7
CgkKICAgICAgICBzdGQ6OmNvdXQgPDwgIkFyZ3VtZW50ICIgPDwgaSA8PCAiOiAiIDw8IGFyZ3Zb
aV0gPDwgc3RkOjplbmRsOwoJCWlmKCFzdGQ6OnN0cmNtcChhcmd2W2ldLCAiLWhlbHAiKSkKCQl7
CgkJICAgIHByaW50ZigiLWlvdmE6ICAgICAgICAgaW5wdXQgdGhlIG1hcCBhZGRyZXNzIGlvdmFc
biIpOwoJCQlwcmludGYoIi1zaXplOiAgICAgICAgIGlucHV0IHRoZSBOdW1iZXIgb2YgYnl0ZXMg
dG8gY29weSBhbmQgbWFwXG4iKTsKCQkJcHJpbnRmKCItZGV2aWNlOiAgICAgICBpbnB1dCB0aGUg
YmRmXG4iKTsKCQkJcHJpbnRmKCItdmZpbyAgOiAgICAgICBpbnB1dCB0aGUgdmZpb1hcbiIpOwoJ
CQlyZXR1cm4gMDsJCgkJfQoJCWlmKCFzdGQ6OnN0cmNtcChhcmd2W2ldLCAiLWlvdmEiKSkKCQl7
CgkJCWkrKzsKCQkJY2hhciAqYWRkcmVzcyA9IGFyZ3ZbaV07CgkJCXNzY2FuZihhZGRyZXNzLCAi
JSIgU0NOeDY0LCAmcGFyYS5pb3ZhKTsKCQkJcHJpbnRmKCJUaGUgYWRkcmVzcyBpczogJSIgUFJJ
eDY0ICJcbiIsIHBhcmEuaW92YSk7CgkJfQoJCWlmKCFzdGQ6OnN0cmNtcChhcmd2W2ldLCAiLXNp
emUiKSkKCQl7CgkJICAgIGkrKzsKCQkJcGFyYS5zaXplID0gYXRvaShhcmd2W2ldKTsKICAgICAg
ICAgICAgc3RkOjpjb3V0IDw8ICJ0aGUgc2l6ZSBpcyAiPDwgcGFyYS5zaXplIDw8IHN0ZDo6ZW5k
bDsKCQl9CgkJaWYoIXN0ZDo6c3RyY21wKGFyZ3ZbaV0sICItdmZpbyIpKQoJCXsKCQkgIAlpKys7
CgkJCXBhcmEudmZpb1ggPSBhcmd2W2ldOwogICAgICAgICAgICBzdGQ6OmNvdXQgPDwgInZmaW9Y
IGlzICI8PCBwYXJhLnZmaW9YIDw8IHN0ZDo6ZW5kbDsKCgkJfQogICAgICAgIGlmKCFzdGQ6OnN0
cmNtcChhcmd2W2ldICwgICItZGV2aWNlIikpCgkJewoJCSAgICBpKys7CgkJCWNoYXIgKmlucHV0
X3N0cmluZyA9IGFyZ3ZbaV07CgkJCXBhcmEuYmRmID0gaW5wdXRfc3RyaW5nIDsKCQl9CgkJCQog
ICAgfQoJCgkKCXN0cnVjdCB2ZmlvX2RldmljZV9iaW5kX2lvbW11ZmQgYmluZCA9IHsKICAgICAg
ICAuYXJnc3ogPSBzaXplb2YoYmluZCksCiAgICAgICAgLmZsYWdzID0gMCwKICAgIH07CiAgICAg
c3RydWN0IGlvbW11X2lvYXNfYWxsb2MgYWxsb2NfZGF0YSAgPSB7CiAgICAgICAgLnNpemUgPSBz
aXplb2YoYWxsb2NfZGF0YSksCiAgICAgICAgLmZsYWdzID0gMCwKICAgICB9OwogICAgIHN0cnVj
dCB2ZmlvX2RldmljZV9hdHRhY2hfaW9tbXVmZF9wdCBhdHRhY2hfZGF0YSA9IHsKICAgICAgICAu
YXJnc3ogPSBzaXplb2YoYXR0YWNoX2RhdGEpLAogICAgICAgIC5mbGFncyA9IDAsCiAgICAgfTsK
ICAgIHN0cnVjdCBpb21tdV9pb2FzX21hcCBtYXAgPSB7CiAgICAgICAgLnNpemUgPSBzaXplb2Yo
bWFwKSwKICAgICAgICAuZmxhZ3MgPSBJT01NVV9JT0FTX01BUF9SRUFEQUJMRSB8CiAgICAgICAg
ICAgICAgICAgSU9NTVVfSU9BU19NQVBfV1JJVEVBQkxFIHwKICAgICAgICAgICAgICAgICBJT01N
VV9JT0FTX01BUF9GSVhFRF9JT1ZBLAogICAgICAgIC5fX3Jlc2VydmVkID0gMCwKICAgIH07Cglz
dHJ1Y3QgaW9tbXVfaW9hc191bm1hcCB1bm1hcCA9IHsKCQkuc2l6ZSA9IHNpemVvZih1bm1hcCks
Cgl9OwoJc3RydWN0IHZmaW9fZGV2aWNlX3Bhc2lkX2F0dGFjaF9pb21tdWZkX3B0IHBhc2lkID0g
ewoJCS5hcmdzeiA9IHNpemVvZihwYXNpZCksCiAgICAgICAgLmZsYWdzID0gMCwKCX07CgkKCXN0
cnVjdCB2ZmlvX2RldmljZV9wYXNpZF9kZXRhY2hfaW9tbXVmZF9wdCBkZXRhY2hfcGFzaWQgPSB7
CgkJLmFyZ3N6ID0gc2l6ZW9mKGRldGFjaF9wYXNpZCksCiAgICAgICAgLmZsYWdzID0gMCwKCX07
CgoKICAgIC8qIE9wZW4gdGhlIGdyb3VwICovCiAgICBzdGQ6OnN0cmluZyB2ZmlvOwogICAgaWYo
IXBhcmEudmZpb1guZW1wdHkoKSkKICAgIHsKCSAgICB2ZmlvID0gIi9kZXYvdmZpby9kZXZpY2Vz
LyIgKyBwYXJhLnZmaW9YOwogICAgfQogICAgZWxzZSAKICAgIHsKICAgICAgICB2ZmlvID0gIi9k
ZXYvdmZpby9kZXZpY2VzL3ZmaW8wIjsKICAgIH0KICAgIGNkZXZfZmQgPSBvcGVuKHZmaW8uY19z
dHIoKSwgT19SRFdSKTsKICAgIGlvbW11ZmQgPSBvcGVuKCIvZGV2L2lvbW11IiwgT19SRFdSKTsK
CiAgICBpZiAoY2Rldl9mZCA8IDAgfHwgaW9tbXVmZCA8MCkgCiAgICB7CgkgICAgLyogaWYgZmls
ZSBub3QgZm91bmQsIGl0J3Mgbm90IGFuIGVycm9yICovCgkgICAgaWYgKGVycm5vICE9IEVOT0VO
VCkgCgkJewoJICAgICAgICBzdGQ6OmNvdXQgPDwgIkNhbm5vdCBvcGVuICI8PCBpb21tdWZkICA8
PCAiIG9yICAiPDwgY2Rldl9mZCA8PCIgLCBlcnJvciBpcyA6ICIgPDwgIHN0cmVycm9yKGVycm5v
KTsKCSAgICAgICAgcmV0dXJuIC0xOwoJICAgIH0gCiAgICB9CiAgICBiaW5kLmlvbW11ZmQgPSBp
b21tdWZkOwoKICAgIGlmKGlvY3RsKGNkZXZfZmQsIFZGSU9fREVWSUNFX0JJTkRfSU9NTVVGRCwg
JmJpbmQpKQogICAgewoJc3RkOjpjb3V0IDw8ICJWRklPX0RFVklDRV9CSU5EX0lPTU1VRkQgZmFp
bGVkISAiPDxzdHJlcnJvcihlcnJubyk8PHN0ZDo6ZW5kbDsKICAgICAgICByZXR1cm4gMTsKICAg
IH0KCiAgICBpZihpb2N0bChpb21tdWZkLCBJT01NVV9JT0FTX0FMTE9DLCAmYWxsb2NfZGF0YSkp
CiAgICB7CiAgICAgICAgc3RkOjpjb3V0IDw8ICJJT01NVV9JT0FTX0FMTE9DIGZhaWxlZCEgIjw8
IHN0cmVycm9yKGVycm5vKSA8PCBzdGQ6OmVuZGwgOwogICAgICAgIHJldHVybiAxOwogICAgfQoJ
CiAgICBhdHRhY2hfZGF0YS5wdF9pZCA9IGFsbG9jX2RhdGEub3V0X2lvYXNfaWQ7CiAgICBpZihp
b2N0bChjZGV2X2ZkLCBWRklPX0RFVklDRV9BVFRBQ0hfSU9NTVVGRF9QVCwgJmF0dGFjaF9kYXRh
KSkKICAgIHsKCXN0ZDo6Y291dCA8PCAiVkZJT19ERVZJQ0VfQVRUQUNIX0lPTU1VRkRfUFQgZmFp
bGVkISAiPDwgc3RkOjplbmRsOwogICAgICAgIHJldHVybiAxOwogICAgfQoKICAgIC8qIEFsbG9j
YXRlIHNvbWUgc3BhY2UgYW5kIHNldHVwIGEgRE1BIG1hcHBpbmcgKi8KCQoJbWFwLmxlbmd0aCA9
IDEwMjQgKiAxMDI0OwogICAgbWFwLmlvdmEgPSAwOyAvKiAxTUIgc3RhcnRpbmcgYXQgMHgwIGZy
b20gZGV2aWNlIHZpZXcgKi8KCWlmKHBhcmEuc2l6ZSkKICAgIHsKCSAgICBtYXAubGVuZ3RoID0g
cGFyYS5zaXplOyAKICAgIH0KICAgIGlmKHBhcmEuaW92YSE9IG1hcC5pb3ZhKQogICAgewoJICAg
IG1hcC5pb3ZhID0gcGFyYS5pb3ZhOyAgLyogMU1CIHN0YXJ0aW5nIGF0IDB4MCBmcm9tIGRldmlj
ZSB2aWV3ICovCiAgICB9CiAgICBtYXAudXNlcl92YSA9IChpbnQ2NF90KW1tYXAoMCwgbWFwLmxl
bmd0aCwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwKICAgICAgICAgICAgICAgICAgICAgICAgICAg
IE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9VUywgMCwgMCk7CgogICAgbWFwLmlvYXNfaWQgPSBh
bGxvY19kYXRhLm91dF9pb2FzX2lkOwoKICAgIHByaW50ZigidGhlIG1hcCB2YSBpcyA6ICVsbHgs
dGhlIGlvdmEgaXMgJSBsbHgsdGhlIHNpemUgaXMgJWRcbiIsbWFwLnVzZXJfdmEsbWFwLmlvdmEs
bWFwLmxlbmd0aCk7CiAgICBpZihpb2N0bChpb21tdWZkLCBJT01NVV9JT0FTX01BUCwgJm1hcCkp
CiAgICB7CglzdGQ6OmNvdXQgPDwgIklPTU1VX0lPQVNfTUFQIGZhaWxlZCEgIjw8IHN0ZDo6ZW5k
bDsKICAgICAgICByZXR1cm4gMTsKICAgIH0KCiAgICAvKmF0dGFjaEFzc29jaWF0ZSBhIHBhc2lk
IChvZiBhIGNkZXYgZGV2aWNlKSB3aXRoIGFuIGFkZHJlc3Mgc3BhY2Ugd2l0aGluIHRoZSBib3Vu
ZCBpb21tdWZkKi8KICAgIHBhc2lkLnBhc2lkID0gMDsKICAgIHBhc2lkLnB0X2lkID0gYWxsb2Nf
ZGF0YS5vdXRfaW9hc19pZDsKICAgIGlmKGlvY3RsKGNkZXZfZmQsIFZGSU9fREVWSUNFX1BBU0lE
X0FUVEFDSF9JT01NVUZEX1BULCAmcGFzaWQpKQogICAgewoJc3RkOjpjb3V0IDw8ICJWRklPX0RF
VklDRV9QQVNJRF9BVFRBQ0hfSU9NTVVGRF9QVCBmYWlsZWQhIGVycm9yIGlzICI8PHN0cmVycm9y
KGVycm5vKTw8IHN0ZDo6ZW5kbDsKICAgICAgICByZXR1cm4gMTsKICAgIH0KICAgICAvKmF0dGFj
aEFzc29jaWF0ZSBhIHBhc2lkIChvZiBhIGNkZXYgZGV2aWNlKSB3aXRoIGFuIGFkZHJlc3Mgc3Bh
Y2Ugd2l0aGluIHRoZSBib3VuZCBpb21tdWZkKi8KICAgIHBhc2lkLnBhc2lkID0gMTsKICAgIHBh
c2lkLnB0X2lkID0gYWxsb2NfZGF0YS5vdXRfaW9hc19pZDsKICAgIGlmKGlvY3RsKGNkZXZfZmQs
IFZGSU9fREVWSUNFX1BBU0lEX0FUVEFDSF9JT01NVUZEX1BULCAmcGFzaWQpKQogICAgewogICAg
ICAgIHN0ZDo6Y291dCA8PCAiVkZJT19ERVZJQ0VfUEFTSURfQVRUQUNIX0lPTU1VRkRfUFQgZmFp
bGVkISAiPDwgc3RkOjplbmRsOwogICAgICAgIHJldHVybiAxOwogICAgfQogICAgCgkKICAgIHdo
aWxlKDEpCiAgICB7CiAgICAgICAgY2hhciBpbnB1dFs1XTsKCXNsZWVwKDE1MCk7CglwcmludGYo
ImNvdWxkIHlvdSB3YW50IEVYSVQgP2VudGVyIFt5ZXN8bm9dPyA6ICIpOwogICAgICAgIHNjYW5m
KCIlcyIsIGlucHV0KTsKCWlmKCFzdGQ6OnN0cmNtcChpbnB1dCwgInllcyIpKQoJewoJICAgICBi
cmVhazsKCX0KICAgIH0KCQogICAgZGV0YWNoX3Bhc2lkLnBhc2lkID0gYWxsb2NfZGF0YS5vdXRf
aW9hc19pZDsKICAgIGlmKGlvY3RsKGNkZXZfZmQsIFZGSU9fREVWSUNFX1BBU0lEX0RFVEFDSF9J
T01NVUZEX1BULCAmZGV0YWNoX3Bhc2lkKSkKICAgIHsKCXN0ZDo6Y291dCA8PCAiVkZJT19ERVZJ
Q0VfUEFTSURfREVUQUNIX0lPTU1VRkRfUFQgZmFpbGVkISAiPDwgc3RkOjplbmRsOwogICAgICAg
IHJldHVybiAxOwogICAgfQoJCgkvKkRNQSB1bm1hcHBpbmcgKi8KCXVubWFwLmlvYXNfaWQgPSBt
YXAuaW9hc19pZDsKCXVubWFwLmlvdmEgPSBtYXAuaW92YTsKCXVubWFwLmxlbmd0aCA9IG1hcC5s
ZW5ndGg7CglpZihpb2N0bChpb21tdWZkLCBJT01NVV9JT0FTX1VOTUFQLCAmdW5tYXApKQogICAg
ewoJICAgIHN0ZDo6Y291dCA8PCAiSU9NTVVfSU9BU19VTk1BUCBmYWlsZWQhICI8PCBzdGQ6OmVu
ZGw7CiAgICAgICAgcmV0dXJuIDE7CiAgICB9CgogICAgc2xlZXAoMTUwKTsKCQogICAgcmV0dXJu
IDA7CgovKiBPdGhlciBkZXZpY2Ugb3BlcmF0aW9ucyBhcyBzdGF0ZWQgaW4gIlZGSU8gVXNhZ2Ug
RXhhbXBsZSIgKi8KfQoKCgoK

--_008_SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92SJ0PR18MB5186namp_--

