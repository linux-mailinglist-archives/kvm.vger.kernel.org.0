Return-Path: <kvm+bounces-34643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B43BA03255
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 22:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D46547A22E2
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3751E04BD;
	Mon,  6 Jan 2025 21:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rufQ8efn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA05915886C;
	Mon,  6 Jan 2025 21:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736200362; cv=fail; b=j5fkBnmoLHikdNLXgIBAtzBe6/IGgGYREbWstDB7ZAdiWcnuXeGvkzoZckZafEQfs7J0gO+gznLwl8VWUWdpPuc0+9qPCWjrK3cwlGKKV/rqL1KpFTSLcBNocsB2jsHnfWiX/fJRwZasA2ti9yb6p00/vo8rd9rdKtQw8m4cKRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736200362; c=relaxed/simple;
	bh=PQwidJsi1fy0mAG8Hkly8jtx9RLfDGNdmGWHIGq50dE=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=VTTef/vNO/7o25in79gHJJ/HZYoAjvYw3nnH2aXOckV9TZLfT1X1bnEr3+8Ur1mCgcwQuIjDv9XHlBGfr0KUWUQ4wwT8mlXM+56HE4oAySuAGtjn5LrS48mjrZhrvXP+kGsTAdEAmNQe6s1/Sk+KZcSyly+Y55lxPKNRkyp68EU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rufQ8efn; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ROnz3L2MYS9xdv3PWzC/KJvRPmWAhjBlYNVvKPebXYtqaMi7c8gCKvmO4/knKZIAURkEY3Fk70CXwhvqQqOyevgS4vBBNSYH5S5a8KTEXf72rpHBbyRuOu0wleFFOuxRMVzOGX+MqQySmfSIBBNLMIBqZsQEYfiZ4P35dsI6iMqzXV32nC41S6ZlcgE7wSNDDw7vunBjOYUEr1YNNhzTP/hR+E2QDs0fEm8TB5vO1Ey+IiOWvhkwd1H23qClpouvgCnzEq6yRqqQcz9rEfbAqOYJ7jrdGF7/DUUbc2AwJNtp+e2Zop2XaAqza1FZSviCO1PZDYh9Gl/f9UElhoxqxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBN/fe1ypBCAQjOwuYQ5sw3Yo3AsNhUL+Pzg2nsuyMA=;
 b=wTEJxtk5cUruz0elhuurY3KDZ6fbQZgPR6024gcljPm3IYzeIdGSLgh0U1G5rq3S2afBUYO1y5FXdvxMxKpqrdUW3zZ8xxf0pZ4jDXFzUoba8zD2HYTtZKILk23CFALV5jRtiC1Zcv8r0Y6y8gIB1tOPNZD73cw/Cb+Ke86sOZGv2rsxny9CZV3dxEf7+0H242wDhTumipvxjrRvBPjb2JwOLx0h0Y9wQTBJfakh/cFHupqAoHREO0ezRtQBvdYLWSnoMAr9xP+CSGtC3U2C4EI84sX5IMLzvPEtz4MeGFjTpd0J5pM4+9UkLW283Qlso9+FitLnZez756uNN8zf1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBN/fe1ypBCAQjOwuYQ5sw3Yo3AsNhUL+Pzg2nsuyMA=;
 b=rufQ8efnnbW/JrK6Vxee+6/pTAIAizegdl+hJHgjWqLw7DKQzrUoECPqo3Jj+UYbIYPO0jXl0NOfPIDgKug6SSzfC9ap4EOp2P2mSlm27bs15xtkaFBiYJ45Fb23UKIm7Ecrb3EyKNe/enK56sLn7BSmsrUIvHKECyLsHy/ZhZYGEWOZFs+2gpmVnHyK/CEImCUz6uxavBpwJVCRTRojEQ7B+ZpmjEARLgMKY9hm/Z5hwyY/fHo8324v6hJ29JKrMXCPey4sY77ixn2TO9OBG7jx0rc8mD+1jkHFL39XO0OgeoE+WCjT69MA7uuYp4cR7Q3jnVpQ+HrY5aB1jFV3pQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12)
 by IA1PR12MB9468.namprd12.prod.outlook.com (2603:10b6:208:596::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 21:52:34 +0000
Received: from MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e]) by MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e%4]) with mapi id 15.20.8314.018; Mon, 6 Jan 2025
 21:52:34 +0000
