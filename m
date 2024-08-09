Return-Path: <kvm+bounces-23689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A15F094D13E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C4F21F23DAA
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 13:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FCD195FCE;
	Fri,  9 Aug 2024 13:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BgBzFAao"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8A719538A;
	Fri,  9 Aug 2024 13:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723210134; cv=fail; b=PeB4dRfpbQHeJzFSHwgHj84E/dV7vf5WlYHntjr2jfdgTeVtHAdTKYUFJ9/Dmg0Ub8NcqYFF50fUx7sCCmG/dcPmkVgpCCgUWZtk5XM1zUbfwem3DS5hsP7IYapt53ic7uSX/6ZuD1ym9fpyPzDnjN8T9DD4mOLaWupVdz2yJ04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723210134; c=relaxed/simple;
	bh=EctziKcAyquakDoP0wscF8rBYkwob39nPk2uVOk5r7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q0N6yaHj2yeb+O2Yp24a0MgEib2BWib4kk9FKpzZJGPU+wI72DMZs+VvIdOYnTnfWSg0hJXM3hNOunr12mm+Lbs25b8um+yfBN3D5pLsamZRI7Ojo3WsOYGVGQP2TCUOzS9+G+jKLUsubYFCoxAejuETJNw5AcucxVvmDmHdvHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BgBzFAao; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nnIo3uKT3PW80LH49frlPYXVb5oVq8sxMI7qJBy5Q34mUlejVnxpTCJw0TgNa+SHV2W0kkeiSJ4ViFiqtB1ydpxkZJJlH4NYoU6hzi1Qbkyz8Yy+5nTQ2ZRVL0GcJ+QZ3+O6/PERFgjh4TCEzIuhE5WHJxYuJIvE2vk3VWOZHdbQcF/9wfR18cx24CggqFGj4Uk51sPvWd0P2hGU5Afhuqtngp5359dih4CUG1Io+3MkB6T+KBZJon94U/+X3GPFnoIFK3MhhmUXoJ4IvKdibL6k5AJtSGvHw0b7SyEmqj6ZcYzVnx8zd2jHB2N4aCqOJ2gWB4iEKhEt4+Xb47lJ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9KJgKlV00IdZqKfMfIDPB7HhFe6NVuBPS3hMuJb6vw=;
 b=nf3tZh8KBKZ+9wpXGbOayUkNo1o+OZKWYBui1cR+n2yArvAeUKR6y4RjcVpIE5NAw58ySKOmz6u/+yFA/yVPM1MPQ+08Kk3k+UpVGRT95vhY4BvTGzaPVid/rI/bsV7Aq0s4XuEPziTk5R5A3irdMIttN0WsSIBzXvhM0bwg8QCnqtYoHwbdBuS2ojCVn+QnNvK+9DGZC/uuh//fi43AiZ32o42Ni9j+XR0JOAQH+3syyBGabuYCRXxTOPHA+Hqi9uw6lNdipQ7/r4qvPwDtDtpZfkt6+pKM2x0g96oPO4lYW8KSo6+vkHOJgf/zJS/kWlyl4jtQgb3YfK+QKceOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9KJgKlV00IdZqKfMfIDPB7HhFe6NVuBPS3hMuJb6vw=;
 b=BgBzFAaonFBWhvhhivspbclYRv+AUh+AspM7nhE4G4dZFS0zoVVk0RCc7MrapC0X3YGYr1ndMnPyrfRaV1G/hyjhNtysI+voG5qi0nT6Ee0TY0XSjS2anmW95LVNfXn2KZ/xlshvWxgGi/ZyMgxG6kW9uLny5LlCsp3RR67pifbQ2TiwcqmPmiYgKqn7ed2r0d6nSPQZl0+zCP3A4yA4H5W4HD+S4m5f1PqHblJN3SeyAdaxwPotGifkAhp1DILUTnLQHXZHrmiqeDTXXyyiKxbpciQp0DBz1PKbg+YqM/sMtXwQJkI0+h556j0KGtKazGs/s1XWLOLAJbb2br8fhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA3PR12MB8809.namprd12.prod.outlook.com (2603:10b6:806:31f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Fri, 9 Aug
 2024 13:28:47 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 13:28:47 +0000
Date: Fri, 9 Aug 2024 10:28:45 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
Message-ID: <20240809132845.GG8378@nvidia.com>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
 <BN9PR11MB52762296EEA7F307A48591518CBA2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52762296EEA7F307A48591518CBA2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::9) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA3PR12MB8809:EE_
