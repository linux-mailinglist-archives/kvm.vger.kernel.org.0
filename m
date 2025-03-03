Return-Path: <kvm+bounces-39911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC98A4C9B6
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:36:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A2CF7A3DB6
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA65F23C8B9;
	Mon,  3 Mar 2025 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="giLfkpk8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="giLfkpk8"
X-Original-To: kvm@vger.kernel.org
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2055.outbound.protection.outlook.com [40.107.105.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD823C8A8;
	Mon,  3 Mar 2025 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741022509; cv=fail; b=jmUIHygL+AFsHNr3X98L1Fk8ydhnjksRkpvApb7tx6ksruiaWXK682CGKX9Pzy/O6B3kwU1Cmchn0sxRrxW3UdgE7nNN1NH4KCzad3bmwpOeCT6Txmho4SFh6Ci5OhmK2WT73zcnREDiT0mt1uUwPOORETJNevRs6pLVVJO5Wbo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741022509; c=relaxed/simple;
	bh=29d1xX6nZ9VK5Y/5F66eZg2Bt7Jg4H+qtWQsFWfz5QQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Os1V2/ghjWsAHV+jaoJp84kvgIj8dIlgRCynhqYEACMzsUmw/Bg4FKpM40RBM+7vid9seUXnE0DtV3qW4J9k1v1K8CpDf6cJNpQcLL+H9wURW+d2xum0EiKsH8pekQPkVMsaOvFwyK2ZLE26FKvf3APEVsuBUosVRnHvaCurWNw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=giLfkpk8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=giLfkpk8; arc=fail smtp.client-ip=40.107.105.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KDn2bB13InEmtF1ppAwqYZ+8RZrNxXOgKEUNvRoiK/0hlMZNA5BOp5E4ocHfkmAur06N/qRnW62eu2eHZCqLzEP/B4munVEw8HlE0ue4kzPfRSYzfhMsF1Innsz/tNJV7GuBTszbM19w1MZwYFhzattjaYBnGX3JtA4UedPI381ZwHVzetOtMKuViPX9nZLyw04EM2L/ulEK2kG3QIwKvgc2usKRr7xzkGkPl4QMnP2HWnsQuboG6o/JxAmHI6GNJgarzRDijcmYxKqoUEOvbYPRQf6Z5OXOH5RVFdMU14HiPa4PHtAolR7lg4ovD+1WPFy2axkxrWbgcSgJs71ZrQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29d1xX6nZ9VK5Y/5F66eZg2Bt7Jg4H+qtWQsFWfz5QQ=;
 b=k82phb8hjhglQSQZ/twJqRxBnWY5NFERguo6LjP9AtJ8kcVaa0o9vqZu5Gnjl7hrhVSFqeAiltqgZDSu5nwiLI5xf8VRNf2ItLaU5OiIwXfkFnd8SZ+M/xdFoVmPB1DIhXyLPNZPQZCWv1xGiBIiUoNJMPFyyoZUnZr7SPfFapQATwlo0/DA8dgmWMnTnmF3n10r0MAVDpntF+moGP7M+Q3bewxsmEQizSkKqI/VXTklloie7XA4G2+QTJ2cgodHBjlKNNBoz1bFcmfrtvA28dGnxFNx1ycRlkUEk1wWFJRpUtzJkOVHd+TwB/EAA4FtNEBB7a2KAziEuA+QpooBkA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29d1xX6nZ9VK5Y/5F66eZg2Bt7Jg4H+qtWQsFWfz5QQ=;
 b=giLfkpk8/izBSzuBGL/NynkdF3kKF8z6ofYsocldxz1Gl2CTVjIuTGC9Ysiaj8LGb7CSSJ5dc4XPwppJj2+7PaocgZvMI+xJ4GGTsudLhgcqrMn2nJWZvc/nVY+DukuZipVoPlDN3unABRxRm8YMATMwtON8oFuCaZLK/LXkYuM=
Received: from DUZPR01CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::11) by PAVPR08MB10340.eurprd08.prod.outlook.com
 (2603:10a6:102:30b::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Mon, 3 Mar
 2025 17:21:42 +0000
Received: from DU6PEPF00009526.eurprd02.prod.outlook.com
 (2603:10a6:10:3c2:cafe::d2) by DUZPR01CA0073.outlook.office365.com
 (2603:10a6:10:3c2::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.28 via Frontend Transport; Mon,
 3 Mar 2025 17:21:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DU6PEPF00009526.mail.protection.outlook.com (10.167.8.7) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.15 via
 Frontend Transport; Mon, 3 Mar 2025 17:21:42 +0000
Received: ("Tessian outbound c3a902884497:v585"); Mon, 03 Mar 2025 17:21:42 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 6d5bfed02f15a552
X-TessianGatewayMetadata: Y8htF6PHyc37AliBkL/WfW/eGf2pe4JsXUTRl7BlAbyVEdfYfZhop5RoKd18yQJDitUVsRJiqyz8a8Hl8Nkx3/ohaXYJR/h6E7RNjDAKhWTki8/c8NktWVcvPYlvZ1deO38jdMTpvPeruJBbXM28Via3YH/8Av03nsrMaJ/1UncXDKIGqai6qvEBETE9umhh6lbkfoTGMSl5YXys0Pzcyw==
X-CR-MTA-TID: 64aa7808
Received: from L8bbc48786312.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 4577F7AB-FD79-46FF-8680-7C2800F2149A.1;
	Mon, 03 Mar 2025 17:21:36 +0000
Received: from DUZPR83CU001.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L8bbc48786312.2
    (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
    Mon, 03 Mar 2025 17:21:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lhbq3j9DjDHi4Xb0vgId03WXPRNEdUNlY8rIkeTvBw7FnUa5vn/jYLGowgIuEctDeifE+PUHvaldQRZagNSNg3BvJTXUhIKDIY11b1NCGET6qI4sAJQitX6/ktYj8h3eR0gJpfnKc6yWznEuSZXCOoscK8Zz5Zj0sHoZQm01yI+VQKLVpM2HCO2RTZNu5DeSjHSnjGGutYGKbUNE9If8DgVwCdWHzSj5JuK2coaaETeAnWEfrmoh1rmDK/4zLoei9FS6wzkAhjZQZGFJ9IczXJKfahJJF6Zh+D40nVTNxaYUJEjLTAhXSk3D1DjM8rDQ9x92QOWCj2ReQHEEA7Qq5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29d1xX6nZ9VK5Y/5F66eZg2Bt7Jg4H+qtWQsFWfz5QQ=;
 b=R60GL6+uqt6oDcWcQCTFlMQcPZ3yij8RZ/jJ5UeZkZqzE8Jh1787wlltRLqBEtuB8HpznUFHVqU1qYnzRgPl7lFH81qLbN78dXPdnzO0KKa6u+JfrAmHG8Y11OWH/Y/ND0yrW1ehKLVv6zqhvd3Qy6wOa0Bo0vrCpZQZV4mCkhdtA+jkBNPM2ToLENxicpeJdpt8nbgKugnP4stwH+lkMnfIfBJhZ6wshf9nbdoFLw1yXE0NbX2W0Qw9SpTHbSCs/PEBH94lCozowntBUkzs2YmUxugW8GTLYn3d1mr9/FFoHqfNzqS4uKPbuWHF3NToOQexdLPw98l53Usu+YtSPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29d1xX6nZ9VK5Y/5F66eZg2Bt7Jg4H+qtWQsFWfz5QQ=;
 b=giLfkpk8/izBSzuBGL/NynkdF3kKF8z6ofYsocldxz1Gl2CTVjIuTGC9Ysiaj8LGb7CSSJ5dc4XPwppJj2+7PaocgZvMI+xJ4GGTsudLhgcqrMn2nJWZvc/nVY+DukuZipVoPlDN3unABRxRm8YMATMwtON8oFuCaZLK/LXkYuM=
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com (2603:10a6:102:33a::19)
 by AS1PR08MB7427.eurprd08.prod.outlook.com (2603:10a6:20b:4c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.27; Mon, 3 Mar
 2025 17:21:33 +0000
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294]) by PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294%5]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 17:21:33 +0000
From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
To: Philipp Stanner <pstanner@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: nd <nd@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Yunxiang Li
	<Yunxiang.Li@amd.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Ankit
 Agrawal <ankita@nvidia.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	Honnappa Nagarahalli <Honnappa.Nagarahalli@arm.com>, Dhruv Tripathi
	<Dhruv.Tripathi@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index: AQHbhLKEApVfqCfEsEO/VXZQklRIvLNhGBcAgACH2KA=
Date: Mon, 3 Mar 2025 17:21:33 +0000
Message-ID:
 <PAWPR08MB89096A5C954CCABB248609859FC92@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
 <c30b50066aa0910538bf3cacd046d9c58984fb60.camel@redhat.com>
In-Reply-To: <c30b50066aa0910538bf3cacd046d9c58984fb60.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAWPR08MB8909:EE_|AS1PR08MB7427:EE_|DU6PEPF00009526:EE_|PAVPR08MB10340:EE_
X-MS-Office365-Filtering-Correlation-Id: df8fd5af-e5d9-4136-fb51-08dd5a77ddaa
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cFIyZldQeFBGQ2lSbVdGQ0t2MFdNVVNpUWhjejBBNVlMbnh4MUxIeUgvUGtI?=
 =?utf-8?B?QzN6cXdCWnF3bVp2RFlaZ29Obkh4RDJBblJRMFRObW56YkRxWElBV3VmeFpo?=
 =?utf-8?B?d3A5cnVtY0xJNTc4TCtUZlJqSFdHZlZ1cFdjYVlycmpSWDgyaFF5ZEtjckFJ?=
 =?utf-8?B?OTNwVGpCQ1Y2b1l3MTdITEJ4ZnlzcFJEYXA4ZXo1YjZlQkVvakNyekNvV3lG?=
 =?utf-8?B?clhZT1c4aFZXaDNCQ2RoUm1FVjUrak5CQTdPdnBJekFIbW1SV0Y5b3cwNVpy?=
 =?utf-8?B?ZStvVUdHVHhnVkFJdTlXcDE0QjZ1N0owUGpDK0NKT05PMUt2NFBid0VyTmxP?=
 =?utf-8?B?U29zT01McFJJUTFqUU43aVkvdHp0OXBpTlJqNUg2Z0JlSldSd0xBVVZVSm0r?=
 =?utf-8?B?ZTJLbDNUZ2xxREMxb01HVFFTMTQrb0MxVm0xZ2d6VXhPZld2ZkZ3U2w5ektH?=
 =?utf-8?B?VTdzZ01IRk9ZNVQyNERBTmxtVXFBMk1LZEZRYTB3VEV4TTlFMVptMTVTUUpI?=
 =?utf-8?B?cVRZaldWZ3pkenBTb2cxMWd2b3NJbW8zSHY2YUVZRG9hSXFQbjZjOHlSM1ZG?=
 =?utf-8?B?QUFQYnVsU1ljaUR3aEFiMURGVWRDN0JiUi80akg5NnRMSmorOXBKWWV6UlRj?=
 =?utf-8?B?TTRGOUljSWdpdVFNWU1ENjQ3YldBRmk2MDZDbFNQMkNkejRkSUhwTDJOdjNR?=
 =?utf-8?B?MFJhZnRQSWZpMXZQTFM5ZlA3SWdoU3hvRDRCdURjT2grNmdVcE1GYTB2Ujc2?=
 =?utf-8?B?dTh3MmJWM3BXMnRvUTh5OERNSUsrVFl3WG10QUJMTUZudENkdW00MlFiWE5W?=
 =?utf-8?B?UXVoeE0xQUZYaDM1d09pSnM3czAzWEhWa0I0VzloNThSaSt0YUYwODRqaU9Y?=
 =?utf-8?B?UWhOVDRaS0FyVUlYMG03QUdNbS9iNXFFakpRclpoSVJpZmN4OVNjYnNtenA1?=
 =?utf-8?B?NzBOcUh6emI0NmRiSkFiTkFCQW5GTldBczBvTG5zcHF0c1Bvc09HWnU1VDJw?=
 =?utf-8?B?MkdlTVVsTXI4NGo4QWtDa0tqM0g2eUx5N0ZGOVNDajNJcXV5U3p5bkV0WFJM?=
 =?utf-8?B?Q1pab1c1emRibGhoRVVUT0U1UFlNcklRQ1RHN3FzSkRwNWcvVVloZUlTa09s?=
 =?utf-8?B?cm1aQmRqQWI4ZWNqTTdUS1hRdTg2c2NMMEUyelcvOUV0RFBwSVlneVdtZVBK?=
 =?utf-8?B?SGpLMUtTVTlLZzFyUjJJc2Z6bGZkK1YybUNQTnZHVlBabGdhRk5qdkxNZlVH?=
 =?utf-8?B?OTZHa1poOG5IbTg3bFh5L1Q0WGFWRUx3UWJENlNWWVVXYmV4UDFnQS9vaSt4?=
 =?utf-8?B?N1EvUW10ZTk3TE5MOGkvYVNZN2RNM1M1dWlNZEFYbWtaTitkd2UvNlZ3TkZq?=
 =?utf-8?B?Y2R6RVhwQ2ZOU1ZnN2FIT2RRV2xQMS9DQ1hIQkgrUFpLMHNVN3doQ3BCREly?=
 =?utf-8?B?Z0RQbVlUYmluUW9HalY3S3QxWnRuZ2E4b1NrNHc3elRYWDExWENndldPSE1N?=
 =?utf-8?B?Y3R1eCtvbzNBMEVHL0NhZWlNR1NLaEhnTmRReTA3RFU4WGZnYUcwNFhyUFhT?=
 =?utf-8?B?TXUwQmlKWXZkaEJyaFlBdGUvUGtRUUtKdXNuT0E4eFI1ZHNzVlp4bGJKc3U2?=
 =?utf-8?B?QWovL0R0NmY5MlVGSzBvbHJsdllicEVQdFducjQvc3ZsbUtiWXVqU1BjZjdj?=
 =?utf-8?B?VWhzOHZHaC8zYUhCcnNMb0xxcVRjaitwZlg2R0E5RE0zZER4SnVBWjgyVjlm?=
 =?utf-8?B?eVF5LzFrZm5PU29zcitXdVFNMGtzSmF3OE1HQUFNcitJNFdmVnlOcHorSWNn?=
 =?utf-8?B?MDgyVVVDNjgrdkRSUGhnRVE0Rk1hcUR2VkVmc3ZaS2p4Y21GbHE5NlExNDgx?=
 =?utf-8?B?WlU0QnREQjgzV3hWcFAyckExZnlCbzFDeWRmaTVHVklCY0lJeURnb0kxY3pH?=
 =?utf-8?Q?qhgyhnbumP3/lmuk4pju57Z+M/2n5VO5?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB8909.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7427
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:102:33a::19];domain=PAWPR08MB8909.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009526.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bde46e0f-6d48-4049-a09b-08dd5a77d8a3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700013|35042699022|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTBOaWQvMlMzV3YxeThYSW9NYURGUGpMQndqWCt4QXg4WndqaDNRT01hNkdW?=
 =?utf-8?B?azkyWHBVRThiZzg3OEU2U2xoQjdqQnlndDVOb3JueEVjVTNWcjJxclcwRVdl?=
 =?utf-8?B?Zi9YMFNWQWVISHBndlYrSHB5TWlxcGhtbEk3dHdJT0lMOVUyM3JSdld2VGVw?=
 =?utf-8?B?REJaRkJMbWR6Nm1uRUI4Y2hVL0ZXQ1lqYlJGNWxnYWl2WDV0bHNaUEhzNHNo?=
 =?utf-8?B?ekJIWUF6RDJwTE5vbTVNdHplQjYzL1hRa1JIUlUvZWprNHNlanRmTmZmS1lW?=
 =?utf-8?B?Rkwrbi9wRFppWFlYME8waFVWL2VzMXVOL0p2S1RReFJWMVozbEd2ZG45VVI3?=
 =?utf-8?B?WDdCaTE1TmFvMVhGK1JLdS84bUI0YkZZVTYvdDVZNzRXeDVZOFppSTRwMTUw?=
 =?utf-8?B?NUZJM0s4ck9zeXZiV0YwNkFXOEN2Y1JBb3VneEQrd2dncUhJY05sNDNnMjhY?=
 =?utf-8?B?aFVxOEdLTE1MQndabXBFSWRTa2orZDAyNDRnWXpyWlg4Q3RUR2owWFBCN3lF?=
 =?utf-8?B?YkVTSHBZUGVyc0daaVdLSXJPeGhsVkhGVnRFcmRFdWxsWGNNdmtYY1ZuVUtD?=
 =?utf-8?B?Q0szYzRYTjV2RHFHYlJ6MnB1QmlwSVZTQlRGdUowK0srWUNHTnM4KzVtS2do?=
 =?utf-8?B?OXRnYmdtSWxLdHZQaEIvdTRWa0hmVU9oS3pwbHFxa1NHYjRCNUJTOGRJajR3?=
 =?utf-8?B?NWxZc2ZMWUZmcldhL1ZrRnpFb0ZVak9xWFBqcC96cHFneHd3aHhPS2xPZHdw?=
 =?utf-8?B?eWk0MllaUFBaWEg3YUY3Ym5ZUVY3NURlUHkzMEx2YmFvRkhkdFdFaW1xZTY4?=
 =?utf-8?B?aHZ3Wld6VXFOb1B6RWJJWUxjNlNVRXVRRGtpK1pNdFFFVFpBN2VxRTM0S2Vh?=
 =?utf-8?B?OVJmR3JKTzk4WXNOaklDeWxVV0xFQzNCN2MzeDNsYWZpVmZpWHhHeHpaMW9l?=
 =?utf-8?B?RWI4VXh0WDBoNklRbStKN0ZiU3R6eUxBcHhldnhZMUNCejNqZUZyYmVOTTV1?=
 =?utf-8?B?ZVJPOUlyNFB5VUxuMVd3b3ppZmNia1hrYWdHWlp4SWs0cGxxV1BrZGZEUE9a?=
 =?utf-8?B?TkFIMWljek1GeXpvVXlZSVpnd3lQb3RuTDMxL3lpZTJTTUQ1QTZ2WURzWW9u?=
 =?utf-8?B?MDZQNUJZNC9RVnJiWXhsME14MHY0KzlRdENNQk43b1diSmdNUkZzdGJ4N3lF?=
 =?utf-8?B?SEU5WEJOUGFNUGVPMWZaOHhNR0NyRkFkbEU5MmZtNG1MNWxzZCt3bkZUTXU0?=
 =?utf-8?B?SGhEK2Q1TlBTUW1Zakd2S1NFS0ptQ3cxZjJ1ZVhVT1REdkNQb3pGdUROZ1JD?=
 =?utf-8?B?R3hJV3U3aDNHV1B6RzJEYkxMSnpEcGxVS0JScUxVZ3RKd29YY2U3SHpyNmNx?=
 =?utf-8?B?cE9KUjhjZFJLNFo5QXlhUFBieHlDWnhpV3hZOERHZEZjOVhFVHdNanh6djVr?=
 =?utf-8?B?REJoSXdHRkZXZk9wY1prblNXN3dnK3pDUnptUjRPRHl1dWlEemp5YUY3UEEx?=
 =?utf-8?B?ekRERmMydlVyVG9FbG80SityTUQ4RVBNY3pCNUxHWjRhOTNhVG5FbXNzd2VO?=
 =?utf-8?B?UGJmTHRYcGJHVGVtc1g1RWt3Zk4zMWpCeVRVdmZ5c0IrRlNDdUpBOUo2NGlX?=
 =?utf-8?B?aGJBelJvMElGVFRnNDV4V3BaRElDb1p5ODBERXRXUzZjSVBsUnVnSnJYQTRI?=
 =?utf-8?B?ZGFLWEx5dGJRenMyUGxOK3U1UFJzMm10WU10NEUvMitHaDF5aXViWGhtM0Mz?=
 =?utf-8?B?SHovdjFoVDdiNUVnNDlaZnBaRS9DUmI2SzBEL0hYYUZMeWFjWExPd0RBR2tw?=
 =?utf-8?B?L0xsdC9uRERLdVZqaGhWdk8rZm5rL2NMaU9YL0hBL1lFRXBaallKc2REcFpG?=
 =?utf-8?B?VFBxOGZJS0pKSUN4SDVrYVhkT3UzaFI2amQ2RXc2L0RsY2d4M05YNXJNeG4v?=
 =?utf-8?B?a2dCcXJ0aDRXaCtUMXlPaVhIOGJ5S2JQYjJTbzNFVjlTL3V6Zk1FZHJHVmZi?=
 =?utf-8?Q?ymUDg9NVKplpf4gzn3z2angCu7waFw=3D?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:64aa7808-outbound-1.mta.getcheckrecipient.com;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700013)(35042699022)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 17:21:42.2119
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df8fd5af-e5d9-4136-fb51-08dd5a77ddaa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009526.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB10340

