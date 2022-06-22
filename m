Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A023554C76
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358346AbiFVOOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358199AbiFVOOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:14:31 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150059.outbound.protection.outlook.com [40.107.15.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9BD2BB22
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 07:14:13 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=Qz9rDW9aS7jXJwNYQZQhV0YmHbMqwQGRYlhbsOmIqqn1Ze72PR7vzeaQMpbtZWCLY4tnMYwsv6HzlzZv/WZ21WItJJDELGBku3CV5/KAFoJIWqaxz+wlPCm1JciSCtcHkaNXDub0W923GDXfV/c1ldmjEFWRgZxq0IN/gM3M6vT9A1W05KH3l+nDebVznS4UKnhrtQkz+EoDvRM50cFwsTM44Xb4Cx5ZBWOFvnDndTzRVSJEbFnzIRx/S2D8LwAlMAcEfLGQR7PaNbzHwEFDIdDhtSRV1Ez7oNWI4LLme4o5r85cNWf7oFdf0HTaWeFe1RigYD2zrxR8hOOmI7mzRA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miIZGjKcrTF2z7iOaG0YoX2wA/cNh6eTOi81jbIAds4=;
 b=k9Z553c3yXeENVn8xLn9SynqVTQacR4CSfvbAFdh9lzn60LdOfcC0MNlPGK6YWd/mG8O2b/S7FbIMg2XqW3dD7kce/Fv3wXkLniDzCCTXGzk7P0Xv33ko2huvsyGB0iL0YjVW2VMpJwou3hgTxKjD5OVhjTTGUdSlTAhvsUKgt3AsXWeH6TNRi5ohhJUuGPKaRJLrlar4r6hrirdNZ6buHP7b2NARQEJPNwNp4jAkrGARHYaLmd99mZFCJEfEdGyrYc+ygeKGUTp04Ivtz/njt3kvZEfJOUP1lOaD+CfD5SZT3GVS5kTe88JP7VexGlDR+ctZs4qPImKO3j1GhiAGA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miIZGjKcrTF2z7iOaG0YoX2wA/cNh6eTOi81jbIAds4=;
 b=Ul5ehCIGSya4Xv1khUlI9dUftSVHlglXtitlCKVxTKxj3UzGXv0Pyyl+YoUvjoyYucDStlgN4KvMuRffYUeU01cSRpuNX2OTPcG5vhG0eLKZtwB3ULixaxGOi19SJ6ifS5wvcWQNeF0Ua7a0xVxnQfFUQ2aVDDjjZKFCBLbqPaY=
Received: from DB3PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:8::16) by
 DB9PR08MB6714.eurprd08.prod.outlook.com (2603:10a6:10:2a4::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.15; Wed, 22 Jun 2022 14:14:11 +0000
Received: from DBAEUR03FT020.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:8:0:cafe::92) by DB3PR08CA0003.outlook.office365.com
 (2603:10a6:8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 22 Jun 2022 14:14:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT020.mail.protection.outlook.com (100.127.143.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 22 Jun 2022 14:14:11 +0000
Received: ("Tessian outbound d3318d0cda7b:v120"); Wed, 22 Jun 2022 14:14:11 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: a88618268001a5ae
X-CR-MTA-TID: 64aa7808
Received: from 0051d3011230.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id EFD47AB6-A749-442E-8856-0F6FE84DBC86.1;
        Wed, 22 Jun 2022 14:14:00 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0051d3011230.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 22 Jun 2022 14:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epj0Aai/3b5ofhROv4y6Qb3np5PcZZ3J4Nlap8rfKn7q8Ic4PkpJHwD5was7kDhHbtQfIAvBL+KXADxF8uMnG4L8SZKxAr6fS/a6Sc283D6zH3ZIZrfkAxY87EccBAgzXI+YHA9A4lyCK2yMqKLMlxp5FtjQMa/bpb6QbXMcsHLmXDTi0C59+1HRqr0BPhFu5teB9WEMMFtQICk24FF9fdY6cOYBaJnulvImtvgPd8aLSigYfzZSah5KQ73T3lBx3SNrI3mKOSRuIYa9YtEsLtSBliwtXLgaT0OHHTXs32LNmsTeS8XzTLasMIj4YuPhqGHG3i2LXgmI68meAbQHkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miIZGjKcrTF2z7iOaG0YoX2wA/cNh6eTOi81jbIAds4=;
 b=KBVX10cPusoSBH/u+J2wooJGObGUwt7sbwmjtxUqA5tyBsUV34qp/a4ijYkuR6M87EcnGcNTAT2ztA6IYknsXfqQMIgaMYosBuW7Qpb9hMcwspteBRbbbUYiUhg6t2cMRjn8fQCSTWEhPIn39FmwKshis28mLS/sgjmOi8TC3rrDuGMoggJmMdymZIrop9bK6A4ZOVL7s9AzeVeDabjBFB3vNTlhZ3TnO/aBMdr9rC/DIJfUsmWXmPrn1LNFE2slJitUnc1EslxtUZLYvP9q+Mlb/H0BZ6/MjxvtstB9iRZcE/uyXl3V8K+sMtUjQ58OEJbRYMJF0ElFLD1G8/Mk8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miIZGjKcrTF2z7iOaG0YoX2wA/cNh6eTOi81jbIAds4=;
 b=Ul5ehCIGSya4Xv1khUlI9dUftSVHlglXtitlCKVxTKxj3UzGXv0Pyyl+YoUvjoyYucDStlgN4KvMuRffYUeU01cSRpuNX2OTPcG5vhG0eLKZtwB3ULixaxGOi19SJ6ifS5wvcWQNeF0Ua7a0xVxnQfFUQ2aVDDjjZKFCBLbqPaY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com (2603:10a6:102:1df::21)
 by HE1PR0802MB2250.eurprd08.prod.outlook.com (2603:10a6:3:c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Wed, 22 Jun
 2022 14:13:58 +0000
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::e5a0:dc06:c44a:9e6a]) by PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::e5a0:dc06:c44a:9e6a%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 14:13:58 +0000
Message-ID: <b4b03930-3132-9632-c091-3d968ba5aa7b@arm.com>
Date:   Wed, 22 Jun 2022 15:13:56 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 23/23] arm64: Add an efi/run script
Content-Language: en-GB
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-24-nikos.nikoleris@arm.com>
 <YrJPsmon33EAfe54@google.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <YrJPsmon33EAfe54@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0461.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::16) To PAXPR08MB7017.eurprd08.prod.outlook.com
 (2603:10a6:102:1df::21)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: efca1461-2004-42e2-fe47-08da54597ad8
