Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF09777EF7
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjHJRTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 13:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjHJRTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 13:19:46 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2063.outbound.protection.outlook.com [40.107.101.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2362C26BD;
        Thu, 10 Aug 2023 10:19:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCWL3QaG/tonVz/wBmI+3Bb0P8UlFMaGslmF7fTaou4OPR1VJkLoQX/CwKuT+CO8lNIZbm0QgUepnhq07pR8yWo0X6U9I/LNMDy5nq2BTpqs5wP5/lqXz9spAj8pKeHHXv9b23eFUK1WbSMBdn8XuVg74oEv5OUaV3dJonXOBIRbk6sNIsYM2540kql9Cwj5Q96AHLvVe0Wwky+ajWELFsxKAEWilSSLjGGlrgcn44ov7NO7aG5ZzuG3LZw8g86npEkkGnMogwThhqwuc/ihZZ+YvgWiIV/Uz0XTgjd6Y/yqJ4bdXjNk08D3LjF8Z3pSC7g27xwxPcAA/9LIOAGQuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTHd28N4qg6Xe/t8iE84kDi9RvtzUCV2Ydycw3mAgwg=;
 b=PQJx8w2IpXXnhVLB7jm9liOLGnjDDiJcsVD6oPRQtXW9EHtAIRfBafqcbqv2h/go5tZEWaAxtL7wF9U1Dm6FDVJ/2uU6zV1fwin8epK5heX7guyzBj18owqT+rbrhYBbwEnfMikKx9d05BmeT9UEGstuHcj5mwm4bfJ04lsqOvISAPkFgAu3lCrrPu9yrPHBtXILD99vyw+Spvo6nCSfRB+BsxGD0Yu41KfCMwdGlU7T2vvTG/6DZpnqvJjC+5ERYnV9CVSI0bsMEhyZFQ2LJO4bw6SAjpiHvfxL1FtLI/phKjKwc+H4subLGihlyUehrINHsF/VtREKMORPBUz+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTHd28N4qg6Xe/t8iE84kDi9RvtzUCV2Ydycw3mAgwg=;
 b=kYZ3fDmtJbmCptLAes02vyqp5doY7iO+GTh8z7j/OISbioiKTmObqj3vvq6uwRm/RLZtALqQeAEzP8PevpmkjqRxqB+7K3HKioFUvzY9QnjS54FuFzuwU7ILsp6c/DNNF65x9wpVLBVVJjQz7wOe/4LBzkwNNmimzd7208n3jgMQ9eVGs8K+jO6PW8hcJvP8CCuoSLkv41fNLz8czFsgpDiiLUJ46mZRGlz3WCARbFcM4iduqHtSzNlSW9nRF+JiNe7lnAVB1DR3S/+lYchYdaSNb0ZIhQWgRtke/MkwbW0yIgec45jjHCvjonNwKONVAG4xrygaE0oI3NuMmbSgDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4909.namprd12.prod.outlook.com (2603:10b6:5:1ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 17:19:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 17:19:42 +0000
Date:   Thu, 10 Aug 2023 14:19:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Message-ID: <ZNUcLM/oRaCd7Ig2@nvidia.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
 <20230807205755.29579-7-brett.creeley@amd.com>
 <20230808162718.2151e175.alex.williamson@redhat.com>
 <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
 <20230809113300.2c4b0888.alex.williamson@redhat.com>
 <ZNPVmaolrI0XJG7Q@nvidia.com>
 <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230810104734.74fbe148.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230810104734.74fbe148.alex.williamson@redhat.com>
X-ClientProxiedBy: CH2PR14CA0002.namprd14.prod.outlook.com
 (2603:10b6:610:60::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4909:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ed1d0dc-a239-4fbe-83b5-08db99c5fc52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AUdo2hxDGoK5TNbMQRaerW5PutnLvho8dKAJ8zSfgkHLp8+aB8BuPYEAqAWorbzELF/re0S8SquDZLM6VUXa18ooUzv4eWbSlOZCgpydzlYFEcm59A75wBtzk2fD/FRydzXYJIvwBkgOrowpkpnxgSu9WYRYaUE4MGmCowz+Z4BtG/xVn1TffCX6r4TDlBTg7q5/1gVY5UW9+REn8K83O/XxABWp/G6pKCy8risT/DnYc07pdWZPBVs3dKTp+15TCvu6DJ9W2//JGAl9Z5espQg2Q6uHt+FlL3Dc6igkjZ0htI2C10oKXZvz989T3Z16s564vLDHokWPgk2ytDwfbsbc2o6VlbUmBx18t6gEBJDMSBYEzZ4xBlXLGQo4iosw+H+bCreI/YCDr9qeodU7AXqyAxsTAfzgvk6nUypRvQVfjilQhSGIKJqH57QEt9VB0GbRRtOOGXa4xOqruyDtVJmdk5Yua1WEQgZuQnPApQIah8qvDrEsH5BzVHmsB3ekiXCE6wDqOTHixSpGnnJKkl63DvktL7/kgFMO89m+pos57cdnJ/8B+LzG9RwchmFcq3Il2d+nygkPAOTwZPDwpntSBo66nGDhlSWi5zPhuOw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199021)(1800799006)(186006)(36756003)(110136005)(478600001)(54906003)(66556008)(6486002)(6506007)(66946007)(66476007)(26005)(6512007)(4326008)(2906002)(41300700001)(316002)(7416002)(5660300002)(8936002)(38100700002)(8676002)(86362001)(83380400001)(2616005)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Ii250Ao/KkJgiot7rkH+h/qOBSOXyDM6u94DdWREZDCNkIgmMp0VFHul50B?=
 =?us-ascii?Q?QeczThK/SP2w5ZcNZjXROdkzXPqZAP2xPx3nK7og82SK/MoyDA5NmmhVCS/9?=
 =?us-ascii?Q?iZKXVXJ7A0EaXAaCtuy5sbPQupUpDFQLvR3pU6nsljdFWOExc2mNNoJYr5UF?=
 =?us-ascii?Q?wCUVsKCfU2Zx1I1zkGxwT918YqBsTiCDCxFidekBd4BVYXpun4vPwoGyH0O5?=
 =?us-ascii?Q?vFcfdgIUveDi6wsZSSqCzLAxAUFKMBfrTz95UzyNvyTyxchrnGVDSSUkYtm1?=
 =?us-ascii?Q?5pDzhuNh6pqkn76ANRbjM9oBV+XMQlrTPOF3s15hra5ylmz1/PxmZQcO/Sba?=
 =?us-ascii?Q?o67dNc1eGzFiHZUtSNoZ2ta21qRqfBQ7f2mzH1x+tjF/irIvx+Xop83MWaa/?=
 =?us-ascii?Q?PRvXtcoNMdV/SWTgMN6KtzdG4tUqtGxh4+k3PWvvwOn07wNRn7oAAGqPLF8w?=
 =?us-ascii?Q?cB/XwjnGaJtIA826DW45j61+eNgQttENEfyYvk0zyeKZwctnMCtsWIfpeybw?=
 =?us-ascii?Q?eEiZcVy/+EDve2+qnyGT8fMX+78Ff7T4FL6T6IT7a5StKELWWctTPmvrbj1x?=
 =?us-ascii?Q?Y2D2HvIcmbkCQ0BQgTMwlO0S7uQU4jbLTKMw3+712gW1IuSdaZ/ZdUsVZzNg?=
 =?us-ascii?Q?FgQ5Vb4q8a9We/Uu67vHIdJgbxknJtAsNg2jJdpUF8+t+/xadOlKLFmIMR+Z?=
 =?us-ascii?Q?wK3DYRFD6/56xk2CrvNoKfyndkUYpOCL5rjvkY1ISEPa9WFNSLlnkLZAS6Su?=
 =?us-ascii?Q?WXK3AVGo3TGDVcnC6E3OBw3WB3+iNXNeMTdann9ALrQG6DOwEKSdtKA6wEmn?=
 =?us-ascii?Q?DDvSQh/MngN24B5tp2dwGN5aWNp7wCRBrpfuGv2lluulLVQryV9tSCymtFTJ?=
 =?us-ascii?Q?EtNLjsY8n/A5RezjUvFOu2scshCmeRbscvswjtBZ2YyZpkn9NAfOgXvXrwlx?=
 =?us-ascii?Q?pCEKWQFLqi9PCGhb8GAObBX37HxORXSYV7DlyLSS4TCxCduMsT9ljaFYK5a0?=
 =?us-ascii?Q?T9a63yUzOYxNMK9eM6BkbCCXg8LatjH/1lFNGvWtHb1aBiU/CSrrbq6dXSC+?=
 =?us-ascii?Q?3cO3bTnCj4fiV/gotnMrur7Rm2/qAsrojvitrRmisVorh/tXVLhi/GJvaYp7?=
 =?us-ascii?Q?/DD1GSs10k5mYrOd4G9sttz5yOPJ7dgeKUmHQp+O+USkvBkL4ViyACZPFOk2?=
 =?us-ascii?Q?BHyDOl/2XW28jLD/3fU5xT/mkF+qmP8RtqN/EAgboG1ULbMUczbRh8N5KMxx?=
 =?us-ascii?Q?lLUenR/ah7xakZLI2U3gdh//7/JfVhc4OdXP+lpsvJ2D3Ov3oIXvY+XZuaKu?=
 =?us-ascii?Q?tkDNA0bEymTKmiX0Vob92KaRbqFjlvL52vvHLKW1xwJk6GQm6xP3LP/9IFrg?=
 =?us-ascii?Q?YOXMIVwNR8tZo3yD0wW4ZnlD4Ohez+181TcDzGVRaawAw9V/6ICpkTmeUZ+u?=
 =?us-ascii?Q?aEZrlpUwbmUn/ybSjceRR/6EoIZ0YmgbdpN/+dE+XTRmcjyUFqb6t/2Z1jf1?=
 =?us-ascii?Q?VeyyD+zm8L19XUzOd6BoMX1wnqdd84YSMYw2EAas8OsEcOiQ8uGAEGgkRjlc?=
 =?us-ascii?Q?mL0e9fWrJhjeC2OC73xDE//1j8eFteFIB/5KqNXp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed1d0dc-a239-4fbe-83b5-08db99c5fc52
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 17:19:42.5266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwecH58P15bk1MPLcqT688Rlcwv+qcDZWM3/jPAVrNWzGqqWy97/5TMda20ikU1y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4909
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 10:47:34AM -0600, Alex Williamson wrote:
> On Thu, 10 Aug 2023 02:47:15 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, August 10, 2023 2:06 AM
> > > 
> > > On Wed, Aug 09, 2023 at 11:33:00AM -0600, Alex Williamson wrote:
> > >   
> > > > Shameer, Kevin, Jason, Yishai, I'm hoping one or more of you can
> > > > approve this series as well.  Thanks,  
> > > 
> > > I've looked at it a few times now, I think it is OK, aside from the
> > > nvme issue.
> > >   
> > 
> > My only concern is the duplication of backing storage management
> > of the migration file which I didn't take time to review.
> > 
> > If all others are fine to leave it as is then I will not insist.
> 
> There's leverage now if you feel strongly about it, but code
> consolidation could certainly come later.
> 
> Are either of you willing to provide a R-b?

The code structure is good enough (though I agree with Kevin), so sure:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> What are we looking for relative to NVMe?  AIUI, the first couple
> revisions of this series specified an NVMe device ID, then switched to
> a wildcard, then settled on an Ethernet device ID, all with no obvious
> changes that would suggest support is limited to a specific device
> type.  I think we're therefore concerned that migration of an NVMe VF
> could be enabled by overriding/adding device IDs, whereas we'd like to
> standardize NVMe migration to avoid avoid incompatible implementations.

Yeah

> It's somewhat a strange requirement since we have no expectation of
> compatibility between vendors for any other device type, but how far
> are we going to take it?  Is it enough that the device table here only
> includes the Ethernet VF ID or do we want to actively prevent what
> might be a trivial enabling of migration for another device type
> because we envision it happening through an industry standard that
> currently doesn't exist?  Sorry if I'm not familiar with the dynamics
> of the NVMe working group or previous agreements.  Thanks,

I don't really have a solid answer. Christoph and others in the NVMe
space are very firm that NVMe related things must go through
standards, I think that is their right.

It does not seem good to allow undermining that approach.

On the flip side, if we are going to allow this driver, why are we not
letting them enable their full device functionality with all their
non-compliant VF/PF combinations? They shouldn't have to hide what
they are actually doing just to get merged.

If we want to block anything it should be to block the PCI spec
non-compliance of having PF/VF IDs that are different.

Jason
