Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738AF5BA316
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 01:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiIOXUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 19:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiIOXUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 19:20:13 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01hn2219.outbound.protection.outlook.com [52.100.0.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934FF27FF2;
        Thu, 15 Sep 2022 16:20:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AU8WWQHdkxjKnLCOMOSJjTTQuH1MkVhroDAM9J8+9f6eCA5zt4DU6HRxVPBQ1dqoLZgFUjNqm0AOdPAvv26HfKdoGZAQxdD05siChzufCTawQm8LoxJzPSIUH91oqeJKyUkmS5EuwkZorDK0oGzp4K5v0VBUbwawwINFkikS7iUtrouStCx8MMyZWOlzjcDZ7NDV76neIUEI+azJ4c+/WeUN60YvKXnwphETtE5mXZbIalcidqM5j3ujfYQp+ALDHdvRr1G+rIgEXpAt/WD0s97Z8zOiJz5paNsbRM8qo1nxGXe8OC+iFrjDfotKGKceEZ1wlL0gxTk7hTNWrtRwOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs10Md+15nMnyayKLyd22Uv+/ZH79IcFcpzuzGLq1Fg=;
 b=GsrwQ7stBNO/t/CFIywnzZt2nha2hrt3FE+/rLp+bK06+BYl26wQceKS/8GjUOWPoQsrr8i831fSxxxM3ZYvBzhxct6U9sOCrItvcLPLvRMtTwaZvw7HudZGxK2OawRyZz1v/6Vo93x/PN1R4vcVLlKOyb3v7+noXmd0vUjZhnI+AuARNEUhbUd+sWK+8hfEWupMLiM8/yDeBTKUN26cj7Cag6sJqWFEBlV7crHlYROcD7ohaLnN5pYVo9bfgABvJfXolyNwqwtj4MLB04cjysWsy3eRW18PUFVlkMrIyrTDouLqP5gU43dl7WMX6jlNs5Nfo8MrwGql1jTWHWwRmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 45.14.71.5) smtp.rcpttodomain=vdk.de smtp.mailfrom=t4.cims.jp;
 dmarc=bestguesspass action=none header.from=t4.cims.jp; dkim=none (message
 not signed); arc=none (0)
