Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AB358D9F2
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 15:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244672AbiHINx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 09:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239746AbiHINx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 09:53:56 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80077.outbound.protection.outlook.com [40.107.8.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C5B2610
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 06:53:54 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=DbCeHyVdRMVm9RcqgejGuWvfmDxvQREDrVKT4RIgu1pCgEIWzDicfAl0FRl1dZ8ovQMDyvhsDFHE+VUiOjP6gldjWBSXBWPukpF0RDZ1WdBDQyAF83u1evGIt8xDuqvwJXZGoMjXCGfidIPi1LJR7Xa1GGXPHX4aWAvNznQ7DJbCZ1785uv5M4XYOlBReHooVdTmmIXsPP/kzAcwIrUHrWWRJKRNosaACTnMrP9nb0gXZDPd7pzZNWT561Q5s5R59th3cZJZJWJtnbxp4JN/Y0rE3xad7DZGQ23Di2Y5Qs+d2eBI+YKkMpIliuZFNJyriezZB+z299XQURlgq+CZQg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCDv48U3BLl490S4d2Gd37kg/2WlkPVnCcewTiOQ4gE=;
 b=NJJKARDk9a/U04MhO/Su49k/JQcGJODxLwrVOEYyqvaC81a2I/YHYWy8v9i2fhuF0oSifYgNJG7H4Q5Vn/AECRkSWTIBBGcCvAPUw0bWY0FBPY+LV6Nq3y4WkLsbjJSr276L62Te3kanaCaFdlx5iKdp8U/TYtzG3gXAgf+Sz/frQrvkvUVjY7UrBEBpbRG4SvPW1+pQm8CdOtxS6qIEzeJxoSr7XquL7awxzSLec1xvBgqWfJz7Fd15Z3OchkRm2mShXEpjYu2XFdafML34OUFmZp0+J2zb2snsmc86CXgfx69cnq/yAAWDFHiuQ3YU4q92PUX6u0exTuh6PPOYbQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCDv48U3BLl490S4d2Gd37kg/2WlkPVnCcewTiOQ4gE=;
 b=h61R5Cy3TOFcENXvDWGm9jHQd4cFIKjOxPMEjUuz5zCcX1k30sRGoEGQM+wkOFYbYIPjRlXFOVOpWm/e1t0yRnTFt+4QwKAPij6UJ0EETsBBmLiGsYzBGkeR3vWDrRIg70WhqfuiZOLoOKpSn9b8XyZTfXn4uqwz5yQLDtewrKA=
Received: from DU2P251CA0015.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::19)
 by DB7PR08MB3275.eurprd08.prod.outlook.com (2603:10a6:5:24::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 13:53:51 +0000
Received: from DBAEUR03FT051.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:230:cafe::20) by DU2P251CA0015.outlook.office365.com
 (2603:10a6:10:230::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.21 via Frontend
 Transport; Tue, 9 Aug 2022 13:53:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT051.mail.protection.outlook.com (100.127.142.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16 via Frontend Transport; Tue, 9 Aug 2022 13:53:51 +0000
Received: ("Tessian outbound fa99bf31ee7d:v123"); Tue, 09 Aug 2022 13:53:51 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 0e11ca4bd0cb821e
X-CR-MTA-TID: 64aa7808
Received: from b1dbd22baf1b.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 673CA2B8-717E-4042-A88F-F9A388FF180D.1;
        Tue, 09 Aug 2022 13:53:44 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b1dbd22baf1b.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 09 Aug 2022 13:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhyYnuvT+4obDFJikM/BMsqSHmSALvpQZYOrbTiMztdp9b4V8HA9zOAq1r/JLrtHOph3e5XHa/N/nCcKDlllil9P8/HmkiemIKdcrvToNDoI1WiPiSliXxm8dq+S7/QgIC3ciK6fXHJZpckiKr7AUBOecAoE+G0n2UsIIXdVhOnAvQrJWbYDYX5ub/bml48PM83duHjuJG6G1eAA/QVV1ByWyTd9w1EYolF5pdVqJS89Kmyg38d8XvLvj6pBWWp9Dq4QY8evR2IRerFvp4M13FnTgjsLq/dCSig1WkDIcHnBQlqinC0vfvt05w1Ngn1hjuXF2aNnInFaviVUemrR7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCDv48U3BLl490S4d2Gd37kg/2WlkPVnCcewTiOQ4gE=;
 b=ethCCN4+s74sHYvVkWyL+YkBxWz/Stq9KyN2GEB4ckud8pCe1OL3L660ItCpPkxDJZv46+yn8DB/oGnjfsubr1qp9rqyxX/1tK/4Zkuaunj/Dd6Eh4sTWoTK9IhVaUBx4gbq7/Vm3a7K6JrrdhKNTg7zCgIRlHQXAKe416ZKi486Y4WSoF9l9FHk+tiOkVFjvZ0DqUPKIFznRxzBhCJHTNRYFKAH/buiEC63TFu0sUl8NWl0cIO57q1fzrfrO/KhZMn0DOuC32LSFVdbBLJRt0iIXbuOJEdI57jdgnjYg1bR+VrVoq1QmSBIwWfVuZUMZEP4EDgUsmLWpPaMD188pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCDv48U3BLl490S4d2Gd37kg/2WlkPVnCcewTiOQ4gE=;
 b=h61R5Cy3TOFcENXvDWGm9jHQd4cFIKjOxPMEjUuz5zCcX1k30sRGoEGQM+wkOFYbYIPjRlXFOVOpWm/e1t0yRnTFt+4QwKAPij6UJ0EETsBBmLiGsYzBGkeR3vWDrRIg70WhqfuiZOLoOKpSn9b8XyZTfXn4uqwz5yQLDtewrKA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com (2603:10a6:102:1df::21)
 by AS8PR08MB8222.eurprd08.prod.outlook.com (2603:10a6:20b:52a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Tue, 9 Aug
 2022 13:53:41 +0000
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::3199:7b81:627:45e9]) by PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::3199:7b81:627:45e9%7]) with mapi id 15.20.5504.021; Tue, 9 Aug 2022
 13:53:40 +0000
