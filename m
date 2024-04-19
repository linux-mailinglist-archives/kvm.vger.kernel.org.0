Return-Path: <kvm+bounces-15294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61BB38AAFE6
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1976D2843B4
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F1B12D77F;
	Fri, 19 Apr 2024 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K77f2eU0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9026212AAEB
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535174; cv=fail; b=Hz98DeB4/2dD1mwWosxHVIhSVEn6sDQv9d4K+mGHlz6lFg8Rjba3B3wYcR8qBtrwQrfZTJ8N33YF4lwpwOsOEdrKUe2V5/KZCrH4Nrkcrg8WzY5iSVUbPZn0ma1ozF9h6zwUPfYfxUqcJv4xXleVRu2RJ4Io1yPwbn5JyzdtpKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535174; c=relaxed/simple;
	bh=57g+9gTtXq5wuhiQStR6LNwRtaUVLt+CAKa8Y6117s8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gNuAlc9CAbsAF9UJrejxdw7gp/aRVZgimzGQtCB+9Y/tXy6AVFw+dnmYiX++Y4Jp7gXMBWlw/6Wc9hwJnAX88T8pqxlkr4wQyt3irTys/3NVlRDOSetMiL6xL1uNMRmuL4B4GxtKyJJ1HUT/17GUPZqUs54d7BG484FyIoyq5Ak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K77f2eU0; arc=fail smtp.client-ip=40.107.100.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUHdZiPKUC+gN6GJlf52SV59QYhDAlIHUTeb/zd0RQ8h44c0HJzNHjnaFskGUtPpAiiSQoWUDfzUlu77ke9uwuNW2Yk++S8fEs537J64+LzWrVgIqOsf9xxv6sMskObY/jCJ8XQMeSPtA9Lmn0D7WkSVjfgh43vdI85t1CVey/tdTi+hMVMRerjdmqiqUJv8Xi+SvTGm+/raiIvhRAuKW7GraX+uHWsnZz+FQMRsDxSHXoE2RAzXGHq1ElgBaapEkTy1+4Qm1eolc/RODkAIPph7zBnjSi41inXzLfNugZqaYywiTqcao89XZuQIaoUZjOtA0NuL2iBG3ovlAmmpSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fClBbdDkcDYZ9A7EZFoFNvZ4yWok7aCsLztw/7V9/I=;
 b=ZDiAXAv5bVC56QeOZkeGbDmm45rnDSPyKpg781FhuIf3LBLtxi83qqISmqKB53qVZJ4H85xR3O0DGJsszftbKIypZrpZ0uWuT4blAJD+pjRlJ2lWUjwrEEgXTszUrTfEcGOV0ek7TzsnBBpcVxStoICufgYVnVVqrr1gCF1xt0om0iDruGjVUN4LDIQ1t4OZ/bQ2y1omOA4QXiFFF8FEKBxgOGwRcgUWTMqTVH4OKyJs3BsLICu7l5wYT3Nf1OLkw7CaACypnzOM0VY4KVWAxGoXL9GygADxSKDUfWAgeT8V87ylKKAZNqFiJCj070eoRgfJb4clA6GDtRjdxin5Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fClBbdDkcDYZ9A7EZFoFNvZ4yWok7aCsLztw/7V9/I=;
 b=K77f2eU0OOJoI9F7KY+Y4NOT9HCyVvYEKb7sFF+gGHq/IfnSEmvbMts293E2DN0BZCcXDDhupwvOkRmTCIeQDv48z40zSLKjuoOMRaL2izV+HzzVC5EKdin3fx+iLrR1TVqqV5ZWn7GR6jXHnQODwJTMy5Og40KebVH20PPqy40GUkP0ugIuGVdGLMSvIUOn+k1d2MMMDf70gYn8tqEOnMRUo3nt3li+yLiiPLR0seOhbvPGZsvKzJgZnUnUwoA4g12GDJhfj2V8KUv/lqzoNxmQkpsnPXOvnsybNrJuImq07FH2PYKMfQO7hTsE+Fdv/eQU75ZGpTg6dCExZPoLJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB6351.namprd12.prod.outlook.com (2603:10b6:8:a2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.39; Fri, 19 Apr 2024 13:59:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Fri, 19 Apr 2024
 13:59:27 +0000
Date: Fri, 19 Apr 2024 10:59:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240419135925.GE3050601@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240416175018.GJ3637727@nvidia.com>
 <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418143747.28b36750.alex.williamson@redhat.com>
X-ClientProxiedBy: DS7PR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: 07e1445b-7ded-428b-e510-08dc6078ed0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KHPdmJvfQgw5489YYg3Km8wk4ccJaJZ/TqFRWY0cdghOXqSm+rGJL0P0/Xx9?=
 =?us-ascii?Q?r+8n96hv0GC6gdSz1s4ZjsclJMBg7IySt3aaQRznQ7U3fQJCxSXPM4l1+sgE?=
 =?us-ascii?Q?xjpPRyFtN4mflGKBuOx8R3AQSVxhbrMsgtRyTqxlZX+0mEoGzHQAR1daGcGb?=
 =?us-ascii?Q?3XEcHHIz+UxwCrlw7HRth4pj7zPq7pWMm7vOmq46BxSDE4/esgWpC9cCKkM3?=
 =?us-ascii?Q?ruwfQBt98LSJo+Zb3buz6T5IJh/25NeA3pb5gwD0uPrnruWaTcMG+qczTNFI?=
 =?us-ascii?Q?Fd84+uS1Uaw/QtZTJzZiuMewwNAj9lhuEmpRCs5SUGj9Isuqu9jWFvDSDwzR?=
 =?us-ascii?Q?PpjU2uFbsV+Eak03apKJt1old5o+vxsl4N/vpjeIETONIOQSgchAfPUkWl9O?=
 =?us-ascii?Q?ZhUxqSqmVfYNZDFNe66ALCufZ3CNnXGJjoHvucZOVEQaUg6LY/Vy6t40BL13?=
 =?us-ascii?Q?utgj9wUqUl5J2N3135nQ8GGXUvRh/WnHoaDGzop1aS3RrteuBs+qDp0Z5COw?=
 =?us-ascii?Q?G9ChuJ4cBqrupgxeIj3LdM5ngLsxul+9dgcJ8NgvPU4Jo9kUJhYi51eCRiXF?=
 =?us-ascii?Q?mAJpsc98/3PevW0E/EdoSZ+rSmelsb9oMT7UUhfIkSyq1Pi4d7bLNh9BzFkt?=
 =?us-ascii?Q?NG1nkgN+4NF9RYUXMka7YHwl32hRYxrjt/Xu5FV3TNFg7MMCxAsuqkOI5fnl?=
 =?us-ascii?Q?2xuVRUcvNb9iog7rvKkO/iYiSiITfyke2XQXdNWgfh35wsROKR+arFfepHCj?=
 =?us-ascii?Q?y/AA2v0IDe8I93vcSz5s26VEx0LKdtCCxMuG88Zn/QDR7iL+Zb2vp7ui7oAt?=
 =?us-ascii?Q?hSA5UayPdV0wbi9qng/5i6zAB+DU6/H2r1miT8wvMxImOrVxJPEol0vcyhTZ?=
 =?us-ascii?Q?tkqfb7TXs8o0b+TJdfF+br1MinGnnNoBqsAlIH3VGmeZ//T+VdtazjA/F1L4?=
 =?us-ascii?Q?JGwodW8zgc2uWAFKgz+PaWj8UQqc9V5pKEV621PalC6GwqyIGWA24yRXzQiM?=
 =?us-ascii?Q?tLuOHN3X0c/4Ox4RXbgvbC5vW2XtO9q1RZZ5gFKbz6W+SY2vdmQQOaBugRqC?=
 =?us-ascii?Q?vSP0o2HPIWk1sYptMx9iAZMgWOHotMUqvaW2h4Ub59y+FKM6wIJ4kW9fCoIS?=
 =?us-ascii?Q?NnzKy4pG4wgnY5el1Zelx+dzbrkkJ71FEAOtot/gy3pD7T/5ZpPd0a8wOVuw?=
 =?us-ascii?Q?Z5l5rbI7WpXQp3Uv0gsR/PFJKz0qd5LOzgCEg3+5GZU7l7corSuLh1ywf+Dg?=
 =?us-ascii?Q?QfT7aEPR2lM4m74B94Me8dJvYWq+MzrAmsc8yXykuA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3ppnXljhPd3IVqheR3TamnWd38L7vzRY41mBPrySWWT4uMjiwu3b7tKU6glW?=
 =?us-ascii?Q?TwwPXX9OckOQ7BrStr13tyUexM3fDJxtpR48WR1wBbqaJCHqfubThzGUOXpn?=
 =?us-ascii?Q?WZKKP50CIyxKcRk3u6yTiUub37jgBtkmtitKTBS7BZgr2CJv2uPPcb0Ez/iw?=
 =?us-ascii?Q?onpRZuUvtH0B24E1Lpk3lwvpe5nWTES+imK8kyUGPkpkTPceSa+a/at/5ikq?=
 =?us-ascii?Q?USWtyxZMbY+7UPV9VCoTGRk7/nb8Z/TXhD3JPEF8/7AHp0Y7Gjs7nfVmOgCu?=
 =?us-ascii?Q?3BsijdcjiR1x8g9F7KqGFVE8T9pzZlVqISR8hMOKPpXWkZaZQznUy1uIfleH?=
 =?us-ascii?Q?ZEKkiIBIgVa/+ZlwEslPILeSSbdFrf+V1BzOnJCXFxF8VxoCpnjyrc8nvmjQ?=
 =?us-ascii?Q?FjAyeViqaTH9JMW6VOYNstd0S8MQCyac8e71GmPNDSPeNrMIuUuO6WaNmON6?=
 =?us-ascii?Q?gTKatIVN6pzpaMaWRSWgcWo54wE9N5dr6sY9lmdbEy+t3rbsQMG+25sfoFZn?=
 =?us-ascii?Q?8Gt28HVdneKjvRph1DYum/ukFg7YEGy33whzC/EFdWBuvaVSL4VQ6i3J/iHl?=
 =?us-ascii?Q?scejFDNOuzKo0CvQstwdG3ILnWAWEmBUFpLTSOQdmdGysV1AqrhHxfxFTkEa?=
 =?us-ascii?Q?auST5t0RCEmL4L+ifQ/HkLLjGU6GmeTLRm4MSGMHt/gSq3IBFuJAYIfdb+em?=
 =?us-ascii?Q?pqhzzSGkqzutI7FQYE88p7uobTPEjvhVs9uvN45ZWmPxDm4PnN7ki7KIKpCz?=
 =?us-ascii?Q?V5nU5H64EqlsEkh/obxhyHotWM7tuYCy37WY82ZtMBzUHzLA2LKWfDtPXmCK?=
 =?us-ascii?Q?Xhoy7mDhdC1bsq6nXRgg69jR+oSH3Gbq7uxgYQJ/Q/p5Qux0YH5bIhaHnFcK?=
 =?us-ascii?Q?Yb5gMROQ7q1r8diccEN5HJQxrqHVOTW0CJF3nfIzOhba6JbTApyPGggl/6Lk?=
 =?us-ascii?Q?pYj1VrSdwHV2RUKON/kHez9uZhBDsjAAmmRjTGS3w/Vae+drIRKkiUn2lCVZ?=
 =?us-ascii?Q?ILJ9+r9cp5GBTALfmAXAjujVBsF5QINeYQhA5S/rbhbzrSbjsGeiZxY9yR/o?=
 =?us-ascii?Q?i4xBTk1bcJhbH6cs8sqceeFdkl1+YvhxBWnNGWUmyWWtICS4PsNCGzFrhurc?=
 =?us-ascii?Q?oBBt4Awak1e+v2xZsw+8sBDHtblNfMEdmZYcCLMKxklatnqFwk4QDwn28nCT?=
 =?us-ascii?Q?bnk+OSowxVwLht2GJOdVAzAkpgstL0sogb/9GGvscPRwawqPdEkG79yFW7fh?=
 =?us-ascii?Q?cEZAfqiynSgE6VIvL+QNAafiDLRBaLFQb2zG/nVJINafOGERKJ4+kO0zKkGL?=
 =?us-ascii?Q?dh/P7YPhKEnRj+SN7mh5E82F8AzOv++qK4BZUW7Iks35ukN+1fkfuBzxRuiz?=
 =?us-ascii?Q?2dmPeMiOfMFGQwaF9sIKkjB8djLFV4w5evCiT8yXrnCn3Xwj5mNhLh6l2pz6?=
 =?us-ascii?Q?+Nk+ziGNyrMm5IJpLXhF1P487utC3rLCMZ87vgeRpt99MnzfFopvOuuZPTS0?=
 =?us-ascii?Q?O0OOlMoYm8/3b2ajYGGaWneTwPjAfMnzpnpUO43poH/RdAmvwra947ZDarSM?=
 =?us-ascii?Q?C5YsnxFNEafmISpJoiJ21joPNy0GcMhCF4YbfvA9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e1445b-7ded-428b-e510-08dc6078ed0a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 13:59:27.0273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8NipmfSxmhqTMabEZHiexufOREm/k4Wi2jiAK98SCGgYTaTdcXv01t1mF28QXLza
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6351

On Thu, Apr 18, 2024 at 02:37:47PM -0600, Alex Williamson wrote:

> Some degree of inconsistency is likely tolerated, the guest is unlikely
> to check that a RW bit was set or cleared.  How would we virtualize the
> control registers for a VF and are they similarly virtualized for a PF
> or would we allow the guest to manipulate the physical PASID control
> registers?

No, the OS owns the physical PASID control. If the platform IOMMU
knows how to parse PASID then PASID support is turned on and left on
at boot time.

There should be no guest visible difference to not supporting global
PASID disable, and we can't even implement it for VFs anyhow.

Same sort of argument for ATS/etc

> > If kernel exposes pasid cap for PF same as other caps, and in the meantime
> > the variant driver chooses to emulate a DVSEC cap, then userspace follows
> > the below steps to expose pasid cap to VM.
> 
> If we have a variant driver, why wouldn't it expose an emulated PASID
> capability rather than a DVSEC if we're choosing to expose PASID for
> PFs?

Indeed, also an option. Supplying the DVSEC is probably simpler and
addresses other synthesized capability blocks in future. VMM is a
better place to build various synthetic blocks in general, IMHO.

New VMM's could parse the PF PASID cap and add it to its list of "free
space"

We may also be overdoing it here..

Maybe if the VMM wants to enable PASID we should flip the logic and
the VMM should assume that unused config space is safe to use. Only
devices that violate that rule need to join an ID list and provide a
DVSEC/free space list/etc.

I'm guessing that list will be pretty small and hopefully will not
grow. It is easy and better for future devices to wrap their hidden
registers in a private DVSEC.

Then I'd suggest just writing the special list in a text file and
leaving it in the VMM side.. Users can adjust the text file right away
if they have old and troublesome devices and all VMMs can share it.

> > 1) Check if a pasid cap is already present in the virtual config space
> >     read from kernel. If no, but user wants pasid, then goto step 2).
> > 2) Userspace invokes VFIO_DEVICE_FETURE to check if the device support
> >     pasid cap. If yes, goto step 3).
> 
> Why do we need the vfio feature interface if a physical or virtual PASID
> capability on the device exposes the same info?

Still need to check if the platform, os, iommu, etc are all OK with
enabling PASID support before the viommu advertises it.

Jason

