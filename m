Return-Path: <kvm+bounces-15096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0FA8A9B92
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E9701F21937
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 13:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E612161900;
	Thu, 18 Apr 2024 13:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="acf6IxIZ"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2125.outbound.protection.outlook.com [40.107.127.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173B17D413;
	Thu, 18 Apr 2024 13:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.127.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713448113; cv=fail; b=cL97Jy4wK2o9gZz39WG4Q4oOPGRgMgaOX8f3QhP1tynitGSyRxCW5RMMJKvW7sw3sPFLvCII2mnSfj1TyZWJfU4JtiT45JmFtrp+hf/RDUFnLrAN454Ytd1VvQvJRO2+mIYub5BXOCoQGe0XrIYjnX3YpkBPQN0UaASlOdfo5HQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713448113; c=relaxed/simple;
	bh=f9C306mDyPzubiWDJjSocUgTy9mXKea4th3asxbSqyA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ipvoYN0sFi3RWHjedvnoBLe+zLTiPaLtOJ6wtGf/UJR1TheYTascRK7KcdpeYC6eCb1bzmHzR5DJ5UIMT89fM4tYT9s8C8CEz8G/Fm4FZ39NeTefWWH09FYaaHQo9uIqyxgdpDyUBN4uqusPMTD2OglxyekrrjIzi841IU4gE3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=acf6IxIZ; arc=fail smtp.client-ip=40.107.127.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQR+Rm8zBHRfNY12Mz8jdIXgbn4AEdphV9gqVwvgsDgYBs+fcXjqWQh5xYbpWCw18jeWmwLOI3z8EnKm1EZM8/RnNaB7KIqKagRPrq1v0ufMaXoMi+fwyfkqNFBPPXCXgIYlndKnywMJ374VeqnxXRG7k2UMIiXmA88+hW+r3xxsYWNxngUPL+UoUk1ROS6AuxNKTICM+sKJ0+Y89ClNxprY6y6TkbDecW/Bb2Mup04Ch8m6efwc5v1LyMKOEoDxH/jyJrOI3wvTBWxI4H9hF7Ih6C+VEnufCm70iSoplWP5s4E/b+dnbwyR5X9lqhSvUTMW+krHRuEdxbZ492gnhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9C306mDyPzubiWDJjSocUgTy9mXKea4th3asxbSqyA=;
 b=a9dk/X0CgN1/CgqNuZaCs3R70qWYsIJ/d3gjaa50XA+U5w5o4CcN5oPIKu6oD1rzhjfSohalrikGQ/ko3wPGyaNhPZRQZFG/AkAULn+wf6dwcV7XUOWnS+pIOuJzhQZd3L8PUT92NmXgJQWFKA8/pFvUM9N7Z5Tp0DbHGDWpLynVYNxn/tAb5hYnyMmO7Xis8a6ECHuJfwaQF0f/NTeFmeZTA851vD2QXDtFX/B6+7NnyIfHumaikwtTZxiHkgcqqKNzp7YeGolqGXMefd/kfey0Si1Lri/1c296ayIYpXUJOkghAhwmK+bPFJRINmgzPJtOp5LmDXdo+dUxM+X/ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9C306mDyPzubiWDJjSocUgTy9mXKea4th3asxbSqyA=;
 b=acf6IxIZKgM4A0cVSM3UvSpyZkl+Zlq2kXTq0J7shjSLcTNRVMWDKd9RIJHSeDj97VmejS7RQtswFTOxWOkLqBOt3yQP0ctKPXEM7ugeHLXYKgnVA/2p1ldZkf6XTsPWjA5n3Q9PxdOsMSK5trM3hadclomihWttr7JUjzV1wJHB13mo3Lz/0xltLzKT4xugC1JFkaSnxTa5SggPdnvUsGk+0V+c6iS20qPwbRU8PvLSqLKbpP7l0am/sucerNQA0B2DZlE1YOqO8VNmL2a5gA2i/O1XtLZbJbtKeSsE+GtF+N7E3joFSvz4cpHYqOppeGxZOUGZuOrWFD/+DuMHFg==
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:c3::11)
 by FR4P281MB4101.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:f9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Thu, 18 Apr
 2024 13:48:27 +0000
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75]) by FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75%5]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 13:48:27 +0000
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
To: "seanjc@google.com" <seanjc@google.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Topic: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Index:
 AQHaj/q7SvbB6thKm0KGE0qK9A01DLFq9pcAgAAJW4CAAAKJAIAAJXoAgAAKGICAAT2zgIAANBgAgAAEzACAAWWUgA==
