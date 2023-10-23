Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45367D3D95
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 19:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjJWR2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 13:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjJWR2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 13:28:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D95694
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 10:28:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nh9Kg4rn60E2ySHXNWNwzO6v1fhGfHveWimID+fIvLVywZQVvCS/f+c1K1OzCk/f1TLEJWTsnbXqisS6aRH+AUyHKAHhymuwle9x0X35ZMmAQ/IugBL3vI7A2gywSGLERTm0RCck7it0N8YgPeo+Mqb2hqhQyn0o7Cvjhq2rlQmWCcG+gdr76rXzc3TlXdRRuUph09EFE+Rupq1NKKGEN6rm0Evhxrfp5WnAnS27l/tlW191t+3RHP9k1oc8cTsTeMaUJoz0BpIMLBUFTJf6FxlBFJ0Keu0do02Vmmfd/DDkqPpErE6RGBkAGQKQPndbTk6PkqfVWTz5/pugumMb2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=raOdY9HoWCPOvR2YagQ6P3p0IOkK4KStYu8poaMPeyI=;
 b=eg8yu35fXuAMe5F6uPhu4yP6ICpXCD3dkwClj5tb3aj5Fg3lu1i11Zb9lNfBzUnVZUsLpjwRubfbReIGyJCPOGQlneegZI5gBmFQo5yCu6yAh/LWpcUa7s2WSKYIpK+85iMnyHKtyNmJ35abo+btnO9v16EFM4JbdK4pgvZ02H3zE44NjcuaHa8D/Pf+rwbqDbvCOwkiNave/qn7i9bTcuHy3vxGy/W/D1t8OXX1Xq8RyX0EtEeJCQcU4aRqlobbIIZKtXGwW7qomsCX3N/+RVRdaRzSp2jZAk4ZvdATo1ACc41meNH9O8MABYRP6NZeEPrpyW3jEc7TbYCrzl8W7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raOdY9HoWCPOvR2YagQ6P3p0IOkK4KStYu8poaMPeyI=;
 b=igSRdtEIVbDTVfBKdjLbppL1NQTBqqFRb1zB/1QJgqYshS355//wrPKIfzj4gtwIyhJdytHk2PQjrEEwGdW3Vmrzwroa7h8qEaUl/yLoDBtgjNWHvoKIewN9Od3rsS/KPzaJcCzutHhGCxdt5/nmXf/5vTO7DCjFfPziAj2W6cBRKTYUkqMlBcbiazg5I2DyQqlIm9/TpOsjaIAojp4NFtUNMTsOLd7+tfh30Pmk/CKJre6/r+5GLO1thHIcA7UipuybgIRBKTQZ3HSsAetcozb5VpPnY6ZYpkPdd8JNhipigO2c9ROJncWgbwD+TLUbCoQcf7Ru7gomGXuk6hOmRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV3PR12MB9166.namprd12.prod.outlook.com (2603:10b6:408:19c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Mon, 23 Oct
 2023 17:27:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Mon, 23 Oct 2023
 17:27:59 +0000
Date:   Mon, 23 Oct 2023 14:27:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com,
        si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com,
        jasowang@redhat.com
Subject: Re: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231023172757.GD3952@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
 <20231023093323.2a20b67c.alex.williamson@redhat.com>
 <20231023154257.GZ3952@nvidia.com>
 <20231023100913.39dcefba.alex.williamson@redhat.com>
 <20231023162043.GB3952@nvidia.com>
 <20231023104548.07b3aa19.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104548.07b3aa19.alex.williamson@redhat.com>