Received: from SG2PR02CA0043.apcprd02.prod.outlook.com (2603:1096:3:18::31) by
 TYUPR04MB6741.apcprd04.prod.outlook.com (2603:1096:400:351::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 23:20:09 +0000
Received: from SG2APC01FT0037.eop-APC01.prod.protection.outlook.com
 (2603:1096:3:18:cafe::b7) by SG2PR02CA0043.outlook.office365.com
 (2603:1096:3:18::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16 via Frontend
 Transport; Thu, 15 Sep 2022 23:20:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 45.14.71.5)
 smtp.mailfrom=t4.cims.jp; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=t4.cims.jp;
Received-SPF: Pass (protection.outlook.com: domain of t4.cims.jp designates
 45.14.71.5 as permitted sender) receiver=protection.outlook.com;
 client-ip=45.14.71.5; helo=User; pr=M
Received: from mail.prasarana.com.my (58.26.8.158) by
 SG2APC01FT0037.mail.protection.outlook.com (10.13.36.190) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Thu, 15 Sep 2022 23:20:08 +0000
Received: from MRL-EXH-02.prasarana.com.my (10.128.66.101) by
 MRL-EXH-01.prasarana.com.my (10.128.66.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 16 Sep 2022 07:19:28 +0800
Received: from User (45.14.71.5) by MRL-EXH-02.prasarana.com.my
 (10.128.66.101) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Fri, 16 Sep 2022 07:18:10 +0800
Reply-To: <rhashimi202222@kakao.com>
From:   Consultant Swift Capital Loans Ltd <info@t4.cims.jp>
Subject: I hope you are doing well, and business is great!
Date:   Fri, 16 Sep 2022 07:19:40 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1251"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2600.0000
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2600.0000
Message-ID: <134c2800-ac73-4df4-aa47-d5b66a469a96@MRL-EXH-02.prasarana.com.my>
To:     Undisclosed recipients:;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender: ip=[45.14.71.5];domain=User
X-MS-Exchange-ExternalOriginalInternetSender: ip=[45.14.71.5];domain=User
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2APC01FT0037:EE_|TYUPR04MB6741:EE_
X-MS-Office365-Filtering-Correlation-Id: 1664c3f4-8158-4f67-b04b-08da9770d483
X-MS-Exchange-AtpMessageProperties: SA|SL
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?windows-1251?Q?dc3OPyhIdtfWYOH220tKiz9inY/NmvTb7QRS2HOewJ6hSvlyS0Nkjzs+?=
 =?windows-1251?Q?jiNNWaCetk8R1rNFcj30naNnm+hDYWCAxUMkIPw+MdlM859H8+bKYaxL?=
 =?windows-1251?Q?IdL98hRsHmzzMCQNeeVJJ+WeXK3CP/VYrCB8oe9nvRF9KZiDIff5McRk?=
 =?windows-1251?Q?u3AJIGLmiKSc1DcCwgYmUy5MC/6U3XJwYMeKiLQNYSxCWcYLNBxNqt/j?=
 =?windows-1251?Q?DzMzA+lbhpgTwzOMSgIpnUKuv9etBaXW1NPQq0Nin59f1FaNCCyDrZNz?=
 =?windows-1251?Q?ZQgolkiiyYNS0oJUsXS1+yO520ClKbI+VvCCDQWLD0YEiKtpoQ6O7oVI?=
 =?windows-1251?Q?hBMxyE3XwbVCV2tpnsEqoJQRPc85hiamX4BWhVMhgj76KESpdO9xMx/l?=
 =?windows-1251?Q?4QHnHxy3CT9RQ4gr4hFQ/O4FLjr4uk+84wlbxMZtrFTgszeZv2XLafeY?=
 =?windows-1251?Q?wAfsDT4yxhv0PHEWk04kY9xAObuzpZ3enGfZui4BxyyHon3Z+14evVcb?=
 =?windows-1251?Q?kPsdTGH4jjGAd0HIRQyQywIiKcjABSdZ+53V3bb5YyWhkIoXspd5H7oA?=
 =?windows-1251?Q?9o1jg+bJxH2n5oQH4Eij5PhMStsGMgKaXr8LG7BLDb2CmNCWzMWC15XH?=
 =?windows-1251?Q?ayW60GzVuzWOLQezQsgwn0zE7hTkzRYjTWnrhXPa3uDzJvXDPRSSfilg?=
 =?windows-1251?Q?obkppea+Tz0rT+CTiUA130QNB+hBDU2BxBH8WAb9jKy8+8RuAydRS7ap?=
 =?windows-1251?Q?ww+42jMkthgf77466QWxb1lva2aGJ8Q4UAsBLDKbJbHMXZUwWJRRnW7E?=
 =?windows-1251?Q?jMrzcRkXlEFxW5rjA4D1S/MJQHjB0mM17Mg5JudQ5uOtMU4EwkCPTvbP?=
 =?windows-1251?Q?LOvxuGDCvCcm/ZC2Aj7Bpyow6Dmed1OBovT80czvkBJacTq6Skl9IS8c?=
 =?windows-1251?Q?qmr+sUtD5rr2JvK5xDS5a3ImVZ1CRZGQrUqDt8cuA0iJMoisQlw6rbON?=
 =?windows-1251?Q?xPwrebH5JkKTOhZfpmxD9Qn6tRGNkWnxuSKmPQIpuAgEw1xLiRa96idR?=
 =?windows-1251?Q?eLLZHvNddj7bgU9xiVy1hyn+Gg7bO8VKRt4Oe9Ut8SF7qCS+cpx2477+?=
 =?windows-1251?Q?HxJjcvnuqjheTlM2TQpFy754Fe8Z0KllUlRX+68b8K2LCj2bWLm5og4N?=
 =?windows-1251?Q?A75bLTFx1lQ0KEtJ9oOgXqDeeBctuhaTMqUTmB6N0LBqXsG7Sfex4XA9?=
 =?windows-1251?Q?ikCXu/7FBQpb327QZ+D0KIdW6b6+rHssbQ5pyWUs8XfwFbpFFLtQUj/Z?=
 =?windows-1251?Q?Silika48cJqPUKZDrhJON2QjVMZi/eVlPBtv9CSxhVskVFww?=
X-Forefront-Antispam-Report: CIP:58.26.8.158;CTRY:JP;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:User;PTR:45.14.71.5.static.xtom.com;CAT:OSPM;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199015)(40470700004)(70586007)(70206006)(31686004)(36906005)(35950700001)(316002)(8676002)(7416002)(2906002)(156005)(82310400005)(7366002)(8936002)(32850700003)(4744005)(498600001)(86362001)(31696002)(41300700001)(5660300002)(6666004)(40480700001)(40460700003)(336012)(109986005)(7406005)(26005)(9686003)(32650700002)(956004)(82740400003)(66899012)(81166007)(2700400008);DIR:OUT;SFP:1501;
X-OriginatorOrg: myprasarana.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 23:20:08.3253
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1664c3f4-8158-4f67-b04b-08da9770d483
X-MS-Exchange-CrossTenant-Id: 3cbb2ff2-27fb-4993-aecf-bf16995e64c0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3cbb2ff2-27fb-4993-aecf-bf16995e64c0;Ip=[58.26.8.158];Helo=[mail.prasarana.com.my]
X-MS-Exchange-CrossTenant-AuthSource: SG2APC01FT0037.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR04MB6741
X-Spam-Status: Yes, score=6.2 required=5.0 tests=AXB_XMAILER_MIMEOLE_OL_024C2,
        AXB_X_FF_SEZ_S,BAYES_50,FORGED_MUA_OUTLOOK,FSL_CTYPE_WIN1251,
        FSL_NEW_HELO_USER,HEADER_FROM_DIFFERENT_DOMAINS,NSL_RCVD_FROM_USER,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [52.100.0.219 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5024]
        *  0.0 NSL_RCVD_FROM_USER Received from User
        *  0.0 FSL_CTYPE_WIN1251 Content-Type only seen in 419 spam
        *  3.2 AXB_X_FF_SEZ_S Forefront sez this is spam
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [52.100.0.219 listed in wl.mailspike.net]
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  0.2 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level
        *      mail domains are different
        *  0.0 AXB_XMAILER_MIMEOLE_OL_024C2 Yet another X header trait
        *  0.0 FSL_NEW_HELO_USER Spam's using Helo and User
        *  1.9 FORGED_MUA_OUTLOOK Forged mail pretending to be from MS Outlook
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

I hope you are doing well, and business is great!
However, if you need working capital to further grow and expand your business, we may be a perfect fit for you. I am Ms. Kaori Ichikawa Swift Capital Loans Ltd Consultant, Our loans are NOT based on your personal credit, and NO collateral is required.

We are a Direct Lender who can approve your loan today, and fund as Early as Tomorrow.

Once your reply I will send you the official website to complete your application

Waiting for your reply.

Regards
Ms. Kaori Ichikawa
Consultant Swift Capital Loans Ltd
