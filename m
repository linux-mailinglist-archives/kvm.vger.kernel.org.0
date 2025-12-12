Return-Path: <kvm+bounces-65811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA9CCB8116
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 08:09:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5BEB530006CC
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 07:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2952C2ECEB9;
	Fri, 12 Dec 2025 07:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uzg8QMiC";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PdMgDk+C"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25003C38;
	Fri, 12 Dec 2025 07:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765523339; cv=fail; b=jlULKqllgHr/w1x7DBkJkNTIA2wQPWh6dd1TUbgrPgb0hrO4gwsuQlB2IZ6L/MuQav2hBMFcl41Hd2ofHTf7b4jvbQkbZ7Ikud9y2UqJ8bVym/Y4JpdF/siWF/VTYzLqNHggqRcG4FyAa04WGyUtNwmSZjiSS2gqOrQehhO3yN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765523339; c=relaxed/simple;
	bh=wg+ELRmo3/takwH72EOuxp8JYQsmmz/WwUXOJ48l0A0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F95G2nVEOqEdSXgz2zfTzY0Sf0tEkyL6bpOmkg1yavIn1/8q2MWFLP65s/9TwKq/PsF8zMv06RMcnlj73NFf+4y0c9QQI0CvsbNgUaaoaPspcbvOAfyVwXY5Im6kNocbCNkicb+UFGw1tILY0mzCxNxnI1IUdVppWYZzDETE05o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uzg8QMiC; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PdMgDk+C; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BC04V4C3832357;
	Thu, 11 Dec 2025 23:08:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=wg+ELRmo3/takwH72EOuxp8JYQsmmz/WwUXOJ48l0
	A0=; b=uzg8QMiCh20AMroHE1jeILzItEpeyjtxl4wYK4AXwOgyEhZVUQAm7JnCQ
	Qiy5TspuhP0XNQw4Dgb+Hr/ANHS5khb6LA+INJpvnmKz3IvTxE7wUxg1oGU1D3Vf
	VzxEBfCifxPzeqQC4AaCVuyxNzi5VeYH2zkky89Z/TyfQ00Wa2XcRwjfxFUkFBvM
	XkEFO9wS6yIhvocedGM1NLMorJTw87JPiWeWbTETzJVIexbY06pvxDqDKzP3spRI
	O3yArom/uGhxQRQod9/Fz0BUxOM2yOLFTsv3syGzLx6Yvpg7sZPS0FAHKN7GIJWM
	UdGAaJW7ZbuOqKnmaxVMOs5hwgWoQ==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022077.outbound.protection.outlook.com [40.107.200.77])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b086j8mkt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Dec 2025 23:08:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qew6cOa7tCIZYT7Tjo6tVRa/HzU4ICmGHtppeQpFeHcoApRGb7eqHfGAZbgwLeUjNXq/JV9sCC0ZMRrspvlM9YpLSM8PsvHn7Dv8WolhZjs7relxpwmruXazn8SKfhKO4XOxbw+KJKtPXxJlpU2nlbOGz0ooYUsBl8MGcDXJbfPBD+Yngv5heWHeKQhyZF3kdLfYsdS6W1Vvcfgpg1Qp5cUMOHLdEa2qLHBC0r5ltDNTJaRxWYPgBz2YUC0Qf8lbsgNTiIyWOabe1bQ8wAzUWjIEf0/mIZCwEKw2QU0pU+ejNRfy74ldoj6tYuySjtRD9VcEaK/hXltAU86BWZSVLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wg+ELRmo3/takwH72EOuxp8JYQsmmz/WwUXOJ48l0A0=;
 b=yGLkcMoJUhG9D8tWC7Ci5JLufpZXfFYJpzFstrlm48bSjpF2IMwSq7AUaPylrVVDqsN5orucpJPKjzOicZz4JkBJeOu/nZKG23FtS284rTu1gGYE7zFxZ7SvTo4kliZ2gtz2w4RgAU+apCKLSSup5H6nICayOhOLy70GydwwMMg8cXCgeaaQ+MW0q6yhFqMY8xIBam/aaJEcANq/IkxJHVjW6j/Dq46Xsosd/TXERqEmk/tguLkN5dpSVuThF+xKhaA74dAef3ckLpgr7rwnZ86S54W48vGhNccgj835Pa+yraoH9YgIu8PaeTwk3G2lm/5N27cmcZUEwspWo5Id0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wg+ELRmo3/takwH72EOuxp8JYQsmmz/WwUXOJ48l0A0=;
 b=PdMgDk+C5w98Vn3npYB4qFMkfm/RA4TxQreyskHNkonsscV/v19AwfkD0w6tsZRZpfTMWLHycNbPHRKgkDf2qULWCIRa5iMhyoH1o5eD8IFWvW57S+oQXqq+kIrk6v2LdUzo5Rj0O2B/8uTtYYfOiuT3oweyPnCofiS/G50CPMXiEfeMVoFtBNy/Ed6ItxhIiR/vlCXiA4ehg0hnAsumQhagqQUWUPhUyBRQMwEpg+lCNS3uTk36GjSMfFk8qz9fNh8meSd0oBuZ9VnjdcWrYXCaX5UsGwPjj8clFTB4+6ptpWHTyYgPImLF3x3C75VHdgLVGz7ASCyBUXSYdku3SQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SN4PR0201MB8725.namprd02.prod.outlook.com (2603:10b6:806:1e8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 07:08:23 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 07:08:23 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon
 Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcao1m0m+Je6bySUSdnhU8EZf0EbUdH8CAgAB3S4A=
Date: Fri, 12 Dec 2025 07:08:23 +0000
Message-ID: <B45DB519-3B04-46F7-894E-42A44DF2FC8E@nutanix.com>
References: <20251211110024.1409489-1-khushit.shah@nutanix.com>
 <83cf40c6168c97670193340b00d0fe71a35a6c1b.camel@infradead.org>
In-Reply-To: <83cf40c6168c97670193340b00d0fe71a35a6c1b.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SN4PR0201MB8725:EE_
x-ms-office365-filtering-correlation-id: a8dbcd35-8664-493c-c537-08de394d3d00
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?aXdlYlhkOUthY1JyTzdaVHFQc2dkUFFEc1ZiQ2YrOGxUTkRtclVPWjdSOFZh?=
 =?utf-8?B?Vm1idkxRcWYxc2JuNHZUa0U1UnZuNnZXa2podmNtenZKUGlaTHhSRDNneS9u?=
 =?utf-8?B?aStIYU05ZmN1cXBDRTN6TmhMSG16emtwdi9kWGpRb1pNZUY2d2JlYkY3WWZy?=
 =?utf-8?B?bFBZTHdEZlBXOGJZNkZXR0ZXRy9oQzJRdGZSYzVQd2hzY1U4VXpUeFhOb05T?=
 =?utf-8?B?L00xRE8wUzI2UUU2dFZ6SVFsVExPbHo4ZkVtR2FKbUZJYlRHeEZicklGaml5?=
 =?utf-8?B?RXA0cU9oOEkxK081Y1FIbFViamhNRVhWT3NSaGRxK1JBR0lzOWhyRzJ1amV6?=
 =?utf-8?B?UmV2VTZJeGl5bmh2NHdEZ2U3VXp0K3d5RzZaL29oVXB3am5SWnFKanNHbzZj?=
 =?utf-8?B?ZmVyVDAzL2J5MWFJcjkyWCthL2V2QThzVW9NNm1VQnBPKytXV3c0V2ZsTTM0?=
 =?utf-8?B?Z292KzBuMytUUDk4R3NERDl0d0RzY1lIZnVlL1JPeEgzcUM4MUZYanFQd0h3?=
 =?utf-8?B?VnZFcE9pQ2NGTFJ3dG0xTlpwRXk0VSs3ei9HSW13NDJCci9BVjBtanB1UzRm?=
 =?utf-8?B?amFPUEd1RXRkdGQ4WElRWXhkNXZPeGhySWZwMzFJaUFQeE5rb2pxMUE1ZUt3?=
 =?utf-8?B?Y0ZXeUNKNkdrdjdtNS9iejZBZHVXSm92a2s5Vm1KVDN0K1RDZmgvMXVwSGRm?=
 =?utf-8?B?RWxGdWJhcUxHSldZa3ZHdkhnQlVBUnBzVWJ1WURYM3hKRHZ1SFAxVkhsdTJH?=
 =?utf-8?B?MHlQYkVsWjRmUmpycTdVZWg4MnRETXV0ZXFQS3NISU90R0M0ZUltTDJkazlH?=
 =?utf-8?B?dFhGeU5xNy9xMmNwVFNoQ1VrcWROMCswTE1WK0szTUdhekE4aGQwUjlpd2lj?=
 =?utf-8?B?YmUzUWsvK01JY2tLVkJGNjN5czh1d3BPK2NMZjNwbXZqS1FFTm1kUlo2Qm5q?=
 =?utf-8?B?OWovTTdMeUZlZEZ2bkVSenRLWVBUaTlhL05rUTJKUkRlVkltclVVZDJHMlBa?=
 =?utf-8?B?TVNJQmgvVGpSR1VJRjgzWXNaNldvK3VyOEpUMkRGYjhEc2FsUjg2dlhiMGJq?=
 =?utf-8?B?bXVrTnVjcDVUWm10T1JaR0VhVGFYNTEybDl4cGVXRGU2WktPa3ZIeTBwa0ds?=
 =?utf-8?B?dnkwdmhWSC9jR20vZkZHSTFMTDJyZ2JpUWJjTnJ0aWNtWDFtYlhFRCtWTlZu?=
 =?utf-8?B?dWg4dDZmTU90bzdoOTZ1a2lyYXI5UkFObVc3dzE4NGNFSFhtYzVxSmpRUkdY?=
 =?utf-8?B?R0tMOHV2cUVPREJFaWpRQjRiS1Z3S1BXcURneTlwMXhNeUNnb1k5cHdZYkpm?=
 =?utf-8?B?VXhPS24xbFhWT1FKeTJQN2J2VXlOUG5DZzdhZHJhUlRPamY1bHpGWHE0enla?=
 =?utf-8?B?QWJyK0NsTndWNW1DR2gxL3oxQUFYdTNPcnJUNmZTT1lubXVUdVZyeGZvTHha?=
 =?utf-8?B?QUhoRmtaczRiRklqS25qaHRkb3BDSXZkTld6M00rMmhDZktNdkVZSWtOUmxp?=
 =?utf-8?B?bit1U3N2a25PTUtYQm5oS1VnbzhUa3NhdWJmKzUzSkFCeTVLNGkvdkFaVURw?=
 =?utf-8?B?NjNWTE5UN3lBNWVGSnlodUZzalU1K3I5Q1BkeGJyL1pCL2c5NVgrSnJDbng0?=
 =?utf-8?B?NFl4MXRRQnBydDN4bmNFOXhtdEN2TVp6Q3JUMzYyTENzKzhOOU96YlIzWHJo?=
 =?utf-8?B?UWxjamdPUE1MbmtySzM2TzBUYXd4dU5mRDR6Qm5JRjJJTDJvWkNnNnB6cUZw?=
 =?utf-8?B?dFllNnB2VU5MSi8rM3diczBPVkpPSnQ3QnFLdEhKOERudnNhOC9HaktZd0NH?=
 =?utf-8?B?VTI4b2svcEFhM2t3ckR4WVdPUG16ZVNya1lOSy96MCtKY3NFcFNxUTd3ZWwx?=
 =?utf-8?B?ZnNKc1BMRllpOXlaUUJONzloNU55cDdhMDZLNUJCdWoydlFWVFlnZzgvSUk3?=
 =?utf-8?B?WGk2VmJ0OStIMDJrYTBlS0N3MjhjZGNiYVpQTi81NWxkY0xSdTNJYjMrOVhZ?=
 =?utf-8?B?N252ZFYyNGhVdEo1dkcvQ1RRbS81djVkSzkveU90cGlYZTJyT1dHUXdXOGFX?=
 =?utf-8?Q?mAbe7T?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OHVvVGdIQWdXN29GMEZTWE15WXVXWk8xQVRRdGYvSkFvYWswZlpzRGJ0Q3ov?=
 =?utf-8?B?eFI2enlnQkIxRHBsT01CckNxRGJhQVFHbHgzMFR6OExZNnRnZGExejdaWjZM?=
 =?utf-8?B?ZkdBQ0p1TFVHRjRNYzVLUkpoR2ZtNlcwN25VdWxUSW1CdkRyMHdqMm5ZSUFq?=
 =?utf-8?B?cVROTWxhQ0dyVzk1SG9VWFh2QU1ET29Lb0RDR1pNajErR1VLN3FxM0hmTURO?=
 =?utf-8?B?VlE3ZU1FZ0dJMWJ1cWZ5aG1YYUw0N2R4MW9kTFlNK01oYnZJV0JoYU5POWZ2?=
 =?utf-8?B?QytjT1hlZGJRWEt4Mk9TRW5YZDBzeDJTL0ZRY0RMYjZiMm8yajFRTVBrSDZV?=
 =?utf-8?B?MXVFSHFxNFVQcndrTFRZYjUzbFlCY28rN0NEUkl4ODNFNlV4V2ZRVDFWTlRG?=
 =?utf-8?B?Z2oxRWpwdXAwRm1QUUU2b0E1eE4yMzBtaHpYaVI2SHhJSDlENDhkZXg1VVY1?=
 =?utf-8?B?WUNuWXV5c1hKODJzN1BIZy9QWU4vUEtCOFZyNXlkS2F1NjZkQzFpMmNNcjNM?=
 =?utf-8?B?SVVTTUdwWUlHcTNkMTdhdE1kS0Q1MXNSejgzdnlxOGRZcy9OMnJldzFSY1E2?=
 =?utf-8?B?b3VsMGhhbHVBUU1rMnRFMElKRUYwRWlQa2NLdEFwMkt2Rkt3UW9PbGNXdVlW?=
 =?utf-8?B?VjE3VVJPVDMwODJic3RGSC94TWEzVG1qWUZwQnRFWWlaWG84RFAveTU1UU0w?=
 =?utf-8?B?YzlGM1E1NVFaMWF4cjlJeVVacG1GSWU0cVA3L28rSVBRNGRUaTk3YUQ4dmNQ?=
 =?utf-8?B?TTRpQ25KVlJCemRMUlF5OVNCSnpSY2tVUVZDMjNYSjJkMWcvS25qdVpRZVRp?=
 =?utf-8?B?MmV4L3AvV0lGVnkvTEpobXZCMWhRa1FrcnltNzFUMDBtT2EvV2RDaG1qN1hQ?=
 =?utf-8?B?QlduM1BobmZzaGFTZ1M5R2JuQURkYWRhWHNZcjh6ZVdkWTl5bEtJWnFxeVVG?=
 =?utf-8?B?SENHM1N1cU4wWHMyM0E3R1IyWi9oa0ppYTRQckdpc2xQKzViNGhhNGpqOXNa?=
 =?utf-8?B?c2FqMzNwT2llQ2o4M3VMU2k5SnZSOW5Wdk9idnBLekJIWnpWMlVxclkxekVo?=
 =?utf-8?B?SzA2U3A1a2ZzVzZoTUE2QlRqOHkreHdjZ0V1cjM2ZTdnWDZrRUZhdzY2Z2tO?=
 =?utf-8?B?T0hOOUNUZ0Z0MHRVRXdOSzlNaUhJT1B5VnNNemJjbVV3RDFCeHZaN1F2SnlF?=
 =?utf-8?B?SlRvdWFWNy91MmM0WU5DU0lwRlJPTW1oQVgxSEZ0QU83S284ME56MlhleW1J?=
 =?utf-8?B?L3ZoNE91eXRjbWJDdkJlZnJ6SDRYV0hQWCtCSDFuaFBEOW5WY0k3Vy9QRkQ4?=
 =?utf-8?B?c3hRZnZ0VXRqTUtMY1ZtUHNTUTVoUGpIdnlKYkp4eG5tc25rNlh5RnRJaWM0?=
 =?utf-8?B?b3ZabGZjdE44angzcHZUSXpIbXBhWG5rVXVNUWpwS1FaRUZ2L0pWTmVTME1m?=
 =?utf-8?B?QlJGa1VpV2JNUnQybElFbWg0bUVLTUIwRXh4Y1ZjZTRQNmM5TW1neFZaMnZY?=
 =?utf-8?B?cUxYTHhRSklPNlNyQm5PYWJlN3h4eEFxS2VubmlWbG5lSmRiYThtS2NWd1Z4?=
 =?utf-8?B?b0d0cFZFQVhneExVaGtaK3ZoeTYzbndnQ2ZvaUEyMnorb2RwTnY0dngxMDNC?=
 =?utf-8?B?aDhIL2ZuTkR2Z0ZTZkVsdkJCY2IrL2ZwMi80UG16YmNoV0xSVFQ1K1RSK0lU?=
 =?utf-8?B?RzYyT0tGdUUzMmJYY3d3cGJsYnZEVkpsTGk3SlZZbUJNdGlJRE5EMHU2Nzlh?=
 =?utf-8?B?NmRab29ndnZKMmJ0WTlYNC8yVTh1YXdpTVFpR0dQWGY5RXV6WnN3SnM0R0ZD?=
 =?utf-8?B?MEowVml5VkRvNEw3Z2JrNnA2d2VwVEVOZ0xqejNUL0pnN1dXcjNoT2RzcWVO?=
 =?utf-8?B?MlJPQlZuUVVNTUFlaTFqSHlOeDZpS0hBdU93d0pUNC83UzlQd2lub3hTU0d1?=
 =?utf-8?B?VHF1RHk2V1NsYTgzY09OMGQwUDNTU0JpL0VmazM3V1VuL0psRGZFQk9PSlZu?=
 =?utf-8?B?QnJtc1RqTFFtaTRCOFZXZ1hxd2tmSEVBU3ZVYTg5Rk02UjZBKzZlYnpRRllN?=
 =?utf-8?B?bjFmaExZQm9aSjJSTnJsNzFXcHIzdUZUVGhHREEwOEJCaFdHdW5CWFE3emtn?=
 =?utf-8?B?MzhXdForVFVRR2FINzl4YnZ4Nnpxd0JLdGlMREpmSkUxKzN6cCtSbEtPamx5?=
 =?utf-8?B?UjVHZmxkRmRDdzRCWUVIY25IdnFMYTlJdnc2bTNVN1M3ZTczbDI4T041RTVn?=
 =?utf-8?B?QUpsZ0c5TzFlS2ovenJaZ05HRmdRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95EAE9A1BED9C3448D688FC493B6B673@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8dbcd35-8664-493c-c537-08de394d3d00
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 07:08:23.1474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5a2JO+evQH1UOPqUHZ7ViGDbWc1sBE/AKc5KfvQuRkIAuyBxcKMp0uFySzYaGSLl7QizALe5WCvNdfplkMhRVtMJMJcQuzi0fNSTCZ9/bGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0201MB8725
X-Proofpoint-GUID: u5CAMX4mtI8IbBl-4xe43JgwdggL6JcW
X-Proofpoint-ORIG-GUID: u5CAMX4mtI8IbBl-4xe43JgwdggL6JcW
X-Authority-Analysis: v=2.4 cv=dc2NHHXe c=1 sm=1 tr=0 ts=693bbf69 cx=c_pps
 a=zTBNYDxB24c+L2bFQgZTuw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=0WL2uXCgeL9GrZ2AX8MA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDA1NCBTYWx0ZWRfX0KMywFhKJz6Y
 YKjr9c00vETPHb1sVqtYGtKL84N/sVdWPHRtC2gG00QFAxncdgRpmAV3OlUdZjmyzEhGunmNzGd
 czyhyMDziThCj1lsZN5+U1Y2XtLstSz9uvraQZwdsF/X8UaCDqpwdr14vBTUDXQ0FnC6UHrg8Tp
 HrnQ/m5FeNQChoopFiPI7m2NKvFBGP+4lJTpTPAQcX9MPcScgWvzkQLeJiulYlYt/Z7femXLzAy
 xF3ujqkKd7sQX6B8Bi0RiEFndJ10uNb/KEjSrrLVa02x3SNxjRW2wP08lNc3SfQeccya0RurPD3
 sUsnXGKaQqV8cZtyWOrJK7SLka6e2cBZrzVqmP+ln9jzilUV++8lICTzfhnEO1cYzZrQEP0gkRX
 XpU1sQFcMqbdMJXEtVUVOUab77CH1Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-12_01,2025-12-11_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQo+IE9uIDEyIERlYyAyMDI1LCBhdCA1OjMx4oCvQU0sIERhdmlkIFdvb2Rob3VzZSA8ZHdtdzJA
aW5mcmFkZWFkLm9yZz4gd3JvdGU6DQo+IA0KPiBIbSwgSSBkb24ndCBsaWtlIHRoYXQgbXVjaC4g
Rm9yIGEgc3RhcnQsIERJU0FCTEUgc2hvdWxkIGJlIGZpbmUgd2l0aA0KPiB0aGUgaW4ta2VybmVs
IElSUUNISVAgcmlnaHQgbm93IChhbmQgaXMgdGhlIG9ubHkgYmVoYXZpb3VyIHRoYXQgdHJ1bHkN
Cj4gbWFrZXMgc2Vuc2UgcmlnaHQgbm93KS4NCj4gDQo+IEFuZCBteSBpbnRlbnQgd2FzIHRoYXQg
dGhlIGluLWtlcm5lbCBJL08gQVBJQyBwYXRjaCBnZXRzIGluY2x1ZGVkIGFzDQo+ICpwYXJ0KiBv
ZiB0aGlzIHNlcmllcywgb3RoZXJ3aXNlIHdlJ3JlIG1ha2luZyBhIHNlbWFudGljIGNoYW5nZSB0
byB0aGUNCj4gRU5BQkxFIGJlaGF2aW91ciBsYXRlci4NCj4gDQo+IEFsc28uLi4gaG93IGRvZXMg
dXNlcnNwYWNlIGRpc2NvdmVyIHRoZSBhdmFpbGFiaWxpdHkgb2YgdGhlc2UgZmxhZ3M/DQo+IA0K
PiAoQW5kIGlmIHlvdSBkb24ndCBpbmNsdWRlIHRoZSBJL08gQVBJQyBwYXRjaCBhcyBwYXJ0IG9m
IHRoaXMgc2VyaWVzLCB3ZQ0KPiBhbHNvIG5lZWQgdG8gdW5kZXJzdGFuZCBob3cgdXNlcnNwYWNl
IHdpbGwgbGF0ZXIgZGlzY292ZXIgdGhhdCBFTkFCTEUNCj4gY2FuIGJlIGFwcGxpZWQgdG8gdGhl
IGluLWtlcm5lbCBpcnFjaGlwIHRvby4pDQoNCg0KVGhhdCBpcyBhIHZhbGlkIHBvaW50LCBob3cg
YWJvdXQgYWxzbyBpbmNsdWRpbmcgdGhlIElPQVBJQyB2ZXJzaW9uIDB4MjANCihuZWVkcyB0byBi
ZSB0ZXN0ZWQpIGFuZDoNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9sYXBpYy5jIGIvYXJj
aC94ODYva3ZtL2xhcGljLmMNCmluZGV4IDBhZTdmOTEzZDc4Mi4uN2IzNjgyODRlYzBiIDEwMDY0
NA0KLS0tIGEvYXJjaC94ODYva3ZtL2xhcGljLmMNCisrKyBiL2FyY2gveDg2L2t2bS9sYXBpYy5j
DQpAQCAtMTA1LDYgKzEwNSw0MyBAQCBib29sIGt2bV9hcGljX3BlbmRpbmdfZW9pKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgaW50IHZlY3RvcikNCiAgICAgICAgICAgICAgICBhcGljX3Rlc3RfdmVj
dG9yKHZlY3RvciwgYXBpYy0+cmVncyArIEFQSUNfSVJSKTsNCiB9DQogDQorc3RhdGljIGJvb2wg
a3ZtX2xhcGljX2FkdmVydGlzZV9zdXBwcmVzc19lb2lfYnJvYWRjYXN0KHN0cnVjdCBrdm0gKmt2
bSkNCit7DQorICAgICAgIC8qDQorICAgICAgICAqIFJldHVybnMgdHJ1ZSBpZiBLVk0gc2hvdWxk
IGFkdmVydGlzZSBTdXBwcmVzcyBFT0kgYnJvYWRjYXN0IHN1cHBvcnQNCisgICAgICAgICogdG8g
dGhlIGd1ZXN0Lg0KKyAgICAgICAgKg0KKyAgICAgICAgKiBJbiBzcGxpdCBJUlFDSElQIG1vZGU6
IGFkdmVydGlzZSB1bmxlc3MgdGhlIFZNTSBleHBsaWNpdGx5IGRpc2FibGVkDQorICAgICAgICAq
IGl0LiBUaGlzIHByZXNlcnZlcyBsZWdhY3kgcXVpcmt5IGJlaGF2aW9yIHdoZXJlIEtWTSBhZHZl
cnRpc2VkIHRoZQ0KKyAgICAgICAgKiBjYXBhYmlsaXR5IGV2ZW4gdGhvdWdoIGl0IGRpZCBub3Qg
YWN0dWFsbHkgc3VwcHJlc3MgRU9Jcy4NCisgICAgICAgICoNCisgICAgICAgICogSW4ga2VybmVs
IElSUUNISVAgbW9kZTogb25seSBhZHZlcnRpc2UgaWYgdGhlIFZNTSBleHBsaWNpdGx5DQorICAg
ICAgICAqIGVuYWJsZWQgaXQgKGFuZCB1c2UgdGhlIElPQVBJQyB2ZXJzaW9uIDB4MjApLg0KKyAg
ICAgICAgKi8NCisgICAgICAgIGlmIChpcnFjaGlwX3NwbGl0KGt2bSkpIHsNCisgICAgICAgICAg
ICAgICByZXR1cm4ga3ZtLT5hcmNoLnN1cHByZXNzX2VvaV9icm9hZGNhc3RfbW9kZSAhPQ0KKyAg
ICAgICAgICAgICAgICAgICAgICAgS1ZNX1NVUFBSRVNTX0VPSV9CUk9BRENBU1RfRElTQUJMRUQ7
DQorICAgICAgIH0gZWxzZSB7DQorICAgICAgICAgICAgICAgcmV0dXJuIGt2bS0+YXJjaC5zdXBw
cmVzc19lb2lfYnJvYWRjYXN0X21vZGUgPT0NCisgICAgICAgICAgICAgICAgICAgICAgIEtWTV9T
VVBQUkVTU19FT0lfQlJPQURDQVNUX0VOQUJMRUQ7DQorICAgICAgIH0NCit9DQorDQorc3RhdGlj
IGJvb2wga3ZtX2xhcGljX2lnbm9yZV9zdXBwcmVzc19lb2lfYnJvYWRjYXN0KHN0cnVjdCBrdm0g
Kmt2bSkNCit7DQorICAgICAgIC8qDQorICAgICAgICAqIFJldHVybnMgdHJ1ZSBpZiBLVk0gc2hv
dWxkIGlnbm9yZSB0aGUgc3VwcHJlc3MgRU9JIGJyb2FkY2FzdCBiaXQgc2V0IGJ5DQorICAgICAg
ICAqIHRoZSBndWVzdCBhbmQgYnJvYWRjYXN0IEVPSXMgYW55d2F5Lg0KKyAgICAgICAgKg0KKyAg
ICAgICAgKiBPbmx5IHJldHVybnMgZmFsc2Ugd2hlbiB0aGUgVk1NIGV4cGxpY2l0bHkgZW5hYmxl
ZCBTdXBwcmVzcyBFT0kNCisgICAgICAgICogYnJvYWRjYXN0LiBJZiBkaXNhYmxlZCBieSBWTU0s
IHRoZSBiaXQgc2hvdWxkIGJlIGlnbm9yZWQgYXMgaXQgaXMgbm90DQorICAgICAgICAqIHN1cHBv
cnRlZC4gTGVnYWN5IGJlaGF2aW9yIHdhcyB0byBpZ25vcmUgdGhlIGJpdCBhbmQgYnJvYWRjYXN0
IEVPSXMNCisgICAgICAgICogYW55d2F5Lg0KKyAgICAgICAgKi8NCisgICAgICAgcmV0dXJuIGt2
bS0+YXJjaC5zdXBwcmVzc19lb2lfYnJvYWRjYXN0X21vZGUgIT0NCisgICAgICAgICAgICAgICAg
ICAgICAgIEtWTV9TVVBQUkVTU19FT0lfQlJPQURDQVNUX0VOQUJMRUQ7DQorfQ0KKw0KIF9fcmVh
ZF9tb3N0bHkgREVGSU5FX1NUQVRJQ19LRVlfRkFMU0Uoa3ZtX2hhc19ub2FwaWNfdmNwdSk7DQog
RVhQT1JUX1NZTUJPTF9GT1JfS1ZNX0lOVEVSTkFMKGt2bV9oYXNfbm9hcGljX3ZjcHUpOw0KIA0K
QEAgLTU2Miw3ICs1OTksNyBAQCB2b2lkIGt2bV9hcGljX3NldF92ZXJzaW9uKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkNCiAgICAgICAgICogSU9BUElDLg0KICAgICAgICAgKi8NCiAgICAgICAgaWYg
KGd1ZXN0X2NwdV9jYXBfaGFzKHZjcHUsIFg4Nl9GRUFUVVJFX1gyQVBJQykgJiYNCi0gICAgICAg
ICAgICFpb2FwaWNfaW5fa2VybmVsKHZjcHUtPmt2bSkpDQorICAgICAgICAgICAgICAga3ZtX2xh
cGljX2FkdmVydGlzZV9zdXBwcmVzc19lb2lfYnJvYWRjYXN0KHZjcHUtPmt2bSkpDQogICAgICAg
ICAgICAgICAgdiB8PSBBUElDX0xWUl9ESVJFQ1RFRF9FT0k7DQogICAgICAgIGt2bV9sYXBpY19z
ZXRfcmVnKGFwaWMsIEFQSUNfTFZSLCB2KTsNCiB9DQpAQCAtMTUxNSw2ICsxNTUyLDE3IEBAIHN0
YXRpYyB2b2lkIGt2bV9pb2FwaWNfc2VuZF9lb2koc3RydWN0IGt2bV9sYXBpYyAqYXBpYywgaW50
IHZlY3RvcikNCiAgICAgICAgaWYgKGFwaWMtPnZjcHUtPmFyY2guaGlnaGVzdF9zdGFsZV9wZW5k
aW5nX2lvYXBpY19lb2kgPT0gdmVjdG9yKQ0KICAgICAgICAgICAgICAgIGt2bV9tYWtlX3JlcXVl
c3QoS1ZNX1JFUV9TQ0FOX0lPQVBJQywgYXBpYy0+dmNwdSk7DQogDQorICAgICAgIC8qDQorICAg
ICAgICogRG9uJ3Qgc2VuZCB0aGUgRU9JIHRvIHRoZSBJL08gQVBJQyBpZiB0aGUgZ3Vlc3QgaGFz
IGVuYWJsZWQgRGlyZWN0ZWQNCisgICAgICAgKiBFT0ksIGEuay5hLiBTdXBwcmVzcyBFT0kgQnJv
YWRjYXN0cywgaW4gd2hpY2ggY2FzZSB0aGUgbG9jYWwNCisgICAgICAgKiBBUElDIGRvZXNuJ3Qg
YnJvYWRjYXN0IEVPSXMgKHRoZSBndWVzdCBtdXN0IEVPSSB0aGUgdGFyZ2V0DQorICAgICAgICog
SS9PIEFQSUMocykgZGlyZWN0bHkpLiBJZ25vcmUgdGhlIHN1cHByZXNzaW9uIGlmIHRoZSBndWVz
dCBoYXMgbm90DQorICAgICAgICogZXhwbGljaXRseSBlbmFibGVkIFN1cHByZXNzIEVPSSBicm9h
ZGNhc3QuDQorICAgICAgICovDQorICAgICAgIGlmICgoa3ZtX2xhcGljX2dldF9yZWcoYXBpYywg
QVBJQ19TUElWKSAmIEFQSUNfU1BJVl9ESVJFQ1RFRF9FT0kpICYmDQorICAgICAgICAgICAgICAg
ICAha3ZtX2xhcGljX2lnbm9yZV9zdXBwcmVzc19lb2lfYnJvYWRjYXN0KGFwaWMtPnZjcHUtPmt2
bSkpDQorICAgICAgICAgICAgICAgcmV0dXJuOw0KKw0KICAgICAgICAvKiBSZXF1ZXN0IGEgS1ZN
IGV4aXQgdG8gaW5mb3JtIHRoZSB1c2Vyc3BhY2UgSU9BUElDLiAqLw0KICAgICAgICBpZiAoaXJx
Y2hpcF9zcGxpdChhcGljLT52Y3B1LT5rdm0pKSB7DQogICAgICAgICAgICAgICAgYXBpYy0+dmNw
dS0+YXJjaC5wZW5kaW5nX2lvYXBpY19lb2kgPSB2ZWN0b3I7DQoNCg0KSSBhbSBub3QgZW50aXJl
bHkgc3VyZSBpZiByZXR1cm5pbmcgZnJvbSBrdm1faW9hcGljX3NlbmRfZW9pKCkgZWFybHkgaXMg
Y29ycmVjdA0KZm9yIGtlcm5lbCBJT0FQSUMuIFRoZSBvcmlnaW5hbCBjb2RlICh3aGljaCBpcyBu
b3cgcmVkdW5kYW50KSBkb2VzIHRoaXMgdmVyeSANCmxhdGUgaW4ga3ZtX2lvYXBpY191cGRhdGVf
ZW9pX29uZSgpLg0KDQoNCg0K

