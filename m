Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDA9489EDA
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238804AbiAJSLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 13:11:44 -0500
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:1152
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238786AbiAJSLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 13:11:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivkLam3/ujFZalFhdU0PgML2lILVgUamkFlNjO4+DYXCy3Vv9KWgaHMRqbonKfKCfbSJw7LtlJDeijNyUCyT87EMooyQo8SE57KkNE3rKww4nMaX5DFb+1T/86oOYa8fhvwaJ0owQSJNXzqpvAYlYvLdFP4eOAJ0CstdbRXVJTlQOtIEK3YFZ20tvS2XnObtvCc92XlhYb/5v5WiVW0MBHFMa+TeMpqf9r+YCgh9XzD7FyCPdllaLyWQhCrmWZrILlrAv0VbUOPVLIRBlkYGlbovOWFtTyBzZGaa7fMOgCJyDo39YmG/znbwDMnlCAZJl9TM7ZND5Zi7aVT9k/xEjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VroKdGNlGJNUUNg8Jujev4wLhT8zfM6H6DUeCvTBhgs=;
 b=nXT7TzGT5SuiV3SJrZ63Tqm2IrB5BXwajlIJchs1j8jhCKTTZ29VMU5Q5f2C+9b8mL0HdEduuRZHIKXThhPA4rtT5scskii08xAXog9+Usc/jKKqvbEAEPQZjCFTdHthZDiwiRbxMThR/CdcHK8D7Lo9O8Ny1EVnYzn8GAPQm/ttlJVaqFv6kX23SuXLFoiLtAUAaG1IPyd44zfGSRoHSE6uywVjM6f6s4l7gXAR0UKkle0ctIbRSsHTz+liRKpfWZzR2vR3fWLMV4H6mAWyKpSUlsboiyw3wPRbaK636FE/w2qUeTW5eYpgX2x2VPzig0IqGJoHJVw4Z+Lq023aRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VroKdGNlGJNUUNg8Jujev4wLhT8zfM6H6DUeCvTBhgs=;
 b=L7lGph1JkNH7t/f6zn1eziTu/ERvC2nhgtPBSd74U5aI8/KXW6f/UpAdtEJabp8GNVEanUur30u0B14AF4YjNd8rYg8Slns7P/SYjnZObXXhgf/VvmRfa0rxAkqugWveXLhu3HeKs1nT4CWKuAVa1zRwO9Ey1reshuS2KoV7QATQ+sbCm5eCGvlChemLXVpgw1Y6Hyd2zpevjSMhrSmnu8JPrtPgvvH4FnoKwDwKxbPYV6J1sPVSlXzIvTwsOQbVviCuFDMrcoQMb3jHwfeW3tjBbiP6MVzpcSLGQe+GmYQT8lVOwCHUjcpahqE36xQTfRRDVGRNTrFgdoa65ROKBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5095.namprd12.prod.outlook.com (2603:10b6:208:31b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 18:11:41 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 18:11:41 +0000
Date:   Mon, 10 Jan 2022 14:11:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220110181140.GH2328285@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <20211220152623.50d753ec.alex.williamson@redhat.com>
 <20220104202834.GM2328285@nvidia.com>
 <20220106111718.0e5f5ed6.alex.williamson@redhat.com>
 <20220106212057.GM2328285@nvidia.com>
 <BN9PR11MB52767CB9E4C30143065549C98C509@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52767CB9E4C30143065549C98C509@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0100.namprd03.prod.outlook.com
 (2603:10b6:208:32a::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43072233-b1e4-41b0-5234-08d9d464a6fb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5095:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5095E39AEC6FAB9C3D34E03AC2509@BL1PR12MB5095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAtRyJRcKe1AwvmRSz2/Yk/3tDPnev6YQMTq2htmA1S59E43a4Uyyq/1IzJZleQlTfj/yHV525x6GxPepDtj4l+LISE6p/Mmrcavb5KD+5KZmKatvYYijAGTx/wZ5RzgKo0goE/twoXSqv78ANKeLQ3X3IzOdvvEvY2+xaT9QFX8fIoEnc8X+ZoTszlAGNGnJt03E4d8ua7428XSwK6/Gx4x6/Q/dawEO660faDG3kejy1KQmcVLCd9BFcFQOWqXoF6GVqAvR5IkDVI9rSZP+BEVqPUu6EkP4cvnQLDDgs5dAGJtPTeVuiNDxdX/LAbloke8XazY6wt+ks38lvASkXZuxVq+E2+wk5hEoOwNrfl1UP4W/pr6c3qg6QSEd3xMGZTp9EGtlPdVaXAi+ZWNiQiSJzm1XfXqyOdJ1HY1YFISRVYaVgXF/ONaq9ztebS8j5wJJOBd+jewFcRt3ca+RGhYtzTRY2iwL0PoJe5xHwyKpwZ/aAKNY3i7IRxU4hoLqtCYZr0OrQ922BDCMWjX/BCQMWd0UzNvBxwwFibtBIKY6rFGlj5h0f1HG1HVHA1g7/RnPnHngmwYsn78MSeGP9TmOfhPm1A5lHe9sJfytBlzyzsS4SUMdKTOmWG20aoahT0NGx8zXLFseFKPrlNQbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6486002)(66556008)(26005)(186003)(86362001)(38100700002)(6506007)(66946007)(4326008)(54906003)(5660300002)(2906002)(36756003)(316002)(33656002)(66476007)(8936002)(6916009)(83380400001)(508600001)(8676002)(6512007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wJu4u59bEmAtL9dJL+NOzatB8VGdNghdDK9CFS7CxmNHojaOgaXQ0owJLBxB?=
 =?us-ascii?Q?03A2U5YEjyWgnVgO5un2o8hlBH68Ua+GKmjK9pSqu1X3jb+NFGpVu8a3sqtI?=
 =?us-ascii?Q?sTFZX+y7ViTIpQEezR/TpzrPTc+YkHYWKXTt6Dko5ArXkaUYxxI2grFGXdjh?=
 =?us-ascii?Q?G8jiTj1zZ6s412hT3Cvfvi6YSPjX4bD3xTe3pd89zkEpFIi8D7RCU2Pyn5lj?=
 =?us-ascii?Q?vxRXByQpJNnbOaY7PV8IwA9KCa51y7wlE2jP/u74J3znxKAk9dnEn7NTSxkR?=
 =?us-ascii?Q?SJNUn/DX639M+2jmAx6JpiHeQPbGpGEtzWfwPjQM7aV1qDRaQBnP6HEZzR0f?=
 =?us-ascii?Q?8oqwGV4XztDBTPXH8FtS+QjY+EgoMButtccM1pi+3zJWoXGkNvNarzne5PXS?=
 =?us-ascii?Q?CeSG1Q72BZyCiKJpDu5NSAjw6MMJxRN+iS0KRNfM8cLdjYTX8ze49LDYvx8o?=
 =?us-ascii?Q?ypLBfSBb/YWFnH7qTjTRerQkLNMbszGvwEdfxG3zPTMZlMRexTNvlzUjwDus?=
 =?us-ascii?Q?G6cxlMS6ncaW+bPOivpVg+FemcAeI0kaN8KNVm4qlL0EvZoQFYvsk+VWrlT3?=
 =?us-ascii?Q?i7NiNLNUbT090HVA4n9yfxOCZqdHND1b7SKHj6oHC/p+qZ7PcnIcHhXwFraP?=
 =?us-ascii?Q?wiXlM8KiyCn4KXt1s9QpGc7Tp0t78SF3A6f2Lwnnorvdj61YESlEBZqZs3YY?=
 =?us-ascii?Q?NibsxHfpEZJiIkJXT34XgjRzAfhgyCC2oQAU2USvpCMkc5+SZeou31hGuUcK?=
 =?us-ascii?Q?ZECQfXNA3qDjN3k7y2EABpvYvv+RDT360vShgfMhSmtSXUiu9WMGnutgdyil?=
 =?us-ascii?Q?/akgmvtA1t0kUTGjscyQ4DR21J2v+94UvEKyPA6Gi4b7mcQonAOiS3+kuSjM?=
 =?us-ascii?Q?Yc8nuTtexfoYRMmIPasd2P83TEP/QJ7FXLOkce7IfwgK5HRsS92StDrxf3EY?=
 =?us-ascii?Q?j4mE2LT8Gy0PjFHJQkm7eHRRTZ9F6uC6XXHOyqdgcQDRcmAj+bFUuAB2WHOp?=
 =?us-ascii?Q?Q5udZef5sqaD7xA7klGaqg+SdohqpmqPgIY8jNxdV1DgTEgarFN+9Gnu1HVS?=
 =?us-ascii?Q?OzeGnYLRyJX4sTgi/ZaKNywsG9k828DXPbm0hEqXGLXVWGnCZ0FbpkMC6Psk?=
 =?us-ascii?Q?a3y5Ekfdq2pCNXYqL3m88yElFAXnbJiTG+jd/TW5IPdnO+fpXyAoDfhKiHyT?=
 =?us-ascii?Q?IhB2QnWZ4dCCiX97JY2N5nU8jBdoylV7ocLhDfuF6TQKAo1aIaKc65ufclqe?=
 =?us-ascii?Q?QBYTXZHeFsbvqE0MX1xLqVZZTcFF5bLQ0Ov7TlfqsKC++dqwtRtocmKPb3ZI?=
 =?us-ascii?Q?0QWK0oLZ1z2VxZPY4WCAbHIoAkYl2dgyUYd+oJ8z8MsSyfpOtOnsDrZ+jwjc?=
 =?us-ascii?Q?Wtj7gCcuEKJnlOjIceuekBeOZfSufeyVkg6xAgk80jSkYxHZA+g4kjZUN8Z+?=
 =?us-ascii?Q?Ag7AP1w/jbEaFivRjRuRNUF1jOwIH+xGXCsGvUaZj+Tz9Mkn2B8rR3HEQOu9?=
 =?us-ascii?Q?DT1LbyuGHkcOGDgPNssMe2mGsbInaiTvCgnhR1TwQodelPPSmCLZaJhj1Bzz?=
 =?us-ascii?Q?17HRSInRtcETiPlKgzk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43072233-b1e4-41b0-5234-08d9d464a6fb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 18:11:41.4192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l11gQFweYvAARRbbrGBkVTYxH+CuoWJwYkLv3vdMQzRWjcRjw4E0J6B6VLoHYIL4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 07:55:16AM +0000, Tian, Kevin wrote:

> > > {SAVING} -> {RESUMING}
> > > 	If not supported, user can achieve this via:
> > > 		{SAVING}->{RUNNING}->{RESUMING}
> > > 		{SAVING}-RESET->{RUNNING}->{RESUMING}
> > 
> > This can be:
> > 
> > SAVING -> STOP -> RESUMING
> 
> From Alex's original description the default device state is RUNNING.
> This supposed to be the initial state on the dest machine for the
> device assigned to Qemu before Qemu resumes the device state.
> Then how do we eliminate the RUNNING state in above flow? Who
> makes STOP as the initial state on the dest node?

All of this notation should be read with the idea that the
device_state is already somehow moved away from RESET. Ie the above
notation is about what is possible once qemu has already moved the
device to SAVING.

> > This is currently buggy as-is because they cannot DMA map these
> > things, touch them with the CPU and kmap, or do, really, anything with
> > them.
> 
> Can you elaborate why mdev cannot access p2p pages?

It is just a failure of APIs in the kernel. A p2p page has no 'struct
page' so it cannot be used in a scatter list, and thus cannot be used in
dma_map_sg.

It also cannot be kmap'd, or memcpy'd from.

So, essentially, everything that a current mdev drivers try to do will
crash with a non-struct page pfn.

In principle this could all be made to work someday, but it doesn't
work now.

What I want to do is make these APIs correctly use struct page and
block all non-struct page memory from getting into them.

> > Since it doesn't bring any value to userspace, I prefer we not define
> > things in this complicated way.
> 
> So ERROR is really about unrecoverable failures. If recoverable suppose
> errno should have been returned and the device is still in the original
> state. Is this understanding correct?

Yes
 
> btw which errno indicates to the user that the device is back to the
> original state or in the ERROR state? or want the user to always check
> the device state upon any transition error?

IMHO it is a failing of the API that this cannot be reported back. The
fact that the system call became on-directional is a side effect of
abusing the migration region like this.

Jason
