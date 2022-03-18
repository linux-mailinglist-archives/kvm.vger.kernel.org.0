Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473754DE007
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbiCRRfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbiCRRfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:35:39 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085D018BCC2;
        Fri, 18 Mar 2022 10:34:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qbq2XRPMP8wia7vJOsAIx3g36jeqldjWr0qp3hmlcNWnjV4tnkHVB+k6kvkRS/Gd8syAWnsDeHm+KV9MiqAZVqXtKdrWhUJtAqv/OLxmXJ1JKjRl5G0PJqYtSLA4HyzbALqnE6bsf5Fg7DBIbJLlFPgo0G+LUXVuKxrmGDXXd7khN+8kfzSRoLN3ONAhTacXwIyziKJPUz8AHl/nNSFq4RT90WXDBa+JWWO/4yYi/1u14PTh8eRMSpp49AcYdvofvrXpZrIJJyad5NQQXpSLoG6sIgOP/moqaqFvtG6JZU448iwrWnDfY+OgU12tRkJklz8SIOqQA9gqO5YhCauoDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zD3LacytbH3zrmkkuiDMg/PVsyEjw5MVX3upa9cYGkA=;
 b=eAUr7XFJa21GDBkNQsFz+z2hxlPC7jmZ4nvFfJIP5hh3CfL+OZ4NYBXtSOPNwz5RTTNRbIuFN6LiNxhTIAAxNz0QCB9tEZO19Rrm8LLGfP+5nErW26vK2QMChTxdRAsIgw3xPBnKSSwyZVMqHt605a1ilejuv5lb9y0d7wLoZlc3tbXDa2ngCkR3C74f4sHx/7v/JAI+d2Zow8yElRjOVxnW8h7jEKJtBfNbqRk5zDAHK85XT9I/dAu/82IUsLHuQYyPfgk7bhG5hgAh0btSNfxGwdS+g7yCLxNkhbUB+oelc31RVljYDFnwj2zwDrnwZtGQY+tCAg1GMYTBOldnuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zD3LacytbH3zrmkkuiDMg/PVsyEjw5MVX3upa9cYGkA=;
 b=pDCY8cnJnHX5llZzQ5oeO38tuKnJKPZVxLWN0c0SwiJqLAsKvV1XjspPFIFSYQMnZcA987zMO1P+rRddlUwjYVsQq9PlXkrowGz7HP1BNhJrlpaD84kqq94dHMrUms94SHji7h1cpISnPsniXg/dEOL/sFEsiUZis8mLcsqqUa6xejaGdmKR1p7WGVtUZvUriAkAFa3Pp76jEd35NYWvDQog5y51o2njTuonvL7qRegVEZFHaIzIZaFmGsiQcUVvRYMPB/NcFYOkAPCDR24rK6rrwsh2vM/cMQ2dbxTcx1hE5EA3jfndYGQtyZsa1rYxTrIPFQALjdDzOYY4ASjYpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1795.namprd12.prod.outlook.com (2603:10b6:404:107::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Fri, 18 Mar
 2022 17:34:18 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:34:18 +0000
Date:   Fri, 18 Mar 2022 14:34:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: iommufd(+vfio-compat) dirty tracking
Message-ID: <20220318173416.GS11336@nvidia.com>
References: <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
 <8448d7fb-3808-c4e8-66cf-4a3184c24ec0@oracle.com>
 <20220315192952.GN11336@nvidia.com>
 <6fd0bfdc-0918-e191-0170-abce6178ddaa@oracle.com>
 <c85a0d65-143e-6246-0d48-dec4e059e51a@oracle.com>
 <052c5f12-4f2d-f302-c2a3-2f2b580e4b4d@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <052c5f12-4f2d-f302-c2a3-2f2b580e4b4d@oracle.com>
X-ClientProxiedBy: BLAPR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:208:329::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f115980-ebd1-43ec-ec22-08da090587b3
X-MS-TrafficTypeDiagnostic: BN6PR12MB1795:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB17957908B82CFAC78BD6D74DC2139@BN6PR12MB1795.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QELuJWyb+y6qof12w6KBjZR9ZzyJoTgHjh/F5x3XY72ExpNYcVCnE+xtwwhKQtC07lRV4R6atmc8dfRXVVGPZyv8aQu/6gLDnIo/E7ocJQ7CvBIgji/9TzVPx6ViVtJDVerHPL4fdc/8vjT0dxWA0P6Bfr8snYKwtykljKHxcYhbFTk9OkPuNTD2drk6uJp1+yojHVQsVwtnXF8+ZtIxkNm3ihBNSLs63mfGe+bSk2eFdzPAJNSaAk5gMWc5n3fGAyvE0HQe2gck+qpQiTEzjv3cBUjJsyTDd0rN/oE035HNREzTcy35cM6YnEKB5/sAdpnS58hyIP56tRT388G6a/K+amKuDFNXpwmhOerFcVXmYelHWwgdGSc6JMYkJ64HMU99Pnn/50WIYXG8veiQBtLdGZtAQiWVo6x/X23UqV3TC2rNg4MVAmJK5bfz2ZDwiPco+znutWOrKURSE6FNISKbaOr9R3feFekbtffIpR77HiWKMZbKLIODCfNdFZNKZuEejswvtF/1v1/RmCS+LRdLjh6m6kjHgRfdo5O6JUvjvyfdQSeuaAaORW2i7YT1UXQfOJN4X+AbHMb2FB+QdmaXwY1Ac+qvxsc1KFyn9sKM9giR6RW1aqZKuucq0hcf2q/1DFrPO0w8wH8B0N2Ilg2xrSt68hB2ySebWdeOwItoaAgQbyGkP8ZrukCqcRTz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(5660300002)(4744005)(8676002)(4326008)(66476007)(66556008)(66946007)(7416002)(316002)(54906003)(6916009)(6486002)(508600001)(36756003)(33656002)(6506007)(6512007)(83380400001)(2616005)(26005)(1076003)(186003)(2906002)(38100700002)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZGpodZ9LVxIeFlxfFyldb6T+tcEOzqnW9LrT2kQ1b7iikuXL2vd4UhIWSRpQ?=
 =?us-ascii?Q?afx6oTikHVEMWccRZ+NC2Ojo3gNbteQB5rNNdASMQBR6oZpC92KnlohBrcOZ?=
 =?us-ascii?Q?kVHmk6Um3jgUOCA4HaM5P1zqkxkqgUpEzLPz6BgKFxjun4pPcOppapDaflWi?=
 =?us-ascii?Q?687nSO72WcmTWI5VRcLXrctj0cCw0RAyMxoSb31qKPaBI4Lt7XOR8Lrq/dbh?=
 =?us-ascii?Q?2lMLeYDCrgJKJxZtt6/eBS3LJIqAYty2PuD/HDab/J4rwHGT6rx0VopuAbrh?=
 =?us-ascii?Q?yuZn/bOTrnBIoJfaosBjkx+uj37iUaurtpMGlH/rxqTYpQ5dnePSTJgwIQeU?=
 =?us-ascii?Q?1fRFq0IWC8T4lvm22VGyOnX66PvR9wQ7DLteAcjVPaVXQy+wOG20cRIAjIHI?=
 =?us-ascii?Q?48ocnCCvMZE99xNw6c6BCpL2g3azqc8f/fInWSG2bhH9mreCyb2Yg3Sya2DQ?=
 =?us-ascii?Q?QdfnT4N4oC67THHbpIptusl9LodJUATKZXEoOzW/ruGAkcp1qpAwle9jcklG?=
 =?us-ascii?Q?JrXny7qX9Gv0CUL0TOE3iUAJbErYrHMTRkO55ev7u6uFOB0zSkQ0wmzvzxG3?=
 =?us-ascii?Q?Df2hJt3rMGn1U8eHRX4eS6TZV8xrgPwBi4S4xOWBIR4mmjPNluNS+yP8mQ2K?=
 =?us-ascii?Q?E0WYwTqtgNroYm6f7L/TqH06sYEFxGmfbsCZu7z3hbalLeQrEddwwX9gQbmj?=
 =?us-ascii?Q?K3W2vDjvZL3a93U4+MZeqsmHy4aYj5j8thzLeaqrVtd+eaPj8GZF6/bQyTk9?=
 =?us-ascii?Q?Irb1f0P+iy6rZfkQOQG/YSAJ9UYPeLU5OTVo9i2y59lF4yT5CjrPBbqjPMrS?=
 =?us-ascii?Q?GwzVWANrKwU1E+2wJPZcWQjOTSs0T7jt0PXd/nacTPnxBNVKo0FtdFN5Sutv?=
 =?us-ascii?Q?V2orteHH7C9xKrRjDPYFCFw07pSrD4TovZelxGL7uwq5MUHYOrcX7x4pzuug?=
 =?us-ascii?Q?M7sCO9b+FTbZ8CTxGzmfq6WxWYouLg9wN24VKgrXkT90MqmNHMACR8sgrnt4?=
 =?us-ascii?Q?KXPNON68mX1onlTJSpTWLHm9vwXAXmrV0PaQmXFGg5YYy1cnBRo1rpbBuaAY?=
 =?us-ascii?Q?kntbNfHd3xSx/e1074HLy/Av8Cix7kBiloum+Qc5MrDxGnd3nvVNzrpjXZdV?=
 =?us-ascii?Q?eYjQrMJ+PgPWUKSk8zqxW4P83F/1+6Rdz8XtsXlDKbCiB8WzaWWs5lImivjC?=
 =?us-ascii?Q?DpTokCici9z9RmmQLI5uvjAmjH/YWS4xtHUlDYdlM0VnWAFmo+clQUccxfsu?=
 =?us-ascii?Q?DTkr++arH7xUeyIATZDtbxRolxmAbpvwbRPU/qbllB31iFy5v9IfobW1p3Nm?=
 =?us-ascii?Q?R4O9Q87ZiMPxeWHbZ52kZ7cEicLnIWNWiTdXy24QDM0R+8ZVKafViGeHVIja?=
 =?us-ascii?Q?fsZSOez58MgkCIZjTR6TiTioXMcdd0KYgSY0FY/NTbwj4MeBkbRbMRq1ATk2?=
 =?us-ascii?Q?7gN9A1DK563AIOGhOEMn+jNti5NB27z2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f115980-ebd1-43ec-ec22-08da090587b3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:34:18.3497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vnr5bFAm9tItOCx4f6McF+ZHDYbIp/rO2dILAzBjjy0hyGj9P8xrfAs8DHy2KQbP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1795
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 05:12:01PM +0000, Joao Martins wrote:
> I updated my branch and added an SMMUv3 implementation of the whole thing (slightly based
> on the past work) and adjusted the 'set tracking' structure to cover this slightly
> different h/w construct above. At the high-level we have 'set_dirty_tracking_range' API,
> which is internal in iommufd obviously. The UAPI won't change ofc.

Shameerali has HW, AFAIK..

Jason
