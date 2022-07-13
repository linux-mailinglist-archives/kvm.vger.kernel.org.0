Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFB057324B
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 11:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbiGMJRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 05:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiGMJRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 05:17:50 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2070.outbound.protection.outlook.com [40.107.21.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AAEE4F0D
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 02:17:48 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=EjylyWilHplPukg0HA5J6laRbnxlIVug8UblYT4N8G0vDv1VGOVbyHyXFVGx4zuHKIRCyFiPutuDtOgLi7fVMjBczGZUfVtrjVZlsvD1GTRW/AwL+fan9SXANk//6mc7VkcIXJNcMur/xunFBHISd7m9tail0nXQv5o6XS3jQoR/BkDmKUcOLULf7OkHeh5SEnU+N4TIppY4Rq8HFDKBJyrX6kuxvVbAYMaGdEKcBLTB0yEMCaVVeds72PL4t+QTHkyNKvUpqkbZiZSImkpDTAf1mvzgNxf6OqQRUPRPSInrmPbyMSyq8GrL57PtHy6Xaz1ewpy26Tv1OfABTnGdVA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sI5uKP0VFqcOAHkdeHGDPLwV6/S1X3aMEMWAxoB9qoc=;
 b=VOjAC1pBruSYEXiU1kIrRl1GYD+Y0Lvr+Qto/PAOhpZb9r+UMPTGhVNf71bdjjtExhoIxHP20sCtbqZrbGTEbMf29dwplaOuRBDqTUamscBRhXQXUDPZpi5Q7xvE9B1iGuvVQyxTMyU0PTKwNvonnADXfc2Lo8G4JW2LNJBsRGoTt+Z19t7YPZPt+Yb4bM+NB0FnxBGB75WOQ29RJiHx+d8ZmnlQP8jxVN1lg4TdUZa3oP2w16lHEc0WjOtfyA+lCM7ScqAoTo/cvv3FG+uIj2q7EUkIoxz70aVytqHAUdjAEAb6L6SJ0VnBn4H1g7mIIYRurl8+pM+G3A+cn5TWyw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI5uKP0VFqcOAHkdeHGDPLwV6/S1X3aMEMWAxoB9qoc=;
 b=xJ/nfKMTbi1aUf4FoKK0QOoOLzAGRuwcrvoJlfBU4NRnh90xXfNJybuK4hhJGtIeLEFQ3uZdYAgnzfKOBmmi+oYHq4d48oaLk5I4NqOWwrK6oddLi16eKqtZo08LpfkWfus361hbSghwrvDQlZKhtbrKD3/cIuf4pGivwKVkQC8=
Received: from AS9PR06CA0213.eurprd06.prod.outlook.com (2603:10a6:20b:45e::12)
 by PAXPR08MB7020.eurprd08.prod.outlook.com (2603:10a6:102:203::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Wed, 13 Jul
 2022 09:17:45 +0000
Received: from VE1EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:45e:cafe::df) by AS9PR06CA0213.outlook.office365.com
 (2603:10a6:20b:45e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Wed, 13 Jul 2022 09:17:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT007.mail.protection.outlook.com (10.152.18.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 13 Jul 2022 09:17:45 +0000
Received: ("Tessian outbound 13cb25bfb745:v122"); Wed, 13 Jul 2022 09:17:45 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 19ea7bad8c5dd645
X-CR-MTA-TID: 64aa7808
Received: from 62500d6f198b.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3119DBCC-2C3F-4CE4-8C7F-81EF1BFA82EF.1;
        Wed, 13 Jul 2022 09:17:37 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 62500d6f198b.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 13 Jul 2022 09:17:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9OGGu7Xl1rDq4jWKmzgD2IWoEW0E+23PzyX7c8iN2BN89sEZ3aXhRd68/etQYDkwChyM2S45FMmX6OHEyHwXv5BlTVVfJFWoXXPI5010o2uipefGbHa3qiqQVv9H5rZaVH1ctbxjCpXOqSS4OmZ5OoZyfDDVhH+P8tsOUsn9pgbxxz2DV5uzqjJD2+rfSE08GLszLB45BaVDBeLv7BrH86JMlJEpVMKI/eROzNCk0kq3KpTsV+Ul+CpYTu/ZHBmqNjiX+xuFl1bgN9UJQo8amABX3ZXkDoBg/UqUN6TXTpvTsQePO25LwvjjOwQXkAtLxXu+v91S0fl7ETopxeoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sI5uKP0VFqcOAHkdeHGDPLwV6/S1X3aMEMWAxoB9qoc=;
 b=gYamBY0Fi0hZ8Wftv8vGPdlzsZ38HhxDpo0gp71XsMVfzhQU5lwKhRi7asW2sGor310JMQgizNzI0L5lWkFM5OMex+ie8uG361v8FTHfAfBEjPE5PCJ7FbuFQc3XvN6ZntI+wzuP8RXZjPaegAinY93cosGxn4+2cC98BrEvmHKWqsR7n1hh+wcC8TGNwmTzcvlW36LMAZ9Vq0DO5h1etAw0O2gIVTYh2vbgbSXJ+pEKi9MPyWG8ckR3DR9WeQwIhTc+yB57JThOO1XkAiYnriMOHXCJNYBVcAyk6h/7qgTtetOrZKeuNeC4JVvkcAMbaFqK5z2UoE6YHi/nGFjB4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI5uKP0VFqcOAHkdeHGDPLwV6/S1X3aMEMWAxoB9qoc=;
 b=xJ/nfKMTbi1aUf4FoKK0QOoOLzAGRuwcrvoJlfBU4NRnh90xXfNJybuK4hhJGtIeLEFQ3uZdYAgnzfKOBmmi+oYHq4d48oaLk5I4NqOWwrK6oddLi16eKqtZo08LpfkWfus361hbSghwrvDQlZKhtbrKD3/cIuf4pGivwKVkQC8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com (2603:10a6:102:1df::21)
 by DB4PR08MB8150.eurprd08.prod.outlook.com (2603:10a6:10:382::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13; Wed, 13 Jul
 2022 09:17:31 +0000
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::e5a0:dc06:c44a:9e6a]) by PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::e5a0:dc06:c44a:9e6a%6]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 09:17:31 +0000
Message-ID: <679ff55b-e12c-e313-e344-a11805ba50a6@arm.com>
Date:   Wed, 13 Jul 2022 10:17:30 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v3 25/27] arm64: Add support for efi in
 Makefile