X-MS-TrafficTypeDiagnostic: HE1PR0802MB2250:EE_|DBAEUR03FT020:EE_|DB9PR08MB6714:EE_
X-Microsoft-Antispam-PRVS: <DB9PR08MB6714C3FA8EB4E0B68891BB91F7B29@DB9PR08MB6714.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: xCgwEQpHDFUhgbsdM45vpmxR5f41TJRdl4RE8YBuBCAtkFASHnF0WKrRHQnTB5z5tsgAubYrUFk6sUDDpgzEfh25dZ5Y0dJ5busJwGQHmipPrZHzluSSTfHvQ1rRMEdgZ3VNzmpg8NyeW4WnBy5icJ+4A9JMyQb8jl+dMBqXgoZMNfdz37C1Jg5PabW/69XZVOiehhaQRk0919fso+LhyCA/p0tJbcXurknWFIFk2mrENnRmGGcOLJGsh/7H6uZYRfB610E2978TFaOy+EDSPuFMtqX7FSVfa5QuQTig9DNC08skLOXQQ3ZaDoFW2hc22qku8yrkIjzYwHEjzCuuKnllXVqBEw+1k0h2ZoeWeKbuKbVmkyiBYwF09hPU37iy00A2jUYkFO1EK+TS+KO7nvJZjR5F6rz5ZTCfJQcXJbN6G49scWX199m+UGQoRuzHNeZ4jv0wzWmG9DU9k/zOj1xCNfOukwFRMFDM3zOtntVphxzrUXQot3q1jHzllNRu/IQXKCIV5gG7762OCSI3xiF+0X6NbxO5x2/4u+kmsxrvh5yar/GUHl/e9P8LD5ezSEpKdQtcbTPh6EwTOBj7jkPxzMEdOoVrjdehzGMgeeb1edku+tvNOERQxX7NulE42f9JxI8ggH/lRowdAicocpntBlrwTC7mnbPaBKzP+CBfftfTZEuY7kiqjGwo7DPXjSImFXaGlg9lsHvGkArID2ognbIlTkbESn8dLAkFne855DYl/zTgppz9sH8dk4ayXfKH9zGSe56BmQfsKkgGiNtajpZksMNJD9PI1pY7POU=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB7017.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(31696002)(66476007)(83380400001)(6512007)(86362001)(8936002)(2616005)(186003)(6916009)(36756003)(44832011)(31686004)(38100700002)(478600001)(316002)(5660300002)(4326008)(2906002)(6486002)(53546011)(8676002)(66556008)(66946007)(6506007)(41300700001)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2250
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: eb52e067-4273-4281-d926-08da545972ee
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+bUh25Q+IWqxTthB4YPBSvolV0Bvv6VWhQnDhALD1cMLO1tnDEl3zPnU3w3J8wgQM5q8Djrozrj6N2O1y6k0zvcBNB5W/Czm5bMRFCwqmHDja4MXzZumPilIxWR9SGR6HgoZh9ccHytyDT8q4eaybjFiLhUvH37wCcWxNk1/hUxhyId5msbNCdjNvXcb1yvzHTFbSbbRg8uHoV2m2FECVmgIL67GJnDP6L+KS1Tnjp3vSbBjGJYsJNR/+zEWN7tLDUlxwaYd2tFYpUc6Z3JAbXc90MkC0RwozkQLo6hxjaYD3j+4TRDPYv3EHnx0ymXodhB+tgtwryrbSMF8DkYzKyOydWj1PQDzlE86SUIeVZJqWAVIhMvnhMK8VxCDzr/Gx+wOvvkHB3ZxgHCzHDVa49HJqeQKViVn64gkchRleAhiXEw2E1+YO0eOLe/TeUxzEdjx6RNkPb5YSdwHTaQWAfKljpG6fk/I/lG0OTY1CDR1lOTUUz/CzGD9KtcNlIeYwDs/zc7xmLkIf6wywDqR4ERAmQSFT4lpNMq0/YZt7QLpDztfM0R311XBzYanIWwVGk9LrML39NSIOFQ6k9OJXb4vqCgXzS297umINSnW238P4vqmJ78XsCc1fs2jIzpqk5rljF+qGzr+SZx1fUVpF1m2UeuH+XlWyki2sPWWKa/fdRqdqXcQY1gS0vHEolgTeyqvNvgEQFuehl83iIsfvkYPPFuqemjW3coRdY66ZGlMCEqkOhsQVU85/2m0lpZJdGgmXgEJBdaG4Ci++DxSt9yQ1csbHiVjljK5SNkbzg=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(396003)(40470700004)(36840700001)(46966006)(82310400005)(8936002)(6862004)(316002)(2906002)(36860700001)(31696002)(40460700003)(478600001)(6486002)(86362001)(82740400003)(47076005)(356005)(70206006)(4326008)(41300700001)(6512007)(40480700001)(53546011)(83380400001)(336012)(81166007)(186003)(5660300002)(36756003)(70586007)(2616005)(6506007)(44832011)(26005)(31686004)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 14:14:11.6054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efca1461-2004-42e2-fe47-08da54597ad8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6714
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/2022 00:09, Ricardo Koller wrote:
> On Fri, May 06, 2022 at 09:56:05PM +0100, Nikos Nikoleris wrote:
>> This change adds a efi/run script inspired by the one in x86. This
>> script will setup a folder with the test compiled as an EFI app and a
>> startup.nsh script. The script launches QEMU providing an image with
>> EDKII and the path to the folder with the test which is executed
>> automatically.
>>
>> For example:
>>
>> $> ./arm/efi/run ./arm/selftest.efi setup smp=3D2 mem=3D256
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   scripts/runtime.bash | 14 +++++-----
>>   arm/efi/run          | 61 ++++++++++++++++++++++++++++++++++++++++++++
>>   arm/run              |  8 ++++--
>>   arm/Makefile.common  |  1 +
>>   arm/dummy.c          |  4 +++
>>   5 files changed, 78 insertions(+), 10 deletions(-)
>>   create mode 100755 arm/efi/run
>>   create mode 100644 arm/dummy.c
>>
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index 7d0180b..dc28f24 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -131,14 +131,12 @@ function run()
>>       fi
>>
>>       last_line=3D$(premature_failure > >(tail -1)) && {
>> -        skip=3Dtrue
>> -        if [ "${CONFIG_EFI}" =3D=3D "y" ] && [[ "${last_line}" =3D~ "en=
abling apic" ]]; then
>> -            skip=3Dfalse
>> -        fi
>> -        if [ ${skip} =3D=3D true ]; then
>> -            print_result "SKIP" $testname "" "$last_line"
>> -            return 77
>> -        fi
>> +        if [ "${CONFIG_EFI}" =3D=3D "y" ] && [ "${ARCH}" =3D x86_64 ]; =
then
>> +            if ! [[ "${last_line}" =3D~ "enabling apic" ]]; then
>> +                    print_result "SKIP" $testname "" "$last_line"
>> +                    return 77
>> +            fi
>> +    fi
>>       }
>>
>>       cmdline=3D$(get_cmdline $kernel)
>> diff --git a/arm/efi/run b/arm/efi/run
>> new file mode 100755
>> index 0000000..dfff717
>> --- /dev/null
>> +++ b/arm/efi/run
>> @@ -0,0 +1,61 @@
>> +#!/bin/bash
>> +
>> +set -e
>> +
>> +if [ $# -eq 0 ]; then
>> +    echo "Usage $0 TEST_CASE [QEMU_ARGS]"
>> +    exit 2
>> +fi
>> +
>> +if [ ! -f config.mak ]; then
>> +    echo "run './configure --enable-efi && make' first. See ./configure=
 -h"
>> +    exit 2
>> +fi
>> +source config.mak
>> +source scripts/arch-run.bash
>> +source scripts/common.bash
>> +
>> +: "${EFI_SRC:=3D$(realpath "$(dirname "$0")/../")}"
>> +: "${EFI_UEFI:=3D/usr/share/qemu-efi-aarch64/QEMU_EFI.fd}"
>> +: "${EFI_TEST:=3Defi-tests}"
>> +: "${EFI_CASE:=3D$(basename $1 .efi)}"
>> +
>> +if [ ! -f "$EFI_UEFI" ]; then
>> +    echo "UEFI firmware not found: $EFI_UEFI"
>> +    echo "Please install the UEFI firmware to this path"
>> +    echo "Or specify the correct path with the env variable EFI_UEFI"
>> +    exit 2
>> +fi
>> +
>> +# Remove the TEST_CASE from $@
>> +shift 1
>> +
>> +# Fish out the arguments for the test, they should be the next string
>> +# after the "-append" option
>> +qemu_args=3D()
>> +cmd_args=3D()
>> +while (( "$#" )); do
>> +    if [ "$1" =3D "-append" ]; then
>> +            cmd_args=3D$2
>> +            shift 2
>
> Does this work with params like this (2 words)?
>
>       [pmu-cycle-counter]
>       file =3D pmu.flat
>       groups =3D pmu
>       extra_params =3D -append 'cycle-counter 0'
>

I think it does. cmd_args will take the value of the string that follows
append and in this case whatever is between the single/double quotes.

Thanks,

Nikos

>> +    else
>> +            qemu_args+=3D("$1")
>> +            shift 1
>> +    fi
>> +done
>> +
>> +if [ "$EFI_CASE" =3D "_NO_FILE_4Uhere_" ]; then
>> +    EFI_CASE=3Ddummy
>> +fi
>> +
>> +: "${EFI_CASE_DIR:=3D"$EFI_TEST/$EFI_CASE"}"
>> +mkdir -p "$EFI_CASE_DIR"
>> +
>> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
>> +echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
>> +echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.n=
sh"
>> +
>> +EFI_RUN=3Dy $TEST_DIR/run \
>> +       -bios "$EFI_UEFI" \
>> +       -drive file.dir=3D"$EFI_TEST/$EFI_CASE/",file.driver=3Dvvfat,fil=
e.rw=3Don,format=3Draw,if=3Dvirtio \
>> +       "${qemu_args[@]}"
>> diff --git a/arm/run b/arm/run
>> index 28a0b4a..e96875e 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -67,7 +67,11 @@ fi
>>
>>   A=3D"-accel $ACCEL"
>>   command=3D"$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_t=
estdev"
>> -command+=3D" -display none -serial stdio -kernel"
>> +command+=3D" -display none -serial stdio"
>>   command=3D"$(migration_cmd) $(timeout_cmd) $command"
>>
>> -run_qemu $command "$@"
>> +if [ "$EFI_RUN" =3D "y" ]; then
>> +    ENVIRON_DEFAULT=3Dn run_qemu $command "$@"
>> +else
>> +    run_qemu $command -kernel "$@"
>> +fi
>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>> index a8007f4..aabd335 100644
>> --- a/arm/Makefile.common
>> +++ b/arm/Makefile.common
>> @@ -12,6 +12,7 @@ tests-common +=3D $(TEST_DIR)/gic.$(exe)
>>   tests-common +=3D $(TEST_DIR)/psci.$(exe)
>>   tests-common +=3D $(TEST_DIR)/sieve.$(exe)
>>   tests-common +=3D $(TEST_DIR)/pl031.$(exe)
>> +tests-common +=3D $(TEST_DIR)/dummy.$(exe)
>>
>>   tests-all =3D $(tests-common) $(tests)
>>   all: directories $(tests-all)
>> diff --git a/arm/dummy.c b/arm/dummy.c
>> new file mode 100644
>> index 0000000..5019e79
>> --- /dev/null
>> +++ b/arm/dummy.c
>> @@ -0,0 +1,4 @@
>> +int main(int argc, char **argv)
>> +{
>> +    return 0;
>> +}
>> --
>> 2.25.1
>>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
