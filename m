Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF004E4468
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 17:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiCVQmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 12:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239208AbiCVQml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 12:42:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A4D71A33
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 09:41:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iV4Ku6lTjJHRX3TSYdO4vWlZDRi2nmUaEkG8QotZDCZfKKqweCSfaOxutbzRbf+497JoiJ0bp45e8Y6TC54ON4gOkoMZ+uGQQ/nEtWMCJ+E2CBgsocLlAMpX6PYGzS9MHG8GgPLMBGp+SsBRfltj39Ilt+VT/gQhnrSLWf5E8wKF3r9q4ifYpbe8sDm2jhHdlNL9/+8D/ybfkUyvChKDTolko/Pve4WaRM8Tj8qTZ+OAoNa+3+LoAmKrgZFcHpniO0zJOpDwpZaWE+JHKzjYcVH8I5fM/WdRBobvcsAEXrhNB13hu/bU2Jyoz4cuqmTGYvsB/kZhqJZM0z8YbUvZ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lblBlbecdhrAr8AFw493aJAJ8/fH/gSLh0P8bVxiwjM=;
 b=XRtgkck5/ufHTl4Vk8/HPBdEjkMjDDu9s/HK+w2ixK7mPG7eYDECVKubjSHZbgMVU71DnjPY3s4G7oAXCs+P3gV1iJefzGf9OXLIeSy0edvPUSNGaUKh3pSEWvgWomhzzvqKp4z7Z3DSldQbB9H306ZkeZ5M4y6kjzkAxZX933nN2y2HSiNukcLlz6me1t2BKFwyipQVk3P7tpmPOdiLpq2v8MysN/JyKXuq/FadIh5ZSZQjBOQVfEOpi0gzUILiufM2DTB7Q/8fUaigHO09F+o/fD6Kx/rzj/tpDVBNQKjFbGNadcclf2sr0DSGXFql65s8NqpkIhnEDxYO2eOQQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lblBlbecdhrAr8AFw493aJAJ8/fH/gSLh0P8bVxiwjM=;
 b=dfI5/FA+HXIdWjMnR7K7LcCDnbOTyeCugeQqQL4HZBGiLKmj5Tcm2RXmLaLkHROGqWm5hfokpb+fhMQcrjB7CkZ9oZ6Vh3doIPCZ9jAaBXRBX3tf3zPO/69YmPtAUuHTsB0LEs/RiMV8b0hrElANtabDX2MQ75Jazuld1fCHXnNXdF5FCKvg+iqs//3bW9zPrbdDCTONocXxfkH05NbTfgwVBAtKPA2gGRlogzw7+Xfo3sSRht0IhVHdz/zqkaISAOQFbJ5BsNGZvRtV1RXEE94av30L4b7ffr7kdAK+Z1igv/XjFuOIuxTi74lXa+EK3JDHFettu8pqOTOBnBfw1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB3782.namprd12.prod.outlook.com (2603:10b6:610:23::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 16:41:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 16:41:11 +0000
Date:   Tue, 22 Mar 2022 13:41:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220322164110.GL11336@nvidia.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com>
 <974181b0c01513293909d56844aa58c09c5fa166.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <974181b0c01513293909d56844aa58c09c5fa166.camel@linux.ibm.com>
