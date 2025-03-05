Return-Path: <kvm+bounces-40131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3797BA4F6DE
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 07:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 830EF3AAE03
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 06:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4801D8A12;
	Wed,  5 Mar 2025 06:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UU1Wqicn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UU1Wqicn"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013006.outbound.protection.outlook.com [40.107.162.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4646D43AB7;
	Wed,  5 Mar 2025 06:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741155109; cv=fail; b=gbUcdvff4XZKGlBp1J3PzLp3/DaHuoO6EoLM7dhDRruuOVcWPiyC/Vbzv8UNGWUxkewVdylKzjx7nygGzNtvVOF8bjcoV/ebF5u2XvCVmDv29RgvQO9jNJWEcwkoJkPKxL9WnNV+dQ2d8JYWo6595lVvJI7NsVjw+ibOdZPj1Cw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741155109; c=relaxed/simple;
	bh=AuwUGY4qCkQ6cgss6bCNH9MZ+2QmzrEflO+tNOCGV7U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IyPcRmYcvGG9//2rSJ/bmQtqKZWKkkXoipfyJcfeWJN4PG3R77DgvK6GWP78F16zFk3jf5Ru06kmDm+IAg9sxt1MUs7fQERkN1EdZE71hpfHz4R10fdvGTXEA1iGwVG6k8P3BOKn/aW8Y2u++ePMWSS4b/H8J6WVY2UtgAUwa1Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UU1Wqicn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UU1Wqicn; arc=fail smtp.client-ip=40.107.162.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=C+kQWI5UL1AM5luh50v6PL0PTgTZWZj/f+BuTADa0WZiU/U/elQOlNC8LQBC44YU2Q5aVytQwCFzdk6odZNhcQmADj3oPeXncXDwONwUCYaPWyyvcetqklEI0WPVGkRavxbWhimeJOlGNg+m7n105Etd+fk8LV0Ldcx2kmG87K9+F5qo9ykmqiih+C8i2zy2bRmLObQZizektY0VYS3UpM1MJagbMTzqV8oNhilkuG/CkwgRb6wdTmCByqgMgmeBi7XhtS0jlkrq7gXu4QZ2Urs7xHf0+vI/6nVG9zyco/173KPIndymLMABkFM9Fo+lPgwtx8LmCYRtJz8SQlK0Hw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9A+iJUckhB8BzPxWz/O3dGIRQjWQT8uWJz6Udk2c7Q=;
 b=tIbykFQzBttBU9LHrgUV9SAHUy+2nmnC5WkCu71fETm9WAgQKYnnPiKhZ4FUZQ9Y+638bcLRa9JGdELtkUH9Mh4TtMxuTJ3HswdJh0FKvnU7SQOX56x82oPS7tfg7boLapqjlcPyE9+zGRHzyw0O+7iRfwd6P569JBcO/3Kn8C480XelAK5nE3UyiKFKJrXn8itNKlkTrRFgO7USx+4g795f5xzQzJYBZC/k8HqHxHFZ42FgPP3Hx0LKbHVN/iUNCiW0wDo2Q0l7OymsuauRUpSNrADWGtqdyh4aVw46LHYgwZESVK2heB+A0/7z8Hg0MlNsWVgyaIG9hop7tamkZQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9A+iJUckhB8BzPxWz/O3dGIRQjWQT8uWJz6Udk2c7Q=;
 b=UU1WqicncpQvLuThE2i33gQATFItSdnc2nsGR6ndfSJttJEp/h+tKBhpubpzuzbMWP9c3Ons5YDUgdYU9rObUogHfWQcQmLFDDVzM/u9ByMV15+nuAeXpGaOkZYfnqgGu/OaDJ+11SyBsww0jlmIWOZ0rQ8g+7S2Szj5u9KOCDU=
