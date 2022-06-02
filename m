Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0797953BE79
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbiFBTOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbiFBTOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:14:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F225FA5;
        Thu,  2 Jun 2022 12:14:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZiunqxtvPhsnQkuucPMVKd7Ur+3I02wzPtJLbkAKdTLDhqZvF89rieMLWbbSRbVzY3v1WDXzZKc0RaTV9LvDAWa9f1dn2v5TgcI3PH0dNqME3vvk5qKTZg+NPx7BTqp3uexbSpxfuqUN1fXOyRsBIr127UeGq8Foez0u35qCHZfVg7gjJ1YESt/Epbs/Rd65LW+svL8+LZ6N6EqffSBMtE7o2/Z8ks/jL1AMaaKuF7j1ho6j7p+hm19xjlM5lEgWNsc8AUcgX1HU5YqvOuZPIFpanrXlz6DG8OVlc9waPQ53iq2VqniyJ4Be5nMOJq9MC6Max1WxLPUvXalDYqSRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfSX+bAw93302Hlc4csgeXuEGrLKGp5igUPsFdNU6SY=;
 b=eT/ouIaxnXqVVpzxnDLwXuErAU+8JTJo3XTnvubv3FQ/dzG0zG1/H5BfsqUk3hvq2heWkEaP1FeN1lHUDj87H0bwVUwBHtpLu0yhv+ubJAqCdwVWlCvVcABGDZPzkPXowHibid6+TOzGNG8ExHrgrk6Bivkw8PZc+kOQrmdIXnv2XR664gZ5MAhgaCuAeWFY/mlVorCxnd+UPH0ZElYFK0TysA5EpcatstiXH9H93U8zsFnHx28mjzoxvK79SMT6XWfeBcwjVVAns8RlJwIx5utQzeMHSsWD5NxZjb9y1PioTow2FkkzO0r2JloWbK0bb4evNr0xiMuCI4nsKC4qcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfSX+bAw93302Hlc4csgeXuEGrLKGp5igUPsFdNU6SY=;
 b=Ln/2ej6ZJXV1XXIHrs7sYshEjaL5M8nHhgWRhmEYd6LROddc1xTT6EE/VJg7L0IDg9kUcT2n6ifCfPseEGhsd3JyuPoESIg3Ouew9vzwoVlDv0I+PfP9IF2xt1z1Pt3uS0QRxTxJoC/6Y7oHFA6KqZ7jEoZ8x5qMBBx+qyrtwQZI4+B/L+1IFwK90lmB7Xnek3QVO5+Sv4pNLzZ7Uo7XyX6+MxfKzOWCgCsYmwQxOQufoaHnDrluNf5tsSRSJfnCr561URNISXMyMwSRR0mgX+5XuwLd1Tn5J+SU/fr5h3t2+eRzWO5iACaOLp8Az5VsiHlhb9lCGftR9fR0qFINjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB2918.namprd12.prod.outlook.com (2603:10b6:a03:13c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.17; Thu, 2 Jun
 2022 19:14:03 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:14:03 +0000
Date:   Thu, 2 Jun 2022 16:14:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 12/18] vfio/ccw: Move FSM open/close to MDEV open/close
Message-ID: <20220602191402.GI3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-13-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-13-farman@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:208:256::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca231000-ebf5-4447-e31f-08da44cc0e6d
X-MS-TrafficTypeDiagnostic: BYAPR12MB2918:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2918A24F672B9F8963598F53C2DE9@BYAPR12MB2918.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wRmJMUSI59anTYLODENjeTdOg/ktQk0JrxwToXJ64bW99tD7SbBjBqa9Cik61Ryv3kVYJ1elj5DZ6mqj5tIbFUJj6YwZnSOHex7OphLdVPaLKrWLjUW/tOs3b03WDlm6ejguUUz4/cLnrBkUARs+0eZVWhQltrkmpEsYhLPuPEG8AoAjyi6poMm8GwHGZvSawGhpQlio2v1TkXtwvpOaPKRYFVoU0UcOHSVagCcMKrzirc92+Yz93hCxvOK+eKuSEvRVCPjVGShm90xOBZvq99u38CNAfNImDTWL5/CQxN0GnC5pH2KkPfmTL+3j4OTmbcjWe+1uVEHSUtyhzvj7k4Ez4LQyF8U/375lKszyfR6cdny8yrVZSnTpeKGYXvwr/eD3FodBkjS7fvUtOrnS+MXrKhfUyRawGg9S2IAuer5ZRWAm46XkVl6jK7sDFCsfr0hkpNR2tWleUitb8gsRnMZtPKoWFCeaGi9fkN9lJ+XWb3NvuI6CPTq8lzuBk1h7l+PrkMuKjUbz3EKOgRE1QafN5uXvuZxnAC3kT2nyA0AwEaqJ8gjYu1KbtMLG66NGMYBAl4N4DP54frFhInHLD+cZIy8XeSJuFdiLyNu/cZ/tvELsswXesCnliaA04jJWwAmL1tC6IvyUU1MUB6skjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(54906003)(316002)(83380400001)(2906002)(186003)(1076003)(2616005)(86362001)(38100700002)(8676002)(66556008)(4326008)(6486002)(36756003)(66946007)(8936002)(5660300002)(508600001)(66476007)(6512007)(33656002)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1jkrExeblBfqyjuLiwmrUMJ0LWpoc6oXoA30MjgOxXq8slnwFDyNsGjIxJMP?=
 =?us-ascii?Q?WT/AOtiS0AXEkBwoiW4lbPfTDMxndaJFkSxtc5sX4eQw/GZQ+q8iqej377pC?=
 =?us-ascii?Q?YYEDQ2SCOZ8RCsnaMfwu45sAL+Bqu7YOZSQH2b9PtBliUaqRv2WF2UNHTgQV?=
 =?us-ascii?Q?lFl81vLb9equ43oMn7ORidyImtGD6F4GynkCmPT6SWx62/LNogBznV6u6orN?=
 =?us-ascii?Q?TRvokuJ3rwu0rjqKRWoeq+mTaHvDRfvQb0sRNgt8mabxTaFSdQZmPqwJKrVe?=
 =?us-ascii?Q?Dw6s+475nkFx/JWUoN41sFzulSp0Ax7z7LKg0/EET4PpJimn76TEg6xLB8Mf?=
 =?us-ascii?Q?SF04aNMlgvdqALdlhdsINNCo63UkiUjS0zZRD+mswaGhu6aoF59amH3Sfnki?=
 =?us-ascii?Q?FeyOH+Y0poma05rjsOMfeRKsXvx+D/3Q+PbxjSiqnapBYlVBMAvDtw54CowO?=
 =?us-ascii?Q?zWjC11wjHDOGD5kGJCEBTfZ6lbE9ppdEk3TN3YelI18NfHvNMJmRJIMJrqyY?=
 =?us-ascii?Q?mvWM9ZZu7Q8rEG8yakjtJHmt1vcl5bt7kLyo5pq/T1aJHsXpmPRGmLs0j+L/?=
 =?us-ascii?Q?ZJAL3R/8kFM/ACK1hhe18fBAcMMuunDoKt0dStbYm6KNSaisbsHeNZU2/4yE?=
 =?us-ascii?Q?LzbmHDhYKcSnKr3DJCFg9pcgGTrORaFDdFaW2Cl1wOhO4NhMGsHx8qrDyXYo?=
 =?us-ascii?Q?E3dyE0P8soWbxLCNCF0yHuBm4bMd1d4I7GcYwsJ6iUo/xaFH+5EzVCMFXzyQ?=
 =?us-ascii?Q?ZgxwCkA1LEW54jSQoIwPm4Ap8x+Voa6DmJsj3N+FiAeytn2gaE5fUYXvdZt8?=
 =?us-ascii?Q?9dcVtndPemi678NbbIadvOoraqQU0DPkKo5iFSht08e8LhlDkud8gXv2YoHn?=
 =?us-ascii?Q?Poeu1J+giwsbVgD7d70Nj2uwP33DimBvYZm8A1P2QCzD04UzwiozyhST5e4p?=
 =?us-ascii?Q?ANh4TdK2bJF8BbA/ilDMO8iLGAQeb+ILifnhuy4WcdHr0QsYsa496INSc7CH?=
 =?us-ascii?Q?lIiOmvi+AO+FbkXm6zmUDrYFOnljjFhVgVI4N8k8LOKy8/QY319c5SYaF+q+?=
 =?us-ascii?Q?FsqXOP7Ny8MmkjPyJvPUoWKhFdQpHsyu0zCKAQo9quzE1koWcOy4jcEJCkPZ?=
 =?us-ascii?Q?xW5NyZJ1TLr1nUzaig2U2mhYQQxnHWX8c7aAUoFSDTweIs2jlTa1bk3q7QWh?=
 =?us-ascii?Q?um3NUTpekKyUbWb4apmDBtoatqJ+t13dtCloUTdP+PBPcYZxMuhiSmb20sCn?=
 =?us-ascii?Q?g0ukbU9baMwhUZGW+76L23FzukRSKjgh/ut9tjljsn+tzk20DU++ghs0xpnK?=
 =?us-ascii?Q?I1L5bKixPQkfrvDmgf2wbZzOc6jkRtncTKUwUBwbSQHN6q3XjBn47nq1qqMG?=
 =?us-ascii?Q?YcbG3wg9NMzIS4F3BjbPKZk5IJcJCnok/L+laD/vfzP5iFFqh1Zev51huWyf?=
 =?us-ascii?Q?vVrxKXpTtrnvVW/KBp6B+b4vv23vCZRixx0AyP309IpnV11yJ32Spx1kS/aP?=
 =?us-ascii?Q?25bzY1NJphEA3RJUoyxgMiIAwnGFaEXy9denJoFbX4t3wJxoZfQo3q3VPmmO?=
 =?us-ascii?Q?Q5x4sV+f29o2icM6og697FduCju7DbX7xuez0J69Ls72dYNbJGcGyHp5795J?=
 =?us-ascii?Q?PkyUCadhL+VzLroNA9JReX6KS86PPgyN4hUABvhDEADwvDz09P30zmxbl8dT?=
 =?us-ascii?Q?reNa++CIUpfoTEZL1oIkU6nsgWDdpmRDJx8YrrY5aT1URNjk1tompad/pLfx?=
 =?us-ascii?Q?5VXMIqIo1A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca231000-ebf5-4447-e31f-08da44cc0e6d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:14:03.3383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNvLjQEtivxYXl+X5MWr6EFdsHKQteX4NPwYZASXrJVQi7DcM2reGG+FfYCeXA+Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2918
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:42PM +0200, Eric Farman wrote:
> Part of the confusion that has existed is the FSM lifecycle of
> subchannels between the common CSS driver and the vfio-ccw driver.
> During configuration, the FSM state goes from NOT_OPER to STANDBY
> to IDLE, but then back to NOT_OPER. For example:
> 
> 	vfio_ccw_sch_probe:		VFIO_CCW_STATE_NOT_OPER
> 	vfio_ccw_sch_probe:		VFIO_CCW_STATE_STANDBY
> 	vfio_ccw_mdev_probe:		VFIO_CCW_STATE_IDLE
> 	vfio_ccw_mdev_remove:		VFIO_CCW_STATE_NOT_OPER
> 	vfio_ccw_sch_remove:		VFIO_CCW_STATE_NOT_OPER
> 	vfio_ccw_sch_shutdown:		VFIO_CCW_STATE_NOT_OPER
> 
> Rearrange the open/close events to align with the mdev open/close,
> to better manage the memory and state of the devices as time
> progresses. Specifically, make mdev_open() perform the FSM open,
> and mdev_close() perform the FSM close instead of reset (which is
> both close and open).
> 
> This makes the NOT_OPER state a dead-end path, indicating the
> device is probably not recoverable without fully probing and
> re-configuring the device.
> 
> This has the nice side-effect of removing a number of special-cases
> where the FSM state is managed outside of the FSM itself (such as
> the aforementioned mdev_close() routine).
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c | 11 +++--------
>  drivers/s390/cio/vfio_ccw_fsm.c | 30 ++++++++++++++++++++++--------
>  drivers/s390/cio/vfio_ccw_ops.c | 26 +++++++++++---------------
>  3 files changed, 36 insertions(+), 31 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
