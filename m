Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841307604BB
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 03:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjGYBeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 21:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjGYBeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 21:34:18 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2134.outbound.protection.outlook.com [40.107.7.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F12171E
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 18:34:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LL8G1yMLDQ6udxEclClOyZOQKf1YLhBuv8vLlSjfa4CFudCPSTTJaVyEkLhEH0BdfeNVycynMAY2z4KOICQtCsRI3Di0j5W/GSBmBODZuN+QS7pWB5l4J8bMBtFH/gVThv6UrISxwnHJyolqqzI0pV/TBxsItfwOpU5ohirWhhVXp9+mPNsKUjnsdI8Av3bpWXeEQcYpQwcrKrL9m2I0RrtOt6yEss+dVi07O5sSX4bi+Ag+0NcSeaxMpP7c8D9HoQqdjjtcRMpzB5dzwxd9rz5+noAhwZA7mpDfWOVaMkiDUjyPuqpE4f5InWOdZISxg1GOkzASOURkjAbGP5FJPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJpkXDrrYtPjmOG9U550vpmdXL2p3locVChjL8bTHik=;
 b=jD4SD1oK35/RlhenFAq0YGm4oXaJmYOyHDwToL6tcOlOAm/a1LC5fDS+imUJPbEjwBOL5z+TXhyRooM2XqDl0lkqx9K6zmKg4btMS5e9/4A6unozlERNB3viNMQ1snSIhKu5CCB75l0Zd516jMyGrcdj4Cett1Z9RFqwmfMeH0dPMAq1whG56XcbUrDkLCuASpvkD2Das3QnrFn5Q8OJXq5ny2dGR0d1C7ndbwqenR1Hz9tJ7q9BZ7vf+ScGhmVBWqECUOA0ZG5Goi3U7jXCuhhLDgos4MvFnxUn/QDt1zKjvYjnmmrM75Fol8nU0Q2EskjDR6w+SXjhcpLd3+bV1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 147.33.15.5) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=vscht.cz;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=vscht.cz; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vscht.cz; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJpkXDrrYtPjmOG9U550vpmdXL2p3locVChjL8bTHik=;
 b=d0kuYr/vIXPZvUhVu193oeml4j0Cj4JoC4Z90eDC8fVGzFfQYcjrLqN668swUDqYXdTPZlyE28Gnv/5DYwfaUoDrnzuObQAz/i7kBo1xh5FLOEJ5L+7y9lA5h743JoBh/rBmPCxdFbnAxD8R3fu/9RnfQ3//eiGhYGE/2vrrXVk=
Received: from DUZPR01CA0117.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::23) by AM8PR05MB7538.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 01:34:13 +0000
Received: from DB5EUR01FT052.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:10:4bc:cafe::79) by DUZPR01CA0117.outlook.office365.com
 (2603:10a6:10:4bc::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31 via Frontend
 Transport; Tue, 25 Jul 2023 01:34:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 147.33.15.5)
 smtp.mailfrom=vscht.cz; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=vscht.cz;
Received-SPF: Pass (protection.outlook.com: domain of vscht.cz designates
 147.33.15.5 as permitted sender) receiver=protection.outlook.com;
 client-ip=147.33.15.5; helo=ns.vscht.cz; pr=C
