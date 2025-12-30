Return-Path: <kvm+bounces-66809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D6BCE8777
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 02:12:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A67D73013392
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 01:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6C52DE719;
	Tue, 30 Dec 2025 01:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NPBhIJqM"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8A42D9EF3
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 01:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767057166; cv=fail; b=CstwHwW4Chd2/apGDzjUN+sXILqQVoSYzmHI8y7nbzKttmcDfmTWrZVuHOS0ADbQDDbrNihB7SYtFX74ufbMUosBAqexmq3H3MYrKYc63ExULG/ZfTdT7JZ5nFBdexYR7i2A9wE4YOilBJlQmK87A3vA5N+UZnr0ZCAelD+Sgrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767057166; c=relaxed/simple;
	bh=JprzyW+pMzZ/zWcfKQ7SLusLsL3Hq9F2XnZeV7B+zg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YNHfhVoEIp93ZYm+u3ZPjE0T5eqld7yDpGjUNRSliq7p5V6TYeu5Jt/5AKQL27/b5qXs4P4KseC2j2nYzuJzcdQ1a/NiHqX8Ny+aCQ3Hgjg4JgN38g+38SYBZas8ubzPBYVdynFheq6mdEexlKj7/06P4nkLf/K8sfVpB56OWH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NPBhIJqM; arc=fail smtp.client-ip=52.101.61.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WQKmcBGW2jcTFuvx57rGs2d4U5381ijSB5ZWwcedoNLgVzIjfhfaj7EYcPWhP9cX/MeUAVqEv/ukMNZbKD1mfmN/2Mv0YdNvUcg6LjNo2fs1yi1qf2fAcTMu57Jkm9NWk/ezPiMtCA7Oq9OynDWya6ukgfVS8pc7Rnmb2GqCWcHaJAOvkNrpPwQRwWhNYLwBjZgP+g2rhyY6cUwU/tWrqH5AJi2PpShWN0Az5CKnVdRmlPu3xxpLAmlscg5mUjJ7j1xj0ljot6MY8xWRH0jk3Hd1Cf3Str6E+u7yWsUnDtuoLwNpGE6crCIH0P4udrJoB6oQ0TrZEhSDhLf6At7NOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPbBM95ObqC6RBKbRgZFqq8yPf9Re/RjSSLM3q4OUQ4=;
 b=aP0eSXizKNu3pk9TXGiprtwZts9Bj8wX7lE9xgsit4dVpKSipwdlCOrxXYcgI7BEnG8O4NdFgMps4LlFv3hk5GCqFEaMDlAaB06QgqZilvdg/sKUnkRqn4EurL0wb0JDoCRcZIoBvKEb++04MjX4sDhQexogTy/0x/PJR3p8BN+tyW9KQ6BSS0y87DtzOPM5HeN2pUxttbYtOy6eacNB9dI1ONl1e2XoGIPURJ+k4Fn+Tn++RLjH7KquzAwNj8HkX3qdLqkZA8UcLdKtZCGVUJkX7o6HP3fWFUBYttIpsb0JJqDvplqFhnYZSPRchND/vmEIJPPK/QEfAqOwfc7RYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPbBM95ObqC6RBKbRgZFqq8yPf9Re/RjSSLM3q4OUQ4=;
 b=NPBhIJqMMrw8AQqRB4fE1djFXrsfSi8EQk8jNsV46jUBA74Z+ebGczTao9cdMAVH4AxHnj3hdZRp5b7b5SxI0MtITE1Zey+SoMNKpnP/q9urvM8udwQysEyYbnx9u34qvj+7bbb1kMAmT0cXTXZ2ohp2hBj8+wHzl1uAYchsG2hU144lKwYoj6KcSKAz8y/UBYS3/9cq4UIlv8bv0BrbqsJIoWr20T51iKpXLpx8QcHpINpUV3UYrCnl42b7pe+5ZT/ufgyhjeS51nIPBr2pbin2WK5NkMEklfSVUb+YLzaXPgxAEkisUXPxtAJo9lpVoFXpDYlw1NKV5iZN02jPlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5831.namprd12.prod.outlook.com (2603:10b6:510:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Tue, 30 Dec
 2025 01:12:42 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9456.013; Tue, 30 Dec 2025
 01:12:42 +0000
Date: Mon, 29 Dec 2025 21:12:41 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: alex.williamson@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
	seanjc@google.com
Subject: Re: [RFC PATCH 1/2] vfio: Improve DMA mapping performance for huge
 pages
Message-ID: <20251230011241.GA23056@nvidia.com>
References: <20251223230044.2617028-1-aaronlewis@google.com>
 <20251223230044.2617028-2-aaronlewis@google.com>
 <aUtLrp2smpXZPpBO@nvidia.com>
 <CAAAPnDEcAGEBexGfC92pS=t9iYQRJFyFE9yPUU916T92Y465qw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDEcAGEBexGfC92pS=t9iYQRJFyFE9yPUU916T92Y465qw@mail.gmail.com>
X-ClientProxiedBy: MN2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::30) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5831:EE_
X-MS-Office365-Filtering-Correlation-Id: 3717a928-5d3b-440a-b8e9-08de47408810
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3YMaLpI732kYrzBUMBe/2ALHb1nWVI+zIExKgeeXrTDHxWhcYhQGsFwhF3tb?=
 =?us-ascii?Q?/Nn/C6ddJ26qINZ/S9WEwdckp7D11DY1i/VOd2LDaVGs3791+uMELfBqQfHE?=
 =?us-ascii?Q?upj7MpgxYanclWdLvTBu6CfIWBbp0zad/uIbNPj5eAcg39jCctc2yAk5RiXt?=
 =?us-ascii?Q?GR4J+UPi3kU/H76fO73yvzHylGU1CSOpRBVNddRECEB7ugoo3u21e7PbI48l?=
 =?us-ascii?Q?EVM5ax1MqmnNJ5HX4J7cjSpRlRBNZCc3NnagLPGz8NPwYa+unZITzDpGWVL0?=
 =?us-ascii?Q?cth+2kskVzalqQQWYx2pw5kDXvC0/0w5HcUnXZG6H/VolCHSH2xpuGJgKWuz?=
 =?us-ascii?Q?DyF+5mjARb2lmQkaIMHcln+Gcwy0JA1ayylrhdIZ+WPyKtG7ni9DR3lZBVQZ?=
 =?us-ascii?Q?aPOT+v3voAmkC1rc7KvQNC0n/8I9b3JXRxTmBr8+KQsgzWWw33VaDI96yPld?=
 =?us-ascii?Q?zOEafdv9dP+tTaJYX87ZikSOlMM1yCnsEUOhSXo00GSpOGbJMHGYCxRiff7r?=
 =?us-ascii?Q?1iWJUdCFW1fb5dMavFtdRh+OAUyJfz/EiA868jgdIMT/wO2d7Pd4UJ+KSdei?=
 =?us-ascii?Q?o8Qyz6/atXueeogBwAXmikwQqIFd2x64txdn+P81QSJjKGMAhXxt35HIlzvx?=
 =?us-ascii?Q?ds1ddk6HxKjH1nS4WtjgTWxHPSA378XRsk/3Ze+P34zFzil7HsLI8mNNFPjb?=
 =?us-ascii?Q?wCdM8Qk/1AZGBYbLAEcQ1+J0Zw3RpsUPBrKnempx0Gebe9Lcw5SHXYTwLtcc?=
 =?us-ascii?Q?WoG4NRJsFep7IqzBv8BN1UlSo0oY+n+jkCZj1dMTvxRcIkdmF1SZwfMl/lTv?=
 =?us-ascii?Q?X4hFwVU7FaesLBidYpKAzrVMdnS+v4Gw1Kt9h2JLoRpmIQprVr1HxX0H20Wk?=
 =?us-ascii?Q?ogIwNESZ/wofxfcYRcbustTPVXmLmqkSp8snFW3zek5tqxhJekVEaNAG9e3L?=
 =?us-ascii?Q?O+8YO16RhLwAhB9mWF1+PWNbpKLH0IQkr6/FTuXH+UnigvJzTIUM1cvUYB+S?=
 =?us-ascii?Q?wh/evEIsT1bJfVNMwoa/K2qaiSQ6oMxto8bHFOHdwsSDhRPlZtIV2oh7/go9?=
 =?us-ascii?Q?B6c6VG19roSiahQ+92I3Eti8h7NI1kuCwxLgF5YM6fcvRYU+upf25Q6pn7kU?=
 =?us-ascii?Q?panumnoM7DusxLMQyoeofs3mN4MfiUY+AtowkNtiodRScFbElTWqjPL7ubPI?=
 =?us-ascii?Q?sgyOObpcQaQYfZVeyNTTdhGMdDAZOPDirzCuRR2XDqz6E7WENiMV2PgNy5XY?=
 =?us-ascii?Q?eLRQd9NOdco2ziKCQjJmigPMrzOzYDEZaDyiZDNUdwk9fIuaGKPynQDw5BR+?=
 =?us-ascii?Q?84jJi87P0+TRKFji/NGWA+bFTbHvPMxfGr9UtjpeokZ84yNzbLquiFU25cT7?=
 =?us-ascii?Q?cMcUX+uz9lelHiuqQPFKxupvlN4nAfA81N8t8tziVpA4sNrRVCDCHO4f71zs?=
 =?us-ascii?Q?1EgksF7SXzbVeXEAayrHwRpMvyB/cELP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IcN9s04jaxnuurXHTqt5u9KAUJ0Cdlnygag57mbyytKC28QzGSVhz5JWR7xD?=
 =?us-ascii?Q?w/ILLz9fbJsnM20HQprTta0XYeRuwkGNf+IHZ97GzkSME3yGNDysWLdWdvV6?=
 =?us-ascii?Q?3Cl/PF00fJoGlhzzAEughmN33R06PCMfNV1eqrNkLZ+pI6Y4vQjQthhRqor9?=
 =?us-ascii?Q?kOBE/JgvKoDc4t67gQIRWVkFy2XE/9NY3q4X1vkl/odaJ15pug49wapj7J8H?=
 =?us-ascii?Q?KwCZLwEq2+mwyn9kkJ5QUOd1qjirNrZYpnpQYTY0U1BYdu7ZdzZCd6LCFdJ+?=
 =?us-ascii?Q?Uxzu4QuccdAHSNFbYl5NJeSPUR3ilHLvWLmRGawopM7h+P2yrkpsNKoeH6y9?=
 =?us-ascii?Q?ODCciSksMeylQTIXY+/Uk7Ev77YSVHRjcLgC452fs+TCv0J4n2u1e+bHuo9U?=
 =?us-ascii?Q?M29goFLXRYT3V1jjnbMDDVpBQNVZplb2tZ8iuMVF6VncScPNinQ3GvaG/dT2?=
 =?us-ascii?Q?A6sM9xP5f+wCCGgbkdakpjf0ASjc3lOV3AKStikP0ZYSDOf5+FvRgaqxeK09?=
 =?us-ascii?Q?A0ukWXwW50JSLTBoGxMe0rAr3h9Lud+Fdcf69ttJMdIYVaDfZ01B4u9SvhX5?=
 =?us-ascii?Q?I8SzvwrjZhc6Renu9QaupaDoj0kEE38fOKJfpw2KvxiTfWg6IxyGYVkjVq9M?=
 =?us-ascii?Q?j0FgVMq448AEVuQhff3pK17GYYD0d6IEYQtrDsZac2VZqCMDVjz48cVIlaeM?=
 =?us-ascii?Q?maA0SAP47ec9rDGQANvZFUgFtCjJsO6QrkmG9Qswc3E/QqwFPvYAEeHL1lUj?=
 =?us-ascii?Q?J9+xutxprfP7r4RQnyhFIJJkuqlja2Ynp0k7OGg1dM2rHejrPNUmt9+34ylW?=
 =?us-ascii?Q?QabPwqeoflpXIsGKfHMcW4MoBLJMySmWHdXEs35ACSm2CxQ1J5b9l40IN2HL?=
 =?us-ascii?Q?VKRi1SqF3/dWep2aI0Cg6W6sW5A65bihJRZxP3OtAO81Pv+Es42fRoyPMsbz?=
 =?us-ascii?Q?RkhUfEFdAty3yJMTImuTP2f4IhWkqPsgtpGX5YnWec5AHMyeqXQiBWUUaHQh?=
 =?us-ascii?Q?Y1dYHponpH08hLPr0WISxtYlm86y11PusnDkPSoiLD/QwFXUmTPAX14UTIdy?=
 =?us-ascii?Q?4zczjjn5P5u11lBclnppDNAb3/nY/gb3aMpS+MBBzHw+kYfG0jq+e8WLIlSY?=
 =?us-ascii?Q?M0UoMz+EPs4tVOQ1nf5Hv9T7qDjA3MccYClaYEnKENdZRS+qYMKTPKgTIXbd?=
 =?us-ascii?Q?S8Q0ouy4wImxhWengw9GJgKM1+U/BAwS1vfiG/yQ0Chl1ZwTqOgApFpq7I5d?=
 =?us-ascii?Q?pUImKNKZguxvaNyNSg3Ux3OcqTcSCiNmkcHe4wnuWHbgBL6oZd5bzB6stJ91?=
 =?us-ascii?Q?YYYLkBDEj0K0/UwQbyABgQph0jqzPvY2RGfyoQQGXtUEH2Ocxo5mEDBJfwbG?=
 =?us-ascii?Q?DQxvOTvbcCQ2LpdiuiloEI4Q9J7jJCuJPCoIFk4/obxxX1AdLid+PswNfw8C?=
 =?us-ascii?Q?MSohcBnrDHt8VngqQ0Z6thUln+iInchHiGEvPsAMSdU1QvIQq5/uBSWZWbMZ?=
 =?us-ascii?Q?lD2t4r2O6ieyXAlNoS6imamgIaCE6h8y7yzOKTKuKTKjGuhE9753KFH3dDZH?=
 =?us-ascii?Q?VceuRuIy4wlUGGVWGSXrAboqgwsPC+a5Zan24T5fdr0BZmDicI0/Z7WO2JCa?=
 =?us-ascii?Q?kOfSx2gi9/wBqKw4fJu+ZiGEXdqd356Fj+P9HfqqAUAQ2C7LaHXX8dCRL3av?=
 =?us-ascii?Q?QrBT0tPKk1hhymysSXBTVeDzFhE675Utf0nrda8EOA1JYzJ/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3717a928-5d3b-440a-b8e9-08de47408810
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2025 01:12:42.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ckod9Co9AW5h6GTsTcLswlxyRkZpdjD57/UEjZgzs9SobwQQHaMbBo/dpBUCFle
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5831