X-MS-Office365-Filtering-Correlation-Id: f4cbad76-5d82-43bc-826b-08dcb877330d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rcrQmojDXy27qZWjw3l0/Ge2jllwMjrVIouU8B3eDRCW2Iq7UyIf1vS2+QfU?=
 =?us-ascii?Q?W6d1Y7eHGPhQfwYCLu6voU6a7rPNbCO7ILtfVNugDqc0+BHzKCnwhdswdDCk?=
 =?us-ascii?Q?nAh5nLq2UjEe6gTdTChPsHddAUOnMYg+J+N8w0J/8RB6MVBcZP8L78rBJ2np?=
 =?us-ascii?Q?Rs1EVDefunWon9kVBD7lHWekt5YKE5PRvB4eq/uHssJEKrp0APzgbd9M8NJO?=
 =?us-ascii?Q?KnmkmkWgmKmHzkpAQfD5Brr6UR5eJvmmf3wIco43ZnLUycosz7FslwWrGvlD?=
 =?us-ascii?Q?QIrfApIJ2ysM0L9u8cxEnDtQb48TbGczYU2994gSo0Z1cy9IaRWPjhsITEBw?=
 =?us-ascii?Q?mvE+fJbEeOM/YHwJZTm5QR+J5Tp2dTF9KM+xQU2MwUQAZS19DmJ9iRFyi5B9?=
 =?us-ascii?Q?JzLVUHX9OIJ1DLwsUhgxiHCca1U1n3M5jRmXJiwN8PUm1SnrsHhrg3YHxL9X?=
 =?us-ascii?Q?zsTQ5OzPPExWQ8tyu7V3En5L/oXxq+dB9HCkIKCXSKkC+Vj3oYs2DBExM3CZ?=
 =?us-ascii?Q?uk+yBIkAgar+kjBghZNGvXsesZ3JgT/ojxb4ndVZV3ZgcpXjEaZJ13DgWw4K?=
 =?us-ascii?Q?WaZAmhMOP1j7BDHe5kT9mSyHLjjtJ7z5+lEhhn8GvZ8J9baNS5jy58IilLID?=
 =?us-ascii?Q?Iclg2ywJ6TYS+imkGeOmCP1TmRTUoSNgN+OVw6EZmIvjJApZAKR5qskvyZQe?=
 =?us-ascii?Q?UpPbgwIO9yuJeR5UwTSkjCA+5siRaTuyQyeSRg6toFTakpbZoiYZ1eSmfiEo?=
 =?us-ascii?Q?0lcfXU/gizfloEiqXHmcIP2LA73NFBAfRK0/mC4ncaH34xTlTYpPQtpyCSB8?=
 =?us-ascii?Q?/y1nrnuAj9FaBXI+IMCpwoh3mjDFa85/nmuzAw1vO53DeeZSexwjI6UVitA9?=
 =?us-ascii?Q?vbBg+nSytzAkSWx42m5Af/QvI3H5IgERXvOScARKdvedR279t3bQKZKY0GfH?=
 =?us-ascii?Q?LSXtTD/gdA1STT4fxLAiMWPHe5v7bSrwDP4YdnLiktYh/nVXYERlQw18K0sj?=
 =?us-ascii?Q?1LSFaus+feXqjH5EctBue+zK7va8t2NEBbXxaPHof8KVoXS7zwd6ACHGgC6Q?=
 =?us-ascii?Q?TZvqYtO6/kng8ZpS7JVuyTCfiVxa2kteG//lARbMsQYOdWgap+r725tcPhWB?=
 =?us-ascii?Q?24ysmeIaiUpdaJ809dN+szbAsQctH1KPjlrExwXhOWEmXworHXLjkDziL1tH?=
 =?us-ascii?Q?Phr7ePm999ftli037b5JyNNfmzFwn9eH5yQ30mCAxFlgsu9yghbAlotgfmw8?=
 =?us-ascii?Q?cF6fwHfR9Ya+u1CmOws+6uQ1KlIyzN6CJ9EWv7696YKLb3fbqPvMrE6JjlyH?=
 =?us-ascii?Q?k+9nxSEhtrQHuscnFgg4ju89vPKkidm7EBJ15i1dnuelhg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KIPR8cSbfXtio+OCOoX212a68JNy+xEoTKa0fi8tkUeQI7SCo3NSeTgX2wS+?=
 =?us-ascii?Q?WvgqDvQUwXtog/gL0KWNFcuqPhzNSsdBI3DAcJ1OOVGUreIXJ3patdO2yYEk?=
 =?us-ascii?Q?QYvf+tervWuWLpjLCw+ZsTqjF3H/UUo4WTEJuXV/TRPViU48W/yuuqR3l2OB?=
 =?us-ascii?Q?lTcJTftUqidF+cASAeEnjBnoKYyoX0+eRhCrTIndTFgsB1G3rvkpmsH0nfU4?=
 =?us-ascii?Q?mCZ0CvpS47V7HmcDF8xvWhnSNeF6W3q6woz58T5YntHbzZO+pjvb6C56FOjl?=
 =?us-ascii?Q?0MNhjmeFFu/PnbQ3x+Jr9djadWYzCDKZvE1I6Z0ivxIuyHwrHSIqoPAzpRiu?=
 =?us-ascii?Q?pTVtg1rmA1jOclbB18dWwqXfgASynLqEfxbuR+2zLzC0wvesQcS569WAVmDD?=
 =?us-ascii?Q?nC4ngQb1b51WCQsamHxzmI9XIVG76xMCHjDVp2BaOL2gOJ6Qdi8CdErIAedP?=
 =?us-ascii?Q?bz3aGi7HSiAEuF/HrRJV8UwHwPTTI8lireJAvQ5g9sqnWfQTCTBJvgzSPWLp?=
 =?us-ascii?Q?AKxLQsTkvfVGUhura6UlZM7Oga4frIjLAKLlYPkrg2K1c+zjD7kbVSj7gIMz?=
 =?us-ascii?Q?RR0MiPHgPhSzEZEZ0TEndsOtzdZc0svRKn1gYo5pzOF11mqrgpa51O4qXmRG?=
 =?us-ascii?Q?IpxkAC2r9Qdt636qsTfI0IC1LdK2CJCPsN/8+40e+Lpmj/Z3zmCIvPbQWQxr?=
 =?us-ascii?Q?cUZYSJSLO7rwfb99S8/rgSeznzcwfEfrB4Bqx85scvu+07lp5N23kuMc45GF?=
 =?us-ascii?Q?iguxEigDgg7gqfN8XJzCPDgGXmyucC2I0jsbgUxEpSgva6PzBZhY60pq5CBe?=
 =?us-ascii?Q?WBE8AUpiA/GJ7d9NhclrUedEcKryK5YSGsbXYjaLluUco968NXDDuJuJfVtf?=
 =?us-ascii?Q?9+ZkSiKKf0IcQB86L8phjSPETXUMS/woDGBxNdTk8A92yJALjo2mtSjRd9ES?=
 =?us-ascii?Q?gbE0P8YFC3Fdz7soZNv3c4AR4bgxb28XMl+85M0as2a01kEvqPWsTsCNbX9j?=
 =?us-ascii?Q?6xqm4WSexcG6y1UZJolPcNXUgoujXf44nRiRHW/s+mRUjOoO7sxTIzV3s1H8?=
 =?us-ascii?Q?LPs6aqPp5vfVKBts0v13vo9+V4tBTgZ5poanWoE43ooX5ewo8jzEGW8WSa7j?=
 =?us-ascii?Q?y9URLfRU3w2thSTbiiBedvnJ7CJdmLFbEXMXTtEJuVwkeRhNEfnj1uPMmQGS?=
 =?us-ascii?Q?euhqiqpjMRWyXOmwnaK9tisu7JddAye7KPgJeBh1De8mm1LxaPALxVGApSFe?=
 =?us-ascii?Q?Ni4hIrxmxvzAoaMhSCzpZouaNppWHUuXifJQKlEIQpy6oMgnywYGXYNQbQNo?=
 =?us-ascii?Q?b+OIj6NmF1waddvnFW1klr2iHo+Ne7sOqJJz15M+DQ2bZgEMfBEFXvFA6MXG?=
 =?us-ascii?Q?vazkKEdtN/V0BE4wyl9giCvT5SVK5tufl5yZhUslJeRpjpdjGTS2cPMB3/LH?=
 =?us-ascii?Q?Q2EU1fFNxZvqMuq4BZhXr4EQ4d+LRKgSb/ajk/TL9PHSFaVxH8Jji49tFSBc?=
 =?us-ascii?Q?bb08cyk7qsjLuKUI7dAQKswI+jny284UjK3OfqYYk/9r19UnshvXqyIgZ40t?=
 =?us-ascii?Q?owkZnihxmPqeQPHbQ+o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4cbad76-5d82-43bc-826b-08dcb877330d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 13:28:47.8208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDhsPaQRevCLmk82tpwUQH+jgFYIai+ksWXwkrYwTnc3UMNrXZm1+cv2WkLZ+mkJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8809

