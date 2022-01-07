Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB587486EC7
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 01:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343849AbiAGA3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 19:29:54 -0500
Received: from mail-bn1nam07on2040.outbound.protection.outlook.com ([40.107.212.40]:9955
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343753AbiAGA3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 19:29:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVJCs/AmyBCSc6Un2KozGFfuPTbU354mYd3CO43TCR5+idr6gNHDzSpfJTQQG1Tt4C+EQvjO4A1lCle/hcdq17I0euBk5OsgC3nhmvQKEHxqzSxbhkJqaS0YDm4KTKx6PhflBkMwdAKNnaa6tGe6A3CFI7GNRNrJtKJmg+niK3vzdSesauNaJmNDbOqVnGSD7HCa3HHti6kfD7MRCy8hwzY+2hD1zsnnt4xaR9NV2FePKsqtXC6FHZWJ8F9KRbDDwz1HG4cbOesUottORd4a7BE0nc6u7TRl/TuFc0RWQ4FCfuwEqO8aq8Ndn2/69yX7CI2Tth2zeFUYcbc/95thmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzNQKS5ezM9vcgNKQfDRlXYCzbhBiN5MVl2b7WGmZQU=;
 b=D9jW8IczYC/yWsIGtUSUWt1x6Qjj0Zs8MB3i2VIRX8i3HkGcpkneIOnK+cxspid10SRxP3yiZd2ornz9bu4hOdWXMFWsUAKYODGZXACpDk55OWK1xdPo2j+s1p1TQr0NvVPtQaUzijyERiKLnOJjM6sxVAytT3PN7k3Og0v72Dj0p8Qcwq0Bz0f00mQDPGCSDa/8R59vnhNqZ9+b0nd4Sxt4K2MHecwjFaPAzYVeA5g5LhowIhDUOXr4+g2l0/L8vOD/2jlG4IU79tbCbWcFV50MSd9e9qQBGCjL7P3KG1giXezMI618t3be7kA2I/LNT42Z9mKSwo0fdzsmf1rRDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzNQKS5ezM9vcgNKQfDRlXYCzbhBiN5MVl2b7WGmZQU=;
 b=mud4MEawYPp9lSHQNoS/w8oVmryBjDNpYoZh5DFCSObTK0uo8L+1DtTezt4+5GjXz+DsADbSACYlDxpLI/6hFz59KKAp/4gMRf4WNzeB98SSmp34wLsqGva57IHK8q7YuK6bzvtClqNRIwsbg/6JxBFU8raeenx6vsV8GGKFMuGfma7kqE/euobxEL9a0rEs+U6OPt+9hAXj15hl3yInHrHlvF7dW+SKxX5G89xvxNmA7xTZ/yXpBRrmSstsiT0Iu5wVHPWY3Tmne8ZxVDn7rPiWMFmFvmKSpl21q9Gtff6QC3Fjk9vzC+u7RV8z1BeC1uIRInN/cERtA/NwnjOmWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5064.namprd12.prod.outlook.com (2603:10b6:208:30a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 00:29:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 00:29:52 +0000
Date:   Thu, 6 Jan 2022 20:29:50 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220107002950.GO2328285@nvidia.com>
References: <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220105124533.GP2328285@nvidia.com>
 <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220106154216.GF2328285@nvidia.com>
 <BN9PR11MB5276E587A02FC231343C87F98C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276E587A02FC231343C87F98C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH0P223CA0020.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39b0d85e-e5fc-4943-6144-08d9d174d1f8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5064:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5064C2B6CB37685C4AFBEFD9C24D9@BL1PR12MB5064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y4DhGaW+tEZX188srJ7ZJehdFFux4uGTO1GF0781vroJfym1AbhFYFy7mC9/D44rvxEM1l9gmqk9+35RXHws9GexVbUJpuznyer1x89XEztxlVxIHMY2yR+u3sPIQnWfhGWgQC+qFR2lC6glL29bfhCL5tD5tc28bKObmk9bUCYehr29qLANvKfCq4gMIBZKr5wG6Hspmd2nd/NJFZNtRUrYGkLrkA42JCA71ftDsyPoUMz+QtaYoG+X2WEXewlsXW8vk1T2n6pM3Tl0QNIfKSQmP3hvvDCWvvTXCvmToAIE64isPlmAQrlVQId5slJpNxDbuA3wgBzGTxfA6ACPBlwbwK6Db3lpefkG5fMGubdrPXdxxQMAOdwIha6A1eSdF5uCd/BVZRFpz0hcKpzaZsYGQiUuMbqcsKGd8tlCemmMhXjcQOivcadPDQwn3oPDDjElPl9YB7GamQAUR1QmeMlM9Kg151urMOMBA/Jh4aNS62tu2ix+2GJN/HXmWo8bnH9F/CGscbWNRGRSVM4hIiE96D7dRJLieO8f/Z+HpSmcZyfAioHdQg5JIjwxbcrPlv0Xcj9lA1zdjUIfnzTILHgMskowgKvdk2anY1g4+XMXlwli3Ff9Rjqv6+XnGdWd+UtUkt+xuhQYT3uP0dhfBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(66556008)(2906002)(66476007)(6486002)(6506007)(1076003)(66946007)(54906003)(6916009)(4744005)(6512007)(186003)(316002)(508600001)(4326008)(38100700002)(7416002)(36756003)(2616005)(86362001)(8676002)(8936002)(33656002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FOJL9kCs8YUs8qUK6fDcHgaD9vHZyeUgocXd6RFgLfwEKdRp4R6HnWhBzX8C?=
 =?us-ascii?Q?j1GFtCgw6MrF8S3DruEE8QCMGLD/Gmg0w8t/QhTGp3kae4aFXKJ8EBBlaGbV?=
 =?us-ascii?Q?zXx5jXk2f0OXCznT3z7bphr8zQkNIlvtqNHXcP+YsR2f9u99ApJc1qM+KDdn?=
 =?us-ascii?Q?SnaD231WhbLZGqR8/f4DnX3PuEF4QUTqknkAGSHyjUyExNIwT68IaKsU44EY?=
 =?us-ascii?Q?N3jPC7OkF+HBLOABTEsMsB70/5de2z3uyybD5PavOeUR4M0+fQ853bNBsXvk?=
 =?us-ascii?Q?OZ7gVnlSwN5tV3/o+hrTPyfNYajgnr/tbgmRuBKhV0bR8RrYROslWSLew/JZ?=
 =?us-ascii?Q?POQ+DGJa7Xs05zJIXyURH9iaakfj97sSeE5zWi0+kDZZAgl8pmE7XqfSuPCF?=
 =?us-ascii?Q?10JOkPuuiI7CLUIbUduqzbMB1b7JRCMIZj0uKY3vAQpR5jsmGfI+O+YkJJUD?=
 =?us-ascii?Q?AeEyGOd/4nASZmtuzbqI2tIJWzDGQBKLzMeQe8B2fW2CYxnyA3RfWGJvufr6?=
 =?us-ascii?Q?aniel9pYI008jBuZgqkgTAaa1yGwV2JE0kPWTK3Gk/YYr7AfJJdC4sjQdkIv?=
 =?us-ascii?Q?GDdgP5uAPsBiKlVfBLYMqAzocjPJsORUfCNrEZwpEWpmnvTx/uoesoyxy3a9?=
 =?us-ascii?Q?is9wQ91iDCjpY8PvdSDydM0cbnjscqQqTcsqs8C88PK3gUDFWBvzoN9ERMEr?=
 =?us-ascii?Q?6bYWJR+Zryhfv3uWK2KmQxgD5fSBRMAQTJuWu8aoV/OqDmiqxAsQqq4cMqxV?=
 =?us-ascii?Q?Rxoa+yORg7ukxj/boJWkWSqOVBGv0fb+4dD0BXQ5UMvDjzuNAd72LoEhfPNb?=
 =?us-ascii?Q?1/aSaRvkyDGjEvKKqVTYk08wGWom/wFJBX9xYzNauO3YhoLIObRbijcZ2JAl?=
 =?us-ascii?Q?DBzvkEe6sVFi6//xvnDAxU8xaFOGoMI6zj8jwHKOx0Orqool1U2wozc7FliT?=
 =?us-ascii?Q?r+x61ZjTGfxtF04Lvt6udq5EPbADciEijWR2fjmmlussX1p0tb6Yu2NZwFmH?=
 =?us-ascii?Q?haN34ZQP4kjMpUef0PxhhOB3uK4g8amnUGHbbm7Cj/Ac6ZJ2ATILxZ/cuDZd?=
 =?us-ascii?Q?fjgjD5Uupqda4DGvaHq8DvqAK54AL8VCYYa6VxaXx8qWLautHby9npE+5xbt?=
 =?us-ascii?Q?PuagIHLTLCdkIdQYZAVTQvi5mkBOVStOJiAg/R9saaJej17em2D4UxXfj2YW?=
 =?us-ascii?Q?TeZdzM+iAW8Z0pazjzS8I6tukz8W3aYD/O9SI5rKsPzThVj3xzK5wPdPDm42?=
 =?us-ascii?Q?y6vVRVNnhhVXOZvBya1/9Qwph28X27+/X1gWkncYwOuvXHVXfG4nOq52Hozr?=
 =?us-ascii?Q?i8SViAoC9NLA0IFyvhOAnmbG0xNhoqgzQQjIm30Os1yIdyakv5EISlgyFLB4?=
 =?us-ascii?Q?s8t11a79tDUgLef588U3cHz+49pD7H/lAEUI8yFJM2vNPYCNSH41QoNVgtt/?=
 =?us-ascii?Q?U8AmrVudQwSFBg31MWGNasa+7iqbtFMZUWLKiRJTCPZeWMVRn+wi6IVEAQOj?=
 =?us-ascii?Q?QNr6QTfth6juZVzS5WoMOP1xTkD+nE6c6pdiLkzB7RRYggc3vR/X3+4f3yko?=
 =?us-ascii?Q?J449Mq30DHy3KXXwdiU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b0d85e-e5fc-4943-6144-08d9d174d1f8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 00:29:52.0012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N96LXYRTAM1FzFFWjPR13dyT8I9Cr+nBfZqsseFIy4pTdsWafLHmwubItY4/UwSO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022 at 12:00:13AM +0000, Tian, Kevin wrote:
> > Devices that are poorly designed here will have very long migration
> > downtime latencies and people simply won't want to use them.
> 
> Different usages have different latency requirement. Do we just want
> people to decide whether to manage state for a device by
> measurement?

It doesn't seem unreasonable to allow userspace to set max timer for
NDMA for SLA purposes on devices that have unbounded NDMA times. It
would probably be some new optional ioctl for devices that can
implement it.

However, this basically gives up on the idea that a VM can be migrated
as any migration can timeout and fail under this philosophy. I think
that is still very poor.

Optional migration really can't be sane path forward.

Jason
