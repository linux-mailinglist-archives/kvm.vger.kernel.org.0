Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A4344CDD2
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 00:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhKJX3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 18:29:51 -0500
Received: from mail-bn1nam07on2061.outbound.protection.outlook.com ([40.107.212.61]:65280
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234206AbhKJX3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 18:29:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqWWr43B7u78OGRqhxIbAMXQiAErb/uSPqzFo1mp6c4gcor4p3WnaEijdIAc8iIDHW7/ksFWE91F+a3MBXo9ZFB7KwUalMRZ3wpAEVRK5AJm0LDVmTVN/lctdHndBwN8Uj5yw0YlpLi4KxvFc5LYWiZ0bDYpWY81xK6jzc8tFdF1UlPcSdvp/JLtNwZG0NE7tiBrIuwohCXfuoP+h8kIqYAq44TFiq2chO2Hs2W0ZgQKXvgxKgXMKquNIBCM7LL+bV7mRr28gTqhVm/Ns0bA210C2qdp7qDgBxwdPz+BYN2tLN8MyTx+zGlAN50qfhzEIwLhXruL8IpymKAQU16sMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mo5rc3knFIfKgJ+fqmhTmPu3qUpmGAfFwBbF84pO58=;
 b=Lcjihj0iOKr4HDNtQ/5tQheEhnbnq3/MnvG+IrfITGa3K1gvLsSJ5NdJsZb8wPjY7AxLmLoCWTLPs86Y46FLKvtUuqk7BrmvIZAnCOyAv7E1QlhfIupYDcxRg7g486nS5IIV+CZhAWMtKpuf51NoPSNcAQsoeYrkZeSHZZCwZfYPHLHH7yRPh65qv1N+oIEDawXd7f/F7vl6pm31IhQWzes+Pnq8wZXucY+yriiGrGp5qolMxrDAD+LyE03eqwLxYaZZV7Ne2qIT47cUy3WaUep+yEfnpAJpAU7zZNV0hyzH8yHElppokOVDouDA47buG7fekOgbbnZajSnjs5UfCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mo5rc3knFIfKgJ+fqmhTmPu3qUpmGAfFwBbF84pO58=;
 b=h7+dlRH+/G6u18vmutXz0pZkq6owEgLPRtykZH1bQ7WMm4dVoSDXTvD6ouBIODenC5xO85E3QzxKGRz4isRxY7chvjXPdh3HzvYrVc6ee/A2K+moYcjVBHOnkDLUeeuJXbk6qGNVraFSmCPlUAmEd+zn8lZD248uykDxhWS+/XNU4g8/dmGZRziboHkjlX57Vh6MJJRLYmhwWTqGAEgcihdgyyuMCCrwZM7gy7rxD0r+7Tj/Jnw5PK6APLbqokvT5XVB9IKkgSnvs1mdg2DG3KvW+ZvmwvgDFLkZFUGYk6SI9EWcsqBxLHmiYS2Io1zYWeLcFbSjvvu40h9ButpuHw==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5160.namprd12.prod.outlook.com (2603:10b6:208:311::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Wed, 10 Nov
 2021 23:26:57 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 23:26:57 +0000
Date:   Wed, 10 Nov 2021 19:26:55 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: drivers/vfio/vfio.c:293: warning: expecting prototype for
 Container objects(). Prototype was for vfio_container_get() instead
Message-ID: <20211110232655.GE1740502@nvidia.com>
References: <202111102328.WDUm0Bl7-lkp@intel.com>
 <20211110164256.GY1740502@nvidia.com>
 <38a9cb92-a473-40bf-b8f9-85cc5cfc2da4@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38a9cb92-a473-40bf-b8f9-85cc5cfc2da4@infradead.org>
X-ClientProxiedBy: YT3PR01CA0022.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0022.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:86::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 10 Nov 2021 23:26:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mkwzX-008GyT-QU; Wed, 10 Nov 2021 19:26:55 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: baa50a8d-b3cc-491d-b7fe-08d9a4a196bc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5160:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51603D81F9AAF968CF09233EC2939@BL1PR12MB5160.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UfitPOV2ncVMtDPC+4TWudDMACxn4hOE2AFQmnwTaAhTYViy0f0lLLderGoyFsCj2hBrMBjSyK0Ks7qnVz7GhWnhqa8tIEftReLk5Jukps9u0txRSRLOjew1cCGQMXZYhMCUFe1YFe6bRLbUw9rAZMtoZmrlsn/dggKxtJqCo83pAVRz3haxX269g4I+ORzRQ0HKj0d9fENm0NDIQv6j+K+FTkss/vf4GM2WOm4kSHnHExT/7MSZ8Sin8PKaDsN+pPrBf9D59b8docM2/50fPSfW/wnm8Xs8cawtcJGxV9CIS7S/TqENYqJuDwX8+UdHeJxhlDKOU9lNVN0M9AEHVsGHFEGbNU/c421OUl+fFjyCnxzoybNctUPV2ZtR1IxL9rWxEwhrFUEm2ly9sXDETp+ZRWOle/hbOAEbe20YX7uBTXNiIq4v5slbghssqNeh8f1M6u5ZlD7eFBikEAy6fxjyuLS/42VkUk72+z4cQjc7fYLIkiuWYZAybCiNLTaQc2k0jxbmpJx493pHDBZ6Yk4Yd6cdfuWXpJWcfuZy8LtdSoXlQgMkRVsOoSAGOH3oXdXNwPZ1PMVJ8j9z+dBDc1QUGaZAF/GnuUaP8frFgfMX2kvGrfcknGsv6T12WMAPNbUzU512hMpcdAMkxmPCOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(2616005)(508600001)(54906003)(186003)(4326008)(426003)(38100700002)(26005)(36756003)(9786002)(9746002)(2906002)(8936002)(83380400001)(316002)(6916009)(66556008)(4744005)(8676002)(66476007)(86362001)(66946007)(33656002)(1076003)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RK/LdPRbDnEX1Uyk3Gifw+Ls+LOg41k10zHUu5Z//PrwWcj7bOD71Zkl74U4?=
 =?us-ascii?Q?U81WL/tt/CW+1w0ir1GyU+6zOYK1i9w2TbP6gZFvZPofrqlOrmqupEHfG6UM?=
 =?us-ascii?Q?jaJDxD4J6YOLvozut3cLVKT0rVPvy3BN5mK43H2SOUTOeZj+4fn3+qCmJdPP?=
 =?us-ascii?Q?hFm7osmcweq+jF9Dmb6J42D/vPPyEWfqfywgleWuzFn5KYsKZWOdDbdHVk8o?=
 =?us-ascii?Q?V5L86gTJjRmjBA/tbMAjiSUwo4jDCWGU6chadj99s8bJ387rP/vFzINdyGGl?=
 =?us-ascii?Q?1f6XSiL1+aVFkJDuXL6WStnt9sBy79kDzgOv7D5/lJZkwlPM8suAHcsq5SHh?=
 =?us-ascii?Q?w9vt4lFnORNczZH1JOtYEeHAtDo0B69cDAu+jSyD+UPLPd4MC3cb21GvH+Ny?=
 =?us-ascii?Q?TkCMXId7zryQl33oKd4Lt/K5t05z5Pa6JiIr7W6aU5k2BrxRWqMMiLhUDTNR?=
 =?us-ascii?Q?I88rWH7E63V65sNZBBTHC3jMu28feWE0J+rE+N4aHtxcMFXEDePeVWKYWixq?=
 =?us-ascii?Q?STFiYQgLxv/b/MvYiyrxRIXUR/BxpwWz3dsTMrL7A4+D5cCcllLVan3IrMRF?=
 =?us-ascii?Q?mEelEX4PA0bkJ1KGGyEcqxthrDj8VBK6GPGF11pZDcj29QFmQhEaWbiaZuU0?=
 =?us-ascii?Q?H7lNbX2WRsOFZCeBq2F4XErX7kwftiAtGS4V1XLz1Yc8SDsAuJBVfXkx+4ev?=
 =?us-ascii?Q?5zSncF3PEG0EOq6AGuW7a7OWFNskfK6Et/jtkaBiiTVuP+0/JA+GJgG/FKtY?=
 =?us-ascii?Q?EblAp1rm/Xbn+WOEGd+fpOZF6wx7Mtd2yKuPI5aEU5VAIMtugn1MKnoefx3j?=
 =?us-ascii?Q?orgUMY61j5yTw0nt+KvFjadun9dy3fC4BMRNvOeGXgFdQzEmewQCF3IRl8wv?=
 =?us-ascii?Q?gMYEYUG0agRNIH+5RFBSEk7nC4X2ZAfU36/dugPUHrDrMnWq6mwMs00X2VY3?=
 =?us-ascii?Q?7w94rm8PBDiwoAU22n8awOmga1cJLSP29ABUePQ6jqRbM8NLHd9v4gFy6XAx?=
 =?us-ascii?Q?4+9CyUBzUWGYKGDxvaogWdZoIsNNLmrrvgYtLl7aT4eTsFa3C84cCsjBgDdK?=
 =?us-ascii?Q?6fLvOAAmiTb7wi2YrTX0BL/uPPGus1OKDyr0WTxRMq6N1UTF3cLc0V9GpvEm?=
 =?us-ascii?Q?fiyskXcWP30YADpHBomQkswkQ/OHrY79iYvqMzm+/VtMT2ZfirFY2hNUzGkM?=
 =?us-ascii?Q?A/ozoMp+4X3+CqLyuI038GLtwZ7NCnNyD4U5Bj1pul1/1rtqZvVFEihR6Ws6?=
 =?us-ascii?Q?GRsEKdCFY0ZtVAn2blx8sDFDYWdHOLT34JmclXFzwCpd8kiGf1edVJ7heblS?=
 =?us-ascii?Q?53SjZq3K4cwaiKW21kpbeCkh9P+qPYNWRiBsbR/47Pp8FfZ9cWhEZTfA1M71?=
 =?us-ascii?Q?o1A+ewVQirJ2x7D70sejSVN1oag0UOiVgXDbGnF6FD7vRhemFvhyuhys9nkK?=
 =?us-ascii?Q?lx7nE5wmn+xow2/zq5lY3WvzZNG50KuAEgbTe7p4IHNosqoTgaFSa4R0UcUM?=
 =?us-ascii?Q?PI+7LMWhWtS+eSnXZjd6IX7Azgv/H5Kh34OagYo5ihevmoJxkuojLQe0CXab?=
 =?us-ascii?Q?ETjcICYcje/k1+6nm3s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baa50a8d-b3cc-491d-b7fe-08d9a4a196bc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 23:26:57.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFBprZC0qjH2sIsRc0XWvAH2dPsWXR2Xij2ipw9C8pjG7Id7aeSDDGPGQ+9q9PoV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5160
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 03:19:40PM -0800, Randy Dunlap wrote:
> On 11/10/21 8:42 AM, Jason Gunthorpe wrote:
> > On Wed, Nov 10, 2021 at 11:12:39PM +0800, kernel test robot wrote:
> > > Hi Jason,
> > > 
> > > FYI, the error/warning still remains.
> > 
> > This is just a long standing kdoc misuse.
> > 
> > vfio is not W=1 kdoc clean.
> > 
> > Until someone takes a project to fix this comprehensively there is not
> > much point in reporting new complaints related the existing mis-use..
> 
> Hi,
> 
> Can we just remove all misused "/**" comments in vfio.c until
> someone cares enough to use proper kernel-doc there?

No objection from me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