Message-ID: <3fba260d-bfca-14ea-7bdd-3e55f3d1e276@arm.com>
Date:   Tue, 9 Aug 2022 14:53:34 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests RFC PATCH 19/19] arm/arm64: Rework the cache
 maintenance in asm_mmu_disable
Content-Language: en-GB
To:     Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
        thuth@redhat.com, andrew.jones@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-20-alexandru.elisei@arm.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20220809091558.14379-20-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0313.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::12) To PAXPR08MB7017.eurprd08.prod.outlook.com
 (2603:10a6:102:1df::21)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 2c2783ff-37ea-4c5a-f0ab-08da7a0e9752
X-MS-TrafficTypeDiagnostic: AS8PR08MB8222:EE_|DBAEUR03FT051:EE_|DB7PR08MB3275:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: mVP0v+OJusJOd40RZ2uNA5fD/BzvCK2GKSdaj1x0IJqA4uoG2qHvwwmKugpnFEpkmy4Py58XWszaQkZEGwms/tUWMD1u73FEfN9IQAC0eAPjR+Jm0cduV5lNVGJtpihpNGWO6ONpLqdcVhRUVJqI9EXYpig0qqHyGbcylBZ42VFBM8jfx2h630ey4Js83gXC36EymtcfspmUqiZKAXclJfKHd1qKqXtU1dwYQ3o9i1QyeIwzInmRV0OQj9emLwmMOXFZgZwYmNSRIlZSfwNojNjod6lTr1aMCOsVQ7QOwE2yr5sh03xkhmrpN/eLljGwjY527zzp3TCJ+1F1Wwhv8KB2JVvoltiPRJVWMBO74DrUGO1N6JJdYAh9zgHnBjGuymcpoGrdHLISWCWOpo5NdAXuhnNcIsLGpBhnswAkT5G1C5lY77xYo7rboszGBWC/0cIb2Q6mQZ176qn2n+al0dPwWNyOZL0NjfGmGxKz+dOgfjazBcIix5QjAgEM+wQnNKFCKygWGod8ijfAQynTIjLSRqrRSi85t1NxcP/HOKrv3G0HtLzBO38UfizbmMzligRt5CK9GC2IqguLrL6uUdNcEGD7Gmdaje9vcAnC76u6ht2np7NZiBe9HEdG/f+ns97HequAZGKW7WCc1JYoaSO3NzGsjszL7QA2R665M6CyXrjfMNLUJQDgrzb8MB/YStefh2+BW6JBlF6wAq8rsISliHg2vKuT2PQNSIUng6rSR6BFnJYdLos1cSZ07Km24OxDB5ruq91cmM0nzBvVdpgZAX8JuGdCiMI1xVV8lCbJN6SyONNM9mDuCWooUIQGbFEW+SWHf1Rptf6wnwBF5Q==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB7017.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(6486002)(5660300002)(478600001)(8936002)(31686004)(8676002)(66476007)(66556008)(316002)(44832011)(36756003)(31696002)(2906002)(26005)(66946007)(38100700002)(186003)(6666004)(53546011)(6506007)(83380400001)(41300700001)(6512007)(2616005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8222
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT051.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: c44f3dec-778a-48e3-543b-08da7a0e90f4
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKOCJfNJItsEB9T8cfW53rd36eOMVyJjzLtWmP3vlns1JAHNL06EE0v0diV413FHHu67e4F3DjjltIF0SgLU7Xem4iaJ9il0MZuBW9D6jxgwI4jXZlhfhJL/q7z4yb+d1+/8zxKIaQzPNnL8FIGK+XbHqMjWc63NJ5Ui8e7Pf4xdIalWFhvyxjziFUuzZnSTxQiZtVicTtUNVN4m1vltdzpYrOJSs/i9e8T7cqU6zcY+T1Q3GWr28N0Dib52ZoLIMRXMwtzMGMSiuw6+dsFEyQAJG1mln9Kfq9my+wRA4CDowNNOqaL1upUhN+jhPInGVlSU63TkYNNrxWRNSUhrm1Ly8rhOoEmjex3dR7bsJlGAOqqMR+oAtrVkg0TaHJ7MHMYxp+0fgU1SkVFXYwzp3Orw9qIEJZxHsOUQXtzejzc3JpPOA0cuTi01p0aWkg15m2F/nn8N7srJXpzgPazoFGhi0SFk3I4xSXX7aKrV4FzjFhubd9l7Vlov5wetY5Lbkz9Pvn2TTviVK8YzsqEkm7Miivru0JLELBPBNaXkECQxkFQAZuGKZh5fiwo7UICXEidtbp6wJABIy7+E+5App+EnGcmzMQ5FmLuliLT0uajwR0pl27xamCFg2TgKfCujS6eapOerheREhSlE5SOndIUtfmJbXp1g8NWQoujRZtRTKl+tLKdfqqn1n/ZAOhwEZUn4QV+hWSSYOh53QWmgrg8nH2DKGLKZt4ZebNDVMXFU3ne7bSNJJjll6HEeEXWwHllgnRJNEVVnHC+jyVMLZDhu1PmIn9q3VnVSDwZSpYeYUyutQxTwuohq3t7/CzBWAtfUokcCW2eoIvBuEjM8Pg==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(36840700001)(40470700004)(8676002)(6512007)(478600001)(186003)(83380400001)(2616005)(70206006)(70586007)(47076005)(82310400005)(86362001)(31696002)(6486002)(40480700001)(6506007)(41300700001)(53546011)(316002)(6666004)(26005)(336012)(81166007)(2906002)(31686004)(36756003)(40460700003)(44832011)(8936002)(356005)(36860700001)(82740400003)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 13:53:51.3272
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c2783ff-37ea-4c5a-f0ab-08da7a0e9752
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT051.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3275
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 09/08/2022 10:15, Alexandru Elisei wrote:
> asm_mmu_disable is overly ambitious and provably incorrect:
>
> 1. It tries to clean and invalidate the data caches for the *entire*
> memory, which is highly unnecessary, as it's very unlikely that a test
> will write to the entire memory, and even more unlikely that a test will
> modify the text section of the test image.
>

While it appears that we don't modify the text section, there is some
loading happening before we start executing a test. Are you sure that
the loader doesn't leave the memory dirty?

> 2. There is no corresponding dcache invalidate command for the entire
> memory in asm_mmu_enable, leaving it up to the test that disabled the
> MMU to do the cache maintenance in an asymmetrical fashion: only for
> re-enabling the MMU, but not for disabling it.
>
> 3. It's missing the DMB SY memory barrier to ensure that the dcache
> maintenance is performed after the last store executed in program order
> before calling asm_mmu_disable.
>

I am not sure why this is needed. In general, iiuc, a store to location
x followed by a DC CVAC to x in program order don't need an barrier (see
Arm ARM ARM DDI 0487G.b "Data cache maintenance instructions" at K11.5.1
and "Ordering and completion of data and instruction cache instructions"
at D4-2656). It doesn't hurt to have it but I think it's unnecessary.

