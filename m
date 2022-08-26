Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1666C5A2E91
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 20:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344568AbiHZSce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 14:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiHZSca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 14:32:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B628CE2C57;
        Fri, 26 Aug 2022 11:32:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpEtCk2pQ3BK5LyN/xAEAfV1JhapsvNLN3lHityIWSf0mCk6hoYVYpFrh+fbasLAWxMQlo12h35Elauk7cqV/hPB8+s7nbRy0FsPPfuvpPgnZmxqFcOy6zDJkMJft0AWG/lTMdpiRvk+Jxwt0hjODEmOQhA7rz0WcoUecwnEOgqHMha22u1DWhubYiOuRZHueLj7ff3FmRAEwDKNcTp6xkAqlX16OzD4hZ15Cp/Y9Qt471IhwNCYMfyI6edn57hhA29Gp7K87R7XNnJ1D9MJPDmjmHf1/ipjt7JLX7caJA0B/Td+FqZprelwmB7fUcyntIw2u+R8egKv9G1XtSXP3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TD4hx2G/rHcB24m61NRHW6I09EUo2ObQt8P9fMrhLsU=;
 b=dD0GTMcR3oLw0Oo9VuCMeB9uKUXC02e58iYI+iZD0CWTPS2nsmbOnrwdgHw1MGtmUOZcKxhEibqlx/3LoUoOgOc7ie4OLmUkwLBhjz3z7UfRuw/8qhdvCa85R/eePSa+ljH9pgZWIxW/4vQiJuIrta0Czfm+G9vX9N+VbLiq6M5pzVt6WxW6HbVhnl2GkJ/rSpIGseZPUSDf3n/RPqr9ConuDtN/h+WDNVFXJvDG3wXoGrVLLFO3JgAsCgtu9r2ZD+rT0qDfNWL7CvT1Pn8GR2HEcX7DKtybbtWIdGZ7OC49UGqvlwmnEKecHqMCZjzvJdBC5GXKThVim6JY1qoo9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TD4hx2G/rHcB24m61NRHW6I09EUo2ObQt8P9fMrhLsU=;
 b=OpuQnq+a1R4GAsyZfJlvVM3qFPo93avyGmOI7Y1NSxCZ6i4ObcyGJVIP6iGnrg4wJS7jGgKyhWM+lgqpPNpKs0KRrEKOqlLzxzjMC/2qXw/g5onQmY2BKU9xWuih0EOgKlXliCW3EEiqUBh0D3+g7SjckZhXOyg0VFW8G0hKpECCQTbJgwfeSLibuG9xSUKFtERaLQIIP5soK2VnIbC57FRiNE80vjpbuSG091D5XxWNIjxPFx/GuSLmZsv6EQHDOrBM4cYjuxEvOV84l7Y8PUYfkHDA78gDm5C1tQY+oWME7NFMezLB8309gedrbI+SqA9GHnG7i6x6GLdQ48898w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 18:32:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 18:32:27 +0000
Date:   Fri, 26 Aug 2022 15:32:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH 1/2] vfio/pci: Split linux/vfio_pci_core.h
Message-ID: <YwkRurCNZDlNvSyS@nvidia.com>
References: <0-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
 <1-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
 <BN9PR11MB527610FD13AEB17B5C98DB7E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527610FD13AEB17B5C98DB7E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR0102CA0034.prod.exchangelabs.com
 (2603:10b6:207:18::47) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37e25a7d-c5f3-4265-0417-08da879153bc
