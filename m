Return-Path: <kvm+bounces-40181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99123A50C67
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 21:22:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1C353A9818
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 20:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F422255250;
	Wed,  5 Mar 2025 20:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qzJiLJrV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qzJiLJrV"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013056.outbound.protection.outlook.com [40.107.159.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3390C2459FC;
	Wed,  5 Mar 2025 20:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206143; cv=fail; b=p4uiQjhGuys7mQp9VbLZ8huog51h+ap2uS5gzUAvotAw7rS8Bi46AzXYG4cr1Cv/vZY16ogcU6HTlWT7xRDEO5MZTYajx4l8gAdLrlDAanMqxdfRsjnm6gS149OqdKHct54CEWBAldJxy+S+Sl7ys3isZ16ozZRizM7Hb4nSIQs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206143; c=relaxed/simple;
	bh=j1NrfdBT9nB5/o/U+z6ZWWa83PqVVmX+2a0ZZ8e+dmc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cnd4yDZ5GqSIrrp8MiX9EFgj8t5jI4/GuiDSAPWV9DolNE9eildys5GQhPOsMXzSYPpmX58LJAjFGTpfM2gpK0o5aFYqE31FEms/vNqNhpaFIGSZ+M4jRXkQT7ITTL6PpE1/A8J4wJbKa00OsZNgP/HWb94Ml6ZWcvLNiJ4kH4g=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qzJiLJrV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qzJiLJrV; arc=fail smtp.client-ip=40.107.159.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dVlPwsyZ/zpHmtBCF/ToVu2P0rMCcYHcZQSvz6sscm0nQoNoW8fkUV70E6xQTH6umUKtqqSAyv+KCg6nxTwOe2c81+yAQMzHoS1zlk8WbMwG5HCOUzI6ZZSABgm4FJBPtjaugQFYyy9wJmYvY+OFLUY4jAa/LNiNcF6KvRqIE5gFAb7m7XTlElSlI8kcPJdiiAoKPF2Wxwcj1idPDf2RFfyFICl+SkgNg6znWYKlq1GuXqkfTCPgFpihusWPSYJSMLJfyCHyCSTYN3yY8xaU3JXr2jeKVjoB67Ulkw8DHgnDTPk0Hz7AcSLIhoNIr9RYs5VjKzNg+WssupEVoWrJNQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1NrfdBT9nB5/o/U+z6ZWWa83PqVVmX+2a0ZZ8e+dmc=;
 b=wvy/hyAvcWfX1SYOTZTMRJx3BeueE1TjoISD16dBDKzEZk9rJ+fnSPx8BnqUw99464aO4oF+VUKtZfzXRzzouacv+osXNBjiB2bYoL7E3OkxtcT13z0479Y5nbRv3nKv9JE9D/mVBMWURAd3REyGhS6hcGO6jSn5hVHsQc3MX9fg/UWVjL8sYdsCLK//ewbWBUyVldYESJIejBhpCLX4gIpqpSAcAS+fii0KpykuUmvlDUyM0yImQJ/vmsICsaSa5OpRcuDItbAPuswcfYwPXZ8gPs8mi+cUtOu6qU9OKkYVZsv3aBgR2Dw0Xwo9e3A0UJU1Xj8f7JTQP/Ex03dyuw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1NrfdBT9nB5/o/U+z6ZWWa83PqVVmX+2a0ZZ8e+dmc=;
 b=qzJiLJrVwtiRAiZhGjIP58J6V3CgRasZGKsRXOCTuFByqd3855P0TT9NufV6UYgxY670uQX1PTaP0tY+mS+IeRiHO2sG7Ahd6jaiDt7Pf/T7QVQDeSz7Od1g+prZzxDRihwOw8KsumFuu2a3oPhHgZoPDUfi2OG521qVhjpxvOg=