Date: Thu, 18 Apr 2024 13:48:27 +0000
Message-ID:
 <61f14bc6415d5d8407fc3ae6f6c3348caa2a97e9.camel@cyberus-technology.de>
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
	 <Zh6MmgOqvFPuWzD9@google.com>
	 <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
	 <Zh6WlOB8CS-By3DQ@google.com>
	 <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
	 <Zh6-e9hy7U6DD2QM@google.com>
	 <adb07a02b3923eeb49f425d38509b340f4837e17.camel@cyberus-technology.de>
	 <Zh_0sJPPoHKce5Ky@google.com> <Zh_4tsd5rAo4G1Lv@google.com>
In-Reply-To: <Zh_4tsd5rAo4G1Lv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR6P281MB3736:EE_|FR4P281MB4101:EE_
x-ms-office365-filtering-correlation-id: e78e737e-d8f2-4b83-81c8-08dc5fae39ad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?utf-8?B?aVY2QjI0Yng5Qis1YklnL2tkQVpXblNTWVE4Q1ljeHNJUTBtVE1QMVFHc3Rv?=
 =?utf-8?B?bTNlMXhUUGhDZ3pweDF6c2IxZlNxL2JzR3FIZTE0MUt1Znc2NlBSbmMxUlJ4?=
 =?utf-8?B?SDFUeUNVNkQ4UzNGMHAwRCs3TmsxTDFmUTFRT25IOElqcDZjTEZSdjhxWmNL?=
 =?utf-8?B?V3RhT1dFcVhrOFpJcG5TbUFKTitRQ2NlMHVES2Vwd3psQUx6MnpTUHhGQnk5?=
 =?utf-8?B?UGd0dU5sM1FPMXMvd1BaQVloSXkvK2RlS3NNODZCbDl0TnVPa0dBQUhJRlB0?=
 =?utf-8?B?Z3hkbnp4T0p1WE1qTDBuMmM5bkFneWRiaG80azZiZ3QzZC95Tll3dHh6UVFK?=
 =?utf-8?B?MFd2QThMeFY4MEhrbGk2TzA5UjhHeHJhVGpsRmZ6eCt4MGt3Z3Z4TTJ1MUtX?=
 =?utf-8?B?RGVmL3RVNURIY3lDU2IyaG14UXNCZms2Zmk4RHlyTGszWmdGQVlwTHNFOU5k?=
 =?utf-8?B?M1JvVk54RXVWM284eTJkbUk0NStNNlpYOGRScFdpUWJ2OFFnekpZMkd0OGwx?=
 =?utf-8?B?N0UrTzdQL0dNdkh5OUYyNStxTWJwdlpEYm5VWW9aQkRuYVl3VXNTcHVvK3BZ?=
 =?utf-8?B?K0hGUXFwYXRtQUJSQ3h5S2dxL2crcnJ2Q0lDTGxxYi9TRlVnNHVrdGJMVTc5?=
 =?utf-8?B?TTZYQVdXeURFaUpZd0s3QXI3UUdGY0RCeVdoVXlyaHFJeG45N2IzMmZxbFQy?=
 =?utf-8?B?N0FzdnhvbzVUY1hSQUpRRUNzSUVKWWVDVFo2blNENHpkWDRON2IzeXM1M0lL?=
 =?utf-8?B?NWc1VkFDOWlLeU1YbHFNdWxFY2IzcFJSaDRmQ0NkSk5iTjFPQXMybFhHY2pV?=
 =?utf-8?B?NVREa2w1M2M0ZkcyMkNQTFJkRnVQREs4L2ZJMkJxZTdSdjZhT3JxZ255VVZ0?=
 =?utf-8?B?SlNoM2xDNEZiSkhmWVpJMHBUN08xMTJUM3MyNmJTY0NCbTg5ZzlDaUFTWEFJ?=
 =?utf-8?B?N0I2bjdRSEkzbjdnVHpVU3VqWlZRaVZ2M0hHWHdlckVES1kvRDlJQ2xkV0hY?=
 =?utf-8?B?SEpoODJtSGJQQ0xQcXRrOVdnQW9zbDN6Rm1iblZkempsN1hZbGdFZEpLTlln?=
 =?utf-8?B?VUFTUmx1S1pvQWQyUW15dHdaWit3dTFrL2tXemZxQlVtaWFoNlgzcTF6dmdY?=
 =?utf-8?B?eUpMcUxOVmh1Y2ZoUmhRS0RJNVNEUFpEcGp1TTRJTHVQdU5RdGJtQmpzbkNH?=
 =?utf-8?B?dTk4TkVvY1ZUUk56Q2NjSzFQa21rWngxR3VMMjF0Y010T3UyR2o3MWNIVTIx?=
 =?utf-8?B?N0RxNHRGdnROMlkvM2l6MkJON0t3VHFDR2taYzgzWHlob29uWlhBOVNUMXJw?=
 =?utf-8?B?Q2ZPTnlTR05FQmZGVVZKRUdNcXhZRHR0Sm92T0JpbHNmTkpsUEtmZlh6UU1S?=
 =?utf-8?B?MGd1dTRHOGtRcldibk0zem8zc2Q3RVVSMDBkQlBWZHBVaXh1ME5HTnEreU4v?=
 =?utf-8?B?VUw0K3NMZTZpM09PY3Q2bWQyazBScGg1MDhKVk5OWVJKVTErc3phOGxMOHhw?=
 =?utf-8?B?dEk1QWsxVlFURS9EVUJUMmNkd2ZzOWxJbmVUdnlCMFQ1V0p6TW1CVmJlYit5?=
 =?utf-8?B?UGpVT0JMYW5WRzVvK3BTZGxISk5jSjdQcExMZkU5SURrZ1p3bTVyVDZOc1hs?=
 =?utf-8?B?VWp3b05MelRjb1pyOENENjIzNVJzcHJ4QUwzaSt3ZWt5eUFlb0R0OHEzbUtM?=
 =?utf-8?B?MzVJSW1MMVM1NERSOFNqVzZFNnVRS0J2Z2tKMmIvRkxyZUFlRldROEtvVnc1?=
 =?utf-8?B?cGhkTytpaHJ4dHpXSXZiTURJZWtRTTNoM2plN3Q1dFl5V1FsTzlta3U3OVNh?=
 =?utf-8?B?UXkvNExzTG9vTGo1VGtQUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b1puakdYSWpZdGZxNmpyN0l6bm1FQWVURGZKU3VuMFV6SnUzN0x2YTkyc0Rr?=
 =?utf-8?B?SDIxOVNBRnByQXM2RWlnaTdFWmF0MXpUMUtVbkhBRk0vbzBGREMycG1uYWVX?=
 =?utf-8?B?MXRIRHljUURqYUkzZGlXOXFpTG56VmNOWEtFc01lVWc5bEFzRlZkb2E2OHFQ?=
 =?utf-8?B?TkwwaERaZW1WeEQrS205aTdORnBHMmgvVGsyektQU3F0ZkZiMmxwdlkycWpq?=
 =?utf-8?B?U01HRjBLNUlsdnVNUXlQZmVydkFKOUZkaWV4cnFDL0pSWjRmZkJxOU9oRnEz?=
 =?utf-8?B?Q09Sbzh1WUJqT0Y3THBzZ0NHMENHWTZGT2I0ZTBiZnlJT0k5UkZJZlNsOUdZ?=
 =?utf-8?B?NHo3RnhvQW9QcnVTUktQU0JMb0NreHZscHNUcFJ3VUpEZ2Q5Z3NuRFBMd2xM?=
 =?utf-8?B?NExScENkamRlTEZQYS92eTJMWGM4R0h4enhCb3dnSXlSV294NkJ0eXViSG9N?=
 =?utf-8?B?d2wyZEtqUHNtbklDMVBDUlQwQStER29KRFhYRFIrd2N4SHlBM3dkTDRRdFl2?=
 =?utf-8?B?VU9VeHdwUy95V2UwQmkxY2hlbkJuMlhCK3UzaHozbkJ3Q3JaSE11c2REMUxs?=
 =?utf-8?B?TUpRYTNNRVVuNDROY21Pa3FtSFhYRDJLeFdjVU5aZldSWENnd2R2SnlZZmx3?=
 =?utf-8?B?T0ZuZ0x2anVrM0owRm9pZDFHeUU1SnpYd0dMVzNlYVkxUUw1Z1loZ0hVNThy?=
 =?utf-8?B?bXN2QWV4TzBrdmQvZml5aCsvTll5Q0VHeGRmV0MvZXNwV1prQm4wOElKNGlh?=
 =?utf-8?B?dXVvOEV0ZytmdGJ1SU5sb3k3bnI4QktXY2VrejZFS1MrMTVZTEJhVjBlZi9z?=
 =?utf-8?B?NnNsYkorbXRaQXFNS0tOc096REdIQjZzVjFuR3NqU3NzR2tJTFhtb0I4azNt?=
 =?utf-8?B?VGxxQksrR0FIb0ZCVHJaWXozNllEVVNSV0xZN3A3RXh5d1NBVGVyRExsRkdQ?=
 =?utf-8?B?c1BtY2NqQmdSc2IrdFBjTEt6czR3ZHNuT09Oa28yNllJbVJsN0MxU3NLNHJ4?=
 =?utf-8?B?Y3BrNHo3Qk9idzlUS2t6ejdHWjBLczM3bS9JZVYvM0pLd04ySnpEbm1qcWFh?=
 =?utf-8?B?TCtxSnFoK3h4OTRuS3QvMWdUOFM1UmpYd2l6OXZxeGo5dFZzUDFmMjFibk5q?=
 =?utf-8?B?MHRqakM3UFZGNGFLbWl0Y3l2bW9nVk5INXlGNHNWc2hxQ0VqeGdjUWRqbDc2?=
 =?utf-8?B?OSs4cVFPWnpValJlWXdqdHBLcFRFRjZwb3V4ZmhoaVRwS3ZYaFhjWmQ5Y1dL?=
 =?utf-8?B?eHJuaXhWOGUrTHVzbUNmNFJ4UmxDeDZ6OC9wU0Z6OGh0dVpBSk80QjZFVTBi?=
 =?utf-8?B?Nlh1K1MzK3J4eTBZTzR6UjBPbHBaaTF1Q2txOVVERUVvdGVMUzBtZUFhdWho?=
 =?utf-8?B?Wkx6ejVJcy8waVVvL01jaHVQc0xlNlBlWnI2VnYvRlRTeWJia25yNVRDN2Ix?=
 =?utf-8?B?Y0J4MzhkVnNNTHFMeHpSVEh3bUkvYklFaUZtN0x2NDl6bFdIMmNWNWVZTkxo?=
 =?utf-8?B?ZlNac1VtdGpsbG9OMmVxUjVCZ2lMVkphVmlrTXI2bEZNMGhvZFlZTXJVdW5G?=
 =?utf-8?B?SWYwSVhtSE9JeFNUZ3NqaHI5TXZZSzl3S2I5a2FIZURZeXdRUVdCMzViZTEy?=
 =?utf-8?B?SHl2WFhUNUswZGpFa0o5WDYyTjdPRE1Sd3VTb0pBTlgwR21sdmUrK2FLNVJO?=
 =?utf-8?B?aWhFeFdWdEJrZHk1QmZhWlJXRkd5MWRxZHQxSHAwV1QzVnRNcGxuK29wMlpt?=
 =?utf-8?B?NVdtK29mZXZFQ29Fblk4VHRhZDgxeGl3M25QVkdKWDNtVzJSMWR3KzkvaXAx?=
 =?utf-8?B?bFhTZVhqb1QvRURUOUthTWNtM1BhUVdXRmt5QmNiVVhCcmpOdkJaZUdTenpz?=
 =?utf-8?B?YUFyRlpQcGVYWTI2cnBla0hmWG9jZXZMNGpuaW81L2NsVVMxNlZ2cXpVRXdK?=
 =?utf-8?B?UjIwUC9udnJuWXd2YzFEZXZVZ1NvbnBnK0dYdEZwOGs1RzJxU2YrOGpQSkhx?=
 =?utf-8?B?R3JGUlpjTmNoRzB3Wk0rZEpnZjN1Z0xURFZLRXoxdmNCKys4ZXBTQXlXVUZ4?=
 =?utf-8?B?a25iMWZ0UnpBWG90RHlMclRON2NtaXExTUdaNTd0ZHAvVHJJZ24xQWVHR1hO?=
 =?utf-8?B?QXVaVVRld2d5VTFUR3JJbmtMMVRZMHJBOVdnMWdQL3hxVlhZc3pQR2xlL25p?=
 =?utf-8?B?b0dGVHBaUm95TGFzenpSY3ZLYlZyMlJpbkJ2T00rakhpVXVCSVUzcWxrQTM3?=
 =?utf-8?B?cnlsS0JEaWR6cVFxZk1KTUFFVFlpMkxoYXo5cUpJM3VJZjUreS9ZZ1NvczVy?=
 =?utf-8?Q?cKTCbU2WrYQ0WVnLLx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6BB03A7E5F1D24F946BCC3355ADDE47@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e78e737e-d8f2-4b83-81c8-08dc5fae39ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 13:48:27.6001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fB8q5HO+c7JmEWm45qeRALhbXviEUoZXNEm5xJsfDEYtreP6BUPCGxFTd5F6tSaFX8Oi1e7JViwP4/KS9rcW1FkseOmUcvrfxZxxsSU5N2jfiR/XpALlBBy0TPTdAit/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR4P281MB4101

