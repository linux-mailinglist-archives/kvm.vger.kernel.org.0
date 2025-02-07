Return-Path: <kvm+bounces-37635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 661ABA2CE88
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 21:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18D1B3A43F5
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 20:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C22D81B0412;
	Fri,  7 Feb 2025 20:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZIMDGDC5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2043.outbound.protection.outlook.com [40.107.102.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF0819C57C;
	Fri,  7 Feb 2025 20:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738961772; cv=fail; b=jW0HbthisDdEvMFjdEFR3t2em1nBvFxA4EckcidfuX/yCUgh5eoUbF+mxteimUIiGOUoLomtfBkMRztK4hM+SJ/wcghn2qZFgO9f8L9LEZ7QxRJQrTBL0sVJHGKGmjxaiE7o2bnNBjeMjZHZxszZVHvWTw1OeEknkfm4X6wPQcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738961772; c=relaxed/simple;
	bh=RhNrAdtXGS7RP9MUpe2a+tGYcQG9KskkuwADCGRHwso=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J1Nef46bUT6yOIIXwgui+8jOJmmzq7r6VMu48icw9ULmHCr4uDyZwL4E+spbCHwV+BFdtYkKRSDCkHRJn2BvFX2m+IaOZdO54yPM+ThTXOcQU9KfDunY41XwF+TtVocvZwsf2o8ttaO65uvxKWrzioEzuWykOPukd0hsAiLLBlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZIMDGDC5; arc=fail smtp.client-ip=40.107.102.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UmFpzfeif44TwiKvHeiMd7GzUk22iOyEW5pnBLc8VyUGXtMr50ZuvLNP9y1+qLENlLiQStlpCMvkzOHQ2Bk1kqPVtQypToAbsHZ6z7XIDyEl+wAjQMr+TmLFLS04HVWeY+bwViB6J23uKJAmF5beS7c5ytledRmwyNznOc8aIl5kzgleGGbPRIU5z4MKlCNMD/iWa6N4nMXV1n2rKF0j8U/gfJB9a6E5QagYI+cFq6LkrrFYNesV8rzwdniFRMi3u9K0RqqDdfrPwDe2kojdzBHdw0ZmXPBzYyHi0rgD3k0UxZ6u3EoLUgU7vJFb0MEpHIrGCAQK8eQUR0LnAZwIpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFV81q9e0T1pePxBLVs12TrgCrY7nR3+PPatf7X2foc=;
 b=mZhL/snjm7fsn5xmxm6JUO5amKJpZwWqjOrLv3InTDhxucVSX6+DjE+5/B3/UmzYkxSxHaSfb3deoFmYV3bdORVFpKNBuCOEO5b7Z+K3f//uC8wxRhSl8QYuWsx95yksY0rsalBEmgNNa7muzxdmZTv8ikfngb6I1R+DgrSme6Oc3B0TF/V3QwSlyYPtga+2uiSKn0Gc6fx30Q8OXGz8JqQFpOtwSmu9vtfg/44kK0YZhYRFvZVrvBAuGhkMAc8pLQWQjbuHmZsBq+IuuaX3ch0owxTFdx/VmPblgi0dnOQUvXsrBGpS/mUi6JHIeMcFU0NBqJuZGULhoKiiTHpY3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFV81q9e0T1pePxBLVs12TrgCrY7nR3+PPatf7X2foc=;
 b=ZIMDGDC5vFP4GyOdOJL5sZKyEXPNxqZBmhK0q9F0TfCRTuwWZur1gwMt+lMh4DLcgwQiCUHbmn7Y2SnwWFEM2UVt4XIBY1eVmsD4vLEOHwnVc+PU7WpsmBwdkYfYI3P6ckt0bRfO3W8+IlGI1LI0j/UaedvVFmH76EhRsys6SG9lTXdn3/XydV8NBviSLx26yNx2Di4KkG+esXzgEWFmGFMZzOLkG35kUrxWCKUg06V59Nx2FaQgzstBw2yWT2JfolHNUdJqVOwxgx4IUHn4ycbwH3cQcK4tz8YRCnvp7yGMpvdadVotjFpsD2ji3PhCPQHotuLGJj/qvcgN3EolBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12)
 by PH7PR12MB5784.namprd12.prod.outlook.com (2603:10b6:510:1d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Fri, 7 Feb
 2025 20:56:02 +0000
Received: from MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e]) by MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e%4]) with mapi id 15.20.8422.012; Fri, 7 Feb 2025
 20:56:02 +0000