Content-Language: en-GB
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, pbonzini@redhat.com,
        jade.alglave@arm.com, ricarkol@google.com
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-26-nikos.nikoleris@arm.com>
 <Ys15pk9rhYr3BS7i@monolith.localdoman>
 <7e3810f6-5fc9-3a29-71c7-1610b8300c1e@arm.com>
 <Ys6GVrYLpM8Yu2Ip@monolith.localdoman>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <Ys6GVrYLpM8Yu2Ip@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO2P123CA0085.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::18) To PAXPR08MB7017.eurprd08.prod.outlook.com
 (2603:10a6:102:1df::21)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: be0d1f0f-e4f7-4395-7040-08da64b08c29
X-MS-TrafficTypeDiagnostic: DB4PR08MB8150:EE_|VE1EUR03FT007:EE_|PAXPR08MB7020:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: zI+KMox8XXbGkkJsr9zH6He46Jh6AeQK9DTSBXrnG8on3Im0x0zT1ZdSvywRhFcGuJ2SJnkCUS5cSJHA6NQ2hj2iTDMOSA0BJJWGJ88GQZMGEQ7jWoZQWrY+37YOfQYetXA7/wxaDUgsgcpj72ll5w1/xY9Jmqjlqx+FUIvDcIysk+E6kXWL4LD5gSj5dIjdvsdwROcJxg96QPrBt4KrwPEY/wriq4K5Ahu6SpecohIhAHohDFHJ217gHgtdPuJwFpLG29aFw+udg+5rL3bBawXEm+iTjNL1NALyfFRi6oaNjZS9sN7iV6KQeQ6H+M9f4Wi3Ouw1357CPKcbAJblswIV1AzUXreGIesx2IB9G5jzXduiTCh5vXDZVwTLpBVQCKn8FBxvNEK6uOisbw1loXGcFGynYEZSnXbYWztAIcQhUjAz6GeLuNGE3TMNhn5mY1XRJYAALvG2BRN5nojKFk1mqwFngUhgV2FK3UzWOY+AG6HPyf5uaU1aLcMNr3d7Z5UP83gZPojaUl2x3ls94EUZm8WLHfIopyl/7bN+cRssDrB49nBjNm/3KFhT31293eD4uBtYN+ULS9OvJHWmqgScQ+lUMTMR9t+dUwQSXSGBakIlj1ywDx7eWwFnoB7O/uS/NY+z258ks1v0Y1OKDeIlhUjBUpIM2NsvJrgBabink+xdZZip7DfvEfz2e+Pd6rQJY8rxZwLFMrDm8N5SQ2OGbCUqHhCE9v0lIOVBElIXTZu1A1z2CjMGfi8ki1h/6mSEARimhPMD0WpAoDnurHl/FMlABuW71CZGMmM7yCfJTFCqCz5vp2FDz/g+898rmPg7/GxbAItwCZrO5/Ll/A==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB7017.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(186003)(6636002)(37006003)(8676002)(66476007)(66946007)(66556008)(4326008)(26005)(6512007)(2616005)(31686004)(36756003)(53546011)(83380400001)(6506007)(31696002)(86362001)(44832011)(6486002)(41300700001)(316002)(5660300002)(2906002)(38100700002)(478600001)(6862004)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8150
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 3f980215-56f3-4268-cd45-08da64b083ca
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TuZc8RKA5ZjPw61cjMOMK3ULQXmorolBO6cN2Xc2yPDz3dHnuujUjDqKhNVdYH/8uK9o+92SNjrzg/22PWc1LdZeufilU1zX1D1Qiskr9TiaGrZMMfHXSYyyvuzIMplknfSx13AkDoK0WtWV8MKbwiltQgpsnMzeJKxbFbXUzHeMHxD/mcbI5RVMSOfGr8xZTBXpC81VDrTIbjQFezhEhknWSk6Vjltu/0/ZkztSOgZG+YeBhtqUklb+cO6JoHFpnjkcNU20Njz0V2t8VwOB8teWtGFjDqCZYTIg3BK+IimAruhEdv3c9OtjhunQGdNvCAVdbvkgtanRQPPD9lTZjvbhPVyJCTLh8gN+QH12LoiMlLaNlC1fygIzMO8ujS1P2emb8V5vQsRxJ5vEb18MMwag5Vfzp1HXpKg575ZAaC/mPszdTxNkhDJmjDazla4F/cpE8DEgriJKOCozSLH7u25bV6v77mlbzu1FzP8khTBn15R1Vn0ISn0J4ZX13nHp1JwsQeJvvKSlp1ZGjXxsPyfnL+nRsApySm3UsEiAsrMZwpWjQtuJH22gFQ0oQwEG7X8gQpHdmmuiBOssdjoVXrIgwurcpsG29Bu+LcKzCyw7B6xNQzpyNIWqlIt09BTcfRFQXlTcBwkQcxuHIQYSZN8WzHtwn540Jnf9AZcPz0IYe7t70ebyfshI82VCwgcwBTe9rdaDFH0sXdYFsSIFN07UdsENjC3CMDyj5CQU4B2yFM1Qej3YZSFfxUuNg9XAQQK3ZUf2IfPaM+FOI92ZGPk0Nhmw0Pb3hGo3WSPEvqAEWfJZkPFbwYEIO9jVBsDgW+F2G+jfKpchb/ZFegjH/Etpoli0kBkbeJ3xGP2/vRc=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(39860400002)(136003)(40470700004)(36840700001)(46966006)(4326008)(83380400001)(2616005)(82310400005)(47076005)(82740400003)(81166007)(26005)(40460700003)(8676002)(6512007)(31686004)(356005)(336012)(70206006)(36756003)(107886003)(186003)(53546011)(478600001)(86362001)(70586007)(40480700001)(316002)(37006003)(6636002)(41300700001)(5660300002)(6506007)(8936002)(6862004)(2906002)(36860700001)(31696002)(44832011)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 09:17:45.3800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be0d1f0f-e4f7-4395-7040-08da64b08c29
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7020
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/2022 09:46, Alexandru Elisei wrote:
> Hi,
>
> On Tue, Jul 12, 2022 at 09:50:51PM +0100, Nikos Nikoleris wrote:
>> Hi Alex,
>>
>> On 12/07/2022 14:39, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> On Thu, Jun 30, 2022 at 11:03:22AM +0100, Nikos Nikoleris wrote:
>>>> Users can now build kvm-unit-tests as efi apps by supplying an extra
>>>> argument when invoking configure:
>>>>
>>>> $> ./configure --enable-efi
>>>>
>>>> This patch is based on an earlier version by
>>>> Andrew Jones <drjones@redhat.com>
>>>>
>>>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>>>> Reviewed-by: Ricardo Koller <ricarkol@google.com>
>>>> ---
>>>>    configure           | 15 ++++++++++++---
>>>>    arm/Makefile.arm    |  6 ++++++
>>>>    arm/Makefile.arm64  | 18 ++++++++++++++----
>>>>    arm/Makefile.common | 45 ++++++++++++++++++++++++++++++++++--------=
---
>>>>    4 files changed, 66 insertions(+), 18 deletions(-)
>>>>
>>>> diff --git a/configure b/configure
>>>> index 5b7daac..2ff9881 100755
>>>> --- a/configure
>>>> +++ b/configure
>>> [..]
>>>> @@ -218,6 +223,10 @@ else
>>>>            echo "arm64 doesn't support page size of $page_size"
>>>>            usage
>>>>        fi
>>>> +    if [ "$efi" =3D 'y' ] && [ "$page_size" !=3D "4096" ]; then
>>>> +        echo "efi must use 4K pages"
>>>> +        exit 1
>>>
>>> Why this restriction?
>>>
>>> The Makefile compiles kvm-unit-tests to run as an UEFI app, it doesn't
>>> compile UEFI itself. As far as I can tell, UEFI is designed to run payl=
oads
>>> with larger page size (it would be pretty silly to not be able to boot =
a
>>> kernel built for 16k or 64k pages with UEFI).
>>>
>>> Is there some limitation that I'm missing?
>>>
>>
>> Technically, we could allow 16k or 64k granules. But to do that we would
>> have to handle cases where the memory map we get from EFI cannot be rema=
pped
>> with the new granules. For example, a region might be 12kB and mapping i=
t
>> with 16k or 64k granules without moving it is impossible.
>
> Hm... From UEFI Specification, Version 2.8, page 35:
>
> "The ARM architecture allows mapping pages at a variety of granularities,
> including 4KiB and 64KiB. If a 64KiB physical page contains any 4KiB page
> with any of the following types listed below, then all 4KiB pages in the
> 64KiB page must use identical ARM Memory Page Attributes (as described in
> Table 7):
>
> =E2=80=94 EfiRuntimeServicesCode
> =E2=80=94 EfiRuntimeServicesData
> =E2=80=94 EfiReserved
> =E2=80=94 EfiACPIMemoryNVS
>
> Mixed attribute mappings within a larger page are not allowed.
>
> Note: This constraint allows a 64K paged based Operating System to safely
> map runtime services memory."
>
> Looking at Table 30. Memory Type Usage after ExitBootServices(), on page
> 160 (I am going to assume that EfiReservedMemoryType is the same as
> EfiReserved), the only region that is required to be mapped for runtime
> services, but isn't mentioned above, is EfiPalCode. The bit about mixed
> attribute mappings within a larger page not being allowed makes me think
> that EfiPalCode can be mapped even if isn't mapped at the start of a 64Ki=
B
> page, as no other memory type can be withing a 64KiB granule. What do you
> think?
>
I wasn't aware of this. So from your explanation, it sounds like if we
have multiple regions in any 64k aligned block then it should be
possible to map them all using the same mapping?

I'll check if we can add rely on this and add some assertions.

> There's no pressing need to have support for all page sizes, from my poin=
t
> of view, it's fine if it's missing from the initial UEFI support. But I
> would appreciate a comment in the code or an explanation in the commit
> message (or both), because it looks very arbitrary as it is right now. At
> the very least this will serve as a nice reminder of what still needs to =
be
> done for full UEFI support.

If it's just removing the check in configure and adding assertions in
lib/arm/setup.c it shouldn't be a big problem.

Thanks,

Nikos

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
