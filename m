Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47D3503150
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbiDOV4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 17:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiDOV4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 17:56:40 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1968437ABC
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:54:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDC03ZUVlHKRf2zYCS8R/Mb6M9W5x6NSxEt0xEQsbrbQsW+i1UztuIgJqpQy51lG6oJ4B/7qNXfViQvz0ATlEpxDo/yKi1MaTMmEFB2yoAIZWsYIE8EOmEzxEGt6irUAL6okmPtYgggqvvxyRCG/YXJ8tH24oSeXqWr7uWAKt7QCPZ7CPiiF3nkF4nFSDCk8wkMImnyQHUEdwW9EuYGkbcNmmpbTd0cSieXjgGJGfFH+052seoMojM3Ljdt3WJVjFnNOw3ixmZiAhJd4uIjeFtL31YMtbt4m4swTUTRhCiFGwb6timjk7qzee+UhhecS2pp38CEeTc1SVukIoM8qzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNrqlDV6Zq7WJpUwFdUrctXLOQeU81k+7TcUdM3+ljE=;
 b=mQL6qZOLGqjVbu1XyCI/xU3EUG3H3Y8YLmRan9avTzP+WwQDITQlFE9TqLfbPsE4YZyohwsH2uu4HJLgxUesVeLbSgu8oX6QpD6ngXpfLmB8Va9oMQ/Fl233uOX1q0b2znV5O56IAOR+QtPli8ZR+14cpQRJdmmKk1InEwrH9rtjsacNk1gfaJyKW1GVy9XapJmh0D9prz7uZeKEMEd7uKj2tzLssFuevQKCsVLbWskPgA1pEbxaDhkZPIrYm/8fv2ePWEUdYusFh5bnppAKQ5jFmo6uAqdqkmzNhEH2saYLxca1Xl/wHMiKcUjSGI1ltuiWD+beBDyMX11O5eLbTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNrqlDV6Zq7WJpUwFdUrctXLOQeU81k+7TcUdM3+ljE=;
 b=fBdkRHlMiyO7zyO3d6MfZ43DDRftNVDFIupxhcJoz8teLUoFKpOUabASCc4gvOMCSWKB19DWRqKSumuzh3LiGnYBDZvwH/ZaTg1M+bDmrsTbUmh7YPiIQVvoIQ3IjaTx3SjOpNyaNhetum2f5FeFfduSrDdIHpluNWA8DPbkZfkVFDAVZqZXfZQH7YQ8832VkMwQNOwKDrlLKeWkmAz5V0Imt5OFLWxaJQLXXRwxLxEtyrMzUhglN/rXBRKPPo0etvrf8o+qtzc9YUzYrTm4iIm5Y/IndwtJ51W70Lj3ax+Bh+9I3+zivkdFwjYiiJPEQ85xXC4r50SSz782koZWoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Fri, 15 Apr
 2022 21:54:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 21:54:08 +0000
Date:   Fri, 15 Apr 2022 18:54:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Message-ID: <20220415215407.GM2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB52764D80F73203162C8E82268CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52764D80F73203162C8E82268CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0032.namprd20.prod.outlook.com
 (2603:10b6:208:e8::45) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1da0077c-148e-4c5d-18b0-08da1f2a77a3