X-ClientProxiedBy: SN6PR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:805:de::47) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV3PR12MB9166:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a6fb4a4-3ef6-426c-334c-08dbd3ed66df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbkf2KIi3HHa6NPraLsRMDsJduxmqUUoDp0oojLBZ/cLXOljism3pFxuU5rzV9bIe8/6qdcN/LZ7vwa4Q4i0qpj3u2AHr/IxJEaFCOAYKnRxwkc8uZx3sETdFiCPVGTDxWeTK7lhzZIHEhx2umQ1wT4Zp8OX+m2E7X0hkkPYlieazW5clhs/8EbDtJZpeu8YxKrruXH0Kme8gA0raMZh5QEoXg2YhUrOuaz+ALIhfd9V5kC3FPlI3fh23imsACDSakFdaeWq+6GwCkPARnpse9lPkC20+GyTgIu4NatxN/sI2537IOn6JtN8bGI+0S8x+8OmQ9XDcrbypw0F/LzLj9E6Q5BsTsAwB8gk0ohjLmOSoQyRC6KxYxO80EwnR5O35L1v5DxLInqxsvYvvr1CT9I8fX4uD09hAuj/Nwc5k/DUh2RAEP7T6JjAC8j0YnjP9w0P4/N6ECc40E+GveMlr/p6PaYffMmwGTeqLPatEHXGA0ftlEwZxsc7USDpe2gMzfxUOv//FUt9Ptpr8/EyacXcS8W2FmVxfY4WBS6Ek3id9JJ8x8TtaxdUo/gNkNV8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(346002)(396003)(366004)(376002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(8936002)(66946007)(8676002)(36756003)(4326008)(5660300002)(66556008)(66476007)(316002)(41300700001)(2906002)(86362001)(6916009)(83380400001)(33656002)(6512007)(38100700002)(478600001)(1076003)(2616005)(26005)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?13QKP5Lg3m/ikhfPv5vOKqngjwawRBLmwLJpdN03yCabTJ4RtZfrPRPVe0ft?=
 =?us-ascii?Q?SPUqqxU30b+y85moDO7I3qfrs6gN5XRtfYAVx0a5QNcar1ge7wFLMTcwZXAj?=
 =?us-ascii?Q?ZXxI5KzpncAJEV9k7mOPtfIgaf9P2qwu5nzp8kQW90DduZIU3+BiPZsitzSQ?=
 =?us-ascii?Q?akdT/rsVM14zp06/nydp9S4hL9/gj/KkvXjqWtSNNpsN6i7+2H4y45EceBuk?=
 =?us-ascii?Q?n04Xjd7X4LR6iHlSZbAcjJkEHkCQ6R596YR5pKV0B62TvBWgoyBHsb9uYG5v?=
 =?us-ascii?Q?zXI4zI6b/tw1vLVpBXUOLrH+BcQowMQwKgLyszjmleA0Zy7pbsoU+xApOOH9?=
 =?us-ascii?Q?58EwseNjuy1v4REsGummdlp/kE//tlDSmdiRIFaK6giaRdwOO/I8WPxwlMzF?=
 =?us-ascii?Q?JsWZrPw/912W4PQinLa9ZxRIgbTQ6fxDufpsmJ4KxQQwFUhA2z57D/s/ZwDD?=
 =?us-ascii?Q?ykbTj8tUHb0ltBPk1w65i+i6xukToPzJSXMK8hqf1OhMOu1k70N8CbRKkDO2?=
 =?us-ascii?Q?E60zP4nX+j//DyRSTHQ7bYdZWh+EU517m+cW42rYIaaLaGF5QTuDg2FFalvD?=
 =?us-ascii?Q?4ySEwaACBt1YdCBDvR7v7lg831WGu24YxuPkYv5oTWzokKLoeXFsfsbtyug4?=
 =?us-ascii?Q?ecu0ZUAQBokqtTnZk9YSXIzryZS8r+98OftBxr1v4Z33pYx5/POv9reJstJZ?=
 =?us-ascii?Q?v7Nbl3tMWWMzvIA5NjH9BBwZWAKiBfYPT0pxBK3bHY1ghFWo1dCEGYviATpg?=
 =?us-ascii?Q?DjLigJJ3CqRGzirbli/syVAWahAbK/piAz1roSFpewjW8lXQmhW2KWlOzGyy?=
 =?us-ascii?Q?a4NfgakfXT55b6j3zWC6XSv5cqqe4l/fuyJ6cK1I4FR7Iu1mv6qZ4nVJY+Fl?=
 =?us-ascii?Q?RtVk0QKKpB5mxjcKmIGady2aU3MPLKb5gtio0JZtr0sbzjxUDADnSyIsDIJ/?=
 =?us-ascii?Q?zpGy6hzg8DTZ5qOfdbbbq5PgzWZ9bpUFfzklBU0XNrfZpQBUVu/zDwNCgo9A?=
 =?us-ascii?Q?fvLIp9HNyDHMrjXE2rArDxEH9lymXIGmPu94LdIabayGXKyJXNNr9+d6Xnbm?=
 =?us-ascii?Q?A7rqwB2SOKz+rn9xvdB7VAA8MlcZLpXeQnidHS6DsW91gKLGl6AV6g5iPBL8?=
 =?us-ascii?Q?Jou00D6SKtPh9YPRycclgiFZaCQBzHAAHKES7hjxUIJR1e/gJ1jiVhcQ5I8o?=
 =?us-ascii?Q?/M5QA29D11Dz2zFOV/VUA7KBaR185mGLW2BAvVpSLBOozfCSsmZ1FNALz3ua?=
 =?us-ascii?Q?g2yuTaowjVi1bB4I/urC0O6VYo+jfRpdIvPsLE7lVuMFQ1WHUqhZI6c4ywtb?=
 =?us-ascii?Q?cmF9a+T9d2f/DtB3QdnDNM/JMtn05R0wCs4u3AMGRCt2S4domsDGVa4He53x?=
 =?us-ascii?Q?GdTtjJTAvoYpTGtCFpEDNEqsJan9aA1baz7mvoK+C4frpqVU80uYbp3xrnoe?=
 =?us-ascii?Q?8c3Mj+uUlzdUCKGEMthtXZNT6IUwUijlrVwPgecGdD/6TSWdr7ywgQWUvHW1?=
 =?us-ascii?Q?bhNUmh3XfQ/T2LWKcqbY0m+MArRvFngjfkPCMSmlJq0pI67Eq9fxHAWK5LVT?=
 =?us-ascii?Q?Hrl7yjNluxl9Z7NfDXjN7b/x6+zqzzuDF6mfaORS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a6fb4a4-3ef6-426c-334c-08dbd3ed66df
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 17:27:59.1911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKW2O/B1/5ZfVmCxV6xFDMqBCuHogSqN631OBH11KuZe+kIwbkeFALfjBOS3HBHB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9166
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 10:45:48AM -0600, Alex Williamson wrote:
> On Mon, 23 Oct 2023 13:20:43 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Oct 23, 2023 at 10:09:13AM -0600, Alex Williamson wrote:
> > > On Mon, 23 Oct 2023 12:42:57 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Mon, Oct 23, 2023 at 09:33:23AM -0600, Alex Williamson wrote:
> > > >   
> > > > > > Alex,
> > > > > > Are you fine to leave the provisioning of the VF including the control 
> > > > > > of its transitional capability in the device hands as was suggested by 
> > > > > > Jason ?    
> > > > > 
> > > > > If this is the standard we're going to follow, ie. profiling of a
> > > > > device is expected to occur prior to the probe of the vfio-pci variant
> > > > > driver, then we should get the out-of-tree NVIDIA vGPU driver on board
> > > > > with this too.    
> > > > 
> > > > Those GPU drivers are using mdev not vfio-pci..  
> > > 
> > > The SR-IOV mdev vGPUs rely on the IOMMU backing device support which
> > > was removed from upstream.    
> > 
> > It wasn't, but it changed forms.
> > 
> > mdev is a sysfs framework for managing lifecycle with GUIDs only.
> > 
> > The thing using mdev can call vfio_register_emulated_iommu_dev() or
> > vfio_register_group_dev(). 
> > 
> > It doesn't matter to the mdev stuff.
> > 
> > The thing using mdev is responsible to get the struct device to pass
> > to vfio_register_group_dev()
> 
> Are we describing what can be done (possibly limited to out-of-tree
> drivers) or what should be done and would be accepted upstream?