On Fri, Aug 09, 2024 at 02:36:14AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, August 8, 2024 2:19 AM
> > 
> > PCI ATS has a global Smallest Translation Unit field that is located in
> > the PF but shared by all of the VFs.
> > 
> > The expectation is that the STU will be set to the root port's global STU
> > capability which is driven by the IO page table configuration of the iommu
> > HW. Today it becomes set when the iommu driver first enables ATS.
> > 
> > Thus, to enable ATS on the VF, the PF must have already had the correct
> > STU programmed, even if ATS is off on the PF.
> > 
> > Unfortunately the PF only programs the STU when the PF enables ATS. The
> > iommu drivers tend to leave ATS disabled when IDENTITY translation is
> > being used.
> 
> Is there more context on this?

How do you mean?

> Looking at intel-iommu driver ATS is disabled for IDENETITY when
> the iommu is in legacy mode:
> 
> dmar_domain_attach_device()
> {
> 	...
> 	if (sm_supported(info->iommu) || !domain_type_is_si(info->domain))
> 		iommu_enable_pci_caps(info);
> 	...
> }
> 
> But this follows what VT-d spec says (section 9.3):
> 
> TT: Translate Type
> 10b: Untranslated requests are processed as pass-through. The SSPTPTR
> field is ignored by hardware. Translated and Translation Requests are
> blocked.