X-MS-TrafficTypeDiagnostic: CH2PR12MB4198:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4198FAA5289BC2CCB1EEB411C2EE9@CH2PR12MB4198.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9+xMJaS+FXW1s8On3YntJb3zy5vEYtU6JwwIo6qfaJWEewUoin8OD/vGRhUH1ikkQpFZgZaUkPSimlY5c7Pgqzhtng/UR++/PU3OyIyWKUH86jKrY8O902peq7chOCpHa3zrGj/hDCadXWkjTZM5toCwCmufOXwJmrZREKxkokpO+hl+NQnZ8zds0V2Ei6Eq0wDyRwWD4kcYiM08472YL4YLS2DvUmo7R++/jDEtaI9JFacjCQ9CEp+HZbu5GoSzwFlmrrj5u2BWPa+qJfkWEbR54uFgm7iS4aeGWXJGgM0XmER268hvYJXr4jufFKv8tYx/Rsx2fGi4ecUJw5m6ml8En+A/mcjYkfI1V12bo+K99jII3c5yUTER/IElLS+QLnWo0E++314/IikNCCHfJqoifgU2DDrBDMbnH3QEny5a3ZJSMrYJDCaCqtlrm91L5sM8+0n1LHQ2f0/mhhOK/18JBbnmmOA+kpk7II6G0VGNXIC/QBXjWNtxxBm3MVdvIzDsXCtFvh3iNIZ9U7yzMKB9urfBpIglcOxR1/bd7eqLUs72I21K4b7xP10slI3VPRJKLJ7pKRGLeXzAa1CI78ra8L86aIdZCk9fAvNmub5nXRT7Ch3ZIsX+A2MPg3ji5H9WEqAwEqo+TxVyveHTdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(4326008)(1076003)(6506007)(26005)(186003)(54906003)(2616005)(6916009)(6486002)(508600001)(6512007)(316002)(66556008)(83380400001)(8676002)(66946007)(66476007)(36756003)(33656002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aP3gLDiuD3izqltv6f4uDNWBR+eME4vKvc0MgcT0CzcvxWoE7pTiUutI2L3y?=
 =?us-ascii?Q?WiujMMV61lWZmxiZHjVxkz85W8pfdI/jNB9o5ifwjnNL9sRxMylXSMqSy4vJ?=
 =?us-ascii?Q?0uxrrZBdKvAtJRZJIxLsfOTxZwJuaVt/FGxcrkK7+1n78p/2a07WMo7YgbsE?=
 =?us-ascii?Q?BKN6GEDKDytQ95/5b2fQcfcKdf9lQdRkP8yqktCKkP2Rha/mrBB56TiZmhLb?=
 =?us-ascii?Q?fxm62AlWOCAt70P0164Dp6N4XqryHV9efkeTr/OvCktFF66HBDHhz6CP4NN5?=
 =?us-ascii?Q?IFE5mueUi2Modv81As0up10+X/WzZXrWpKpPTgTm9e63IPK/6pEZyW+6QgKP?=
 =?us-ascii?Q?z5vrM4bLRFNcetaGBF8+fYeXxFdQcrBabWHVfQiKK1+5RhnxwSwLN67OqaB0?=
 =?us-ascii?Q?GU/ge1gjY2W+xp9LaWzQwhxRV28I14033LhDlDy4xgW5utolHeK7vopa+A3L?=
 =?us-ascii?Q?OdPHj46Ga9WL7rCfrStExle9VgLlC3RiKSVGauAIOi3cY/AhOPecZYtCAWdG?=
 =?us-ascii?Q?3KsS23eFIDy0A61uRuE28cqnjtzezDuct1zzH37Z5k55oOjdETnokOzx6p4x?=
 =?us-ascii?Q?zMjucDf8+aATRcLZpkLu3j9biDaEQ4x0O8B/a6OgQ2KS418D56dqbEiLysmj?=
 =?us-ascii?Q?zXXRoLt6Xye4FFwsp7+S5T3uzb+YyjSYhiq4rQvj9cuQ4/TqSF+WVw4CQq1X?=
 =?us-ascii?Q?vHp5cN9ZIoqOqI1+RWUT2n5DpmSWS5RRpPNHSDRZrn4/8f89QSyPjTl/9+s6?=
 =?us-ascii?Q?o4exXbArqnW87tsLW6JDujTQQ4KSQVF4btBcntmhWPEzNTUr800J1CKzfPdJ?=
 =?us-ascii?Q?GFgk4TAInIXoprznsr7OjOnWuCwHUuDPFGAHK0tnfJ7tD+kjTnzqlcV+x7IE?=
 =?us-ascii?Q?UQnWiFQy2x56e76I4GLPvBqOfDAz+O0TiUVQYUWl8Z0Acj1bIvuXR5tVrZNt?=
 =?us-ascii?Q?+8o1r5ivw2kH+h8FqCd5kSArS6MpMA5mSe6PLtv60G6/1/+LcyK1KZBfQdZs?=
 =?us-ascii?Q?JaPltGKK9vBJKZ4DliMEvF6r6k7OKbF5n+TUrqyue6mA42FwXJFXfjr/oGvk?=
 =?us-ascii?Q?a33CeTKGhFt7UhRt5OngRBgIY91Tt9zrlwmyC9pZuCToDPyQ3wu6fHaic/lY?=
 =?us-ascii?Q?7z5l/ieYxyFI1gvAyQ0xu/DyZFZKpLp1oBYRr6Y4EKknKELgKh3NfYbUxdwk?=
 =?us-ascii?Q?uGCQF06Xyb/6hLlYv/0CadM4tq1AL1IdpH4L+HltGCevIaO+5diGVslR/jWE?=
 =?us-ascii?Q?6nDHwCDuFGxeXBETK3UWex+8twg5w1dZkI32Mn/9hfz0QHyMpMrCqPNnvqAD?=
 =?us-ascii?Q?UADNQw2pKdnAI7jb+hyw2gC2zUMLMvmikG9oGEk106UyRfNnt4efVqUyNDyD?=
 =?us-ascii?Q?3vSaKCkZlmjBM2Sy3Bg25pH9PGEvj4kIwJpK0XthhmlWfgJ+TVSHkvD06xLU?=
 =?us-ascii?Q?u5egy957oyRTYt26m7Tba9iAMBBn5WgOA8Watq4ulWSgsZwb03uF/q0fQWAm?=
 =?us-ascii?Q?/Ww5wzWZn8/s75uTNOMTudQGvN13pEgFV/drfxKnP2osJ5Afj2woXAtJ0IyX?=
 =?us-ascii?Q?IhIRt7l7NcFb4R2pwtJlpEXSvZy0DRVMAzXCdTC28kXHdnPTpsrdp97Nop1x?=
 =?us-ascii?Q?lntico58lGd1CWcL2aH9lObnUavRoimODqkGlZWZiV5iAxocVaa07/h2qQe1?=
 =?us-ascii?Q?sh6GMQHvOazHrZMuERAXhZb3L4fnvzCoK2BrfNr1pWn3Iv/EZWQxrTqIwMC9?=
 =?us-ascii?Q?HVHv5IAiOQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da0077c-148e-4c5d-18b0-08da1f2a77a3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 21:54:08.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ZJxBOzULtEOSFCbebpPkNdU5fqOiB2DOpXf/ZdlCW/SsRMT+NdS+ELPcZd3r7P+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4198
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 03:57:14AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, April 15, 2022 2:46 AM
> > 
> > kvm and VFIO need to be coupled together however neither is willing to
> > tolerate a direct module dependency. Instead when kvm is given a VFIO FD
> > it uses many symbol_get()'s to access VFIO.
> > 
> > Provide a single VFIO function vfio_file_get_ops() which validates the
> > given struct file * is a VFIO file and then returns a struct of ops.
> 
> VFIO has multiple files (container, group, and device). Here and other
> places seems to assume a VFIO file is just a group file. While it is correct
> in this external facing context, probably calling it 'VFIO group file' is
> clearer in various code comments and patch descriptions.
> 
> > 
> > Following patches will redo each of the symbol_get() calls into an
> > indirection through this ops struct.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 
> Out of curiosity, how do you envision when iommufd is introduced?
> Will we need a generic ops abstraction so both vfio and iommufd
> register their own ops to keep kvm side generic or a new protocol
> will be introduced between iommufd and kvm? 

I imagine using the vfio_device in all these context where the vfio
group is used, not iommufd. This keeps everything internal to vfio.

Jason