From: Nishanth Aravamudan <naravamudan@nvidia.com>
To: "Bjorn Helgaas" <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org
Subject: [PATCH v3] PCI: account for sysfs-disabled reset in pci_{slot,bus}_resettable()
Date: Fri,  7 Feb 2025 14:56:00 -0600
Message-Id: <20250207205600.1846178-1-naravamudan@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250122192241.32172-1-naravamudan@nvidia.com>
References: <20250122192241.32172-1-naravamudan@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0031.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::13) To MW3PR12MB4524.namprd12.prod.outlook.com
 (2603:10b6:303:2d::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4524:EE_|PH7PR12MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: a232cd00-3e93-4b61-e540-08dd47b9d4be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FD5AURHHDF0OJrPrn5D4FtDqdJPzF1rgYirgmUMl+IufUBeRLDtKU/Ja2RB6?=
 =?us-ascii?Q?Tx5CNpjTCEiCeaZ3MY1aMNIQBKd0YRO2BaKgrOZl0rFR0Hw42uwjFLrCMOLZ?=
 =?us-ascii?Q?IN4k4m96C4t/LGg8SyU76dLPDanV21sxxNSAmiOimydBvIHGTiMdElFZ2mOZ?=
 =?us-ascii?Q?5a4yAFmgGqGJ2vHie2C4NP2nRZ+xfzHu1a6R8a5wRKxGIRIX8nlUfx19xHxY?=
 =?us-ascii?Q?5Z8Zoh4OtEwaOSltsmfzi+yI7GvdS8o+ckhPv4WkQQOGxYhV5LfdvyFn6bYk?=
 =?us-ascii?Q?dVo12kOaOrsqcBCb1p7+dUs3qm/pwDC3fOh3ZC5h7BwwCsjjUmmf3vJt7AtO?=
 =?us-ascii?Q?pPxRy936VC7B/9VO2rhlvQ1MTAd0sX04s+RFJX3Z3lNr2IamDQjuCcx7jDpr?=
 =?us-ascii?Q?w2pjHS3PbHYhAfuuZUiH79tb3iPjHmK3MdU3W9riS5UOyZsI8w8SWJRtkHZ/?=
 =?us-ascii?Q?qi0GeoQYu0fgDpexEgKvZPBZqwsHtFnLdBLlhUEnVFcXbKVLC8MXAsj3G+M2?=
 =?us-ascii?Q?aTJ4YiZNmXYNI2EuCzWMztYDR0wMcXKqj7uDrDvT9SU2sxb9hmronLQGsgyc?=
 =?us-ascii?Q?yeweIlKu++YzR0a6eS+8Uo2rHUI5jZq/Bac0Xjute+XPYmmacJ3i5h/1Vpgs?=
 =?us-ascii?Q?Br3CRwp3ExjkGTSLKPHRH5BERWFse5Er12xxpTgd180krzn1/v7b4qQF/qf+?=
 =?us-ascii?Q?I7dJZtSUPtNE2yIOXvmKuHr432AZW7G1jYWa/kIrC7MdSiF+SkvZLLB8bq+E?=
 =?us-ascii?Q?jmWzytXwBtpbwgYpuG3WMISyAAi3JyKVcN9hsIWgktPCbH6DQJxcpFocJkVr?=
 =?us-ascii?Q?maEgl+FkLxEf9s8XSkRZBPubwHyA+kjSZuESxboF8n3mOi9njXWZwbwp6/MA?=
 =?us-ascii?Q?EnopSoknmfxmfGktaT/mLRSEpeWqs9ZniSsm+I4FWaskS1VXbKH8Ixlqg0oE?=
 =?us-ascii?Q?LXfLfPhUtb8KT9zTzua3p52clyfW2utfHiMu5b/JZqULWIEXsburgqnMP2wm?=
 =?us-ascii?Q?fxp2B+VrNAt0chxaKJgUGZYKUO459hz9MfI+tT9vtYgEF9APQel/SKvKTA5o?=
 =?us-ascii?Q?iQ33fSMV4V2pG1hIlsWxuuRCiXDWi0omOJPSascr/Czi30yv8ScxpdbDg/XR?=
 =?us-ascii?Q?sr7vV31bWGjNjLrYHnfRYq+4Uu+yOOXBCYSLh3Uw1Tf6Kbl+U0XmXSHQX6JV?=
 =?us-ascii?Q?1i6aJOSM+1f5hr2rCBaKG5vz9ZRTRC3o5jW6sZd01n+85WqiukxQdWzyN1dS?=
 =?us-ascii?Q?kCVXEpbP6gc9q8DDruDMW/jXkhIk5KiSdeAukW5NFi6SPo1KDtmoT/lhzjDt?=
 =?us-ascii?Q?+jGjUePxxOz0UTvijWUJ09btlaZs232qZKnSD4g+CJFtSlOI5iAbD/G8uOtm?=
 =?us-ascii?Q?nlfF8gTduJHRRP3oPbg0CjmhejYT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4524.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bqd/S8+m7EJU9tEYiTaQSKc4/Fhb1SxwuWuDG0CqUf3p9pr4mWH85vaSFTPQ?=
 =?us-ascii?Q?zpc1WxAyx4Lsl422o62LulzTu897SieM4NIREuVwF1fFzCwZd8pqJNlu7pBC?=
 =?us-ascii?Q?nXWsSXSVpyh2lST2FeULJFWXQVbc5sgSusUvKQd3JGodoFaOycoVKgQttxce?=
 =?us-ascii?Q?Z6o/nDFBz2Pi6gLmDlKnkV6xRl0RUvlmZsG8lO7p9noSIFX4htej1dmx4mNB?=
 =?us-ascii?Q?ZVmEialOLdbYNX1tGkTERXP92E6FoSjkMJysbnlX76D4X+k3CBbnPaSzAEym?=
 =?us-ascii?Q?GIn79WUP1pTg5UVUhwE8btu/LrGH32+ZDEVWBCK/HoB2Z2sc3+dXkREgW0TQ?=
 =?us-ascii?Q?/HYox8+ECjqaoJb5PMD7eGd5D/vop/4NiVydFHNR3DaMDNowC6NqgyHfqH0A?=
 =?us-ascii?Q?tnS7svzOlgUFcjMSfb0Pird7YS7IJ17RXifBapMbaUfP61SYVZJFiwckfAFO?=
 =?us-ascii?Q?e8z1qhFWU8PdGnTlEdk/pQUGjxMLzUbfZgm3oFUXPHepNn7cHAURcJUeDOQC?=
 =?us-ascii?Q?Gtq8Z695HdsBnEXmUUadqZ2SWyWOA8gM+oBUCrvQFk5IcMG8QAsf3SXjgWM3?=
 =?us-ascii?Q?ZJE1DCc3IDLfvFG8l9UmZPSDfS8zZ2VXu7N5hrpKSBgccEU4BV+S5/uc461x?=
 =?us-ascii?Q?uoU2Wd9O9LkWS4msCgy+3d0tUmvo2i2dlNNCccjxdA8LEdU0gIBd5YNXghSb?=
 =?us-ascii?Q?rA3J+/M8YiqrgdDQ0K/XDNBONYn1wnPgI1rK8lvskHJglmjMaPjqVCa8W0Nd?=
 =?us-ascii?Q?GrS1g2tAeGKlngjq6fNtHVeSbm8lX+dJ64kcXA3vRTHdyd8n7zTAJOw8U2xG?=
 =?us-ascii?Q?+1eeEPagcRWyJPCuI3BslXq7bkItdH+8aIGaELN/RU5GAMv2HI1ZBPJr0/ox?=
 =?us-ascii?Q?cB4XEkKdJIvLRFB8+JVqBS9EEnAIAAuVPukT0ATXUTMV4bDQjUc1/BtILppG?=
 =?us-ascii?Q?lK5b6d6CwWDxV4bVPtwci1mGcCld6OUCjh1nNV/b99A3UcahJgPMbVxNk+UT?=
 =?us-ascii?Q?Lqm7hdkyR8AmDH+fXZF5rf6D/Z/Amwy1HnwVrHGQM9AJSdCoqZQj9RIyF3mq?=
 =?us-ascii?Q?199v1eNeUPRhHc7asmWsTrQVkVvy+5Fkg72JSl/rnyl2bBYTOeFYIIlgZK0v?=
 =?us-ascii?Q?bpQMs47avPUM4wLq3VFQLPyCRgvcL4jppq0v4Sp0oqk2/GPljTGQ5C5EVsK9?=
 =?us-ascii?Q?+fgZmxJ5Fb44YnruPuqynu/O/mQ8y6cgwtTMDzXTME3cz8hOwb7447vi3hYP?=
 =?us-ascii?Q?1WQ0RkJjalwmsoEHY/QseXRkG7jH6QwlfhG2PdKp4Ra37u9nMF0fSuHlXDnE?=
 =?us-ascii?Q?wRCm5Evadrebkoh38eSNk4sXX6GCEsJSHGYksFQyN+5pBhabgAoc9H8gZURC?=
 =?us-ascii?Q?RtUFOKSzqeGSAKbTY4bzr1GIPOOF+uP3lVNz9UjCT1MX+sWLj79a8ANvJ4V0?=
 =?us-ascii?Q?F6ZNeLGQRMpBFFmeYlACNOQjsx5i6ooQZ5HJhyVimh/qGF8EbTMfgWwfE9El?=
 =?us-ascii?Q?wt5BS4mSgSbrVdikaxoSXoUrSK4y6LNf8QT3XtBO5LJHQ3WdSBFn8LsfxQBZ?=
 =?us-ascii?Q?4pRPcDv7nKOtrCyz0l8wmEvAetfmIDNNEvsOLs4feQ4tg7tzzaEbBfXWPPmS?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a232cd00-3e93-4b61-e540-08dd47b9d4be
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4524.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 20:56:02.2485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQtG7+5lwOkpVI4Jg9+RrMcqx01T+X6W8EDQeyDs9sjIVKZ25V+S/l2ZuJcOL2tBXh8s+IUcqGndy03ANGE9fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5784

Commit d88f521da3ef ("PCI: Allow userspace to query and set
device reset mechanism") added support for userspace to disable reset of
specific PCI devices (by echo'ing "" into reset_method) and
pci_{slot,bus}_resettable() methods do not check pci_reset_supported()
to see if userspace has disabled reset.

__pci_reset_bus()
	-> pci_bus_reset(..., PCI_RESET_PROBE)
		-> pci_bus_resettable()

__pci_reset_slot()
	-> pci_slot_reset(..., PCI_RESET_PROBE)
		-> pci_slot_resettable()

pci_reset_bus()
	-> pci_probe_reset_slot()
		-> pci_slot_reset(..., PCI_RESET_PROBE)
			-> pci_bus_resettable()
	if true:
		__pci_reset_slot()
	else:
		__pci_reset_bus()

I was able to reproduce this issue with a vfio device passed to a qemu
guest, where I had disabled PCI reset via sysfs. Both
vfio_pci_ioctl_get_pci_hot_reset_info() and
vfio_pci_ioctl_pci_hot_reset() check if either the vdev's slot or bus is
not resettable by calling pci_probe_reset_slot(). Before my change, this
ends up ignoring the sysfs file contents and vfio-pci happily ends up
issuing a reset to that device.

Add an explicit check of pci_reset_supported() in both
pci_slot_resettable() and pci_bus_resettable() to ensure both the reset
status and reset execution are both bypassed if an administrator
disables it for a device.

Fixes: d88f521da3ef ("PCI: Allow userspace to query and set device reset mechanism")
Signed-off-by: Nishanth Aravamudan <naravamudan@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>
Cc: Amey Narkhede <ameynarkhede03@gmail.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: kvm@vger.kernel.org

---

Changes since v2:
 - update commit message to include more details

Changes since v1:
 - fix capitalization and ()s
 - clarify same checks are done in reset path

 drivers/pci/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 869d204a70a3..738d29375ad3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5405,6 +5405,8 @@ static bool pci_bus_resettable(struct pci_bus *bus)
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
@@ -5481,6 +5483,8 @@ static bool pci_slot_resettable(struct pci_slot *slot)
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
-- 
2.34.1