T24gV2VkLCAyMDI0LTA0LTE3IGF0IDA5OjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEFwciAxNywgMjAyNCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiBPbiBXZWQsIEFwciAxNywgMjAyNCwgVGhvbWFzIFByZXNjaGVyIHdyb3RlOg0KPiA+ID4g
T24gVHVlLCAyMDI0LTA0LTE2IGF0IDExOjA3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gPiBIdXIgZHVyLCBJIGZvcmdvdCB0aGF0IEtWTSBwcm92aWRlcyBhICJndWVz
dF9tb2RlIiBzdGF0LsKgDQo+ID4gPiA+IFVzZXJzcGFjZSBjYW4gZG8NCj4gPiA+ID4gS1ZNX0dF
VF9TVEFUU19GRCBvbiB0aGUgdkNQVSBGRCB0byBnZXQgYSBmaWxlIGhhbmRsZSB0byB0aGUNCj4g
PiA+ID4gYmluYXJ5IHN0YXRzLA0KPiA+ID4gPiBhbmQgdGhlbiB5b3Ugd291bGRuJ3QgbmVlZCB0
byBjYWxsIGJhY2sgaW50byBLVk0ganVzdCB0byBxdWVyeQ0KPiA+ID4gPiBndWVzdF9tb2RlLg0K
PiA+ID4gPiANCj4gPiA+ID4gQWgsIGFuZCBJIGFsc28gZm9yZ290IHRoYXQgd2UgaGF2ZSBrdm1f
cnVuLmZsYWdzLCBzbyBhZGRpbmcNCj4gPiA+ID4gS1ZNX1JVTl9YODZfR1VFU1RfTU9ERSB3b3Vs
ZCBhbHNvIGJlIHRyaXZpYWwgKEkgYWxtb3N0DQo+ID4gPiA+IHN1Z2dlc3RlZCBpdA0KPiA+ID4g
PiBlYXJsaWVyLCBidXQgZGlkbid0IHdhbnQgdG8gYWRkIGEgbmV3IGZpZWxkIHRvIGt2bV9ydW4g
d2l0aG91dA0KPiA+ID4gPiBhIHZlcnkgZ29vZA0KPiA+ID4gPiByZWFzb24pLg0KPiA+ID4gDQo+
ID4gPiBUaGFua3MgZm9yIHRoZSBwb2ludGVycy4gVGhpcyBpcyByZWFsbHkgaGVscGZ1bC4NCj4g
PiA+IA0KPiA+ID4gSSB0cmllZCB0aGUgImd1ZXN0X21vZGUiIHN0YXQgYXMgeW91IHN1Z2dlc3Rl
ZCBhbmQgaXQgc29sdmVzIHRoZQ0KPiA+ID4gaW1tZWRpYXRlIGlzc3VlIHdlIGhhdmUgd2l0aCBW
aXJ0dWFsQm94L0tWTS4NCj4gPiANCj4gPiBOb3RlLCANCj4gDQo+IEdhaCwgZ290IGRpc3RyYWN0
ZWQuwqAgSSB3YXMgZ29pbmcgdG8gc2F5IHRoYXQgd2Ugc2hvdWxkIGFkZA0KPiBLVk1fUlVOX1g4
Nl9HVUVTVF9NT0RFLA0KPiBiZWNhdXNlIHN0YXRzIGFyZW4ndCBndWFyYW50ZWVkIEFCSVsqXSwg
aS5lLiByZWx5aW5nIG9uIGd1ZXN0X21vZGUNCj4gY291bGQgcHJvdmUNCj4gcHJvYmxlbWF0aWMg
aW4gdGhlIGxvbmcgcnVuICh0aG91Z2ggdGhhdCdzIHVubGlrZWx5KS4NCj4gDQo+IFsqXQ0KPiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvQ0FCZ09iZlo0a3FhWExhT0FPajRhR0I1R0FlOUd4
T21KbU9QKzdrZGtlNk9xQTM1SHpBQG1haWwuZ21haWwuY29tDQoNCkFsbHJpZ2h0LiBJIHdpbGwg
cHJvcG9zZSBhIHBhdGNoIHRoYXQgc2V0cyB0aGUgS1ZNX1JVTl9YODZfR1VFU1RfTU9ERQ0KZmxh
ZyBpbiB0aGUgbmV4dCBjb3VwbGUgb2YgZGF5cy4gRG8gd2UgYWxzbyBuZWVkIGEgbmV3IGNhcGFi
aWxpdHkgZm9yDQp0aGlzIGZsYWcgc28gdXNlcmxhbmQgY2FuIHF1ZXJ5IHdoZXRoZXIgdGhpcyBm
aWVsZCBpcyBhY3R1YWxseSB1cGRhdGVkDQpieSBLVk0/DQo=