Yes, HW like this is exactly the problem, it ends up not enabling ATS
on the PF and then we don't have the STU programmed so the VF is
effectively disabled too.

Ideally iommus would continue to work with translated requests when
ATS is enabled. Not supporting this configuration creates a nasty
problem for devices that are using PASID. 

The PASID may require ATS to be enabled (ie SVA), but the RID may be
IDENTITY for performance. The poor device has no idea it is not
allowed to use ATS on the RID side :(

> > +/**
> > + * pci_prepare_ats - Setup the PS for ATS
> > + * @dev: the PCI device
> > + * @ps: the IOMMU page shift
> > + *
> > + * This must be done by the IOMMU driver on the PF before any VFs are
> > created to
> > + * ensure that the VF can have ATS enabled.
> > + *
> > + * Returns 0 on success, or negative on failure.
> > + */
> > +int pci_prepare_ats(struct pci_dev *dev, int ps)
> > +{
> > +	u16 ctrl;
> > +
> > +	if (!pci_ats_supported(dev))
> > +		return -EINVAL;
> > +
> > +	if (WARN_ON(dev->ats_enabled))
> > +		return -EBUSY;
> > +
> > +	if (ps < PCI_ATS_MIN_STU)
> > +		return -EINVAL;
> > +
> > +	if (dev->is_virtfn)
> > +		return 0;
> 
> missed a check that 'ps' matches pf's ats_stu.

Deliberate, that check is done when enabling ats:

> > +
> > +	dev->ats_stu = ps;
> > +	ctrl = PCI_ATS_CTRL_STU(dev->ats_stu - PCI_ATS_MIN_STU);
> > +	pci_write_config_word(dev, dev->ats_cap + PCI_ATS_CTRL, ctrl);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_prepare_ats);
> > +
> 
> Then there is no need to keep the 'ps' parameter in pci_enable_ats().

Which is why I left it here.

Jason

