Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C529A7BCBD1
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 05:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbjJHDD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 23:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbjJHDDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 23:03:54 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2044.outbound.protection.outlook.com [40.107.255.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18127C5;
        Sat,  7 Oct 2023 20:03:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gou6BxWAYaBM0Ne4+fQMfvtNBaF45iMgQg/PTeJg5Rjua62bTg4Ym7lfkLT6EOAiEb2fzsH0qNPKqFu7gE6StcCivZyKfYOf/MKTPSIMO/aDkVH/9S3GhkuQufA89aJyhKKmqiqiVCevMlUJgUUzoYjMG6INXh/cwBxXAgiDLbbknACQ1pxmaEaIwj/RrI9vSZR/9czP8BxMJ2r3mWnw4Ycc3eTnwooodobCOMjz1a0VTYTwcmqNDuqXPxunXDQQ5IsN1gM6V+inyCJILoJHnOCa18HU+BtqN3ouX8HvBnug2tbzero0Vau97Ym3q2CQ3msNtbAE41ksC4ItfB3MSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LcJs31P+aC95oQM4lgXf5nX5SVirrycQMTygAjP8S1Y=;
 b=O81RD0UYIsO5SiAH96JSaTGg/RC5n1Po7yiHs861aowlDIfAsLdp/F9qqcalPfojgfD6mJ6+WqG7BMKUdoYQbKmM4wNv80AaP2XXPO4hx+Zlyk9wRvHoeVwsCe9Tzn2lOOeKPnM1LlAdhCWuAyz0mGtp8kfA1b3bNYsEZExyYvc2fsIkBVrC/SFntB3NwNqd+3B7G/lEScWnDpBw+v7/sv+0aV9z0j+QUIb/V2J/sM50a/TZnIdNlnAh7k+A8IUu84D0eek4oAV0pTYqt2z4kBROjgbmJauQRtO7vyN6Gi/7sPCbABDgvzWW/CfxchadSgnBEGLlUG1OEbZELqAV+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LcJs31P+aC95oQM4lgXf5nX5SVirrycQMTygAjP8S1Y=;
 b=cbgLEu1uZDGZSCE+e7t0AY/5Xaiju78JWUzgLqqbCbSFq3ATu3FnZKSdHXOK/g0eHJCwaZqJF8QTfiTWIWjSBKjRvkmmBzcysDaISwOgjSCLrPqQUd84fYKZKgKe6g3TOLf6HFjS0WwXz+0mvhBXQrPCPnoEdity3mgwEWj84TPax+9reRWuneBpczBHuWpoT/VeOOFaCdc65QROEMTOOaOFX2r/dDaWm0IeWme8h6G1a4AhO+/UqJt0lWVm5zd4mPu9KnmCQ9AsYdo1OaWWOUpgeqiOic/mYX6hMytGxADvGiaLEAsFowI1/9hE02dbB6kDc/YB7ZlUgN9u4g20hg==
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by KL1PR0601MB4177.apcprd06.prod.outlook.com (2603:1096:820:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.41; Sun, 8 Oct
 2023 03:03:43 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd%4]) with mapi id 15.20.6863.032; Sun, 8 Oct 2023
 03:03:43 +0000
From:   Liming Wu <liming.wu@jaguarmicro.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [PATCH v2 1/2] tools/virtio: Add dma sync api for virtio test
Thread-Topic: [PATCH v2 1/2] tools/virtio: Add dma sync api for virtio test
Thread-Index: AQHZ+OtW793w5h9+jkK1diJSHXBDBLA/KdaAgAAMP7A=
Date:   Sun, 8 Oct 2023 03:03:43 +0000
Message-ID: <PSAPR06MB3942DE121AD46C46D8728942E1CFA@PSAPR06MB3942.apcprd06.prod.outlook.com>
References: <20230926050021.717-1-liming.wu@jaguarmicro.com>
 <20230926050021.717-2-liming.wu@jaguarmicro.com>
 <20230927111904-mutt-send-email-mst@kernel.org>
 <20231007065547.1028-1-liming.wu@jaguarmicro.com>
 <1696731557.4612653-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1696731557.4612653-1-xuanzhuo@linux.alibaba.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR06MB3942:EE_|KL1PR0601MB4177:EE_
