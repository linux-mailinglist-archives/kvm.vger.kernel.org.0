Return-Path: <kvm+bounces-30132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CADF9B7112
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7ED84B212A6
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09CB78B60;
	Thu, 31 Oct 2024 00:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ckKPjqVA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061.outbound.protection.outlook.com [40.107.101.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26F86F06A;
	Thu, 31 Oct 2024 00:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334081; cv=fail; b=oe6Jw4tKPlhw1lZ9K8RHHlesXY2uAxh0NWwGV5LDtpu/G+3mg4HfNpFmKESgrtDR7pQd31ktkB/OVYe8w8mDglEd+zHp7BNVtOeHill+rfim+qX/+BnJ/zLfm2vtzYdn0WEsdROZGvH0XIX+LlKnEAqnmoPGGaP3i/7tCIYz5Kw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334081; c=relaxed/simple;
	bh=8HmRIQ+ob3Cujks43WszTNKg071RPE+9RsXErrb33Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pXIyjxj3kjcfrLX25Ic9tYYD2NUQkt3eYNxubO5odMZBLVQPQr8dias9ojdgTREmVKIMHgTc0FJWyNY5/nogE4ecQBAeuij9Z/MnUyn1/B8FTFkyr3bkc6b+cw67J+fQhIDPgqBIUfdBngxXtb+WkDPFIA/jvlTMtlUEVDhiB6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ckKPjqVA; arc=fail smtp.client-ip=40.107.101.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zT1PajWwCdhzPFFx/fmKaOUXf2CIM5xxQYlLjsOrJSjtmP3qEOverjffeSv6Z8hyMcCd4PXgDLJg9qds6ztvPynhTOYFKIfxW1wnciYD/y5cwp3Xn32Gp0DGLgwwWF9N7fa79vndSQDvzt3llEnCDVj78+6Jm4zJU65g+ee7Ugfxzm9Lk7WOefpmr707DlrdKXnxIl3pfeVttlayJgLAlCPcS8OlWKet7DWXbJW/RPJTeetJcXhqN66ORirKbCvHTE40L4rchlbhZy+2TwNNOPFOAuqmD4ODdO5fu9eWOzrf8UbPKVnzIUil/OjO/upZpBOevvqsAypV7A8UgQ28rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfXCICcjx/gPooceCH2idpyPNlo530cMDJUtAU51n+g=;
 b=wfUIEcOc9cWUEwqW4/6+ti0srA3cBtwa9OLYEtTdlQMpRZUDCFXmLVm/NAnZ2s5XWCQYWNJMBwaDIKzQWLl2TmqWDe1Nr2VlRXJBe/XLnIDEHDJVY4hEbALh7prThuyDha9JT2zwYZmwm59dW8DqzcPQZ73qV8EegsKeF/gBjQX8U8Yfe2sP9b5hUqmgXTC35c8JmPogU8k2kgpUBcLEOvnaBTGq/PLKf7Ap6vy9xfe7G8vDMgwZ8PfAvskLjHjgYB6IlbuKkk9bEA/E9TVFf8gUIHD61zQcjSKZoeRpDD2AkcwUW5LXc4nW9e7vvRk5LHR3Jc6DvxcdBqKKr+30IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfXCICcjx/gPooceCH2idpyPNlo530cMDJUtAU51n+g=;
 b=ckKPjqVA5Cec7L0OVzDaQY2t5gPe23r5X7iLul+s33hQFbU0dcgcEEyBMfXRpxktsg5svW8cLzKKnEYO8exTfyO2/wjIHVLM6K23oQ1LmHVI5ThxROoaD0dDnzM+7KR1NtfG6aKEXAC6zdAMoHiUKxK9B7EjHoWGcPn+/2dywW+0LthnUYB1whQkAAfvlAn/7FyIbfx3puXd8JzPPCFJj537WbKayjO2anF1gOL6HN3DsIOjKqy0594RN1UN8swoT6GIbUvvfBKcI/jRcdtA46itjBHKgIvqgovvaMp9/D3HTHK6E15QPAawQddv78ptkZs9iDdU+3aSoUW6EXSowg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:21:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:21:01 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 06/12] iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
