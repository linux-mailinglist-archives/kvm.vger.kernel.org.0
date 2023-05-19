Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DE170984E
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjESNaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbjESN3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:29:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F988E7F
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:29:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJn72qHb5TJq/EuiycHVO0TmpMLNqj9scogEXw8IArgSTrgWyUSnRSkwn6+5YjbgDXsbBI6I7gBfNmAz9PbMRZqEu6lVsaqV8nTm/d37OriIOOBwvki7LM23M6FBBZomWxBMXy88SO3o8pSH56jFl/qrx/XtHSD2MFQhtAq1enVQQbe9vPIv0TmYVhOUCErivThbWhIosnGq/AyItcHcurcRKAKOM3nbDFLXCv+wmfmTdJCFgqJIk1dnxZQKhU1GlEkNeZ5mSNY9K/4SfsOLpb4/C8S39KmDc29TdJnN1Mf8OzCcu31qu573LNQJ4ppYiDFLH6sxpDj4TFg+Eizwrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ElmX6AUznC7MQJUyR0leMmnNABrDXJtOklYHq3grmE=;
 b=Cca/pQSB1ep7JSQuSQHF5mPcWsE4Xt7UStwIsB3TRTYfCeotcKf6VrtA7F9Ha+MQMi00ZF9KP4pBQIkPKykGYH0WJJ6XtuXFsJm0C88cB0FQCrmSp0ZYP7wSAGJekGltlEJFre2Z0Sn6QlcYndzt0mYiap7DJREhQGW6rSxSSt8KG6zqHR9TsbqK+yNr39h79NbdOMm95PsGT1xkCQOBiERzZbziLpIqN35SXBYV8ZUk8CYCAZJaPZFTXvaeTC2CLVTDCiXyou1ArRbbaD1dbrdUVXcner39EsxTUY5/8BSYXVH8bR0kUHhr39Nv52Ed7uwJuWGWdoKSjGkfiVfu5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ElmX6AUznC7MQJUyR0leMmnNABrDXJtOklYHq3grmE=;
 b=YHkxSg9ArAsHbVr0VXQrA/R69l2ZuzH2UbHgooTIiar7w5E+dNM7kZgXK7TBHFRtlzqkqvZI3VjG4zBvGszGI0RxzL0rKAjwDPCA3K5dEtsQc0THuMKJycacuHcvTnFtO4RZSsWNcRq2mqDk898OO2EHVtstLRjbDOeujcHDI7Q1LI5MdFHX6AJ4YAtI/y2LRz1taGbJUzbEUdxgIcPyKTzokz5NOlEOW1Dx/j2/kLKrAEl88RLbGALM4wuBlOr7Ndd8W8Apmb433shLhTceUAV29jhBlrfC/1lxOYljIgiHM0O5xS8acoNRiMWTjS50EYW2h8WgKTfHtnkAUBllpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6218.namprd12.prod.outlook.com (2603:10b6:a03:457::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 13:29:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:29:32 +0000
Date:   Fri, 19 May 2023 10:29:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Message-ID: <ZGd5uvINBChBll31@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <ZGdgNblpO4rE+IF4@nvidia.com>
 <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
 <ZGdipWrnZNI/C7mF@nvidia.com>
 <29dc2b4c-691f-fe34-f198-f1fde229fdb0@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29dc2b4c-691f-fe34-f198-f1fde229fdb0@oracle.com>
X-ClientProxiedBy: BL1PR13CA0427.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6218:EE_
X-MS-Office365-Filtering-Correlation-Id: 486c06fc-8dd2-438a-3878-08db586d1447
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8po1AG/ILiPktzqdPJ9h3xMp4cGoS1i0BOOsNRSDMavXIOmxDJDsNvAgikeX/tGrlX+iwkx0w7/pJUct+1bVBuih0h9PJZR/PHU1hjmFMt4I+zEdBmxutI3IY2Gn/D6641gohKSNXVywbfLfyK2+S+bsSHCsbsduuV7bTUNuD8v3C5MnRmXNWD+xw1110bxMS7N4QDgNetFY852EL53OK2VmpBetlxS5edCFPeGIolHgfzsxxjZmfq6y27TGSKyUQUdztBCSVFQOn3jUlx0LEpWMIklVauI8ANumi4nGNC8lxe4odyZb1F6udqD7gdlrQ+7XP78yW+XDIdNK6ct6P6UdklHFQ9AdUs9UYJAw6E39FoBaWTTWqES2PVkyecfUpWS/HrbMaEKNQ1jjVLe3Vb+d4Y32VKGtAxa/YfN1tKJcJAzxm3UwLx0WY7CVw5Y/xBtFS/s1syjAxFc8msLS6xOE62MG8L7JnaCElR6qKNrsnZUbhkWWUyJm4dF11InbCqK8GZzlbagRR9dBWf7kR1qef6NewuU0h5VFU/5cKeHDE39veN25COghdRGldoCYvyMdZC7A7VwbAJvfnBNqR88ttM0tuAtM58mw9Tc98I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199021)(2906002)(8676002)(41300700001)(316002)(8936002)(478600001)(54906003)(7416002)(6486002)(6916009)(66946007)(66556008)(66476007)(5660300002)(4326008)(6512007)(86362001)(53546011)(26005)(6506007)(186003)(2616005)(38100700002)(36756003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?idY6WBEvb905sVuG6agtl+/sDYO1P2+9T/JYmrlMMmu6+X28Ies+0EHWtQmS?=
 =?us-ascii?Q?NutlHF6SAQ2jcjLoa9XUKV9YxN/WSLxKnF+gB2e1uGSvqH1OiotjqfumB2ud?=
 =?us-ascii?Q?27+oD/Mc6z+10TRl20i6BZPNDyHlHqEwGOFpNQH/8412Z3RFP9RQ9F7VKz7D?=
 =?us-ascii?Q?1dIhMeWFwVkEkae82QVIdGDTt/emn8b+l+jSuFRCgdEfAyuUxCaNsHOwIQNe?=
 =?us-ascii?Q?ThAO2MH/ZpuVUiZzE7VydvyrmhLq4xDj4tE8CCu/oOGLBReR6Eobls0OLbsh?=
 =?us-ascii?Q?AsRvA4UZqlTnJiit2DCQLX06KatJ/jfgKu190k0XSxqsJtOPVgG+xyfWhNFv?=
 =?us-ascii?Q?Z+qyx7Hllmo+Vv1pWrF7AywaCYT9Y29IJJOxMIk94ZAJNfyd++YNrI8boeGz?=
 =?us-ascii?Q?ASrakLg4FWodehUD99cYW21CVqfNYm7eZsl+GSmgBSuLUyw8Q6WG/idiOEYb?=
 =?us-ascii?Q?xOPMuxLxO2qkO8n3vM/VxpY6SCs9I8XGuAPlU3BppspcP5py9IzjDpe3euQG?=
 =?us-ascii?Q?RcMy+g927by17sdZs+hpOh3Rf/rbSq65vVi36brHhPNIhKVGReYNK4NwZ49p?=
 =?us-ascii?Q?SLMVP0u6LEW3EQoqCVTq1IXbyy9DhSw2JmObpG9La5P6vtQpMJ7rU9YPpaUy?=
 =?us-ascii?Q?i4hVjCQQMQKRV0PDTxPEYqooHHh6Gc1Rt39N5I4VGuvBJKiaDAvgQ7FKE8px?=
 =?us-ascii?Q?xD8UVFJEBlYb/XBfYHteg02ci7kxnf9f2QXYfwmPzMnI7Hnlbp9EflasLgoC?=
 =?us-ascii?Q?YJesUnoQ+SeyMi+M8zmyx3GwJwI5mmrVJrv122fPZeElwaHHJ5MCP3Nizy6v?=
 =?us-ascii?Q?pp0vFz7KusUVfl6nVseNbk4QFb2Xu+SlM9eL928t6jHV8tjBOmYhBy5zCQ9Y?=
 =?us-ascii?Q?4d+pBUPZUpNIJrvKiyd5YYUvFEpIJv4XYzwR4eHx9t0jOacYMK1xsoDuM0zx?=
 =?us-ascii?Q?242CNbrGnYvOUstGxHrkE6gq2un817BxI9QgWWtn690pzMhtixvrJNaz4tlK?=
 =?us-ascii?Q?9tbHY1ltlHfzGuLi5AusoTNAfknlGcFqhcPxS0/2Zm4L/CliqzxWlwZJbfjC?=
 =?us-ascii?Q?AZlVDalIb4pWbcWGcVRFrmJMHh7VqEhPmFo3pWqvp+7nvsz9i+xH+7njY543?=
 =?us-ascii?Q?fIjHTzQ9cjnJmVWOEl0HgBmYy+5lgXcIG67uGaIlrUGW1Q0mO3vbaHLIBfQI?=
 =?us-ascii?Q?EcRYThDy+i1clxmVO0ytzylvKf52sA3ssCO20gU8tFAXaTk+4/Lo51weE0ho?=
 =?us-ascii?Q?47QBmQ1zreiFcZxuW15e6nOI24EHC8zJnIJp09i7HTmqP68EKrjUolBTjw9J?=
 =?us-ascii?Q?DXnMbCjE/WOBz8lqoVNzv10v7cxSzL0yRTTEJoNCpGtoU7WlQUtiKfBbZL8K?=
 =?us-ascii?Q?NhqU0LpJOgdqUBR+lXAEkp3RDyVxGOl8kFAxE/J8nLBc/7oQNE2mZqNQEFdi?=
 =?us-ascii?Q?e/Jmtkh1xJLAp8BJEMeshP7J/vOvfnqgX/yOzVkfkfUZJMW+Rh/7losh40vA?=
 =?us-ascii?Q?GFM30o2howRbknAtY8qVaUIQiUSmqAZFadexBngdaFUdki8olOwt+CNIAQ78?=
 =?us-ascii?Q?NkJzGDV/d7Pxj/NPprdIeeTmD15kkhOVrPSzghoJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 486c06fc-8dd2-438a-3878-08db586d1447
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:29:31.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FqrZxHz344NUsvbyh3CnEC2IKJ31tkOPzwoXzAQiTu2aePo9dQMhvoQq6hT95cML
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6218
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023 at 12:56:19PM +0100, Joao Martins wrote:
> 
> 
> On 19/05/2023 12:51, Jason Gunthorpe wrote:
> > On Fri, May 19, 2023 at 12:47:24PM +0100, Joao Martins wrote:
> > 
> >> In practice it is done as soon after the domain is created but I understand what
> >> you mean that both should be together; I have this implemented like that as my
> >> first take as a domain_alloc passed flags, but I was a little undecided because
> >> we are adding another domain_alloc() op for the user-managed pagetable and after
> >> having another one we would end up with 3 ways of creating iommu domain -- but
> >> maybe that's not an issue
> > 
> > It should ride on the same user domain alloc op as some generic flags,
> 
> OK, I suppose that makes sense specially with this being tied in HWPT_ALLOC
> where all this new user domain alloc does.

Yes, it should be easy.

Then do what Robin said and make the domain ops NULL if the user
didn't ask for dirty tracking and then attach can fail if there are
domain incompatibility's.

Since alloc_user (or whatever it settles into) will have the struct
device * argument this should be easy enough with out getting mixed
with the struct bus cleanup.

Jason
