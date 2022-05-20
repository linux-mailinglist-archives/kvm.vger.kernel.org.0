Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4CB52E868
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 11:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345912AbiETJKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 05:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiETJKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 05:10:30 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AC71312AC
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 02:10:28 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=UIBtKA6M3Ps83k62I8Xmhqq7JUSNfdnY7giSgvf+L5km1RCd5OU+bhnEhM4EaHIwWSHAHhsIwuSK8ApKkgGq3XLxjnh8ghItf+y/tB8V8QZS+Oh5Zqcv359Nt4QJUVSKscnqgvuWeF2/FZ3DWNo0bFZrKGrzeg8c5HM16/6xmGNsGF1Nhnuof0C2GTfHEs3AjLr7EwNFUvZ/GqDOXb6k6JMJKT8OH/w8T0zQBtfC82qe6x1QXt2iJ7TZkJf0/ozDosYXnkRsyv/uqqxEn20Nun7zwE4swWNnPgnfUk0oyzgZdQu+XItY4RIWmYXVvn6mUGnxJy3O2rBrM5vsFafMrw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLfVggiy+eJGUccLh5mE1nO5Fe/MG7OQtb8z6PYFLeE=;
 b=Y7YKOfkIwpuN0iO2hJMb497R2vwwzZNJJ6QoQDnM9uY9sS/8mTTydzm5e5Y5vMpwAdoPZ6q616thGPZwI6fWtXa6MhmOOt3pe2Iwnjdp2pZNfr004N879ZfKuTW/HkqOJF7/VG6yMR+A/A3rkJ1t4wG3oGZry2Jd8nsdSOT8YkN1LD1QmeRBBjf4JDno7okOashwKvV9vKTLB+GERKM2TlzFrscbLNSeOUszFNt5RTcvzmLUYD6lxLcPjNVRiqLVXfXZDaKIEpFyJiJ591gcnb/bBMAMRe4BVeMJ6ntj2/NXOGCmyweSatEs5460Vgu7wsyd2pPx0gqA3dgCoEd1ag==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLfVggiy+eJGUccLh5mE1nO5Fe/MG7OQtb8z6PYFLeE=;
 b=U0dxFMMH908PXIYd3B9UVjxrqb6cHq5l1Ygv20c5RlrTfmk2KxkEKNLxj6M2ojWm50jbuh6ptHA4s2/y3O9Vl3w7fDSsTviJnEAWSpg9wIMlqk0jmrYH18i2ccbN5TTUdkMOLF1/S64rqoTgYAKL6LCXay9FBQ40tnHHWOcnBbI=
Received: from DB6PR0601CA0002.eurprd06.prod.outlook.com (2603:10a6:4:7b::12)
 by VI1PR0802MB2272.eurprd08.prod.outlook.com (2603:10a6:800:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 20 May
 2022 09:10:25 +0000
Received: from DBAEUR03FT032.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:7b:cafe::80) by DB6PR0601CA0002.outlook.office365.com
 (2603:10a6:4:7b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Fri, 20 May 2022 09:10:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT032.mail.protection.outlook.com (100.127.142.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14 via Frontend Transport; Fri, 20 May 2022 09:10:25 +0000
Received: ("Tessian outbound 9a0893f586e2:v119"); Fri, 20 May 2022 09:10:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 583c523d89baee39
X-CR-MTA-TID: 64aa7808
Received: from a71f5ea7cab4.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 1535C4FE-BCF5-4D5E-BCA8-FDDA96E63C35.1;
        Fri, 20 May 2022 09:10:18 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a71f5ea7cab4.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 20 May 2022 09:10:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+Q+G0/SyjAdw0dZ44MfA69Vb2m4sfLctSoBVHzaimH06aF6ZXOXME6lN5nkYkxU/2YIQl1TADAlsQrrde33vfhIvo9ifz67rU/M49k4zAEHZ9vnuCrwW4YqD7MLSqhVrquI1QkLXesEXzCunCT+wIOe9wnobXLpn8qulUwoRb9FYBxHwdO+7cs21phI+w8QdwmMFWYKL1pKy7Pw0wiufEyl+es+mHTQUXSxLUOyawvpUAZ/3TYXhZvIPDqldYos1KxIBDGj2J/Ye8zkteAQAkn8p8mGbHiksyxYwJfRtqXiEXPXEXkCP4UJINhSio/znB49Fry3jPXdMViQWBdb8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLfVggiy+eJGUccLh5mE1nO5Fe/MG7OQtb8z6PYFLeE=;
 b=is80okNuEwtd2Na4zO6Nwco5wYjUIfLwXlQWHJuT1Jd1fs7dX7m7ScvBlvfNpEf7V9MMcgwlFOX+9ZvoqUF2chg/upcYxtcFhYtgJ8lYphBW7rsW8c7x3wkdskt+j3xYs2qZ/xgFXPLUf435xE4fsdEDESvmgMFowLTQx7u/cJQsi0igwn1JwRaZ59t3srEPsMaSkfuxLVf0di8fUv6YXrKR6R+4cER/xSatyHZfCH7WGa46vbTBH77JYb7SQcjw8Mt/+mZqaUCSuB39ikmdZB7mxrtJN4Zv4o8TwPIVwuNEClrEV7B8EP5ryhet/U0HiD34TaH1wFWUYJUpkYBP8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLfVggiy+eJGUccLh5mE1nO5Fe/MG7OQtb8z6PYFLeE=;
 b=U0dxFMMH908PXIYd3B9UVjxrqb6cHq5l1Ygv20c5RlrTfmk2KxkEKNLxj6M2ojWm50jbuh6ptHA4s2/y3O9Vl3w7fDSsTviJnEAWSpg9wIMlqk0jmrYH18i2ccbN5TTUdkMOLF1/S64rqoTgYAKL6LCXay9FBQ40tnHHWOcnBbI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com (2603:10a6:102:1df::21)
 by HE1PR0802MB2441.eurprd08.prod.outlook.com (2603:10a6:3:de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 09:10:15 +0000
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::21e9:1af8:8c5a:75d5]) by PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::21e9:1af8:8c5a:75d5%5]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 09:10:15 +0000
Message-ID: <21a2a499-a61b-8d25-92c6-c91e6d5ea2f9@arm.com>
Date:   Fri, 20 May 2022 10:10:14 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH kvm-unit-tests 2/2] lib: Add ctype.h and collect is*
 functions
