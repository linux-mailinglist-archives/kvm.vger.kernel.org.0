Return-Path: <kvm+bounces-64409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 212FBC81D5A
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:13:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 677304EA463
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 17:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099E83176FD;
	Mon, 24 Nov 2025 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tLv77RS1"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010015.outbound.protection.outlook.com [52.101.85.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31263314B60;
	Mon, 24 Nov 2025 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004178; cv=fail; b=Eysl3TyaRbCBjJG8iOg2SfzT4mKKjzVPj616sqPyw3rVjuZmAMZOxsHhOLZyuN/Ueg17RoxrtkpKOFbdxT+ABjPO5yXPhPudWm97CkTXWtVdH8SeWE2qaBPid8kj11UtrGceWeElZgYPo6wwy+SsxcminWVlaWjNOgUYT7xv1MI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004178; c=relaxed/simple;
	bh=Fp7ixSIjuaAmR30qvy6P9FYr5qqGHXp6AWHd51Wam90=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SjsgdCgfHE+O3OCnJV3XI1Av3JkmGWem0ryE2+NAtxafs1IzOo88fR61r6El6V/J4jjaO6ullZUliT8swBuHo3hw29EpHZ3ZyfdNcmGzYVgCyM+kaAvf3iaXI3H7A+V4uGTBVNk8HwRBOrJtKEE3DyLvXJBgFyeRlA5gkA40/r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tLv77RS1; arc=fail smtp.client-ip=52.101.85.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yoWJtmSmthE5U9c/dcmpSgGV89IpnIHErNMNMo1Vq1jba761Oauz9axfbRequvxnxdbxK/imw/3AZt0AQ5YOtKnTXHUSlbZDCQP/QaD6VkifVjCRUrtHo37xJyoYKvVoP2sYTEdwyfxqCKtLhqrhEFL4QHQ8e+yubA0AntCzNm2kPWElVfEPm4tzIV7jmtDOZaNW9b+3RZgmn/GJXmTKq/zBIjF1JfGuiCK+vKygJKf0zD2pqTV81HX+w615Sb0Tl0BYVgr1DwTUD5vPfZLBgRaMkqwqwf86UQehdrLICjA/Z54O8b9pQ2LsnW4h/YKNYSFz9+OXIR04HZjpteURiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXrSAIBiFW4MC85w41GpyjLeibGs6+sMy3DJpeWyOhE=;
 b=VjsDPjm3dXzmStTrchmxzmE8wG85JeMqbnyF8oNxU2AeMNmhgOZTdeB4mBE/QKFX4VDgieJxKb5Wyoba0PlHMXcK24Cj5RF3ufcxBdVKc+SxwZeJi6y0Euy30aeLgxBCzjd5q8ENvE8GvZHgIn5l9sApI3jODM/m7/6TQHHvxn6C5aYOaUi4ANVWcFFHxJszjjOPq7QNwg948G8ZDBZrLtRt655aFRz6S/nyYGAJ0BCWj+kSlFj3XdYDs59/gm3e3b5SktLMzCOARWbawMHSozU8ioX8BFqiKNv5hVYQEeCIImFYU31mpBmvyImvj9AQ586TVxririEIc6ZJWMdnlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXrSAIBiFW4MC85w41GpyjLeibGs6+sMy3DJpeWyOhE=;
 b=tLv77RS1Ho5Z5WDuIgPTLmM5TOa3Zbc/KiXJKD/oO/+iFlXqI9y6PaFFWgM9j2by7hYvR4qbbmMFSH0MdkAIN9+RRkuxWKAMHtAYBl45jwdFvrRE6LwXfRhZEYOpo7ijbhCkQG4N341BtskX0fKN6D1UjyqBQv+LF16t0N8AwQE8blXFjaOvb1NjhQQCGtmpAwRCPtXVUvcAoq5HCi+4A6pwqbG8ufu8KfrjRlJkFT/bcrq+yFkQeiOw+BogmnBPdDWqtWwcnuz8+ZKddVs291GSfhRSbqt24gYjNH7cg6cmRvg5mtukDbBjKIOiH5sN37TDinfxTyrCNchNGMOUjQ==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by MN0PR12MB5714.namprd12.prod.outlook.com (2603:10b6:208:371::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 17:09:30 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 17:09:30 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai
 Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>
CC: "Yunxiang.Li@amd.com" <Yunxiang.Li@amd.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "zhangdongdong@eswincomputing.com"
	<zhangdongdong@eswincomputing.com>, Avihai Horon <avihaih@nvidia.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "pstanner@redhat.com" <pstanner@redhat.com>, Alistair
 Popple <apopple@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>
Subject: RE: [PATCH v5 1/7] vfio/nvgrace-gpu: Use faults to map device memory
Thread-Topic: [PATCH v5 1/7] vfio/nvgrace-gpu: Use faults to map device memory
Thread-Index: AQHcXTnQ6med+l6tVEOe3bY/Ezp9+7UCCh5w
Date: Mon, 24 Nov 2025 17:09:30 +0000
Message-ID:
 <CH3PR12MB7548F47FCF28EDF9EE0FB2B6ABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-2-ankita@nvidia.com>
In-Reply-To: <20251124115926.119027-2-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|MN0PR12MB5714:EE_
x-ms-office365-filtering-correlation-id: 8fcac870-eba0-442e-b264-08de2b7c3b1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?nBR5TbFPrlaMKXtbrhNku6+W/+4xJXp12OI+zh6YT5P5794YACKiIXwhVfzo?=
 =?us-ascii?Q?AnMT8uJEGhkZ2sihDcv0C7BfRpW+NINyRkGm7EuSYYj6OEtOcPcw+UPPIBBR?=
 =?us-ascii?Q?DeFFICbsPQD2+rZhlBHNM/Gj20kRPd7QGEE0r5jfJ+7+DgwsH0IOeRqvVniQ?=
 =?us-ascii?Q?zNMxxwRCSsjmQFMGzmLyn9+Dwq3BBz8aU3lCAQQKPL8vXDpF1LxTggJRaw+g?=
 =?us-ascii?Q?Pext79SUAaTrBqexLgIJQZKXI2fM7x3ywHcmZyXMyVCSV2OW8PgJl3o+mrEk?=
 =?us-ascii?Q?k5xAzr4isdr8m8xphsAUkfpHLuwNTYAZ3et5015xIQ5qBDwX137t4Uf3f5+5?=
 =?us-ascii?Q?YiTbnjl7TFQ4aGSLaSW9zOZFkbdQxORSqe2E4PhkpcL6pOynNRCNqP6SfiRn?=
 =?us-ascii?Q?uOJlpPHmTlFT20EafNn+hoSexEBdId2lgZLJyM+uDXQ7AS1OAGH1vEfZ8q/B?=
 =?us-ascii?Q?kjLDruLZHq1Vh9cRIvPbvYHqJzwHNSXCBNdpwARzChfBLI+/hSZ+FHpQ6nYc?=
 =?us-ascii?Q?I9Rz2K7v6nRbuWbjoBY5Bx3SeGYDpjDPm25z6nrOceeJWrvBemZf72Ww++8j?=
 =?us-ascii?Q?ecbnt6S8weehM/TXxK+Xd8h7cZU5Ij/bsCSooAn3ftZ0+MWfNTILViXRQtSJ?=
 =?us-ascii?Q?vAGAZ+nj6rs7EwAkE5XLS9cexRJfZrHK0bCEt5IVZGThvqx062TB4crN0uAy?=
 =?us-ascii?Q?Guws3FffcLYkWhuDGtXLylMnCbxTQ/Oxtozc42OLvyRFtOdi5hg9HgBLsX/N?=
 =?us-ascii?Q?uOmR+QdT+NYg+EMiOc0iHhpVaCOzx7DJcmjCjBJgMadqMv+K4SgOAH2S6B4R?=
 =?us-ascii?Q?ZEP3X73/m93x075qwXITxwfbN30hkZjnjn8fGgbV/sO90Wbm+s3uYS12LrZJ?=
 =?us-ascii?Q?KyWlGmoQ2SPhs9zF/rp86ZrVdhjUVNmw9CWpXUr5DH7+mjbocnlU8Mc03jBm?=
 =?us-ascii?Q?Z9WPNn1k0RkDtQFLNBm6qsZzQednkh4aOq5GJ/uEy1317sxoWDM4GhJWglzb?=
 =?us-ascii?Q?XW9qzmJr/tvUJLuSPCy13WJ0/ntCUZ8C8xMfXtSmmgAtnLleMjWrVVhR+s/V?=
 =?us-ascii?Q?1r0sRih0U+jrhWFxuHEIwk3AYvSyDD8rQp+LSTQfKhoZFkPxZ0U5f3ZuY8sb?=
 =?us-ascii?Q?xpCrye351Gp9zMsc+SUx9aYi593IUnYz6101cCGMRJWG/Zr+gQcW0tL7zt21?=
 =?us-ascii?Q?2Sbi7K/H+j2wfXFNxx78WUeVzFj+5KPAmrEXT3Pb1qRl+LJHuww+ghQle0t4?=
 =?us-ascii?Q?MnCg3omxgy7UZLQip81ICuAYhlckcXYRPr9jxsU3rCxf3w6y418QBI6kaIBD?=
 =?us-ascii?Q?rSwjFxro/B6tC3cgopzxUmjUAirlQoRkTbL/9ARSzjJRjN7od1zcPt7fCIHa?=
 =?us-ascii?Q?VcV+Hv7OfZIZo8FNFgdTYvFaIveQyxntQP4/NQ1LmbzBjJhlJ6hOSZTl5bD4?=
 =?us-ascii?Q?nuMp0SSAmq3Y1lMurnq6GSiwNMwhcKjdQCASRLpBRKlSfvrvEVHwD7DIHYrV?=
 =?us-ascii?Q?gTycrQvVnomljkm+2Hb7IfzmW/zc8nSkg/V8?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vnNTjIkuML1hAN8Ho8CS7TlDg0v+H3mrzTjEq9RNcmz9pS8G8bUVM5udy6s1?=
 =?us-ascii?Q?R5giWh3db9rhYywkOy8k5bTI7dVcN8fTD1dJozPye+3GD9mrcUX/SUpmDG8M?=
 =?us-ascii?Q?t41QeqD49CjvTY8aOvHRgIGDbYv+BDyq3z/o2nPxO6v4h5UppoDrZGA1yk2i?=
 =?us-ascii?Q?owPbBEkz4ar9t0ASp1PgCUytRoIOH4kW3W49x+3j7jkaB+ei4K6zqRN5GLLp?=
 =?us-ascii?Q?u+Aj4d72c65hVEmt9oFb9a4x4zNj9yc5tdFfs/6QVdSEJKmgAZWZzAnzuQjE?=
 =?us-ascii?Q?f0d22z5oqKrF6CLv9BwZm6HPBpE8kSioiN6Mezb/1qUhv1Fnlj4YFIx8d+c0?=
 =?us-ascii?Q?FA468f/k9id+RpCnQm8qHwBHIknRc9/OlYdGPQSAcmay9ZDCLk7MdF+Ai7xM?=
 =?us-ascii?Q?5uJQe6+Ys7h2bYaFqUUVdkkVDYgmBkOgFV/sIHf751Ctx1lS1xhFJ36KoWi4?=
 =?us-ascii?Q?HprkovXTZVwz2c77npKjJL1ZoOf40U3KsEYSNKwj49z5KX2egq4MbHB59PJO?=
 =?us-ascii?Q?LOE3Jh7wQxERf5us5cH0Vn2HHA47dEj2rZkM8sF5Oe+ZdEiMA9nbLCNra5Ri?=
 =?us-ascii?Q?Swh5zdZolveryxLzMA5dZcHJw1sj0NswjWdh2N22txQo96Iy5qwrFygE4897?=
 =?us-ascii?Q?OayN++s95GFE1OvDJEmL7FFIrmD5LC70xDtqtSgxL1vXQ/aI4Fydm+UFbnjD?=
 =?us-ascii?Q?LbpXCxDZDjJsS4sztVHzrxhY2C0SwaaY3aGQDjeyao/FsO+Fwlz7Lig3pQ9k?=
 =?us-ascii?Q?osUedUg0vACSWPnw45ya7SyOfNV/s0FCBjojaUP6kYafyMVrczXNhlP/nF3a?=
 =?us-ascii?Q?49m/XBV+8Djh2vwXThlyTcWsALBYiYk6hSROVE1/tS8VkF1nG1g8Sd4pA+RE?=
 =?us-ascii?Q?f3CsaRt9t62SYj0+XdyNHg8iJA9jRpfK5gLeiukvkQq2wm1Ai7SGpKkwDa+l?=
 =?us-ascii?Q?5nvaPKeIfYekssodEI44AIFlObjz5auObUFXKuRxnXjATJ7LS6xNzkpAbHXJ?=
 =?us-ascii?Q?je6eWcLj2ML//Bz3yJLnvZNZ8s5Krn33ibY45vGwWjpPPK2lMDggeeAsunOW?=
 =?us-ascii?Q?xeZdyMDsdCAPoH0fnz347PVxlAWndapjyKzUjsB4dEAKJ854TMTIjkt0bQB2?=
 =?us-ascii?Q?r1kSlySkWmTRYnS2ly90uT3gWSmjTNeWYaHnDHwPo/UJiBRXobXshH8wJ/3x?=
 =?us-ascii?Q?7iUn6GZ9SYvpdf9QV5eZE++OX4hSqZoUIw5+uf/ZTYLfk0HDVctKbdS6btda?=
 =?us-ascii?Q?7ewAnUJZHaIC/6FdoCMVfwuraJSu442xQ+bg255dABG5VFIAL9PEG9xGDBBq?=
 =?us-ascii?Q?0h8q0jVrq3WqGH9Z/YM121gtzj9CdsxfO1PTy2fbb97tHpdYOaUBZE4EIPmx?=
 =?us-ascii?Q?mH2J4kPw/ETKMPBLwxAWL8IIwgiSdB+K/MxlDGJJPI7BChYpJxe2DbNWx5Wm?=
 =?us-ascii?Q?gDUEErzhbyDBLwYQvGB063Czfpx/HSzv6JJbqoykvRhncqqzghHqwpPCQPK0?=
 =?us-ascii?Q?cUOu3febih/Ly21JUEO3nckllWY4EGHKAP0sXkw12ruVMMrbOwfoC/CqYl+D?=
 =?us-ascii?Q?qRKLxNsQOQrdfcS7CV1Kwu2IYzKQbyhWHQIztg0Z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fcac870-eba0-442e-b264-08de2b7c3b1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 17:09:30.0424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51SJfu7g/H1mdaNsUXRZ2P85NbvuEYmsba2eLi6NfHWx8uuUXnoxMZr9JQw9psMKkgK9x8T1DpoS3eG9D0mCMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5714



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 24 November 2025 11:59
> To: Ankit Agrawal <ankita@nvidia.com>; jgg@ziepe.ca; Yishai Hadas
> <yishaih@nvidia.com>; Shameer Kolothum <skolothumtho@nvidia.com>;
> kevin.tian@intel.com; alex@shazbot.org; Aniket Agashe
> <aniketa@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>; Matt Ochs
> <mochs@nvidia.com>
> Cc: Yunxiang.Li@amd.com; yi.l.liu@intel.com;
> zhangdongdong@eswincomputing.com; Avihai Horon <avihaih@nvidia.com>;
> bhelgaas@google.com; peterx@redhat.com; pstanner@redhat.com; Alistair
> Popple <apopple@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Neo Jia <cjia@nvidia.com>; Kirti Wankhede
> <kwankhede@nvidia.com>; Tarun Gupta (SW-GPU) <targupta@nvidia.com>;
> Zhi Wang <zhiw@nvidia.com>; Dan Williams <danw@nvidia.com>; Dheeraj
> Nigam <dnigam@nvidia.com>; Krishnakant Jaju <kjaju@nvidia.com>
> Subject: [PATCH v5 1/7] vfio/nvgrace-gpu: Use faults to map device memory
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> To make use of the huge pfnmap support and to support zap/remap
> sequence, fault/huge_fault ops based mapping mechanism needs to
> be implemented.
>=20
> Currently nvgrace-gpu module relies on remap_pfn_range to do
> the mapping during VM bootup. Replace it to instead rely on fault
> and use vmf_insert_pfn to setup the mapping.
>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 50 +++++++++++++++++------------
>  1 file changed, 30 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index e346392b72f6..f74f3d8e1ebe 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,6 +130,32 @@ static void nvgrace_gpu_close_device(struct
> vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>=20
> +static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma =3D vmf->vma;
> +	struct nvgrace_gpu_pci_core_device *nvdev =3D vma->vm_private_data;
> +	int index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT -
> PAGE_SHIFT);
> +	vm_fault_t ret =3D VM_FAULT_SIGBUS;
> +	struct mem_region *memregion;
> +	unsigned long pgoff, pfn;
> +
> +	memregion =3D nvgrace_gpu_memregion(index, nvdev);
> +	if (!memregion)
> +		return ret;
> +
> +	pgoff =3D (vmf->address - vma->vm_start) >> PAGE_SHIFT;
> +	pfn =3D PHYS_PFN(memregion->memphys) + pgoff;

The core fault code seems to calculate the BAR offset in vma_to_pfn()
which is missing here.

pgoff =3D vma->vm_pgoff &
                ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);

Is the assumption here is user space will always map at BAR offset 0?

> +
> +	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock)
> +		ret =3D vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> +
> +	return ret;

Could do return vmf_insert_pfn(vmf->vma, vmf->address, pfn); if
you don't need it later.

Thanks,
Shameer


