Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0106C4C19
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 14:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjCVNn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 09:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVNnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 09:43:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902F624CB1;
        Wed, 22 Mar 2023 06:43:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxEHYR3eZ8sS4S5ASWY1LtyYDyFVc4x/xIXklh/J9itfwM9SyV5TYfpbphGf9Gm4cb4bwk0/jEOVeH4kfIt3H9y9e7doFlfDFDEphxRA3gjU3A64wUL+OjEG9BB8UKtjN82CmhDfG1JQlsh4mBz0u+m9tAjgQgWPCL63AruapRd2+woPi3SXYwq1WpPMuKXOHofrdDx+smxK4GWtNSQnZwkY75W9da7+kDsbwZYVpBs0Sr2lrqD5queeDP0PokeOzbAWPl5Rjs5u5h0DdQL53LeC5u1ihqZ4JU6wvkoz/B+dvUNHpWOVHLBBUhs2tKIRxvEPNMJvN+exiD1VUFOGEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49MTJytHHUnDkPj5i9b0LHnspdiBi6MCuxBpY3yRoqI=;
 b=W3SiRU2SfsTYNChVXZx9JYTS3vTBcEQuX0pcUieYKdzP71giqGaWcQfPtOUiTEvHoznpXVw45P79rGJM4XQlEwBLCRj9irMzfODHBYA4UQQzqVmRogszj9+JWs9BmBuCSmDvocCngwwuew5LG551d3VwkuC5uOJBwWTOXLe5n3wk01aXy58AfmprB+V8Sr8xHv8ycO0N7LJ4h/T5T89kj641crZ95T3tkzjdcH8WOgiMetR3TipWaVkqscnHxn413+/LvK2ppE2Gmk/Jg3waocU4a41EcMOmUmXL7Z3VSevJBHMPj357pd1VsCOVXvunUtqqo9mR5TbOYjct5VJtwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49MTJytHHUnDkPj5i9b0LHnspdiBi6MCuxBpY3yRoqI=;
 b=clHnjioSBMi4c5dc92bNuTKQwZPfHGHrfirovsoYsuX3ZfUd1/9il1MUWKxDLG4uvbOZ2ysyQ/pCwoPlH2TqHKtRl8/I/DFEcureXGYKKLn+IZ1ffCVbKGHE674tmOMThHZ9nAbPzW5j92CfwYXua+ONnMGtwgLUFAm5AokU/LNdv4leYIXhxerxtKdyvvotXj3i0P+1ZT4eY/PQZxtasv9wQMHExcu8H99HgO01onJe3qGc+kU5e1klZ1DAHco9jc2WdocoRuiJrI3KxrCRUSYtoTX7MPKQvf4BbY5c/ous4K+aYJEBQesTF5DTGw2Hf25yJBaroIShaPVN/+Z8xQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5389.namprd12.prod.outlook.com (2603:10b6:5:39e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 13:43:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 13:43:21 +0000
Date:   Wed, 22 Mar 2023 10:43:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBsF950laMs2ldFc@nvidia.com>
References: <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
 <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <DS0PR11MB7529B8A8712F737274298381C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBrx98kqNZs3jeWO@nvidia.com>
 <DS0PR11MB7529E4C6196C8581CD39A7C7C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529E4C6196C8581CD39A7C7C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0233.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5389:EE_
X-MS-Office365-Filtering-Correlation-Id: b9531912-2fe7-4d1d-323b-08db2adb667f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtkSEvDEegw/vIed7ftqAOTJIu6y19Tlk5CxPT1H8lsZvrVea79PMJftz47QBV5SbQgHpDUaXaU1dyw5GjiyihAff/7M84RVyELU26KWoxtUWch/JsBog/KGrEgUgdbe5GnRRINxqZP6VrLe06Bntm3LOAuDiTCe7aS40NxMfO5KSvtAnBHhL7eTY343qRVaRRdRQRrvrpR+qV885IOxB0aob5FfmQ/aHNjbtplgr7X+HLqd91lqDjcUADKaO6/th2GCjqepOfuLD8f9PL8XNYfvSSrzfQMQDfbzO6HkjyRcaAAfCctdhoQ5Hy351Kg5p/ousYT+bCQVgsBBYGcAlURrXLMQaxjkV57qoYNzUDBxI/WPsTEAl/s9oK9YnJ8UOQMEfoJDbpxitQkyr3aU21xRwBg/SKaDzoOgwLNNf32KuFkGsxa7YTMtyg3Lbw9teZhvFfGP8x4PjHG+WBjB87p1WhqcRCNfzbe8fzY7aLsdM/ugJuTxiQ9ot8s+8aHJQyl+uGZAoSrXwdD+3X9cyluWwopiMpdh6aUVMUYq9gzeCkJlNEjtNYgNahQaUNhLY7WFFeWTnyZiAvGKKuRCGN+CvAT/LMZQzrG7YskrXLvl2hppmQVTZ/DoH9Huksdq8qOlbwfFWe4K06OJRAABmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199018)(38100700002)(83380400001)(8676002)(6512007)(54906003)(7416002)(5660300002)(316002)(66946007)(36756003)(41300700001)(4326008)(66556008)(66476007)(8936002)(6916009)(478600001)(2906002)(86362001)(6506007)(2616005)(26005)(186003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nytQ2lsrNtFox0/YuSIC/DqZCYycM6e97MdlAvhcKwtS53u3E6WLWpi3xZBy?=
 =?us-ascii?Q?MTt+rmv4gQCO3qfxKE1g4xunDeaEhAsQAXI2tNjLrEehs4rlFJv6HDrRlLjR?=
 =?us-ascii?Q?jKB7kRkdQtet4ri93ehaHp5CIZMexBroUzt1Sgo+DiHqE6qcFMBgkaVUP3CX?=
 =?us-ascii?Q?hkV0Ee84k1yuNRB2YoBJjHw25U8nkp7wPlRGgD4J3hJmFR0L/7uOuZHi2m0s?=
 =?us-ascii?Q?6itdhw1PC+UgXOyJVGdud74pLZWXfQ6bNBVylF1D/7C5+YuW66/AJZFxJMYb?=
 =?us-ascii?Q?dRC+InfM5Q46xV35IlVHzU3aanxjD++wS3jjdjl0N09Tg1399XxikOmgcdgX?=
 =?us-ascii?Q?ulfTMg6u+O7PHnqkN/MWWqXzArMq3m/RHP0tqtOJ62nA7DIZvrfabalVaPGf?=
 =?us-ascii?Q?tk7gUwRuDnGmEB4mdcUqF505xkSqupufqolkGoxD879lxjb6ZZBPGfqiqgG2?=
 =?us-ascii?Q?lpFupPzjSpFwIS40AEukhBd/l+tNXLSPcHm+c3Fk/oX7tGIfVLg0idHnhUTd?=
 =?us-ascii?Q?KnMqCvBSgopKjUFRmwLMJN8jakrVEVMEd6wmNaRDUVg7wYMv2iID3ho2I7LP?=
 =?us-ascii?Q?28cBVTrMEN7FdaFHmZgk+E+Lu9X4PPG93HRXpejGFPxgvMFosMooLF0GTK+n?=
 =?us-ascii?Q?GI5AKD4EooPn87G85x96NR/J2pIIds/4iOaPESXoG222gR61/oH6oKWdvhrY?=
 =?us-ascii?Q?ZcJbKcTgVso6fwQgK9ATkKdVRES5PamkgUw/AjdNURc/CmnB+CDsJRK/55jP?=
 =?us-ascii?Q?riR2BUXbqYdAV5Klxr6FJtmnErQ0NyFPFlB1o102EEpIjO0gK2xXMO9O7CBz?=
 =?us-ascii?Q?zSCJ3KfrjGc/cFUaYQc754FEpW7t34Us9nGKwrWGdQhEwiZUurKlOOMZomQW?=
 =?us-ascii?Q?UEV36R39f30GUIV0F8+KBhPh+ZJ3OX+Be3YV2lYJbg7htyaQ/yB66w5IWyDL?=
 =?us-ascii?Q?drTCr8mw+3SWTNsKmwCvE1rhFzbHAFLkY8rZ3n/V0CMKSRXN2lY/rGAP5pJJ?=
 =?us-ascii?Q?0Vke45oj0KfDcKRv5R1BPvXYf648+cm071qDoZ7JFzFPgmtQ0mjXmBaM1sYf?=
 =?us-ascii?Q?0oQfiTmyzLM8J2gpDR+qkDbAU9xPqnrkLl6LPWt0/2/dlc4bOTqbpqZb2TjZ?=
 =?us-ascii?Q?/HRwRDjiLe2dpjqMXiRDtYaArNWOPHhnhRYA/UA4FsLuMCugzXkhWg2XDFRv?=
 =?us-ascii?Q?o6pONJfujFmv7tl6U1Wac/mrF6IxtEP9webY6rxV5xqQpYCg/LABeM3Dvpim?=
 =?us-ascii?Q?koiMIqR7gBRPo7iElQyDhHLjN3yE2jEWFBd4EAB/Q9FJeG4nv2paWmZALVY6?=
 =?us-ascii?Q?8oYzZGLgBGvaMpDbjjfweh2TAERezYFr93A8efxGkfYUdutIne+Rvzkhtts7?=
 =?us-ascii?Q?cqG20QtV2z7XOVesZEwkHEAVbDoeQ7oS5SzYJg8oagUkYfM0MMUdkPO5+6Cy?=
 =?us-ascii?Q?zyv+A2gA+HixFEYIGsYFCa+yN0ZdnU8vDUvD1rberGZCpIgIW6KydUBLWznV?=
 =?us-ascii?Q?HryH1EI0jl03erYlzPi8dqVipmZCiITj521tmmIeRDzPt05SZzx98Qvjf8rS?=
 =?us-ascii?Q?+hagqnquWgk6VvJCJ681ugZ4em245fFiyh6ZKU+0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9531912-2fe7-4d1d-323b-08db2adb667f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 13:43:21.0434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RQXWz7fGDBeHXJ93C4GTiw7d3t85WDz6AQSVgUhkpVZ7yc1um1MKT2XkwYaJixIB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5389
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 01:33:09PM +0000, Liu, Yi L wrote:

> Thanks. So this new _INFO only reports a limited scope instead of
> the full list of affected devices. Also, it is not static scope since device
> may be opened just after the _INFO returns.

Yes, it would be simplest for qemu to do the query after it gains a
new dev_id and then it can add the new dev_id with the correct reset
group.

> > I'd probably use similar logic as the reset path, if one of reset
> > group devices is open and on a different iommufd_ctx then fail the
> > IOCTL with EPERM.
> 
> Say there are three devices in the dev_set. When the first device is
> opened by the current qemu, this new _INFO would return one dev_id
> to user. When the second device is opened, this new _INFO will return
> two dev_ids to user.

Yes

> If the third device is opened by another qemu, then
> the new _INFO would fail since the former two devices were opened and
> have different iommufd_ctx with the third device.

Yes

qemu should refuse to use the device at this moment.

Jason
