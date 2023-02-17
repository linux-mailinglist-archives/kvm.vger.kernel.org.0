Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8D669B00A
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 16:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjBQP7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 10:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjBQP7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 10:59:34 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C823B85A;
        Fri, 17 Feb 2023 07:59:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVotyfSIdQ60TiFXev0lk4+WevmvD/UYYFthtUFb/UHMszItg5hmiJSUruQ9FC3vTZWe2YXqqBYNRY5z5vpUrykFFtjNjeqzF4otLGmp1JD34EIWROdFadV0DXyIfTfRI0HmpEXKWbM4ZfwKyTPVQW+1mTZx8C6jmNk0s2oSNKXB5cCZqju1objnL+JfN5yZUjUmdYQ0otzukrbMLhInbIz9Gxyvdky6x849fwou+rXB7ZivgyWT2ww4zpFhgaBen7tz0uXTHxM+hLrUx9A9JiiRZT2dRiltCNVPmxwh6UAUqZwY2tjX4Ea6iO7cYCCUSpEmJYd1qp7tMYJqwiuQYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wm40sVRxgeAxtQkYolrQ9vXt0qcpEmLh5p2KbTEghSQ=;
 b=FXrmVWkJWbUlY86U/MTNKMuNbZpfaDBBOPJLJHLQZIHmxzgCnXXF1MAcao9e+ZHskssknQHLuZxV6fApN4wlKdArZoNw8eJI1ZTQcMILtlitliD34jmxwMr6xc6xHXich6jKKER0wswpYvsc4VAdqWSZ59Usqv43WteKTR7iJvrfeQdC7QdJWMuBe/RdfSOSExfxwrNoxOl2Yi6IDLJxoEsoNKuIMxVWGO/Hp5wZmOewFSBVedFHrgVYfljfO9AHxuXCiTO/eDuBxNMxuWTx7e1rptgCIO2UrdyMZkthn+CM7CHb1CMP7ONTEefLOzhIOshqs5m9gnwZJe8ufDgKHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wm40sVRxgeAxtQkYolrQ9vXt0qcpEmLh5p2KbTEghSQ=;
 b=CPBkBqXzvzalFN3sGdycbculBtc9sELINX+3tQXRMAIJjQKDRvWY0AzyIEneMQ+7kchSfcb/QFoswpmieJV3i0gJ44CxAcUlfqV2mq9UyqBFxp606DQAaTcl+kEcZd6woXsvdM6G6Du1fKRDQavZWT6AbNmgYgOy/1dVmrCEr4Qxp26mmGQplyV/csVkSaCC6aXvp7lWjlN2YnPD7tChLvZNYL6EYra26dXidjcJoQCdJyqW9J1Hj7Z7XPzClytJ+XTshmPUxHu84dwvjL/hw12gNO1tBtBUWD/ldDH1QbMchNfhKuSoAx1L7huu31IgKqOpH5+lWTyE+NREyug/FA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6914.namprd12.prod.outlook.com (2603:10b6:510:1cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 15:59:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 15:59:17 +0000
Date:   Fri, 17 Feb 2023 11:59:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Message-ID: <Y++kVGvMDfOrNf5b@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com>
 <Y+rLKvCMivND0izd@nvidia.com>
 <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB7529028251B2DFF28A3CCD00C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB75293D6F394CA6F255D05159C3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75293D6F394CA6F255D05159C3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR19CA0064.namprd19.prod.outlook.com
 (2603:10b6:208:19b::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: fa2ca6d0-afa2-4d07-ad9c-08db10ffec86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ttS4IF/kjC1A34Mp0GgtXziGeEGfzf8MWXdQDfkzh6lbdzWttJK8uUFKaVDVK8mdHkdjLetk8oy3PIySOgHGkpXs8aNIeoAW1B8FF1lSgGE/P/6CY/uNCuftBT1UOojjzbTzCQfNEhRWZbuSsqUHpbASMxX8gZZFJWgvpb9EJn8NORRDBgGWRwIK0s6L9xshdMPOOeH1Rtjvx5lGi8Kdrqc62dTe9x3PJUyg/9jvKPCZDwgT8TKtmjvjOzNbsqxjJiyJOGTkcjWSDb+DTRuZ+xLwwBOdIplnBDWeIz5jliaFJLGjMX/0Me0QASSJZJNF5wWcWy0/zr+06wno8jb0hqQ/dQ8rhMkWKaBrP8MFUo1eDGuzIyqp8s0OUZUQsFuM1CgxolAnrBwYdW2ob0bGQHS+3pGBpeyUBHWKMYqgl0AfgOdvymPzG63OWnYLuuvVgNzkWy9HYrzVB1Ek2kT0XPrs7ou7nhXxUdZzvHJGGurwaI64x0WY68RRDlyPNERcl/iyWqYKQjIeg+K97qFosiS7ZXbflRubyaM5q+MiBNBClORMPAtYFlWott7mZPFfXLsjPu3RkQKbNVawxw3pTcab4O20Lpt+jN17YFI0zG+W+tbSQbqdE8nOmcDewN6bOgSpaeoPGu6hezedOxtoSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199018)(38100700002)(36756003)(4744005)(7416002)(5660300002)(66946007)(6916009)(8676002)(2906002)(66556008)(66476007)(8936002)(4326008)(2616005)(186003)(26005)(6512007)(83380400001)(316002)(54906003)(6506007)(6486002)(478600001)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qsTVf6+nYRGf0hzx7VI2E8C+ZUElYIf5JmIVhGPJ1c/mLgNJLMCkejmFdEOm?=
 =?us-ascii?Q?qF6W655qaq+U3aHk3pvY0iOH2nUaqP3cK3FiyyirOfvGOsvS55zUD7GUbq5/?=
 =?us-ascii?Q?tjqeNmAk0Qjuuz3g6IvninoH2Y695GNW454SjxXE0jlHpbddVlvpxFnQuoaJ?=
 =?us-ascii?Q?SMnvS2Xdpp9P6enkUmyG+IWl5VSAlT9dIYbEX78fYHo7EThN852iTIhGuwCC?=
 =?us-ascii?Q?4jU0PkjVNfbvgfRrmWTdYVviOyltVrE+DETi4D2wwIwckDIj8iwIKepJxYz+?=
 =?us-ascii?Q?bMqCFupfbFgHZz7N888fyMvha8WvpdVxIErAG2EEAwvkLAOXxg9NCA/258E3?=
 =?us-ascii?Q?hlF0ZYxQtstLknOdXEwAS+Dac/+AtxKlRdwmPn4TdBcOLa2x5/UGuoII7CYy?=
 =?us-ascii?Q?ydc0KZkPuXfuglL3SmGN5ULhNn+TSC6cgrWvOP5m6RaAnz+E1LIK7ZVgJisU?=
 =?us-ascii?Q?kEND32HNm9Z9oqNwAhuYb/eadk+O/bx++vS35AFYdAqAnEkbU1X9jvbDOU1o?=
 =?us-ascii?Q?J42zYjvnkodPMQEos7AVLHO0l5Sf3Rsku22kBJiOTNccJz07dFyGGcLYyBL5?=
 =?us-ascii?Q?20SDyN5Y2AQuzZy40hdxF0/yy/dyOkRWGgl7plBY7l9qb/gar3t9p4+CMfk4?=
 =?us-ascii?Q?FuvlokEG52qN5+MYaxYPsirKbRlHVGIyrvagvYairh/8nDyqpFdwP9fb6YFp?=
 =?us-ascii?Q?6c3kwXk/UME9XDwLY8nS7ToviiR/GZ6HQk/0mO811estQlaGen02p7zTWORk?=
 =?us-ascii?Q?Di+v725yMUukkMpdltUaFVAkTgmPPU0cMut8B/zT12j7rGnbQkXh5vO1iTic?=
 =?us-ascii?Q?nvPl10lubch+BmuniImUyDOSEGwiENrClFCEEWEFu2RSZVtGAWwlcQvK87W5?=
 =?us-ascii?Q?YLPHln8XY6Uzlq+5PPw6v2LJNCXJrRTD+ILf1RH5KGAgz8nH4fpItpkjcRUj?=
 =?us-ascii?Q?ucCeTnwV0LmyLgv24mgyPNS75QXCFP1wJM8xi+BJ6EUxEWNbSZ42ETLkao+r?=
 =?us-ascii?Q?mqGEWHsdu5DotAQkZBooM/5/jCg137kQTiePgLTymiMMPqtmAbFfQjZWqFT8?=
 =?us-ascii?Q?p3rEAEuZ07OCL6WptGHcqkMiPATl8NfHOHZWmBEk4Oh2HfGV9z36z6dksXUt?=
 =?us-ascii?Q?uvEa+1Tn6p7yrOBouO1jBqGfB4lvJACpA74vrAqFrfD2XtiLivip/2aOcsQG?=
 =?us-ascii?Q?C4tLhqMCBBL8JAy5PrRPXFA3wpJVageR9L6cjEMqBe4yXN5EucPSIl8pBivQ?=
 =?us-ascii?Q?aL/ingezSBl/e7UISm6QJU3pe9Nq3macyMmyJDHlaG26S0+tTIxqmf+0TMLt?=
 =?us-ascii?Q?gyJFUIBWIGC4B7FZOS7QlVt0gmY8fbN2T8bw7bKoIHGbK6r2Gx2gvcdgodWf?=
 =?us-ascii?Q?4bSG1ZhlxKGeYJjzV70O3h7jxaXwjMRYpZXZTJaw6fULJQTEXStPEDabVDFJ?=
 =?us-ascii?Q?3yhAoKbWEydqCGZyHAXNgEcBISQJ3DAmCY9uggBoECAT7yvhCh9p693bYDfY?=
 =?us-ascii?Q?TH5OpfxnApYVYWNlSNXRzzACeqzJnpymugD4J8V2jbwHc5yRQxRDqJFikBUW?=
 =?us-ascii?Q?cNPxtra3A/+6r38PTjQQFtXGlN4WGQ8fLQ2OlUXA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2ca6d0-afa2-4d07-ad9c-08db10ffec86
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 15:59:17.5573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqrMb5ef8A+r/dljKzOoN3+K4yz0vITjdOPc9Z0mDEETpkep4yZT08jkQoQFRcd6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6914
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 10:55:08AM +0000, Liu, Yi L wrote:

> One more thinking on this. For a single device, my above reply is true.
> The device should have been fully-opened when its GET_PCI_HOT_RESET_INFO
> and HOT_RESET path have been unblocked. However, when there are
> multiple devices that have been affected by the hotreset. User may only
> have one device that is fully opened while others are not yet. In such case,
> existing vfio_file_is_valid() is not enough. Shall we have another API for
> this purpose? E.g. if it's cdev fd, then the new API return true only when
> the device is fully opened. Any suggestion here?

I think what I heard is you need two APIs, one for pci and one for KVM
and the PCI one requires binding to succeed.

Jason
