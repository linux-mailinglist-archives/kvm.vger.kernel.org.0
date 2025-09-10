Return-Path: <kvm+bounces-57214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2C1B51F09
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 540F61C87F51
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 17:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0395C32C331;
	Wed, 10 Sep 2025 17:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aFNvJqHq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDB926FD8E;
	Wed, 10 Sep 2025 17:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757525655; cv=fail; b=PiESavnNOeB0eBVBAPAnKp0dvp+P9GC+CgcayItWdz1VlFo7ZnBzyh6PszG93qY6SSQ6yQV/4u18VJnypWz51X1g1y9YaE54dRSKe/gcrEHoFKVXxnxNF97o17Y5QQJaME3T10e7BHZ2CvQz1HC/rDlPP/5+8Vuq5rIaaQnS2mU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757525655; c=relaxed/simple;
	bh=OyLwuCaDRVCd5SzN2NcZTr38J0yHWiHQp0KhQ3kc/wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n7db602Dzdf84erCAhw6OxHrcpsqbIUgem7Jn6pJ+6Eiva67+Yd7aoi5erhBcrg4t3jqtb2aRceb67ubnFrHANcj7zihS6oWJUjtYEoZ8pIzefLnBspQ6x3Gyn5uWJXylbDgeMfobHZ3LIa6JJSLDghvaDK2AaA0C7MsKC0CiKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aFNvJqHq; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMWM/lal5DEH/W2Mute1yOSvCbAfuK/dsy7CFQOJ3I5pObwoCeezux8Wo3lIH9JeiEpvgT6jp00M0OdWlh1bbRXdhAiBmHzto3QKXvd1Q8x81k/FCyvveFlNzBCLvxN2FpMVggXLvp9PjPe1QJWfwWAx3BnBzGyjw9vn94B6E5kuet259JyMiLkz9y9ckUfvC9w21O8GK6TFgClpn24voZf61hEq4eP1vqN5uSCob9l1GVZfwIh0Hp5Vem9Gur5hUWCqgVREcpXd7l1paVQslODHi6BHNBGjGaNKGGFK5jyoCePo98Bz3H+un3W0/n7YPtIMII9RUjDDA7NnHBgtGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zsfklg51Vt4B653Ndr/jQSqkJF7YiVWEDwrJChU5HBQ=;
 b=VBp7eSgiYtlvfdNfHrZyq+bR5SgSov2GRHtGmeBJileXoeTwBrnrlSWvNY3VIW7dl+T/ZokpsFYo6iS+2zarT5puv4Dt6IFp+nvm2i+p4ils4gXzrH7SCGGLU9PRam8nPGZpOJJdB7+O2TqnkukDn5dEPhmODMgpTeCuqMddUFcNl95QTP7rGQSuknKY9OSk1lUrztPIFa3T2atvPlC7JBXoEvoFOphbgFLwlS4hwc8Z7j0rlc9Cx7zQ3B6VMoFlstII8cP1ztplcqgaQzVjnb0VBVOz0Y3Q+LaLH+SOYL658n8x9mYcp+YIxuEYDerlpunGOqe5nyJvVvm031MPVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zsfklg51Vt4B653Ndr/jQSqkJF7YiVWEDwrJChU5HBQ=;
 b=aFNvJqHqY7jXFWliFyzp6fyhrFKdnc8pI11Bsgm839c78F2BWJ7DlbYnx50+t1HLq4Wt9uygIbMZ+BAPt0/7i5WWArI4BOlif2HkGZoMwsOHJha52FWUP0V2p87d45edGiKE88vzkMiFEdwgP7qcSMCYj69BI1f723Id5TRwu1FwO/tQh4BPCStqe77UAWsCxb+4pH/6KqAi5zps3g8hrnUQbOWmlamUdgNL0ycCw6QWkVp0c66MBILge7tgqodbSL1GX7keRlokzwgFNJri+Exx1TmcCG25np6lnVL0W6Hwv11DelpmewemrTNqtfaAfTvj07vkKqKC0qb71wAjIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5769.namprd12.prod.outlook.com (2603:10b6:8:60::6) by
 DM4PR12MB6085.namprd12.prod.outlook.com (2603:10b6:8:b3::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Wed, 10 Sep 2025 17:34:10 +0000
Received: from DM4PR12MB5769.namprd12.prod.outlook.com
 ([fe80::f5f:6beb:c64a:e1ff]) by DM4PR12MB5769.namprd12.prod.outlook.com
 ([fe80::f5f:6beb:c64a:e1ff%5]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:34:06 +0000
Date: Wed, 10 Sep 2025 14:34:05 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 10/11] PCI: Check ACS DSP/USP redirect bits in
 pci_enable_pasid()
Message-ID: <20250910173405.GC922134@nvidia.com>
References: <10-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <20250909214350.GA1509037@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909214350.GA1509037@bhelgaas>
X-ClientProxiedBy: YT4PR01CA0154.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::20) To DM4PR12MB5769.namprd12.prod.outlook.com
 (2603:10b6:8:60::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5769:EE_|DM4PR12MB6085:EE_
X-MS-Office365-Filtering-Correlation-Id: c12cbadc-c4cd-4e95-990f-08ddf0903e37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iqmG6bF/iK0TEdYe/DA89AQQnNQbkMAkBrT3JdU7vhlOP+OvdpmMb7SDth09?=
 =?us-ascii?Q?puRRdS2ehhYgOiRcSqjWhAAdirVX/prpnJttm/LSB3df+48w0Bam462jL48H?=
 =?us-ascii?Q?Toy/O1D8EmrzQINNvyy4hvHjYZDruNaJcApa36mYslo94Iv//+nAUehNSuAt?=
 =?us-ascii?Q?Zqyu47Aim44DvYXVXNzB8EinbHa1jf4CbEVggOsoapZMO9+MXEB9LLw+wToO?=
 =?us-ascii?Q?o/IuXvF77AAGTo3IISBQI0l7mL3UEDqdg2HOHL+LI173VXNodxN2hI6m/89y?=
 =?us-ascii?Q?/ACqXbhU2W+pc6zc0Zb0mTFyRdTck7NClTIXtdNaUQyNprl7U1Pqaocx00+/?=
 =?us-ascii?Q?WyHMw3fAy2zoiSvCknhJBNV12U5kovNPSCZDRegrH+FY6BC2OPCbBcKbT3J3?=
 =?us-ascii?Q?sVa6K9SntmwPs6DSkPGG7I3mHcneT2ldbzbPEcygjusEAn4hWhf86PIMuFOp?=
 =?us-ascii?Q?TiKl8fxsWMSBMsBPaNLJsiabSfb6kVMB1SulqY33JpCIHHdeAZ97V4A/kFKR?=
 =?us-ascii?Q?k/APaPGl3CcX0EBuWzkADMuotK0uE9e7q/9P8IlB2RvijhF6wT+L4Ewm+7O1?=
 =?us-ascii?Q?KJJ+h8LF0Fy3OOgBB/WbIsOrvbtT9GAN1fsnHe97QjwPzN88sdF0sNVaqXsQ?=
 =?us-ascii?Q?sPwJg40cVK9NKjRWxB99WJl/U7JzmoOeUb481iyVUErH5pF8+OlHjVXrpESl?=
 =?us-ascii?Q?12Zmwq7dbHDFqCLuBZnaaIe1fW+8dyxjmHBvgcIICANKHTyu5U2PdtKoDS6D?=
 =?us-ascii?Q?6JkrcYZj2sOUezrtdZtGqEMBE+Bn2TXhA+Uk/3OZmGDJd4m+u868KdMJGDuv?=
 =?us-ascii?Q?7qLGYAWjjHALAZqQQx9zZGoRhtGujO6YcmH6luJqAbsDT60zKUbAivMFZDgq?=
 =?us-ascii?Q?+cp/SbuDP8a08d9/iLJFCZSdxROln7eNUp2lb4kB0lv5FJaG8Gbt+GzKfdIs?=
 =?us-ascii?Q?WAmO0pjvJPxniIgDXCZQXyCj4ECq0aXx24EiiW7Puas9LYhmxVDHPlVmb54k?=
 =?us-ascii?Q?eHph7J90WvAm58IjqktAJNOMGda7T9yGwZap9/0Nl5plvF+xSCT8wgHI+G2u?=
 =?us-ascii?Q?f9aC0pczhbiVXSq6ctqMa47bbhkN6G0KnRsL1837MrO5Y3qniILE3xyWFoaX?=
 =?us-ascii?Q?cn1L38Qaol2hJItqn6d9sjTJGTBT3r2Cm3Peq/QsolZA2SYUTb9IfeHjePgj?=
 =?us-ascii?Q?LpLr82NXAuPBAnnKrNezwbF0RREhkRKI/NEkS/92P3Ck97NN59WYCT69eR0I?=
 =?us-ascii?Q?KP+tRzNVQCxiT5x0RKbWnQic5jazVL4cWzDBJ1tTTK+9qZ4eg3fpjTCqBnmb?=
 =?us-ascii?Q?n/Ftec495AKAKrJmX6Qlu+0brtW6Rz9Adee/adFL5IQ6gD+lPmUAdsr+BkXU?=
 =?us-ascii?Q?6MPuXS0Y9JBBnM2Ir2WfZqldoMWFW2IkBPtVYG2wxL2GjW4JYrgQ8YnrugV7?=
 =?us-ascii?Q?FwQriegNCHo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5769.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H92cnVSt+nfc0leaworlXTRpWhhVkO98e7xp5wuMTzA2USOBJ+x0nJb3sz+L?=
 =?us-ascii?Q?XbsGmlQTaKT+rUcs9j8I0efLTcfAnLiKijSshOLlglvdEmCPrMju3CZzGxpD?=
 =?us-ascii?Q?0xeuj2MsiEDycNBZ89g13y5xP5BKU4tB5rneR8aWnPgF/XuTaG+zbRoPjHod?=
 =?us-ascii?Q?awqm56bzcmxzIgoM/8NufTJ7UHUWSAMEDR1dE8gZmVSagpTq79mJ85FrfyXE?=
 =?us-ascii?Q?0ELC06D8z5vShaaFojA0/mjyG381GQpxkYjC4HF0dPJH/EPOGAXsVOwLgP9X?=
 =?us-ascii?Q?eKvZg57YGdmKgGQbPwa8aqgC7YfNXvRQYsj9caZNSVgaHZvOvHPcV0fwhbyu?=
 =?us-ascii?Q?2fS+Jo2V6MrH1+DcERVOv+dYLZKC6GBrXaC7aCEM8P/BPlcnXoGgE34ugk0G?=
 =?us-ascii?Q?FJbJp62lYOSMJGuNiI3qDoYomHXRI8Jg7UPKU6XI3/yPXhdImdjtlPgjIGYy?=
 =?us-ascii?Q?NOSM8/CKZB1Qry1kYeYTLzkga//I7YLIzcKb/nPYFmy8me2TtfRN5c1Zu1Wa?=
 =?us-ascii?Q?qlUV6uM4YpkFMKDU4dSTVB+PJAJVzBx3spfhctcp7nI6QmUnsrtZXirih86A?=
 =?us-ascii?Q?u7yDi3/4FE42JecjHC/zIZV3NaDfhvmem513dTcDbM+OK8eCqHN44y7jkN26?=
 =?us-ascii?Q?/tAdMiKfGosq144NFehkILKa3s2mbV5h+Ab7vGE4XpnqXP01Go6o/0dMBfdB?=
 =?us-ascii?Q?tOVOU5cWsIwCLxqxQHuiXVC3KfUzrN/UeC8ojsil+0K/ZrXnyROz8D8qgGEa?=
 =?us-ascii?Q?k4tnrIifPRJSGr99Ob+oy5LCJVDyRfcVkLa+l4IKH7Di1NaK82jP+zridHnm?=
 =?us-ascii?Q?o+RYudIouX7cFpEY7Gn7KkUDZyx9D3JnJRlaJHZbNJZwRFD5EptiJsg77N7R?=
 =?us-ascii?Q?/sz826+JmXORvf3q8s6Pa+TXLuurdBaFeTQ8Ge8IqIb0BbL8gZEirbazWdeS?=
 =?us-ascii?Q?japwm7PlxaWDHebbZ7EBdOFc5bZGrmkfAu6RbGbCpXaJKWyg5V5hI6P8OgtW?=
 =?us-ascii?Q?1DCvDA2aUpapHV1c+FiV9jBmWUIIY6IfBak5qx4/bbh5uNX/ZGv3jQP3oG0c?=
 =?us-ascii?Q?5+BG2VDQpLjfGopZUTUTmmwD5UQzdoJr/htkoJ3i7lO/Pxx8PER8LiDIIMCM?=
 =?us-ascii?Q?m48aUaAl2x21CltAfP28QaKtXQPPwVxDU2biYIMa/cdDg3MIFWSWdFpja9Yq?=
 =?us-ascii?Q?EG3+2kesXBKQsn4crw8p1n+xdiH6TgXiRFoaLQWzepqNJCn7zPF9gaY3JchD?=
 =?us-ascii?Q?iXs1GuUoIq3Oyr3oVoeYFgiUzC6IGDFMjuYL/TkwrdJcl13OouFlJbMT60pC?=
 =?us-ascii?Q?Qr/gAfE2DGdu0kDtcuRKj+wfC5YOrohTaXEU8MwubGoAZ/3Vn6HDzQszHjr9?=
 =?us-ascii?Q?a9wsh4Xrqup8XqjFEV37C61Kv0xCAnGf0DjP87+GdGYWGEehN9jYRtB75hR9?=
 =?us-ascii?Q?Uc1uh1C/Q4r8UZvwg4vT6Yhld7nIl+qCPAmQFHuzYVC05K+ZgPY9bmeJ6s9E?=
 =?us-ascii?Q?yqWaURvp8I+a5y81MTPAWSkAXhssFTUwogObnCioGB5lQrNeFSOn6zvQng6f?=
 =?us-ascii?Q?uCkZlhPGimbvjvG4vRk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c12cbadc-c4cd-4e95-990f-08ddf0903e37
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5769.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 17:34:06.8587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwBjfBnUmtmjQthSG5oKyXdRY649+uzX0cvxwmbgeLXRDkL57eF3ko5bAOFzEqBQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6085

On Tue, Sep 09, 2025 at 04:43:50PM -0500, Bjorn Helgaas wrote:
> > +/*
> > + * The spec is not clear what it means if the capability bit is 0. One view is
> > + * that the device acts as though the ctrl bit is zero, another view is the
> > + * device behavior is undefined.
> > + *
> > + * Historically Linux has taken the position that the capability bit as 0 means
> > + * the device supports the most favorable interpretation of the spec - ie that
> > + * things like P2P RR are always on. As this is security sensitive we expect
> > + * devices that do not follow this rule to be quirked.
> 
> Interpreting a 0 Capability bit, i.e., per spec "the component does
> not implement the feature", as "the component behaves as though the
> feature is always enabled" sounds like a stretch to me.

I generally agree, but this is how it is implemented today.

I've revised this text, I think it is actually OK and supported by the
spec, but it is subtle:

/*
 * The spec has specific language about what bits must be supported in an ACS
 * capability. In some cases if the capability does not support the bit then it
 * really acts as though the bit is enabled. e.g.:
 *
 *    ACS P2P Request Redirect: must be implemented by Root Ports that support
 *     peer-to-peer traffic with other Root Ports
 *
 * Meaning if RR is not supported then P2P is definately not supported and the
 * device is effectively behaving as if RR is set.
 *
 * Summarizing the spec requirements:
 *      DSP   Root Port   MFD
 * SV    M        M        M
 * RR    M        E        E
 * CR    M        E        E
 * UF    M        E        N/A
 * TB    M        M        N/A
 * DT    M        E        E
 *   - M=Must Be Implemented
 *   - E=If not implemented the behavior is effecitvely as though it is enabled.
 *
 * Therefore take the simple approach and assume the above flags are enabled
 * if the cap is 0.
 *
 * ACS Enhanced eliminated undefined areas of the spec around MMIO in root ports
 * and switch ports. If those ports have no MMIO then it is not relevant.
 * PCI_ACS_UNCLAIMED_RR eliminates the undefined area around an upstream switch
 * window that is not fully decoded by the downstream windows.
 *
 * Though the spec is written on the assumption that existing devices without
 * ACS Enhanced can do whatever they want, Linux has historically assumed what
 * is now codified as PCI_ACS_DSP_MT_RB | PCI_ACS_DSP_MT_RR | PCI_ACS_USP_MT_RB
 * | PCI_ACS_USP_MT_RR | PCI_ACS_UNCLAIMED_RR.
 *
 * Changing how Linux understands existing ACS prior to ACS Enhanced would break
 * alot of systems.
 *
 * Thus continue as historical Linux has always done if ACS Enhanced is not
 * supported, while if ACS Enhanced is supported follow it.
 *
 * Due to ACS Enhanced bits being force set to 0 by older Linux kernels, and
 * those values would break old kernels on the edge cases they cover, the only
 * compatible thing for a new device to implement is ACS Enhanced supported with
 * the control bits (except PCI_ACS_IORB) wired to follow ACS_RR.
 */

> Sounds like a mess and might be worth an ECR to clarify the spec.

IMHO alot of this is badly designed for an OS. PCI SIG favours not
rendering existing HW incompatible with new revs of the spec, which
generally means the OS has no idea WTF is going on anymore. 

For ACS it means the OS cannot accurately predict what the fabric
routing will be..

Jason

