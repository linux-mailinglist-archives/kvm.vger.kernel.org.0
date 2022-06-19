Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FB25508FC
	for <lists+kvm@lfdr.de>; Sun, 19 Jun 2022 08:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiFSGlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jun 2022 02:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiFSGli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jun 2022 02:41:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F399D2729;
        Sat, 18 Jun 2022 23:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kw71n96qQsiOXQgEVwhg8Z1VDdbn8WMAaO3ktaXx8uICvcoUeehioWNIuatnT/rIlcDFotRJdxOmQSkHMlq81WyL+j2Rng+U07dZM8FZAFgr4GFyncBvZ5xFNA6x4S0o2yf3CDZeoFjMxdofNgJ51FHxsw0PDkQXHpLeIylkXjBdQ71xetzZOvhr8PEVLzQULeqXYd2KkNLxLDjKNdj1r7GZh5wVa543181S7XiELQJFzwBaZMMgzeg4aiRtWWY92f3JzqqZKUYloLDNMQbyBHauF4wdchluHXSrtBFc1iYZ881X0yrr132d563e9r4jY3btH3YWsu1/bckKZyhc1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4g9TITHWXRU19k2Ccog+BkCLq45szKCfFjJ+wFyO8Nw=;
 b=H+hUrCEWocP4YmarACh9PYvzF8ExYmGQFPWq4ZguR3iaLv9/xp6wi6+tz2otePvcgJbalQRBg5GdStPzoyLFWVpEa+SFL1ufhrSylHDD5mG68UkmpSso5E3ndVNShqGVQUlKoxM8Xs7BlxXW2jsNDnWi5IQabJQwrClEcdaA9d3YAQG6a9iAYa14OsZVvqO9TpP5bnHv7IqiayAuBPJMtycDCt3QKYcrz8ZhGhi0Y4YAUQPPjyksKgcZfE59XFf9LuSCyk5c/yrTsH8XHLVejRloS9pGR3S7YS+7iUAUtLG0dcuN9BZXJ8c7LMfl0e8NT/hsVIeZCvgKFevIhA1SrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4g9TITHWXRU19k2Ccog+BkCLq45szKCfFjJ+wFyO8Nw=;
 b=RYYUS/h1EEuh+5+zRIxiln3Jrl/rOvsiC7X/Bd45zOXSeHdnovYR7OSX+eap5JhDTSODu/FgZ8CYSOMcdpYFNZXVQiv+dxG7T/hTcGQCAASAJ89wPEQE9LuX21uGmbVmlS36nQ7Yx5kQwNjZBnUCqSU0/AFaUh90xC+rJcN5lAF//sxTunIORt946s4Yo4d69J6YoWa8m7PH0rn0CK4kZ7LxuLFz5etmCoNBwnlWy5zV5Re85OqwFjUT9VgNOelypJsaOIDyQO5RSffH3GC2uRj3OS8BYPqxmfMnYSULSLBmsir1yypJznbT5oVjooHQCArVF6FzN0u4YN8aGxOE3g==