Received: from ns.vscht.cz (147.33.15.5) by
 DB5EUR01FT052.mail.protection.outlook.com (10.152.5.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.25 via Frontend Transport; Tue, 25 Jul 2023 01:34:12 +0000
Received: from smtp-rtr.vscht.cz (smtp-rtr.vscht.cz [147.33.10.25])
        by ns.vscht.cz (8.14.7/8.14.7) with ESMTP id 36P1YBq4023184
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 03:34:11 +0200
Received: from proxy51.vscht.cz (proxy51.vscht.cz [147.33.10.51])
        by smtp-rtr.vscht.cz (Postfix) with ESMTPS id 870E6600049
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 03:34:11 +0200 (CEST)
X-ASG-Debug-ID: 1690248845-15854f4f7732abf0002-HEqcsx
Received: from mailex.vscht.cz (cln96.vscht.cz [147.33.90.96]) by proxy51.vscht.cz with ESMTP id 9gubpGo209MD9ux2 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 25 Jul 2023 03:34:06 +0200 (CEST)
X-Barracuda-Envelope-From: khailoy@vscht.cz
X-Barracuda-Effective-Source-IP: cln96.vscht.cz[147.33.90.96]
X-Barracuda-Apparent-Source-IP: 147.33.90.96
Received: from cln95.vscht.cz (147.33.90.95) by cln96.vscht.cz (147.33.90.96)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 25 Jul
 2023 03:06:04 +0200
Received: from cln95.vscht.cz ([147.33.90.95]) by cln95.vscht.cz
 ([147.33.90.95]) with mapi id 15.01.2507.027; Tue, 25 Jul 2023 03:06:04 +0200
From:   Khailo Yelyzaveta <Yelyzaveta.Khailo@vscht.cz>
Subject: =?ks_c_5601-1987?B?u/W3zr/uILjevcPB9rChILW1wvjH373AtM+02Q==?=
Thread-Topic: =?ks_c_5601-1987?B?u/W3zr/uILjevcPB9rChILW1wvjH373AtM+02Q==?=
X-ASG-Orig-Subj: =?ks_c_5601-1987?B?u/W3zr/uILjevcPB9rChILW1wvjH373AtM+02Q==?=
Thread-Index: AQHZvpQv6NC01zuLpUKjaBoHBqcCOg==
Date:   Tue, 25 Jul 2023 01:06:04 +0000
Message-ID: <9a077352f3e94cef8280a3fc0c7e9730@vscht.cz>
Accept-Language: ru-UA, cs-CZ, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [147.33.93.20]
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Barracuda-Connect: cln96.vscht.cz[147.33.90.96]
X-Barracuda-Start-Time: 1690248846
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://147.33.10.51:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at vscht.cz
X-Barracuda-Scan-Msg-Size: 271
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 2.02
X-Barracuda-Spam-Status: No, SCORE=2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=6.0 tests=BSF_SC0_MV0028, EMPTY_TO_HEADER, MISSING_HEADERS, MISSING_HEADERS_2, NUMERIC_HTTP_ADDR, TO_CC_NONE
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.111829
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.01 EMPTY_TO_HEADER        Custom rule EMPTY_TO_HEADER
        0.00 MISSING_HEADERS        Missing To: header
        0.00 NUMERIC_HTTP_ADDR      URI: Uses a numeric IP address in URL
        0.00 TO_CC_NONE             No To: or Cc: header
        1.21 MISSING_HEADERS_2      Missing To: header
        0.80 BSF_SC0_MV0028         Custom Rule BSF_SC0_MV0028
To:     Undisclosed recipients:;
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB5EUR01FT052:EE_|AM8PR05MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: f7de4dbd-62c4-4809-1a02-08db8caf4036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: afy2gb95XN8t9+4hOXnvw0+mMtOocPCe4RFARmmoRoKFDGcsbIARrtjjUBgLctsTzMZYkpEWlvJBtPELKmv14ESUwyfAxeFPOvZTgoaRqjpi2m/HpRtg1SCZOpiQTTKu8m9Zl6IJlSm4tapb/NoQOcIkERcEIgJJrGdoL8yVNk0OM1bXqfQT8NkJT6rueme/bxA1jaeSvdwf6ZyjUYZpTlSCb44T2bk3npHjeVA8d/tOMFoROyqdMBGBELSxcLk+J0yVliutabIcrCH/XE/QlTVY7hG5lIp88t0s0Woxo4FjEHVHO8+byE2xtZUTsbJI4E6yrHve+CgQ86Utfm8i+VM59X5d1Zdb661McMSahcQ3ERpsPTCSePyrbTsYMskZTLh6GhXaOJk+O15gQpXZ9RHUb+8fZuAV6ZikaifmjGta+PbEDInJ14J65hsMTCLgx1itfB+WQfTSOMXLyxueSEn1FwD/yrdSM74mfxbSYNDSEjuZf/k4CnIG1xDrTDvHlQhetSOyDqvJkL9ndlH+/9Nm9SJ+RRxcYnky7QUN5uDbM1ShM4aa28XfW/7XCtltbrGPMRj99lbu0gm1VoNw61RvvxS10QyIAJ9SDvHdOjru/9kImKE7JRbtk/4fFnI7S82UyTsbbP99bMAOsMCeSu/mkIdx7hHIULo8p7P9TGsF6o6D3dx1XpN02O00NB6nX77fNG7TsaAlVVzrsCkcN+YKeZQHrtx6VWZgN1wr4XpCW1dFQOd/WMcFydzLgz+r
X-Forefront-Antispam-Report: CIP:147.33.15.5;CTRY:CZ;LANG:ko;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ns.vscht.cz;PTR:ns.vscht.cz;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39850400004)(451199021)(82310400008)(109986019)(40470700004)(46966006)(36840700001)(36756003)(224303003)(558084003)(2906002)(66899021)(40480700001)(47076005)(336012)(186003)(426003)(36860700001)(26005)(574094003)(7596003)(7636003)(356005)(7696005)(24736004)(478600001)(108616005)(40460700003)(70206006)(70586007)(8936002)(956004)(2616005)(786003)(316002)(45080400002)(82740400003)(41300700001)(5660300002)(10412655002);DIR:OUT;SFP:1102;
X-OriginatorOrg: vscht.cz
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 01:34:12.6728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7de4dbd-62c4-4809-1a02-08db8caf4036
X-MS-Exchange-CrossTenant-Id: a5085469-d927-486a-966e-f350bf2fe08a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a5085469-d927-486a-966e-f350bf2fe08a;Ip=[147.33.15.5];Helo=[ns.vscht.cz]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT052.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCn6/obDUICAgIG0qKioqKioqQHNudS5hYy5rcjxodHRwczovLzU1NTY4MzRzbnUtYWMta3Iu
d2VlYmx5LmNvbS8+ICwNCg0KTWljcm9zb2Z0IFRlYW1zwMcgv6y29MOzv6G8rSC6uLO9IDews8DH
ILv1ILjevcPB9rChIMDWvcC0z7TZLg0KDQpzZW5kZXI6IGEqKioqKioqQHNudS5hYy5rcjxodHRw
czovLzU1NTY4MzRzbnUtYWMta3Iud2VlYmx5LmNvbS8+DQoNCrjevcPB9iDA0LHiPGh0dHBzOi8v
NTU1NjgzNHNudS1hYy1rci53ZWVibHkuY29tLz4NCg0KsPy4rsDaDQoNCg==