Received: from AS9PR05CA0168.eurprd05.prod.outlook.com (2603:10a6:20b:496::15)
 by GV1PR08MB8404.eurprd08.prod.outlook.com (2603:10a6:150:80::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Wed, 5 Mar
 2025 06:11:38 +0000
Received: from AM2PEPF0001C70A.eurprd05.prod.outlook.com
 (2603:10a6:20b:496:cafe::bf) by AS9PR05CA0168.outlook.office365.com
 (2603:10a6:20b:496::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.16 via Frontend Transport; Wed,
 5 Mar 2025 06:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM2PEPF0001C70A.mail.protection.outlook.com (10.167.16.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.15
 via Frontend Transport; Wed, 5 Mar 2025 06:11:38 +0000
Received: ("Tessian outbound a81432d5988b:v585"); Wed, 05 Mar 2025 06:11:38 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 9d1ee16611b5a818
X-TessianGatewayMetadata: i8coCI9A/xrJKAIG/0C4+/OZeN86SUoKKjYw1fJ4XBb3nlt0jvVWC0k+KCV6xY6LE/7ww2J1FtKnqL6hO6QhJZQ39SvOtbs6/cQ+SH3LVVc2LbOzYFBFFC4AAOJx3aHQ13ZV3bYE87tbqVfbWhm6YoV3Euqwiirq6jh1I67J3zR1BLyBVnVFMhnJiv1eJjQlnYC7fSm2Dlz6rSej2bGBeg==
X-CR-MTA-TID: 64aa7808
Received: from L894849358c42.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 815A2CDB-C694-4D97-A561-7CF3889ED692.1;
	Wed, 05 Mar 2025 06:11:27 +0000
Received: from DU2PR03CU002.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L894849358c42.1
    (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
    Wed, 05 Mar 2025 06:11:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tUy+Dunar6jMSH4tLlKLwAOSDdnLuEr0sX8qPaasRqc5e0gcNWBYKBwZNB13I7ECPm7xMkKjS3kfuqwF1aaFGZ7WE8Sfh1woIOjuzFESHzZMDfDxWPqC1KPazM1hFdTymRgbc3+bfW3C+rFL4uAP6KPs1074TzGk/LbV2aiZwDFw76kB+VIQTvIAyMFOnMNu53XxiO4E37d2ZaWCHgsGTGaeRqPRF/sirXzqF2X0F9tct4leNkezcPFmzJ+6NVD2T049SI2JtYDJ1sJ5s+kkPhjZitwnO+7siAU9WlL+FtpMbXP4wl52XGep6fImPMBpwkZ3ELwlyy9sW9iw+kpF8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9A+iJUckhB8BzPxWz/O3dGIRQjWQT8uWJz6Udk2c7Q=;
 b=CUB/5DWCfJxP3LD3BPb+2ubV9i0203XiWJrTe0ssKoDLENjbHFlO7IwOYm0kqyYFYGbniWgvn6i8zO/ajEdixJLxzFdJhA7P7rixtuixNRH+ggCIsz0FkabNrM7p4FhJCdDiIPqDhHL+oNszVD7zZF5pNrCNAtfv8Lb4GvCtuDlIh1hAyWXosb40RVuQnl7dW3L5gNwRDhHjwY+ig8qcW09Tr51o3b9zE70ATSQ/u9A47TaxYyBC7OqQYoZmUErivjUY2cX5/QRbxue23aZ96bfcfTW5wlMYgD6oQ6xCVudkI5YL9rXiflsKhhhBsM4DJal0I8P7byfiaX2J3LyELg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9A+iJUckhB8BzPxWz/O3dGIRQjWQT8uWJz6Udk2c7Q=;
 b=UU1WqicncpQvLuThE2i33gQATFItSdnc2nsGR6ndfSJttJEp/h+tKBhpubpzuzbMWP9c3Ons5YDUgdYU9rObUogHfWQcQmLFDDVzM/u9ByMV15+nuAeXpGaOkZYfnqgGu/OaDJ+11SyBsww0jlmIWOZ0rQ8g+7S2Szj5u9KOCDU=
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com (2603:10a6:102:33a::19)
 by GV2PR08MB9926.eurprd08.prod.outlook.com (2603:10a6:150:c1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Wed, 5 Mar
 2025 06:11:22 +0000
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294]) by PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294%5]) with mapi id 15.20.8511.015; Wed, 5 Mar 2025
 06:11:22 +0000
From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, nd <nd@arm.com>, Kevin Tian
	<kevin.tian@intel.com>, Philipp Stanner <pstanner@redhat.com>, Yunxiang Li
	<Yunxiang.Li@amd.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Ankit
 Agrawal <ankita@nvidia.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	Dhruv Tripathi <Dhruv.Tripathi@arm.com>, Honnappa Nagarahalli
	<Honnappa.Nagarahalli@arm.com>, Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index: AQHbhLKEApVfqCfEsEO/VXZQklRIvLNjFiyAgACJGACAADH7gIAAQ1nQ
Date: Wed, 5 Mar 2025 06:11:22 +0000
Message-ID:
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
	<20250304141447.GY5011@ziepe.ca>
	<PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
In-Reply-To: <20250304182421.05b6a12f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAWPR08MB8909:EE_|GV2PR08MB9926:EE_|AM2PEPF0001C70A:EE_|GV1PR08MB8404:EE_
X-MS-Office365-Filtering-Correlation-Id: a5c7ffe9-a437-45dc-81b0-08dd5bac9730
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?1r/U9TkG41bfUSSSy4CSRDamDYX1Q2vX1v1TqsXZ9dNcT//SWcaExZkXVI?=
 =?iso-8859-1?Q?2zZQZhNjNJnDnbu1SLXF/CPDVo9FvvL/JcgnG7CiNiGWWyUk0dNzqQ2l+/?=
 =?iso-8859-1?Q?5BSQ562yZcqKgCn4AEX1397Tah+00Tm2qGudttKw/gZ3rkedz2Ig1jcqbz?=
 =?iso-8859-1?Q?eqnV289N/86RPOx9lZmKxoPraX76K6M9TgyR5A9YLYQ5QIh6uAlPCjAYnN?=
 =?iso-8859-1?Q?UqrKNDdQorU1b7NcobS5/WXPJnOx8uWEDMjFe13peeTaA5MMmBfNIjsvdY?=
 =?iso-8859-1?Q?xj13V3pU3PUmuqo2G+I7OSmTJ2U58ThtFnfhraJO/l9gXQXffIBkaXan51?=
 =?iso-8859-1?Q?wuH0A6umfWAfZdz6LaQN2kGSvLHtZccZ7tfpckXAErWl4z6n/LRT33YEeY?=
 =?iso-8859-1?Q?WJa41KI0XtOt+tB3ZHLgKGp0G1lROHvJLdf328iUYZoF7zwCSX6AKxJxdC?=
 =?iso-8859-1?Q?IInzIsxnI+vV10D2tWfFNq0WgI2lyCisCxU7g09RnpoF/UAJun0j2xjL7R?=
 =?iso-8859-1?Q?ejf/44CwxNXgdx+u0MjSOYAJilxHDrmrKWeJmn6+odtFP5lwFo5NR4lp2n?=
 =?iso-8859-1?Q?LK3F6JLzF+tWbmE0o+sq1cly3K+t7X0f3uVrKYxjnTfxCoY/0OWsT/GUTi?=
 =?iso-8859-1?Q?TEKtBsjX/K1qV/v5Xl83tWARqLOKOf4m06ze79DbyNP7AFJxFx5LoIliaM?=
 =?iso-8859-1?Q?DfUg0/6esjvIOizknJpODHWg5Gquumk6olmbaCKPEo0QkgwWhC8ZvRB0bA?=
 =?iso-8859-1?Q?Kpt/wHsvf1tB3RFXJ57qy0O2cdqljkV12ZBklzfmpQOkWnGcryUjm6ONnW?=
 =?iso-8859-1?Q?EFmh7ctAMObPuG7ZOttsNMz1FUa7KbNg9tMhUmETMjzVD+fzliuFi8S2Da?=
 =?iso-8859-1?Q?N2BFqFVBqFGxcmUyhJh29epwgnQQoldM+2LHBe40Kl0Gc57NNd3FL63UGz?=
 =?iso-8859-1?Q?9tYmBiAaWqW/vovOmlDxJ0NAj6Pm76XxNxb1yrYLXYrJm/od+OJubQNErY?=
 =?iso-8859-1?Q?9NhvYGDVM4IHoThz2nnX87SyVOorfm/0AkpE9f+8zJJDD40k5rB7lOBRnv?=
 =?iso-8859-1?Q?rIwmDpwQ0wLpLq7UOtx7nYUKTCZau8WqA0orRge4zLdStM9/YzqA64W9Bg?=
 =?iso-8859-1?Q?RMOxcy2WxJBgRo4Jbg5CQtv2+evo3B232QTjl/0JI6SqYRVTOTeF4NTclw?=
 =?iso-8859-1?Q?qcmBMpkAb/NMvcQ9rdyEVHeIisHLPFhcPNO0oXUryfbF5LIYowb0X/lt+U?=
 =?iso-8859-1?Q?UcYFplQI6IRblNjrSQxuk8bRMBhW9qKNjqp4dX5UsP0bpTnmWSJUVWkaNt?=
 =?iso-8859-1?Q?2xTZX7do9lfw8diG/YL44otEf06iiGWztXClW6/Kf2qcc6ZJVL9ax11jFf?=
 =?iso-8859-1?Q?L5m3+n+x7F2mbPQP+hvI73Ejj+wasdGkVaXYdWs3OuBqJkpqAG0e3Jqa7b?=
 =?iso-8859-1?Q?XdHEZIlmgQNLPfCE9KxuSDd4tDiy8sdMuILn4r2+kcjRG/9cd5FuFgUnQr?=
 =?iso-8859-1?Q?Ly35X+37HqEHG5tkwyNoLm?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB8909.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9926
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:102:33a::19];domain=PAWPR08MB8909.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ec374e1c-51ff-4a78-88d6-08dd5bac8d86
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|1800799024|14060799003|36860700013|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?lNYICmj4n8d5fwKtBeDcZTax3agWP49wovvRKCSPMZtzpVve6q2JQTTHUn?=
 =?iso-8859-1?Q?jVBpPbzcAnpohV1LV4JsYXnYIrRfYLKV4ebvPavv9DfqwjDjUvH+s0RP+2?=
 =?iso-8859-1?Q?/LSCs9+CN1hPTJmbNfZSa/leT39AEr+AX7rcxiNWRtsqslIHXi4jfrpLFw?=
 =?iso-8859-1?Q?aiVBz3ZfiXOaNMqb6TTDNhWAFsZHuuamKAcafQHmeKkWIRBcZ6+kNq7oiz?=
 =?iso-8859-1?Q?QjCLC2cWZ8lHgoyNADU1YUhXGqE2KEtIGlTR3iJusOuyla7dCVxTkY/Ob9?=
 =?iso-8859-1?Q?ExyGaERj7R9e1Urq6vNjEzgsD+waQb38oWReukqklnbci2jZzQhnVoK+3B?=
 =?iso-8859-1?Q?O8SUWzz7ZYE0OvsV/kkEu9wJcfqtqP8EZx9g82J5K5XWi+QJdVBFx44G+s?=
 =?iso-8859-1?Q?6PEoJYz6P+9qGNwLYC43EfGrEKEVoewESAc6jWxcDPxqGIA2CaHFoClcix?=
 =?iso-8859-1?Q?ro4tGXT/gxrKOL3u2gt6zZ2/IkOheHjTSp+DI6VEyypkduW2TesQkWX2nn?=
 =?iso-8859-1?Q?SipL1MjvrDAgcuw2Gcc4d8msmI0YzU9FPWI05IXp4l0/E91zGbrwMUgQiM?=
 =?iso-8859-1?Q?s6ptaVKzf2g+EdPfioAjRBPB5MwraYn+F7eBTLOY98HYwQ7G468PZ2SOp/?=
 =?iso-8859-1?Q?1OlVmGN8NfksvEDdbiFpfizAgSLtBoo1vNCqEKbSx0uvfoiCfyQuuvjrAd?=
 =?iso-8859-1?Q?Z3YWUVJoTHL2VWB2cSVQ/aTgCfAi6Y0aarU9vZz/KPv/FEf6AT2Nr54MDV?=
 =?iso-8859-1?Q?HXjLxVvY2D+MWF4i31YLWQ12iJGOs23cMftM913Er/Uyc9vZkpy6Q8WDIM?=
 =?iso-8859-1?Q?WG3QxmMbZH0IkInbewEcJ2TtqDVT+PMpZNxd1/hL/8QK9AZE+MwTO8rXLm?=
 =?iso-8859-1?Q?kdZgzPwvEWDviM8bfLVaYBq0LmKFIoh96hvjGYUzreNWNgcRkMBL+0t4+j?=
 =?iso-8859-1?Q?GzaO57gKzzhkPFZD2yMATDW80tI8vVElI6G+1LWidJOgqWGI3PX65Paufz?=
 =?iso-8859-1?Q?1AY88gJ/4Ru7f1daYIDS7TYY/ZQcuYEoo6n3MGxrypR87CDFcSsISQPv9b?=
 =?iso-8859-1?Q?GA2K3+4l4ku1kzz+XQb+t4bC53yi/r2qa49aBGgTJW+G+tvyAoYEtI6YVF?=
 =?iso-8859-1?Q?LwSbTU+foMiN9IB5SaMj4D9h4GfhiSP4Po3fyfzv2Be4gP6koDONBdPr1e?=
 =?iso-8859-1?Q?hZsGkBK4jdY+pFR08k5N+BXFYRzyWaE+NgAKWkrBbIKPQLAFPw0LGw2cyr?=
 =?iso-8859-1?Q?cPyRioCgSBoNqEVheD3KELCUkOs9ATCGeVc9+C95ZRjxnfpZNRiyL2E8g9?=
 =?iso-8859-1?Q?gEES9B9/92oE9zBLp8Ytrl5g3yuzY8AIRq5SkiGZc85qNCK3XA+/OGTe9x?=
 =?iso-8859-1?Q?D380f2wvBqOEGvys34EGxd2ThPvKTOYW11wrkk41lj51Xtqmp9SyvxW0S6?=
 =?iso-8859-1?Q?LJ1ssHs2ZMgegl2jnQ/U5uGn7BWV+lSfD0mbhuPmKKpLvWgRzZ5tYC/T8G?=
 =?iso-8859-1?Q?YSpv/6eFkBD+BpHmGXmb3V8VjQbXz2h+tvi5DE2fkzo2S61XwktwB7WtfM?=
 =?iso-8859-1?Q?Ibif38g=3D?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:64aa7808-outbound-1.mta.getcheckrecipient.com;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(1800799024)(14060799003)(36860700013)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 06:11:38.4738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c7ffe9-a437-45dc-81b0-08dd5bac9730
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8404



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, March 4, 2025 7:24 PM
> To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>; linux-kernel@vger.kernel.org; nd
> <nd@arm.com>; Kevin Tian <kevin.tian@intel.com>; Philipp Stanner
> <pstanner@redhat.com>; Yunxiang Li <Yunxiang.Li@amd.com>; Dr. David Alan
> Gilbert <linux@treblig.org>; Ankit Agrawal <ankita@nvidia.com>; open list=
:VFIO
> DRIVER <kvm@vger.kernel.org>
> Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
>=20
> On Tue, 4 Mar 2025 22:38:16 +0000
> Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com> wrote:
>=20
> > > > Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feature =
for
> > > > direct cache injection. As described in the relevant patch set [1],
> > > > direct cache injection in supported hardware allows optimal platfor=
m
> > > > resource utilization for specific requests on the PCIe bus. This fe=
ature
> > > > is currently available only for kernel device drivers. However,
> > > > user space applications, especially those whose performance is sens=
itive
> > > > to the latency of inbound writes as seen by a CPU core, may benefit=
 from
