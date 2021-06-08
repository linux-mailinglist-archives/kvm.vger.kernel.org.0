Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3769439FAAD
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 17:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhFHP3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 11:29:40 -0400
Received: from mail-ve1eur01hn2208.outbound.protection.outlook.com ([52.100.7.208]:2988
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231618AbhFHP3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 11:29:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvWeB2OKKXZyjbLU9VCrPxzja2SOZnW8AwOBYXUw1LyVau2+vqPoLcuBwBk0tUGixrmj/aQz1IRFFaNagxMQhfbUQCk9JC+hwwuKyKo/s3Bf6tq6neKaVFkTqhC8sqa2WnV0BYbj9buyceEuNWrha/nuQlHMx7RsLZetEkVKnHGnVz1Y/c3BbWNCfh+b/YKqreKv0hNAdTPpas8kfSwhHyphtAXSkDqeLEhw0aaVesoS4ZUL6MFlwM2g7Y+CYisJ1UsXsGxZJTn0mvOVWPsSZqDyXGNnkuigKFQQITq6DBxqGPXB/5LJ45sYVQIPBPMyhvYIPRfySAW7WCsnDF5Y1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5MUkQKkrgl5l2m/0JM4KYouD0nabS8Mhlm9K+J4+hs=;
 b=Vw0DX4MVXuhD73HDu41XwiNlYYwPwlzpf3PoL4WR7FKjyXiVILAXxl4umOsAnkcwMwPWAALA+h2lUW03G4SXcNkV+2p/YhV8aH/NYRCzx6m3J6SrU6cCXArfxtNQRY9VVAdGGfrxBs8KiLqMzJOfLEU2Bvrhb6/iW8W6aGl/kBTMq58hCjjZUCHxaki4UuazW3bBKNeZsswlyTtB8lLJBvW4agkUIzXDpmuIAUFHO/jU+et21GnSWxgpBGi3Ab8WVy4Y47ezAHwiEBf1PUO3tmD5Z/8C8y4OE7fj2phY/30OFmfCwqgyJOtB+K1o1ZPIQ36QYFUZq4tFgZPOOZxVdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5MUkQKkrgl5l2m/0JM4KYouD0nabS8Mhlm9K+J4+hs=;
 b=tXGEA6y/4yMw3cid/NW0JtgXCXsn8y16SSiiO+ngvWNDZ4MEOAm8Q7ZuhX4aDZXVDa3FgdvdOsNC3v6mRt2VVIU6gMyyrjS9M+f2w0pkblH2tiRrATsEnbq4xONa6Wnsf+AAaa6Js3ivwDAKRXhfNLRWgd7f3tcrOnibD9YwzqM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6114.eurprd08.prod.outlook.com (2603:10a6:20b:287::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 15:27:33 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 15:27:33 +0000
Date:   Tue, 8 Jun 2021 18:27:28 +0300
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH v8] qapi: introduce 'query-kvm-cpuid' action
Message-ID: <20210608152727.GA958156@dhcp-172-16-24-191.sw.ru>
References: <20210531123806.23030-1-valeriy.vdovin@virtuozzo.com>
 <87y2bkwfqv.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2bkwfqv.fsf@dusky.pond.sub.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR10CA0058.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::38) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-172-16-24-191.sw.ru (185.231.240.5) by AM0PR10CA0058.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Tue, 8 Jun 2021 15:27:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75b56c1f-22f0-48ea-4ee7-08d92a91f00b
