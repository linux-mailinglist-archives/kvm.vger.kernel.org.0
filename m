Return-Path: <kvm+bounces-25526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 390B9966374
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34CA41C23903
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C87F81B011C;
	Fri, 30 Aug 2024 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WOwLP7uZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8312A15852C;
	Fri, 30 Aug 2024 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725026092; cv=fail; b=jNguo3QZzxcU4NmL2FwDF2UZ6ieRPG+LZdbSpURLaNFM0g+3p97yjR4jzbx3wZjYA6LpUo/l0pr/VXKvSlh0I1DcafGogSVb3Y7519jWmrrA8J9ANA99tnYUKHynAec290bD0HLEFcV9OG1CwFOr26JlcOOSSCuMDRKXAirYRrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725026092; c=relaxed/simple;
	bh=W4umXlBPFqUG/hSSeMVgcOqKs1N9/O23kHULo5isem8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rqA3u9yBjnyYG/Ij8x+/lYdfXNW2q5M6yM8y2uPJEXNxnRbfPobuPNUze2f8S2cS3JgNQrzenSDAkcDbta2eq3eLG2mAALRu6fw5xas7E3AWRZGjXDKOaQuEQqGxnwqoPy96iVWq7aBtjVAfa7/wIpBGkTryTPePabvavj4hhUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WOwLP7uZ; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eol21QMnl6bDhf8XHurJ0XWdek99FYUQ39rbmGU8sP2xjBG7lpd9Y33okiekL7ZFWs3gPlQRcrfqzz+xPEFcfySWlH5C22OGEnofhOzybbMCyEpDRFc50pb0MUwHbwdSXclhZfpHj1Rm3k4NqnHSKm1pH6cyDkVrIgAKZwGlC3TbABVALthKHdUCrP2zOCXh3Nll/p4gwtQHNtXX1jcN2xJV/QM+51BDp+ZgApyufLFedNCYSVvkuCaes7CLiNpjdMe+I5vorv9tZR9empEclKlbBRdcTts0yjtBR4FV6lPekpvzWUpI0LBjLbuqXXIhhUCTw6tv7zYyZoCUqwKheA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4umXlBPFqUG/hSSeMVgcOqKs1N9/O23kHULo5isem8=;
 b=UUjlj9uYPyTJZYoEIcjG+ZmlIt3MgRKhIXwuMTWVgABKhnIje/oV2+ySG5M0X97dPM/QifYBXf/c9XcJ/1n0fknc8lGlaJ7/pyiimk8lEFxXq7at2WmkiWV4EiDWjhBHom4wBFrn3oYqikwpq5Egpyn6xzQDcXD/zfjlqIO4qga4WWgpRQPzcQacmWAbiEJZPicVulRxFsJnah7Z1HUyGdCdPdmaDKPSZwg9vVVE8qyA+7qv5DJCcVCWsAKrbRB7T1sPnEvRUz1Aso0y6roswC1a9iezzA3QWPEVH1Hz+SQqfDV2UiE2P4NU1SI8PhR5Xw9JmtrqJm3eRRuYKD9yVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4umXlBPFqUG/hSSeMVgcOqKs1N9/O23kHULo5isem8=;
 b=WOwLP7uZmm9j2fPBgs6vN3GHQAH3ZHx92TCEoLYcEwG/7GwnumynFGigUhBatrZOiXQqpT8p8loRVhCtlal+ZHYG7af1tEmUSflFYrPPICy/0GmA1rK4pQxUf+X3K9oXtLYn5sbAOFElzDaqJcd5K4l85gaMFyf+PlkTlB5rrev1Rdzsq5DvijJ7xIqc4YxiH+Oh3Kn6QM0bgkOziBa0KJMlWgNd0uatjlA5crcjz5EKASmAb/CoYzVB1vKprcYrA7DE+Q08FUyN6uj+cw0lTFxKS22zXcoJHny3QXjeH6dENBe0s2PbHVwHrKicLfv4xc4mWMsaT5Z9bdlX9/vSsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB6487.namprd12.prod.outlook.com (2603:10b6:8:c4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 13:54:48 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 13:54:48 +0000
Date: Fri, 30 Aug 2024 10:54:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Moore, Robert" <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 4/8] ACPI/IORT: Support CANWBS memory access flag
Message-ID: <20240830135446.GP3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <4-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <BN9PR11MB5276313B7EE893B59FBD46F58C972@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276313B7EE893B59FBD46F58C972@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN8PR15CA0039.namprd15.prod.outlook.com
 (2603:10b6:408:80::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB6487:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ec6623c-b6e6-4f18-8e46-08dcc8fb4fd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nx5RPoB0HvdG0xuYCM6tC0hixuiR1VkK+D8qyFkw1joohAdnmHVQ7TKi5vgq?=
 =?us-ascii?Q?qsLoEx7u2YLc8sdpl/xtIx+8orrkv4QBEVCL7zTI/X9GOBbdO9qzEFvJmeNY?=
 =?us-ascii?Q?Mw+bW4BkzueV5Wr00J9GVMC7naUH+JsIWb5xF8UmAgX0muh3xspR2EzqPKR8?=
 =?us-ascii?Q?6dEYR3LjvxqFIKNV5qQ+hOAJag0UdMVwZuBxc9h/hdcpkQ/40hDQZ0vwv6VD?=
 =?us-ascii?Q?b/FDJKCEJjyooM4mGKRoTYQNCF/6/t/YK83hZIiNFKv/W+tWBAUc86ds4vDx?=
 =?us-ascii?Q?QSma/Orhrl+2eZKeyP3vgfBRgoHytEZQ8uw6neo95Z4ezxMivDSkyFW+ooxt?=
 =?us-ascii?Q?JMLIA1MiheBuRb/BvCgxKRvNVUv9Eg1n4I+wV6psnCqshvGeqb9rD6U58gPg?=
 =?us-ascii?Q?amVi3H6cLJERHbbflIGuhYsPxEo6/LsmcL6vpkboVRKw5Cmmq6beDeCQ0gqO?=
 =?us-ascii?Q?VcavdcSAfw53pbnjzI+K6KfkP1sHBjjzejXBQAYA4MsaNUlMwwXlwd0zB0nF?=
 =?us-ascii?Q?+5kKoInHEIeGyRdTNBJ4VOWqztBUIK/iqOAZbrTVzLfTuPcopdY0xgZFYYzx?=
 =?us-ascii?Q?zqZ7azTTCSolj1dAn46d9XwobNiOA59Mxn1PV+ZBpXvgSU8Uy16za0AKKtvN?=
 =?us-ascii?Q?VC9yq5reIYeadQqvdXja+PPgh+0h8KsknBaJiKuHN3jTZ8jYQ9DrNIzbfZbA?=
 =?us-ascii?Q?/K5zl0Hk0QPGV62r+deA+W87O7xZQSnVE0ckKIBlH/I5gl2X6pd1oO7N6+XT?=
 =?us-ascii?Q?+0cLTIj2KatoWlsMnyQIyeqwytUCJ7tlbdp32dEHyr6girt3ErIQ+SOqMkUi?=
 =?us-ascii?Q?obWg6+xzo1AKkp6MD/I02KHh4SsC3h725L9bCFC0mVS+few/X1bD7ThmTp0A?=
 =?us-ascii?Q?/ob6fAtZYvu1vsy0NXZ8OIP3/+OxRYeS6RlMB3XWyl6w1GRgNibzsTRr2WQC?=
 =?us-ascii?Q?GZ7zlHVnFoOb0MMuQWWuhfVGEnGHYi/uY5PwslL3zR5ht1dzw+A7dBBW7XpW?=
 =?us-ascii?Q?AoblXmfVL+JQYMDcirbCpUBkee9o8Y7bo03sKei8jNdDHcBkC7co4E5GpU8p?=
 =?us-ascii?Q?USYkfsw8OZePuSa7gclqDc0gOrEYhR90kjKSZlQzLfHzAmYWhSjkFkuALCgp?=
 =?us-ascii?Q?Tv9IvPvN5XwFt3uxAcu3KN7PFOEvBa82I6kx2LYyb9Yc9Zu1T20byGD0haHb?=
 =?us-ascii?Q?QRB2khG6ev3TGvbmxKsN/1fse4snjoxo/5SMfh3gRLQg20gGWZuGT0gtY9nS?=
 =?us-ascii?Q?ZroBjTRGYuHI5mEzCQ5kVmt94ra95cEFI51B1Q8L+ipOtobXOnBiQ0d7GEgY?=
 =?us-ascii?Q?HiOruZy8cjo4kbJLUbapZaT5SMWep5Ijja06XlmVvia3rg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K3g2YSm/5J6WEY7+LAmwa7p+P4OQEQ7fcTypLhdF5J6qqtZ40ZeUoQ6aOSIJ?=
 =?us-ascii?Q?+tVOLz1gdF4w+T8fR/mn2eniggxPmtUXLVxrlHS/kTHum8t6Dh+1bzSb3jWT?=
 =?us-ascii?Q?7HIHV/bQ85/JEmgad9o9oReK7rFJ3y8V2sHSgcNaV1CfZ4zrz6vg4jpvQznc?=
 =?us-ascii?Q?Ow+tUbki/XOmm4NTW/OgoMpqzOUjbrUSn7UudEzPkysPTtw9c/NYJDVseHcJ?=
 =?us-ascii?Q?+TJvWGJveGCYb63dDT6JhZbIpSH+fDoglDGmElFVucPKibOmXnWaLGS4skbd?=
 =?us-ascii?Q?uFrYxzUvBbDgNHK35TACSzcUCHxN36UYABHOg/1gbJjMyPj6olJgJcdWOkTI?=
 =?us-ascii?Q?yyhGaRWh2H9xM/q+ZgcjS7fSxjHXaIB2iIl+bH4yrIJn3kPquZpEAZNKNAMB?=
 =?us-ascii?Q?79yYwCxF4D6Yw+WKsGwQ38Wb3G8WhChacZi5l7z9ABMGIwIKEEPglu9bcV2z?=
 =?us-ascii?Q?g0Vva2KBWfjhPiqJMYR8novkV7XxISkG5dBgGBe7KdFKzgqM4hrtcIK685Nk?=
 =?us-ascii?Q?vHY9/DDpsCIgywiR+/2ToxxBsMJc6Z5S/kNDj/UJEFEvTyVKIYcw2VAlgRdP?=
 =?us-ascii?Q?WozKazTGiWMJgccFCxHY3OmIXXC1xrzpiVcJm1kG7GP2TsDUh4KRnrVDW0eD?=
 =?us-ascii?Q?F4Qvn0uCFm5OMXPS62dfKnq6HtKLJraEYtv9Gr7SLRjq579b1EWt9CGpTc38?=
 =?us-ascii?Q?Gj0ztXinpnobkTjJuQ3VqMIc7ZFKgBtyBY5yXWSfmO0yc1bz02tUdT+Ml3bb?=
 =?us-ascii?Q?zq7WWpjz1siRnX+DwuyO89o/TqFTBjqbuL1bNTzDoHIf0aUmx7Nn/knmgAIR?=
 =?us-ascii?Q?NBAUUULmgDObWvUw4+0TKpdcM4MnJQymJ59E1H5K8EcPoiKetsavQaCDZYwZ?=
 =?us-ascii?Q?xZA1PBxuJL35q7kpSqi99FocTELcvxACQRT/fL9nd91r35F9AdnP6Hl6eLP7?=
 =?us-ascii?Q?hh6mFSoGOYsCiza0mdqYrfraZotWx5wZgV+4cH7j7HGNy53NGJ1GiIr2Q4LE?=
 =?us-ascii?Q?HpaHucPkppkY6/6jjV0jvlP5pWE8azlrMTINFIf4w9/8n0jWRdqE3W7Ggg90?=
 =?us-ascii?Q?oQy2Vi+3y+AHkKB7RnhOWtf8jNVLxGCdoIciHwQ4nDp4f/kdlA5wqqL6b3d+?=
 =?us-ascii?Q?YiJrQH/kVzmPf+pD+/2Mq/FPQcswrA9quQVn135xt8cHOrJU/NASoKasdUoU?=
 =?us-ascii?Q?mOvr7W2lbumf2FDLSOFUIQ+oQ0+P1U5rY0kfLPqh/QPVWgi/Nd0Er5qvshJw?=
 =?us-ascii?Q?1/dgHoBqWU2ioZbV3fkrsFII2zlzTR+GfywY7PfLQIN7/sFwgcLpVVbLE0L8?=
 =?us-ascii?Q?pF3vZgJK+zFKwnkgsMATKZ+pQT7YPizA7NfBbQ9ujxVopNeUuQJBRqHhmBWZ?=
 =?us-ascii?Q?qZrJKcEh7afMNx7788QmcTIr9w2k8Y0b67fFNSrDyo23AIjQ5RAB7+nTgyb1?=
 =?us-ascii?Q?SKedG108RDqE66u6+gb5E7CPqeuWZq80Z9cDx8oukwimm+3rpET2XsAfEFHz?=
 =?us-ascii?Q?tjtlHExETFJ55u2Cungj5wVoVlw01AYtxPvsQNueg600eTQItI87IRmwPiGU?=
 =?us-ascii?Q?IH6txWOAHcljQiA0iJGYYwLHXugnE5d7H4Z/Ht0C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec6623c-b6e6-4f18-8e46-08dcc8fb4fd4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 13:54:48.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kH4F7qmUS4uU1K/XyWoQSOg5lksh1/yWGLunu+ExgB6CZ7mn9IX6PKB37qJeDqHY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6487

On Fri, Aug 30, 2024 at 07:52:41AM +0000, Tian, Kevin wrote:

> But according to above description S2FWB cannot 100% guarantee it
> due to PCI No Snoop. Does it suggest that we should only allow nesting
> only for CANWBS, or disable/hide PCI No Snoop cap from the guest
> in case of S2FWB?

ARM has always had an issue with no-snoop and VFIO. The ARM
expectation is that VFIO/VMM would block no-snoop in the PCI config
space.

From a VM perspective, any VMM on ARM has to take care to do this
today already.

For instance a VMM could choose to only assign devices which never use
no-snoop, which describes almost all of what people actually do :)

The purpose of S2FWB is to keep that approach working. If the VMM has
blocked no-snoop then S2FWB ensures that the VM can't use IOPTE bits
to break cachability and it remains safe.

From a VFIO perspective ARM has always had a security hole similer to
what Yan is trying to fix on Intel, that is a separate pre-existing
topic. Ideally the VFIO kernel would block PCI config space no-snoop
for alot of cases.

Jason