> > > > using this information (E.g., DPDK cache stashing RFC [2] or an HPC
> > > > application running in a VM).
> > > >
> > > > This patch enables configuring of TPH from the user space via
> > > > VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user space
> > > > drivers and VMMs to enable/disable the TPH feature on PCIe devices =
and
> > > > set steering tags in MSI-X or steering-tag table entries using
> > > > VFIO_DEVICE_FEATURE_SET flag or read steering tags from the kernel =
using
> > > > VFIO_DEVICE_FEATURE_GET to operate in device-specific mode.
> > >
> > > What level of protection do we expect to have here? Is it OK for
> > > userspace to make up any old tag value or is there some security
> > > concern with that?
> > >
> > Shouldn't be allowed from within a container.
> > A hypervisor should have its own STs and map them to platform STs for
> > the cores the VM is pinned to and verify any old ST is not written to t=
he
> > device MSI-X, ST table or device specific locations.
>=20
> And how exactly are we mediating device specific steering tags when we
> don't know where/how they're written to the device.  An API that
> returns a valid ST to userspace doesn't provide any guarantees relative
> to what userspace later writes.  MSI-X tables are also writable by

By not enabling TPH in device-specific mode, hypervisors can ensure that
setting an ST in a device-specific location (like queue contexts) will have=
 no
effect. VMs should also not be allowed to enable TPH. I believe this could
be enforced by trapping (causing VM exits) on MSI-X/ST table writes.=A0

Having said that, regardless of this proposal or the availability of kernel
TPH support, a VFIO driver could enable TPH and set an arbitrary ST on the
MSI-X/ST table or a device-specific location on supported platforms. If the
driver doesn't have a list of valid STs, it can enumerate 8- or 16-bit STs =
and
measure access latencies to determine valid ones.

> userspace.  I could have missed it, but I also didn't note any pinning
> requirement in this proposal.  Thanks,
>=20

Sorry, I failed to mention pinning earlier. Let's say we don't pin VMs to
CPUs. Now, say VM_A sets an ST on a NIC to get packet data to the L2D=20
of the CPU_N to which its vCPU_0 is currently bound. Then, after a while,
say, VM_B gets scheduled to CPU_N. CPU_N, regardless of what=20
process/thread is scheduled, will continuously receive data from VM A's
NIC for its L2D. Consequently, the performance of VMs scheduled on
CPU_N other than VM_A would degrade due to capacity misses and
invalidations. This is where the pinning requirement comes=A0from.

--wathsala