X-MS-TrafficTypeDiagnostic: AM9PR08MB6114:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB611441B70CF0EDE45CF1E42287379@AM9PR08MB6114.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(346002)(39840400004)(136003)(396003)(366004)(6666004)(316002)(9686003)(1076003)(38100700002)(55016002)(4326008)(7416002)(16526019)(186003)(38350700002)(66946007)(107886003)(4744005)(956004)(36756003)(33656002)(54906003)(8936002)(52116002)(6916009)(7696005)(6506007)(44832011)(8676002)(2906002)(26005)(86362001)(478600001)(66476007)(66556008)(5660300002)(30126003);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FDSMtsY1D7V+FqZ6RTCFt4CTwDddrCqtHE9efN2Ocm3umwi2iD7WBT+LvFwQ?=
 =?us-ascii?Q?sx3Ipuksep3+ieH+3RJxRXTl60iIfZpLpNwm8dlbAv5DxHcjGvwdpZkKGYyB?=
 =?us-ascii?Q?7jo4LyMDCRZzVhjxAWJsMoyMftclIERD22mW4PJBTyCJMcUIzmKFs6KuJ8pK?=
 =?us-ascii?Q?WhNFQTeND5XJvxEPHNKuCH+5d2c4tdAlKbptn1R6KrluVIDaya4YLyGlFxnG?=
 =?us-ascii?Q?9zaSZ4j8Ez3zpNo4DH66jB2JIFJhGlDCWU9sGiVPQZfGnaEgcGWtSL2YfDQM?=
 =?us-ascii?Q?JqOS5hp1jC+Fd/bo01Zz1zqJmQ2RjGxNtX/cgpLq2B2k7w02S0G3VN2K8+ge?=
 =?us-ascii?Q?lqCW0RZiBJ/XSwEUMa0ug2QqSJsY1OT7J+Y4IXY6K/jhOGM6twf7bw423222?=
 =?us-ascii?Q?zTDGomoFTVqfhEdrqufBALUAxTiF5Vw/DbcxvvTu5WlJm7fDFQZ8ScIxX2/h?=
 =?us-ascii?Q?+HOu4LFdW4O9FEJp3dr3TaAGPEQaf4MVRSOtJ8D/D7E0BFWzY9Xd5I45gqtn?=
 =?us-ascii?Q?BCfg1nxLpwoYMuZpsOWrKPyilXKR1TBtvO08EjJF7cNIGoMtJLq6Gq5tWShM?=
 =?us-ascii?Q?o2fJufuhgAN7IcIEcUKlHoN9azo2YRNtrjm91muBmsSeqwgF8XIaNeY2uCWs?=
 =?us-ascii?Q?NK4V9ZwqpnggbDgfSoQhntijo0sZHjB2Y8VyQHDI4ZP4agh9qFnnaKkshTkP?=
 =?us-ascii?Q?tKOnFjMC0e4xorQmOJRyAFVot9CcrbqXBKSMtBlIOTk7tMt9qVXrahtaw86G?=
 =?us-ascii?Q?7dQNmt1SFwtZmjqsMizRqpk/6mM1Shque3Ti+tEYJ98smMMQrKO//yyJ1I0b?=
 =?us-ascii?Q?VJmwNGw0duiLFNaw63VZ2Vlm2HqjCPqk7TWavvCWBTxXKEGXdGk1Idz9W3nn?=
 =?us-ascii?Q?z9Js0VQyrH6r/M1HygJ9L/EMSDdp3tO/0IOO/CSCh7MceXo4O7vS/Ozn2vgU?=
 =?us-ascii?Q?fz7RiTDmACL5TM0NamhBLLhe0af6MT5s017PvK/jUnM=3D?=
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KEV5ZVGJ0VQ9Xy6K4M8EFj046XxgYORCA8yC+Sx++vDsJybk2nc82L0dxPST?=
 =?us-ascii?Q?l5xEnUliYsVxlqxrG+llB3txyt8w6Q3ZCiGfOZKbnHh+CsBwV+DfKYsSt8LQ?=
 =?us-ascii?Q?zUybDoFIY88eKs8zlvcsP+0IpkFioXv6lOvLzJKQwJpJ4d8hamwuMRzcA77N?=
 =?us-ascii?Q?mJ3xDKM6kHHQLrDDQPvfwRhDI9VBjLA064GTBOtXzez724heRajn0K43QRqa?=
 =?us-ascii?Q?Io6anf/mUcEqWKv8d3NvaIxPvRBso7sIvZysOcKA886xEurepVfUvVaIuRG3?=
 =?us-ascii?Q?xq3nvbo+KheHorxkwI3Eep4XMozPBPEeVtMy2uI/u9s8T69V7SVHQ64ui99m?=
 =?us-ascii?Q?KqGSwaWt5n3YvZ6t7DZhBvFmuBWtWs8ukslTlna+0Yb97CKeRIGSInCBPsw4?=
 =?us-ascii?Q?zFaAyyXC8+PrbSU0wd1h1l9NlHVZF298zAiI2dcxkFWT+AEsIEhUeju41GPq?=
 =?us-ascii?Q?QPbShDZxhCLmIkBiavNWAFYbvvmcIWGBmPiugELxIJMJOCEXgc4Z/XO89uUD?=
 =?us-ascii?Q?qxo1gpYA1wXYGNUkOBJ9tRgDZP2aELsfSy3KrdaO7X8B9acfcFAWiGjlK9nH?=
 =?us-ascii?Q?Mubf76id/DutcRQfGZ07CA/tInOqXn8LO8XXqRJf+RlZR8I4tm31y4Io4Kps?=
 =?us-ascii?Q?/V2ewoou1UIW3ndXQXtK6pCb0MK3+4cS4v8f7Rwg5ObuirQXANMw3qvrtfLy?=
 =?us-ascii?Q?slmSlA5CV0t+yKjipvTHSCp7+06VwlhWAaDBKEpboU6dxQELFHhi9HeeIAwe?=
 =?us-ascii?Q?WX6xrsaMaxv+yKA1VMDaw7Rx5Vfj+fPwvktwGLYP+fkwP8A/79u8hgZo29f7?=
 =?us-ascii?Q?KMzC7M6OZ1AyLsRfRga8J/ChK9/1hYjSZIlrsUXSrTV+M3idfDNGZ9tw9VM3?=
 =?us-ascii?Q?+0MKfAgPBKzuZkZuiQaa2N88nfqAZrXutk/Ozp9WEpyaLa54CZpTwRVJzSzD?=
 =?us-ascii?Q?BdNpZAlNF202zEZg5I1eY/hw4fB3AJmPjNfnOSEcxvsDUaJV/nGQU/5jp8Rn?=
 =?us-ascii?Q?BvJsFnpSlBGGSlbiuZXLjWIRqFisuzxdVr6aips0MuwQZxTmo0ku24FX2q+x?=
 =?us-ascii?Q?roWOObLc5s8Ar5pu1fJWeDCTdPJbQYuhb0++oGp2+coAHTW7SxHfU/7r/HER?=
 =?us-ascii?Q?BwDVZjhRlH1cMedLfA7AGSMCVY2dJf+dyiqEySunxsF81nV8rXpB2LzTSock?=
 =?us-ascii?Q?XosL5n3TEFBc8uirXe3erBLLAPW6TnFZg/BEq1wB0XC+nBc5CFFVAMvISKAH?=
 =?us-ascii?Q?Z7QrB2R6icnEj61gJ36MW3wkSgT89jCnCnyfXdIuvlVpGFBMuMME9w7o38bo?=
 =?us-ascii?Q?TN4RgmiAC+mvRHMo7rnLmjv7?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75b56c1f-22f0-48ea-4ee7-08d92a91f00b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 15:27:33.6260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAxrtdfiNhMoonimAkMOY/6Ab7ophv6X+mv3Z7PBTxmqEa2qctzYff7Y39WJPBR5j7gz27a6cjZklqHglE2hMSFEJ3xZtNFVofVFx7ldkaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 05:14:16PM +0200, Markus Armbruster wrote:
> Double-checking: this supersedes "[PATCH v7 0/1] qapi: introduce
> 'query-cpu-model-cpuid' action"?
> 
Yes. I've changed the title in response to the changed api name
and just forgot that I should have linked it to the previous versions
somehow.