PiA+ICtzdGF0aWMgc3NpemVfdCB2ZmlvX3BjaV90cGhfdWluZm9fZHVwKHN0cnVjdCB2ZmlvX3Bj
aV90cGggKnRwaCwNCj4gPiArCQkJCcKgwqDCoMKgwqAgdm9pZCBfX3VzZXIgKmFyZywgc2l6ZV90
DQo+ID4gYXJnc3osDQo+ID4gKwkJCQnCoMKgwqDCoMKgIHN0cnVjdCB2ZmlvX3BjaV90cGhfaW5m
bw0KPiA+ICoqaW5mbykNCj4gPiArew0KPiA+ICsJc2l6ZV90IG1pbnN6Ow0KPiA+ICsNCj4gPiAr
CWlmICh0cGgtPmNvdW50ID4gVkZJT19UUEhfSU5GT19NQVgpDQo+ID4gKwkJcmV0dXJuIC1FSU5W
QUw7DQo+ID4gKwlpZiAoIXRwaC0+Y291bnQpDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+
ICsJbWluc3ogPSB0cGgtPmNvdW50ICogc2l6ZW9mKHN0cnVjdCB2ZmlvX3BjaV90cGhfaW5mbyk7
DQo+ID4gKwlpZiAobWluc3ogPCBhcmdzeikNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiAr
DQo+ID4gKwkqaW5mbyA9IG1lbWR1cF91c2VyKGFyZywgbWluc3opOw0KPiANCj4gWW91IGNhbiB1
c2UgbWVtZHVwX2FycmF5X3VzZXIoKSBpbnN0ZWFkIG9mIHRoZSBsaW5lcyBhYm92ZS4gSXQgZG9l
cyB0aGUNCj4gbXVsdGlwbGljYXRpb24gcGx1cyBvdmVyZmxvdyBjaGVjayBmb3IgeW91IGFuZCB3
aWxsIG1ha2UgeW91ciBjb2RlIG1vcmUNCj4gY29tcGFjdC4NCj4gDQoNClRoYW5rIHlvdSwgd2Fz
bid0IGF3YXJlIG9mIGl0Lg0KDQo+ID4gKwlpZiAoSVNfRVJSKGluZm8pKQ0KPiA+ICsJCXJldHVy
biBQVFJfRVJSKGluZm8pOw0KPiA+ICsNCj4gPiArCXJldHVybiBtaW5zejsNCj4gDQo+IHNlZSBi
ZWxvd+KApg0KPiANCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCB2ZmlvX3BjaV9mZWF0
dXJlX3RwaF9zdF9vcChzdHJ1Y3QgdmZpb19wY2lfY29yZV9kZXZpY2UNCj4gPiAqdmRldiwNCj4g
PiArCQkJCcKgwqDCoMKgwqAgc3RydWN0IHZmaW9fcGNpX3RwaCAqdHBoLA0KPiA+ICsJCQkJwqDC
oMKgwqDCoCB2b2lkIF9fdXNlciAqYXJnLCBzaXplX3QNCj4gPiBhcmdzeikNCj4gPiArew0KPiA+
ICsJaW50IGksIG10eXBlLCBlcnIgPSAwOw0KPiA+ICsJdTMyIGNwdV91aWQ7DQo+ID4gKwlzdHJ1
Y3QgdmZpb19wY2lfdHBoX2luZm8gKmluZm8gPSBOVUxMOw0KPiA+ICsJc3NpemVfdCBkYXRhX3Np
emUgPSB2ZmlvX3BjaV90cGhfdWluZm9fZHVwKHRwaCwgYXJnLCBhcmdzeiwNCj4gPiAmaW5mbyk7
DQo+ID4gKw0KPiA+ICsJaWYgKGRhdGFfc2l6ZSA8PSAwKQ0KPiA+ICsJCXJldHVybiBkYXRhX3Np
emU7DQo+IA0KPiBTbyBpdCBzZWVtcyB5b3UgcmV0dXJuIGhlcmUgaW4gY2FzZSBvZiBhbiBlcnJv
ci4gSG93ZXZlciwgdGhhdCB3b3VsZCByZXN1bHQgaW4gYQ0KPiBsZW5ndGggb2YgMCBiZWluZyBh
biBlcnJvcj8NCj4gDQo+IEkgd291bGQgdHJ5IHRvIGF2b2lkIHRvIHJldHVybiAwIGZvciBhbiBl
cnJvciB3aGVuZXZlciBwb3NzaWJsZS4gVGhhdCBicmVha3MNCj4gY29udmVudGlvbi4NCj4gDQo+
IEhvdyBhYm91dCB5b3UgcmV0dXJuIHRoZSByZXN1bHQgdmFsdWUgb2YgbWVtZHVwX2FycmF5X3Vz
ZXIoKSBpbiDigKZ1aW5mb19kdXAoKT8NCj4gDQo+IFRoZSBvbmx5IHRoaW5nIEkgY2FuJ3QgdGVs
bCBpcyB3aGV0aGVyIHRwaC0+Y291bnQgPT0gMCBzaG91bGQgYmUgdHJlYXRlZCBhcyBhbg0KPiBl
cnJvci4gTWF5YmUgbWFwIGl0IHRvIC1FSU5WQUw/DQo+IA0KPiANCg0KSSB3YXNuJ3Qgc3VyZSBi
ZWZvcmUsIGJ1dCBJIGxlYW4gdG93YXJkcyAtRUlOVkFMIG5vdy4gSSB3aWxsIGFtZW5kIHRoaXMg
dG8gLUVJTlZBTC4NCkkgc2F3IHRoaXMgbGlrZSByZWFkaW5nIDAgYnl0ZXMgZnJvbSBhIGZpbGUg
ZGVzY3JpcHRvciwgd2hpY2ggcmV0dXJucyAwLg0KQnV0IHRoZXJlIGFyZSBhbHNvIGRpZmZlcmVu
Y2VzLCByZWFkIHJldHVybiB0aGUgbnVtYmVyIG9mIGJ5dGVzIHJlYWQsIHdoZXJlYXMgdGhpcw0K
ZG9lc24ndCByZXR1cm4gdGhlIG51bWJlciBvZiByZWNvcmRzLg0KDQo=