x-ms-office365-filtering-correlation-id: 462573c9-2839-4c9b-8315-08dbc7ab2e5d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: keIxB51VUH0l4IoxqTBMQablVFHiIvrI4MdPpb0LoaFP13WW2uCj9SWpOStzzebXYaqfRL3Jq51Fo3BhWPWXooIT6ldmnWjw42Q9DuQ4jm0sy9T9BkoLt7VYPO4g6OdwuFw2iM5/4AYPEohn3lOegsDktj30tKsPMR1F4wh3zfad6Q3s1s1QSsd9ZkArf1yGWnaE2UnrWKippluEVKx9q5paHukbKzNb9zKqqph6Ad9ih3or/ejGFPujUj94+ylqUSeokcbT4h175XhEVZAi74NXpo7NEjDQnGwWjo1NXVp8mbb+Clsu+oZnSM4iHFWcjlVElOvOoIlDIQAQoX10l8+jo6c9HrUeERcQ954b35M82muq0OApHJ0BaqwdAjC+QV1B3nyMWrj/f3v6tlh3PA01m9QSJ+QijCSHvzIpVusF0vt2bnNoc0nlTgJonNOj/wdS/Wwd435RX2B21FSd80vXCFgo6Xvii2ZFUBgQs1wOz+ijfiS8K/4O87RR5s2mcR+aKR0STK/TDeOXdQghhph1a0IVYwZRchGQt9NeTzkSsDwFR6f/WgTQA7xfHb/7ZrEZPSdfv9aLQkIClFg470bo9zIznE34tRFK7MDoRzLOcbV0C8wA7PZhvhSwTC4q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(39830400003)(346002)(136003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(55016003)(83380400001)(26005)(66946007)(66476007)(66556008)(316002)(66446008)(54906003)(76116006)(6916009)(64756008)(8936002)(8676002)(4326008)(5660300002)(52536014)(41300700001)(44832011)(7696005)(6506007)(53546011)(71200400001)(9686003)(2906002)(4744005)(478600001)(33656002)(38070700005)(38100700002)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fm4MJEpMPBCSS3iGcwNFGYwkFF1C/Ax8GtKSstYxzre1fmiOsHS68KcGmUtE?=
 =?us-ascii?Q?wke5MDX5girHGbYqK7GJabsgGkjO4c5yjImVbZKTY5mapH+k3pSU7cRBUXBz?=
 =?us-ascii?Q?kLGM2iWyZmAv+Lpy3/zkU4alV6aHonuf9aCW9idf6qkqDd2b1JbroWY1vbtn?=
 =?us-ascii?Q?/Mon6kYtFIkcn2lxkPYot/SBjPRQwRzgmZ4Ljlye4ivlV86FnWs5YhoZZ/Aj?=
 =?us-ascii?Q?WEii1l2nkQ18WEGn6iLwC/BIBwq3Txjm57VHtBzpprjlicevMaUHV6ai6F/q?=
 =?us-ascii?Q?ZrZcRkPXraB7JGi5yTNAUIPYiYR7eoV9yyTdD8qhkoxGV8AAEBRi85cKdeWT?=
 =?us-ascii?Q?gekDix1WJEiARmYSCahjJlE4Ip8zNPwPnFGyxwHIuedttJTHRqfmH737ZxjV?=
 =?us-ascii?Q?TEIWLGQAHKZesvX9p1j02q2mlM37D/3uVAiFUZIYxebtAtH2bhKigalct6PV?=
 =?us-ascii?Q?K4v7tEJzW/rCNTKQ28d5+ezVIXO5gfNtcmXbDEeHgWO0l2VIif9s7sWSaER7?=
 =?us-ascii?Q?Mlq4UcdVJNg/HuDWUlTKxGlS4W7JC0lvb/jIbcweEvCbHzDzLud7CdgTitbD?=
 =?us-ascii?Q?YcupEBYF0rU71gCfxwghGkYsoFi6wjufjtRHhu/WSKC1W+q1uZPns9vZRZJ+?=
 =?us-ascii?Q?F/3WLyLO6MXpu86MYz4EMYNmNobbNsuCKEr+KiiEHhKJKwG0qzGQFZq7Dnyc?=
 =?us-ascii?Q?dxDXtZKS6dEFDpdOkCZe/UlPeBshuh1YrGR7vWH6qh+EUvwjGAYDjj/ASI0Y?=
 =?us-ascii?Q?8TRCqebZmLAM58uc7FIOkXOXCf3BNQui57QCPIqaJRON17t6wIAyyedSFIiV?=
 =?us-ascii?Q?aLIAi/fnAURHN9sDKb9hzkeub+1tumSn7dG9cD6mXd/0yWwfuR8L393vtEOG?=
 =?us-ascii?Q?ymjY6sPCrYZYFUbcVhmInGG7UHKHeHcypQeiyDNjGa2EpnWv/hBVos/IV3LH?=
 =?us-ascii?Q?vii2a+2FO2IIlGBuqBbENAuV8NBkcwVPGy3u7jAF+vVwclVfuR5e9P8TN+G4?=
 =?us-ascii?Q?iPLx2sG5ghsMUOsnZvPlKFsjauS6TjJU8WOL1C5P6Y5X6h2pSihCFTfyv75d?=
 =?us-ascii?Q?fpGjKYoH8eeKmt4cCV44sJpAt0mX1PDC1b4lvpriCdItW/iQtPg6E8w6D9qz?=
 =?us-ascii?Q?BmCkxrycJPTrcl0HATEopCNL0T9fAfBGdfFFWyphuzCO7pDeeYf1EvRJP9HZ?=
 =?us-ascii?Q?+jJYuNSBeUl91ddKeAl7o/BdaKXay2WG0E1K176muNdI5FaCxr7ea66VhXRW?=
 =?us-ascii?Q?Sm9AeB8znKSoHb2lC7pg14ifvJPIHP0yZC6X3g+TGOJEijvvvk3vEqc+CT52?=
 =?us-ascii?Q?GONmjeglUSRWP+bhxchrdsGFw4N+1iar6eyfbVF/NmISVae6LHTZOQdbfNpd?=
 =?us-ascii?Q?sflMgLBxIhqDs0OiVVUeEEXUDCnFVa+tybiegBVGhABNJM4rbU6Pi7GbWWC8?=
 =?us-ascii?Q?glzgKdulVKCqy3xMIVsnqxmkuHj2VfB2R4HhmnDN0EQdiTxCTQGIGi2GHR3h?=
 =?us-ascii?Q?tw/CDRTiBDsfdjm/0ZU1HULJy6FWkdIMd8QDTy+ndStjj7fzbjqTq6SCZ24A?=
 =?us-ascii?Q?DIOLOWPiEaaRSM2k9KdKm3v/k2om5KqQ6vhQ486J?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 462573c9-2839-4c9b-8315-08dbc7ab2e5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2023 03:03:43.4138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zohhMopvtEX+z7Ssg3vKjDEgysZfW5pK5jGmLYSM7PTo1HGJdRpmfrELaAPX+6e04UDB88ew8zr8SrU5by1ddPbMDHq++cPp761DH2OPtjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4177
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Sent: Sunday, October 8, 2023 10:19 AM
> To: Liming Wu <liming.wu@jaguarmicro.com>
> Cc: kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liming Wu
> <liming.wu@jaguarmicro.com>; Michael S . Tsirkin <mst@redhat.com>;
> Jason Wang <jasowang@redhat.com>
> Subject: Re: [PATCH v2 1/2] tools/virtio: Add dma sync api for virtio tes=
t
>=20
> On Sat,  7 Oct 2023 14:55:46 +0800, liming.wu@jaguarmicro.com wrote:
> > From: Liming Wu <liming.wu@jaguarmicro.com>
> >
> > Fixes: 8bd2f71054bd ("virtio_ring: introduce dma sync api for
> > virtqueue") also add dma sync api for virtio test.
> >
> > Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
>=20
> You should post a new thread.

OK,  Thanks.
>=20
> Thanks.
>=20
>=20
> > ---
> >
