Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640E2338F6B
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 15:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhCLOHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 09:07:05 -0500
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:7904
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230302AbhCLOHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 09:07:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLbytI0O4hNk/CNO8oyVGrltPhVkyOPVULnXfpwtEo3hSK0sfHQxeLo/svQE1zccXXl1/+y2cAOykq8Sco+MXDX9X4wmmsfF0U44nyc1oG3CqM3gCduiMmBCvANjECPDxd4lHJSAP+G1SV4AmlJP+6nKjtP/h6hTA35GMyX0Yti9BocRf4SCE1Bs58o+VLjPmMLmYzbpuQ9jU3JlI3aH3Fawa2lpGZB9+d8Ywz0knLGYyqOUnoygaUE/TVySt99jEO+5fPIhpwJUauyJJ+CwKFdLGLXYya2wHj/uOmDf/ARsySg8Kbzdt8VsA2kdnqCfCwKcd+pzAzG93fGU2fm0Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQBZaPkeC3uVWkl0D/GTRU5hNXKs76lj49OLlbPyGZ0=;
 b=jI0VO4XCYlNsC2kdd6fcIuGnZRi0hRPO0jjVIxEao1vHkftTFPKKorDPELi1mUKfIDZyzb57Q0nDErsPs3T+ygdIrQ+9IerahfekCOXzn6Bwjd8AtCM5AUmSkGGPsDDqw0XeFaGBLP25X70laflQZJd6uYANjj0MQcNefYBQ68t7xWZ1C/rjrLF4O/czTCdAIewuUNAiNec8678cG43enK9Efg8NxIkGSlh26GpEu7fy9iU+Ycy5TnhSuZFOgraznfNued1gHUZtwENoGFmhjdxFC7NjI3bKZrTUn+c5+4clv/wNOoyI6FREVKPDHfPGGoDuNZ3roXpapBKmVFxfsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQBZaPkeC3uVWkl0D/GTRU5hNXKs76lj49OLlbPyGZ0=;
 b=S6rZzCGJM7yLrE2r0OJz7uAJlOCWdlbfcS8wFNzIhfIoYoMDjU2vwPAjOxXc7WqVnVZV2izotgHFxod7YUddA2kjLV5m5pMoAk41VfCitgmjtdxMnXzPVFArCWppIV/P2JkvdghPZgkPN0Fty6QRVFXDLHuCmg4CYLqLe+6KCfgf2qyStqC05kI8dJy6aEpO6Dby8w+ow+HQZ1pg3CHuxs/Xw2JU3gxdEgdaPHvpfzYmIL2B6xHs0ntxR/tDdWhBPVaSeEsSWMDjmr4w8ZmRnVMCut+FPcErjym/QRo3iUZBaKe1tI8GdaK/69LWe4l7mUz9xfi1Hdw4QxGzlza8ew==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 14:06:53 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 14:06:53 +0000
Date:   Fri, 12 Mar 2021 10:06:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 08/10] vfio: Make vfio_device_ops pass a 'struct
 vfio_device *' instead of 'void *'
