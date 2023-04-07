Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034136DB0DC
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 18:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjDGQsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 12:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDGQsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 12:48:18 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2080.outbound.protection.outlook.com [40.107.15.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B199D55A3;
        Fri,  7 Apr 2023 09:48:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YySSuGcp1LS7VJ8TYVsT2jNtxJxaA62hQD2zXR5hP3ygPsyeN6C8f/PrSR/D87LghLYRt6pDXhNAOZWopxQQdOfS7ucdT+NZJjwwb7KmRDZIWt3ZW+CeQEoR5wJ1/ekl59SHzYsoD+dbsNDnoYjo+VPj01QLe250W/mPbxJxvuYy3ybsmSe2D3o85lgYoEAedwfuadDvoSALDbVFhb21KNNb6Y4EuDAL0HCmLtt/7ZGIJMw/h3gUxeTw3QzW+UTnPvYBpCNS+tnaUp3vk+4uHLm7p3ZnhOp2ONx92w45/5SpEIwMmKtHh56fz23N+hcX4G52cHTRe6hmbQUzAfRolA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVTIIQy3mlLEAMS1E/GKz8ici1hj2QNz3b/igDPEm1Y=;
 b=PkeYTGhzOUGmGYoSxI23qU2DyUgfTcCmvxGL9NnMd237hJAsSkJ5ng6d3hj4cxGVFYG0Bx9+kGKOjVc3AbRYQSCHq1D1/tRaQW4SXZvj8mb55D7QkDqgLBXSIeNyInpHIjgDFS/9bhPqxe0CuiQxqvIZEIS7Af+AfVr8NZXclJjj+veNUmZFqcdhfQskLPpklsR7Q1vaKWXgtezuXsm2t4NiPAlZi8fnpHJizIhwjEv+ldtojhDYSuy7GrhZuE/7Pn9j9XCbDiqw9esN0herqFWQWEs8NslZsZ0N4u8gl7wA+QgNkOkyJWq3iKiOTmq4erS4U5mvpMEZ3UTgkCe2wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVTIIQy3mlLEAMS1E/GKz8ici1hj2QNz3b/igDPEm1Y=;
 b=Edn0ClbDhINmI96IdMUyUeClBHAN54F6g54p8t1U5sfk9dJ/6eeZdNH+RXdScTTWdVQc04/euzs1ZKky8GGcDUnL05/wh6t+37BjqvaRUHhrnnDWQx2dUYv0lxkq/roQe3Ra+MhruLOngPSbqPX9SBu0jhwn3V8OAa++OLn1SMA=
Received: from AM6PR04MB4725.eurprd04.prod.outlook.com (2603:10a6:20b:7::14)
 by PAXPR04MB8589.eurprd04.prod.outlook.com (2603:10a6:102:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.33; Fri, 7 Apr
 2023 16:48:15 +0000
Received: from AM6PR04MB4725.eurprd04.prod.outlook.com
 ([fe80::8294:7580:fb56:128e]) by AM6PR04MB4725.eurprd04.prod.outlook.com
 ([fe80::8294:7580:fb56:128e%5]) with mapi id 15.20.6277.031; Fri, 7 Apr 2023
 16:48:15 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        "viktor@daynix.com" <viktor@daynix.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yan@daynix.com" <yan@daynix.com>
Subject: Re: [PATCH v6] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Thread-Topic: [PATCH v6] virtio: add VIRTIO_F_NOTIFICATION_DATA feature
 support
Thread-Index: AQHZXon0whv8NnC6hUW1jNhoqDcu6a8W1qQogASvawCABJtfrA==
Date:   Fri, 7 Apr 2023 16:48:14 +0000
Message-ID: <AM6PR04MB4725AAE468363214FC548A53D4969@AM6PR04MB4725.eurprd04.prod.outlook.com>
References: <20230324195029.2410503-1-viktor@daynix.com>
 <AM0PR04MB4723A8D079076FA56AB45845D48C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230404141501-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230404141501-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR04MB4725:EE_|PAXPR04MB8589:EE_
x-ms-office365-filtering-correlation-id: 26cae1dc-4a28-428a-1f7b-08db3787e1af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FxeINmh/bt17ntb9fcjrhd65PBF0aaSsWJr4Z4eXEy44LGbBCL+ZjT3201zW+anu1HivVR0zvmQ16A/QJxmbxStOx5WzYRDwNaZEBfjMmDm6M1l07p5GaFkWi0OMWz9t/pEOXXBvWK5scg649TTB+GLOBzSL/qQascgVIr96Gg6Sfu6mJPIIfdHHI+PenCzrNcXVySkWs3elZzj95xcxq9BwIrz1/DBKvSme7izKdP+niRITaJ+AulKeO4moV2aM1Wswt4JtNN6wOf9hli10wQs6i0pvfDxxg1aJ/h66YIz7zEtmkS1TJCinVET/GTZGI//2WWCZTdSiO4MdMWg8jiFOGaX13r1WEXlE5kkb9YBuySkAt5qMWhW/aQwF33gbSpYiScAcUBOvzquEC2iDjuDbdTi85XwWjsTadYS4nTPFiwJZ0L8f95UsNYoD1AFwVsH7AOcv3qUNHIceS6YH9KFQ/TWqTdRQhobiMn7zP7Jq8hBjizznqJvKIEfTRwoH/137uLAR9yOOlwMVj6hDH9xqFcRDYXqT7fvUY+OtLh7mynOqX9+PJ+poiSAO7l6ZpcYGAOwYEhX3+BkVGmUxRlgxsFQfMiK4LmdljmfcplM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4725.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39830400003)(376002)(136003)(396003)(346002)(366004)(451199021)(86362001)(33656002)(91956017)(76116006)(966005)(66946007)(41300700001)(110136005)(316002)(66476007)(66446008)(64756008)(66556008)(478600001)(54906003)(4326008)(8676002)(7696005)(38070700005)(71200400001)(83380400001)(55016003)(44832011)(2906002)(8936002)(7416002)(5660300002)(38100700002)(186003)(52536014)(122000001)(9686003)(6506007)(66899021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?GIzjPrlLdysMdfsS4Pxa1Ae9BjGalUWMZaKchqCyrS+nAW0Z3WGKM+DBUw?=
 =?iso-8859-1?Q?Y4aHejGPWoZWyxUuADAZakm+ha8rvRHk+IYIHIfYAZwfUXtLJJclaYI0WN?=
 =?iso-8859-1?Q?wS6+79N75zqBm8aoSRyjLU9EU/rFc7P7eHCTw0s/YZp51XNWqu/RT0D9Hl?=
 =?iso-8859-1?Q?oMuvhBF/kpspTrGnwt6Gq5w4LseBEIGZ7uMBYVcMfzjSNrahZeV9MEdHUK?=
 =?iso-8859-1?Q?v7nEF7ogHxF3M1+ctS2Db945SwccOfYLtzGgiIKkTAD4whXTkE8BJBLm1v?=
 =?iso-8859-1?Q?1Tdrzk354jJRfMUz+JIegSBXZKhzSNJEE2izRUFX/jM2SiO/oB7aLrviSx?=
 =?iso-8859-1?Q?JYKhn2D+xL0xHrr+fatdzGo+FPcz4jR5rwlRLMmBU5vzI95NRyKc0XkYeG?=
 =?iso-8859-1?Q?49Rvz8NOtcVQ8B51/rpri1jF0jjlXu6kVb0kxOrmS1BkydH6knlwFX+gSx?=
 =?iso-8859-1?Q?s0tUGOw5BCBjYgKXiZBHWhB/UkOLjksPzts7kooQ52otFgJnRajXQpmYqZ?=
 =?iso-8859-1?Q?wSXOppHIzjJMTX9rnojMbuBu0hMdAzEkTIdDXtVn4hbNxoaftvWBrpkZXV?=
 =?iso-8859-1?Q?FyE7zbGyfbaOXFceU+CdwdQ8ZfJqDtXyJ6ojeHXaSNKxsh0yv1ArmxY6mN?=
 =?iso-8859-1?Q?/8/GUn+QUhJc1HTCeFhgr2Hul4Qe18XaTvyMfEWBHcIkA99+VwSVRnVn6V?=
 =?iso-8859-1?Q?qMzRdoQkim7lRtQD+y+k06I2qeFZD21dHK1XuEVs/Rdd+MNmRLHoO4PgR5?=
 =?iso-8859-1?Q?PeBFSZDlMmlzgByRiNL1CVbLMIQN8O/jhrmhWrT04hXoVcqf2BmfZD2K6V?=
 =?iso-8859-1?Q?etIA7XRTFZIC54y6ylN46da+ANRDHF3XG0PfqfleH+W8jrMDElULBCyHhp?=
 =?iso-8859-1?Q?0/OZ5/1AzW0epr6uBnBR4LbTEyafjQ/Hr1IcZKYUI6Grhte9iS9TkzFwg1?=
 =?iso-8859-1?Q?ylQEegv65JmDwpRZK6QC7gEYgr4xL+ynP2umg0QXOjUufqn4NPOecnwUI0?=
 =?iso-8859-1?Q?qNlFaE6p2+JRBSTGkTUltwUGrnCLKwF050o6bzTiy/Zu0vpRsZl5q0awHq?=
 =?iso-8859-1?Q?yCKUz1SmPdM+9brArW86rNzEjp1ULsSZXac9qh5wMHGZk4oJgRGDPmopKT?=
 =?iso-8859-1?Q?1YilukO6g59apVLDRCkStk8X2aBalprLkTgTouV+wg1TL0spWMHLfAqyra?=
 =?iso-8859-1?Q?zK5Q/TiaHuID7yl0nLLHKQPY/sYPoEZriHgBD2i+4EKdr22fB2NExN315Q?=
 =?iso-8859-1?Q?t9ow55JGjqBw5A3+nciwXS76rUkGeYLO0K2fRBq1MTI7kHf1MVR9oywNp7?=
 =?iso-8859-1?Q?IH8SsX0o5beELFj2eEPq7wsUuEjKQWrd5GuUhvtjEFkuVa+P4CBVqtJhP7?=
 =?iso-8859-1?Q?bY49CSwKcuwOhKvMBcHKxHdO5XGfjIz4sP3H7mXCE23ZwcZXT+fkQv48cN?=
 =?iso-8859-1?Q?vVOuaxyDE0V/xYWsMpxLyG9crWSCBgbhmXElkjX2BuzmHmIdBCh0moNpvE?=
 =?iso-8859-1?Q?/eHskjVYnvVCYn0T7MPj65fcyhPyleVj8t/Uyebvnsv6dLhjH3xHc9DWgA?=
 =?iso-8859-1?Q?BuXi/UbWtxIfemnAwEDHh+LPHAKVSkbRyKTUwb8n8TYkxZe//ftCm3RhZO?=
 =?iso-8859-1?Q?KWhVhsyPzaxKUqHdmdNvTG/crPkXaow4cOnyMINh3HeR07UC72RtBaxSkJ?=
 =?iso-8859-1?Q?EQXY16JxGpgh5aN9DCKZ9UZ+ilScMPx/9WiKxY5Q?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4725.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26cae1dc-4a28-428a-1f7b-08db3787e1af
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 16:48:14.9097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XEk2dyQLBN45TuF/2zxbqSAnUVCuStbuPR9cD2UoPCvHpd514PSf9euwUJnw71lUSWFH2fwDG+VaIgN2IPSgW+76Fb+k0kON5eA9Q/Lt5/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8589
X-Spam-Status: No, score=1.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > This function is used by virtio_vdpa as well (drivers/virtio/virtio_vdp=
a.c:virtio_vdpa_finalize_features).=0A=
> > A vDPA device can offer this feature and it will be accepted, even thou=
gh VIRTIO_F_NOTIFICATION_DATA is not a thing for the vDPA transport at the =
moment.=0A=
> >=0A=
> > I don't know if this is bad, since offering VIRTIO_F_NOTIFICATION_DATA =
is meaningless for a vDPA device at the moment.=0A=
> >=0A=
> > I submitted a patch adding support for vDPA transport.=0A=
> > https://lore.kernel.org/virtualization/20230402081034.1021886-1-alvaro.=
karsz@solid-run.com/T/#u=0A=
> =0A=
> Hmm.  So it seems we need to first apply yours then this patch,=0A=
> is that right? Or the other way around? What is the right way to make it =
not break bisect?=0A=
=0A=
My patch should be applied on top of Viktor's, it uses one of the functions=
 created by Viktor: vring_notification_data.=0A=
Viktor's patch without mine won't break bisect, it will just accept the fea=
ture for a virtio_vdpa without any meaning.=0A=
=0A=
> Do you mind including this patch with yours in a patchset=0A=
> in the correct order?=0A=
=0A=
Viktor, since you did most of the work here, maybe you want to create the p=
atchset?=0A=
I can do it myself if you prefer so.=0A=
=0A=
Thanks,=0A=
Alvaro=
