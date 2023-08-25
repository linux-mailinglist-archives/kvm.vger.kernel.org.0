Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECF7788D82
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 19:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344142AbjHYRAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 13:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjHYQ7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 12:59:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8027CE67;
        Fri, 25 Aug 2023 09:59:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acyD4alfaqGNBSoLTUcAzirAa/eHzBzUf8kfuGuAhOGPwxIoxirCbOYdZ+WuFMAN6Rdkf6yC4wGuXwJHf01SlA03djh88FjhnRbhDu6EZy2IdEI+wvTufB1/MIuhG+8x06dGxNh0lLOE2wfnpLkgPOU4O5pPKMKt1HdGxRTuL7J9XRvRnDClzf+HUliPhzX4zn9KyVh++6QmFxd73WPNSKxikimsczhhF328oxIxct4BjtqXY/eQ82aWKqibDfO71M6EXglW/2AjqH92aCgzMxcpiaE1dXhrWhu7cYr8sdcXKrITG60psjK5Wiylt5Vw65j+q9ni53xzsFrgwEoY0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yahXW6pOKYdoKRG/Pvd/pHcmoW7/n3uBrLduyyZAk1U=;
 b=Vj4RxEZ1InkNYka2yKDG7FCB3gbuR3v4PxXGs4ehkrMavb17SFz7BLcVmp7s6sWLWhHNiNthhLX/eySIJ+7kbKiDczL5gBNR5ewkIm9xND/6hGjnQAWCcDNfelp9COE8JCrA917Lce7ImitLEjhKQWOor8k3h2U+dcKW1OtL0UZsg+GcRCpub0p/9ZSYoXZvCpNxonzTmE0Z2rQDzzX2k9uvNv6slIab10oqDg6K3/YBnmItlejpDDtZkoQLq6BZn1kLedIMrlItEabFBAIsMaeKp6GrnTG8+ce9K0q3MOQOIe/J6aAAQofWRuk3N/1QFxghz/ykZLVABsZEcFoyiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yahXW6pOKYdoKRG/Pvd/pHcmoW7/n3uBrLduyyZAk1U=;
 b=Bkm3K/3V6CnkeM5a0kasdCyHn6dL6m2oIW/MD5MPTvboxX54iqyCJmc46wHjb/wJXbHIksqqfPlXmgcLZQKyUL1J2eqwimH/yP/jDmWcqcv2SkFNE+U4cYoR6Vzt/2GjAhcQt02zKubRMO//NOOVWz+cm1Vov7Nhy1VPWX8LcnAamFQkiJHRwzrcufWFVXf51+2VV0jZmA6i89QnWvKYAzIm0suuQ226qPAU8LhncF72fnOlxahnefqT9HjZEnQilwbyA0F4Pi58edacyhunXlGlub3JMngrr/IMz9SaZiX0OPnwF0tGYlpotbgMDTurqVs1zBR1oGQPFnVn+xjutQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.29; Fri, 25 Aug
 2023 16:59:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6699.032; Fri, 25 Aug 2023
 16:59:42 +0000
Date:   Fri, 25 Aug 2023 13:59:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] vfio/ims: Support emulated interrupts
Message-ID: <ZOjd+7TxunlKSjTA@nvidia.com>
References: <cover.1692892275.git.reinette.chatre@intel.com>
 <7a08c41e1825095814f8c35854d3938c084b2368.1692892275.git.reinette.chatre@intel.com>
 <ZOeGQrRCqf87Joec@nvidia.com>
 <84629316-dafa-9f4e-89e9-40ccaee016de@intel.com>
 <BN9PR11MB5276D9778C48BD2FD73CE9658CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f46f44cd-2961-7731-d5a2-483c9e5189d1@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f46f44cd-2961-7731-d5a2-483c9e5189d1@intel.com>
