Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4C475F7B4
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 15:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjGXNCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 09:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjGXNC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 09:02:29 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B0F10C0;
        Mon, 24 Jul 2023 06:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuAccUqOiNUPwNyipZmypw176Bp+HiwTQQUOpvq7FgDeImyxlEugfGFz27RZpFDmcKf9jkB9CBWXUGWdDTPv12+WSeE5ZeTTbGRWFZHJVUp88EAiFOk+0iDHuta8XkcOtw+S7UG0TOlOm5uHoBYA73I52xjECeE8x/gOGWSsCmMB2dhSkgI7bgqBlJSh1kXQt6jn65ehcs11/IUY5vy+Zd4+NQHQYevQz7LAA1o25PPb0oEvgRs5aNwV0WUhKhVGNL3jTOC5czSt2lhO7ifjmEd7bHWsLfCkguo6jr8dKrT+JzRtBaNj9CWkTUEht4DmAYKHx+i0E9sV5ZV9ZmcKIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hDBAPlgpmfyMwj/MHnu8ryc3JVGCZDQFlDs2ehOmEUo=;
 b=bq3Ye2UrDP6iA1rHOxUBnOQ2N9aLh5LwhxpM8zPPUFH1h7VurfzZs3GM6FzHaNc0+uPAZyjnbeFugdzh6MXp1cB9NFvVjTWErAVpsiL3DGb2NM34IrJpmDNXUn8pB8Ex3x3RwdT0iffkwt/RZVAxEZQ9We40oZbAAVELQzIZd4E1YvRhw52Uxp5bRiI1kweM1jO2D4kMuOymS60yYNa111JIYlgPoKCMZVt7Qt4NpBUM4vsgQzvtHsDr0XBsiz2FtXWdkJx7te4mC92ihGttyABEFJAyeajw7JsiDG165jewTWmXI3vYk7QQ/icZ2M4i/zn5F+zVb1ucXN9dg3KbWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDBAPlgpmfyMwj/MHnu8ryc3JVGCZDQFlDs2ehOmEUo=;
 b=p//72aFCKgNuHan4xfXHqn+fRvoryGPa3EVXwaHD2MrzpfFBIhy9FHl3EIe0XnIrPQtvHi03nmLleMFJnYJ9fYdpAPUTpuTxPKnNdx8ThcMRVcDmnfspgQu4H5uClliS37mJfJ2nyI4aRgzAeqCc69GqvDdcLS4Jgt9UKFdBmxNEoVdpDgsEtzsPNlfTcGIa/CFeYElmkcrVRjtT/gFsMg0BO2MqDjK3X09gl7E50KqEwY59Dqdj6EDHYbF3VOonMSn85aNLA4o5tcbk4+pLWa4rby1qsOq+1B6pJgu987vpExB8ui1OnGUz/qHZET+U4eqgYYf32zTqlVTWeqRGrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5145.namprd12.prod.outlook.com (2603:10b6:408:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 13:00:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 13:00:26 +0000
Date:   Mon, 24 Jul 2023 10:00:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v12 vfio 3/7] vfio/pds: register with the pds_core PF
Message-ID: <ZL516RPMMHS4Ds1k@nvidia.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-4-brett.creeley@amd.com>
 <BN9PR11MB527656A2E28090DDA4ED07728C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ea5cd85a-e29e-d178-5b17-1440be84f5fe@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea5cd85a-e29e-d178-5b17-1440be84f5fe@amd.com>
