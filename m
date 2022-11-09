Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5626234CC
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiKIUnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbiKIUnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:43:09 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01C5303F3;
        Wed,  9 Nov 2022 12:43:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMUfnYoqEHNfovDZBr8vJyEibcwXHyakMjO+gfpvhxvKArtClwpQ+tCKmldNN99c70mjNCk+QQXKlFaBW58MjXYyyenNMfDdX8Ka2gNtYk0n+xNzUkjggdgLxgaHM2zMrPtaz82qY9XNtqL4/0ef64rNCNkoSPo48QYXXN6kBfrHBWZz12z8mtqil59kDmIQVojMe0P7Ck1uH8NNOsY20wm3CRh3lc8lwj1lcG3mueEbKI6g3YNgrPnMpyn4ktqqAGOrY9WbleytZdP6/r0bIgZ6aZnAgLlGTc/fCDiQlNBh2iO0UTwQRXQogMUUiNreeb5A+wfglc3YhUz1yCU7aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqt5p9O4q6Jn0AgD8XljO8m9/AP2+k4fm9r89d4pgPY=;
 b=MiE15npJzFQByIaSTgb+HZiqdOSR262/WdOha+jf+WWy/5h5MkfCycvyvrvClzCxsnVwxZBMlJ0RokoueWwS/nhnNpVZRxi55KNRK6KAJjI1PBU3JEq/bjLfmdUGCH1Pr00iwkczT3gX161nC1O2gWSe2o8VCH6w1OhmdeLxy7Nl4j7uyvmXvKlfTgS3JW+yJJgvFKzOHHjmMwnuRciZzYIWW1u6g+6a7UtVl9glIOHd+3R3dKMkVj2kFdZPpI5zNvOwOmmndE/xG5BC+q6eIb97mKFsYVuNNRd40+9RbmyxAd+bwUFfNQcCpes6Y7sodeXtOs1uyR1vFitS/KirHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqt5p9O4q6Jn0AgD8XljO8m9/AP2+k4fm9r89d4pgPY=;
 b=mLVNPA9i+Oq38OxF1LzH7F3adMqDpZ0UuvWSwrKv+pWVwMoNGPl7jdxom8Y2sOgG9L7szCl00izgW9pOSnpLMMSRVEHGHSk5wZity9Zo23Vjm+i1hWj1FzVEMcXwj7huFFSQJZEAvud6tqF5VpnpsizDI0lIW+EHalEPo67LulmSMILPSxH8HBUeTC5HHRM1obdP6uSmQxxeAS6DtmPyZ87qbyISRyRoGDkyZJ5Xp4WEtpqPsqYh8QR//i9UR1HqkiK6tMG0Dn244WpDMfJiBm9ntmlA42uBJwcLUr3sfrgSWDCqocRq02pUq4PvVS3ctrUKUL+I1BV9HOEz/dRb1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4136.namprd12.prod.outlook.com (2603:10b6:610:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Wed, 9 Nov
 2022 20:43:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 20:43:06 +0000
Date:   Wed, 9 Nov 2022 16:43:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Anthony Krowiak <akrowiak@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: S390 testing for IOMMUFD
Message-ID: <Y2wQ2EGTaLauBTZT@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <fbb84105-cc6e-59bd-b09c-0ea4353d7605@linux.ibm.com>
 <d814e245-2255-15ce-cf3d-65788aa61689@linux.ibm.com>
 <73dd6b0e-35c7-bb5d-b392-a9de012d4f92@linux.ibm.com>
 <Y2vRYUXvIG21ytkT@nvidia.com>
 <aef32076-6431-cdf2-4193-5e62549384ab@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aef32076-6431-cdf2-4193-5e62549384ab@linux.ibm.com>