Beyond disliking mdev, I'm not really set on how we should try to
setup an extensively mediated PCI SRIOV driver. There is quite a lot
of similarity to SIOV, so it may be the right answer is to put SIOV
and this special mediated SRIOV case on the same, new, infrastructure.

SIOV can't use variant vfio PCI drivers.

mdev guid lifecycle is really ugly and quite limited anyhow.

So I've been thinking we need something else.

> I'm under the impression that mdev has been redefined to be more
> narrowly focused for emulated IOMMU devices and that devices based
> around a PCI VF should be making use of a vfio-pci variant driver.

I've been viewing mdev as legacy, just let it die off with the S390
drivers and Intel GPU as the only users, ever.

When we solve the SIOV issue we should come with something that can
absorb what S390/GPU need too.

At the end of the day we need an API to create /dev/vfioXX on demand,
to configure them before creating them, and the destroy them. It
doesn't matter at all how the driver that owns vfioXX operates, it
will call the right iommufd APIs for RID/PASID/access/etc to do
whatever its thing is.

It would be wonderful if we could get to the point where the new
interface can also create/destroy SRIOV vfios directly too.

> Are you suggesting it's the vendor's choice based on whether they want
> the mdev lifecycle support?

So, in tree I would like to discourage new mdev drivers. Out of tree,
I don't care, the APIs exist if people want to build things with them
then they get the usual out of tree cavet.

> We've defined certain aspects of the vfio-mdev interface as only
> available for emulated IOMMU devices, ex. page pinning.  Thanks,

Did we?

iommufd made it up to the driver to decide what to do, and a driver
can certainly create a concurrent iommufd_access and iommufd_device if
it wants.

AFAICT the container stuff doesn't check, drivers can do both
concurrently?

Jason