From: Nishanth Aravamudan <naravamudan@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org
Subject: [PATCH] pci: account for sysfs-disabled reset in pci_{slot,bus}_resettable
Date: Mon,  6 Jan 2025 15:52:31 -0600
Message-Id: <20250106215231.2104123-1-naravamudan@nvidia.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0179.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::9) To MW3PR12MB4524.namprd12.prod.outlook.com
 (2603:10b6:303:2d::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4524:EE_|IA1PR12MB9468:EE_
X-MS-Office365-Filtering-Correlation-Id: dc2821ac-9681-4db4-7353-08dd2e9c6d46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iiWh+09T/U8No+dqyPByxdlRbfSvS13LVQ+mFiuT7ULWdKx3t/uKBILfsuiL?=
 =?us-ascii?Q?vSDrwPZuuTreLT3OZU0M+CD629kP6r5WQKqjzRCeHL1TEbi8pTFD+wzYecha?=
 =?us-ascii?Q?ZZgH/OHLn0kQjlllmK+qFfWlji7Hx6lPkjaulWZyB9IIT1gZn0L+kpp9lyxR?=
 =?us-ascii?Q?A+Dth3/V9KxITsXrAZKuEHMAnxp/ZHMrExCl3MKyC0b78dHdEdk7oPp7zk6j?=
 =?us-ascii?Q?Wpw0cU7XLit5y0H7iZ1URAs/iT1fNMcYl3081I1sxtrtum9r7Nfe2na+69uk?=
 =?us-ascii?Q?ALUeHlg8IIU9FKv+PdWkR7EXIL33gHV79MCQf1xZdX/eLVpkHvMtT2rsbZ+4?=
 =?us-ascii?Q?QFnboNU0IjNzKlhenVvXPwrKDdclRnNcWaPPfMxOEQ8LPgU3Lxhps6/YpEZ1?=
 =?us-ascii?Q?2dJ0Rv9hgazcEz7YaC0LlvNkPCW2dJqQvHQdP1fLvx8g99KzlLxdZQmD85zK?=
 =?us-ascii?Q?KhPWC17evMDtHHV51SgG2w/Us4F+HkgoZ4TgD+L+M8vA+kQO7iMQ5YR3Pz/0?=
 =?us-ascii?Q?9hEArQwfyJs1iftHes7hWssi9x5oIPMSX/+tj9Je1tF/8qry+z0ToPxqpzFE?=
 =?us-ascii?Q?fpMKZqnwbW8q6kYHq9S1wTrBOgvnyE2tyQiFRPCcOtqGgaMZFZoXIqg0ajpA?=
 =?us-ascii?Q?uEn8sQJm888CMiuJt25Qdj/6QO4/tarkDWjuT9OAg+ob8kcI/Ga87ELvYnc6?=
 =?us-ascii?Q?EGS7nY6cXOA888ZkhRbpzJGaub1rT4cW8+nbPKY6lUZXF4hNpHaaV4v7oQ0e?=
 =?us-ascii?Q?QwfHl9sdaV6G1vloLbPwSpYZ7lPwWvuD/FAXv6aV6qRnyl65tHGb9shAq2q3?=
 =?us-ascii?Q?kO5nhpEKCq07IuS2LBe9FXfScWZWN9wpwtuZ3hB2/8nYAmRn0sghxlI2p9GS?=
 =?us-ascii?Q?6GWTv1pYeiIbpRVZDJZuLMgopxGVo5n9TKAH3V6kekDAXmuKQwaFtfEKrZIv?=
 =?us-ascii?Q?3oDkAjEA30nFI1/lu8YKGIRI1jCtnUUzy/FdyJX22KjttTm1VE71WDHsDviE?=
 =?us-ascii?Q?w1F+jIL24GRNIqZlvwcNnyK28mYj0iMMc3BIBjFTNezukPESSN1Q7JQEctjL?=
 =?us-ascii?Q?pC/evHd7uoCoXMcLxsnTKdDU9Ykbi/H12Cw8+7Ex2THNexiLcNNMJYFULEUD?=
 =?us-ascii?Q?l/+9ssp0+1v+c4CABnPfCB2y0ZyhHrEXKpDjSpmAfJp2vg8LGNbH0yod3eB6?=
 =?us-ascii?Q?sl+Ggih9Q8dIGmw9wcRbkEIGpjfKKtS/SIwpJWoOaGd+1wKv6WfNOtoQj+w1?=
 =?us-ascii?Q?39MOcdZt9jGmCwEm6CEjiO0oSWpCCdxBNRF2qEgpkI/qcRY8H2rNnYaHgk9O?=
 =?us-ascii?Q?U1VtpfREzBtLZ7gcpEvhLM8ymUYGKqTx/RL1jS7SAPPyF59w1sptZLii6M3T?=
 =?us-ascii?Q?EcVP3+NsQwAZRiZbgTURUU+0XhFd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4524.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e5hyndCmhmmb5a2jQDKurXZRH7D8qdM/PkY61Yt3O00C0LjXuEaXw6XmlTa6?=
 =?us-ascii?Q?hlENg8hjsH7V5lsONa6+/hmsdGXO+FBzRGRp+lXlREEPpAQ5ZwW75t5v2HIu?=
 =?us-ascii?Q?bwNcKaHq3A/utQoJx3QTxFwElbBpbXkhHiPaA2wUM0QwpjJ7bzERC7BY3/MA?=
 =?us-ascii?Q?WrHpiZ90638zO21dm5liTl4Mi2SEl3wadkOhKMw1p657aZ64veJ4enH+S1uD?=
 =?us-ascii?Q?m18cLW4+E7Vi/fVTrwYSa0o3kXo2N7I4mKc/e9x8t1gxRudAjpCIV0XHV04M?=
 =?us-ascii?Q?UHaXNUeeqViZ9pYV8CIm4vFrb+wP+H+jpP/DQYxJPjtM2asVNXSl8lqYD2PH?=
 =?us-ascii?Q?NJDbzbPe2WKP9MC4938tE5OfK/6ZOsjHiRpGPRmIIpsoGJxtmAyTqzw7Q7j2?=
 =?us-ascii?Q?C4XNpDC5h95r/TOO/6PWmU3zYqkFW4bpsmB2U+CfNP9aAlO2iNtyITeVO8oe?=
 =?us-ascii?Q?zeqzHH9+HPv0FizlcXuB4suk4bN84q2ta0yx//t060bukK+DaTvzB/COGnPn?=
 =?us-ascii?Q?a9S4PTMs2no5wrprIrMOBX9HQv6JiKlHVa2UPCITeX7UiZNZOxJOXg2CKgaK?=
 =?us-ascii?Q?o4n1PYtV9O4fH48+xE9woktiJrKyH4WEtyoQMVV6K9kGMowSt8Xgz7xZHGD9?=
 =?us-ascii?Q?E2EPty72waLmYauklP+ofbuzYGbVn5VpZ1RQMnkuPkp+BwFhlq09pgpCQhzz?=
 =?us-ascii?Q?jIqvvKRseq3EslqqVWcVhcq1jAZOKFvUoxET1LFUe+3/9JvheLeZcf0yeA2v?=
 =?us-ascii?Q?qeksJtV+aMqNO/sRdRmJO13aSTkS/dzqlYrSTmV0kxfKzpVIwtX+zVwz4qzc?=
 =?us-ascii?Q?B6ZZX7wcNwt6yQnperHRyBpxafAgUhUKmpxAPIXLH9xDUtuAu2HAiD7CB+a9?=
 =?us-ascii?Q?Sr0N+v+SozqIu9dj5sRtw52MQs7Cn9QGoW0QXhx48vL94YRTWdHuWspvhv+e?=
 =?us-ascii?Q?KKW2S15SSooKs6Ko9D5qfgAJ5jwTIwNu/OpVYMmm2TzhvjV6YUtgJdxnoDNb?=
 =?us-ascii?Q?WXt1ZhwTmBd4QrFcwwb4/Qk2PvV1hPBdNTN56keTxQwCFyrVivw+FtfzaRsG?=
 =?us-ascii?Q?p3FJ76l4yb1FXBHg4I+e5F23G5DMF15IKnBAId/bk0NfCdTpLL8Dr/WxIyrk?=
 =?us-ascii?Q?EGFQhGqz2I8Vq/VrVc3GKmMUpY8Z063rQN2cT8i0i5qB3txUcdB9lFWNy2S3?=
 =?us-ascii?Q?011jN+UvpWu01gvuajnd+oCsNTROtgcjfOuNcdQuUTucUuUIWs1NVl+3I+pB?=
 =?us-ascii?Q?Zp80kvb+02c/3yqNtQjSCnhsf9nFNu5CWuTuy8/QZCytdV3E84FSe3hJDZIg?=
 =?us-ascii?Q?NFXfFxYdkqMGO5xd4NuFTU7xVtqeuzTrmSrYjFzXu6jEH2skpSvGj25zd43w?=
 =?us-ascii?Q?saRSAI3ko5i8vHtt2EKzAi7HV//iF0R1hiWMOdrPTPs00CvGRC6sTWC9hoV0?=
 =?us-ascii?Q?zz3rmhgbqUnEilLOgQSykrPN/A3zh1rZrS6sT336ODMsc5k67c2qixiZbvq+?=
 =?us-ascii?Q?IK0AwMjShgzTaBTUxUt/I5QTSASI3e2A7VBRia++iputjgo9f9Do5dI5kPbY?=
 =?us-ascii?Q?oVqlxsKNA8pouNH8BVQZiIPkJpoNgv6CLGELvZp9S7xIzK4V+I9FW7V7oEr6?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2821ac-9681-4db4-7353-08dd2e9c6d46
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4524.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 21:52:34.1799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +QmEN+rCB1iENo+P9VIy/ZXN8qd5rk1J2ToqeXwG3t0DHqyi+01H+7y2H7lBBUMNDmaofKMMUwIeimS4nyd2Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9468

vfio_pci_ioctl_get_pci_hot_reset_info checks if either the vdev's slot
or bus is not resettable by calling pci_probe_reset_{slot,bus}. Those
functions in turn call pci_{slot,bus}_resettable() to see if the PCI
device supports reset.

However, commit d88f521da3ef ("PCI: Allow userspace to query and set
device reset mechanism") added support for userspace to disable reset of
specific PCI devices (by echo'ing "" into reset_method) and
pci_{slot,bus}_resettable methods do not check pci_reset_supported() to
see if userspace has disabled reset. Therefore, if an administrator
disables PCI reset of a specific device, but then uses vfio-pci with
that device (e.g. with qemu), vfio-pci will happily end up issuing a
reset to that device.

Add an explicit check of pci_reset_supported() in both paths.

Fixes: d88f521da3ef ("PCI: Allow userspace to query and set device reset mechanism")
Signed-off-by: Nishanth Aravamudan <naravamudan@nvidia.com>
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
 drivers/pci/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 661f98c6c63a..809936e1c3b7 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5536,6 +5536,8 @@ static bool pci_bus_resettable(struct pci_bus *bus)
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
@@ -5612,6 +5614,8 @@ static bool pci_slot_resettable(struct pci_slot *slot)
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
+		if (!pci_reset_supported(dev))
+			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;


