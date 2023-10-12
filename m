Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B207C6F20
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 15:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbjJLN14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 09:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbjJLN1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 09:27:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCAE91
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 06:27:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxMX2N/OZQ+Mjdo1XW0WLEDnmz4YZytE5rzGlghEBCsm07XuKfqXiggmcAjVjgo18OkuwJZbmDAm87FCFDBv/MGsBpIAIDVxKzmTbnZdY+XvQEkPj2gv4Gx143j0vGPdQsLYcp7sdePKBDvyaQ5nvWQFMV+hm23Dx5IPJu9UthV/xAAjx30W+jz+rMkTCp5KWstZvxssN3cbYYFv+w6xo45TrIfrlZogz6eYcpAYo3tUbcgc501ppgldGbFZSZJcgY4D7sUBWiFRTeZIogIb2tcpXcNhv6cxuvtVM1RdEBsuTK/ECoLKfjmLdxWq0NH6OGyBLvlL3q7qh3giLY6shg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zh9VwQngV/GPsouz4mlqSKoo2NN09Pj8arzLWuN0NjI=;
 b=U0yAzY4lgPlOo8tzpyx4XYqy4az5aCKPFnGpWoRVlw0mtRWldc8WZ8v4tH4KWu3XnVaWsqZRaM6EY0o/iaCZEFpsfS1HBumn4XRxWL6Kifbn6jjqqiTAgD/Ry6cq18C52nYEIfPx0XDI4E79EYcXLQkE/FUA4SVw5IcdVVDvYtW3bMq0e753Cl0ZT0pv+eD0WSDwZ2CxTAr5vsBa3xyLvUa6R/B3zUABIwbLUY0oIW0Gpda1mmxBQBExGnQQMwwOgkpOOhSXpLmwsLKTmfNeMNLps+wKS4F5fE+c5OYPfQqAdExAun78akwv2UN+OJIqY5qEcIOyDMrbfN6MlKeHBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zh9VwQngV/GPsouz4mlqSKoo2NN09Pj8arzLWuN0NjI=;
 b=s2kp9ibWfUEJwfqE6DCdI2LOfJsi0X924wysfmUryKw5dwP2AIkV2FSMV6m4ySMSyWl960dK2OO3TzS2dhYVxXFqyWTC+zzt9h5RnYgYjYDwZ7i17J62obSy3e48CUhXpcuTXvKm/1seftGVPMlK4caF4gUWWiuNC3KufaTmzhwA+XSkdlw6ah5WaLD53bRBOPc+qJYtKhQVOuotom0YM4yIT2csmtZW6DdkzFlMWhh6WraMj68ThDEgHxQ1aUaO1KDP4TXcsLUIhP1cVauG0N9x3quP2dFI6T3R6S+zrrDTqmKV+GVdKXQqgI9IuvlLnaYvWvCT+EIeN9ejDYSGMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5811.namprd12.prod.outlook.com (2603:10b6:208:377::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Thu, 12 Oct
 2023 13:27:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Thu, 12 Oct 2023
 13:27:51 +0000
Date:   Thu, 12 Oct 2023 10:27:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231012132749.GK3952@nvidia.com>
References: <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c75bb669-76fe-ef12-817e-2a8b5f0b317b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c75bb669-76fe-ef12-817e-2a8b5f0b317b@intel.com>
X-ClientProxiedBy: BL1PR13CA0363.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: f2814f39-ea82-4d4a-ec7f-08dbcb2708b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IN+LYBJzgLezeHwIK2RGiL7UV1lRTnHF0nLJ7Uy0X1aOBDSCGI51dtvwUHYXzw1mYu5l266U2C2HVQbmyG2O9ikhop2mC8uiCX7lWpg+lcBz8aFELsNEInWra3pU0PuqDedq8/kLk0rlCkIdc9cEtNgJ3/1xZlDiJUN/gLsPrrMRI2HwTTz4J0di2cmjA3AoQruSsOgwSkIcXF6Do3KgfGOqG+Qc62NUE66wPuy8kRTuc4ca8zmt71OdxfFHoj3NUbK0rL14IUPIuPXSTEWcIkn+h8LJBswZQh5UJYJA4tvPUS5fW28DlnE+Bj1c1yYFc9kLgCecEK8yww38bGMdwZptVlBD+DXPmisVXPDOLtYmPpdLEKMpwpoJ7iJWC3JHdbtNOx5jL/zHWbbkjAAO25xA00fD29xUk86SWdBxSxKrpg56m3+LBl3k4PDtPnOqiE50l8pqUlYxRHtaI1GVLRSxo0lWDKw+j7IvIsEO6wgr1ugAth8+2n+/jt67YcBr4QgmNc2RHWqN6o/zsNyZgr5280CV+qzahKrmK9oKRAlwzFT9LA3K3cm8HDBfIEHj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(376002)(366004)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(4326008)(107886003)(1076003)(26005)(8676002)(8936002)(38100700002)(33656002)(86362001)(2906002)(4744005)(36756003)(5660300002)(41300700001)(6512007)(6506007)(6486002)(478600001)(316002)(54906003)(6916009)(66946007)(66476007)(66556008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X3cguscC9jSIDdZbh4iYV3WcA7Vi2xd5HUyu6HYUu6IaakfoiNwzdS1ZleJt?=
 =?us-ascii?Q?PyCEQh4zNmNDHoBy4iFGGUj7RB03SO0RDXAYT93ykgY8NpHYvAU+yqiteRYj?=
 =?us-ascii?Q?nNgThnpQ7fij9g+bhdh3j/IuOTd6uuxDJ3ewLdGPefbdG8iJPjVTjnciSqEe?=
 =?us-ascii?Q?+wGJUDFgqE28BkFvdVQyqD7C6eo/1PYLb9Sq88xWhb+qFb7ykxsFUVhRWAFT?=
 =?us-ascii?Q?oy+9rK85AIsvgg65yTbT+DgmbMGygDAYMjYV1XLwSPf6dQ+fHMYsw6c9VDa/?=
 =?us-ascii?Q?IQ1KSyNHNmER0a/XSvzkYI6+lnHLMA4/O+E/l8MBgr4SlwpmA34nYZF14lg6?=
 =?us-ascii?Q?nSiOTHRoKBFRhdfEuFaCRooAkk4AHt7Dn9t8hsZpAZDropKJbGBWHyVhNjGe?=
 =?us-ascii?Q?yWZIf/gpmfve1OuNRKwMI54lKlm1oZxc53Xggngz9GNM3du1naIh48pQeNR5?=
 =?us-ascii?Q?D77NK9pkLDboSveBhip/jE+BGToXD2G1btgfRD42fVS6Ro5yacgbfEPGkJts?=
 =?us-ascii?Q?oeHLKVDHgVQb81xNdVt+W9Bc9oVpSIP0rD8G9vJn0tBwDa9e+jA+WX0dF1Ek?=
 =?us-ascii?Q?tJkUWMVTZsVsCCfZ/rX/+i29/1ovp19j03H+ywGPRnfjd0r+2U7YvTqurWhM?=
 =?us-ascii?Q?5pXIx0FukatlyVEZQ+E3xafY+NnofS9z7RDXoiZruMoP9drD//69ki61+7cB?=
 =?us-ascii?Q?JmjHO4e2PTGs0GCyKCKdm8FwmKxxISSQSK33XnckBpgKjheI6zJhZH+ypPNK?=
 =?us-ascii?Q?YBvifLRCuFET6GqoImtQg/GgUAsQ2JcBM8zTe9QPWQSdupqgVfXyNP/c9k5B?=
 =?us-ascii?Q?MSaGOrxkzA0LanbrAk9t7AMgG+uYsHCJvOURXHn0lEuky9jgziCTgj9cTtmL?=
 =?us-ascii?Q?cII09HV12swEi+MZcQw2h7OggOFd/DX9bzolqsVLT0aNUHcuQ6KEeF4GW2ac?=
 =?us-ascii?Q?sHXNqUKLDIyKpa9o6AaNMuaIpFKSq+xeCMRHIPmppxyemKOn4JnthD1RQaFL?=
 =?us-ascii?Q?mzXfozvwHB5VPI40p6l2dcdVf/fMlkuGpls/IF1CkcJJ6JOpJ4jpBnjhV0Cm?=
 =?us-ascii?Q?4nnCsclipoTnyCusI5S8kCtceeb9MZasQelbwUwosd0QDh76NIEJ007d+Pev?=
 =?us-ascii?Q?6GKpilOYmnPcR+oOfjmRXSbeREpddtfQl1N5WRvNQWbMD+3t1OC5NdvqKYFI?=
 =?us-ascii?Q?PAAsLCq6UKThnQkgF08P1mX4tHk/iEEvNZkd3gzQNbYToqa51ONHHo1tvi+U?=
 =?us-ascii?Q?h4Ngwb/qumtjM9m7AcUikj80Xhxhe/xD8stL9s4lI+RVu9zwAEwRSbtlrbtX?=
 =?us-ascii?Q?flgud9+14RtUvASXIYEKZUDgN+DduGndFjXsCG6DS51W8Nu6hwp3jwZ4WOfX?=
 =?us-ascii?Q?uRn5MhYar4hxWW7mIM4EstyUm6huPIiTSRi55anOZry+MZkD0J7VKPvmsCuv?=
 =?us-ascii?Q?UI8soircx0+7+27eMynO5gweNnih27+QVbqKExoGUHmludNj7X8q6LBALQZe?=
 =?us-ascii?Q?ZUzQD1R92JqScA6nxUncbNnhA/ykkcLGMp94+IQ/1R2BqlCSZhItq+dI/HCb?=
 =?us-ascii?Q?CUarGNGn+/g/HIdroPA+MDITvBsXLZ1hAhwfKqav?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2814f39-ea82-4d4a-ec7f-08dbcb2708b6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2023 13:27:51.4871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGigrs1nzH2ufMDa+nl2RhF4NX95hBlodf0AL0ENdMZl/4xE+e9v66Q7TBnqHoB7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5811
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 06:29:47PM +0800, Zhu, Lingshan wrote:

> sorry for the late reply, we have discussed this for weeks in virtio mailing
> list. I have proposed a live migration solution which is a config space solution.

I'm sorry that can't be a serious proposal - config space can't do
DMA, it is not suitable.

Jason
