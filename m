Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B845A008E
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 19:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbiHXRkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 13:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240260AbiHXRkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 13:40:36 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2078.outbound.protection.outlook.com [40.107.104.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502347C52A;
        Wed, 24 Aug 2022 10:40:35 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=aHTPR2OxBJLqjAZxLmPFGPFCcdFENwOkTqLQHyw6DTJ3NJlK8SHjztwAnxWpysGC5NVxN/Yin4qAEgQ5AdNLJWDTfMy3vGUPeMeec0AR37IoX9HaoUoP85N02Qp4e/a7RCCLk+xW2+etOt5KOKGn3kPokN2I0GThktvUaXHBeZvCxf71cAYzCX3CSUhFkYzFatX0U9fi4dj/GwvhG54sz7pbCKzHxsx+cGbcEI4svjTr/QG119iU4B7aDEOTLAY0Mc/G9EezqrXhzSUVK/bRXd+qwSUTUkqp1Pb0RUMdgr0VchUG0WL5di9tcGv/EDkMw4pyWdbPVPPxT/hGkE8O3g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bM3NU/bL0nZHlk4kwrx+1jlhPFQOsK2oGf5febQz9M=;
 b=Oc8TZQyFzHMRX94uU2UMDFSsB0J7bUir4S4yFsiRM3ToO4j7wNMsIr52OhcLg5oQZC5VTC+HITDiqKUA6gifjdHxNTg0KY7zdLKRSb/+Unza/giash3/5uksr5E22JcJv2G8Ybjhke3aSvLQYxtyons1twJmJOoXTWINDthy7nPpttOJHHBNaeFtO6XFx15fbcd8BOrRiByZGuCxWUuLBdkVTV7Y0OO0AyPU7oPtUJL8RF55smPKTRkLhQ3xp13taj7zgQKx6plSiQlatulw/Q6tx1W/8bTW0o62MG9Yne9KczL4qKnZQZKSy1yEvZC1VXkR1TdBS0u1ahb2LND0Iw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bM3NU/bL0nZHlk4kwrx+1jlhPFQOsK2oGf5febQz9M=;
 b=E8K3tfgYR16XXoMvgyl8eGf1mu6pJ2Vz9SP6C7nWdksjoSj7j732oqSL2Vj4CEU+rU+th9Ur/xboM3IftsX6vKHQKzNHZixk97Ndw3fPO+DBSRHe3gDhYXjaTWStxU+gZKMfmN51iZwyFrd8RetdBk7zmPObkn3sX7IDczlzJLM=
Received: from DU2PR04CA0007.eurprd04.prod.outlook.com (2603:10a6:10:3b::12)
 by PAXPR08MB6944.eurprd08.prod.outlook.com (2603:10a6:102:137::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 17:40:31 +0000
Received: from DBAEUR03FT040.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:3b:cafe::bf) by DU2PR04CA0007.outlook.office365.com
 (2603:10a6:10:3b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 17:40:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT040.mail.protection.outlook.com (100.127.142.157) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 17:40:31 +0000
Received: ("Tessian outbound fa99bf31ee7d:v123"); Wed, 24 Aug 2022 17:40:31 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 02f4580d91b07a39
X-CR-MTA-TID: 64aa7808
Received: from f1ec42e7c881.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3F56B78B-D386-4307-B5DF-E9B104D80ED6.1;
        Wed, 24 Aug 2022 17:40:20 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f1ec42e7c881.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 24 Aug 2022 17:40:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRBOlOmDwH3O7fbFwOcMejMebPsCsh4rDBsyhg1z+X7oXGu07BA9cHk/JQcj2WdJ5nDhKhX+ivXnztT7aX1xy2Q6mWYgwwFg/UOfsBKeeyWvetS+c1Vww3gJ4yqrzbB2HJHIO359JkayWA+Wya7q1mFx3ryzAH9tsCbOUyxlMCU8bet3zmL0Tk7hfY8JHn90CPG5wvtskxrdG3U7nScoKmhkoFq8uQjnnIKVA4hyZtbM+MCPLaD3qoNWk5HEujoutlXy49JNdozlkPjDCiBT5aEtsJc8qrXY4WmQpfx9cL9KlrfFmyEgPDeJnZyZ+6X/hFDUTe+duG++W+81rpky0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bM3NU/bL0nZHlk4kwrx+1jlhPFQOsK2oGf5febQz9M=;
 b=YqaKnTu6Q0CONrNktIpGGi/fKlIxeFj5SMvWhR0Neyk97oFjmZRKrRqPJfZY0Gzf+OIz6ErL1lAgkE9Dsa+Vut7HG9TO7kror2SAAJoShPzFDmyau1HESKQVztK0BQq8jTZRR4hEGvytzPtye7XDJ2BKDOGlUhcmxhOABnuFKiJWAD9KDvin90c+LMFfkt0NSvrZ9nTPzADR+ca7o48/YhAtDjXPxpjlGOkhdysEXZpQqoISx1FFesRTY9k4BTqt0cUHKMB8KT80Xg4Ul+LhVXSmZjN5i4FlQsgfjg9NMSZ6GS3FC160S4wJDznWXbhPLtev6m+JXnTfoa2Kx2EhpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bM3NU/bL0nZHlk4kwrx+1jlhPFQOsK2oGf5febQz9M=;
 b=E8K3tfgYR16XXoMvgyl8eGf1mu6pJ2Vz9SP6C7nWdksjoSj7j732oqSL2Vj4CEU+rU+th9Ur/xboM3IftsX6vKHQKzNHZixk97Ndw3fPO+DBSRHe3gDhYXjaTWStxU+gZKMfmN51iZwyFrd8RetdBk7zmPObkn3sX7IDczlzJLM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by AM9PR08MB6997.eurprd08.prod.outlook.com (2603:10a6:20b:418::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 17:40:17 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559%4]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 17:40:17 +0000
Message-ID: <69b50235-b77d-5310-2cc6-040f936b8864@arm.com>
Date:   Wed, 24 Aug 2022 18:40:13 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
Subject: Re: [PATCH v7 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang@google.com, Shaoqin <shaoqin.huang@intel.com>,
        Linux-MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        nd@arm.com
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-2-yosryahmed@google.com>
 <5ac13c91-0e42-533b-42d0-c78573c7aef3@arm.com>
 <CAJD7tkbn7mFvf0oiUKPZtu92GtuMht-s5iPBRfEuUfTxXC_j8Q@mail.gmail.com>
From:   Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <CAJD7tkbn7mFvf0oiUKPZtu92GtuMht-s5iPBRfEuUfTxXC_j8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0022.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::17) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 6494d44f-16ae-4397-6715-08da85f7be10
X-MS-TrafficTypeDiagnostic: AM9PR08MB6997:EE_|DBAEUR03FT040:EE_|PAXPR08MB6944:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 7G6m6EeEYKRlZaosUmCJht9vP9OlW5WbdQ3sai/Bhhh1YH0P8E4JGYPVm0ogJom5ZuaHPLXsWtcZ0mdsswl8IwV1awGTP5KzORs3kz4T2C8/E3lsjFQmvYD8o0ksdQAO7kNWMb4U9ayGEBdg6aAklUUtPza2plHxn2IRoLU03vYdXgHYHY8mLuFy/E31pew0WGBDtOo1phOhh/LjD5Otkc7Hv0IiLccWcAfQCQeFuTTyUSn0Pjvl1BmNT+PwibmzXdY5mZLD8q9Rpk+EsOw4QwBLqxcex813xEUWb4B0KU4eF8KJtO9bsC12v8sg99sv/tMhMt7kTBXjxVzupd8llzr39orYVLHta/65/nAE1fisDADLlzpn90lWaXLdRwHcA9OSV8mEcR0oSgaZ0aF6XrvWDpJbDCgpL2AMds3Ynrs0JQLHVU/TWr8ujLRO/wmtMYsOc3APLbv6hrEilHJH7H/4lA28bFUacOlFwt10R0gzfcmdmppjsUQgOTvwOV/3FG7X6HT9OyKK7EMFefd7IPmwPLrddaPtnJW7wgLVWVhwJ8FIrCdu+d7NO7vWgLZxlRAMWCl1bKh1YbXsGr8zmb25Z8wS0/5LTyPN+v2D7djlgNmIKthAvE+gJeQcAkfK6ZEHQUaOvqOmjxvUJFp8HKH3qpu/+6VWgLICF17SCN0O9w9II+fQDXdZ0aPvTDYdvJmbS+u09NOpl04ORJ1j3lvNb5kOFR6oCfDj6gOHInb0K0K8Jj9bwkG6dI8NiukgUDcM20wOp2FYot3INvSYK+qdByoLZM/M771XsA+F3r0=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6995.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(8936002)(6916009)(2616005)(316002)(41300700001)(83380400001)(44832011)(36756003)(38100700002)(31686004)(186003)(54906003)(8676002)(66556008)(66946007)(4326008)(478600001)(6506007)(6666004)(53546011)(31696002)(2906002)(7416002)(5660300002)(66476007)(6512007)(6486002)(26005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6997
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: b1ae2a65-6c02-492f-cec1-08da85f7b489
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bb2aM7udMtePNZOVeD8ak2NXJ39Dyb46HU0af6Pm84KJEAQoksC5ycDVIGzVVqZDQyO/U8FMdnc6t+rHOwLIvEQ54RKLrKRN6wiQDW16xod+d6yTwgaj0FcihY+9chKHDf2jThRvK0bN2rJ29kvT9nqF1ziVJHjvUSax5BbiWA8H9vHDKbPHZjCPKfVUYSDZRYtUtZ96prrRBIhZ2XQupoa4581V+pZ0xqk7P6FNJVMIe2SLlYlWzZ/Fan25+S1FU4lhLaANGCRbGA2BSOe1OyrC0Qll6+fkcZtFZmJDUOSyX+1+b2Q4NETIQUUqK7Kd6TEONRRgkRPGGSMfZXrbPsBYHT89iwLnjS8gjkkfgvvTso0WpthsDYks9BjVxtNIWcG9ipGcHLWwMTE95ndlD/3lt65Ul22Xf8nQRhOqVZIXPrvgDp/inXWWHAEzsvK+GfsKeL+U8UlFqfthsR31JdPDCfQPXDNDgOiPMjh/PI14u3ufgoiAbQXcN+xo4La9I5NFAJzNK1XFGRjfqogQE2VHFTuAR7JBpdvcNWAfC0yJWqd4Y3Aat73Zt7qNTZHCzuTxXcD7tbkvKJOXzkw7Rm8704r5UCUB8sS8gQFRU3PHHlNVEHDUpd6AV9P3ZMEsxTxAiMlz/7F6xQjW1P5Qz3GX53EXy+aHxH7LXCrDld4x5Ou0AgmzWDyz/ovGAHagVQXtmows/l+ouFPjXXpc7Byh3ALdub9sgaqHkstfEYPZ3UC7ZXjooXiT9QWRZgJ8hsKr92mBeYTEAkiye56j6beRYRwgiDtOrx1DLSHPHV5OY2kB8MzCO/O0FHInDfRW
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(40470700004)(36840700001)(46966006)(81166007)(54906003)(356005)(83380400001)(31696002)(2906002)(316002)(31686004)(82740400003)(82310400005)(6506007)(186003)(36756003)(336012)(6862004)(26005)(6486002)(8936002)(6666004)(8676002)(41300700001)(478600001)(6512007)(4326008)(36860700001)(70586007)(40460700003)(450100002)(70206006)(47076005)(2616005)(40480700001)(53546011)(86362001)(5660300002)(44832011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 17:40:31.8352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6494d44f-16ae-4397-6715-08da85f7be10
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6944
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/08/2022 18:25, Yosry Ahmed wrote:
> On Wed, Aug 24, 2022 at 6:42 AM Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>>> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
>>> index e7aafc82be99..898c99eae8e4 100644
>>> --- a/Documentation/filesystems/proc.rst
>>> +++ b/Documentation/filesystems/proc.rst
>>> @@ -982,6 +982,7 @@ Example output. You may not have all of these fields.
>>>        SUnreclaim:       142336 kB
>>>        KernelStack:       11168 kB
>>>        PageTables:        20540 kB
>>> +    SecPageTables:         0 kB
>>>        NFS_Unstable:          0 kB
>>>        Bounce:                0 kB
>>>        WritebackTmp:          0 kB
>>> @@ -1090,6 +1091,9 @@ KernelStack
>>>                  Memory consumed by the kernel stacks of all tasks
>>>    PageTables
>>>                  Memory consumed by userspace page tables
>>> +SecPageTables
>>> +              Memory consumed by secondary page tables, this currently
>>> +              currently includes KVM mmu allocations on x86 and arm64.
>>
>> nit: I think you have a typo here: "currently currently".
> 
> Sorry I missed this, thanks for catching it. The below diff fixes it
> (let me know if I need to send v8 for this, hopefully not).
> 
> diff --git a/Documentation/filesystems/proc.rst
> b/Documentation/filesystems/proc.rst
> index 898c99eae8e4..0b3778ec12e1 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -1093,7 +1093,7 @@ PageTables
>                 Memory consumed by userspace page tables
>   SecPageTables
>                 Memory consumed by secondary page tables, this currently
> -              currently includes KVM mmu allocations on x86 and arm64.
> +              includes KVM mmu allocations on x86 and arm64.
>   NFS_Unstable
>                 Always zero. Previous counted pages which had been written to
>                 the server, but has not been committed to stable storage.
> 

Looks good to me!


