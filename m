Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C101C68A12D
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjBCSH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 13:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjBCSHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 13:07:55 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06169F9D5
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 10:07:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dty2D3Z8+XfdFONY8IOFVAHSmKSWrYb8TZ+iD+g0YCkFcowdj58KcbCQkzBGSmxgSPyH9DS3JAAoLhT4qZtoDEBUvvwx7y8MmI3I+/WSIHRhmruj30QjnIYx6NSzIAutUctlH2SjOk4Cf/csyF4hDuCCbNe6iS142L5MHWwqLpZadimEkXvWz+u526H0Z29cXo2bOQGDsYnKgSQTDmn5ukYCJI/j6SGXOZfSIN+dtLGt1g6plCzCEgyMu0QIDo22bnm50JkO3s6d2DNmElYF7biW6ynuIV+ylfkLcx6oBRkcP5o8C2zxeIIOYHohFMj1VZbjx28fWLYx884vHoKYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFiwbWqwKUzGpweecm5DwoMEnP22Ja7TBe0A8LNdoBU=;
 b=RWhX98jE9NEMk0qZJo4cHE1+gHuMLn1zeJHvuHxCPDFgBPAVOLB5q/oflNaEGE4yRHTWhNX2eapD5MCXLlwRNjes4KT9PtGx/zWFdJSnXpmocboSVuAQPyYdja1lFDQF8xNDfhhzRjr4v+9PKBShw/XGzjfbB2iNj/OQcfReOKhrLI05VN/Ts6jbwB4KiW4A974ZhVIFNqlRg5dEaLCVAIBJPznmP3iDCUhAFKDUaRkjJ3kdPimisC1TcwB8WtA8dyDQkloLEVE809UUWPTOksd1ILR9nFvZ36ntQfCQlnVxmC2kVTEursoSi8equAN3zHRYYaVz1GA7q3CxFoydfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFiwbWqwKUzGpweecm5DwoMEnP22Ja7TBe0A8LNdoBU=;
 b=VQm4AFE7uVq3KoMxg5oqQF+GoCqbP1bK8ftJ8UP+2xigKs16XLC9o1c0YMxHc9yCMFZdA+dsFL7o5Z35YBHuwHYgEFSA5YoEklqYbLkjNcDOQb+DiDn+ZdYUQ0kABMRLXJPwsz5maDxcs7+gnzJBcI0RWBRqnnUBFPJ36pLl8qqi+ngwxRf2xaLNZpcdZgPY57pakcIFRO1/OOPemlPn3ecEmbDacTKTnlEeMmVGGBazO0UQnSkXGQfxekQ39ue6EjJWcCoh3CJAl/sDqUU3b1QE5R3CiLPRO+53ZcladiTwQmgClnAM3RK05bcKWgUze6rrWiCfN6iZcVleV62Pgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6764.namprd12.prod.outlook.com (2603:10b6:510:1ae::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 18:07:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 18:07:52 +0000
Date:   Fri, 3 Feb 2023 14:07:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        alex.williamson@redhat.com, clg@redhat.com, qemu-devel@nongnu.org,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, nicolinc@nvidia.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: Re: [RFC v3 00/18] vfio: Adopt iommufd
Message-ID: <Y91Nd9CPA2+tG6XY@nvidia.com>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
 <Y90EvdM0CZlr51ug@nvidia.com>
 <fc6271e1-ee1e-41d5-0710-007f780e653b@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc6271e1-ee1e-41d5-0710-007f780e653b@redhat.com>
X-ClientProxiedBy: BLAPR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:208:32d::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6764:EE_
X-MS-Office365-Filtering-Correlation-Id: 85bb774a-0682-47e5-472f-08db0611915f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TWhI1lupeivODa0NqGEa7iVTHIVFM9jYJ6hF4JeVJtYmlbQ/S+ysKGy84zHRE8yJuh2xlJZi1MRWSDKwR/GdfeoNHtff1zWMuW8UukbCkoKUxSx6Uti/bxlM/d7Px1mSXGSx9L0wBvmJR3/QrtiV/BGiKLw/UnF2CBAG+xQ0D7wN9InJ9YGRDJMs/urfBmjdaWReqmsYDrMZXS7oE1nYNS31ql3vzATv3DfBF30jILpkKJYlxxmh+G5yUWJITCEhk2me56rkBBcuFofrJKMR74jA/0lkBRW0PU0sd4Ps6+w3U37tKZUK6nG8lCAf7SwZX2Z4upA9nij2XpPTlw0nyisRxSWtKwJxRwD+XI9nOqX0uQSdH8FOOeVJNZS9S7Y4v11jrXyV3CqFDMjzPq3tgb1cpUdqf5OvkAXOW9bNtRY7nK6S2hZHQBvz3WEGke1plttEfD0XPfeGJJ4a6FnksJ2YDdjqetodykaqTbNrD1pLgp8peNfPkw+vQb0Qk8rPzRDqoqqxRoqFypwE+PE09pJ+qB3UtmtEDVjHd9X9sJWuM76E/PlhE9oSHnUqp/yays+EZ1zXIZiXR/ILXcej5hqgcI3mZz4nU7zk3kiUix0TzB70UTeW5eOTzk+vhY2DsYtRMlI9qRYtrB4Wu8OKqz/6UxwN2iBDlx5iNGskc5UUTyM5Pvrp6uUguGd+tRrR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199018)(6916009)(66476007)(66556008)(66946007)(4326008)(7416002)(5660300002)(4744005)(8936002)(41300700001)(316002)(8676002)(2906002)(38100700002)(2616005)(6486002)(478600001)(186003)(26005)(6512007)(36756003)(86362001)(6506007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X+23cSU0ROdxderHE+ZEQGjUAxScp++/1OP9ybq80iWu7wfCv5LLckkAauPs?=
 =?us-ascii?Q?mNmtbXuULdsHrBApaPJQLomMu/zSZ6B5xOkHpKveMukpCS68N2X2yTMMFnzQ?=
 =?us-ascii?Q?6uRJb6mtIyOt8Nr0/LLjgo8XpslC1aMxIunIBhK9F4n1DwgLzxQQGUPdEmSa?=
 =?us-ascii?Q?npe+22chBXwlJEe6kpcH6riTTdqVgvYmOKS7mLWD3tmviLSlWArC0VJa4LE5?=
 =?us-ascii?Q?GUUuR75LG6qZPE1NT6DgHMHhXB4cnzFW0uKoMjkFr2ddPhzt1Y6JAmUreJsm?=
 =?us-ascii?Q?Ro1qxBTRGEgTxkUeVglz4fAB0JcnLGKKJZCae1TL1WRmXjw5MznJjXkZnW3G?=
 =?us-ascii?Q?VUQGtdjUKyhmdxCJpnZtt3Mt2bMBLPQbq6g6sNaLYRqwQhTeqf2B82/V/zXb?=
 =?us-ascii?Q?nyGCKt0KIth12+fl5/nouwtnErt3QePn/5YftUnwq3IXCxNZY/bWiSFd50hS?=
 =?us-ascii?Q?Nt6MArXcuQLhEU489OsBrzYvtB8gY3LiIfDlPX3BRpjwNm86m5Nn5JBBKrm3?=
 =?us-ascii?Q?IlF22qoLMgvomPxi9Lh3qq2fqj6hWPnFbPCHp9M+4Ase9JVofOfG+XG3qX10?=
 =?us-ascii?Q?9qFKES6YpXm0RGTHftzvLhTmfA7W4VISCUf5YfA7GMuZ9U8RKpxYZfmTG/Ez?=
 =?us-ascii?Q?SgOjeHQz2YYih5oiz9uzbg0DGGIqtX9IyZ0d3DNvNxQzeo2+Lc6ovy2VbEj2?=
 =?us-ascii?Q?K+cHJ7orCQ0wht4S0d2VvS7SkkHFhvnv0e9D8e5mkpmFOhgnpziiYOe+E9b4?=
 =?us-ascii?Q?JkTe/U7goZ3DxHKhsZnBeyaY21Ou1EkmKGr+KcgdZ3Cdaemf6ULVZvtkyVkU?=
 =?us-ascii?Q?th98ycWNNYjzbGrMo67Lx9Z49p17RACqzxAgUIGnjOQKY+Y1OdfUb+iM3dnG?=
 =?us-ascii?Q?H5Y8otbQe92DPEE322YKXCzs1H3p5iGTWRNJ1qCKDGKPIZmoha2CEy2FZAIZ?=
 =?us-ascii?Q?Qa2ebXLhT3+IAvKHylHYOowO2j7+MOW0N899x6EzYCpFnM0A6EKX9Dzv2zXo?=
 =?us-ascii?Q?OZAml6ltySPPI+BRjDtvBnNT5+MNjC3wKD/K3MB04Qx/yWZJJHTSPBMrfy2W?=
 =?us-ascii?Q?P5pKcVpa71tXew3lYXrMiUiXlInGsqRVRMPgghL9v645LKQwxEZwJpZsKb36?=
 =?us-ascii?Q?b39d2FZDh87sBm89WKIRnMxA42UBh3Oan8D8xdbIhlEQ9bf999eEQTuhSuME?=
 =?us-ascii?Q?pL0r5Wj+yHO8VWwHZbFl/anCAZhf7NNQq1zZu26gcRBRg9suHteWPKPTD4fl?=
 =?us-ascii?Q?Wy9raS1wwUl1c4l0WXtBSQ0KCEx8vT3MKiDDITI0RApBla0LD/mavvpGaF9x?=
 =?us-ascii?Q?xGYpV4G8SGFEGvQ59mSnwLUd6x37QR5mJ4ubnSf+fhe9NW/Zx0MMw5CguoJ/?=
 =?us-ascii?Q?Bg5tqRTWyW7kvKUdmk7Fiy9P6BloFBG/Sq6qEs/Iu8o+rWOhDLQOdS3iHDTd?=
 =?us-ascii?Q?xpnc+Ayhkd23V6WF3nFx2F5FKLvvRB4GQ8Gv+3ZF+fXWSBIneXVsG4qQNt/o?=
 =?us-ascii?Q?8IXvm34ELYHcea5ZZmkAQMj+WWAKtNvm5JHXNdo4Xtsjqx4YuDXtpFXzTgrT?=
 =?us-ascii?Q?49HDtGf1sRJyoHMgnCheLpH/85Axy0FLes1UQq6M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85bb774a-0682-47e5-472f-08db0611915f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 18:07:52.7458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zIe8oJLS7Mbe/moRwfs7jrrvqJkT6XJZtbQnJxQhzLEDu26q3V1qaybfh1EP6QSB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6764
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023 at 07:03:50PM +0100, Eric Auger wrote:

> >> - vfio pci device hot reset
> > What is needed here?
> 
> we need to revisit the vfio_pci_hot_reset() implementation in hw/vfio/pci.c
> It uses VFIO_DEVICE_GET_PCI_HOT_RESET_INFO and VFIO_DEVICE_PCI_HOT_RESET
> uapis
> which retrieves/passes the list of iommu groups involved in the reset.
> The notion of group had initially disappeared from the the iommufd BE
> but I am afraid that's not that simple.

From the kernel side I expected that the device FD would be passed in
place of the group FD and like in KVM we'd transform that into a group
and run exactly the same algorithm. The kernel cdev series should be
doing this.

So from the qemu side I would expect it to keep track of all the open
VFIO device FD and pass them all into the host rest functions when
working in cdev mode.

Jason
