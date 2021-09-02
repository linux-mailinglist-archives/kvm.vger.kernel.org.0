Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DE93FF3E8
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 21:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347221AbhIBTOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 15:14:22 -0400
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:13024
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243832AbhIBTOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 15:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpG8QG6N1rCwXHThHtDC975j7xQBYSVfAV8GfqmOXKrFMdlIFJZm2su15VDs8NJtBV9/gm9JBrWPYmnlkJ9QzEeo1s2Uu1+JJGHy9/2lQHlMQTKWbnpfVcMs+yd01Ox3zqqQtnJxBdd+a41D2X/vxV4sruyWh8xo+CuAGRiMlxJ8Y2XoROOOPfZiqky7Mp7FRq9nmTjgSQ9BpBSals9v2nwu1FIxSD8sl5AAbubBHJrGmv/TsCM2ItsUF+79DW2QI8XEn5VJrPRgtlUoy3pWCf7oMFAebx4TWlo53AGb1zkZsP8LcCb5XgYFIs8/ZC19wExLpTMO77XmtXoT4cOAjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFQYl9jVo95hmSJzFWhR6rpHkEGdFkgEl3u4qvxUmvY=;
 b=DStRPIwjgpvYC5lmsR+qTDXVS1CsET9tOrHbgg3XiBV8OAl4ooVixMX0kPTU/6XbnNa1m0Mow2M1ToNwVNXdYNRhb+MJIFIJ0FzAA4gnSq+inW24HxxklKBqMalT5yMXSjw0zcZgyug6qWZzAPKJFGofFBhf3A2Y8Cltsq5GsrGVtAdGZmcc93yrnj/ZwJvAlaoQ+yDenlGpNSRg2TifzaVVoXyFamZ3TYUoV/oR30RRdVL1RzOv6/AkPWMK6eyLGsnhK5r2UV0ssout6Ib5bP8yQh5/qc8E9Qwcpne/S6o4LICt0CZEs1LDdpKe/LHwugBQ39yJorMpRv0O7XQURw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFQYl9jVo95hmSJzFWhR6rpHkEGdFkgEl3u4qvxUmvY=;
 b=hTszt0w9LLaoMi/6ibEkjLr27gzUz/R4hdTR4ZIBDggsLHT/14MjWDRx4jAZ0M2wazyrnXekqc5q7Zo/CrzL0vZP5OmB8PX6BEVZGieOq/fQzIG61+G9h3cmyQJYLRJfhHnN5jtIbci3QTGrA8bYaMvAuhXIuagHE+Wpck4bqChJ8y87i6NKggNdhOLpdA7+WynEPnQWDW5eOX8+c3xIl/eQCCZGbCLa7KOr/JuN10x/bNtv7wNVDMKeTQ94cCOZPoPbcedhvoABCCAeedI/NE5DN6CbWGWupWc5fb6R4Ly9Ts2axpNg0aS5vddO7J5hdIW5GcGtCWhuDoWrvhVElQ==
Received: from BN8PR16CA0001.namprd16.prod.outlook.com (2603:10b6:408:4c::14)
 by MN2PR12MB3070.namprd12.prod.outlook.com (2603:10b6:208:c1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Thu, 2 Sep
 2021 19:13:10 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::4b) by BN8PR16CA0001.outlook.office365.com
 (2603:10b6:408:4c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Thu, 2 Sep 2021 19:13:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Thu, 2 Sep 2021 19:13:10 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Sep
 2021 19:13:09 +0000
Received: from [172.27.1.70] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Sep 2021
 19:13:07 +0000
Subject: Re: [PATCH 1/1] virtio-blk: remove unneeded "likely" statements
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <oren@nvidia.com>, <linux-block@vger.kernel.org>, <axboe@kernel.dk>
References: <20210830120111.22661-1-mgurtovoy@nvidia.com>
 <YTDnD1c8rk3SWcx9@stefanha-x1.localdomain>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <6800aad7-038a-b251-4ad5-3dc005b0a8a1@nvidia.com>
Date:   Thu, 2 Sep 2021 22:13:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTDnD1c8rk3SWcx9@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25f18023-9b23-41b6-6f9f-08d96e45b428
X-MS-TrafficTypeDiagnostic: MN2PR12MB3070:
X-Microsoft-Antispam-PRVS: <MN2PR12MB307091FEDCF352658A651CEADECE9@MN2PR12MB3070.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CDsKG31REnZ+sWxVppfMJT1XT/hMsQq8WUEjCOd7ucgTgfZ0kn1J4P1QpO+Epec3hAUmlbNqPFYN4WNXIUyxsacN0ZRNctGjVzupI+dMJ8DwB+xgl/idznXyFY9KKLQs/XzMMyZUlZcUT1a3IRICNTqLJSFfGnaNZ1oTJxRSbW1sqje+2xNb+52K0BpqL3fCeafmK8jH84oVmu1BG6wILxiyI1qZU7tMC1ArcHDiziWG7LniWTeKcTy2zFlajqYLyQR5r46EhsILVwdvGF2gWlkfACuVPnI+ChbIIQIBUSoiRJeRS4cpxyHIp5Yt5+Ms8VhVFp8RiUThCRZ5KXgo0F9rjRWOT197eyYFi5JMdxuuG6deaItcHoXJbQlvAiWgYJ/dPIJsq8veGzHRkaRn6I69rm0xvX7lWJgzz+G7pbCmXjycBPrvs8D90b3CmvsrP+xGBxUN+s9f/8eB0hdJstQBPmcn5roirXgtv44UE30L6W40MwLWtmiwrLiUpGOk6i8QW6QdJJ/Ym3xokTkYA5mnj0zkALJOeXK95cUNmZw+4esSlWQ44/9wbo2/RkxzLFcUsdkl1Vo3RV+VV08hv0SEM5xCxfRKj+eD8bzxJ3iDxo7JLrrX9wcqMdd1HtUe8UeS5DfIr7f94BjvxA8vYq+lfhJPUfAw+Y9jDMA5MAokG/ITJ8koFzEEYFdmtWbJJIDO3KGveAlm/0zxtv5ioq8pmgRdOcoJ2WnpGfow1tw=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(46966006)(36840700001)(31696002)(2906002)(70586007)(7636003)(356005)(36860700001)(70206006)(478600001)(6666004)(8936002)(36756003)(82310400003)(336012)(426003)(5660300002)(53546011)(8676002)(82740400003)(86362001)(4326008)(4744005)(16526019)(26005)(186003)(316002)(47076005)(31686004)(2616005)(16576012)(110136005)(36906005)(54906003)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 19:13:10.2244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f18023-9b23-41b6-6f9f-08d96e45b428
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/2/2021 6:00 PM, Stefan Hajnoczi wrote:
> On Mon, Aug 30, 2021 at 03:01:11PM +0300, Max Gurtovoy wrote:
>> Usually we use "likely/unlikely" to optimize the fast path. Remove
>> redundant "likely" statements in the control path to ease on the code.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>   drivers/block/virtio_blk.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> It would be nice to tweak the commit description before merging this. I
> had trouble parsing the second sentence. If I understand correctly the
> purpose of this patch is to make the code simpler and easier to read:
>
>    s/ease on the code/simplify the code and make it easier to read/

I'm ok with this change in commit message.

MST,

can you apply this change if you'll pick this commit ?

-Max.

>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
