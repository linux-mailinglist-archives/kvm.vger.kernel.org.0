Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A10787572
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242546AbjHXQdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 12:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242575AbjHXQdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 12:33:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5DCE5E;
        Thu, 24 Aug 2023 09:33:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnBXSaf5JxM1v0ilyuNW4/pNyf14R6E+mrxXYFI+IB0/aUuamTLyV68+H3iOxRHHYN6PsrfO+REkp7xoG4DyifF10CnRPbW3k2jmSWkbxx1vSURe3hZvKu7/uUssQE/8S0GQ350wbvYBsEhmc0QkyB1qNfxYzLcX0NsG7dJur8Vm9bDH9r4z+eywMjgluqzeSfPK0lQKwFC2CEN2kmFQB0cVUHyZmfrCY7Gjg+wMyclsb+TRi9tT1Ww3FxAal3uUYR57rw0L3SB0/CDT3pVe41yxuOZrVaLfVjQIbC9HMU9rHIBozLNIfA/VUnC3ywfCbTe1Z+UaB6CJmEKM3bZOJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXQDKGVxewLqdoLdOxi8Ou8xuVe/F8ye7SoSoy99QMY=;
 b=IaUZqoyf8ZKNUMkcZ80Lhw9wOz6v+G85lsB6soFisPn/QheX3hRO02zkr2TXh2hwhhZIFS5toZAx131zTie4C27Iy+Po5iUHOw+nh9NX2EgahcUic9wsIuOOhlMmIuD6wRFZH3eLBT/OvtQO62b9X06aW87efY+ok3sulI9JYxZ/2u7Hduar7OUR0YhGMD8AhEQi0hjc2FCO7GtocIUBi4NyajFR4m3H8hqromClaHrV6zJEd7B1frnoznZCtb3waS/dvkDpcUbQrgCkr3g6nxFajeDT5dEHS0uoxvlMgKFULsXWL66BO+i46eTxOcWxTC6TdL5bvUyzov0i7b8Aqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXQDKGVxewLqdoLdOxi8Ou8xuVe/F8ye7SoSoy99QMY=;
 b=eub2BmkwmTOdDJB1p1hte1fWwGJtyf1H+eXyZ3C4dygBoJmKF0maZNYYRqpvCREPmWJatFZZI1pW2j4wQ5BjLXpH6e+9Kr5F+3LMoAqm08gJhEewg6r120wXEveZVA8HbX+WcEaaAQmw40iZAqpqaKQcruCDyKOthm36qtzfKBpxRS7Ij1td28Ogd+0C67f4tnt+iFXnBVX0w60d976VUwvCE1K3uNSIwH4viSGuhmD+WG4LvASl4p+4zg+msMkoi+kmUTdgiKjIJAkk0H6tlPL2TMC0d8gIIG6t9Sz4IEqk9ZjnFXRla3JCWxmfdedQ5oSLC98Fy0GarZ3fysq5tQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB8324.namprd12.prod.outlook.com (2603:10b6:8:ec::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.27; Thu, 24 Aug 2023 16:33:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6699.027; Thu, 24 Aug 2023
 16:33:09 +0000
Date:   Thu, 24 Aug 2023 13:33:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, alex.williamson@redhat.com,
        kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] vfio/ims: Support emulated interrupts
Message-ID: <ZOeGQrRCqf87Joec@nvidia.com>
References: <cover.1692892275.git.reinette.chatre@intel.com>
 <7a08c41e1825095814f8c35854d3938c084b2368.1692892275.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a08c41e1825095814f8c35854d3938c084b2368.1692892275.git.reinette.chatre@intel.com>