Received: from DB7PR02CA0002.eurprd02.prod.outlook.com (2603:10a6:10:52::15)
 by GVXPR08MB10614.eurprd08.prod.outlook.com (2603:10a6:150:14f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Wed, 5 Mar
 2025 20:22:11 +0000
Received: from DU2PEPF00028D01.eurprd03.prod.outlook.com
 (2603:10a6:10:52:cafe::57) by DB7PR02CA0002.outlook.office365.com
 (2603:10a6:10:52::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.17 via Frontend Transport; Wed,
 5 Mar 2025 20:22:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DU2PEPF00028D01.mail.protection.outlook.com (10.167.242.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.15
 via Frontend Transport; Wed, 5 Mar 2025 20:22:10 +0000
Received: ("Tessian outbound 678e42ac23ee:v585"); Wed, 05 Mar 2025 20:22:10 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8ddbc324be5477a4
X-TessianGatewayMetadata: /zuThLR8xwpKo11/rgv6AD9BUJi7bBB3sOiCTRYSMf6AracYU0p36vmBwGsM79F+znHtvzjpp5NcKIOF693+/RElI986vstZDjV8S9enxH9e1WyciFBVBhzFkM+ZD4b3ipJFiYRlf0UlbU3hRMYUGDhuw1c+cTHRjBJflng+NqK0vyXWcEgIA4LSo10aQGerhJV4HbJmSGkND9jn77pnrg==
X-CR-MTA-TID: 64aa7808
Received: from L9c22a00fb817.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6C573D01-8BA6-44CB-8DD5-43821A44BCC6.1;
	Wed, 05 Mar 2025 20:22:00 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L9c22a00fb817.2
    (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
    Wed, 05 Mar 2025 20:22:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nrp/kVRchMDNRKs+onUCT6tilPpItOc4+IvOcts95io98g7vHlsZMSzw+37aVv2h6OGSPYdFNSzxRVxPpzIFGFrn2Iernj18Gw710EHKl81Bh39aDUGN+UgB+GEt83dF3/WrZ/SLAvqZw3jGbqtofFrq3flfoEwy1BVGInWPP2qnWVsmiFY8cGJ6OJ5azG+SifH42i+blrW26kaHR+u7LD2u+XtEbY8aStW0hJvJDbo912qFEsLMEBzxIgyiy4hEqUigfB+ajMAriQIJAD5jzN+uQdFo/H4pcc8HmAAwnVVveGRs13jmFnSDNLs1Vpp/aBgCOJgTKypzsZ6C/0dDvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1NrfdBT9nB5/o/U+z6ZWWa83PqVVmX+2a0ZZ8e+dmc=;
 b=DuthiMAuI4LZ9br+YeOCJgP1e3L+1BsRkAmfnu7QLdgR2LwpyCBC7g0CGbPhzUHuxIuJTmtgsMxdSbjWj6p/+/5C0/4Y1lxGY69/4S6rlTQNpaeFJ030rikL+VscDkdqB/LSqEPHa2hQcA+K0bNrX5hC7MQuFXcbALddMhYoXsivt5H2z34v/pdciUjsWoVko8dhrelHq4EvYZL8Rp+qmkcVtYKIQhwJ1+D+GBAW+dDCVR30t8wdmsN1O4kHuF5mbxRPeekIOhwnUsmqfGvAopX3NFHGlDhCwfy7t4HMUc/vh4aeF4ipP4opqdQcxXnCPAHa7BUcVtDipazO+fH9iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1NrfdBT9nB5/o/U+z6ZWWa83PqVVmX+2a0ZZ8e+dmc=;
 b=qzJiLJrVwtiRAiZhGjIP58J6V3CgRasZGKsRXOCTuFByqd3855P0TT9NufV6UYgxY670uQX1PTaP0tY+mS+IeRiHO2sG7Ahd6jaiDt7Pf/T7QVQDeSz7Od1g+prZzxDRihwOw8KsumFuu2a3oPhHgZoPDUfi2OG521qVhjpxvOg=
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com (2603:10a6:102:33a::19)
 by AS8PR08MB8442.eurprd08.prod.outlook.com (2603:10a6:20b:568::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Wed, 5 Mar
 2025 20:21:57 +0000
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294]) by PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294%5]) with mapi id 15.20.8511.015; Wed, 5 Mar 2025
 20:21:57 +0000
From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Williamson <alex.williamson@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd
	<nd@arm.com>, Kevin Tian <kevin.tian@intel.com>, Philipp Stanner
	<pstanner@redhat.com>, Yunxiang Li <Yunxiang.Li@amd.com>, "Dr. David Alan
 Gilbert" <linux@treblig.org>, Ankit Agrawal <ankita@nvidia.com>, "open
 list:VFIO DRIVER" <kvm@vger.kernel.org>, Dhruv Tripathi
	<Dhruv.Tripathi@arm.com>, Honnappa Nagarahalli
	<Honnappa.Nagarahalli@arm.com>, Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index:
 AQHbhLKEApVfqCfEsEO/VXZQklRIvLNjFiyAgACJGACAADH7gIAAQ1nQgADjEQCAAA+N8A==
Date: Wed, 5 Mar 2025 20:21:57 +0000
Message-ID:
 <PAWPR08MB8909ECF0B0D9DE942C71BDAD9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
 <20250304141447.GY5011@ziepe.ca>
 <PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250305185806.GB354403@ziepe.ca>
In-Reply-To: <20250305185806.GB354403@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAWPR08MB8909:EE_|AS8PR08MB8442:EE_|DU2PEPF00028D01:EE_|GVXPR08MB10614:EE_
X-MS-Office365-Filtering-Correlation-Id: b20beb03-e146-4419-7c8d-08dd5c2368fe
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?NnJxRk85eDl5MDNFZWlKVXN2NldWMEFNQ2ZibkdwT3Y1aHhGQUZVYTMzM3ha?=
 =?utf-8?B?cmloQ3daZ3ErNXVocXNVK3FiMFhBeWc3OVlQckdvUHpkdkhTMG9YczB6N3hy?=
 =?utf-8?B?R1JTZi9tczJEUVRJdVRhRmM3WUtQUWtiNnpnemUzMDdxV0pvU3l1TkxpREFR?=
 =?utf-8?B?MXNFZm9oMUh6UFZCWTdDeEFrcFdPN2M5ajZ4QWtFTjVzYm9nKzNiZzZubE4r?=
 =?utf-8?B?RHlHNEVrNHZncTltcE9vTXpBSVJqVGNTNisrMlRiOHFkS08zZ1ptOVUvTHFt?=
 =?utf-8?B?UGd6WitpZ3RQZEVYWFZ4TElZdjl1RkxSWmlvK3BJR3ZpU3c2SWhjbURtS0ZY?=
 =?utf-8?B?VktPVmJaTTJpNnFCTUJBdHl6b3QvVG9RaWlTVTQwMS9IcDh4MFlTZHJyQmZS?=
 =?utf-8?B?YlplVUFyNEVQQnh5ZjlpQUh5UlM1MDlDWHN1VWlBa2NKUDBzRTdzNnF0TExw?=
 =?utf-8?B?TjlXcFEyUTlBd0k2SS8vZENTQVRKaUhBR1pyYzJFRXAxK3dXclBWZVhmd0ZH?=
 =?utf-8?B?dHgva3NCUG5wTk91UHNpdTliMVJXZUYvWUJlQ2NOVXQ1UUllSGlXV3gwK1ZZ?=
 =?utf-8?B?akgvMFNxL2J6R2tCb0tKb3NFVGZzNTFNellzVXJuOUpYMFVuYm55NjlLTkF5?=
 =?utf-8?B?VTl1YjVKYnhNNjBoSjhVd1VEbWJ0S05LYmloL0ZtMFNZWkhhZ2xPTFdHTW9i?=
 =?utf-8?B?V2ZMMTE3dS9rRkJPTDZwZHI0QktiRzU1MnR0YjFKZUFkZ0NzU29YSnk1NVhZ?=
 =?utf-8?B?VHdHZG1DbVo5TmpMZCtiQWZzZUNHdVZIR2x6RUpKVnNVY1IvdjN4OFRTT2R6?=
 =?utf-8?B?MFk2YWFjT3pmejhrRVNuNnhjMm5pSm0zQjk0V2t5MUoyQ0hVR0phb28vYW1V?=
 =?utf-8?B?M2RJNEs5NVJLQWVDeGNzTnVpR1lFbHhXZW56ZlRVS1RDR0poTTBWalZ5R2ln?=
 =?utf-8?B?QTN4NmJBaGRTNGU4RVFCd1ZHdTdHUFhkL29ySVhkWTZWdU5FR3dvRVcrMW1a?=
 =?utf-8?B?aDFTNTdvWThaMHFtZXJDaW02UUpVc2FRTzNFWVhYa3VCTEpCWEM4WVAzUnh2?=
 =?utf-8?B?M1FMN1BmdWlSNGRZRGdqTERaMzBBMGRRbWMzMlB4QUpFdzlpbmtldmVVcXlJ?=
 =?utf-8?B?cVlQTjJQS0VmWmRHTERPNzBDWlU3aVVQSXBNKzdIQ3ZRVXp4MFI3OXBiOVda?=
 =?utf-8?B?Slg5eEFGMnVJbUFvaHNmUVVlZEg0U1MxdmZrK2xuREh0MytqcGludDh1Mitz?=
 =?utf-8?B?dkE3SGl5Yk50dUpwWUZvT05qUVRVTDY2ZG9saElidk5aRXJuc1A5T3o2d0sz?=
 =?utf-8?B?a2VTMTBGOUxOQzBjTnh5TXczYlB3elBreFdDMXNYY3B3N2NwOHhJamhOOElz?=
 =?utf-8?B?bWVhWWJ6QkkrWndoaDJYenh3aU9nblRsd3l2TWVtSDZpTXJZbG1vT3E5ZlRN?=
 =?utf-8?B?RVZhSHBTamJRUUcxN3BnWDJRa21DZVFnd2wzT3RBL1ZVMExvTXgvVWw3WW9O?=
 =?utf-8?B?U0FJWDJXQ0lIUXZ5RDBIc3MwMElvbC9mM0NnVVVxU2VFbWxXaUQzMldCdTBt?=
 =?utf-8?B?MnRKOFl2N2YwL0k1ZGFuU2o5d3JxZ0hWVkJydXlsVm1UMkZRWmcwUnErenZ5?=
 =?utf-8?B?MUtxOVpPTy9xS0tENHZMelRYcGJINjRqdmRPZ0thNk9RdG80cFkwZW1ZQjc2?=
 =?utf-8?B?YTA0cE94blFYTm56b2xDaS9NVnpwYjg1YUd6RWcvOXBkdUFaVmxwQ3oydjJC?=
 =?utf-8?B?WU1mcU0wTHl2c3N0MklEZ0xzcDZXRkowVUo2U3M3OE4rWmxVaWVuVTRybGxN?=
 =?utf-8?B?K3VaSWNxODZ4MFVGQUtkU29maDFsTlNFcFRza0RMUHp6R3YxSGt2TElibExv?=
 =?utf-8?B?NWVUSWQraWVvbmF3RzAyQXZyQ0UrV0ZDWWpsU001UTBLT0dTYVEvVE4zZGhG?=
 =?utf-8?Q?zeRbEpvbbvwwzcf5ij21nA0POeSlsHq1?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB8909.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8442
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:102:33a::19];domain=PAWPR08MB8909.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	304528e3-09fa-44e5-7466-08dd5c2360a8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDNoRGVncnBUMEtPN09VYjBua0hxdGQxL0FnQ1NVNnFSL1BtQkJpLzl2bDhE?=
 =?utf-8?B?NkE2R3U3WWRUZ3kxMWJSb1hpR1F4NmUxb3NwWHF0d3hOWjFHaitDVnVLTzl1?=
 =?utf-8?B?Um9oWitITHFuVWE1NWZWQk93Q0tOelo1ejdMVk5hT2ZnVUtrU3BzUXZ5R28v?=
 =?utf-8?B?Z1JxK1Y2dGorQWkzc0hVdEd4M3hsWENoYkZOcmlDWEVjdUpnWlBWNXdSM0FN?=
 =?utf-8?B?U3VDWHRhczRtaXMzZU5jWDJQVXZEVnBOaUFGRElQVzNYWnpBVUgxY2xieWR0?=
 =?utf-8?B?UjhwaXVhaHUwR2ROcnprdm55QTViTjBFZGxqZHdCcVN2dlNCNm1Kd2lYcXlU?=
 =?utf-8?B?WHo0NHNJL1dmTnZRbis5N081ZFpXNktYWHp5QnE3MklmdVRwVFZkenFhM2J0?=
 =?utf-8?B?YVJlSFFUaHozTlZudXlBRVZvcExxUVo0LzN4MEVBYkw3ek53S0ZDTVJVYy9D?=
 =?utf-8?B?V2EyTzdydVhaeFBETi8rdkFUUmNVZUtYd05obFc3c0JxejlFQ2FlTUY0R3NT?=
 =?utf-8?B?OXE4Y3pCcUhvTU1CZ1Y4MEVSOU1xNUNPSGNUbkhKYWtER0RYaU1abklGSjVx?=
 =?utf-8?B?WGVnaFIzOXpVV0hRb3pTdDRVZFRsWHJJeVRkaEw1N0grY3dCcXI4V1VpeGlw?=
 =?utf-8?B?S1lXR3hZelg4aFFRQ1dDWEtXUlRQUTI5R09hVUcvSWEydG8rRUd2YjlyV01O?=
 =?utf-8?B?SnY5U0tvdHgxR0JBOFNUenNmR2ZEam4wa0ZUVElxR3FHZ0xUek0ySjlRVUsv?=
 =?utf-8?B?d0NPRHkwelhUandoZTBGSFpocmhCSjN2RHRlNCtaMFhsYWUvb00xaWdTZEp5?=
 =?utf-8?B?MGtHWDQ0VnRTbmtVSURpV1lvWjJYOC80SytvUlRQVVE2SWYwQlA4WTFseGNI?=
 =?utf-8?B?N2daazZWdjVqMWw5c1ZmcGhLRkg3TjU5RStpOFpkWWRabnNyejZtRjVMU1Rx?=
 =?utf-8?B?b1VIRWFWc1pnZGZmVTZMQk91aHAvWk9lL0ljMGRzcStmb3B6QXY4QzBBeFNO?=
 =?utf-8?B?UmQ4RTNIOGFKeE5Gc0pVN25xaVhnZzUvT3oybVVjT2xMZ2ppL0hYL1RlcHg1?=
 =?utf-8?B?NklMWFNiQUJJd3Erd3JZUm1JQ3lzRXlDZkZNSWdjRms0cE5TWWdRUndMMlFj?=
 =?utf-8?B?NWdmbUYwZS9aREJQLzBrNmhTUjR2Q0taT3NVM0JRTmxxUnd6SnFOVVRMNzVC?=
 =?utf-8?B?TEd6SU44aU14OVRERnAvVXJvek1hV25UV1d1QTM1WTMxWDI2eHg4RXFQOFlm?=
 =?utf-8?B?Mnc0SmFvZlExRk1RVEtFNVZYRS84TXo5UWZDb29oNlNJQkphdzlxZ0FQdjUy?=
 =?utf-8?B?eVJLVEZWS2FMRHR6M3Z3V3VvWGdtbnZQdFVjZ3lENTlJeEJTSytyTXlVdDda?=
 =?utf-8?B?Y0RZYWVZNW0ydDZGdUNRclhDMEhMM2M1N210VGNyMXhpWmZEUHZwSGJCbEVu?=
 =?utf-8?B?blhsUWEvQkZkTlB2NDd0cXRGalZtWUl2cGhlcGJJdGlURkNFRmtwQ045MldB?=
 =?utf-8?B?b3c5Vnp0WWFsSkNDblREUmZIUGFxZys1ZGN6NVdHZlNvSDBDYUMrcEtrR0pj?=
 =?utf-8?B?ZEVIUGNteHc0RkUxWW1rek45Z0V6ZWVUWmJ3Mmd6SXg1eXdiekJjQlVLWDBo?=
 =?utf-8?B?UnlUMWs4OVkrYngrd3lUOUNhMkR1bTgwYVllUTBVREhlRytlQW1GZDVnVGxP?=
 =?utf-8?B?enlLbjdjamg1NlJwZlpQUWNZU0xNS2NPb2wweEZ5Q3VKMFJxZy84dkg0U0tC?=
 =?utf-8?B?NzU1c3p2Um1IYnhtalZvQ1NxZjh3WkdwOWxGY01EZGJ1VE5uMkdNWGlJdHVC?=
 =?utf-8?B?eHpLL2pMYmRPMm9obkVJYTErNktNWFdBMGNzSTN2UDNjNUZwbmRLcUdScVhL?=
 =?utf-8?B?Z091SVNDWGFINHNaZ3dJWFZIV3RCM1R6R01JWDJHTEJ4TUdWZ1FWNjVSd1Zy?=
 =?utf-8?B?Y0E1VmZDejlodWV0SmYyanJPd0lVbTRLbm90d050ZVV1SmNVY1grVmRza2Mr?=
 =?utf-8?Q?6owGYVIZrm7V9iJ0pboGYH2kM3NC3A=3D?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:64aa7808-outbound-1.mta.getcheckrecipient.com;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 20:22:10.8316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b20beb03-e146-4419-7c8d-08dd5c2368fe
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10614

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gR3VudGhvcnBl
IDxqZ2dAemllcGUuY2E+DQo+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggNSwgMjAyNSAxMjo1OCBQ
TQ0KPiBUbzogV2F0aHNhbGEgV2F0aGF3YW5hIFZpdGhhbmFnZSA8d2F0aHNhbGEudml0aGFuYWdl
QGFybS5jb20+DQo+IENjOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQu
Y29tPjsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5kIDxuZEBhcm0uY29tPjsg
S2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+Ow0KPiBQaGlsaXBwIFN0YW5uZXIgPHBz
dGFubmVyQHJlZGhhdC5jb20+OyBZdW54aWFuZyBMaSA8WXVueGlhbmcuTGlAYW1kLmNvbT47DQo+
IERyLiBEYXZpZCBBbGFuIEdpbGJlcnQgPGxpbnV4QHRyZWJsaWcub3JnPjsgQW5raXQgQWdyYXdh
bCA8YW5raXRhQG52aWRpYS5jb20+Ow0KPiBvcGVuIGxpc3Q6VkZJTyBEUklWRVIgPGt2bUB2Z2Vy
Lmtlcm5lbC5vcmc+OyBEaHJ1diBUcmlwYXRoaQ0KPiA8RGhydXYuVHJpcGF0aGlAYXJtLmNvbT47
IEhvbm5hcHBhIE5hZ2FyYWhhbGxpDQo+IDxIb25uYXBwYS5OYWdhcmFoYWxsaUBhcm0uY29tPjsg
SmVyZW15IExpbnRvbiA8SmVyZW15LkxpbnRvbkBhcm0uY29tPg0KPiBTdWJqZWN0OiBSZTogW1JG
QyBQQVRDSF0gdmZpby9wY2k6IGFkZCBQQ0llIFRQSCB0byBkZXZpY2UgZmVhdHVyZSBpb2N0bA0K
PiANCj4gT24gV2VkLCBNYXIgMDUsIDIwMjUgYXQgMDY6MTE6MjJBTSArMDAwMCwgV2F0aHNhbGEg
V2F0aGF3YW5hIFZpdGhhbmFnZQ0KPiB3cm90ZToNCj4gDQo+ID4gQnkgbm90IGVuYWJsaW5nIFRQ
SCBpbiBkZXZpY2Utc3BlY2lmaWMgbW9kZSwgaHlwZXJ2aXNvcnMgY2FuIGVuc3VyZQ0KPiA+IHRo
YXQgc2V0dGluZyBhbiBTVCBpbiBhIGRldmljZS1zcGVjaWZpYyBsb2NhdGlvbiAobGlrZSBxdWV1
ZSBjb250ZXh0cykNCj4gPiB3aWxsIGhhdmUgbm8gZWZmZWN0LiBWTXMgc2hvdWxkIGFsc28gbm90
IGJlIGFsbG93ZWQgdG8gZW5hYmxlIFRQSC4NCj4gDQo+IFNvIG1hbnkgd29ya2xvYWRzIHJ1biBp
bnNpZGUgVk1zIG5vdyBmb3Igc2VjdXJpdHkgcmVhc29ucyB0aGF0IGlzIG5vdCBhDQo+IHJlYXNv
bmFibGUgYXBwcm9hY2guDQo+IA0KPiA+IEkgYmVsaWV2ZSB0aGlzIGNvdWxkDQo+ID4gYmUgZW5m
b3JjZWQgYnkgdHJhcHBpbmcgKGNhdXNpbmcgVk0gZXhpdHMpIG9uIE1TSS1YL1NUIHRhYmxlIHdy
aXRlcy4NCj4gDQo+IFllcywgSSB0aGluayB0aGlzIHdhcyBhbHdheXMgcGFydCBvZiB0aGUgcGxh
biBmb3IgdmlydHVhbGl6YXRpb24gd2hlbiB1c2luZyBhIE1TSS1YDQo+IHRhYmxlLg0KPiANCj4g
PiBIYXZpbmcgc2FpZCB0aGF0LCByZWdhcmRsZXNzIG9mIHRoaXMgcHJvcG9zYWwgb3IgdGhlIGF2
YWlsYWJpbGl0eSBvZg0KPiA+IGtlcm5lbCBUUEggc3VwcG9ydCwgYSBWRklPIGRyaXZlciBjb3Vs
ZCBlbmFibGUgVFBIIGFuZCBzZXQgYW4NCj4gPiBhcmJpdHJhcnkgU1Qgb24gdGhlIE1TSS1YL1NU
IHRhYmxlIG9yIGEgZGV2aWNlLXNwZWNpZmljIGxvY2F0aW9uIG9uDQo+ID4gc3VwcG9ydGVkIHBs
YXRmb3Jtcy4gSWYgdGhlIGRyaXZlciBkb2Vzbid0IGhhdmUgYSBsaXN0IG9mIHZhbGlkIFNUcywN
Cj4gPiBpdCBjYW4gZW51bWVyYXRlIDgtIG9yIDE2LWJpdCBTVHMgYW5kIG1lYXN1cmUgYWNjZXNz
IGxhdGVuY2llcyB0byBkZXRlcm1pbmUNCj4gdmFsaWQgb25lcy4NCj4gDQo+IEFuZCB5b3UgdGhp
bmsgaXQgaXMgYWJzb2x1dGVseSB0cnVlIHRoYXQgbm8gVFBIIHZhbHVlIGNhbiBjYXVzZSBhIHBs
YXRmb3JtDQo+IG1hbGZ1bmN0aW9uIG9yIHNlY3VyaXR5IGZhaWx1cmU/DQo+IA0KDQpJIHRoaW5r
IHN1Y2ggaGFyZHdhcmUgYnVncyBhcmUgaW5ldml0YWJsZSA6KS4NCldvdWxkIGRpc2FibGluZyBU
UEggaW4gdGhlIGtlcm5lbCBhbmQgcHJldmVudGluZyBjb25maWctd3JpdGVzIHRoYXQgZW5hYmxl
cw0KVFBIIGZyb20gdGhlIHVzZXItc3BhY2UgYnkgdHJhcHBpbmcgdGhlbSBpbiB0aGUga2VybmVs
IHdvcmsgYXMgYSBzb2x1dGlvbj8NClRoYXQgcmVxdWlyZXMgdHJhcHBpbmcgY29uZmlnLXdyaXRl
cy4NCg0KLS13YXRoc2FsYQ0KDQoNCg0KDQo=