Thanks,

Nikos

> Fix all of the issues in one go, by doing the cache maintenance only for
> the stack, as that is out of the control of the C code, and add the missi=
ng
> memory barrier.
>
> The code used to test that mmu_disable works correctly is similar to the
> code used to test commit 410b3bf09e76 ("arm/arm64: Perform dcache clean
> + invalidate after turning MMU off"), with extra cache maintenance
> added:
>
> +#include <alloc_page.h>
> +#include <asm/cacheflush.h>
> +#include <asm/mmu.h>
>   int main(int argc, char **argv)
>   {
> +       int *x =3D alloc_page();
> +       bool pass =3D true;
> +       int i;
> +
> +       for  (i =3D 0; i < 1000000; i++) {
> +               *x =3D 0x42;
> +               dcache_clean_addr_poc((unsigned long)x);
> +               mmu_disable();
> +               if (*x !=3D 0x42) {
> +                       pass =3D false;
> +                       break;
> +               }
> +               *x =3D 0x50;
> +               /* Needed for the invalidation only. */
> +               dcache_clean_inval_addr_poc((unsigned long)x);
> +               mmu_enable(current_thread_info()->pgtable);
> +               if (*x !=3D 0x50) {
> +                       pass =3D false;
> +                       break;
> +               }
> +       }
> +       report(pass, "MMU disable cache maintenance");
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arm/cstart.S   | 11 ++++++-----
>   arm/cstart64.S | 11 +++++------
>   2 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/arm/cstart.S b/arm/cstart.S
> index fc7c558802f1..b27de44f30a6 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -242,11 +242,12 @@ asm_mmu_disable:
>       mcr     p15, 0, r0, c1, c0, 0
>       isb
>
> -     ldr     r0, =3D__phys_offset
> -     ldr     r0, [r0]
> -     ldr     r1, =3D__phys_end
> -     ldr     r1, [r1]
> -     dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
> +     dmb     sy
> +     mov     r0, sp
> +     lsr     r0, #THREAD_SHIFT
> +     lsl     r0, #THREAD_SHIFT
> +     add     r1, r0, #THREAD_SIZE
> +     dcache_by_line_op dccmvac, sy, r0, r1, r3, r4
>
>       mov     pc, lr
>
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 1ce6b9e14d23..af4970775298 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -283,12 +283,11 @@ asm_mmu_disable:
>       msr     sctlr_el1, x0
>       isb
>
> -     /* Clean + invalidate the entire memory */
> -     adrp    x0, __phys_offset
> -     ldr     x0, [x0, :lo12:__phys_offset]
> -     adrp    x1, __phys_end
> -     ldr     x1, [x1, :lo12:__phys_end]
> -     dcache_by_line_op civac, sy, x0, x1, x2, x3
> +     dmb     sy
> +     mov     x9, sp
> +     and     x9, x9, #THREAD_MASK
> +     add     x10, x9, #THREAD_SIZE
> +     dcache_by_line_op cvac, sy, x9, x10, x11, x12
>
>       ret
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