X-ClientProxiedBy: BLAP220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4136:EE_
X-MS-Office365-Filtering-Correlation-Id: b7c0ae5f-af2f-4718-d626-08dac29300fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQgI6dP4MBp1tBv3GdumOoWwrHHvgkqalrqvfmMGxEa5LPfE1X9H7NRn2GrrIVAseHK5IgetWP9utzFwJtsqxwyO9zFtoIw5SaqpWcMOoCX+5LbvB6W6M/J0yYngpoMUjRU/TPFaAQ8mmFsFeTicBijmHEnkHsCUMYfbF4JpqfKicOLRLMPkMa3OJsxHx6Ez6Ubw65fBl2//vXSA09EQpjmYgawno+yzCumtHObq7txPYbgZ/pYyT0zFmPNPa3m3+ANXdjH/5SVBFnN0ACXpjJH1ID3Kv19Z9+XHXlXZVSMm9Y8E1gKq1lz73wkq6gbj4ozSrcYNy/GgkZFyY7fdlUqGo0hUzz98QmKg5YLsN9N71Yde6n9Lc2w4mKtUaBOGCazTPGUaWY1T3d9JoECbwdaB99rOJKATBso5AQcbiW2OHLWjlvFx4XLGt+oSXZ6iPGoRW4Ntmaiift+jggeYP0CgsvBGgjAJUfrlj01dREBQKUTeCbz6S3lkzUO6zdb1TZPKXRAd7s71Qkt0G3mQnNi1g/6LknVMeaXGzvmmoV8eullCreRfMDGuJApbn6w7r30yRNOswweFlHeDRoSVtOvP3IE6oOPRCpavMFvjb4H+E7BeoRymymZU3m5MiAyEvYZYMwujvm06zjnmbe6O87gW7yxAGBGwWFtgmIWtj8csOjiS4mfB9e58OYv2hdxS5nsm3E1GALe1oWl7vA2f56cs4whcED+M6JamRcQHsCrpOlGDugSsBtCmmcMXG7h/olJ5ru0Pdt9dR5++rfT7tUDeAwEnVwOJyu2uggVVcG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199015)(6916009)(54906003)(6506007)(316002)(8936002)(66476007)(83380400001)(2616005)(7416002)(186003)(5660300002)(2906002)(8676002)(66946007)(66556008)(36756003)(53546011)(41300700001)(6512007)(86362001)(26005)(4326008)(478600001)(38100700002)(6486002)(966005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fwKo3wX3+vx35Ytpr8IxbZ1Qjq+3uVDqTa5FSfASExO7C1KMonCIf8Gqa7C5?=
 =?us-ascii?Q?bDwntwSrEv7Tp0c7zoa3dJ9iAM9zJOLH7gee/4pquyjNvZrOk9/NiPFTBxNo?=
 =?us-ascii?Q?SYsrKuPBzSTigSx7kw8lD2W3M5utuBNbMeXhca7jswMWq0dhTIz1rcHz2XRX?=
 =?us-ascii?Q?2r+bUwJ2NXwQNEhoGbeD4OGqOT7QJp84Pg4YGys5etY+BFy9+5x9lzrxwXC1?=
 =?us-ascii?Q?samvR/8NjJGq3qN3E0I4OnRfQD3pp/hNAcYHtT+7BEBmrFQYucmobE9i/UlR?=
 =?us-ascii?Q?QLAhhlqAYXpsUK3whbpTsxtxAPr2mXRr7UzCJqcBzTRRBRowMyOn6NY4bBQe?=
 =?us-ascii?Q?dLHZklX4DOhLiE/3GKHXbIPBru/WpEY10POZxNfP19HU37HTCsGKP6Na2wCq?=
 =?us-ascii?Q?ytJ15CRSrPfxRIOU3TzdQ/W11ZQ2MQVDnBKqFbU/z7qjizsk8NaCG4PgNI1/?=
 =?us-ascii?Q?6/6TZoVEWAGoNn2D/TIMGvCUmmWxkj0sZfedCSiiVv1ak8I9xx7HDX94a+a+?=
 =?us-ascii?Q?T2uYwUkPUXMDq+uOKu0KEcZ7anUVqK7g2QF140SUOXraSdg5IR9BvN3D73UO?=
 =?us-ascii?Q?ItQNqqgP/dWGQED5yt2M+IavgyDM8I1ygtanavZb/3ti1AhF2QqqjZuM4RNP?=
 =?us-ascii?Q?HfArAFlMKGpY6DMmMEaF1L5QtqxBBjaDmiqJXNy001nayXZZZzED4e70mMoH?=
 =?us-ascii?Q?p4ZkFfbhZrNeAi1WiGzoErKz3eme560QVIPflJRC1gyj6ca5yCuaqkyhoAut?=
 =?us-ascii?Q?AUO1ryhtdEGS+r+VSf2VXUpa2Jo3KfyA8Up1aPjysgQ/Zw5rh4ZXIVer8q4X?=
 =?us-ascii?Q?QKzH4ccJEn82d8+IFT5JHWDUeuBXoC8h72krpFexq4coAqRLFPtUw0XxUvO2?=
 =?us-ascii?Q?PQqUvRMuMHfgJj+yfDs1YOGd38oCZoH3h6b5/m0DeYiYmZIAoMtaQSE+Ajh5?=
 =?us-ascii?Q?LvdCsJZ97GaLmI7sT2pZ/QXG5tTtKaUvvBCdEPOa86k/StIJvI9xPvLLG+l5?=
 =?us-ascii?Q?2g9dqAwu3t+ziThMbgItFsPN5JRW2n1+xDFTcIXlWPx3rW6KhrkjBQPl9vKa?=
 =?us-ascii?Q?i8WB39NSrP3AWIrmpvbE2P8Ox2GB4yDj1fsxgXu6+t+o0OiEO6VCNSbF79uQ?=
 =?us-ascii?Q?cx/Z8eVC9rxWQ8t4ES6kz5g24iUD3Dphq59mi2y4EnJnxMmILIDfC5APMQCt?=
 =?us-ascii?Q?egm2zffdTyyAU/HaowZEKH1MCW2q7JG9WWmirRmZA/+nyoUAVuMzGkcG9WSz?=
 =?us-ascii?Q?G58nHJ3sbilsyOR3z6q8s35Mn1wyynyJHVLdynotzXZxCjAqLu9eeT3QHhTE?=
 =?us-ascii?Q?JPuUSgnVTaTu7D5ymxiyaYW2y0uTGFVbaYXsTBOzO8Zxn38tqRvpHbGw0fGn?=
 =?us-ascii?Q?eKaNmYJV5HI1LxOY1itcw6F6bWu/H8c/u50arqTHZo4QtwxKduXfi4PX40D8?=
 =?us-ascii?Q?uaGzeSOGjahx8MQMEWea8ZDKjWHAPNW+YY0mGyUgrZ1Om8cK8xLYTnXD1VBW?=
 =?us-ascii?Q?H9357rIKbdRSps2RSWRfQSlsyiW1rHcM+94R/PtdoCoBc5O2JCJE9OdVFK2p?=
 =?us-ascii?Q?00vnUOqjNT6+dCAx8bA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c0ae5f-af2f-4718-d626-08dac29300fe
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 20:43:05.9965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7/aqKoV0uZz9fWzGMPw8/atOqRiqrf+UsgqIV5GPbyEeV56Yh+XClDWM+IvZMLs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4136
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 02:13:22PM -0500, Anthony Krowiak wrote:
> 
> On 11/9/22 11:12 AM, Jason Gunthorpe wrote:
> > On Wed, Nov 09, 2022 at 09:49:01AM -0500, Anthony Krowiak wrote:
> > > I cloned the https://lore.kernel.org/kvm/Y2q3nFXwOk9jul5u@nvidia.com/T/#m76a9c609c5ccd1494c05c6f598f9c8e75b7c9888
> > > repo and ran the vfio_ap test cases. The tests ran without encountering the
> > > errors related to the vfio_pin_pages() function
> > I updated the git repos with this change now
> > 
> > > but I did see two tests fail attempting to run crypto tests on the
> > > guest. I also saw a WARN_ON stack trace in the dmesg output
> > > indicating a timeout occurred trying to verify the completion of a
> > > queue reset. The reset problem has reared its ugly head in our CI,
> > > so this may be a good thing as it will allow me to debug why its
> > > happening.
> > Please let me know if you think this is iommufd related, from your
> > description it sounds like an existing latent bug?
> 
> 
> Just in case you missed my response to my previous email, the problems I was
> seeing were due to using a set regression tests that I patched to try to
> improve the tests performance. When I ran the vanilla tests they ran
> successfully without any problems with your patch. I will continue testing
> but as of now, it looks good to me.

Great, can all of you provide some Tested-by's for the various things
you've run?

Thanks,
Jason