X-MS-TrafficTypeDiagnostic: MN0PR12MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QPv6k9A6QE2NR+b7oAryPzvzu/e6ITk1KOHzYmptaFExgrTY25adXZ5+MPLkWcAFnnG3n0xfOx3AUxrT4/WDnTcYAfBq2Sw/42JvsLlWhaqcV63pdmGtBfwm+7PCQFiyTcnUkLGF75g57R5bTZxVe+ZRkVQz6zAtjGnzjQjqPsXbwHRU6EWIzxr6cbZGt92xzXEi+emjcxFaFn+p4Ynlsokbr+PIgzVcryHy9iqNRrLENLA+PrkDA30NDGPz4kmorrdpb/L/tA2EfbAOpmjpo4PpJoAMQyGeifhfnLR1wuq6/2/ELJirSUeTVLXeZ7Bq9vpqjSogiUZKsl0ER+dnXPL5VLTtjnJQca61nXk7DjF6q2yM8GdPbZ1ydhWoYdOGErvdR6juyeHSmFRI9Cb6fRTHYECVyM0gIdcaN7gNzIe9/QTT8ncxpyAB61Tpx9oeECTNNy5zWkaJUh0YC6WYtucJuWwxlVZhaTWpX4kXienvOdfmHGnDqSbSjtxSqm1Li+hl9MGePPRH4nLevdAGT2uo/HH8vXE243SrCl7u3B/EuXslzirLD71+qOZAK4uoe6+k5JtqtmTFUfQhe8gOnCDxsG49EE/cAKGz/tS7kplaI1Y9DPxOBPC9wlnHnSd1xquKLQe6vBTSdVbVLp31JD/tTZZkYDS53FaIbkU2+dW2sx8hejJEwuYK9Icw/8EVXifj+hgbVDmlYQMeOR0F+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(41300700001)(8936002)(66946007)(36756003)(66476007)(66556008)(186003)(4744005)(6916009)(6506007)(86362001)(54906003)(2906002)(2616005)(5660300002)(316002)(26005)(6512007)(8676002)(4326008)(38100700002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LfT1q71zsx2CKZ+iS144w/fL9/yEOvJutJuSE7Ny5lFUjvhk5ku/zQVzJm5b?=
 =?us-ascii?Q?FYqInExMCf7Lu/jnFYfrxh/V/bqTO/opXkS06U7byk3AX6yjhGoaOnmEPiH/?=
 =?us-ascii?Q?i30v2Zti/YhL4AQxdnpNMhS5kFr5NkANSeyNFf4jVgUQyOxUX4D7PS4lIZsz?=
 =?us-ascii?Q?MsizlIOYZN10Us2Znp3fpu1VaohQ9hITUFYPDpUi8RshdWW1moifvjnn/uD7?=
 =?us-ascii?Q?9bPhAB06zeGELvrGGOhNffJ/D0HSVjjmfoQ+jrnC2nokajFFe4pCU/SIWMj4?=
 =?us-ascii?Q?aBINwOCN6SIlZ87+WcLBsRGKr8oYhlz3iXNz8shniCSHrXzEcw/0yzTPw4zk?=
 =?us-ascii?Q?Z9uKFjC3DPUoP+7Y+VDIzZuXxfc95OhG5OwqA5294WNBRipeT2jubhptt0Qb?=
 =?us-ascii?Q?ayhz/iVxeKes+NfLeiG3EuatC3Pes43ZrkCJXEvVo6Zuc9C2QBSBKy4/fg8n?=
 =?us-ascii?Q?KjEZbUp+fgC8fq1E/2xKuj6lprFFO7oEETVcsefzvYwDjWWiJQNeVFPLa+ra?=
 =?us-ascii?Q?yBYNGEKrRLfedXRgT23YTrTvENgKN4AsNZ/Kmkk+Bz2OR8Huycryh1ar9NRa?=
 =?us-ascii?Q?8pHE9TqlrnqmWmBYMxIzzoCdOqxxxpRXPHvomiEVUyOSr+3cev+6rvOEEFFA?=
 =?us-ascii?Q?jREV4BNOX3auIMjmzRAKiEqZZ9tvHpGkp8EszKVfIhBEOL6/9tIUJTgLfx39?=
 =?us-ascii?Q?GUzixWyK/XG4CnFKg3ZMM/tkFyffNDHlOvQFMsFC8NxbtQ1Oq55SMrZ5ghkY?=
 =?us-ascii?Q?ad130aoC0SdACpVJIOdi8eUxlPOL9ixzrP9utNQSj1WwE4jXXk5wHF+mali/?=
 =?us-ascii?Q?lN2O5qALppnKSLLdBRqqFS2i1pO7ujan6DYEjYd0+EFA86Bd0b9pMKCQfVwW?=
 =?us-ascii?Q?zbfUUfkc9/yDtsMhpvndnD6ANbd6PaM6gCnfnkrs6HABd8/aTFrB/dR3v8U/?=
 =?us-ascii?Q?mnkvQkWs7GOCn4JpgqfulV/TzYfbomDoUYhkNRQBTdWvXiFLiJtvzkhzdrpt?=
 =?us-ascii?Q?jPQ6pTCcoxmKpWRsaIrp1xC5RSi3lcZfN51QpsTuAuM/Tgxv9k9OsSWMfovf?=
 =?us-ascii?Q?ZfD3BGvQxtvNyO/IeuWSwzCHolqxVwNy8+4S+V1lZi1l0DRcRZttS/9cWFuK?=
 =?us-ascii?Q?On6VJvioLdt0MMxAIxsdioCMFKicTbygwSGQ5R01M07lkNYGzMX/mIlWc+G7?=
 =?us-ascii?Q?cgAErClcAaBOhUHo73WFe/z46l9DNH61ZMjX0C2xfo5eYek6nrbuXw7NeTA8?=
 =?us-ascii?Q?pzY1jN+x9ioPaDHEo+1dH/4R/9uwmB+Fw7yV1EiB1zodB0hWoB+D0kA8Kr5W?=
 =?us-ascii?Q?mmp/rNe26HbvgmqgJyvdo4vwqGUcZm5lj+SBBlikuuiRJM3n6WcM3zpCYyBu?=
 =?us-ascii?Q?SnsF4NpF1hTe5oFpXlPohmvdyD8H7403ixE7xa0+GrTII7/0BqOxUOkd5i5W?=
 =?us-ascii?Q?ZEYpwKIGek45qPATecHlRiOjgArq5p7be9ZGesQb4+xHRyxt6cmhiuf9aBoy?=
 =?us-ascii?Q?VAQyX1JIfcjQ0BZdfgKNmeIlGnS3soGNVIhagWGwCqZPDvPiaXw7WzLLMuss?=
 =?us-ascii?Q?U00ogtIdxmC7rVDRoqfMRalf5lyY9DfN6LY5Tq/1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e25a7d-c5f3-4265-0417-08da879153bc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 18:32:27.3683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXAqkQ13l2WPMkpz7KbJ/nqvoNh0FEr5YyYp3LwD1+m5vgkiEfQH81ovaFEANnPq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022 at 04:22:17AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, August 17, 2022 11:30 PM
> > 
> > +/* Will be exported for vfio pci drivers usage */
> >  int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
> >  				 unsigned int type, unsigned int subtype,
> >  				 const struct vfio_pci_regops *ops,
> >  				 size_t size, u32 flags, void *data);
> 
> NIT. This wants to follow the convention of other exported symbols
> in following line i.e. having 'vfio_pci_core_' as the prefix.

I added a patch for this

Thanks,
Jason