X-ClientProxiedBy: BYAPR08CA0043.namprd08.prod.outlook.com
 (2603:10b6:a03:117::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB8324:EE_
X-MS-Office365-Filtering-Correlation-Id: cec1fe30-9d56-48d3-cad6-08dba4bfcd03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMlxn58Gg+bbHlekXacwZkJodMOEcS2kFShuabp9tGOX7xrGuywgS1noyFxqNWZtimH8jPAFfbywuOOtxkutWwGJN1ceUyCv5vazKp/QJWfQHLjak81tiOvwXuyISygYNWvJLeccH71/ySSZ49igSHLdMFBjeyMYipqEiIIZt+BSA/SMNGyw7WJaLejzQpZ9lf/BlnEBmi4ZnWZwPbIV/HNp7Iz3BWGcwZrXH9bQWAAI999egVdztFjy3M36FQRBMyaBUa0gCxnkF3oGso+q02SIBuV8PswRLAlgLAfNTfg/2RnFNI8n6lNw3HoClIfIvlnBXII1N2c+JARbMpZGGdOzVdwvBXdk6K12gZcGbpRsmz6Tq4Vs1dFP7k9L64qXv4p+1LkEJSI5/QaYdx5LJrG+M70wmYjPrm3v/NN0LG/wCGVqphe6jKFgvFvTcEbk330tugqb891ZAn7LyxidlY4xRTaIxnINtczfjkPJ6ZKs5z7Y6/0qEBi4oAzlIw3aFZePgUHMFaaAAA4owKPby2GsVHyYHQCYz1To/lvi+NFHqKn3c6srdg9LG5WttaHt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39860400002)(366004)(376002)(1800799009)(186009)(451199024)(2616005)(8936002)(4326008)(8676002)(83380400001)(5660300002)(4744005)(36756003)(7416002)(26005)(6666004)(38100700002)(66946007)(66556008)(66476007)(6916009)(316002)(478600001)(41300700001)(2906002)(6512007)(6506007)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hu1GyGLJGyi2Ql41EiuT5yTDQ/gNjzYOkieee5SvrM/oyXUNbOu6yfPPW/DX?=
 =?us-ascii?Q?/v0Vm33cSL4HBADBrL7znjSygV4yd/CBxGJtnkDPgsV1I34/1/2NBsf3CcLb?=
 =?us-ascii?Q?5JxqHu+4SbY69mm/iVZB4KpfRbP7NcXdiCcjrc/n9R4P0xF2JEtEKq92SbmU?=
 =?us-ascii?Q?bE1hGAXfFsU0s8stvkFvrdv6Yh+MwlnITQsKVEv2sIIN2HIP8SFW9GYZrW3l?=
 =?us-ascii?Q?9dnYINSU3ufomymKhKCNIoH5gTVQXvqTiCyTuBXzAQjjvOcw4O6tm7KoHpJh?=
 =?us-ascii?Q?zCsqYo//foB4roaXL1Tfr6RLF6YXwtDrPcvTr6viz2mdI+mIf4Bin9NzgEQl?=
 =?us-ascii?Q?j+Fob/VR+DIzM0dM1lA2Atf6iKlMbgjcc2xnqBKapeyIlmm2PeY/mY5LBOSA?=
 =?us-ascii?Q?CNAGB1QA4iBjHPeiRKiZdK+OnaHr4mQWpcto/F9abHf77c54MY0PuHSpEJ/8?=
 =?us-ascii?Q?VZ09ku0/bZ123A3BeGjG7SjK7uEDxp+FqFUO3KowNhnFFO50nzoioPoAgN/I?=
 =?us-ascii?Q?wZzOXthjywMIcl0kSLpgpkFFe1vM1q4nZBSKtAo31pw5IECPmzPJI2c7/AcW?=
 =?us-ascii?Q?3zRF51EWOm6AX6cjbg4vaAYe/PydNRJCCtIBeYUijD+X9H/yc0x755sDOuoI?=
 =?us-ascii?Q?N8mqkjA9ms5VsyJD6Uj4HHee2iiA9CLqsz8/qz/4ewX1wmHVihqBpO+xVoyf?=
 =?us-ascii?Q?Xx+ogmTppRyn+eRcZ44zBtBKXBUHNinYPsSrtCNs9IYt9n9Xco9W5rhr2ms+?=
 =?us-ascii?Q?DM54bDIkCR2bV5QF+PeZwO2odzjez9pLwAi8Zmcw0LZHgQI9AN2d+Fb0TZ1f?=
 =?us-ascii?Q?Ma0DG9IaMYYoyoI504tNeR+XAn+HqM/HiEE5Uca6+dClez9eXAHIZdM6KLC7?=
 =?us-ascii?Q?1cKUcRtFnHOhjJ3xqpcHfv7PjRJ5wSCAYEob1IKLBHaElD1K/32yyAZr0HyE?=
 =?us-ascii?Q?dJWoUJdDN6otZDprY0GZgYNKdcg7bvCumLseW2l6U5FiPIsQ+alpP+ds5LdB?=
 =?us-ascii?Q?oYt+94ojGn9lhNW+9BU7Fg7UP1oYw3s9Bx1ZLyiVeuJtE6W3GC1CW1PCVy56?=
 =?us-ascii?Q?N8YNwnB024V2vEzUl3EycgUX5y8kfUNw5qxrfnUi4s0UGS+uLtmMrARv3lMX?=
 =?us-ascii?Q?w6MzjX5a49RTHKnlze4whvqx2ToFeDNRrPQFZqwxf/aqppSfNNqcsd816Esa?=
 =?us-ascii?Q?Q/1dpHv5cxP1BCyNbzGk1jAJqRIsQ+KuaVp6chSwhxj6KneIOC7oVNTJzy+j?=
 =?us-ascii?Q?eQpJ+GhhihwG7eLSLywxVTPEkwEQD8EMwJ1WKhTmFgkLvKtkZK9p6DFEt1Bq?=
 =?us-ascii?Q?NN1YS4a5MvAt+nqxyNVP5Sx5+O9zQUMBJoDnigG8DSXPOvRlYdt8lBujyG3Q?=
 =?us-ascii?Q?Hl1Vuii4mPYejLb/i3o4svJ94vyNdVj12/oGJ3w5BC070J1DGxQQxQTE2Vik?=
 =?us-ascii?Q?mb9vaCHZ+x6QJrz+wvEK1C+bba/YvHIwWAs/wOs6+6GSj7gTN3se4Nd2AhVD?=
 =?us-ascii?Q?au6mxFtngLTrtKsvPCgtz8+iUKMX6CkcKpvY2/zMXlmXpotRkkZ15SdiwxxX?=
 =?us-ascii?Q?53IFEpVxMeuvccHO1k0y+zVEpMBn6SbJ8YdKnSp5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec1fe30-9d56-48d3-cad6-08dba4bfcd03
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2023 16:33:09.0123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zWPGpW3GiyyeKavLIjuoujwJocR81osG6eiTS9s+mgEmZNwMFvELmvPmgZONw9w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8324
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 24, 2023 at 09:15:21AM -0700, Reinette Chatre wrote:
> Access from a guest to a virtual device may be either 'direct-path',
> where the guest interacts directly with the underlying hardware,
> or 'intercepted path' where the virtual device emulates operations.
> 
> Support emulated interrupts that can be used to handle 'intercepted
> path' operations. For example, a virtual device may use 'intercepted
> path' for configuration. Doing so, configuration requests intercepted
> by the virtual device driver are handled within the virtual device
> driver with completion signaled to the guest without interacting with
> the underlying hardware.

Why does this have anything to do with IMS? I thought the point here
was that IMS was some back end to the MSI-X emulation - should a
purely emulated interrupt logically be part of the MSI code, not IMS?

Jason