Date: Wed, 30 Oct 2024 21:20:50 -0300
Message-ID: <6-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:208:23a::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: e917b365-bd5a-4ce3-1272-08dcf941e495
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7wLGnVtWm5E8MJPNSBBpnUipcRnbmkO81d4obyOch6oravTyAlsZ4OlUTamt?=
 =?us-ascii?Q?3RpxvZCgZQJqBfc/w70IchPQEg7MQTh2wtFzPxwCLJ7ISa4f1dNxQx58uSe5?=
 =?us-ascii?Q?zkl2+BKxMXPuRUZS0xz1ZxSWB/nA5xVaskLRUj8gVI8duLeR8WZdtaII7Ze4?=
 =?us-ascii?Q?6A5RgyF41R1liFDOvx53dE8u+YRVegmml3Mam8IuiPU7Rarm/VMvzDYDjxj+?=
 =?us-ascii?Q?T+W8cLdrQ5Z9hrwtIi+scpJTBMNrd7Cs7urzsqR+oxF9goaK5HP1ZPDriYoD?=
 =?us-ascii?Q?fFnmSc7/5aJWk/ALnc470r5dahdBxuODvJ4qLdvvYKHqJ2ED+F3TiGZgyAg5?=
 =?us-ascii?Q?hp7MRTrYiTu1dNhYB5W8aqU9EOTVcZFaGBCpcYrjGW/z0hBLij9S6c6bJQtx?=
 =?us-ascii?Q?HmudU7PsIAVmfXkHSm6IUSpbcI97CV8q16Ky/gGOk5v1JvQKMZqU2tTfBLXv?=
 =?us-ascii?Q?eimnhkgy+kS8cPVXXRyweoVJR762dePrAnzQsGZqQ3v9exChkBX2jaJ3LZIh?=
 =?us-ascii?Q?lHJqasDe9767YtVkXEVpGJGtWrGBy1bqKEkzxBHe7b4VKfDwzjgmkjSNqPYm?=
 =?us-ascii?Q?i/dF7kAIL9t8iYTjxEcmFFT2/e+oF5h2vDJnguuhLVU7ACzMX1bTIGnHGp9C?=
 =?us-ascii?Q?F0xZBoR0CPlhyR/ajRxhYQMtbS/qy1atcBCL0AcfwgjoQPCk+S0BHLp7cG2j?=
 =?us-ascii?Q?fsZlSvMs2dYF8wDCsCZlQSB87WMwsxPKYjhuEbR05I78DHKqhrYgADSIu1MW?=
 =?us-ascii?Q?iEkhfYLKOfvNEAixMDXV0KtUTDSVrcwNaHLJffBFdhhGv/63krccTf0Xn1pP?=
 =?us-ascii?Q?jXTZdnH0lvSAPKWYmbBXo/fF1myfnlk2YRmXu3mpyrrnn/4Tu3P0XxOw17g4?=
 =?us-ascii?Q?FYslFfA22foHUmr+DsNHpXHxGrF4fRlJqSYwUa4NoARZUmg8d2zCKhNPYURv?=
 =?us-ascii?Q?iipuS0jMX03u6bCPFhthetl+/1WjQSz+f8+rt2AxF/9IdGT8bt7OnQeSyx+l?=
 =?us-ascii?Q?fav3FbywaludECCHWkJBrBaLC9FK/aE5Pc4W0rNYjnduqcdWCjuLT6HkZpxf?=
 =?us-ascii?Q?77ptL9ax2EkAea/BgR/Qrc6n0PJrZNAn+gfYaWVNdyJizvPhIYQn5aA88EJ4?=
 =?us-ascii?Q?lY2R/4EG7193Drcde9I+Kmd6zlKPfHL50unOnmPjjk38K/JccrhZ3SeGE4R4?=
 =?us-ascii?Q?d6tj1Tmn2rBHuXfF38gikrxo6MerUAL5j+ROCTY0TSf1cFRJCuriHYi0Q8p8?=
 =?us-ascii?Q?UHFXzdYVUz5gENXLg/G0r5jpYu2SNQq1rTuBJ1hy9vT2CXMRUpKFhe8Lff+d?=
 =?us-ascii?Q?xmDEklmu4OCrSyJoCSulond26jw/yFR21qrnFdlmzsU7P59wsICOHIKtc7LU?=
 =?us-ascii?Q?mwpgzNo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+1EZl7QyU5rPlD4u/gzBUHBxLyRmUrZc7kUMvkOnFW+QWnTlFDWIG9SfNOhr?=
 =?us-ascii?Q?fXPHVdDpfeI/PcWHmjSv15ZQqAsjPzGFL28r6r4tJOOKDn1zmrt0F7ThrK3B?=
 =?us-ascii?Q?Rkw74f1FpVO6F0NUsxkY1gL9DOmwWPL3nJuYvS+qRRXYa+iOcLiw23TbgIGB?=
 =?us-ascii?Q?uWfJ11V5vW6Tab4hqHFEk0NmcsaKFoKgen4LI4U83ywJI3EUEPfT5BZTbxEX?=
 =?us-ascii?Q?NJP5wzBrXd8CQnlGX3cRXTg1iDcfUGENeU2V/PnHRm8B/oMecfXvXjenF+K/?=
 =?us-ascii?Q?U3qIKvS69FH6UbC44P6URl/7A09UIFerdg8P+oHJs4H+aXVU1mrfyWoL4biT?=
 =?us-ascii?Q?SklF7wmdVEl6sb4EoqVKWWWOSHMsUKQnFdLsAQQTyBG5iShZeuvJrWyZOEf3?=
 =?us-ascii?Q?lUIzVyw/lTzC1ffPhlUSEMAs1z21EC52ygAOvdlQv4SEEY6vMjNmiHI5jO52?=
 =?us-ascii?Q?4F76N1eFMepQwHyamdwgC4on/dg6RYMPfg7PVFX4yV3kR79GbZitBv7dcCml?=
 =?us-ascii?Q?a1ueeICuNeSZ/sxsmK9Ce5On0lGzeOqYba7zsAZoYzpGpIWoslDGwlE8gWpE?=
 =?us-ascii?Q?oBBIuV5aBIvjzrRvUlurCIhE0wc9J5h9QEe9vu+st5w/U0/UHBqCT/qIB8bV?=
 =?us-ascii?Q?Xsbluap4FMAKT52jOAyVvfww/nZeT4rlzJU2Spdabe24FwpObqcjXwS7B5Kj?=
 =?us-ascii?Q?Fhps6ax0a+pnuh9yxSnIN1Wx0oDQi6H1QJo8B0CE8yFk8Vg0I7Uzz/XKarBs?=
 =?us-ascii?Q?rKI60lNmgM6L7wdkVt4Rqw8c90ICwh3Yuy+hapHpd3AZC6qfHq4wPiF44A8q?=
 =?us-ascii?Q?2rYOSfRBM2HPjBVOeu2fKZOexJTaHjl1xLStrEixF9Z9NHGBMV9kHkzBcPwp?=
 =?us-ascii?Q?uCrvzOsTIbXOaQ9a31W+DY4rTTsP0J+PqSqAOaTJgIzuvMhxi1TE0/0o6FNF?=
 =?us-ascii?Q?LoXw40JenDBhzchHf9yuorNilhx0auazNEFmx2zgovV+ztZ/DXIkL3TT262L?=
 =?us-ascii?Q?bjH5EwD/N2kWaiz4p3krMYURnb8L2pLone8UtYG5eB1TBpUWTwNyPAOD/pyz?=
 =?us-ascii?Q?bmzecxr74+mrAehOwEHLPgpIplfskF1sHfIg+7v06OwspguwVYOnZWQb3eac?=
 =?us-ascii?Q?rDgEuKplmJJiAjTgduTEz+vFFNpKL8IF5qHK+3BNO9j3dxaN3uLyx19Bzu6X?=
 =?us-ascii?Q?vpH3RfzZ++FLodNUapkyS+E1n06XPD750KVuwMUvWYIst+LcPT4lk1+8+0k/?=
 =?us-ascii?Q?tGJdk5ZWOmy3GW6KDAS3fCcUsIenzGmMY9SJLsbTJv5bnvrGJEsNmmwsC1ub?=
 =?us-ascii?Q?n1GPJJTNu8hJbbV7sns3pZP2bXtXqmdN8t6/i6q/pHrh7LTwdwhwKhgxS2NQ?=
 =?us-ascii?Q?vVCg/mKO5Td6E0VsJWLIsZ1WEEQrRo/TjeDGcKW//GWcfIZYBy+GHwUZuGtS?=
 =?us-ascii?Q?afMDuQTTwy7gxyaOW0yTlVz272fWoI126wPdlV4/r5rxuDa/xAxOiw8Y0uLu?=
 =?us-ascii?Q?sd4I2qjlr0SnGfMoir8J4funsBmYRo6mVy0h5eaBXWJ3cUkVKDq4uoEzUoAw?=
 =?us-ascii?Q?qGcpDWoZk6blorpF+kI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e917b365-bd5a-4ce3-1272-08dcf941e495
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:58.4214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UpayNvBePLtLGRhcOn2XMQkiH5cMQHoDI/pX2qImo9UUFf6X7iKcQSSIPfUNF3Q3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

For SMMUv3 the parent must be a S2 domain, which can be composed
into a IOMMU_DOMAIN_NESTED.

In future the S2 parent will also need a VMID linked to the VIOMMU and
even to KVM.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 996774d461aea2..80847fa386fcd2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3114,7 +3114,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			   const struct iommu_user_data *user_data)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
+	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
+				 IOMMU_HWPT_ALLOC_NEST_PARENT;
 	struct arm_smmu_domain *smmu_domain;
 	int ret;
 
@@ -3127,6 +3128,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 	if (IS_ERR(smmu_domain))
 		return ERR_CAST(smmu_domain);
 
+	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
+		if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING)) {
+			ret = -EOPNOTSUPP;
+			goto err_free;
+		}
+		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+	}
+
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
 	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, flags);
-- 
2.43.0