Content-Language: en-GB
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
References: <20220519170724.580956-1-drjones@redhat.com>
 <20220519170724.580956-3-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20220519170724.580956-3-drjones@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0441.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::14) To PAXPR08MB7017.eurprd08.prod.outlook.com
 (2603:10a6:102:1df::21)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 50369963-1096-4591-ad6e-08da3a409391
X-MS-TrafficTypeDiagnostic: HE1PR0802MB2441:EE_|DBAEUR03FT032:EE_|VI1PR0802MB2272:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0802MB22725EFCE41D28FDE4B9D6AAF7D39@VI1PR0802MB2272.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: I6erH4z5H64wQ/8FR0gjIrMVk/8BrANCYMOz3o6i59JZvhwkvRhZkvsiDK7qQk8HeiJBvdYN8j6gbeusDpW4ec6OPC+Th6HM2soiWywUsyUMaIQOMF63Tbdh72pk/bmnVo0YC4gipCkJ1Ox3Z3X4yWETnIWYQ8D/iIZo9Q6FcuR9cWqttJahs+ArkmqTSQnqUvkVf7VEFo+9tEzgZRrqBIoO50FHtvDzNKYtkb2jX/XLLpfoAcqpGu/jlmDA+0HIaMGWScgWauQMb0he8OfPmF0fbOjvjQwhpwvh/wtEMS6uVoydEJsq1/33VbkDpNT+1wo+j6AsrWtMG2ykJYIBRXRzWgZ1UkVzAN78vbyktTkz1y+8N9bBfB8PMQs+j6qnVcz/cuumJbz4WqUS7fmBqSTauHafHUnEV5X1I9Re70zdi66uWpSHddY8iiedOd0pHE3CJw+r5gst8izY71sLhyQ40Vp9Z+j0RSQ2iO+rsdqHjCrtdeRGOghw593kauWtRfRnUjDCuuZoG4ApE0orIYXqMw2E3zFxOBZ75DEFrBwtQPnvkkOe55jQrz3h3ayqdd9/WNOUmSaZOcfXxewY0dtmyKXKYxe8Uaim8a/0Ofk/HCSsvBIPyLl/MdwFuBPK5z7aUcmJjXTzF4XSFfZrXdkHxnzxPGJ+nnaGxnXSOVfk7Dl0l+cfPku4u2E+iOwA43asivFPnMBDf4l6CgbbO6/dp75BCcMjYqMcMxWwyIM=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB7017.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2616005)(6486002)(5660300002)(508600001)(8676002)(4326008)(66476007)(66946007)(44832011)(2906002)(66556008)(53546011)(316002)(38100700002)(31686004)(31696002)(36756003)(26005)(6512007)(83380400001)(6506007)(186003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2441
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT032.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: ffe82883-5f07-4ec8-42cc-08da3a408dbb
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q/DNQthayrWhomvBQHHVA2fKV5OJ8nOX7ovn40a1O5hPBOZVsHDtQinODS9znoAz/lGAy038wuiBt1x72EQjJ1O5JGMPPkPf+eQbQObO2q6CUd5euFRxKqyBehikpET9FQVX/1DxddJuTF16+kY4Hby6y6ViZJJtogQMvCrhA4UTCT37ZswuG1RBAIyjWMPapZoT9tLES/X3ONfkmRREdK63YIg/nMCQm4r4uQX+R//ZplAFLiSrDwkXnU1w8dCaPPeQkwshwhuAM9hHRxUVDzZaBvB8vlA3OU1nwCnMHMyMbxVwIdtEBMMifH3upJl02hBdMNIFUo+lRkcOt/sKfORjvdBvc6zGXY/3VLkPwH0HeUTPceuWx+IqVPYRNFwhANU7n69ZqObkex05iG16zn02780CyIxGBU1TKz5mEeRBsSuqaZD2j5D5MOsjtaFwjrFpaoJ1XUGpAnr9/DcxJDjUBYzX5LHN7eIcYN3NCbFQT/PhvdtkNGzApc1E2aJZXja7pMTHXFMPXGrx9qp4mk2ZClEaNHJbQRZBdtr9SiaYmXqnbUpJN4sHRY9whn+3B+yHTNVhukumWBUjlZh6tOQXdkSWDSincDCA1bVI9rNrddSnLO4Pitu1Dft7PpwN4b7LU4lolCgGFa724pCL9HBjHgMrJp6iXg7dmZHDFYGOwAd0b9uRWoJEQct6HYZzgIz2E4xE7NxIxROwQLjIVw==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(31696002)(26005)(44832011)(186003)(53546011)(6512007)(86362001)(316002)(40460700003)(356005)(5660300002)(82310400005)(36756003)(31686004)(81166007)(70206006)(47076005)(70586007)(8936002)(336012)(6486002)(6506007)(2616005)(36860700001)(8676002)(107886003)(4326008)(2906002)(508600001)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 09:10:25.4462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50369963-1096-4591-ad6e-08da3a409391
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT032.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2272
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2022 18:07, Andrew Jones wrote:
> We've been slowly adding ctype functions to different files without
> even exporting them. Let's change that.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   lib/argv.c   |  7 ++-----
>   lib/ctype.h  | 40 ++++++++++++++++++++++++++++++++++++++++
>   lib/string.c |  6 +-----
>   3 files changed, 43 insertions(+), 10 deletions(-)
>   create mode 100644 lib/ctype.h
>
> diff --git a/lib/argv.c b/lib/argv.c
> index 0312d74011d3..951b176ae8b1 100644
> --- a/lib/argv.c
> +++ b/lib/argv.c
> @@ -6,6 +6,7 @@
>    */
>
>   #include "libcflat.h"
> +#include "ctype.h"
>   #include "argv.h"
>   #include "auxinfo.h"
>
> @@ -19,10 +20,6 @@ char **environ =3D __environ;
>   static char args_copy[1000];
>   static char *copy_ptr =3D args_copy;
>
> -#define isblank(c) ((c) =3D=3D ' ' || (c) =3D=3D '\t')
> -#define isalpha(c) (((c) >=3D 'A' && (c) <=3D 'Z') || ((c) >=3D 'a' && (=
c) <=3D 'z') || (c) =3D=3D '_')
> -#define isalnum(c) (isalpha(c) || ((c) >=3D '0' && (c) <=3D '9'))
> -
>   static const char *skip_blanks(const char *p)
>   {
>       while (isblank(*p))
> @@ -92,7 +89,7 @@ static char *env_next(char *env)
>       if (!*env)
>               return env;
>
> -     if (isalpha(*env)) {
> +     if (isalpha(*env) || *env =3D=3D '_') {
>               bool invalid =3D false;
>
>               p =3D env + 1;
> diff --git a/lib/ctype.h b/lib/ctype.h
> new file mode 100644
> index 000000000000..ce787a60cdf3
> --- /dev/null
> +++ b/lib/ctype.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _CTYPE_H_
> +#define _CTYPE_H_
> +
> +static inline int isblank(int c)
> +{
> +     return c =3D=3D ' ' || c =3D=3D '\t';
> +}
> +
> +static inline int islower(int c)
> +{
> +     return c >=3D 'a' && c <=3D 'z';
> +}
> +
> +static inline int isupper(int c)
> +{
> +     return c >=3D 'A' && c <=3D 'Z';
> +}
> +
> +static inline int isalpha(int c)

minor nit: I think there is a trailing whitespace in the line above,
otherwise:

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> +{
> +     return isupper(c) || islower(c);
> +}
> +
> +static inline int isdigit(int c)
> +{
> +     return c >=3D '0' && c <=3D '9';
> +}
> +
> +static inline int isalnum(int c)
> +{
> +     return isalpha(c) || isdigit(c);
> +}
> +
> +static inline int isspace(int c)
> +{
> +        return c =3D=3D ' ' || c =3D=3D '\t' || c =3D=3D '\r' || c =3D=
=3D '\n' || c =3D=3D '\v' || c =3D=3D '\f';
> +}
> +
> +#endif /* _CTYPE_H_ */
> diff --git a/lib/string.c b/lib/string.c
> index a3a8f3b1ce0b..6d8a6380db92 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -6,6 +6,7 @@
>    */
>
>   #include "libcflat.h"
> +#include "ctype.h"
>   #include "stdlib.h"
>   #include "linux/compiler.h"
>
> @@ -163,11 +164,6 @@ void *memchr(const void *s, int c, size_t n)
>       return NULL;
>   }
>
> -static int isspace(int c)
> -{
> -     return c =3D=3D ' ' || c =3D=3D '\t' || c =3D=3D '\r' || c =3D=3D '=
\n' || c =3D=3D '\v' || c =3D=3D '\f';
> -}
> -
>   static unsigned long long __strtoll(const char *nptr, char **endptr,
>                                   int base, bool is_signed, bool is_longl=
ong)
>   {
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