X-ClientProxiedBy: SJ0PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf6aff7-1ffc-471c-f065-08dba58cad42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CbuQ3CKy61dyzPjxIsNVCokcYGOGlmJhs6FRptklLviNP/7yxKj5CPuMyiSAAlWbWsa1ByluXz26PY9/5gqwHiKz4OYIDTdpoZaBEGwvxWQHptkkM1sGG740Nc+uWT50lkgA6w6lSLrkoR/qxpHaapvXToX6sAXU+YGSVjj9uBsvFngZG6n4tktt4g2swgkNUX7FRvKwtXM0ig1Q2cU2vIXrf+F/1KrdXHuRWv+VqjXAdjQekivmKuglpx7X/HgC3yc2681ss50rK9RS1mNBA2RGQjd1XXVaSFl4MSMPzi/dxSIsXe5+565tvNM+UIbLR/2CoWzcqJhf9qosESq1OD4UchF1H86w0ZchEs2gbs9rvR1MRX+5qOzk8gVarWP8xN8H9F+5ADbtOdY/a17WOIbT3JXvZSI2ZuXBSJcFIGID3jg6g2PHES4DaiATvfb+9NnMpqyPOUf2feROQuUhQhKyPk4h7VAC8RsKMeJEsm7NnLys0LjpmwcigIKpWVyOZbFULSVONXOwn5IujWl1pfEUwAo9g5CSXpgz2/0lW3I5apb+MTQNv2inPr3qvVMURfDO6VUr5G2amWSSstWyKFI2aYjQQsk9mtU2JPHvbho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199024)(1800799009)(186009)(38100700002)(8676002)(4326008)(8936002)(54906003)(41300700001)(6506007)(6486002)(316002)(6666004)(36756003)(66946007)(6916009)(66476007)(66556008)(86362001)(6512007)(26005)(478600001)(7416002)(2906002)(4744005)(2616005)(5660300002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xrtd2nkaj2fHJhM2hjmRvDTukU+vPcm4/Qq1lLICnaV0yyQTI05muIN/TxcL?=
 =?us-ascii?Q?rwW6/5fScg3syNF9yOL5S80aBxSJADX7SReaCJAFJOXFrD4oR6MR1ORPtr3l?=
 =?us-ascii?Q?HPBIWa1vXX6Fm4odM3XB7YyKnDCyMHsZGX590BLRV0aJ7+HuZj6KbUHRqR9Z?=
 =?us-ascii?Q?9b/cRN5Ud+3JYlmK04edSHurjH63NzV4xHz0syWjYLsZSQPxDN7IYhUE6jrx?=
 =?us-ascii?Q?KncqyMIf3SejgHrqDXQNExoY14WOvuphnge4VdcwdpK5jIe5k+ShDG9+eyKy?=
 =?us-ascii?Q?MgFOc07V7Mfr/uurMrcgzTt3PCnWUbVXfJ2aPSQ8SXAzqqmtk2zGYS3ktcs+?=
 =?us-ascii?Q?QBrVSvBl0MJzRILi1pNHvqVAE6rAOMc+8PMiecR7F/sPHTcVHHro1lnTU0dz?=
 =?us-ascii?Q?6NyxKElgtxdJDk4AzMI2Puv1V5szPzdNF88KjDF55INMnIpcSeZFFZhcxJqh?=
 =?us-ascii?Q?GiyiBigIYDUtGlQDaGK+CSsdgRTfP0g5veLrZnnJV0pAFgqee4n9ASe+U0Sy?=
 =?us-ascii?Q?Ah1DNrK4deQCdbBq/bVRi+5fIiTj9ublqp3m6mBinuJUF1x0a0mr00MkednR?=
 =?us-ascii?Q?LJ8gCunFebRIzx4S9zrncYktXyVbVdORTD5AmsI3Zb9z0aGq6ZkYKT7ptvOo?=
 =?us-ascii?Q?5DJ8A6xG7O6I21iMTPzZGpCKevYb+6d4C93WhBk8bxCW5QNuMKwb3/P0dIrZ?=
 =?us-ascii?Q?KwOEEdg1O8pBlFhBcN3eMFo0zp0hpybICF1vTqXGicz9vX/YYz9kOsQuQOjm?=
 =?us-ascii?Q?8eTCKRXi79jGF7dwcanznaTY6ZOCeXSQgB80768MgOXJUbQ+F7aL+s09HxFc?=
 =?us-ascii?Q?4xXC7qNUX4evRpgQ6ImENvPkTi+rE3Nf0KKF1yFeINwqe8JmrSUWDM5lUyCh?=
 =?us-ascii?Q?F7VuCEEQ//tF8NnPZdpw1r8XUi5i1xD6Do7zcBhmGWcus36GLVsNKv+IBP8C?=
 =?us-ascii?Q?jAX+LJijRJs2PBjjeLh+ydmM1SByxfp3xXf7qCrSCAeFTyT9IA2LgBDrbC3n?=
 =?us-ascii?Q?rKYIXtC89NP0HDEPZZX8RAFnRqg0W9DaWq1SVX20gtBo+rH2KAXphi7CKvWS?=
 =?us-ascii?Q?xK9PAc2paBuge5woq/hjf/kFp70SilnE4Hj9toK09F7Yz+x3U8t+c6yHUsgC?=
 =?us-ascii?Q?Bsr2KXV2nIezWVPCVyjWrgjjF40qy1FIUOzbqmde33c0TXJImh0DFa2AYwtt?=
 =?us-ascii?Q?VjyWoQmIEQJXCjCWckE6MEndkvQnwfGJnkT40wZGnUVrwoB8LKD0cc2tFBIU?=
 =?us-ascii?Q?zuBYryd3OSEVWIAbMXA1sjkUZ4tBM0ImMtDX6g1xsevwbDOusBa2/YXp0xws?=
 =?us-ascii?Q?OLn2O6i/DbCpETNYmFcKNpGfScsaXntB5J3900NZ1UJud/w3d4AospKx5+W3?=
 =?us-ascii?Q?Dg8h1wMmht7ky17ui7fZxI0gAMCVp8s5yq6kNqISWhi/kwIgdqZmaxQb2DGn?=
 =?us-ascii?Q?rT2isK7MIU7ICmOtN70va+FjZnNd7exmif7kgnLB6UE6fs4R35UAsH00MUnj?=
 =?us-ascii?Q?dKVmLjE/zcByAxo/937G4saCe96PYIFipzwagMcpO9dsNMrXAHEJKcvCcxSE?=
 =?us-ascii?Q?2y7xOumnszY/ywYlb1eeLsX8UWt9IFmuL58ZdYHJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf6aff7-1ffc-471c-f065-08dba58cad42
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 16:59:42.5318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dNEtHyXQzc+WYGAKzk5sif+ZhOCSpMhCu2DZ2RIkr/kNbEwKQfGOnnIGlnnAHvxP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5995
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 09:55:52AM -0700, Reinette Chatre wrote:

> Thank you very much for your guidance. Instead of Jason's expectation that
> IMS would be a backend of MSI-X this will change to IMS and MSI-X both being
> a backend to a new interface. It is difficult for me to envision the end
> result so I will work on an implementation based on my understanding of
> your proposal that we can use for further discussion.

I think the point is that emulating MSI-X is kind of tricky and should
be common VFIO code, regardless of what path it takes.

So I would expect some library code to do this, entry points the
vfio_device can hook into its callbacks (eg config space and rw of a
page)

Then the other side would connect to the physical implementation,
sw,ims,msi-x,future

Jason
