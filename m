Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF65A3AA7BF
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 01:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhFPXx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 19:53:26 -0400
Received: from mail-bn1nam07on2040.outbound.protection.outlook.com ([40.107.212.40]:1766
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234772AbhFPXx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 19:53:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CV5AsYvs5Iw61hByr04AakAA24wJUejj2gPuG1Uo1/o7dN6FHnDFsQdByHg171T9WSin9q/ON661lN0Kk9lAgBaZKQeI8GsR6rYZeMuAQuufPRlIyoAScMZwNILe7Bvu1RUSTboOgF3VELm7w4ppFh0appJdVPqGzDXeYOY++n8XTbKI4TOJvoKQfs38yipfHjUlDm7zDl3m2U1zCjbH6yH33el02gDBYu6dG3rJ1ZRffW8Pa4mzVI238hwPK/5MdJ4TjeXXFUGZCctMOSfwv+x73HC1KhLdKaEpTyYB7aimjt26/bpeRcZGRRiZe02PR6m5BxgbvmhZtWcJ4jfbqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POyfp11h6T1/ev1eSwNh8ddlNsT5PADRL3eK40DYk1A=;
 b=FY/G1ya6dvTuggW/bgICiREttJtxi4eWTtv4WnBB4vHAUPJ7yV1U/BgE09nS1o4dQm4lQ8JtFRld9joM6k+jmfCefpHybRSKoKJftV9l8vOC0eg3ar0LfttajbXufxdYF0VfyrXKYik57SQZ0dzOQnHVewHp22VeluQ5OCJ5hJ/Um1Iqo+kf5Bb6yNH0AWEJflN+E6tTxxQ73qLUNkvGaEJ7gzh8v/t2b50lsaX3QDWRByFyBE6AsbXbtDjy4Oza4kcQynPLyQhC1+/sX9S1yLcTkElwnR5YO/QsYEcPKouYc3UuyCLH1NefN9Tpccgr0tdua2zP7z0SMqqKSupuuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POyfp11h6T1/ev1eSwNh8ddlNsT5PADRL3eK40DYk1A=;
 b=NXHhkg3IKLL2WhPHYqM2ZY3rQt/bUpXtdxNMO0+KALOgLDAtdggoGb+WIWEGSHQgzmg1nqwpxx/ZyUj9GwikkL5vDUunHGaXWkIpbWfEbnzaXKCgK5f4wItUPGpTtNueijJCpCOe6153KRGrDD5TJn1acv2VbcjmS+RiExXa/V2knaBzaTlhB4YKvzfNjS9bnb/otdPE00FVfCZJ6+mGGPuI83R2Z0Oajs95oA19QcIB5yRGlxNlTl8fuNVTlphBUau5xIfIPtCmpEhZ7f4YmrpSetR/4m0e1lWVidV+GJqEHWDKyWj+JCzAhw8w4rokXLxSMgeiL1/Z5QcBx3Kmlw==
Received: from BN9PR03CA0228.namprd03.prod.outlook.com (2603:10b6:408:f8::23)
 by DM6PR12MB3452.namprd12.prod.outlook.com (2603:10b6:5:115::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Wed, 16 Jun
 2021 23:51:18 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::d8) by BN9PR03CA0228.outlook.office365.com
 (2603:10b6:408:f8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend
 Transport; Wed, 16 Jun 2021 23:51:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 23:51:18 +0000
Received: from [172.27.0.196] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Jun
 2021 23:51:11 +0000
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
References: <20210615204216.GY1002214@nvidia.com>
 <20210615155900.51f09c15.alex.williamson@redhat.com>
 <20210615230017.GZ1002214@nvidia.com>
 <20210615172242.4b2be854.alex.williamson@redhat.com>
 <20210615233257.GB1002214@nvidia.com>
 <20210615182245.54944509.alex.williamson@redhat.com>
 <20210616003417.GH1002214@nvidia.com>
 <cd95b92c-a23b-03a7-1dd3-9554b9d22955@nvidia.com>
 <20210616233317.GR1002214@nvidia.com>
 <f6ef5c0c-0a85-30ca-5711-3b86d71c141a@nvidia.com>
 <20210616234437.GS1002214@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <6c97caa0-f6f6-11c8-9870-4f08f6f8d6a0@nvidia.com>
Date:   Thu, 17 Jun 2021 02:51:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210616234437.GS1002214@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9749edf4-7686-4c93-e895-08d93121a2b0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3452:
X-Microsoft-Antispam-PRVS: <DM6PR12MB34527E3010E94DD4844FD2C2DE0F9@DM6PR12MB3452.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sNcGaYoL/hg6vq5u7r8y1KO08O1Rm6C6CRqO040X5pjlYrynLk5U2/au+O3zWPX+2Hcl5STgkrAWgiLgqPUKFCcT3G+sjhSceNXDOMTmgBXcVCwIaNrloQxwxLAd07WYNdWoAINK9TM4XbjkBNhEuQvghjS2Qw5i52IbLudwG1+jId5LcXqjUNeHhBmGXyC3P0ZgXaTshdEnVnTttelbHGbVBRpxIOzZYdfav9lehdvACpcUAaxVdqlSguKWGqqqD9tLq20fcKZ3ccx9y2amNzslr93zRqbJSfBpIuLqPZ7sJhKT8x4dRUVEI6gZ7yGYMcA+aPoVBQOHn8MbeucHcoRri6sanl0nXiYXeNkmMbrDTSbddAt4rJ7jrplRFlqgSkHMcJxt0IDQLoxtPTlgTBC4NOxFAGVuJceIFPNEd5ZK1kvtd6sQ+nxRQ+MSoNSETcW3oumdIDaYkpRa91QaUAAnS+bM4lsRoDZ1gsyr0AoOPgKb376ymCF8Mn9DvdzvshXj84IHEkdhycK8usfK5V7Az3P7RQ4m6p0i3AEZPzHD3TwkjH9+qId5/xxyrjoqdKPgRNeVvkyKOFJL3E5z7G+KVKFnwCX2UWrX56lsY0N/IIYtI7AXdb9i+iiM2kUEfcG6mYMW4eHjYcguiXG8rjwevjXfdZSu2xMfyq9cYGSt53GC2m6nnUJmgQgGi9I
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(36840700001)(46966006)(36860700001)(26005)(6862004)(426003)(316002)(16526019)(356005)(47076005)(54906003)(82740400003)(186003)(8676002)(16576012)(4326008)(5660300002)(2616005)(6636002)(478600001)(70206006)(336012)(53546011)(7636003)(70586007)(36906005)(4744005)(31686004)(37006003)(8936002)(31696002)(82310400003)(36756003)(86362001)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 23:51:18.0901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9749edf4-7686-4c93-e895-08d93121a2b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3452
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/17/2021 2:44 AM, Jason Gunthorpe wrote:
> On Thu, Jun 17, 2021 at 02:42:46AM +0300, Max Gurtovoy wrote:
>
>> Do you see a reason not adding this alias for stub drivers but
>> adding it to vfio_pci drivers ?
> It creates uABI without a userspace user and that is strongly
> discouraged. The 'stub_pci:' prefix becomes fixed ABI.
so is it better to have "pci:v*d*sv*sd*bc*sc*i*" for stub drivers ? or 
not adding alias at all if stub flag is set ?
>
> Jason
