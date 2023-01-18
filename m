Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81183671F19
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 15:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjAROLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 09:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjAROK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 09:10:58 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E5556EDF
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 05:52:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBW3ktitkLYsVCAANdLoiaxbkrN8fG8XAl/GTFbZi+hvpLGEz4qKNiHvtS8GH1Ofz7gLjj+XRwosHNpmU5LFdB/aAyxxrjR6DfNvQp4swnt6pBnAtvKOVWAGOPgaUAd1s18EqSXKVG51dtB+qBnrpQOcnCmI8ViAtLiCDoUJJDnONJXRjAgxHBlC7u1m27ivohgUoJueiyszEpRdGSSxP6M9v7uzFkoA/TN/7e0gGzT6cjy2M1qLig0i7J+sZDg8grfXyMjEdETLdVMU/Pw83kdElUgRaTW6/tKXibi8HKe2Navp9LurDSOKBGOrUI6HqugqwW9MA13OfQgvQYVq4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ihmZ20ZmGKBz+UUsGgcmvMIxJXxnBGE3yDOIQJXays=;
 b=lQHEYJqR0QHWN53ZpRY6gUUJoBPKy8Cmtv5Mcidzl45UNmEo55rkYsp/eEBMh1Gzh8Ks/HBUn63Qlo6e5C4YeeNg5MBIkWtyrlBmCpookmHsKbVWdasTRB85IaFG/jQ6nXd2C8++/MlZxdByQh9qSb3jQnfN/Y62jvTwLVEpnZ8DSiuQIRbrZoA3w36vpzmxU+YE8u/I0jnpEZ9iBbhY2j4ITAaEQB84mJZaVAFVn+WOytVepA+06ekPGuvpuSNewwWVxZsyj4wx3XzoaA68CPVBYzSwsanDw5Bibyjqa0aSD3k06IDvRqObYSiiEq/YvQ5jx2HW6eoPmoT5i7Rmvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ihmZ20ZmGKBz+UUsGgcmvMIxJXxnBGE3yDOIQJXays=;
 b=aZia7ocAA0RJs0kcK6gjo0AyA7/vy+VyRaFnwP7T02MIzOiTZxkp0T72NkAvpagtt/tfn4RBnv/fG0iDITIdqPe7dWiq1Pq8GXWRpPzADUHZV83d0SSZyc7DIenEtTYLJXj3LdCzKVplpgSnxXGcPIFlIpbukCKonbHJDKO0JxTCXs21jZS8smltu86JFat1cne3Na1oP7ZKg6FZN98GNOZgTtL17z5buqPpNjqXM3SrYxfq65w1WrouCe6+ofs0r0ENxKv1EW2YqkugUqTMrnZPKFjNA2rCwq2155Q6GmA8wsPhxF0o14PvwfaQnRLXq9EJvZHXp8xdNXfOLISkTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8077.namprd12.prod.outlook.com (2603:10b6:208:3f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 13:52:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 13:52:22 +0000
Date:   Wed, 18 Jan 2023 09:52:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Message-ID: <Y8f5lEcYaL6QgiDD@nvidia.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-9-yi.l.liu@intel.com>
 <BN9PR11MB5276941A0F5FD7880DD1C41C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276941A0F5FD7880DD1C41C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:610:b0::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8077:EE_
X-MS-Office365-Filtering-Correlation-Id: e840cba4-3e16-480a-c0b7-08daf95b391f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSE9I1WYUTcg4IH4uudG5UtC5ewKajTP/IAcCCMJQLErHQgx8LySwNhqdi2WgSaqCoDiNbPs1sqROoJuKoL/alRVqFS7ZAzpY1C4uZ5m0gMNgy++aV3d9sl1AXFb8vIUIdCaufws4IBqdX2AdtElWLCQO6By2FTwRcNjjK5V0OqLR7OzogGsI9YoslWwfB+s9J948C7J4d+DEoVmES23VeE7FTVd+bHA1PV7l0jxdvM4s9OJ2zlYVRABjwa2BnykhWTj3vHfCnYknNeOAsRACIEaPexcNGHtfx8oOg0nvAHvq3KTr+YysgAKz/Mw+RTmOqBMd8TvLR9FhgbmyLW9eN2s6tDEU6mogS4VOtULrKW8XIiG+M0Q0GlTANPH1kIaq3/hvbsGuIQ++Np69XQ+V4r1rDI72Ydah3kR821ch44afPBWUARY94U7Pw0efLe5JjXj2CHj63AoDTvLhBfiFmn3Vq+/+VbCOW9j9DcjQyml9JZxp7TcrQRrEBTggXRwp4T+FUsWVnCGRAm8TePpotRs08pCTrg5Vh9easwKmfypoQbQKAN6hB4Uh/m0QVUMXicBSkJBCzzXkDKddU80ML65ctll7bZy+VjYUPvfdLv5E9FywqaeC90Ca3nPz3FDx5RSJTMjxG9npKeYo3xZEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(38100700002)(36756003)(86362001)(6486002)(186003)(6512007)(66946007)(66476007)(6916009)(66556008)(4326008)(26005)(478600001)(54906003)(2616005)(316002)(8936002)(83380400001)(8676002)(6506007)(41300700001)(2906002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XetdL8z4yVS2/nuEEaH4ttxlaXHscWnlTaVnVF7kxQan/0EotWQT+OdZxuLn?=
 =?us-ascii?Q?IaCPnL5p3J8zIU6/dvGUrv1/KKBs8yFG8RWj+v40+UsWYmw8S1IEGrMkvvSy?=
 =?us-ascii?Q?GZUBOqYSbqDeC+lZDJetYGaD2SPDA5/GgD6guGiD5TnGHbcSKyBBrBRrzEs8?=
 =?us-ascii?Q?0yhGWY7rWlDKKFTM8ilBp0BUhXhu97bMz99NmrVmDa7Q2jyyKlK31bDjBcCp?=
 =?us-ascii?Q?pcWVfJT3xz9r6nUre85RuLrCW3y5K5fCd/B1/s9PHp+V3J9cHmwz1t6SjyB/?=
 =?us-ascii?Q?ZhpJKEthPi9cqqePLtN0ZL6Z+2CEEPxAxd0s2pMUIp8m1LCgmPWO5A4a5ez+?=
 =?us-ascii?Q?4W5gPgJBrbqRcQBE6A55Vz19ZfvytCsb17qHePLV75QM5UYKHc4SXIDK7jvf?=
 =?us-ascii?Q?0ToxzXIq3MdLxkF1pH675TutVFbTTlgpWx236sAXeX5rlWAyxgUL7VeHaNo7?=
 =?us-ascii?Q?VWT6tB+P8Qqeomptt3ZdDazmu6Sv6xXVPv0VbrS5/j9wF69GQ2ZFoD/SGeB9?=
 =?us-ascii?Q?CirLT79Ci2jujB+ipXy1dZbv1y8mUbZHPIGdy1k4Pl1qnuS2I1LLip3eHQHt?=
 =?us-ascii?Q?qYuFNR6MGwvOE66KH+wEFHVSm6KVInMJImIKa7AYTnOW7va5fROz8QVvhUy3?=
 =?us-ascii?Q?D4QBouCTj2e0GxL7C6HHYzFx4PilepnfTWIu9Li1FhKU7eQXVaNsICJNa7yN?=
 =?us-ascii?Q?M7iBdYtfvtB8rGKrmFbx5iliTSPJOWcMhdrlQcliP9ZDN4hKouH+6k2/C5EU?=
 =?us-ascii?Q?cNm1JldJ+SlytyERKfCVFFep1Y+aZuoBS+7tgSxZZERSMQ6fmFTf0XE30gRu?=
 =?us-ascii?Q?ORw+hf+usUUazIiyAwGR2ep4VAHape9ez0xNIpo8pmVtbrau2pBgCWIe+ENJ?=
 =?us-ascii?Q?MvkVdNVESrms1jXpYb+c/I5HZlsNHS9AkDFQXNqeLFhgoOJ6SqHJXVZxmcU9?=
 =?us-ascii?Q?djwklpA+QgR6ErUa44hC8el3z3+KlDt9haQ1NM2gqhM/oVE3248NBlD0oCQN?=
 =?us-ascii?Q?+PJVahnNBy7W/IMZv+e0P/SDFof2xSk4vn8cBoFsotrEKJSkfYfk0p6TFeSa?=
 =?us-ascii?Q?HCsK6t9lL4UhNGbrFsvmXmSrqimChnJLhe188hnVaDuTa/HS43GNRRaBTUe/?=
 =?us-ascii?Q?tjx/A1Ar3QRRc7rBT/vsUWX1N1KlLLHPLPOEMyDhWDhchLQlEmP473Z298Nz?=
 =?us-ascii?Q?PqbJMpp28rTnTqsN4A+cUe2CohOmeMxX5KNayuSkVS20gv/HYWfDACnZRWK+?=
 =?us-ascii?Q?e4xjtk3UMNkhG1V7jIkKKxhGLQz8moY8RZO+zu1lCOPdj2bO9v6TWQbL0lKB?=
 =?us-ascii?Q?II3ciQjSk4Bvy27AYTBY3KsHDYKrB6rkB7iRqK+gyzL5AeTIw1pV63IU/RPr?=
 =?us-ascii?Q?4nfmvkQiDl5MiJTI++TTaaFS5UCoWeovHDDU0bpti+erH7abBGfhRhPHGuLR?=
 =?us-ascii?Q?Zjnbx1tmMM6s7qX21rxSZOmqxpJ3Iz8/vienFZgv2o9dCFsJDWZxhouUcRpL?=
 =?us-ascii?Q?S12yNjOK4GlcRMldBHfabi5Id11wZWNjmk4FueqjHcFFkBwF1yQKKCsNY22q?=
 =?us-ascii?Q?qVQGQLEgDMBZ/lGOKGOvuLcyBF8wrWD/V0eOL54o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e840cba4-3e16-480a-c0b7-08daf95b391f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 13:52:22.3297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NCAh5acvAzsxRaF+H8OQwJ0LegEIl9kF7YTIDk/Lia6LzMSlCKwthrpITRgEj7dv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8077
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 09:35:33AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Tuesday, January 17, 2023 9:50 PM
> > 
> > Allow the vfio_device file to be in a state where the device FD is
> > opened but the device cannot be used by userspace (i.e. its .open_device()
> > hasn't been called). This inbetween state is not used when the device
> > FD is spawned from the group FD, however when we create the device FD
> > directly by opening a cdev it will be opened in the blocked state.
> > 
> > In the blocked state, currently only the bind operation is allowed,
> > other device accesses are not allowed. Completing bind will allow user
> > to further access the device.
> > 
> > This is implemented by adding a flag in struct vfio_device_file to mark
> > the blocked state and using a simple smp_load_acquire() to obtain the
> > flag value and serialize all the device setup with the thread accessing
> > this device.
> > 
> > Due to this scheme it is not possible to unbind the FD, once it is bound,
> > it remains bound until the FD is closed.
> > 
> 
> My question to the last version was not answered...
> 
> Can you elaborate why it is impossible to unbind? Is it more an
> implementation choice or conceptual restriction?

At least for the implementation it is due to the use of the lockless
test for bind.

It can safely handle unbind->bind but it cannot handle
bind->unbind. To allows this we'd need to add a lock on all the vfio
ioctls which seems costly.

Jason