On Mon, Dec 29, 2025 at 01:40:02PM -0800, Aaron Lewis wrote:
> I tried the memfd path on iommufd and it is indeed fast.  It was in
> the same ballpark as the optimization I posted for VFIO_TYPE1_IOMMU.

I would expect it to be better than just ball park, it does a lot less
work with 1G pages.

> I also tried it with a HugeTLB fd, e.g. /mnt/huge/tmp.bin, and it was
> fast too.  I haven't had a chance to try it with DevDax w/ 1G pages,
> though.  

I don't think any of the DAX cases are supported. I doubt anyone would
complain about adding support to memfd_pin_folios() for devdax..

> I noticed DevDax was quite a bit slower than HugeTLB when I
> tested it on VFIO_TYPE1_IOMMU.  

If you are testing latest upstream kernels it should be the same,
Alistair fixed it up to install folios in the PUD level:

aed877c2b425 ("device/dax: properly refcount device dax pages when mapping")

So the folios can be properly 1G sized and what comes out of
pin_user_pages() should not be any different from hugetlbfs.

If your devdax has 1G folios and PUD mappings is another question..

Older kerenls were all broken here and num_pages_contiguous() wouldn't
work right.

> > This isn't right, num_pages_contiguous() is the best we can do for
> > lists returns by pin_user_pages(). In a VMA context you cannot blindly
> > assume the whole folio was mapped contiguously. Indeed I seem to
> > recall this was already proposed and rejected and that is how we ended
> > up with num_pages_contiguous().
> 
> Can't we assume a single page will be mapped contiguously?  

No.

pin_user_pages() ignores VMA boundaries and the user can create a
combination of VMAs that slices a folio.

In general the output of pin_user_pages() cannot be assumed to work
like this.

> If we are operating on 1GB pages and the batch only covers ~30MB of
> that, if we are a head page can't we assume the VA and PA will be
> contiguous at least until the end of the current page?  

No, only memfd_pin_folios() can use that logic because it can assume
there is no discontiguity. This is why it returns folios, and why
num_pages_contiguous() exists.

> + untagged_vaddr = untagged_addr_remote(mm, vaddr);
> + vma = vma_lookup(mm, untagged_vaddr);

Searching the VMA like this is kind of ridiculous for a performance
path.

Even within a VMA I don't think we actually have a universal rule that
folios have to be installed contiguously in PTEs, I believe they are
permitted to be sliced, though a memfd wouldn't do that for its own
VMAs.

> Using memfd sounds reasonable assuming DevDax w/ 1GB pages performs
> well.

IMHO you are better to improve memfd_pin_folios() for your use case
than to mess with this stuff and type1. It is simpler without unknown
corner cases.

Jason