X-ClientProxiedBy: MN2PR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:208:23d::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6774980a-7123-497a-dbe5-08da0c22c5f0
X-MS-TrafficTypeDiagnostic: CH2PR12MB3782:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB378288F0A63D9F26C4A9BF1FC2179@CH2PR12MB3782.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rHCyEDCFzMpGjgFn9pAJqopT5fMx9f+PaNUOA2ABCaY3n+pTt8TGe/sJYMsZnL+T+KMgzwjzfee6sfKBXsqOyyLu+34jttfh+91E+wRlpm9Bx5FZxRL7gzscBjAUJ3M3iUjHxqhvh7IeWg8Qa3DEHa2iEmuBUZ75DahF6YImzZlE5pv1Bk2hcC3WXS+goeK83lCiqI+Lu1I9gI0w9fogMYMG7uPrI2bLUQ9noVUMwfOvIsWU2/BV6Pj3m8CdbfDFpyj0JmUGgSoio9eUMgAyUvi2yzs8cgMSLJJnvG/aDV+X+DxrfeZwahp0nevn+wDPeNw0jrYYuA4IPNKHE0eXaNBs/fZSrTsSWChnvlMg2dkZ1sYSHEIgMeqtNA1XjnMRShrEBG6N6tgyeLhVmR20Og0plY1OO69ZS0wTNkghRHsDZjDd9zAdVrTgjcNsPxGi57C7KoFaFvGn8FbCDXDiWNsv+9IHSmSKTtUmdXX8OCMrU6VmdbjUWFIeYerHD1QfXsOZJhVUw2J5bdN196cgITIPYyFieS0j7I2FbKlxxJ35nmTDFbR+Bp3Fm0w+8deCucxrQybjTRGcjniA0ny0DOOMVuJQkl0Wf/sS+vhTyljwcuTdJvGm/WnDycJCZ3T2x2PTdGOP/u7UtXlFUJ3vIxXb1LZ8mQog11RItinTkHYxVXIdN0qxUMuBtj0d9iC8/EK5SJSx0jYYXDwVkDOhgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(33656002)(86362001)(38100700002)(6486002)(6916009)(54906003)(5660300002)(7416002)(8936002)(8676002)(66556008)(66476007)(66946007)(4326008)(2906002)(83380400001)(1076003)(2616005)(4744005)(508600001)(6506007)(6512007)(186003)(26005)(36756003)(367364002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yVkOq61IoEdWrnF4Fzn6PEPFiLAnDf+OzhX0zkipt2cB1db9aQQLLD8u8a8F?=
 =?us-ascii?Q?em7Qc6aZXVA/XKuqog/jFg5b9LNnjNW4anUyjQhlk/mz8OtQt272hOaj80a0?=
 =?us-ascii?Q?lX0YOrKbbk4RG+E+FnexJl0RBVCCpU/kiA0lpY9e2jb+eCtxZwzQlW5x8oJ9?=
 =?us-ascii?Q?L2JaHTpqZH8SLXyow0z3M4w6nofUzhIfW/bXGRs2mRpiObPMzkTZczwLmw5P?=
 =?us-ascii?Q?Vk94NGp6wbiuPGON7LAM9BeADUfzLjbzn5B20rxGzwxeqkkHwf835BI2Ae5h?=
 =?us-ascii?Q?GU2qsRL9z9VCtNjYbA1LWpxgQDXXobJeTbo4eA8sWuCwydO6a59npqI8DWBx?=
 =?us-ascii?Q?6al7tuOl3+ZT99l2WbNrssIDRIIzta+oH5ewudjnT/PgBSbXBgYKRa2fAKJY?=
 =?us-ascii?Q?evrefCkN/ANzhDPdQwakEI/rc6jKvWc+lmmNzopqr0LvGO9QN4SLvfD9REae?=
 =?us-ascii?Q?WblmAMvwKgaiejwlRM4sPg8bsxT0E4PCEMV8dhJnAkoRWva9q09lki748MQ4?=
 =?us-ascii?Q?UI8Biz2QRf9a/u4cwKQs9eDet6l460Hv4T6N+L9xGTCW51VhOZbkCnC0MPi7?=
 =?us-ascii?Q?gU9IkauOpMyDuKK/oAeXBiqEpYD5n+5snjynQqIR2X3N6o5kAf/zxbFahXXo?=
 =?us-ascii?Q?j/l4t8FbbQnT2ZtbtLhUV1YOINbcXzPUbSDEovdC1VRxtjU4wJswfcCgGgvT?=
 =?us-ascii?Q?zkVyGmC7lFBjNVWh9uaq6rYtucJH1xBjza6eI1cWYcMlveJHnQGO8k7kUuHF?=
 =?us-ascii?Q?CQ2mUzi8vwEXzdo2lKlqpIxa3o9eC0Uws8lCYIC0ie5nXk7Rmn0IjfMqi6NV?=
 =?us-ascii?Q?a/kj7vkez2Lw9d9rB28V5ybwZy0TFZqG7c+5WsXUmi4/VeLoGmm42lzQnDK9?=
 =?us-ascii?Q?Z+s4ey48YcfPRfO7uN8/ikpEr/XgHOOa6HIUXQVpuFoFlZGUgGovdUjVQch1?=
 =?us-ascii?Q?2U2G2lOUDoYNAsss4ptB7PUEM4oF0erUB0tnODpD7ZbjRKoQZJ33tyd9k8ok?=
 =?us-ascii?Q?8m0BS0aJVxrL08BKSO6SsUqjcFjfiMzvsgxDPaknQOrnau9Hl889oaYhvdS1?=
 =?us-ascii?Q?erJVTTdcD1fybqdAfMprrhGcpK5HuWPWGnMpwEnkuGKWW6ha91RXHcr9LtCx?=
 =?us-ascii?Q?YPS+1mI2JsTqNZgPVEcY7zKXNC4EcbehCo4RGEBM7VJXv2+SBG37BNciN8TZ?=
 =?us-ascii?Q?fXx44aPLVMF+6gi84c2T++rxvP4OtcV6HWpy6t7iyQmJ3lFUJyTYKIEDrYek?=
 =?us-ascii?Q?0t636kU3jwD1rOKnPrPBHjozthFdTz/sUAvGsdRQlf3cloBB6I4iZf/Y1tWY?=
 =?us-ascii?Q?GU8WzqkIdNXgl00RHuOVgNnNE2FXIkqunSlPki/3EUITlDJZI6yTHYgL+wST?=
 =?us-ascii?Q?DBZdIMcnkP3jcoj61WBTzT7Njx/2GtYYgVUMG15HBzggwc4WpvFAd4Bg8X+w?=
 =?us-ascii?Q?xxDkGZYR5c1ovaas5P3/E6NM19xvnz7I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6774980a-7123-497a-dbe5-08da0c22c5f0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 16:41:11.6601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4V16NyZfJgwBGHTKE8xw1XNFPaFqDlTv3jgGD+Om5ZgQtOg8aOOKz+IhYln8TwP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3782
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 05:31:26PM +0100, Niklas Schnelle wrote:

> > > In fact I stumbled over that because the wrong accounting in
> > > io_uring exhausted the applied to vfio (I was using a QEMU utilizing
> > > io_uring itself).
> > 
> > I'm pretty interested in this as well, do you have anything you can
> > share?
> 
> This was the issue reported in the following BZ.

Sorry, I was talking about the iouring usage in qemu :)

Thanks,
Jason