X-ClientProxiedBy: MN2PR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:208:239::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5145:EE_
X-MS-Office365-Filtering-Correlation-Id: 55c4aafc-1a14-4186-a4eb-08db8c45f343
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OYItgJWCmM+U0t6bjOnPBm+TEnKqtehPfhFv7kLUFjJDh4v3wSOig0p4AU8JqYEumkjtEmnWwnrw1pseLQJyOiN307zSMj1A9nOOzsbF4yI4UQdhkzKK90cxmwrGKeC0RUIKa5yT//y+PihaH3FILOTeBg6uvzI/+gvzGnvahfNMUWvoguBvRT1N8wLgbbi3TZmv9WQ1gUd9EKJe97NJZt0pkfJ/zybq/nGQGYaiqCMpRlGBzFHp9cRhH06ix7TTechYlSJrne8gZHyVmTiy9jeqfNIbNvlrn0d3ygP5Yk94xDHg8Q+bwJVcwsbZHB1eT96nfn8iqP+jr8g0s/ZsyxUEFVBEo2liEcdQOLetu62691xecKP1N9vu6Oz707BOj9rDCkzP6oP3j2bV5VQYX1429YAeLW3Q7IS6F5f7QojVhrVQ+tvDZCdt5MiVrVWhAW0NKRVVJYycORckeM1aCQOqWc8csts5OMFFpBosmQk/DQ5oMoUvWt6g2l1N8JqSl6fL/YlBwPJr+m5g5Vndxm9OoJdlq/xJIgqQMl2v2f9oFXzXb16ozrhKumqsx6TF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199021)(8676002)(8936002)(478600001)(4744005)(2906002)(66476007)(66556008)(66946007)(4326008)(6916009)(316002)(41300700001)(5660300002)(54906003)(36756003)(38100700002)(6506007)(53546011)(186003)(86362001)(26005)(2616005)(6512007)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pfBDkhmzUnVwfw5vBObLZpsrl+a4dIsvbD0bOzU01usrw23n6SXG0AnEkq7B?=
 =?us-ascii?Q?ZjRah6p8kjMw5onjsNFGL51vJ0/s0z/4FDKqjM3/1ZVP4iFu6we3Uh0+ps8H?=
 =?us-ascii?Q?7E6XO5pKQ4JtWJgoyL49r9sCl4LS3vwh+LTWjoLmNKJVMveSrCKMYn9BCs5r?=
 =?us-ascii?Q?+/0nYDXXDWd0xb0ttSuSI98CWIOciUCli4ZkldibczSPlkO/NqKVtg0uLN+o?=
 =?us-ascii?Q?qqittkCl8OhlphPrcbx1QZcRj2t63fOLCaOYSo2Wkcd0StSTxuDOYHzuiFoe?=
 =?us-ascii?Q?KP6i5CyEo9NQdHm1TPNhag27MlLOFZe11OigTBrOtyYRZKdSqxDnartQzucM?=
 =?us-ascii?Q?odIktV84dNsKJsVrk4GRSeW9PAZKP4v/ez26n0mHqitNd8FiDoVz1qsy3D7p?=
 =?us-ascii?Q?50cLJsZb69qxHgVgmnFSzjVwMFdGKV6osjZR/cZQGOPY9xkTh06jCNhz1Qjw?=
 =?us-ascii?Q?yeG2YrMXKFt7Lv/84WqjRKc3VUIhqxbKpdyBwibD6OVAk+W0jmuEPhsLYKU7?=
 =?us-ascii?Q?LF1jCS82J6qYb82b3PFgENqSutRFsnN4f0+8EpXUeHkMdrpC13X9Ic0t+V6N?=
 =?us-ascii?Q?VosuExMeE5XD8iqENojPJE6rSqzbT9idm6AYYS90MFTE99g73gmZsifv8aBB?=
 =?us-ascii?Q?5QseSlw5+038FEkfAA3eYkuA9yTsIUatT1gJWCzXvzTUL3CwifA0lAXrlE4K?=
 =?us-ascii?Q?blfZkumBf1BWIqzo3UEx1XaSRL4c+YfcNyRa0xpSYslbdKJXHO7XBEbRcl9z?=
 =?us-ascii?Q?0CgDkBeenSFZXdBPjmUNuHkUZeEn5BRa5Dw4FPIFcY1Y+85xgHqEmvCiKlSf?=
 =?us-ascii?Q?cgYcGoLza9oGFR1+F7Zw267YDm9ctnTSFhFv6bs1PZIlcZc5HU+IiIrTPoZN?=
 =?us-ascii?Q?2JIRJSKOLvdDe5EylAMB0hIAXMOlSjW+NsxRS4hzdkUdwYWKeRfAG+2hbKXl?=
 =?us-ascii?Q?hdg0IafP+9GJfjljXFz21bhAg0WI1jTbrwlq4EidolYyQxkwjIuAn8ETmLJq?=
 =?us-ascii?Q?nqf9IlacYRtfdHCLwOwksQdyZl6Q24And5s/JgeJ4KmUKYwr8d9H15FdkGev?=
 =?us-ascii?Q?eTzhQxgV+L2lN3xfJWfe/Ie9F2Qfy4eZdImx6Bqkweqbz9s41+Bi2q/JX/fz?=
 =?us-ascii?Q?ztfvzDWlRmvy5LKDjJ9rSjsPAccxRjEKX6xj+hwouqt8iLaxCMf6T06cVnUb?=
 =?us-ascii?Q?8PLiY5XA16k0ntOcUpcprOYknZlZwjRrVRYcM/0jR9y0FcN6X+GEOaYbpw6j?=
 =?us-ascii?Q?meuyeBumqo9wD1oSKaL0H7T5K6zj2Rw0BsdaBR8dwWze86325xqeTLRREZVV?=
 =?us-ascii?Q?8jg+wGH3nWkKsm5AGwA7NDTLwOWByUbAb+5EYXo3oAegSvZmgFIWeWEHyres?=
 =?us-ascii?Q?cvBugS12gFqlMXHwqtflvamem8TCLE/ZFAHr+iDe4+c/YNyJQerMQ1ES1zOX?=
 =?us-ascii?Q?YPtbadAQ6tUKCsrHGZeR9pekKS7v/p1iD8vOSWVzLf7egXhZjDOrpM44lxL+?=
 =?us-ascii?Q?Odfan/nhLTW+N1g0nBG1IpE0MCPXexO7Mzs7zrMBL5x/WQRg+5jM9I5awPgx?=
 =?us-ascii?Q?Apw6O54nL0IyVFrB/IFhLLQDkoTrMwYTVZPK1zT/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55c4aafc-1a14-4186-a4eb-08db8c45f343
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 13:00:26.6539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T4HzgoKRb8Gt+BGbkq+6CS1vagNpvTZ+Vz7CrW1UndLtIfgCkF5QI5MeKNQcCsqv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5145
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 22, 2023 at 12:09:58AM -0700, Brett Creeley wrote:
> On 7/21/2023 2:01 AM, Tian, Kevin wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > > From: Brett Creeley <brett.creeley@amd.com>
> > > Sent: Thursday, July 20, 2023 6:35 AM
> > > 
> > > +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> > > +{
> > > +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
> > > +     int err;
> > > +
> > > +     err = pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
> > > +     if (err)
> > > +             dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
> > > +                     ERR_PTR(err));
> > 
> > Why using ERR_PTR() here? it looks a common pattern used cross
> > this series.
> 
> Yes, this is intentional. This is more readable than just printing out the
> error value.

That seems like a hack, it would be nicer if printk could format
errnos natively

Jason