Received: from CO1PR15CA0104.namprd15.prod.outlook.com (2603:10b6:101:21::24)
 by BL0PR12MB2497.namprd12.prod.outlook.com (2603:10b6:207:4c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Sun, 19 Jun
 2022 06:41:35 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::39) by CO1PR15CA0104.outlook.office365.com
 (2603:10b6:101:21::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20 via Frontend
 Transport; Sun, 19 Jun 2022 06:41:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Sun, 19 Jun 2022 06:41:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 19 Jun
 2022 06:41:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sat, 18 Jun
 2022 23:41:34 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Sat, 18 Jun 2022 23:41:32 -0700
Date:   Sat, 18 Jun 2022 23:41:30 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>, <jgg@nvidia.com>
CC:     <kwankhede@nvidia.com>, <corbet@lwn.net>, <hca@linux.ibm.com>,
        <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <tvrtko.ursulin@linux.intel.com>,
        <airlied@linux.ie>, <daniel@ffwll.ch>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <pasic@linux.ibm.com>,
        <vneethv@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <freude@linux.ibm.com>, <akrowiak@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kevin.tian@intel.com>,
        <jchrist@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [RFT][PATCH v1 6/6] vfio: Replace phys_pfn with phys_page for
 vfio_pin_pages()
Message-ID: <Yq7FGti2byQCelPN@Asurada-Nvidia>
References: <20220616235212.15185-1-nicolinc@nvidia.com>
 <20220616235212.15185-7-nicolinc@nvidia.com>
 <YqxBLbu8yPJiwK6Z@infradead.org>
 <Yqz64VK1IQ0QzXEe@Asurada-Nvidia>
 <Yq6/qS+AE1LfO+/q@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yq6/qS+AE1LfO+/q@infradead.org>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed3a46ed-fcdd-4fba-8af8-08da51bec12d
X-MS-TrafficTypeDiagnostic: BL0PR12MB2497:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2497E40DB4AB0D4C77BC9B2FABB19@BL0PR12MB2497.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jShLU1EipbuQZFSyVBZq7qUr0kjH0qhxZ0cCRXnX1H1c4HoAygL7K1Mw1tHCYfSoTVukJj8EbLNoTwVcKm1tZ4LFDqzMJbGBdeAKIK2iFN8GqhNofGikLSbQBtzlVstQbDoznDkowBzyW88UL81tNOl2o/GDVTXykZ9LdfOuHDvhPp8hlBmdPYB4jtkic0oyZ3jM87570GduiwyoxoKP/8aHTgsvahUgJ6S2pSNlhgcEVH50X+7RQ/YXeie3d1D7ig3WZ//6qTG/6M0PTFIlf0PbEGqU7sP5Q56+cLgUc9kqztY2rXSnT5o/R90ii39c213OSZGF7PWAq3y6npZ7rzlL/20NyMDTccBxQ3M2g6qfGUUL2oKXpChtUa6GftB+fCB+l3FEuvOs09+9CB1zPUU6Xh/z2pe5Xp99oqojBcJo5MLYQP/+1poOBVB/cHKyjWT0KovoD0qYTQBg6Il0W1+mXUC1+iAHsF9LJ2cbhj8RDQ6gEXsK/t09wOAMTZV1M68ztUkAJd+aMszyf3OOxn+ZRC/QwUsgJVZIZmTDXLI6eEDuD7BQd+Qw+XvwRgti4KU6iIfGC9QSbQGyVdXxDo9WugjZ0ovrhNQ5jDTXN0dPQXyf6d1qPqZU1r/JV4Vw0/YKW+NXC4dZUyJNUD1RLmoFQym6sXAjm3vpKY5dOXVqYia14yVAHYesuKIbDbP67A+LMrPewzK/Y4XP2Lm+nQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(46966006)(36840700001)(356005)(7406005)(81166007)(70586007)(8676002)(7416002)(6636002)(316002)(498600001)(110136005)(54906003)(5660300002)(8936002)(4326008)(70206006)(40460700003)(186003)(86362001)(82310400005)(2906002)(9686003)(47076005)(336012)(36860700001)(83380400001)(55016003)(26005)(33716001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 06:41:35.1720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3a46ed-fcdd-4fba-8af8-08da51bec12d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2497
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 18, 2022 at 11:18:17PM -0700, Christoph Hellwig wrote:
> > > There is a bunch of code an comments in the iommu type1 code that
> > > suggest we can pin memory that is not page backed.  
> > 
> > Would you mind explaining the use case for pinning memory that
> > isn't page backed? And do we have such use case so far?
> 
> Sorry, I should have deleted that sentence.  I wrote it before spending
> some more time to dig through the code and all the locked memory has
> page backing.  There just seem to be a lot of checks left inbetween
> if a pfn is page backed, mostly due to the pfn based calling convetions.

OK. We'd be safe to move on then. Thanks for the clarification.

> > I can do that. I tried once, but there were just too much changes
> > inside type1 code that felt like a chain reaction. If we plan to
> > eventually replace with IOMMUFD implementations, these changes in
> > type1 might not be necessary, I thought.
> 
> To make sure we keep full compatibility I suspect the final iommufd
> implementation has to be gradutally created from the existing code
> anyway.

Hmm. I think Jason can give some insight. Meanwhile, I will try
to add a patch to type1 code, in case we'd end up with what you
suspected.
