Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7C168C10B
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 16:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjBFPKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 10:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjBFPKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 10:10:38 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2056.outbound.protection.outlook.com [40.107.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2F1A5D4
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 07:10:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fma4NvcWNk7Z2LJXidGkte6TlAGl/9Yl4zv7w1PVfGN5EybhvGmASO6c//0AHlKmU2tZEW5Q4AGrw5fqyl4tS6yoouXPvd5Ua12WN/ApzJ/IaNoyBt/LXQ0U47s1FDlokt+Je7o928VY4t3D0nq2n0GA1WYW/in1R7IXfOlUeH/yHOHAFn6eqAbYbSSMwKxOkzbxhu7LjLxXKOxCo0tMTgbmVU4QwV2e0OuebnqksIWSzjL5dGJfIwSG66HdTlnl4kthZtYpNOLlnUHFodHglfFQJH70C3llPom5XlViAzz90T+opd6RDGwzm6oJs6ULU3B5iJNXHkMyQtSr5E7MPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4rn7lCEL2YZumUex8qojN4VLvDDY9cOLyLfGHJMwbA=;
 b=Pa2m4KZP9jgpdTqIvNmDnrskGmoWuUHWFhrKAp7kWLF+jOZMtMEqxhXC4smYwtkcRKeUBI/1DSIkhffpcgKQLLXkrhq6/x63hEvU57m2kOYTnRreFIxHeR+BX9S5NJzWk2r+54FNRxDlVkgrDLJiHbZlmYrYNBHsuNgl2rF4iXd31N5aQiQrtsQpcQqUXHrGUNGXdKLEOpNRK8/78tHHQPmBYxx+wWz5kZ2lTl3mH34DkcQrYLwGZXnUL0i+r9kOrKKV6MMFp167DYAltROYYXcQaDmhDTkRt6Um1TogzOnxK477rgdwKzlhNjJkon3UUpeZ9QQcrvPAvWQ54d9vog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4rn7lCEL2YZumUex8qojN4VLvDDY9cOLyLfGHJMwbA=;
 b=QtLHzM1H5F4eoW20r3bv9LS5HTVifRlT6p8qYdya+zqwwEim2CQ3HXYA8RFPi9szNNfuYCD2fC6EJzBLD1QiX/uzCf7dARk63F7bJMPRn9DOM5gdf4JfCtu1kCrNXOo0WvCipdBUGOiOwS5yUBmy0priXK07KHKEoaj7AqBySpP6R0hxcXXIbUMNHd/Fll23hWKLM8XKQd7d/PIeAcVs89nQJOAwo2s8PJcHwwBuGSweivmXifnybi23l/XpL+dIf+Eznwe0rxS9C1iF0JRhL1MQVk3SIdamjPvvx1jeDeBW6UtE8xNMxxzxv6vPlNQtuyfREhrT+RUAJoVIobrBhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 15:10:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 15:10:35 +0000
Date:   Mon, 6 Feb 2023 11:10:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Message-ID: <Y+EYaTl4+BMZvJWn@nvidia.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
 <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR18CA0016.namprd18.prod.outlook.com
 (2603:10b6:208:23c::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: 151fb01c-d6e7-466d-a31c-08db08544c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGYfJwuStP9M9N+L5RYEqhtlmwHxo50MRNB0gEb4xvUG7GCdo1s+BnhvAUF1/CnHGutwe+Zu0vkWnMCupJGDDBcTC/nMzRkDSgah2ttVrwM002Crzq/u0ZBFF1e/WIL0uCPJbULNpz7MatWYQahW2fda4vHPnpFFH5Wos2Hpr0ziOJGxQvVhAStcqcHMCx10fsWSBTiQ+VyPYPmmYpGtrOX0dWsc78tHYApgpB/nrey/GAA7PbNOC+m1z+b2bhBW1Do02szLj55koQJCa7rlXVyuztcMbzbw7r/0GSIjWVWrxNR04idNwak6MnkdqcEDq/H3gYB1FHwiKhw8ipPGhTiPWW5VR+T9nyzEAhvkWc2myuOdVDRlJL6HfZhUeKfC0umI2qQrTnXQLtuky+SG05HtLtTLHDFB/fVVeUdgArHjY2Vvhr3vR9l8tM3Tm7BaSNnTd6C2rSVUugj3UTl9pLUwcPmSGjAUQOUCmxdaRUyHaoRnmJIRXkZE6kyrV2e4GyTr5G4nd5HmYcRkucaJ+fUFJ0DxaW9bbO9Z/lM0gnemaHmiWpx8NTDA7k2g/zCdM3LoGTXSZKqmWY2KkP98eK+i9S6ZGy0GbVFornZT0nVjVWO6TZEgGYnyRvvdsbfSr6vuuZ27rDNoykcltuFIGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199018)(478600001)(6916009)(2906002)(6486002)(26005)(66946007)(186003)(6512007)(66476007)(41300700001)(6506007)(8676002)(66556008)(4326008)(7416002)(316002)(54906003)(5660300002)(38100700002)(558084003)(8936002)(86362001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9u5V+n9XCq/xCWrz0GNOW/9JGWaM/T5AEJbecMPNf020TSpCK/qr38B2zBBQ?=
 =?us-ascii?Q?GS1/y6jR8IT9WmahAyV4QHDiwQqjbTJ3KYvd88BVyZyHvStARLhwxyI+lUvs?=
 =?us-ascii?Q?7+465O6FI9gGyCVeHaKFOEdLDQ/Co9l15bU+Z+GIs+clgtmSyYztpwRKrkBD?=
 =?us-ascii?Q?VnfH0/Qm9ABqPsEq8Ah/41X72uo8jPurZdDUvSohe+VoMJrzlgFqLELIdmqt?=
 =?us-ascii?Q?xDr4WYuUcluPrGczQ/l+uqHnvVNYgLa+Tp3RFjnILmJyUkedLbQCu0GNNILG?=
 =?us-ascii?Q?V1QQZpKEMY9GEM285wQ00NGlg1fEuuF9AP+HD0EQCgopVpOaWAjvdY7QANgW?=
 =?us-ascii?Q?oEMR5LoJkizH5EZxC70IzOqzXJteLau0shVLf20KcUG5rxYxgGmNhqo9xpG3?=
 =?us-ascii?Q?7z+CREO1f4wXLr+7GeG+0q5gChDvDpgpcpqvSy8+w4B46atDJDNCGYS0+ebL?=
 =?us-ascii?Q?URC7l2WFJSoonl5OF0R3jnLM1FdZhj9RS8FpvGgChFEp3YImZpHOUGzdErqs?=
 =?us-ascii?Q?iGKIaFIh7foOEprxeCfhCNLDklbvT8GiCqd0IZ26Z2AIE6jR9R5n77opE8yu?=
 =?us-ascii?Q?QuK+l3c2tV4KO5Vv3KQCBCwaNv0jO3yWCEbAO6+wYfhrJpC9etMDduSD7v8F?=
 =?us-ascii?Q?vovFvxmH2Jc6kkKbJ8EJ3U+M4rucX++WhC47fzohGydWhSwhzboZ4L/kCqv9?=
 =?us-ascii?Q?rdUvQKKTwSwkYRgkOJQGPHKm6JL0nt0sRGQh1DB+nQFDR+RDKGd6J5X6cfPS?=
 =?us-ascii?Q?HWq93iF+t1/E7YBUstXM7OWnlYayjWozgfO7ZYZr+X/5ibpHM7SuMq27dvwG?=
 =?us-ascii?Q?S6Cpd/jA5O+zQdOY0osNfY3wggQ9odyuXTN/TdnaXOtoJzTZGzmfSJHeuBIY?=
 =?us-ascii?Q?xW/6lNcWgTH6sjNN87uZnQZBgtFlXJ/PQH8PXm9u3aXFpq6xCeRsw/MISGFF?=
 =?us-ascii?Q?+M/BKk3a7ONpWbROZ7Jqbu+kUWFiyS13O3n1vnFzV/oc67eYdakWDmrVgrS5?=
 =?us-ascii?Q?gazl3CEFDMIBm6PqnVaQH5onTAd889PTD+DI65bRry8De6UJnHnl2K107QmR?=
 =?us-ascii?Q?mTa+dQtx9hIVVeqfv8eLcJANkmduMJE6dPIQXUVTB01WHqdfu9gL+NVpH4LL?=
 =?us-ascii?Q?Z1YdVFkbf/7e4Nin/8LBTZ6nVIlaVhAkMK4+U1q9SIE0fxDUuKo9M2VCAQBG?=
 =?us-ascii?Q?ECGL0igza3eRnriFDNY+guV3APuASpNv+xJIEF//fyoPRSaoE1EVsO3cZ9pn?=
 =?us-ascii?Q?YI/dblIGEzoTDNo2ap5ZNndUyKJV/Vul1ixxGt+opQ/M8PjYd8PYk2Ai7AE+?=
 =?us-ascii?Q?QE7VTPAXRQV2qCTVhkMxwUfYkx/OEza0Pi6ynHLsrD1aJBxNkAthgSx1QiYI?=
 =?us-ascii?Q?rhXO3I8n2E8LwhOF9T+Uqg2EU0tpnPYIjqt6baz/y41QKKITQXOMWxPZwA9f?=
 =?us-ascii?Q?9IXxingmujdOiCT7fi2b9e5O4AyQ0knTei7VJ+FwB2qkyQcZmtT33BiUl1pA?=
 =?us-ascii?Q?72RgmU2bg2J/iNcOow37vbURupUMlcDP1LhNuXsfEqD/0YY7kdk36zQ/aEAe?=
 =?us-ascii?Q?gPVwyrYEY++iuUVQuJDQr9xXhSOrz4ArkpUE1jAq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 151fb01c-d6e7-466d-a31c-08db08544c07
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:10:35.0932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X2+zBBwxaeTxmg5AJVDWOzlnwK9eZZuOwXiwv6v0CHtq1QQ17j5tgA9EZTE4gkZO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 10:09:52AM +0000, Tian, Kevin wrote:
> It's probably simpler if we always mark DMA owner with vfio_group
> for the group path, no matter vfio type1 or iommufd compat is used.
> This should avoid all the tricky corner cases between the two paths.

Yes

Jason