Message-ID: <20210312140651.GY2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <8-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <BN6PR11MB406801671BEC89068FA77F44C36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR11MB406801671BEC89068FA77F44C36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0437.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0437.namprd13.prod.outlook.com (2603:10b6:208:2c3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend Transport; Fri, 12 Mar 2021 14:06:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKiRH-00Buyn-HQ; Fri, 12 Mar 2021 10:06:51 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d598f8c7-0ca6-41b0-d4ba-08d8e560164f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB440222A9DEEEDBB85DB981D9C26F9@DM6PR12MB4402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6YitTXprzRL/FQD690Z6FSFlamstTp4p0478DYG9K4ZJrDPFEh/q2dNuqvF9K7fb3AWuxPZfy2wYO/MyzENjnr2hmPLM62qZBTuINTM3KJCWDfA8SxGAPNeSYaSXR7z1tlscqyQXiqxxGdjvKBkBCOF4n6XhiyGNeO0belX/3qiFxjs/W1wux33rLfP5venFhYEQY70n0VaruV17l+HJJecgNhyHfAVhZZ39FQAfwbKuVxXNmc3uQob8AzGlGEzKyEOCn5k28ulHUHBtNBBUnXjDM/RcQ+3tjeWvoyihAc5tSxcSqa8vaor7cMACN2jQJY7Gzz+/SSojBJT4pJu5uTxM8TywZHJeBniMz+CR1HPy4m/Er46NA5IHVnMZ07pAs6iWlzOftPepTbAKKw4M6NAJIInaA+h9V8j57EBh0AU4zSbpc/OHUSEmfIAldCzNra7L8ZwaoYJv2JuoNz1MAeiGq0MF3CrjJRkJwFKey1hkedFnSZwYWSNCD+1IAt6nI5IXdv3Dqx8UGv7j7YtrnKw5sYES5GTh4RMzzIawHnNsCCIZAjtduShepe+6tvgW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(478600001)(186003)(6916009)(5660300002)(54906003)(66946007)(2616005)(1076003)(66556008)(33656002)(26005)(66476007)(2906002)(8676002)(7416002)(107886003)(316002)(8936002)(426003)(36756003)(86362001)(4744005)(9786002)(9746002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k7U94arj16GkG2T2H26TEsxX+IMKXCvnuTn5ehTBnT4a39Fk4Nl0euRV+EsJ?=
 =?us-ascii?Q?LJ7XrCuo+3WLZBGmiqRpni8vNd671rEysa1YWx57lYurMswujTGFMcONk8gL?=
 =?us-ascii?Q?oPcs2ZLWQPrurMSFAtApRMnLXlNhnhb9UVWMFKNKrlnpkChnf2qRPYqajmQ+?=
 =?us-ascii?Q?fj/aSwk4DjhS/wk0VZGe2xS6X6H850nH8Y9iF0zIYOichC7U8SMV5Fj/eo2i?=
 =?us-ascii?Q?kfaq2FOe0vhiz/LPDkpAh/7pa6Y1heH8PiSOe3AjbaKCx8EBh3cVBQNmlKO2?=
 =?us-ascii?Q?F6Vh998699h6x4l187f0PtcuzlOBgZhFpNyeZBkWut1oJcktja3pUkui70bx?=
 =?us-ascii?Q?IrfqHH2aB8Zqj18/CrPrICJ1pMyRP3suWu2TfylkBoiKAB8Mrhjq6PK/o+RW?=
 =?us-ascii?Q?EVXovSpMkwDXG6wy8OBl35qq0zYjnxBgfJbZCMok8mlaDsejcW6Y/R1xrYQe?=
 =?us-ascii?Q?AGWq+yuG6kz5e8Hmss+RTHF6Qvj/jKPO5JTWOMsWVO5hTqA3TeePK1p3wvSf?=
 =?us-ascii?Q?yalHQ5Chj9q8RBl2K72sTEb59/zzmu+C4caJP3In6ApwMBl2ocCQJnDmgD0Y?=
 =?us-ascii?Q?qKCQ6KWAUwnSZFBerRfML6EKf98FTMHJekIlkvaoMfF/2f3rQ8M4ONXfsre5?=
 =?us-ascii?Q?a26Lqgv9AHiJ96tuOU+b2GU9J2O10UcWLEx6BbVb9cFNIdgVPMLqZGEBtzHi?=
 =?us-ascii?Q?MbUBdmQkUoIIL798JRXDfQoyW2qHte6pZCdJkNBCv/GjNZ14M/kyNPsmUZmY?=
 =?us-ascii?Q?JJhlS5R8Yf3pKdtmOwnvPnd9SW5CooSDhnn/8jMWnlKH/GIBToxyXfG1BRQW?=
 =?us-ascii?Q?FpyS4rrv48ACOLfXuSySpwhl9B7bCLtOe51co7HtlzKbG5/jkGi2cZ2kQQQm?=
 =?us-ascii?Q?s2+Co7/0S3CroM3/3m2Fj7rbolOcsFMlAZ4jfjk3WmdlH+PJwIn6W1UVZ0Ye?=
 =?us-ascii?Q?Jwt3NUQISt2sNU0yjRoliSNztuPm4EXf256PCNSdPWSzQ6gxXg0Dr92gDJzm?=
 =?us-ascii?Q?+ykZEk/6FoRe7MAqpURyMso8w06XeFqOUBmtEh+llNMRj1ZaAvnM7Cpxxpat?=
 =?us-ascii?Q?t7BZthBt76it9oSaaA+zVt5dcwq0lTeWMd8C0OO85ywRUrl5PqG7VQpyG7cE?=
 =?us-ascii?Q?Ak0usZ6lz7v4JYHfdugExqjLdKKVWw7ELrXiO8nY5xAWj/NkOocujf0/jr91?=
 =?us-ascii?Q?CGhszSF29rB4z4CB5YduavJ0EpNkwyD0mbSq6EcRGzdbrCmK0cJjzzCnuP3v?=
 =?us-ascii?Q?wZKGi4XNCnKF0psQz0HPKxhcQydlAB41xQU/c0kMu/t33vVY5olVkW2H0xRn?=
 =?us-ascii?Q?moEEtZZoL/5G8mt2z/U+o3j8QqDywNeE+7+Nd5wFzLovXg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d598f8c7-0ca6-41b0-d4ba-08d8e560164f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 14:06:52.8635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMHjEXRgNkF0jHgVeE0K2bIOvJH4XQ4cLCowi4+SgsCYbDaxqZHD3pvFDO/Tx5Jl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4402
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 01:42:38PM +0000, Liu, Yi L wrote:
> > -Each function is passed the device_data that was originally registered
> > +Each function is passed the vdev that was originally registered
> >  in the vfio_register_group_dev() call above.  This allows the bus driver
> > -an easy place to store its opaque, private data.  The open/release
> > +to obtain its private data using container_of().  The open/release
> 
> I think the is to let VFIO device drivers (e.g. vfio_pci driver) to obtain
> its private data by using container_of instead of let the bus driver.
> right?

vfio_pci is the "bus driver" in VFIO speak

It replaces the void * vfio_device_data() with container_of

Jason
